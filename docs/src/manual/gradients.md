# Gradient estimation

Suppose the expected number in system over a morning is ``J(\theta)``, where
``\theta`` holds the arrival and service rates. Research questions are often
about ``\partial J/\partial\theta``: how much would the queue shrink if
service were ten percent faster? Derivatives drive optimization, sensitivity
analysis, and calibration against data.

The naive approach — run at two nearby parameter values and subtract — is
noisy, because the difference between the runs is small compared to the
noise of each. Concourse supports four estimators that compute the
derivative from simulation output directly, through
[ClockGradients.jl](https://github.com/adolgert/ClockGradients.jl).

One design rule makes this possible: `θ` enters a simulation in exactly one
place, when the model builds a clock's firing-time distribution. Nothing
else reads `θ`. There is one door through which a parameter can affect
anything, so an estimator only has to watch that door.

## Binding a model to the contract

ClockGradients works against a model contract, not against Concourse
specifically. A `ReplayModel` binds a compiled `QueueGSMP` to that
contract. There are two bindings:

- `replay_model(m, rec)` binds one record's auxiliary draws to the model,
  so replaying the trajectory reproduces every mark and routing draw. Use
  it for the record-based estimators, score and IPA.
- `live_model(m)` is the off-record binding, used by the clone-based
  estimators that run past any record. A model whose firings consume
  auxiliary draws fails loudly under this binding rather than replaying
  stale values.

`ClockGradients.gradient_record(rm, rec, θ)` ingests a `MarkedRecord` into
the gradient machinery, rebuilding the clock histories the estimators
differentiate.

## The four estimators

**Score function.** Replay the record and compute how much more or less
likely the same trajectory would have been at a slightly different `θ`.
Multiply that sensitivity by the observed outcome and average over runs.
This works for almost any model and any statistic. Its weakness is noise:
the estimates have high variance.

**Pathwise, also called IPA** (infinitesimal perturbation analysis). Keep
the order of firings fixed, and ask how each firing *time* would shift if
`θ` moved a little. Slide the times, recompute the statistic, and read off
the slope. This has low noise. Its weakness is blindness: if changing `θ`
would change which clock wins a race, IPA does not see that effect, and
for statistics that jump when the order changes, IPA is simply wrong.

**Branching.** Run the simulation live. At a firing, copy the whole running
world and force a *different* clock to win in the copy. Compare the copy's
outcome with the original's. This directly measures the effect of order
changes, which is exactly what IPA misses. Its weakness is cost: every
branch point spawns clones.

**Smoothed perturbation analysis, SPA.** A compromise. Take the IPA
estimate, then add a correction for the near-ties: moments where two clocks
almost fired together, so a small change in `θ` could swap their order. The
correction weighs each near-tie by how likely the swap was and by how much
the statistic would jump if it happened, estimated with one coupled clone
pair. It needs far fewer clones than branching.

## Score and IPA on a record

The test statistic is the integrated occupancy
``\int_0^H N(t)\,dt`` over ``H = 50`` for an M/M/1 queue, and the check is
against common-random-number finite differences. Both estimators read the
same records.

```@example gradients
using Concourse
using Statistics
import ClockGradients
using ClockGradients: IntegratedOccupancy

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)

θ = [1.0, 2.0]
H = 50.0
R = 200
intN(rec) = rec.horizon * time_average(number_in_system, m, rec)
fn = IntegratedOccupancy(number_in_system)

fs = zeros(R); S = zeros(2, R); G = zeros(2, R)
for r in 1:R
    rec = simulate(m, θ, H; seed = 100 + r)
    rm = replay_model(m, rec)
    grec = ClockGradients.gradient_record(rm, rec, θ)
    fs[r] = intN(rec)
    S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
    G[:, r] = ClockGradients.ipa_gradient(rm, θ, grec, fn)
end

# Score estimator: covariance of the outcome with the score.
fbar = mean(fs)
score_est = [mean((fs .- fbar) .* S[j, :]) for j in 1:2]
score_se  = [std((fs .- fbar) .* S[j, :]) / sqrt(R) for j in 1:2]
# IPA estimator: a plain mean over replications.
ipa_est = [mean(G[j, :]) for j in 1:2]
ipa_se  = [std(G[j, :]) / sqrt(R) for j in 1:2]
nothing # hide
```

The finite-difference baseline runs pairs of simulations at
``\theta_j \pm \delta`` with shared seeds:

```@example gradients
δ = 0.05
fd_est = zeros(2); fd_se = zeros(2)
for j in 1:2
    θp = copy(θ); θp[j] += δ
    θm = copy(θ); θm[j] -= δ
    diffs = [(intN(simulate(m, θp, H; seed = 100 + r)) -
              intN(simulate(m, θm, H; seed = 100 + r))) / (2δ) for r in 1:R]
    fd_est[j] = mean(diffs); fd_se[j] = std(diffs) / sqrt(R)
end

using Printf
for (name, est, se) in (("score", score_est, score_se),
                        ("IPA  ", ipa_est, ipa_se),
                        ("FD   ", fd_est, fd_se))
    @printf("%s  ∂λ = %7.1f ± %4.1f   ∂μ = %7.1f ± %4.1f\n",
            name, est[1], se[1], est[2], se[2])
end
```

All three agree within statistical error (the repository convention is
four standard errors). Notice the standard errors: the score estimator's
are several times larger than IPA's on the same 200 records. That is the
trade in practice — score is general, IPA is quiet.

## Branching, on a live world

The branching estimator drives a [branchable world](branching.md) rather
than a record. Pass it a world factory, the functional as a function of the
terminal state, and a replication budget.

```@example gradients
T = 5.0
res = ClockGradients.branching_gradient(() -> branch_world(m, θ; seed = 71), θ,
                                        st -> Float64(number_in_system(st));
                                        nreps = 600, horizon = T,
                                        seed = 11, branch_rng_seed = 12)
round.(res.estimate, digits = 2), round.(res.stderr, digits = 2), round(res.clones_per_rep, digits = 1)
```

The finite-difference check on the same terminal statistic,
``N(T)`` at ``T = 5``:

```@example gradients
terminalN(θv, seed) = begin
    rec = simulate(m, θv, T; seed)
    isempty(rec.key) ? 0.0 : Float64(number_in_system(replay(m, rec)[end]))
end
fdt_est = zeros(2); fdt_se = zeros(2)
for j in 1:2
    θp = copy(θ); θp[j] += 0.1
    θm = copy(θ); θm[j] -= 0.1
    diffs = [(terminalN(θp, 7000 + r) - terminalN(θm, 7000 + r)) / 0.2 for r in 1:3000]
    fdt_est[j] = mean(diffs); fdt_se[j] = std(diffs) / sqrt(3000)
end
round.(fdt_est, digits = 2), round.(fdt_se, digits = 2)
```

## SPA, on a live world plus a pure model

`spa_gradient` takes both a world factory and the pure model binding — the
world simulates, and the pure `live_model` twin replays clone jumps at
near-ties.

```@example gradients
spa = ClockGradients.spa_gradient(() -> branch_world(m, θ; seed = 77),
                                  live_model(m), θ,
                                  IntegratedOccupancy(number_in_system);
                                  nreps = 600, horizon = T, seed = 15)
round.(spa.estimate, digits = 2), round.(spa.stderr, digits = 2)
```

And its finite-difference check on the integrated occupancy over
``[0, 5]``:

```@example gradients
fdo_est = zeros(2); fdo_se = zeros(2)
for j in 1:2
    θp = copy(θ); θp[j] += 0.1
    θm = copy(θ); θm[j] -= 0.1
    diffs = [(intN(simulate(m, θp, T; seed = 7000 + r)) -
              intN(simulate(m, θm, T; seed = 7000 + r))) / 0.2 for r in 1:3000]
    fdo_est[j] = mean(diffs); fdo_se[j] = std(diffs) / sqrt(3000)
end
round.(fdo_est, digits = 2), round.(fdo_se, digits = 2)
```

SPA's validity conditions are real requirements, not fine print. It needs
clock families whose replay carries derivative information
(`Exponential`, `Weibull`, `LogNormal`), a `fire` that is pure, and **no
mid-flight re-declaration of an enabled clock's distribution**. A record
that contains re-declared clocks — which is what processor sharing
produces — makes `spa_gradient` throw rather than return a biased number.

## An honest caveat: IPA fails on processor sharing

Under processor sharing (PS), every job at a station is served at once,
each at a fraction of the server's speed. Each arrival or departure changes
that fraction, so the model *re-declares* the law of every resident
service clock. Each re-declaration starts a new segment in the clock's
history.

The obvious hope was that IPA would extend to these multi-segment records.
It does not. The experiment that settled it (test file `test/test_ps.jl`,
translated in
[Design questions and outcomes](../developer/design_questions.md)) found
frozen-order IPA over PS records **biased under both couplings** — both
ways of realizing a re-declaration, carrying the retained draw or
redrawing conditioned on age. A sharpened version of the experiment ran a
64-server PS station at a load where it never actually slows anyone down,
so its law equals plain first-come-first-served (FCFS) — and IPA was
unbiased on the segment-free FCFS records and biased on the multi-segment
PS records of the *same dynamics*. The bias lives in the record's segment
representation, not in the queue.

The demonstration is cheap enough to run here. IPA versus finite
differences for ``\partial/\partial\mu`` of the integrated occupancy of an
M/M/1-PS queue:

```@example gradients
netps = QueueNetwork(param_names = (:lambda, :mu))
source!(netps, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(netps, :cpu; discipline = ProcessorSharing(), servers = 1,
         service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(netps, :done)
route!(netps, :arrive, Always(:cpu))
route!(netps, :cpu, Always(:done))
mps = compile(netps)

Rps = 150
intNps(rec) = rec.horizon * time_average(number_in_system, mps, rec)
fps = zeros(Rps); Sps = zeros(2, Rps); Gps = zeros(2, Rps)
for r in 1:Rps
    rec = simulate(mps, θ, H; seed = 700 + r)
    rm = replay_model(mps, rec)
    grec = ClockGradients.gradient_record(rm, rec, θ)
    fps[r] = intNps(rec)
    Sps[:, r] = ClockGradients.score_gradient(rm, θ, grec)
    Gps[:, r] = ClockGradients.ipa_gradient(rm, θ, grec, fn)
end
fpsbar = mean(fps)
ps_score = mean((fps .- fpsbar) .* Sps[2, :])
ps_score_se = std((fps .- fpsbar) .* Sps[2, :]) / sqrt(Rps)
ps_ipa = mean(Gps[2, :]); ps_ipa_se = std(Gps[2, :]) / sqrt(Rps)

θp = copy(θ); θp[2] += δ
θm = copy(θ); θm[2] -= δ
diffs = [(intNps(simulate(mps, θp, H; seed = 700 + r)) -
          intNps(simulate(mps, θm, H; seed = 700 + r))) / (2δ) for r in 1:Rps]
ps_fd = mean(diffs); ps_fd_se = std(diffs) / sqrt(Rps)

@printf("IPA    ∂μ = %6.1f ± %4.1f\n", ps_ipa, ps_ipa_se)
@printf("score  ∂μ = %6.1f ± %4.1f\n", ps_score, ps_score_se)
@printf("FD     ∂μ = %6.1f ± %4.1f\n", ps_fd, ps_fd_se)
@printf("IPA is %.0f combined standard errors from FD\n",
        abs(ps_ipa - ps_fd) / sqrt(ps_ipa_se^2 + ps_fd_se^2))
```

The IPA estimate is confidently, precisely wrong — a small standard error
around a badly biased value. The score estimator on the same records
agrees with finite differences. **On processor-sharing records, the valid
estimators today are score and branching.** SPA refuses the records; IPA
returns a biased answer if you force it, so do not.

## Which estimator when

| Estimator | Needs | Variance | Order changes | PS records |
|---|---|---|---|---|
| Score | records | high | correct | valid |
| IPA | records | low | blind | **biased — do not use** |
| Branching | branchable world | moderate | correct | valid |
| SPA | world + pure model | low | corrected | refused (throws) |

Start with IPA when your statistic is a smooth path functional and the
model has no re-declared clocks. Use score as the general fallback and as
a cross-check. Reach for branching or SPA when the statistic responds to
event order — counts, thresholds, first passages — and read
[the SPA page](../developer/spa.md) for when SPA's conditions hold.
