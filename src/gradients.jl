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
struct ReplayModel
    m::QueueGSMP
    draws::Union{Nothing,Vector{DrawList}}
end

replay_model(m::QueueGSMP, rec::MarkedRecord) = ReplayModel(m, rec.draws)
live_model(m::QueueGSMP) = ReplayModel(m, nothing)

function _model_draws(rm::ReplayModel, key::ClockKey, st::QueueState)
    rm.draws === nothing && return replaydraws(key, DrawList(), rm.m.params)
    st.nfired < length(rm.draws) ||
        error("replay past the record: firing $(st.nfired + 1) of $(length(rm.draws))")
    replaydraws(key, rm.draws[st.nfired + 1], rm.m.params)
end

ClockGradients.initial_state(rm::ReplayModel) = initial_state(rm.m)
ClockGradients.clockkeytype(rm::ReplayModel) = ClockKey
ClockGradients.enabled(rm::ReplayModel, st::QueueState) = enabled(rm.m, st)
ClockGradients.clock_distribution(rm::ReplayModel, θ::AbstractVector,
                                  key::ClockKey, st::QueueState) =
    clock_distribution(rm.m, θ, key, st)

function ClockGradients.fire(rm::ReplayModel, st::QueueState, key::ClockKey, t)
    first(fire_changes(rm.m, st, key, Float64(t), _model_draws(rm, key, st)))
end

ClockGradients.fire_changes(rm::ReplayModel, st::QueueState, key::ClockKey, t) =
    (ClockGradients.fire(rm, st, key, t), nothing)

ClockGradients.states_equal(rm::ReplayModel, a::QueueState, b::QueueState) =
    states_equal(a, b)

# The framework-record ingestion seam: the bare-trace constructor rebuilds
# back-references and retained uniforms by walking this very contract.
ClockGradients.gradient_record(rm::ReplayModel, rec::MarkedRecord,
                               θ0::AbstractVector) =
    ClockGradients.GradientRecord(rm, θ0, rec.key, rec.time, rec.horizon;
                                  coupling = :redraw)
