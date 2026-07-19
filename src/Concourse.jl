"""
Concourse.jl — a queueing-theory simulation framework.

A queueing network compiles to a generalized semi-Markov process written as
plain data (`QueueGSMP`), interpreted against the CompetingClocks.jl sampler
and satisfying the ClockGradients.jl model contract for derivative
estimation. The normative design lives in `notes/model_definition.tex` and
`notes/event_loop.tex`, which supersede `notes/queue_layers.tex` where they
disagree; the code discharges the falsification charters in those notes'
§7 tables.
"""
module Concourse

using Distributions
using Random: Random
using Random: Xoshiro, randexp
using ClockGradients: ClockGradients
using CompetingClocks: CompetingClocks
using CompetingClocks:
    SamplingContext,
    SamplerBuilder,
    enable!,
    disable!,
    reenable!,
    fire!,
    next,
    NextReactionMethod,
    FirstToFireMethod,
    FirstReactionMethod,
    DirectMethod

include("expr.jl")
include("rounds.jl")
include("network.jl")
include("state.jl")
include("draws.jl")
include("semantics.jl")
include("record.jl")
include("interpret.jl")
include("gradients.jl")
include("branchworld.jl")

# The combinator algebra (A3)
export ScalarExpr, Param, Mark, Enab, Const, InService, InBuffer, Law, Opaque, MarkLaw
export reads_params, reads_marks, reads_time, reads_state
# The surface language
export QueueNetwork, source!, station!, sink!, fork!, join!, route!, populate!, compile
export Batching
# Round-based token service (capability 6)
export Rounds, RoundPolicy, RoundView, RoundJob, RoundPlan, plan_round
export FasterTransformerRule, VanillaVLLM, Orca, Sarathi, ClassPriority
export ClassBudgets, FlowControl
export FCFS, LCFS, SIRO, Priority, ProcessorSharing, SRPT
export Always, ByMark, Probabilistic, RoundRobin, FCFSUnblock
# The IR and its contract functions
export QueueGSMP, QueueState, ClockKey
export initial_state, enabled, clock_distribution, fire_changes, states_equal
# The interpreter and the record
export simulate, MarkedRecord, replay, time_average, number_in_system
export BlockingDeadlock
export FirstToFireMethod, NextReactionMethod, FirstReactionMethod
# The ClockGradients binding
export ReplayModel, replay_model, live_model
export ConcourseWorld, branch_world

end # module Concourse
