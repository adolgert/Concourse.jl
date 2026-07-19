# Amendment A4: every auxiliary draw flows through a DrawSource that either
# draws from a keyed stream and records the value (live), or returns the
# recorded value (replay). Replay never touches an RNG and never needs θ,
# which is what makes the contract's fire θ-free and deterministic given the
# record.

const DrawList = Vector{Pair{Symbol,Float64}}
const StreamKey = Tuple{ClockKey,Symbol}

"""
    DrawSource

The single conduit for auxiliary draws (Amendment A4). A live source
(built by [`livedraws`](@ref)) draws from a keyed RNG stream and appends
each value to `consumed`, which becomes the firing's draw record. A replay
source (built by [`replaydraws`](@ref)) returns recorded values in order
and never touches an RNG — replay needs neither streams nor θ, which is
what makes the contract's fire θ-free and deterministic given the record.

Fields: `streams`/`θ` are `nothing` in replay mode; `replay` is `nothing`
in live mode; `firing` is the clock whose fire is consuming draws; `ri`
is the replay cursor into `replay`.
"""
mutable struct DrawSource
    streams::Union{Nothing,CompetingClocks.KeyedStreams{StreamKey}}
    firing::ClockKey
    params::Dict{Symbol,Int}
    θ::Union{Nothing,AbstractVector}
    consumed::DrawList
    replay::Union{Nothing,DrawList}
    ri::Int
end

"""
    livedraws(streams, firing, params, θ) -> DrawSource

A live draw source for the firing of clock `firing`: draws come from
`streams` keyed by `(firing, purpose)`, and every value is appended to the
source's `consumed` list, which the interpreter stores as the firing's
draw record.
"""
function livedraws(streams, firing::ClockKey, params, θ)
    return DrawSource(streams, firing, params, θ, DrawList(), nothing, 0)
end

"""
    replaydraws(firing, recorded, params) -> DrawSource

A replay draw source: draw and mark requests during the fire of `firing`
are answered from `recorded` in order, checking that each request's
purpose matches what was recorded. No RNG, no θ.
"""
function replaydraws(firing::ClockKey, recorded::DrawList, params)
    return DrawSource(nothing, firing, params, nothing, DrawList(), recorded, 0)
end

"""
    _next_recorded(ds, purpose) -> Float64

The next recorded value from a replay source, erroring if the record is
exhausted or the recorded purpose disagrees with what the fire asked for —
either means the replayed fire diverged from the recorded one.
"""
function _next_recorded(ds::DrawSource, purpose::Symbol)
    replay = ds.replay::DrawList   # only replay sources reach here
    ds.ri += 1
    ds.ri <= length(replay) ||
        error("replay of $(ds.firing) asked for draw $purpose beyond the record")
    p = replay[ds.ri]
    p.first == purpose || error("replay of $(ds.firing) wanted $(p.first), fire asked for $purpose")
    return p.second
end

"""
    draw!(ds, purpose, dist) -> Float64

A raw distribution draw (routing uniforms, SIRO's pick). Keying the stream
by (firing clock, purpose) makes the draw belong to the clock rather than
to a position in a global call sequence — the coupling property the
sampler's own streams already have. In replay mode the recorded value is
returned and `dist` is ignored.
"""
function draw!(ds::DrawSource, purpose::Symbol, dist)
    ds.replay === nothing || return _next_recorded(ds, purpose)
    # A live source always carries streams (livedraws is the only non-replay
    # constructor).
    streams = ds.streams::CompetingClocks.KeyedStreams{StreamKey}
    rng = CompetingClocks.stream_for!(streams, (ds.firing, purpose))
    v = Float64(rand(rng, dist))
    push!(ds.consumed, purpose => v)
    return v
end

"""
    drawmark!(ds, name, law, marks, te) -> Float64

A mark draw: the value of mark `name` under `law`, given the marks drawn
so far and the enabling time `te`. Only the live side evaluates the law,
so θ never enters replay.
"""
function drawmark!(ds::DrawSource, name::Symbol, law::AbstractLaw, marks::NamedTuple, te::Float64)
    ds.replay === nothing || return _next_recorded(ds, name)
    # Live sources carry streams and θ; replay returned above, so θ never
    # enters this evaluation path with `nothing`.
    dist = builddist(law, ds.params, ds.θ::AbstractVector, marks, te, NOSTATE)
    streams = ds.streams::CompetingClocks.KeyedStreams{StreamKey}
    rng = CompetingClocks.stream_for!(streams, (ds.firing, name))
    v = Float64(rand(rng, dist))
    push!(ds.consumed, name => v)
    return v
end

"""
    drawmarks!(ds, ml, te) -> NamedTuple

All of a job's marks under mark law `ml` (nothing means no marks), drawn
in declaration order so a later law may read an earlier mark.
"""
function drawmarks!(ds::DrawSource, ml::Union{MarkLaw,Nothing}, te::Float64)
    ml === nothing && return NamedTuple()
    marks = NamedTuple()
    for (name, law) in ml.laws
        v = drawmark!(ds, name, law, marks, te)
        marks = merge(marks, NamedTuple{(name,)}((v,)))
    end
    return marks
end
