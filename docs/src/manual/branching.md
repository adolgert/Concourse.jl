# Branching worlds and trajectory splitting

A record replays the past. A branchable world runs the future. It is a live
simulation you can pause, copy, steer, and re-randomize. Trajectory
splitting — "what would have happened if a different event had won this
race?" — and the clone-based derivative estimators are both built on it.

`branch_world` wraps a compiled model in a `ConcourseWorld`, which
implements the branchable-world protocol of ClockGradients.jl. The protocol
is ten small functions, called verbs:

| Verb | Meaning |
|---|---|
| `branch_peek` | look at the next firing (time, clock) without committing it |
| `branch_commit!` | let the peeked winner fire |
| `branch_force!` | make a *different* clock fire at that time |
| `branch_clone` | copy the whole running world |
| `branch_rekey!` | give a world fresh randomness from a seed |
| `branch_time` | the world's current time |
| `branch_enabled_ages` | the enabled clocks and their ages |
| `branch_clock_distribution` | a clock's current firing-time law |
| `branch_state` | the current `QueueState` |
| `branch_schedule` | the pending firing times, in order |

The verbs live in ClockGradients, so call them qualified:
`ClockGradients.branch_peek(w)` and so on.

## Driving a world by hand

The example model routes each arrival by a random size mark: small jobs go
to one station, large jobs to another. Marks and random routing matter here,
because they are exactly the draws a clone must handle carefully.

```@example branching
using Concourse
import ClockGradients

net = QueueNetwork(param_names = (:lambda, :mu_short, :mu_long))
source!(net, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(size = Law(:Exponential, scale = Const(1.0))))
station!(net, :short; service = Law(:Exponential, scale = inv(Param(:mu_short))))
station!(net, :long;  service = Law(:Exponential, scale = inv(Param(:mu_long))))
sink!(net, :done)
route!(net, :arrive, ByMark(Mark(:size), [2.0], [:short, :long]))
route!(net, :short, Always(:done))
route!(net, :long, Always(:done))
m = compile(net)
θ = [1.2, 2.0, 2.0]

w = branch_world(m, θ; seed = 5)

# Advance a world n firings; return the keys that fired and the marks of
# every job seen along the way (jobs vanish at the sink, so collect early).
function advance!(w, n)
    keys = Concourse.ClockKey[]
    seen = Dict{Int64,NamedTuple}()
    for _ in 1:n
        pk = ClockGradients.branch_peek(w)
        pk === nothing && break
        ClockGradients.branch_commit!(w, pk[2], pk[1])
        push!(keys, pk[2])
        merge!(seen, w.state.jobs)
    end
    keys, seen
end

advance!(w, 6)
ClockGradients.branch_time(w), number_in_system(w.state)
```

## A clone continues identically

`branch_clone` copies everything: the state, the pending clocks with their
reserved firing times, and the internal states of the auxiliary random
streams. With no further action, the clone's future is the original's
future, firing for firing — including the sizes of jobs that have not yet
arrived.

```@example branching
c = ClockGradients.branch_clone(w)
kw, jw = advance!(w, 20)
kc, jc = advance!(c, 20)
kw == kc, states_equal(w.state, c.state), jw == jc
```

## Rekeying decouples a clone

`branch_rekey!` re-seeds a world's randomness from a given seed: the clock
streams and the auxiliary streams both. After a rekey, the clone's future is
a fresh, independent draw.

```@example branching
w2 = branch_world(m, θ; seed = 5)
advance!(w2, 6)
c2 = ClockGradients.branch_clone(w2)
ClockGradients.branch_rekey!(c2, 0xDECAF)
k_orig, _ = advance!(w2, 20)
k_new, _ = advance!(c2, 20)
k_orig != k_new
```

Two clones rekeyed with the *same* seed share their randomness with each
other while differing from the original. That controlled sharing is what
makes the difference between two clones quiet: the common randomness
cancels, and only the effect you injected remains.

## Splitting a trajectory

Here is the full splitting idiom. Clone twice, rekey both clones with the
same seed, then commit the peeked winner in one clone and force the
runner-up in the other. From that moment the two trajectories disagree
about event order. The difference between their outcomes measures the
effect of that single decision, with everything else held common.

```@example branching
w3 = branch_world(m, θ; seed = 5)
# Advance until the coming race has at least two contenders.
while length(ClockGradients.branch_enabled_ages(w3)) < 2
    advance!(w3, 1)
end
a = ClockGradients.branch_clone(w3)
b = ClockGradients.branch_clone(w3)
ClockGradients.branch_rekey!(a, 0xA11CE)
ClockGradients.branch_rekey!(b, 0xA11CE)

(tstar, winner) = ClockGradients.branch_peek(a)
runnerup = first(k for (k, _) in ClockGradients.branch_enabled_ages(b) if k != winner)
ClockGradients.branch_commit!(a, winner, tstar)
ClockGradients.branch_force!(b, runnerup, tstar)

ka, ja = advance!(a, 40)
kb, jb = advance!(b, 40)
ka != kb   # the event orders genuinely diverged
```

Even though the orders diverged, corresponding jobs still drew the same
marks in both trajectories:

```@example branching
common = intersect(keys(ja), keys(jb))
length(common) > 5, all(ja[j] == jb[j] for j in common)
```

That alignment is not luck. It is the auxiliary-draw discipline.

## The rules for auxiliary draws

A clone runs forward, past the end of any record. Its future arrivals need
new sizes; its future routing needs new coin flips. The rules that govern
those draws are part of the world's contract:

- **The world owns its auxiliary streams.** They sit beside the sampler's
  clock streams, keyed and separate, so adding a mark to a model never
  perturbs its firing times.
- **A stream key is a stable identity, not a position.** A mark or routing
  draw is keyed by the clock it belongs to — a source's arrival clock, a
  job's service clock — never by its position in a global call sequence.
  The k-th value of a source's mark stream *is* the k-th arrival of that
  source, in any same-seed world, whatever else fired in between. That is
  why the split above kept corresponding jobs' marks matched after the
  orders diverged.
- **Clones copy generator states.** A coupled clone reproduces the
  original's future draws exactly, including draws for jobs not yet born.
- **Rekeys re-seed both families.** `branch_rekey!` re-seeds the clock
  streams and the auxiliary streams. Re-seeding only the clocks would leave
  a clone replaying the original's future sizes and coin flips.
- **Parameter-dependent mark laws are refused.** A mark law that reads `θ`
  would add its own derivative term to every estimator. Until that term is
  implemented, `branch_world` rejects such models at construction, loudly.
  Routing weights and random-order (SIRO) selection are `θ`-free by
  construction, so they are always admitted.

The refusal in action:

```@example branching
net2 = QueueNetwork(param_names = (:lambda, :mu))
source!(net2, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(size = Law(:Exponential, scale = inv(Param(:mu)))))
station!(net2, :cpu; service = Law(:Dirac, value = Mark(:size)))
sink!(net2, :done)
route!(net2, :arrive, Always(:cpu))
route!(net2, :cpu, Always(:done))
mbad = compile(net2)
try
    branch_world(mbad, [1.0, 2.0]; seed = 1)
catch err
    println(err.msg)
end
```

## Certifying a world

ClockGradients ships a conformance checker that exercises the protocol
obligations — peek repeatability, clone coupling, rekey independence, and
the rest — against a world factory. It is the same certification the test
suite runs.

```@example branching
report = ClockGradients.check_branchable(() -> branch_world(m, θ; seed = 44), θ;
                                         nsteps = 20, seed = 0xFACE)
report.pass
```

One practical note: `branch_world` defaults to `NextReactionMethod()` as
its sampler, because that method caches its `next` reservation. Peeking
twice must return the same answer, and a sampler that redraws at every
`next` would fail the certification honestly. See
[Choosing a sampler](samplers.md).

The clone-based derivative estimators — branching and smoothed
perturbation analysis (SPA) — drive these same ten verbs. They are the
subject of [Gradient estimation](gradients.md). Splitting also composes
with ordinary statistics; see the common-random-numbers section of
[Statistical analysis](statistics.md) for a variance-reduction example
built on `branch_world`.
