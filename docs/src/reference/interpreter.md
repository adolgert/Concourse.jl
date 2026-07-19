# Interpreter and record

The interpreter connects the [IR](ir.md) to the bottom layer,
CompetingClocks.jl, which samples the clocks. [`simulate`](@ref) runs the
event loop and writes a [`MarkedRecord`](@ref) — the primary observable.
Every statistic is a fold over the record, and [`replay`](@ref) reproduces
the exact state trajectory from it without touching a random number
generator. The record also feeds the
[gradient estimators](gradients_worlds.md).

## Running and measuring

```@docs
simulate
MarkedRecord
replay
time_average
number_in_system
```

## Auxiliary draws

Every draw that is not a clock — marks, probabilistic routing, SIRO's
pick, a round policy's randomness — flows through one conduit, the draw
source (amendment A4). Live sources record every value into the firing's
draw list; replay sources answer from the record and never touch a random
number generator. A custom [`RoundPolicy`](@ref) is the one place user
code receives a draw source: draw through [`Concourse.draw!`](@ref) and
the policy replays for free.

```@docs
Concourse.DrawSource
Concourse.livedraws
Concourse.replaydraws
Concourse.draw!
```

## Runtime errors

A model compiled with `allow_blocking_cycles = true` (see
[`compile`](@ref)) raises one typed exception when a cycle of full `:block`
buffers wedges; it arrives carrying the partial record, so the deadlock is
replayable evidence. The
[Cycles section](../queues/richer_stations.md#Cycles) of the blocking
tutorial shows it in action.

```@docs
BlockingDeadlock
```

## Samplers

`FirstToFireMethod`, `NextReactionMethod`, and `FirstReactionMethod` are
re-exported from CompetingClocks.jl. Pass one as the `method` keyword of
[`simulate`](@ref) or [`branch_world`](@ref). The manual page
[Choosing a sampler](../manual/samplers.md) discusses when each is the right
choice.
