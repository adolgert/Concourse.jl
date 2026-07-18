# PkgBenchmark-style suite: a local regression tool, not wired into CI —
# shared-runner timings are noise. See benchmark/README.md for how to run.
using BenchmarkTools
using Concourse
using ClockGradients

# testmodels.jl supplies mm1 and friends, already compiled. The compile
# group needs uncompiled nets, and forkjoin2 lives in test/test_forkjoin.jl
# whose testsets would execute on include, so both nets are built here.
include(joinpath(@__DIR__, "..", "test", "testmodels.jl"))

function mm1net()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :counter; discipline = FCFS(), servers = 1,
             service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    net
end

# forkjoin2 from test/test_forkjoin.jl, minus the compile.
function forkjoin2net()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    fork!(net, :split; branches = (:disk_a, :disk_b))
    station!(net, :disk_a; service = Law(:Exponential, scale = inv(Param(:mu))))
    station!(net, :disk_b; service = Law(:Exponential, scale = inv(Param(:mu))))
    join!(net, :merge; parts = 2)
    sink!(net, :done)
    route!(net, :arrive, Always(:split))
    route!(net, :disk_a, Always(:merge))
    route!(net, :disk_b, Always(:merge))
    route!(net, :merge, Always(:done))
    net
end

const θ = [1.0, 2.0]
const HORIZON = 1000.0

SUITE = BenchmarkGroup()

SUITE["compile"] = BenchmarkGroup()
SUITE["compile"]["mm1"] = @benchmarkable compile(net) setup = (net = mm1net())
SUITE["compile"]["forkjoin"] = @benchmarkable compile(net) setup = (net = forkjoin2net())

SUITE["simulate"] = BenchmarkGroup()
SUITE["simulate"]["mm1"] =
    @benchmarkable simulate(m, θ, HORIZON; seed = 42) setup = (m = mm1())

SUITE["replay"] = BenchmarkGroup()
SUITE["replay"]["mm1"] = @benchmarkable replay(m, rec) setup = begin
    m = mm1()
    rec = simulate(m, θ, HORIZON; seed = 42)
end

SUITE["gradients"] = BenchmarkGroup()
SUITE["gradients"]["score_mm1"] = @benchmarkable begin
    grec = ClockGradients.gradient_record(rm, rec, θ)
    ClockGradients.score_gradient(rm, θ, grec)
end setup = begin
    m = mm1()
    rec = simulate(m, θ, HORIZON; seed = 42)
    rm = replay_model(m, rec)
end
