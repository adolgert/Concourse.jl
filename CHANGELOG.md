# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Mark redraw on deposit: `station!(...; remark = (name = Law(...), ...))`
  declares laws (a `NamedTuple` or a `MarkLaw`) drawn when a job is
  deposited into the station from outside — filing into the buffer, or
  turning back blocked — and merged over the job's marks (same names
  replace, new names extend), before the discipline or the service law
  reads them. Every remark law is evaluated against the job's pre-redraw
  marks, then the drawn values merge, so laws reading each other's names
  swap. Re-files within the station (a preempted job's return, an
  unblocked transfer's admission) redraw nothing. Remark draws flow
  through the depositing firing's draw source, land in the record like
  any mark draw, and replay exactly.
- Compile check C11: remark laws obey source-mark-law scope — no station
  state. The mark census turns placement-aware for remark marks: a
  remark-only mark is readable at the remark station and downstream of
  it, never upstream, and a remark law reads only marks on the job
  before the redraw. `branch_world` refuses θ-reading remark laws
  exactly as it refuses θ-reading source mark laws.
- Remark tests: the two-hop tandem whose hops match their own M/M/1
  occupancies (a mark leaking across hops would land on the wrong
  moments), the pre-redraw swap convention with the draws visible in the
  record, replay equality with loud truncation of a remark draw, the
  once-per-deposit count under blocking and unblocking, the branching
  refusal, and the C11/census messages verbatim.
- Docs: a "Redrawing marks en route" section on the marks tutorial page,
  the `station!` remark keyword, an estimator-validity note (remark
  draws are ordinary recorded mark draws — no new row), and the README
  branching limitation extended to remark laws.

- Cyclic blocking: `compile(net; allow_blocking_cycles = true)` skips the
  blocking-cycle check (C3) and lets `:block` cycles run; the default is
  byte-for-byte unchanged. When a cycle of full buffers actually wedges —
  every station on the cycle full and holding a finished job routed to the
  next — the simulation raises `BlockingDeadlock`, a typed exported
  exception carrying the cycle's station names in routing order, the wall
  time, the held job ids, and the partial record (throwing firing
  included, horizon set to the deadlock time). A deadlock is a state
  property, so `replay` of the record reproduces the trajectory and
  re-raises the identical error at the same firing. The settle cascade's
  fuel-bound backstop message now points at `allow_blocking_cycles` and
  `BlockingDeadlock`. Deadlock *resolution* (simultaneous exchange)
  remains unsupported.
- F9 (cascade worklist-order independence) re-examined under cyclic
  blocking and holding: FIFO and LIFO worklists either both reach the
  horizon with identical records or both raise the identical
  `BlockingDeadlock`, because `FCFSUnblock` admits the longest-blocked
  transfer from a per-destination queue regardless of cascade order.
- Cyclic-blocking tests: the two-station wedge with the exact error and
  replay determinism, a non-deadlocking loop against an exact transient
  CTMC oracle (which also bounds the wedging probability, showing the
  non-deadlocking regime is structural, not just light load), FIFO/LIFO
  agreement under two-sided blocking including wedging trials, the C3
  default-rejection regression, a three-station cycle through a
  `Probabilistic` kernel, and flag inertness on acyclic nets.
- A "Cycles" section on the blocking tutorial page (what deadlock means
  under blocking-after-service, the flag, the replayable error, why
  resolution is out of scope); `BlockingDeadlock` on the interpreter
  reference page; README Limitations updated.

- Closed networks: `populate!(net, station, count; mark)` seeds a fixed
  population at a service station before time zero. Jobs are filed into
  the buffer in declaration order and dispatched by one settle cascade
  at t = 0, honoring disciplines and capacities; enabled clocks get
  enabling time 0 through the ordinary enable loop. Multiple calls
  compose (multiclass populations), a network with a population needs no
  source — sourceless networks become legal — and sources and
  populations may coexist. `stability` returns an empty report for a
  sourceless network: a closed network cannot be unstable.
- The record's "firing 0" slot: `MarkedRecord.init` holds the draws that
  seeding consumed — initial marks in declaration order, plus any t = 0
  dispatch draw — keyed by the reserved pseudo-clock `(:init, 0, 0)`.
  `replay` and `time_average` seed the initial state from `rec.init`, a
  truncated init list errors loudly, and the zero-argument
  `initial_state` still serves draw-free populations while pointing
  draw-bearing ones at the record. `replay_model` binds `rec.init`, so
  the score estimator covers populated models; `live_model` and
  `branch_world` fail loudly on drawn initial marks, and a θ-reading
  initial mark law is refused under branching exactly as a source's.
- Compile check C10: a populated station's counts must fit within
  `servers + capacity`; a network with neither a source nor a
  `populate!` entry is still refused.
- Closed-network tests: the two-station cycle against Buzen's
  convolution, machine-repairman availability against the birth–death
  form, multiclass per-class conservation, replay equality through the
  init draws with the truncated-init failure, mixed open + closed census
  accounting, a score gradient against finite differences, and the C10
  and populate! messages verbatim.
- Manual page on closed networks (`populate!`, the firing-0 record slot,
  the Buzen/MVA validation pattern, machine-repairman, branching and
  gradient restrictions); a firing-0 section on the record/replay page;
  the networks tutorial's closed-population section now builds an
  interactive-users model instead of calling closed populations
  inexpressible.

- Sibling cancellation: `join!(net, name; parts, need, cancel)` races a
  fork's siblings as (n, k) redundancy. Under `cancel = :on_completion`
  the `need`-th sibling to reach the join merges the group and cancels
  the rest wherever they sit — buffered, in service, or held blocked —
  freeing servers and waiting-room slots for the dispatch cascade. Under
  `cancel = :on_start` the `need`-th sibling to *enter service* cancels
  still-buffered siblings only; in-service survivors run to completion
  and are silently absorbed at the join, visible in the record. Nested
  forks cancel recursively, and a nested join's merged job inherits its
  fork parent's group so races compose. Cancellation is deterministic
  given the state — nothing new is recorded and replay equality holds.
- Compile checks C7–C9 for race coherence: `need < parts` requires a
  cancellation policy (C7, at `join!`), a fork's siblings reach at most
  one canceling join (C8), and stations on tracked branches receive
  sibling traffic only, `renege_to` edges included (C9).
- Cancellation tests: the Joshi (n, 1) Pollaczek–Khinchine oracle for
  shifted-exponential and hyperexponential service with the server-cost
  identity E[C] = n·E[X₍₁:ₙ₎], the exponential (3, 1) pair of oracles —
  `:on_completion` is M/M/1 at the pooled rate while `:on_start` is
  exactly M/M/n, with a separation test — (4, 2) census conservation,
  blocked-sibling cancellation with cascade refills, nested-fork
  recursion and no-residue sweeps, replay/debug membership, and C7–C9
  messages verbatim.
- Manual: a "Racing and cancellation" section on the fork–join tutorial
  page with both cancellation policies and the worked Joshi (n, 1)
  oracle; the estimator-validity table gains a sibling-cancellation row
  (score valid, IPA only for identity-insensitive statistics, SPA the
  road for latency derivatives), with a matching caveat in the gradient
  manual and the README.

- Batch service: `station!(...; batching = Batching(min, max))` gathers
  waiting jobs into a synthetic batch job served by one clock. The batch
  carries the mark `batchsize`, frozen at enabling, so existing
  mark-reading service laws set the batch's processing time; on
  completion the members route individually on their own marks and
  draws. `Batching()` defaults to the gather-everything rule (Inoue's
  dynamic batching); `min = max = K` is classical fixed-size batch
  service.
- Compile check C6: batching requires the non-preemptive `:back`-insert
  FCFS discipline; the `batchsize` mark is visible only to the batch
  station's own service law.
- Batch-service semantics decisions: members keep patience clocks while
  a batch forms (reneging before formation), batch jobs never get
  patience clocks, and a member that meets a full `:block` destination
  is dropped like a source arrival — after the batch fires, no server
  is left to hold it. `number_in_system` counts members, not batch
  bookkeeping jobs. Batch composition is deterministic given state, so
  nothing new is recorded and replay equality holds.
- Batch-service tests: degenerate `min = max = 1` record equality with
  the plain FCFS station, M/M^[K]/1 and Inoue (2021) gather-all oracles,
  reneging and blocking interactions, replay/debug membership, and C6
  messages.
- Manual page on batch service with Inoue's gather-everything model as
  the worked illustration; the estimator-validity table gains a
  batch-service row (score valid, IPA not guaranteed).
- State-dependent service laws: the expression atoms `InService(station)`
  and `InBuffer(station)` let a station's service law read live occupancy
  as `Float64` counts.
- `reads_state`, the census of which stations' occupancy an expression or
  law watches; `compile` builds its re-evaluation dependency map from it.
- Compile check C5, confining occupancy reads to the service laws of
  stations (mark, interarrival, and patience laws, routing kernels, and
  discipline ordering keys are refused).
- General mid-flight re-evaluation with age carryover: when a watched
  count changes, surviving service clocks bank their accrued effort,
  re-anchor at the change, keep `te`, and redraw from the fresh law
  conditioned on the banked effort. Processor sharing now rides this
  general path as a special case.
- `CONCOURSE_TEST_QUICK=1` environment variable, shrinking test
  replication counts for fast local iteration.
- Manual page on state-dependent service laws with the estimator-validity
  table, and amendment A5 in `notes/model_definition.tex`.
- MIT license, test CI, Aqua/JET quality tests, CompatHelper/TagBot
  workflows, JuliaFormatter config, and a local benchmark suite.

## [0.1.0]

Initial development release.

### Added

- Surface language for queueing networks: sources, stations, sinks,
  forks/joins, routing kernels, service disciplines (FCFS, SIRO, priority,
  processor sharing, SRPT), marks, patience/reneging, capacity and
  blocking.
- Compilation of a network to a generalized semi-Markov process (GSMP)
  simulated with CompetingClocks.jl.
- Simulation with records, deterministic replay, and trajectory splitting.
- Gradient estimation of simulation outputs through ClockGradients.jl,
  including branching-world estimators.
- Diátaxis documentation site: queueing tutorial, research manual, API
  reference, and developer design notes.
