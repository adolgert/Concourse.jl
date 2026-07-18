# Line disciplines

When the server frees up and several jobs are waiting, someone has to decide
who goes next. That rule is the **discipline**. Concourse ships six, and this
page runs the same stream of work through all of them.

The experiment at the bottom of the page needs jobs whose service demands are
known when they arrive. So each arriving job is stamped with a **size** — the
exact amount of service it will need — drawn from a uniform distribution. A
number stamped on a job is called a *mark*; marks get [their own
page](marks.md). For now: every discipline below sees the identical arrival
stream and the identical job sizes, and only the order of service changes.

In the diagrams, jobs are colored by arrival order: blue arrived first, then
orange, then green. The head of the line (next to be served) is drawn nearest
the server.

## FCFS — first come, first served

The default in shops, banks, and fair-minded software: jobs are served in
arrival order. The earliest arrival stands at the head.

```@example disc
using Luxor, QueueDiagrams, LaTeXStrings # hide
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-60, 0), 150, 40; slots = 5, jobs = [1, 2, 3]) # hide
discipline(Point(-60, 0), 150, 40, "FCFS") # hide
s = server(Point(75, 0), 22; inservice = 0) # hide
flow(Point(-220, 0), b.entry) # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(190, 0)) # hide
end 460 120 # hide
```

## LCFS — last come, first served

The newest arrival is served first, like plates in a stack. The blue job that
arrived first now waits at the back — and every later arrival cuts ahead of
it.

```@example disc
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-60, 0), 150, 40; slots = 5, jobs = [3, 2, 1]) # hide
discipline(Point(-60, 0), 150, 40, "LCFS") # hide
s = server(Point(75, 0), 22; inservice = 0) # hide
flow(Point(-220, 0), b.entry) # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(190, 0)) # hide
end 460 120 # hide
```

## SIRO — service in random order

When the server frees up, it picks a waiting job uniformly at random. Arrival
order carries no weight at all.

```@example disc
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-60, 0), 150, 40; slots = 5, jobs = [2, 3, 1]) # hide
discipline(Point(-60, 0), 150, 40, "SIRO") # hide
sethue("black"); fontsize(15) # hide
text("?", Point(-60, -32), halign = :center) # hide
s = server(Point(75, 0), 22; inservice = 0) # hide
flow(Point(-220, 0), b.entry) # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(190, 0)) # hide
end 460 120 # hide
```

## Priority

Jobs carry a priority key, and the buffer stays sorted by it: lowest key at
the head, ties served in arrival order. In the diagram the blue class outranks
the orange class, so blues wait at the head regardless of when they arrived.
In the experiment below the key is the job's size, which makes this
*shortest job first*: `Priority(Mark(:size))`. (A `preempt = true` variant
can also evict the job currently in service, with a choice of whether the
victim keeps its progress.)

```@example disc
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-60, 0), 150, 40; slots = 5, jobs = [1, 1, 2, 2]) # hide
discipline(Point(-60, 0), 150, 40, "Priority") # hide
s = server(Point(75, 0), 22; inservice = 1) # hide
flow(Point(-220, 0), b.entry) # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(190, 0)) # hide
end 460 120 # hide
```

## PS — processor sharing

No line at all: every job present is served at once, each at an equal share of
the server's speed. With ``n`` jobs present, each proceeds at speed ``1/n``.
This is the classical model of a time-sliced CPU (central processing unit).

```@example disc
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
s = sharedserver(Point(0, 0), 40; jobs = [1, 2, 3, 4], label = "PS") # hide
flow(Point(-180, 0), s.entry) # hide
flow(s.exit, Point(180, 0)) # hide
end 460 140 # hide
```

## SRPT — shortest remaining processing time

The job with the least work *left* is served first, and a newly arrived
shorter job preempts the one in service (the interrupted job keeps its
progress and resumes later). SRPT provably minimizes the average number of
jobs in the system. In the diagram the smallest job stands at the head.

```@example disc
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b = buffer(Point(-60, 0), 150, 40; slots = 5) # hide
for (i, r) in enumerate((6, 9, 12)) # hide
    job(Point(-60 + 75 - (i - 0.5) * 25, 0), r) # hide
end # hide
discipline(Point(-60, 0), 150, 40, "SRPT") # hide
s = server(Point(75, 0), 22; inservice = 0) # hide
flow(Point(-220, 0), b.entry) # hide
flow(b.exit, s.entry) # hide
flow(s.exit, Point(190, 0)) # hide
end 460 120 # hide
```

## Same load, six disciplines

Now the experiment. One station, arrival rate ``\lambda = 0.8``, job sizes
uniform on ``[0.4, 1.6]`` (mean 1), so the utilization is ``\rho = 0.8`` in
every case. The service law `Law(:Dirac, value = Mark(:size))` says "this
job's service time is exactly its stamped size". Swapping the discipline is a
one-argument change:

```@example disc
using Concourse

function line_model(disc)
    net = QueueNetwork(param_names = (:lambda,))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = Law(:Uniform, a = Const(0.4), b = Const(1.6))))
    station!(net, :desk; discipline = disc, servers = 1,
             service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:desk))
    route!(net, :desk, Always(:done))
    compile(net)
end
nothing # hide
```

For each discipline we run eight independent simulations and measure each
job's **time in system** (also called the sojourn or response time: waiting
plus service). A job's clock starts at its arrival event and stops at its
service-completion event, both read straight from the record:

```@example disc
using Statistics

function sojourns(rec)
    arr = Float64[]                    # arrival time of job i, in arrival order
    dep = Dict{Int,Float64}()          # job id => departure time
    for (k, t) in zip(rec.key, rec.time)
        k[1] == :arrival && push!(arr, t)
        k[1] == :service && (dep[Int(k[3])] = t)
    end
    [dep[j] - arr[j] for j in eachindex(arr) if haskey(dep, j)]
end

disciplines = ["FCFS"     => FCFS(),
               "LCFS"     => LCFS(),
               "SIRO"     => SIRO(),
               "Priority" => Priority(Mark(:size)),
               "PS"       => ProcessorSharing(),
               "SRPT"     => SRPT()]

println(rpad("discipline", 11), rpad("mean N", 8), rpad("mean T", 8),
        rpad("std T", 8), rpad("T90", 7), "T99")
for (name, disc) in disciplines
    md = line_model(disc)
    Ts = Float64[]; Ns = Float64[]
    for r in 1:8
        rec = simulate(md, [0.8], 2000.0; seed = 20 + r)
        append!(Ts, sojourns(rec))
        push!(Ns, time_average(number_in_system, md, rec))
    end
    println(rpad(name, 11), rpad(round(mean(Ns), digits = 2), 8),
            rpad(round(mean(Ts), digits = 2), 8),
            rpad(round(std(Ts), digits = 2), 8),
            rpad(round(quantile(Ts, 0.9), digits = 2), 7),
            round(quantile(Ts, 0.99), digits = 2))
end
```

## How to read the table

**FCFS, LCFS, and SIRO agree on the averages.** Same mean number in system
(`mean N`), same mean time in system (`mean T`). That is not luck: none of
the three looks at job sizes, all keep the server busy whenever work is
waiting, so they do the same total work and — by a law we meet on the
[next page](kendall_mm1.md) — must share a mean. For the record, the
Pollaczek–Khinchine formula of the [M/G/1 page](mg1.md) predicts
``\text{mean } T = 3.24`` for this load; the measured means sit a few
percent under it because a finite run starts empty and never counts the
jobs still inside at the end.

**But the spread is completely different.** Look at `std T` and the
percentile columns (`T90` and `T99`: 90% and 99% of jobs finish within
those times). Under FCFS your wait is bounded by the work ahead of you at
arrival, so its tail is the shortest. LCFS is sneaky: its `T90` is actually
*better* than FCFS — most jobs arrive near the head and are served fast —
but its `T99` is three times worse, because a job that loses its turn keeps
losing it to every later arrival. SIRO sits in between. Same averages,
different victims: *the number in the system may not care about the
discipline, but who waits absolutely does.*

**Size-aware disciplines beat the average.** Priority-by-size and SRPT push
small jobs ahead of big ones and cut both the mean and the tail. SRPT is the
provable optimum for mean number in system.

**PS is not a free lunch.** Processor sharing has the *worst* mean here.
Sharing helps short jobs escape behind long ones, but these sizes are nearly
uniform — there are no monsters to escape from — and slowing everyone down
just makes everyone late. On the [M/G/1 page](mg1.md), where service times
get a heavy tail, PS will look much better. Which discipline wins depends on
the service-time distribution — that is the next two pages' subject.
