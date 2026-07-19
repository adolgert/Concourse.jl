# The branchable world: ClockGradients' ten-verb protocol implemented over
# (QueueGSMP, QueueState, SamplingContext), which admits the clone-based
# estimators (weak-derivative branching; SPA for frozen-law models). The
# world is the second implementation of the protocol beside the ChronoSim
# extension — same test of the abstraction as the model contract.
#
# Auxiliary draws (marks, probabilistic routing, SIRO): the world owns live
# keyed streams beside the sampler — the Q1 decision. The stream key is the
# stable identity the draw belongs to, never a position in a global call
# sequence: a mark or source-routing draw is keyed by the source's own clock
# and consumed once per arrival, so the k-th value IS the k-th arrival of
# that source in any same-seed world, whatever else fired in between. A
# station's routing or SIRO draw is keyed by the job's clock and stays
# aligned exactly when job identities do. Clone copies the streams with
# their generator states; rekey re-seeds them with the clock streams. No
# jitter analogue exists because auxiliary draws are consumed at firings,
# never scheduled ahead.
#
# θ-dependent MARK laws stay refused: the mark's own derivative would add a
# term to every estimator (design brief Q1's separable sub-question).
# Routing weights and SIRO selection are θ-free by construction.

"""
    ConcourseWorld

A branchable simulation world: the compiled model, its parameter values,
the current state, a CompetingClocks.jl sampling context, and keyed streams
for auxiliary draws. It implements ClockGradients.jl's branchable-world
protocol (`branch_peek`, `branch_commit!`, `branch_force!`,
`branch_clone`, `branch_rekey!`, and the rest), which admits the
clone-based estimators such as `ClockGradients.branching_gradient`. Build
one with [`branch_world`](@ref).

A clone carries the auxiliary generators' states, so an unrekeyed clone's
future is bit-for-bit the original's. After `branch_rekey!`, same-seed
clones still agree on corresponding jobs' draws, because each draw is keyed
by the clock it belongs to, never by a position in a global call sequence.
"""
mutable struct ConcourseWorld{C}
    m::QueueGSMP
    θ::Vector{Float64}
    state::QueueState
    ctx::C
    streams::CompetingClocks.KeyedStreams{StreamKey}
    time::Float64
end

function _assert_thetafree_marks(m::QueueGSMP)
    # Remark laws are mark laws drawn at deposit instead of at birth; a
    # θ-reading remark would add the same unimplemented derivative term as a
    # θ-reading source mark, so the refusal extends verbatim.
    for stn in m.stations
        for (kindword, ml) in (("mark", stn.mark), ("remark", stn.remark))
            ml === nothing && continue
            for (name, law) in ml.laws
                ps = reads_params(law)
                isempty(ps) || throw(
                    ArgumentError(
                        "branchable worlds support θ-free marks only for now; $kindword " *
                        "$name of $(stn.name) reads parameters $(sort!(collect(ps)))",
                    ),
                )
            end
        end
    end
    # Population mark laws are mark laws; a θ-reading initial mark would add
    # the same unimplemented derivative term as a θ-reading source mark.
    for p in m.population
        p.mark === nothing && continue
        for (name, law) in p.mark.laws
            ps = reads_params(law)
            isempty(ps) || throw(
                ArgumentError(
                    "branchable worlds support θ-free marks only for now; initial " *
                    "mark $name of the population at $(m.stations[p.station].name) " *
                    "reads parameters $(sort!(collect(ps)))",
                ),
            )
        end
    end
    return nothing
end

# State-dependent service laws stay refused: pathwise branching replays one
# event order against another, and when reordering changes an occupancy, an
# occupancy-dependent law changes with it — the clone-based estimators'
# unbiasedness argument does not cover that coupling. The score estimator
# (score_gradient over replay_model) handles these models.
function _assert_stateless_service(m::QueueGSMP)
    for stn in m.stations
        stn.kind == :station || continue
        stn.service === nothing && continue
        ss = reads_state(stn.service)
        isempty(ss) || throw(
            ArgumentError(
                "branchable worlds support state-blind service laws only for now; " *
                "the service law of $(stn.name) reads occupancy of " *
                "$(sort!(collect(ss))), and pathwise branching is not guaranteed " *
                "unbiased when event reordering changes an occupancy-dependent " *
                "law — use the score estimator instead",
            ),
        )
    end
    return nothing
end

"""
    branch_world(m, θ; seed, method=NextReactionMethod()) -> ConcourseWorld

An initialized, ready-to-peek branchable world for model `m` at parameter
vector `θ`. `seed` seeds both the sampler's clock streams and the world's
auxiliary streams. The default sampler method caches its `next`
reservation, which the protocol's peek-repeatability obligation requires; a
redraw-at-next method would fail `ClockGradients.check_branchable`
honestly.

Marks, [`Probabilistic`](@ref) routing, and [`SIRO`](@ref) are admitted
because their draws are θ-free. A mark law that reads a parameter — a
source's, or a station's deposit-time `remark` — is
refused with an `ArgumentError`: its own derivative would add a term to
every estimator, and that term is not implemented. A service law that reads
station occupancy ([`InService`](@ref)/[`InBuffer`](@ref)) is refused too:
pathwise branching is not guaranteed unbiased when event reordering changes
an occupancy-dependent law — use the score estimator for those models.

A [`populate!`](@ref) population follows the same rules: a θ-reading
initial mark law is refused like a source's, and because a branchable world
seeds from the zero-argument [`initial_state`](@ref), any *drawn* initial
mark fails loudly at seeding — only draw-free populations branch.

# Example

```julia
res = ClockGradients.branching_gradient(
    () -> branch_world(m, θ; seed = 81), θ,
    st -> Float64(number_in_system(st));
    nreps = 1200, horizon = 5.0, seed = 17, branch_rng_seed = 18)
```
"""
function branch_world(m::QueueGSMP, θ::AbstractVector; seed::Integer, method=NextReactionMethod())
    _assert_thetafree_marks(m)
    _assert_stateless_service(m)
    rng = Xoshiro(seed)
    ctx = SamplingContext(SamplerBuilder(ClockKey, Float64; method), rng)
    # The interpreter's own seeding order: the auxiliary family's seed is the
    # next UInt64 off the master rng, after the context has taken its share.
    streams = CompetingClocks.KeyedStreams{StreamKey}(rand(rng, UInt64))
    st = initial_state(m)
    for k in enabled(m, st)
        enable!(ctx, k, clock_distribution(m, θ, k, st), st.te[k])
    end
    return ConcourseWorld(m, collect(Float64, θ), st, ctx, streams, 0.0)
end

function ClockGradients.branch_peek(w::ConcourseWorld)
    (t, k) = next(w.ctx)
    (k === nothing || !isfinite(t)) && return nothing
    return (t, k)
end

# Commit and force share one update path — the resulting world depends on
# which transition ran, not on why it ran (the protocol's force obligation).
function _world_apply!(w::ConcourseWorld, key::ClockKey, t::Float64)
    ds = livedraws(w.streams, key, w.m.params, w.θ)
    st, deltas = fire_changes(w.m, w.state, key, t, ds)
    apply_deltas!(w.ctx, w.m, w.θ, st, deltas, t)
    w.state = st
    w.time = t
    return w
end

function ClockGradients.branch_commit!(w::ConcourseWorld, key, tstar)
    fire!(w.ctx, key, Float64(tstar))
    return _world_apply!(w, key, Float64(tstar))
end

function ClockGradients.branch_force!(w::ConcourseWorld, key, tstar)
    CompetingClocks.force_fire!(w.ctx, key, Float64(tstar))
    return _world_apply!(w, key, Float64(tstar))
end

# clone(ctx, rng) is deliberately fresh-and-empty; the COUPLED copy is
# empty-clone + copy_clocks! + time restore (the same idiom ChronoSim's
# clone uses), so the clone's continuation is bit-for-bit the original's
# until an explicit branch_rekey!.
function ClockGradients.branch_clone(w::ConcourseWorld)
    ctx2 = CompetingClocks.clone(w.ctx, copy(w.ctx.rng))
    CompetingClocks.copy_clocks!(ctx2, w.ctx)
    ctx2.time = w.ctx.time
    # copy carries the auxiliary generators' STATES, so the clone's next mark
    # or routing draw equals the original's (the Q1 copying obligation).
    return ConcourseWorld(w.m, w.θ, copystate(w.state), ctx2, copy(w.streams), w.time)
end

# Rekey-then-jitter, the same pairing the ChronoSim adapter uses: reseeding
# the keyed streams alone would leave the backend's cached putative firing
# times replaying the old randomness; jitter! resamples every scheduled clock
# at the current time conditioned on survival, a resample at a stopping time.
function ClockGradients.branch_rekey!(w::ConcourseWorld, seed)
    CompetingClocks.rekey_streams!(w.ctx.sampler, UInt64(seed))
    CompetingClocks.jitter!(w.ctx.sampler, w.time)
    # Re-seed the auxiliary family too (the Q1 re-seeding obligation): clock
    # streams alone would leave the clone replaying the original's future
    # sizes and coin flips. Same-seed clones share both families, which is
    # what keeps corresponding jobs' draws matched across them.
    CompetingClocks.rekey_streams!(w.streams, UInt64(seed))
    return w
end

ClockGradients.branch_time(w::ConcourseWorld) = w.time

# Ages come from the model state's own te table (the A1 invariant says the
# sampler agrees), sorted by key as the protocol's coupling contract demands.
function ClockGradients.branch_enabled_ages(w::ConcourseWorld)
    ks = sort!(enabled(w.m, w.state))
    return [(k, w.time - w.state.te[k]) for k in ks]
end

function ClockGradients.branch_clock_distribution(w::ConcourseWorld, θ::AbstractVector, key)
    return clock_distribution(w.m, θ, key, w.state)
end

ClockGradients.branch_state(w::ConcourseWorld) = w.state

# The optional tenth verb (TruncatedHazard's runner-up residual): scheduled
# putative times read from the sampler's public per-clock indexer.
function ClockGradients.branch_schedule(w::ConcourseWorld)
    sched = [(k, w.ctx.sampler[k]) for (k, _) in ClockGradients.branch_enabled_ages(w)]
    sort!(sched; by=p -> p[2])
    return sched
end
