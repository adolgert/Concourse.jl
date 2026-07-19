# An M/G/1 model of a single-GPU LLM inference server, after
# Yang, Jiao & Xu, "A Queueing Theoretic Perspective on Low-Latency LLM
# Inference with Variable Token Length" (WiOpt 2024, arXiv:2407.05347).
#
# What the server does. Inference requests arrive to one GPU (FCFS, one at a
# time — no batching in this model) as a Poisson process of rate λ. Each
# request wants some number of OUTPUT tokens, drawn from a heavy-tailed
# lognormal law. The GPU's service time is affine in the output-token count,
#
#       S = a * n + c        (a in seconds/token, c in seconds),
#
# because generating tokens autoregressively costs roughly constant time per
# token. Input-token count is deliberately ignored: the paper measures its
# effect on latency as negligible (~8% over a 64->512 input range, versus 8x
# over a 128->1024 output range).
#
# Why the token count is the MARK. Every request carries its own output
# length, so the length is a per-job attribute drawn at arrival and read by
# the service law — exactly what a mark is. We draw a raw lognormal length
# and, in a second (deterministic) mark, round it up to an integer and clip
# it to a cap n_max: n = min(ceil(raw), n_max). The clipped integer is the
# service basis.
#
# What n_max trades off. Because output length is heavy-tailed, a few very
# long completions dominate E[S^2], and the Pollaczek-Khinchine formula makes
# mean queueing delay proportional to E[S^2]. "Max-token clipping" caps every
# request at n_max output tokens: this shears the right tail of S, collapses
# E[S^2], and sharply cuts mean queueing delay — at the cost of truncating a
# fraction of requests (the "clipped fraction"). Smaller n_max => lower delay
# but more requests cut short; the paper studies where the sweet spot sits.
# A second variant adds impatient users who abandon (renege) after waiting a
# fixed patience tau; there the benefit of clipping shows up as reduced loss.
#
# What this script does.
#   1. A closed-form P-K oracle for the clipped (right-censored) lognormal.
#   2. A discrete-event simulation whose per-request queueing delay is
#      measured from the record and validated against the oracle at 4 SE.
#   3. Figure 1: mean queueing delay and clipped fraction vs n_max (patient,
#      lambda = 1/40) — the paper's headline: delay ~23 s at the reported
#      optimum n_max = 1600 vs ~56 s at n_max = 3000 (a 58.93% reduction).
#   4. Figure 2: the impatient variant (lambda = 1/25, tau = 60 s) — served-
#      user delay and loss fraction vs n_max, simulated directly (this goes
#      BEYOND the paper's De Kok-Tijms interpolation, which we do not use).
#   5. Figure 3: the token-length law with the clip point, showing the heavy
#      tail that makes clipping so effective.
#   6. A small gradient showcase: d E[integral of N dt] / d lambda by the
#      score estimator, checked against finite differences.
#
# Run from the repository root:
#   julia --project=examples examples/yang2024_llm_mg1.jl
# Figures land in docs/figures/ and docs/src/manual/figures/.
# Total runtime is a few minutes (HORIZON/NREPS below are sized so the
# validation table passes at 4 SE without a long wait).

using Concourse
using Statistics
using Distributions
using Plots
using Plots.PlotMeasures

# ClockGradients ships with Concourse but is not a direct dependency of the
# examples project; reach it through the Concourse namespace.
const CG = Concourse.ClockGradients
using Concourse: replay_model

# ---------------------------------------------------------------------------
# Constants.
#
# CALIBRATION NOTE. The paper never prints the service-line slope a or
# intercept c (Sec. III.A, Eq. 4): they appear only as a fitted line in
# Fig. 2a. We use a = 0.0225 s/token, c = 0, calibrated to reproduce the
# LLaMA-2-7b-chat headline of Fig. 4: mean queueing delay ~23 s at the
# reported optimum n_max = 1600 and ~56 s at n_max = 3000 (a 58.93%
# reduction), all at lambda = 1/40. With these constants the exact P-K oracle
# gives 22.34 s and 55.37 s (a 59.65% reduction) — within figure-reading
# tolerance of the paper. A least-squares fit to the paper's Table I latency
# measurements independently gives a ~ 0.023, c ~ 0, consistent with this.

const A = 0.0225          # seconds per output token (calibrated, see above)
const C = 0.0             # fixed service offset, seconds
const MU = 7.0            # log-mean of the output-token lognormal (natural log)
const SIGMA = 0.7         # log-std of the output-token lognormal

const LAMBDA_PATIENT = 1 / 40      # req/s, patient experiments (Fig. 4a/4d)
const LAMBDA_IMPATIENT = 1 / 25    # req/s, impatient experiments (Fig. 4b/4c)
const TAU = 60.0                   # deterministic patience, seconds (Fig. 4b/4c)

const HORIZON = 200_000.0   # simulated seconds per replicate (~5000 arrivals)
const WARMUP = 5_000.0      # discard the initial transient, seconds
const NREPS = 24            # independent replicates per estimate

# ---------------------------------------------------------------------------
# The model. A Poisson source stamps every request with its output-token
# count as a two-step mark: a raw lognormal draw, then a deterministic mark
# that rounds up and clips. A single FCFS server has DETERMINISTIC service
# S = A * n + C read from the clipped mark. The impatient variant adds a
# deterministic patience clock that routes an abandoning job to a loss sink.
#
# There is no Truncated law in the surface algebra (its logccdf produces NaN
# ForwardDiff partials), so clipping is done with min/ceil on the drawn
# value — censoring, not renormalized truncation, which is exactly the
# paper's rule n = min(N, n_max).

function llm_model(; n_max, patient = true, τ = TAU)
    net = QueueNetwork(param_names = (:lambda,))
    mk = MarkLaw(
        raw = Law(:LogNormal, meanlog = Const(MU), sdlog = Const(SIGMA)),
        n = Law(:Dirac, value = min(ceil(Mark(:raw)), Const(float(n_max)))))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = mk)
    service = Law(:Dirac, value = Const(A) * Mark(:n) + Const(C))
    if patient
        station!(net, :gpu; discipline = FCFS(), servers = 1, service = service)
    else
        station!(net, :gpu; discipline = FCFS(), servers = 1, service = service,
                 patience = Law(:Dirac, value = Const(τ)), renege_to = :lost)
        sink!(net, :lost)
    end
    sink!(net, :done)
    route!(net, :arrive, Always(:gpu))
    route!(net, :gpu, Always(:done))
    compile(net)
end

# ---------------------------------------------------------------------------
# The closed-form oracle: the clipped (right-censored) lognormal and the
# Pollaczek-Khinchine mean waiting time. Exact for this model.
#
# Output length is discretized to integers n >= 1 with pmf
#   p_n = Phi((ln n - mu)/sigma) - Phi((ln(n-1) - mu)/sigma),
# which is exactly P(ceil(raw) = n). Clipping piles all mass above n_max onto
# the atom at n_max (censoring), per the paper's Eqs. 2-3.

Phi(z) = cdf(Normal(), z)
pmf(k) = Phi((log(k) - MU) / SIGMA) - Phi((log(k - 1) - MU) / SIGMA)  # log(0) = -Inf -> 0

# E[n_req] and E[n_req^2] for n_req = min(ceil(N), n_max), Eqs. 2-3.
function clipped_token_moments(n_max)
    m1 = 0.0
    m2 = 0.0
    cum = 0.0
    for k in 1:(n_max - 1)
        p = pmf(k)
        m1 += k * p
        m2 += k * k * p
        cum += p
    end
    tail = 1 - cum                      # P(ceil(N) >= n_max), piled onto n_max
    (m1 + n_max * tail, m2 + n_max * n_max * tail)
end

# Service moments from the token moments via the affine law, Eqs. 4-5.
function service_moments(n_max)
    m1, m2 = clipped_token_moments(n_max)
    ES = A * m1 + C
    ES2 = ES^2 + A^2 * (m2 - m1^2)      # Var(S) = a^2 Var(n), plus E[S]^2
    (ES, ES2)
end

utilization(n_max, λ) = λ * first(service_moments(n_max))

# Pollaczek-Khinchine mean queueing (waiting-in-queue) delay, Eq. 1.
function pk_delay(n_max, λ)
    ES, ES2 = service_moments(n_max)
    ρ = λ * ES
    ρ >= 1 && return NaN                # unstable: plain M/G/1 has no finite W
    λ * ES2 / (2 * (1 - ρ))
end

# Fraction of requests whose native length exceeds the cap, P(N > n_max).
clipped_fraction(n_max) = 1 - Phi((log(n_max) - MU) / SIGMA)

# ---------------------------------------------------------------------------
# Measurement folds over the record.
#
# The source creates job ids 1, 2, 3, ... in arrival order (next_id starts at
# 1 and increments once per arrival), so the i-th :arrival firing owns job
# id i. The output-token mark n is drawn during that firing and lands in the
# firing's draw list. A completed job fires :service at its departure. Because
# service is deterministic, the queueing delay is
#   W = (departure - arrival) - S(n),   S(n) = A * n + C,
# i.e. sojourn minus the known service time. Jobs arriving before WARMUP are
# discarded. Reneged jobs never fire :service, so they are simply absent here
# (that is exactly the "served users" set for the impatient variant).

function queueing_delays(m, rec; warmup = WARMUP)
    arrT = Float64[]                    # arrival time, in arrival order
    arrN = Float64[]                    # output-token mark, in arrival order
    dep = Dict{Int,Float64}()          # job id => departure (service-completion) time
    for (k, t, ds) in zip(rec.key, rec.time, rec.draws)
        if k[1] == :arrival
            push!(arrT, t)
            nv = NaN
            for p in ds
                p.first == :n && (nv = p.second)
            end
            push!(arrN, nv)
        elseif k[1] == :service
            dep[Int(k[3])] = t
        end
    end
    W = Float64[]
    for i in eachindex(arrT)
        (haskey(dep, i) && arrT[i] >= warmup) || continue
        push!(W, (dep[i] - arrT[i]) - (A * arrN[i] + C))
    end
    W
end

# Long-run fraction of users lost to abandonment (impatient variant): each
# abandonment fires exactly one :patience clock.
function loss_fraction(rec)
    na = count(k -> k[1] == :arrival, rec.key)
    nr = count(k -> k[1] == :patience, rec.key)
    na == 0 ? 0.0 : nr / na
end

# Replicate a scalar record statistic; report mean and standard error.
function replicate(f, m, λ, horizon, nreps; seed0 = 1000)
    vals = [f(simulate(m, [λ], horizon; seed = seed0 + r)) for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

meanW(m, λ, horizon, nreps; seed0 = 1000) =
    replicate(r -> mean(queueing_delays(m, r)), m, λ, horizon, nreps; seed0)

# ---------------------------------------------------------------------------
# 1. Validation: simulated mean queueing delay vs the P-K oracle.

function check_table()
    println("patient M/G/1, lambda = 1/40, a = $A, c = $C")
    println(rpad("n_max", 8), rpad("simulated W (s)", 24), rpad("P-K oracle (s)", 16),
            rpad("rho", 8), "|z|")
    for n_max in (800, 1000, 1600, 2400, 3000)
        m = llm_model(n_max = n_max)
        est, se = meanW(m, LAMBDA_PATIENT, HORIZON, NREPS; seed0 = 1000 + n_max)
        orc = pk_delay(n_max, LAMBDA_PATIENT)
        ρ = utilization(n_max, LAMBDA_PATIENT)
        z = abs(est - orc) / se
        println(rpad(n_max, 8),
                rpad(string(round(est, digits = 2), " ± ", round(se, digits = 2)), 24),
                rpad(round(orc, digits = 2), 16),
                rpad(round(ρ, digits = 3), 8),
                round(z, digits = 2))
    end
end

# ---------------------------------------------------------------------------
# 2. Figure 1: mean queueing delay and clipped fraction vs n_max (patient).
#    The P-K delay curve is monotone increasing in n_max; the paper's
#    optimum n_max = 1600 is where the utility-vs-delay objective peaks, not
#    where delay is smallest. We mark it and report the 23 s / 58.93% story.

const SWEEP_NMAX = [800, 1000, 1200, 1400, 1600, 2000, 2400, 3000]
const OPT_PATIENT = 1600

function figure_sweep()
    λ = LAMBDA_PATIENT
    est = Float64[]
    se = Float64[]
    for n_max in SWEEP_NMAX
        m = llm_model(n_max = n_max)
        e, s = meanW(m, λ, HORIZON, NREPS; seed0 = 3000 + n_max)
        push!(est, e)
        push!(se, s)
    end
    fine = 400:25:3000
    curve = [pk_delay(n, λ) for n in fine]
    clipf = [100 * clipped_fraction(n) for n in fine]

    plt = plot(layout = (1, 2), size = (960, 440), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 3mm)
    # Left panel: delay.
    plot!(plt[1], collect(fine), curve; lw = 2, label = "Pollaczek-Khinchine",
          xlabel = "max output tokens n_max", ylabel = "mean queueing delay (s)",
          title = "Delay vs token cap (lambda=1/40)", titlefontsize = 10, legend = :topleft)
    scatter!(plt[1], SWEEP_NMAX, est; yerror = 4 .* se, ms = 4, label = "simulated (4 SE)")
    vline!(plt[1], [OPT_PATIENT]; ls = :dash, lw = 1.5, color = :gray,
           label = "paper optimum n_max = 1600")
    d_opt = pk_delay(OPT_PATIENT, λ)
    d_max = pk_delay(3000, λ)
    hline!(plt[1], [d_opt]; ls = :dot, color = :green, label = "~$(round(Int, d_opt)) s at optimum")
    annotate!(plt[1], 1650, d_max * 0.5,
              text("$(round(Int, 100 * (1 - d_opt / d_max)))% lower\nthan n_max=3000", 8, :left))
    # Right panel: clipped fraction.
    plot!(plt[2], collect(fine), clipf; lw = 2, color = :darkorange, legend = false,
          xlabel = "max output tokens n_max", ylabel = "clipped fraction (%)",
          title = "Requests truncated vs token cap", titlefontsize = 10)
    vline!(plt[2], [OPT_PATIENT]; ls = :dash, lw = 1.5, color = :gray)
    cf = 100 * clipped_fraction(OPT_PATIENT)
    scatter!(plt[2], [OPT_PATIENT], [cf]; ms = 5, color = :darkorange)
    annotate!(plt[2], 1650, cf + 6, text("~$(round(cf, digits = 1))% at n_max=1600", 8, :left))

    savefig_both(plt, "yang2024_sweep.png")
    (est = est, se = se, d_opt = d_opt, d_max = d_max)
end

# ---------------------------------------------------------------------------
# 3. Figure 2: the impatient variant (lambda = 1/25, tau = 60 s). At this
#    load plain M/G/1 is UNSTABLE for large n_max (rho > 1); reneging sheds
#    load and keeps the system stable. We simulate abandonment directly and
#    measure served-user delay and loss fraction — going beyond the paper's
#    De Kok-Tijms interpolation, which needs closed forms it never prints.

const SWEEP_NMAX_IMP = [800, 1000, 1200, 1300, 1400, 1600, 2000, 2400, 3000]
const OPT_IMPATIENT = 1300

function figure_impatience()
    λ = LAMBDA_IMPATIENT
    Wqs = Float64[]; Wqs_se = Float64[]
    loss = Float64[]; loss_se = Float64[]
    for n_max in SWEEP_NMAX_IMP
        m = llm_model(n_max = n_max, patient = false)
        we, ws = meanW(m, λ, HORIZON, NREPS; seed0 = 5000 + n_max)
        le, ls = replicate(loss_fraction, m, λ, HORIZON, NREPS; seed0 = 5000 + n_max)
        push!(Wqs, we); push!(Wqs_se, ws)
        push!(loss, le); push!(loss_se, ls)
    end

    plt = plot(layout = (1, 2), size = (960, 440), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 3mm)
    scatter!(plt[1], SWEEP_NMAX_IMP, Wqs; yerror = 4 .* Wqs_se, ms = 4, lw = 2,
             marker = :circle, label = "simulated (4 SE)",
             xlabel = "max output tokens n_max", ylabel = "served-user delay E[W_qs] (s)",
             title = "Served delay (lambda=1/25, tau=60s)", titlefontsize = 10,
             legend = :bottomright)
    plot!(plt[1], SWEEP_NMAX_IMP, Wqs; lw = 1, color = :steelblue, label = "")
    vline!(plt[1], [OPT_IMPATIENT]; ls = :dash, color = :gray, label = "paper optimum n_max = 1300")
    hline!(plt[1], [TAU]; ls = :dot, color = :red, label = "patience tau = 60 s")

    scatter!(plt[2], SWEEP_NMAX_IMP, loss; yerror = 4 .* loss_se, ms = 4,
             color = :crimson, label = "simulated (4 SE)",
             xlabel = "max output tokens n_max", ylabel = "loss (renege) fraction",
             title = "Abandonment vs token cap", titlefontsize = 10, legend = :topleft)
    plot!(plt[2], SWEEP_NMAX_IMP, loss; lw = 1, color = :crimson, label = "")
    vline!(plt[2], [OPT_IMPATIENT]; ls = :dash, color = :gray, label = "n_max = 1300")
    iopt = findfirst(==(OPT_IMPATIENT), SWEEP_NMAX_IMP)
    annotate!(plt[2], OPT_IMPATIENT + 60, loss[iopt],
              text("loss ~$(round(loss[iopt], digits = 3))", 8, :left))

    savefig_both(plt, "yang2024_impatience.png")
    (Wqs = Wqs, loss = loss, loss_se = loss_se, iopt = iopt)
end

# ---------------------------------------------------------------------------
# 4. Figure 3: the token-length law and the clip point. The heavy right tail
#    is why clipping is so effective: only a small mass sits past n_max, but
#    that mass carries a large share of E[S^2].

function figure_tokens()
    d = LogNormal(MU, SIGMA)
    xs = 1:5:6000
    pdf_vals = pdf.(d, xs)
    samples = rand(d, 200_000)

    plt = plot(size = (780, 500), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 4mm,
               xlabel = "output tokens", ylabel = "density",
               title = "Output-token law: LogNormal(mu=7, sigma=0.7)", legend = :topright)
    histogram!(plt, filter(<(6000), samples); bins = 0:100:6000, normalize = :pdf,
               alpha = 0.35, color = :gray, label = "sampled requests")
    plot!(plt, collect(xs), pdf_vals; lw = 2.5, color = :black, label = "lognormal pdf")
    for (nc, col, lab) in ((OPT_PATIENT, :green, "n_max = 1600 (patient opt)"),
                           (OPT_IMPATIENT, :crimson, "n_max = 1300 (impatient opt)"))
        vline!(plt, [nc]; ls = :dash, lw = 1.5, color = col,
               label = "$lab, $(round(100 * clipped_fraction(nc), digits = 1))% clipped")
    end
    annotate!(plt, 3200, maximum(pdf_vals) * 0.45,
              text("heavy tail: mean ~1401 tokens,\nmedian ~1097, but a few\nrequests run much longer",
                   8, :left))

    savefig_both(plt, "yang2024_tokens.png")
    plt
end

# ---------------------------------------------------------------------------
# 5. Gradient showcase: d E[integral of N dt] / d lambda.
#
# lambda enters only the Exponential arrival clock, so it has a SCORE channel
# (Exponential is a derivative-carrying family) and the score estimator picks
# it up cleanly. IPA (pathwise) is NOT available for this model: sliding
# firing times replays every clock under ForwardDiff duals, and the Dirac
# service clock's quantile has no dual-safe form, so ipa_gradient throws here.
# That is the Dirac caveat in practice — a deterministic service law is
# invisible to pathwise and score channels alike; only lambda, carried by the
# Exponential, is differentiable. We therefore validate the score estimator
# against a paired-seed finite-difference baseline.

function gradient_showcase(; n_max = OPT_PATIENT, H = 4000.0, R = 400)
    m = llm_model(n_max = n_max)
    θ = [LAMBDA_PATIENT]
    intN(rec) = rec.horizon * time_average(number_in_system, m, rec)

    fs = zeros(R)
    S = zeros(1, R)
    for r in 1:R
        rec = simulate(m, θ, H; seed = 7000 + r)
        rm = replay_model(m, rec)
        grec = CG.gradient_record(rm, rec, θ)
        fs[r] = intN(rec)
        S[:, r] = CG.score_gradient(rm, θ, grec)
    end
    sc_est = mean((fs .- mean(fs)) .* S[1, :])
    sc_se = std((fs .- mean(fs)) .* S[1, :]) / sqrt(R)

    δ = θ[1] * 0.05
    θp = [θ[1] + δ]
    θm = [θ[1] - δ]
    d = [(intN(simulate(m, θp, H; seed = 7000 + r)) -
          intN(simulate(m, θm, H; seed = 7000 + r))) / (2δ) for r in 1:R]
    fd_est = mean(d)
    fd_se = std(d) / sqrt(R)

    zz = abs(sc_est - fd_est) / sqrt(sc_se^2 + fd_se^2)
    println("d E[integral N dt]/d lambda over H=$(round(Int, H)) s, n_max=$n_max:")
    println("  score = $(round(sc_est, digits = 1)) ± $(round(sc_se, digits = 1))   ",
            "finite-diff = $(round(fd_est, digits = 1)) ± $(round(fd_se, digits = 1))   ",
            "|Δ|/SE = $(round(zz, digits = 2))")
    (sc_est = sc_est, sc_se = sc_se, fd_est = fd_est, fd_se = fd_se)
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
    println("== validation: simulated queueing delay vs Pollaczek-Khinchine ==")
    check_table()

    println("\n== Figure 1: delay & clipped fraction vs n_max (patient) ==")
    s = figure_sweep()
    println("delay at n_max=1600: $(round(s.d_opt, digits = 2)) s (P-K)   ",
            "delay at n_max=3000: $(round(s.d_max, digits = 2)) s   ",
            "reduction: $(round(100 * (1 - s.d_opt / s.d_max), digits = 2))%")
    println("clipped fraction at n_max=1600: $(round(100 * clipped_fraction(1600), digits = 2))%")
    println("figures: docs/figures/yang2024_sweep.png (+ manual copy)")

    println("\n== Figure 2: impatient variant (lambda=1/25, tau=60 s) ==")
    imp = figure_impatience()
    println("at n_max=1300: served delay $(round(imp.Wqs[imp.iopt], digits = 2)) s, ",
            "loss $(round(imp.loss[imp.iopt], digits = 3))")
    ilast = length(SWEEP_NMAX_IMP)
    println("at n_max=3000: loss $(round(imp.loss[ilast], digits = 3))   ",
            "loss reduction 1300 vs 3000: ",
            "$(round(100 * (1 - imp.loss[imp.iopt] / imp.loss[ilast]), digits = 2))%")
    println("figures: docs/figures/yang2024_impatience.png (+ manual copy)")

    println("\n== Figure 3: token-length law with clip points ==")
    figure_tokens()
    println("figures: docs/figures/yang2024_tokens.png (+ manual copy)")

    println("\n== gradient showcase ==")
    gradient_showcase()
end
