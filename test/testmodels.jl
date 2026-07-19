# Shared model builders for the charter tests.

function mm1(; capacity=typemax(Int), overflow=:drop)
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(
        net,
        :counter;
        discipline=FCFS(),
        servers=1,
        capacity,
        overflow,
        service=Law(:Exponential; scale=inv(Param(:mu))),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:counter))
    route!(net, :counter, Always(:done))
    return compile(net)
end

# Marks drawn and recorded; ByMark thins the Poisson stream so each branch is
# an exact M/M/1 — the closed form the 4-SE convention wants, while still
# exercising the A4 mark path.
function sita_split()
    net = QueueNetwork(; param_names=(:lambda, :mu_short, :mu_long))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; size=Law(:Exponential; scale=Const(1.0))),
    )
    station!(net, :short; service=Law(:Exponential; scale=inv(Param(:mu_short))))
    station!(net, :long; service=Law(:Exponential; scale=inv(Param(:mu_long))))
    sink!(net, :done)
    route!(net, :arrive, ByMark(Mark(:size), [2.0], [:short, :long]))
    route!(net, :short, Always(:done))
    route!(net, :long, Always(:done))
    return compile(net)
end

# Probabilistic routing consumes a recorded uniform per arrival (A4).
function bernoulli_split()
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :a; service=Law(:Exponential; scale=inv(Param(:mu))))
    station!(net, :b; service=Law(:Exponential; scale=inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, Probabilistic(:a => 0.3, :b => 0.7))
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
    return compile(net)
end

# Preemptive priority with :resume memory: exercises eviction, banked ages,
# and re-enabling with a left-shifted anchor (A1).
function preemptive_priority()
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; class=Law(:Uniform; a=Const(0.0), b=Const(2.0))),
    )
    station!(
        net,
        :cpu;
        discipline=Priority(Mark(:class); preempt=true, memory=:resume),
        servers=1,
        service=Law(:Exponential; scale=inv(Param(:mu))),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    return compile(net)
end

# A tandem line with a finite :block buffer in the middle: the cascade and
# unblock machinery under test. Acyclic, so C3 holds by construction.
function blocking_tandem(; cap=2)
    net = QueueNetwork(; param_names=(:lambda, :mu1, :mu2))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :first; service=Law(:Exponential; scale=inv(Param(:mu1))))
    station!(
        net,
        :second;
        service=Law(:Exponential; scale=inv(Param(:mu2))),
        capacity=cap,
        overflow=:block,
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:first))
    route!(net, :first, Always(:second))
    route!(net, :second, Always(:done))
    return compile(net)
end

# A birth-death chain as a queueing model: Poisson arrivals at rate λ feed a
# single-server station whose exponential service RATE is `rate(n)`, where
# `rate` maps the occupancy expression n = InService + InBuffer to a
# ScalarExpr. rate(n) = Param(:mu) * n is M/M/∞ in disguise; rate(n) =
# Param(:mu) * min(n, Const(c)) is M/M/c. Shared with later state-dependent
# capabilities.
function birth_death(rate; station=:q)
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    n = InService(station) + InBuffer(station)
    station!(net, station; servers=1, service=Law(:Exponential; scale=inv(rate(n))))
    sink!(net, :done)
    route!(net, :arrive, Always(station))
    route!(net, station, Always(:done))
    return compile(net)
end

# Batch service (capability 2): source → one FCFS station that gathers
# batches of `min`..`max` waiting jobs into a synthetic batch job, → sink.
# The default service law is the size-independent exponential of the
# M/M^[K]/1 oracle (min = max = K); pass a law reading Mark(:batchsize) for
# the size-dependent variants (Inoue's affine batch processing time).
function batch_mmk1(; min, max=min, service=Law(:Exponential; scale=inv(Param(:mu))))
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :gate; servers=1, service, batching=Batching(; min, max))
    sink!(net, :done)
    route!(net, :arrive, Always(:gate))
    route!(net, :gate, Always(:done))
    return compile(net)
end

# (n, k) redundancy race (capability 3): source → fork into n single-server
# FCFS branch stations :s1..:sn → join(parts = n, need = k, cancel) → sink.
# One service law shared by every branch; the exponential default is the
# redundancy oracle, and an Opaque (shifted exponential, hyperexponential)
# reaches the Joshi P-K oracle — the sampler only needs the distribution to
# answer logccdf/invlogccdf.
function nk_race(n, k; service=Law(:Exponential; scale=inv(Param(:mu))), cancel=:on_completion)
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    branches = [Symbol(:s, i) for i in 1:n]
    fork!(net, :split; branches)
    for b in branches
        station!(net, b; service)
    end
    join!(net, :merge; parts=n, need=k, cancel)
    sink!(net, :done)
    route!(net, :arrive, Always(:split))
    for b in branches
        route!(net, b, Always(:merge))
    end
    route!(net, :merge, Always(:done))
    return compile(net)
end

# CONCOURSE_TEST_QUICK=1 shrinks replication counts for fast local iteration.
const QUICK = get(ENV, "CONCOURSE_TEST_QUICK", "0") == "1"
nreps(n) = QUICK ? max(4, n ÷ 8) : n

# Independent-replication estimate with its standard error; the repo
# convention accepts an oracle within 4 SEs.
function replicate(f, m, θ, horizon, nreps; seed0=1000)
    vals = [f(simulate(m, θ, horizon; seed=seed0 + r, debug=true)) for r in 1:nreps]
    return mean(vals), std(vals) / sqrt(nreps)
end

within4se(est, se, exact) = abs(est - exact) <= 4 * se
