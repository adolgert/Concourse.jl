# Design questions and outcomes

In July 2026, with every target queueing model simulating and most of them
differentiating, four questions remained open. They were written up in
plain English (`notes/design_questions.tex`), discussed, and resolved
(`notes/reading_design_questions.md` records the decisions). This page
states each question and what happened to it.

The centerpiece of this page is a refutation. Question 3 asked whether the
pathwise derivative estimator works on processor-sharing records. It does
not, and the experiment that showed it also located *why*. Recording what
did not work — precisely, with the evidence pinned in tests — is the whole
value of this section.

Background terms used throughout: IPA is infinitesimal perturbation
analysis, the pathwise estimator that freezes the order of firings and
differentiates their times. SPA is smoothed perturbation analysis, IPA plus
a correction for order changes. PS is processor sharing, the discipline
that serves all jobs at a station simultaneously. A *segment* is one
stretch of a clock's life under one declared distribution; PS re-declares
clocks whenever the number of sharing jobs changes, so PS clocks have many
segments. The four estimators are described for users in the
[Manual](../manual/gradients.md).

## Question 1: cloning worlds that use auxiliary draws

**The question.** The branchable world (needed by the branching and SPA
estimators) refused any model that uses marks or random routing. Replay of
a record is safe for those models, because recorded values are read back.
But a clone runs *forward*, past the end of any record: its future arrivals
need new sizes, its future routing needs new coin flips. Where should those
live random streams live, what should re-seeding cover, and — hardest —
what should the draws be keyed by, so that two same-seed clones see
matching randomness even after their event orders diverge?

**The outcome: decided and implemented.** Three rules:

1. The auxiliary streams live in the world object, beside the sampler.
   They are not the sampler's business.
2. Re-seeding covers both families. A rekey re-seeds the auxiliary streams
   along with the clock streams; re-seeding only the clocks would leave the
   clone replaying the original's future sizes.
3. Draws are keyed by a stable identity, never by request order. A mark
   draw is keyed by the source's own clock and consumed once per arrival,
   so the fifth arrival of clone A gets the same size as the fifth arrival
   of clone B, whatever else fired in between — the
   "position in the source's own sequence" rule.

The separable sub-question — marks whose distributions read ``\theta`` —
was deferred: such a mark adds its own derivative term to every estimator,
and that term is future work. ``\theta``-dependent mark laws are refused at
world construction.

**Evidence.** `test/test_branch.jl`: a coupled clone reproduces firings and
marks exactly; a rekeyed clone draws fresh sizes; same-seed clones agree on
corresponding jobs' marks after forced divergence; and `branching_gradient`
matches finite differences on a Bernoulli routing split and on a SITA mark
split.

## Question 2: SPA's correction for re-declared clocks

**The question.** SPA works for clocks that keep one distribution for life
and refuses records containing multi-segment clocks. The refusal is not an
implementation gap: the mathematics of the correction term had not been
derived for the multi-segment case. The correction weighs each near-tie by
the runner-up's hazard and by the jump the swap would cause; when the
forced firing itself re-declares the survivor — which under PS it always
does — the existing correctness argument no longer covers the construction.

**The outcome: the derivation was written.** Following the project's
practice, the answer to "this needs to be derived" was a report:
`notes/spa_derivation.tex` rebuilds SPA from first principles, then works
the multi-segment extension. Two findings, summarized on
[The SPA estimator](spa.md) page:

- The boundary *weight* generalizes without new mathematics: it is the
  hazard of the latest segment's declared law, and the commuting gate (the
  zero-jump shortcut) survives re-declaration whenever the two forced
  orders re-coalesce.
- The genuinely new mathematics is a chain derivative showing that the
  *velocity* term — which SPA takes from the pathwise replay — is exactly
  what the current replay gets wrong on multi-segment records. So the
  multi-segment problem is not, first, an SPA problem; it is a problem in
  the object SPA stands on.

The decision on refusals: they stay whole-record. If any part of a record
is beyond the derivation, the user hears a clear no rather than a quietly
wrong number. Implementation is gated by the falsification ladder in the
derivation; until its first steps pass, SPA's multi-segment refusal stands.

## Question 3: IPA over processor-sharing records

**The question.** The IPA machinery was written with multi-segment records
in mind, and the score estimator — which shares the record structure —
passes its tests on PS. But IPA itself had never been tested on a PS
record. "Untested" and "working" are different claims. The proposed move
was an experiment: run IPA on M/M/1-PS against finite differences, the same
comparison every other estimator passed.

**The outcome: refuted.** The experiment (``\lambda = 1``, ``\mu = 2``,
horizon 50, 400 records, common-random-number central finite differences on
the same seeds, occupancy integral ``\int_0^H N\,dt``) answers no, under
both couplings:

| | ``\partial_\lambda`` | ``\partial_\mu`` |
|---|---|---|
| finite differences | ``93.4 \pm 3.9`` | ``-47.7 \pm 1.8`` |
| IPA, redraw coupling | ``57.7 \pm 3.4`` | ``-10.0 \pm 0.1`` |
| IPA, carry coupling | ``206.0 \pm 11.8`` | ``-36.2 \pm 1.2`` |

Three facts sharpen the failure into something usable.

First, the machinery runs clean. The dual numbers flow without errors, and
the replay reproduces the recorded firing times at the sampling parameter.
The failure is a wrong number, not a crash — the worst failure mode,
because nothing warns the user.

Second, a degenerate control localizes the bias. A PS station with 64
servers re-declares every survivor at every count change, yet at the test
load the speed is always 1, so its *dynamics* are identical to FCFS — but
the PS records carry multi-segment chains while the FCFS records are
segment-free. On the segment-free records, both couplings match finite
differences. On the multi-segment records of the *same law*, both are badly
biased. Identical dynamics, opposite verdicts: the bias lives entirely in
the record's segment representation.

Third, the mechanism is located, and it is structural. The replay rebuilds
each segment's law from states folded at the *recorded* floating-point
times, so the law's bank, anchor, and speed are frozen constants with no
derivative. The sensitivity of a re-declaration *boundary time* — itself a
``\theta``-dependent event time of the race being differentiated — has no
channel into the replayed times. A candidate one-line repair was tried and
refuted: it changed nothing, because the frozen anchors remain frozen
either way. The complete repair needs the segment parameters to be
dual-valued functions of the replayed times — which is Question 4's
territory — and what the correct derivative even is, once that channel
exists, is Question 2's derivation.

**Status.** Pinned as charter item F14 in `test/test_ps.jl`, with fixed
seeds, including the degenerate-segment control. Consequence for users
today: on PS records the valid estimators are score and branching, both
tested against finite differences. IPA silently returns a confident wrong
number — which is the failure mode the score pairing exists to detect.

## Question 4: should the record store segment boundaries?

**The question.** The record stores only firings: clock, time, auxiliary
values. Enabling times and re-declarations are *reconstructed* by
re-running the model's rules over the firing list. Reconstruction keeps the
record minimal and forces the model's rules to be the single source of
truth, with a real audit benefit: every run cross-checks the rules against
the simulation. But reconstruction walks the whole record, rebuilds every
active clock's distribution after every firing, and rests on the assumption
that a re-declaration always visibly changes the distribution. Should the
record store segment boundaries instead?

**The outcome: held open, with a stated preference.** The decision was to
keep the record minimal — it is the filtration, in the statistical sense —
and use reconstruction while developing, treating storage as a possible
later optimization. The Question 3 refutation then gave the question a
derivative-driven edge: the repair for IPA-on-PS needs segment parameters
that carry derivatives, which means either the reconstruction learns to
fold at dual-valued times (the preferred route, keeping the record
minimal), or the record stores boundary indices so boundary ages can be
rebuilt as differences of replayed times. The recommendation in
`notes/spa_derivation.tex` is to make the reconstruction dual-capable and
revisit storing boundaries only if that proves too costly.

## Summary

| Question | Kind | Outcome |
|---|---|---|
| 1. Auxiliary draws in clones | engineering | decided and implemented; tested in `test/test_branch.jl` |
| 2. SPA with re-declaration | research | derivation written (`notes/spa_derivation.tex`); implementation gated by its falsification ladder |
| 3. IPA on PS records | experiment | **refuted** (charter F14, `test/test_ps.jl`); score and branching are the valid estimators on PS |
| 4. Segments in the record | architecture | held open; reconstruction preferred, now with a plan to make it dual-capable |
