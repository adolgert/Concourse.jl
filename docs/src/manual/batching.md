# Batch service

A server that takes several jobs at once — a diffusion furnace loading a
tube of wafers, a GPU running inference over a padded batch of requests, a
shuttle that leaves when enough passengers have boarded — serves a
*batch*: one clock times the whole group, and the group's size may set
that clock's law. In Concourse a station declares this with the
`batching` keyword of [`station!`](@ref); everything else — routing,
reneging, blocking, records — keeps its usual meaning at the level of the
individual jobs.

## The gathering rule

[`Batching`](@ref)`(min, max)` says: while a server slot is free and at
least `min` jobs are waiting, gather up to `max` of them, in discipline
order, into one batch. With fewer than `min` waiting the server idles —
no clock counts down toward formation, because every arrival re-runs the
dispatch step, so the batch forms at the instant the threshold is met.
Two settings bracket the family:

- `Batching()` — the defaults `min = 1, max = typemax(Int)` — is the
  *gather-everything* rule: an idle server takes the entire line. This is
  the dynamic batching of Inoue (2021, arXiv:1912.06322), the worked
  model below.
- `Batching(min = K, max = K)` is classical fixed-size batch service,
  the M/M``^{[K]}``/1 of the textbooks. The test suite pins it against a
  truncated-CTMC solution of the batch chain.

Gathering must consume no randomness, and a batch in service must never
be preempted or reordered — guarantees only the non-preemptive
`:back`-insert [`FCFS`](@ref) discipline gives. Declaring batching under
any other discipline is compile check C6:

```@example batching
using Concourse

net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :furnace; discipline = LCFS(),
         service = Law(:Exponential, scale = inv(Param(:mu))),
         batching = Batching(min = 2, max = 2))
sink!(net, :done)
route!(net, :arrive, Always(:furnace))
route!(net, :furnace, Always(:done))
try
    compile(net)
catch err
    println(err.msg)
end
```

## One synthetic job per batch

When a batch forms, the gathered jobs leave the buffer and a *fresh* job
enters service in their place: a new id whose only marks are
`(batchsize = Float64(k),)`, with ``k`` the number gathered. The service
clock belongs to this synthetic job, so the service law reads the batch
size the way any law reads any mark — `Mark(:batchsize)`, no new
expression atom — and the size is frozen at enabling, like every mark. A
processing time affine in the batch size is one line:

```julia
service = Law(:Dirac, value = Const(τ0) + Const(α) * Mark(:batchsize))
```

The members themselves stay in `st.jobs`, keyed to their batch through
`st.batchmembers` — like stashed join siblings, they are still in the
system, just not in any line. Only the batch station's own service law
may read `batchsize` (check C2): the mark exists on the synthetic job
alone, and a batch job never gets a patience clock — it is in service by
construction, and jobs in service do not renege.

## Members before, during, and after the batch

**Before.** A waiting member is an ordinary waiting job. In particular it
keeps its patience clock until the moment it is gathered, so reneging
races batch formation exactly as it should: a job whose patience fires
while the line is still below `min` abandons like any other, and the
census identity arrivals = served + reneged + in system holds exactly.

**During.** Members in a live batch have no clocks of their own; the one
service clock is the batch's.

**After.** When the batch's clock fires, the synthetic job dissolves and
each member routes *individually*, in gather order, on its own marks —
each member's routing kernel may consume its own recorded draw, so a
[`Probabilistic`](@ref) route downstream of a batch station behaves
per-member, not per-batch.

One decision deserves its rationale. `:block` overflow holds a finished
job in the *upstream server* that produced it, and that server stays
occupied until room frees downstream. But by the time a batch member is
deposited, its batch has already fired — the server is free, and there is
nothing left to hold the member. So a member that meets a full `:block`
destination is **dropped**, exactly like an arrival straight from a
source (which has no server behind it either). This is a documented
modeling decision, to be revisited only if a target model needs
member-blocking; the alternative — re-occupying the freed server — would
silently reintroduce the batch after its completion event.

## Counting members, not bookkeeping

Two occupancy conventions follow from the synthetic-job mechanics:

- [`number_in_system`](@ref) counts *members*. A live batch contributes
  its ``k`` members, not ``k + 1`` jobs — the batch id is bookkeeping,
  and the count subtracts one per entry in `st.batchmembers`.
- `Concourse.number_at(q)` counts *residents of the station* —
  buffer, servers, and held jobs — and there a live batch counts as
  **one**, because the `srv` vector holds the synthetic job.

The distinction is real: in M/M``^{[K]}``/1 the system count sees ``K``
members in service where the station count sees one batch. The test suite
checks both against the same truncated-CTMC oracle.

## Nothing new in the record

Batch composition is a deterministic function of state — `min`, `max`,
and discipline order decide everything, no randomness — so the record
gains nothing: no new event kind, no new draw. [Replay](record_replay.md)
folds the same `fire_changes` and reforms every batch identically;
`states_equal` compares `st.batchmembers` field by field, and the
[debug oracle](checking.md) runs unchanged. The sharpest form of "the
batch path adds nothing when inactive" is also tested: under
`Batching(min = 1, max = 1)` with a deterministic service law, the batch
station reproduces the plain FCFS station's record — same times, same
draws, same event kinds — differing only in the job-id slot, because
batch ids are minted alongside member ids.

## Inoue's gather-everything model

Inoue (2021) analyzes exactly the defaults: an idle server takes the
whole line, and the batch processing time is deterministic and affine in
the batch size, ``\tau(b) = \tau_0 + \alpha b`` — the observed behavior
of GPU inference serving, where ``\tau_0`` is kernel launch overhead and
``\alpha`` the per-request cost. The paper's Theorem 2 gives closed-form
upper bounds on the mean latency. Here is the model at the paper's own
parameter point (the Tesla V100 fit, normalized load
``\rho = \lambda\alpha = 0.5``), with mean latency measured through
Little's law:

```@example batching
α, τ0 = 0.1438, 1.8874          # Inoue's Tesla V100 fit (§3.3)
λ = 0.5 / α                     # normalized load ρ = λα = 0.5

net = QueueNetwork(param_names = (:lambda,))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :gpu;
         service = Law(:Dirac, value = Const(τ0) + Const(α) * Mark(:batchsize)),
         batching = Batching())         # min = 1, max = typemax(Int)
sink!(net, :done)
route!(net, :arrive, Always(:gpu))
route!(net, :gpu, Always(:done))
m = compile(net)

rec = simulate(m, [λ], 4000.0; seed = 7)
L = time_average(number_in_system, m, rec)
W = L / λ                                # Little's law: mean latency

φ0 = (α + τ0) / (2 * (1 - λ * α)) * (1 + 2 * λ * τ0 + (1 - λ * τ0) / (1 + λ * α))
φ1 = 1.5 * τ0 / (1 - λ * α) + (α / 2) * (λ * α + 2) / (1 - λ^2 * α^2)
println("mean latency: ", round(W, digits = 3),
        "   Theorem 2 bound: ", round(min(φ0, φ1), digits = 3))
```

The simulated latency sits below the bound, as Theorem 2 requires — at
this load, just below ``\varphi_1``, matching the paper's Figure 4a. The
test suite runs this comparison as a replicated 4-standard-error oracle
test against both the bound and the exact stationary solution of the
paper's batch-size Markov chain.

## Estimators

The batch clock's law reads only the `batchsize` mark, frozen at
enabling, so the score-function estimator's likelihood is exactly right
as recorded — score is valid. Pathwise IPA is fragile: the batch size is
integer-valued, and a perturbation that reorders an arrival against a
batch formation changes the composition by whole jobs, a discontinuous
jump the IPA interchange argument does not cover. The
[estimator-validity table](state_dependent.md#Estimator-validity) records
the full row.
