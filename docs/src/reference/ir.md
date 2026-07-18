# IR and contract

The intermediate representation (IR) is the middle layer: a generalized
semi-Markov process (GSMP) written as plain data ([`QueueGSMP`](@ref))
together with a state ([`QueueState`](@ref)). Five contract functions define
the model's dynamics, and everything above drives the model only through
them: the [interpreter](interpreter.md) folds `fire_changes` forward, and
the [gradient layers](gradients_worlds.md) implement the ClockGradients.jl
contracts with these same functions. The [surface language](surface.md)
produces a `QueueGSMP` with `compile`.

## Data

```@docs
QueueGSMP
QueueState
ClockKey
```

## The five contract functions

```@docs
initial_state
enabled
clock_distribution
fire_changes
states_equal
```
