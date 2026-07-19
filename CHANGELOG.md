# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

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
