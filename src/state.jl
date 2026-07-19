# Amendment A1: the state carries the clock bookkeeping — enabling times for
# enabled clocks, banked ages for :resume-disabled ones — because they
# determine future behavior. The sampler is a pure consumer of them.

"""
    ClockKey

The identity of a clock: a tuple `(family, station, job)`. `family` is the
clock family — `:arrival`, `:service`, or `:patience`. `station` is the
station index in the compiled model. `job` is the job id, or `0` for an
arrival clock, which belongs to the source rather than to a job. Clock keys
appear in [`MarkedRecord`](@ref)s, in the deltas of
[`fire_changes`](@ref), and as sampler keys.
"""
const ClockKey = Tuple{Symbol,Int32,Int64}
const JobId = Int64

"""
    QueueState

The complete state of a queueing simulation between firings. It holds the
wall-clock `time`, the count `nfired` of firings so far, the next job id,
and per-station vectors of job ids: `buf` (waiting, in discipline order),
`srv` (in service), and `hold` (finished but blocked from transferring).
`jobs` maps each live job id to its marks. `pending` and `group` track
fork–join siblings; `members` maps each unresolved fork parent to the
sibling ids it minted (the roster sibling cancellation walks, recursively
for nested forks), and `started` counts, per group racing toward a
`cancel = :on_start` join, how many siblings have entered service.
`batchmembers` maps a synthetic batch job to the member jobs it gathered
(members stay in `jobs` but appear in no station vector), and `cursor`
holds each [`RoundRobin`](@ref) kernel's position.

The state also carries the clock bookkeeping that determines future
behavior, so the sampler can be a pure consumer of it: `te` holds each
enabled clock's enabling time, `bank` holds the age banked by a
`:resume`-disabled clock, and `anchor` marks the last speed change of a
processor-sharing clock. Fields are documented here because measurement
functions, such as those passed to [`time_average`](@ref), read them
directly.
"""
mutable struct QueueState
    time::Float64
    nfired::Int               # replay's index into the recorded draws
    next_id::JobId
    buf::Vector{Vector{JobId}}      # per station, in discipline order
    srv::Vector{Vector{JobId}}      # per station, jobs in service
    hold::Vector{Vector{JobId}}     # per station, finished jobs whose transfer is blocked
    blocked::Vector{Vector{Tuple{Int32,JobId}}}  # per DESTINATION, (origin, job), blocking order
    jobs::Dict{JobId,NamedTuple}
    pending::Vector{Dict{JobId,Vector{JobId}}}  # per JOIN, group => siblings stashed so far
    group::Dict{JobId,JobId}        # sibling => its fork group (the parent's id)
    members::Dict{JobId,Vector{JobId}}  # fork parent => the siblings it minted
    started::Dict{JobId,Int}        # group racing to an :on_start join => siblings started
    batchmembers::Dict{JobId,Vector{JobId}}     # batch job => members, in gather order
    cursor::Vector{Int}             # RoundRobin state, in the IR so replay reproduces it
    te::Dict{ClockKey,Float64}
    bank::Dict{ClockKey,Float64}
    # Processor sharing (A1 addendum): te stays at the ORIGINAL enabling so
    # the ClockGradients contract's fixed-anchor segment machinery applies;
    # bank holds the internal age accrued up to the last speed change, and
    # anchor holds that change's wall time. Absent entries mean "never
    # re-evaluated": anchor = te, bank = 0.
    anchor::Dict{ClockKey,Float64}
end

"""
    initial_state(m::QueueGSMP) -> QueueState

The state at time zero: no jobs anywhere, and one arrival clock enabled per
source with enabling time `0.0`. One of the five contract functions
(`initial_state`, [`enabled`](@ref), [`clock_distribution`](@ref),
[`fire_changes`](@ref), [`states_equal`](@ref)).
"""
function initial_state(m::QueueGSMP)
    n = length(m.stations)
    st = QueueState(
        0.0,
        0,
        1,
        [JobId[] for _ in 1:n],
        [JobId[] for _ in 1:n],
        [JobId[] for _ in 1:n],
        [Tuple{Int32,JobId}[] for _ in 1:n],
        Dict{JobId,NamedTuple}(),
        [Dict{JobId,Vector{JobId}}() for _ in 1:n],
        Dict{JobId,JobId}(),
        Dict{JobId,Vector{JobId}}(),
        Dict{JobId,Int}(),
        Dict{JobId,Vector{JobId}}(),
        ones(Int, n),
        Dict{ClockKey,Float64}(),
        Dict{ClockKey,Float64}(),
        Dict{ClockKey,Float64}(),
    )
    for (s, stn) in enumerate(m.stations)
        stn.kind == :source && (st.te[(:arrival, Int32(s), JobId(0))] = 0.0)
    end
    return st
end

function copystate(st::QueueState)
    return QueueState(
        st.time,
        st.nfired,
        st.next_id,
        [copy(v) for v in st.buf],
        [copy(v) for v in st.srv],
        [copy(v) for v in st.hold],
        [copy(v) for v in st.blocked],
        copy(st.jobs),
        [Dict(g => copy(v) for (g, v) in d) for d in st.pending],
        copy(st.group),
        Dict(g => copy(v) for (g, v) in st.members),
        copy(st.started),
        Dict(b => copy(v) for (b, v) in st.batchmembers),
        copy(st.cursor),
        copy(st.te),
        copy(st.bank),
        copy(st.anchor),
    )
end

"""
    states_equal(a::QueueState, b::QueueState) -> Bool

Field-by-field equality of two states, including the clock bookkeeping
(`te`, `bank`, `anchor`). This is the equality the replay tests use to
show that a fold of [`fire_changes`](@ref) over a record reproduces the
live trajectory exactly. One of the five contract functions.
"""
function states_equal(a::QueueState, b::QueueState)
    return a.time == b.time &&
           a.nfired == b.nfired &&
           a.next_id == b.next_id &&
           a.buf == b.buf &&
           a.srv == b.srv &&
           a.hold == b.hold &&
           a.blocked == b.blocked &&
           a.jobs == b.jobs &&
           a.pending == b.pending &&
           a.group == b.group &&
           a.members == b.members &&
           a.started == b.started &&
           a.batchmembers == b.batchmembers &&
           a.cursor == b.cursor &&
           a.te == b.te &&
           a.bank == b.bank &&
           a.anchor == b.anchor
end
