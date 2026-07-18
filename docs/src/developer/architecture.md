# Architecture

Concourse is built in three layers. A user writes a queueing network in a
small surface language. The library compiles that network into an
intermediate representation (IR): a generalized semi-Markov process (GSMP)
written down as plain data, with a small generic interpreter. The
interpreter drives [CompetingClocks.jl](https://github.com/adolgert/CompetingClocks.jl),
which samples the clocks. This page translates the design note
`notes/queue_layers.tex`, which set out the layering.

!!! note "Precedence"
    `notes/queue_layers.tex` was the first design document. Two later notes,
    `notes/model_definition.tex` and `notes/event_loop.tex`, amend it. Where
    the documents disagree, the later two win. The pages
    [The model contract](model_contract.md) and [The event loop](event_loop.md)
    translate those amendments. The end of this page lists what changed.

## Why three layers

Each layer has a one-sentence contract.

- **Layer 1 builds a value.** The surface calls (`source!`, `station!`,
  `route!`, ...) construct a `QueueNetwork`. Nothing executes.
- **Layer 2 is pure functions over data.** `compile(net)` produces a
  `QueueGSMP` that satisfies the ClockGradients.jl model contract. The model
  is a value you can print, diff, hash, and analyze.
- **Layer 3 is driven by the interpreter.** No model rule ever calls the
  sampler. The interpreter tells CompetingClocks which clocks to enable and
  disable; the sampler only answers "which clock fires next, and when."

The payoff of this shape: the static checker and the derivative estimators
attach to the IR — the *same* data structure the simulator runs. There is no
second model description to keep in sync.

Four decisions were taken as given when the layering was designed:

1. **Clock speeds are compiled away.** The GSMP literature gives each clock a
   state-dependent speed. Concourse instead expresses a speed change as a
   re-declaration of the clock's firing-time distribution (a left-truncated,
   rescaled law). The sampler never sees a speed. See
   [the declaration rule](event_loop.md#the-processor-sharing-compilation).
2. **No one-input-queue rule.** An earlier project (Quarton.jl) required
   every server to read exactly one queue, which priced out fork–join and
   multiserver jobs. The IR allows synchronization; the surface exposes it as
   `fork!`/`join!`.
3. **Record, then analyze.** The primary observable of a run is the record:
   the ordered sequence of (clock key, firing time, auxiliary draws). Every
   queueing statistic is a fold over that record. No statistics accumulate
   inside tokens or queues.
4. **Full-featured target.** Time-varying hazards, static model checking, and
   derivative estimation are goals, not extensions.

## Layer 1: the surface language

Six constructors build a network. Each adds an entry to a `QueueNetwork`
value and has no other effect.

| Constructor | Meaning |
|---|---|
| `source!` | jobs enter here (interarrival law, mark sampler) |
| `station!` | jobs are served here (discipline, servers, service law, capacity) |
| `sink!` | jobs leave here |
| `fork!` | one job becomes siblings |
| `join!` | siblings merge when all have arrived |
| `route!` | where departures from a station go |

A *law* maps the parameter vector ``\theta`` and the enabling time to a
probability distribution. Because the law receives the wall-clock time,
time-varying hazards (a nonhomogeneous arrival process, a shift schedule)
need no extra machinery. A *mark* is a named value attached to a job at
creation — its size or its class. Disciplines and routing kernels read marks.

### A discipline is four functions

A service discipline is not a queue subtype. It is a value with four small
pure functions, and the buffer is always the same ordered vector:

- `insert` — where an arriving job is filed in the buffer,
- `select` — which waiting job a free server admits,
- `preempt` — which job in service, if any, is evicted,
- `memory` — what an evicted clock remembers: `:fresh` (start over),
  `:resume` (keep the accrued age), or `:replay` (repeat the identical draw).

First-come-first-served (FCFS), last-come-first-served (LCFS), random order
(SIRO), priority with and without preemption, and shortest remaining
processing time (SRPT) are all instances of this one struct. Processor
sharing has no buffer — every job is in service — and is handled by the
compilation described in [The event loop](event_loop.md).

### Routing kernels

A routing kernel is a function from (job, state) to a destination station,
attached to the *origin* station. `Always`, `Probabilistic`, `ByMark`,
`JoinShortestQueue`, `LeastWorkLeft`, and `RoundRobin` cover the standard
policies. Stateful kernels declare their state (round robin's cursor lives
in the IR state), so record replay reproduces them.

## Layer 2: the intermediate representation

Compilation turns the surface value into a `QueueGSMP`: a vector of compiled
stations plus a name table. The dynamic state, `QueueState`, is places: a
buffer vector and an in-service vector per station, the job table, pending
join groups, routing cursors — and, per the A1 amendment, the per-clock
enabling times and banked ages (see [The model contract](model_contract.md)).

A clock key is one concrete tuple, `(family, station, jobid)`. The initial
families are `:arrival` (a source's next-arrival clock) and `:service` (one
clock per job in service). The family set is open — reneging added
`:patience` — which is the A2 amendment.

The entire dynamic semantics is three functions:

- `fire` — what a firing means. An arrival creates a job, draws its marks,
  and routes it. A service completion removes the job from service and
  routes it. `fire` is pure: it maps a state to a new state.
- `deposit!` — what arriving at a station means. Sinks remove the job. Forks
  create siblings. Joins hold siblings until all parts are present. Ordinary
  stations file the job into the buffer, or drop or block it when the buffer
  is full.
- `settle!` — normalization after a change. First preemption: may the best
  waiting job evict a job in service? Then dispatch: fill free servers in
  discipline order.

Every surface feature lands in one identifiable branch of these functions.
A service law becomes the distribution of a `:service` clock. A discipline's
`insert` and `select` become the filing position and the dispatch step of
`settle!`. A routing kernel becomes the destination argument of `deposit!`.
Within one firing, consequences cascade in a fixed, deterministic order —
the cascade worklist of [The event loop](event_loop.md#d2-the-cascade-worklist).

### Randomness accounting

A GSMP puts all randomness in clocks. Queueing adds two draws that are not
clocks: job marks (a size drawn at arrival) and random routing (a weighted
coin flip). The rule, made strict by amendment A4, is:

> Every random draw is either a clock, a recorded mark with a density, or a
> recorded choice with a probability mass. Nothing else may touch a random
> number generator.

The record therefore stores auxiliary draws next to the firings that
consumed them. Replay never draws again; it reads the recorded values back.
That is what keeps replay exact, and it is what lets the likelihood — and
the score estimator built on it — account for every source of randomness.

### The record and measurement

The primary output of a run is the marked record: one entry per firing,
holding the clock key, the firing time, and the auxiliary draws consumed.
Because `fire` is pure and deterministic given the recorded draws, the state
at any index is a fold over the record. Waiting times, response times,
number in system, utilization, and passage times are all folds. Streaming
observers are possible for long runs, but they are an execution-policy
choice, not a modeling concept — the same fold, run early.

### Model checking

Because the IR is data, checks are total functions of it, not lint
heuristics over user callbacks:

- **C1 structure** — every routing target exists; stations reach a sink;
  forks and joins match.
- **C2 mark typing** — a law may only read marks that every source reaching
  it produces (a dataflow check over the routing graph).
- **C3 capacity** — blocking chains must be acyclic; a cycle of full
  blocking buffers is deadlock, detected statically.
- **C4 stability** — solve the traffic equations, estimate utilization, warn
  at saturation.
- **C5 oracle detection** — networks satisfying the BCMP conditions get a
  product-form stationary distribution emitted as a test oracle; small
  all-exponential networks get an exact answer by state enumeration. This is
  how the test suite gets closed-form answers for free.
- **C6 randomness census** — list every mark and routing draw with its
  ``\theta``-dependence, and report which derivative estimators are valid.

These checks run on `test/test_checks.jl`.

## Layer 3: CompetingClocks

The interpreter speaks only the `SamplingContext` surface: `enable!`,
`disable!`, `reenable!`, `next`, `fire!`. The mapping is direct: a clock
appearing in the enabled set is an `enable!`; a clock leaving it is a
`disable!`; `:resume` memory is an `enable!` with a left-shifted enabling
time; a processor-sharing speed change is a `reenable!` with a truncated,
rescaled law. Reproducibility comes from keyed random streams derived from
one master seed. Sampler choice belongs to CompetingClocks' builder — no
sampler is load-bearing (decision D4 in [The event loop](event_loop.md)).

Non-exponential and time-varying laws are first-class throughout. That is
the reason CompetingClocks exists, so supporting them costs the surface
language nothing.

## What later notes changed

Amendments in `notes/model_definition.tex` and decisions in
`notes/event_loop.tex` supersede this note on four points:

1. **Clock bookkeeping moved into the state** (A1). This note left per-clock
   enabling times and ages in the sampler. That broke `fire`'s purity for
   age-reading disciplines and made replay ambiguous for time-varying laws.
2. **"Two clock families suffice" was refuted** (A2). Reneging is a third
   family; breakdowns would be a fourth. The family set became a registry.
3. **Function-valued fields became combinator values** (A3), so the IR is
   actually inspectable data, not closures.
4. **The enabled-set diff was replaced by clock deltas** (D1). A diff is
   blind to re-declarations, which processor sharing requires. The diff
   survives as a debug oracle.

Concourse also dropped the planned dependency on ChronoSim.jl. Every seam
this note borrowed from ChronoSim exists in CompetingClocks.jl and
ClockGradients.jl, and Concourse became the second independent
implementation of the ClockGradients model contract — the test that the
contract is an abstraction, not a description of its only client.
