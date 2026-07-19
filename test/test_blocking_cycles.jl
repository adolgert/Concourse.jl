# Capability 5, cyclic blocking: compile's allow_blocking_cycles permits
# :block cycles, and deposit! raises BlockingDeadlock the moment a cycle of
# full buffers actually wedges. Filter these testsets with "cyclic".
#
# The fuel-bound message ("settle cascade did not reach a fixed point...")
# now points at allow_blocking_cycles, but under a cyclic-permitted model the
# precise deadlock check preempts it, so there is no non-fragile way to
# trigger it here; it stays untested by design.

using LinearAlgebra

# ---------------------------------------------------------------------------
# A test-side CTMC of the blocking_loop under BAS semantics, hand-coded from
# the documented transfer-blocking rules (deposit blocks when the buffer is
# full, a held job occupies its origin's server slot, freed room admits the
# held job): state (sA, bA, hA, sB, bB, hB) is per-station in-service flag,
# buffer count, and held-blocked flag. All laws are exponential and routing
# splits are Bernoulli, so the model is a CTMC on this finite state space,
# with the deadlock states collapsed to one absorbing BAS_DEAD.

const BAS_DEAD = (-1, -1, -1, -1, -1, -1)

# The settle fixed point: dispatch free servers, let freed waiting room admit
# the other station's held job. Confluent (F9), so a simple sweep suffices.
function bas_settle(s, capa, capb)
    sA, bA, hA, sB, bB, hB = s
    changed = true
    while changed
        changed = false
        if sA + hA == 0 && bA > 0          # dispatch at A
            sA = 1
            bA -= 1
            changed = true
        end
        if hB == 1 && bA < capa            # room at A admits B's held job
            hB = 0
            bA += 1
            changed = true
        end
        if sB + hB == 0 && bB > 0          # dispatch at B
            sB = 1
            bB -= 1
            changed = true
        end
        if hA == 1 && bB < capb            # room at B admits A's held job
            hA = 0
            bB += 1
            changed = true
        end
    end
    return (sA, bA, hA, sB, bB, hB)
end

function bas_arrival(s, capa, capb)
    sA, bA, hA, sB, bB, hB = s
    bA == capa && return s     # a source arrival to a full :block buffer drops
    return bas_settle((sA, bA + 1, hA, sB, bB, hB), capa, capb)
end

function bas_adone(s, capa, capb)          # requires sA == 1; routes Always to B
    sA, bA, hA, sB, bB, hB = s
    sA = 0
    if bB == capb
        hB == 1 && return BAS_DEAD         # the new a→b edge closes b→a
        hA = 1
    else
        bB += 1
    end
    return bas_settle((sA, bA, hA, sB, bB, hB), capa, capb)
end

function bas_bdone_to_a(s, capa, capb)     # requires sB == 1; routed back to A
    sA, bA, hA, sB, bB, hB = s
    sB = 0
    if bA == capa
        hA == 1 && return BAS_DEAD         # the new b→a edge closes a→b
        hB = 1
    else
        bA += 1
    end
    return bas_settle((sA, bA, hA, sB, bB, hB), capa, capb)
end

function bas_bdone_out(s, capa, capb)      # requires sB == 1; routed to the sink
    sA, bA, hA, sB, bB, hB = s
    return bas_settle((sA, bA, hA, 0, bB, hB), capa, capb)
end

# Enumerate the reachable states from the empty start and build the CTMC
# generator; the last index is the absorbing deadlock state.
function bas_generator(capa, capb, λ, μa, μb, q)
    s0 = bas_settle((0, 0, 0, 0, 0, 0), capa, capb)
    states = [s0]
    index = Dict{NTuple{6,Int},Int}(s0 => 1)
    frontier = [s0]
    edges = Tuple{NTuple{6,Int},NTuple{6,Int},Float64}[]
    while !isempty(frontier)
        s = pop!(frontier)
        outs = Tuple{NTuple{6,Int},Float64}[(bas_arrival(s, capa, capb), λ)]
        s[1] == 1 && push!(outs, (bas_adone(s, capa, capb), μa))
        if s[4] == 1
            push!(outs, (bas_bdone_to_a(s, capa, capb), μb * q))
            push!(outs, (bas_bdone_out(s, capa, capb), μb * (1 - q)))
        end
        for (s2, rate) in outs
            s2 == s && continue
            if !haskey(index, s2) && s2 != BAS_DEAD
                push!(states, s2)
                index[s2] = length(states)
                push!(frontier, s2)
            end
            push!(edges, (s, s2, rate))
        end
    end
    push!(states, BAS_DEAD)
    index[BAS_DEAD] = length(states)
    n = length(states)
    Q = zeros(n, n)
    for (s, s2, rate) in edges
        i, j = index[s], index[s2]
        Q[i, j] += rate
        Q[i, i] -= rate
    end
    return states, Q
end

# Exact expected time average of g over [0, T] from the empty start,
# (1/T) e₁ᵀ (∫₀ᵀ e^{Qt} dt) g, via the augmented-matrix exponential — the
# same estimand as time_average over a horizon-T record, transient included.
function bas_transient_average(Q, g, T)
    n = size(Q, 1)
    A = [Q g; zeros(1, n + 1)]
    return exp(A * T)[1, n + 1] / T
end

# A three-station :block cycle a → b → c → a where the cycle edge b → c sits
# inside a Probabilistic kernel: detection must follow the held job's one
# realized destination, not every kernel destination.
function blocking_triangle(; cap=1, q=0.75, allow_blocking_cycles=true)
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    for s in (:a, :b, :c)
        station!(
            net, s; service=Law(:Exponential; scale=inv(Param(:mu))), capacity=cap, overflow=:block
        )
    end
    sink!(net, :done)
    route!(net, :arrive, Always(:a))
    route!(net, :a, Always(:b))
    route!(net, :b, Probabilistic(:c => q, :done => 1 - q))
    route!(net, :c, Always(:a))
    return compile(net; allow_blocking_cycles)
end

wanted("cyclic blocking deadlock is detected and replays deterministically") &&
    @testset "cyclic blocking deadlock is detected and replays deterministically" begin
        # Tight caps and a load far above the cycle's capacity wedge quickly:
        # λ / ((1 - q) μ) = 16 with one buffer slot per station.
        m = blocking_loop(cap_a=1, cap_b=1, q=0.75)
        θ = [4.0, 1.0, 1.0]
        @test_throws BlockingDeadlock simulate(m, θ, 1000.0; seed=1)
        e = try
            simulate(m, θ, 1000.0; seed=1)
            nothing
        catch err
            err
        end
        @test e isa BlockingDeadlock
        @test length(e.cycle) == 2 && Set(e.cycle) == Set([:a, :b])
        @test e.time > 0
        @test length(e.jobs) == length(e.cycle)
        # The record includes the throwing firing and stops there.
        rec = e.record
        @test rec isa MarkedRecord
        @test rec.horizon == rec.time[end] == e.time
        msg = sprint(showerror, e)
        ring = join(string.(e.cycle), " → ") * " → " * string(e.cycle[1])
        @test occursin("blocking deadlock at t = ", msg)
        @test occursin(ring, msg)
        @test occursin("deadlock resolution is unsupported", msg)
        # Replay determinism: the fold of everything before the throwing firing
        # is clean...
        trunc = MarkedRecord(
            rec.key[1:(end - 1)],
            rec.time[1:(end - 1)],
            rec.draws[1:(end - 1)],
            rec.init,
            rec.time[end - 1],
        )
        @test length(replay(m, trunc)) == length(rec)   # initial state + n-1 firings
        # ...and the full fold re-raises the identical deadlock at the last
        # firing (clean prefix + throwing fold pins the firing count), with no
        # record attached because the throw comes from fire_changes directly.
        @test_throws BlockingDeadlock replay(m, rec)
        e2 = try
            replay(m, rec)
            nothing
        catch err
            err
        end
        @test e2.cycle == e.cycle && e2.time == e.time && e2.jobs == e.jobs
        @test e2.record === nothing
    end

wanted("cyclic blocking non-deadlocking loop matches the ctmc oracle") &&
    @testset "cyclic blocking non-deadlocking loop matches the ctmc oracle" begin
        # Clearly sub-critical: the visit ratio is 1 / (1 - q) = 1.25, so
        # ρ_B = λ / ((1 - q) μ_b) = 0.25 and ρ_A = 0.1875. Blocking of A on B
        # still happens (b's one buffer slot fills), but the wide :a buffer makes
        # the deadlock-closing b → a block essentially unreachable — the CTMC
        # puts the absorption probability below 1e-5 over this horizon, so every
        # replication runs to the horizon and the oracle bias is negligible.
        capa, capb = 10, 1
        λ, μa, μb, q = 0.3, 2.0, 1.5, 0.2
        T = 200.0
        states, Q = bas_generator(capa, capb, λ, μa, μb, q)
        n = length(states)
        @test exp(Q * T)[1, n] < 1e-5          # P(deadlock by T) from the empty start
        gA = [s == BAS_DEAD ? 0.0 : Float64(s[1] + s[2] + s[3]) for s in states]
        gB = [s == BAS_DEAD ? 0.0 : Float64(s[4] + s[5] + s[6]) for s in states]
        exactA = bas_transient_average(Q, gA, T)
        exactB = bas_transient_average(Q, gB, T)
        m = blocking_loop(cap_a=capa, cap_b=capb, q=q)
        θ = [λ, μa, μb]
        nr = nreps(64)
        estA, seA = replicate(
            r -> time_average(Concourse.number_at(m.names[:a]), m, r), m, θ, T, nr
        )
        estB, seB = replicate(
            r -> time_average(Concourse.number_at(m.names[:b]), m, r), m, θ, T, nr
        )
        @test within4se(estA, seA, exactA)
        @test within4se(estB, seB, exactB)
        # The oracle must be tested where blocking actually occurs: over the
        # replication seeds, some state holds a job blocked at :a.
        nhold = 0
        for r in 1:min(nr, 8)
            _, sts = simulate(m, θ, T; seed=1000 + r, keep_states=true)
            nhold += count(st -> !isempty(st.hold[m.names[:a]]), sts)
        end
        @test nhold > 0
    end

wanted("cyclic blocking f9 fifo and lifo agree under cycles") &&
    @testset "cyclic blocking f9 fifo and lifo agree under cycles" begin
        # F9 on a cyclic topology under enough load that both cycle edges block.
        # A deadlock is a state property, so a wedging seed must wedge under both
        # worklist orders with the identical error and record — the trials that
        # wedge are part of the confluence claim, not excluded from it.
        m = blocking_loop(cap_a=2, cap_b=2, q=0.3)
        θ = [0.5, 2.0, 2.0]
        nok = 0
        holds_a = 0
        holds_b = 0
        for trial in 1:12
            outs = map((:fifo, :lifo)) do order
                try
                    rec, sts = simulate(
                        m, θ, 150.0; seed=trial, worklist=order, keep_states=true, debug=true
                    )
                    (:ok, rec, sts)
                catch err
                    err isa BlockingDeadlock || rethrow()
                    (:dead, err, nothing)
                end
            end
            (taga, ra, sa), (tagb, rb, sb) = outs
            @test taga == tagb
            if taga == :ok
                nok += 1
                @test ra.key == rb.key && ra.time == rb.time && ra.draws == rb.draws
                @test all(states_equal(a, b) for (a, b) in zip(sa, sb))
                holds_a += count(st -> !isempty(st.hold[m.names[:a]]), sa)
                holds_b += count(st -> !isempty(st.hold[m.names[:b]]), sa)
            else
                @test ra.cycle == rb.cycle && ra.time == rb.time && ra.jobs == rb.jobs
                @test ra.record.key == rb.record.key &&
                    ra.record.time == rb.record.time &&
                    ra.record.draws == rb.record.draws
            end
        end
        @test nok > 0            # the horizon-reaching half of the claim ran
        @test holds_a > 0        # ...and under actual blocking on both edges
        @test holds_b > 0
    end

wanted("cyclic blocking default compile keeps the c3 rejection") &&
    @testset "cyclic blocking default compile keeps the c3 rejection" begin
        # Without the flag the cyclic net still fails C3 with the existing
        # message, and the acyclic blocking tandem still compiles.
        err = try
            blocking_loop(allow_blocking_cycles=false)
            nothing
        catch e
            e
        end
        @test err isa ArgumentError
        @test occursin("blocking cycle through", err.msg)
        @test occursin("a cycle of full :block buffers is deadlock (check C3)", err.msg)
        @test blocking_tandem() isa QueueGSMP
    end

wanted("cyclic blocking three-station probabilistic cycle names the cycle") &&
    @testset "cyclic blocking three-station probabilistic cycle names the cycle" begin
        @test_throws ArgumentError blocking_triangle(allow_blocking_cycles=false)
        m = blocking_triangle()
        e = try
            simulate(m, [4.0, 1.0], 2000.0; seed=2)
            nothing
        catch err
            err
        end
        @test e isa BlockingDeadlock
        # All three stations, in routing order a → b → c → a, starting from the
        # station whose blocked transfer closed the cycle.
        @test e.cycle in ([:a, :b, :c], [:b, :c, :a], [:c, :a, :b])
        @test length(e.jobs) == 3
    end

wanted("cyclic blocking flag is inert on acyclic nets") &&
    @testset "cyclic blocking flag is inert on acyclic nets" begin
        ma = blocking_tandem(cap=1)
        mb = blocking_tandem(cap=1, allow_blocking_cycles=true)
        @test !ma.allow_blocking_cycles && mb.allow_blocking_cycles
        θ = [2.0, 3.0, 0.7]
        ra = simulate(ma, θ, 300.0; seed=5, debug=true)
        rb = simulate(mb, θ, 300.0; seed=5, debug=true)
        @test ra.key == rb.key && ra.time == rb.time && ra.draws == rb.draws
    end
