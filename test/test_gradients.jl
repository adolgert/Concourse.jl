# F5 (CD-1 sufficiency): score and IPA on a nonhomogeneous-arrival M(t)/M/1,
# through the patched ClockGradients and the gradient_record seam, against
# common-random-number finite differences. The arrival law reads Enab(), so a
# wrong enabling-time anchor anywhere in the chain shows up as bias here.

import ClockGradients
using ClockGradients: IntegratedOccupancy

function mt_mm1()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential,
        scale = inv(Param(:lambda) *
                    (Const(1.0) + Const(0.5) * exp(Const(-0.02) * Enab())))))
    station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    compile(net)
end

# ∫N dt over [0, H]: the functional both estimators differentiate.
intN(m, rec) = rec.horizon * time_average(number_in_system, m, rec)

function fd_gradient(m, θ, H, R; δ=0.05, seed0=100)
    D = length(θ)
    est = zeros(D); se = zeros(D)
    for j in 1:D
        θp = copy(θ); θp[j] += δ
        θmi = copy(θ); θmi[j] -= δ
        diffs = [(intN(m, simulate(m, θp, H; seed = seed0 + r)) -
                  intN(m, simulate(m, θmi, H; seed = seed0 + r))) / (2δ)
                 for r in 1:R]
        est[j] = mean(diffs); se[j] = std(diffs) / sqrt(R)
    end
    est, se
end

wanted("f5 score gradient matches finite differences on mt-mm1") &&
@testset "f5 score gradient matches finite differences on mt-mm1" begin
    m = mt_mm1()
    θ = [1.0, 2.0]
    H = 50.0
    R = 400
    @test reads_time(m.stations[m.names[:arrive]].service)   # Enab() is live
    fs = zeros(R); S = zeros(2, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 100 + r)
        rm = replay_model(m, rec)
        grec = ClockGradients.gradient_record(rm, rec, θ)
        fs[r] = intN(m, rec)
        S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
    end
    # The E[score] = 0 drift alarm must stay quiet or the likelihood is wrong.
    for j in 1:2
        @test abs(mean(S[j, :])) / (std(S[j, :]) / sqrt(R)) < 4
    end
    fbar = mean(fs)
    est = [mean((fs .- fbar) .* S[j, :]) for j in 1:2]
    se = [std((fs .- fbar) .* S[j, :]) / sqrt(R) for j in 1:2]
    fdest, fdse = fd_gradient(m, θ, H, R)
    for j in 1:2
        @test abs(est[j] - fdest[j]) <= 4 * sqrt(se[j]^2 + fdse[j]^2)
    end
end

wanted("f5 ipa gradient matches finite differences on mt-mm1") &&
@testset "f5 ipa gradient matches finite differences on mt-mm1" begin
    m = mt_mm1()
    θ = [1.0, 2.0]
    H = 50.0
    R = 400
    fn = IntegratedOccupancy(number_in_system)
    G = zeros(2, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 100 + r)
        rm = replay_model(m, rec)
        grec = ClockGradients.gradient_record(rm, rec, θ)
        G[:, r] = ClockGradients.ipa_gradient(rm, θ, grec, fn)
    end
    est = [mean(G[j, :]) for j in 1:2]
    se = [std(G[j, :]) / sqrt(R) for j in 1:2]
    fdest, fdse = fd_gradient(m, θ, H, R)
    for j in 1:2
        @test abs(est[j] - fdest[j]) <= 4 * sqrt(se[j]^2 + fdse[j]^2)
    end
end
