# The event loop of notes/event_loop.tex §6: everything model-specific is
# inside fire_changes, everything stochastic is in the context and the draw
# source, everything observable is the record. This loop should never grow.

"""
    simulate(m, θ, horizon; seed, method=nothing, worklist=:fifo,
             debug=false, keep_states=false) -> MarkedRecord

`method=nothing` lets CompetingClocks' builder choose the sampler (D4); pass
a `SamplerSpec` (e.g. `FirstToFireMethod()`) to override. `debug=true` runs
the F11 membership oracle after every firing. `keep_states=true` also returns
the live state trajectory for comparison against `replay` (F4).
"""
function simulate(m::QueueGSMP, θ::AbstractVector, horizon::Real;
                  seed::Integer=0, method=nothing, worklist::Symbol=:fifo,
                  debug::Bool=false, keep_states::Bool=false)
    rng = Xoshiro(seed)
    ctx = SamplingContext(SamplerBuilder(ClockKey, Float64; method), rng)
    # Auxiliary draws get their own keyed streams, independent of the clock
    # streams, so adding a mark to a model never perturbs its firing times.
    streams = CompetingClocks.KeyedStreams{StreamKey}(rand(rng, UInt64))
    st = initial_state(m)
    rec = MarkedRecord()
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
    keep_states ? (rec, states) : rec
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
            op == :enable ? enable!(ctx, k, dist, shift) :
                            reenable!(ctx, k, dist, shift)
        end
    end
    nothing
end

# F11's membership half: the recompute is the specification, the deltas are
# the implementation. (The anchor half is the te table replayed by F4.)
function check_membership(m::QueueGSMP, st::QueueState, ctx)
    want = Set(enabled(m, st))
    have = Set(collect(CompetingClocks.enabled(ctx)))
    want == have ||
        error("delta drift: model enables $(collect(setdiff(want, have))), " *
              "sampler holds extra $(collect(setdiff(have, want)))")
    nothing
end
