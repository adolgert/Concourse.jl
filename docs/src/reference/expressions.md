# Expression algebra

Every random quantity in a model — interarrival times, service times,
patience, marks — is declared as a law written in this small algebra. A law
is data, not a closure, so [`compile`](@ref) can see exactly which
parameters, marks, and times each law reads and check the model statically.
The [surface language](surface.md) consumes these values, and the
[IR](ir.md) evaluates them when clocks are enabled.

## Expressions

```@docs
ScalarExpr
Param
Mark
Enab
Const
InService
InBuffer
```

## Laws

```@docs
Law
Opaque
MarkLaw
```

## Inspection

These predicates report what an expression or law reads. The compile-time
checks are built on them.

```@docs
reads_params
reads_marks
reads_time
reads_state
```
