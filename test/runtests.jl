# Phase-1 tests implement the falsification charter of
# notes/model_definition.tex §7 and notes/event_loop.tex §7: each testset
# names the claim it can refute. Oracles use the 4-standard-error convention.
# Filter by substring: julia --project=. test/runtests.jl mm1
# CONCOURSE_TEST_QUICK=1 shrinks replication counts (see nreps in testmodels.jl).
using Test
using Statistics
using Concourse

include("testmodels.jl")

const FILTER = isempty(ARGS) ? "" : lowercase(ARGS[1])
wanted(name) = isempty(FILTER) || occursin(FILTER, lowercase(name))

for file in [
    "test_mm1.jl",
    "test_replay.jl",
    "test_splits.jl",
    "test_blocking.jl",
    "test_blocking_cycles.jl",
    "test_checks.jl",
    "test_samplers.jl",
    "test_reneging.jl",
    "test_ps.jl",
    "test_forkjoin.jl",
    "test_srpt.jl",
    "test_gradients.jl",
    "test_branch.jl",
    "test_bcmp.jl",
    "test_statedep.jl",
    "test_batch.jl",
    "test_cancel.jl",
    "test_closed.jl",
    "test_quality.jl",
]
    path = joinpath(@__DIR__, file)
    isfile(path) && include(path)
end
