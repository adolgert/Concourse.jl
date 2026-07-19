# Batch service (capability 2, check C6): a station may gather waiting jobs
# into a synthetic batch job served by one clock whose law may read the mark
# batchsize; on completion the members route individually, and a member that
# meets a full :block destination is dropped. The degenerate test pins the
# batch path to the plain FCFS record; the oracles are a truncated-CTMC
# M/M^[K]/1 solution and Inoue (2021)'s closed-form mean-latency bound, both
# computed here from scratch with linear algebra shared with nothing in src/.

using Distributions: Poisson, pdf

# The plain single-server FCFS station with a Dirac service time `v` — the
# batch-free twin of batch_mmk1(min = 1, max = 1, Dirac service).
function plain_dirac(v)
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :gate; service=Law(:Dirac; value=Const(v)))
    sink!(net, :done)
    route!(net, :arrive, Always(:gate))
    route!(net, :gate, Always(:done))
    return compile(net)
end

# Members renege while a batch is forming: slow arrivals against min = 3 and
# short exponential patience, abandonments to their own sink.
function batch_reneging()
    net = QueueNetwork(; param_names=(:lambda, :mu, :gamma))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(
        net,
        :gate;
        service=Law(:Exponential; scale=inv(Param(:mu))),
        batching=Batching(; min=3, max=6),
        patience=Law(:Exponential; scale=inv(Param(:gamma))),
        renege_to=:lost,
    )
    sink!(net, :done)
    sink!(net, :lost)
    route!(net, :arrive, Always(:gate))
    route!(net, :gate, Always(:done))
    return compile(net)
end

# Batch members route to a downstream :block station with one server and one
# waiting slot: a firing batch of 2..4 members must drop the surplus.
function batch_blocking()
    net = QueueNetwork(; param_names=(:lambda, :mu1, :mu2))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(
        net,
        :gate;
        service=Law(:Exponential; scale=inv(Param(:mu1))),
        batching=Batching(; min=2, max=4),
    )
    station!(
        net, :down; service=Law(:Exponential; scale=inv(Param(:mu2))), capacity=1, overflow=:block
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:gate))
    route!(net, :gate, Always(:down))
    route!(net, :down, Always(:done))
    return compile(net)
end

# Exact M/M^[K]/1 under the full-batch policy (min = max = K): the CTMC on
# (waiting count q, server busy s). Arrivals at rate λ; a completion at rate
# μ gathers the next K waiting jobs when q >= K and idles the server
# otherwise; an arrival that brings q to K while the server idles starts a
# batch at once, emptying the buffer. Truncated at Q waiting jobs and solved
# as a plain linear system — this oracle never touches the simulator, only a
# generator matrix the simulator never sees. Returns (E[number in system],
# E[number at the station]), where the station count sees the batch as ONE
# resident (the srv vector holds the synthetic job) while the system count
# sees its K members.
function mmk1_exact(λ, μ, K; Q=400)
    idle(q) = q + 1                 # q = 0..K-1, server idle
    busy(q) = K + 1 + q             # q = 0..Q, server holds a K-batch
    n = K + Q + 1
    G = zeros(n, n)
    for q in 0:(K - 1)
        G[idle(q), q == K - 1 ? busy(0) : idle(q + 1)] += λ
    end
    for q in 0:Q
        q < Q && (G[busy(q), busy(q + 1)] += λ)
        G[busy(q), q >= K ? busy(q - K) : idle(q)] += μ
    end
    for i in 1:n
        G[i, i] = -sum(G[i, :])
    end
    π = [G'; ones(1, n)] \ [zeros(n); 1.0]
    nsys = sum(q * π[idle(q)] for q in 0:(K - 1))
    nat = nsys
    nsys += sum((q + K) * π[busy(q)] for q in 0:Q)
    nat += sum((q + 1) * π[busy(q)] for q in 0:Q)
    return nsys, nat
end

# Inoue (2021), arXiv:1912.06322 — gather-everything batching (an idle
# server takes ALL waiting jobs, i.e. Batching(min = 1, max = typemax)) with
# deterministic batch processing time τ[b] = α b + τ₀ (Assumption 4).
# Exact oracle: the processed batch sizes form the Markov chain
# B_{n+1} = A_n + 1{A_n = 0} with A_n | B_n = b ~ Poisson(λ(αb + τ₀))
# (eqs. 3–5); its stationary distribution, truncated and solved by linear
# algebra, gives E[B] and E[B²], and eq. 36 gives the exact mean latency
#   E[W] = α + τ₀ + (1 + 2λα)(E[B²] − E[B]) / (2λ E[B]).
# Closed-form oracle: Theorem 2's upper bounds
#   φ₀ = (α+τ₀)/(2(1−λα)) · (1 + 2λτ₀ + (1−λτ₀)/(1+λα))        (eq. 41)
#   φ₁ = (3/2)·τ₀/(1−λα) + (α/2)·(λα+2)/(1−λ²α²)               (eq. 42)
# with E[W] <= min(φ₀, φ₁). Both are independent of the simulator: nothing
# here but Poisson pmfs and a linear solve.
function inoue_exact(λ, α, τ0; B=200)
    M = zeros(B, B)                 # transposed transition matrix minus I
    for b in 1:B
        A = Poisson(λ * (α * b + τ0))
        row = zeros(B)
        row[1] = pdf(A, 0) + pdf(A, 1)
        for k in 2:(B - 1)
            row[k] = pdf(A, k)
        end
        row[B] = max(0.0, 1.0 - sum(row))
        for k in 1:B
            M[k, b] += row[k]
        end
        M[b, b] -= 1.0
    end
    π = [M; ones(1, B)] \ [zeros(B); 1.0]
    EB = sum(b * π[b] for b in 1:B)
    EB2 = sum(b^2 * π[b] for b in 1:B)
    EW = α + τ0 + (1 + 2 * λ * α) * (EB2 - EB) / (2 * λ * EB)
    φ0 = (α + τ0) / (2 * (1 - λ * α)) * (1 + 2 * λ * τ0 + (1 - λ * τ0) / (1 + λ * α))
    φ1 = 1.5 * τ0 / (1 - λ * α) + (α / 2) * (λ * α + 2) / (1 - λ^2 * α^2)
    return EW, min(φ0, φ1)
end

# Per-member latency, folded from the record: a member's entry is its source
# firing (the created id is the pre-firing next_id) and its exit is its
# BATCH's service firing, so membership is read from st.batchmembers just
# before the batch job is deleted — the b_sojourns pattern. Members still in
# the system at the horizon are excluded.
function batch_latencies(m, rec)
    src = m.names[:arrive]
    g = m.names[:gate]
    st = Concourse.initial_state(m)
    entry = Dict{Int64,Float64}()
    lat = Float64[]
    for i in eachindex(rec.key)
        key = rec.key[i]
        key[1] == :arrival && Int(key[2]) == src && (entry[st.next_id] = rec.time[i])
        if key[1] == :service && Int(key[2]) == g && haskey(st.batchmembers, key[3])
            for member in st.batchmembers[key[3]]
                push!(lat, rec.time[i] - entry[member])
            end
        end
        ds = Concourse.replaydraws(key, rec.draws[i], m.params)
        st, _ = fire_changes(m, st, key, rec.time[i], ds)
    end
    return lat
end

wanted("batch degenerate min=max=1 reproduces the plain fcfs station") &&
    @testset "batch degenerate min=max=1 reproduces the plain fcfs station" begin
        # Firing-time streams are keyed by clock key and batch ids are
        # minted, so literal record equality holds under a Dirac service law
        # (the service stream's draws never reach the firing time); the
        # exponential twin below is compared distributionally instead.
        θ = [1.0, 1.0]              # ρ = 0.8 under Dirac(0.8) service
        H = 400.0
        mb = batch_mmk1(; min=1, max=1, service=Law(:Dirac; value=Const(0.8)))
        mp = plain_dirac(0.8)
        rb = simulate(mb, θ, H; seed=11, debug=true)
        rp = simulate(mp, θ, H; seed=11, debug=true)
        @test length(rb) == length(rp)
        @test rb.time == rp.time
        @test rb.draws == rp.draws
        @test [(k[1], k[2]) for k in rb.key] == [(k[1], k[2]) for k in rp.key]
        # ... and the job-id slot is the ONLY divergence: batch ids are
        # minted alongside member ids, so the raw keys cannot coincide.
        @test rb.key != rp.key
        sb = replay(mb, rb)
        sp = replay(mp, rp)
        @test [number_in_system(s) for s in sb] == [number_in_system(s) for s in sp]
        gb = Concourse.number_at(mb.names[:gate])
        gp = Concourse.number_at(mp.names[:gate])
        @test [gb(s) for s in sb] == [gp(s) for s in sp]
        # Exponential service: the arrival subsequence still matches, the
        # service draws come from differently keyed streams, so compare the
        # mean number in system against the plain M/M/1 distributionally.
        me = batch_mmk1(; min=1, max=1)
        mpe = mm1()
        θe = [1.0, 2.0]
        estb, seb = replicate(r -> time_average(number_in_system, me, r), me, θe, 500.0, nreps(16))
        estp, sep = replicate(
            r -> time_average(number_in_system, mpe, r), mpe, θe, 500.0, nreps(16)
        )
        @test abs(estb - estp) <= 4 * sqrt(seb^2 + sep^2)
    end

wanted("batch oracle m/m^[k]/1 fixed batch matches the truncated ctmc") &&
    @testset "batch oracle m/m^[k]/1 fixed batch matches the truncated ctmc" begin
        K = 3
        θ = [2.0, 1.0]              # ρ = λ/(Kμ) = 2/3
        m = batch_mmk1(; min=K, max=K)
        nsys, nat = mmk1_exact(θ[1], θ[2], K)
        est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 2000.0, nreps(16))
        @test within4se(est, se, nsys)
        g = Concourse.number_at(m.names[:gate])
        esta, sea = replicate(r -> time_average(g, m, r), m, θ, 2000.0, nreps(16))
        @test within4se(esta, sea, nat)
    end

wanted("batch oracle inoue gather-all latency meets the closed-form bound") &&
    @testset "batch oracle inoue gather-all latency meets the closed-form bound" begin
        # The paper's own parameter point: the Tesla V100 fit α = 0.1438,
        # τ₀ = 1.8874 (§3.3, Fig. 4a) at normalized load ρ = λα = 0.5.
        α, τ0 = 0.1438, 1.8874
        λ = 0.5 / α
        exact, bound = inoue_exact(λ, α, τ0)
        @test exact <= bound        # oracle self-consistency (Theorem 2)
        m = batch_mmk1(;
            min=1,
            max=typemax(Int),
            service=Law(:Dirac; value=Const(τ0) + Const(α) * Mark(:batchsize)),
        )
        θ = [λ, 1.0]                # μ is declared but unread by the Dirac law
        est, se = replicate(r -> mean(batch_latencies(m, r)), m, θ, 3000.0, nreps(12); seed0=700)
        # The headline claim: simulated mean latency never beats the bound
        # by more than noise ...
        @test est <= bound + 4 * se
        # ... and the spot check against the exact chain solution, which at
        # ρ = 0.5 sits just below φ₁ (Fig. 4a's simulation curve).
        @test within4se(est, se, exact)
    end

wanted("batch reneging members abandon a forming batch and counts conserve") &&
    @testset "batch reneging members abandon a forming batch and counts conserve" begin
        m = batch_reneging()
        θ = [1.0, 1.0, 1.0]         # arrivals slow against min = 3, patience short
        rec = simulate(m, θ, 2000.0; seed=23, debug=true)
        g = m.names[:gate]
        st = Concourse.initial_state(m)
        arrivals = served = reneged = nbatch = 0
        sizes_ok = true
        for i in eachindex(rec.key)
            key = rec.key[i]
            key[1] == :arrival && (arrivals += 1)
            key[1] == :patience && Int(key[2]) == g && (reneged += 1)
            if key[1] == :service && Int(key[2]) == g
                members = st.batchmembers[key[3]]
                k = length(members)
                sizes_ok &= 3 <= k <= 6 && st.jobs[key[3]].batchsize == Float64(k)
                served += k
                nbatch += 1
            end
            ds = Concourse.replaydraws(key, rec.draws[i], m.params)
            st, _ = fire_changes(m, st, key, rec.time[i], ds)
        end
        @test nbatch > 20           # batches genuinely formed
        @test reneged > 20          # reneging genuinely competed with them
        @test sizes_ok              # every batch fired with min <= size <= max
        # Exact census: every arrival was served in a batch, reneged, or is
        # still in the system (waiting or gathered into a live batch).
        @test arrivals == served + reneged + number_in_system(st)
    end

wanted("batch members meeting a full :block destination are dropped") &&
    @testset "batch members meeting a full :block destination are dropped" begin
        m = batch_blocking()
        θ = [1.5, 1.2, 1.0]
        rec = simulate(m, θ, 1000.0; seed=31, debug=true)   # completing = no wedge
        g = m.names[:down]
        gate = m.names[:gate]
        st = Concourse.initial_state(m)
        arrivals = sunk = dropped = 0
        holds_empty = true
        for i in eachindex(rec.key)
            key = rec.key[i]
            key[1] == :arrival && (arrivals += 1)
            key[1] == :service && Int(key[2]) == g && (sunk += 1)
            members = key[1] == :service && Int(key[2]) == gate ? st.batchmembers[key[3]] : Int64[]
            ds = Concourse.replaydraws(key, rec.draws[i], m.params)
            st, _ = fire_changes(m, st, key, rec.time[i], ds)
            # A member missing from the post-firing state was dropped at the
            # full :block destination — after the batch fired, no server was
            # left to hold it.
            dropped += count(j -> !haskey(st.jobs, j), members)
            holds_empty &= all(isempty, st.hold)
        end
        @test dropped > 0
        @test holds_empty           # nothing is ever held: members drop instead
        @test arrivals == sunk + dropped + number_in_system(st)
    end

wanted("batch i4 replay and debug membership on every batch model") &&
    @testset "batch i4 replay and debug membership on every batch model" begin
        models = [
            (batch_mmk1(; min=1, max=1, service=Law(:Dirac; value=Const(0.8))), [1.0, 1.0]),
            (batch_mmk1(; min=1, max=1), [1.0, 2.0]),
            (batch_mmk1(; min=3, max=3), [2.0, 1.0]),
            (
                batch_mmk1(;
                    min=1,
                    max=typemax(Int),
                    service=Law(:Dirac; value=Const(1.8874) + Const(0.1438) * Mark(:batchsize)),
                ),
                [3.5, 1.0],
            ),
            (batch_reneging(), [1.0, 1.0, 1.0]),
            (batch_blocking(), [1.5, 1.2, 1.0]),
        ]
        for (m, θ) in models
            rec, live = simulate(m, θ, 300.0; seed=77, keep_states=true, debug=true)
            folded = replay(m, rec)
            @test length(folded) == length(live)
            # states_equal covers batchmembers, so a membership divergence
            # between the live run and the fold cannot hide.
            @test all(states_equal(a, b) for (a, b) in zip(live, folded))
            @test any(st -> !isempty(st.batchmembers), live)   # batching genuinely ran
        end
    end

wanted("batch checks: c6 discipline, batching bounds, batchsize mark scope") &&
    @testset "batch checks: c6 discipline, batching bounds, batchsize mark scope" begin
        @test_throws "Batching needs min >= 1" Batching(; min=0)
        @test_throws "Batching needs min <= max" Batching(; min=3, max=2)

        # C6: batching demands the non-preemptive :back-insert FCFS discipline.
        function c6net(disc)
            net = QueueNetwork(; param_names=(:lambda, :mu))
            source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
            station!(
                net,
                :gate;
                discipline=disc,
                service=Law(:Exponential; scale=inv(Param(:mu))),
                batching=Batching(; min=2, max=2),
            )
            sink!(net, :done)
            route!(net, :arrive, Always(:gate))
            route!(net, :gate, Always(:done))
            return net
        end
        @test_throws "station gate declares batching under the lcfs discipline; batching requires the non-preemptive :back-insert FCFS discipline (check C6)" compile(
            c6net(LCFS())
        )
        @test_throws "station gate declares batching under the ps discipline; batching requires the non-preemptive :back-insert FCFS discipline (check C6)" compile(
            c6net(ProcessorSharing())
        )

        # The batchsize mark is visible to the batch station's own service
        # law: the model compiles, runs, and completes batches.
        m = batch_mmk1(;
            min=2, max=4, service=Law(:Exponential; scale=Const(0.2) * Mark(:batchsize))
        )
        rec = simulate(m, [1.5, 1.0], 100.0; seed=5, debug=true)
        @test any(k -> k[1] == :service, rec.key)

        # C2: a NON-batch station's service law cannot read batchsize.
        net = QueueNetwork(; param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(
            net,
            :gate;
            service=Law(:Exponential; scale=inv(Param(:mu))),
            batching=Batching(; min=2, max=2),
        )
        station!(net, :tail; service=Law(:Exponential; scale=Const(0.1) * Mark(:batchsize)))
        sink!(net, :done)
        route!(net, :arrive, Always(:gate))
        route!(net, :gate, Always(:tail))
        route!(net, :tail, Always(:done))
        @test_throws "law at tail reads mark batchsize no source, populate!, or upstream remark produces" compile(
            net
        )

        # C2: even at a batch station, only the SERVICE law sees batchsize —
        # patience clocks belong to waiting members, which are not batches.
        net = QueueNetwork(; param_names=(:lambda, :mu))
        source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
        station!(
            net,
            :gate;
            service=Law(:Exponential; scale=inv(Param(:mu))),
            batching=Batching(; min=2, max=2),
            patience=Law(:Exponential; scale=Mark(:batchsize)),
            renege_to=:lost,
        )
        sink!(net, :done)
        sink!(net, :lost)
        route!(net, :arrive, Always(:gate))
        route!(net, :gate, Always(:done))
        @test_throws "law at gate reads mark batchsize no source, populate!, or upstream remark produces" compile(
            net
        )
    end
