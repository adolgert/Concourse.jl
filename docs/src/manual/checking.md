# Checking your model

A queueing model can be wrong before it runs, and a simulator can drift
from its model while it runs. Concourse checks both. The compiled model is
plain data — every law is an inspectable expression, not a closure — so
static checks are total functions of the model value, and the runtime
checks compare the simulator against the model's own definition.

## Checks at compile time

`compile(net)` refuses broken networks with an error that names the
problem. Structural mistakes come first: a route to a station that does not
exist, a station with no route out, a law that reads an unknown parameter.

```@example checking
using Concourse

net = QueueNetwork(param_names = (:mu,))
station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
route!(net, :a, Always(:nowhere))
try
    compile(net)
catch err
    println(err.msg)
end
```

Mark use is a dataflow check over the routing graph: a law may only read
marks that every source reaching it produces.

```@example checking
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :a; service = Law(:Exponential, scale = Mark(:size) * inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:a))
route!(net, :a, Always(:done))
try
    compile(net)
catch err
    println(err.msg)
end
```

Deadlock from blocking is detected statically. A cycle of stations whose
buffers can all fill and block each other would freeze the simulation; the
compiler rejects the cycle instead. The same loop with `:drop` overflow
cannot deadlock and compiles fine.

```@example checking
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))),
         capacity = 1, overflow = :block)
station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu))),
         capacity = 1, overflow = :block)
sink!(net, :done)
route!(net, :arrive, Always(:a))
route!(net, :a, Probabilistic(:b => 0.5, :done => 0.5))
route!(net, :b, Probabilistic(:a => 0.5, :done => 0.5))
try
    compile(net)
catch err
    println(err.msg)
end
```

## Stability, per parameter value

A network can be well formed and still saturate at the parameters you
chose. `Concourse.stability` (not exported) solves the traffic equations
and reports each station's utilization ``\rho``, warning when a station is
at or beyond capacity.

```@example checking
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)

Concourse.stability(m, [1.0, 2.0])
```

```@example checking
Concourse.stability(m, [3.0, 2.0])   # warns: ρ = 1.5
```

An unstable queue is not an error — you may be studying overload on
purpose — so this check warns instead of throwing.

## Checks at run time

### Replay as an oracle

The strongest routine check costs one keyword.
`simulate(...; keep_states = true)` returns the live state trajectory next
to the record, and `states_equal` compares each live state against the
[replay](record_replay.md) fold, field by field — buffers, jobs, clock
enabling times, banked ages, everything.

```@example checking
rec, live = simulate(m, [1.0, 2.0], 500.0; seed = 7, keep_states = true)
all(states_equal(a, b) for (a, b) in zip(live, replay(m, rec)))
```

If a model change ever breaks the determinism of replay — a draw that
bypassed the recording discipline, state hidden outside `QueueState` —
this comparison fails at the first divergent firing.

### The debug oracle

The event loop keeps the sampler's enabled set in sync with the model's by
applying small deltas: enable this clock, disable that one. The
`debug = true` keyword turns on the membership oracle, which recomputes
the model's full enabled set after every firing and errors on the first
drift between model and sampler, naming the clocks that disagree.

```@example checking
rec = simulate(m, [1.0, 2.0], 500.0; seed = 7, debug = true)
length(rec)   # ran clean: model and sampler agreed after every firing
```

The oracle roughly doubles the cost of a run, which is cheap insurance
everywhere except your largest production sweeps. The test suite runs
with `debug = true` as a matter of course, and new station types or
disciplines should be developed with it on: the recompute is the
specification, and the deltas are the implementation being checked
against it.

### Certifying a branchable world

For work with [branching worlds](branching.md), one more check applies:
`ClockGradients.check_branchable` exercises the world protocol —
peek repeatability, clone coupling, rekey independence — against a world
factory and reports pass or fail with diagnostics. Run it once for any new
model you intend to branch.

## The habit

The checks are layered so each catches what the previous cannot: `compile`
catches structure, `stability` catches parameters, replay catches recording
discipline, and the debug oracle catches event-loop drift. Together they
are the working answer to the question every simulation paper gets asked —
"why should I believe your simulator?" — and they are cheap enough to
leave on while you build.
