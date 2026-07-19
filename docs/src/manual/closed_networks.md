# Closed networks

A fixed population of jobs circulating forever — ``N`` machines cycling
between working and being repaired, ``N`` interactive users thinking and
then submitting a request, a central-server model with a set number of
processes — is a **closed** network: nothing arrives from outside and
nothing leaves. In Concourse a population is declared with
[`populate!`](@ref), and everything else — disciplines, capacities,
routing, records, replay, gradients — keeps its usual meaning. The one
genuinely new mechanism is a "firing 0" slot in the record, `init`,
carrying the draws that seeding consumed, so that a populated network
replays and differentiates exactly like an open one.

## Seeding a population

[`populate!`](@ref)`(net, station, count; mark = nothing)` seeds `count`
jobs at a service station — only a service station; populating a source,
sink, fork, or join is an error. Multiple calls compose, which is how a
multiclass population is written: each call may carry its own
[`MarkLaw`](@ref), and each seeded job draws its marks at time zero.

A network with at least one `populate!` needs no source — that is a
closed network — and sources and populations may also coexist, an open
network that starts nonempty. In the mixed case the census is exactly
``N + \text{arrivals} - \text{departures}`` at every recorded state,
which the test suite folds over a whole record. A network with neither a
source nor a population is refused at [`compile`](@ref): "the network
has no source and no populate! entry, so it can never contain a job".

Placement is deliberately unmagical. Each entry's jobs are filed into
their station's buffer in declaration order, and then *one* settle
cascade runs at ``t = 0`` — the same dispatch step every firing runs —
honoring the discipline and the capacity, so the run starts exactly as
if the jobs had always been there. Every clock that ends up enabled gets
enabling time `0.0` through the ordinary enable loop; nothing downstream
knows a job was seeded rather than routed. Because seeded jobs are
ordinary residents, they must fit — check C10 requires each populated
station's counts to sum to at most `servers + capacity`:

```@example closed
using Concourse

net = QueueNetwork(param_names = (:mu,))
station!(net, :a; servers = 1, capacity = 2,
         service = Law(:Exponential, scale = inv(Param(:mu))))
route!(net, :a, Always(:a))
populate!(net, :a, 4)
try
    compile(net)
catch err
    println(err.msg)
end
```

One check goes quiet rather than loud: `Concourse.stability` (check C4)
returns an empty report for a sourceless network. With a fixed
population there is no arrival rate to outrun, so a closed network
cannot be unstable; mixed networks keep the source-driven part of the
traffic equations.

## A closed cycle against Buzen's algorithm

The two-station cycle is the smallest closed network with something to
predict: ``N`` jobs alternate between exponential single-server stations
`:a` and `:b`, and the question is how the population splits between
them in the long run.

```@example closed
net = QueueNetwork(param_names = (:mu1, :mu2))
station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu1))))
station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu2))))
route!(net, :a, Always(:b))
route!(net, :b, Always(:a))
populate!(net, :a, 4)
m = compile(net)

θ = [1.0, 1.5]
rec = simulate(m, θ, 4000.0; seed = 5)
at(name) = (q = m.names[name]; st -> Float64(length(st.buf[q]) + length(st.srv[q])))
La = time_average(at(:a), m, rec)
Lb = time_average(at(:b), m, rec)
La + Lb    # the population is closed: every job is at :a or :b
```

The exact answer comes from the product form for closed networks
(Gordon–Newell): the stationary probability of an occupancy vector is
``\prod_i \rho_i^{n_i}`` divided by a normalizing constant ``G(N)``,
where ``\rho_i`` is visit ratio × mean service time. ``G(N)`` looks like
a sum over all ways to place ``N`` jobs on the stations, but **Buzen's
convolution** computes it in ``O(MN)``: fold stations in one at a time
with ``g_m(n) = g_{m-1}(n) + \rho_m\, g_m(n-1)``, which one ascending
in-place pass realizes. The mean occupancy of station ``i`` follows from
the same table, ``L_i = \sum_{k=1}^{N} \rho_i^k\, G(N-k)/G(N)``:

```@example closed
N = 4
ρ = [1 / θ[1], 1 / θ[2]]    # visit ratio × mean service time; both visits are 1
G = zeros(N + 1)
G[1] = 1.0
for r in ρ, n in 1:N
    G[n + 1] += r * G[n]
end
exact_La = sum(ρ[1]^k * G[N - k + 1] / G[N + 1] for k in 1:N)
println("simulated L at :a = ", round(La, digits = 3),
        "   Buzen exact = ", round(exact_La, digits = 3))
```

This is the validation pattern for closed models: an exact
normalizing-constant (or mean value analysis — MVA walks the same
recursion population by population) computation priced against the
simulated time averages. The test suite runs this comparison as a
replicated 4-standard-error oracle test, and checks that the two
station means sum to exactly ``N``.

## Machine repairman

The classical availability model is two lines away from the cycle:
``N`` machines fail independently — a *delay station* `:up` with
`servers = N`, so every machine ages on its own clock — and queue for a
single repairman. The number in repair is a finite birth–death chain
with ``\pi_k \propto \frac{N!}{(N-k)!} (\nu/\mu)^k``, which prices the
fraction of machines up:

```@example closed
netmr = QueueNetwork(param_names = (:nu, :mu))
station!(netmr, :up; servers = N, service = Law(:Exponential, scale = inv(Param(:nu))))
station!(netmr, :repair; service = Law(:Exponential, scale = inv(Param(:mu))))
route!(netmr, :up, Always(:repair))
route!(netmr, :repair, Always(:up))
populate!(netmr, :up, N)
mr = compile(netmr)

θmr = [0.5, 2.0]    # failure rate ν, repair rate μ
mrec = simulate(mr, θmr, 4000.0; seed = 9)
up = mr.names[:up]
avail = time_average(st -> Float64(length(st.srv[up])), mr, mrec) / N

r = θmr[1] / θmr[2]
πk = [factorial(N) / factorial(N - k) * r^k for k in 0:N]
πk ./= sum(πk)
exact = sum((N - k) * πk[k + 1] for k in 0:N) / N
println("simulated availability = ", round(avail, digits = 3),
        "   birth–death exact = ", round(exact, digits = 3))
```

## Firing 0: the record's init slot

Seeding may consume randomness — each populated job draws its marks at
``t = 0``, and the ``t = 0`` dispatch may draw too (a [`SIRO`](@ref)
pick, say). Under amendment A4 new randomness means new record content,
never a second channel, so these draws flow through the same draw
conduit as every mark and routing draw, keyed by the reserved
pseudo-clock `(:init, 0, 0)`.
`:init` is not a clock family — this key can never be enabled or fired —
it exists to key the seeding streams and to label the record's
[`MarkedRecord`](@ref) `init` list, the "firing 0" slot. A two-class
population makes the contents visible:

```@example closed
netc = QueueNetwork(param_names = (:mu1, :mu2))
station!(netc, :a; service = Law(:Exponential, scale = Mark(:speed) * inv(Param(:mu1))))
station!(netc, :b; service = Law(:Exponential, scale = inv(Param(:mu2))))
route!(netc, :a, Always(:b))
route!(netc, :b, Always(:a))
populate!(netc, :a, 2; mark = MarkLaw(speed = Law(:Dirac, value = Const(0.5))))
populate!(netc, :b, 2; mark = MarkLaw(speed = Law(:Dirac, value = Const(2.0))))
mc = compile(netc)

crec = simulate(mc, [1.0, 1.5], 100.0; seed = 21)
crec.init
```

Four initial mark draws, in declaration order — the order
[`initial_state`](@ref) seeds jobs, which is the order replay reads them
back. [`replay`](@ref) and [`time_average`](@ref) seed the initial state
from `rec.init` before folding the firings, so a populated record
replays without an RNG or a θ, like every record. The conduit's
discipline also holds at firing 0: a truncated `init` list errors loudly
instead of desynchronizing quietly.

```@example closed
short = MarkedRecord(crec.key, crec.time, crec.draws, crec.init[1:3], crec.horizon)
try
    replay(mc, short)
catch err
    println(err.msg)
end
```

The zero-argument [`initial_state`](@ref)`(m)` still works for draw-free
populations (no `mark` laws, deterministic dispatch). For a draw-bearing
population it refuses to invent draws and points at the record instead:

```@example closed
try
    initial_state(mc)
catch err
    println(err.msg)
end
```

## Branching and gradients

The score estimator works through the record, population included:
[`replay_model`](@ref) binds `rec.init`, so the ClockGradients contract's
`initial_state` reproduces the seeded population — and its ``t = 0``
clocks enter the likelihood like any others. The test suite checks the
score gradient of the closed cycle's occupancy with respect to both
service rates against common-random-number finite differences, drift
alarm included.

The live, branchable side is stricter, and loud about it. A drawn
initial mark cannot branch: [`live_model`](@ref)'s init binding is
empty, and [`branch_world`](@ref) seeds from the zero-argument
`initial_state`, so both fail at seeding rather than replay stale
values — only draw-free populations branch. A θ-reading initial mark law
is refused by `branch_world` at construction, exactly as a θ-reading
source mark law is: an initial mark law *is* a mark law, and a
θ-dependent one would add an unimplemented derivative term to every
estimator (see [the branching rules](branching.md)).

Beyond those existing rules, closed populations add no estimator caveat:
initial marks are ordinary recorded draws, consumed once at ``t = 0``,
so seeding introduces no new event-order discontinuity and no new
likelihood term. The
[estimator-validity table](state_dependent.md#Estimator-validity) gains
no row.
