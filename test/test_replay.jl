# F4: fire is deterministic given the record — the fold reproduces the live
# trajectory exactly, including the clock bookkeeping (te, bank), on models
# that exercise marks, recorded routing draws, and preemption banking.

wanted("f4 replay fold reproduces live states exactly on mm1") &&
@testset "f4 replay fold reproduces live states exactly on mm1" begin
    m = mm1()
    rec, live = simulate(m, [1.0, 2.0], 500.0; seed = 7, keep_states = true)
    folded = replay(m, rec)
    @test length(folded) == length(live)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
end

wanted("f4 replay reproduces recorded mark and routing draws") &&
@testset "f4 replay reproduces recorded mark and routing draws" begin
    for m in (sita_split(), bernoulli_split())
        θ = [1.0, 2.0, 2.0][1:length(m.params)]
        rec, live = simulate(m, θ, 500.0; seed = 11, keep_states = true)
        folded = replay(m, rec)
        @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    end
end

wanted("f4 replay reproduces preemption banking under resume memory") &&
@testset "f4 replay reproduces preemption banking under resume memory" begin
    m = preemptive_priority()
    rec, live = simulate(m, [1.0, 1.5], 500.0; seed = 13, keep_states = true)
    folded = replay(m, rec)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    # The run must actually exercise eviction for this test to mean anything.
    @test any(!isempty(st.bank) for st in live)
end
