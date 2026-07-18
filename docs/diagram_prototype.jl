# Experiment: queueing-theory diagrams with Luxor.jl
# Goal: a small vocabulary of drawing functions (station, buffer, server,
# arrows, class-marked jobs) that composes into arbitrary queue diagrams.

using Luxor

# ---- style ----------------------------------------------------------------
const INK = "black"
const CLASS_COLORS = ["#3b6bb5", "#c4552d", "#3f8f4e", "#8455b0"]  # job classes
const LW = 1.6

# A job token: filled circle colored by class; class 0 = uncolored.
function job(pt::Point, r::Real; class::Int=0)
    class == 0 ? sethue("gray55") : sethue(CLASS_COLORS[class])
    circle(pt, r, action = :fill)
    sethue(INK)
    setline(0.8)
    circle(pt, r, action = :stroke)
end

# Open-ended buffer: top, bottom, right walls; open on the left (arrival side).
# `slots` vertical slat marks; `jobs` is a vector of class ids drawn right-to-left.
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

# Single server: circle; optionally a job in service and a rate label.
function server(center::Point, r::Real; inservice::Int=-1, label="")
    sethue("white"); circle(center, r, action = :fill)
    sethue(INK); setline(LW)
    circle(center, r, action = :stroke)
    inservice >= 0 && job(center, r * 0.45; class = inservice)
    if label != ""
        fontsize(13)
        text(label, Point(center.x, center.y + r + 16), halign = :center)
    end
    return (entry = Point(center.x - r, center.y), exit = Point(center.x + r, center.y))
end

# Processor-sharing / infinite-server style station: big circle with several jobs inside.
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
    if label != ""
        fontsize(13)
        text(label, Point(center.x, center.y + r + 16), halign = :center)
    end
    return (entry = Point(center.x - r, center.y), exit = Point(center.x + r, center.y))
end

# Labeled flow arrow. `label` is drawn above the midpoint.
function flow(from::Point, to::Point; label="")
    sethue(INK); setline(LW)
    arrow(from, to, arrowheadlength = 10, arrowheadangle = π/8)
    if label != ""
        fontsize(15)
        mid = midpoint(from, to)
        text(label, Point(mid.x, mid.y - 8), halign = :center)
    end
end

# Discipline tag under the buffer, e.g. "FIFO", "SRPT".
function discipline(center::Point, w::Real, h::Real, name::String)
    fontsize(13)
    sethue(INK)
    text(name, Point(center.x, center.y + h/2 + 16), halign = :center)
end

# ---- Diagram 1: M/G/1 FIFO with two job classes ---------------------------
function diagram_mg1(fname)
    Drawing(560, 170, fname)
    origin()
    background("white")
    fontface("Helvetica")

    bc = Point(0, 0)
    b = buffer(bc, 170, 44; slots = 5, jobs = [1, 2, 1, 1])
    discipline(bc, 170, 44, "FIFO")
    s = server(Point(130, 0), 26; inservice = 2, label = "μ")
    flow(Point(-230, 0), b.entry; label = "λ₁ + λ₂")
    flow(b.exit, s.entry)
    flow(s.exit, Point(240, 0))
    finish()
end

# ---- Diagram 2: processor sharing station ---------------------------------
function diagram_ps(fname)
    Drawing(480, 190, fname)
    origin()
    background("white")
    fontface("Helvetica")
    s = sharedserver(Point(0, 0), 44; jobs = [1, 2, 1, 3], label = "PS, rate μ")
    flow(Point(-190, 0), s.entry; label = "λ")
    flow(s.exit, Point(190, 0))
    finish()
end

# ---- Diagram 3: tandem network with feedback ------------------------------
function diagram_network(fname)
    Drawing(760, 240, fname)
    origin()
    background("white")
    fontface("Helvetica")

    # station 1: FIFO
    b1c = Point(-190, -20)
    b1 = buffer(b1c, 120, 38; slots = 4, jobs = [1, 2])
    discipline(b1c, 120, 38, "FIFO")
    s1 = server(Point(-95, -20), 21; inservice = 1, label = "μ₁")

    # station 2: PS
    s2 = sharedserver(Point(120, -20), 38; jobs = [2, 1], label = "PS μ₂")

    flow(Point(-360, -20), b1.entry; label = "λ")
    flow(b1.exit, s1.entry)
    flow(s1.exit, s2.entry; label = "p = 1")
    flow(s2.exit, Point(330, -20); label = "1 − q")

    # feedback loop from station 2 back to station 1
    sethue(INK); setline(LW)
    fb_start = Point(120, -20 + 38)
    fb_end   = Point(b1.entry.x - 18, -20)
    move(fb_start)
    curve(Point(120, 90), Point(fb_end.x - 40, 90), Point(fb_end.x, 5))
    strokepath()
    arrow(Point(fb_end.x, 5), fb_end, arrowheadlength = 10, arrowheadangle = π/8)
    fontsize(15)
    text("q", Point(-40, 82), halign = :center)
    finish()
end

for (f, base) in [(diagram_mg1, "luxor_mg1"), (diagram_ps, "luxor_ps"), (diagram_network, "luxor_net")]
    f(base * ".svg")
    f(base * ".png")
end
println("done")
