# The static checks are total functions of the network value (possible
# because A3 made every law inspectable). Each test names the check.

wanted("c1 compile rejects broken structure") &&
@testset "c1 compile rejects broken structure" begin
    net = QueueNetwork(param_names = (:mu,))
    station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
    route!(net, :a, Always(:nowhere))
    @test_throws ArgumentError compile(net)

    net2 = QueueNetwork(param_names = (:mu,))
    station!(net2, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
    @test_throws ArgumentError compile(net2)   # no route

    net3 = QueueNetwork(param_names = (:mu,))
    station!(net3, :a; service = Law(:Exponential, scale = inv(Param(:bogus))))
    sink!(net3, :done)
    route!(net3, :a, Always(:done))
    @test_throws ArgumentError compile(net3)   # unknown parameter
end

wanted("c2 a law may not read marks no source produces") &&
@testset "c2 a law may not read marks no source produces" begin
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :a; service = Law(:Exponential, scale = Mark(:size) * inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:a))
    route!(net, :a, Always(:done))
    @test_throws ArgumentError compile(net)
end

wanted("deterministic kernels may read only marks") &&
@testset "deterministic kernels may read only marks" begin
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = Law(:Exponential, scale = Const(1.0))))
    station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
    station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, ByMark(Param(:mu) * Mark(:size), [1.0], [:a, :b]))
    route!(net, :a, Always(:done)); route!(net, :b, Always(:done))
    @test_throws ArgumentError compile(net)
end

wanted("c3 a cycle of full block buffers is rejected as deadlock") &&
@testset "c3 a cycle of full block buffers is rejected as deadlock" begin
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))),
             capacity = 1, overflow = :block)
    station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu))),
             capacity = 1, overflow = :block)
    sink!(net, :done)
    route!(net, :arrive, Always(:a))
    route!(net, :a, Probabilistic(:b => 0.5, :done => 0.5))
    route!(net, :b, Probabilistic(:a => 0.5, :done => 0.5))
    @test_throws ArgumentError compile(net)
    # The same loop with :drop overflow cannot deadlock and must compile.
    net2 = QueueNetwork(param_names = (:lambda, :mu))
    source!(net2, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net2, :a; service = Law(:Exponential, scale = inv(Param(:mu))),
             capacity = 1, overflow = :drop)
    station!(net2, :b; service = Law(:Exponential, scale = inv(Param(:mu))),
             capacity = 1, overflow = :drop)
    sink!(net2, :done)
    route!(net2, :arrive, Always(:a))
    route!(net2, :a, Probabilistic(:b => 0.5, :done => 0.5))
    route!(net2, :b, Probabilistic(:a => 0.5, :done => 0.5))
    @test compile(net2) isa QueueGSMP
end

wanted("c4 stability reports rho and flags saturation") &&
@testset "c4 stability reports rho and flags saturation" begin
    m = mm1()
    ρs = Concourse.stability(m, [1.0, 2.0])
    @test ρs == [(:counter, 0.5)]
    @test (@test_logs (:warn,) match_mode=:any Concourse.stability(m, [3.0, 2.0])) ==
          [(:counter, 1.5)]
end
