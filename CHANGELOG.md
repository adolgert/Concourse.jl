# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

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
