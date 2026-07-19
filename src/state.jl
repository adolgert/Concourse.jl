# Amendment A1: the state carries the clock bookkeeping — enabling times for
# enabled clocks, banked ages for :resume-disabled ones — because they
# determine future behavior. The sampler is a pure consumer of them.

"""
    ClockKey

The identity of a clock: a tuple `(family, station, job)`. `family` is the
clock family — `:arrival`, `:service`, `:patience`, or `:round`. `station`
is the station index in the compiled model. `job` is the job id, or `0`
for an arrival clock, which belongs to the source rather than to a job,
and for a round clock, which belongs to the station's running round. Clock keys
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

Round service ([`Rounds`](@ref)) adds two replay-owned fields: `work`
maps each job active at a round station to its remaining integer work per
phase (created at admission, deleted at departure or eviction), and
`roundplan` holds, per station, the running round's committed
[`RoundPlan`](@ref) — its frozen allocation and aggregates — or `nothing`
when the station is between rounds. A `RoundPlan` in a slot is immutable:
state transitions replace the slot, never the plan's vectors, so copies
of the state may share it.

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
    work::Dict{JobId,Vector{Int}}   # round stations: remaining work per phase
    roundplan::Vector{Union{RoundPlan,Nothing}} # per station, the running round's plan
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
    initial_state(m::QueueGSMP, ds::DrawSource) -> QueueState

The state at time zero, with one arrival clock enabled per source (enabling
time `0.0`) and the network's [`populate!`](@ref) population seeded: each
entry's jobs are filed into their station's buffer in declaration order,
one settle pass at t = 0 dispatches them into service, and every enabled
clock gets enabling time `0.0`. One of the five contract functions
(`initial_state`, [`enabled`](@ref), [`clock_distribution`](@ref),
[`fire_changes`](@ref), [`states_equal`](@ref)).

Seeding may consume draws — initial marks, and any draw the t = 0 dispatch
makes (a [`SIRO`](@ref) pick, say) — which flow through `ds`, keyed by the
reserved pseudo-clock `(:init, 0, 0)`; [`simulate`](@ref) records them as
the record's `init` list and [`replay`](@ref) reads them back. The
one-argument form works when no draw is needed; a model whose population
carries mark laws must be seeded through a draw source and errors here,
pointing at the record's `init` draws.
"""
function initial_state(m::QueueGSMP)
    isempty(m.population) && return _empty_state(m)
    any(p -> p.mark !== nothing, m.population) && throw(
        ArgumentError(
            "initial_state(m) has no draw source to draw the population's " *
            "initial marks; seed from a record's init draws instead: " *
            "initial_state(m, replaydraws((:init, Int32(0), Int64(0)), rec.init, m.params))",
        ),
    )
    return initial_state(m, replaydraws(INIT_KEY, DrawList(), m.params))
end

function _empty_state(m::QueueGSMP)
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
        Dict{JobId,Vector{Int}}(),
        Union{RoundPlan,Nothing}[nothing for _ in 1:n],
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
        Dict(j => copy(v) for (j, v) in st.work),
        # RoundPlans are immutable once committed (slots are replaced, never
        # the plans' vectors), so a shallow slot copy is a safe deep copy.
        copy(st.roundplan),
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
           a.work == b.work &&
           a.roundplan == b.roundplan &&
           a.te == b.te &&
           a.bank == b.bank &&
           a.anchor == b.anchor
end
