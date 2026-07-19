# State-dependent service laws

A service rate that depends on how busy the station is — helpers who join
as the line grows, a machine that slows near saturation, a birth–death
chain with an arbitrary rate function — is bread-and-butter queueing. In
Concourse a station's service law may read live occupancy through two
expression atoms, and the interpreter re-evaluates the law mid-flight
whenever a count it watches changes. Processor sharing, which always worked
this way, is now one special case of the same machinery.

## The atoms, and where they may appear

[`InService`](@ref)`(:s)` is the number of jobs in service at station
`:s`, and [`InBuffer`](@ref)`(:s)` the number waiting, both as `Float64`
counts at the moment the law is evaluated. They compose with the rest of
the [expression algebra](../reference/expressions.md), so
`Param(:mu) * min(InService(:q) + InBuffer(:q), Const(3.0))` is a rate
that grows with the crowd and saturates at three.

Occupancy is live state, not a value frozen at enabling, so where the
atoms may appear is restricted: **only the service law of a station**
(compile check C5). A mark law reading state would push station state into
the record's mark draws and break replay; a state-reading interarrival law
is balking, a separate feature; patience laws, routing kernels, and
discipline ordering keys are refused for their own reasons. As with every
static check, [`compile`](@ref) names the problem:

```@example statedep
using Concourse

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda) + InService(:q))))
station!(net, :q; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:q))
route!(net, :q, Always(:done))
try
    compile(net)
catch err
    println(err.msg)
end
```

The [`reads_state`](@ref) census reports which stations a law watches.
[`compile`](@ref) turns the census into a dependency map on the
[`QueueGSMP`](@ref) (`srv_readers` and `buf_readers`), so the interpreter
knows exactly which stations' service clocks to revisit when an in-service
or buffer count changes — and revisits no others.

## The segment convention

A clock enabled under one occupancy may see that occupancy change before
it fires. Each change closes one *segment* of the clock's history and
opens another. Four quantities describe a clock mid-flight:

- **`te`** — the wall-clock enabling time. It is set once, when the clock
  enters the enabled set, and *never rewritten* while the clock lives.
- **accrued effort** — the service the job has received so far: wall time
  weighted by speed. Speed is 1 everywhere except processor sharing, where
  it is `min(1, servers/n)`.
- **bank** — the effort accumulated over the closed segments
  (`st.bank[k]`).
- **anchor** — the wall time at which the current segment opened
  (`st.anchor[k]`).

When a watched count changes at time ``t``, every surviving in-service
clock of a reader station banks the effort of the segment that just closed
(at the *old* speed), moves its anchor to ``t``, keeps `te` where it was,
and is re-declared to the sampler with the delta `(:reenable, k)`. The new
law is the *fresh base* — the station's law rebuilt from the occupancy now
— conditioned on the total draw exceeding the accrued effort: age
carryover. Internally the wrapper is
`SharedRemaining(newbase, age, speed, shift)`, whose support starts at the
anchor's offset from `te`.

One clock, walked through its life at speed 1:

| wall time | what happens | `te` | bank | anchor | law declared to the sampler |
|---|---|---|---|---|---|
| 2.0 | enabled; occupancy gives base ``F_1`` | 2.0 | — | — | ``F_1``, measured from `te` |
| 5.0 | a watched count changes: `(:reenable, k)` | 2.0 | 3.0 | 5.0 | ``F_2`` conditioned on ``X > 3.0``, anchored at 5.0 |
| 6.5 | it changes again: `(:reenable, k)` | 2.0 | 4.5 | 6.5 | ``F_3`` conditioned on ``X > 4.5``, anchored at 6.5 |
| 8.0 | the clock fires | — | — | — | the drawn ``X`` was ``4.5 + (8.0 - 6.5) = 6.0`` |

An alternative convention was considered and rejected: the
quantile-equivalent (hazard-matching) mapping, which would carry the old
law's survival quantile into the new law so that the clock's survival
probability is continuous across the change. Age carryover won because it
is what processor sharing already implements — a PS speed change is now
literally this path, with the station registered as an srv-reader of
itself, the base law unchanged, and speed `min(1, servers/n)` — and
because it is what the ClockGradients fixed-anchor contract expects: `te`
anchors every likelihood segment, and the score replay rebuilds the
current segment's law at every state it visits. The convention is recorded
as amendment A5 in `notes/model_definition.tex`.

## M/M/c as one state-dependent server

The classic birth–death identity: ``c`` exponential servers at rate
``\mu`` each are indistinguishable from *one* server whose rate is
``\mu \cdot \min(n, c)``, with ``n`` the number in the system. The second
formulation exercises the whole re-evaluation path — every arrival and
departure below ``n = c`` changes the law of the clock in flight.

```@example statedep
c = 3.0
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
n = InService(:q) + InBuffer(:q)
station!(net, :q; servers = 1,
         service = Law(:Exponential, scale = inv(Param(:mu) * min(n, Const(c)))))
sink!(net, :done)
route!(net, :arrive, Always(:q))
route!(net, :q, Always(:done))
m = compile(net)

rec = simulate(m, [2.1, 1.0], 20000.0; seed = 3)
time_average(number_in_system, m, rec)
```

Erlang C for M/M/3 at ``\lambda = 2.1``, ``\mu = 1`` puts the exact
long-run mean at about 3.25. The test suite runs this comparison as a
replicated 4-standard-error oracle test, both ways: the plain
three-server station and this one-server disguise agree with the closed
form and with each other.

## A cross-station read

The atoms are not confined to a station's own counts. Here station `:b`
slows down while station `:a` is busy — `:b` is a reader of `:a`'s
in-service count and of nothing else:

```@example statedep
net2 = QueueNetwork(param_names = (:la, :ma, :lb, :mb))
source!(net2, :src_a; interarrival = Law(:Exponential, scale = inv(Param(:la))))
source!(net2, :src_b; interarrival = Law(:Exponential, scale = inv(Param(:lb))))
station!(net2, :a; service = Law(:Exponential, scale = inv(Param(:ma))))
station!(net2, :b; service = Law(:Exponential,
         scale = inv(Param(:mb) * (Const(1.0) - Const(0.5) * InService(:a)))))
sink!(net2, :done)
route!(net2, :src_a, Always(:a))
route!(net2, :src_b, Always(:b))
route!(net2, :a, Always(:done))
route!(net2, :b, Always(:done))
mx = compile(net2)
```

Folding the record through [`fire_changes`](@ref) shows the mechanism:
`(:reenable, k)` deltas appear exactly at firings that change `:a`'s
in-service count while `:b` has a survivor in service, and nowhere else.

```@example statedep
θ = [1.0, 2.0, 0.8, 2.0]
rec2 = simulate(mx, θ, 300.0; seed = 41, debug = true)
st = Concourse.initial_state(mx)
nreen = 0
for i in eachindex(rec2.key)
    ds = Concourse.replaydraws(rec2.key[i], rec2.draws[i], mx.params)
    global st, deltas = fire_changes(mx, st, rec2.key[i], rec2.time[i], ds)
    global nreen += count(d -> d[1] == :reenable, deltas)
end
nreen
```

The bank and anchor tables are part of [`QueueState`](@ref), so
[replay](record_replay.md) reproduces state-dependent trajectories
exactly, `states_equal` compares the segment bookkeeping field by field,
and the [debug oracle](checking.md) runs unchanged.

Two tools opt out, deliberately. `Concourse.stability` skips
state-reading stations — their service law has no static mean, and the
census principle is to report what the combinator values expose, never to
invent. And `branch_world` refuses state-reading service laws with an
`ArgumentError`, for the estimator reason the next section makes precise.

## Estimator validity

This table records which derivative estimators are guaranteed for which
model features; later capabilities will extend it.

| Model feature | Pathwise IPA | Score | SPA |
|---|---|---|---|
| ``\theta``-dependent mark laws | not guaranteed | not guaranteed | not guaranteed |
| State-dependent service laws | not guaranteed | **valid** | valid |
| [Batch service](batching.md) (`Batching`) | not guaranteed | **valid** | valid |
| [Sibling cancellation](../queues/richer_stations.md#Racing-and-cancellation) (`join!` with `cancel`) | not guaranteed | **valid** | valid |

- **``\theta``-dependent mark laws** (the existing
  [branching](branching.md) restriction): a mark law that reads a
  parameter adds a derivative term of its own to every estimator, and that
  term is not implemented — `branch_world` refuses such models at
  construction rather than return a silently incomplete number.
- **State-dependent laws, pathwise IPA**: not guaranteed unbiased. IPA
  holds the event order fixed while perturbing times, but reordering
  events changes an occupancy, hence the law itself, discontinuously — the
  interchange argument behind IPA does not cover that coupling. This is
  why `branch_world` refuses state-reading service laws.
- **State-dependent laws, score**: valid. The likelihood of each
  inter-event interval is evaluated under the current segment's law, which
  the record and the `te`/bank/anchor bookkeeping pin down exactly. The
  test suite verifies `E[score] = 0` and agreement with finite differences
  on birth–death models.
- **State-dependent laws, SPA**: the estimator remains valid — SPA's
  correction conditions on the realized order at each swap, so a law
  change caused by the swap sits inside the conditioning. The current
  `spa_gradient`, however, refuses any record containing re-declared
  clocks rather than handle multi-segment histories, so this validity has
  no code path yet; use the score estimator today.
- **[Batch service](batching.md), score**: valid. The batch clock's law
  reads only the `batchsize` mark, frozen at enabling like every mark, so
  each interval's likelihood is exactly what the record pins down —
  nothing state-dependent enters the law mid-flight.
- **Batch service, pathwise IPA**: not guaranteed unbiased. The batch
  size is integer-valued: a perturbation that reorders an arrival against
  a batch formation changes the composition by whole jobs, and the path
  jumps. Unlike state-reading laws, `branch_world` does *not* refuse
  batching models — the fragility is documented here, not enforced —
  because statistics insensitive to composition may still differentiate
  cleanly; the claim is the user's to make.
- **Batch service, SPA**: valid — a swap's correction conditions on the
  realized order, so the recomposition a swap causes sits inside the
  conditioning, as with a law change. Batch clocks are never re-declared,
  so these records do not trip `spa_gradient`'s multi-segment refusal.
- **Sibling cancellation, score**: valid. Cancellation consumes no draws
  and changes no law mid-flight: canceled clocks simply leave the enabled
  set at a firing the record pins down, so each inter-event interval's
  likelihood — survival terms of the canceled clocks included — is exactly
  what the record says it is.
- **Sibling cancellation, pathwise IPA**: not guaranteed unbiased — this
  is the canonical order discontinuity. Which sibling wins a race *is* the
  event order: a perturbation that swaps two finish times swaps the
  winner's identity, and different work is canceled. IPA is valid only for
  statistics insensitive to that identity switch; as with batching, the
  fragility is documented, not enforced — `branch_world` does not refuse
  racing models, and the insensitivity claim is the user's to make.
- **Sibling cancellation, SPA**: valid — a swap's correction conditions on
  the realized order, so the identity switch and the work it cancels sit
  inside the conditioning; SPA is the road to latency derivatives for
  racing models. Canceled clocks are removed, never re-declared, so these
  records do not trip `spa_gradient`'s multi-segment refusal.

[Closed networks](closed_networks.md) (`populate!`) earn no row: initial
marks are ordinary recorded draws, consumed once at ``t = 0`` and replayed
from the record's `init` slot, so seeding introduces no new event-order
discontinuity and no new likelihood term. A θ-reading *initial* mark law
falls under the θ-dependent-mark row above — `branch_world` refuses it
exactly as it refuses a source's.

See [Gradient estimation](gradients.md) for the estimators themselves and
for the processor-sharing experiment that first demonstrated the IPA
failure on multi-segment records.
