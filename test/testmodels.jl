# Shared model builders for the charter tests.

function mm1(; capacity=typemax(Int), overflow=:drop)
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :counter; discipline = FCFS(), servers = 1, capacity, overflow,
             service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    compile(net)
end

# Marks drawn and recorded; ByMark thins the Poisson stream so each branch is
# an exact M/M/1 — the closed form the 4-SE convention wants, while still
# exercising the A4 mark path.
function sita_split()
    net = QueueNetwork(param_names = (:lambda, :mu_short, :mu_long))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = Law(:Exponential, scale = Const(1.0))))
    station!(net, :short; service = Law(:Exponential, scale = inv(Param(:mu_short))))
    station!(net, :long;  service = Law(:Exponential, scale = inv(Param(:mu_long))))
    sink!(net, :done)
    route!(net, :arrive, ByMark(Mark(:size), [2.0], [:short, :long]))
    route!(net, :short, Always(:done))
    route!(net, :long, Always(:done))
    compile(net)
end

# Probabilistic routing consumes a recorded uniform per arrival (A4).
function bernoulli_split()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :a; service = Law(:Exponential, scale = inv(Param(:mu))))
    station!(net, :b; service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Probabilistic(:a => 0.3, :b => 0.7))
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    compile(net)
end

# Preemptive priority with :resume memory: exercises eviction, banked ages,
# and re-enabling with a left-shifted anchor (A1).
function preemptive_priority()
    net = QueueNetwork(param_names = (:lambda, :mu))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(class = Law(:Uniform, a = Const(0.0), b = Const(2.0))))
    station!(net, :cpu;
             discipline = Priority(Mark(:class); preempt = true, memory = :resume),
             servers = 1, service = Law(:Exponential, scale = inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

# A tandem line with a finite :block buffer in the middle: the cascade and
# unblock machinery under test. Acyclic, so C3 holds by construction.
function blocking_tandem(; cap=2)
    net = QueueNetwork(param_names = (:lambda, :mu1, :mu2))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :first;  service = Law(:Exponential, scale = inv(Param(:mu1))))
    station!(net, :second; service = Law(:Exponential, scale = inv(Param(:mu2))),
             capacity = cap, overflow = :block)
    sink!(net, :done)
    route!(net, :arrive, Always(:first))
    route!(net, :first, Always(:second))
    route!(net, :second, Always(:done))
    compile(net)
end

# Independent-replication estimate with its standard error; the repo
# convention accepts an oracle within 4 SEs.
function replicate(f, m, θ, horizon, nreps; seed0=1000)
    vals = [f(simulate(m, θ, horizon; seed = seed0 + r, debug = true))
            for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

within4se(est, se, exact) = abs(est - exact) <= 4 * se
