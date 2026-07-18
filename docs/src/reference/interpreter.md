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

## Samplers

`FirstToFireMethod`, `NextReactionMethod`, and `FirstReactionMethod` are
re-exported from CompetingClocks.jl. Pass one as the `method` keyword of
[`simulate`](@ref) or [`branch_world`](@ref). The manual page
[Choosing a sampler](../manual/samplers.md) discusses when each is the right
choice.
