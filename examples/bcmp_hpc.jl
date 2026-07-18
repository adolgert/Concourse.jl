# A BCMP network for a high-performance computing cluster.
#
# Two job classes (debug and production) flow through four resources:
#
#   login node  — processor sharing, class-dependent Gamma service (type 2)
#   scheduler   — FCFS, one server, class-INDEPENDENT exponential (type 1)
#   compute     — 64 nodes, one job per node (a delay station, type 3)
#   filesystem  — processor sharing, class-dependent exponential (type 2)
#
# After each compute burst a job checkpoints to the filesystem with
# probability p and returns to compute; with probability 1-p it finishes.
# The number of compute bursts is geometric with mean 1/(1-p).
#
# Because every station is a BCMP type, the stationary distribution has
# product form, and every station's mean occupancy has a closed form from
# the traffic equations alone. This script checks the simulation against
# those closed forms, sweeps the production arrival rate to find the
# bottleneck, and demonstrates the insensitivity property that defines the
# BCMP class: at the processor-sharing filesystem the service DISTRIBUTION
# does not matter, only its mean — while at the FCFS scheduler it does.
#
# Run from the repository root:
#   julia --project=examples examples/bcmp_hpc.jl
# Figures land in docs/figures/.

using Concourse
using Statistics
using Plots

# ---------------------------------------------------------------------------
# The model. Class-dependent means travel as marks: each source stamps its
# jobs with the class's service scales, and the station laws read the marks.
# Class 0 = debug, class 1 = production.

const P_CHECKPOINT = 0.75           # compute -> filesystem probability
const V_COMPUTE = 1 / (1 - P_CHECKPOINT)          # mean compute visits = 4
const V_IO = P_CHECKPOINT / (1 - P_CHECKPOINT)    # mean filesystem visits = 3

# Per-class service MEANS (time units: minutes, say).
const LOGIN_MEAN = (debug = 0.05, prod = 0.10)
const SCHED_MEAN = 0.15                        # class-independent (type 1!)
const COMP_MEAN = (debug = 1.0, prod = 6.0)
const IO_MEAN = (debug = 0.04, prod = 0.20)

function hpc_model(; io_shape = 1.0, sched_shape = 1.0)
    net = QueueNetwork(param_names = (:lambda_debug, :lambda_prod))
    classmarks(login, comp, io, class) = MarkLaw(
        class = Law(:Dirac, value = Const(class)),
        login_s = Law(:Dirac, value = Const(login)),
        comp_s = Law(:Dirac, value = Const(comp)),
        io_s = Law(:Dirac, value = Const(io)))
    source!(net, :debug_in;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda_debug))),
            mark = classmarks(LOGIN_MEAN.debug, COMP_MEAN.debug, IO_MEAN.debug, 0.0))
    source!(net, :prod_in;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda_prod))),
            mark = classmarks(LOGIN_MEAN.prod, COMP_MEAN.prod, IO_MEAN.prod, 1.0))
    # Type 2: PS admits a GENERAL class-dependent law; Gamma(2, m/2) has mean m.
    station!(net, :login; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Gamma, shape = Const(2.0),
                           scale = Const(0.5) * Mark(:login_s)))
    # Type 1: FCFS requires exponential, class-independent. sched_shape != 1
    # deliberately LEAVES the BCMP class (the insensitivity demonstration).
    station!(net, :sched; discipline = FCFS(), servers = 1,
             service = sched_shape == 1.0 ?
                 Law(:Exponential, scale = Const(SCHED_MEAN)) :
                 Law(:Gamma, shape = Const(sched_shape),
                     scale = Const(SCHED_MEAN / sched_shape)))
    # Type 3: a delay station — every job gets its own node.
    station!(net, :compute; discipline = FCFS(), servers = 64,
             service = Law(:Exponential, scale = Mark(:comp_s)))
    # Type 2 again; io_shape varies the distribution at FIXED mean.
    station!(net, :fs; discipline = ProcessorSharing(), servers = 1,
             service = io_shape == 1.0 ?
                 Law(:Exponential, scale = Mark(:io_s)) :
                 Law(:Gamma, shape = Const(io_shape),
                     scale = Mark(:io_s) * Const(1 / io_shape)))
    sink!(net, :done)
    route!(net, :debug_in, Always(:login))
    route!(net, :prod_in, Always(:login))
    route!(net, :login, Always(:sched))
    route!(net, :sched, Always(:compute))
    route!(net, :compute, Probabilistic(:fs => P_CHECKPOINT, :done => 1 - P_CHECKPOINT))
    route!(net, :fs, Always(:compute))
    compile(net)
end

# ---------------------------------------------------------------------------
# The product-form oracle: loads from the traffic equations, means from the
# per-type closed forms (PS and FCFS: rho/(1-rho); delay: rho).

function oracle(λd, λp)
    ρ_login = λd * LOGIN_MEAN.debug + λp * LOGIN_MEAN.prod
    ρ_sched = (λd + λp) * SCHED_MEAN
    ρ_comp = V_COMPUTE * (λd * COMP_MEAN.debug + λp * COMP_MEAN.prod)
    ρ_io = V_IO * (λd * IO_MEAN.debug + λp * IO_MEAN.prod)
    (login = ρ_login / (1 - ρ_login),
     sched = ρ_sched / (1 - ρ_sched),
     compute = ρ_comp,
     fs = ρ_io / (1 - ρ_io),
     rho = (login = ρ_login, sched = ρ_sched, compute = ρ_comp / 64, fs = ρ_io))
end

# Per-class mean time in system: sojourns summed over visits. At a PS or
# FCFS station one visit costs E[S]/(1-rho); at a delay station, E[S].
function oracle_T(λd, λp)
    ρ = oracle(λd, λp).rho
    T(login, comp, io) = login / (1 - ρ.login) + SCHED_MEAN / (1 - ρ.sched) +
                         V_COMPUTE * comp + V_IO * io / (1 - ρ.fs)
    (debug = T(LOGIN_MEAN.debug, COMP_MEAN.debug, IO_MEAN.debug),
     prod = T(LOGIN_MEAN.prod, COMP_MEAN.prod, IO_MEAN.prod))
end

# ---------------------------------------------------------------------------
# Measurement: time-averaged number present per station (and per class),
# read off the replayed states.

nat(st, s::Int) = length(st.buf[s]) + length(st.srv[s]) + length(st.hold[s])

function station_means(m, rec)
    sts = replay(m, rec)
    times = vcat(rec.time, rec.horizon)
    tot = Dict(name => 0.0 for name in keys(m.names))
    t0 = 0.0
    for (i, t) in enumerate(times)
        dt = t - t0
        for (name, s) in m.names
            tot[name] += dt * nat(sts[i], s)
        end
        t0 = t
    end
    Dict(name => v / rec.horizon for (name, v) in tot)
end

function class_counts(m, rec)
    sts = replay(m, rec)
    times = vcat(rec.time, rec.horizon)
    tot = [0.0, 0.0]
    t0 = 0.0
    for (i, t) in enumerate(times)
        dt = t - t0
        for (_, marks) in sts[i].jobs
            tot[marks.class == 0.0 ? 1 : 2] += dt
        end
        t0 = t
    end
    tot ./ rec.horizon
end

function replicate_stations(m, θ, horizon, nreps; seed0 = 4000)
    per = [station_means(m, simulate(m, θ, horizon; seed = seed0 + r)) for r in 1:nreps]
    names = keys(first(per))
    est = Dict(n => mean(p[n] for p in per) for n in names)
    se = Dict(n => std([p[n] for p in per]) / sqrt(nreps) for n in names)
    est, se
end

# ---------------------------------------------------------------------------
# 1. The product-form check at the base point.

const θ0 = [2.0, 0.5]                 # debug 2/min, production 0.5/min
const HORIZON = 2000.0
const NREPS = 16

function check_table()
    m = hpc_model()
    est, se = replicate_stations(m, θ0, HORIZON, NREPS)
    orc = oracle(θ0...)
    println("station    simulated             product form   |z|")
    for s in (:login, :sched, :compute, :fs)
        z = abs(est[s] - getfield(orc, s)) / se[s]
        println(rpad(s, 10), rpad(string(round(est[s], digits = 3), " ± ",
                round(se[s], digits = 3)), 22),
                rpad(round(getfield(orc, s), digits = 3), 15),
                round(z, digits = 2))
    end
    # Per-class Little check: N_c measured vs lambda_c * T_c predicted.
    per = [class_counts(m, simulate(m, θ0, HORIZON; seed = 4200 + r)) for r in 1:NREPS]
    Tpred = oracle_T(θ0...)
    for (i, (c, λc, Tc)) in enumerate((("debug", θ0[1], Tpred.debug),
                                       ("production", θ0[2], Tpred.prod)))
        nc = mean(p[i] for p in per); sec = std([p[i] for p in per]) / sqrt(NREPS)
        println(rpad(c, 10), rpad(string(round(nc, digits = 3), " ± ",
                round(sec, digits = 3)), 22),
                rpad(round(λc * Tc, digits = 3), 15),
                round(abs(nc - λc * Tc) / sec, digits = 2))
    end
    est, se, orc
end

# ---------------------------------------------------------------------------
# 2. The bottleneck sweep: production rate up, filesystem saturates.

function sweep_plot()
    m = hpc_model()
    λps = 0.1:0.1:1.2
    series = Dict(s => (Float64[], Float64[]) for s in (:login, :sched, :compute, :fs))
    for λp in λps
        est, se = replicate_stations(m, [θ0[1], λp], 1000.0, 8; seed0 = 5000)
        for s in keys(series)
            push!(series[s][1], est[s]); push!(series[s][2], se[s])
        end
    end
    plt = plot(; xlabel = "production arrivals per minute (λ_prod)",
               ylabel = "mean jobs present", yscale = :log10,
               title = "Where the cluster saturates", legend = :topleft,
               size = (760, 480), dpi = 150)
    fine = 0.1:0.02:1.2
    for (s, lab) in ((:compute, "compute (64 nodes)"), (:fs, "filesystem"),
                     (:sched, "scheduler"), (:login, "login"))
        an = [getfield(oracle(θ0[1], λ), s) for λ in fine]
        plot!(plt, fine, an; label = "$lab — product form", lw = 2)
        scatter!(plt, collect(λps), series[s][1]; yerror = 4 .* series[s][2],
                 label = "$lab — simulated", ms = 3)
    end
    savefig(plt, joinpath(@__DIR__, "..", "docs", "figures", "bcmp_sweep.png"))
    plt
end

# ---------------------------------------------------------------------------
# 3. Insensitivity: change the service distribution at fixed mean.
#    At the PS filesystem nothing moves (BCMP). At the FCFS scheduler the
#    occupancy moves with the variance (and the network leaves the class).

function insensitivity_plot()
    shapes = [(0.5, "Gamma, CV² = 2"), (1.0, "exponential, CV² = 1"),
              (4.0, "Gamma, CV² = 1/4")]
    fs_est = Float64[]; fs_se = Float64[]
    sc_est = Float64[]; sc_se = Float64[]
    for (k, _) in shapes
        est, se = replicate_stations(hpc_model(io_shape = k), θ0, HORIZON, NREPS;
                                     seed0 = 6000)
        push!(fs_est, est[:fs]); push!(fs_se, se[:fs])
        est, se = replicate_stations(hpc_model(sched_shape = k), θ0, HORIZON, NREPS;
                                     seed0 = 7000)
        push!(sc_est, est[:sched]); push!(sc_se, se[:sched])
    end
    orc = oracle(θ0...)
    labels = [l for (_, l) in shapes]
    plt = plot(; layout = (1, 2), size = (900, 420), dpi = 150, legend = false)
    bar!(plt[1], labels, fs_est; yerror = 4 .* fs_se, title = "filesystem (PS)",
         ylabel = "mean jobs present", fillalpha = 0.7)
    hline!(plt[1], [orc.fs]; lw = 2, ls = :dash)
    bar!(plt[2], labels, sc_est; yerror = 4 .* sc_se, title = "scheduler (FCFS)",
         fillalpha = 0.7)
    hline!(plt[2], [orc.sched]; lw = 2, ls = :dash)
    savefig(plt, joinpath(@__DIR__, "..", "docs", "figures", "bcmp_insensitivity.png"))
    (fs_est, fs_se, sc_est, sc_se)
end

if abspath(PROGRAM_FILE) == @__FILE__
    mkpath(joinpath(@__DIR__, "..", "docs", "figures"))
    println("== product-form check at λ_debug = $(θ0[1]), λ_prod = $(θ0[2]) ==")
    check_table()
    println("\n== bottleneck sweep ==")
    sweep_plot()
    println("figure: docs/figures/bcmp_sweep.png")
    println("\n== insensitivity ==")
    fs_est, fs_se, sc_est, sc_se = insensitivity_plot()
    println("filesystem (PS): ", join(round.(fs_est, digits = 3), "  "))
    println("scheduler (FCFS): ", join(round.(sc_est, digits = 3), "  "))
    println("figure: docs/figures/bcmp_insensitivity.png")
end
