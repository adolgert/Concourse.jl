# Benchmarks

A local regression tool: run before and after a change to compare. Not
wired into CI, where shared-runner timings are noise.

Set up the benchmark environment once (same one-develop-call pattern as
`.github/workflows/docs.yml` — every unregistered package must land in a
single `Pkg.develop` call, here by local path from the repo root):

```julia
julia --project=benchmark -e '
  using Pkg
  Pkg.develop([
      PackageSpec(path = joinpath(homedir(), "dev", "CompetingClocks.jl")),
      PackageSpec(path = joinpath(homedir(), "dev", "ClockGradients.jl")),
      PackageSpec(path = pwd()),
  ])
  Pkg.instantiate()'
```

(Substitute URLs, `url = "https://github.com/adolgert/..."`, if you have no
local checkouts.) Then run the suite:

```julia
julia --project=benchmark -e '
  include("benchmark/benchmarks.jl")
  using BenchmarkTools
  display(run(SUITE; verbose = true))'
```

Groups: `compile` (surface → GSMP for M/M/1 and fork-join), `simulate`
(M/M/1 to a fixed horizon, fixed seed), `replay` (fold a recorded
trajectory), `gradients` (one score-estimator pass over a record).
