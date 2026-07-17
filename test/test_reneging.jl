# F2: reneging entered as a third clock family. The claim under test is both
# behavioral (M/M/1+M matches the Erlang-A birth-death closed form) and
# structural (the addition touched only the family registry and the surface
# constructor — enforced here by the derived-delta membership oracle running
# through every reneging cascade).

import ClockGradients

function mm1m()
    net = QueueNetwork(param_names = (:lambda, :mu, :gamma))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))),
             patience = Law(:Exponential, scale = inv(Param(:gamma))),
             renege_to = :lost)
    sink!(net, :done)
    sink!(net, :lost)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    compile(net)
end

# Erlang-A (M/M/1+M) stationary distribution: birth rate λ, death rate in
# state n of μ + (n-1)γ, so π_n ∝ Π_{k=1}^n λ/(μ + (k-1)γ).
function erlang_a(λ, μ, γ; N=400)
    w = ones(N + 1)
    for n in 1:N
        w[n+1] = w[n] * λ / (μ + (n - 1) * γ)
    end
    π = w ./ sum(w)
    L = sum(n * π[n+1] for n in 0:N)
    Lq = sum(max(n - 1, 0) * π[n+1] for n in 0:N)
    L, Lq
end

wanted("f2 mm1+m matches the erlang-a closed form") &&
@testset "f2 mm1+m matches the erlang-a closed form" begin
    m = mm1m()
    θ = [1.0, 1.0, 0.5]     # λ = μ: unstable without abandonment
    L, _ = erlang_a(θ...)
    est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, L)
end

wanted("f2 abandonment rate equals gamma times mean queue length") &&
@testset "f2 abandonment rate equals gamma times mean queue length" begin
    m = mm1m()
    θ = [1.0, 1.0, 0.5]
    _, Lq = erlang_a(θ...)
    renege_rate(rec) = count(k -> k[1] == :patience, rec.key) / rec.horizon
    est, se = replicate(renege_rate, m, θ, 2000.0, 16)
    @test est > 0            # reneging must actually occur
    @test within4se(est, se, θ[3] * Lq)
end

wanted("f2 score gradient survives a third clock family") &&
@testset "f2 score gradient survives a third clock family" begin
    m = mm1m()
    θ = [1.0, 1.0, 0.5]
    H = 50.0
    R = 400
    fs = zeros(R); S = zeros(3, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 300 + r)
        rm = replay_model(m, rec)
        grec = ClockGradients.gradient_record(rm, rec, θ)
        fs[r] = rec.horizon * time_average(number_in_system, m, rec)
        S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
    end
    for j in 1:3
        @test abs(mean(S[j, :])) / (std(S[j, :]) / sqrt(R)) < 4
    end
    fbar = mean(fs)
    # More waiting jobs abandon at larger γ, so ∂γ E[∫N dt] must come out
    # negative and match finite differences.
    j = 3
    est = mean((fs .- fbar) .* S[j, :])
    se = std((fs .- fbar) .* S[j, :]) / sqrt(R)
    δ = 0.05
    θp = copy(θ); θp[j] += δ
    θm2 = copy(θ); θm2[j] -= δ
    intN(rec) = rec.horizon * time_average(number_in_system, m, rec)
    diffs = [(intN(simulate(m, θp, H; seed = 300 + r)) -
              intN(simulate(m, θm2, H; seed = 300 + r))) / (2δ) for r in 1:R]
    fdest, fdse = mean(diffs), std(diffs) / sqrt(R)
    @test fdest < 0
    @test abs(est - fdest) <= 4 * sqrt(se^2 + fdse^2)
end

wanted("f2 replay reproduces reneging trajectories exactly") &&
@testset "f2 replay reproduces reneging trajectories exactly" begin
    m = mm1m()
    rec, live = simulate(m, [1.0, 1.0, 0.5], 500.0; seed = 17,
                         keep_states = true, debug = true)
    folded = replay(m, rec)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    @test any(k -> k[1] == :patience, rec.key)
end
