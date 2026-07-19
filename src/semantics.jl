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

"""
    enabled(m::QueueGSMP, st::QueueState) -> Vector{ClockKey}

The keys of every clock enabled in state `st`, derived from the state
alone: one `:arrival` clock per source, one `:service` clock per job in
service, and one `:patience` clock per waiting job at a station with a
patience law. One of the five contract functions. The interpreter's debug
oracle recomputes this set after every firing and compares it against the
sampler.
"""
function enabled(m::QueueGSMP, st::QueueState)
    ks = ClockKey[]
    for fam in CLOCK_FAMILIES, s in eachindex(m.stations)
        family_station_keys!(ks, Val(fam), m, st, s)
    end
    return ks
end

function family_station_keys!(ks, ::Val{:arrival}, m::QueueGSMP, st::QueueState, s::Int)
    m.stations[s].kind == :source && push!(ks, (:arrival, Int32(s), JobId(0)))
    return nothing
end

function family_station_keys!(ks, ::Val{:service}, m::QueueGSMP, st::QueueState, s::Int)
    for j in st.srv[s]
        push!(ks, (:service, Int32(s), j))
    end
    return nothing
end

# Reneging: a patience clock per WAITING job, at stations that declare a
# patience law. Jobs in service or held blocked have no patience clock.
function family_station_keys!(ks, ::Val{:patience}, m::QueueGSMP, st::QueueState, s::Int)
    m.stations[s].patience === nothing && return nothing
    for j in st.buf[s]
        push!(ks, (:patience, Int32(s), j))
    end
    return nothing
end

"""
    clock_distribution(m::QueueGSMP, θ, key::ClockKey, st::QueueState) -> Distribution

The firing-time distribution of clock `key` in state `st`, measured from
the clock's enabling time `st.te[key]`. The clock's law is evaluated with
the parameter vector `θ`, the owning job's marks, and the enabling time.
Under [`ProcessorSharing`](@ref) the returned distribution also folds in
the banked age, the current speed, and the anchor of the last speed change.
One of the five contract functions.

The result's element type follows `eltype(θ)`, so a dual-number-valued `θ`
flows through untouched — the seam ClockGradients.jl differentiates
through.
"""
function clock_distribution(m::QueueGSMP, θ::AbstractVector, key::ClockKey, st::QueueState)
    return family_law(Val(key[1]), m, θ, key, st)
end

function family_law(::Val{:arrival}, m, θ, key, st)
    # An :arrival clock exists only for a source, and every source is
    # compiled with its interarrival law in the service slot.
    return builddist(
        m.stations[key[2]].service::AbstractLaw, m.params, θ, NamedTuple(), st.te[key], NOSTATE
    )
end

# The wall-time law of a shared job, anchored at the ORIGINAL te: given
# internal age `age` banked at the last speed change (wall offset `shift` =
# anchor − te) and current speed `speed`, the clock fires at wall age
# shift + (X − age)/speed with X ~ base conditioned on X > age. Implemented
# directly instead of composing Distributions' truncated/affine wrappers:
# Truncated's logccdf produces NaN ForwardDiff partials through its stored
# upper-bound constants, and every method here is an explicit two-call
# delegation to the base law, dual-clean by construction.
struct SharedRemaining{D<:UnivariateDistribution} <: ContinuousUnivariateDistribution
    base::D
    age::Float64
    speed::Float64
    shift::Float64
end

_sr_x(d::SharedRemaining, x) = d.age + d.speed * (x - d.shift)

function Distributions.logccdf(d::SharedRemaining, x::Real)
    norm = logccdf(d.base, d.age)
    x <= d.shift && return zero(norm)
    return logccdf(d.base, _sr_x(d, x)) - norm
end
Distributions.ccdf(d::SharedRemaining, x::Real) = exp(logccdf(d, x))
Distributions.cdf(d::SharedRemaining, x::Real) = -expm1(logccdf(d, x))
Distributions.logcdf(d::SharedRemaining, x::Real) = log(cdf(d, x))

function Distributions.logpdf(d::SharedRemaining, x::Real)
    norm = logccdf(d.base, d.age)
    x < d.shift && return oftype(norm, -Inf)
    return log(d.speed) + logpdf(d.base, _sr_x(d, x)) - norm
end
Distributions.pdf(d::SharedRemaining, x::Real) = exp(logpdf(d, x))

function Distributions.invlogccdf(d::SharedRemaining, lp::Real)
    return d.shift + (invlogccdf(d.base, lp + logccdf(d.base, d.age)) - d.age) / d.speed
end
Distributions.quantile(d::SharedRemaining, q::Real) = invlogccdf(d, log1p(-q))
Distributions.cquantile(d::SharedRemaining, q::Real) = invlogccdf(d, log(q))
Base.rand(rng::Random.AbstractRNG, d::SharedRemaining) = invlogccdf(d, -randexp(rng))
Base.minimum(d::SharedRemaining) = d.shift
Base.maximum(d::SharedRemaining) = Inf
Distributions.insupport(d::SharedRemaining, x::Real) = x >= d.shift
# θ enters only through the base law; age/speed/shift are θ-free state.
Distributions.partype(d::SharedRemaining) = Distributions.partype(d.base)

function family_law(::Val{:service}, m, θ, key, st)
    stn = m.stations[key[2]]
    # Service laws alone may read occupancy (check C5), so this is the one
    # call site that passes a real view; the base law F may change between
    # segments when a watched count changes.
    sv = StateView(st.srv, st.buf, m.names)
    F = builddist(stn.service::AbstractLaw, m.params, θ, st.jobs[key[3]], st.te[key], sv)
    # Law changes compile to mid-flight re-evaluations of this value with
    # te fixed — the contract's segment convention, not a te rewrite. The
    # surviving clock carries its accrued effort `a` in bank/anchor; the new
    # law is the base conditioned on X > a. Under processor sharing the
    # effort also accrues at speed min(1, servers/n); every other station
    # serves at speed 1.
    n = length(st.srv[key[2]])
    r = stn.discipline.name == :ps ? min(1.0, stn.servers / n) : 1.0
    a = get(st.bank, key, 0.0)
    shift = get(st.anchor, key, st.te[key]) - st.te[key]
    (a == 0.0 && r == 1.0 && shift == 0.0) && return F
    return SharedRemaining(F, a, r, shift)
end

function family_law(::Val{:patience}, m, θ, key, st)
    # A :patience clock exists only where compile stored a patience law.
    return builddist(
        m.stations[key[2]].patience::AbstractLaw, m.params, θ, st.jobs[key[3]], st.te[key], NOSTATE
    )
end

# What a disabled-without-firing clock remembers, per family. The generic
# disable pass banks the age for :resume and forgets it for :fresh.
family_memory(::Val{:arrival}, m, key) = :fresh
family_memory(::Val{:service}, m, key) = m.stations[key[2]].discipline.memory
family_memory(::Val{:patience}, m, key) = :fresh

# ---------------------------------------------------------------------------
# fire

"""
    fire_changes(m, st, key, t, draws; worklist=:fifo) -> (new_state, deltas)

Apply the firing of clock `key` at time `t` to state `st` and return the
new state together with the list of clock deltas — `(:enable, k)`,
`(:disable, k)`, or `(:reenable, k)` pairs the sampler must apply. `st` is
not mutated. `draws` is the draw source for auxiliary randomness (marks,
routing, random selection); `worklist` (`:fifo` or `:lifo`) orders the
settle cascade, and both orders reach the same fixed point. One of the five
contract functions; most users reach it through [`simulate`](@ref) and
[`replay`](@ref).

Pure given the draw source: live it records, in replay it reads back. Deltas
are DERIVED, not emitted: for every station the firing's cascade touched,
each family's enabled keys are diffed between the old and new state, so a
clock's lifecycle follows from membership alone and a new family needs no
plumbing. A clock enabled and disabled within one firing never reaches the
sampler — the GSMP has no zero-duration clocks. Enabling-time and banked-age
bookkeeping (amendment A1) happens in the same pass, in one place.
"""
function fire_changes(
    m::QueueGSMP,
    st::QueueState,
    key::ClockKey,
    t::Float64,
    draws::DrawSource;
    worklist::Symbol=:fifo,
)
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
    return st, deltas
end

function derive_deltas!(
    m::QueueGSMP, old::QueueState, new::QueueState, fired::ClockKey, t::Float64, touched::Set{Int}
)
    deltas = ClockDelta[]
    # State-dependent re-evaluation, first pass: every station whose service
    # law watches an occupancy that changed (the compiled srv_readers /
    # buf_readers map, which includes each PS station watching itself) is a
    # reader this firing. Readers join `touched` before the membership loop
    # so their own derived deltas stay consistent; an untouched reader's
    # state is unchanged, so joining adds no spurious diffs and no further
    # readers.
    readers = Set{Int}()
    for s in touched
        length(old.srv[s]) == length(new.srv[s]) || union!(readers, m.srv_readers[s])
        length(old.buf[s]) == length(new.buf[s]) || union!(readers, m.buf_readers[s])
    end
    union!(touched, readers)
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
                    # Bank from the last anchor, not from te: a clock the
                    # re-evaluation pass has touched already banked its
                    # earlier segments.
                    new.bank[k] = get(new.bank, k, 0.0) + (t - get(new.anchor, k, new.te[k]))
                end
                delete!(new.anchor, k)
                delete!(new.te, k)
                push!(deltas, (:disable, k))
            end
            for k in b
                (k in aset && k != fired) && continue
                if family_memory(Val(fam), m, k) == :resume
                    new.te[k] = t - get(new.bank, k, 0.0)
                    delete!(new.bank, k)
                else
                    new.te[k] = t
                    delete!(new.bank, k)
                end
                delete!(new.anchor, k)
                push!(deltas, (:enable, k))
            end
        end
    end
    # Second pass, the one delta kind membership cannot see (event_loop.tex
    # §2.4): a clock whose law changed while it stayed enabled. For each
    # reader, every surviving in-service clock banks the effort accrued at
    # the old speed (min(1, servers/n_old) under PS, 1 elsewhere), moves its
    # anchor to now, keeps te at the original enabling — the segment
    # convention — and tells the sampler to re-evaluate. Newly admitted
    # clocks are owned by the enable pass above; the fired clock is gone.
    # `readers` is a set and each survivor appears once, so a clock is
    # re-enabled at most once per firing however many watched counts changed.
    for r in sort!(collect(readers))
        stn = m.stations[r]
        n_old = length(old.srv[r])
        n_old == 0 && continue           # no survivors to re-evaluate
        speed_old = stn.discipline.name == :ps ? min(1.0, stn.servers / n_old) : 1.0
        for j in new.srv[r]
            j in old.srv[r] || continue
            k = (:service, Int32(r), j)
            k == fired && continue
            new.bank[k] = get(new.bank, k, 0.0) + speed_old * (t - get(new.anchor, k, new.te[k]))
            new.anchor[k] = t
            push!(deltas, (:reenable, k))
        end
    end
    return deltas
end

function family_fire!(::Val{:arrival}, m, st, key, t, draws, wl, touched)
    _, s, _ = key
    stn = m.stations[s]
    j = st.next_id
    st.next_id += 1
    st.jobs[j] = drawmarks!(draws, stn.mark, t)
    d = routejob!(m, st, Int(s), j, draws)
    return deposit!(m, st, Int(s), d, j, wl, touched, draws)
end

function family_fire!(::Val{:service}, m, st, key, t, draws, wl, touched)
    _, s, j = key
    _remove!(st.srv[s], j)
    if haskey(st.batchmembers, j)
        # A batch completion: the synthetic batch job dissolves and each
        # member routes individually on its own marks, in gather order. A
        # member that meets a full :block destination is dropped like a
        # source arrival (holdable = false) — the batch has fired, so there
        # is no server left to hold the member.
        for member in st.batchmembers[j]
            d = routejob!(m, st, Int(s), member, draws)
            deposit!(m, st, Int(s), d, member, wl, touched, draws; holdable=false)
        end
        delete!(st.jobs, j)
        delete!(st.batchmembers, j)
    else
        d = routejob!(m, st, Int(s), j, draws)
        deposit!(m, st, Int(s), d, j, wl, touched, draws)
    end
    return push!(wl, Int(s))
end

# A patience firing is an abandonment: the job leaves the waiting line for
# the station's renege destination, and the freed waiting room may admit a
# blocked transfer.
function family_fire!(::Val{:patience}, m, st, key, t, draws, wl, touched)
    _, s, j = key
    _remove!(st.buf[s], j)
    deposit!(m, st, Int(s), Int(m.stations[s].renege), j, wl, touched, draws)
    return push!(wl, Int(s))
end

function _remove!(v::Vector, x)
    i = findfirst(==(x), v)
    i === nothing && error("$x not present")
    return deleteat!(v, i)
end

# ---------------------------------------------------------------------------
# routing

# Kernel expressions may read marks only: a θ-dependent or time-dependent
# deterministic route would make the routing decision part of the likelihood,
# which A4 reserves for recorded draws. compile-time checks enforce it, so
# evaluation passes θ = nothing and te = 0 safely here.
function routejob!(m::QueueGSMP, st::QueueState, origin::Int, j::JobId, draws::DrawSource)
    k = m.stations[origin].routing
    if k.kind == :always
        Int(k.dests[1])
    elseif k.kind == :bymark
        v = evalexpr(k.expr, m.params, nothing, st.jobs[j], 0.0, NOSTATE)
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

# `holdable` says whether a job that meets a full :block destination may be
# held in the origin's server. Every ordinary deposit is holdable; a batch
# member deposited after its batch fired is not, because the batch job's
# firing already freed the server — there is nothing left to hold the member,
# so it drops like a source arrival.
function deposit!(
    m::QueueGSMP,
    st::QueueState,
    origin::Int,
    d::Int,
    j::JobId,
    wl::Vector{Int},
    touched::Set{Int},
    draws::DrawSource;
    holdable::Bool=true,
)
    push!(touched, d)
    stn = m.stations[d]
    if stn.kind == :sink
        delete!(st.jobs, j)      # the departure remains visible in the record
        delete!(st.group, j)
    elseif stn.kind == :fork
        # Instantaneous split: one sibling per branch, sharing the parent's
        # id as group id. Clock-free, so no family entry is needed — which is
        # itself part of charter claim F7.
        for b in stn.branches
            sib = st.next_id
            st.next_id += 1
            st.jobs[sib] = st.jobs[j]
            st.group[sib] = j
            deposit!(m, st, d, Int(b), sib, wl, touched, draws)
        end
        delete!(st.jobs, j)
    elseif stn.kind == :join
        # Instantaneous synchronization: stash the sibling (it stays a job in
        # the system — a group's sojourn ends only at the merge); release one
        # merged job through the join's route when all parts have arrived.
        g = get(st.group, j, JobId(0))
        g == 0 && error("job $j reached join $(stn.name) without a fork group")
        sibs = get!(st.pending[d], g, JobId[])
        push!(sibs, j)
        if length(sibs) == stn.parts
            merged = st.next_id
            st.next_id += 1
            st.jobs[merged] = st.jobs[j]
            for sib in sibs
                delete!(st.jobs, sib)
                delete!(st.group, sib)
            end
            delete!(st.pending[d], g)
            d2 = routejob!(m, st, d, merged, draws)
            deposit!(m, st, d, d2, merged, wl, touched, draws)
        end
    elseif stn.kind == :station
        if length(st.buf[d]) >= stn.capacity
            # A source has no server to hold a blocked job, so an external
            # arrival to a full :block station is lost, not blocked.
            if holdable && stn.overflow == :block && m.stations[origin].kind == :station
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
        v = _ordval(m, st, disc, q, j)
        # Insert after equal keys: FCFS within a priority class.
        vals = [_ordval(m, st, disc, q, x) for x in st.buf[q]]
        insert!(st.buf[q], searchsortedlast(vals, v) + 1, j)
    else
        error("unknown insert $(disc.insert)")
    end
end

function _byval(m, st, disc::Discipline, j::JobId)
    return evalexpr(disc.by, m.params, nothing, st.jobs[j], 0.0, NOSTATE)
end

function _ordval(m, st, disc::Discipline, q::Int, j::JobId)
    v = _byval(m, st, disc, j)
    disc.name == :srpt || return v
    k = (:service, Int32(q), j)
    haskey(st.te, k) && return v - (st.time - st.te[k])
    return v - get(st.bank, k, 0.0)
end

# Under processor sharing every job is in service; `servers` is the shared
# capacity in the speed min(1, servers/n), not a slot count.
_freeslots(m, st, q) =
    if m.stations[q].discipline.name == :ps
        typemax(Int)
    else
        m.stations[q].servers - length(st.srv[q]) - length(st.hold[q])
    end

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
function settle!(
    m::QueueGSMP,
    st::QueueState,
    q::Int,
    t::Float64,
    draws::DrawSource,
    wl::Vector{Int},
    touched::Set{Int},
)
    stn = m.stations[q]
    stn.kind == :station || return nothing
    disc = stn.discipline

    # 1. Preemption: a strictly better waiting job (lower ordering key) evicts
    # the worst in-service job when no slot is free. Only :ordered disciplines
    # preempt, so the ordering key exists. What the evicted clock remembers is
    # the family_memory policy, applied when the derived deltas disable it.
    if disc.preempt && disc.by !== nothing
        while _freeslots(m, st, q) == 0 && !isempty(st.buf[q]) && !isempty(st.srv[q])
            wbest = _ordval(m, st, disc, q, st.buf[q][1])
            vi = argmax([_ordval(m, st, disc, q, j) for j in st.srv[q]])
            victim = st.srv[q][vi]
            wbest < _ordval(m, st, disc, q, victim) || break
            deleteat!(st.srv[q], vi)
            file_into_buffer!(m, st, q, victim)
        end
    end

    # 2. Dispatch: fill free slots in discipline order. A batching station
    # instead gathers waiting jobs into a synthetic batch job: once at least
    # `min` jobs wait, a free server takes up to `max` of them in discipline
    # order (draw-free under FCFS, the only discipline C6 admits), and one
    # fresh job id carrying the mark `batchsize` enters service for them.
    # Members leave the buffer but stay in st.jobs, keyed through
    # st.batchmembers — like stashed join siblings, they are still in the
    # system. With fewer than `min` waiting, the server idles; no clock is
    # needed for the forming batch because arrivals re-run settle.
    b = stn.batching
    if b === nothing
        while _freeslots(m, st, q) > 0
            j = selectjob!(m, st, q, draws)
            j === nothing && break
            push!(st.srv[q], j)
        end
    else
        while _freeslots(m, st, q) > 0 && length(st.buf[q]) >= b.min
            k = min(length(st.buf[q]), b.max)
            members = JobId[]
            for _ in 1:k
                push!(members, selectjob!(m, st, q, draws))
            end
            batch = st.next_id
            st.next_id += 1
            st.jobs[batch] = (batchsize=Float64(k),)
            st.batchmembers[batch] = members
            push!(st.srv[q], batch)
        end
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
    return nothing
end

_pick_unblock!(::FCFSUnblock, queue::Vector{Tuple{Int32,JobId}}) = popfirst!(queue)

# F9's claim is that FIFO and LIFO reach the same fixed point because
# contention lives in UnblockPolicy, not in this order. The fuel bound turns a
# blocking cycle (excluded statically by C3) into an error instead of a hang.
function run_cascade!(
    m::QueueGSMP,
    st::QueueState,
    t::Float64,
    draws::DrawSource,
    wl::Vector{Int},
    touched::Set{Int},
    order::Symbol,
)
    fuel = 10 * (length(st.jobs) + length(m.stations) + 10)
    while !isempty(wl)
        q = order == :fifo ? popfirst!(wl) : pop!(wl)
        push!(touched, q)
        settle!(m, st, q, t, draws, wl, touched)
        fuel -= 1
        fuel >= 0 || error("settle cascade did not reach a fixed point")
    end
    return nothing
end
