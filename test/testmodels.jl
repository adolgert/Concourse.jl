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
# unblock machinery under test. Acyclic, so C3 holds by construction;
# allow_blocking_cycles is inert here and passed through only so tests can
# assert that inertness.
function blocking_tandem(; cap=2, allow_blocking_cycles=false)
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
    return compile(net; allow_blocking_cycles)
end

# A two-station :block loop (capability 5): source → :a → :b, and :b feeds
# back to :a with probability q or escapes to the sink. Both buffers are
# finite with overflow = :block, so the topology has a blocking cycle and
# needs compile's allow_blocking_cycles; pass false to exercise the C3
# default. The cycle's effective load is λ / ((1 - q) μ) — a feedback loop
# with escape probability 1 - q has visit ratio 1 / (1 - q) — so
# non-deadlocking tests must keep that clearly below 1.
function blocking_loop(; cap_a=1, cap_b=1, q=0.5, allow_blocking_cycles=true)
    net = QueueNetwork(; param_names=(:lambda, :mu_a, :mu_b))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(
        net, :a; service=Law(:Exponential; scale=inv(Param(:mu_a))), capacity=cap_a, overflow=:block
    )
    station!(
        net, :b; service=Law(:Exponential; scale=inv(Param(:mu_b))), capacity=cap_b, overflow=:block
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:a))
    route!(net, :a, Always(:b))
    route!(net, :b, Probabilistic(:a => q, :done => 1 - q))
    return compile(net; allow_blocking_cycles)
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

# Closed network (capability 4): a fixed population of N jobs circulates the
# two-station cycle :a → :b → :a, exponential service at both stations, no
# source and no sink. `mark` gives the population drawn initial marks, which
# land in the record's init list ("firing 0"); the service laws are
# overridable so a mark-reading variant (speed by class) reuses the topology.
function closed_cycle(
    N;
    mark=nothing,
    service_a=Law(:Exponential; scale=inv(Param(:mu1))),
    service_b=Law(:Exponential; scale=inv(Param(:mu2))),
)
    net = QueueNetwork(; param_names=(:mu1, :mu2))
    station!(net, :a; service=service_a)
    station!(net, :b; service=service_b)
    route!(net, :a, Always(:b))
    route!(net, :b, Always(:a))
    populate!(net, :a, N; mark)
    return compile(net)
end

# Two-hop tandem with a per-hop redrawn size (capability 7): the source
# stamps size ~ Exp(mean m1), each hop serves Dirac(Mark(:size)) — so each
# hop is exactly M/M/1 with its own size moments — and :hop2's remark
# redraws size ~ Exp(mean m2) at deposit. Had the mark leaked across the
# hops, :hop2 would sit at :hop1's moments instead. `thetafree` freezes the
# size scales at 0.5 and 0.25 so branch_world admits the model.
function remark_tandem(; thetafree=false)
    net = QueueNetwork(; param_names=(:lambda, :m1, :m2))
    scale1 = thetafree ? Const(0.5) : Param(:m1)
    scale2 = thetafree ? Const(0.25) : Param(:m2)
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; size=Law(:Exponential; scale=scale1)),
    )
    station!(net, :hop1; service=Law(:Dirac; value=Mark(:size)))
    station!(
        net,
        :hop2;
        service=Law(:Dirac; value=Mark(:size)),
        remark=(size=Law(:Exponential; scale=scale2),),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:hop1))
    route!(net, :hop1, Always(:hop2))
    route!(net, :hop2, Always(:done))
    return compile(net)
end

# Degenerate M/D/1 as a round station (capability 6): every job carries one
# unit of single-phase work, Sarathi with token budget 1 admits everyone and
# serves exactly one token per round in FCFS order, and the Dirac round
# duration makes the station literally M/D/1 — the engine must add nothing
# when the policy degenerates. `s` is the deterministic service time.
function round_md1(; s=0.5, budget=1)
    net = QueueNetwork(; param_names=(:lambda,))
    source!(
        net,
        :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; w=Law(:Dirac; value=Const(1.0))),
    )
    station!(
        net,
        :gpu;
        rounds=Rounds(; policy=Sarathi(; budget), duration=Law(:Dirac; value=Const(s)), work=(:w,)),
    )
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Dong & Cao's synthetic three-class system (arXiv:2604.11001 §4.1): classes
# (l, o) = (10, 20), (10, 40), (10, 60), each arriving as an independent
# Poisson process at rate λ (the paper's Poisson-per-slot arrivals: a
# continuous-time Poisson stream binned by the unit slots gives i.i.d.
# Poisson(λ) counts per slot), served by Algorithm 1's per-class activation
# budgets b on a single decode phase — one token per active request per
# unit slot, prefill costs memory but zero time, no memory check.
function dong_three_class(; b=(4, 4, 4))
    net = QueueNetwork(; param_names=(:lambda,))
    for (k, ok) in enumerate((20.0, 40.0, 60.0))
        source!(
            net,
            Symbol(:arrive, k);
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(;
                class=Law(:Dirac; value=Const(Float64(k))),
                l=Law(:Dirac; value=Const(10.0)),
                o=Law(:Dirac; value=Const(ok)),
            ),
        )
        route!(net, Symbol(:arrive, k), Always(:gpu))
    end
    station!(
        net,
        :gpu;
        rounds=Rounds(;
            policy=ClassBudgets(b; class=:class), duration=Law(:Dirac; value=Const(1.0)), work=(:o,)
        ),
    )
    sink!(net, :done)
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Dai et al.'s Rybko–Stolyar network of two LLM servers (arXiv:2504.07347
# §5.4), joining capabilities 6 and 7: type A (class = 1) takes hop 1 at :s1
# with sizes ~ (Poisson(32), Poisson(32)) and hop 2 at :s2 with
# (Poisson(512), Poisson(32)); type B (class = 2) flows the reverse way. The
# remark at each server redraws the hop's sizes on deposit — mean prefill
# -448 + 480·class at :s1 and 992 - 480·class at :s2 puts the long prefill
# on each type's SECOND hop. Both servers run mixed decode-priority FCFS
# (Sarathi) with b_max = 768 and t_b ≡ 1 under a non-preemptive class
# priority: :destabilizing gives each server priority to the class EXITING
# through it (s1 favors B, s2 favors A), the paper's unstable configuration;
# :stabilizing reverses it. λ per type: ρ = 0.9 is λ = 0.9·768/608.
function rybko_stolyar(; budget=768, priorities=:destabilizing)
    priorities in (:destabilizing, :stabilizing) ||
        throw(ArgumentError("priorities must be :destabilizing or :stabilizing"))
    o1, o2 = priorities === :destabilizing ? ([2.0, 1.0], [1.0, 2.0]) : ([1.0, 2.0], [2.0, 1.0])
    net = QueueNetwork(; param_names=(:lambda,))
    for (nm, cls) in ((:arrive_a, 1.0), (:arrive_b, 2.0))
        source!(
            net,
            nm;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; class=Law(:Dirac; value=Const(cls))),
        )
    end
    dur = Law(:Dirac; value=Const(1.0))
    station!(
        net,
        :s1;
        remark=(
            v_p=Law(:Poisson; lambda=Const(-448.0) + Const(480.0) * Mark(:class)),
            v_d=Law(:Poisson; lambda=Const(32.0)),
        ),
        rounds=Rounds(;
            policy=ClassPriority(Sarathi(; budget); by=:class, order=o1),
            duration=dur,
            work=(:v_p, :v_d),
        ),
    )
    station!(
        net,
        :s2;
        remark=(
            v_p=Law(:Poisson; lambda=Const(992.0) + Const(-480.0) * Mark(:class)),
            v_d=Law(:Poisson; lambda=Const(32.0)),
        ),
        rounds=Rounds(;
            policy=ClassPriority(Sarathi(; budget); by=:class, order=o2),
            duration=dur,
            work=(:v_p, :v_d),
        ),
    )
    sink!(net, :done)
    route!(net, :arrive_a, Always(:s1))
    route!(net, :arrive_b, Always(:s2))
    route!(net, :s1, ByMark(Mark(:class), [1.5], [:s2, :done]))
    route!(net, :s2, ByMark(Mark(:class), [1.5], [:done, :s1]))
    return compile(net)
end

# Two identical exponential servers behind one routing decision
# (capability 8): source → kernel over (:a, :b) → sink. The default kernel
# is join-the-shortest-queue by job count; pass the fair Bernoulli split for
# the paired comparison, or any other two-destination kernel over the same
# topology. Declaration order puts :a at the lower station index, so JSQ
# ties break toward :a.
function jsq_pair(; kernel=ShortestQueue(:a, :b))
    net = QueueNetwork(; param_names=(:lambda, :mu))
    source!(net, :arrive; interarrival=Law(:Exponential; scale=inv(Param(:lambda))))
    station!(net, :a; service=Law(:Exponential; scale=inv(Param(:mu))))
    station!(net, :b; service=Law(:Exponential; scale=inv(Param(:mu))))
    sink!(net, :done)
    route!(net, :arrive, kernel)
    route!(net, :a, Always(:done))
    route!(net, :b, Always(:done))
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
