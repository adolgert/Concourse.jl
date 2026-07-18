# The SPA estimator

Smoothed perturbation analysis (SPA) is one of the four derivative
estimators Concourse supports through ClockGradients.jl. This page
summarizes the derivation note `notes/spa_derivation.tex` (also built as a
PDF in `notes/`), which rebuilds SPA from first principles and then works
out what changes when clocks are re-declared mid-flight. The full
derivation stays in the note; read it there if you need the mathematics
line by line. This page gives the shape.

## What SPA estimates

We want ``\partial_\theta\,\mathbb{E}[L]``: the derivative of an expected
performance measure — a time integral such as ``\int_0^T N(t)\,dt``, a
terminal reading, a first-passage time — with respect to the parameter
vector ``\theta``.

Fix the underlying random numbers and move ``\theta`` a little. Every
holding time slides smoothly, so every firing time slides too. As long as
the *order* of firings does not change, the path deforms continuously, and
differentiating along it is what the pathwise estimator — infinitesimal
perturbation analysis (IPA) — computes. But at certain values of
``\theta``, two firing times tie. Crossing a tie swaps the order of two
events, and a functional that reads anything order-dependent jumps there.
The set of paths near a tie has probability of order ``\delta\theta``, and
each contributes a jump of order one; the product is a first-order term
that IPA cannot see:

```math
\frac{d}{d\theta}\,\mathbb{E}[L]
= \underbrace{\mathbb{E}\!\left[\frac{\partial L}{\partial\theta}\right]}_{\text{IPA: times slide}}
+ \underbrace{(\text{probability flux across ties}) \times (\text{jump size})}_{\text{the boundary term IPA drops}} .
```

SPA estimates the second term and adds it to the first.

## The shape of the derivation

**Conditioning smooths.** The trick (Gong and Ho; developed at book length
by Fu and Hu) is not to differentiate ``L`` itself but a conditional
expectation of ``L``. Condition on everything except one distinguished
piece of randomness; the inner expectation integrates over that piece, and
integration turns jump indicators into continuous probabilities, which
differentiate.

**The candidate and the hazard weight.** Apply this at each firing. The
winner fired at time ``t_k``; consider one other enabled clock — a
*candidate* — with age ``\xi`` at that moment. Conditioned on everything
else, all we know about the candidate is that it survived to age ``\xi``,
so its conditional law is its declared law conditioned on survival. That is
why the boundary weight is a *hazard*, ``h_e(\xi) = f_e(\xi)/(1 -
F_e(\xi))``, and not a marginal density. An exact two-clock-race check pins
this in the implementation: the hazard weight integrates to the true
derivative of the win probability; the marginal density integrates to a
wrong value.

**The velocity.** The boundary is a tie between two moving times, so the
probability flux is proportional to the *relative* velocity of the age and
the candidate's sample, taken at positive part: ``(d\xi/d\theta -
dX_e/d\theta)^+``. The first piece comes from the pathwise replay's time
derivatives; the second comes from the candidate's law directly. This
dependence matters below: **the boundary term is built on top of the
pathwise replay.** If the replay's time derivatives are wrong, no boundary
correction can rescue the sum.

**The jump, by coupled clones.** What multiplies the flux is the difference
between the functional on the path where the pair fired in swapped order
and on the nominal path. The implementation branches two clones from the
pre-commit world, gives them one shared rekey seed, forces the pair in
opposite orders, and runs both to the horizon. The shared seed makes the
difference quiet: the continuation randomness cancels and only the effect
of the order remains. Two shortcuts reduce cost. The *commuting gate*: if
both orders re-coalesce to the same state, the jump is exactly zero and no
clones are needed — cloning there would return pure noise. The *horizon
term*: a clock scheduled just past the observation window crosses into it
as ``\theta`` moves; that boundary is a constant, so the jump is read
directly off the fired state, no clones.

The estimator is the IPA term plus these boundary contributions summed over
epochs and candidates. The note's section 5 maps every symbol of the
derivation onto the implementation in `ClockGradients/src/spa.jl`.

## What re-declared clocks change

Processor sharing re-declares a clock's distribution at event times while
the clock stays enabled; each replacement starts a new *segment*. SPA
refuses records containing multi-segment clocks, and the derivation asked
what it would take to lift that refusal.

**What generalizes cleanly.** The weight: the conditioning argument never
used the number of segments, so the boundary weight for a re-declared
candidate is the hazard of the *latest* segment's declared law — a
mechanical bookkeeping change. The clone construction: whenever the two
forced orders re-coalesce to the same state, the survivors' re-declared
laws coincide in both arms, so the commuting gate survives.

**Where it actually breaks: the velocity, not the weight.** The Question 3
experiments (see [Design questions](design_questions.md#question-3-ipa-over-processor-sharing-records))
showed the pathwise replay itself is biased on multi-segment records. The
derivation explains why. Differentiating the carry chain — the map that
carries a would-be firing age across a re-declaration by matching
conditional survival — produces a term in which the sensitivity of the
*boundary time* enters the clock's future weighted by the hazard jump
across the re-declaration:

```math
\dot{\alpha}' = \frac{h^{\mathrm{new}}(a) - h(a)}{h^{\mathrm{new}}(\alpha')}\,\dot{a}
\;+\; (\text{terms in } \dot\alpha \text{ and } \partial_\theta \log S).
```

Three consequences, each matching an experiment. If a re-declaration does
not change the conditional law, the coefficient is zero and the chain step
must be transparent. If it changes the speed — processor sharing — the
boundary time's derivative genuinely feeds the clock's future, and dropping
it biases the replay. And the current implementation *cannot express* the
term: segment laws are rebuilt from states folded at the recorded
floating-point times, so their parameters are frozen constants, and the
evaluation at the boundary lands at the new law's support start, where it
is pinned to zero however the boundary moves. Half of a cancelling pair is
killed, which is why even the degenerate case — segments that all declare
the same law — fails with large per-path errors.

## The frozen-order IPA bias, diagnosed

This is the diagnosis of charter item F14 (the refutation pinned in
`test/test_ps.jl`). On M/M/1-PS both IPA couplings are biased in different
directions while finite differences and the dual machinery both behave.
The degenerate-segment control — a 64-server PS station whose dynamics are
identical to FCFS but whose records carry chains — shows the bias lives
entirely in the record's segment representation: same law, segment-free
records pass, chained records fail. A one-line repair (taking the formula
branch at the support boundary) was tried and refuted: bit-identical
gradients, because round-off lands the evaluation on either side of the
boundary and the frozen anchors stay frozen either way. A refuted repair is
as informative as a successful one; it rules out the cheap fix before
anyone tries it again.

The two-job worked example in the note makes the lesson concrete. For a
plain PS station and an occupancy functional, the jump at a
completion–completion tie is exactly zero — the entire derivative must
come through the smooth pathwise term, including the way each completion
depends on the *other* job's completion through the speed change. That is
precisely the channel the replay is missing. For processor sharing, the
hard part of SPA is not an exotic boundary weight; it is that the smooth
part must first be made correct.

## The falsification ladder

The derivation dictates the order of implementation work, each step gated
by a test that can refute it:

1. **Segment-aware replay.** Give the replay the missing channel: rebuild
   segment laws with dual-valued boundary parameters (fold at dual times,
   or record segment boundary indices — the Question 4 decision). Gate: the
   degenerate-segment test flips from refutation to agreement, path by
   path, not just on average.
2. **Pathwise on PS.** Gate: the M/M/1-PS carry column matches finite
   differences; then a Weibull-base PS variant, which exercises the terms
   the exponential case partially hides.
3. **SPA weight for re-declared candidates.** Implement the latest-segment
   hazard, replacing the whole-record refusal only after step 2 holds.
   Gates on both a boundary-free functional (must agree with repaired IPA)
   and an order-carried one (must match finite differences where plain IPA
   visibly does not).
4. **Jump construction audit.** An adversarial model where the two forced
   orders do *not* re-coalesce, checked against finite differences.

Until step 2 passes, both SPA's multi-segment refusal and the matching
refusal for IPA on chained records are the user-facing truth. Refusals are
whole-record, by decision: a record either is within the derivation or is
not, and the user hears a clear no rather than a quietly wrong number.
