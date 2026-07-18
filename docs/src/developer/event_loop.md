# The event loop

This page translates `notes/event_loop.tex`, the normative middle-layer
document. [The model contract](model_contract.md) defines what a model is;
this page describes how the interpreter runs one: four decisions D1–D4, the
cascade worklist, the processor-sharing compilation, and the branchable
world. Charter items F9–F14 extend the
[falsification charter](model_contract.md#the-falsification-charter).

## The four decisions

- **D1 (decided).** `fire` emits enable/disable/re-enable deltas. The full
  recompute of the enabled set is kept as a debug-mode consistency check,
  not measured against.
- **D2 (proposed, then tested).** The cascade worklist must settle to a
  unique, deterministic fixed point; contention is resolved by a declared
  policy, and the rest of the cascade is claimed to be order-free.
- **D3 (decided).** The interpreter owns the marked record. CompetingClocks
  samples, and only samples.
- **D4 (decided).** Sampler choice belongs to CompetingClocks'
  `SamplerBuilder`. No sampler is load-bearing.

## D1: fire emits clock deltas

An enabled-set diff — compare `enabled(state)` before and after a firing
and enable/disable the difference — looks simpler, but it is *semantically
blind to re-declarations*. When processor sharing re-evaluates every
resident clock on an arrival, the enabled set before and after is
identical: the diff sees nothing, while the sampler must receive a
`reenable!`. Deltas carry information the diff cannot express. Deltas were
chosen for correctness of the order of operations, not for speed.

The contract's `fire` is pure and ``\theta``-free, so deltas carry only
keys and operations — `(:enable | :disable | :reenable, key)`. The
interpreter derives each distribution from `clock_distribution` at the
post-firing state and each anchor from the state's `te` table.

After every firing, debug mode asserts two things:

1. **Membership** — the new enabled set equals the old one plus the emitted
   enables minus the emitted disables. The recompute is the specification;
   deltas are the implementation.
2. **Anchors** — the sampler's per-clock enabling times equal the state's
   `te` table. This is the A1 invariant, and it is what checks
   re-declarations, which membership cannot see.

### Deltas are derived, not emitted

Running charter item F2 (add reneging touching only the family registry)
falsified D1 *as first implemented*. Patience clocks are born when a job
enters a buffer and die when it leaves. With deltas hand-emitted inside
`settle!` and the family `fire` functions, adding the family would have
meant threading emission code through every state-transition site —
interpreter surgery, which is exactly what F2 forbids.

The repair keeps the decision and changes the mechanism. The cascade knows
which stations it touched. After the cascade, for each touched station and
each family, the family's enabled keys are diffed between the old and new
states (both exist, because `fire` is pure). Clock lifecycle follows from
membership alone; explicit `:reenable` deltas remain for the
processor-sharing path, which membership cannot see. The derived diff runs
only over the touched stations' clocks, so the cost argument for deltas
still stands. And there is a correctness dividend: a clock enabled and
disabled within one firing nets out of the diff and never reaches the
sampler — the GSMP has no zero-duration clocks.

This is the falsification charter working as designed: the claim failed
against the first implementation, and what survived is a better mechanism
under the same decision. After the repair, adding `:patience` changed only
the registry and the surface fields.

## D2: the cascade worklist

Within one firing, instantaneous consequences chain. A deposit triggers
`settle!` at the destination. A departure from a full buffer lets a blocked
upstream server transfer in, which frees that server, which admits from its
buffer, which may unblock stations further upstream. The cascade must reach
a fixed point before the sampler sees any delta, and the fixed point must
be unique and deterministic, because `fire` is the replayed, differentiated
object. (The generalized stochastic Petri net literature has this exact
problem as immediate transitions and vanishing markings.)

The design splits contention from propagation:

- **Contention is model semantics.** Order matters in exactly one place:
  two consumers competing for one freed resource — two blocked upstream
  servers and one freed buffer slot. Who wins is an observable modeling
  choice, so it is a declared policy on the station: `FCFSUnblock()`
  (longest-blocked first, the default), `PriorityUnblock(by)`, or
  `RandomUnblock()` (a recorded choice, inside the A4 randomness census).
- **Propagation is order-free.** With contention delegated to policy, the
  claim is that the remaining cascade relation is *confluent*: any fair
  processing order reaches the same fixed point. Termination comes from
  check C3 (acyclic blocking chains). Confluence plus termination give a
  unique normal form.

The implementation still fixes a canonical order — a first-in-first-out
worklist seeded with the destination, then the origin — so behavior is
deterministic even if the confluence claim were false. A debug-build fuel
counter turns nontermination into an error rather than a hang. The claim is
tested as F9: run the same trajectories with FIFO and LIFO worklists and
require equal states at every index. It holds.

## D3: the interpreter owns the record

The marked record — (key, time, auxiliary draws) per firing — is the
primary observable of the library. Its auxiliary-draw column exists because
the *interpreter* supplies the draw source (amendment A4); the sampler
never sees those draws, so a sampler-side watcher could never capture them.
CompetingClocks' watchers remain what they are — instrumentation of
sampling — and none of the record path attaches to them.

One replay detail follows: during estimation, `fire` must read the current
firing's recorded draws, and the contract does not pass an index. The state
therefore carries a firing counter, incremented by every `fire` — a pure
counter in a pure state.

## D4: the builder chooses the sampler

Concourse tells `SamplerBuilder` the clock-key type and lets CompetingClocks
choose a sampler for the distributions in play. The design consequence is a
claim, not a configuration: *every* sampler valid for the model's
distributions must produce statistically identical results, because the
interpreter speaks only the blessed `SamplingContext` surface and no model
code reaches around it. Estimator-driven overrides (the carry coupling for
IPA) are passed through by the estimation entry points, not chosen by the
model. This is charter item F10, tested by running the charter oracles
under multiple sampler methods.

With D1–D4 fixed, the interpreter loop is small: ask the sampler for the
winner, fire it, run `fire_changes` (the cascade happens inside), append to
the record, apply the deltas to the sampler. Everything model-specific is
inside `fire_changes`; everything stochastic is inside the sampling context
and the draw source; everything observable is the record. The loop itself
should never grow.

## The processor-sharing compilation

Processor sharing (PS) serves every job at a station simultaneously, each
at a fraction of the server's speed. Every arrival and departure changes
the fraction, so the law of every resident clock changes while the clocks
stay enabled. Implementing PS (charter item F8) surfaced one normative rule
that governs everything else.

**The declaration rule.** A model's entire specification for an enabled
clock is the pair ``(F, t_e)`` — a distribution and an enabling time —
re-declarable only at event times. Its meaning is the conditional law:
given the history up to now, the firing time is distributed as
``t_e + X`` with ``X \sim F``, conditioned on not having fired yet. Nothing
else crosses the interface — not a speed, not an age, not how the sampler
realizes the draw. "Speed" is a modeling-side device used to *construct*
the declared ``F``, and it compiles away. Two declarations with the same
conditional law are the same model. In particular, the anchored-at-now form
and the fixed-anchor form of a PS re-declaration are the same conditional
law, and a test pins that identity numerically. The choice between them is
not semantics but which sufficient statistics the state records — and that
choice is forced by the replay bookkeeping, which holds ``t_e`` fixed while
a clock stays enabled.

Concretely:

- **The state carries `(bank, anchor)` per clock** — the internal age at
  the last re-declaration and that re-declaration's wall time. This is an
  addendum to amendment A1. The sampler side is CompetingClocks'
  age-keeping `reenable!`; the interpreter's existing `:reenable` branch
  needed no change.
- **A re-evaluation hook.** The derived-delta pass gained a per-family hook
  run after the membership diff at each touched station. The `:service`
  method detects a resident-count change at a PS station, banks each
  survivor's internal age at the old speed, moves its anchor, and emits
  `(:reenable, k)`. A `:rescale` memory mode joins `:fresh` and `:resume`.
- **A bespoke distribution.** Composing library truncation and affine
  wrappers builds the right law but poisons automatic differentiation:
  stored bound constants produce NaN partial derivatives. `SharedRemaining`
  (in `src/semantics.jl`) implements the conditional-remaining law
  directly, and is the object the sampler draws from, the likelihood
  differentiates, and the replay bookkeeping compares for segment
  detection.

The oracles: M/M/1-PS matches ``\rho/(1-\rho)``; M/G/1-PS with Gamma
service is *insensitive* to the service distribution's shape, while the
same law under FCFS matches its distinct Pollaczek–Khinchine mean — which
proves the discipline actually shares; replay reproduces `bank` and
`anchor` exactly; and the score gradient matches finite differences through
genuine mid-flight segment chains. All in `test/test_ps.jl`.

## The branchable world

The clone-based estimators (branching, and smoothed perturbation analysis —
SPA) need to copy a running simulation and force alternative events in the
copy. `ConcourseWorld` — the model, ``\theta``, the state, the sampling
context, and the clock — implements ClockGradients' ten-verb branchable
protocol: `branch_peek`, `branch_commit!`, `branch_force!`, `branch_clone`,
`branch_rekey!`, `branch_time`, `branch_enabled_ages`,
`branch_clock_distribution`, `branch_state`, and `branch_schedule`. It is
the second implementation beside the ChronoSim adapter — the same
two-clients test the model contract passed.

The verbs are thin. Peek reads the context's cached reservation. Commit and
force share one update path. A coupled clone is an empty clone plus a clock
copy plus a time restore. Rekey re-seeds and then jitters, because
re-seeding alone would replay cached putative times. Ages come from the
state's own `te` table — the A1 invariant makes the sampler agree.

**Auxiliary draws in branch worlds** (the Q1 decision — see
[Design questions](design_questions.md)): the world owns a live keyed
stream family beside the sampler, so models with marks, probabilistic
routing, and random selection can branch too. The stream key is the stable
identity the draw belongs to. A mark draw is keyed by the source's own
clock and consumed once per arrival, so the ``k``-th value *is* the
``k``-th arrival of that source in any same-seed world, whatever else fired
in between. Clones copy the generators' states; rekeys re-seed the
auxiliary family along with the clocks; and two same-seed clones agree on
the marks of corresponding jobs even after a forced firing makes their
event orders diverge. Mark laws that read ``\theta`` are refused at
construction: that derivative term is future work, not a default.

## Charter F9-F14

Continuing the numbering from
[the model contract's charter](model_contract.md#the-falsification-charter):

| Item | Claim | Status | Test |
|---|---|---|---|
| F9 | Cascade confluence: with contention resolved by `UnblockPolicy`, the fixed point is order-independent (FIFO vs LIFO worklists, random blocking networks). | Tested, holding | `test/test_blocking.jl` |
| F10 | Sampler agnosticism: no charter result depends on the sampler; oracles pass under multiple builder outcomes. | Tested, holding | `test/test_samplers.jl` |
| F11 | Delta fidelity: emitted deltas agree with the recompute oracle — membership and anchor assertions over long mixed runs, including preemption and PS. | Tested, holding | debug oracle, asserted in every debug-mode run |
| F12 | Protocol portability: `check_branchable` passes in full on `ConcourseWorld`, for frozen-law models and for PS. | Tested, holding | `test/test_branch.jl` |
| F13 | Clone estimation over re-declared clocks: `branching_gradient` matches finite differences on the PS terminal count. | Tested, holding | `test/test_branch.jl` |
| F14 | Pathwise estimation over re-declared clocks: frozen-order IPA on PS records gives the correct derivative. | **Refuted**, under both couplings | `test/test_ps.jl` (pinned with fixed seeds) |

F14 deserves the emphasis. IPA (infinitesimal perturbation analysis, the
pathwise estimator) was believed ready for multi-segment records; the
experiment says no. The refutation, the degenerate-segment control that
localizes the bias to the record's segment representation, and the
diagnosis are on the
[Design questions](design_questions.md#question-3-ipa-over-processor-sharing-records)
page; the algebra that explains it is summarized on
[The SPA estimator](spa.md) page. On PS records the valid estimators today
are the score function and branching.
