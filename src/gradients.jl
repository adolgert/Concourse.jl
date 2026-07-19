# The ClockGradients model contract, implemented by Concourse — the second
# independent client beside the ChronoSim extension, which is what makes the
# contract an abstraction rather than a description of one framework.
#
# A ReplayModel binds one record's auxiliary draws to the QueueGSMP so that
# the contract's θ-free fire can reproduce mark and routing draws by the
# state's own firing counter. fire uses the CD-1 four-argument form only;
# an estimator path that has not been time-threaded fails loudly.

# `draws === nothing` is the LIVE binding for off-record use (the branchable
# estimators continue past any record): fire then runs with an empty draw
# source, so a model whose fire consumes auxiliary randomness fails loudly
# instead of replaying stale draws. Only draw-free models may branch.
"""
    ReplayModel

Concourse's implementation of the ClockGradients.jl model contract: a
[`QueueGSMP`](@ref) bound to a source of auxiliary draws, so the contract's
θ-free `fire` can reproduce mark and routing draws indexed by the state's
own firing counter. Build one with [`replay_model`](@ref) (bound to a
record) or [`live_model`](@ref) (no record, for draw-free models). Pass it
to `ClockGradients.gradient_record`, `score_gradient`, `ipa_gradient`, and
`spa_gradient`.
"""
struct ReplayModel
    m::QueueGSMP
    draws::Union{Nothing,Vector{DrawList}}
    init::DrawList        # the record's "firing 0" draws; seeds the population
end

"""
    replay_model(m::QueueGSMP, rec::MarkedRecord) -> ReplayModel

Bind the model to the auxiliary draws of one record, for gradient
estimation over that record. Replaying the draws keeps `fire` deterministic
and free of `θ`, which the ClockGradients.jl estimators require.

# Example

```julia
rec = simulate(m, θ, horizon; seed = 1)
rm = replay_model(m, rec)
grec = ClockGradients.gradient_record(rm, rec, θ)
ClockGradients.score_gradient(rm, θ, grec)
```
"""
replay_model(m::QueueGSMP, rec::MarkedRecord) = ReplayModel(m, rec.draws, rec.init)

"""
    live_model(m::QueueGSMP) -> ReplayModel

The off-record binding, for estimators that continue past any record, such
as `ClockGradients.spa_gradient` (SPA = smoothed perturbation analysis).
`fire` runs with an empty draw source, so this binding works only for
models that consume no auxiliary randomness — no marks, no
[`Probabilistic`](@ref) routing, no [`SIRO`](@ref), and no
[`populate!`](@ref) mark laws (the init binding is empty too, so a drawn
initial mark fails loudly at seeding). A model that asks for a draw fails
loudly instead of replaying stale values.
"""
live_model(m::QueueGSMP) = ReplayModel(m, nothing, DrawList())

function _model_draws(rm::ReplayModel, key::ClockKey, st::QueueState)
    rm.draws === nothing && return replaydraws(key, DrawList(), rm.m.params)
    st.nfired < length(rm.draws) ||
        error("replay past the record: firing $(st.nfired + 1) of $(length(rm.draws))")
    return replaydraws(key, rm.draws[st.nfired + 1], rm.m.params)
end

function ClockGradients.initial_state(rm::ReplayModel)
    return initial_state(rm.m, replaydraws(INIT_KEY, rm.init, rm.m.params))
end
ClockGradients.clockkeytype(rm::ReplayModel) = ClockKey
ClockGradients.enabled(rm::ReplayModel, st::QueueState) = enabled(rm.m, st)
function ClockGradients.clock_distribution(
    rm::ReplayModel, θ::AbstractVector, key::ClockKey, st::QueueState
)
    return clock_distribution(rm.m, θ, key, st)
end

function ClockGradients.fire(rm::ReplayModel, st::QueueState, key::ClockKey, t)
    return first(fire_changes(rm.m, st, key, Float64(t), _model_draws(rm, key, st)))
end

function ClockGradients.fire_changes(rm::ReplayModel, st::QueueState, key::ClockKey, t)
    return (ClockGradients.fire(rm, st, key, t), nothing)
end

ClockGradients.states_equal(rm::ReplayModel, a::QueueState, b::QueueState) = states_equal(a, b)

# SharedRemaining's invlogccdf delegates to the base law's invlogccdf plus
# arithmetic, so pathwise duals flow through it exactly when they flow
# through the base law (ClockGradients' documented extension point).
ClockGradients._dual_safe(d::SharedRemaining) = ClockGradients._dual_safe(d.base)

# The framework-record ingestion seam: the bare-trace constructor rebuilds
# back-references and retained uniforms by walking this very contract.
function ClockGradients.gradient_record(rm::ReplayModel, rec::MarkedRecord, θ0::AbstractVector)
    return ClockGradients.GradientRecord(rm, θ0, rec.key, rec.time, rec.horizon; coupling=:redraw)
end
