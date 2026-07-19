# Flow-controlled LLM inference as a round-based token-service station, after
# Dong & Cao, "Flow-Controlled Scheduling for LLM Inference with Provable
# Stability Guarantees" (arXiv:2604.11001, preprint — not yet peer reviewed).
#
# What the system is. A large language model (LLM) inference server generates
# text one token at a time on a graphics processing unit (GPU). To serve many
# requests at once it batches them: at every decode iteration it produces one
# more output token for each request in the active set. The scarce resource is
# GPU memory, specifically the KEY-VALUE CACHE (KV cache): for every token a
# request has already processed, the model stores an intermediate key and value
# vector so it does not recompute them each step. That store grows by one slot
# per generated token and is freed only when the request finishes. So a request
# that has produced j tokens and had a prompt of length l occupies l + j cache
# entries, and the whole server must keep the total under a hard budget M (the
# GPU memory devoted to the cache). Overflow forces the server to evict a
# request — throw away its partial work — which is pure waste.
#
# The paper's model (their Section 2). Time is SLOTTED: one slot = one decode
# iteration. Each slot the server picks an active set S and generates exactly
# one token for every request in it; a request of class with prompt length l
# and output length o occupies l + j cache entries after generating its j-th
# token, and finishes (releasing all its memory) at the end of the slot in
# which it produces token o. New requests arrive at the start of a slot, join a
# waiting queue, and are ACTIVATED (moved into the active set, starting to hold
# cache) only when the scheduler admits them. The whole contribution is a
# FLOW-CONTROL rule on activation: cap how many requests may be activated per
# slot so memory rises smoothly instead of in bursts.
#
# Why this is a round station in Concourse. Concourse's `Rounds` capability is
# exactly iteration-level batching: one station-level clock per slot, per-job
# integer work counters (here the remaining output tokens), and a policy hook
# at each slot boundary that reads the waiting line and active set and returns
# admissions / evictions / per-job token allocations. The paper's discrete-time
# token model is the degenerate timing case: a `Dirac` duration of 1.0 (one
# slot), one output-token phase, and one token allocated per active request per
# slot. Prefill (processing the prompt) costs l cache entries but zero time —
# it is an ordinary mark, not a work phase. Two shipped policies ARE the paper's
# two algorithms, verbatim:
#   * `ClassBudgets(b; class)` = Algorithm 1 (known output length): per-class
#     per-slot activation budgets b_k, FIFO, one decode token each, no memory
#     check (budgets meeting the paper's inequality (2) keep the cache safe by
#     construction).
#   * `FlowControl(Bdist, M; prompt)` = Algorithm 2 (unknown output length): a
#     drawn global activation budget B_t each slot, KV accounting
#     U = Σ (l + generated + 1), and LIFO (last-in, first-out) eviction with
#     full progress reset while U > M.
#
# What this script reproduces (the paper's synthetic Section 4.1).
#   1. Algorithm 1's exact per-class DECOUPLING identity. With no memory check,
#      each class's waiting queue follows the scalar Lindley recursion
#      Q_{t,k} = (Q_{t-1,k} + n_{t,k} - b_k)^+ independently. We check the
#      simulated per-class queue against this recursion slot for slot (EXACT).
#   2. The KV-cache workload bound. With classes (l,o) = (10,20),(10,40),(10,60)
#      and budgets b = (4,4,4), the per-request minimum workload is
#      w_k = l·o + (o + o²)/2, and the active-set memory can never exceed
#      Σ b_k w_k = 16240 < M = 16492 (the paper's inequality (2), tight). We
#      check the simulated peak KV usage equals 16240 exactly and never exceeds
#      M — memory is SAFE even when the queue is not.
#   3. Proposition 3.2's stability boundary. The necessary condition for ANY
#      scheduler to be stable is Σ λ_k w_k ≤ M, i.e. λ ≤ M / Σ w_k = 4.0621.
#      Algorithm 1's own sufficient condition (Theorem 3.3) is stricter:
#      b_k > λ_k, i.e. λ < 4 for integer budgets b = 4. We sweep λ and show the
#      queue-growth flip at λ = 4 while KV usage stays bounded throughout.
#   4. Algorithm 2 under overload. A drawn budget keeps the cache smooth; a
#      naive greedy admit-all baseline pins the cache at M and evicts
#      constantly, wasting recomputed tokens. We show what flow control buys.
#
# What this script does NOT reproduce. The paper's Section 4.2 real-trace
# experiment replaces the one-slot Dirac timing with Microsoft Vidur, an
# external LLM-serving simulator that computes each batch's wall-clock time from
# its exact prefill/decode composition. There is no published closed form for
# that timing, so it cannot be reproduced as an oracle here; the synthetic
# Section 4.1 experiment is the reproduction target. We also compare Algorithm 2
# only against a greedy admit-all baseline (the paper's own "b large degenerates
# to greedy + LIFO"), not against the paper's α-protection / MC / MC-SF / Amin
# benchmarks or its Gurobi hindsight-optimal integer programs.
#
# Run from the repository root:
#   julia --project=examples examples/dong2026_flow_control.jl
# Figures land in docs/figures/ and docs/src/manual/figures/. Total runtime is
# a few minutes (horizons and replicate counts are sized so the validation
# table passes without a long wait).

using Concourse
using Distributions
using Statistics
using Plots
using Plots.PlotMeasures

# ---------------------------------------------------------------------------
# Constants. These are the paper's PUBLISHED numbers (Section 4.1), not
# calibrated fits: classes (l,o) = (10,20),(10,40),(10,60), per-class Poisson
# rate λ = 5, KV budget M = 16492 (their stated Llama2-70B-on-two-A100 scale),
# activation budgets b = (4,4,4) chosen to satisfy inequality (2). The one
# derived constant, the tight workload bound Σ b_k w_k = 16240, we recompute
# below so it is auditable.

const CLASSES = ((10, 20), (10, 40), (10, 60))   # (prompt length l, output length o) per class
const LAMBDA_PAPER = 5.0                          # per-class Poisson arrivals per slot (Section 4.1)
const M_KV = 16492                                # KV cache budget (tokens), paper's value
const B_BUDGET = (4, 4, 4)                         # per-class activation budgets (Algorithm 1)

# Per-request minimum KV workload w_k = l·o + (o + o²)/2 = Σ_{j=1}^{o} (l + j):
# the total cache-slot-seconds a class-k request must consume to finish.
workload(l, o) = l * o + (o + o^2) / 2
const W = [workload(l, o) for (l, o) in CLASSES]              # [410, 1220, 2430]
const KV_TIGHT = Int(sum(B_BUDGET[k] * W[k] for k in 1:3))   # 16240, inequality (2) LHS
const LAMBDA_STAR = M_KV / sum(W)                            # Prop 3.2 boundary, 4.0621

# Horizons. λ = 5 with b = 4 is queue-UNSTABLE (below), so "steady state" only
# exists in the stable sweep points (λ < 4); those use the longer horizon.
const T_IDENTITY = 130.0    # short run for the exact slot-for-slot identity check
const T_STABLE = 8000.0     # long run for batch-mean estimates in the stable regime
const NBATCH = 20           # batches for batch-means standard errors

# ---------------------------------------------------------------------------
# Model builders (local copies of the verified test parameterizations in
# test/testmodels.jl, so the example is self-contained and inherits the exact
# constants the test suite checks).

# Algorithm 1: three classes, each a Poisson source stamping (class, l, o) as
# marks, feeding one round station under ClassBudgets. Duration is a unit Dirac
# (one slot); the single work phase is the output-token count o; prefill length
# l is an ordinary memory-only mark.
function dong_three_class(; b = B_BUDGET)
    net = QueueNetwork(param_names = (:lambda,))
    for (k, (l, o)) in enumerate(CLASSES)
        source!(net, Symbol(:arrive, k);
                interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
                mark = MarkLaw(class = Law(:Dirac, value = Const(Float64(k))),
                               l = Law(:Dirac, value = Const(Float64(l))),
                               o = Law(:Dirac, value = Const(Float64(o)))))
        route!(net, Symbol(:arrive, k), Always(:gpu))
    end
    station!(net, :gpu;
             rounds = Rounds(policy = ClassBudgets(b; class = :class),
                             duration = Law(:Dirac, value = Const(1.0)),
                             work = (:o,)))
    sink!(net, :done)
    route!(net, :gpu, Always(:done))
    compile(net)
end

# Algorithm 2: one class of unknown-output-length requests (l, o) = (10, 15),
# a Poisson arrival stream, one round station under FlowControl with a drawn
# activation budget and hard cache budget M. The output length o is the work
# phase (the scheduler never reads it — output length is "unknown" — it only
# reads the prompt mark l for accounting).
function flow_model(Bdist; M = 120, l = 10.0, o = 15.0)
    net = QueueNetwork(param_names = (:lambda,))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(l = Law(:Dirac, value = Const(l)),
                           o = Law(:Dirac, value = Const(o))))
    station!(net, :gpu;
             rounds = Rounds(policy = FlowControl(Bdist, M; prompt = :l),
                             duration = Law(:Dirac, value = Const(1.0)),
                             work = (:o,)))
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    compile(net)
end

# ---------------------------------------------------------------------------
# Oracles.
#
# 1. The exact decoupling recursion (Algorithm 1). With no memory check, class
# k's waiting queue evolves as Q_{t,k} = (Q_{t-1,k} + n_{t,k} - b_k)^+, where
# n_{t,k} is the number of class-k arrivals landing in slot t. Given the
# recorded arrival times/classes this is a deterministic sequence — the oracle
# the simulated queue must match slot for slot.

function decoupling_oracle(atimes, aclasses, t0, nslots; b = B_BUDGET)
    oracle = Vector{Int}[]
    Q = [0, 0, 0]
    for i in 1:nslots
        n = [0, 0, 0]
        for (ta, ca) in zip(atimes, aclasses)
            t0 + (i - 1) < ta <= t0 + i && (n[ca] += 1)
        end
        Q = [max(Q[k] + n[k] - b[k], 0) for k in 1:3]
        push!(oracle, copy(Q))
    end
    oracle
end

# 2. The stationary mean waiting-queue length of a single class under
# Algorithm 1 in the STABLE regime (λ < b). The per-class recursion
# Q_t = (Q_{t-1} + n_t - b)^+ with n_t ~ Poisson(λ) is a reflected random walk;
# its stationary distribution is computed here by power-iterating the
# transition on a truncated state space. Exact (to truncation) for λ < b.

function stationary_mean_queue(λ, b; Nmax = 400, iters = 50_000, tol = 1e-14)
    pois = [pdf(Poisson(λ), n) for n in 0:Nmax]
    p = zeros(Nmax + 1); p[1] = 1.0
    for _ in 1:iters
        q = zeros(Nmax + 1)
        for i in 0:Nmax
            pi = p[i + 1]
            pi == 0 && continue
            for n in 0:Nmax
                pn = pois[n + 1]
                pn == 0 && continue
                nb = min(max(i + n - b, 0), Nmax)
                q[nb + 1] += pi * pn
            end
        end
        maximum(abs.(q .- p)) < tol && (p = q; break)
        p = q
    end
    sum(i * p[i + 1] for i in 0:Nmax)
end

# ---------------------------------------------------------------------------
# Measurement folds over the record.

# The station index and the source-id -> class map for the three-class model.
gpu_index(m) = m.names[:gpu]
class_of_source(m) = Dict(Int(m.names[Symbol(:arrive, k)]) => k for k in 1:3)

# Per-slot trace of Algorithm 1: at each round firing record the post-firing
# per-class waiting counts q (the Q_{t,k}), the active-set KV usage U, and the
# tokens delivered that slot (the fired plan's total allocation).
function alg1_trace(m, λ, T; seed)
    rec = simulate(m, [λ], T; seed = seed)
    st = replay(m, rec)
    g = gpu_index(m)
    ts = Float64[]; qs = Vector{Int}[]; Us = Int[]; deliv = Int[]
    for i in eachindex(rec.key)
        rec.key[i][1] == :round || continue
        pre, post = st[i], st[i + 1]
        p = pre.roundplan[g]
        push!(deliv, p === nothing ? 0 : sum(av[1] for (_, av) in p.alloc; init = 0))
        q = [0, 0, 0]
        for j in post.buf[g]
            q[Int(post.jobs[j].class)] += 1
        end
        push!(qs, q)
        U = 0
        for j in post.srv[g]
            mk = post.jobs[j]
            U += Int(mk.l) + (Int(mk.o) - post.work[j][1]) + 1
        end
        push!(Us, U)
        push!(ts, rec.time[i])
    end
    (rec = rec, ts = ts, qs = qs, Us = Us, deliv = deliv)
end

# The recorded arrival times and classes, in record order.
function arrivals(m, rec)
    src = class_of_source(m)
    ts = Float64[]; cs = Int[]
    for i in eachindex(rec.key)
        rec.key[i][1] == :arrival || continue
        push!(ts, rec.time[i]); push!(cs, src[Int(rec.key[i][2])])
    end
    ts, cs
end

# Batch-means point estimate and standard error of a per-slot series.
function batch_means(vals; nbatch = NBATCH)
    n = length(vals)
    bs = div(n, nbatch)
    bs == 0 && return (mean(vals), NaN)
    ms = [mean(@view vals[(i - 1) * bs + 1:i * bs]) for i in 1:nbatch]
    mean(ms), std(ms) / sqrt(nbatch)
end

# Algorithm 2 fold: evictions, tokens wasted to progress-reset, completed
# requests, and the KV-usage trace. Mirrors the structure of the paper's
# recomputation accounting (test/test_rounds_papers.jl).
function flow_analyze(m, λ, T; seed)
    rec = simulate(m, [λ], T; seed = seed)
    st = replay(m, rec)
    g = gpu_index(m)
    narr = count(k -> k[1] == :arrival, rec.key)
    since_act = Dict{Int,Int}()   # tokens generated since a job's last activation
    wasted = 0                    # tokens discarded by eviction resets
    nevict = 0
    completions = 0
    overM = 0
    Utrace = Int[]; ttrace = Float64[]
    lastplan = nothing
    for i in eachindex(rec.key)
        pre, post = st[i], st[i + 1]
        if rec.key[i][1] == :round
            p = pre.roundplan[g]
            if p !== nothing
                for (j, av) in p.alloc
                    since_act[j] = get(since_act, j, 0) + av[1]
                end
            end
        end
        p = post.roundplan[g]
        if p !== nothing && p !== lastplan
            lastplan = p
            nevict += length(p.evict)
            for j in p.evict
                wasted += get(since_act, j, 0)
                since_act[j] = 0
            end
            for j in p.admit
                since_act[j] = 0
            end
            U = sum(Int(post.jobs[j].l) + (Int(post.jobs[j].o) - post.work[j][1]) + 1
                    for j in post.srv[g]; init = 0)
            push!(Utrace, U); push!(ttrace, rec.time[i])
        end
        for _ in setdiff(keys(pre.jobs), keys(post.jobs))
            completions += 1
        end
    end
    (rec = rec, narr = narr, nevict = nevict, wasted = wasted,
     completions = completions, Utrace = Utrace, ttrace = ttrace,
     maxU = maximum(Utrace; init = 0), meanU = mean(Utrace))
end

# ---------------------------------------------------------------------------
# Validation table.

function check_table()
    println(rpad("check", 46), rpad("simulated", 22), rpad("target", 12), "verdict")

    # 1. Exact decoupling identity (Algorithm 1), paper's λ = 5.
    m = dong_three_class()
    tr = alg1_trace(m, LAMBDA_PAPER, T_IDENTITY; seed = 11)
    atimes, aclasses = arrivals(m, tr.rec)
    t0 = atimes[1]
    nslots = length(tr.ts)
    # The slot grid never realigns: round i fires at t0 + i.
    gridok = all(tr.ts[i] ≈ t0 + i for i in 1:nslots)
    oracle = decoupling_oracle(atimes, aclasses, t0, nslots)
    identity_ok = (tr.qs == oracle) && gridok
    println(rpad("Alg 1 decoupling identity ($nslots slots)", 46),
            rpad(identity_ok ? "matches recursion" : "MISMATCH", 22),
            rpad("exact", 12), identity_ok ? "PASS" : "FAIL")

    # 2. KV workload bound, tight at 16240 and never over M.
    peak = maximum(tr.Us)
    kv_ok = (peak == KV_TIGHT) && all(u -> u <= M_KV, tr.Us)
    println(rpad("Alg 1 peak KV usage (tokens)", 46),
            rpad(string(peak), 22), rpad(string(KV_TIGHT), 12),
            kv_ok ? "PASS" : "FAIL")
    println(rpad("  Σ b_k w_k = 16240 < M = 16492 ?", 46),
            rpad(string(KV_TIGHT, " < ", M_KV), 22), rpad("yes", 12),
            KV_TIGHT < M_KV ? "PASS" : "FAIL")

    # 3. Proposition 3.2 necessary-condition boundary (closed form).
    println(rpad("Prop 3.2 boundary λ* = M / Σ w_k", 46),
            rpad(string(round(LAMBDA_STAR, digits = 4)), 22),
            rpad("4.0621", 12),
            isapprox(LAMBDA_STAR, 4.0621; atol = 1e-3) ? "PASS" : "FAIL")

    # 4. Stable-regime mean waiting queue vs stationary oracle, at 4 SE.
    #    λ = 3 < b = 4, so each class is positive recurrent with the same
    #    E[Q] (the recursion depends only on λ and b, not on o).
    λs = 3.0
    ms = dong_three_class()
    trs = alg1_trace(ms, λs, T_STABLE; seed = 101)
    eq_oracle = stationary_mean_queue(λs, 4)
    for k in 1:3
        est, se = batch_means([q[k] for q in trs.qs])
        z = abs(est - eq_oracle) / se
        println(rpad("Alg 1 stable E[Q] class $k (λ=3, 4 SE)", 46),
                rpad(string(round(est, digits = 3), " ± ", round(se, digits = 3)), 22),
                rpad(string(round(eq_oracle, digits = 3)), 12),
                z <= 4 ? "PASS (|z|=$(round(z, digits = 2)))" : "FAIL (|z|=$(round(z, digits = 2)))")
    end

    # 5. Stable-regime token throughput vs Σ λ_k o_k, at 4 SE.
    tok_oracle = λs * sum(o for (_, o) in CLASSES)   # 3*(20+40+60) = 360
    est, se = batch_means(Float64.(trs.deliv))
    z = abs(est - tok_oracle) / se
    println(rpad("Alg 1 token throughput (λ=3, 4 SE)", 46),
            rpad(string(round(est, digits = 2), " ± ", round(se, digits = 2)), 22),
            rpad(string(round(tok_oracle, digits = 1)), 12),
            z <= 4 ? "PASS (|z|=$(round(z, digits = 2)))" : "FAIL (|z|=$(round(z, digits = 2)))")

    # 6. Algorithm 2 structural guarantees under overload (exact).
    mf = flow_model(DiscreteUniform(0, 6); M = 120)
    fa = flow_analyze(mf, 1.0, 400.0; seed = 2)
    overflow_free = fa.maxU <= 120
    census = fa.narr >= fa.completions   # arrivals ≥ completions (rest in flight)
    println(rpad("Alg 2 KV usage never exceeds M=120", 46),
            rpad(string("max U = ", fa.maxU), 22), rpad("≤ 120", 12),
            overflow_free ? "PASS" : "FAIL")
    println(rpad("Alg 2 evictions actually exercised", 46),
            rpad(string(fa.nevict, " evictions"), 22), rpad("> 0", 12),
            fa.nevict > 0 ? "PASS" : "FAIL")

    identity_ok && kv_ok
end

# ---------------------------------------------------------------------------
# Figure 1: the synthetic Section 4.1 experiment at the paper's λ = 5.
# Left: per-class waiting queue Q_{t,k} vs slot, simulated vs the exact scalar
# recursion (they coincide) — the queue grows linearly because b = 4 < λ = 5
# (Theorem 3.3's b_k > λ_k is violated). Right: KV usage stays flat, capped by
# the tight bound 16240 well under M = 16492 — MEMORY is safe even while the
# queue is not.

function figure_synthetic()
    m = dong_three_class()
    tr = alg1_trace(m, LAMBDA_PAPER, 300.0; seed = 11)
    atimes, aclasses = arrivals(m, tr.rec)
    t0 = atimes[1]
    nslots = length(tr.ts)
    oracle = decoupling_oracle(atimes, aclasses, t0, nslots)
    slots = 1:nslots

    plt = plot(layout = (1, 2), size = (1000, 440), dpi = 150,
               left_margin = 7mm, bottom_margin = 7mm, top_margin = 4mm, right_margin = 4mm)
    cols = (:steelblue, :darkorange, :seagreen)
    for k in 1:3
        plot!(plt[1], slots, [q[k] for q in tr.qs]; lw = 2, color = cols[k],
              label = "class $k simulated (o=$(CLASSES[k][2]))")
        plot!(plt[1], slots, [o[k] for o in oracle]; lw = 1, ls = :dash, color = :black,
              label = k == 1 ? "exact recursion (Q_t=(Q+n-b)^+)" : "")
    end
    plot!(plt[1]; xlabel = "slot t", ylabel = "waiting requests Q_{t,k}",
          title = "Algorithm 1 queues (λ=5, b=4): queue-unstable", titlefontsize = 10,
          legend = :topleft, legendfontsize = 7)

    plot!(plt[2], slots, tr.Us; lw = 2, color = :purple, label = "KV usage U_t",
          xlabel = "slot t", ylabel = "KV cache tokens in use",
          title = "KV usage stays memory-safe", titlefontsize = 10, legend = :bottomright)
    hline!(plt[2], [KV_TIGHT]; ls = :dot, lw = 1.5, color = :green,
           label = "Σ b_k w_k = $KV_TIGHT (tight bound)")
    hline!(plt[2], [M_KV]; ls = :dash, lw = 1.5, color = :red,
           label = "M = $M_KV (cache budget)")
    ylims!(plt[2], 0, M_KV * 1.08)

    savefig_both(plt, "dong2026_synthetic.png")
    (peak = maximum(tr.Us), match = tr.qs == oracle)
end

# ---------------------------------------------------------------------------
# Figure 2: the stability story. Sweep λ for Algorithm 1 with b = (4,4,4).
# Left: backlog growth rate (waiting requests per slot, second half minus first
# half) vs λ — flat below λ = 4, then linear, matching the analytic drift
# 3·(λ − 4)^+ (three classes each with drift λ − b). Two boundaries are marked:
# λ = 4 (Theorem 3.3, Algorithm 1's sufficient condition b_k > λ_k) and
# λ* = 4.0621 (Proposition 3.2, the necessary condition for ANY scheduler).
# Right: the peak KV usage stays at/below the tight bound 16240 < M across the
# whole sweep — the cache never overflows even where the queue explodes.

const SWEEP_LAMBDA = [2.0, 3.0, 3.5, 3.8, 4.0, 4.2, 4.5, 5.0, 5.5, 6.0]

function figure_stability()
    m = dong_three_class()
    T = 3000.0
    slopes = Float64[]
    peaks = Int[]
    for λ in SWEEP_LAMBDA
        tr = alg1_trace(m, λ, T; seed = 7)
        # backlog = total waiting requests; growth rate over the second half.
        half = something(findlast(t -> t <= T / 2, tr.ts), 1)
        qtot(i) = sum(tr.qs[i])
        slope = (qtot(length(tr.qs)) - qtot(half)) / (T / 2)
        push!(slopes, slope)
        push!(peaks, maximum(tr.Us))
    end
    fine = 2.0:0.05:6.0
    drift = [3 * max(λ - 4, 0) for λ in fine]

    plt = plot(layout = (1, 2), size = (1000, 440), dpi = 150,
               left_margin = 7mm, bottom_margin = 7mm, top_margin = 4mm, right_margin = 4mm)
    plot!(plt[1], collect(fine), drift; lw = 2, color = :black,
          label = "analytic drift 3·(λ−4)^+",
          xlabel = "per-class arrival rate λ", ylabel = "backlog growth (req / slot)",
          title = "Algorithm 1 stability flip", titlefontsize = 10, legend = :topleft)
    scatter!(plt[1], SWEEP_LAMBDA, slopes; ms = 5, color = :steelblue, label = "simulated slope")
    vline!(plt[1], [4.0]; ls = :dash, color = :orange, label = "λ = b = 4 (Thm 3.3)")
    vline!(plt[1], [LAMBDA_STAR]; ls = :dot, color = :red,
           label = "λ* = 4.0621 (Prop 3.2)")

    scatter!(plt[2], SWEEP_LAMBDA, peaks; ms = 5, color = :purple, label = "simulated peak KV",
             xlabel = "per-class arrival rate λ", ylabel = "peak KV cache tokens",
             title = "KV usage bounded across the sweep", titlefontsize = 10,
             legend = :bottomright)
    hline!(plt[2], [KV_TIGHT]; ls = :dot, lw = 1.5, color = :green,
           label = "Σ b_k w_k = $KV_TIGHT")
    hline!(plt[2], [M_KV]; ls = :dash, lw = 1.5, color = :red, label = "M = $M_KV")
    ylims!(plt[2], 0, M_KV * 1.08)

    savefig_both(plt, "dong2026_stability.png")
    (slopes = slopes, peaks = peaks)
end

# ---------------------------------------------------------------------------
# Figure 3: what flow control buys (Algorithm 2, unknown output length, under
# overload). Compare a drawn activation budget B_t ~ DiscreteUniform(0,6)
# (mean 3) against a naive greedy admit-all baseline (a large constant budget,
# the paper's "b large degenerates to greedy + LIFO"). Left: the KV usage
# trajectory — flow control varies smoothly below M while greedy pins the cache
# at M. Right: aggregate cost over the run — evictions, tokens wasted to
# progress-reset, and completed requests, averaged over seeds. Flow control
# evicts less, wastes less recomputation, and completes more.

function figure_flowcontrol()
    M = 120
    λ = 1.0
    T = 400.0
    fc = flow_analyze(flow_model(DiscreteUniform(0, 6); M = M), λ, T; seed = 2)
    gd = flow_analyze(flow_model(DiscreteUniform(50, 50); M = M), λ, T; seed = 2)

    # Average the bar metrics over a handful of seeds for a fair comparison.
    seeds = 1:8
    function avg_metrics(Bdist)
        ev = Float64[]; wa = Float64[]; co = Float64[]
        for s in seeds
            a = flow_analyze(flow_model(Bdist; M = M), λ, T; seed = s)
            push!(ev, a.nevict); push!(wa, a.wasted); push!(co, a.completions)
        end
        (mean(ev), mean(wa), mean(co))
    end
    fc_ev, fc_wa, fc_co = avg_metrics(DiscreteUniform(0, 6))
    gd_ev, gd_wa, gd_co = avg_metrics(DiscreteUniform(50, 50))

    plt = plot(layout = (1, 2), size = (1000, 440), dpi = 150,
               left_margin = 8mm, bottom_margin = 9mm, top_margin = 4mm, right_margin = 4mm)
    plot!(plt[1], fc.ttrace, fc.Utrace; lw = 1.6, color = :seagreen,
          label = "flow control B~Unif(0,6)",
          xlabel = "slot t", ylabel = "KV cache tokens in use",
          title = "KV usage: smooth vs pinned at M", titlefontsize = 10, legend = :bottomright)
    plot!(plt[1], gd.ttrace, gd.Utrace; lw = 1.2, color = :crimson, alpha = 0.75,
          label = "greedy admit-all")
    hline!(plt[1], [M]; ls = :dash, lw = 1.5, color = :red, label = "M = $M")
    ylims!(plt[1], 0, M * 1.12)

    groups = ["evictions", "wasted tokens", "completions"]
    fcvals = [fc_ev, fc_wa, fc_co]
    gdvals = [gd_ev, gd_wa, gd_co]
    xs = 1:3
    bar!(plt[2], xs .- 0.18, fcvals; bar_width = 0.34, color = :seagreen,
         label = "flow control", xticks = (xs, groups),
         ylabel = "count over T=$(Int(T)) slots (mean of $(length(seeds)) seeds)",
         title = "Flow control wastes less, completes more", titlefontsize = 10,
         legend = :topright)
    bar!(plt[2], xs .+ 0.18, gdvals; bar_width = 0.34, color = :crimson, label = "greedy")
    for (i, (f, gg)) in enumerate(zip(fcvals, gdvals))
        annotate!(plt[2], i - 0.18, f + maximum(gdvals) * 0.03, text(string(round(Int, f)), 7))
        annotate!(plt[2], i + 0.18, gg + maximum(gdvals) * 0.03, text(string(round(Int, gg)), 7))
    end

    savefig_both(plt, "dong2026_flowcontrol.png")
    (fc = (fc_ev, fc_wa, fc_co), gd = (gd_ev, gd_wa, gd_co))
end

# ---------------------------------------------------------------------------
# Save a figure to both the docs/figures tree and the manual's figures tree.

function savefig_both(plt, name)
    for sub in (["..", "docs", "figures"], ["..", "docs", "src", "manual", "figures"])
        dir = joinpath(@__DIR__, sub...)
        mkpath(dir)
        savefig(plt, joinpath(dir, name))
    end
end

# ---------------------------------------------------------------------------

if abspath(PROGRAM_FILE) == @__FILE__
    println("== validation: Dong & Cao flow-controlled LLM inference ==")
    check_table()

    println("\n== Figure 1: synthetic Section 4.1 (λ=5, b=4) ==")
    s = figure_synthetic()
    println("peak KV usage = $(s.peak) (tight bound $KV_TIGHT), queues match recursion: $(s.match)")
    println("figure: docs/figures/dong2026_synthetic.png (+ manual copy)")

    println("\n== Figure 2: stability flip at λ = 4, KV bounded throughout ==")
    st = figure_stability()
    println("backlog slopes (req/slot): ",
            join(string.(round.(st.slopes, digits = 3)), ", "))
    println("peak KV per λ: ", join(string.(st.peaks), ", "),
            "  (all ≤ $KV_TIGHT < $M_KV)")
    println("figure: docs/figures/dong2026_stability.png (+ manual copy)")

    println("\n== Figure 3: Algorithm 2 flow control vs greedy admit-all ==")
    f = figure_flowcontrol()
    println("flow control (evict, wasted, completed) = $(round.(f.fc, digits = 1))")
    println("greedy       (evict, wasted, completed) = $(round.(f.gd, digits = 1))")
    println("figure: docs/figures/dong2026_flowcontrol.png (+ manual copy)")
end
