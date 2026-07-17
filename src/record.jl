# The marked record is the primary observable (decision D3): the fired key,
# the time, and the auxiliary draws that firing consumed, in consumption
# order. Every statistic is a fold of fire over it; replay conditions on the
# draws, which is what makes the fold deterministic (F4).

mutable struct MarkedRecord
    key::Vector{ClockKey}
    time::Vector{Float64}
    draws::Vector{DrawList}
    horizon::Float64
end
MarkedRecord() = MarkedRecord(ClockKey[], Float64[], DrawList[], NaN)

Base.length(r::MarkedRecord) = length(r.key)

function push_firing!(r::MarkedRecord, key::ClockKey, t::Float64, draws::DrawList)
    push!(r.key, key)
    push!(r.time, t)
    push!(r.draws, draws)
    r
end

"""
    replay(m, rec; worklist=:fifo) -> Vector{QueueState}

The state trajectory as a fold of `fire_changes` over the record, including
the initial state; index i+1 is the state just after firing i.
"""
function replay(m::QueueGSMP, rec::MarkedRecord; worklist::Symbol=:fifo)
    sts = QueueState[initial_state(m)]
    for i in eachindex(rec.key)
        ds = replaydraws(rec.key[i], rec.draws[i], m.params)
        st, _ = fire_changes(m, sts[end], rec.key[i], rec.time[i], ds; worklist)
        push!(sts, st)
    end
    sts
end

"""
    time_average(g, m, rec) -> Float64

The time average of `g(state)` over `[0, horizon]`, exact between events
because the state is constant there.
"""
function time_average(g::Function, m::QueueGSMP, rec::MarkedRecord)
    st = initial_state(m)
    acc = 0.0
    tprev = 0.0
    for i in eachindex(rec.key)
        acc += g(st) * (rec.time[i] - tprev)
        ds = replaydraws(rec.key[i], rec.draws[i], m.params)
        st, _ = fire_changes(m, st, rec.key[i], rec.time[i], ds)
        tprev = rec.time[i]
    end
    acc += g(st) * (rec.horizon - tprev)
    acc / rec.horizon
end

number_in_system(st::QueueState) = length(st.jobs)
number_at(q::Int) = st::QueueState -> length(st.buf[q]) + length(st.srv[q]) + length(st.hold[q])
