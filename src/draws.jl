# Amendment A4: every auxiliary draw flows through a DrawSource that either
# draws from a keyed stream and records the value (live), or returns the
# recorded value (replay). Replay never touches an RNG and never needs θ,
# which is what makes the contract's fire θ-free and deterministic given the
# record.

const DrawList = Vector{Pair{Symbol,Float64}}
const StreamKey = Tuple{ClockKey,Symbol}

mutable struct DrawSource
    streams::Union{Nothing,CompetingClocks.KeyedStreams{StreamKey}}
    firing::ClockKey
    params::Dict{Symbol,Int}
    θ::Union{Nothing,AbstractVector}
    consumed::DrawList
    replay::Union{Nothing,DrawList}
    ri::Int
end

function livedraws(streams, firing::ClockKey, params, θ)
    DrawSource(streams, firing, params, θ, DrawList(), nothing, 0)
end

function replaydraws(firing::ClockKey, recorded::DrawList, params)
    DrawSource(nothing, firing, params, nothing, DrawList(), recorded, 0)
end

function _next_recorded(ds::DrawSource, purpose::Symbol)
    ds.ri += 1
    ds.ri <= length(ds.replay) ||
        error("replay of $(ds.firing) asked for draw $purpose beyond the record")
    p = ds.replay[ds.ri]
    p.first == purpose ||
        error("replay of $(ds.firing) wanted $(p.first), fire asked for $purpose")
    p.second
end

# A raw distribution draw (routing uniforms, SIRO's pick). Keying the stream
# by (firing clock, purpose) makes the draw belong to the clock rather than to
# a position in a global call sequence — the coupling property the sampler's
# own streams already have.
function draw!(ds::DrawSource, purpose::Symbol, dist)
    ds.replay === nothing || return _next_recorded(ds, purpose)
    rng = CompetingClocks.stream_for!(ds.streams, (ds.firing, purpose))
    v = Float64(rand(rng, dist))
    push!(ds.consumed, purpose => v)
    v
end

# A mark draw. Only the live side evaluates the law, so θ never enters replay.
function drawmark!(ds::DrawSource, name::Symbol, law::AbstractLaw,
                   marks::NamedTuple, te::Float64)
    ds.replay === nothing || return _next_recorded(ds, name)
    dist = builddist(law, ds.params, ds.θ, marks, te)
    rng = CompetingClocks.stream_for!(ds.streams, (ds.firing, name))
    v = Float64(rand(rng, dist))
    push!(ds.consumed, name => v)
    v
end

function drawmarks!(ds::DrawSource, ml::Union{MarkLaw,Nothing}, te::Float64)
    ml === nothing && return NamedTuple()
    marks = NamedTuple()
    for (name, law) in ml.laws
        v = drawmark!(ds, name, law, marks, te)
        marks = merge(marks, NamedTuple{(name,)}((v,)))
    end
    marks
end
