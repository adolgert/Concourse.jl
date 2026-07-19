# Amendment A3: laws and their parameters are inspectable values, not
# closures, so that the checker can derive what each law reads (θ-dependence
# for the randomness census, mark names for the dataflow check) instead of
# trusting the model author.

"""
    ScalarExpr

Abstract supertype of the expression algebra that law arguments are written
in. A `ScalarExpr` is a value, not a closure, so the compile-time checker can
see what an expression reads: parameters ([`reads_params`](@ref)), marks
([`reads_marks`](@ref)), and time ([`reads_time`](@ref)).

The leaves are [`Param`](@ref), [`Mark`](@ref), [`Enab`](@ref), and
[`Const`](@ref). Expressions combine with `+`, `-`, `*`, `/`, `inv`, `log`,
`exp`, `sqrt`, `min`, and `max`. A bare number in arithmetic with an
expression is promoted to a `Const`.

# Example

```jldoctest
julia> rate = Param(:lambda) * 2;

julia> reads_params(rate)
Set{Symbol} with 1 element:
  :lambda
```
"""
abstract type ScalarExpr end

"""
    Param(name::Symbol)

The model parameter called `name`. Evaluation reads the entry of the
parameter vector `θ` at the position [`compile`](@ref) assigned to `name`
from the network's `param_names`. A law must reach `θ` through `Param`;
that is how the checker and the gradient estimators know which clocks
depend on which parameters.
"""
struct Param <: ScalarExpr
    name::Symbol
end

"""
    Mark(name::Symbol)

The mark called `name` on the job the law applies to. Marks are per-job
values drawn once at job creation (see [`MarkLaw`](@ref)). A service law
that reads `Mark(:size)` gives each job its own service distribution.
"""
struct Mark <: ScalarExpr
    name::Symbol
end

"""
    Enab()

The wall-clock time at which the clock being built was enabled. This is the
only time a law may read. In a generalized semi-Markov process (GSMP) a
clock's distribution is frozen at its enabling, so "current time" has no
meaning inside a law. Use `Enab` for time-varying rates, for example a
nonhomogeneous arrival process:

```julia
Law(:Exponential,
    scale = inv(Param(:lambda) * (Const(1.0) + Const(0.5) * exp(Const(-0.02) * Enab()))))
```
"""
struct Enab <: ScalarExpr end

"""
    Const(value)

A literal number as a [`ScalarExpr`](@ref). Bare numbers in arithmetic with
expressions are promoted to `Const` automatically, so `Param(:mu) * 2` and
`Param(:mu) * Const(2.0)` are the same expression.
"""
struct Const <: ScalarExpr
    value::Float64
end

struct Apply <: ScalarExpr
    op::Symbol
    args::Vector{ScalarExpr}
end

asexpr(e::ScalarExpr) = e
asexpr(x::Real) = Const(Float64(x))

for op in (:+, :-, :*, :/)
    @eval Base.$op(a::ScalarExpr, b::ScalarExpr) = Apply(Symbol($op), ScalarExpr[a, b])
    @eval Base.$op(a::ScalarExpr, b::Real) = Apply(Symbol($op), ScalarExpr[a, asexpr(b)])
    @eval Base.$op(a::Real, b::ScalarExpr) = Apply(Symbol($op), ScalarExpr[asexpr(a), b])
end
for op in (:inv, :log, :exp, :sqrt, :-)
    @eval Base.$op(a::ScalarExpr) = Apply(Symbol($op), ScalarExpr[a])
end
Base.min(a::ScalarExpr, b::ScalarExpr) = Apply(:min, ScalarExpr[a, b])
Base.max(a::ScalarExpr, b::ScalarExpr) = Apply(:max, ScalarExpr[a, b])

"""
    AbstractStateView

What a law is allowed to see of the queue state at evaluation time. Laws
never receive the full `QueueState`; they receive a view, so the signature
of `evalexpr` and `builddist` documents exactly what a law may read. The concrete views are [`StateView`](@ref), which exposes
per-station occupancy counts, and [`NoState`](@ref), the sentinel for
evaluation contexts where reading state is not permitted.
"""
abstract type AbstractStateView end

"""
    StateView(srv, buf, index)

A read-only view of station occupancies: `srv` and `buf` are the
per-station in-service and in-buffer job vectors (borrowed from the live
`QueueState`, not copied), and `index` maps a station name to its station
id. Laws reach it only through [`inservice_count`](@ref) and
[`inbuffer_count`](@ref), so a law can count jobs but cannot identify or
mutate them.
"""
struct StateView{T<:AbstractVector} <: AbstractStateView
    srv::Vector{T}
    buf::Vector{T}
    index::Dict{Symbol,Int}
end

"""
    NoState()

The sentinel state view for evaluation contexts where a law may not read
station state (mark draws, routing expressions, static stability checks).
Its accessors throw, so a state-reading law used in a state-blind context
fails loudly instead of reading stale or meaningless occupancies. The
shared singleton is `NOSTATE`.
"""
struct NoState <: AbstractStateView end

const NOSTATE = NoState()

"""
    inservice_count(sv::AbstractStateView, station::Symbol) -> Float64

The number of jobs in service at `station` under the view `sv`. Throws for
[`NoState`](@ref).
"""
inservice_count(sv::StateView, station::Symbol) = Float64(length(sv.srv[_station_id(sv, station)]))

"""
    inbuffer_count(sv::AbstractStateView, station::Symbol) -> Float64

The number of jobs waiting in the buffer at `station` under the view `sv`.
Throws for [`NoState`](@ref).
"""
inbuffer_count(sv::StateView, station::Symbol) = Float64(length(sv.buf[_station_id(sv, station)]))

function _station_id(sv::StateView, station::Symbol)
    id = get(sv.index, station, 0)
    id == 0 && error("no station named $station in the state view")
    return id
end

function inservice_count(::NoState, station::Symbol)
    return error("this law may not read station state (evaluated without a state view)")
end
function inbuffer_count(::NoState, station::Symbol)
    return error("this law may not read station state (evaluated without a state view)")
end

const _OPS = Dict{Symbol,Function}(
    :+ => +,
    :- => -,
    :* => *,
    :/ => /,
    :inv => inv,
    :log => log,
    :exp => exp,
    :sqrt => sqrt,
    :min => min,
    :max => max,
)

# `params` maps a Param name to its index in the θ vector; built at compile
# time so evaluation never searches. The return type follows eltype(θ) so a
# Dual-valued θ flows through untouched (the ClockGradients seam). `sv` is
# the state view the law may read (NOSTATE where reading state is illegal).
function evalexpr(
    e::Param, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te, sv::AbstractStateView
)
    return θ[params[e.name]]
end
evalexpr(e::Mark, params, θ, marks::NamedTuple, te, sv::AbstractStateView) = getfield(marks, e.name)
evalexpr(::Enab, params, θ, marks, te, sv::AbstractStateView) = te
evalexpr(e::Const, params, θ, marks, te, sv::AbstractStateView) = e.value
function evalexpr(e::Apply, params, θ, marks, te, sv::AbstractStateView)
    f = _OPS[e.op]
    if length(e.args) == 1
        f(evalexpr(e.args[1], params, θ, marks, te, sv))
    else
        f(
            evalexpr(e.args[1], params, θ, marks, te, sv),
            evalexpr(e.args[2], params, θ, marks, te, sv),
        )
    end
end

"""
    reads_params(x) -> Set{Symbol}

The parameter names that a [`ScalarExpr`](@ref) or a law reads through
[`Param`](@ref). For an [`Opaque`](@ref) law it returns the declared names.
[`compile`](@ref) checks every name against the network's `param_names`.

# Example

```jldoctest
julia> reads_params(Law(:Exponential, scale = inv(Param(:mu))))
Set{Symbol} with 1 element:
  :mu
```
"""
reads_params(e::Param) = Set{Symbol}([e.name])
reads_params(e::Apply) = union(Set{Symbol}(), (reads_params(a) for a in e.args)...)
reads_params(::ScalarExpr) = Set{Symbol}()

"""
    reads_marks(x) -> Set{Symbol}

The mark names that a [`ScalarExpr`](@ref) or a law reads through
[`Mark`](@ref). For an [`Opaque`](@ref) law it returns the declared names.
[`compile`](@ref) checks that every read mark is produced by some source.

# Example

```jldoctest
julia> reads_marks(Mark(:size) - Const(1.0))
Set{Symbol} with 1 element:
  :size
```
"""
reads_marks(e::Mark) = Set{Symbol}([e.name])
reads_marks(e::Apply) = union(Set{Symbol}(), (reads_marks(a) for a in e.args)...)
reads_marks(::ScalarExpr) = Set{Symbol}()

"""
    reads_time(x) -> Bool

Whether a [`ScalarExpr`](@ref) or a law reads the enabling time through
[`Enab`](@ref). For an [`Opaque`](@ref) law it returns the declared `time`
flag.

# Example

```jldoctest
julia> reads_time(exp(Const(-0.02) * Enab()))
true

julia> reads_time(Param(:mu))
false
```
"""
reads_time(::Enab) = true
reads_time(e::Apply) = any(reads_time(a) for a in e.args)
reads_time(::ScalarExpr) = false

abstract type AbstractLaw end

"""
    Law(family::Symbol; kwargs...)

A probability distribution written as data. `family` names a
Distributions.jl type, and each keyword argument is one constructor
argument, given as a [`ScalarExpr`](@ref) or a number. The keyword names
are labels for the reader; the values are passed to the constructor
positionally, in the order written. So write them in the constructor's
positional order.

Because a `Law` is inspectable data, [`reads_params`](@ref),
[`reads_marks`](@ref), and [`reads_time`](@ref) report exactly what it
depends on, and [`compile`](@ref) can check the model statically.

# Examples

```julia
Law(:Exponential, scale = inv(Param(:mu)))            # Exponential with mean 1/μ
Law(:Gamma, shape = Const(2.0), scale = Const(0.5) * inv(Param(:mu)))
Law(:Dirac, value = Mark(:size))                      # deterministic, per job
```
"""
struct Law <: AbstractLaw
    family::Symbol
    args::Vector{Pair{Symbol,ScalarExpr}}
end

function Law(family::Symbol; kwargs...)
    return Law(family, Pair{Symbol,ScalarExpr}[k => asexpr(v) for (k, v) in kwargs])
end

"""
    Opaque(f; params=Symbol[], marks=Symbol[], time=false)

The escape hatch for laws the expression algebra cannot write: an arbitrary
function made legal by declaring what it reads. `f` has the signature
`(θnamed, marks, te) -> distribution`, where `θnamed` is a `NamedTuple` of
the declared `params`, `marks` is the job's mark `NamedTuple`, and `te` is
the enabling time. The declarations `params`, `marks`, and `time` tell the
checker what `f` reads; the checker trusts them, so its conclusions about
an `Opaque` law are unverified.

# Example

```julia
Opaque((θ, marks, te) -> Exponential(1 / (θ.mu * marks.weight));
       params = [:mu], marks = [:weight])
```
"""
struct Opaque <: AbstractLaw
    f::Function
    params::Vector{Symbol}
    marks::Vector{Symbol}
    time::Bool
end

function Opaque(f::Function; params=Symbol[], marks=Symbol[], time=false)
    return Opaque(f, collect(Symbol, params), collect(Symbol, marks), time)
end

function builddist(
    law::Law, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te, sv::AbstractStateView
)
    ctor = getfield(Distributions, law.family)
    vals = (evalexpr(a.second, params, θ, marks, te, sv) for a in law.args)
    return ctor(vals...)
end

# Opaque stays state-blind: the user callback keeps the (θnamed, marks, te)
# signature, so `sv` stops here.
function builddist(
    law::Opaque, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te, sv::AbstractStateView
)
    named = NamedTuple{Tuple(law.params)}(Tuple(θ[params[p]] for p in law.params))
    return law.f(named, marks, te)
end

reads_params(l::Law) = union(Set{Symbol}(), (reads_params(a.second) for a in l.args)...)
reads_marks(l::Law) = union(Set{Symbol}(), (reads_marks(a.second) for a in l.args)...)
reads_time(l::Law) = any(reads_time(a.second) for a in l.args)
reads_params(l::Opaque) = Set(l.params)
reads_marks(l::Opaque) = Set(l.marks)
reads_time(l::Opaque) = l.time
isopaque(::Law) = false
isopaque(::Opaque) = true

"""
    MarkLaw(; name = law, ...)

A named collection of laws, one per mark. Marks are drawn once at job
creation, in the written order, and recorded, so replay reproduces them. A
later law in the list may read an earlier mark of the same job. Attach a
`MarkLaw` to a source with the `mark` keyword of [`source!`](@ref).

# Example

```julia
MarkLaw(size = Law(:Exponential, scale = Const(1.0)),
        class = Law(:Uniform, a = Const(0.0), b = Const(2.0)))
```
"""
struct MarkLaw
    laws::Vector{Pair{Symbol,AbstractLaw}}
end
MarkLaw(; kwargs...) = MarkLaw(Pair{Symbol,AbstractLaw}[k => v for (k, v) in kwargs])
marknames(m::MarkLaw) = Symbol[p.first for p in m.laws]
