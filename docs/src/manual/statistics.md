# Statistical analysis

A simulation run gives you a number. Research needs the number *and* an
honest statement of its uncertainty. This page shows three standard output
analyses — batch means, regenerative estimation, and common random
numbers — each written as a fold over Concourse records or worlds, so the
statistics compose with [replay](record_replay.md) and
[splitting](branching.md).

The running example is the M/M/1 queue at utilization
``\rho = 0.5``, whose long-run mean number in system is exactly
``\rho/(1-\rho) = 1``. Having the true answer lets every method be checked
on the page.

```@example statistics
using Concourse
using Statistics

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)

rec = simulate(m, [1.0, 2.0], 20_000.0; seed = 42)
time_average(number_in_system, m, rec)
```

## Why one run lies

The time average above is close to 1, but what is its standard error? The
observations inside one run are autocorrelated: when the queue is long now,
it will still be long a moment from now. Treating the trajectory as
independent samples understates the variance badly, so a naive confidence
interval is far too narrow. Batch means and regenerative estimation are two
disciplined ways to get an honest interval from a single long run.

## Batch means

Cut the run into `k` equal time intervals, called batches. Compute the time
average inside each batch. If batches are long compared to the correlation
time of the queue, the batch means are nearly independent, and their sample
standard deviation gives an honest standard error.

The fold below integrates a state function piecewise over the record —
between firings the state is constant — and splits the integral at batch
boundaries.

```@example statistics
function batch_means(g, m, rec, nbatch)
    width = rec.horizon / nbatch
    area = zeros(nbatch)
    st = initial_state(m)
    tprev = 0.0
    times = vcat(rec.time, rec.horizon)
    for i in eachindex(times)
        v = g(st)
        a, b = tprev, times[i]
        while a < b                     # spread [a, b] over the batches it crosses
            k = min(nbatch, Int(fld(a, width)) + 1)
            edge = min(b, k * width)
            area[k] += v * (edge - a)
            a = edge
        end
        i <= length(rec.key) || break
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
        st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        tprev = times[i]
    end
    area ./ width
end

b = batch_means(number_in_system, m, rec, 20)
est = mean(b)
se = std(b) / sqrt(length(b))
round(est, digits = 3), round(se, digits = 3)
```

The interval covers the true value 1. One diagnostic is worth the habit:
the lag-1 correlation of the batch means. If it is far from zero, the
batches are too short — use fewer, longer batches.

```@example statistics
round(cor(b[1:end-1], b[2:end]), digits = 3)
```

Two practical notes. First, this run starts from an empty queue, so the
early batches carry some warmup bias; at this utilization the effect is
small, but for heavily loaded systems, discard an initial portion of the
run before batching. Second, twenty batches is a conventional compromise:
enough batches to estimate a variance, few enough that each stays long.

## Regenerative estimation

An M/M/1 queue restarts itself. Each time an arrival finds the system
empty, the future is a fresh, independent copy of the process —
memorylessness wipes out the past. Times like these are called
regeneration points, and the segments between them are independent,
identically distributed cycles. The theory is developed in Shedler,
*Regeneration and Networks of Queues* (1987), which treats exactly the
generalized semi-Markov processes Concourse compiles to.

The estimator is a ratio. For cycle ``i``, let ``Y_i`` be the integral of
the statistic over the cycle and ``\tau_i`` the cycle length. Then the
long-run time average is ``E[Y]/E[\tau]``, estimated by
``\hat r = \sum Y_i / \sum \tau_i``, with a standard error from the delta
method: the variance of ``Z_i = Y_i - \hat r\,\tau_i``.

The fold detects a regeneration whenever an `:arrival` clock fires while
the system is empty:

```@example statistics
function regenerative_cycles(g, m, rec)
    st = initial_state(m)
    tprev = 0.0
    Y = Float64[]; τ = Float64[]
    y = 0.0; tcycle = 0.0; started = false
    for i in eachindex(rec.key)
        t = rec.time[i]
        if rec.key[i][1] == :arrival && number_in_system(st) == 0
            if started
                push!(Y, y); push!(τ, t - tcycle)
            end
            started = true; y = 0.0; tcycle = t
        end
        started && (y += g(st) * (t - tprev))
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
        st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        tprev = t
    end
    Y, τ
end

Y, τ = regenerative_cycles(number_in_system, m, rec)
n = length(Y)
r̂ = sum(Y) / sum(τ)
Z = Y .- r̂ .* τ
se_regen = std(Z) / (mean(τ) * sqrt(n))
n, round(r̂, digits = 3), round(se_regen, digits = 3)
```

Roughly ten thousand cycles from the same record, and an estimate that
again covers the true value. Two properties make the regenerative method
attractive when it applies. There is no warmup problem — cycles are
independent and identically distributed from the first one. And there is no
batch-length tuning — the process itself chooses the cut points. Its
limitation is just as plain: the system must actually regenerate often. A
heavily loaded queue empties rarely, and a large network may effectively
never return to its regeneration state.

## Common random numbers

Comparing two systems is a different problem from measuring one. The
difference between two configurations is usually small compared to the
noise of either, so simulating them independently wastes most of the
budget. Common random numbers (CRN) is the cure: drive both systems with
the *same* randomness, so the shared noise cancels in the difference.

Concourse's randomness is keyed — every clock and every auxiliary draw has
its own named stream derived from one seed — so two worlds built from the
same seed reuse the same draws for corresponding clocks even when their
parameters differ. Build two [branchable worlds](branching.md) on a shared
seed, run each to a horizon, and difference the results.

```@example statistics
import ClockGradients

# Fold a time average over a live world, driven by peek and commit.
function world_time_average(g, w, T)
    acc = 0.0
    tprev = ClockGradients.branch_time(w)
    t0 = tprev
    while true
        pk = ClockGradients.branch_peek(w)
        (pk === nothing || pk[1] > T) && break
        acc += g(w.state) * (pk[1] - tprev)
        ClockGradients.branch_commit!(w, pk[2], pk[1])
        tprev = pk[1]
    end
    acc += g(w.state) * (T - tprev)
    acc / (T - t0)
end

# Mean number in system at μ = 2.0 versus μ = 2.2, R paired replications.
R = 40; H = 500.0
avgN(θv, seed) = world_time_average(number_in_system,
                                    branch_world(m, θv; seed), H)

paired = [avgN([1.0, 2.0], r) - avgN([1.0, 2.2], r) for r in 1:R]
indep  = [avgN([1.0, 2.0], r) - avgN([1.0, 2.2], 5000 + r) for r in 1:R]

(crn = (round(mean(paired), digits = 3), round(std(paired) / sqrt(R), digits = 3)),
 independent = (round(mean(indep), digits = 3), round(std(indep) / sqrt(R), digits = 3)))
```

The true difference is
``1 - \frac{1/2.2}{1 - 1/2.2} \approx 0.167``. Both estimates cover it,
but the paired standard error is many times smaller — a variance
reduction of well over an order of magnitude for the same simulation
budget. The same pairing works through `simulate` directly: two calls with
equal seeds and different `θ` couple the same way, which is exactly how the
finite-difference baselines in [Gradient estimation](gradients.md) are
built.

## Splitting and statistics compose

Everything above is a fold, and the folds run over records or over live
worlds interchangeably. That is deliberate. The splitting idiom of
[Branching worlds](branching.md) — clone a world, rekey the clones with a
shared seed, force different decisions — produces pairs of trajectories
that any of these estimators can consume: batch the two continuations,
difference their cycle statistics, or pair them as CRN replicates. The
statistics do not know they are running on a counterfactual.
