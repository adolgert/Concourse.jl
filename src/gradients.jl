# The ClockGradients model contract, implemented by Concourse — the second
# independent client beside the ChronoSim extension, which is what makes the
# contract an abstraction rather than a description of one framework.
#
# A ReplayModel binds one record's auxiliary draws to the QueueGSMP so that
# the contract's θ-free fire can reproduce mark and routing draws by the
# state's own firing counter. fire uses the CD-1 four-argument form only;
# an estimator path that has not been time-threaded fails loudly.

struct ReplayModel
    m::QueueGSMP
    draws::Vector{DrawList}
end

replay_model(m::QueueGSMP, rec::MarkedRecord) = ReplayModel(m, rec.draws)

ClockGradients.initial_state(rm::ReplayModel) = initial_state(rm.m)
ClockGradients.clockkeytype(rm::ReplayModel) = ClockKey
ClockGradients.enabled(rm::ReplayModel, st::QueueState) = enabled(rm.m, st)
ClockGradients.clock_distribution(rm::ReplayModel, θ::AbstractVector,
                                  key::ClockKey, st::QueueState) =
    clock_distribution(rm.m, θ, key, st)

function ClockGradients.fire(rm::ReplayModel, st::QueueState, key::ClockKey, t)
    st.nfired < length(rm.draws) ||
        error("replay past the record: firing $(st.nfired + 1) of $(length(rm.draws))")
    ds = replaydraws(key, rm.draws[st.nfired + 1], rm.m.params)
    first(fire_changes(rm.m, st, key, Float64(t), ds))
end

ClockGradients.states_equal(rm::ReplayModel, a::QueueState, b::QueueState) =
    states_equal(a, b)

# The framework-record ingestion seam: the bare-trace constructor rebuilds
# back-references and retained uniforms by walking this very contract.
ClockGradients.gradient_record(rm::ReplayModel, rec::MarkedRecord,
                               θ0::AbstractVector) =
    ClockGradients.GradientRecord(rm, θ0, rec.key, rec.time, rec.horizon;
                                  coupling = :redraw)
