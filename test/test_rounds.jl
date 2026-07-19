# Round-based token service (capability 6, checks C12–C13): a station may
# serve in synchronous rounds planned by a RoundPolicy at each boundary,
# with per-job integer work counters persisting across rounds. The core
# falsification tests: the degenerate M/D/1 (Sarathi with budget 1 on
# unit work IS M/D/1, checked against Pollaczek–Khinchine AND record-level
# against the plain FCFS twin at the same seed), replay equality with
# admission/eviction traffic, an impure policy caught by the replay
# harness, the check messages verbatim, and chained rounds at sustained
# overload staying inside the cascade fuel bound. The paper-reproduction
# tests (Dai Fig. 8, Theorem 2, vertex C, Rybko–Stolyar, Dong's
# decoupling oracle) build on these and live with the examples.

using Distributions: Dirac

# The batch-free twin of round_md1: plain single-server FCFS with the same
# Dirac service time and the same (recorded but unread) unit work mark, so
# the two models consume identical draws and their records must align.
function plain_md1_twin(; s=0.5)
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; w=Law(:Dirac; value=Const(1.0))),
    )
    station!(net, :gpu; service=Law(:Dirac; value=Const(s)))
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Dong's Algorithm 2 in its smallest deterministic form: two seeded jobs
# with (l, o) = (3, 4) against KV capacity M = 10 and a constant activation
# budget of 2. Round by round the KV usage l + generated + 1 grows until
# slot 3 overflows (6 + 6 > 10) and the newer job is evicted LIFO with its
# progress reset — its total decode work becomes visible recomputation.
function flow_eviction_model(; M=10, l=3.0, o=4.0)
    net = QueueNetwork(; param_names=())
    station!(
        net,
        :gpu;
        rounds=Rounds(;
            policy=FlowControl(Dirac(2), M; prompt=:l),
            duration=Law(:Dirac; value=Const(1.0)),
            work=(:o,),
        ),
    )
    sink!(net, :done)
    route!(net, :gpu, Always(:done))
    populate!(
        net, :gpu, 2; mark=MarkLaw(; l=Law(:Dirac; value=Const(l)), o=Law(:Dirac; value=Const(o)))
    )
    return compile(net)
end

# A two-phase (prefill, decode) round station under Sarathi with Dai's
# staircase duration read off the frozen aggregates through ceil.
function two_phase_model(; budget=4)
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(3.0)), v_d=Law(:Dirac; value=Const(2.0))),
    )
    station!(
        net,
        :gpu;
        rounds=Rounds(;
            policy=Sarathi(; budget),
            duration=Law(:Dirac; value=Const(0.1) + Const(0.2) * ceil(Mark(:tokens) / 2)),
            work=(:v_p, :v_d),
        ),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# A test-only IMPURE policy: its plan depends on a counter outside the draw
# conduit, so a replay of the record recomputes different plans and the
# replay-equality harness must catch the divergence.
const RIGGED_CALLS = Ref(0)
struct RiggedPolicy <: RoundPolicy end
function Concourse.plan_round(::RiggedPolicy, v::RoundView, draws)
    jobs = vcat(v.active, v.waiting)
    isempty(jobs) && return nothing
    RIGGED_CALLS[] += 1                     # randomness outside `draws`
    n = isodd(RIGGED_CALLS[]) ? 1 : 0
    alloc = [j.id => Int[min(n, j.work[1])] for j in jobs[1:1]]
    return RoundPlan(; admit=[w.id for w in v.waiting], alloc)
end

wanted("round degenerate m/d/1 matches pollaczek-khinchine") &&
    @testset "round degenerate m/d/1 matches pollaczek-khinchine" begin
        # Sarathi(budget = 1) on unit work with a Dirac(s) round IS M/D/1:
        # mean number in system L = ρ + ρ²/(2(1-ρ)).
        m = round_md1(; s=0.5)
        ρ = 1.0 * 0.5
        exact = ρ + ρ^2 / (2 * (1 - ρ))
        est, se = replicate(
            rec -> time_average(number_in_system, m, rec), m, [1.0], 1000.0, nreps(24)
        )
        @test within4se(est, se, exact)
    end

wanted("round degenerate m/d/1 record matches the plain fcfs twin") &&
    @testset "round degenerate m/d/1 record matches the plain fcfs twin" begin
        # The sharpest cheap test that the engine adds nothing when the
        # policy degenerates: at the same seed, the round model's firing
        # times match the plain FCFS M/D/1 one-for-one, with :round firings
        # standing exactly where the twin's :service firings stand.
        mr = round_md1(; s=0.5)
        mp = plain_md1_twin(; s=0.5)
        rr = simulate(mr, [1.0], 500.0; seed=11, debug=true)
        rp = simulate(mp, [1.0], 500.0; seed=11, debug=true)
        @test length(rr) == length(rp)
        @test rr.time == rp.time
        @test all(
            kr[1] == (kp[1] == :service ? :round : kp[1]) && kr[2] == kp[2] for
            (kr, kp) in zip(rr.key, rp.key)
        )
    end

wanted("round replay equality and debug membership") &&
    @testset "round replay equality and debug membership" begin
        # I4 on the degenerate M/D/1 and on the two-phase Sarathi model:
        # the fold of fire_changes over the record reproduces the live
        # trajectory exactly, work counters and round plans included, and
        # the debug oracle sees no membership drift.
        for (m, θ) in ((round_md1(), [1.5]), (two_phase_model(), [1.0]))
            rec, live = simulate(m, θ, 200.0; seed=17, debug=true, keep_states=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
        end
    end

wanted("round eviction resets work and replays exactly") &&
    @testset "round eviction resets work and replays exactly" begin
        # FlowControl forces a LIFO eviction at the slot-3 boundary: the
        # evicted job leaves the active set with its counters deleted, is
        # re-admitted later with the FULL profile re-snapshotted, and the
        # whole trajectory — evictions in the committed plans included —
        # replays exactly. Departures land at t = 4 (survivor) and t = 8
        # (evicted job, its two pre-eviction tokens recomputed).
        m = flow_eviction_model()
        rec, live = simulate(m, Float64[], 50.0; seed=1, debug=true, keep_states=true)
        g = m.names[:gpu]
        @test rec.time == [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
        plans = [st.roundplan[g] for st in live if st.roundplan[g] !== nothing]
        @test any(p -> !isempty(p.evict), plans)
        # After the eviction commits, the evicted job waits with no counter
        # entry — reset, not banked.
        i = findfirst(st -> st.roundplan[g] !== nothing && !isempty(st.roundplan[g].evict), live)
        evicted = live[i].roundplan[g].evict[1]
        @test evicted in live[i].buf[g]
        @test !haskey(live[i].work, evicted)
        # 8 one-token slots for 2 jobs of o = 4 with 2 tokens recomputed
        # means the record shows exactly the paper's refresh semantics.
        folded = replay(m, rec)
        @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    end

wanted("an impure round policy is caught by the replay harness") &&
    @testset "an impure round policy is caught by the replay harness" begin
        # The purity contract is enforced by falsification: a policy that
        # keeps state outside `draws` plans differently when the fold
        # recomputes it, so replay either diverges from the live states or
        # errors — either way the harness catches it.
        net = QueueNetwork(; param_names=(:lambda,))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; w=Law(:Dirac; value=Const(1.0))),
        )
        station!(
            net,
            :gpu;
            rounds=Rounds(;
                policy=RiggedPolicy(), duration=Law(:Dirac; value=Const(0.5)), work=(:w,)
            ),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:gpu))
        route!(net, :gpu, Always(:done))
        m = compile(net)
        RIGGED_CALLS[] = 0
        rec, live = simulate(m, [1.0], 100.0; seed=5, keep_states=true)
        caught = try
            folded = replay(m, rec)
            !all(states_equal(a, b) for (a, b) in zip(live, folded))
        catch
            true
        end
        @test caught
    end

wanted("chained rounds at sustained overload stay inside the fuel bound") &&
    @testset "chained rounds at sustained overload stay inside the fuel bound" begin
        # ρ = 5: every round boundary re-plans immediately at the firing
        # time (zero-gap chaining) while deposits keep arriving; the settle
        # cascade must reach its fixed point within the fuel bound at every
        # firing, with membership clean throughout.
        m = round_md1(; s=1.0)
        rec = simulate(m, [5.0], 200.0; seed=23, debug=true)
        st = replay(m, rec)[end]
        g = m.names[:gpu]
        backlog = length(st.buf[g]) + length(st.srv[g])
        @test backlog > 300              # genuinely overloaded, still running
        @test count(k -> k[1] == :round, rec.key) > 150
    end

wanted("two-phase sarathi respects phase order and the staircase duration") &&
    @testset "two-phase sarathi respects phase order and the staircase duration" begin
        # A lone (v_p, v_d) = (3, 2) request under Sarathi(budget = 4):
        # round 1 is a 3-token prefill chunk (no decode in the same round —
        # Dai's constraint (6a)), rounds 2 and 3 are single decode tokens.
        # The staircase duration 0.1 + 0.2⌈b/2⌉ prices them 0.5, 0.3, 0.3.
        net = QueueNetwork(; param_names=())
        station!(
            net,
            :gpu;
            rounds=Rounds(;
                policy=Sarathi(; budget=4),
                duration=Law(:Dirac; value=Const(0.1) + Const(0.2) * ceil(Mark(:tokens) / 2)),
                work=(:v_p, :v_d),
            ),
        )
        sink!(net, :done)
        route!(net, :gpu, Always(:done))
        populate!(
            net,
            :gpu,
            1;
            mark=MarkLaw(; v_p=Law(:Dirac; value=Const(3.0)), v_d=Law(:Dirac; value=Const(2.0))),
        )
        m = compile(net)
        rec, live = simulate(m, Float64[], 10.0; seed=1, debug=true, keep_states=true)
        @test [k[1] for k in rec.key] == [:round, :round, :round]
        @test rec.time ≈ [0.5, 0.8, 1.1]
        g = m.names[:gpu]
        aggs = [st.roundplan[g].aggregates for st in live if st.roundplan[g] !== nothing]
        @test [(a.tokens, a.v_p, a.v_d) for a in aggs] == [(3.0, 3.0, 0.0), (1.0, 0.0, 1.0), (1.0, 0.0, 1.0)]
        @test isempty(replay(m, rec)[end].jobs)
    end

wanted("c12 round station shape messages verbatim") &&
    @testset "c12 round station shape messages verbatim" begin
        r = Rounds(; policy=Sarathi(; budget=8), duration=Law(:Dirac; value=Const(1.0)), work=(:w,))
        function build(; kwargs...)
            net = QueueNetwork(; param_names=(:lambda,))
            source!(
                net,
                :arrive;
                interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
                mark=MarkLaw(; w=Law(:Dirac; value=Const(1.0))),
            )
            station!(net, :gpu; rounds=r, kwargs...)
            sink!(net, :done)
            route!(net, :arrive, Always(:gpu))
            route!(net, :gpu, Always(:done))
            return net
        end
        @test_throws "station gpu declares rounds under the lcfs discipline; round service requires the non-preemptive :back-insert FCFS discipline (check C12)" compile(
            build(; discipline=LCFS())
        )
        @test_throws "station gpu declares both rounds and batching; the round policy owns batch formation (check C12)" compile(
            build(; batching=Batching(; min=2))
        )
        @test_throws "station gpu declares rounds with servers = 3; the round clock is the station's single server, so rounds fixes servers = 1 (check C12)" compile(
            build(; servers=3)
        )
        @test_throws "station gpu declares both service and rounds; a round station takes its duration from the Rounds config (check C12)" compile(
            build(; service=Law(:Exponential; scale=Const(1.0)))
        )
        # The census half: a work mark nothing upstream produces.
        net = QueueNetwork(; param_names=(:lambda,))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(net, :gpu; rounds=r)
        sink!(net, :done)
        route!(net, :arrive, Always(:gpu))
        route!(net, :gpu, Always(:done))
        @test_throws "rounds at gpu names work mark w no source, populate!, or upstream remark produces (check C12)" compile(
            net
        )
        # A station with neither service nor rounds never leaves station!.
        @test_throws "station bare needs a service law (or a rounds config)" station!(
            QueueNetwork(; param_names=()), :bare
        )
    end

wanted("c13 duration law scope messages verbatim") &&
    @testset "c13 duration law scope messages verbatim" begin
        function build(duration)
            net = QueueNetwork(; param_names=(:lambda,))
            source!(
                net,
                :arrive;
                interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
                mark=MarkLaw(; w=Law(:Dirac; value=Const(1.0))),
            )
            station!(net, :gpu; rounds=Rounds(; policy=Sarathi(; budget=8), duration, work=(:w,)))
            sink!(net, :done)
            route!(net, :arrive, Always(:gpu))
            route!(net, :gpu, Always(:done))
            return net
        end
        # The aggregates are legal; a job mark is not, live state is not.
        @test compile(build(Law(:Dirac; value=Const(0.1) * Mark(:tokens) + Mark(:w)))) isa QueueGSMP
        @test_throws "rounds duration law at gpu reads mark size, which is not a round aggregate; the duration law reads only the plan's frozen aggregates — tokens, requests, and the per-phase sums (:w,) (check C13)" compile(
            build(Law(:Dirac; value=Mark(:size)))
        )
        @test_throws "rounds duration law at gpu reads station state; a round's duration is frozen at the boundary and reads only the plan's aggregates (check C13)" compile(
            build(Law(:Dirac; value=InService(:gpu)))
        )
    end

wanted("non-integer work marks error at admission") &&
    @testset "non-integer work marks error at admission" begin
        # The runtime half of C12: the compile census cannot see mark
        # values, so a fractional work mark errors when the plan tries to
        # snapshot it into a counter.
        net = QueueNetwork(; param_names=(:lambda,))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; w=Law(:Dirac; value=Const(1.5))),
        )
        station!(
            net,
            :gpu;
            rounds=Rounds(;
                policy=Sarathi(; budget=8), duration=Law(:Dirac; value=Const(1.0)), work=(:w,)
            ),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:gpu))
        route!(net, :gpu, Always(:done))
        m = compile(net)
        @test_throws "round station gpu cannot admit job 1: work mark w = 1.5 is not a nonnegative integer" simulate(
            m, [1.0], 50.0; seed=1
        )
    end
