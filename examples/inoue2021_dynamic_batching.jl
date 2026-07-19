# A batch-service model of a single GPU inference server with DYNAMIC BATCHING,
# after Inoue, "Queueing analysis of GPU-based inference servers with dynamic
# batching" (Performance Evaluation 2021, arXiv:1912.06322).
#
# GPU = graphics processing unit. FCFS = first come, first served.
# SE = standard error. cdf = cumulative distribution function.
#
# What the server does. Inference requests (image classifications, say) arrive
# to one GPU as a Poisson process of rate lambda. A GPU is a wide parallel
# processor: it runs the SAME neural network over many inputs at once almost as
# cheaply as over one input, because the fixed cost of launching the
# computation (moving weights on-chip, starting thousands of threads) is paid
# once per batch rather than once per request. Table 1 of the paper makes this
# concrete: on a Tesla V100 a batch of 128 images is processed at 6275
# images/sec versus 476 images/sec for a batch of 1 — a batch of 128 costs only
# about 13x the wall-clock time of a single image, not 128x. So it pays to wait
# a moment, gather the requests that have piled up, and process them together.
#
# The dynamic batching rule. This is the scheduling policy the paper analyzes
# (Section 2): whenever the server becomes idle and at least one job is waiting,
# it sweeps up ALL waiting jobs into a single batch and starts processing them
# at once. No fixed batch size, no timer — the batch is exactly whatever has
# accumulated during the previous batch's processing. Under heavy load a long
# batch is running, more requests pile up behind it, and the next batch is
# large; under light load batches are small (often size 1). This is precisely
# Concourse's `Batching(min = 1, max = typemax(Int))` — the "gather everything
# on idle" default. A finite maximum batch size `bmax` caps the sweep at `bmax`
# jobs, which we study in Figure 2.
#
# The processing-time law. The paper's Assumption 4: a batch of size b takes a
# DETERMINISTIC time that is affine in the batch size,
#
#       tau(b) = alpha * b + tau_0        (milliseconds),
#
# where tau_0 is the per-batch launch overhead and alpha the marginal cost of
# one more request in the batch. Deterministic because a DNN applies a fixed
# sequence of operations to a fixed-shape input regardless of the data, so the
# time depends only on the batch size. The paper fits (alpha, tau_0) to Table 1
# by least squares and reports alpha = 0.1438 ms/job, tau_0 = 1.8874 ms for the
# Tesla V100 (mixed precision), with coefficient of determination R^2 ~ 0.9998.
# We use exactly those PUBLISHED numbers — nothing here is calibrated by us.
#
# Why the batch size is the MARK. When Concourse forms a batch it mints one
# synthetic job carrying a single mark, `batchsize = b`. The batch's service
# clock reads that mark, so the affine law `tau_0 + alpha * batchsize` is one
# line and needs no new machinery. On completion the b members route out
# individually. See docs/src/manual/batching.md.
#
# The counter-intuitive result the paper proves. Because the server speeds up
# as the batch grows, the server utilization 1 - pi_0 (fraction of time busy)
# is NOT the traffic intensity rho = lambda*alpha, as it would be in an
# ordinary M/G/1 queue. It climbs close to 1 even at moderate rho, because when
# the server is briefly idle a single arrival starts a size-1 batch, which is
# the slowest, least efficient mode. This is why the paper's tight upper bound
# phi_1 (obtained by pretending pi_0 = 0) is so accurate across most of the
# load range.
#
# What this script does.
#   1. A model builder: one Poisson source, one FCFS batch station whose Dirac
#      service law reads `batchsize`, gather-everything batching.
#   2. Two closed-form oracles, both independent of the simulator:
#        - the EXACT mean latency, from the stationary distribution of the
#          processed-batch-size Markov chain B_{n+1} = A_n + 1{A_n = 0} with
#          A_n | B_n = b ~ Poisson(lambda*(alpha*b + tau_0)) (Eqs. 3-5, 36);
#        - Theorem 2's closed-form upper bounds phi_0 (Eq. 41), phi_1 (Eq. 42),
#          and phi = min(phi_0, phi_1) (Eq. 43).
#   3. A validation table: simulated mean latency (via Little's law, at 4 SE)
#      vs the exact oracle and the bound, over a load sweep.
#   4. Figure 1: mean latency and server utilization vs normalized load rho
#      (reproduces the paper's Figs. 4 and 5, Tesla V100 fit).
#   5. Figure 2: mean latency vs arrival rate for several finite maximum batch
#      sizes bmax against the infinite-bmax bound (reproduces the paper's
#      Fig. 8).
#   6. A gradient showcase: d E[integral of L dt] / d lambda by the score
#      estimator, checked against finite differences. Batching is score
#      territory, not pathwise IPA (integer batch sizes are discontinuous) --
#      an honest boundary, matching docs/src/manual/batching.md.
#
# Run from the repository root:
#   julia --project=examples examples/inoue2021_dynamic_batching.jl
# Figures land in docs/figures/ and docs/src/manual/figures/. Total runtime is
# a few minutes; HORIZON/NREPS below are sized so the validation table passes
# at 4 SE without a long wait.

using Concourse
using Statistics
using Distributions: Poisson, pdf
using Plots
using Plots.PlotMeasures

# ClockGradients ships with Concourse but is not a direct dependency of the
# examples project; reach it through the Concourse namespace.
const CG = Concourse.ClockGradients
using Concourse: replay_model

# ---------------------------------------------------------------------------
# Constants.
#
# PUBLISHED, not calibrated. alpha and tau_0 are the paper's own least-squares
# fit to the Tesla V100 (mixed precision) row of Table 1, reported in Sec. 3.3
# just after Assumption 4: alpha = 0.1438 ms/job, tau_0 = 1.8874 ms. Times are
# in milliseconds throughout, exactly as the paper plots them. Arrival rate
# lambda is in jobs/ms; the normalized load is rho = lambda*alpha, and the
# stability condition is rho < 1 (Eq. 27).

const ALPHA = 0.1438       # ms per job in the batch (published V100 fit)
const TAU0  = 1.8874       # ms fixed per-batch overhead (published V100 fit)

# The Tesla P4 (INT8) fit from the same paragraph, used only for a note.
const ALPHA_P4 = 0.5833
const TAU0_P4  = 1.4284

const HORIZON = 6000.0     # simulated milliseconds per replicate
const NREPS   = 16         # independent replicates per estimate

# ---------------------------------------------------------------------------
# The model. A Poisson source feeds a single FCFS station whose service law is
# DETERMINISTIC given the batch size: tau_0 + alpha * batchsize. Batching() is
# gather-everything (min = 1, max = typemax); a finite bmax caps the sweep.

function inoue_model(; α = ALPHA, τ0 = TAU0, bmax = typemax(Int))
    net = QueueNetwork(param_names = (:lambda,))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
    station!(net, :gpu;
             service = Law(:Dirac, value = Const(τ0) + Const(α) * Mark(:batchsize)),
             batching = Batching(min = 1, max = bmax))
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    compile(net)
end

# ---------------------------------------------------------------------------
# Oracle 1: the EXACT mean latency (infinite bmax).
#
# The sequence of processed batch sizes (B_n) is a Markov chain on {1, 2, ...}
# with B_{n+1} = A_n + 1{A_n = 0}, where A_n | B_n = b is the number of Poisson
# arrivals during the batch's deterministic processing time tau(b) = alpha*b +
# tau_0, i.e. A_n | B_n = b ~ Poisson(lambda*(alpha*b + tau_0)) (Eqs. 3-5). We
# truncate the chain at B states, solve for the stationary distribution by
# linear algebra, and read off E[B] and E[B^2]. Then Eq. 36 gives the exact
# mean latency
#   E[W] = alpha + tau_0 + (1 + 2*lambda*alpha)(E[B^2] - E[B]) / (2*lambda*E[B]).
# This oracle touches nothing in the simulator: only Poisson pmfs and a solve.

function batch_moments(λ, α, τ0; B = 600)
    M = zeros(B, B)                 # transposed transition matrix minus I
    for b in 1:B
        A = Poisson(λ * (α * b + τ0))
        row = zeros(B)
        row[1] = pdf(A, 0) + pdf(A, 1)          # A = 0 and A = 1 both land at B_{n+1} = 1
        for k in 2:(B - 1)
            row[k] = pdf(A, k)
        end
        row[B] = max(0.0, 1.0 - sum(row))       # pile the truncated tail onto state B
        for k in 1:B
            M[k, b] += row[k]
        end
        M[b, b] -= 1.0
    end
    π = [M; ones(1, B)] \ [zeros(B); 1.0]
    EB  = sum(b * π[b] for b in 1:B)
    EB2 = sum(b^2 * π[b] for b in 1:B)
    (EB, EB2)
end

function exact_latency(λ, α, τ0; B = 600)
    EB, EB2 = batch_moments(λ, α, τ0; B)
    α + τ0 + (1 + 2 * λ * α) * (EB2 - EB) / (2 * λ * EB)
end

# Server utilization 1 - pi_0 from Eq. 38: 1 - pi_0 = lambda*alpha +
# lambda*tau_0/E[B]. This is the fraction of time the server is busy -- NOT the
# traffic intensity, because a briefly-idle server restarts on a slow size-1
# batch. Its trivial upper bound is min(1, lambda*(alpha + tau_0)) (from Eq. 39).
function exact_utilization(λ, α, τ0; B = 600)
    EB, _ = batch_moments(λ, α, τ0; B)
    λ * α + λ * τ0 / EB
end
util_upper(λ, α, τ0) = min(1.0, λ * (α + τ0))

# ---------------------------------------------------------------------------
# Oracle 2: Theorem 2's closed-form upper bounds (infinite bmax).
#   phi_0 (Eq. 41): tight for SMALL load (obtained by setting E[B] = 1).
#   phi_1 (Eq. 42): tight for MODERATE-TO-HIGH load (obtained by setting pi_0 = 0).
#   phi = min(phi_0, phi_1) (Eq. 43); phi_0 <= phi_1 iff lambda <= 1/(alpha+tau_0).
# The paper's central claim is E[W] <= phi and, empirically, E[W] ~ phi.

φ0(λ, α, τ0) = (α + τ0) / (2 * (1 - λ * α)) * (1 + 2 * λ * τ0 + (1 - λ * τ0) / (1 + λ * α))
φ1(λ, α, τ0) = 1.5 * τ0 / (1 - λ * α) + (α / 2) * (λ * α + 2) / (1 - λ^2 * α^2)
φ(λ, α, τ0)  = min(φ0(λ, α, τ0), φ1(λ, α, τ0))

# Maximum stable arrival rate for a finite maximum batch size bmax: the server
# throughput saturates at mu[bmax] = bmax/(alpha*bmax + tau_0), so lambda must
# stay below it. For bmax = infinity this is 1/alpha.
mu_cap(bmax, α, τ0) = bmax / (α * bmax + τ0)

# ---------------------------------------------------------------------------
# Measurement. Mean latency by Little's law: L = time-average number in system
# (which counts batch MEMBERS, not the synthetic batch job), and E[W] = L /
# lambda -- exactly the paper's Lemma 2 identity E[L] = lambda*E[W]. This reads
# the replayed record; no counters are bolted into the simulator.

meanL(m, λ, rec) = time_average(number_in_system, m, rec)

function replicate(f, m, λ, horizon, nreps; seed0 = 1000)
    vals = [f(simulate(m, [λ], horizon; seed = seed0 + r)) for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

# Mean latency estimate and SE.
meanW(m, λ, horizon, nreps; seed0 = 1000) =
    replicate(rec -> meanL(m, λ, rec) / λ, m, λ, horizon, nreps; seed0)

# Server-busy fraction estimate and SE. number_at counts residents of the
# station (a live batch is ONE resident); busy means at least one resident.
function busy_fraction(m)
    q = Concourse.number_at(m.names[:gpu])
    s -> (q(s) > 0 ? 1.0 : 0.0)
end
meanBusy(m, λ, horizon, nreps; seed0 = 1000) =
    replicate(rec -> time_average(busy_fraction(m), m, rec), m, λ, horizon, nreps; seed0)

# ---------------------------------------------------------------------------
# 1. Validation: simulated mean latency vs the exact oracle and the bound.

const RHO_TABLE = (0.3, 0.5, 0.7, 0.8, 0.9)

function check_table()
    println("Tesla V100 fit: alpha = $ALPHA ms, tau_0 = $TAU0 ms, infinite bmax")
    println(rpad("rho", 6), rpad("lambda", 9), rpad("simulated W (ms)", 24),
            rpad("exact W (ms)", 14), rpad("bound phi", 12), "|z|")
    ok = true
    for ρ in RHO_TABLE
        λ = ρ / ALPHA
        m = inoue_model()
        est, se = meanW(m, λ, HORIZON, NREPS; seed0 = 1000 + round(Int, 1000ρ))
        ex = exact_latency(λ, ALPHA, TAU0)
        b  = φ(λ, ALPHA, TAU0)
        z  = abs(est - ex) / se
        ok &= (z <= 4) && (est <= b + 4 * se)
        println(rpad(ρ, 6), rpad(round(λ, digits = 3), 9),
                rpad(string(round(est, digits = 3), " ± ", round(se, digits = 3)), 24),
                rpad(round(ex, digits = 3), 14),
                rpad(round(b, digits = 3), 12),
                round(z, digits = 2))
    end
    println(ok ? "PASS: all points within 4 SE of the exact oracle and under the bound." :
                 "FAIL: a point missed the 4 SE / bound check.")
    ok
end

# ---------------------------------------------------------------------------
# 2. Figure 1: mean latency and server utilization vs normalized load rho.
#    Left panel reproduces the paper's Fig. 4 (E[W] with bounds phi_0, phi_1);
#    right panel reproduces Fig. 5 (utilization near 1 even at moderate load).

const RHO_POINTS = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

function figure_latency()
    # Simulated points.
    west = Float64[]; wse = Float64[]
    uest = Float64[]; use_ = Float64[]
    for ρ in RHO_POINTS
        λ = ρ / ALPHA
        m = inoue_model()
        we, ws = meanW(m, λ, HORIZON, NREPS; seed0 = 2000 + round(Int, 1000ρ))
        ue, us = meanBusy(m, λ, HORIZON, NREPS; seed0 = 2000 + round(Int, 1000ρ))
        push!(west, we); push!(wse, ws)
        push!(uest, ue); push!(use_, us)
    end
    # Closed-form curves over a fine rho grid.
    fine = 0.02:0.01:0.94
    λf = collect(fine) ./ ALPHA
    b0  = [φ0(λ, ALPHA, TAU0) for λ in λf]
    b1  = [φ1(λ, ALPHA, TAU0) for λ in λf]
    exW = [exact_latency(λ, ALPHA, TAU0) for λ in λf]
    exU = [exact_utilization(λ, ALPHA, TAU0) for λ in λf]
    ubU = [util_upper(λ, ALPHA, TAU0) for λ in λf]

    plt = plot(layout = (1, 2), size = (980, 440), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 4mm)
    # Left: latency.
    plot!(plt[1], collect(fine), b0; lw = 2, ls = :dash, color = :orange,
          label = "upper bound phi_0 (Eq. 41)",
          xlabel = "normalized load rho = lambda*alpha", ylabel = "mean latency E[W] (ms)",
          title = "Mean latency vs load (Tesla V100)", titlefontsize = 10, legend = :topleft,
          ylims = (0, 40))
    plot!(plt[1], collect(fine), b1; lw = 2, ls = :dash, color = :purple,
          label = "upper bound phi_1 (Eq. 42)")
    plot!(plt[1], collect(fine), exW; lw = 2.5, color = :black, label = "exact E[W] (Markov chain)")
    scatter!(plt[1], RHO_POINTS, west; yerror = 4 .* wse, ms = 4, color = :steelblue,
             label = "simulated (4 SE)")
    # Right: utilization.
    plot!(plt[2], collect(fine), exU; lw = 2.5, color = :black,
          label = "exact utilization 1 - pi_0 (Eq. 38)",
          xlabel = "normalized load rho = lambda*alpha", ylabel = "server utilization 1 - pi_0",
          title = "Utilization runs ahead of load", titlefontsize = 10, legend = :bottomright,
          ylims = (0, 1.02))
    plot!(plt[2], collect(fine), ubU; lw = 2, ls = :dash, color = :orange,
          label = "upper bound min(1, lambda(alpha+tau_0))")
    plot!(plt[2], collect(fine), collect(fine); lw = 1.5, ls = :dot, color = :gray,
          label = "traffic intensity rho (an M/G/1 would sit here)")
    scatter!(plt[2], RHO_POINTS, uest; yerror = 4 .* use_, ms = 4, color = :crimson,
             label = "simulated (4 SE)")

    savefig_both(plt, "inoue2021_latency.png")
    (west = west, wse = wse, uest = uest)
end

# ---------------------------------------------------------------------------
# 3. Figure 2: finite maximum batch size (reproduces the paper's Fig. 8). For
#    each bmax the simulated mean latency tracks the infinite-bmax bound phi
#    while the system is moderately loaded, then peels away and diverges as
#    lambda approaches the bmax-specific stability boundary mu[bmax].

const BMAX_LIST = [4, 8, 16, typemax(Int)]
const BMAX_COLORS = [:seagreen, :darkorange, :mediumpurple, :black]

function figure_bmax()
    plt = plot(size = (820, 500), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 4mm,
               xlabel = "arrival rate lambda (jobs/ms)", ylabel = "mean latency E[W] (ms)",
               title = "Effect of the maximum batch size bmax (Tesla V100)",
               titlefontsize = 11, legend = :topleft, ylims = (0, 60))
    # The infinite-bmax closed-form bound phi as the reference curve.
    fineλ = 0.3:0.02:6.6
    plot!(plt, collect(fineλ), [φ(λ, ALPHA, TAU0) for λ in fineλ]; lw = 2.5, color = :black,
          ls = :dash, label = "bound phi (bmax = infinity)")

    results = Dict{Int,Any}()
    for (bmax, col) in zip(BMAX_LIST, BMAX_COLORS)
        cap = mu_cap(bmax, ALPHA, TAU0)          # stability boundary for this bmax
        # Sample lambda up to ~92% of the boundary.
        λmax = 0.92 * cap
        λs = collect(range(0.5, λmax, length = 8))
        est = Float64[]; se = Float64[]
        for λ in λs
            m = inoue_model(bmax = bmax)
            e, s = meanW(m, λ, HORIZON, NREPS; seed0 = 4000 + round(Int, 100λ) + bmax % 1000)
            push!(est, e); push!(se, s)
        end
        lab = bmax == typemax(Int) ? "bmax = infinity (sim)" : "bmax = $bmax (sim)"
        scatter!(plt, λs, est; yerror = 4 .* se, ms = 4, color = col, label = lab)
        plot!(plt, λs, est; lw = 1, color = col, label = "")
        if bmax != typemax(Int)
            vline!(plt, [cap]; ls = :dot, lw = 1.2, color = col, label = "")
        end
        results[bmax] = (λs = λs, est = est, se = se, cap = cap)
    end
    savefig_both(plt, "inoue2021_bmax.png")
    results
end

# ---------------------------------------------------------------------------
# 4. Gradient showcase: d E[integral of L dt] / d lambda.
#
# lambda enters only the Exponential arrival clock, a derivative-carrying
# family, so it has a SCORE channel and the score (likelihood-ratio) estimator
# picks it up. Batching is exactly where PATHWISE IPA fails: the batch size is
# integer-valued, and a perturbation that reorders one arrival against a batch
# formation changes the batch composition by a whole job -- a discontinuity the
# IPA interchange argument does not cover (see docs/src/manual/batching.md,
# "Estimators"). So this validates the score estimator against a paired-seed
# finite-difference baseline; there is no IPA curve to show for a batch model.

function gradient_showcase(; ρ = 0.5, H = 3000.0, R = 200)
    m = inoue_model()
    λ0 = ρ / ALPHA
    θ = [λ0]
    intL(rec) = rec.horizon * time_average(number_in_system, m, rec)

    fs = zeros(R); S = zeros(1, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 7000 + r)
        rm = replay_model(m, rec)
        grec = CG.gradient_record(rm, rec, θ)
        fs[r] = intL(rec)
        S[:, r] = CG.score_gradient(rm, θ, grec)
    end
    sc_est = mean((fs .- mean(fs)) .* S[1, :])
    sc_se  = std((fs .- mean(fs)) .* S[1, :]) / sqrt(R)

    δ = θ[1] * 0.05
    d = [(intL(simulate(m, [θ[1] + δ], H; seed = 7000 + r)) -
          intL(simulate(m, [θ[1] - δ], H; seed = 7000 + r))) / (2δ) for r in 1:R]
    fd_est = mean(d); fd_se = std(d) / sqrt(R)

    zz = abs(sc_est - fd_est) / sqrt(sc_se^2 + fd_se^2)
    println("d E[integral L dt]/d lambda over H=$(round(Int, H)) ms, rho=$ρ:")
    println("  score       = $(round(sc_est, digits = 1)) ± $(round(sc_se, digits = 1))")
    println("  finite-diff = $(round(fd_est, digits = 1)) ± $(round(fd_se, digits = 1))")
    println("  |Δ|/SE = $(round(zz, digits = 2))")
    (sc_est = sc_est, sc_se = sc_se, fd_est = fd_est, fd_se = fd_se, z = zz)
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
    println("== validation: simulated mean latency vs exact oracle and bound ==")
    check_table()

    println("\n== Figure 1: mean latency & utilization vs load (V100) ==")
    f1 = figure_latency()
    ρlo, ρhi = 0.3, 0.9
    println("at rho=$ρlo: exact E[W] = $(round(exact_latency(ρlo/ALPHA, ALPHA, TAU0), digits=3)) ms, ",
            "bound phi = $(round(φ(ρlo/ALPHA, ALPHA, TAU0), digits=3)) ms")
    println("at rho=$ρhi: exact E[W] = $(round(exact_latency(ρhi/ALPHA, ALPHA, TAU0), digits=3)) ms, ",
            "bound phi = $(round(φ(ρhi/ALPHA, ALPHA, TAU0), digits=3)) ms")
    println("utilization at rho=0.5: exact 1-pi_0 = ",
            round(exact_utilization(0.5/ALPHA, ALPHA, TAU0), digits=3),
            " (vs traffic intensity 0.5) -- the server is nearly always busy.")
    println("figures: docs/figures/inoue2021_latency.png (+ manual copy)")

    println("\n== Figure 2: finite maximum batch size bmax (V100) ==")
    f2 = figure_bmax()
    for bmax in BMAX_LIST
        r = f2[bmax]
        tag = bmax == typemax(Int) ? "inf" : string(bmax)
        println("bmax=$tag: stability boundary mu = $(round(r.cap, digits=3)) jobs/ms; ",
                "highest sampled lambda = $(round(maximum(r.λs), digits=3))")
    end
    println("figures: docs/figures/inoue2021_bmax.png (+ manual copy)")

    println("\n== gradient showcase (score vs finite difference) ==")
    gradient_showcase()
end
