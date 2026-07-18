# Documentation plan for Concourse.jl

Concourse's documentation has two landing pages (a GitHub `README.md` and the
documentation index) and four sections:

- **Queues** — a tutorial on queueing theory for someone who does not know it,
  taught through pictures and forward simulations run by Concourse.
- **Manual** — how to use Concourse for research: records and replay,
  trajectory splitting, gradient estimation, statistical analysis.
- **Reference** — docstrings for exported structs and functions, grouped by
  architectural layer.
- **Developer** — translations of the design notes in `notes/`, so the
  reasoning behind choices survives outside LaTeX.

This split follows the Diátaxis pattern (tutorial / how-to / reference /
explanation). The distinctive commitment: every concept in Queues ends with a
diagram and a runnable simulation, and where closed-form theory exists, the
simulation is checked against it on the page. The reader watches simulation
confirm formulas, which builds trust for the cases where no formula exists.

## Language

 * Use plain language.
 * Split complicated ideas into multiple shorter sentences.
 * Don't use adjectives to convey complicated information.
 * Define all acronyms before using them.

## Directory layout

```
README.md                          GitHub storefront
docs/
  Project.toml                     Documenter, Luxor, MathTeXEngine,
                                   [DocumenterCitations], Concourse (dev'd)
  make.jl
  QueueDiagrams/                   local package: the queue-diagram vocabulary
  src/
    index.md                       documentation landing page
    queues/                        tutorial section
    manual/                        research-workflow section
    reference/                     API docstrings
    developer/                     design-note translations
```

## Diagrams

Diagrams are drawn with Luxor.jl using a small vocabulary of queue-specific
drawing functions (`buffer` with slats, `server`, `sharedserver`, class-colored
`job` tokens, `flow` arrows, `discipline` tags). Math labels (λ, μ, subscripts)
render through MathTeXEngine.jl — pure Julia, no LaTeX toolchain on CI.

The vocabulary lives as a tiny local package `docs/QueueDiagrams/`, added by
path to the docs environment, so every page writes `using QueueDiagrams` with
no `include` path fragility. Pages produce figures inside `@example` blocks
via `@drawsvg`; Documenter embeds the SVG at build time. One style module
means restyling once restyles every figure. A prototype of this pipeline was
validated end-to-end (Luxor → `@example` → embedded SVG in built HTML),
including LaTeX math labels. The prototype vocabulary is preserved at
`docs/diagram_prototype.jl` — the starting point for QueueDiagrams (note its
top-level render calls must move behind a function or module before reuse).

## Code blocks

Every code block in Queues and Manual is a Documenter `@example` block with a
fixed RNG seed. Building the docs executes all of them: docs build = docs
tested. CI builds docs on PRs and `deploydocs` publishes to gh-pages.

## The two landing pages

### README.md (GitHub)

Short; READMEs rot when they duplicate manuals.

- One sentence: queueing networks compiled to a GSMP, simulated against
  CompetingClocks.jl, differentiable via ClockGradients.jl.
- One committed diagram, rendered by QueueDiagrams so it matches the docs.
- A ~10-line M/M/1 quickstart using the real surface language
  (`source!`, `station!`, `sink!`, `compile`, `simulate`).
- Badges, install line, link to the documentation.

### index.md (documentation landing)

Routes three readers:

- New to queueing theory → **Queues**.
- Know queueing, want to do research with the tool → **Manual**.
- Want to understand or extend the design → **Developer**.

Repeats the quickstart so the landing page proves the package runs.

## Queues (tutorial section)

Page pattern: concept in prose → diagram → Concourse code that builds it →
forward simulation → measured quantity compared against theory when theory
exists.

1. **Jobs, servers, and service times.** What a server is; service time as a
   random variable. Diagram: lone server circle. Code: one station, a handful
   of jobs, inspect the `MarkedRecord` directly — the record is introduced as
   "what a simulation produces" from page one.
2. **Arrivals and the waiting line.** Poisson arrivals, the buffer,
   utilization ρ, stability. Diagram: buffer + server. Code: `source!` with
   exponential interarrivals; number-in-system over time for ρ = 0.8 vs
   ρ = 1.1 (watch the unstable line grow).
3. **Line disciplines.** FCFS, LCFS, SIRO, Priority, ProcessorSharing, SRPT —
   all six exports, one diagram each. Code: identical load, swap the
   discipline, compare waiting-time distributions. Insight to land: the number
   in system may not care, but *who waits* changes completely.
4. **Kendall notation and M/M/1.** A/S/c notation; memorylessness. Simulate
   M/M/1; check L = ρ/(1−ρ) and Little's law with `time_average` and
   `number_in_system`. (`test/test_mm1.jl` knows workable tolerances.)
5. **M/G/1 and why distributions matter.** General service,
   Pollaczek–Khinchine, the waiting-time cost of variance. Simulate M/D/1 vs
   M/M/1 vs heavy-tailed at equal means. Sets up insensitivity for the BCMP
   capstone.
6. **Networks: open and closed.** `route!` and routing kernels (`Always`,
   `Probabilistic`, `RoundRobin`); tandem queues, feedback, closed populations
   with think time. Diagram: two-station network with a feedback arc.
7. **Marks: classes of jobs.** `ByMark` routing, class-dependent service,
   marks in the record. Points to the BCMP HPC case study as capstone —
   the existing `docs/bcmp_hpc.md` moves into this section.
8. **Richer stations.** Fork-join (`fork!`/`join!`), blocking
   (`FCFSUnblock`), reneging. Short sections, one diagram each; each has a
   test file proving the code path (`test_forkjoin.jl`, `test_blocking.jl`,
   `test_reneging.jl`).
9. **Measuring a simulation.** Transients and warmup, why one run lies, time
   averages vs job averages. Deliberately the bridge into Manual.

## Manual (research-workflow section)

1. **The record and replay.** `MarkedRecord`, `replay`, determinism as the
   foundational property everything else builds on.
2. **Branching worlds and trajectory splitting.** `ConcourseWorld`,
   `branch_world`, the auxiliary-draw discipline — the Q1 outcome stated as
   user-facing rules, not design debate.
3. **Gradient estimation.** `ReplayModel`, `live_model`, the ClockGradients
   contract; the four estimators in a paragraph each (adapt the summary in
   `notes/design_questions.tex` §Background); honest caveats — IPA fails on
   processor sharing (Q3 refutation), SPA's validity conditions.
4. **Statistical analysis.** Batch means; regenerative estimation (the
   Shedler reading note feeds this); comparing systems with common random
   numbers via branching — splitting and statistics composing.
5. **Choosing a sampler.** `FirstToFireMethod` vs `NextReactionMethod` vs
   the others; practical guidance.
6. **Checking your model.** The IR model checks, `states_equal`, the debug
   oracle.

## Reference

Grouped by architectural layer, mirroring `queue_layers.tex` — not one
`@autodocs` dump:

- **Surface language** — `QueueNetwork`, builders, disciplines, routing
  kernels.
- **Expression algebra** — `ScalarExpr`, `Param`, `Mark`, `Enab`, `Const`,
  `Law`, `Opaque`, `MarkLaw`, the `reads_*` predicates.
- **IR and contract** — `QueueGSMP`, `QueueState`, `ClockKey`, the five
  contract functions (`initial_state`, `enabled`, `clock_distribution`,
  `fire_changes`, `states_equal`).
- **Interpreter and record** — `simulate`, `MarkedRecord`, `replay`,
  measurement helpers.
- **Gradients and worlds** — `ReplayModel`, `replay_model`, `live_model`,
  `ConcourseWorld`, `branch_world`.

**Prerequisite: a docstring pass.** ~40 names are exported but src has ~14
docstrings, concentrated in `record.jl`. Add doctests where examples are
cheap.

## Developer (design-note translations)

One page per note, translated not transcribed — prose explanations of
choices, with falsification-charter items linked to the tests that discharge
them:

- **Architecture** — from `queue_layers.tex`: the three layers (surface
  language, IR, CompetingClocks integration).
- **The model contract** — from `model_definition.tex`: axioms A1–A4 and why
  each alternative lost; the amended contract surface; the falsification
  charter.
- **The event loop** — from `event_loop.tex`: decisions D1–D4, the cascade
  worklist, the processor-sharing compilation, the branchable world.
- **Design questions and outcomes** — from `design_questions.tex` and the
  Q1–Q3 outcomes, including refutations; recording what *didn't* work is this
  section's whole value.
- **The SPA estimator** — a summary page; the full derivation stays in
  `notes/spa_derivation.tex`/PDF, linked.
- **Bibliography** — generated from `notes/queuepapers/INDEX.md`;
  DocumenterCitations if proper cite keys are wanted.

Note precedence carries over: `model_definition.tex` and `event_loop.tex`
supersede `queue_layers.tex` where they disagree, and the pages should say so.

## Deliberately deferred

- A how-to/cookbook section: Manual covers it while the API is young; split
  it out later if pages get baggy.

## Build order

1. **Infrastructure** — `docs/Project.toml`, `make.jl`, the QueueDiagrams
   package, `index.md` skeleton with the nav tree, CI docs job.
2. **README.md** and the index page.
3. **Docstring pass + Reference** — unblocks `@docs` blocks everywhere.
4. **Queues** — the most new writing, but the diagram vocabulary and existing
   test files make each page mechanical; move `bcmp_hpc.md` in as capstone.
5. **Developer** — translations of the notes.
6. **Manual** — last, because the Q1/Q2 outcomes are freshest and may still
   shift.
