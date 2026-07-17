# F10: no charter result depends on the sampler. The interpreter speaks only
# the blessed SamplingContext surface, so every method valid for the model's
# distributions must reproduce the oracles and the replay determinism.

wanted("f10 the mm1 oracle holds under every sampler method") &&
@testset "f10 the mm1 oracle holds under every sampler method" begin
    m = mm1()
    θ = [1.0, 2.0]
    for (i, method) in enumerate((FirstToFireMethod(), NextReactionMethod(),
                                  FirstReactionMethod()))
        vals = [time_average(number_in_system, m,
                             simulate(m, θ, 1000.0; seed = 10_000i + r,
                                      method, debug = true))
                for r in 1:12]
        est, se = mean(vals), std(vals) / sqrt(12)
        @test within4se(est, se, 1.0)
    end
end

wanted("f10 replay determinism is sampler independent") &&
@testset "f10 replay determinism is sampler independent" begin
    m = preemptive_priority()
    for method in (FirstToFireMethod(), NextReactionMethod())
        rec, live = simulate(m, [1.0, 1.5], 300.0; seed = 21, method,
                             keep_states = true, debug = true)
        folded = replay(m, rec)
        @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    end
end
