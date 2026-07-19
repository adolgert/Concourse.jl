# Closed networks (capability 4): populate! seeds a fixed population whose
# initial mark draws are the record's "firing 0" (init) slot. Oracles are the
# exact product-form occupancies (Buzen's convolution) and the classical
# machine-repairman birth-death form; conservation, replay through the init
# draws, mixed open+closed census, a score gradient, and check C10 cover the
# rest of the plan's test list.

using ClockGradients: ClockGradients

# Time-average occupancy of one named station (waiting + in service + held).
function closed_occ(m, name::Symbol)
    q = m.names[name]
    return st -> length(st.buf[q]) + length(st.srv[q]) + length(st.hold[q])
end

# Buzen's convolution over relative utilizations ρ (visit ratio × mean
# service time, load-independent single-server stations): G[n + 1] holds
# G(n), built by the recursion g_m(n) = g_{m-1}(n) + ρ_m g_m(n - 1), which
# the ascending in-place update realizes. Scale-invariant in ρ, because the
# occupancy formula uses only the ratios G(N - k)/G(N) against ρ^k.
function buzen_G(ρ::Vector{Float64}, N::Int)
    G = zeros(N + 1)
    G[1] = 1.0
    for r in ρ
        for n in 1:N
            G[n + 1] += r * G[n]
        end
    end
    return G
end

# Mean occupancy of single-server station i under population N:
# L_i = Σ_{k=1}^N ρ_i^k G(N-k)/G(N).
buzen_mean(ρ, i, N, G) = sum(ρ[i]^k * G[N - k + 1] / G[N + 1] for k in 1:N)

# N machines that fail (delay station :up, servers = N, exponential rate ν)
# and queue for a single repairman (:repair, FCFS, rate μ).
function machine_repairman(N)
    net = QueueNetwork(; param_names=(:nu, :mu))
    station!(net, :up; servers=N, service=Law(:Exponential; scale=inv(Param(:nu))))
    station!(net, :repair; servers=1, service=Law(:Exponential; scale=inv(Param(:mu))))
    route!(net, :up, Always(:repair))
    route!(net, :repair, Always(:up))
    populate!(net, :up, N)
    return compile(net)
end

# Two populate! calls with Dirac mark laws — a two-class population whose
# service speed at :a reads the class mark (SITA-style speed by class). The
# init draws are the only randomness besides the service clocks.
function multiclass_cycle()
    net = QueueNetwork(; param_names=(:mu1, :mu2))
    station!(net, :a; service=Law(:Exponential; scale=Mark(:speed) * inv(Param(:mu1))))
    station!(net, :b; service=Law(:Exponential; scale=inv(Param(:mu2))))
    route!(net, :a, Always(:b))
    route!(net, :b, Always(:a))
    populate!(net, :a, 2; mark=MarkLaw(; speed=Law(:Dirac; value=Const(0.5))))
    populate!(net, :b, 2; mark=MarkLaw(; speed=Law(:Dirac; value=Const(2.0))))
    return compile(net)
end

# Sources and a population coexist: an M/M/1 that starts with 3 jobs already
# at the counter.
function mixed_mm1_populated()
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :counter; service=Law(:Exponential; scale=inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    populate!(net, :counter, 3)
    return compile(net)
end

wanted("closed cycle occupancies match buzen's convolution") &&
    @testset "closed cycle occupancies match buzen's convolution" begin
        N = 4
        θ = [1.0, 1.5]                      # μ1 ≠ μ2
        m = closed_cycle(N)
        ρ = [1 / θ[1], 1 / θ[2]]            # visit ratios are both 1
        G = buzen_G(ρ, N)
        La = buzen_mean(ρ, 1, N, G)
        # Self-check the convolution against the direct two-station sum
        # π(n_a) ∝ ρ_a^{n_a} ρ_b^{N - n_a}.
        w = [ρ[1]^n * ρ[2]^(N - n) for n in 0:N]
        @test La ≈ sum((0:N) .* w) / sum(w)
        R = nreps(24)
        ea, sa = replicate(rec -> time_average(closed_occ(m, :a), m, rec), m, θ, 400.0, R)
        eb, sb = replicate(rec -> time_average(closed_occ(m, :b), m, rec), m, θ, 400.0, R)
        @test within4se(ea, sa, La)
        @test within4se(eb, sb, N - La)
        # The population is closed: the two means account for every job.
        @test ea + eb ≈ N
    end

wanted("closed machine-repairman availability matches the birth-death form") &&
    @testset "closed machine-repairman availability matches the birth-death form" begin
        N = 4
        θ = [0.5, 2.0]                      # failure rate ν, repair rate μ
        m = machine_repairman(N)
        # Finite birth-death on k = number in repair: π_k ∝ N!/(N-k)! (ν/μ)^k.
        r = θ[1] / θ[2]
        πk = [factorial(N) / factorial(N - k) * r^k for k in 0:N]
        πk ./= sum(πk)
        avail = sum((N - k) * πk[k + 1] for k in 0:N) / N
        R = nreps(24)
        est, se = replicate(rec -> time_average(closed_occ(m, :up), m, rec) / N, m, θ, 400.0, R)
        @test within4se(est, se, avail)
    end

wanted("closed multiclass populate conserves per-class populations") &&
    @testset "closed multiclass populate conserves per-class populations" begin
        m = multiclass_cycle()
        θ = [1.0, 1.5]
        rec = simulate(m, θ, 200.0; seed=21, debug=true)
        @test length(rec) > 0
        # The init slot holds exactly the four initial mark draws, in
        # declaration order: class 0.5 twice, then class 2.0 twice.
        @test rec.init == [:speed => 0.5, :speed => 0.5, :speed => 2.0, :speed => 2.0]
        want_marks = [0.5, 0.5, 2.0, 2.0]
        conserved(st) =
            length(st.jobs) == 4 &&
            sort([Float64(marks.speed) for marks in values(st.jobs)]) == want_marks
        # Fold the record and check conservation at every state: no source,
        # no sink, so both the census and the multiset of class marks are
        # invariants of the whole run.
        st = initial_state(m, Concourse.replaydraws(Concourse.INIT_KEY, rec.init, m.params))
        @test conserved(st)
        ok = true
        for i in eachindex(rec.key)
            ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
            st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
            ok &= conserved(st)
        end
        @test ok
    end

wanted("closed replay equality includes the init draws") &&
    @testset "closed replay equality includes the init draws" begin
        cases = [
            (closed_cycle(4), [1.0, 1.5]),
            (machine_repairman(4), [0.5, 2.0]),
            (multiclass_cycle(), [1.0, 1.5]),
        ]
        for (m, θ) in cases
            rec, live = simulate(m, θ, 100.0; seed=31, debug=true, keep_states=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
        end
        # A truncated init list errors loudly (draw-conduit discipline): the
        # replay seed asks for the fourth initial mark and the record has 3.
        m = multiclass_cycle()
        rec = simulate(m, [1.0, 1.5], 50.0; seed=32, debug=true)
        @test length(rec.init) == 4
        short = MarkedRecord(rec.key, rec.time, rec.draws, rec.init[1:3], rec.horizon)
        @test_throws "replay of (:init, 0, 0) asked for draw speed beyond the record" replay(
            m, short
        )
    end

wanted("closed plus open: census accounting at every state") &&
    @testset "closed plus open: census accounting at every state" begin
        m = mixed_mm1_populated()
        θ = [1.0, 2.0]
        N = 3
        rec, live = simulate(m, θ, 200.0; seed=41, debug=true, keep_states=true)
        # Fold the record: arrivals counted from the fired keys, departures
        # from job ids vanishing into the sink. The census must be exactly
        # N + arrivals − departures at every recorded state.
        st = initial_state(m)
        @test number_in_system(st) == N
        arrivals = 0
        departures = 0
        alive = Set(keys(st.jobs))
        ok = true
        for i in eachindex(rec.key)
            ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
            st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
            rec.key[i][1] == :arrival && (arrivals += 1)
            now = Set(keys(st.jobs))
            departures += length(setdiff(alive, now))
            alive = now
            ok &= number_in_system(st) == N + arrivals - departures
        end
        @test ok
        @test arrivals > 0 && departures > 0   # both flows actually ran
        # And the mixed record replays exactly, init slot included.
        folded = replay(m, rec)
        @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    end

# Score gradient of ∫ occupancy(:a) dt over the closed cycle w.r.t. both
# service rates, against common-random-number central differences — the
# test_gradients.jl pattern with the population seeded through rec.init.
intA_closed(m, rec) = rec.horizon * time_average(closed_occ(m, :a), m, rec)

function fd_gradient_closed(m, θ, H, R; δ=0.05, seed0=100)
    D = length(θ)
    est = zeros(D)
    se = zeros(D)
    for j in 1:D
        θp = copy(θ)
        θp[j] += δ
        θmi = copy(θ)
        θmi[j] -= δ
        diffs = [
            (
                intA_closed(m, simulate(m, θp, H; seed=seed0 + r)) -
                intA_closed(m, simulate(m, θmi, H; seed=seed0 + r))
            ) / (2δ) for r in 1:R
        ]
        est[j] = mean(diffs)
        se[j] = std(diffs) / sqrt(R)
    end
    return est, se
end

wanted("closed cycle score gradient matches finite differences") &&
    @testset "closed cycle score gradient matches finite differences" begin
        m = closed_cycle(4)                 # draw-free population
        θ = [1.0, 1.5]
        H = 50.0
        R = nreps(400)
        fs = zeros(R)
        S = zeros(2, R)
        for r in 1:R
            rec = simulate(m, θ, H; seed=100 + r)
            rm = replay_model(m, rec)
            grec = ClockGradients.gradient_record(rm, rec, θ)
            fs[r] = intA_closed(m, rec)
            S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
        end
        # The E[score] = 0 drift alarm must stay quiet or the likelihood is
        # wrong — here that includes the t = 0 clocks the population enables.
        for j in 1:2
            @test abs(mean(S[j, :])) / (std(S[j, :]) / sqrt(R)) < 4
        end
        fbar = mean(fs)
        est = [mean((fs .- fbar) .* S[j, :]) for j in 1:2]
        se = [std((fs .- fbar) .* S[j, :]) / sqrt(R) for j in 1:2]
        fdest, fdse = fd_gradient_closed(m, θ, H, R)
        for j in 1:2
            @test abs(est[j] - fdest[j]) <= 4 * sqrt(se[j]^2 + fdse[j]^2)
        end
    end

wanted("closed network checks: c10, populate errors, stability silence") &&
    @testset "closed network checks: c10, populate errors, stability silence" begin
        # C10: the population must fit servers + capacity.
        net = QueueNetwork(; param_names=(:mu1,))
        station!(net, :a; service=Law(:Exponential; scale=inv(Param(:mu1))), servers=1, capacity=2)
        route!(net, :a, Always(:a))
        populate!(net, :a, 4)
        @test_throws "populate! places 4 jobs at a, which holds at most servers + capacity = 3 jobs (check C10)" compile(
            net
        )
        # Zero sources and zero populate! is still an error.
        net2 = QueueNetwork(; param_names=(:mu1,))
        station!(net2, :a; service=Law(:Exponential; scale=inv(Param(:mu1))))
        route!(net2, :a, Always(:a))
        @test_throws "the network has no source and no populate! entry, so it can never contain a job" compile(
            net2
        )
        # populate! argument validation.
        net3 = QueueNetwork(; param_names=(:mu,))
        @test_throws "populate! needs count >= 1, got 0" populate!(net3, :a, 0)
        @test_throws "populate! targets unknown station nowhere" populate!(net3, :nowhere, 1)
        net4 = QueueNetwork(; param_names=(:lambda,))
        source!(net4, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        @test_throws "populate! targets arrive, which is a source; only a service station can hold an initial population" populate!(
            net4, :arrive, 1
        )
        # Zero-arg initial_state works for a draw-free population and errors
        # for a draw-bearing one, pointing at the record's init slot.
        @test number_in_system(initial_state(closed_cycle(2))) == 2
        @test_throws "initial_state(m) has no draw source to draw the population's initial marks; seed from a record's init draws instead: initial_state(m, replaydraws((:init, Int32(0), Int64(0)), rec.init, m.params))" initial_state(
            multiclass_cycle()
        )
        # C4 for a sourceless network: nothing to report, and quietly so —
        # a closed network cannot be unstable.
        @test (@test_logs Concourse.stability(closed_cycle(4), [1.0, 1.5])) ==
            Tuple{Symbol,Float64}[]
    end
