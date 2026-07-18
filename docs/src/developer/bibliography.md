# Bibliography

The literature that shaped Concourse's design lives in
`notes/queuepapers/`, as full-text extractions selected to support
implementing the three-layer architecture. This page is the annotated
index; `notes/queuepapers/INDEX.md` is its source and carries extraction
details (two OCR pipelines fed the directory, so in the noisier files,
trust the math over the surrounding prose).

The selection criteria, in the order they mattered: how to map a queueing
model onto a generalized semi-Markov process (GSMP) you can execute with a
next-event rule; how to specify a queueing model in the first place; and
works the design notes cite by name.

## The central one

**Zimmermann (2007). *Stochastic Discrete Event Systems.***
The closest published relative of Concourse's design. Zimmermann's thesis
is the same thesis as `notes/queue_layers.tex`: many surface model classes
share one underlying abstract model, so define the abstraction once and
translate each surface class into it. His Chapter 2 (a unified description
for stochastic discrete event systems) maps to Concourse's intermediate
representation, Chapter 4 (queuing models) to the surface language and its
compilation, Chapters 5–6 (Petri nets) to the `:fresh`/`:resume` preemption
vocabulary, and Chapter 9 (efficient simulation) to the sampler layer. Also
the source for the immediate-transition / vanishing-marking treatment the
cascade worklist restates for queues.

## Mapping a queueing model to a GSMP

**Glasserman (1991). *Gradient Estimation via Perturbation Analysis.***
Chapter 2 defines the GSMP with a detailed construction of its sample paths
— the canonical statement of the clock-speed formalism that Concourse
compiles away, and the text the time-change proposition is checked against.
Also the standard reference for infinitesimal perturbation analysis (IPA),
the pathwise estimator.

**Bogliolo et al. (2004). *Specification and Analysis of Power-Managed
Systems.***
The most concrete GSMP-with-clock-speeds implementation in the collection:
an explicit array of clock readings and a literal state-by-event speed
matrix, with an execution semantics. Useful precisely *because* it does the
thing Concourse argues against — it is the baseline the
truncate-and-rescale compilation replaces, and the reference implementation
named in charter item F8.

**Dolgert (2016). *Continuous-Time Discrete-Event Simulation from Counting
Processes.***
The tightest statement of the "which event fires next" rule: hazard rates
to counting processes to a transition kernel, with four ways to sample it.
Argues that GSMP and generalized stochastic Petri nets (absent immediate
and simultaneous events) are computationally the same class. The bridge
from the intermediate representation to CompetingClocks.

**Reinhardt et al. (2022). *ML3: A Language for Agent-Based Discrete-Event
Simulation.***
The one prior art for the whole stack: a domain-specific surface language
whose semantics are defined in terms of GSMPs, with abstract syntax, formal
semantics, and the simulation algorithms the semantics imply. Evidence that
compile-surface-syntax-to-GSMP is a known-good architecture rather than a
bet; also bears on keeping routing-kernel state declarative instead of
hidden in closures.

**Lindemann and Shedler (1999). *Numerical Analysis of Generalized
Semi-Markov Processes.***
Short. Finite-state GSMPs with concurrent deterministic events, worked on a
small non-Markovian queue with an exact numerical answer — candidate test
oracle for the cases the product-form (BCMP) detector cannot reach.

**Carnevali et al. *ORIS: A Tool for Non-Markovian Evaluation.***
Tool paper: stochastic time Petri nets over an underlying GSMP, with a
passenger-queue case study. Read for its engine/analysis split — a working
instance of the architecture diagram in which a checker and several
analyzers attach to one intermediate representation.

## Specifying queueing models

**Shedler (1987). *Regeneration and Networks of Queues.***
Cited twice by the design notes: the job stack (the buffer order *is* the
discipline's data, so there is no per-discipline container type) and
passage times (the two-predicate fold over the record reimplements his
marked-job specification, with the record replacing the state augmentation
his 1987 memory budget forced him to compress). Also feeds the regenerative
estimation material in the Manual's statistics page.

**Lipsky (2009). *Queueing Theory: A Linear Algebraic Approach*, 2nd ed.**
Matrix-analytic closed forms, a semi-Markov process chapter, and a section
on networks of non-exponential servers — the case the sampler layer exists
to handle. Oracle material beyond the product-form reach of BCMP.

## Quarton documents

`notes/queuepapers/quarton_docs/` preserves design documents from
Quarton.jl, the predecessor project the architecture note argues against
throughout. `definition.md` is the source of the sub-event ordering worry
("the danger of separating these steps is that we might exclude a useful
model") that the fixed `deposit!`/`settle!` cascade order resolves, and
`redesign_ordering.md` is the ordering problem itself.

## Cited but not in the collection

- **Harchol-Balter, *Performance Modeling and Design of Computer
  Systems*.** The claim "every statistic in Harchol-Balter's book is a fold
  over the record" is made against a book the collection does not carry.
- **Baskett, Chandy, Muntz, and Palacios (1975)** — the BCMP theorem, which
  the product-form oracle detector (check C5) rests on. The notable gap;
  Zimmermann Chapter 4 and Lipsky carry enough of the product-form
  conditions to reconstruct the check.
- **The GSMP clock-speed literature (Glynn; Haas)** that the compile-away
  decision leans on; Glasserman Chapter 2 is the closest substitute and is
  included.
- **Gong and Ho; Fu and Hu** — the origin and the book-length treatment of
  smoothed perturbation analysis, followed closely by
  `notes/spa_derivation.tex` (see [The SPA estimator](spa.md)).
