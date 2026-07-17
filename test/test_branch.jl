# The branchable world: ClockGradients' protocol certification plus the
# clone-based estimators against common-random-number finite differences.
# Draw-free models only, by the factory's own refusal.

import ClockGradients
using ClockGradients: IntegratedOccupancy

function branch_mm1()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    compile(net)
end

function branch_ps()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :cpu; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

# Terminal number in system at the horizon, by simulation: the state after
# the last firing is constant to T.
function terminal_N(m, θ, T, seed)
    rec = simulate(m, θ, T; seed)
    isempty(rec.key) ? 0.0 : Float64(number_in_system(replay(m, rec)[end]))
end

function fd_terminal(m, θ, T, R; δ=0.1, seed0=7000)
    est = zeros(length(θ)); se = zeros(length(θ))
    for j in eachindex(θ)
        θp = copy(θ); θp[j] += δ
        θm2 = copy(θ); θm2[j] -= δ
        diffs = [(terminal_N(m, θp, T, seed0 + r) - terminal_N(m, θm2, T, seed0 + r)) / (2δ)
                 for r in 1:R]
        est[j] = mean(diffs); se[j] = std(diffs) / sqrt(R)
    end
    est, se
end

wanted("branchable certification holds for mm1 and ps worlds") &&
@testset "branchable certification holds for mm1 and ps worlds" begin
    for (m, θ) in ((branch_mm1(), [1.0, 2.0]), (branch_ps(), [1.5, 2.0]))
        rep = ClockGradients.check_branchable(() -> branch_world(m, θ; seed = 42), θ;
                                              nsteps = 20, seed = 0xBEEF)
        for d in rep.diagnostics
            @info "check_branchable" d
        end
        @test rep.pass
    end
end

wanted("the world factory refuses models with auxiliary draws") &&
@testset "the world factory refuses models with auxiliary draws" begin
    @test_throws ArgumentError branch_world(bernoulli_split(), [1.0, 2.0]; seed = 1)
    @test_throws ArgumentError branch_world(sita_split(), [1.0, 2.0, 2.0]; seed = 1)
end

wanted("branching gradient matches finite differences on mm1 terminal count") &&
@testset "branching gradient matches finite differences on mm1 terminal count" begin
    m = branch_mm1()
    θ = [1.0, 2.0]
    T = 5.0
    res = ClockGradients.branching_gradient(() -> branch_world(m, θ; seed = 71), θ,
                                            st -> Float64(number_in_system(st));
                                            nreps = 1200, horizon = T,
                                            seed = 11, branch_rng_seed = 12)
    fdest, fdse = fd_terminal(m, θ, T, 6000)
    for j in 1:2
        @test abs(res.estimate[j] - fdest[j]) <=
              4 * sqrt(res.stderr[j]^2 + fdse[j]^2)
    end
end

wanted("branching gradient matches finite differences on ps terminal count") &&
@testset "branching gradient matches finite differences on ps terminal count" begin
    # The capability table's open cell: clone-based estimation over a world
    # whose clocks are re-declared mid-flight. The world re-enables through
    # the same apply_deltas! path as the interpreter, so if re-declaration
    # broke the branch coupling this comparison would drift.
    m = branch_ps()
    θ = [1.5, 2.0]
    T = 5.0
    res = ClockGradients.branching_gradient(() -> branch_world(m, θ; seed = 73), θ,
                                            st -> Float64(number_in_system(st));
                                            nreps = 1200, horizon = T,
                                            seed = 13, branch_rng_seed = 14)
    fdest, fdse = fd_terminal(m, θ, T, 6000; seed0 = 9000)
    for j in 1:2
        @test abs(res.estimate[j] - fdest[j]) <=
              4 * sqrt(res.stderr[j]^2 + fdse[j]^2)
    end
end

wanted("spa gradient matches finite differences on mm1 occupancy") &&
@testset "spa gradient matches finite differences on mm1 occupancy" begin
    m = branch_mm1()
    θ = [1.0, 2.0]
    T = 5.0
    res = ClockGradients.spa_gradient(() -> branch_world(m, θ; seed = 77),
                                      live_model(m), θ,
                                      IntegratedOccupancy(number_in_system);
                                      nreps = 800, horizon = T, seed = 15)
    intN(seed) = begin
        rec = simulate(m, θ, T; seed)
        rec.horizon * time_average(number_in_system, m, rec)
    end
    δ = 0.1
    for j in 1:2
        θp = copy(θ); θp[j] += δ
        θm2 = copy(θ); θm2[j] -= δ
        diffs = [(begin
                      rp = simulate(m, θp, T; seed = 7000 + r)
                      rm2 = simulate(m, θm2, T; seed = 7000 + r)
                      (rp.horizon * time_average(number_in_system, m, rp) -
                       rm2.horizon * time_average(number_in_system, m, rm2)) / (2δ)
                  end) for r in 1:4000]
        fdest, fdse = mean(diffs), std(diffs) / sqrt(length(diffs))
        @test abs(res.estimate[j] - fdest) <= 4 * sqrt(res.stderr[j]^2 + fdse^2)
    end
end
