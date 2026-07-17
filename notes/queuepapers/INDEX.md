# queuepapers/

Markdown sources copied from the local `findpdfs-library` knowledge base (rkb MCP), selected
to support implementing `../queue_layers.tex` on a machine without access to that library.

Selection criteria, in the order they mattered:

- **(b) mapping a queueing model onto a GSMP** you can execute with a next-event rule
- **(a) how to specify a queueing model** in the first place
- documents `queue_layers.tex` cites by name

Everything here is a complete extraction, not an excerpt. Two extraction pipelines feed the
library — `marker-pdf` and `nougat-ocr`. Where both existed the marker version was taken; it
preserves headings and code better. The `.mmd` originals were renamed to `.md`; they are
Markdown with LaTeX math either way. OCR noise is present in the nougat files (Lipsky's title
comes through as "Queeting Theory"), so trust the math over the surrounding prose.

## The central one

**`Zimmermann2007_StochasticDiscreteEventSystems.md`** (1.2 MB, 393 pp., marker)
This is the closest published relative of `queue_layers.tex`, and it is the reason this
directory is worth carrying. Zimmermann's thesis is precisely yours: many surface model
classes share one underlying abstract model, so define the abstraction once and translate each
surface class into it. His structure maps onto your layers directly:

| Zimmermann | line | maps to |
|---|---|---|
| Ch. 2, A Unified Description for SDES | 488 | Layer 2, the IR |
| §2.3.2, The Stochastic Process Defined by an SDES | 656 | the interpreter's semantics |
| Ch. 3, Stochastic Timed Automata | 1008 | a sibling surface class |
| **Ch. 4, Queuing Models** | **1409** | **Layer 1, and its compile to the IR** |
| Ch. 5–6, Simple / Colored Petri Nets | 1697 / 2054 | where `:fresh`/`:resume` vocabulary lives |
| Ch. 9, Efficient Simulation of SDES Models | 3415 | Layer 3, the sampler |

Read Ch. 4 against your §3.2 (station-to-rule compilation). His queuing model class carries an
explicit `Sink` node, per-queue response time `S(q)`, and visit ratios — the same furniture your
IR grows. Ch. 2 is the argument that decisions #1 and #4 in your §1 are the right shape.

## Mapping a queueing model to a GSMP (concern b)

**`Glasserman1991_GradientEstimationViaPerturbationAnalysis.md`** (583 KB, 124 pp., marker)
Chapter 2 (line 642) defines the GSMP and gives *"a detailed construction of their sample
paths"* — the construction your §3.5 time-change proposition is implicitly quoting. This is the
canonical statement of the clock-speed formalism you compile away, so it's the text to check
that proposition against. Note `../../papers_filtered/Glasserman1991_*.md` already exists in the
repo; this is the full book, that one is a filtered note.

**`Bogliolo2004_SpecificationAnalysisPowerManagedSystems.md`** (176 KB, 39 pp., nougat)
The most concrete GSMP-with-clock-speeds implementation in the library: it carries an explicit
`clk[e]` array of clock readings and a literal `speeds[s][e]` state×event matrix, plus an
execution semantics for simulating it. Useful precisely *because* it does the thing your §3.5
argues you should not do — it's the baseline your truncate-and-rescale compilation replaces, and
the clearest way to check the equivalence claim is against someone who kept the speeds.

**`Dolgert2016_CTDESFromCountingProcesses.md`** (50 KB, 17 pp., nougat)
Your own paper, and the tightest statement of the "which event fires next" rule: hazard rates →
counting processes → transition kernel → four ways to sample it. Argues GSMP and GSPN (absent
immediate/simultaneous events) are subclasses for computational purposes. This is the bridge
from your IR to CompetingClocks in 17 pages.

**`Reinhardt2022_ML3_LanguageForAgentBasedDES.md`** (97 KB, 26 pp., marker)
The one prior art for your *whole stack*: a domain-specific surface language whose semantics are
"defined in terms of Generalized Semi-Markov Processes," with abstract syntax, formal semantics,
and a discussion of the efficient simulation algorithms the semantics imply. If you want
evidence that compile-surface-syntax-to-GSMP is a known-good architecture rather than a bet,
this is it. Relevant to your §5 open question 4 (declarative kernel state vs. closures).

**`Lindemann1999_NumericalAnalysisOfGSMPs.md`** (32 KB, 6 pp., nougat)
Short. Finite-state GSMPs with concurrent deterministic events, worked on an MMPP/D/2/K queue —
a small non-Markovian queueing model with an exact numerical answer. Candidate oracle for C5
where BCMP doesn't reach.

**`Carnevali_ORIS_NonMarkovianEvaluationTool.md`** (31 KB, 6 pp., nougat)
Tool paper: Stochastic Time Petri Nets with an underlying GSMP, including a passenger-queue case
study. Read for its engine/analysis split — it's a working instance of your Figure 1, where a
checker and several analyzers attach to one IR.

## Specifying queueing models (concern a)

**`Shedler1987_RegenerationAndNetworksOfQueues.md`** (380 KB, 232 pp., marker)
Cited twice in your tex (the job stack, §3.1; passage times, §3.6) and the one citation whose
PDF you already had but with no Markdown. Chapters: Discrete Event Simulation (109), Markovian
Networks of Queues (1341), Non-Markovian Networks of Queues (2656), **Convergence of Passage
Times (4004)** — that last is the source your `passage_times` fold reimplements.

**`Lipsky2009_QueueingTheoryLinearAlgebraicApproach.md`** (857 KB, 560 pp., nougat)
The `papers/queueing theory a linear algebraic approach.pdf` you already have, now as text. 2nd
ed. adds a semi-Markov process chapter and a section on networks of non-exponential servers —
the case your Layer 3 exists to handle. Matrix-analytic closed forms here are oracle material
for C5 beyond BCMP's product-form reach.

## quarton_docs/

Not from the MCP — copied from `~/dev/Quarton.jl`, since `queue_layers.tex` argues against
Quarton throughout and none of it would otherwise travel with you. `definition.md` is the file
your §3.2 quotes ("the danger of separating these steps is that we might exclude a useful
model"). `redesign_ordering.md` (Dec 2025) is the sub-event ordering problem your
deposit!/settle! order resolves by fiat. Delete if you don't want them.

## Cited by queue_layers.tex but NOT obtainable here

- **Harchol-Balter's book** (§3.6, "every statistic in Harchol-Balter's book is a fold over ℛ").
  Not in the library, in any edition. Several Harchol-Balter *papers* are (Grosof's WCFS and
  RESET/MARC, on multiserver-job and limited-processor-sharing analysis) — deliberately left out
  as analysis rather than specification, but they bear on the multiserver-job models your
  decision #2 restores, and on PS. Easy to add.
- **BCMP** (Baskett/Chandy/Muntz/Palacios 1975), which C5's product-form oracle detector rests
  on. Searched by title and by all four author names; not in the library. This is the notable
  gap — C5 is specified against a paper you won't have. Zimmermann Ch. 4 and Lipsky both cover
  product-form networks and may carry enough of the BCMP conditions to reconstruct the check.
- **The GSMP clock-speed literature** (Glynn; Haas) that decision #1 leans on. No Glynn GSMP
  paper in the library; Glasserman Ch. 2 is the closest substitute and is included.
