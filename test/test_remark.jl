# Mark redraw on deposit (capability 7): a station's remark laws redraw a
# job's marks as it files in from outside, through the firing's draw source.
# The oracle is the two-hop tandem whose hops must match their OWN M/M/1
# occupancies — marks leaking across hops would land on the wrong moments —
# plus the pre-redraw read convention, replay through the recorded remark
# draws, the once-per-deposit rule under blocking, the branch_world refusal,
# and the C11/census messages verbatim.

wanted("remark tandem hops match their own m/m/1 occupancies") &&
    @testset "remark tandem hops match their own m/m/1 occupancies" begin
        # Dirac(Mark(:size)) service with size ~ Exp makes each hop exactly
        # M/M/1; Burke keeps :hop2's arrivals Poisson. With the redraw,
        # occupancy at hop i is ρᵢ/(1-ρᵢ) for ρᵢ = λ mᵢ (sojourn follows by
        # Little); a leak would put :hop2 on :hop1's moments.
        θ = [1.0, 0.5, 0.25]               # λ, mean size at hop1, at hop2
        m = remark_tandem()
        at(name) = (q=m.names[name]; st -> Float64(length(st.buf[q]) + length(st.srv[q])))
        R = nreps(24)
        e1, s1 = replicate(rec -> time_average(at(:hop1), m, rec), m, θ, 1000.0, R)
        e2, s2 = replicate(rec -> time_average(at(:hop2), m, rec), m, θ, 1000.0, R)
        ρ1 = θ[1] * θ[2]
        ρ2 = θ[1] * θ[3]
        @test within4se(e1, s1, ρ1 / (1 - ρ1))
        @test within4se(e2, s2, ρ2 / (1 - ρ2))
        # The leak alarm: had :hop2 kept :hop1's sizes, it would sit at
        # ρ1/(1-ρ1) = 1, far outside the band around 1/3.
        @test !within4se(e2, s2, ρ1 / (1 - ρ1))
    end

wanted("remark laws read the pre-redraw marks: a swap swaps") &&
    @testset "remark laws read the pre-redraw marks: a swap swaps" begin
        # Two Dirac remark laws reading each other's names: under the
        # pre-redraw convention both see the OLD marks and (a=1, b=2)
        # becomes (a=2, b=1). Sequential drawmarks!-style evaluation would
        # give (a=2, b=2) instead.
        net = QueueNetwork(; param_names=(:lambda,))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; a=Law(:Dirac; value=Const(1.0)), b=Law(:Dirac; value=Const(2.0))),
        )
        station!(
            net,
            :swap;
            service=Law(:Exponential; scale=Const(1.0)),
            remark=(a=Law(:Dirac; value=Mark(:b)), b=Law(:Dirac; value=Mark(:a))),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:swap))
        route!(net, :swap, Always(:done))
        m = compile(net)
        rec, live = simulate(m, [1.0], 20.0; seed=3, debug=true, keep_states=true)
        i = findfirst(k -> k[1] == :arrival, rec.key)
        @test i !== nothing
        # The arrival's draw list carries birth marks then the redraw, in
        # deposit order; the redrawn values show the swap.
        @test rec.draws[i] == [:a => 1.0, :b => 2.0, :a => 2.0, :b => 1.0]
        @test only(values(live[i + 1].jobs)) == (a=2.0, b=1.0)
    end

wanted("remark replay equality and loud truncation") &&
    @testset "remark replay equality and loud truncation" begin
        m = remark_tandem()
        θ = [1.0, 0.5, 0.25]
        rec, live = simulate(m, θ, 300.0; seed=17, debug=true, keep_states=true)
        folded = replay(m, rec)
        @test length(folded) == length(live)
        @test all(states_equal(a, b) for (a, b) in zip(live, folded))
        # Remark draws are ordinary recorded draws: a completion at :hop1
        # deposits into :hop2 and carries the redrawn size in its draw list.
        q1 = Int32(m.names[:hop1])
        i = findfirst(
            n -> rec.key[n][1] == :service && rec.key[n][2] == q1 && !isempty(rec.draws[n]),
            eachindex(rec.key),
        )
        @test i !== nothing
        @test all(p.first == :size for p in rec.draws[i])
        # Truncating that firing's draw list errors loudly at replay — the
        # draw-conduit discipline, as for a truncated init list.
        cut = MarkedRecord(rec.key, rec.time, copy(rec.draws), rec.init, rec.horizon)
        cut.draws[i] = rec.draws[i][1:(end - 1)]
        @test_throws "asked for draw size beyond the record" replay(m, cut)
    end

wanted("remark draws once per deposit, blocking and unblocking included") &&
    @testset "remark draws once per deposit, blocking and unblocking included" begin
        # A finite :block buffer behind the remark station: a transfer that
        # turns back blocked redraws at the DEPOSIT, and its eventual
        # unblock re-file replays nothing — so the redraw count equals the
        # completion count upstream, blocked transfers included.
        net = QueueNetwork(; param_names=(:lambda, :mu1))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(net, :first; service=Law(:Exponential; scale=inv(Param(:mu1))))
        station!(
            net,
            :second;
            service=Law(:Exponential; scale=Mark(:w)),
            capacity=1,
            overflow=:block,
            remark=(w=Law(:Exponential; scale=Const(0.75)),),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:first))
        route!(net, :first, Always(:second))
        route!(net, :second, Always(:done))
        m = compile(net)
        θ = [1.5, 2.0]                     # ρ at :second = 1.125: steady blocking
        rec, live = simulate(m, θ, 300.0; seed=23, debug=true, keep_states=true)
        q1 = m.names[:first]
        @test any(!isempty(st.hold[q1]) for st in live)   # blocking actually occurred
        completions = count(
            n -> rec.key[n][1] == :service && Int(rec.key[n][2]) == q1, eachindex(rec.key)
        )
        wdraws = sum(count(p -> p.first == :w, rec.draws[n]) for n in eachindex(rec.key))
        @test completions > 0
        @test wdraws == completions
        @test all(states_equal(a, b) for (a, b) in zip(live, replay(m, rec)))
    end

wanted("branch_world refuses theta-reading remark laws") &&
    @testset "branch_world refuses theta-reading remark laws" begin
        # The θ-dependent-mark refusal extends verbatim to deposit-time
        # redraws; a θ-free remark model is admitted. The source mark is
        # θ-free so the remark law alone triggers the refusal.
        net = QueueNetwork(; param_names=(:lambda, :m2))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; size=Law(:Exponential; scale=Const(0.5))),
        )
        station!(
            net,
            :hop2;
            service=Law(:Dirac; value=Mark(:size)),
            remark=(size=Law(:Exponential; scale=Param(:m2)),),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:hop2))
        route!(net, :hop2, Always(:done))
        @test_throws "branchable worlds support θ-free marks only for now; remark size of hop2 reads parameters [:m2]" branch_world(
            compile(net), [1.0, 0.25]; seed=1
        )
        @test branch_world(remark_tandem(; thetafree=true), [1.0, 0.5, 0.25]; seed=1) isa
            ConcourseWorld
    end

wanted("c11 remark laws may not read station state") &&
    @testset "c11 remark laws may not read station state" begin
        net = QueueNetwork(; param_names=(:lambda,))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(
            net,
            :hop;
            service=Law(:Exponential; scale=Const(1.0)),
            remark=(w=Law(:Exponential; scale=InService(:hop) + Const(1.0)),),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:hop))
        route!(net, :hop, Always(:done))
        @test_throws "remark law w at hop reads station state; remark laws obey source-mark-law scope, and state in a mark draw would put station state into the record's mark draws, breaking replay — amendment A4 (check C11)" compile(
            net
        )
    end

wanted("census: a remark-only mark reads downstream, never upstream") &&
    @testset "census: a remark-only mark reads downstream, never upstream" begin
        # source → :front → :mid (remark w) → :back → sink. Reading w at
        # :mid (the remark station itself) or at :back (downstream) is
        # legal; reading it at :front, upstream of the redraw, is not.
        expo = Law(:Exponential; scale=Const(0.2))
        function build(read_at)
            net = QueueNetwork(; param_names=(:lambda,))
            source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
            svc(s) = s == read_at ? Law(:Dirac; value=Mark(:w)) : expo
            station!(net, :front; service=svc(:front))
            station!(net, :mid; service=svc(:mid), remark=(w=Law(:Exponential; scale=Const(0.2)),))
            station!(net, :back; service=svc(:back))
            sink!(net, :done)
            route!(net, :arrive, Always(:front))
            route!(net, :front, Always(:mid))
            route!(net, :mid, Always(:back))
            route!(net, :back, Always(:done))
            return net
        end
        @test compile(build(:mid)) isa QueueGSMP
        @test compile(build(:back)) isa QueueGSMP
        @test_throws "law at front reads mark w no source, populate!, or upstream remark produces" compile(
            build(:front)
        )
        # A remark law reads the PRE-redraw marks, so its own product is
        # not available to it unless something upstream supplies it.
        net = QueueNetwork(; param_names=(:lambda,))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(
            net,
            :hop;
            service=Law(:Exponential; scale=Const(0.2)),
            remark=(w=Law(:Dirac; value=Mark(:w) + Const(1.0)),),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:hop))
        route!(net, :hop, Always(:done))
        @test_throws "remark law w at hop reads mark w, which is not on the job before the redraw — remark laws read the PRE-redraw marks" compile(
            net
        )
    end
