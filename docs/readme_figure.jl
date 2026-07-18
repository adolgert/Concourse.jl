# Renders the README diagram: an M/M/1 queue (buffer + single server),
# drawn with the same QueueDiagrams vocabulary the documentation uses.
#
#     julia --project=docs docs/readme_figure.jl

using Luxor
using LaTeXStrings
using QueueDiagrams

const OUT = joinpath(@__DIR__, "figures", "readme_queue.svg")

function readme_figure(fname)
    mkpath(dirname(fname))
    Drawing(560, 170, fname)
    origin()
    background("white")
    fontface("Helvetica")

    bc = Point(-40, -10)
    b = buffer(bc, 170, 44; slots = 5, jobs = [0, 0, 0])
    discipline(bc, 170, 44, "FCFS")
    s = server(Point(105, -10), 26; inservice = 0, label = L"\mu")
    flow(Point(-260, -10), b.entry; label = L"\lambda")
    flow(b.exit, s.entry)
    flow(s.exit, Point(240, -10))

    finish()
end

readme_figure(OUT)
println("wrote ", OUT)
