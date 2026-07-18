# The model contract

This page translates `notes/model_definition.tex`, the normative statement
of what a Concourse model *is*. It amends the three-layer design described
in [Architecture](architecture.md); where the two disagree, this one wins.

The note makes four amendments, labeled A1–A4, and states each so that a
test could refute it. The refutation tests are collected in the
[falsification charter](#the-falsification-charter) at the end of this page.

## A1: clock bookkeeping is model state

A generalized semi-Markov process (GSMP) has Markov state
``(s, \text{clock readings})``. The original design put ``s`` in
`QueueState` and left the clock readings — enabling times and accrued ages —
inside the sampler. That split fails twice:

1. **It breaks `fire`'s purity for age-reading disciplines.** Shortest
   remaining processing time (SRPT) compares remaining sizes, which are size
   marks minus ages. `:resume` re-enabling needs the banked age. If ages
   live only in the sampler, the model must query the sampler mid-firing,
   which inverts the layering.
2. **It makes replay ambiguous for time-varying laws.** The score
   estimator's replay evaluates each clock's distribution at states *later*
   than that clock's enabling. A time-varying law must be anchored at the
   clock's enabling time. Only a per-clock enabling-time table inside the
   state gives the same answer no matter which state the replay asks from.

So `QueueState` carries two dictionaries: `te`, the enabling time of every
enabled clock, and `bank`, the accrued age of every disabled `:resume`
clock. A clock entering the enabled set at time ``t`` gets
``te[k] = t - bank[k]``; a `:resume` clock leaving without firing banks
``t - te[k]``; a `:fresh` clock's bank is discarded. A clock's age at any
state is readable from the state alone — no model code ever calls the
sampler's age query.

Two consequences. First, state equality and record replay now compare the
clock bookkeeping too, so a divergence between the model's ages and the
sampler's is detectable rather than silent: the runtime invariant is that
`st.te` equals the sampler's enabling times after every firing. Second, the
state stays plain data that copies, hashes, and diffs.

**Contract delta CD-1.** `fire` must stamp the state's time and the new
`te` entries, so it needs the firing time. The ClockGradients.jl contract
passed only `fire(model, state, key)`; the amendment adds a four-argument
form `fire(model, state, key, t)` with the three-argument form as a
fallback, so existing time-free models are untouched. The alternative —
keeping `fire` time-free and expressing every law in age coordinates — was
rejected because it silently forbids wall-clock-inhomogeneous laws, which
are a stated goal.

## A2: the clock-family set is open

The original design claimed two clock families (`:arrival`, `:service`)
suffice. The claim holds for the initial feature set and fails one step
outside it: *reneging* — a patience clock on a job that is waiting, not in
service — is bread-and-butter queueing and is a third family. Server
breakdowns would be a fourth. The claim was demoted from an architectural
assumption to a statement about the initial feature set, and the
architecture was changed to make adding a family cheap.

A clock family is a registry entry: who is enabled (`enumerate`), what law
each clock carries (`law`), and what firing means (`fire`). The `enabled`
function is the concatenation of each family's enumeration in registry
order, which keeps the deterministic ordering the contract requires. The
interpreter, the record fold, the checker, and the estimators never mention
a family by name. What stays closed: a family's `fire` still works through
the shared `deposit!`/`settle!` vocabulary, so disciplines and routing
compose with new families instead of each family reinventing station
semantics.

The acid test is charter item F2: adding `:patience` must touch the
registry and the surface constructor and nothing else. Running that test
falsified the first delta-emission mechanism and forced a repair — see
[the D1 refinement](event_loop.md#deltas-are-derived-not-emitted).

## A3: every function-valued field is a combinator value

The IR's advertised virtue is that it is *data* — printable, diffable,
checkable. Plain-function fields for laws, marks, and kernels quietly
forfeit that: closures cannot be hashed, compared, or inspected, and the
checks that justify the IR need to know what a law reads and whether it
depends on ``\theta``.

The fix is one small expression algebra. `Param(:mu)` reads a parameter by
name, `Mark(:size)` reads a job mark, `Enab()` reads the enabling time,
`Const(2.0)` is a constant, and arithmetic is lifted over these. A law is a
distribution family applied to such expressions:

```julia
service = Law(Exponential, scale = Mark(:size) * inv(Param(:mu_short)))
```

Predicates like `reads_θ`, `reads_marks`, and `reads_time` are *derived* by
walking the tree, not declared. Mark typing (check C2) becomes a dataflow
check over values, and the randomness census (C6) and the estimator
validity table are computed, not asserted.

There is one escape hatch, `Opaque`, which wraps an arbitrary function but
*must* declare its reads. The checker trusts the declaration, marks every
conclusion resting on it as unverified, and degrades the estimator tiers it
cannot certify. A closure with no declaration is a construction-time error.
Charter item F3 measures whether the algebra is rich enough that the hatch
stays shut for the standard models.

## A4: no hidden randomness

Two kinds of randomness are not clocks: marks drawn at arrival, and random
choices (probabilistic routing, random-order selection). A4 makes the rule
"every draw is a clock, a recorded mark, or a recorded choice" a
signature-level fact: any function that may draw receives an explicit draw
source as an argument. In live simulation the draw source wraps keyed
random streams, keyed by (clock, purpose) rather than by position in a
global call sequence, and every drawn value is appended to the record. In
replay, the draw source *is* the recorded sequence, and drawing returns the
recorded values in consumption order.

This is exactly the conditioning that makes `fire` deterministic given the
record, and it is what the likelihood's mark and routing terms require.

## The amended contract surface

Concourse implements the ClockGradients model contract. The working
surface is five functions over `(QueueGSMP, QueueState)`:

| Function | What it does |
|---|---|
| `initial_state(m)` | empty places; `te` and `bank` empty; time zero |
| `enabled(m, st)` | the enabled clock keys, in deterministic registry order |
| `clock_distribution(m, θ, k, st)` | the clock's declared law, anchored from `st.te` |
| `fire_changes(m, st, k, t)` | the new state plus the clock deltas the firing caused |
| `states_equal(a, b)` | value equality, including the clock bookkeeping |

`fire_changes` is the delta-emitting form of `fire` chosen by decision D1
(see [The event loop](event_loop.md#d1-fire-emits-clock-deltas)); both
carry the CD-1 time argument. Replay determinism is conditional on the
recorded draws (A4), and `states_equal` comparing `te` and `bank` is what
makes divergences visible (A1). Concourse is the second independent
implementation of this contract, beside the ChronoSim.jl extension.

## The falsification charter

Every design claim above is paired with a concrete test that would refute
it. A failed test is a design discovery, not a bug to paper over. Oracles
use the 4-standard-error convention against closed forms (M/M/1, the SITA
farm as two independent M/G/1 queues, Erlang-A for reneging). The charter
continues with F9–F14 in [The event loop](event_loop.md#charter-f9-f14).

| Item | Claim | Status | Test |
|---|---|---|---|
| F1 | A1 suffices: no model code needs sampler introspection. SRPT and preempt-resume match oracles with ages read from state alone. | Tested, holding | `test/test_srpt.jl` |
| F2 | A2 openness: a new clock family costs one registry entry. Reneging (M/M/1+M vs Erlang-A) touched only the registry and surface fields — after the D1 repair it forced. | Tested, holding | `test/test_reneging.jl` |
| F3 | A3 coverage: the expression algebra covers the standard models with zero `Opaque` escapes. | Tested, holding | `test/test_splits.jl` |
| F4 | A4 determinism: folding the marked record reproduces the live trajectory at every index, including `te` and `bank`. | Tested, holding | `test/test_replay.jl` |
| F5 | CD-1 sufficiency: the four-argument `fire` is the only ClockGradients change queueing needs. Score and IPA on a time-varying-arrival M(t)/M/1 match finite differences. | Tested, holding | `test/test_gradients.jl` |
| F6 | Cascade totality: under acyclic blocking, cascades terminate deterministically. | Tested, holding | `test/test_blocking.jl` |
| F7 | The initial family set `{:arrival, :service}` suffices for the five phase-1 models. Fork–join sharpened this: forks and joins are clock-free station kinds, not a new family. | Tested, holding | `test/test_forkjoin.jl` |
| F8 | The speed-free compilation of processor sharing equals an explicit-speed reference. M/M/1-PS matches ``\rho/(1-\rho)``; M/G/1-PS shows insensitivity. | Tested, holding | `test/test_ps.jl` |

Reading the notation: IPA is infinitesimal perturbation analysis, the
pathwise derivative estimator; the estimators are described in the
[Manual's gradients page](../manual/gradients.md). F2's structural half was
a genuine falsification-and-repair, and F14 (in the event-loop charter) is
an outright refutation — both are recorded, because recording what did not
work is what the charter is for.
