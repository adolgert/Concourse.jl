# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

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
