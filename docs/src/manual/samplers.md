# Choosing a sampler

The interpreter does not draw firing times itself. It tells
[CompetingClocks.jl](https://github.com/adolgert/CompetingClocks.jl) which
clocks are enabled, with which distributions, and the sampler answers one
question: which clock fires next, and when. Concourse re-exports three
sampler choices and passes your pick through the `method` keyword of
`simulate`:

```julia
simulate(m, θ, horizon; seed = 1, method = NextReactionMethod())
```

- `FirstToFireMethod()` draws a clock's firing time once, when the clock is
  enabled, and keeps it in a queue. It is the simplest and usually the
  fastest choice, and it is what the builder picks when you pass no method.
- `NextReactionMethod()` is Anderson's modified next-reaction method for
  exponential-family clocks and the classic next-reaction method for
  everything else. It reuses draws across re-declarations, which makes it
  the best choice for variance reduction with common random numbers (CRN).
- `FirstReactionMethod()` redraws every enabled clock at every step. That
  is wasteful for large models but very fast for small ones, and redrawing
  at each call is occasionally what you want when resampling paths.

## No sampler is load-bearing

The design claim (decision D4 in
[The event loop](../developer/event_loop.md)) is that sampler choice is a
performance knob, never a correctness knob. Every sampler valid for the
model's distributions must produce statistically identical results, because
the interpreter speaks only the sampler-facing surface (`enable!`,
`disable!`, `reenable!`, `next`, `fire!`) and no model code reaches around
it. The M/M/1 mean under all three methods:

```@example samplers
using Concourse
using Statistics

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)
θ = [1.0, 2.0]

for method in (FirstToFireMethod(), NextReactionMethod(), FirstReactionMethod())
    vals = [time_average(number_in_system, m,
                         simulate(m, θ, 1000.0; seed = r, method))
            for r in 1:12]
    println(nameof(typeof(method)), ": ",
            round(mean(vals), digits = 3), " ± ",
            round(std(vals) / sqrt(12), digits = 3))
end
```

All three straddle the true value 1. The guarantee is statistical, not
pathwise: two methods may or may not reproduce the same trajectory from
the same seed. (Here `FirstToFireMethod` and `NextReactionMethod` happen
to produce identical records for these exponential clocks, while
`FirstReactionMethod` walks a different path to the same distribution.)

```@example samplers
ftf = simulate(m, θ, 100.0; seed = 3, method = FirstToFireMethod())
frm = simulate(m, θ, 100.0; seed = 3, method = FirstReactionMethod())
length(ftf), length(frm), ftf.time == frm.time
```

## Replay does not care either

Whatever sampler produced a record, [replay](record_replay.md) is a fold
over the record and touches no sampler at all. The replayed trajectory
matches the live one for every method — here on a harder model, preemptive
priority with resumed service, with the debug oracle on:

```@example samplers
net2 = QueueNetwork(param_names = (:lambda, :mu))
source!(net2, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(class = Law(:Uniform, a = Const(0.0), b = Const(2.0))))
station!(net2, :cpu;
         discipline = Priority(Mark(:class); preempt = true, memory = :resume),
         servers = 1, service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net2, :done)
route!(net2, :arrive, Always(:cpu))
route!(net2, :cpu, Always(:done))
mp = compile(net2)

for method in (FirstToFireMethod(), NextReactionMethod())
    rec, live = simulate(mp, [1.0, 1.5], 300.0; seed = 21, method,
                         keep_states = true, debug = true)
    ok = all(states_equal(a, b) for (a, b) in zip(live, replay(mp, rec)))
    println(nameof(typeof(method)), " replay exact: ", ok)
end
```

## Practical guidance

- **Plain forward simulation:** pass nothing. The builder chooses, and the
  default (`FirstToFireMethod`) is the fastest for ordinary runs.
- **Paired runs and finite differences:** `NextReactionMethod`. Reusing
  draws per clock gives the tightest CRN coupling across parameter
  changes; see the common-random-numbers section of
  [Statistical analysis](statistics.md).
- **Branchable worlds:** `branch_world` defaults to `NextReactionMethod`
  and you should leave it. The branching protocol requires that peeking at
  the next firing twice gives the same answer, so the sampler must cache
  its reservation. A redraw-at-`next` method would fail
  `ClockGradients.check_branchable` — honestly, at certification time,
  rather than silently in an estimator.
- **Tiny models, many restarts:** `FirstReactionMethod` avoids the queue
  bookkeeping entirely and redraws each call.

If a sampler choice ever changes a *statistical* result, that is a bug in
Concourse or CompetingClocks, not a configuration subtlety — the test
suite (`test/test_samplers.jl`) runs the same oracles under every method
to enforce exactly that.
