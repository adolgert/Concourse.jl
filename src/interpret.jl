# The event loop of notes/event_loop.tex §6: everything model-specific is
# inside fire_changes, everything stochastic is in the context and the draw
# source, everything observable is the record. This loop should never grow.

"""
    simulate(m, θ, horizon; seed=0, method=nothing, worklist=:fifo,
             debug=false, keep_states=false) -> MarkedRecord

Run the compiled model `m` at parameter vector `θ` until the next firing
would pass `horizon`, and return the [`MarkedRecord`](@ref) of what fired.

- `θ`: parameter values, ordered as the network's `param_names`.
- `seed`: seeds the master random number generator. The same seed gives the
  same record.
- `method`: `nothing` lets CompetingClocks.jl's builder choose the sampler;
  pass `FirstToFireMethod()`, `NextReactionMethod()`, or
  `FirstReactionMethod()` to override.
- `worklist`: order of the settle cascade, `:fifo` or `:lifo`. Both reach
  the same fixed point.
- `debug`: after every firing, recompute the enabled clock set from the
  state and compare it against the sampler; error on drift.
- `keep_states`: also return the live state trajectory, as
  `(record, states)`, for comparison against [`replay`](@ref).

# Example

```julia
m = compile(net)                          # an M/M/1 with θ = (λ, μ)
rec = simulate(m, [1.0, 2.0], 2000.0; seed = 7)
time_average(number_in_system, m, rec)    # near ρ/(1-ρ) = 1
```
"""
function simulate(
    m::QueueGSMP,
    θ::AbstractVector,
    horizon::Real;
    seed::Integer=0,
    method=nothing,
    worklist::Symbol=:fifo,
    debug::Bool=false,
    keep_states::Bool=false,
)
    rng = Xoshiro(seed)
    ctx = SamplingContext(SamplerBuilder(ClockKey, Float64; method), rng)
    # Auxiliary draws get their own keyed streams, independent of the clock
    # streams, so adding a mark to a model never perturbs its firing times.
    streams = CompetingClocks.KeyedStreams{StreamKey}(rand(rng, UInt64))
    # "Firing 0": seeding the population may draw initial marks and t = 0
    # dispatch picks; they flow through the same conduit as every other
    # draw, keyed by the reserved (:init, 0, 0) pseudo-clock, and land in
    # the record's init list for replay.
    ds0 = livedraws(streams, INIT_KEY, m.params, θ)
    st = initial_state(m, ds0)
    rec = MarkedRecord()
    rec.init = ds0.consumed
    states = QueueState[]
    keep_states && push!(states, st)
    for k in enabled(m, st)
        enable!(ctx, k, clock_distribution(m, θ, k, st), st.te[k])
    end
    while true
        (t, key) = next(ctx)
        (key === nothing || t > horizon) && break
        fire!(ctx, key, t)
        ds = livedraws(streams, key, m.params, θ)
        st, deltas = fire_changes(m, st, key, t, ds; worklist)
        push_firing!(rec, key, t, ds.consumed)
        keep_states && push!(states, st)
        apply_deltas!(ctx, m, θ, st, deltas, t)
        debug && check_membership(m, st, ctx)
    end
    rec.horizon = Float64(horizon)
    return keep_states ? (rec, states) : rec
end

# D1's sampler-facing half, shared by the interpreter and the branchable
# world: deltas are applied verbatim, with distributions and anchors derived
# from the post-firing state (a banked age is a negative shift; a PS
# re-declaration keeps its original te).
function apply_deltas!(ctx, m::QueueGSMP, θ, st::QueueState, deltas, t::Float64)
    for (op, k) in deltas
        if op == :disable
            disable!(ctx, k)
        else
            dist = clock_distribution(m, θ, k, st)
            shift = st.te[k] - t
            op == :enable ? enable!(ctx, k, dist, shift) : reenable!(ctx, k, dist, shift)
        end
    end
    return nothing
end

# F11's membership half: the recompute is the specification, the deltas are
# the implementation. (The anchor half is the te table replayed by F4.)
function check_membership(m::QueueGSMP, st::QueueState, ctx)
    want = Set(enabled(m, st))
    have = Set(collect(CompetingClocks.enabled(ctx)))
    want == have || error(
        "delta drift: model enables $(collect(setdiff(want, have))), " *
        "sampler holds extra $(collect(setdiff(have, want)))",
    )
    return nothing
end
