# Throughput-optimal scheduling for LLM inference, after Dai, Deng, Li & Peng,
# "Throughput-Optimal Scheduling Algorithms for LLM Inference and AI Agents"
# (arXiv:2504.07347).
#
# WHAT THE SYSTEM IS. A large-language-model (LLM = large language model)
# inference server answers requests on a graphics processing unit (GPU). Each
# request is processed in two phases. The PREFILL phase reads the whole input
# prompt (v_p tokens) to build the model's key-value cache (KV cache = the
# per-token attention state the model reuses); prefill tokens may be processed
# many-at-a-time. The DECODE phase then generates the answer one token at a
# time (v_d tokens), because each new token depends on the previous one.
#
# The server does NOT serve one request to completion and then the next. At
# every ITERATION it forms a BATCH of tokens drawn from many requests at once
# — a prefill chunk from one, a single decode token from each of several
# others — up to a per-iteration TOKEN BUDGET b_max, runs one forward pass,
# and every request in the batch has its remaining work reduced by what it was
# allocated. Requests stay resident across many iterations. This is
# ITERATION-LEVEL BATCHING, and Concourse expresses it with round-based token
# service (`Rounds`): one station-level clock per round, integer work counters
# per job, and a scheduling POLICY consulted at every round boundary. See
# docs/src/manual/rounds.md.
#
# THE FOUR POLICIES. The paper studies four real scheduling algorithms, each
# shipped as a Concourse `RoundPolicy`:
#   - FasterTransformer (`FasterTransformerRule`): decode-first, NO mixing of
#     prefill and decode in one batch. NOT work-conserving.
#   - vanilla vLLM (`VanillaVLLM`): prefill-first, no mixing, no chunking.
#     NOT work-conserving.
#   - Orca (`Orca`): prefill-first but MIXED batching. Work-conserving.
#   - Sarathi-Serve (`Sarathi`): decode-first, chunked prefill, mixed.
#     Work-conserving.
# A policy is WORK-CONSERVING if it fills the batch to b_max whenever there is
# enough waiting work to do so — i.e. it never wastes GPU capacity.
#
# THE BATCH-TIME MODEL (paper Eq. 4, Fig. 6). One forward pass over a batch of
# token load b costs, to high accuracy on real hardware,
#
#       t_b = c + a * ceil(b / b_0)   milliseconds,
#
# a staircase in b: cost jumps every b_0 tokens. For CodeLlama-34B on one
# A100 80GB GPU (tensor-parallel size 1) the paper fits c = 11.28 ms,
# a = 35.47 ms, b_0 = 128 tokens (R^2 > 0.97). These three constants are the
# ONLY calibration this example takes from the paper; everything else
# (workloads, arrival rates, budgets) is taken verbatim from the paper's
# experiments. All times here are in MILLISECONDS.
#
# THE HEADLINE RESULT (Theorem 2). The maximal token-processing rate of the
# server is b_max / t_{b_max} (fill the budget every round). With Poisson
# request arrivals at rate lambda and mean work m_p + m_d tokens per request,
# the server is STABLE (backlog stays bounded) if and only if
#
#       lambda * (m_p + m_d) < b_max / t_{b_max}
#
# under ANY work-conserving policy, and UNSTABLE (backlog diverges) above that
# line under ANY policy. Non-work-conserving policies (FasterTransformer,
# vanilla vLLM) waste capacity and can diverge well BELOW this line.
#
# WHAT THIS SCRIPT DOES.
#   1. Stability contrast (paper Fig. 1 flavor): total requests in the system
#      over time for all four policies at one fixed load. Orca and Sarathi
#      stay flat; FasterTransformer and vanilla vLLM ramp up and away.
#   2. Theorem 2 boundary: sweep lambda across the predicted boundary and show
#      the long-run backlog GROWTH RATE flip from ~0 to the fluid prediction
#      (lambda*(m_p+m_d) - b_max/t_{b_max}) exactly at the boundary.
#   3. Rybko-Stolyar AI-agent network (paper Sec. 5.4): two LLM servers with
#      cyclic routing where a work-conserving policy plus the WRONG class
#      priority (via `ClassPriority`) DESTABILIZES the network even though
#      each server is under-loaded; reversing the priority restores stability.
#   4. A validation table: Fig. 8's exact batch compositions for all four
#      policies (deterministic, exact match) and the Theorem 2 boundary slope
#      against the fluid oracle (stochastic, checked at 4 standard errors).
#
# IMPORTANT EXCLUSION. The paper's Fig. 1 left panel is an EMPIRICAL A100
# latency trace at 14 queries per second (qps); its batch times are measured
# on real hardware. This example instead drives the batch clock with the
# FITTED staircase t_b = c + a*ceil(b/b_0). With those fitted constants the
# work-conserving stability boundary for the Fig. 1 workload sits at about
# 13.9 qps, so 14 qps is essentially critical; we therefore draw the contrast
# at 0.75 of the boundary (~10.4 qps), where the fitted model separates the
# policies cleanly. We reproduce the MODEL and its stability structure, not
# the hardware trace.
#
# Run from the repository root:
#   julia --project=examples examples/dai2026_llm_scheduling.jl
# Figures land in docs/figures/ and docs/src/manual/figures/. Total runtime is
# a few minutes; horizons and replicate counts below are sized so the
# validation table passes at 4 SE without a long wait.

using Concourse
using Statistics
using Plots
using Plots.PlotMeasures

# ---------------------------------------------------------------------------
# Constants.
#
# CALIBRATION NOTE. Only (c, a, b_0) below are calibrated — and they are
# published verbatim in the paper (Sec. 2.3): CodeLlama-34B, one A100 80GB
# GPU, tensor-parallel size 1. The staircase reads the round's total token
# load b through the frozen pseudo-mark `:tokens` (the round's aggregate token
# allocation), the same construction the round tests use.

const C0 = 11.28          # ms, fixed per-iteration cost c
const A0 = 35.47          # ms, marginal cost a per block of b_0 tokens
const B0 = 128            # tokens per hardware block b_0
const BMAX = 512          # default token budget b_max (a multiple of b_0)

# t_{b_max} = c + a*ceil(b_max/b_0) = 11.28 + 35.47*4 = 153.16 ms.
const T_BMAX = C0 + A0 * ceil(BMAX / B0)          # 153.16 ms
const CAP = BMAX / T_BMAX                          # tokens/ms, maximal token rate

# The batch-processing-time law: a Dirac (deterministic) duration reading the
# round's total token load b via the pseudo-mark :tokens.
dai_staircase() = Law(:Dirac; value=Const(C0) + Const(A0) * ceil(Mark(:tokens) / Const(Float64(B0))))

# Fig. 1 workload: Poisson requests with mean 129 prefill + 112 decode tokens
# (paper Fig. 1 caption). Deterministic per-request sizes at the means.
const FIG1_VP = 129.0
const FIG1_VD = 112.0
const FIG1_MPMD = FIG1_VP + FIG1_VD                # 241 tokens

# Theorem 2 boundary experiment: (v_p, v_d) = (100, 100), the paper/test
# parameterization (m_p + m_d = 200).
const BND_VP = 100.0
const BND_VD = 100.0
const BND_MPMD = BND_VP + BND_VD                   # 200 tokens
# Boundary arrival rate lambda*(m_p+m_d) = b_max/t_{b_max}  =>  lambda* below.
const LAMBDA_STAR = CAP / BND_MPMD                 # req/ms

# ---------------------------------------------------------------------------
# Model builders.
#
# All three are the plain round-station shape: an FCFS buffer, one round clock,
# the staircase duration, and (v_p, v_d) work phases. The only thing that
# changes across experiments is the policy and the arrival/mark setup.

# Single GPU, Poisson arrivals, deterministic per-request (v_p, v_d), one
# round-based station under `policy`. Used for both the Fig. 1 contrast and
# the Theorem 2 boundary sweep.
function gpu_model(policy; vp, vd)
    net = QueueNetwork(; param_names=(:lambda,))
    source!(net, :arrive;
        interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(vp)), v_d=Law(:Dirac; value=Const(vd))))
    station!(net, :gpu;
        rounds=Rounds(; policy, duration=dai_staircase(), work=(:v_p, :v_d)))
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    return compile(net)
end

# Paper Fig. 8: a five-request worked example, batch by batch. Requests A, B, C
# are already decoding (prefill done) with decode lengths 2, 4, 3; D and E
# (one prefill token, one decode token each) arrive during the first round via
# a :feed relay. Every policy sees the paper's exact configuration at its
# second round boundary. (Copied from test/test_rounds_papers.jl so the
# example inherits the verified constants.)
function fig8_model(policy)
    net = QueueNetwork(; param_names=())
    station!(net, :gpu;
        rounds=Rounds(; policy, duration=Law(:Dirac; value=Const(1.0)), work=(:v_p, :v_d)))
    station!(net, :feed; service=Law(:Dirac; value=Const(0.25)))
    sink!(net, :done)
    route!(net, :feed, Always(:gpu))
    route!(net, :gpu, Always(:done))
    for vd in (2.0, 4.0, 3.0)   # A, B, C in populate (= job id) order
        populate!(net, :gpu, 1;
            mark=MarkLaw(; v_p=Law(:Dirac; value=Const(0.0)), v_d=Law(:Dirac; value=Const(vd))))
    end
    populate!(net, :feed, 2;    # D (id 4), then E (id 5)
        mark=MarkLaw(; v_p=Law(:Dirac; value=Const(1.0)), v_d=Law(:Dirac; value=Const(1.0))))
    return compile(net)
end

# Paper Sec. 5.4: the Rybko-Stolyar network of two LLM servers with cyclic
# routing. Type A (class 1) does a SHORT task at server 1 then a LONG task at
# server 2; type B (class 2) flows the reverse way. A per-hop `remark` redraws
# the hop's (v_p, v_d) sizes on deposit so the long prefill lands on each
# type's SECOND hop. Both servers run work-conserving mixed Sarathi with
# b_max = 768 and t_b = 1 ms, wrapped in `ClassPriority`.
#   :destabilizing — each server prioritizes the class EXITING through it
#       (s1 favors B, s2 favors A): the paper's unstable configuration.
#   :stabilizing   — the reversed priority, which restores stability.
# (Copied from test/testmodels.jl.)
function rybko_stolyar(; budget=768, priorities=:destabilizing)
    priorities in (:destabilizing, :stabilizing) ||
        throw(ArgumentError("priorities must be :destabilizing or :stabilizing"))
    o1, o2 = priorities === :destabilizing ? ([2.0, 1.0], [1.0, 2.0]) : ([1.0, 2.0], [2.0, 1.0])
    net = QueueNetwork(; param_names=(:lambda,))
    for (nm, cls) in ((:arrive_a, 1.0), (:arrive_b, 2.0))
        source!(net, nm;
            interarrival=Law(:Exponential; scale=inv(Param(:lambda))),
            mark=MarkLaw(; class=Law(:Dirac; value=Const(cls))))
    end
    dur = Law(:Dirac; value=Const(1.0))
    station!(net, :s1;
        remark=(v_p=Law(:Poisson; lambda=Const(-448.0) + Const(480.0) * Mark(:class)),
                v_d=Law(:Poisson; lambda=Const(32.0))),
        rounds=Rounds(; policy=ClassPriority(Sarathi(; budget); by=:class, order=o1),
                      duration=dur, work=(:v_p, :v_d)))
    station!(net, :s2;
        remark=(v_p=Law(:Poisson; lambda=Const(992.0) + Const(-480.0) * Mark(:class)),
                v_d=Law(:Poisson; lambda=Const(32.0))),
        rounds=Rounds(; policy=ClassPriority(Sarathi(; budget); by=:class, order=o2),
                      duration=dur, work=(:v_p, :v_d)))
    sink!(net, :done)
    route!(net, :arrive_a, Always(:s1))
    route!(net, :arrive_b, Always(:s2))
    route!(net, :s1, ByMark(Mark(:class), [1.5], [:s2, :done]))
    route!(net, :s2, ByMark(Mark(:class), [1.5], [:done, :s1]))
    return compile(net)
end

# ---------------------------------------------------------------------------
# Measurement folds over the replayed record.
#
# `replay(m, rec)` re-runs the record and returns the state after every firing
# (states[1] is the initial state, states[i+1] follows firing i at time
# rec.time[i]). Everything below reads those states — no counters bolted into
# the simulator.

# Total unprocessed tokens in the system at a state: remaining work counters
# for jobs active at a round station, the full (v_p, v_d) profile for everyone
# still waiting. This is the |X(n)| of Theorem 2.
function tokens_left(st)
    tot = 0
    for (j, marks) in st.jobs
        w = get(st.work, j, nothing)
        tot += w === nothing ? Int(marks.v_p) + Int(marks.v_d) : sum(w)
    end
    return tot
end

# (times, total-requests-in-system) at every firing.
function nsys_trajectory(m, rec)
    sts = replay(m, rec)
    return rec.time, [number_in_system(sts[i + 1]) for i in eachindex(rec.key)]
end

# (times, total-unprocessed-tokens) at every firing.
function backlog_trajectory(m, rec)
    sts = replay(m, rec)
    return rec.time, [tokens_left(sts[i + 1]) for i in eachindex(rec.key)]
end

# Value of a step trajectory at time t (last sample at or before t).
function at_time(ts, vs, t)
    i = searchsortedlast(ts, t)
    return i == 0 ? 0 : vs[i]
end

# Maximum of a step trajectory over the window (lo, hi].
window_max(ts, vs, lo, hi) = maximum((vs[i] for i in eachindex(ts) if lo < ts[i] <= hi); init=0)

# The committed round plans of station g, in commit order (object identity
# separates consecutive rounds even when their content coincides).
function committed_plans(m, rec, g)
    plans = RoundPlan[]
    for st in replay(m, rec)
        p = st.roundplan[g]
        p === nothing && continue
        (isempty(plans) || plans[end] !== p) && push!(plans, p)
    end
    return plans
end

# ---------------------------------------------------------------------------
# Validation part 1: Fig. 8 batch compositions, exact for all four policies.
#
# The figure fixes only the five decode lengths (A..E = 2,4,3,1,1). With one
# prefill token each for D and E, b_max = 4 reproduces the vLLM,
# FasterTransformer, and Sarathi rows EXACTLY, and b_max = 5 the Orca row (no
# single budget fits all four: the figure is schematic about the budget, not
# the compositions). Each entry like "Ad" means request A contributes a decode
# token in that batch; "Dp" a prefill token.

const FIG8_EXPECTED = Dict(
    "vllm" => [["Ad", "Bd", "Cd"], ["Dp", "Ep"], ["Ad", "Bd", "Cd", "Dd"],
               ["Bd", "Cd", "Ed"], ["Bd"]],
    "orca" => [["Ad", "Bd", "Cd"], ["Ad", "Bd", "Cd", "Dp", "Ep"],
               ["Bd", "Cd", "Dd", "Ed"], ["Bd"]],
    "ft" => [["Ad", "Bd", "Cd"], ["Ad", "Bd", "Cd"], ["Bd", "Cd"], ["Bd"],
             ["Dp", "Ep"], ["Dd", "Ed"]],
    "sarathi" => [["Ad", "Bd", "Cd"], ["Ad", "Bd", "Cd", "Dp"],
                  ["Bd", "Cd", "Dd", "Ep"], ["Bd", "Ed"]])

function fig8_compositions(policy)
    m = fig8_model(policy)
    rec = simulate(m, Float64[], 10.0; seed=1)
    g = m.names[:gpu]
    plans = committed_plans(m, rec, g)
    name(j) = string("ABCDE"[Int(j)])
    return [sort([name(j) * (av[1] > 0 ? "p" : "d") for (j, av) in p.alloc]) for p in plans]
end

# ---------------------------------------------------------------------------
# Validation part 2: the Theorem 2 boundary slope against the fluid oracle.
#
# Above the boundary the fluid limit predicts the total unprocessed tokens to
# grow linearly at rate lambda*(m_p+m_d) - b_max/t_{b_max}; below it, the
# backlog is bounded (rate 0). We measure the empirical second-half growth
# rate (backlog(T) - backlog(T/2)) / (T/2) across seeds and compare it to the
# fluid prediction at 4 standard errors.

fluid_slope(λ) = max(0.0, λ * BND_MPMD - CAP)      # tokens/ms

function boundary_slope(policy, λ, T, nseeds; seed0=100)
    m = gpu_model(policy; vp=BND_VP, vd=BND_VD)
    slopes = Float64[]
    for s in 1:nseeds
        rec = simulate(m, [λ], T; seed=seed0 + s)
        ts, vs = backlog_trajectory(m, rec)
        push!(slopes, (at_time(ts, vs, T) - at_time(ts, vs, T / 2)) / (T / 2))
    end
    return mean(slopes), std(slopes) / sqrt(nseeds)
end

# ---------------------------------------------------------------------------
# The validation table.

function check_table()
    println("== validation 1: Fig. 8 batch compositions (deterministic, exact match) ==")
    all_ok = true
    for (label, pol) in (("vllm", VanillaVLLM(; budget=4)), ("orca", Orca(; budget=5)),
                         ("ft", FasterTransformerRule(; budget=4)), ("sarathi", Sarathi(; budget=4)))
        got = fig8_compositions(pol)
        ok = got == FIG8_EXPECTED[label]
        all_ok &= ok
        println(rpad(uppercase(label), 8), ok ? "PASS" : "FAIL",
                "  ($(length(got)) batches)  ", ok ? "" : string(got))
    end

    println("\n== validation 2: Theorem 2 boundary slope vs fluid oracle (stochastic, 4 SE) ==")
    println("  lambda* = ", round(LAMBDA_STAR, digits=6), " req/ms  (",
            round(LAMBDA_STAR * 1000, digits=2), " req/s);  b_max/t_bmax = ",
            round(CAP, digits=4), " tokens/ms")
    println(rpad("lambda/lambda*", 16), rpad("measured slope", 24),
            rpad("fluid oracle", 16), "|z|")
    T = 120_000.0
    for frac in (0.9, 1.1, 1.2)
        λ = frac * LAMBDA_STAR
        est, se = boundary_slope(Sarathi(; budget=BMAX), λ, T, 6; seed0=Int(round(1000 * frac)))
        orc = fluid_slope(λ)
        z = abs(est - orc) / se
        all_ok &= (z <= 4)
        println(rpad(frac, 16),
                rpad(string(round(est, digits=4), " ± ", round(se, digits=4)), 24),
                rpad(round(orc, digits=4), 16), round(z, digits=2))
    end
    println("\nvalidation table ", all_ok ? "PASSED" : "FAILED")
    return all_ok
end

# ---------------------------------------------------------------------------
# Figure 1: the stability contrast (paper Fig. 1 flavor). Total requests in
# the system over time for all four policies at load 0.75 * lambda_boundary of
# the Fig. 1 workload. Work-conserving Orca and Sarathi stay flat; the
# non-work-conserving FasterTransformer and vanilla vLLM ramp up and away.

const FIG1_LAMBDA_STAR = CAP / FIG1_MPMD           # req/ms boundary for 129+112
const FIG1_LOAD = 0.75                             # fraction of boundary

function figure_contrast()
    λ = FIG1_LOAD * FIG1_LAMBDA_STAR
    T = 90_000.0                                   # ms
    plt = plot(size=(820, 500), dpi=150,
               left_margin=6mm, bottom_margin=6mm, top_margin=4mm, right_margin=4mm,
               xlabel="time (seconds)", ylabel="requests in the system",
               title="Stability contrast at $(round(λ * 1000, digits=1)) qps " *
                     "(0.75x the work-conserving boundary)", titlefontsize=10,
               legend=:topleft)
    styling = (("Sarathi (work-conserving)", :seagreen, :solid),
               ("Orca (work-conserving)", :dodgerblue, :solid),
               ("FasterTransformer (not WC)", :orange, :dash),
               ("vanilla vLLM (not WC)", :crimson, :dash))
    finals = Dict{String,Int}()
    for ((label, col, ls), pol) in zip(styling,
            (Sarathi(; budget=BMAX), Orca(; budget=BMAX),
             FasterTransformerRule(; budget=BMAX), VanillaVLLM(; budget=BMAX)))
        m = gpu_model(pol; vp=FIG1_VP, vd=FIG1_VD)
        rec = simulate(m, [λ], T; seed=5)
        ts, ns = nsys_trajectory(m, rec)
        plot!(plt, ts ./ 1000, ns; lw=2, color=col, ls=ls, label=label)
        finals[label] = isempty(ns) ? 0 : ns[end]
    end
    savefig_both(plt, "dai2026_stability_contrast.png")
    return finals
end

# ---------------------------------------------------------------------------
# Figure 2: the Theorem 2 boundary. Left panel — backlog(t) for a stable
# (0.9 lambda*) and an unstable (1.1 lambda*) run, with the fluid growth line
# overlaid on the unstable one. Right panel — measured second-half backlog
# growth rate vs lambda/lambda*, with the fluid prediction curve and the
# boundary at lambda/lambda* = 1.

function figure_boundary()
    T = 150_000.0
    m = gpu_model(Sarathi(; budget=BMAX); vp=BND_VP, vd=BND_VD)

    plt = plot(layout=(1, 2), size=(1000, 440), dpi=150,
               left_margin=6mm, bottom_margin=7mm, top_margin=4mm, right_margin=4mm)

    # Left: two representative backlog trajectories.
    for (frac, col, lab) in ((0.9, :seagreen, "0.9 lambda* (stable)"),
                             (1.1, :crimson, "1.1 lambda* (unstable)"))
        rec = simulate(m, [frac * LAMBDA_STAR], T; seed=7)
        ts, vs = backlog_trajectory(m, rec)
        plot!(plt[1], ts ./ 1000, vs ./ 1000; lw=2, color=col, label=lab)
    end
    # Fluid growth line for the unstable run (slope in tokens/ms -> k tokens/s).
    s = fluid_slope(1.1 * LAMBDA_STAR)
    plot!(plt[1], [0, T] ./ 1000, [0, s * T] ./ 1000; lw=1.5, ls=:dot, color=:black,
          label="fluid slope $(round(s, digits=3)) tok/ms")
    plot!(plt[1]; xlabel="time (seconds)", ylabel="unprocessed tokens (thousands)",
          title="Backlog below vs above the boundary", titlefontsize=10, legend=:topleft)

    # Right: slope vs load.
    fracs = [0.6, 0.8, 0.9, 1.0, 1.1, 1.2, 1.4]
    est = Float64[]
    se = Float64[]
    for frac in fracs
        e, sderr = boundary_slope(Sarathi(; budget=BMAX), frac * LAMBDA_STAR, T, 6;
                                  seed0=Int(round(2000 * frac)))
        push!(est, e)
        push!(se, sderr)
    end
    grid = range(0.5, 1.5; length=200)
    plot!(plt[2], collect(grid), [fluid_slope(f * LAMBDA_STAR) for f in grid];
          lw=2, color=:black, label="fluid prediction",
          xlabel="load  lambda / lambda*", ylabel="backlog growth rate (tokens/ms)",
          title="Growth rate flips at the boundary", titlefontsize=10, legend=:topleft)
    scatter!(plt[2], fracs, est; yerror=4 .* se, ms=5, color=:crimson,
             label="simulated (4 SE)")
    vline!(plt[2], [1.0]; ls=:dash, color=:gray, label="Theorem 2 boundary")

    savefig_both(plt, "dai2026_theorem2_boundary.png")
    return (fracs=fracs, est=est, se=se)
end

# ---------------------------------------------------------------------------
# Figure 3: the Rybko-Stolyar AI-agent network (paper Sec. 5.4). Total
# unprocessed tokens over time under the destabilizing priority (grows without
# bound, with geometrically growing oscillations) vs the stabilizing priority
# (bounded). Both servers are individually under-loaded (rho = 0.9) and both
# use a work-conserving policy — only the class-priority direction differs.

function figure_rybko()
    λh = 0.9 * 768 / 608                            # per-type rate at rho = 0.9
    T = 4500.0

    plt = plot(size=(860, 500), dpi=150,
               left_margin=8mm, bottom_margin=6mm, top_margin=4mm, right_margin=4mm,
               xlabel="time (ms)", ylabel="unprocessed tokens (thousands)",
               title="Rybko-Stolyar network at rho = 0.9: priority direction " *
                     "decides stability", titlefontsize=10, legend=:topleft)
    out = Dict{Symbol,Int}()
    for (pri, col, lab) in ((:destabilizing, :crimson,
                             "destabilizing priority (work-conserving, UNSTABLE)"),
                            (:stabilizing, :seagreen,
                             "stabilizing priority (work-conserving, stable)"))
        m = rybko_stolyar(; priorities=pri)
        rec = simulate(m, [λh], T; seed=7)
        ts, vs = backlog_trajectory(m, rec)
        plot!(plt, ts, vs ./ 1000; lw=2, color=col, label=lab)
        out[pri] = window_max(ts, vs, 0.0, T)
    end
    savefig_both(plt, "dai2026_rybko_stolyar.png")
    return out
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
    ok = check_table()

    println("\n== Figure 1: stability contrast, four policies ==")
    finals = figure_contrast()
    for k in ("Sarathi (work-conserving)", "Orca (work-conserving)",
              "FasterTransformer (not WC)", "vanilla vLLM (not WC)")
        println("  ", rpad(k, 32), " requests in system at end: ", finals[k])
    end
    println("figures: docs/figures/dai2026_stability_contrast.png (+ manual copy)")

    println("\n== Figure 2: Theorem 2 stability boundary ==")
    b = figure_boundary()
    for (f, e, s) in zip(b.fracs, b.est, b.se)
        println("  lambda/lambda* = ", rpad(f, 5), " slope = ",
                rpad(string(round(e, digits=4), " ± ", round(s, digits=4)), 22),
                " fluid = ", round(fluid_slope(f * LAMBDA_STAR), digits=4))
    end
    println("figures: docs/figures/dai2026_theorem2_boundary.png (+ manual copy)")

    println("\n== Figure 3: Rybko-Stolyar AI-agent network ==")
    rs = figure_rybko()
    println("  destabilizing peak tokens: ", rs[:destabilizing])
    println("  stabilizing   peak tokens: ", rs[:stabilizing])
    println("  ratio (destab / stab): ",
            round(rs[:destabilizing] / max(rs[:stabilizing], 1), digits=1), "x")
    println("figures: docs/figures/dai2026_rybko_stolyar.png (+ manual copy)")

    println("\nDONE. validation table ", ok ? "PASSED" : "FAILED")
end
