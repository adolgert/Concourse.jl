"""
QueueDiagrams — a small vocabulary of queue-diagram drawing functions for the
Concourse.jl documentation, built on Luxor.jl.

Every documentation figure is composed from these functions inside a Luxor
`@drawsvg` block, so restyling this module restyles every figure. Math labels
(λ, μ, subscripts) are `LaTeXString`s rendered by MathTeXEngine.jl — pure
Julia, no LaTeX toolchain required.

The vocabulary:

- [`job`](@ref) — a job token, colored by class
- [`buffer`](@ref) — a waiting line with slat marks
- [`server`](@ref) — a single-server circle
- [`sharedserver`](@ref) — a processor-sharing / delay station circle
- [`flow`](@ref) — a labeled arrow
- [`discipline`](@ref) — a discipline tag under a buffer
- [`feedback`](@ref) — a curved return arc between stations
"""
module QueueDiagrams

using Luxor
using LaTeXStrings
using MathTeXEngine  # loads Luxor's LaTeXString text extension

export job, buffer, server, sharedserver, flow, discipline, feedback
export INK, CLASS_COLORS

# ---- style ----------------------------------------------------------------
const INK = "black"
const CLASS_COLORS = ["#3b6bb5", "#c4552d", "#3f8f4e", "#8455b0"]  # job classes
const LW = 1.6

# Draw a text label that may be a plain String or a LaTeXString.
function _label(s, pt::Point; size=13, halign=:center)
    sethue(INK)
    if s isa LaTeXString
        fontsize(size + 2)
        text(s, pt, halign = halign, valign = :middle)
    else
        fontsize(size)
        text(s, pt, halign = halign)
    end
end

"""
    job(pt, r; class=0)

A job token: filled circle of radius `r` at `pt`, colored by `class`
(an index into `CLASS_COLORS`; class 0 draws gray).
"""
function job(pt::Point, r::Real; class::Int=0)
    class == 0 ? sethue("gray55") : sethue(CLASS_COLORS[class])
    circle(pt, r, action = :fill)
    sethue(INK)
    setline(0.8)
    circle(pt, r, action = :stroke)
end

"""
    buffer(center, w, h; slots=4, jobs=Int[])

An open-ended waiting line: top, bottom, and right walls, open on the left
(the arrival side), with `slots` vertical slat marks. `jobs` is a vector of
class ids drawn right-to-left, so the head of the line sits nearest the
server. Returns `(entry, exit)` connection points.
"""
function buffer(center::Point, w::Real, h::Real; slots::Int=4, jobs::Vector{Int}=Int[])
    sethue(INK); setline(LW)
    left, right = center.x - w/2, center.x + w/2
    top, bot = center.y - h/2, center.y + h/2
    poly([Point(left, top), Point(right, top), Point(right, bot), Point(left, bot)],
         action = :stroke, close = false)
    # slats
    setline(0.9)
    pitch = w / (slots + 1)
    for i in 1:slots
        x = right - i * pitch
        line(Point(x, top), Point(x, bot), action = :stroke)
    end
    # waiting jobs, right-to-left (head of queue nearest the server)
    r = h * 0.30
    for (i, c) in enumerate(jobs)
        job(Point(right - (i - 0.5) * pitch, center.y), r; class = c)
    end
    return (entry = Point(left, center.y), exit = Point(right, center.y))
end

"""
    server(center, r; inservice=-1, label="")

A single server: a circle of radius `r`. `inservice ≥ 0` draws a job of that
class inside; `label` (String or LaTeXString) is drawn below. Returns
`(entry, exit)` connection points.
"""
function server(center::Point, r::Real; inservice::Int=-1, label="")
    sethue("white"); circle(center, r, action = :fill)
    sethue(INK); setline(LW)
    circle(center, r, action = :stroke)
    inservice >= 0 && job(center, r * 0.45; class = inservice)
    label != "" && _label(label, Point(center.x, center.y + r + 16))
    return (entry = Point(center.x - r, center.y), exit = Point(center.x + r, center.y))
end

"""
    sharedserver(center, r; jobs=Int[], label="")

A processor-sharing or delay (infinite-server) station: one large circle with
the resident `jobs` (class ids) arranged inside. Returns `(entry, exit)`
connection points.
"""
function sharedserver(center::Point, r::Real; jobs::Vector{Int}=Int[], label="")
    sethue("white"); circle(center, r, action = :fill)
    sethue(INK); setline(LW)
    circle(center, r, action = :stroke)
    n = length(jobs)
    for (i, c) in enumerate(jobs)
        θ = 2π * (i - 1) / max(n, 1) - π/2
        p = n == 1 ? center : center + r * 0.52 * Point(cos(θ), sin(θ))
        job(p, r * 0.22; class = c)
    end
    label != "" && _label(label, Point(center.x, center.y + r + 16))
    return (entry = Point(center.x - r, center.y), exit = Point(center.x + r, center.y))
end

"""
    flow(from, to; label="")

A flow arrow from `from` to `to`. `label` (String or LaTeXString) is drawn
above the midpoint.
"""
function flow(from::Point, to::Point; label="")
    sethue(INK); setline(LW)
    arrow(from, to, arrowheadlength = 10, arrowheadangle = π/8)
    label != "" && _label(label, midpoint(from, to) - Point(0, 10); size = 15)
end

"""
    discipline(center, w, h, name)

A discipline tag (e.g. "FCFS", "SRPT") under a buffer drawn at `center` with
size `(w, h)`.
"""
function discipline(center::Point, w::Real, h::Real, name::String)
    fontsize(13)
    sethue(INK)
    text(name, Point(center.x, center.y + h/2 + 16), halign = :center)
end

"""
    feedback(from, to; drop=70, label="")

A curved return arc from `from` down through a control depth `drop` and back
up to `to`, ending in an arrowhead — the standard way to draw a feedback loop
under a network. `label` is drawn near the bottom of the arc.
"""
function feedback(from::Point, to::Point; drop::Real=70, label="")
    sethue(INK); setline(LW)
    ybot = max(from.y, to.y) + drop
    move(from)
    curve(Point(from.x, ybot), Point(to.x - 40, ybot), Point(to.x, to.y + 25))
    strokepath()
    arrow(Point(to.x, to.y + 25), to, arrowheadlength = 10, arrowheadangle = π/8)
    label != "" && _label(label, Point(midpoint(from, to).x, ybot - 8); size = 15)
end

end # module QueueDiagrams
