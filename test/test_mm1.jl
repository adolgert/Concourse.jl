wanted("mm1 time-average number in system matches rho/(1-rho)") &&
@testset "mm1 time-average number in system matches rho/(1-rho)" begin
    m = mm1()
    θ = [1.0, 2.0]                       # ρ = 0.5, L = 1, utilization = 0.5
    est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, 1.0)
    @test se < 0.1
end

wanted("mm1 utilization matches rho") &&
@testset "mm1 utilization matches rho" begin
    m = mm1()
    θ = [1.0, 2.0]
    busy(st) = isempty(st.srv[2]) ? 0.0 : 1.0
    est, se = replicate(r -> time_average(busy, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, 0.5)
end

wanted("mm1k finite waiting room drops and matches truncated geometric") &&
@testset "mm1k finite waiting room drops and matches truncated geometric" begin
    # capacity = 2 waiting + 1 in service is M/M/1/K with K = 3:
    # L = Σ n πₙ with πₙ ∝ ρⁿ truncated at K.
    m = mm1(capacity = 2)
    θ = [1.0, 2.0]
    ρ = 0.5; K = 3
    πs = [ρ^n for n in 0:K]; πs ./= sum(πs)
    exact = sum(n * πs[n+1] for n in 0:K)
    est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, exact)
end
