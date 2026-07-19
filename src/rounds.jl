# Round-based token service (capability 6): a station may serve in
# synchronous rounds. At each round boundary a RoundPolicy examines the
# waiting line and the active set through a read-only RoundView, admits and
# evicts jobs, and allocates integer work units (tokens) to active jobs; one
# station-level clock runs the round, and per-job work counters persist
# across rounds. The policy is the first user-code hook inside the fire
# path, so the view is a real barrier — copies and counts, never the
# QueueState — and the purity contract (a pure function of (view, draws))
# is the Opaque-law precedent: documented and tested, not compile-checkable.
#
# This file defines the surface config, the policy interface, and the
# shipped policies; the engine half (planning in settle!, the :round clock
# family, commit and credit) lives in semantics.jl. Job ids are Int64 here
# because state.jl's `const JobId = Int64` loads later; the alias is used
# freely inside method bodies.

"""
    RoundPolicy

Abstract supertype of round-boundary batch policies. A concrete policy
implements one method, [`plan_round`](@ref), a pure function of a
[`RoundView`](@ref) and a draw source that returns the next round's
[`RoundPlan`](@ref) (or `nothing` to idle). The shipped policies are Dai
et al.'s four ([`FasterTransformerRule`](@ref), [`VanillaVLLM`](@ref),
[`Orca`](@ref), [`Sarathi`](@ref)) with the [`ClassPriority`](@ref)
wrapper, and Dong & Cao's two ([`ClassBudgets`](@ref),
[`FlowControl`](@ref)).
"""
abstract type RoundPolicy end

"""
    Rounds(; policy, duration, work)

The round-service configuration of [`station!`](@ref). A round station
serves in synchronous rounds: at each boundary `policy` (a
[`RoundPolicy`](@ref)) plans the round — admissions, evictions, and
per-active-job integer token allocations — and one station-level clock
runs it under `duration`, a law over the plan's frozen aggregates. At the
firing the allocations are credited against per-job work counters, jobs
whose work is exhausted route onward, and the next round is planned at the
same instant, so back-to-back rounds chain with no gap. A station with no
plan idles clock-free; the first deposit after an idle period starts the
round grid at that deposit's time.

- `policy`: the [`RoundPolicy`](@ref) consulted at every boundary.
- `duration`: the round-length law. It may read parameters, [`Enab`](@ref),
  and the plan's aggregates as pseudo-marks — `Mark(:tokens)` (the token
  load b), `Mark(:requests)` (the batch size k), and one per-phase sum
  named by each `work` mark — frozen at enabling like any mark (check
  C13). Dai's staircase is `Const(c) + Const(a) * ceil(Mark(:tokens) / b0)`.
- `work`: the names of the marks (produced upstream or by `remark`) that
  give a job's integer work profile, in phase order; the LAST phase is the
  decode phase of the shipped policies. The marks are snapshotted into
  integer counters at admission and must be integers ≥ 0 at runtime.

Check C12 fixes the station shape: FCFS (`:back`-insert, non-preemptive),
no `batching`, `servers = 1` (the round clock is the server), and no
`service` law — the duration lives here. Waiting jobs keep patience
clocks; active jobs have none, and an evicted job re-files with a fresh
patience clock and RESET work counters (Dong's refresh semantics).
Round-station departures meeting a full `:block` destination are dropped,
the batch-member rule. A `Dirac` duration bears no density, so θ inside
it has no score channel and pathwise IPA is not certified; θ in the
arrival, mark, or remark laws feeding the station keeps a valid score.
`branch_world` refuses round stations in v1.

# Example

```julia
station!(net, :gpu;
    rounds = Rounds(
        policy   = Sarathi(budget = 512),
        duration = Law(:Dirac; value = Const(11.28) + Const(35.47) * ceil(Mark(:tokens) / 128)),
        work     = (:v_p, :v_d),
    ))
```
"""
struct Rounds
    policy::RoundPolicy
    duration::AbstractLaw
    work::Vector{Symbol}
    function Rounds(; policy::RoundPolicy, duration::AbstractLaw, work)
        wk = work isa Symbol ? Symbol[work] : collect(Symbol, work)
        isempty(wk) && throw(ArgumentError("Rounds needs at least one work mark"))
        allunique(wk) || throw(ArgumentError("Rounds work marks must be distinct"))
        for reserved in (:tokens, :requests)
            reserved in wk && throw(
                ArgumentError(
                    "Rounds work mark $reserved collides with the round aggregate " *
                    "of the same name",
                ),
            )
        end
        return new(policy, duration, wk)
    end
end

"""
    RoundJob

One job as a [`RoundView`](@ref) shows it to a policy: `id` (the job id),
`marks` (the job's marks), and `work` — the remaining integer work per
phase for an active job, or the full profile the marks give (what the
counters would be at admission) for a waiting one. The vectors are copies;
mutating them changes nothing.
"""
struct RoundJob
    id::Int64                 # JobId (state.jl)
    marks::NamedTuple
    work::Vector{Int}
end

"""
    RoundView

The read-only window a [`RoundPolicy`](@ref) plans through: `phases` (the
station's `work` mark names, in phase order), `waiting` (the
[`RoundJob`](@ref)s in the buffer, FCFS order), and `active` (the jobs in
service, admission order). It is a barrier — copies and values, never the
`QueueState` — so a policy can rank and count jobs but cannot reach the
simulation state.
"""
struct RoundView
    phases::Vector{Symbol}
    waiting::Vector{RoundJob}
    active::Vector{RoundJob}
end

"""
    RoundPlan(; admit = [], evict = [], alloc = [])

What a [`RoundPolicy`](@ref) commits at a round boundary: `admit` (waiting
job ids to move into the active set, in order), `evict` (active job ids
returned to the waiting line, work counters RESET — Dong's refresh
semantics), and `alloc` (`id => tokens-per-phase` pairs over active jobs,
newly admitted included; an active job absent from `alloc` gets zero).
The engine applies evictions, then admissions, then checks every
allocation against `0 ≤ alloc ≤ remaining` per phase, and freezes the
plan's `aggregates` — `tokens`, `requests`, and the per-phase sums — as
the pseudo-marks the duration law reads. A job whose every phase reaches
zero at the round's firing routes onward.
"""
struct RoundPlan
    admit::Vector{Int64}      # JobId (state.jl)
    evict::Vector{Int64}
    alloc::Vector{Pair{Int64,Vector{Int}}}
    aggregates::NamedTuple    # frozen by the engine at commit; empty until then
end

function RoundPlan(;
    admit=Int64[], evict=Int64[], alloc=Pair{Int64,Vector{Int}}[], aggregates::NamedTuple=(;)
)
    return RoundPlan(
        collect(Int64, admit),
        collect(Int64, evict),
        Pair{Int64,Vector{Int}}[j => v for (j, v) in alloc],
        aggregates,
    )
end

function Base.:(==)(a::RoundPlan, b::RoundPlan)
    return a.admit == b.admit &&
           a.evict == b.evict &&
           a.alloc == b.alloc &&
           a.aggregates == b.aggregates
end

"""
    plan_round(policy, v::RoundView, draws) -> Union{RoundPlan,Nothing}

The one required method of a [`RoundPolicy`](@ref): plan the next round
from the view, or return `nothing` to idle (no round runs; the station
re-plans at the next deposit). The contract, documented and tested but
not compile-checkable (the `Opaque` precedent): the policy is a pure
function of `(v, draws)` — all randomness through `draws` (via
[`draw!`](@ref), recorded and replayed), no clocks, no wall time, no θ,
no state beyond the view. Replay equality and the `debug = true`
membership oracle catch violations.
"""
function plan_round end

# ---------------------------------------------------------------------------
# Shared machinery of the shipped policies. Phase convention: the LAST work
# phase is the decode phase — one token per request per round, Dai's
# constraint (6c) — and every earlier phase is chunkable prefill. A request
# with prefill remaining takes no decode token in the same round (Dai (6a)).

_prefill_left(w::Vector{Int}) = sum(view(w, 1:(length(w) - 1)))
_decode_left(w::Vector{Int}) = w[end]

# One decode token: all phases zero except the last.
function _decode_one(j::RoundJob)
    av = zeros(Int, length(j.work))
    av[end] = 1
    return av
end

# A prefill chunk of n tokens, filling the non-final phases in order.
function _prefill_chunk(j::RoundJob, n::Int)
    av = zeros(Int, length(j.work))
    for p in 1:(length(j.work) - 1)
        take = min(n, j.work[p])
        av[p] = take
        n -= take
        n == 0 && break
    end
    return av
end

# The Dai policies admit every waiting job — the papers' active set is the
# whole system; memory is not modeled — and differ only in how _allocate
# composes the batch over the post-admission active list (existing active
# first, then the admissions, which preserves global FCFS order).
function _dai_plan(pol::RoundPolicy, v::RoundView)
    admit = Int64[w.id for w in v.waiting]
    jobs = vcat(v.active, v.waiting)
    isempty(jobs) && return nothing
    alloc, tokens, _ = _allocate(pol, jobs, _budget(pol), _kmax(pol))
    tokens == 0 && return nothing
    return RoundPlan(; admit, alloc)
end

_budget(pol::RoundPolicy) = pol.budget
_kmax(pol::RoundPolicy) = pol.kmax

# Decode-only composition: one token per decode-phase request, FCFS, while
# the budget and the batch-size cap allow.
function _fill_decodes!(alloc, jobs, budget::Int, kmax::Int, tokens::Int, requests::Int)
    for j in jobs
        (_prefill_left(j.work) == 0 && _decode_left(j.work) > 0) || continue
        (tokens < budget && requests < kmax) || break
        push!(alloc, j.id => _decode_one(j))
        tokens += 1
        requests += 1
    end
    return tokens, requests
end

# Whole-prefill composition (no chunking): add each waiting prefill in FCFS
# order while it fits whole; stop at the first that does not (head-of-line).
function _fill_whole_prefills!(alloc, jobs, budget::Int, kmax::Int, tokens::Int, requests::Int)
    for j in jobs
        n = _prefill_left(j.work)
        n > 0 || continue
        (n <= budget - tokens && requests < kmax) || break
        push!(alloc, j.id => _prefill_chunk(j, n))
        tokens += n
        requests += 1
    end
    return tokens, requests
end

# Chunked-prefill composition: fill the remaining budget with prefill tokens
# in FCFS order, as much as possible from each request before moving to the
# next — which is Sarathi's "minimal number of requests" rule.
function _fill_prefill_chunks!(alloc, jobs, budget::Int, kmax::Int, tokens::Int, requests::Int)
    for j in jobs
        n = min(_prefill_left(j.work), budget - tokens)
        n > 0 || (_prefill_left(j.work) > 0 ? break : continue)
        requests < kmax || break
        push!(alloc, j.id => _prefill_chunk(j, n))
        tokens += n
        requests += 1
    end
    return tokens, requests
end

"""
    FasterTransformerRule(; budget, kmax = typemax(Int))

Dai et al.'s stylized FasterTransformer (arXiv:2504.07347 §4):
decode-prioritized, no mixed batching. Whenever any request is in the
decode phase, the round is a decode-only batch — one token per decode
request, FCFS, up to the token `budget` and the batch-size cap `kmax` —
and prefill waits. Only with no decodes pending does it form a
prefill-only batch of whole prefills (no chunking), FCFS while they fit.
Not work-conserving; unstable inside the Theorem 2 region.
"""
struct FasterTransformerRule <: RoundPolicy
    budget::Int
    kmax::Int
end
function FasterTransformerRule(; budget::Int, kmax::Int=typemax(Int))
    budget >= 1 || throw(ArgumentError("FasterTransformerRule needs budget >= 1"))
    kmax >= 1 || throw(ArgumentError("FasterTransformerRule needs kmax >= 1"))
    return FasterTransformerRule(budget, kmax)
end

function _allocate(pol::FasterTransformerRule, jobs, budget::Int, kmax::Int)
    alloc = Pair{Int64,Vector{Int}}[]
    anydecode = any(j -> _prefill_left(j.work) == 0 && _decode_left(j.work) > 0, jobs)
    tokens, requests = if anydecode
        _fill_decodes!(alloc, jobs, budget, kmax, 0, 0)
    else
        _fill_whole_prefills!(alloc, jobs, budget, kmax, 0, 0)
    end
    return alloc, tokens, requests
end

"""
    VanillaVLLM(; budget, kmax = typemax(Int))

Dai et al.'s vanilla vLLM (arXiv:2504.07347 §4): prefill-prioritized, no
mixed batching, no chunked prefill. Whenever any request is in the prefill
phase, the round is a prefill-only batch of whole prefills, FCFS while
they fit the token `budget` (and `kmax`), and decodes wait. Only with no
prefill pending does it batch decode tokens, one per request, FCFS. Not
work-conserving; unstable inside the Theorem 2 region.
"""
struct VanillaVLLM <: RoundPolicy
    budget::Int
    kmax::Int
end
function VanillaVLLM(; budget::Int, kmax::Int=typemax(Int))
    budget >= 1 || throw(ArgumentError("VanillaVLLM needs budget >= 1"))
    kmax >= 1 || throw(ArgumentError("VanillaVLLM needs kmax >= 1"))
    return VanillaVLLM(budget, kmax)
end

function _allocate(pol::VanillaVLLM, jobs, budget::Int, kmax::Int)
    alloc = Pair{Int64,Vector{Int}}[]
    anyprefill = any(j -> _prefill_left(j.work) > 0, jobs)
    tokens, requests = if anyprefill
        _fill_whole_prefills!(alloc, jobs, budget, kmax, 0, 0)
    else
        _fill_decodes!(alloc, jobs, budget, kmax, 0, 0)
    end
    return alloc, tokens, requests
end

"""
    Orca(; budget, kmax = typemax(Int))

Dai et al.'s stylized Orca (arXiv:2504.07347 §4): prefill-prioritized with
mixed batching. Each round first fills the token `budget` with prefill
tokens, FCFS (chunked as needed to stay work-conserving), then packs
decode tokens — one per decode request, FCFS — into the remainder, up to
the batch-size cap `kmax`. Work-conserving, hence throughput-optimal in
the Theorem 2 region.
"""
struct Orca <: RoundPolicy
    budget::Int
    kmax::Int
end
function Orca(; budget::Int, kmax::Int=typemax(Int))
    budget >= 1 || throw(ArgumentError("Orca needs budget >= 1"))
    kmax >= 1 || throw(ArgumentError("Orca needs kmax >= 1"))
    return Orca(budget, kmax)
end

function _allocate(pol::Orca, jobs, budget::Int, kmax::Int)
    alloc = Pair{Int64,Vector{Int}}[]
    tokens, requests = _fill_prefill_chunks!(alloc, jobs, budget, kmax, 0, 0)
    tokens, requests = _fill_decodes!(alloc, jobs, budget, kmax, tokens, requests)
    return alloc, tokens, requests
end

"""
    Sarathi(; budget, kmax = typemax(Int))

Dai et al.'s stylized Sarathi-Serve (arXiv:2504.07347 §4):
decode-prioritized with chunked prefill. Each round first takes one decode
token per decode-phase request, FCFS, then fills the remaining token
`budget` with prefill chunks from a minimal number of requests — as much
as possible from the FCFS-first prefill request before touching the next —
up to the batch-size cap `kmax`. Work-conserving, hence
throughput-optimal in the Theorem 2 region.
"""
struct Sarathi <: RoundPolicy
    budget::Int
    kmax::Int
end
function Sarathi(; budget::Int, kmax::Int=typemax(Int))
    budget >= 1 || throw(ArgumentError("Sarathi needs budget >= 1"))
    kmax >= 1 || throw(ArgumentError("Sarathi needs kmax >= 1"))
    return Sarathi(budget, kmax)
end

function _allocate(pol::Sarathi, jobs, budget::Int, kmax::Int)
    alloc = Pair{Int64,Vector{Int}}[]
    tokens, requests = _fill_decodes!(alloc, jobs, budget, kmax, 0, 0)
    tokens, requests = _fill_prefill_chunks!(alloc, jobs, budget, kmax, tokens, requests)
    return alloc, tokens, requests
end

"""
    ClassPriority(inner; by, order)

Non-preemptive class priority over any Dai-style policy: jobs are
partitioned by the value of mark `by`, classes are served in the order
`order` lists their values (unlisted values come last, together), and
`inner`'s composition rule runs class by class on the leftover token
budget and batch-size cap — so the whole budget goes to the highest
class's tokens before any lower class is touched, with `inner`'s own
prefill/decode rule inside each class. FCFS is preserved within a class.
This is the wrapper Dai et al.'s Rybko–Stolyar experiment (§5.4) needs:
`ClassPriority(Sarathi(budget = 768); by = :class, order = [2.0, 1.0])`
gives class 2 strict priority. Admissions delegate to the Dai rule (every
waiting job is admitted); wrappers nest.
"""
struct ClassPriority{P<:RoundPolicy} <: RoundPolicy
    inner::P
    by::Symbol
    order::Vector{Float64}
end
function ClassPriority(inner::RoundPolicy; by::Symbol, order)
    return ClassPriority(inner, by, collect(Float64, order))
end

_budget(pol::ClassPriority) = _budget(pol.inner)
_kmax(pol::ClassPriority) = _kmax(pol.inner)

function _allocate(pol::ClassPriority, jobs, budget::Int, kmax::Int)
    nranks = length(pol.order) + 1
    rank(j) = something(findfirst(==(Float64(getfield(j.marks, pol.by))), pol.order), nranks)
    alloc = Pair{Int64,Vector{Int}}[]
    tokens = 0
    requests = 0
    for r in 1:nranks
        group = [j for j in jobs if rank(j) == r]
        isempty(group) && continue
        (tokens < budget && requests < kmax) || break
        a, tk, rq = _allocate(pol.inner, group, budget - tokens, kmax - requests)
        append!(alloc, a)
        tokens += tk
        requests += rq
    end
    return alloc, tokens, requests
end

function plan_round(
    pol::Union{FasterTransformerRule,VanillaVLLM,Orca,Sarathi,ClassPriority}, v::RoundView, draws
)
    return _dai_plan(pol, v)
end

# ---------------------------------------------------------------------------
# Dong & Cao's policies (arXiv:2604.11001). Both serve a SINGLE decode
# phase — one slot per round, every active request generating one token —
# with the prompt (prefill) length as an ordinary mark that costs memory
# but no time.

function _assert_one_phase(pol, v::RoundView)
    length(v.phases) == 1 || error(
        "$(nameof(typeof(pol))) serves a single decode phase (one token per " *
        "active request per round); the station declares $(length(v.phases)) " *
        "work phases $(Tuple(v.phases))",
    )
    return nothing
end

_one_decode(j::RoundJob) = Int[min(1, j.work[1])]

"""
    ClassBudgets(b; class = :class)

Dong & Cao's Algorithm 1 (arXiv:2604.11001): flow control with known
output lengths. Each round (one decode slot), for each class `k = 1..m`
in order, up to `b[k]` waiting requests whose integer-valued mark `class`
equals `k` are activated, FIFO; every active request then decodes exactly
one token. There is NO memory check — budgets satisfying the paper's
inequality (2) guarantee the KV cache never overflows — and no eviction.
`b` is anything indexable by the class index (a `Tuple`, `Vector`, or
`NamedTuple` in class order). Use a single work phase naming the decode
length; the prompt length is an ordinary mark.
"""
struct ClassBudgets{B} <: RoundPolicy
    b::B
    class::Symbol
end
ClassBudgets(b; class::Symbol=:class) = ClassBudgets{typeof(b)}(b, class)

function plan_round(pol::ClassBudgets, v::RoundView, draws)
    _assert_one_phase(pol, v)
    (isempty(v.waiting) && isempty(v.active)) && return nothing
    admit = Int64[]
    admitted = RoundJob[]
    for k in 1:length(pol.b)
        n = 0
        for w in v.waiting
            n < pol.b[k] || break
            Int(getfield(w.marks, pol.class)) == k || continue
            push!(admit, w.id)
            push!(admitted, w)
            n += 1
        end
    end
    alloc = Pair{Int64,Vector{Int}}[j.id => _one_decode(j) for j in vcat(v.active, admitted)]
    (isempty(admit) && isempty(alloc)) && return nothing
    return RoundPlan(; admit, alloc)
end

"""
    FlowControl(Bdist, M; prompt = :l)

Dong & Cao's Algorithm 2 (arXiv:2604.11001): flow control with unknown
output lengths. Each planned round (one decode slot) draws a global
activation budget `B ~ Bdist` through the round's draw source (recorded,
so replay reproduces it), activates up to `B` waiting requests FIFO, and
then checks the KV cache: with `l` the value of the `prompt` mark and
`g` the tokens a request has generated, the slot's memory usage is
`U = Σ (l + g + 1)` over the active set, the slot's own token included
(the paper's `l + (t - s + 1)` accounting). While `U > M`, active
requests are evicted last-in first-out — the most recently activated
first, just-activated ones before older ones — with FULL progress reset
(the engine clears the work counters; a re-activated request regenerates
everything). Survivors each decode one token. Use a single work phase
naming the decode length. The station idles (and draws nothing) only when
it holds no jobs at all; each round with jobs present draws a fresh
budget, one draw per slot as in the paper.
"""
struct FlowControl{D} <: RoundPolicy
    Bdist::D
    M::Int
    prompt::Symbol
end
function FlowControl(Bdist, M::Integer; prompt::Symbol=:l)
    M >= 1 || throw(ArgumentError("FlowControl needs a KV cache capacity M >= 1"))
    return FlowControl{typeof(Bdist)}(Bdist, Int(M), prompt)
end

function plan_round(pol::FlowControl, v::RoundView, draws)
    _assert_one_phase(pol, v)
    (isempty(v.waiting) && isempty(v.active)) && return nothing
    B = Int(draw!(draws, :budget, pol.Bdist))
    B >= 0 || error("FlowControl drew a negative activation budget $B")
    nadmit = min(B, length(v.waiting))
    admitted = v.waiting[1:nadmit]
    # This slot's KV usage of one member: prompt length + tokens generated
    # after this slot's decode. A just-activated request has generated none.
    l(j) = Int(getfield(j.marks, pol.prompt))
    gen(j) = Int(getfield(j.marks, v.phases[1])) - j.work[1]
    usage(j, isactive) = l(j) + (isactive ? gen(j) : 0) + 1
    U =
        sum(usage(j, true) for j in v.active; init=0) +
        sum(usage(j, false) for j in admitted; init=0)
    # LIFO eviction on overflow: newest activation first. Dropping a
    # just-admitted request is simply not admitting it; evicting a
    # previously active one goes into the plan's evict list for the engine
    # to reset and re-file.
    evict = Int64[]
    kept_admit = collect(admitted)
    kept_active = collect(v.active)
    while U > pol.M
        if !isempty(kept_admit)
            j = pop!(kept_admit)
            U -= usage(j, false)
        elseif !isempty(kept_active)
            j = pop!(kept_active)
            push!(evict, j.id)
            U -= usage(j, true)
        else
            break
        end
    end
    admit = Int64[j.id for j in kept_admit]
    alloc = Pair{Int64,Vector{Int}}[j.id => _one_decode(j) for j in vcat(kept_active, kept_admit)]
    (isempty(admit) && isempty(evict) && isempty(alloc)) && return nothing
    return RoundPlan(; admit, evict, alloc)
end
