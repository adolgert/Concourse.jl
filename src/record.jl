# The marked record is the primary observable (decision D3): the fired key,
# the time, and the auxiliary draws that firing consumed, in consumption
# order. Every statistic is a fold of fire over it; replay conditions on the
# draws, which is what makes the fold deterministic (F4).

"""
    MarkedRecord

What a simulation produces: for each firing, the clock key (`key`), the
firing time (`time`), and the auxiliary draws that firing consumed in
consumption order (`draws`, a vector of `purpose => value` pairs per
firing), plus the `horizon` the run covered. `length(rec)` is the number of
firings.

The record is the primary observable. Every statistic is a fold of
[`fire_changes`](@ref) over it, and because the draws are recorded,
[`replay`](@ref) reproduces the exact state trajectory without touching a
random number generator or the parameter vector.
"""
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
    return r
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
    return sts
end

"""
    time_average(g, m, rec) -> Float64

The time average of `g(state)` over `[0, horizon]`, exact between events
because the state is constant there. `g` maps a [`QueueState`](@ref) to a
number, for example [`number_in_system`](@ref).

# Example

```julia
rec = simulate(m, θ, 2000.0; seed = 1)
L = time_average(number_in_system, m, rec)   # mean number in system
```
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
    return acc / rec.horizon
end

"""
    number_in_system(st::QueueState) -> Int

The number of jobs in the system: every live job, whether waiting, in
service, held blocked, or stashed at a join. Pass it to
[`time_average`](@ref) to estimate L, the time-average number in system.
"""
# Batch members stay in st.jobs while their synthetic batch job (also in
# st.jobs, one per batchmembers entry) is in service; counting both would
# double-count. The batch job is bookkeeping, the members are the real jobs,
# so subtract one per live batch.
number_in_system(st::QueueState) = length(st.jobs) - length(st.batchmembers)
number_at(q::Int) = st::QueueState -> length(st.buf[q]) + length(st.srv[q]) + length(st.hold[q])
