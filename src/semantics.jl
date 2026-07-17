# The dynamic semantics: clock families (amendment A2), fire with delta
# derivation (decision D1 as refined by F2 — see event_loop.tex §2.4), and
# the settle cascade with declared unblock policies (decision D2). No
# function here touches the sampler; the deltas are the only channel outward.

const ClockDelta = Tuple{Symbol,ClockKey}   # (:enable | :disable | :reenable, key)

# Amendment A2: the interpreter iterates this registry and hard-codes no
# family. A family is its entry here plus four methods —
# family_station_keys!, family_law, family_fire!, family_memory. Charter
# claim F2 is that adding a family (as :patience was added) changes nothing
# else: clock lifecycle is DERIVED from family_station_keys! at the stations
# a firing touched, never hand-emitted at the state-transition sites.
const CLOCK_FAMILIES = (:arrival, :service, :patience)

function enabled(m::QueueGSMP, st::QueueState)
    ks = ClockKey[]
    for fam in CLOCK_FAMILIES, s in eachindex(m.stations)
        family_station_keys!(ks, Val(fam), m, st, s)
    end
    ks
end

function family_station_keys!(ks, ::Val{:arrival}, m::QueueGSMP, st::QueueState, s::Int)
    m.stations[s].kind == :source && push!(ks, (:arrival, Int32(s), JobId(0)))
    nothing
end

function family_station_keys!(ks, ::Val{:service}, m::QueueGSMP, st::QueueState, s::Int)
    for j in st.srv[s]
        push!(ks, (:service, Int32(s), j))
    end
    nothing
end

# Reneging: a patience clock per WAITING job, at stations that declare a
# patience law. Jobs in service or held blocked have no patience clock.
function family_station_keys!(ks, ::Val{:patience}, m::QueueGSMP, st::QueueState, s::Int)
    m.stations[s].patience === nothing && return nothing
    for j in st.buf[s]
        push!(ks, (:patience, Int32(s), j))
    end
    nothing
end

function clock_distribution(m::QueueGSMP, θ::AbstractVector, key::ClockKey,
                            st::QueueState)
    family_law(Val(key[1]), m, θ, key, st)
end

function family_law(::Val{:arrival}, m, θ, key, st)
    builddist(m.stations[key[2]].service, m.params, θ, NamedTuple(), st.te[key])
end

function family_law(::Val{:service}, m, θ, key, st)
    builddist(m.stations[key[2]].service, m.params, θ, st.jobs[key[3]], st.te[key])
end

function family_law(::Val{:patience}, m, θ, key, st)
    builddist(m.stations[key[2]].patience, m.params, θ, st.jobs[key[3]], st.te[key])
end

# What a disabled-without-firing clock remembers, per family. The generic
# disable pass banks the age for :resume and forgets it for :fresh.
family_memory(::Val{:arrival}, m, key) = :fresh
family_memory(::Val{:service}, m, key) = m.stations[key[2]].discipline.memory
family_memory(::Val{:patience}, m, key) = :fresh

# ---------------------------------------------------------------------------
# fire

"""
    fire_changes(m, st, key, t, draws; worklist) -> (new_state, deltas)

Pure given the draw source: live it records, in replay it reads back. Deltas
are DERIVED, not emitted: for every station the firing's cascade touched,
each family's enabled keys are diffed between the old and new state, so a
clock's lifecycle follows from membership alone and a new family needs no
plumbing. A clock enabled and disabled within one firing never reaches the
sampler — the GSMP has no zero-duration clocks. Enabling-time and banked-age
bookkeeping (amendment A1) happens in the same pass, in one place.
"""
function fire_changes(m::QueueGSMP, st::QueueState, key::ClockKey, t::Float64,
                      draws::DrawSource; worklist::Symbol=:fifo)
    old = st
    st = copystate(st)
    st.time = t
    st.nfired += 1
    delete!(st.te, key)
    wl = Int[]
    touched = Set{Int}([Int(key[2])])
    family_fire!(Val(key[1]), m, st, key, t, draws, wl, touched)
    run_cascade!(m, st, t, draws, wl, touched, worklist)
    deltas = derive_deltas!(m, old, st, key, t, touched)
    st, deltas
end

function derive_deltas!(m::QueueGSMP, old::QueueState, new::QueueState,
                        fired::ClockKey, t::Float64, touched::Set{Int})
    deltas = ClockDelta[]
    for s in sort!(collect(touched))
        for fam in CLOCK_FAMILIES
            a = ClockKey[]
            family_station_keys!(a, Val(fam), m, old, s)
            b = ClockKey[]
            family_station_keys!(b, Val(fam), m, new, s)
            aset = Set(a)
            bset = Set(b)
            for k in a
                (k in bset || k == fired) && continue
                if family_memory(Val(fam), m, k) == :resume
                    new.bank[k] = get(new.bank, k, 0.0) + (t - new.te[k])
                end
                delete!(new.te, k)
                push!(deltas, (:disable, k))
            end
            for k in b
                (k in aset && k != fired) && continue
                new.te[k] = t - get(new.bank, k, 0.0)
                delete!(new.bank, k)
                push!(deltas, (:enable, k))
            end
        end
    end
    deltas
end

function family_fire!(::Val{:arrival}, m, st, key, t, draws, wl, touched)
    _, s, _ = key
    stn = m.stations[s]
    j = st.next_id
    st.next_id += 1
    st.jobs[j] = drawmarks!(draws, stn.mark, t)
    d = routejob!(m, st, Int(s), j, draws)
    deposit!(m, st, Int(s), d, j, wl, touched)
end

function family_fire!(::Val{:service}, m, st, key, t, draws, wl, touched)
    _, s, j = key
    _remove!(st.srv[s], j)
    d = routejob!(m, st, Int(s), j, draws)
    deposit!(m, st, Int(s), d, j, wl, touched)
    push!(wl, Int(s))
end

# A patience firing is an abandonment: the job leaves the waiting line for
# the station's renege destination, and the freed waiting room may admit a
# blocked transfer.
function family_fire!(::Val{:patience}, m, st, key, t, draws, wl, touched)
    _, s, j = key
    _remove!(st.buf[s], j)
    deposit!(m, st, Int(s), Int(m.stations[s].renege), j, wl, touched)
    push!(wl, Int(s))
end

function _remove!(v::Vector, x)
    i = findfirst(==(x), v)
    i === nothing && error("$x not present")
    deleteat!(v, i)
end

# ---------------------------------------------------------------------------
# routing

# Kernel expressions may read marks only: a θ-dependent or time-dependent
# deterministic route would make the routing decision part of the likelihood,
# which A4 reserves for recorded draws. compile-time checks enforce it, so
# evaluation passes θ = nothing and te = 0 safely here.
function routejob!(m::QueueGSMP, st::QueueState, origin::Int, j::JobId,
                   draws::DrawSource)
    k = m.stations[origin].routing
    if k.kind == :always
        Int(k.dests[1])
    elseif k.kind == :bymark
        v = evalexpr(k.expr, m.params, nothing, st.jobs[j], 0.0)
        Int(k.dests[searchsortedfirst(k.cutoffs, v)])
    elseif k.kind == :probabilistic
        u = draw!(draws, :route, Uniform())
        acc = 0.0
        for (i, p) in enumerate(k.probs)
            acc += p
            u <= acc && return Int(k.dests[i])
        end
        Int(k.dests[end])
    elseif k.kind == :roundrobin
        c = st.cursor[origin]
        st.cursor[origin] = mod1(c + 1, length(k.dests))
        Int(k.dests[c])
    else
        error("unknown kernel kind $(k.kind)")
    end
end

# ---------------------------------------------------------------------------
# deposit and the settle cascade — pure state movement; clock lifecycle is
# derived afterwards from the membership these moves imply.

function deposit!(m::QueueGSMP, st::QueueState, origin::Int, d::Int, j::JobId,
                  wl::Vector{Int}, touched::Set{Int})
    push!(touched, d)
    stn = m.stations[d]
    if stn.kind == :sink
        delete!(st.jobs, j)      # the departure remains visible in the record
    elseif stn.kind == :station
        if length(st.buf[d]) >= stn.capacity
            # A source has no server to hold a blocked job, so an external
            # arrival to a full :block station is lost, not blocked.
            if stn.overflow == :block && m.stations[origin].kind == :station
                push!(st.hold[origin], j)
                push!(st.blocked[d], (Int32(origin), j))
                push!(touched, origin)
            else
                delete!(st.jobs, j)
            end
        else
            file_into_buffer!(m, st, d, j)
            push!(wl, d)
        end
    else
        error("cannot route into $(stn.kind) station $(stn.name)")
    end
end

function file_into_buffer!(m::QueueGSMP, st::QueueState, q::Int, j::JobId)
    disc = m.stations[q].discipline
    if disc.insert == :back
        push!(st.buf[q], j)
    elseif disc.insert == :front
        pushfirst!(st.buf[q], j)
    elseif disc.insert == :ordered
        v = _byval(m, st, disc, j)
        # Insert after equal keys: FCFS within a priority class.
        vals = [_byval(m, st, disc, x) for x in st.buf[q]]
        insert!(st.buf[q], searchsortedlast(vals, v) + 1, j)
    else
        error("unknown insert $(disc.insert)")
    end
end

_byval(m, st, disc::Discipline, j::JobId) =
    evalexpr(disc.by, m.params, nothing, st.jobs[j], 0.0)

_freeslots(m, st, q) =
    m.stations[q].servers - length(st.srv[q]) - length(st.hold[q])

function selectjob!(m::QueueGSMP, st::QueueState, q::Int, draws::DrawSource)
    disc = m.stations[q].discipline
    isempty(st.buf[q]) && return nothing
    if disc.select == :front
        popfirst!(st.buf[q])
    elseif disc.select == :random
        u = draw!(draws, :select, Uniform())
        i = clamp(ceil(Int, u * length(st.buf[q])), 1, length(st.buf[q]))
        j = st.buf[q][i]
        deleteat!(st.buf[q], i)
        j
    else
        error("unknown select $(disc.select)")
    end
end

# One settle pass: preempt, dispatch, unblock. Any pass that changes blocking
# or slot occupancy re-enqueues the affected stations; run_cascade! iterates
# to the fixed point.
function settle!(m::QueueGSMP, st::QueueState, q::Int, t::Float64,
                 draws::DrawSource, wl::Vector{Int}, touched::Set{Int})
    stn = m.stations[q]
    stn.kind == :station || return
    disc = stn.discipline

    # 1. Preemption: a strictly better waiting job (lower ordering key) evicts
    # the worst in-service job when no slot is free. Only :ordered disciplines
    # preempt, so the ordering key exists. What the evicted clock remembers is
    # the family_memory policy, applied when the derived deltas disable it.
    if disc.preempt && disc.by !== nothing
        while _freeslots(m, st, q) == 0 && !isempty(st.buf[q]) && !isempty(st.srv[q])
            wbest = _byval(m, st, disc, st.buf[q][1])
            vi = argmax([_byval(m, st, disc, j) for j in st.srv[q]])
            victim = st.srv[q][vi]
            wbest < _byval(m, st, disc, victim) || break
            deleteat!(st.srv[q], vi)
            file_into_buffer!(m, st, q, victim)
        end
    end

    # 2. Dispatch: fill free slots in discipline order.
    while _freeslots(m, st, q) > 0
        j = selectjob!(m, st, q, draws)
        j === nothing && break
        push!(st.srv[q], j)
    end

    # 3. Unblock: freed waiting room admits blocked transfers, longest-blocked
    # first under FCFSUnblock (D2: the policy is model semantics).
    while !isempty(st.blocked[q]) && length(st.buf[q]) < stn.capacity
        p, j = _pick_unblock!(stn.unblock, st.blocked[q])
        _remove!(st.hold[p], j)
        file_into_buffer!(m, st, q, j)
        push!(wl, q)          # the admitted job may enter service here
        push!(wl, Int(p))     # the origin's server slot is free again
        push!(touched, Int(p))
    end
    nothing
end

_pick_unblock!(::FCFSUnblock, queue::Vector{Tuple{Int32,JobId}}) = popfirst!(queue)

# F9's claim is that FIFO and LIFO reach the same fixed point because
# contention lives in UnblockPolicy, not in this order. The fuel bound turns a
# blocking cycle (excluded statically by C3) into an error instead of a hang.
function run_cascade!(m::QueueGSMP, st::QueueState, t::Float64,
                      draws::DrawSource, wl::Vector{Int}, touched::Set{Int},
                      order::Symbol)
    fuel = 10 * (length(st.jobs) + length(m.stations) + 10)
    while !isempty(wl)
        q = order == :fifo ? popfirst!(wl) : pop!(wl)
        push!(touched, q)
        settle!(m, st, q, t, draws, wl, touched)
        fuel -= 1
        fuel >= 0 || error("settle cascade did not reach a fixed point")
    end
    nothing
end
