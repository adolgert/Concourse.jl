# Round-based token service

An LLM inference server does not serve requests one at a time: at every
iteration it recomposes a batch, spends a token budget across the requests
in it — a prefill chunk here, one decode token each there — and every
request's remaining work shrinks by exactly what it was allocated.
Requests persist across many iterations; the "batch" is a per-iteration
allocation, not a group of jobs that enters and leaves together. Queueing
theory calls this *iteration-level batching*, and Concourse expresses it
with the `rounds` keyword of [`station!`](@ref): a station that serves in
synchronous **rounds**, with per-job integer work counters, one
station-level clock per round, and a *policy* hook at every round
boundary. Everything else — sources, routing, reneging, fork/join,
records — keeps its usual meaning.

```julia
station!(net, :gpu;
    rounds = Rounds(
        policy   = Sarathi(budget = 512),
        duration = Law(:Dirac, value = Const(11.28) + Const(35.47) * ceil(Mark(:tokens) / 128)),
        work     = (:v_p, :v_d),
    ))
```

`work` names the marks (produced upstream, by [`populate!`](@ref), or by
the station's own [`remark`](../queues/marks.md#Redrawing-marks-en-route))
that give a job's integer work profile, in phase order; they are
snapshotted into counters at admission. The last phase is the decode phase
of the shipped policies; every earlier phase is chunkable prefill.

## The round lifecycle

A deposit files the job into the station's FCFS buffer like any other
deposit. Then, whenever the station has **no round running**, the settle
step asks the policy to plan one: [`plan_round`](@ref)`(policy, view,
draws)` sees the waiting line and the active set through a read-only
[`RoundView`](@ref) and returns a [`RoundPlan`](@ref) — or `nothing` to
idle. A plan commits in three moves: evictions (active jobs return to the
waiting line), admissions (waiting jobs move into the active set, their
work marks snapshotted into counters), and per-active-job integer
allocations, which the engine checks against ``0 \le \text{alloc} \le
\text{remaining}`` per phase. The plan's **aggregates** — `tokens` (the
total allocation ``b``), `requests` (the batch size ``k``), and one sum
per work phase — are frozen, and one station-level `:round` clock is
enabled under the `duration` law, which reads those aggregates as
pseudo-marks (and nothing else — check C13). The round then runs closed
and non-preemptive: deposits during a round simply queue, and the next
boundary is the clock's firing.

At the firing the allocations are **credited** — each active job's
counters drop by exactly its allocation — and every job whose last phase
hit zero routes onward on its own marks, like any departure. Then the
station re-plans *immediately, at the same instant*, so back-to-back
rounds chain with no gap. Work conservation is the policy's business, not
the engine's: a policy that returns a plan with no useful allocation gets
exactly the round it asked for.

When the policy returns `nothing` the station idles with **no clock at
all**, and the next deposit triggers the next planning attempt. One
convention follows: the round grid is not a global slotted clock but
re-anchors at the first deposit after an idle period. Both papers below
analyze loaded regimes where the server never idles, so the convention is
invisible there; it is documented because a lightly loaded round station
genuinely has no "slot 17 of the simulation" — only rounds it actually
ran.

## The station shape (check C12)

Round service composes with exactly the plain FCFS station shape: the
non-preemptive `:back`-insert [`FCFS`](@ref) discipline, no `batching`
(the policy owns batch formation), `servers = 1` (the round clock *is*
the server), and no `service` law (the duration lives in the `Rounds`
config). The work marks must be produced upstream (the census checks it)
and must be integers ``\ge 0`` at admission, checked at runtime. As with
every static check, [`compile`](@ref) names the problem:

```@example rounds
using Concourse

net = QueueNetwork(param_names = (:lambda,))
source!(net, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(w = Law(:Dirac, value = Const(1.0))))
station!(net, :gpu; discipline = LCFS(),
         rounds = Rounds(policy = Sarathi(budget = 8),
                         duration = Law(:Dirac, value = Const(1.0)),
                         work = (:w,)))
sink!(net, :done)
route!(net, :arrive, Always(:gpu))
route!(net, :gpu, Always(:done))
try
    compile(net)
catch err
    println(err.msg)
end
```

## The policy contract

[`RoundPolicy`](@ref) is the first user-code hook inside the fire path,
so its contract is stated bluntly: **a policy is a pure function of
`(view, draws)`**. All randomness flows through the draw source (via
[`Concourse.draw!`](@ref), recorded in the firing's draw list and replayed
from it); no clocks, no wall time, no ``\theta``, no state beyond the
view. The [`RoundView`](@ref) is built as a real barrier — copies and
values, never the `QueueState` — so a policy can rank and count jobs but
cannot reach the simulation. The contract is documented and tested rather
than compile-checked, the [`Opaque`](@ref) law precedent: Julia cannot
prove an arbitrary function pure, but [replay
equality](record_replay.md) and the [debug membership
oracle](checking.md) catch violations — the test suite includes a rigged
impure policy caught exactly this way.

What the policy sees and returns:

- [`RoundView`](@ref): `phases` (the `work` mark names, in order),
  `waiting` (the buffer in FCFS order), `active` (the jobs in service, in
  admission order) — each entry a [`RoundJob`](@ref) with `id`, `marks`,
  and `work`, where `work` is remaining counters for an active job and
  the full profile for a waiting one.
- [`RoundPlan`](@ref)`(admit, evict, alloc)`: waiting ids to activate,
  active ids to return to the line, and `id => tokens-per-phase` pairs
  over the post-admission active set (an absent job gets zero).

## Waiting, eviction, cancellation

**Waiting** jobs are ordinary waiting jobs: they keep patience clocks and
renege as usual, racing the next round boundary exactly as reneging races
batch formation on the [batch service page](batching.md). **Active** jobs
have no clocks of their own — the one round clock is the station's.

**Eviction always resets work counters** — Dong & Cao's refresh
semantics: an evicted request's partial progress is discarded, and if it
is later re-admitted it regenerates everything (the recomputation is
visible in the record). The evicted job re-files at the *back* of the
FCFS line with a **fresh** patience clock; a keep-progress, keep-position
eviction is a different capability, out of scope until a target model
needs it.

**Cancellation** (a [`join!`](@ref) sibling losing its race) may reach a
job that is active mid-round: the job is removed from the active set, its
counters and its entry in the running plan are deleted, and the round
runs on — the clock's aggregates were frozen at enabling, like every
mark, so the duration does not change under it. This is the canceled
batch-member rule applied to rounds.

**Departures meeting a full `:block` destination are dropped**, exactly
as batch members are and for the same reason: by the time a round's
finished jobs are deposited, the round has fired — there is no per-job
server left to hold them. The [batching page](batching.md) records the
rationale in full.

## The shipped policies

Seven policies ship with Concourse, each a few dozen lines over the view
and each usable as a template for writing your own. The first five are
the stylized scheduling rules of Dai, Deng, Li & Peng, "Throughput-Optimal
Scheduling Algorithms for LLM Inference and AI Agents" (arXiv:2504.07347);
the last two are the flow-control algorithms of Dong & Cao,
"Flow-Controlled Scheduling for LLM Inference with Provable Stability
Guarantees" (arXiv:2604.11001).

- [`FasterTransformerRule`](@ref)`(budget, kmax)` — decode-prioritized,
  no mixed batching: decode-only rounds while any decode is pending,
  whole-prefill rounds otherwise. Not work-conserving.
- [`VanillaVLLM`](@ref)`(budget, kmax)` — prefill-prioritized, no mixing,
  no chunking: whole-prefill rounds while any prefill is pending. Not
  work-conserving.
- [`Orca`](@ref)`(budget, kmax)` — prefill-first mixed batching: fill the
  budget with prefill tokens (chunked), pack decode tokens into the
  remainder. Work-conserving, throughput-optimal in the paper's Theorem 2
  region.
- [`Sarathi`](@ref)`(budget, kmax)` — decode-first mixed batching: one
  token per pending decode, then prefill chunks from a minimal number of
  requests. Work-conserving, throughput-optimal.
- [`ClassPriority`](@ref)`(inner; by, order)` — strict non-preemptive
  class priority wrapped around any of the above, class by class on the
  leftover budget. This is the wrapper the paper's Rybko–Stolyar
  two-server instability experiment (§5.4) needs.
- [`ClassBudgets`](@ref)`(b; class)` — Dong & Cao's Algorithm 1: per-slot
  per-class activation budgets, FIFO, one decode token per active request
  per round, no memory check (budgets satisfying the paper's inequality
  keep the KV cache safe by construction).
- [`FlowControl`](@ref)`(Bdist, M; prompt)` — Dong & Cao's Algorithm 2: a
  *drawn* global activation budget each round (through the draw source,
  so it replays), KV accounting ``U = \sum (l + \text{generated} + 1)``,
  and LIFO eviction with full progress reset while ``U > M``.

## An M/D/1 in disguise

The sharpest cheap check of the engine is the degenerate case: one work
phase, every job carrying one unit of work, `Sarathi(budget = 1)`, and a
`Dirac` duration. Each round serves exactly one job for a fixed time —
the round station *is* M/D/1, and the mean queue must match
Pollaczek–Khinchine:

```@example rounds
net = QueueNetwork(param_names = (:lambda,))
source!(net, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(w = Law(:Dirac, value = Const(1.0))))
station!(net, :gpu;
         rounds = Rounds(policy = Sarathi(budget = 1),
                         duration = Law(:Dirac, value = Const(0.5)),
                         work = (:w,)))
sink!(net, :done)
route!(net, :arrive, Always(:gpu))
route!(net, :gpu, Always(:done))
m = compile(net)

λ, s = 1.2, 0.5
rec = simulate(m, [λ], 8000.0; seed = 11)
L = time_average(number_in_system, m, rec)
ρ = λ * s
println("simulated L = ", round(L, digits = 3),
        "   Pollaczek–Khinchine: ", round(ρ + ρ^2 / (2 * (1 - ρ)), digits = 3))
```

The test suite runs this as a replicated 4-standard-error oracle test,
and sharper still: the round record's firing sequence must match a plain
FCFS M/D/1 model's firings one for one at the same seed — the engine adds
nothing when the policy degenerates.

## Notes from the paper reproductions

The test suite (`test/test_rounds_papers.jl`) reproduces both papers end
to end — Dai's Fig. 8 worked example, Theorem 2 stability boundary,
vertex-C discriminator, and Rybko–Stolyar network; Dong & Cao's
Algorithm 1 decoupling identity and Algorithm 2 eviction dynamics. Two
behavioral findings from that work are worth knowing when you build on
the shipped policies:

- **Dai's Fig. 8 is schematic about its token budget.** The figure fixes
  only the five requests' decode lengths, and no single ``b_{\max}``
  reproduces all four of its policy rows: Orca's second batch carries
  five tokens where vanilla vLLM's third stops at four. The tests
  reproduce the vLLM, FasterTransformer, and Sarathi rows exactly at
  ``b_{\max} = 4`` and the Orca row at ``b_{\max} = 5`` — the figure is
  schematic about the budget, not about the compositions.
- **`FasterTransformerRule` and `VanillaVLLM` freeze totally when a whole
  prefill exceeds** ``b_{\max}``. Neither chunks prefill, faithful to the
  paper's stylization, so a request whose entire prefill does not fit the
  budget blocks the head of the line forever: no round ever runs and the
  backlog is exactly the arrival count. The deterministic vertex-C
  experiment shows this failure mode at ``b_{\max} = 128`` against a
  290-token prefill — reproduced by the tests as the paper's own
  discriminator, not papered over.

## Estimators

The honest position, recorded in the
[estimator-validity table](state_dependent.md#Estimator-validity):

- ``\theta`` in the **arrival, mark, or remark laws feeding a round
  station**: the score estimator is valid. Round dynamics are a
  deterministic map of the recorded draws — the policy consumes no
  ``\theta`` (its contract forbids it) — so the likelihood lives entirely
  in the laws that produced the draws, exactly as the record states it.
- ``\theta`` in a **density-bearing duration law**: score valid as usual;
  the aggregates are frozen pseudo-marks, so nothing state-dependent
  enters the law mid-flight.
- ``\theta`` in a **`Dirac` duration** — Dai's staircase constants ``a``
  and ``c`` are the common case: **no score channel exists** (a point
  mass bears no density, so the score cannot see those parameters at
  all), and pathwise IPA is not certified (a perturbation that reorders a
  deposit against a round boundary changes plans by whole tokens). This
  is SPA territory, documented rather than silently wrong.
- [`branch_world`](@ref) refuses models containing round stations in v1,
  the state-reading-law refusal precedent; score gradients over recorded
  trajectories remain available for ``\theta`` in the feeding laws.

The `ceil`/`floor` expressions the staircase uses are flat almost
everywhere, so a dual number entering them leaves as a constant — which
is exact, not an approximation: the staircase genuinely has zero slope
between its jumps.
