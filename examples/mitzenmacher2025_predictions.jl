# A single M/G/1 testbed for SCHEDULING WITH PREDICTIONS, after
# Mitzenmacher & Shahout, "Queueing, Predictions, and LLMs: Challenges and
# Open Problems" (SIGMETRICS 2025 tutorial survey, arXiv:2503.07545). The
# exact equilibrium numbers this script reproduces originate in Mitzenmacher's
# two prior peer-reviewed papers, which the survey tabulates:
#
#   [misprediction] M. Mitzenmacher, "Scheduling with Predictions and the
#       Price of Misprediction," ITCS 2020.  (Survey Table 1 = its Tables I-II.)
#   [small-advice]  M. Mitzenmacher, "Queues with Small Advice," 2021.
#       (Survey Tables 2-3 = its Tables 1-2.)
#
# --------------------------------------------------------------------------
# THE ONE-SENTENCE STORY. If a single server does not know how long each job
# will take, first-in-first-out (FIFO) is all it can do; if it knows the exact
# sizes it can run shortest-remaining-processing-time (SRPT) and do far
# better; and a NOISY PREDICTION of each size -- even a bad one -- recovers
# most of that gain. This script builds ONE M/G/1 queue and runs the whole
# zoo of size-based and prediction-based disciplines through it, checking the
# simulated mean response time against the papers' exact equilibrium values.
#
# --------------------------------------------------------------------------
# THE DISCIPLINE ZOO (all acronyms spelled out; "response time" = time in
# system = waiting + service; "preemptive" = a better job may interrupt the
# one in service, which later resumes where it stopped; "non-preemptive" = the
# job in service always runs to completion first):
#
#   FIFO  first in, first out         -- ignores size. Baseline.  FCFS()
#   SJF   shortest job first          -- true size, non-preemptive.
#   SPJF  shortest PREDICTED job first-- predicted size, non-preemptive.
#   PSJF  preemptive shortest job first-- true size, preemptive.
#   PSPJF preemptive shortest predicted job first -- predicted size, preemptive.
#   SRPT  shortest remaining processing time -- true remaining, preemptive. Optimal.
#   SPRPT shortest PREDICTED remaining processing time -- predicted remaining.
#
# HOW EACH MAPS TO A Concourse DISCIPLINE. A predicted size is just a second
# MARK drawn jointly with the true size at the source. Then:
#   SJF   = Priority(Mark(:size))                 (order by true size)
#   SPJF  = Priority(Mark(:pred))                 (order by predicted size)
#   PSJF  = Priority(Mark(:size); preempt = true)
#   PSPJF = Priority(Mark(:pred); preempt = true)
#   SRPT  = SRPT(Mark(:size))                     (rank = size - age)
#   SPRPT = SRPT(Mark(:pred))                     (rank = predicted - age)
# The last line is the key trick: Concourse's SRPT ranks a job by
# (its `by` mark) - (age in service) and preempts on that rank, while the job
# still COMPLETES at its true service time (the Dirac service law reads
# Mark(:size)). Feeding it Mark(:pred) therefore gives exactly the survey's
# SPRPT rank y - a, with completion at the true x. No new machinery.
#
# --------------------------------------------------------------------------
# THE PREDICTION MODEL. Following [misprediction]/[small-advice], a job of true
# size x gets a predicted size y that is EXPONENTIALLY distributed with mean x
# (the "exponential prediction model"): y = Exp(mean = x). It is deliberately
# a weak predictor -- it only tends to order jobs correctly -- which is the
# point: even this recovers most of SRPT's benefit.
#
# --------------------------------------------------------------------------
# WHAT THIS SCRIPT VALIDATES (each simulated mean checked at 4 standard errors
# against an EXACT number):
#
#  1. Exponential service (mean 1), Survey Table 1. All seven disciplines at
#     lambda = 0.5, 0.7, 0.9. Six of the seven exact values are RECOMPUTED
#     here by numerical integration of the papers' own priority/SRPT integral
#     formulas (they match the published table to four decimals); SPRPT has no
#     elementary closed form, so it is checked against the paper's published
#     SIMULATION value.
#  2. Heavy-tailed Weibull service F(x) = 1 - exp(-sqrt(2x)) (mean 1, but
#     second moment 6), Survey Table 3. FIFO (exact Pollaczek-Khinchine) and
#     SRPT/SPRPT at lambda = 0.5, 0.7. The prediction GAIN grows under the
#     heavy tail; the lambda = 0.98 contrast (FIFO 148 vs SRPT 7.666) is shown
#     as a figure trend, too expensive to validate tightly.
#  3. One-bit predictions (Survey Table 2, from [small-advice]). A job is
#     flagged "short" or "long" by a single threshold bit. The NON-PREEMPTIVE
#     mean response t1 is validated against the exact closed form, for both a
#     perfect bit (THRESHOLD, on the true size) and a predicted bit (PREDICTION,
#     on the exponential prediction). The paper's identity t1 = lambda*t2 + 1
#     links t1 to the PREEMPTIVE t2; the preemptive threshold is a discipline
#     Concourse does not express (its Priority does not preempt among equal
#     keys, so shorts do not preempt shorts), so t2 is excluded and the identity
#     is checked only for the closed forms. See the scope note at check_onebit.
#
# FIGURES (saved to docs/figures/ and docs/src/manual/figures/):
#  (a) mitzenmacher2025_suite.png       -- mean response vs lambda, all seven.
#  (b) mitzenmacher2025_heavytail.png   -- exp vs Weibull: the gain grows.
#  (c) mitzenmacher2025_quality.png     -- response vs prediction quality.
#
# Run from the repository root:
#   julia --project=examples examples/mitzenmacher2025_predictions.jl
# Total runtime is a few minutes (horizons sized so the tables pass at 4 SE).

using Concourse
using Statistics
using Distributions
using Plots
using Plots.PlotMeasures

# ---------------------------------------------------------------------------
# Constants. Horizons are sized so every validation point passes at 4 SE
# within a few minutes; high lambda and the heavy-tailed Weibull need the most
# work, so they get their own (larger) budgets.

const HORIZON = 25_000.0     # simulated time units per replicate (exp service)
const WARMUP  = 2_000.0      # discard jobs arriving before this (transient)
const NREPS   = 10           # independent replicates per estimate

const HORIZON_W = 60_000.0   # Weibull is heavier-tailed: longer runs
const NREPS_W   = 12

const HORIZON_FIG = 30_000.0 # figures: a little lighter than validation
const NREPS_FIG   = 8

# The three arrival rates the validation tables check.
const LAMBDAS = [0.5, 0.7, 0.9]
# A finer grid for the smooth figure curves.
const LAMBDA_GRID = [0.5, 0.6, 0.7, 0.8, 0.9]

# ---------------------------------------------------------------------------
# The model. One Poisson source, one single-server station. Every job carries
# TWO marks drawn jointly: its true size, and a predicted size that is
# Exponential with mean equal to the true size. Service is deterministic GIVEN
# the true size (a Dirac law reading Mark(:size)); the discipline is the only
# thing that changes between runs.

function suite_model(disc; service::Symbol = :exp)
    net = QueueNetwork(param_names = (:lambda,))
    sizelaw = service === :exp ?
        Law(:Exponential, scale = Const(1.0)) :               # mean 1
        Law(:Weibull, shape = Const(0.5), scale = Const(0.5)) # F=1-exp(-sqrt(2x))
    mk = MarkLaw(
        size = sizelaw,
        pred = Law(:Exponential, scale = Mark(:size)))        # y ~ Exp(mean = x)
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = mk)
    station!(net, :cpu; discipline = disc, servers = 1,
             service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

# A step-function ordering key: 0 for jobs whose key mark <= T ("short"), 1 for
# jobs above T ("long"), ties broken first-come first-served. Built from the
# surface algebra's ceil/min/max (no comparison operator is needed). This is
# how a single "short vs long" advice bit becomes a two-class priority.
oneb_key(e, T) = ceil(min(max(e - Const(T), Const(0.0)), Const(1.0)))

# The uniform prediction model used only in Figure (c): a job of size x gets a
# predicted size uniform on [(1-alpha)x, (1+alpha)x]. alpha = 0 is a perfect
# predictor; larger alpha is noisier.
function quality_model(alpha)
    net = QueueNetwork(param_names = (:lambda,))
    mk = MarkLaw(
        size  = Law(:Exponential, scale = Const(1.0)),
        predu = Law(:Uniform, a = Const(1.0 - alpha) * Mark(:size),
                              b = Const(1.0 + alpha) * Mark(:size)))
    source!(net, :arrive;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = mk)
    station!(net, :cpu; discipline = Priority(Mark(:predu)), servers = 1,
             service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

# The seven disciplines of Survey Table 1, in the order they appear there.
suite_disciplines() = [
    "FIFO"  => FCFS(),
    "SJF"   => Priority(Mark(:size)),
    "SPJF"  => Priority(Mark(:pred)),
    "PSJF"  => Priority(Mark(:size); preempt = true),
    "PSPJF" => Priority(Mark(:pred); preempt = true),
    "SRPT"  => SRPT(Mark(:size)),
    "SPRPT" => SRPT(Mark(:pred)),
]

# ---------------------------------------------------------------------------
# Measurement folds over the record. A job's response time is its departure
# (service-completion firing) minus its arrival firing; jobs arriving during
# the warm-up are dropped. The i-th :arrival firing owns job id i, and a
# completed job fires :service at its id, so arrival and departure line up by
# index -- read straight off the record, no counters in the simulator.

function response_times(rec; warmup = WARMUP)
    arr = Float64[]
    dep = Dict{Int,Float64}()
    for (k, t) in zip(rec.key, rec.time)
        k[1] == :arrival && push!(arr, t)
        k[1] == :service && (dep[Int(k[3])] = t)
    end
    [dep[j] - arr[j] for j in eachindex(arr) if haskey(dep, j) && arr[j] >= warmup]
end

# Mean response time with its standard error, over NREPS independent runs.
function mean_response(m, lambda; horizon = HORIZON, nreps = NREPS,
                       warmup = WARMUP, seed0 = 1000)
    vals = [mean(response_times(simulate(m, [lambda], horizon; seed = seed0 + r);
                                warmup = warmup)) for r in 1:nreps]
    mean(vals), std(vals) / sqrt(nreps)
end

# ---------------------------------------------------------------------------
# NUMERICAL ORACLES. The papers give exact equilibrium formulas; we implement
# them by composite-Simpson quadrature so the script carries its own
# ground truth, independent of the simulator. Service is exponential, mean 1,
# unless noted: f(x)=e^{-x}, E[S]=1, E[S^2]=2, rho = lambda.

function simpson(f, a, b, n)
    n = iseven(n) ? n : n + 1
    h = (b - a) / n
    s = f(a) + f(b)
    @inbounds for i in 1:(n - 1)
        s += (isodd(i) ? 4.0 : 2.0) * f(a + i * h)
    end
    s * h / 3
end

# --- exponential-service building blocks (true-size distribution) ---
fs_exp(x) = exp(-x)
rhox_exp(x, lam) = lam * (1 - (x + 1) * exp(-x))     # load from jobs of size <= x
M2_exp(x) = 2 - (x^2 + 2x + 2) * exp(-x)             # int_0^x t^2 f(t) dt

# --- prediction-model building blocks. The joint density of (size x, pred y)
# is g(x,y) = e^{-x} (1/x) e^{-y/x}. Three integrals over x recur:
#   pdens(y)  = int (1/x) e^{-x-y/x} dx = f_p(y), the predicted-size density
#   pmass(y)  = int      e^{-x-y/x} dx           (also 1 - F_p(y); and int x g dx)
#   pload(y)  = int  x   e^{-x-y/x} dx           (int x^2 g dx; rho'_y = lam(1-pload))
pdens(y) = simpson(x -> (1 / x) * exp(-x - y / x), 1e-9, 60.0, 2000)
pmass(y) = simpson(x -> exp(-x - y / x), 1e-9, 60.0, 2000)
pload(y) = simpson(x -> x * exp(-x - y / x), 1e-9, 60.0, 2000)

# FIFO: exact M/M/1.
oracle_fifo(lam) = 1 / (1 - lam)

# SJF (non-preemptive, true size): mean response = E[S] + int f(x) W(x) dx,
# W(x) = rho E[S^2]/(2 E[S] (1-rho_x)^2) = lambda/(1-rho_x)^2.
oracle_sjf(lam) = 1 + simpson(x -> fs_exp(x) * lam / (1 - rhox_exp(x, lam))^2,
                              0.0, 40.0, 4000)

# PSJF (preemptive, true size): residence x/(1-rho_x) plus waiting
# lambda*M2(x)/(2(1-rho_x)^2).
oracle_psjf(lam) = simpson(x -> fs_exp(x) *
        (x / (1 - rhox_exp(x, lam)) + lam * M2_exp(x) / (2 * (1 - rhox_exp(x, lam))^2)),
        0.0, 40.0, 4000)

# SRPT (Schrage-Miller): residence R(x)=int_0^x dt/(1-rho_t) plus waiting
# lambda(M2(x) + x^2 (1-F(x)))/(2(1-rho_x)^2).
function oracle_srpt(lam)
    N = 4000; xmax = 40.0; h = xmax / N
    R = 0.0; prevr = 1 / (1 - rhox_exp(0.0, lam))
    s = 0.0
    for i in 0:N
        x = i * h
        if i > 0
            cur = 1 / (1 - rhox_exp(x, lam))
            R += (prevr + cur) / 2 * h
            prevr = cur
        end
        wq = lam * (M2_exp(x) + x^2 * exp(-x)) / (2 * (1 - rhox_exp(x, lam))^2)
        integ = fs_exp(x) * (R + wq)
        s += (i == 0 || i == N ? 1.0 : (isodd(i) ? 4.0 : 2.0)) * integ
    end
    s * h / 3
end

# SPJF (non-preemptive, predicted size): 1 + int f_p(y) lambda/(1-rho'_y)^2 dy,
# rho'_y = lambda(1 - pload(y)). The predicted-size density f_p is integrably
# singular at y=0, so the low tail is taken analytically: near 0, rho'_y ~ 0
# and int_0^{y0} f_p = 1 - pmass(y0).
function oracle_spjf(lam)
    y0 = 0.02; ymax = 70.0; N = 2000; h = (ymax - y0) / N
    low = lam * (1 - pmass(y0))
    s = 0.0
    for i in 0:N
        y = y0 + i * h
        rp = lam * (1 - pload(y))
        integ = pdens(y) * lam / (1 - rp)^2
        s += (i == 0 || i == N ? 1.0 : (isodd(i) ? 4.0 : 2.0)) * integ
    end
    1 + low + s * h / 3
end

# PSPJF (preemptive, predicted size): residence E[x|pred=y]/(1-rho'_y) plus
# waiting lambda*K2(y)/(2(1-rho'_y)^2), K2(y)=int_0^y (int x^2 g dx) dt. The
# residence numerator int x g dx = pmass(y); int x^2 g dx = pload(y).
function oracle_pspjf(lam)
    y0 = 1e-3; ymax = 70.0; N = 2000; h = (ymax - y0) / N
    K2 = pload(y0) * y0; prevk = pload(y0)   # cumulative int_0^y pload
    lowA = 1.0 * y0                          # int_0^{y0} pmass/(1-rho') ~ y0
    s = 0.0
    for i in 0:N
        y = y0 + i * h
        ky = pload(y)
        if i > 0
            K2 += (prevk + ky) / 2 * h
            prevk = ky
        end
        rp = lam * (1 - ky)
        A = pmass(y) / (1 - rp)
        B = pdens(y) * lam * K2 / (2 * (1 - rp)^2)
        integ = A + B
        s += (i == 0 || i == N ? 1.0 : (isodd(i) ? 4.0 : 2.0)) * integ
    end
    lowA + s * h / 3
end

# Map discipline name -> oracle function (SPRPT handled separately below).
const EXP_ORACLE = Dict(
    "FIFO" => oracle_fifo, "SJF" => oracle_sjf, "SPJF" => oracle_spjf,
    "PSJF" => oracle_psjf, "PSPJF" => oracle_pspjf, "SRPT" => oracle_srpt)

# --- Weibull service F(x)=1-exp(-sqrt(2x)): mean 1, E[S^2] = 6. ---
const WEI = Weibull(0.5, 0.5)
oracle_fifo_w(lam) = 1 + 3lam / (1 - lam)   # P-K: 1 + lambda*6/(2(1-lambda))
function oracle_srpt_w(lam; xmax = 800.0, N = 8000)
    h = xmax / N; eps = 1e-9
    rho = 0.0; R = 0.0; M2 = 0.0
    prevr = 1.0
    s = 0.0
    for i in 0:N
        x = max(i * h, eps)
        if i > 0
            a = (i - 1) * h; a2 = max(a, eps); b = i * h
            drho = lam * simpson(t -> t * pdf(WEI, t), a2, b, 4)
            M2  += simpson(t -> t^2 * pdf(WEI, t), a2, b, 4)
            cur = 1 / (1 - rho - drho)
            R += (prevr + cur) / 2 * h
            rho += drho
            prevr = cur
        end
        wq = lam * (M2 + x^2 * (1 - cdf(WEI, x))) / (2 * (1 - rho)^2)
        integ = pdf(WEI, x) * (R + wq)
        i > 0 && (s += (i == N ? 1.0 : (isodd(i) ? 4.0 : 2.0)) * integ)
    end
    s * h / 3   # (i=0 term is 0*Inf; the pdf mass there is negligible)
end

# --- one-bit threshold oracles (exponential service) ---
# THRESHOLD (perfect bit on the true size). Optimal T solves
# lambda = (T-1)/(e^{-T}+T-1). Sojourn, non-preemptive S_en and preemptive S_ep:
rhoT_exp(T, lam) = lam * (1 - (T + 1) * exp(-T))
Sen_thr(T, lam) = lam * (1 - lam + lam * exp(-T)) /
                  ((1 - lam) * (1 - rhoT_exp(T, lam))) + 1
Sep_thr(T, lam) = (1 - lam + lam * exp(-T)) /
                  ((1 - lam) * (1 - rhoT_exp(T, lam)))
function optT_thresh(lam)
    f(T) = (T - 1) / (exp(-T) + T - 1) - lam
    lo, hi = 1.0001, 60.0
    for _ in 1:200
        mid = (lo + hi) / 2
        f(mid) > 0 ? (hi = mid) : (lo = mid)
    end
    (lo + hi) / 2
end
# PREDICTION (bit from the exponential prediction). Q(T)=1-pmass(T),
# rho'(T)=lambda(1-pload(T)). Optimal T minimizes the non-preemptive sojourn.
Ssn_pred(T, lam) = lam * (1 - lam * (1 - pmass(T))) /
                   ((1 - lam) * (1 - lam * (1 - pload(T)))) + 1
Ssp_pred(T, lam) = (lam * pmass(T) + 1 - lam) /
                   ((1 - lam) * (1 - lam * (1 - pload(T))))
function optT_pred(lam)
    best = (Inf, 1.0)
    for T in 0.1:0.02:12.0
        v = Ssn_pred(T, lam)
        v < best[1] && (best = (v, T))
    end
    best[2]
end

# ---------------------------------------------------------------------------
# PUBLISHED VALUES used where we do not recompute an oracle. Survey Table 1
# SPRPT column is from EQUATIONS with a known ~1% numerical-integration bias
# (the source paper truncates predicted times at 50); the paper's own
# SIMULATION value is the honest target for a simulator, so we use that
# (from [misprediction] Table II, "Sim").
const SPRPT_SIM = Dict(0.5 => 1.6588, 0.7 => 2.3684, 0.9 => 5.0973)  # exp service
# Survey Table 3 heavy-tail published rows (from [small-advice] Table 2), for
# the figure curves. NOTE: the lambda=0.9 FIFO entry prints 29.00, but every
# other FIFO entry equals 1+3*lambda/(1-lambda) exactly, which gives 28.00 at
# 0.9 -- an apparent typo; we plot the exact P-K value.
const WEI_FIFO_PUB = Dict(0.5=>4.0, 0.6=>5.5, 0.7=>8.0, 0.8=>13.0, 0.9=>28.0, 0.95=>58.0, 0.98=>148.0)
const WEI_SRPT_PUB = Dict(0.5=>1.411, 0.6=>1.574, 0.7=>1.813, 0.8=>2.217, 0.9=>3.154, 0.95=>4.517, 0.98=>7.666)
const WEI_SPRPT_PUB = Dict(0.5=>1.940, 0.6=>2.280, 0.7=>2.750, 0.8=>3.519, 0.9=>5.224, 0.95=>7.788, 0.98=>13.404)
# Survey Table 2 one-bit published (exp service): THRESHOLD/PREDICTION, np & p.
const THR_NP_PUB = Dict(0.5=>1.783, 0.7=>2.542, 0.9=>5.278)
const THR_P_PUB  = Dict(0.5=>1.564, 0.7=>2.203, 0.9=>4.755)
const PRD_NP_PUB = Dict(0.5=>1.850, 0.7=>2.761, 0.9=>6.366)
const PRD_P_PUB  = Dict(0.5=>1.698, 0.7=>2.517, 0.9=>5.960)

# ---------------------------------------------------------------------------
# Run the whole suite once over LAMBDA_GRID and cache the results, so the
# validation table and the figure share one simulation pass.

function run_suite()
    res = Dict{String,Tuple{Vector{Float64},Vector{Float64}}}()
    for (name, disc) in suite_disciplines()
        m = suite_model(disc)
        means = Float64[]; ses = Float64[]
        for lam in LAMBDA_GRID
            e, s = mean_response(m, lam; horizon = HORIZON, nreps = NREPS,
                                 seed0 = 2000 + round(Int, 1000lam))
            push!(means, e); push!(ses, s)
        end
        res[name] = (means, ses)
    end
    res
end

# ---------------------------------------------------------------------------
# 1. Validation table: exponential service, Survey Table 1.

function check_suite(res)
    println("Exponential service (mean 1), exponential predictions. ",
            "Survey Table 1 (from [misprediction]).")
    println(rpad("discipline", 8), rpad("lambda", 8), rpad("simulated (4 SE)", 22),
            rpad("exact", 10), rpad("source", 14), "|z|")
    maxz = 0.0
    for (name, _) in suite_disciplines()
        means, ses = res[name]
        for lam in LAMBDAS
            i = findfirst(==(lam), LAMBDA_GRID)
            est, se = means[i], ses[i]
            if name == "SPRPT"
                exact = SPRPT_SIM[lam]; src = "paper sim"
            else
                exact = EXP_ORACLE[name](lam); src = "oracle(=Table1)"
            end
            z = abs(est - exact) / se
            maxz = max(maxz, z)
            println(rpad(name, 8), rpad(lam, 8),
                    rpad(string(round(est, digits = 3), " ± ", round(se, digits = 3)), 22),
                    rpad(round(exact, digits = 3), 10), rpad(src, 14),
                    round(z, digits = 2))
        end
    end
    println("max |z| = $(round(maxz, digits = 2))  (all pass at 4 SE if < 4)")
end

# ---------------------------------------------------------------------------
# 2. Heavy-tail validation: Weibull service, FIFO / SRPT / SPRPT at low lambda.

function check_weibull()
    println("\nHeavy-tailed Weibull service F(x)=1-exp(-sqrt(2x)) (mean 1, E[S^2]=6). ",
            "Survey Table 3.")
    println(rpad("discipline", 8), rpad("lambda", 8), rpad("simulated (4 SE)", 22),
            rpad("exact/pub", 12), "|z|")
    maxz = 0.0
    rows = [("FIFO",  FCFS(),        lam -> oracle_fifo_w(lam), "oracle"),
            ("SRPT",  SRPT(Mark(:size)), lam -> oracle_srpt_w(lam), "oracle"),
            ("SPRPT", SRPT(Mark(:pred)), lam -> WEI_SPRPT_PUB[lam], "paper sim")]
    for (name, disc, exactf, _) in rows
        m = suite_model(disc; service = :weibull)
        for lam in (0.5, 0.7)
            est, se = mean_response(m, lam; horizon = HORIZON_W, nreps = NREPS_W,
                                    seed0 = 4000 + round(Int, 1000lam))
            exact = exactf(lam)
            z = abs(est - exact) / se
            maxz = max(maxz, z)
            println(rpad(name, 8), rpad(lam, 8),
                    rpad(string(round(est, digits = 3), " ± ", round(se, digits = 3)), 22),
                    rpad(round(exact, digits = 3), 12), round(z, digits = 2))
        end
    end
    println("max |z| = $(round(maxz, digits = 2))")
end

# ---------------------------------------------------------------------------
# 3. One-bit predictions. We validate the NON-PREEMPTIVE t1 (both the perfect
# THRESHOLD bit and the noisy PREDICTION bit) against the exact closed forms of
# [small-advice], and confirm those closed forms satisfy the paper's identity
# t1 = lambda*t2 + 1.
#
# SCOPE NOTE (an honest limitation of the discipline surface). The paper's
# PREEMPTIVE threshold has any short job preempt the job in service, INCLUDING
# another short -- i.e. the short class is served last-come-first-served
# preemptive-resume, which gives a short of size t a sojourn t/(1-rho(T)).
# Concourse's `Priority(...; preempt = true)` evicts a job in service only when
# a waiting job is STRICTLY better, so two jobs in the same class (equal key) do
# NOT preempt each other -- the short class is FCFS. That is a different (also
# valid) discipline: "class-preemptive, FCFS within class." Its mean response
# is genuinely different from the paper's t2 (we print both so the gap is
# visible), so the preemptive t2 and the t1 = lambda*t2 + 1 identity are OUT OF
# SCOPE for the simulator; the identity is checked only for the exact formulas.

function check_onebit()
    println("\nOne-bit predictions (exp service). THRESHOLD = a PERFECT short/long ",
            "bit on the\ntrue size; PREDICTION = a NOISY bit from the exponential ",
            "prediction. Non-preemptive\nsojourn t1 validated against [small-advice]; ",
            "Survey Table 2. (Preemptive t2 excluded --\nsee the script's scope note.)")
    println(rpad("scheme", 12), rpad("lambda", 8), rpad("T*", 7),
            rpad("sim t1 (4 SE)", 20), rpad("exact t1", 10), "|z|")
    maxz = 0.0
    for lam in LAMBDAS
        Tt = optT_thresh(lam)
        e_np, s_np = mean_response(suite_model(Priority(oneb_key(Mark(:size), Tt))), lam;
                                   seed0 = 6000 + round(Int, 1000lam))
        z = abs(e_np - Sen_thr(Tt, lam)) / s_np; maxz = max(maxz, z)
        println(rpad("THRESHOLD", 12), rpad(lam, 8), rpad(round(Tt, digits = 2), 7),
                rpad(string(round(e_np, digits = 3), " ± ", round(s_np, digits = 3)), 20),
                rpad(round(Sen_thr(Tt, lam), digits = 3), 10), round(z, digits = 2))
        Tp = optT_pred(lam)
        pe_np, ps_np = mean_response(suite_model(Priority(oneb_key(Mark(:pred), Tp))), lam;
                                     seed0 = 7000 + round(Int, 1000lam))
        pz = abs(pe_np - Ssn_pred(Tp, lam)) / ps_np; maxz = max(maxz, pz)
        println(rpad("PREDICTION", 12), rpad(lam, 8), rpad(round(Tp, digits = 2), 7),
                rpad(string(round(pe_np, digits = 3), " ± ", round(ps_np, digits = 3)), 20),
                rpad(round(Ssn_pred(Tp, lam), digits = 3), 10), round(pz, digits = 2))
    end
    println("max |z| (non-preemptive t1) = $(round(maxz, digits = 2))")
    # The exact closed forms satisfy the identity t1 = lambda*t2 + 1 exactly.
    println("exact identity t1 = lambda*t2 + 1 (closed forms of [small-advice]):")
    for lam in LAMBDAS
        Tt = optT_thresh(lam); Tp = optT_pred(lam)
        rt = Sen_thr(Tt, lam) - (lam * Sep_thr(Tt, lam) + 1)
        rp = Ssn_pred(Tp, lam) - (lam * Ssp_pred(Tp, lam) + 1)
        println("  lambda=$lam  THRESHOLD residual=$(round(rt, sigdigits = 2))  ",
                "PREDICTION residual=$(round(rp, sigdigits = 2))  (both ~0)")
    end
end

# ---------------------------------------------------------------------------
# Figure (a): mean response time vs lambda for the seven-discipline suite.

const SUITE_COLORS = Dict(
    "FIFO" => :black, "SJF" => :royalblue, "SPJF" => :deepskyblue,
    "PSJF" => :seagreen, "PSPJF" => :mediumseagreen,
    "SRPT" => :firebrick, "SPRPT" => :orange)

function figure_suite(res)
    plt = plot(size = (860, 560), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 4mm,
               xlabel = "arrival rate lambda", ylabel = "mean response time E[T]",
               title = "M/G/1, exponential service: seven scheduling disciplines",
               titlefontsize = 11, legend = :topleft, ylim = (1, 11))
    for (name, _) in suite_disciplines()
        col = SUITE_COLORS[name]
        # exact curve: oracle evaluated at the grid points (six disciplines),
        # published simulation points for SPRPT.
        if name == "SPRPT"
            xs = sort(collect(keys(SPRPT_SIM)))
            plot!(plt, xs, [SPRPT_SIM[x] for x in xs]; lw = 2, ls = :dot, color = col, label = "")
        else
            plot!(plt, LAMBDA_GRID, [EXP_ORACLE[name](l) for l in LAMBDA_GRID];
                  lw = 2, color = col, label = "")
        end
        means, ses = res[name]
        scatter!(plt, LAMBDA_GRID, means; yerror = 4 .* ses, ms = 4, color = col,
                 markerstrokecolor = col, label = name)
    end
    annotate!(plt, 0.6, 4.55, text("predictions (SPJF/SPRPT) recover\nmost of SRPT's gain",
              8, :left, :firebrick))
    savefig_both(plt, "mitzenmacher2025_suite.png")
    plt
end

# ---------------------------------------------------------------------------
# Figure (b): the gain grows under a heavy tail. Two panels, exp vs Weibull,
# FIFO / SRPT / SPRPT curves to lambda = 0.98, with the ratio annotated.

function figure_heavytail()
    plt = plot(layout = (1, 2), size = (980, 470), dpi = 150,
               left_margin = 6mm, bottom_margin = 7mm, top_margin = 5mm, right_margin = 4mm)
    fine = 0.5:0.01:0.98
    # left: exponential service (light tail)
    plot!(plt[1], collect(fine), [oracle_fifo(l) for l in fine]; lw = 2, color = :black,
          label = "FIFO", yscale = :log10, legend = :topleft,
          xlabel = "lambda", ylabel = "mean response time E[T] (log)",
          title = "Light tail: exponential service", titlefontsize = 10)
    plot!(plt[1], collect(fine), [oracle_srpt(l) for l in fine]; lw = 2, color = :firebrick,
          label = "SRPT (exact sizes)")
    xs = sort(collect(keys(SPRPT_SIM)))
    plot!(plt[1], xs, [SPRPT_SIM[x] for x in xs]; lw = 2, ls = :dash, color = :orange,
          label = "SPRPT (predictions)")
    # right: Weibull service (heavy tail)
    xw = sort(collect(keys(WEI_FIFO_PUB)))
    plot!(plt[2], collect(fine), [oracle_fifo_w(l) for l in fine]; lw = 2, color = :black,
          label = "FIFO", yscale = :log10, legend = :topleft,
          xlabel = "lambda", ylabel = "mean response time E[T] (log)",
          title = "Heavy tail: Weibull F=1-exp(-sqrt(2x))", titlefontsize = 10)
    scatter!(plt[2], xw, [WEI_SRPT_PUB[x] for x in xw]; ms = 4, color = :firebrick,
             label = "SRPT (exact sizes)")
    plot!(plt[2], xw, [WEI_SRPT_PUB[x] for x in xw]; lw = 1, color = :firebrick, label = "")
    scatter!(plt[2], xw, [WEI_SPRPT_PUB[x] for x in xw]; ms = 4, color = :orange,
             marker = :diamond, label = "SPRPT (predictions)")
    plot!(plt[2], xw, [WEI_SPRPT_PUB[x] for x in xw]; lw = 1, ls = :dash, color = :orange, label = "")
    annotate!(plt[2], 0.5, 33,
              text("at 0.98: FIFO 148 vs SRPT 7.7\n(~19x): the gain GROWS", 7, :left, :firebrick))
    savefig_both(plt, "mitzenmacher2025_heavytail.png")
    plt
end

# ---------------------------------------------------------------------------
# Figure (c): mean response vs prediction quality. SPJF with a uniform
# predictor on [(1-alpha)x,(1+alpha)x] at lambda = 0.8; alpha = 0 is perfect.

const QUALITY_LAMBDA = 0.8

function figure_quality()
    # alpha = 0 would make the uniform predictor a point mass (a == b), which
    # is degenerate; start just above 0 and mark the alpha -> 0 limit (= SJF).
    alphas = [0.02, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    est = Float64[]; se = Float64[]
    for a in alphas
        m = quality_model(a)
        e, s = mean_response(m, QUALITY_LAMBDA; horizon = HORIZON_FIG,
                             nreps = NREPS_FIG, seed0 = 8000 + round(Int, 100a))
        push!(est, e); push!(se, s)
    end
    fifo = oracle_fifo(QUALITY_LAMBDA)
    sjf  = oracle_sjf(QUALITY_LAMBDA)
    srpt = oracle_srpt(QUALITY_LAMBDA)
    plt = plot(size = (820, 520), dpi = 150,
               left_margin = 6mm, bottom_margin = 6mm, top_margin = 4mm, right_margin = 4mm,
               xlabel = "prediction noise alpha  (0 = perfect, larger = noisier)",
               ylabel = "mean response time E[T]",
               title = "SPJF response degrades gracefully with prediction noise (lambda=0.8)",
               titlefontsize = 10, legend = :topleft, xlim = (-0.02, 1.05))
    hline!(plt, [fifo]; ls = :dash, color = :black, label = "FIFO (no info) = $(round(fifo,digits=2))")
    hline!(plt, [sjf];  ls = :dot,  color = :royalblue,
           label = "SJF (perfect, non-preempt) = $(round(sjf,digits=2))")
    hline!(plt, [srpt]; ls = :dashdot, color = :firebrick,
           label = "SRPT (perfect, optimal) = $(round(srpt,digits=2))")
    scatter!(plt, collect(alphas), est; yerror = 4 .* se, ms = 5, color = :deepskyblue,
             label = "SPJF, uniform predictor (sim, 4 SE)")
    plot!(plt, collect(alphas), est; lw = 1, color = :deepskyblue, label = "")
    annotate!(plt, 0.05, sjf - 0.15, text("alpha=0: SPJF = SJF", 8, :left, :royalblue))
    savefig_both(plt, "mitzenmacher2025_quality.png")
    plt
end

# ---------------------------------------------------------------------------
# Save a figure into both docs trees, like the other worked examples.

function savefig_both(plt, name)
    for sub in (["..", "docs", "figures"], ["..", "docs", "src", "manual", "figures"])
        dir = joinpath(@__DIR__, sub...)
        mkpath(dir)
        savefig(plt, joinpath(dir, name))
    end
end

# ---------------------------------------------------------------------------

if abspath(PROGRAM_FILE) == @__FILE__
    println("== validation 1: seven disciplines, exponential service (Survey Table 1) ==")
    res = run_suite()
    check_suite(res)

    println("\n== validation 2: heavy-tailed Weibull service (Survey Table 3) ==")
    check_weibull()

    println("\n== validation 3: one-bit predictions and t1 = lambda*t2 + 1 (Survey Table 2) ==")
    check_onebit()

    println("\n== Figure (a): mean response vs lambda, seven-discipline suite ==")
    figure_suite(res)
    println("figures: docs/figures/mitzenmacher2025_suite.png (+ manual copy)")

    println("\n== Figure (b): the prediction gain grows under a heavy tail ==")
    figure_heavytail()
    println("figures: docs/figures/mitzenmacher2025_heavytail.png (+ manual copy)")

    println("\n== Figure (c): response time vs prediction quality ==")
    figure_quality()
    println("figures: docs/figures/mitzenmacher2025_quality.png (+ manual copy)")
end
