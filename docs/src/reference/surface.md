# Surface language

```@docs
Concourse.Concourse
```

The surface language is the top layer of Concourse's three-layer design. Its
calls build a [`QueueNetwork`](@ref) value; nothing executes while you build.
[`compile`](@ref) freezes that value into the intermediate representation
(IR) described in [IR and contract](ir.md), which the interpreter, the
checker, and the estimators all read. Laws and ordering keys are written in
the [expression algebra](expressions.md).

## Building a network

```@docs
QueueNetwork
source!
station!
sink!
fork!
join!
route!
populate!
compile
```

## Disciplines

A discipline says how a station keeps its waiting line, which job a free
server takes, whether a better waiting job may evict one in service, and
what an evicted clock remembers. A discipline is a value passed to
[`station!`](@ref), not a station subtype.

```@docs
FCFS
LCFS
SIRO
Priority
ProcessorSharing
SRPT
```

## Routing kernels

A kernel says where a job goes when it leaves a station. Pass one to
[`route!`](@ref).

```@docs
Always
ByMark
Probabilistic
RoundRobin
ShortestQueue
```

## Unblock policies

```@docs
FCFSUnblock
```

## Batch service

A batching policy is a value passed to [`station!`](@ref), like a
discipline; the [batch service manual page](../manual/batching.md) walks
through the semantics.

```@docs
Batching
```
