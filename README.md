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
- `notes/queue_layers.tex` — the three-layer architecture this project
  adopts; superseded by `model_definition.tex` where they disagree.
- `notes/queuepapers/` — supporting literature; see its `INDEX.md`.

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
- **Partially exercised:** F1 (preempt-`:resume` banking is tested; SRPT
  itself is unimplemented), F7 (M/M/1, SITA, preemptive priority, M/M/1+M
  run; processor sharing and fork–join are phase 2).
- **Pending:** F8 (PS truncate-and-rescale), the branchable world,
  SPA/branching time-threading (those ClockGradients paths still call 3-arg
  `fire` and fail loudly on time-needing models).

F2's structural half was a genuine falsification-and-repair: hand-emitted
deltas would have required interpreter surgery for patience clocks, so delta
emission was replaced by per-touched-station membership derivation
(`derive_deltas!` in `src/semantics.jl`); after that, the family addition
touched only the registry methods and the surface `patience`/`renege_to`
fields.

CD-1 (4-argument `fire(model, state, key, t)` with a 3-argument fallback) is
applied to ClockGradients' model contract, score, IPA, functionals,
Bookkeeper, and ClockWorld; its own test suite passes unchanged.
