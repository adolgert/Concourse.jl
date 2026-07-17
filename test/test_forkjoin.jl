# F7's last model: fork-join, clock-free by construction (the split and the
# synchronization are deposit! branches, not clock families). The oracle is
# the Flatto-Hahn exact mean response for k = 2 exponential branches,
# E[T] = (12 - ρ)/8 · 1/(μ - λ), measured through Little's law on the
# number of fork groups in system.

function forkjoin2()
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
    compile(net)
end

groups_in_system(st) = Float64(length(Set(values(st.group))))

wanted("f7 fork-join matches the flatto-hahn k=2 exact mean") &&
@testset "f7 fork-join matches the flatto-hahn k=2 exact mean" begin
    m = forkjoin2()
    θ = [1.0, 2.0]
    ρ = θ[1] / θ[2]
    exact = θ[1] * (12 - ρ) / 8 / (θ[2] - θ[1])   # λ·E[T] by Little
    est, se = replicate(r -> time_average(groups_in_system, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, exact)
end

wanted("a join never holds a complete group between firings") &&
@testset "a join never holds a complete group between firings" begin
    m = forkjoin2()
    _, states = simulate(m, [1.0, 2.0], 500.0; seed = 31, keep_states = true,
                         debug = true)
    merge = m.names[:merge]
    @test all(all(length(v) < 2 for v in values(st.pending[merge])) for st in states)
    # Sibling bookkeeping is total: every alive sibling knows its group.
    @test all(all(haskey(st.group, j) for j in keys(st.jobs)) for st in states)
end

wanted("f4 replay reproduces fork-join trajectories exactly") &&
@testset "f4 replay reproduces fork-join trajectories exactly" begin
    m = forkjoin2()
    rec, live = simulate(m, [1.0, 2.0], 500.0; seed = 37, keep_states = true)
    folded = replay(m, rec)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
end
