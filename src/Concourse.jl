"""
Concourse.jl — a queueing-theory simulation framework.

A queueing network compiles to a generalized semi-Markov process written as
plain data (`QueueGSMP`), interpreted against the CompetingClocks.jl sampler
and satisfying the ClockGradients.jl model contract for derivative
estimation. The normative design lives in `notes/model_definition.tex` and
`notes/event_loop.tex`, which supersede `notes/queue_layers.tex` where they
disagree.

Phase-1 code exists to run the falsification charter in
`notes/model_definition.tex` §7 and `notes/event_loop.tex` §7, not to be a
library.
"""
module Concourse

using Distributions
import Random
using Random: Xoshiro, randexp
import ClockGradients
import CompetingClocks
using CompetingClocks: SamplingContext, SamplerBuilder,
    enable!, disable!, reenable!, fire!, next,
    NextReactionMethod, FirstToFireMethod, FirstReactionMethod, DirectMethod

include("expr.jl")
include("network.jl")
include("state.jl")
include("draws.jl")
include("semantics.jl")
include("record.jl")
include("interpret.jl")
include("gradients.jl")

# The combinator algebra (A3)
export ScalarExpr, Param, Mark, Enab, Const, Law, Opaque, MarkLaw
export reads_params, reads_marks, reads_time
# The surface language
export QueueNetwork, source!, station!, sink!, route!, compile
export FCFS, LCFS, SIRO, Priority, ProcessorSharing
export Always, ByMark, Probabilistic, RoundRobin, FCFSUnblock
# The IR and its contract functions
export QueueGSMP, QueueState, ClockKey
export initial_state, enabled, clock_distribution, fire_changes, states_equal
# The interpreter and the record
export simulate, MarkedRecord, replay, time_average, number_in_system
export FirstToFireMethod, NextReactionMethod, FirstReactionMethod
# The ClockGradients binding
export ReplayModel, replay_model

end # module Concourse
