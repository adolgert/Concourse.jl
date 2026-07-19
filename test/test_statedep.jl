# State-dependent service laws (check C5, the reenable segment convention):
# a station's service law may read live occupancy through InService/InBuffer,
# and whenever a watched count changes, every surviving in-service clock of a
# reader station banks its accrued effort, moves its anchor to now, keeps te
# at the ORIGINAL enabling, and is re-declared from a base law rebuilt from
# the current state. The oracles are birth-death closed forms; the delta and
# replay tests pin the mechanism, not just the distribution.

using ClockGradients: ClockGradients
using Distributions
using Random: Xoshiro, randexp

# Exact M/M/c mean number in system via Erlang C.
function mmc_mean(λ, μ, c)
    a = λ / μ
    ρ = a / c
    tail = a^c / (factorial(c) * (1 - ρ))
    C = tail / (sum(a^k / factorial(k) for k in 0:(c - 1)) + tail)
    return C * ρ / (1 - ρ) + a
end

# Stations A and B with independent Poisson feeds; B's exponential service
# rate is mb * (1 - 0.5 * InService(:a)) — halved while A's one server is
# busy — so B is a reader of A's in-service count and of nothing else.
function cross_read()
    net = QueueNetwork(; param_names=(:la, :ma, :lb, :mb))
    source!(net, :src_a; interarrival=Law(:Exponential; scale=inv(Param(:la))))
    source!(net, :src_b; interarrival=Law(:Exponential; scale=inv(Param(:lb))))
    station!(net, :a; service=Law(:Exponential; scale=inv(Param(:ma))))
    station!(
        net,
        :b;
        service=Law(
            :Exponential; scale=inv(Param(:mb) * (Const(1.0) - Const(0.5) * InService(:a)))
        ),
    )
    sink!(net, :done)
    route!(net, :src_a, Always(:a))
    route!(net, :src_b, Always(:b))
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    return compile(net)
end

# B's service law switches its Gamma SHAPE (1 while A idle, 2 while A busy)
# mid-flight: the whole base distribution changes between segments, not just
# a rate, so the age-carryover convention itself is on trial.
function shape_switch()
    net = QueueNetwork(; param_names=(:la, :ma, :lb))
    source!(net, :src_a; interarrival=Law(:Exponential; scale=inv(Param(:la))))
    source!(net, :src_b; interarrival=Law(:Exponential; scale=inv(Param(:lb))))
    station!(net, :a; service=Law(:Exponential; scale=inv(Param(:ma))))
    station!(net, :b; service=Law(:Gamma; shape=Const(1.0) + InService(:a), scale=Const(0.5)))
    sink!(net, :done)
    route!(net, :src_a, Always(:a))
    route!(net, :src_b, Always(:b))
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    return compile(net)
end

# Sojourn times of B's jobs, folded from the record: a job's entry is its
# source firing (the created id is the pre-firing next_id), its exit is its
# service firing at B. Jobs still in the system at the horizon are excluded,
# the same convention the hand-rolled simulator uses.
function b_sojourns(m, rec)
    srcb = m.names[:src_b]
    b = m.names[:b]
    st = Concourse.initial_state(m)
    entry = Dict{Int64,Float64}()
    soj = Float64[]
    for i in eachindex(rec.key)
        key = rec.key[i]
        key[1] == :arrival && Int(key[2]) == srcb && (entry[st.next_id] = rec.time[i])
        key[1] == :service && Int(key[2]) == b && push!(soj, rec.time[i] - entry[key[3]])
        ds = Concourse.replaydraws(key, rec.draws[i], m.params)
        st, _ = fire_changes(m, st, key, rec.time[i], ds)
    end
    return soj
end

# The same model as shape_switch, simulated directly by an event-driven loop
# that implements the age-carryover convention by hand: the in-service B job
# tracks its accrued effort a; on each regime change the next completion is
# sampled from the NEW base conditioned on X > a, remaining = X - a. Shares
# no code with the interpreter.
function handrolled_shape_switch(la, ma, lb, θscale, horizon, rng)
    nA = 0
    ta = randexp(rng) / la      # next A arrival
    tca = Inf                   # next A completion
    tb = randexp(rng) / lb      # next B arrival
    qB = Float64[]              # arrival times of waiting B jobs
    inb = nothing               # (arrival, effort, anchor, completion) of B's job
    soj = Float64[]
    shape() = nA > 0 ? 2.0 : 1.0
    start(arrt, t) = (arrt, 0.0, t, t + rand(rng, Gamma(shape(), θscale)))
    function regime!(t)
        inb === nothing && return nothing
        (arrt, eff, anc, _) = inb
        eff += t - anc          # effort accrues at speed 1 outside PS
        rem = rand(rng, truncated(Gamma(shape(), θscale); lower=eff)) - eff
        return inb = (arrt, eff, t, t + rem)
    end
    while true
        t = min(ta, tca, tb, inb === nothing ? Inf : inb[4])
        t > horizon && break
        if t == ta
            nA += 1
            ta = t + randexp(rng) / la
            if nA == 1
                tca = t + randexp(rng) / ma
                regime!(t)      # A's in-service count went 0 -> 1
            end
        elseif t == tca
            nA -= 1
            tca = nA > 0 ? t + randexp(rng) / ma : Inf
            nA == 0 && regime!(t)   # 1 -> 0; a backlogged completion keeps count 1
        elseif t == tb
            tb = t + randexp(rng) / lb
            inb === nothing ? (inb = start(t, t)) : push!(qB, t)
        else
            push!(soj, t - inb[1])
            inb = isempty(qB) ? nothing : start(popfirst!(qB), t)
        end
    end
    return soj
end

wanted("statedep mmc oracle: min(n,c) rate law matches the plain m/m/c") &&
    @testset "statedep mmc oracle: min(n,c) rate law matches the plain m/m/c" begin
        c = 3
        θ = [2.1, 1.0]              # a = 2.1, ρ = 0.7
        exact = mmc_mean(θ[1], θ[2], c)
        # Formulation A: c ordinary servers, exponential rate μ each.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda))))
        station!(net, :q; servers=c, service=Law(:Exponential, scale=inv(Param(:mu))))
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        ma = compile(net)
        esta, sea = replicate(r -> time_average(number_in_system, ma, r), ma, θ, 1000.0, nreps(16))
        @test within4se(esta, sea, exact)
        # Formulation B: ONE server whose rate is μ·min(n, c), n the total
        # occupancy — the same birth-death chain, reached through the
        # state-dependent law and its mid-flight re-evaluations.
        mb = birth_death(n -> Param(:mu) * min(n, Const(Float64(c))))
        estb, seb = replicate(r -> time_average(number_in_system, mb, r), mb, θ, 1000.0, nreps(16))
        @test within4se(estb, seb, exact)
    end

wanted("statedep pure birth-death: rate mu*n is m/m/inf in disguise") &&
    @testset "statedep pure birth-death: rate mu*n is m/m/inf in disguise" begin
        m = birth_death(n -> Param(:mu) * n)
        θ = [2.0, 1.0]              # stationary occupancy Poisson(λ/μ), mean 2
        est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 1000.0, nreps(16))
        @test within4se(est, se, θ[1] / θ[2])
    end

wanted("statedep cross-station read emits reenables exactly at watched changes") &&
    @testset "statedep cross-station read emits reenables exactly at watched changes" begin
        m = cross_read()
        θ = [1.0, 2.0, 0.8, 2.0]
        rec, live = simulate(m, θ, 300.0; seed=41, keep_states=true, debug=true)
        a = m.names[:a]
        b = m.names[:b]
        st = Concourse.initial_state(m)
        hits = 0
        for i in eachindex(rec.key)
            ds = Concourse.replaydraws(rec.key[i], rec.draws[i], m.params)
            old = st
            st, deltas = fire_changes(m, st, rec.key[i], rec.time[i], ds)
            @test states_equal(st, live[i + 1])         # I4: the fold IS the trajectory
            reens = [k for (op, k) in deltas if op == :reenable]
            a_changed = length(old.srv[a]) != length(st.srv[a])
            survivors = [
                j for j in st.srv[b] if j in old.srv[b] && rec.key[i] != (:service, Int32(b), j)
            ]
            if a_changed && !isempty(survivors)
                # (a) every surviving in-service clock of the reader re-declares.
                for j in survivors
                    @test (:service, Int32(b), j) in reens
                end
                hits += 1
            elseif !a_changed
                # (b) B reads only A's in-service count, and neither station is
                # PS, so a firing that leaves that count alone re-enables nothing
                # — including A completions that promote a waiting job (count
                # 1 -> 1: the law reads the count, not the membership).
                @test isempty(reens)
            end
        end
        @test hits > 20                                 # the run genuinely exercised it
    end

wanted("statedep shape switch matches a hand-rolled age-carryover simulator") &&
    @testset "statedep shape switch matches a hand-rolled age-carryover simulator" begin
        m = shape_switch()
        # A is busy half the time but flips fast (λa = 2, μa = 4), so most B
        # services straddle regime changes — at these settings a hand-rolled
        # variant that FORGETS the accrued age on a regime change sits ~10
        # combined SEs away, so the 4-SE agreement below is discriminating.
        θ = [2.0, 4.0, 0.8]
        H = 1000.0
        R = nreps(48)
        conc = [mean(b_sojourns(m, simulate(m, θ, H; seed=300 + r, debug=true))) for r in 1:R]
        rng = Xoshiro(9000)
        hand = [mean(handrolled_shape_switch(θ..., 0.5, H, rng)) for r in 1:R]
        est1, se1 = mean(conc), std(conc) / sqrt(R)
        est2, se2 = mean(hand), std(hand) / sqrt(R)
        # Different randomness on the two sides: the comparison is statistical.
        @test abs(est1 - est2) <= 4 * sqrt(se1^2 + se2^2)
    end

wanted("statedep census: reads_state through the algebra and the laws") &&
    @testset "statedep census: reads_state through the algebra and the laws" begin
        @test reads_state(InService(:a)) == Set([:a])
        @test reads_state(InBuffer(:b)) == Set([:b])
        @test reads_state(Param(:mu)) == Set{Symbol}()
        @test reads_state(Const(2.0)) == Set{Symbol}()
        @test reads_state(Param(:mu) * min(InService(:a) + InBuffer(:b), Const(3.0))) ==
            Set([:a, :b])
        @test reads_state(Law(:Uniform, a=InService(:a), b=InBuffer(:b) + Const(9.0))) ==
            Set([:a, :b])
        @test reads_state(Law(:Exponential, scale=inv(Param(:mu)))) == Set{Symbol}()
        # An Opaque callback never receives a state view, so it reads no state.
        @test reads_state(Opaque((θ, mk, te) -> Exponential(1.0))) == Set{Symbol}()
    end

wanted("statedep c5 confines occupancy reads to station service laws") &&
    @testset "statedep c5 confines occupancy reads to station service laws" begin
        # 1. State in a mark law would enter the recorded mark draws.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential, scale=inv(Param(:lambda))),
            mark=MarkLaw(size=Law(:Exponential, scale=Const(1.0) + InService(:q))),
        )
        station!(net, :q; service=Law(:Exponential, scale=inv(Param(:mu))))
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "mark law size at arrive reads station state; state in a mark law would put station state into the record's mark draws, breaking replay — amendment A4 (check C5)" compile(
            net
        )

        # 2. State-dependent arrivals/balking is its own (unbuilt) feature.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(
            net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda) + InService(:q)))
        )
        station!(net, :q; service=Law(:Exponential, scale=inv(Param(:mu))))
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "interarrival law at arrive reads station state; state-dependent arrivals/balking is a separate feature, not supported (check C5)" compile(
            net
        )

        # 3. Patience laws stay state-blind.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda))))
        station!(
            net,
            :q;
            service=Law(:Exponential, scale=inv(Param(:mu))),
            patience=Law(:Exponential, scale=Const(1.0) + InBuffer(:q)),
            renege_to=:done,
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "patience law at q reads station state; only the service law of a station may read occupancy (check C5)" compile(
            net
        )

        # 4. A state-dependent deterministic route would put an unrecorded
        # factor into the likelihood.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda))))
        station!(net, :q; service=Law(:Exponential, scale=inv(Param(:mu))))
        station!(net, :r; service=Law(:Exponential, scale=inv(Param(:mu))))
        sink!(net, :done)
        route!(net, :arrive, ByMark(InService(:q), [0.5], [:q, :r]))
        route!(net, :q, Always(:done))
        route!(net, :r, Always(:done))
        @test_throws "routing kernel at arrive reads station state; A4 reserves likelihood-bearing decisions for recorded draws (check C5)" compile(
            net
        )

        # 5. Ordering keys are evaluated state-blind at filing time.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(
            net,
            :arrive;
            interarrival=Law(:Exponential, scale=inv(Param(:lambda))),
            mark=MarkLaw(class=Law(:Uniform, a=Const(0.0), b=Const(2.0))),
        )
        station!(
            net,
            :q;
            discipline=Priority(Mark(:class) + InBuffer(:q)),
            service=Law(:Exponential, scale=inv(Param(:mu))),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "discipline ordering key at q reads station state; only the service law of a station may read occupancy (check C5)" compile(
            net
        )

        # 6. Every occupancy read names a declared station.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda))))
        station!(net, :q; service=Law(:Exponential, scale=inv(Param(:mu) * InService(:nowhere))))
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "service law at q reads occupancy of unknown station nowhere (check C5)" compile(
            net
        )

        # 7. ... and that station must be a station: sources, sinks, forks, and
        # joins hold no jobs to count.
        net = QueueNetwork(param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential, scale=inv(Param(:lambda))))
        station!(
            net,
            :q;
            service=Law(:Exponential, scale=inv(Param(:mu) * (Const(1.0) + InService(:arrive)))),
        )
        sink!(net, :done)
        route!(net, :arrive, Always(:q))
        route!(net, :q, Always(:done))
        @test_throws "service law at q reads occupancy of arrive, which is a source, not a station — only stations have in-service and buffer counts (check C5)" compile(
            net
        )
    end

wanted("statedep branch_world refuses and stability skips state readers") &&
    @testset "statedep branch_world refuses and stability skips state readers" begin
        m = birth_death(n -> Param(:mu) * n)
        @test_throws "branchable worlds support state-blind service laws only for now" branch_world(
            m, [1.0, 1.0]; seed=1
        )
        # C4 reports what the combinator values expose and invents nothing: the
        # state-reading station has no static mean service time, so it is
        # skipped, without error and without a fabricated ρ.
        @test Concourse.stability(m, [1.0, 1.0]) == Tuple{Symbol,Float64}[]
    end

wanted("statedep score gradient matches finite differences on birth-death") &&
    @testset "statedep score gradient matches finite differences on birth-death" begin
        m = birth_death(n -> Param(:mu) * n)
        θ = [1.0, 1.0]
        H = 50.0
        R = nreps(400)
        intN(rec) = rec.horizon * time_average(number_in_system, m, rec)
        fs = zeros(R)
        S = zeros(2, R)
        for r in 1:R
            rec = simulate(m, θ, H; seed=8100 + r)
            rm = replay_model(m, rec)
            grec = ClockGradients.gradient_record(rm, rec, θ)
            fs[r] = intN(rec)
            S[:, r] = ClockGradients.score_gradient(rm, θ, grec)
        end
        # E[score] = 0, or the likelihood of the state-dependent segments is wrong.
        for j in 1:2
            @test abs(mean(S[j, :])) / (std(S[j, :]) / sqrt(R)) < 4
        end
        fbar = mean(fs)
        est = [mean((fs .- fbar) .* S[j, :]) for j in 1:2]
        se = [std((fs .- fbar) .* S[j, :]) / sqrt(R) for j in 1:2]
        δ = 0.05
        for j in 1:2
            θp = copy(θ);
            θp[j] += δ
            θm = copy(θ);
            θm[j] -= δ
            diffs = [
                (
                    intN(simulate(m, θp, H; seed=8100 + r)) -
                    intN(simulate(m, θm, H; seed=8100 + r))
                ) / (2δ) for r in 1:R
            ]
            fdest, fdse = mean(diffs), std(diffs) / sqrt(R)
            @test abs(est[j] - fdest) <= 4 * sqrt(se[j]^2 + fdse^2)
        end
    end

wanted("statedep i4 replay reproduces every state-dependent trajectory") &&
    @testset "statedep i4 replay reproduces every state-dependent trajectory" begin
        models = [
            (birth_death(n -> Param(:mu) * n), [2.0, 1.0]),
            (birth_death(n -> Param(:mu) * min(n, Const(3.0))), [2.1, 1.0]),
            (cross_read(), [1.0, 2.0, 0.8, 2.0]),
            (shape_switch(), [1.0, 2.0, 0.5]),
        ]
        for (m, θ) in models
            rec, live = simulate(m, θ, 200.0; seed=61, keep_states=true, debug=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
            # The banked-effort machinery must actually have run for the
            # equality to mean anything.
            @test any(!isempty(st.anchor) for st in live)
            @test any(any(v > 0 for v in values(st.bank)) for st in live)
        end
    end
