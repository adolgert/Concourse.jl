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

FCFS() = Discipline(:fcfs, :back, nothing, :front, false, :fresh)
# Preemptive LCFS needs an eviction rule keyed on arrival order, which the
# ordering-expression machinery does not express yet; this is the
# non-preemptive variant.
LCFS() = Discipline(:lcfs, :front, nothing, :front, false, :fresh)
SIRO() = Discipline(:siro, :back, nothing, :random, false, :fresh)
function Priority(by::ScalarExpr; preempt::Bool=false, memory::Symbol=:resume)
    Discipline(:priority, :ordered, by, :front, preempt, memory)
end
# Every resident job is in service at speed min(1, servers/n); the buffer is
# a zero-length staging area the settle pass immediately drains. :rescale
# memory keeps te at the original enabling and re-expresses speed changes as
# mid-flight re-evaluations, the ClockGradients segment convention — NOT the
# anchor-at-now compilation of queue_layers.tex §3.5 (see event_loop.tex).
ProcessorSharing() = Discipline(:ps, :back, nothing, :front, false, :rescale)

abstract type Kernel end

struct Always <: Kernel
    dest::Symbol
end

# SITA-style deterministic split: route by where the mark expression falls
# among the cutoffs. dests has one more entry than cutoffs.
struct ByMark <: Kernel
    expr::ScalarExpr
    cutoffs::Vector{Float64}
    dests::Vector{Symbol}
end

struct Probabilistic <: Kernel
    dests::Vector{Symbol}
    probs::Vector{Float64}
end
Probabilistic(pairs::Pair{Symbol,<:Real}...) =
    Probabilistic(Symbol[p.first for p in pairs], Float64[p.second for p in pairs])

struct RoundRobin <: Kernel
    dests::Vector{Symbol}
end

# D2: who among the blocked upstream servers gets a freed buffer slot is
# observable model semantics, declared per station, not an interpreter rule.
abstract type UnblockPolicy end
struct FCFSUnblock <: UnblockPolicy end

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
end

mutable struct QueueNetwork
    param_names::Vector{Symbol}
    stations::Vector{SurfaceStation}
    routes::Dict{Symbol,Kernel}
end
QueueNetwork(; param_names) = QueueNetwork(collect(Symbol, param_names),
                                           SurfaceStation[], Dict{Symbol,Kernel}())

function _addstation!(net::QueueNetwork, s::SurfaceStation)
    any(x -> x.name == s.name, net.stations) &&
        throw(ArgumentError("duplicate station name $(s.name)"))
    push!(net.stations, s)
    s
end

function source!(net::QueueNetwork, name::Symbol;
                 interarrival::AbstractLaw, mark::Union{MarkLaw,Nothing}=nothing)
    _addstation!(net, SurfaceStation(name, :source, FCFS(), 0, 0, :drop,
                                     FCFSUnblock(), interarrival, mark,
                                     nothing, nothing))
end

function station!(net::QueueNetwork, name::Symbol;
                  discipline::Discipline=FCFS(), servers::Int=1,
                  service::AbstractLaw, capacity::Int=typemax(Int),
                  overflow::Symbol=:drop, unblock::UnblockPolicy=FCFSUnblock(),
                  patience::Union{AbstractLaw,Nothing}=nothing,
                  renege_to::Union{Symbol,Nothing}=nothing)
    (patience === nothing) == (renege_to === nothing) ||
        throw(ArgumentError("patience and renege_to come together"))
    _addstation!(net, SurfaceStation(name, :station, discipline, servers,
                                     capacity, overflow, unblock, service,
                                     nothing, patience, renege_to))
end

function sink!(net::QueueNetwork, name::Symbol)
    _addstation!(net, SurfaceStation(name, :sink, FCFS(), 0, 0, :drop,
                                     FCFSUnblock(), nothing, nothing,
                                     nothing, nothing))
end

function route!(net::QueueNetwork, origin::Symbol, kernel::Kernel)
    net.routes[origin] = kernel
    net
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
end

struct QueueGSMP
    stations::Vector{CompiledStation}
    names::Dict{Symbol,Int}
    params::Dict{Symbol,Int}
end

function _compilekernel(k::Always, names)
    CompiledKernel(:always, Int32[names[k.dest]], nothing, Float64[], Float64[])
end
function _compilekernel(k::ByMark, names)
    length(k.dests) == length(k.cutoffs) + 1 ||
        throw(ArgumentError("ByMark needs one more destination than cutoffs"))
    CompiledKernel(:bymark, Int32[names[d] for d in k.dests], k.expr,
                   k.cutoffs, Float64[])
end
function _compilekernel(k::Probabilistic, names)
    isapprox(sum(k.probs), 1.0; atol=1e-9) ||
        throw(ArgumentError("Probabilistic routing probabilities must sum to 1"))
    CompiledKernel(:probabilistic, Int32[names[d] for d in k.dests], nothing,
                   Float64[], k.probs)
end
function _compilekernel(k::RoundRobin, names)
    CompiledKernel(:roundrobin, Int32[names[d] for d in k.dests], nothing,
                   Float64[], Float64[])
end

function compile(net::QueueNetwork)
    names = Dict{Symbol,Int}(s.name => i for (i, s) in enumerate(net.stations))
    params = Dict{Symbol,Int}(p => i for (i, p) in enumerate(net.param_names))
    check_network(net, names, params)
    stations = CompiledStation[]
    for s in net.stations
        routing = s.kind == :sink ? nothing : _compilekernel(net.routes[s.name], names)
        renege = s.renege_to === nothing ? Int32(0) : Int32(names[s.renege_to])
        push!(stations, CompiledStation(s.name, s.kind, s.discipline, s.servers,
                                        s.capacity, s.overflow, s.unblock,
                                        s.service, routing, s.mark,
                                        s.patience, renege))
    end
    QueueGSMP(stations, names, params)
end

# Check C1 (structure) and the parts of C2 (mark dataflow) and the randomness
# rules that need no traffic equations. Total functions of the value, per
# queue_layers.tex §3.7 — possible only because A3 made the laws inspectable.
function check_network(net::QueueNetwork, names, params)
    produced_marks = Set{Symbol}()
    for s in net.stations
        if s.kind != :sink
            haskey(net.routes, s.name) ||
                throw(ArgumentError("station $(s.name) has no route!"))
            k = net.routes[s.name]
            for d in _kerneldests(k)
                haskey(names, d) ||
                    throw(ArgumentError("route from $(s.name) targets unknown station $d"))
            end
        else
            haskey(net.routes, s.name) &&
                throw(ArgumentError("sink $(s.name) cannot have a route"))
        end
        s.mark !== nothing && union!(produced_marks, marknames(s.mark))
    end
    # Deterministic kernels must read marks only: a θ- or time-dependent
    # deterministic route would put an unrecorded factor into the likelihood.
    for (origin, k) in net.routes
        k isa ByMark || continue
        isempty(reads_params(k.expr)) && !reads_time(k.expr) ||
            throw(ArgumentError("routing kernel at $origin may read only marks"))
    end
    check_blocking_acyclic(net)
    for s in net.stations
        s.renege_to === nothing || haskey(names, s.renege_to) ||
            throw(ArgumentError("renege_to at $(s.name) targets unknown station $(s.renege_to)"))
        laws = AbstractLaw[]
        s.service === nothing || push!(laws, s.service)
        s.patience === nothing || push!(laws, s.patience)
        for law in laws
            for p in reads_params(law)
                haskey(params, p) ||
                    throw(ArgumentError("law at $(s.name) reads unknown parameter $p"))
            end
            # C2, conservatively: any read mark must be produced by some
            # source. The routing-graph dataflow refinement is future work.
            for mk in reads_marks(law)
                mk in produced_marks ||
                    throw(ArgumentError("law at $(s.name) reads mark $mk no source produces"))
            end
        end
    end
    nothing
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
    canblock(s) = s.kind == :station && s.overflow == :block &&
                  s.capacity != typemax(Int)
    byname = Dict(s.name => s for s in net.stations)
    edges = Dict{Symbol,Vector{Symbol}}()
    for (origin, k) in net.routes
        byname[origin].kind == :station || continue
        edges[origin] = [d for d in _kerneldests(k) if canblock(byname[d])]
    end
    seen = Dict{Symbol,Symbol}()   # :active during DFS, :done after
    function visit(v)
        get(seen, v, :new) == :done && return
        seen[v] == :active &&
            throw(ArgumentError("blocking cycle through $v: a cycle of full " *
                                ":block buffers is deadlock (check C3)"))
        seen[v] = :active
        for w in get(edges, v, Symbol[])
            haskey(seen, w) || (seen[w] = :new)
            visit(w)
        end
        seen[v] = :done
    end
    for v in keys(edges)
        haskey(seen, v) || (seen[v] = :new)
        visit(v)
    end
    nothing
end

"""
    stability(m, θ) -> Vector of (name, ρ) pairs

Check C4, advisory: solve the traffic equations for the statically-known
kernels and report per-station utilization ρ = λ E[S] / servers at `θ`,
warning at ρ ≥ 1. Mark-dependent routing and mark-reading service laws have
no static visit ratios or means, so those stations are skipped — the census
principle: report what the combinator values expose, silently invent nothing.
"""
function stability(m::QueueGSMP, θ::AbstractVector)
    n = length(m.stations)
    λ = zeros(n)
    for (s, stn) in enumerate(m.stations)
        stn.kind == :source || continue
        reads_marks(stn.service) == Set{Symbol}() || continue
        λ[s] = 1 / mean(builddist(stn.service, m.params, θ, NamedTuple(), 0.0))
    end
    # Traffic equations λ = inj + Pᵀλ along :always and :probabilistic
    # kernels (ByMark/RoundRobin splits are statically unknown), by fixpoint
    # iteration: n passes reach every path of an acyclic network regardless
    # of declaration order.
    for _ in 1:n
        flow = zeros(n)
        for (s, stn) in enumerate(m.stations)
            stn.routing === nothing && continue
            k = stn.routing
            if k.kind == :always
                flow[k.dests[1]] += λ[s]
            elseif k.kind == :probabilistic
                for (i, d) in enumerate(k.dests)
                    flow[d] += λ[s] * k.probs[i]
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
        reads_marks(stn.service) == Set{Symbol}() || continue
        ρ = λ[s] * mean(builddist(stn.service, m.params, θ, NamedTuple(), 0.0)) /
            stn.servers
        push!(out, (stn.name, ρ))
        ρ >= 1 && @warn "station $(stn.name) is unstable at this θ" ρ
    end
    out
end
