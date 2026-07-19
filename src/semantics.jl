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
const CLOCK_FAMILIES = (:arrival, :service, :patience, :round)

"""
    enabled(m::QueueGSMP, st::QueueState) -> Vector{ClockKey}

The keys of every clock enabled in state `st`, derived from the state
alone: one `:arrival` clock per source, one `:service` clock per job in
service, one `:patience` clock per waiting job at a station with a
patience law, and one `:round` clock per round station with a committed
plan. One of the five contract functions. The interpreter's debug
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
    # A round station's active jobs live in srv but hold no per-job clocks;
    # the one :round clock is the server (I2).
    m.stations[s].rounds === nothing || return nothing
    for j in st.srv[s]
        push!(ks, (:service, Int32(s), j))
    end
    return nothing
end

# Round service: one station-level clock per running round, enabled exactly
# while a committed plan sits in the state's roundplan slot (I2 — membership
# is derived from the plan slot, never hand-emitted).
function family_station_keys!(ks, ::Val{:round}, m::QueueGSMP, st::QueueState, s::Int)
    m.stations[s].rounds === nothing && return nothing
    st.roundplan[s] === nothing || push!(ks, (:round, Int32(s), JobId(0)))
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

function family_law(::Val{:round}, m, θ, key, st)
    # The duration law reads the committed plan's aggregates as pseudo-marks
    # (tokens, requests, per-phase sums), frozen at enabling like any mark;
    # check C13 keeps it off job marks and live state.
    plan = st.roundplan[key[2]]::RoundPlan
    r = m.stations[key[2]].rounds::Rounds
    return builddist(r.duration, m.params, θ, plan.aggregates, st.te[key], NOSTATE)
end

# What a disabled-without-firing clock remembers, per family. The generic
# disable pass banks the age for :resume and forgets it for :fresh. A round
# clock never disables without firing — only its own firing clears the plan
# slot — so :fresh is vacuous there.
family_memory(::Val{:arrival}, m, key) = :fresh
family_memory(::Val{:service}, m, key) = m.stations[key[2]].discipline.memory
family_memory(::Val{:patience}, m, key) = :fresh
family_memory(::Val{:round}, m, key) = :fresh

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
                if k[3] != JobId(0) && !haskey(new.jobs, k[3])
                    # The clock's job was canceled or absorbed out of
                    # existence this firing: nothing is banked for a job
                    # that cannot return, and any earlier residue goes with
                    # it — a canceled clock is as clean as a fired one.
                    delete!(new.te, k)
                    delete!(new.bank, k)
                    delete!(new.anchor, k)
                    push!(deltas, (:disable, k))
                    continue
                end
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

# A round completion: credit the plan's allocations against the work
# counters, route every active job whose work is exhausted (holdable =
# false, the batch-member rule — the round's firing IS the server, so
# nothing is left to hold a departure that meets a full :block buffer),
# clear the plan, and push the station so settle re-plans at the same t —
# back-to-back rounds chain with no gap. Work-conservation is the policy's
# business, not the engine's.
function family_fire!(::Val{:round}, m, st, key, t, draws, wl, touched)
    _, s, _ = key
    plan = st.roundplan[Int(s)]::RoundPlan
    for (j, av) in plan.alloc
        w = get(st.work, j, nothing)
        w === nothing && continue          # the job was canceled mid-round
        for p in eachindex(av)
            w[p] -= av[p]
        end
    end
    for j in copy(st.srv[s])
        all(==(0), st.work[j]) || continue
        _remove!(st.srv[s], j)
        delete!(st.work, j)
        d = routejob!(m, st, Int(s), j, draws)
        deposit!(m, st, Int(s), d, j, wl, touched, draws; holdable=false)
    end
    st.roundplan[Int(s)] = nothing
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
    elseif k.kind == :shortestqueue
        # Deterministic state-reading routing (capability 8): the smallest
        # occupancy wins, ties to the lowest station index. A4 admits it
        # because a deterministic function of state bears no likelihood —
        # nothing is drawn, nothing is recorded, and replay reproduces the
        # decision from the folded state (I1, I4).
        best = Int(k.dests[1])
        bestocc = _jsq_occupancy(m, st, best, k.by)
        for i in 2:length(k.dests)
            d = Int(k.dests[i])
            occ = _jsq_occupancy(m, st, d, k.by)
            if occ < bestocc || (occ == bestocc && d < best)
                best, bestocc = d, occ
            end
        end
        best
    else
        error("unknown kernel kind $(k.kind)")
    end
end

# ShortestQueue's occupancy notions. :requests is the total number of jobs
# at the station — waiting, in service, and held blocked (the number_at
# convention). :tokens is the total remaining work at a round station:
# active jobs' remaining counters plus waiting jobs' full profiles (the
# counters they would get at admission) — compile guarantees every
# destination is a round station whose work marks the waiting jobs carry.
function _jsq_occupancy(m::QueueGSMP, st::QueueState, d::Int, by::Symbol)
    by == :requests && return length(st.buf[d]) + length(st.srv[d]) + length(st.hold[d])
    r = m.stations[d].rounds::Rounds
    tot = 0
    for j in st.srv[d]
        tot += sum(st.work[j])
    end
    for j in st.buf[d]
        marks = st.jobs[j]
        for mk in r.work
            tot += Int(getfield(marks, mk))
        end
    end
    return tot
end

# ---------------------------------------------------------------------------
# deposit and the settle cascade — pure state movement; clock lifecycle is
# derived afterwards from the membership these moves imply.

# Mark redraw on deposit (capability 7): a station's remark laws are drawn
# through the firing's DrawSource when a job arrives from OUTSIDE — filing
# into the buffer, or turning back blocked — and never on moves within the
# station (an eviction's return, an unblocked transfer's admission). Every
# law is evaluated against the job's PRE-redraw marks, then the drawn values
# merge over them — same names replace, new names extend — so an :ordered
# insert and the service law see the new values. A dropped job redraws
# nothing: no draw is consumed for a job that never files.
function remark!(m::QueueGSMP, st::QueueState, d::Int, j::JobId, draws::DrawSource)
    ml = m.stations[d].remark
    ml === nothing && return nothing
    old = st.jobs[j]
    drawn = NamedTuple()
    for (name, law) in ml.laws
        v = drawmark!(draws, name, law, old, st.time)
        drawn = merge(drawn, NamedTuple{(name,)}((v,)))
    end
    st.jobs[j] = merge(old, drawn)
    return nothing
end

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
        g = get(st.group, j, JobId(0))
        delete!(st.group, j)
        # A sunk sibling needs no cancellation; drop it from its group's
        # roster so a roster whose group never merges still empties out.
        g != JobId(0) && _prune_member!(st, g, j)
    elseif stn.kind == :fork
        # Instantaneous split: one sibling per branch, sharing the parent's
        # id as group id. Clock-free, so no family entry is needed — which is
        # itself part of charter claim F7. The whole roster is minted and
        # recorded before any sibling is deposited: a sibling reaching a
        # need-1 canceling join mid-loop cancels the rest of the roster, so
        # each deposit first checks its sibling is still alive.
        sibs = JobId[]
        for _ in stn.branches
            sib = st.next_id
            st.next_id += 1
            st.jobs[sib] = st.jobs[j]
            st.group[sib] = j
            push!(sibs, sib)
        end
        st.members[j] = sibs
        delete!(st.jobs, j)
        for (i, b) in enumerate(stn.branches)
            haskey(st.jobs, sibs[i]) || continue
            deposit!(m, st, d, Int(b), sibs[i], wl, touched, draws)
        end
    elseif stn.kind == :join
        # Instantaneous synchronization: stash the sibling (it stays a job in
        # the system — a group's sojourn ends only at the merge); release one
        # merged job through the join's route when `need` siblings have
        # arrived (`need == parts` unless the join cancels, check C7).
        g = get(st.group, j, JobId(0))
        g == 0 && error("job $j reached join $(stn.name) without a fork group")
        if stn.cancel != :none && !haskey(st.members, g) && !haskey(st.pending[d], g)
            # The group already resolved at this canceling join: a late
            # finisher — an in-service survivor under :on_start, or the
            # merged product of a nested fork whose parent was canceled.
            # Absorb it silently, like a sink; its work stays in the record.
            delete!(st.jobs, j)
            delete!(st.group, j)
        else
            sibs = get!(st.pending[d], g, JobId[])
            push!(sibs, j)
            if length(sibs) == stn.need
                merged = st.next_id
                st.next_id += 1
                st.jobs[merged] = st.jobs[j]
                # Nested forks: the merged job inherits the fork parent's
                # own group entry, so it can still reach an outer join.
                haskey(st.group, g) && (st.group[merged] = st.group[g])
                for sib in sibs
                    delete!(st.jobs, sib)
                    delete!(st.group, sib)
                end
                delete!(st.pending[d], g)
                if stn.cancel == :on_completion
                    # The race is decided: every sibling of the group not
                    # among the arrived is canceled wherever it sits. The
                    # roster comes out of `members` first so the recursive
                    # walk never mutates what it iterates.
                    roster = get(st.members, g, JobId[])
                    delete!(st.members, g)
                    delete!(st.started, g)
                    arrived = Set(sibs)
                    for x in roster
                        x in arrived && continue
                        cancel_job!(m, st, x, wl, touched)
                    end
                else
                    delete!(st.members, g)
                    delete!(st.started, g)
                end
                delete!(st.group, g)
                d2 = routejob!(m, st, d, merged, draws)
                deposit!(m, st, d, d2, merged, wl, touched, draws)
            end
        end
    elseif stn.kind == :station
        if length(st.buf[d]) >= stn.capacity
            # A source has no server to hold a blocked job, so an external
            # arrival to a full :block station is lost, not blocked.
            if holdable && stn.overflow == :block && m.stations[origin].kind == :station
                # The redraw belongs to the deposit, not to the eventual
                # unblock re-file — that one happens in some later firing's
                # settle and replays no draw — so a blocked transfer redraws
                # now, while this firing's draw source is in hand.
                remark!(m, st, d, j, draws)
                push!(st.hold[origin], j)
                push!(st.blocked[d], (Int32(origin), j))
                push!(touched, origin)
                m.allow_blocking_cycles && _deadlock_check(m, st, origin, d, j)
            else
                delete!(st.jobs, j)
                # A dropped sibling resolves like a sunk one: clear its
                # group entry and its slot in the roster.
                g = get(st.group, j, JobId(0))
                delete!(st.group, j)
                g != JobId(0) && _prune_member!(st, g, j)
            end
        else
            remark!(m, st, d, j, draws)
            file_into_buffer!(m, st, d, j)
            push!(wl, d)
        end
    else
        error("cannot route into $(stn.kind) station $(stn.name)")
    end
end

# Runtime deadlock detection under compile's allow_blocking_cycles: the
# wait-for graph is implied by st.blocked — station p waits on q when some
# (p, j) ∈ blocked[q], and that edge is REALIZED (the held job has already
# routed; its single chosen destination is the edge, so a Probabilistic
# kernel contributes exactly one edge per held job). When deposit! adds the
# edge origin → d, DFS from d through the existing edges; reaching origin
# closes a cycle. Every station on the cycle is then full and holding, and a
# held job's destination is already chosen, so no event can free space on
# the cycle — a genuine BAS deadlock, raised as BlockingDeadlock with the
# cycle in routing order. Cost: one pass over all blocked entries per new
# block edge, bounded by the total number of servers.
function _deadlock_check(m::QueueGSMP, st::QueueState, origin::Int, d::Int, j::JobId)
    if d == origin
        # A self-loop: the station blocks on itself.
        throw(BlockingDeadlock([m.stations[origin].name], st.time, JobId[j], nothing))
    end
    # Transient adjacency over realized edges: p → (q, held job at p).
    adj = Dict{Int,Vector{Tuple{Int,JobId}}}()
    for q in eachindex(st.blocked), (p, jb) in st.blocked[q]
        push!(get!(adj, Int(p), Tuple{Int,JobId}[]), (q, jb))
    end
    # parent[v] = (u, jb): DFS reached v along the edge u → v whose held
    # job at u is jb. d has no parent; its incoming edge is the new one.
    parent = Dict{Int,Tuple{Int,JobId}}()
    seen = Set{Int}([d])
    stack = Int[d]
    while !isempty(stack)
        p = pop!(stack)
        for (q, jb) in get(adj, p, Tuple{Int,JobId}[])
            if q == origin
                # Reconstruct the cycle origin → d → … → p → origin,
                # collecting each station's held job along its outgoing edge.
                path = Tuple{Int,JobId}[(p, jb)]
                node = p
                while node != d
                    u, ju = parent[node]
                    push!(path, (u, ju))
                    node = u
                end
                reverse!(path)                # now [(d, …), …, (p, jb)]
                cycle = [m.stations[origin].name]
                jobs = JobId[j]
                for (s, held) in path
                    push!(cycle, m.stations[s].name)
                    push!(jobs, held)
                end
                throw(BlockingDeadlock(cycle, st.time, jobs, nothing))
            end
            if !(q in seen)
                push!(seen, q)
                parent[q] = (p, jb)
                push!(stack, q)
            end
        end
    end
    # A station that is waited on but holds nothing itself has no outgoing
    # edge and can still drain — the DFS dead-ends there, correctly.
    return nothing
end

# Cancel one sibling: remove it from wherever it sits — a buffer, a server
# slot, a hold/blocked pair, a join stash, or a forming batch — and delete it
# from jobs/group. A sibling that already forked (a dead interior node of the
# group forest) cancels its own recorded descendants first, recursively.
# Every station a removal touches joins the worklist and the touched set, so
# freed slots refill, freed waiting room unblocks, and the derived deltas
# disable the removed clocks (I2). Cancellation is deterministic given the
# state — it consumes no draws (I1) — and is a no-op for a job already gone.
function cancel_job!(m::QueueGSMP, st::QueueState, x::JobId, wl::Vector{Int}, touched::Set{Int})
    if haskey(st.members, x)
        kids = st.members[x]
        delete!(st.members, x)
        delete!(st.started, x)
        for k in kids
            cancel_job!(m, st, k, wl, touched)
        end
    end
    found = false
    for s in eachindex(m.stations)
        i = findfirst(==(x), st.buf[s])
        if i !== nothing
            deleteat!(st.buf[s], i)
            # A previously preempted :resume clock banked its age while the
            # job waited; the job is gone, so the residue goes with it.
            k = (:service, Int32(s), x)
            delete!(st.bank, k)
            delete!(st.anchor, k)
            push!(wl, s)
            push!(touched, s)
            found = true
            break
        end
        i = findfirst(==(x), st.srv[s])
        if i !== nothing
            deleteat!(st.srv[s], i)
            # A canceled sibling active in a round: its work counters and its
            # entry in the running plan go with it (the slot is REPLACED —
            # committed plans are immutable), and the round runs on with its
            # aggregates frozen, like a canceled batch member.
            if m.stations[s].rounds !== nothing
                delete!(st.work, x)
                plan = st.roundplan[s]
                if plan !== nothing
                    ai = findfirst(p -> p.first == x, plan.alloc)
                    if ai !== nothing
                        st.roundplan[s] = RoundPlan(
                            plan.admit,
                            plan.evict,
                            plan.alloc[setdiff(eachindex(plan.alloc), ai)],
                            plan.aggregates,
                        )
                    end
                end
            end
            push!(wl, s)
            push!(touched, s)
            found = true
            break
        end
    end
    if !found
        # Blocked: the (origin, x) entry in the destination's blocked queue
        # is paired with x in the origin's hold — both go, and both stations
        # re-settle (the origin's server frees, the destination's queue may
        # admit another transfer).
        for dq in eachindex(st.blocked)
            i = findfirst(p -> p[2] == x, st.blocked[dq])
            i === nothing && continue
            o = Int(st.blocked[dq][i][1])
            deleteat!(st.blocked[dq], i)
            _remove!(st.hold[o], x)
            push!(wl, o)
            push!(wl, dq)
            push!(touched, o)
            push!(touched, dq)
            found = true
            break
        end
    end
    if !found
        # Stashed at a join, waiting for siblings that now never come.
        for dq in eachindex(st.pending)
            for (g2, v) in st.pending[dq]
                i = findfirst(==(x), v)
                i === nothing && continue
                deleteat!(v, i)
                isempty(v) && delete!(st.pending[dq], g2)
                found = true
                break
            end
            found && break
        end
    end
    if !found
        # Gathered into a forming batch: drop it from the roster; the batch
        # clock runs on with its frozen batchsize mark.
        for (_, v) in st.batchmembers
            i = findfirst(==(x), v)
            i === nothing && continue
            deleteat!(v, i)
            break
        end
    end
    delete!(st.jobs, x)
    delete!(st.group, x)
    return nothing
end

# A resolved sibling (it reached a sink) needs no cancellation: drop it from
# its group's roster so a roster whose group never merges — branches that end
# in sinks — still empties and is reclaimed. An emptied fork parent resolves
# like a sunk sibling, recursively (nested forks).
function _prune_member!(st::QueueState, g::JobId, j::JobId)
    v = get(st.members, g, nothing)
    v === nothing && return nothing
    i = findfirst(==(j), v)
    i === nothing || deleteat!(v, i)
    if isempty(v)
        delete!(st.members, g)
        delete!(st.started, g)
        gg = get(st.group, g, JobId(0))
        delete!(st.group, g)
        gg != JobId(0) && _prune_member!(st, gg, g)
    end
    return nothing
end

# Cancel-on-start (redundancy-d): when the need-th sibling of a group racing
# toward a `cancel = :on_start` join enters service, siblings still waiting
# in buffers are canceled; jobs already in service run to completion, and the
# join merges the first `need` arrivals. Which join a group races toward is
# compile-time knowledge — the station where the job starts carries the
# join's index (`cancel_join`, unambiguous by check C9). The counter is per
# group and counts service entries, so the intended pairing is single-hop,
# non-preemptive branch stations: a re-dispatched preempted sibling or a
# multi-hop branch counts more than once.
function maybe_cancel_started!(
    m::QueueGSMP, st::QueueState, q::Int, j::JobId, wl::Vector{Int}, touched::Set{Int}
)
    jn = Int(m.stations[q].cancel_join)
    jn == 0 && return nothing
    m.stations[jn].cancel == :on_start || return nothing
    g = get(st.group, j, JobId(0))
    g == JobId(0) && return nothing
    roster = get(st.members, g, nothing)
    roster === nothing && return nothing     # the group already resolved
    n = get(st.started, g, 0) + 1
    st.started[g] = n
    n == m.stations[jn].need || return nothing
    for x in copy(roster)
        x == j && continue
        any(s -> x in st.buf[s], eachindex(m.stations)) || continue
        cancel_job!(m, st, x, wl, touched)
    end
    return nothing
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

    # 2. Dispatch: fill free slots in discipline order. A round station
    # instead plans: with no round running, the policy examines the view and
    # a committed plan moves its admissions and evictions and stores the
    # frozen allocation, whose derived delta enables the :round clock. With
    # a round already running, deposits simply queue — the next boundary is
    # the running clock's firing. A batching station gathers waiting jobs
    # into a synthetic batch job: once at least `min` jobs wait, a free
    # server takes up to `max` of them in discipline order (draw-free under
    # FCFS, the only discipline C6 admits), and one fresh job id carrying
    # the mark `batchsize` enters service for them. Members leave the buffer
    # but stay in st.jobs, keyed through st.batchmembers — like stashed join
    # siblings, they are still in the system. With fewer than `min` waiting,
    # the server idles; no clock is needed for the forming batch because
    # arrivals re-run settle.
    b = stn.batching
    if stn.rounds !== nothing
        st.roundplan[q] === nothing && _settle_round!(m, st, q, draws)
    elseif b === nothing
        while _freeslots(m, st, q) > 0
            j = selectjob!(m, st, q, draws)
            j === nothing && break
            push!(st.srv[q], j)
            maybe_cancel_started!(m, st, q, j, wl, touched)
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

# ---------------------------------------------------------------------------
# Round planning (capability 6). A round station with no running plan asks
# its policy for one, through a read-only view; `nothing` idles the station
# until the next deposit re-runs settle, and a plan commits its state
# surgery here — evictions, admissions, allocation validation, frozen
# aggregates — so the derived-delta pass enables the :round clock from
# membership alone (I2). Policy randomness flows through the firing's draw
# source (I1); the policy itself must be a pure function of (view, draws).

function _settle_round!(m::QueueGSMP, st::QueueState, q::Int, draws::DrawSource)
    r = m.stations[q].rounds::Rounds
    plan = plan_round(r.policy, _round_view(m, st, q), draws)
    plan === nothing && return nothing
    _commit_round!(m, st, q, plan::RoundPlan, r)
    return nothing
end

function _round_view(m::QueueGSMP, st::QueueState, q::Int)
    stn = m.stations[q]
    r = stn.rounds::Rounds
    waiting = RoundJob[
        RoundJob(j, st.jobs[j], _work_profile(stn, st.jobs[j], j)) for j in st.buf[q]
    ]
    active = RoundJob[RoundJob(j, st.jobs[j], copy(st.work[j])) for j in st.srv[q]]
    return RoundView(r.work, waiting, active)
end

# The admission-time snapshot of a job's work profile: each work mark,
# runtime-checked to be an integer >= 0 (check C12's runtime half).
function _work_profile(stn::CompiledStation, marks::NamedTuple, j::JobId)
    r = stn.rounds::Rounds
    prof = Vector{Int}(undef, length(r.work))
    for (p, mk) in enumerate(r.work)
        v = getfield(marks, mk)
        (isinteger(v) && v >= 0) || error(
            "round station $(stn.name) cannot admit job $j: work mark $mk = $v " *
            "is not a nonnegative integer",
        )
        prof[p] = Int(v)
    end
    return prof
end

function _commit_round!(m::QueueGSMP, st::QueueState, q::Int, plan::RoundPlan, r::Rounds)
    stn = m.stations[q]
    # Evictions first: active → waiting with the work counters RESET (Dong's
    # refresh semantics) — the counter entry is simply deleted, and a later
    # re-admission re-snapshots the full profile from the marks. The evicted
    # job files at the back of the FCFS line and, by membership, gets a
    # fresh patience clock if the station reneges.
    for j in plan.evict
        j in st.srv[q] || error("round plan at $(stn.name) evicts job $j, which is not active")
        _remove!(st.srv[q], j)
        delete!(st.work, j)
        file_into_buffer!(m, st, q, j)
    end
    # Admissions: waiting → active in the plan's order, snapshotting the
    # integer work counters.
    for j in plan.admit
        j in st.buf[q] || error("round plan at $(stn.name) admits job $j, which is not waiting")
        _remove!(st.buf[q], j)
        st.work[j] = _work_profile(stn, st.jobs[j], j)
        push!(st.srv[q], j)
    end
    # Allocations, engine-enforced: every allocation names an active job at
    # most once, covers every phase, and stays within 0 <= alloc <= remaining
    # per phase. The aggregates — token load b, batch size k, per-phase
    # sums — freeze here as the pseudo-marks the duration law reads.
    np = length(r.work)
    tokens = 0
    requests = 0
    phasesum = zeros(Int, np)
    seen = Set{JobId}()
    for (j, av) in plan.alloc
        j in st.srv[q] ||
            error("round plan at $(stn.name) allocates to job $j, which is not active")
        j in seen && error("round plan at $(stn.name) allocates to job $j twice")
        push!(seen, j)
        length(av) == np || error(
            "round plan at $(stn.name) allocates $(length(av)) phases to job $j; " *
            "the station has $np work phases",
        )
        w = st.work[j]
        pos = false
        for p in 1:np
            0 <= av[p] <= w[p] || error(
                "round plan at $(stn.name) allocates $(av[p]) tokens to phase " *
                "$(r.work[p]) of job $j, which has $(w[p]) remaining",
            )
            tokens += av[p]
            phasesum[p] += av[p]
            pos |= av[p] > 0
        end
        pos && (requests += 1)
    end
    ag = merge(
        (tokens=Float64(tokens), requests=Float64(requests)),
        NamedTuple{Tuple(r.work)}(Tuple(Float64.(phasesum))),
    )
    # Defensive copies: the committed plan must be immutable, and the policy
    # keeps no handle into the state through vectors it returned.
    st.roundplan[q] = RoundPlan(
        copy(plan.admit),
        copy(plan.evict),
        Pair{JobId,Vector{Int}}[j => copy(v) for (j, v) in plan.alloc],
        ag,
    )
    return nothing
end

# F9's claim is that FIFO and LIFO reach the same fixed point because
# contention lives in UnblockPolicy, not in this order. The claim survives
# cyclic blocking topologies (compile's allow_blocking_cycles): unblocking
# picks by FCFSUnblock from a per-destination queue, so freed waiting room
# admits the longest-blocked transfer regardless of which cascade order freed
# it — the order can only change WHEN a settle runs, never which blocked
# transfer wins the room. The fuel bound turns a blocking cycle (excluded
# statically by C3 unless allow_blocking_cycles, which detects a realized
# deadlock precisely in deposit!) into an error instead of a hang.
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
        fuel >= 0 || error(
            "settle cascade did not reach a fixed point; if this network has a " *
            "blocking cycle, compile with allow_blocking_cycles = true to get a " *
            "precise BlockingDeadlock error",
        )
    end
    return nothing
end

# The seeded half of initial_state (the docstring lives on the one-argument
# method in state.jl; this method is defined here because it runs the settle
# machinery). Seeded jobs are ordinary jobs: filed into their buffer in
# declaration order, dispatched by one cascade at t = 0 honoring disciplines
# and capacities, with every enabled clock's te set to 0.0 so the enable
# loop in `simulate` needs no special case.
function initial_state(m::QueueGSMP, ds::DrawSource)
    st = _empty_state(m)
    isempty(m.population) && return st
    wl = Int[]
    for p in m.population
        s = Int(p.station)
        for _ in 1:p.count
            j = st.next_id
            st.next_id += 1
            st.jobs[j] = p.mark === nothing ? NamedTuple() : drawmarks!(ds, p.mark, 0.0)
            file_into_buffer!(m, st, s, j)
        end
        push!(wl, s)
    end
    unique!(wl)
    run_cascade!(m, st, 0.0, ds, wl, Set{Int}(), :fifo)
    for k in enabled(m, st)
        st.te[k] = 0.0
    end
    return st
end
