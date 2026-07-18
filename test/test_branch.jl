# The branchable world: ClockGradients' protocol certification plus the
# clone-based estimators against common-random-number finite differences.
# Q1: auxiliary draws run from the world's own keyed streams — copied with
# clones, re-seeded with rekeys, and keyed by stable identity so same-seed
# clones agree on corresponding jobs' draws. θ-dependent marks stay refused.

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

wanted("the world factory accepts theta-free draws and refuses theta-dependent marks") &&
@testset "the world factory accepts theta-free draws and refuses theta-dependent marks" begin
    # The Q1 boundary: marks, probabilistic routing, and SIRO are admitted
    # (their draws are θ-free), while a mark law that reads θ would add its
    # own derivative term to every estimator and stays refused.
    @test branch_world(bernoulli_split(), [1.0, 2.0]; seed = 1) isa ConcourseWorld
    @test branch_world(sita_split(), [1.0, 2.0, 2.0]; seed = 1) isa ConcourseWorld
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = Law(:Exponential, scale = inv(Param(:mu)))))
    station!(net, :cpu; service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu)); route!(net, :cpu, Always(:done))
    @test_throws ArgumentError branch_world(compile(net), [1.0, 2.0]; seed = 1)
end

# Advance a world n commits (or until quiet). Returns the committed keys and
# every job's marks observed along the way — jobs are deleted at the sink, so
# the marks must be collected while each job is in the system.
function _advance!(w, n)
    ks = Concourse.ClockKey[]
    seen = Dict{Concourse.JobId,NamedTuple}()
    for _ in 1:n
        pk = ClockGradients.branch_peek(w)
        pk === nothing && break
        ClockGradients.branch_commit!(w, pk[2], pk[1])
        push!(ks, pk[2])
        merge!(seen, w.state.jobs)
    end
    ks, seen
end

wanted("a coupled clone of a marked world reproduces firings and marks exactly") &&
@testset "a coupled clone of a marked world reproduces firings and marks exactly" begin
    # The Q1 copying obligation: the clone's auxiliary generators carry their
    # STATES, so with no rekey the clone's future — including every size it
    # draws for jobs not yet born — is the original's, firing for firing.
    m = sita_split()
    w = branch_world(m, [1.2, 2.0, 2.0]; seed = 5)
    _advance!(w, 6)
    c = ClockGradients.branch_clone(w)
    kw, jw = _advance!(w, 20)
    kc, jc = _advance!(c, 20)
    @test kw == kc
    @test states_equal(w.state, c.state)
    @test jw == jc
end

wanted("rekeying a clone decouples its future marks from the original") &&
@testset "rekeying a clone decouples its future marks from the original" begin
    # The Q1 re-seeding obligation: clock streams alone are not enough — a
    # clone rekeyed to a new seed must also draw fresh sizes, or its jobs
    # would replay the original's.
    m = sita_split()
    w = branch_world(m, [1.2, 2.0, 2.0]; seed = 5)
    _advance!(w, 6)
    c = ClockGradients.branch_clone(w)
    ClockGradients.branch_rekey!(c, 0xDECAF)
    born = Set(keys(w.state.jobs))
    _, jw = _advance!(w, 30)
    _, jc = _advance!(c, 30)
    fresh = [j for j in keys(jw) if !(j in born) && haskey(jc, j)]
    @test !isempty(fresh)
    @test any(jw[j] != jc[j] for j in fresh)
end

wanted("same-seed clones agree on corresponding jobs' marks after divergence") &&
@testset "same-seed clones agree on corresponding jobs' marks after divergence" begin
    # The Q1 alignment obligation, the hardest of the three: after a forced
    # firing the two clones disagree about event ORDER, but a mark stream is
    # keyed by the source's clock and consumed once per arrival, so the k-th
    # arrival of clone A still matches the k-th arrival of clone B.
    m = sita_split()
    w = branch_world(m, [1.2, 2.0, 2.0]; seed = 5)
    # Advance until the coming decision has a runner-up to force.
    for _ in 1:50
        length(ClockGradients.branch_enabled_ages(w)) >= 2 && break
        _advance!(w, 1)
    end
    a = ClockGradients.branch_clone(w)
    b = ClockGradients.branch_clone(w)
    ClockGradients.branch_rekey!(a, 0xA11CE)
    ClockGradients.branch_rekey!(b, 0xA11CE)
    pk = ClockGradients.branch_peek(a)
    @test pk !== nothing
    (tstar, winner) = pk
    other = [k for (k, _) in ClockGradients.branch_enabled_ages(b) if k != winner]
    @test !isempty(other)   # divergence needs a runner-up to force
    ClockGradients.branch_commit!(a, winner, tstar)
    ClockGradients.branch_force!(b, first(other), tstar)
    ka, ja = _advance!(a, 40)
    kb, jb = _advance!(b, 40)
    @test ka != kb          # the orders genuinely diverged
    common = intersect(Set(keys(ja)), Set(keys(jb)))
    @test length(common) > 5
    @test all(ja[j] == jb[j] for j in common)
end

wanted("branching gradient matches finite differences on the bernoulli split") &&
@testset "branching gradient matches finite differences on the bernoulli split" begin
    # End-to-end over the routing-draw path: every arrival consumes a live
    # recorded-purpose uniform from the world's streams.
    m = bernoulli_split()
    θ = [1.5, 2.0]
    T = 5.0
    res = ClockGradients.branching_gradient(() -> branch_world(m, θ; seed = 81), θ,
                                            st -> Float64(number_in_system(st));
                                            nreps = 1200, horizon = T,
                                            seed = 17, branch_rng_seed = 18)
    fdest, fdse = fd_terminal(m, θ, T, 6000; seed0 = 11000)
    for j in 1:2
        @test abs(res.estimate[j] - fdest[j]) <=
              4 * sqrt(res.stderr[j]^2 + fdse[j]^2)
    end
end

wanted("branching gradient matches finite differences on the sita split") &&
@testset "branching gradient matches finite differences on the sita split" begin
    # End-to-end over the mark path: sizes drawn live at each arrival decide
    # the ByMark route, so a mis-keyed or mis-copied stream would bias this.
    m = sita_split()
    θ = [1.2, 2.0, 2.0]
    T = 5.0
    res = ClockGradients.branching_gradient(() -> branch_world(m, θ; seed = 83), θ,
                                            st -> Float64(number_in_system(st));
                                            nreps = 1200, horizon = T,
                                            seed = 19, branch_rng_seed = 20)
    fdest, fdse = fd_terminal(m, θ, T, 6000; seed0 = 13000)
    for j in 1:3
        @test abs(res.estimate[j] - fdest[j]) <=
              4 * sqrt(res.stderr[j]^2 + fdse[j]^2)
    end
end

wanted("branchable certification holds for marked worlds") &&
@testset "branchable certification holds for marked worlds" begin
    for (m, θ) in ((sita_split(), [1.2, 2.0, 2.0]), (bernoulli_split(), [1.5, 2.0]))
        rep = ClockGradients.check_branchable(() -> branch_world(m, θ; seed = 44), θ;
                                              nsteps = 20, seed = 0xFACE)
        for d in rep.diagnostics
            @info "check_branchable" d
        end
        @test rep.pass
    end
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
