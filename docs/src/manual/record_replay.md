# The record and replay

Every research workflow in this manual builds on one property: a simulation
run produces a record, and the record replays deterministically. Statistics,
trajectory splitting, and derivative estimation are all built as operations
over records or over live worlds that could have produced them. This page
shows what the record holds and why replay is exact.

## What a run produces

`simulate` returns a `MarkedRecord`. The record is a list with one entry per
firing. An entry holds three things: which clock fired, the time it fired,
and any auxiliary random values the firing consumed.

```@example recreplay
using Concourse

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)

rec = simulate(m, [1.0, 2.0], 100.0; seed = 42)
length(rec)
```

Each entry names a clock by its `ClockKey`, a tuple
`(family, station, jobid)`. The `:arrival` family is a source's
next-arrival clock. The `:service` family is one clock per job in service.
The first few firings of this run:

```@example recreplay
[(rec.key[i], round(rec.time[i], digits = 3)) for i in 1:5]
```

The record also stores its horizon, so time averages know the length of the
observation window:

```@example recreplay
rec.horizon
```

## Replay is a fold

`replay` starts from the initial state and applies the firings one at a
time. It returns the whole state trajectory: index `i + 1` is the state just
after firing `i`.

```@example recreplay
states = replay(m, rec)
length(states) == length(rec) + 1
```

Replay is exact, not approximate. The state change caused by a firing is a
deterministic function once the firing time and the recorded draws are
given. `simulate` can keep its own live states so you can check this claim
directly. `states_equal` compares two states field by field, including the
clock bookkeeping:

```@example recreplay
rec2, live = simulate(m, [1.0, 2.0], 100.0; seed = 42, keep_states = true)
all(states_equal(a, b) for (a, b) in zip(live, replay(m, rec2)))
```

The same seed also reproduces the record itself, entry for entry:

```@example recreplay
rec.key == rec2.key && rec.time == rec2.time
```

## Statistics are folds over the record

Because the state between two firings is constant, a time average is exact:
it is a sum of state values weighted by the gaps between event times.
`time_average` runs that fold for any function of the state.
`number_in_system` counts the jobs currently anywhere in the network.

```@example recreplay
long = simulate(m, [1.0, 2.0], 5000.0; seed = 7)
time_average(number_in_system, m, long)
```

Theory for this M/M/1 queue says the long-run mean is
``\rho/(1-\rho) = 1`` at utilization ``\rho = \lambda/\mu = 0.5``.

Any function of the state works. Utilization is the fraction of time the
server is busy:

```@example recreplay
counter = m.names[:counter]
time_average(st -> Float64(!isempty(st.srv[counter])), m, long)
```

You can also write your own fold directly. Counting departures needs only
the keys:

```@example recreplay
ndepart = count(k -> k[1] == :service, long.key)
ndepart / long.horizon   # departure rate, close to λ = 1 in steady state
```

## Auxiliary draws are recorded too

Clocks carry most of the randomness. Two kinds of randomness are not
clocks: marks (a job's random size or class, drawn at arrival) and random
routing (a weighted coin flip). These auxiliary draws are taken from named
random streams during the live run and written into the record next to the
firing that consumed them. Replay never draws again — it reads the recorded
values back. That rule is what keeps replay exact for models with marks and
coin flips, and it means replay never needs a random number generator or a
parameter vector.

```@example recreplay
net2 = QueueNetwork(param_names = (:lambda, :mu_short, :mu_long))
source!(net2, :arrive;
        interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
        mark = MarkLaw(size = Law(:Exponential, scale = Const(1.0))))
station!(net2, :short; service = Law(:Exponential, scale = inv(Param(:mu_short))))
station!(net2, :long;  service = Law(:Exponential, scale = inv(Param(:mu_long))))
sink!(net2, :done)
route!(net2, :arrive, ByMark(Mark(:size), [2.0], [:short, :long]))
route!(net2, :short, Always(:done))
route!(net2, :long, Always(:done))
msplit = compile(net2)

srec = simulate(msplit, [1.0, 2.0, 2.0], 100.0; seed = 11)
# The first arrival's entry carries the size it drew.
srec.key[1], srec.draws[1]
```

The replay fold reproduces the live trajectory for this model too:

```@example recreplay
srec2, slive = simulate(msplit, [1.0, 2.0, 2.0], 100.0; seed = 11, keep_states = true)
all(states_equal(a, b) for (a, b) in zip(slive, replay(msplit, srec2)))
```

## Why this matters

Determinism given the record is the foundation for everything that follows
in this manual.

- [Statistical analysis](statistics.md) computes batch means and
  regeneration cycles by folding over one record, without re-running the
  simulation.
- [Gradient estimation](gradients.md) replays a record while tracking how
  firing times would shift under a parameter change. That only makes sense
  because replay is exact.
- [Branching worlds](branching.md) extend the same discipline to live
  simulations that run past the end of any record.

The record is deliberately minimal — it is the filtration of the run, in
the statistical sense. Anything you did not record can be reconstructed by
replaying, because replay is cheap and exact.
