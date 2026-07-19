# Sibling cancellation (capability 3, checks C7-C9): join!(parts, need,
# cancel) races a fork's siblings and cancels the rest — at the merge under
# :on_completion, at the need-th service entry (buffered siblings only) under
# :on_start. The oracles: (n,1) cancel-on-completion keeps the n branch
# stations in lockstep (siblings are deposited together and canceled
# together), so it IS M/G/1 with service X_{1:n} (Joshi Lemma 1), settled by
# Pollaczek-Khinchine with numerically integrated min-moments; with
# exponential service that is M/M/1 at rate nμ. Cancel-on-start (n,1) is
# exactly M/M/n instead: the fork deposits every sibling into its buffer
# before the cascade settles any station, so the FIRST dispatch is the
# need-th (= 1st) service entry and cancels all its still-buffered siblings —
# exactly one sibling per group ever serves, one logical FCFS queue, n
# servers. The plan's conjecture that :on_start coincides with
# :on_completion under memorylessness is therefore FALSE for the implemented
# need-th-entry semantics, and the M/M/n closed form plus an explicit
# separation test replace it. Cancellation records nothing (I1): every
# statistic here is a fold of fire_changes over the record, and service
# spans — completed and canceled alike — are read from st.te, public for
# exactly this.

using Distributions: Exponential, MixtureModel

# ---------------------------------------------------------------------------
# Oracles computed from scratch.

# Moments of X_{1:n} = min of n iid draws by trapezoid integration of the
# survival function: E[min] = ∫ ccdf(t)^n dt, E[min²] = 2 ∫ t ccdf(t)^n dt.
function min_moments(ccdf1, n, T; N=200_000)
    ts = range(0.0, T; length=N)
    dt = step(ts)
    c = [ccdf1(t)^n for t in ts]
    m1 = (sum(c) - (c[1] + c[end]) / 2) * dt
    tc = ts .* c
    m2 = 2 * (sum(tc) - (tc[1] + tc[end]) / 2) * dt
    return m1, m2
end

# Pollaczek-Khinchine mean sojourn of an M/G/1 queue.
pk_sojourn(λ, EX, EX2) = EX + λ * EX2 / (2 * (1 - λ * EX))

# Exact M/M/c mean sojourn via Erlang C.
function mmc_sojourn(λ, μ, c)
    a = λ / μ
    ρ = a / c
    tail = a^c / (factorial(c) * (1 - ρ))
    C = tail / (sum(a^k / factorial(k) for k in 0:(c - 1)) + tail)
    return 1 / μ + C / (c * μ - λ)
end

# ---------------------------------------------------------------------------
# Record folds for the nk_race model.

# One pass over an nk_race record: group sojourns (fork entry to merge) and
# total branch-server busy time. A group's entry is its arrival firing (the
# created id — the pre-firing next_id — is the group id); its merge is the
# branch service firing that lands the need-th sibling at the join, detected
# as `k - 1` already stashed with the group's roster still open (the roster
# guard keeps an :on_start late finisher, absorbed at the join, from
# counting as a merge). Busy time is measured from st.te spans: a branch
# service span opens when its key appears and closes — own firing or the
# firing whose cascade canceled it — when the key disappears, so canceled
# work counts. Every closed span belongs to a merged group (cancellation and
# absorption both resolve at the merge), so busy/merges is the exact
# per-merged-group server cost E[C].
function race_stats(m, rec, n, k)
    branchset = Set(Int32(m.names[Symbol(:s, i)]) for i in 1:n)
    jn = m.names[:merge]
    st = Concourse.initial_state(m)
    entry = Dict{Int64,Float64}()
    soj = Float64[]
    busy = 0.0
    for i in eachindex(rec.key)
        key = rec.key[i]
        t = rec.time[i]
        key[1] == :arrival && (entry[st.next_id] = t)
        if key[1] == :service && key[2] in branchset
            g = get(st.group, key[3], 0)
            if g != 0 && haskey(st.members, g) && length(get(st.pending[jn], g, Int64[])) == k - 1
                push!(soj, t - entry[g])
            end
        end
        ds = Concourse.replaydraws(key, rec.draws[i], m.params)
        new, _ = fire_changes(m, st, key, t, ds)
        for (kk, t0) in st.te
            kk[1] == :service && kk[2] in branchset || continue
            haskey(new.te, kk) || (busy += t - t0)
        end
        st = new
    end
    return soj, busy
end

race_sojourn(m, rec, n, k) = mean(race_stats(m, rec, n, k)[1])
function race_cost(m, rec, n, k)
    soj, busy = race_stats(m, rec, n, k)
    return busy / length(soj)
end

# ---------------------------------------------------------------------------
# Models beyond the shared nk_race builder.

# A (2,1) race whose fast branch runs through a tiny :block station: fastlane
# (mean 0.125) feeds gate (one server, one waiting slot, mean 6.0), so
# fastlane's finished siblings are routinely held blocked; slow has 16
# parallel servers (mean 1/μ each), so merges arrive OUT of pipeline order
# and a merge often cancels a sibling still sitting in hold/blocked — the
# edge the plan calls likeliest to break. C9 holds: gate hears only fastlane.
function blocked_race()
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    fork!(net, :split; branches=(:fastlane, :slow))
    station!(net, :fastlane; service=Law(:Exponential; scale=Const(0.125)))
    station!(net, :gate; service=Law(:Exponential; scale=Const(6.0)), capacity=1, overflow=:block)
    station!(net, :slow; servers=16, service=Law(:Exponential; scale=inv(Param(:mu))))
    join!(net, :merge; parts=2, need=1, cancel=:on_completion)
    sink!(net, :done)
    route!(net, :arrive, Always(:split))
    route!(net, :fastlane, Always(:gate))
    route!(net, :gate, Always(:merge))
    route!(net, :slow, Always(:merge))
    route!(net, :merge, Always(:done))
    return compile(net)
end

# Nested forks: an outer (2,1) canceling race between a plain station (:left,
# mean 1/μ) and an inner (2,2) fork-join (:ia/:ib, mean 0.6 each). When :left
# wins, the canceled outer sibling is a fork parent whose inner children are
# still live — in service or stashed at :imerge — and cancel_job! must walk
# the members roster recursively. When the inner join wins, its merged
# product inherits the outer group entry and merges the outer join instantly.
function nested_race()
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    fork!(net, :osplit; branches=(:left, :isplit))
    station!(net, :left; service=Law(:Exponential; scale=inv(Param(:mu))))
    fork!(net, :isplit; branches=(:ia, :ib))
    station!(net, :ia; service=Law(:Exponential; scale=Const(0.6)))
    station!(net, :ib; service=Law(:Exponential; scale=Const(0.6)))
    join!(net, :imerge; parts=2)
    join!(net, :omerge; parts=2, need=1, cancel=:on_completion)
    sink!(net, :done)
    route!(net, :arrive, Always(:osplit))
    route!(net, :left, Always(:omerge))
    route!(net, :ia, Always(:imerge))
    route!(net, :ib, Always(:imerge))
    route!(net, :imerge, Always(:omerge))
    route!(net, :omerge, Always(:done))
    return compile(net)
end

# The two non-exponential service laws of the Joshi P-K oracle, as Opaques:
# the sampler needs only logccdf/invlogccdf, which Distributions supplies
# for LocationScale (shifted exponential) and MixtureModel (hyperexponential,
# through the generic numeric quantile).
const SHIFT_Δ, SHIFT_μ = 0.2, 2.0
shifted_exp_law() = Opaque((θ, mk, te) -> SHIFT_Δ + Exponential(1 / SHIFT_μ))
const HYP_P, HYP_μ1, HYP_μ2 = 0.4, 4.0, 1.0
function hyper_exp_law()
    return Opaque(
        (θ, mk, te) ->
            MixtureModel([Exponential(1 / HYP_μ1), Exponential(1 / HYP_μ2)], [HYP_P, 1 - HYP_P]),
    )
end

wanted("cancel joshi p-k oracle: (3,1) on_completion is m/g/1 with min service") &&
    @testset "cancel joshi p-k oracle: (3,1) on_completion is m/g/1 with min service" begin
        n = 3
        H = 1500.0
        laws = [
            (
                shifted_exp_law(),
                t -> t < SHIFT_Δ ? 1.0 : exp(-SHIFT_μ * (t - SHIFT_Δ)),
                SHIFT_Δ + 40 / (n * SHIFT_μ),
                1.5,
                4000,
            ),
            (
                hyper_exp_law(),
                t -> HYP_P * exp(-HYP_μ1 * t) + (1 - HYP_P) * exp(-HYP_μ2 * t),
                20.0,
                3.0,
                5000,
            ),
        ]
        for (i, (law, ccdf1, T, λ, seed0)) in enumerate(laws)
            EX, EX2 = min_moments(ccdf1, n, T)
            if i == 1
                # The integrator on trial against the closed form: the min of
                # n iid shifted exponentials is Δ + Exp(nμ).
                @test isapprox(EX, SHIFT_Δ + 1 / (n * SHIFT_μ); rtol=1e-6)
                @test isapprox(
                    EX2, SHIFT_Δ^2 + 2 * SHIFT_Δ / (n * SHIFT_μ) + 2 / (n * SHIFT_μ)^2; rtol=1e-6
                )
            end
            W = pk_sojourn(λ, EX, EX2)
            m = nk_race(n, 1; service=law, cancel=:on_completion)
            θ = [λ, 0.0]        # μ is declared but unread by the Opaque laws
            est, se = replicate(r -> race_sojourn(m, r, n, 1), m, θ, H, nreps(16); seed0)
            @test within4se(est, se, W)
            # Server-time cost per job, from the record's service spans:
            # every branch serves the head group for exactly X_{1:n} — the
            # winner completes, the canceled leave mid-service — so
            # E[C] = n E[X_{1:n}], canceled work included.
            estc, sec = replicate(r -> race_cost(m, r, n, 1), m, θ, H, nreps(16); seed0)
            @test within4se(estc, sec, n * EX)
        end
    end

wanted("cancel exponential oracles: on_completion pools servers, on_start is m/m/n") &&
    @testset "cancel exponential oracles: on_completion pools servers, on_start is m/m/n" begin
        n = 3
        θ = [1.0, 1.0]
        H = 2000.0
        # Cancel-on-completion keeps the branches in lockstep on the head
        # group: min of n exponentials is Exp(nμ), so the race is M/M/1 at
        # the pooled rate nμ.
        mc = nk_race(n, 1; cancel=:on_completion)
        estc, sec = replicate(r -> race_sojourn(mc, r, n, 1), mc, θ, H, nreps(24); seed0=2000)
        @test within4se(estc, sec, 1 / (n * θ[2] - θ[1]))
        # Cancel-on-start (n,1) is exactly M/M/n: every sibling is buffered
        # before the cascade settles, so the first dispatch cancels the rest
        # and each group is served by exactly one branch server.
        ms = nk_race(n, 1; cancel=:on_start)
        ests, ses = replicate(r -> race_sojourn(ms, r, n, 1), ms, θ, H, nreps(24); seed0=3000)
        @test within4se(ests, ses, mmc_sojourn(θ[1], θ[2], n))
        # The plan conjectured the two coincide by memorylessness; they do
        # not — M/M/n against M/M/1(nμ) — and the separation is the sharper
        # regression: if these ever agree, the :on_start trigger moved.
        @test ests - estc > 4 * sqrt(ses^2 + sec^2)
    end

wanted("cancel (4,2) census: k merged and n-k canceled per group, conserved") &&
    @testset "cancel (4,2) census: k merged and n-k canceled per group, conserved" begin
        n, k = 4, 2
        m = nk_race(n, k; cancel=:on_completion)
        θ = [1.0, 1.2]
        rec = simulate(m, θ, 600.0; seed=13, debug=true)
        branchset = Set(Int32(m.names[Symbol(:s, i)]) for i in 1:n)
        jn = m.names[:merge]
        st = Concourse.initial_state(m)
        arrivals = merges = canceled = minted = 0
        per_merge_ok = true
        census_ok = true
        for i in eachindex(rec.key)
            key = rec.key[i]
            ds = Concourse.replaydraws(key, rec.draws[i], m.params)
            new, _ = fire_changes(m, st, key, rec.time[i], ds)
            if key[1] == :arrival
                arrivals += 1
            elseif key[1] == :service && key[2] in branchset
                # Only a merge mints a job mid-service-firing, and it mints
                # exactly one: the merged job, counted as join throughput.
                minted += new.next_id - st.next_id
                g = get(st.group, key[3], 0)
                if g != 0 &&
                    haskey(st.members, g) &&
                    length(get(st.pending[jn], g, Int64[])) == k - 1
                    merges += 1
                    roster = st.members[g]
                    died = [x for x in roster if !haskey(new.jobs, x)]
                    stashed = st.pending[jn][g]
                    ncanc = count(x -> !(x in stashed) && x != key[3], died)
                    canceled += ncanc
                    # Per merged group: the whole roster of n resolves at
                    # once — the k arrived merge, the n-k others cancel.
                    per_merge_ok &= Set(died) == Set(roster) && ncanc == n - k
                end
            end
            # Global census at every state: n live siblings per unresolved
            # group, none for a merged one (its k merged into a job the sink
            # took and its n-k canceled), and nothing else exists.
            census_ok &= length(new.jobs) == n * (arrivals - merges)
            st = new
        end
        @test merges > 100
        @test per_merge_ok
        @test canceled == (n - k) * merges
        @test minted == merges          # merged completions == join throughput
        @test census_ok
        @test length(st.jobs) == n * (arrivals - merges)
    end

wanted("cancel blocked siblings free their origin server and the cascade refills") &&
    @testset "cancel blocked siblings free their origin server and the cascade refills" begin
        m = blocked_race()
        θ = [1.5, 0.4]
        H = 800.0
        rec = simulate(m, θ, H; seed=7, debug=true)    # debug run to horizon = no wedge
        gate = m.names[:gate]
        fast = m.names[:fastlane]
        slow = m.names[:slow]
        st = Concourse.initial_state(m)
        arrivals = merges = blocked_cancels = refills = 0
        census_ok = unblock_ok = dispatch_ok = true
        last_merge = 0.0
        for i in eachindex(rec.key)
            key = rec.key[i]
            held = Set(j for s in eachindex(st.hold) for j in st.hold[s])
            fastbuf_waiting = !isempty(st.buf[fast])
            ds = Concourse.replaydraws(key, rec.draws[i], m.params)
            new, _ = fire_changes(m, st, key, rec.time[i], ds)
            key[1] == :arrival && (arrivals += 1)
            if key[1] == :service && Int(key[2]) in (gate, slow)
                g = get(st.group, key[3], 0)
                if g != 0 && haskey(st.members, g)
                    merges += 1
                    last_merge = rec.time[i]
                end
            end
            # A held job has no clock, so it can only leave the state by
            # cancellation: gone-from-jobs while held means canceled in
            # hold/blocked.
            gone_held = count(j -> !haskey(new.jobs, j), collect(held))
            if gone_held > 0
                blocked_cancels += gone_held
                # The origin's freed server refills from its buffer in the
                # same cascade.
                fastbuf_waiting &&
                    length(new.srv[fast]) + length(new.hold[fast]) == 1 &&
                    (refills += 1)
            end
            # Settle fixed point: no station rests with a free slot and a
            # waiting job, and freed gate room always admits a blocked
            # transfer before the firing ends.
            for s in (fast, gate, slow)
                dispatch_ok &=
                    isempty(new.buf[s]) ||
                    length(new.srv[s]) + length(new.hold[s]) >= m.stations[s].servers
            end
            unblock_ok &= isempty(new.blocked[gate]) || length(new.buf[gate]) >= 1
            census_ok &= length(new.jobs) == 2 * (arrivals - merges)
            st = new
        end
        @test blocked_cancels > 20      # the edge case genuinely occurred
        @test refills > 10
        @test dispatch_ok
        @test unblock_ok
        @test census_ok
        @test last_merge > 0.9 * H      # merges keep flowing to the horizon
    end

wanted("cancel nested forks recurse and leave no residue") &&
    @testset "cancel nested forks recurse and leave no residue" begin
        m = nested_race()
        θ = [0.8, 2.0]
        rec = simulate(m, θ, 600.0; seed=11, debug=true)
        left = m.names[:left]
        ia, ib = m.names[:ia], m.names[:ib]
        imerge = m.names[:imerge]
        st = Concourse.initial_state(m)
        outer_by_left = live_inner_cancels = inner_merges = drains = 0
        clean = true
        for i in eachindex(rec.key)
            key = rec.key[i]
            ds = Concourse.replaydraws(key, rec.draws[i], m.params)
            new, _ = fire_changes(m, st, key, rec.time[i], ds)
            if key[1] == :service && Int(key[2]) == left
                g = get(st.group, key[3], 0)
                if g != 0 && haskey(st.members, g)
                    outer_by_left += 1
                    # The other roster entry is the isplit-line sibling, a
                    # dead fork parent whose children must be live now and
                    # gone after the recursive cancellation.
                    sib = only(x for x in st.members[g] if x != key[3])
                    if haskey(st.members, sib)
                        kids = st.members[sib]
                        any(x -> haskey(st.jobs, x), kids) && (live_inner_cancels += 1)
                        clean &= all(x -> !haskey(new.jobs, x), kids)
                    end
                end
            end
            if key[1] == :service && Int(key[2]) in (ia, ib)
                g2 = get(st.group, key[3], 0)
                g2 != 0 && length(get(st.pending[imerge], g2, Int64[])) == 1 && (inner_merges += 1)
            end
            # No residue, at every state: rosters and group entries refer
            # only to live jobs or to open fork parents; clock bookkeeping
            # refers only to live jobs; started counters only to open groups.
            clean &= isempty(intersect(keys(new.members), keys(new.jobs)))
            clean &= all(haskey(new.jobs, j) || haskey(new.members, j) for j in keys(new.group))
            clean &= all(
                haskey(new.jobs, x) || haskey(new.members, x) for v in values(new.members) for
                x in v
            )
            clean &= all(k[3] == 0 || haskey(new.jobs, k[3]) for k in keys(new.te))
            clean &= all(haskey(new.jobs, k[3]) for k in keys(new.bank))
            clean &= all(haskey(new.jobs, k[3]) for k in keys(new.anchor))
            clean &= all(haskey(new.members, g) for g in keys(new.started))
            if isempty(new.jobs)
                # The drained system: no jobs means no sibling bookkeeping
                # anywhere — the full-cleanup claim, met between busy periods.
                drains += 1
                clean &=
                    isempty(new.members) &&
                    isempty(new.started) &&
                    all(isempty, new.pending) &&
                    isempty(new.group)
            end
            st = new
        end
        @test outer_by_left > 50        # outer cancellations of a forked sibling
        @test live_inner_cancels > 50   # ... whose inner children were live
        @test inner_merges > 20         # the inner join also wins races
        @test drains > 20               # the no-residue state is genuinely visited
        @test clean
    end

wanted("cancel i4 replay and debug membership on every cancellation model") &&
    @testset "cancel i4 replay and debug membership on every cancellation model" begin
        models = [
            (nk_race(3, 1; service=shifted_exp_law(), cancel=:on_completion), [1.5, 0.0]),
            (nk_race(3, 1; service=hyper_exp_law(), cancel=:on_completion), [3.0, 0.0]),
            (nk_race(3, 1; cancel=:on_completion), [1.0, 1.0]),
            (nk_race(3, 1; cancel=:on_start), [1.0, 1.0]),
            (nk_race(4, 2; cancel=:on_completion), [1.0, 1.2]),
            (nk_race(4, 2; cancel=:on_start), [1.0, 1.2]),
            (blocked_race(), [1.5, 0.4]),
            (nested_race(), [0.8, 2.0]),
        ]
        for (m, θ) in models
            rec, live = simulate(m, θ, 250.0; seed=61, keep_states=true, debug=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            # states_equal covers members and started, so a roster or
            # counter divergence between live and fold cannot hide.
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
            @test any(st -> !isempty(st.members), live)   # racing genuinely ran
        end
    end

wanted("cancel checks: c7-c9 verbatim and join! validation") &&
    @testset "cancel checks: c7-c9 verbatim and join! validation" begin
        # join! validation: parts, need range, cancel symbol.
        net = QueueNetwork(; param_names=(:lambda, :mu))
        @test_throws "a join needs at least two parts" join!(net, :merge; parts=1)
        @test_throws "join merge needs 1 <= need <= parts, got need = 0 with parts = 2" join!(
            net, :merge; parts=2, need=0
        )
        @test_throws "join merge needs 1 <= need <= parts, got need = 4 with parts = 3" join!(
            net, :merge; parts=3, need=4
        )
        @test_throws "join merge: cancel must be :none, :on_completion, or :on_start, got whenever" join!(
            net, :merge; parts=2, need=2, cancel=:whenever
        )

        # C7: need < parts demands a cancellation policy.
        @test_throws "join merge waits for need = 2 of parts = 3 siblings but cancel = :none; a join that merges at need and never cancels would strand the remaining siblings — set cancel = :on_completion or :on_start (check C7)" join!(
            net, :merge; parts=3, need=2
        )

        svc = Law(:Exponential; scale=inv(Param(:mu)))

        # C8: a fork must not reach two canceling joins.
        net = QueueNetwork(; param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        fork!(net, :split; branches=(:a, :b))
        station!(net, :a; service=svc)
        station!(net, :b; service=svc)
        join!(net, :j1; parts=2, need=1, cancel=:on_completion)
        join!(net, :j2; parts=2, need=1, cancel=:on_completion)
        sink!(net, :done)
        route!(net, :arrive, Always(:split))
        route!(net, :a, Always(:j1))
        route!(net, :b, Always(:j2))
        route!(net, :j1, Always(:done))
        route!(net, :j2, Always(:done))
        @test_throws "fork split can reach two canceling joins, j2 and j1; which join triggers a group's cancellation would be ambiguous (check C8)" compile(
            net
        )

        # C9: a tracked interior station takes no outside route...
        net = QueueNetwork(; param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        fork!(net, :split; branches=(:a, :b))
        station!(net, :a; service=svc)
        station!(net, :mid; service=svc)
        station!(net, :b; service=svc)
        station!(net, :outsider; service=svc)
        join!(net, :merge; parts=2, need=1, cancel=:on_completion)
        sink!(net, :done)
        route!(net, :arrive, Always(:split))
        route!(net, :a, Always(:mid))
        route!(net, :mid, Always(:merge))
        route!(net, :b, Always(:merge))
        route!(net, :outsider, Always(:mid))
        route!(net, :merge, Always(:done))
        @test_throws "station outsider routes into mid, which lies on a tracked branch between fork split and canceling join merge; a station on a tracked branch may not also receive non-sibling traffic, so leftover-sibling handling stays unambiguous (check C9)" compile(
            net
        )

        # ... and no outside renege edge either.
        net = QueueNetwork(; param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        fork!(net, :split; branches=(:a, :b))
        station!(net, :a; service=svc)
        station!(net, :mid; service=svc)
        station!(net, :b; service=svc)
        station!(
            net, :flaky; service=svc, patience=Law(:Exponential; scale=Const(1.0)), renege_to=:mid
        )
        join!(net, :merge; parts=2, need=1, cancel=:on_completion)
        sink!(net, :done)
        route!(net, :arrive, Always(:split))
        route!(net, :a, Always(:mid))
        route!(net, :mid, Always(:merge))
        route!(net, :b, Always(:merge))
        route!(net, :flaky, Always(:done))
        route!(net, :merge, Always(:done))
        @test_throws "station flaky routes into mid, which lies on a tracked branch between fork split and canceling join merge; a station on a tracked branch may not also receive non-sibling traffic, so leftover-sibling handling stays unambiguous (check C9)" compile(
            net
        )
    end
