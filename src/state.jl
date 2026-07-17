# Amendment A1: the state carries the clock bookkeeping — enabling times for
# enabled clocks, banked ages for :resume-disabled ones — because they
# determine future behavior. The sampler is a pure consumer of them.

const ClockKey = Tuple{Symbol,Int32,Int64}
const JobId = Int64

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

function initial_state(m::QueueGSMP)
    n = length(m.stations)
    st = QueueState(0.0, 0, 1,
                    [JobId[] for _ in 1:n], [JobId[] for _ in 1:n],
                    [JobId[] for _ in 1:n], [Tuple{Int32,JobId}[] for _ in 1:n],
                    Dict{JobId,NamedTuple}(),
                    [Dict{JobId,Vector{JobId}}() for _ in 1:n],
                    Dict{JobId,JobId}(), ones(Int, n),
                    Dict{ClockKey,Float64}(), Dict{ClockKey,Float64}(),
                    Dict{ClockKey,Float64}())
    for (s, stn) in enumerate(m.stations)
        stn.kind == :source && (st.te[(:arrival, Int32(s), JobId(0))] = 0.0)
    end
    st
end

function copystate(st::QueueState)
    QueueState(st.time, st.nfired, st.next_id,
               [copy(v) for v in st.buf], [copy(v) for v in st.srv],
               [copy(v) for v in st.hold], [copy(v) for v in st.blocked],
               copy(st.jobs),
               [Dict(g => copy(v) for (g, v) in d) for d in st.pending],
               copy(st.group), copy(st.cursor), copy(st.te), copy(st.bank),
               copy(st.anchor))
end

function states_equal(a::QueueState, b::QueueState)
    a.time == b.time && a.nfired == b.nfired && a.next_id == b.next_id &&
        a.buf == b.buf && a.srv == b.srv && a.hold == b.hold &&
        a.blocked == b.blocked && a.jobs == b.jobs && a.pending == b.pending &&
        a.group == b.group && a.cursor == b.cursor &&
        a.te == b.te && a.bank == b.bank && a.anchor == b.anchor
end
