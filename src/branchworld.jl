# The branchable world: ClockGradients' ten-verb protocol implemented over
# (QueueGSMP, QueueState, SamplingContext), which admits the clone-based
# estimators (weak-derivative branching; SPA for frozen-law models). The
# world is the second implementation of the protocol beside the ChronoSim
# extension — same test of the abstraction as the model contract.
#
# Scope: draw-free models only. Branch worlds run FORWARD past any record, so
# a model whose fire consumes auxiliary randomness (marks, probabilistic
# routing, SIRO) would need live keyed draw streams with clone/rekey
# semantics of their own — a design not yet written. The factory refuses such
# models up front rather than failing mid-estimate.

mutable struct ConcourseWorld{C}
    m::QueueGSMP
    θ::Vector{Float64}
    state::QueueState
    ctx::C
    time::Float64
end

function _assert_draw_free(m::QueueGSMP)
    for stn in m.stations
        stn.mark === nothing || throw(ArgumentError(
            "branchable worlds need draw-free models; source $(stn.name) draws marks"))
        stn.routing !== nothing && stn.routing.kind == :probabilistic &&
            throw(ArgumentError(
                "branchable worlds need draw-free models; $(stn.name) routes probabilistically"))
        stn.discipline.select == :random && throw(ArgumentError(
            "branchable worlds need draw-free models; $(stn.name) selects at random"))
    end
    nothing
end

"""
    branch_world(m, θ; seed, method=NextReactionMethod()) -> ConcourseWorld

An initialized, ready-to-peek branchable world at primal `θ`. The default
sampler method caches its `next` reservation, which the protocol's
peek-repeatability obligation requires; a redraw-at-next method would fail
`check_branchable` honestly.
"""
function branch_world(m::QueueGSMP, θ::AbstractVector; seed::Integer,
                      method=NextReactionMethod())
    _assert_draw_free(m)
    ctx = SamplingContext(SamplerBuilder(ClockKey, Float64; method), Xoshiro(seed))
    st = initial_state(m)
    for k in enabled(m, st)
        enable!(ctx, k, clock_distribution(m, θ, k, st), st.te[k])
    end
    ConcourseWorld(m, collect(Float64, θ), st, ctx, 0.0)
end

function ClockGradients.branch_peek(w::ConcourseWorld)
    (t, k) = next(w.ctx)
    (k === nothing || !isfinite(t)) && return nothing
    (t, k)
end

# Commit and force share one update path — the resulting world depends on
# which transition ran, not on why it ran (the protocol's force obligation).
function _world_apply!(w::ConcourseWorld, key::ClockKey, t::Float64)
    ds = replaydraws(key, DrawList(), w.m.params)
    st, deltas = fire_changes(w.m, w.state, key, t, ds)
    apply_deltas!(w.ctx, w.m, w.θ, st, deltas, t)
    w.state = st
    w.time = t
    w
end

function ClockGradients.branch_commit!(w::ConcourseWorld, key, tstar)
    fire!(w.ctx, key, Float64(tstar))
    _world_apply!(w, key, Float64(tstar))
end

function ClockGradients.branch_force!(w::ConcourseWorld, key, tstar)
    CompetingClocks.force_fire!(w.ctx, key, Float64(tstar))
    _world_apply!(w, key, Float64(tstar))
end

# clone(ctx, rng) is deliberately fresh-and-empty; the COUPLED copy is
# empty-clone + copy_clocks! + time restore (the same idiom ChronoSim's
# clone uses), so the clone's continuation is bit-for-bit the original's
# until an explicit branch_rekey!.
function ClockGradients.branch_clone(w::ConcourseWorld)
    ctx2 = CompetingClocks.clone(w.ctx, copy(w.ctx.rng))
    CompetingClocks.copy_clocks!(ctx2, w.ctx)
    ctx2.time = w.ctx.time
    ConcourseWorld(w.m, w.θ, copystate(w.state), ctx2, w.time)
end

# Rekey-then-jitter, the same pairing the ChronoSim adapter uses: reseeding
# the keyed streams alone would leave the backend's cached putative firing
# times replaying the old randomness; jitter! resamples every scheduled clock
# at the current time conditioned on survival, a resample at a stopping time.
function ClockGradients.branch_rekey!(w::ConcourseWorld, seed)
    CompetingClocks.rekey_streams!(w.ctx.sampler, UInt64(seed))
    CompetingClocks.jitter!(w.ctx.sampler, w.time)
    w
end

ClockGradients.branch_time(w::ConcourseWorld) = w.time

# Ages come from the model state's own te table (the A1 invariant says the
# sampler agrees), sorted by key as the protocol's coupling contract demands.
function ClockGradients.branch_enabled_ages(w::ConcourseWorld)
    ks = sort!(enabled(w.m, w.state))
    [(k, w.time - w.state.te[k]) for k in ks]
end

ClockGradients.branch_clock_distribution(w::ConcourseWorld, θ::AbstractVector, key) =
    clock_distribution(w.m, θ, key, w.state)

ClockGradients.branch_state(w::ConcourseWorld) = w.state

# The optional tenth verb (TruncatedHazard's runner-up residual): scheduled
# putative times read from the sampler's public per-clock indexer.
function ClockGradients.branch_schedule(w::ConcourseWorld)
    sched = [(k, w.ctx.sampler[k]) for (k, _) in ClockGradients.branch_enabled_ages(w)]
    sort!(sched; by = p -> p[2])
    sched
end
