# Networks: stations wired together

Real systems are rarely one station. A request hits a load balancer, then an
application server, then a database, sometimes loops back for a retry. In
Concourse a network is just more stations and more `route!` calls, and each
`route!` takes a **routing kernel** that decides where a finished job goes:

- `Always(dest)` — every job goes to `dest`.
- `Probabilistic(a => 0.3, b => 0.7)` — an independent coin flip per job.
- `RoundRobin([a, b])` — alternate destinations in strict rotation.
- `ByMark(...)` — route by a value stamped on the job
  (the [marks page](marks.md)).

This page builds three little networks — a tandem line, a feedback loop, and
a split — and checks each against exact theory.

## Tandem: queues in series

Two stations in a row; every job passes through both.

```@example net
using Luxor, QueueDiagrams, LaTeXStrings # hide
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b1 = buffer(Point(-160, 0), 110, 38; slots = 4, jobs = [0, 0]) # hide
s1 = server(Point(-70, 0), 20; inservice = 0, label = L"\mu_1") # hide
b2 = buffer(Point(60, 0), 110, 38; slots = 4, jobs = [0]) # hide
s2 = server(Point(150, 0), 20; inservice = 0, label = L"\mu_2") # hide
flow(Point(-300, 0), b1.entry; label = L"\lambda") # hide
flow(b1.exit, s1.entry) # hide
flow(s1.exit, b2.entry) # hide
flow(b2.exit, s2.entry) # hide
flow(s2.exit, Point(250, 0)) # hide
end 640 150 # hide
```

A classical result (Burke's theorem) says the departure stream of a stable
M/M/1 queue is itself a Poisson process with rate ``\lambda``. So station 2
is *also* an M/M/1 queue, and the mean number in the whole system is just a
sum of two single-queue formulas:

```math
L = \frac{\rho_1}{1-\rho_1} + \frac{\rho_2}{1-\rho_2},
\qquad \rho_i = \lambda/\mu_i .
```

With ``\lambda = 1``, ``\mu_1 = 2``, ``\mu_2 = 1.6``: ``L = 1 + 5/3 \approx
2.667``.

```@example net
using Concourse, Statistics

function replicate(f, m, θ, horizon, nreps; seed0 = 1000)
    vals = [f(simulate(m, θ, horizon; seed = seed0 + r)) for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

net = QueueNetwork(param_names = (:lambda, :mu1, :mu2))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :first;  service = Law(:Exponential, scale = inv(Param(:mu1))))
station!(net, :second; service = Law(:Exponential, scale = inv(Param(:mu2))))
sink!(net, :done)
route!(net, :arrive, Always(:first))
route!(net, :first,  Always(:second))
route!(net, :second, Always(:done))
tandem = compile(net)

est, se = replicate(r -> time_average(number_in_system, tandem, r),
                    tandem, [1.0, 2.0, 1.6], 2000.0, 16)
println("measured L: ", round(est, digits = 3), " ± ", round(se, digits = 3),
        "   theory: ", round(1.0 + 5 / 3, digits = 3))
```

## Feedback: jobs that come back

Now let a finished job need rework: after station 2, with probability
``q = 0.25`` it is sent back to station 1, otherwise it leaves.

```@example net
@drawsvg begin # hide
background("white") # hide
fontface("Helvetica") # hide
b1 = buffer(Point(-150, -20), 110, 38; slots = 4, jobs = [0, 0]) # hide
s1 = server(Point(-60, -20), 20; inservice = 0, label = L"\mu_1") # hide
b2 = buffer(Point(70, -20), 110, 38; slots = 4, jobs = [0]) # hide
s2 = server(Point(160, -20), 20; inservice = 0, label = L"\mu_2") # hide
flow(Point(-290, -20), b1.entry; label = L"\lambda") # hide
flow(b1.exit, s1.entry) # hide
flow(s1.exit, b2.entry) # hide
flow(b2.exit, s2.entry) # hide
flow(s2.exit, Point(270, -20); label = L"1-q") # hide
feedback(Point(160, 0), Point(-205, -14); drop = 60, label = L"q") # hide
end 640 220 # hide
```

The routing now has a cycle, so how much traffic does each station really
see? Balance the flow: station 1 receives the fresh stream ``\lambda`` plus
the fed-back fraction ``q`` of everything that completes, and in the long run
what completes is what enters. Solving the **traffic equations** gives the
effective arrival rate

```math
\lambda_{\text{eff}} = \frac{\lambda}{1-q},
```

at both stations — each job makes a geometric number of passes, ``1/(1-q)``
on average. Jackson's theorem says each station then behaves as M/M/1 at rate
``\lambda_{\text{eff}}`` (remarkably, even though the merged
stream-plus-feedback is *not* Poisson). With ``\lambda = 1``, ``q = 1/4``:
``\lambda_{\text{eff}} = 4/3``, and with ``\mu_1 = 2, \mu_2 = 4`` the loads
are ``2/3`` and ``1/3``:

```math
L = \frac{2/3}{1/3} + \frac{1/3}{2/3} = 2.5 .
```

```@example net
net = QueueNetwork(param_names = (:lambda, :mu1, :mu2))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :first;  service = Law(:Exponential, scale = inv(Param(:mu1))))
station!(net, :second; service = Law(:Exponential, scale = inv(Param(:mu2))))
sink!(net, :done)
route!(net, :arrive, Always(:first))
route!(net, :first,  Always(:second))
route!(net, :second, Probabilistic(:first => 0.25, :done => 0.75))
loop = compile(net)

est, se = replicate(r -> time_average(number_in_system, loop, r),
                    loop, [1.0, 2.0, 4.0], 2000.0, 16)
println("measured L: ", round(est, digits = 3), " ± ", round(se, digits = 3),
        "   theory: 2.5")
```

Each probabilistic routing decision is one recorded coin flip in the record's
draw list, which is why a run through this network still replays exactly.

## Splitting a stream: coin flips versus turn-taking

Send a rate-2 Poisson stream to two identical servers, first with
`Probabilistic` (each job flips a fair coin), then with `RoundRobin`
(strict alternation). The rates are identical — each server gets rate 1 —
so are the queues the same?

Theory says no, and the difference is instructive. A random split of a
Poisson process *thins* it: each branch is again Poisson, so each server is
an honest M/M/1 with ``\rho = 0.5`` and ``L = 1``. But alternation is not
thinning. Each server sees every *second* arrival, and the gap between its
arrivals is a sum of two exponentials — more regular than Poisson. Smoother
arrivals mean less queueing. The exact value comes from GI/M/1 theory (GI =
general independent interarrivals): the mean number in system is
``\rho/(1-\sigma)``, where ``\sigma`` solves a fixed-point equation in the
interarrival distribution's Laplace transform. Three lines compute it:

```@example net
σ = 0.5
for _ in 1:100
    global σ = (1 / (2 - σ))^2     # Erlang-2 interarrivals, μ = 2
end
L_rr = 0.5 / (1 - σ)
println("sigma = ", round(σ, digits = 4), ",  GI/M/1 prediction L = ",
        round(L_rr, digits = 4))
```

```@example net
function split_model(kernel)
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
    station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, kernel)
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    compile(net)
end

coin = split_model(Probabilistic(:a => 0.5, :b => 0.5))
turn = split_model(RoundRobin([:a, :b]))

at_a(m) = (q = m.names[:a]; st -> Float64(length(st.buf[q]) + length(st.srv[q])))

est_c, se_c = replicate(r -> time_average(at_a(coin), coin, r), coin, [2.0, 2.0], 2000.0, 16)
est_t, se_t = replicate(r -> time_average(at_a(turn), turn, r), turn, [2.0, 2.0], 2000.0, 16)
println("coin flips:  L at server a = ", round(est_c, digits = 3), " ± ",
        round(se_c, digits = 3), "   theory: 1.0")
println("round robin: L at server a = ", round(est_t, digits = 3), " ± ",
        round(se_t, digits = 3), "   theory: ", round(L_rr, digits = 3))
```

Same arrival rate, same server, one-fifth less queue — purely from smoothing
the arrival stream. (For the curious: ``\sigma`` here is exactly
``(3-\sqrt 5)/2``, so the golden ratio is hiding in the round-robin queue.)

## Open versus closed networks

Every network on this page is **open**: jobs enter from outside, circulate,
and leave. The other classical family is **closed**: a fixed population of
``N`` jobs circulates forever, never entering or leaving — the standard model
for "``N`` users at terminals, each thinking, then submitting a job" —
and its theory (mean value analysis) prices interactive systems.

Concourse's surface language cannot express a closed population today: every
job is born at a `source!`, and there is no builder that starts jobs *inside*
the network at time zero. What it can express is the open feedback loop
above, which captures the same phenomenon — jobs revisiting stations — with
an open boundary. If your question is "fixed user population, think time,
response-time law", that is a real limitation of the current surface
language, not a modeling trick away.

Routing kernels so far treat all jobs alike. The [next page](marks.md) gives
jobs identity — classes, sizes, service demands they carry with them.
