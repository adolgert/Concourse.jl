# F6 (cascade totality) and F9 (cascade confluence): with contention resolved
# by UnblockPolicy, the settle cascade must terminate and reach the same fixed
# point under FIFO and LIFO worklist orders.

import Random

# A seeded family of acyclic layered networks with finite :block buffers:
# random capacities and rates, probabilistic branching, every path ends in the
# sink, so C3 holds by construction.
function random_blocking_network(rng)
    nmid = rand(rng, 2:4)
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    mids = [Symbol("mid", i) for i in 1:nmid]
    for (i, name) in enumerate(mids)
        station!(net, name;
                 service = Law(:Exponential, scale = Const(rand(rng, 0.4:0.1:1.5))),
                 servers = rand(rng, 1:2),
                 capacity = rand(rng, 1:3), overflow = :block)
    end
    station!(net, :last; service = Law(:Exponential, scale = inv(Param(:mu))),
             capacity = rand(rng, 1:2), overflow = :block)
    sink!(net, :done)
    if nmid == 2
        route!(net, :arrive, Probabilistic(mids[1] => 0.5, mids[2] => 0.5))
    else
        route!(net, :arrive, Probabilistic((m => 1 / nmid for m in mids)...))
    end
    # A layered chain: each middle station feeds the next, the last feeds :last.
    for i in 1:nmid-1
        route!(net, mids[i], Always(mids[i+1]))
    end
    route!(net, mids[end], Always(:last))
    route!(net, :last, Always(:done))
    compile(net)
end

wanted("f6 blocking cascades settle without exhausting fuel") &&
@testset "f6 blocking cascades settle without exhausting fuel" begin
    # A saturated tandem forces transfer blocking constantly; completing the
    # run at all is the termination assertion (fuel errors otherwise), and
    # debug mode holds the membership oracle through every cascade.
    m = blocking_tandem(cap = 1)
    rec = simulate(m, [2.0, 3.0, 0.7], 500.0; seed = 3, debug = true)
    @test length(rec) > 100
    # Blocking must actually occur for this test to bite.
    _, states = simulate(m, [2.0, 3.0, 0.7], 500.0; seed = 3, keep_states = true)
    @test any(!isempty(st.hold[m.names[:first]]) for st in states)
end

wanted("f9 fifo and lifo worklists reach identical fixed points") &&
@testset "f9 fifo and lifo worklists reach identical fixed points" begin
    for trial in 1:20
        rng = Random.Xoshiro(9000 + trial)
        m = random_blocking_network(rng)
        θ = [2.0, 1.0]
        ra, sa = simulate(m, θ, 200.0; seed = trial, worklist = :fifo,
                          keep_states = true, debug = true)
        rb, sb = simulate(m, θ, 200.0; seed = trial, worklist = :lifo,
                          keep_states = true, debug = true)
        @test ra.key == rb.key && ra.time == rb.time && ra.draws == rb.draws
        @test all(states_equal(a, b) for (a, b) in zip(sa, sb))
    end
end

wanted("blocked jobs are conserved not dropped") &&
@testset "blocked jobs are conserved not dropped" begin
    # Under :block with an infinite first buffer no job is ever lost: every
    # arrival either is in the system or fired a service at the last station.
    m = blocking_tandem(cap = 1)
    rec, states = simulate(m, [2.0, 3.0, 0.7], 300.0; seed = 5, keep_states = true)
    arrivals = count(k -> k[1] == :arrival, rec.key)
    last = m.names[:second]
    completions = count(k -> k[1] == :service && k[2] == last, rec.key)
    @test arrivals - completions == number_in_system(states[end])
end
