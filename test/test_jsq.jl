# Deterministic state-reading routing (capability 8): ShortestQueue sends a
# departing job to the destination with the smallest occupancy, ties to the
# lowest station index, drawing and recording nothing — A4 admits it because
# a deterministic function of state bears no likelihood, and replay
# reproduces the decision from the folded state (I1, I4). Falsification
# tests: the tie-break and no-draw claims on a crafted deterministic trace,
# same-seed determinism and replay equality, the symmetric M/M/2 JSQ oracle
# against a truncated CTMC solved here (the blocking-cycle precedent), Dai's
# Proposition 3 two-server boundary under ShortestQueue(by = :tokens) with
# the CodeLlama staircase (helpers from test_rounds_papers.jl), the paired
# JSQ-beats-Bernoulli comparison, the equal-split stability approximation,
# the compile check messages verbatim, and the branch_world refusal.
# The jsq_pair builder lives in testmodels.jl. Filter with "jsq".

using LinearAlgebra

# Ties and no-draws, deterministically: Dirac arrivals every 1.0 into two
# never-finishing servers. The kernel lists :b FIRST, but :a was declared
# first (the lower station index), so the t = 1 tie goes to :a, t = 2 sees
# (1, 0) and picks :b strictly, t = 3 ties (1, 1) back to :a, t = 4 picks
# :b — destinations a, b, a, b regardless of listing order.
function jsq_tie_model()
    net = QueueNetwork(; param_names=())
    source!(net, :arrive; interarrival=Law(:Dirac; value=Const(1.0)))
    station!(net, :a; service=Law(:Dirac; value=Const(100.0)))
    station!(net, :b; service=Law(:Dirac; value=Const(100.0)))
    sink!(net, :done)
    route!(net, :arrive, ShortestQueue(:b, :a))
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    return compile(net)
end

# Dai Proposition 3 / Remark 4: K = 2 parallel LLM servers under JSQ, each a
# Sarathi(512) round station with the CodeLlama-34B staircase (dai_staircase
# from test_rounds_papers.jl), routed by remaining tokens. The K-server
# boundary is λ* = K·(b_max/t_{b_max})/(m_p + m_d).
function dai_jsq_model()
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(100.0)), v_d=Law(:Dirac; value=Const(100.0))),
    )
    for g in (:gpu1, :gpu2)
        station!(
            net,
            g;
            rounds=Rounds(;
                policy=Sarathi(; budget=512), duration=dai_staircase(), work=(:v_p, :v_d)
            ),
        )
        route!(net, g, Always(:done))
    end
    sink!(net, :done)
    route!(net, :arrive, ShortestQueue(:gpu1, :gpu2; by=:tokens))
    return compile(net)
end

# The symmetric M/M/2 JSQ chain, truncated at N jobs per queue: state (i, j),
# arrivals join the shorter queue (ties to :a, the lower index, matching the
# kernel), each nonempty queue serves at rate μ. An arrival that would push a
# queue past N is dropped — the truncation, whose transient mass the test
# bounds before trusting the oracle.
function jsq_generator(N, λ, μ)
    idx(i, j) = i * (N + 1) + j + 1
    n = (N + 1)^2
    Q = zeros(n, n)
    function add!(a, b, r)
        Q[a, b] += r
        return Q[a, a] -= r
    end
    for i in 0:N, j in 0:N
        s = idx(i, j)
        if i <= j
            i < N && add!(s, idx(i + 1, j), λ)
        else
            j < N && add!(s, idx(i, j + 1), λ)
        end
        i > 0 && add!(s, idx(i - 1, j), μ)
        j > 0 && add!(s, idx(i, j - 1), μ)
    end
    return Q
end

# Mean sojourn read off the record: a job's sojourn runs from the firing
# that created it to the firing that removed it from st.jobs (a sink
# deposit — these models drop and cancel nothing). Jobs still in flight at
# the horizon are censored identically across the paired models.
function jsq_mean_sojourn(m, rec)
    st = initial_state(m, Concourse.replaydraws(Concourse.INIT_KEY, rec.init, m.params))
    entered = Dict{Int64,Float64}(j => 0.0 for j in keys(st.jobs))
    total = 0.0
    n = 0
    for i in eachindex(rec.key)
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
        new, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        t = rec.time[i]
        for j in keys(new.jobs)
            haskey(entered, j) || (entered[j] = t)
        end
        for j in keys(st.jobs)
            haskey(new.jobs, j) && continue
            total += t - entered[j]
            n += 1
        end
        st = new
    end
    return total / n
end

wanted("jsq tie-break to the lowest station index, nothing drawn") &&
    @testset "jsq tie-break to the lowest station index, nothing drawn" begin
        m = jsq_tie_model()
        rec, live = simulate(m, Float64[], 4.5; seed=1, debug=true, keep_states=true)
        a, b = m.names[:a], m.names[:b]
        @test [k[1] for k in rec.key] == fill(:arrival, 4)
        # Destinations a, b, a, b: ties (t = 1 and t = 3) go to :a, the
        # lower station index, even though the kernel lists :b first.
        final = live[end]
        @test sort(vcat(final.srv[a], final.buf[a])) == [1, 3]
        @test sort(vcat(final.srv[b], final.buf[b])) == [2, 4]
        # No draw is recorded for a ShortestQueue decision: the record's
        # draw lists are empty (arrival times are clock draws, not
        # auxiliary draws, and this source has no marks).
        @test all(isempty, rec.draws)
        # I4: the fold reproduces the trajectory from the folded state.
        folded = replay(m, rec)
        @test length(folded) == length(live)
        @test all(states_equal(x, y) for (x, y) in zip(live, folded))
    end

wanted("jsq same seed gives identical records and exact replay") &&
    @testset "jsq same seed gives identical records and exact replay" begin
        m = jsq_pair()
        θ = [1.6, 1.0]
        r1 = simulate(m, θ, 300.0; seed=7, debug=true)
        r2 = simulate(m, θ, 300.0; seed=7, debug=true)
        @test r1.key == r2.key && r1.time == r2.time && r1.draws == r2.draws
        rec, live = simulate(m, θ, 300.0; seed=8, debug=true, keep_states=true)
        folded = replay(m, rec)
        @test length(folded) == length(live)
        @test all(states_equal(x, y) for (x, y) in zip(live, folded))
        # The routing genuinely uses both servers.
        a, b = m.names[:a], m.names[:b]
        @test any(!isempty(st.srv[a]) for st in live) && any(!isempty(st.srv[b]) for st in live)
    end

wanted("jsq symmetric m/m/2 matches the truncated ctmc oracle") &&
    @testset "jsq symmetric m/m/2 matches the truncated ctmc oracle" begin
        # The estimand is the expected time average of the number in system
        # over [0, T] from the empty start — exactly what the augmented
        # matrix exponential computes (bas_transient_average, the
        # blocking-cycle precedent). λ = μ = 1 puts each server at ρ = 0.5,
        # so the N = 25 truncation is far out in the tail; the boundary
        # mass bound certifies the truncation bias is negligible next to
        # the Monte Carlo SE.
        N, λ, μ, T = 25, 1.0, 1.0, 400.0
        Q = jsq_generator(N, λ, μ)
        p = exp(Q * T)[1, :]
        boundary = [i == N || j == N for i in 0:N for j in 0:N]
        @test sum(p[boundary]) < 1e-8
        g = [Float64(i + j) for i in 0:N for j in 0:N]
        exact = bas_transient_average(Q, g, T)
        m = jsq_pair()
        est, se = replicate(r -> time_average(number_in_system, m, r), m, [λ, μ], T, nreps(48))
        @test within4se(est, se, exact)
    end

wanted("jsq dai proposition 3 boundary separates 0.9x from 1.1x") &&
    @testset "jsq dai proposition 3 boundary separates 0.9x from 1.1x" begin
        # Two Sarathi(512) servers under ShortestQueue(by = :tokens):
        # λ* = 2·(512/153.16)/200 requests per ms (t_512 = 153.16 ms, the
        # CodeLlama staircase). Work-conserving JSQ is throughput-optimal
        # (Dai Prop 3), so 0.9λ* keeps total unprocessed tokens bounded
        # while 1.1λ* grows them linearly — the excess token arrival rate
        # 0.1·2·(512/153.16) ≈ 0.67 tokens/ms adds about 20k tokens over
        # the second half-horizon (slope test, helpers from
        # test_rounds_papers.jl).
        λstar = 2 * (512 / 153.16) / 200
        T = 60_000.0
        m = dai_jsq_model()
        rec = simulate(m, [0.9 * λstar], T; seed=3)
        ts, vs = paper_backlog(m, rec)
        stable_half, stable_end = backlog_at(ts, vs, T / 2), backlog_at(ts, vs, T)
        rec = simulate(m, [1.1 * λstar], T; seed=3)
        ts, vs = paper_backlog(m, rec)
        unstable_half, unstable_end = backlog_at(ts, vs, T / 2), backlog_at(ts, vs, T)
        # Bounded: the stable run's second half adds essentially nothing.
        @test stable_end < 30_000
        @test stable_end - stable_half < 8_000
        # Linear growth past the boundary.
        @test unstable_end - unstable_half > 10_000
        @test unstable_end > stable_end + 10_000
        # Both servers actually serve rounds under the token routing.
        for g in (:gpu1, :gpu2)
            @test count(k -> k[1] == :round && Int(k[2]) == m.names[g], rec.key) > 50
        end
    end

wanted("jsq beats the bernoulli split on mean sojourn") &&
    @testset "jsq beats the bernoulli split on mean sojourn" begin
        # Sanity, not a published number: at ρ = 0.8 per server, joining
        # the shorter queue beats the fair coin flip on mean sojourn,
        # paired seed by seed, beyond 4 SE of the paired differences. The
        # pairing shares the arrival stream (clock draws are keyed by the
        # arrival clock, untouched by the Bernoulli model's extra routing
        # draw); the horizon keeps the per-pair variance small enough for
        # the quick-mode replication count.
        mj = jsq_pair()
        mb = jsq_pair(; kernel=Probabilistic(:a => 0.5, :b => 0.5))
        θ = [1.6, 1.0]
        T = 3000.0
        R = nreps(24)
        d = [
            jsq_mean_sojourn(mj, simulate(mj, θ, T; seed=2000 + r)) -
            jsq_mean_sojourn(mb, simulate(mb, θ, T; seed=2000 + r)) for r in 1:R
        ]
        @test mean(d) + 4 * std(d) / sqrt(R) < 0
    end

wanted("jsq stability reports the equal-split approximation") &&
    @testset "jsq stability reports the equal-split approximation" begin
        # The documented approximation: ShortestQueue enters the traffic
        # equations as an equal split, so each of the two identical servers
        # reports ρ = λ/(2μ) — exact here by symmetry.
        rep = Dict(Concourse.stability(jsq_pair(), [1.2, 1.0]))
        @test rep[:a] ≈ 0.6 && rep[:b] ≈ 0.6
    end

wanted("jsq check messages verbatim") && @testset "jsq check messages verbatim" begin
    @test_throws "ShortestQueue needs at least two destinations" ShortestQueue(:a)
    @test_throws "ShortestQueue destinations must be distinct" ShortestQueue(:a, :a)
    @test_throws "ShortestQueue by must be :requests or :tokens, got sizes" ShortestQueue(
        :a, :b; by=:sizes
    )
    # by = :tokens needs round stations at every destination.
    @test_throws "ShortestQueue(by = :tokens) at arrive routes to a, which is not a round station; token occupancy is the remaining work only round stations count — use by = :requests, or make every destination a Rounds station" jsq_pair(
        kernel=ShortestQueue(:a, :b; by=:tokens)
    )
    # A destination with no occupancy to compare.
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :a; service=Law(:Exponential; scale=inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, ShortestQueue(:a, :done))
    route!(net, :a, Always(:done))
    @test_throws "ShortestQueue at arrive routes to done, which is a sink; a shortest-queue destination must be a service station — only stations have occupancy to compare" compile(
        net
    )
end

wanted("jsq branch_world refuses shortest-queue routing") &&
    @testset "jsq branch_world refuses shortest-queue routing" begin
        # The state-reading refusal precedent: pathwise branching is not
        # certified when event reordering flips a state-reading routing
        # decision; the score estimator over records stays valid because
        # the decision bears no likelihood.
        @test_throws "branchable worlds do not support ShortestQueue routing in v1; the route from arrive reads station occupancy" branch_world(
            jsq_pair(), [1.0, 2.0]; seed=1
        )
    end
