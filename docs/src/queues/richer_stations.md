# Richer stations

The stations so far take one job in, put one job out, and never refuse work.
Three mechanisms break that mold, and each one steps outside what
[product-form theory](../manual/bcmp_hpc.md) can bless: **fork–join** (one job becomes
several that must reunite), **blocking** (a full buffer backs up into the
station upstream), and **reneging** (waiting jobs give up and leave). Each
gets a diagram, a short simulation, and the strongest check available — an
exact formula where one exists, an exact accounting identity where none does.

## Fork–join

A fork splits an arriving job into one sibling per branch; a join waits until
*all* siblings have finished and releases a single merged job. This is every
"scatter–gather" in computing: a file striped across two disks, a query
fanned out to replicas, a build with parallel steps. The join is the
expensive part — the merged job is only as fast as its *slowest* sibling.

```@example richer
using Luxor, QueueDiagrams, LaTeXStrings # hide
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
sethue("black") # hide
circle(Point(-150, 0), 4, action = :fill)   # fork # hide
circle(Point(150, 0), 4, action = :fill)    # join # hide
fontsize(12) # hide
text("fork", Point(-150, 22), halign = :center) # hide
text("join", Point(150, 22), halign = :center) # hide
b1 = buffer(Point(-50, -45), 90, 30; slots = 3, jobs = [0]) # hide
s1 = server(Point(20, -45), 15; inservice = 0, label = L"\mu") # hide
b2 = buffer(Point(-50, 45), 90, 30; slots = 3, jobs = [0, 0]) # hide
s2 = server(Point(20, 45), 15; inservice = 0, label = L"\mu") # hide
flow(Point(-270, 0), Point(-156, 0); label = L"\lambda") # hide
flow(Point(-146, -3), b1.entry) # hide
flow(Point(-146, 3), b2.entry) # hide
flow(b1.exit, s1.entry) # hide
flow(b2.exit, s2.entry) # hide
flow(s1.exit, Point(146, -3)) # hide
flow(s2.exit, Point(146, 3)) # hide
flow(Point(156, 0), Point(260, 0)) # hide
end 600 190 # hide
```

In Concourse, `fork!` and `join!` are stations with no clocks of their own —
splitting and merging are instantaneous; only the branch stations take time:

```@example richer
using Concourse, Statistics

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
fork!(net, :split; branches = (:disk_a, :disk_b))
station!(net, :disk_a; service = Law(:Exponential, scale = inv(Param(:mu))))
station!(net, :disk_b; service = Law(:Exponential, scale = inv(Param(:mu))))
join!(net, :merge; parts = 2)
sink!(net, :done)
route!(net, :arrive, Always(:split))
route!(net, :disk_a, Always(:merge))
route!(net, :disk_b, Always(:merge))
route!(net, :merge, Always(:done))
fj = compile(net)
nothing # hide
```

Fork–join queues are notoriously hard: for more than two branches no exact
mean is known. But for exactly two exponential branches, Flatto and Hahn
derived one:

```math
E[T] = \frac{12 - \rho}{8} \cdot \frac{1}{\mu - \lambda},
\qquad \rho = \lambda/\mu,
```

and by Little's law the mean number of fork *groups* in the system is
``\lambda E[T]``. A group is still "in the system" while any sibling is, so
the measurement counts distinct groups in the state:

```@example richer
function replicate(f, m, θ, horizon, nreps; seed0 = 1000)
    vals = [f(simulate(m, θ, horizon; seed = seed0 + r)) for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

groups_in_system(st) = Float64(length(Set(values(st.group))))

θ = [1.0, 2.0]
ρ = θ[1] / θ[2]
exact = θ[1] * (12 - ρ) / 8 / (θ[2] - θ[1])
est, se = replicate(r -> time_average(groups_in_system, fj, r), fj, θ, 4000.0, 16)
println("measured groups in system: ", round(est, digits = 3), " ± ",
        round(se, digits = 3), "   Flatto–Hahn: ", round(exact, digits = 4))
```

For comparison, a *single* M/M/1 at this load holds ``\rho/(1-\rho) = 1``
job on average — synchronization pushes the two-branch system well above
that, exactly as far as the formula says.

## Racing and cancellation

A join that waits for *all* siblings pays for the slowest one. The other
classic use of a fork is the opposite bet: send the same request to ``n``
replicas, keep the first answer, and throw the rest away. Two keywords of
[`join!`](@ref) declare the race — `need`, how many siblings must arrive
before the merge, and `cancel`, what happens to the others:

```julia
join!(net, :merge; parts = n, need = k, cancel = :on_completion)
```

The two cancellation policies differ in *where* the race is decided.

- `cancel = :on_completion` decides it at the finish line. The moment the
  `need`-th sibling of a group reaches the join, the group merges and
  every other sibling is canceled wherever it sits — waiting in a buffer,
  in service, or held blocked — freeing its server or waiting-room slot on
  the spot, with the freed capacity refilled by the ordinary dispatch
  cascade in the same instant.
- `cancel = :on_start` decides it at the starting line. The moment the
  `need`-th sibling of a group *enters service*, siblings still waiting in
  buffers are canceled. A sibling already in service is never interrupted:
  it runs to completion, and the join merges the first `need` finishers
  and silently *absorbs* any later one, like a sink — the late finisher's
  service stays visible in the record; only the join's output ignores it.

The distinction has teeth even with memoryless service, where intuition
says starting and finishing should not matter. Consider ``(n, 1)``: fork
to ``n`` single-server replicas, `need = 1`. Under `:on_completion` all
``n`` servers work on the head group until the first finishes — the
service the group experiences is the *minimum* of ``n`` draws, and with
exponential service the system is exactly M/M/1 at the pooled rate
``n\mu``. Under `:on_start` the fork deposits all ``n`` siblings into
their buffers before any dispatch happens, so the *first* service entry is
already the `need`-th and cancels the rest while they wait: exactly one
sibling per group ever serves, and the ``n`` replicas behave as one FCFS
line with ``n`` servers — M/M/``n``, not a faster M/M/1. Simulation
against both closed forms:

```@example richer
function race(n, cancel; service = Law(:Exponential, scale = inv(Param(:mu))))
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    branches = [Symbol(:replica_, i) for i in 1:n]
    fork!(net, :scatter; branches)
    for b in branches
        station!(net, b; service)
        route!(net, b, Always(:first))
    end
    join!(net, :first; parts = n, need = 1, cancel)
    sink!(net, :done)
    route!(net, :arrive, Always(:scatter))
    route!(net, :first, Always(:done))
    compile(net)
end

θ = [1.0, 1.0]
mc = race(3, :on_completion)
ms = race(3, :on_start)
Lc, sec = replicate(r -> time_average(groups_in_system, mc, r), mc, θ, 2000.0, 16)
Ls, ses = replicate(r -> time_average(groups_in_system, ms, r), ms, θ, 2000.0, 16)

# Exact answers by Little's law, L = λW.
Wc = 1 / (3 * θ[2] - θ[1])                       # M/M/1 at rate 3μ
a = θ[1] / θ[2]                                  # Erlang C for M/M/3
tail = a^3 / (factorial(3) * (1 - a / 3))
C = tail / (sum(a^k / factorial(k) for k in 0:2) + tail)
Ws = 1 / θ[2] + C / (3 * θ[2] - θ[1])
println("on_completion: ", round(Lc, digits = 3), " ± ", round(sec, digits = 3),
        "   M/M/1 at 3μ: ", round(θ[1] * Wc, digits = 3))
println("on_start:      ", round(Ls, digits = 3), " ± ", round(ses, digits = 3),
        "   M/M/3:       ", round(θ[1] * Ws, digits = 3))
```

The `:on_completion` race is Joshi, Soljanin & Wornell's ``(n, 1)``
fork-join with cancellation, and their Lemma 1 holds for *general*
service: the system is M/G/1 with service ``X_{(1:n)}``, the minimum of
``n`` draws, so the Pollaczek–Khinchine formula prices the whole race. A
shifted-exponential law — a floor ``\Delta`` plus an exponential tail,
the standard model of a replica with fixed overhead — makes the minimum
``\Delta + \mathrm{Exp}(n\mu)``, and P–K needs only its two moments:

```@example richer
using Distributions: Exponential
Δ, μs = 0.2, 2.0
overhead_exp = Opaque((θ, mk, te) -> Δ + Exponential(1 / μs))
mg = race(3, :on_completion; service = overhead_exp)

λ = 1.5
Lg, seg = replicate(r -> time_average(groups_in_system, mg, r), mg, [λ, 0.0], 2000.0, 16)

EX  = Δ + 1 / (3μs)                              # E[X₍₁:₃₎]
EX2 = Δ^2 + 2Δ / (3μs) + 2 / (3μs)^2             # E[X₍₁:₃₎²]
W   = EX + λ * EX2 / (2 * (1 - λ * EX))          # Pollaczek–Khinchine
println("measured groups in system: ", round(Lg, digits = 3), " ± ",
        round(seg, digits = 3), "   P–K: ", round(λ * W, digits = 3))
```

The test suite runs this oracle for hyperexponential service too, and
checks the price of redundancy from the record's service spans: every
replica works on the head group for exactly ``X_{(1:n)}``, so the server
time spent per merged job is ``E[C] = n\,E[X_{(1:n)}]``, canceled work
included.

A few semantics worth knowing before racing a larger network:

- **Blocked siblings cancel cleanly.** A sibling canceled while held
  blocked — finished at its station but waiting for room downstream —
  frees both the server it was holding hostage and its slot in the blocked
  queue, and the cascade admits the next job immediately. Cancellation
  never wedges a blocking chain.
- **Nested forks cancel recursively.** A canceled sibling that has itself
  forked cancels its live descendants, all the way down. In the other
  direction, a nested join's merged job inherits the group of its fork
  parent, so inner races compose with outer ones.
- **The record shows the canceled work.** Cancellation is deterministic
  given the state: it consumes no draws and adds no event kind, so replay
  reproduces every race from the same record ([I1 and I4](../manual/record_replay.md)).
  A canceled service span is still visible — fold
  [`fire_changes`](@ref) over the record and watch the clock's `st.te`
  entry open and then vanish without a firing of its own; that fold is how
  the ``E[C]`` test above counts abandoned work.

Three compile-time checks keep a race coherent. A join with `need < parts`
must declare a cancellation policy, or the leftover siblings would be
stranded (check C7, caught at declaration):

```@example richer
try
    join!(QueueNetwork(param_names = (:lambda,)), :first; parts = 3, need = 2)
catch err
    println(err.msg)
end
```

[`compile`](@ref) then checks that a fork's siblings can reach at most
*one* canceling join, so which join decides a group's race is unambiguous
(check C8), and that every station strictly between a tracked fork and its
canceling join receives sibling traffic only — no routes and no
`renege_to` edges from outside — so a job found on a branch is always
somebody's sibling (check C9).

One estimator caveat, kept in the
[estimator-validity table](../manual/state_dependent.md#Estimator-validity):
which sibling wins a race is decided by event order, the canonical
discontinuity that pathwise IPA cannot see. The score estimator remains
valid on racing records; [Gradient estimation](../manual/gradients.md) has
the details.

## Blocking

Buffers are finite in real systems. When a station's waiting room is full,
Concourse offers two `overflow` behaviors: `:drop` (the arriving job is
lost — a call center with a busy signal) and `:block`, where a *finished*
job at the upstream station cannot move forward, and holds its server
hostage until a slot frees downstream. Blocking is how congestion travels
*backwards* through a production line.

```@example richer
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b1 = buffer(Point(-160, 0), 110, 38; slots = 4, jobs = [0, 0, 0]) # hide
s1 = server(Point(-70, 0), 20; inservice = 0, label = L"\mu_1") # hide
b2 = buffer(Point(60, 0), 70, 38; slots = 1, jobs = [0]) # hide
s2 = server(Point(140, 0), 20; inservice = 0, label = L"\mu_2") # hide
sethue("black"); fontsize(12) # hide
text("capacity 1", Point(60, -30), halign = :center) # hide
text("blocked", Point(-70, -34), halign = :center) # hide
flow(Point(-300, 0), b1.entry; label = L"\lambda") # hide
flow(b1.exit, s1.entry) # hide
flow(s1.exit, b2.entry) # hide
flow(b2.exit, s2.entry) # hide
flow(s2.exit, Point(240, 0)) # hide
end 620 150 # hide
```

A tandem line where the second station's buffer holds one waiting job
(`capacity = 1, overflow = :block`), fed harder than the slow second server
can drain (``\lambda = 2``, ``\mu_1 = 3``, ``\mu_2 = 0.7``) so blocking is
constant. When several upstream servers wait for the same freed slot, who
goes first is model semantics, declared per station by an unblock policy —
`FCFSUnblock` (longest-blocked first) is the default and currently the only
policy:

```@example richer
net = QueueNetwork(param_names = (:lambda, :mu1, :mu2))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :first;  service = Law(:Exponential, scale = inv(Param(:mu1))))
station!(net, :second; service = Law(:Exponential, scale = inv(Param(:mu2))),
         capacity = 1, overflow = :block, unblock = FCFSUnblock())
sink!(net, :done)
route!(net, :arrive, Always(:first))
route!(net, :first,  Always(:second))
route!(net, :second, Always(:done))
bt = compile(net)

θ = [2.0, 3.0, 0.7]
rec, states = simulate(bt, θ, 500.0; seed = 3, keep_states = true)
first_st = bt.names[:first]
blocked(st) = isempty(st.hold[first_st]) ? 0.0 : 1.0
println("fraction of time station 1 is blocked: ",
        round(time_average(blocked, bt, rec), digits = 3))
```

No closed form is claimed here — finite-buffer tandems have no simple one —
but an exact accounting identity must still hold, blocking or not: every
arrival is either still inside or has departed. (Note the line at station 1
grows without bound at these rates; this system is deliberately
[unstable](arrivals.md), which is what sustained blocking looks like.)

```@example richer
arrivals    = count(k -> k[1] == :arrival, rec.key)
second_st   = bt.names[:second]
completions = count(k -> k[1] == :service && k[2] == second_st, rec.key)
println(arrivals, " arrivals − ", completions, " completions = ",
        arrivals - completions, "; in system at the end: ",
        number_in_system(states[end]))
```

One structural fact worth knowing: a *cycle* of stations that can block each
other is a deadlock waiting to happen. By default [`compile`](@ref) rejects
such networks (check C3) rather than let a simulation hang — but real
systems do have loops (rework sent back upstream, a token ring), and for
those the next section shows how to run one anyway and what happens the
moment it wedges.

### Cycles

Under transfer blocking, a **deadlock** is a cycle of stations, each with a
full buffer, each holding a finished job routed to the next station on the
cycle. Nothing can ever move again: the only slots that could receive a
held job are occupied by jobs whose own destinations are full, all the way
around the ring, and no future event frees space because each held job's
destination is already chosen. Passing `allow_blocking_cycles = true` to
[`compile`](@ref) skips check C3 and lets a cyclic topology run; the moment
the closing block-edge of a cycle forms, the simulation raises
[`BlockingDeadlock`](@ref) instead of hanging. The exception carries the
cycle's station names in routing order, the wall time, the held job ids,
and the partial record — every firing up to and including the one that
deadlocked, with the horizon set to the deadlock time.

Here is a two-station loop fed hard enough to wedge: jobs go
`:a → :b`, and `:b` sends three quarters of its output back to `:a`. Both
buffers hold one job, so once each station is full and holding a job bound
for the other, the ring is closed:

```@example richer
loop = QueueNetwork(param_names = (:lambda, :mu_a, :mu_b))
source!(loop, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(loop, :a; service = Law(:Exponential, scale = inv(Param(:mu_a))),
         capacity = 1, overflow = :block)
station!(loop, :b; service = Law(:Exponential, scale = inv(Param(:mu_b))),
         capacity = 1, overflow = :block)
sink!(loop, :done)
route!(loop, :arrive, Always(:a))
route!(loop, :a, Always(:b))
route!(loop, :b, Probabilistic(:a => 0.75, :done => 0.25))
ml = compile(loop; allow_blocking_cycles = true)

err = try
    simulate(ml, [4.0, 1.0, 1.0], 1000.0; seed = 1)
catch e
    e
end
println(sprint(showerror, err))
```

A deadlock is a property of the state, not of the random draws, so the
attached record is replayable evidence: [`replay`](@ref) reproduces the
trajectory and re-raises the identical error at the same firing.

```@example richer
rec = err.record
println("record stops at the deadlock: horizon = ", rec.horizon,
        ", last firing at t = ", rec.time[end])
err2 = try
    replay(ml, rec)
catch e
    e
end
println("replay re-raises the same deadlock: ",
        err2.cycle == err.cycle && err2.time == err.time && err2.jobs == err.jobs)
```

The cascade's order-independence claim
([F9 in the event-loop charter](../developer/event_loop.md#Charter-F9-F14))
was argued for acyclic blocking and has been re-examined under cycles: it
holds. On a cyclic topology under load, FIFO and LIFO worklists either both
reach the horizon with identical records or both raise the identical
`BlockingDeadlock` — freed waiting room admits the longest-blocked transfer
from a per-destination queue (`FCFSUnblock`), so cascade order can change
*when* a settle runs but never which blocked transfer wins the room.

One dynamics fact the tests make vivid: deadlock hazard accrues on every
blocking episode, regardless of utilization. A cycle in which both edges
actually block carries a positive wedging probability per episode, so it
wedges eventually — light load only stretches the expected time. A run that
should reach its horizon needs the closing edge *structurally* out of
reach, not merely improbable per unit time: in the two-station loop above, a
wide buffer at `:a` keeps the `:b → :a` edge from ever forming, and a small
CTMC computation in the test suite puts the wedging probability below
``10^{-5}`` over the whole horizon.

What Concourse does *not* offer is deadlock resolution — policies like the
simultaneous exchange, where every job on a wedged cycle rotates one
station forward at once. Resolution is a modeling decision with real
degrees of freedom (who moves, in what order, what the service clocks do)
and no canonical answer, so for now the library reports the deadlock
precisely and stops rather than pick a resolution silently. (Relatedly, if
a blocking network ever dies with the settle-cascade fuel error instead,
recompile with `allow_blocking_cycles = true` to get the precise
`BlockingDeadlock` diagnosis.)

## Reneging

Customers hang up; packets time out; shoppers abandon carts. **Reneging**
gives each *waiting* job a patience clock: if service has not started when
the clock fires, the job leaves the line and goes to a declared destination.
A job whose service has begun never reneges.

```@example richer
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-40, 0), 160, 44; slots = 5, jobs = [0, 0, 0]) # hide
s = server(Point(90, 0), 26; inservice = 0, label = L"\mu") # hide
flow(Point(-260, 0), b.entry; label = L"\lambda") # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(200, 0)) # hide
flow(Point(-70, 24), Point(-70, 80)) # hide
sethue("black"); fontsize(15) # hide
text(L"\gamma", Point(-88, 56), halign = :center, valign = :middle) # hide
fontsize(12) # hide
text("gives up", Point(-40, 96), halign = :center) # hide
end 560 200 # hide
```

The model M/M/1+M adds exponential patience (rate ``\gamma``, gamma) to
M/M/1, declared with a `patience` law and a `renege_to` destination. Take
``\lambda = \mu = 1``: *without* abandonment this queue sits exactly on the
edge of [instability](arrivals.md), but impatience drains long lines, so it
is stable:

```@example richer
net = QueueNetwork(param_names = (:lambda, :mu, :gamma))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))),
         patience = Law(:Exponential, scale = inv(Param(:gamma))),
         renege_to = :lost)
sink!(net, :done)
sink!(net, :lost)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
ra = compile(net)
nothing # hide
```

The exact stationary distribution (the **Erlang-A** model) comes from a
birth–death chain: arrivals at rate ``\lambda``; departures from state ``n``
at rate ``\mu + (n-1)\gamma``, the server plus ``n-1`` impatient waiters.
Ten lines to compute, two predictions to check — the mean number in system
``L``, and the abandonment rate, which must equal ``\gamma`` times the mean
number *waiting* ``L_q``:

```@example richer
function erlang_a(λ, μ, γ; N = 400)
    w = ones(N + 1)
    for n in 1:N
        w[n + 1] = w[n] * λ / (μ + (n - 1) * γ)
    end
    π = w ./ sum(w)
    L  = sum(n * π[n + 1] for n in 0:N)
    Lq = sum(max(n - 1, 0) * π[n + 1] for n in 0:N)
    L, Lq
end

θ = [1.0, 1.0, 0.5]
L_exact, Lq_exact = erlang_a(θ...)

recs = [simulate(ra, θ, 2000.0; seed = 1000 + r) for r in 1:16]
Ls    = [time_average(number_in_system, ra, r) for r in recs]
rates = [count(k -> k[1] == :patience, r.key) / r.horizon for r in recs]

println("mean in system:   ", round(mean(Ls), digits = 3), " ± ",
        round(std(Ls) / sqrt(16), digits = 3), "   Erlang-A: ",
        round(L_exact, digits = 3))
println("abandonment rate: ", round(mean(rates), digits = 3), " ± ",
        round(std(rates) / sqrt(16), digits = 3), "   gamma*Lq: ",
        round(θ[3] * Lq_exact, digits = 3))
```

Abandonments appear in the record as a third kind of event key,
`(:patience, station, job)`, next to `:arrival` and `:service` — the same
record machinery from [page one](jobs_servers.md), one clock family richer.

Every check in this tutorial has quietly leaned on replications, seeds, and
time averages. The [last page](measuring.md) makes that machinery explicit —
and shows the traps.
