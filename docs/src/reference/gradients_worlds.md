# Gradients and worlds

This layer binds Concourse to ClockGradients.jl for derivative estimation.
A [`ReplayModel`](@ref) implements the ClockGradients model contract over
the record of [the interpreter](interpreter.md), which admits the score and
IPA (infinitesimal perturbation analysis) estimators. A
[`ConcourseWorld`](@ref) implements the branchable-world protocol, which
admits the clone-based estimators: weak-derivative branching and SPA
(smoothed perturbation analysis). Both are thin wrappers over the contract
functions of [IR and contract](ir.md).

## The model contract

```@docs
ReplayModel
replay_model
live_model
```

## The branchable world

```@docs
ConcourseWorld
branch_world
```
