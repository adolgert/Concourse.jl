# The surface language builds a QueueNetwork value; compile() freezes it into
# a QueueGSMP whose station references are integer indices. Nothing here
# executes; that is the interpreter's job.

# A discipline is data, not a queue subtype (queue_layers.tex §2.2): how to
# file a job into the buffer, how to pick one for a free server, whether a
# better waiting job may evict one in service, and what an evicted clock
# remembers.
struct Discipline
    name::Symbol
    insert::Symbol            # :back | :front | :ordered
    by::Union{ScalarExpr,Nothing}   # ordering key for :ordered / preemption
    select::Symbol            # :front | :random
    preempt::Bool
    memory::Symbol            # :fresh | :resume
end

"""
    FCFS()

First come, first served. Jobs join the back of the waiting line; a free
server takes the front. Non-preemptive. This is the default discipline of
[`station!`](@ref).
"""
FCFS() = Discipline(:fcfs, :back, nothing, :front, false, :fresh)

# Preemptive LCFS needs an eviction rule keyed on arrival order, which the
# ordering-expression machinery does not express yet; this is the
# non-preemptive variant.
"""
    LCFS()

Last come, first served, non-preemptive. A new job joins the front of the
waiting line, so a free server takes the most recent arrival. A job already
in service is never interrupted; the preemptive variant is not expressible
yet.
"""
LCFS() = Discipline(:lcfs, :front, nothing, :front, false, :fresh)

"""
    SIRO()

Service in random order. A free server picks a waiting job uniformly at
random. The pick consumes one auxiliary draw, which is recorded, so
[`replay`](@ref) reproduces the same choices.
"""
SIRO() = Discipline(:siro, :back, nothing, :random, false, :fresh)

"""
    Priority(by::ScalarExpr; preempt=false, memory=:resume)

Priority service. The waiting line is ordered by the value of `by`
evaluated on each job's marks; lower values are served first, and ties keep
first-come, first-served order. With `preempt=true`, a strictly better
waiting job evicts the worst job in service when no server is free.
`memory` says what an evicted job's service clock remembers: `:resume`
banks the service already received, `:fresh` forgets it and redraws.

# Example

```julia
station!(net, :cpu;
         discipline = Priority(Mark(:class); preempt = true, memory = :resume),
         service = Law(:Exponential, scale = inv(Param(:mu))))
```
"""
function Priority(by::ScalarExpr; preempt::Bool=false, memory::Symbol=:resume)
    return Discipline(:priority, :ordered, by, :front, preempt, memory)
end

# Shortest remaining processing time: the ordering key is size MINUS the
# clock's age, so it reads the A1 bookkeeping (te for a running clock, bank
# for a preempted one) — see _ordval. `by` names the size mark.
"""
    SRPT(by::ScalarExpr = Mark(:size))

Shortest remaining processing time. Preemptive: the job with the least work
left is served, where remaining work is the value of `by` (a mark holding
the job's total size) minus the service the job has already received. An
interrupted job resumes where it stopped. The service law should be
consistent with the size mark, typically `Law(:Dirac, value = Mark(:size))`.
"""
SRPT(by::ScalarExpr=Mark(:size)) = Discipline(:srpt, :ordered, by, :front, true, :resume)

# Every resident job is in service at speed min(1, servers/n); the buffer is
# a zero-length staging area the settle pass immediately drains. :rescale
# memory keeps te at the original enabling and re-expresses speed changes as
# mid-flight re-evaluations, the ClockGradients segment convention — NOT the
# anchor-at-now compilation of queue_layers.tex §3.5 (see event_loop.tex).
"""
    ProcessorSharing()

Processor sharing. Every job at the station is in service at once, each at
speed `min(1, servers/n)` where `n` is the number of resident jobs. There
is no waiting line. Here `servers` is the shared service capacity, not a
count of slots.
"""
ProcessorSharing() = Discipline(:ps, :back, nothing, :front, false, :rescale)

abstract type Kernel end

"""
    Always(dest::Symbol)

The routing kernel that sends every departing job to the station named
`dest`.
"""
struct Always <: Kernel
    dest::Symbol
end

"""
    ByMark(expr::ScalarExpr, cutoffs::Vector{Float64}, dests::Vector{Symbol})

Deterministic split by a mark value. Evaluate `expr` on the job's marks and
route by where the value falls among the sorted `cutoffs`: a value at or
below `cutoffs[1]` goes to `dests[1]`, a value above the last cutoff goes
to `dests[end]`. `dests` has one more entry than `cutoffs`. The expression
may read marks only; [`compile`](@ref) rejects a kernel that reads
parameters or time, because a deterministic route must not put an
unrecorded factor into the likelihood.

# Example

```julia
# Jobs with size <= 2.0 go to :short, larger jobs to :long.
route!(net, :arrive, ByMark(Mark(:size), [2.0], [:short, :long]))
```
"""
struct ByMark <: Kernel
    expr::ScalarExpr
    cutoffs::Vector{Float64}
    dests::Vector{Symbol}
end

"""
    Probabilistic(dests::Vector{Symbol}, probs::Vector{Float64})
    Probabilistic(pairs::Pair{Symbol,<:Real}...)

Random routing: each departing job goes to `dests[i]` with probability
`probs[i]`, independently. The probabilities must sum to 1. Each decision
consumes one auxiliary uniform draw, which is recorded, so [`replay`](@ref)
reproduces the same choices.

# Example

```julia
route!(net, :arrive, Probabilistic(:a => 0.3, :b => 0.7))
```
"""
struct Probabilistic <: Kernel
    dests::Vector{Symbol}
    probs::Vector{Float64}
end
function Probabilistic(pairs::Pair{Symbol,<:Real}...)
    return Probabilistic(Symbol[p.first for p in pairs], Float64[p.second for p in pairs])
end

"""
    RoundRobin(dests::Vector{Symbol})

Cyclic routing: successive departing jobs go to `dests[1]`, `dests[2]`, …,
wrapping around. The cursor is part of the simulation state
([`QueueState`](@ref)), so [`replay`](@ref) reproduces it.
"""
struct RoundRobin <: Kernel
    dests::Vector{Symbol}
end

# D2: who among the blocked upstream servers gets a freed buffer slot is
# observable model semantics, declared per station, not an interpreter rule.
abstract type UnblockPolicy end

"""
    FCFSUnblock()

The unblock policy for stations with `overflow = :block`: when waiting room
frees, the transfer that has been blocked longest is admitted first. Which
blocked upstream job gets a freed slot is observable model behavior, so it
is declared per station (the `unblock` keyword of [`station!`](@ref)), not
fixed by the interpreter. This is the only policy so far.
"""
struct FCFSUnblock <: UnblockPolicy end

# Batch service: a free server gathers between `min` and `max` waiting jobs
# into one synthetic batch job served by a single clock; on completion the
# members route individually. `min = 1, max = typemax(Int)` is the
# gather-everything rule.
"""
    Batching(; min = 1, max = typemax(Int))

Batch-service policy for [`station!`](@ref): a free server waits until at
least `min` jobs are in the buffer, then gathers up to `max` of them (in
discipline order) into one batch served by a single clock. The batch
carries the mark `batchsize`, so the service law may read
`Mark(:batchsize)`. On completion, members route individually. Requires
the [`FCFS`](@ref) discipline (check C6).
"""
struct Batching
    min::Int
    max::Int
    function Batching(; min::Int=1, max::Int=typemax(Int))
        1 <= min || throw(ArgumentError("Batching needs min >= 1"))
        min <= max || throw(ArgumentError("Batching needs min <= max"))
        return new(min, max)
    end
end

struct SurfaceStation
    name::Symbol
    kind::Symbol              # :source | :station | :sink
    discipline::Discipline
    servers::Int
    capacity::Int             # waiting room only; servers are counted apart
    overflow::Symbol          # :drop | :block
    unblock::UnblockPolicy
    service::Union{AbstractLaw,Nothing}   # interarrival law for sources
    mark::Union{MarkLaw,Nothing}
    patience::Union{AbstractLaw,Nothing}  # reneging: per-waiting-job clock
    renege_to::Union{Symbol,Nothing}
    branches::Vector{Symbol}              # forks only
    parts::Int                            # joins only
    batching::Union{Batching,Nothing}     # stations only
end

"""
    QueueNetwork(; param_names)

A queueing network under construction. `param_names` lists the model's
parameter names; their order is the layout of the parameter vector `θ` that
[`simulate`](@ref) and the estimators take. Add stations with
[`source!`](@ref), [`station!`](@ref), [`sink!`](@ref), [`fork!`](@ref),
and [`join!`](@ref), connect them with [`route!`](@ref), then freeze the
network with [`compile`](@ref). Building a network executes nothing.

# Example

```julia
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
m = compile(net)                # an M/M/1 queue
```
"""
mutable struct QueueNetwork
    param_names::Vector{Symbol}
    stations::Vector{SurfaceStation}
    routes::Dict{Symbol,Kernel}
end
function QueueNetwork(; param_names)
    return QueueNetwork(collect(Symbol, param_names), SurfaceStation[], Dict{Symbol,Kernel}())
end

function _addstation!(net::QueueNetwork, s::SurfaceStation)
    any(x -> x.name == s.name, net.stations) &&
        throw(ArgumentError("duplicate station name $(s.name)"))
    push!(net.stations, s)
    return s
end

"""
    source!(net, name::Symbol; interarrival, mark=nothing)

Add an arrival stream called `name` to the network.

- `interarrival`: a law ([`Law`](@ref) or [`Opaque`](@ref)) for the time
  between arrivals. It may read parameters and the enabling time
  ([`Enab`](@ref)); it cannot read marks, because the next job does not
  exist yet.
- `mark`: an optional [`MarkLaw`](@ref). Each arriving job draws its marks
  at creation; the draws are recorded.

A source needs a [`route!`](@ref) saying where its arrivals go.
"""
function source!(
    net::QueueNetwork, name::Symbol; interarrival::AbstractLaw, mark::Union{MarkLaw,Nothing}=nothing
)
    return _addstation!(
        net,
        SurfaceStation(
            name,
            :source,
            FCFS(),
            0,
            0,
            :drop,
            FCFSUnblock(),
            interarrival,
            mark,
            nothing,
            nothing,
            Symbol[],
            0,
            nothing,
        ),
    )
end

"""
    station!(net, name::Symbol; service, discipline=FCFS(), servers=1,
             capacity=typemax(Int), overflow=:drop, unblock=FCFSUnblock(),
             patience=nothing, renege_to=nothing)

Add a service station called `name` to the network.

- `service`: the service-time law, required. It may read parameters, the
  job's marks, and the enabling time. Alone among laws it may also read
  live station occupancy through [`InService`](@ref)/[`InBuffer`](@ref)
  (check C5); such a law is re-evaluated whenever a watched count changes,
  with the job's accrued service effort carried over and `te` kept at the
  original enabling — the same segment convention
  [`ProcessorSharing`](@ref) uses.
- `discipline`: how the waiting line is kept and served — [`FCFS`](@ref)
  (the default), [`LCFS`](@ref), [`SIRO`](@ref), [`Priority`](@ref),
  [`ProcessorSharing`](@ref), or [`SRPT`](@ref).
- `servers`: the number of parallel servers. Under [`ProcessorSharing`](@ref)
  it is the shared capacity in the speed `min(1, servers/n)`, not a slot
  count.
- `capacity`: the size of the waiting room, counted apart from the servers.
  The default is unbounded.
- `overflow`: what happens to a job that finds the waiting room full.
  `:drop` discards it. `:block` holds the job in the upstream server that
  finished it — that server stays occupied — until room frees here. An
  arrival straight from a source is dropped even under `:block`, because a
  source has no server to hold it.
- `unblock`: which blocked upstream transfer is admitted when room frees;
  [`FCFSUnblock`](@ref) is the only policy so far.
- `patience` and `renege_to` come together. `patience` is a law for how
  long a job will wait before abandoning the line, and `renege_to` names
  the station the abandoning job goes to. Jobs in service do not renege.

A station needs a [`route!`](@ref) saying where finished jobs go.
"""
function station!(
    net::QueueNetwork,
    name::Symbol;
    discipline::Discipline=FCFS(),
    servers::Int=1,
    service::AbstractLaw,
    capacity::Int=typemax(Int),
    overflow::Symbol=:drop,
    unblock::UnblockPolicy=FCFSUnblock(),
    patience::Union{AbstractLaw,Nothing}=nothing,
    renege_to::Union{Symbol,Nothing}=nothing,
    batching::Union{Batching,Nothing}=nothing,
)
    (patience === nothing) == (renege_to === nothing) ||
        throw(ArgumentError("patience and renege_to come together"))
    return _addstation!(
        net,
        SurfaceStation(
            name,
            :station,
            discipline,
            servers,
            capacity,
            overflow,
            unblock,
            service,
            nothing,
            patience,
            renege_to,
            Symbol[],
            0,
            batching,
        ),
    )
end

"""
    sink!(net, name::Symbol)

Add an absorbing exit called `name` to the network. A job routed to a sink
leaves the system and is deleted from the state; its history stays visible
in the record. A sink cannot have a [`route!`](@ref).
"""
function sink!(net::QueueNetwork, name::Symbol)
    return _addstation!(
        net,
        SurfaceStation(
            name,
            :sink,
            FCFS(),
            0,
            0,
            :drop,
            FCFSUnblock(),
            nothing,
            nothing,
            nothing,
            nothing,
            Symbol[],
            0,
            nothing,
        ),
    )
end

# A fork is clock-free: depositing a job splits it into one sibling per
# branch, all sharing a group id. A join is clock-free synchronization: it
# stashes siblings and releases one merged job through its route! when all
# `parts` have arrived.
"""
    fork!(net, name::Symbol; branches)

Add a fork called `name` to the network. A job deposited at a fork splits
instantly into one sibling per branch; the siblings share a group id and
the parent job disappears. `branches` names at least two destination
stations. Forks take no time and hold no clock. A fork routes through its
branches, so it cannot have a [`route!`](@ref). Pair it with a
[`join!`](@ref) to synchronize the siblings again.
"""
function fork!(net::QueueNetwork, name::Symbol; branches)
    length(branches) >= 2 || throw(ArgumentError("a fork needs at least two branches"))
    return _addstation!(
        net,
        SurfaceStation(
            name,
            :fork,
            FCFS(),
            0,
            0,
            :drop,
            FCFSUnblock(),
            nothing,
            nothing,
            nothing,
            nothing,
            collect(Symbol, branches),
            0,
            nothing,
        ),
    )
end

"""
    join!(net, name::Symbol; parts::Int)

Add a join called `name` to the network. Siblings of the same fork group
are stashed as they arrive. When `parts` siblings have arrived, they merge
into one job, which leaves through the join's [`route!`](@ref). `parts`
must be at least 2 and usually equals the branch count of the matching
[`fork!`](@ref). Joins take no time and hold no clock; stashed siblings
still count as jobs in the system.
"""
function join!(net::QueueNetwork, name::Symbol; parts::Int)
    parts >= 2 || throw(ArgumentError("a join needs at least two parts"))
    return _addstation!(
        net,
        SurfaceStation(
            name,
            :join,
            FCFS(),
            0,
            0,
            :drop,
            FCFSUnblock(),
            nothing,
            nothing,
            nothing,
            nothing,
            Symbol[],
            parts,
            nothing,
        ),
    )
end

"""
    route!(net, origin::Symbol, kernel)

Declare where jobs leaving the station named `origin` go. `kernel` is one
of [`Always`](@ref), [`ByMark`](@ref), [`Probabilistic`](@ref), or
[`RoundRobin`](@ref). Every source, station, and join needs exactly one
route; sinks and forks take none. [`compile`](@ref) checks this.
"""
function route!(net::QueueNetwork, origin::Symbol, kernel::Kernel)
    net.routes[origin] = kernel
    return net
end

# ---------------------------------------------------------------------------
# Compilation: symbols become indices, the network becomes a value the
# interpreter, the checker, and the estimators all read.

struct CompiledKernel
    kind::Symbol              # :always | :bymark | :probabilistic | :roundrobin
    dests::Vector{Int32}
    expr::Union{ScalarExpr,Nothing}
    cutoffs::Vector{Float64}
    probs::Vector{Float64}
end

struct CompiledStation
    name::Symbol
    kind::Symbol
    discipline::Discipline
    servers::Int
    capacity::Int
    overflow::Symbol
    unblock::UnblockPolicy
    service::Union{AbstractLaw,Nothing}
    routing::Union{CompiledKernel,Nothing}
    mark::Union{MarkLaw,Nothing}
    patience::Union{AbstractLaw,Nothing}
    renege::Int32             # destination index; 0 when no patience law
    branches::Vector{Int32}   # forks only
    parts::Int                # joins only
    batching::Union{Batching,Nothing}   # stations only
end

"""
    QueueGSMP

The compiled model: a generalized semi-Markov process (GSMP) written as
plain data. Produced by [`compile`](@ref); consumed by the interpreter
([`simulate`](@ref)), the record fold ([`replay`](@ref)), and the gradient
estimators. Station references are integer indices. `names` maps a station
name to its index, and `params` maps a parameter name to its position in
the parameter vector `θ`.

`srv_readers` and `buf_readers` are the state-dependence map: `srv_readers[s]`
lists the stations whose service law reads [`InService`](@ref) of station
`s` (a [`ProcessorSharing`](@ref) station is an srv-reader of itself, since
every resident's speed reads the resident count), and `buf_readers[s]`
likewise for [`InBuffer`](@ref). [`fire_changes`](@ref) re-evaluates a
reader's surviving service clocks whenever a watched count changes.
"""
struct QueueGSMP
    stations::Vector{CompiledStation}
    names::Dict{Symbol,Int}
    params::Dict{Symbol,Int}
    srv_readers::Vector{Vector{Int}}
    buf_readers::Vector{Vector{Int}}
end

function _compilekernel(k::Always, names)
    return CompiledKernel(:always, Int32[names[k.dest]], nothing, Float64[], Float64[])
end
function _compilekernel(k::ByMark, names)
    length(k.dests) == length(k.cutoffs) + 1 ||
        throw(ArgumentError("ByMark needs one more destination than cutoffs"))
    return CompiledKernel(:bymark, Int32[names[d] for d in k.dests], k.expr, k.cutoffs, Float64[])
end
function _compilekernel(k::Probabilistic, names)
    isapprox(sum(k.probs), 1.0; atol=1e-9) ||
        throw(ArgumentError("Probabilistic routing probabilities must sum to 1"))
    return CompiledKernel(
        :probabilistic, Int32[names[d] for d in k.dests], nothing, Float64[], k.probs
    )
end
function _compilekernel(k::RoundRobin, names)
    return CompiledKernel(
        :roundrobin, Int32[names[d] for d in k.dests], nothing, Float64[], Float64[]
    )
end

"""
    compile(net::QueueNetwork) -> QueueGSMP

Freeze a network into a [`QueueGSMP`](@ref), the intermediate
representation the interpreter and the estimators read. Station names
become integer indices and parameter names become positions in `θ`.

`compile` also runs the static checks and throws `ArgumentError` at the
first violation:

- every route target and renege destination is a declared station;
- every source, station, and join has a route, and no sink or fork has one;
- deterministic kernels ([`ByMark`](@ref)) read marks only;
- every law reads only declared parameters and marks some source produces;
- no cycle of finite `:block` buffers exists, because a full cycle would
  deadlock;
- station occupancy ([`InService`](@ref)/[`InBuffer`](@ref)) is read only by
  the service law of a station, and every occupancy read names a declared
  station (check C5).
"""
function compile(net::QueueNetwork)
    names = Dict{Symbol,Int}(s.name => i for (i, s) in enumerate(net.stations))
    params = Dict{Symbol,Int}(p => i for (i, p) in enumerate(net.param_names))
    check_network(net, names, params)
    stations = CompiledStation[]
    for s in net.stations
        routing = s.kind in (:sink, :fork) ? nothing : _compilekernel(net.routes[s.name], names)
        renege = s.renege_to === nothing ? Int32(0) : Int32(names[s.renege_to])
        push!(
            stations,
            CompiledStation(
                s.name,
                s.kind,
                s.discipline,
                s.servers,
                s.capacity,
                s.overflow,
                s.unblock,
                s.service,
                routing,
                s.mark,
                s.patience,
                renege,
                Int32[names[b] for b in s.branches],
                s.parts,
                s.batching,
            ),
        )
    end
    # The state-dependence map: which stations' service laws watch each
    # station's counts. Processor sharing is the built-in state-dependent
    # law (speed min(1, servers/n) reads the own resident count), so a PS
    # station registers as an srv-reader of itself and its re-evaluations
    # ride the same general trigger as InService/InBuffer readers.
    n = length(stations)
    srv_readers = [Int[] for _ in 1:n]
    buf_readers = [Int[] for _ in 1:n]
    for (r, stn) in enumerate(stations)
        stn.kind == :station || continue
        svc = stn.service
        if svc !== nothing
            for w in _reads_srv(svc)
                push!(srv_readers[names[w]], r)
            end
            for w in _reads_buf(svc)
                push!(buf_readers[names[w]], r)
            end
        end
        stn.discipline.name == :ps && push!(srv_readers[r], r)
    end
    foreach(v -> unique!(sort!(v)), srv_readers)
    foreach(v -> unique!(sort!(v)), buf_readers)
    return QueueGSMP(stations, names, params, srv_readers, buf_readers)
end

# Check C1 (structure) and the parts of C2 (mark dataflow) and the randomness
# rules that need no traffic equations. Total functions of the value, per
# queue_layers.tex §3.7 — possible only because A3 made the laws inspectable.
function check_network(net::QueueNetwork, names, params)
    produced_marks = Set{Symbol}()
    for s in net.stations
        if s.kind == :fork
            haskey(net.routes, s.name) &&
                throw(ArgumentError("fork $(s.name) routes through its branches, not route!"))
            for b in s.branches
                haskey(names, b) ||
                    throw(ArgumentError("fork $(s.name) branches to unknown station $b"))
            end
        elseif s.kind != :sink
            haskey(net.routes, s.name) || throw(ArgumentError("station $(s.name) has no route!"))
            k = net.routes[s.name]
            for d in _kerneldests(k)
                haskey(names, d) ||
                    throw(ArgumentError("route from $(s.name) targets unknown station $d"))
            end
        else
            haskey(net.routes, s.name) && throw(ArgumentError("sink $(s.name) cannot have a route"))
        end
        s.mark !== nothing && union!(produced_marks, marknames(s.mark))
    end
    # Deterministic kernels must read marks only: a θ- or time-dependent
    # deterministic route would put an unrecorded factor into the likelihood.
    for (origin, k) in net.routes
        k isa ByMark || continue
        isempty(reads_params(k.expr)) && !reads_time(k.expr) ||
            throw(ArgumentError("routing kernel at $origin may read only marks"))
        isempty(reads_state(k.expr)) || throw(
            ArgumentError(
                "routing kernel at $origin reads station state; A4 reserves " *
                "likelihood-bearing decisions for recorded draws (check C5)",
            ),
        )
    end
    check_blocking_acyclic(net)
    check_state_reads(net, names)
    check_batching(net)
    # A batch station's synthetic batch job carries the mark `batchsize`, so
    # its service law alone may read that mark on top of what sources produce.
    batch_marks = union(produced_marks, (:batchsize,))
    for s in net.stations
        s.renege_to === nothing ||
            haskey(names, s.renege_to) ||
            throw(ArgumentError("renege_to at $(s.name) targets unknown station $(s.renege_to)"))
        service_marks = s.batching === nothing ? produced_marks : batch_marks
        for (law, allowed) in ((s.service, service_marks), (s.patience, produced_marks))
            law === nothing && continue
            for p in reads_params(law)
                haskey(params, p) ||
                    throw(ArgumentError("law at $(s.name) reads unknown parameter $p"))
            end
            # C2, conservatively: any read mark must be produced by some
            # source. The routing-graph dataflow refinement is future work.
            for mk in reads_marks(law)
                mk in allowed ||
                    throw(ArgumentError("law at $(s.name) reads mark $mk no source produces"))
            end
        end
    end
    return nothing
end

# Check C5: only the service law of a station may read station occupancy
# (InService/InBuffer). State in a mark law would enter the record's mark
# draws; state in an arrival, patience, routing, or ordering expression
# would either change the likelihood outside recorded draws (A4) or is a
# feature of its own. Every occupancy read must name a declared station —
# sources, sinks, forks, and joins hold no jobs to count.
function check_state_reads(net::QueueNetwork, names)
    kindof = Dict(s.name => s.kind for s in net.stations)
    for s in net.stations
        if s.mark !== nothing
            for (mk, law) in s.mark.laws
                isempty(reads_state(law)) || throw(
                    ArgumentError(
                        "mark law $mk at $(s.name) reads station state; state in a " *
                        "mark law would put station state into the record's mark " *
                        "draws, breaking replay — amendment A4 (check C5)",
                    ),
                )
            end
        end
        if s.kind == :source && s.service !== nothing
            isempty(reads_state(s.service)) || throw(
                ArgumentError(
                    "interarrival law at $(s.name) reads station state; " *
                    "state-dependent arrivals/balking is a separate feature, " *
                    "not supported (check C5)",
                ),
            )
        end
        if s.patience !== nothing
            isempty(reads_state(s.patience)) || throw(
                ArgumentError(
                    "patience law at $(s.name) reads station state; only the " *
                    "service law of a station may read occupancy (check C5)",
                ),
            )
        end
        if s.discipline.by !== nothing
            isempty(reads_state(s.discipline.by)) || throw(
                ArgumentError(
                    "discipline ordering key at $(s.name) reads station state; only " *
                    "the service law of a station may read occupancy (check C5)",
                ),
            )
        end
        if s.kind == :station && s.service !== nothing
            for w in reads_state(s.service)
                haskey(names, w) || throw(
                    ArgumentError(
                        "service law at $(s.name) reads occupancy of unknown " *
                        "station $w (check C5)",
                    ),
                )
                kindof[w] == :station || throw(
                    ArgumentError(
                        "service law at $(s.name) reads occupancy of $w, which is " *
                        "a $(kindof[w]), not a station — only stations have " *
                        "in-service and buffer counts (check C5)",
                    ),
                )
            end
        end
    end
    return nothing
end

# Check C6: batch formation gathers waiting jobs in discipline order without
# consuming draws, and a batch in service must never be preempted or
# reordered — guarantees only the non-preemptive :back-insert FCFS
# discipline gives in v1. Batching is a station!-only keyword, so no
# kind check is needed here.
function check_batching(net::QueueNetwork)
    for s in net.stations
        s.batching === nothing && continue
        if s.discipline.name != :fcfs
            throw(
                ArgumentError(
                    "station $(s.name) declares batching under the " *
                    "$(s.discipline.name) discipline; batching requires the " *
                    "non-preemptive :back-insert FCFS discipline (check C6)",
                ),
            )
        end
    end
    return nothing
end

_kerneldests(k::Always) = (k.dest,)
_kerneldests(k::ByMark) = Tuple(k.dests)
_kerneldests(k::Probabilistic) = Tuple(k.dests)
_kerneldests(k::RoundRobin) = Tuple(k.dests)

# Check C3: a cycle of stations that can transfer-block each other is a
# deadlock reachable when every buffer in the cycle fills, and it is also the
# precondition under which the settle cascade's termination argument (F6)
# holds — so it is an error, not a warning.
function check_blocking_acyclic(net::QueueNetwork)
    canblock(s) = s.kind == :station && s.overflow == :block && s.capacity != typemax(Int)
    byname = Dict(s.name => s for s in net.stations)
    edges = Dict{Symbol,Vector{Symbol}}()
    for (origin, k) in net.routes
        byname[origin].kind == :station || continue
        edges[origin] = [d for d in _kerneldests(k) if canblock(byname[d])]
    end
    seen = Dict{Symbol,Symbol}()   # :active during DFS, :done after
    function visit(v)
        get(seen, v, :new) == :done && return nothing
        seen[v] == :active && throw(
            ArgumentError(
                "blocking cycle through $v: a cycle of full " *
                ":block buffers is deadlock (check C3)",
            ),
        )
        seen[v] = :active
        for w in get(edges, v, Symbol[])
            haskey(seen, w) || (seen[w] = :new)
            visit(w)
        end
        return seen[v] = :done
    end
    for v in keys(edges)
        haskey(seen, v) || (seen[v] = :new)
        visit(v)
    end
    return nothing
end

"""
    stability(m, θ) -> Vector of (name, ρ) pairs

Check C4, advisory: solve the traffic equations for the statically-known
kernels and report per-station utilization ρ = λ E[S] / servers at `θ`,
warning at ρ ≥ 1. Mark-dependent routing, mark-reading service laws, and
state-reading service laws ([`InService`](@ref)/[`InBuffer`](@ref)) have no
static visit ratios or means, so those stations are skipped — the census
principle: report what the combinator values expose, silently invent nothing.
"""
function stability(m::QueueGSMP, θ::AbstractVector)
    n = length(m.stations)
    λ = zeros(n)
    for (s, stn) in enumerate(m.stations)
        stn.kind == :source || continue
        svc = stn.service
        svc === nothing && continue
        reads_marks(svc) == Set{Symbol}() || continue
        λ[s] = 1 / mean(builddist(svc, m.params, θ, NamedTuple(), 0.0, NOSTATE))
    end
    # Traffic equations λ = inj + Pᵀλ along :always and :probabilistic
    # kernels (ByMark/RoundRobin splits are statically unknown), by fixpoint
    # iteration: n passes reach every path of an acyclic network regardless
    # of declaration order.
    for _ in 1:n
        flow = zeros(n)
        for (s, stn) in enumerate(m.stations)
            if stn.kind == :fork
                for b in stn.branches
                    flow[b] += λ[s]
                end
                continue
            end
            stn.routing === nothing && continue
            rate = stn.kind == :join ? λ[s] / stn.parts : λ[s]
            k = stn.routing
            if k.kind == :always
                flow[k.dests[1]] += rate
            elseif k.kind == :probabilistic
                for (i, d) in enumerate(k.dests)
                    flow[d] += rate * k.probs[i]
                end
            end
        end
        for (s, stn) in enumerate(m.stations)
            stn.kind == :source || (λ[s] = flow[s])
        end
    end
    out = Tuple{Symbol,Float64}[]
    for (s, stn) in enumerate(m.stations)
        stn.kind == :station || continue
        svc = stn.service
        svc === nothing && continue
        reads_marks(svc) == Set{Symbol}() || continue
        # A state-reading law has no occupancy to read here; skip, do not
        # invent one (its NOSTATE evaluation would throw).
        isempty(reads_state(svc)) || continue
        ρ = λ[s] * mean(builddist(svc, m.params, θ, NamedTuple(), 0.0, NOSTATE)) / stn.servers
        push!(out, (stn.name, ρ))
        ρ >= 1 && @warn "station $(stn.name) is unstable at this θ" ρ
    end
    return out
end
