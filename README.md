# Concourse.jl

A queueing-theory simulation framework: surface language → GSMP intermediate
representation → the [CompetingClocks.jl](https://github.com/adolgert/CompetingClocks.jl)
sampler, satisfying the ClockGradients.jl model contract so that score, IPA,
SPA, and branching derivative estimators run on the same model value the
simulator runs. Successor to Quarton.jl; deliberately independent of
ChronoSim.jl.

## Design documents, in reading order

- `notes/model_definition.tex` — **normative.** The amended model definition
  (clock bookkeeping in state, open clock families, combinator values, no
  hidden randomness), the ClockGradients contract delta, and the
  falsification charter that phase-1 code exists to run.
- `notes/event_loop.tex` — the middle-layer decisions (D1–D4), the
  processor-sharing compilation, the branchable world, charter F9–F14,
  and the Question 3 experiment.
- `notes/design_questions.tex` — the four open questions of the July 2026
  design conversation, in plain English; answered in
  `notes/reading_design_questions.md`.
- `notes/spa_derivation.tex` — the SPA derivation from first principles
  and the multi-segment extension, with the falsification ladder that
  gates its implementation.
- `notes/queue_layers.tex` — the three-layer architecture this project
  adopts; superseded by `model_definition.tex` where they disagree.
- `notes/queuepapers/` — supporting literature; see its `INDEX.md`.
- `docs/bcmp_hpc.md` — a worked BCMP example: an HPC cluster with two job
  classes, checked against product form, with plots.

## Status

Phase-1 prototype complete; `julia --project=. -e 'using Pkg; Pkg.test()'`
runs the charter (filter by substring: `julia --project=. test/runtests.jl f9`).

Charter scoreboard (claims in the notes' §7 tables):

- **Tested and holding:** F2 (reneging as a third clock family: M/M/1+M vs
  Erlang-A, the γ·Lq abandonment identity, exact replay, and a
  three-family score gradient vs finite differences — see the D1 refinement
  it forced, `notes/event_loop.tex` §2.4), F3 (no opaque escapes), F4
  (replay determinism, incl. preemption banking), F5 (CD-1 sufficiency:
  score + IPA on M(t)/M/1 vs finite differences, through the patched
  ClockGradients), F6 (cascade totality), F9 (FIFO/LIFO confluence, 20
  random blocking networks), F10 (three sampler methods), F11 (membership
  oracle in every debug run). Oracles: M/M/1, M/M/1/K, M/M/1+M,
  thinned-Poisson splits, all within 4 SE.
- **Tested and holding (phase 2):** F8 (processor sharing): M/M/1-PS matches
  ρ/(1−ρ); M/G/1-PS is insensitive while the same law under FCFS matches its
  distinct Pollaczek–Khinchine mean; replay reproduces `bank`/`anchor`
  exactly; resident-count changes emit `:reenable` for every survivor; and
  the score gradient matches finite differences through genuine mid-flight
  segment chains. See `notes/event_loop.tex` §6 for the normative
  declaration rule — a clock's specification is the pair (F, te) through
  its conditional law; `queue_layers.tex` §3.5's anchor-at-now form and the
  fixed-anchor form the state records are the same law (pinned by test),
  the parameterization chosen because the replay bookkeeping holds te
  fixed — and for the dual-safe `SharedRemaining` distribution.
- **Tested and holding (branchable world):** F12 — `ConcourseWorld`
  implements the ten-verb protocol, `check_branchable` passes in full for
  M/M/1, PS, and marked worlds; F13 — `branching_gradient` matches finite
  differences on the terminal count for M/M/1 *and* PS (the capability
  table's "needs framework world" cell, green for branching);
  `spa_gradient` matches finite differences on M/M/1 occupancy, with SPA's
  `fire` call sites now time-threaded in ClockGradients.
- **Tested and holding (auxiliary draws in branch worlds — the Q1
  decision):** the world owns live keyed streams beside the sampler;
  clones copy generator states, rekeys re-seed both families, and stream
  keys are stable identities (a source-anchored draw is
  position-in-source-sequence), so same-seed clones agree on
  corresponding jobs' marks even after forced divergence.
  `branching_gradient` matches finite differences on the bernoulli split
  (routing draws) and the SITA split (mark draws). θ-dependent mark laws
  are refused at the factory — that derivative term is future work.
- **Refuted (F14):** frozen-order IPA over processor-sharing records,
  under BOTH couplings — pinned with fixed seeds, including the
  degenerate-segment control (identical dynamics, opposite verdicts)
  proving the bias lives in the record's segment representation. The
  diagnosis, the chain-derivative result that explains it, and the
  falsification ladder toward repair are in `notes/spa_derivation.tex`.
  On PS records the valid estimators today are score and branching.
- **BCMP demonstration:** `examples/bcmp_hpc.jl` + `docs/bcmp_hpc.md` — a
  two-class HPC-cluster network (PS login, FCFS scheduler, 64-node delay
  compute, PS filesystem, checkpoint cycle) checked against the product
  form at every station (`test_bcmp.jl`), with a bottleneck sweep and an
  insensitivity demonstration.
- **Tested and holding (F1 and F7 complete):** SRPT — the ordering key is
  remaining size read from the A1 bookkeeping (`te` live, `bank` banked);
  exact deterministic preemption trace with Dirac sizes, the M/D/1
  degeneracy (equal sizes never preempt, Pollaczek–Khinchine CV=0 mean),
  the SRPT-undercuts-FCFS optimality inequality with paired seeds, and
  exact replay through banking. Fork–join — clock-free `:fork`/`:join`
  station kinds through `deposit!` (no new clock family, sharpening F7);
  matches the Flatto–Hahn k=2 exact mean via Little's law on groups in
  system; joins never hold complete groups; exact replay.
- **Pending:** the segment-aware dual replay (step 1 of the
  `spa_derivation.tex` falsification ladder), which gates both IPA on PS
  and the SPA multi-segment weight; θ-dependent marks.

F2's structural half was a genuine falsification-and-repair: hand-emitted
deltas would have required interpreter surgery for patience clocks, so delta
emission was replaced by per-touched-station membership derivation
(`derive_deltas!` in `src/semantics.jl`); after that, the family addition
touched only the registry methods and the surface `patience`/`renege_to`
fields.

CD-1 (4-argument `fire(model, state, key, t)` with a 3-argument fallback) is
applied to ClockGradients' model contract, score, IPA, functionals,
Bookkeeper, and ClockWorld; its own test suite passes unchanged.
