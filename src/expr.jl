# Amendment A3: laws and their parameters are inspectable values, not
# closures, so that the checker can derive what each law reads (θ-dependence
# for the randomness census, mark names for the dataflow check) instead of
# trusting the model author.

abstract type ScalarExpr end

struct Param <: ScalarExpr
    name::Symbol
end

struct Mark <: ScalarExpr
    name::Symbol
end

# The wall-clock enabling time of the clock whose law is being built. This is
# the only time a law may read: laws are frozen at enabling, per the GSMP
# construction, so "current time" has no meaning inside one.
struct Enab <: ScalarExpr end

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

const _OPS = Dict{Symbol,Function}(
    :+ => +, :- => -, :* => *, :/ => /,
    :inv => inv, :log => log, :exp => exp, :sqrt => sqrt,
    :min => min, :max => max,
)

# `params` maps a Param name to its index in the θ vector; built at compile
# time so evaluation never searches. The return type follows eltype(θ) so a
# Dual-valued θ flows through untouched (the ClockGradients seam).
function evalexpr(e::Param, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te)
    θ[params[e.name]]
end
evalexpr(e::Mark, params, θ, marks::NamedTuple, te) = getfield(marks, e.name)
evalexpr(::Enab, params, θ, marks, te) = te
evalexpr(e::Const, params, θ, marks, te) = e.value
function evalexpr(e::Apply, params, θ, marks, te)
    f = _OPS[e.op]
    if length(e.args) == 1
        f(evalexpr(e.args[1], params, θ, marks, te))
    else
        f(evalexpr(e.args[1], params, θ, marks, te),
          evalexpr(e.args[2], params, θ, marks, te))
    end
end

reads_params(e::Param) = Set{Symbol}([e.name])
reads_params(e::Apply) = union(Set{Symbol}(), (reads_params(a) for a in e.args)...)
reads_params(::ScalarExpr) = Set{Symbol}()
reads_marks(e::Mark) = Set{Symbol}([e.name])
reads_marks(e::Apply) = union(Set{Symbol}(), (reads_marks(a) for a in e.args)...)
reads_marks(::ScalarExpr) = Set{Symbol}()
reads_time(::Enab) = true
reads_time(e::Apply) = any(reads_time(a) for a in e.args)
reads_time(::ScalarExpr) = false

abstract type AbstractLaw end

# `family` is the Distributions.jl type name; `args` keeps the written order,
# which is the constructor's positional order.
struct Law <: AbstractLaw
    family::Symbol
    args::Vector{Pair{Symbol,ScalarExpr}}
end

function Law(family::Symbol; kwargs...)
    Law(family, Pair{Symbol,ScalarExpr}[k => asexpr(v) for (k, v) in kwargs])
end

# The A3 escape hatch: an arbitrary function (θnamed, marks, te) -> dist, made
# legal only by declaring what it reads. The checker trusts the declaration
# and marks its conclusions unverified.
struct Opaque <: AbstractLaw
    f::Function
    params::Vector{Symbol}
    marks::Vector{Symbol}
    time::Bool
end

function Opaque(f::Function; params=Symbol[], marks=Symbol[], time=false)
    Opaque(f, collect(Symbol, params), collect(Symbol, marks), time)
end

function builddist(law::Law, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te)
    ctor = getfield(Distributions, law.family)
    vals = (evalexpr(a.second, params, θ, marks, te) for a in law.args)
    ctor(vals...)
end

function builddist(law::Opaque, params::Dict{Symbol,Int}, θ, marks::NamedTuple, te)
    named = NamedTuple{Tuple(law.params)}(Tuple(θ[params[p]] for p in law.params))
    law.f(named, marks, te)
end

reads_params(l::Law) = union(Set{Symbol}(), (reads_params(a.second) for a in l.args)...)
reads_marks(l::Law) = union(Set{Symbol}(), (reads_marks(a.second) for a in l.args)...)
reads_time(l::Law) = any(reads_time(a.second) for a in l.args)
reads_params(l::Opaque) = Set(l.params)
reads_marks(l::Opaque) = Set(l.marks)
reads_time(l::Opaque) = l.time
isopaque(::Law) = false
isopaque(::Opaque) = true

# A mark sampler is a named collection of laws, one per mark, drawn at job
# creation through the A4 draw source and recorded.
struct MarkLaw
    laws::Vector{Pair{Symbol,AbstractLaw}}
end
MarkLaw(; kwargs...) = MarkLaw(Pair{Symbol,AbstractLaw}[k => v for (k, v) in kwargs])
marknames(m::MarkLaw) = Symbol[p.first for p in m.laws]
