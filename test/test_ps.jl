# F8: processor sharing compiles to truncate-and-rescale re-evaluations with
# te fixed at the original enabling (the contract's segment convention).
# The oracles: M/M/1-PS shares the M/M/1 mean, and M/G/1-PS is INSENSITIVE —
# L = ρ/(1-ρ) for any service law with the same mean, which a wrong banked
# age, anchor, or speed breaks immediately.

import ClockGradients
using Distributions

function mm1_ps()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :cpu; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

# Gamma(2, 0.5/μ) has mean 1/μ: same load as mm1_ps, CV² = 1/2 ≠ 1.
function mg1_ps()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :cpu; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Gamma, shape = Const(2.0), scale = Const(0.5) * inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

wanted("the two anchor parameterizations declare the same conditional law") &&
@testset "the two anchor parameterizations declare the same conditional law" begin
    # The declaration rule (event_loop.tex §6): a clock's specification is
    # the pair (F, te) through its conditional law, so the anchored-at-now
    # compilation of queue_layers.tex §3.5 and the fixed-anchor form the
    # state records must agree pointwise as laws of the firing time. The
    # at-now side is built from Distributions' own truncated/affine algebra
    # so the two sides share no implementation.
    for F in (Exponential(0.7), Gamma(2.0, 0.5), Weibull(1.3, 0.8)),
        (a, r) in ((0.4, 0.5), (1.1, 2.0), (0.0, 1 / 3))
        te = 1.0; tstar = 3.2
        fixed = Concourse.SharedRemaining(F, a, r, tstar - te)
        atnow = a == 0.0 ? F * (1 / r) : (truncated(F; lower = a) - a) * (1 / r)
        for s in (tstar + 0.05, tstar + 0.7, tstar + 3.0)
            @test logccdf(fixed, s - te) ≈ logccdf(atnow, s - tstar) atol = 1e-12
            @test logpdf(fixed, s - te) ≈ logpdf(atnow, s - tstar) atol = 1e-12
        end
    end
end

wanted("f8 mm1-ps mean number in system matches rho/(1-rho)") &&
@testset "f8 mm1-ps mean number in system matches rho/(1-rho)" begin
    m = mm1_ps()
    est, se = replicate(r -> time_average(number_in_system, m, r),
                        m, [1.0, 2.0], 2000.0, 16)
    @test within4se(est, se, 1.0)
end

wanted("f8 insensitivity: gamma service leaves the ps mean unchanged") &&
@testset "f8 insensitivity: gamma service leaves the ps mean unchanged" begin
    m = mg1_ps()
    est, se = replicate(r -> time_average(number_in_system, m, r),
                        m, [1.0, 2.0], 2000.0, 16)
    @test within4se(est, se, 1.0)
    # The same law under FCFS is a genuine M/G/1 whose Pollaczek-Khinchine
    # mean differs (CV² = 1/2): L = ρ + ρ²(1+CV²)/(2(1-ρ)) = 0.875. If PS
    # and FCFS agreed here, the discipline would not actually be sharing.
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :cpu; service = Law(:Gamma, shape = Const(2.0),
                                      scale = Const(0.5) * inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu)); route!(net, :cpu, Always(:done))
    mf = compile(net)
    estf, sef = replicate(r -> time_average(number_in_system, mf, r),
                          mf, [1.0, 2.0], 2000.0, 16)
    @test within4se(estf, sef, 0.875)
end

wanted("f8 replay reproduces ps banking and anchors exactly") &&
@testset "f8 replay reproduces ps banking and anchors exactly" begin
    m = mg1_ps()
    rec, live = simulate(m, [1.0, 2.0], 500.0; seed = 23,
                         keep_states = true, debug = true)
    folded = replay(m, rec)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    @test any(!isempty(st.anchor) for st in live)
    @test any(any(v > 0 for v in values(st.bank)) for st in live)
end

wanted("f8 resident-count changes emit reenable deltas for every survivor") &&
@testset "f8 resident-count changes emit reenable deltas for every survivor" begin
    m = mg1_ps()
    rec = simulate(m, [1.5, 2.0], 200.0; seed = 29)
    cpu = m.names[:cpu]
    st = Concourse.initial_state(m)
    saw = 0
    for i in eachindex(rec.key)
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
        old = st
        st, deltas = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        survivors = [j for j in st.srv[cpu] if j in old.srv[cpu]]
        if length(old.srv[cpu]) != length(st.srv[cpu]) && !isempty(survivors)
            expected = Set((:reenable, (:service, Int32(cpu), j)) for j in survivors)
            @test issubset(expected, Set(deltas))
            saw += 1
        end
    end
    @test saw > 10
end

wanted("f8 score gradient matches finite differences under ps segments") &&
@testset "f8 score gradient matches finite differences under ps segments" begin
    m = mm1_ps()
    θ = [1.0, 2.0]
    H = 50.0
    R = 400
    fs = zeros(R); S = zeros(2, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 500 + r)
        rm = replay_model(m, rec)
        grec = ClockGradients.gradient_record(rm, rec, θ)
        fs[r] = rec.horizon * time_average(number_in_system, m, rec)
        S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
    end
    for j in 1:2
        @test abs(mean(S[j, :])) / (std(S[j, :]) / sqrt(R)) < 4
    end
    fbar = mean(fs)
    est = [mean((fs .- fbar) .* S[j, :]) for j in 1:2]
    se = [std((fs .- fbar) .* S[j, :]) / sqrt(R) for j in 1:2]
    intN(rec) = rec.horizon * time_average(number_in_system, m, rec)
    δ = 0.05
    for j in 1:2
        θp = copy(θ); θp[j] += δ
        θm2 = copy(θ); θm2[j] -= δ
        diffs = [(intN(simulate(m, θp, H; seed = 500 + r)) -
                  intN(simulate(m, θm2, H; seed = 500 + r))) / (2δ) for r in 1:R]
        fdest, fdse = mean(diffs), std(diffs) / sqrt(R)
        @test abs(est[j] - fdest) <= 4 * sqrt(se[j]^2 + fdse^2)
    end
end
