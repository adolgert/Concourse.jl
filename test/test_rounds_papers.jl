# Paper-reproduction tests for round-based token service (capability 6):
# the acceptance criterion is faithful reproduction of the two papers the
# capability was built for. Dai et al. (arXiv:2504.07347): the Fig. 8
# five-request worked example batch by batch for all four shipped policies,
# the Theorem 2 stability boundary, and the §6.2 vertex-C discriminator
# where only Sarathi-128 among five configurations is stable. Dai §5.4's
# Rybko–Stolyar network (with capability 7's per-hop remark redraws):
# destabilizing second-hop priorities diverge, reversed priorities are
# stable. Dong & Cao (arXiv:2604.11001): Algorithm 1's exact per-slot
# decoupling identity against the scalar recursion, the KV memory bound,
# and Algorithm 2's LIFO eviction with full recomputation. Replay equality
# and debug membership run on every model (I4). Model builders shared with
# the examples (dong_three_class, rybko_stolyar) live in testmodels.jl.

using Distributions: DiscreteUniform

# ---------------------------------------------------------------------------
# Builders local to the paper tests.

# CodeLlama-34B TP-1 batch time (Dai Eq. (4) and Fig. 6):
# t_b = 11.28 + 35.47·⌈b/128⌉ ms.
dai_staircase() = Law(:Dirac; value=Const(11.28) + Const(35.47) * ceil(Mark(:tokens) / 128))

# Dai Fig. 8: requests A, B, C are already decoding (prefill done) with
# decode lengths 2, 4, 3 when D and E — one prefill token, one decode token
# each — arrive during the first batch. A :feed relay delivers D at t = 0.25
# and E at t = 0.50, both inside round 1 (rounds last 1.0), so every policy
# sees exactly the paper's configuration at its second boundary.
function fig8_model(policy)
    net = QueueNetwork(; param_names=())
    station!(
        net,
        :gpu;
        rounds=Rounds(; policy, duration=Law(:Dirac; value=Const(1.0)), work=(:v_p, :v_d)),
    )
    station!(net, :feed; service=Law(:Dirac; value=Const(0.25)))
    sink!(net, :done)
    route!(net, :feed, Always(:gpu))
    route!(net, :gpu, Always(:done))
    for vd in (2.0, 4.0, 3.0)   # A, B, C in populate (= job id) order
        populate!(
            net,
            :gpu,
            1;
            mark=MarkLaw(; v_p=Law(:Dirac; value=Const(0.0)), v_d=Law(:Dirac; value=Const(vd))),
        )
    end
    populate!(                   # D (id 4), then E (id 5)
        net,
        :feed,
        2;
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(1.0)), v_d=Law(:Dirac; value=Const(1.0))),
    )
    return compile(net)
end

# Dai Theorem 2: Poisson arrivals of (v_p, v_d) = (100, 100) requests into
# Sarathi(512) under the CodeLlama staircase. The boundary is
# λ* = (b_max/t_{b_max})/(m_p + m_d) = (512/153.16)/200 requests per ms.
function dai_boundary_model()
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(100.0)), v_d=Law(:Dirac; value=Const(100.0))),
    )
    station!(
        net,
        :gpu;
        rounds=Rounds(; policy=Sarathi(; budget=512), duration=dai_staircase(), work=(:v_p, :v_d)),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Dai §6.2 vertex C: deterministic interarrival 467.5 ms, every request
# (290, 990) tokens, k_max = 100 — exactly (λ_p, λ_d) = (29/46.75, 99/46.75),
# the vertex C of Theorem 10 for b_0 = 128. Fully deterministic.
function vertexc_model(policy)
    net = QueueNetwork(; param_names=())
    source!(
        net,
        :arrive;
        interarrival=Law(:Dirac; value=Const(467.5)),
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(290.0)), v_d=Law(:Dirac; value=Const(990.0))),
    )
    station!(net, :gpu; rounds=Rounds(; policy, duration=dai_staircase(), work=(:v_p, :v_d)))
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Dong Algorithm 2 under overload: unknown-length flow control with a drawn
# activation budget B_t ~ DiscreteUniform(0, 6) (one draw per slot, through
# the round's draw source), KV capacity M, every request (l, o) = (10, 15).
# λ = 1 per slot overloads the cache so overflow, LIFO eviction with
# progress reset, and reactivation all happen repeatedly.
function flow_overload_model(; M=120)
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; l=Law(:Dirac; value=Const(10.0)), o=Law(:Dirac; value=Const(15.0))),
    )
    station!(
        net,
        :gpu;
        rounds=Rounds(;
            policy=FlowControl(DiscreteUniform(0, 6), M; prompt=:l),
            duration=Law(:Dirac; value=Const(1.0)),
            work=(:o,),
        ),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# ---------------------------------------------------------------------------
# Fold helpers: the long-horizon slope tests fold fire_changes over the
# record (the time_average pattern) instead of keeping every state.

# Call f(st, i) on the initial state (i = 0) and after each firing i.
function paper_fold(f, m, rec)
    st = initial_state(m, Concourse.replaydraws(Concourse.INIT_KEY, rec.init, m.params))
    f(st, 0)
    for i in eachindex(rec.key)
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
        st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        f(st, i)
    end
    return st
end

# Total unprocessed tokens: remaining work counters for jobs admitted at a
# round station, the full (v_p, v_d) profile for everyone else in flight.
function paper_tokens_left(st)
    tot = 0
    for (j, marks) in st.jobs
        w = get(st.work, j, nothing)
        tot += w === nothing ? Int(marks.v_p) + Int(marks.v_d) : sum(w)
    end
    return tot
end

# (times, tokens-left) sampled at every firing.
function paper_backlog(m, rec)
    vs = Int[]
    paper_fold((st, i) -> i > 0 && push!(vs, paper_tokens_left(st)), m, rec)
    return rec.time, vs
end

backlog_at(ts, vs, t) = isempty(ts) || t < ts[1] ? 0 : vs[searchsortedlast(ts, t)]
window_max(ts, vs, lo, hi) = maximum(vs[i] for i in eachindex(ts) if lo < ts[i] <= hi; init=0)

# The committed round plans of station g, in commit order. Chained rounds
# replace the roundplan slot with a fresh RoundPlan object at every commit
# (states share the object between commits), so object identity separates
# consecutive rounds even when their content coincides.
function committed_plans(m, rec, g)
    plans = RoundPlan[]
    paper_fold(m, rec) do st, _
        p = st.roundplan[g]
        p === nothing && return nothing
        (isempty(plans) || plans[end] !== p) && push!(plans, p)
        return nothing
    end
    return plans
end

wanted("dai fig. 8 batch compositions exact for all four policies") &&
    @testset "dai fig. 8 batch compositions exact for all four policies" begin
        # The unit test of the shipped policies: Fig. 8's five-request
        # configuration, batch by batch. The figure fixes only the decode
        # lengths (A..E = 2, 4, 3, 1, 1); with one prefill token each for D
        # and E, b_max = 4 reproduces the vLLM, FasterTransformer, and
        # Sarathi-Serve rows EXACTLY, and b_max = 5 the Orca row. (No single
        # budget fits all four rows: Orca's second batch carries five tokens
        # while vLLM's third stops at four — the paper's figure is
        # schematic about the budget, not about the compositions.)
        expected = Dict(
            "vllm" => [
                ["Ad", "Bd", "Cd"],
                ["Dp", "Ep"],
                ["Ad", "Bd", "Cd", "Dd"],
                ["Bd", "Cd", "Ed"],
                ["Bd"],
            ],
            "orca" => [
                ["Ad", "Bd", "Cd"],
                ["Ad", "Bd", "Cd", "Dp", "Ep"],
                ["Bd", "Cd", "Dd", "Ed"],
                ["Bd"],
            ],
            "ft" => [
                ["Ad", "Bd", "Cd"],
                ["Ad", "Bd", "Cd"],
                ["Bd", "Cd"],
                ["Bd"],
                ["Dp", "Ep"],
                ["Dd", "Ed"],
            ],
            "sarathi" => [
                ["Ad", "Bd", "Cd"],
                ["Ad", "Bd", "Cd", "Dp"],
                ["Bd", "Cd", "Dd", "Ep"],
                ["Bd", "Ed"],
            ],
        )
        for (label, pol) in (
            ("vllm", VanillaVLLM(; budget=4)),
            ("orca", Orca(; budget=5)),
            ("ft", FasterTransformerRule(; budget=4)),
            ("sarathi", Sarathi(; budget=4)),
        )
            m = fig8_model(pol)
            rec, live = simulate(m, Float64[], 10.0; seed=1, debug=true, keep_states=true)
            g = m.names[:gpu]
            # Job ids follow populate order: A, B, C = 1..3 (check via their
            # decode lengths), D, E = 4, 5 (D deposits first).
            init = replay(m, rec)[1]
            @test [Int(init.jobs[j].v_d) for j in 1:5] == [2, 4, 3, 1, 1]
            plans = committed_plans(m, rec, g)
            name(j) = string("ABCDE"[Int(j)])
            comps = [
                sort([name(j) * (av[1] > 0 ? "p" : "d") for (j, av) in p.alloc]) for p in plans
            ]
            @test comps == expected[label]
            # I4 on each Fig. 8 variant.
            folded = replay(m, rec)
            @test length(folded) == length(live)
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
        end
    end

wanted("dai theorem 2 boundary separates 0.9x from 1.1x") &&
    @testset "dai theorem 2 boundary separates 0.9x from 1.1x" begin
        # λ* = (b_max/t_{b_max})/(m_p + m_d) with the CodeLlama-34B TP-1
        # staircase: t_512 = 11.28 + 35.47·4 = 153.16 ms. Sarathi is
        # work-conserving K-FCFS, so Theorem 2 puts 0.9λ* inside the
        # stability region and 1.1λ* outside: total unprocessed tokens stay
        # bounded vs grow linearly (slope test over the two half-horizons).
        λstar = (512 / 153.16) / 200
        T = 120_000.0
        m = dai_boundary_model()
        rec = simulate(m, [0.9 * λstar], T; seed=3)
        ts, vs = paper_backlog(m, rec)
        stable_half, stable_end = backlog_at(ts, vs, T / 2), backlog_at(ts, vs, T)
        rec = simulate(m, [1.1 * λstar], T; seed=3)
        ts, vs = paper_backlog(m, rec)
        unstable_half, unstable_end = backlog_at(ts, vs, T / 2), backlog_at(ts, vs, T)
        # Bounded: the stable run's second half adds essentially nothing.
        @test stable_end < 20_000
        @test stable_end - stable_half < 5_000
        # Linear growth: the excess arrival rate is 0.1·(512/153.16)
        # tokens/ms ≈ 0.334, about 20k tokens over the second half.
        @test unstable_end - unstable_half > 10_000
        @test unstable_end > 2 * stable_end
    end

wanted("dai vertex-c discriminator: only sarathi-128 is stable") &&
    @testset "dai vertex-c discriminator: only sarathi-128 is stable" begin
        # §6.2's fully deterministic experiment at vertex C of the (λ_p, λ_d)
        # stability region: interarrival 467.5 ms, requests (290, 990),
        # k_max = 100. Sarathi b_max = 128 is the only stable configuration —
        # the paper's sharpest published discriminator — and it locks into
        # batches of EXACTLY 29 prefill + 99 decode tokens, the operating
        # point C. FasterTransformer and vanilla vLLM cannot form any batch
        # (no mixed batching and a 290-token prefill never fits 128 whole),
        # Orca's prefill priority starves decode, and Sarathi-1024 fills to
        # 1024, accumulates k_max decode requests, and degenerates into
        # inefficient decode-only batches.
        T = 140_000.0
        final = Dict{String,Int}()
        for (label, pol) in (
            ("sarathi128", Sarathi(; budget=128, kmax=100)),
            ("ft128", FasterTransformerRule(; budget=128, kmax=100)),
            ("vllm128", VanillaVLLM(; budget=128, kmax=100)),
            ("orca128", Orca(; budget=128, kmax=100)),
            ("sarathi1024", Sarathi(; budget=1024, kmax=100)),
        )
            m = vertexc_model(pol)
            rec = simulate(m, Float64[], T; seed=1)
            ts, vs = paper_backlog(m, rec)
            final[label] = backlog_at(ts, vs, T)
            if label == "sarathi128"
                # Bounded: the second half adds a sliver of a request.
                @test final[label] - backlog_at(ts, vs, T / 2) < 2_000
                # Exact lock-in at vertex C: the last committed plans are all
                # (b, x, y) = (128, 29, 99).
                plans = committed_plans(m, rec, m.names[:gpu])
                @test length(plans) > 2_000
                @test all(
                    p.aggregates.tokens == 128.0 &&
                        p.aggregates.v_p == 29.0 &&
                        p.aggregates.v_d == 99.0 for p in plans[(end - 9):end]
                )
            elseif label in ("ft128", "vllm128")
                # The freeze is total: no round ever runs (a whole 290-token
                # prefill never fits b_max = 128), so the backlog is exactly
                # the arrived work, 1280 tokens per 467.5 ms.
                @test count(k -> k[1] == :round, rec.key) == 0
                @test final[label] == 1280 * floor(Int, T / 467.5)
            else
                # Orca-128 and Sarathi-1024 serve but diverge linearly.
                @test final[label] - backlog_at(ts, vs, T / 2) > 15_000
            end
        end
        @test all(final[l] > 6 * final["sarathi128"] for l in ("ft128", "vllm128"))
        @test all(final[l] > final["sarathi128"] + 30_000 for l in ("orca128", "sarathi1024"))
    end

wanted("rybko-stolyar second-hop priorities destabilize at rho 0.9") &&
    @testset "rybko-stolyar second-hop priorities destabilize at rho 0.9" begin
        # Dai §5.4 with capability 7's remark redraws: b_max = 768, t_b ≡ 1,
        # per-hop mean sizes (32, 32) then (512, 32), both types at
        # λ = 0.9·768/608 so each server's load is ρ = 0.9. Giving each
        # server priority to the class that EXITS through it produces the
        # classic Rybko–Stolyar oscillation whose peaks grow geometrically —
        # the envelope of total unprocessed tokens roughly quadruples per
        # cycle — while the reversed priorities keep the network stable.
        λh = 0.9 * 768 / 608
        T = 4_500.0
        m = rybko_stolyar(; priorities=:destabilizing)
        rec = simulate(m, [λh], T; seed=7)
        ts, vs = paper_backlog(m, rec)
        destab_peak1 = window_max(ts, vs, 0.0, T / 2)
        destab_peak2 = window_max(ts, vs, T / 2, T)
        m = rybko_stolyar(; priorities=:stabilizing)
        rec = simulate(m, [λh], T; seed=7)
        ts, vs = paper_backlog(m, rec)
        stab_max = window_max(ts, vs, 0.0, T)
        # Divergence: the second oscillation dwarfs the first.
        @test destab_peak2 > 2 * destab_peak1
        # And the first already dwarfs everything the stable run ever holds.
        @test destab_peak1 > 5 * stab_max
        @test stab_max < 60_000
    end

wanted("dong algorithm 1 decoupling identity and memory bound") &&
    @testset "dong algorithm 1 decoupling identity and memory bound" begin
        # Dong & Cao §4.1: (l, o) = (10,20)/(10,40)/(10,60), Poisson λ = 5
        # per class per slot, M = 16492, b = (4, 4, 4). Algorithm 1 has no
        # memory check, so per class the waiting queue decouples into the
        # scalar recursion Q_{t,k} = (Q_{t-1,k} + n_{t,k} - b_k)⁺ — an EXACT
        # identity, slot for slot, against the same arrival draws. The KV
        # usage U_t = Σ over active of (l + tokens generated by the end of
        # slot t) never exceeds Σ_k b_k(l·o + (o + o²)/2) = 16240 < M, the
        # paper's inequality (2).
        M, b = 16492, (4, 4, 4)
        m = dong_three_class(; b)
        rec = simulate(m, [5.0], 130.0; seed=11)
        g = m.names[:gpu]
        srcidx = Dict(Int(m.names[Symbol(:arrive, k)]) => k for k in 1:3)
        atimes = Float64[]
        aclasses = Int[]
        for i in eachindex(rec.key)
            rec.key[i][1] == :arrival || continue
            push!(atimes, rec.time[i])
            push!(aclasses, srcidx[Int(rec.key[i][2])])
        end
        t0 = atimes[1]   # the first deposit starts the slot grid
        # Fold: at each round firing the fired plan's allocations credit the
        # delivered-token ledger, and the post-firing state carries the next
        # slot's committed plan — its per-class waiting counts and its
        # end-of-slot memory usage.
        rtimes = Float64[]
        qtrace = Vector{Int}[]
        Uts = Int[]
        delivered = Dict{Int,Int}()
        firedplan = Ref{Union{RoundPlan,Nothing}}(nothing)
        prestate = Ref{Any}(nothing)
        laststate = paper_fold(m, rec) do st, i
            if i > 0 && rec.key[i][1] == :round
                for (j, av) in prestate[].roundplan[g].alloc
                    delivered[j] = get(delivered, j, 0) + av[1]
                end
                push!(rtimes, rec.time[i])
                q = [0, 0, 0]
                for j in st.buf[g]
                    q[Int(st.jobs[j].class)] += 1
                end
                push!(qtrace, q)
                U = 0
                for j in st.srv[g]
                    mk = st.jobs[j]
                    U += Int(mk.l) + (Int(mk.o) - st.work[j][1]) + 1
                end
                push!(Uts, U)
            end
            prestate[] = st
            return nothing
        end
        nslots = length(rtimes)
        @test nslots > 100
        # The slot grid never realigns: round i fires at t0 + i exactly.
        @test all(rtimes[i] ≈ t0 + i for i in 1:nslots)
        # The exact decoupling identity, slot for slot.
        oracle = Vector{Int}[]
        Q = [0, 0, 0]
        for i in 1:nslots
            n = [0, 0, 0]
            for (ta, ca) in zip(atimes, aclasses)
                t0 + (i - 1) < ta <= t0 + i && (n[ca] += 1)
            end
            Q = [max(Q[k] + n[k] - b[k], 0) for k in 1:3]
            push!(oracle, copy(Q))
        end
        @test qtrace == oracle
        # Memory: bounded by the paper's inequality (2) LHS, which the
        # saturated budgets hit exactly, and never over M.
        @test maximum(Uts) == 16240
        @test all(u -> u <= M, Uts)
        # The state's work counters agree with the record's credited tokens:
        # generated = o - remaining for every job still active at the end
        # (jobs first admitted by the final, still-unfired plan have no
        # credits yet and full counters).
        @test all(
            get(delivered, j, 0) == Int(laststate.jobs[j].o) - laststate.work[j][1] for
            j in laststate.srv[g]
        )
    end

wanted("dong algorithm 2 evicts lifo and recomputes in full") &&
    @testset "dong algorithm 2 evicts lifo and recomputes in full" begin
        # Algorithm 2 under overload: overflow triggers LIFO eviction with
        # FULL progress reset, so an evicted-and-reactivated request must
        # deliver its complete o after its LAST activation — the recomputed
        # tokens are visible as total delivered > o. Census conserves:
        # every arrival is either departed or still waiting/active. The
        # planned slot's memory usage never exceeds M.
        M = 120
        m = flow_overload_model(; M)
        rec = simulate(m, [1.0], 80.0; seed=2)
        g = m.names[:gpu]
        narrivals = count(k -> k[1] == :arrival, rec.key)
        delivered = Dict{Int,Int}()
        since_activation = Dict{Int,Int}()
        activations = Dict{Int,Int}()
        departed = Dict{Int,Int}()
        nevict = 0
        overM = 0
        lastplan = Ref{Union{RoundPlan,Nothing}}(nothing)
        prestate = Ref{Any}(nothing)
        laststate = paper_fold(m, rec) do st, i
            if i > 0
                if rec.key[i][1] == :round
                    for (j, av) in prestate[].roundplan[g].alloc
                        delivered[j] = get(delivered, j, 0) + av[1]
                        since_activation[j] = get(since_activation, j, 0) + av[1]
                    end
                end
                p = st.roundplan[g]
                if p !== nothing && p !== lastplan[]
                    lastplan[] = p
                    nevict += length(p.evict)
                    for j in p.evict
                        since_activation[j] = 0
                    end
                    for j in p.admit
                        activations[j] = get(activations, j, 0) + 1
                        since_activation[j] = 0
                    end
                    U = sum(
                        Int(st.jobs[j].l) + (Int(st.jobs[j].o) - st.work[j][1]) + 1 for
                        j in st.srv[g];
                        init=0,
                    )
                    U > M && (overM += 1)
                end
                for j in setdiff(keys(prestate[].jobs), keys(st.jobs))
                    departed[j] = delivered[j]
                end
            end
            prestate[] = st
            return nothing
        end
        reactivated = Set(j for (j, n) in activations if n > 1)
        # The scenario actually exercises the mechanism.
        @test nevict > 10
        @test count(j -> haskey(departed, j), reactivated) >= 2
        @test overM == 0
        # Census: arrivals = departed + waiting + active.
        @test narrivals == length(departed) + length(laststate.buf[g]) + length(laststate.srv[g])
        # Full recomputation: every departure delivered exactly o = 15 after
        # its last activation; the evicted-and-reactivated ones delivered
        # strictly more than o in total, the non-evicted exactly o.
        @test all(since_activation[j] == 15 for j in keys(departed))
        @test all(departed[j] == 15 for j in keys(departed) if !(j in reactivated))
        @test all(departed[j] > 15 for j in keys(departed) if j in reactivated)
    end

wanted("paper round models replay exactly with clean membership") &&
    @testset "paper round models replay exactly with clean membership" begin
        # I4 on every paper model at a short horizon (the Fig. 8 variants
        # run replay inside their own testset): the fold of fire_changes
        # over the record reproduces the live trajectory exactly — remark
        # draws, FlowControl budget draws, work counters, and committed
        # plans included — with the debug membership oracle on throughout.
        λstar = (512 / 153.16) / 200
        for (m, θ, T) in (
            (vertexc_model(Sarathi(; budget=128, kmax=100)), Float64[], 8_000.0),
            (dai_boundary_model(), [1.1 * λstar], 5_000.0),
            (rybko_stolyar(; priorities=:destabilizing), [0.9 * 768 / 608], 120.0),
            (rybko_stolyar(; priorities=:stabilizing), [0.9 * 768 / 608], 120.0),
            (dong_three_class(), [5.0], 20.0),
            (flow_overload_model(), [1.0], 40.0),
        )
            rec, live = simulate(m, θ, T; seed=17, debug=true, keep_states=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
        end
    end
