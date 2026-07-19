# A reduced discrete-event model of the SMT2020 dataset-1 (HVLM) wafer fab,
# after Kopp, Hassoun, Kalir & Mönch, "SMT2020 -- A Semiconductor Manufacturing
# Testbed" (IEEE Trans. Semiconductor Manufacturing, 2020).
#
# WHAT THE FAB IS. The High-Volume/Low-Mix (HVLM) testbed runs two products
# through 105 real tool groups (1043 tools) plus one virtual hold station.
# Product 3 has a 583-step route, product 4 a 343-step route; both are heavily
# re-entrant (a lot revisits the litho and wet-etch groups dozens of times --
# the "44 mask layers" sawtooth). Lots are 25 wafers. Regular lots of each
# product release every 51.69 min and hot lots every 2016 min, giving
# ~10,000 wafer starts per week (WSPW); the paper's stated capacity is
# ~10,200 WSPW. This script reproduces the paper's raw-processing-time
# (Table II) and utilization (Table III) numbers and draws the operating curve.
#
# THE REDUCTION (what is modeled). Per-step processing time is Uniform(mean +-5%).
# Tool availability A (from PM + breakdown, precomputed in toolgroups.csv and
# validated against Table III to <=0.2 pts) enters as a capacity-equivalent
# service inflation: with derate on, every tool's busy time is multiplied by 1/A,
# so the simulated busy fraction reads directly as the paper's "utilization of
# available capacity". Cascading tools (wafer- and lot-pipelined) use the
# occupancy/latency split from the data's cascade intervals. Diffusion furnaces
# batch (75-150 wafers = 3-6 lots). Metrology steps are visited only with their
# sampling probability. Transport is Uniform(5,10) min per executed step. Hot
# lots (2.5% of releases) hold non-preemptive priority over regular lots at every
# non-batch tool.
#
# WHAT IS DROPPED (each with a quantified bound, see the docs page):
# sequence-dependent setups (<=1.1% of processing minutes; the known cause of the
# Implant max-util residual), rework (<2% flow), CQT links, lot-to-lens
# dedication, the rare SuperHotLot stream (~0.19% of P3 releases), and -- the
# headline caveat -- the DYNAMICS of downtime: only the capacity mean of PM and
# breakdown is kept (via 1/A). With deterministic capacity and no downtime
# variability the simulated operating curve sits BELOW the paper's, exactly the
# way the Yang example's monotone-delay curve sits below its data.
#
# ARCHITECTURE (see build_model). A lot's global step index is a mark. One shared
# infinite-server transport HUB increments the step on every deposit, draws the
# Uniform(5,10) transport time (plus any lot-cascade latency deficit), and
# routes -- via one big O(log n) ByMark over all 928 reachable step ids -- to the
# tool group of the next step, to a per-step sampling GATE, or to the product's
# sink. Tool groups are pure processors (a shared Opaque service law looks the
# step's inflated occupancy up in a table) that route straight back to the hub.
# Sampling gates flip a Probabilistic coin: execute (go to the tool) or skip
# (go to a Dirac(0) skip-hub that costs no transport). Diffusion furnaces are
# split into per-(product,step) Batching substations so every batch is
# homogeneous ("Same Product and Same Step"); see the DIFFUSION BATCHING note.
#
# Run from the repository root:
#   julia --project=examples examples/smt2020_hvlm.jl
# Data (regenerate with examples/smt2020_hvlm_data/extract_smt2020.py) lives in
# examples/smt2020_hvlm_data/. Figures land in docs/figures/ and
# docs/src/manual/figures/. Runtime is dominated by E2/E3: steady-state
# throughput is ~6.5k firings/s at full WIP (~1500 lots make each event cost
# grow with WIP), the E2 record is ~5M firings, and each of the four E3 load
# points is a ~5M-firing simulate + an equal-cost measurement fold. Budget
# roughly 2 to 2.5 hours for the whole script on a laptop; E0 prints a live
# steady-state throughput estimate first so you can predict the rest.

using Concourse
using Concourse: fire_changes, initial_state
using Statistics
using Distributions
using Printf
using Plots
using Plots.PlotMeasures

const DATA = joinpath(@__DIR__, "smt2020_hvlm_data")

# ---------------------------------------------------------------------------
# Experiment sizes (all here, per the spec). Times in SIMULATED DAYS unless
# noted. E0 measures real throughput first; if it is far below ~5k firings/s
# these are the knobs to turn down.

const DAY = 1440.0                       # minutes per day

# E1 -- raw processing time in an (essentially) empty fab.
const E1_N_LOTS   = 60                   # lots released per product

# E2 -- utilization at the 10,000 WSPW working point.
# Sized from the E0 benchmark (~9.1k firings/s, ~55k firings/sim-day steady):
# 110 sim-days ~ 5.5M firings ~ 0.55 GB, well under the 1e7-firing cap.
const E2_LOAD         = 10_000.0
const E2_WARMUP_DAYS  = 40.0
const E2_MEASURE_DAYS = 70.0

# E3 -- operating curve: fitness-ratio percentiles vs load.
# Cycle time at the working point is ~1.85 x RPT ~ 50 days, so the horizon must
# leave every pooled lot a long completion buffer or the tail is right-censored;
# hence the long measure window and the 60-day release upper bound below.
const E3_LOADS        = [8800.0, 9600.0, 10_000.0, 10_200.0]
const E3_WARMUP_DAYS  = 35.0
const E3_MEASURE_DAYS = 70.0
const E3_COMPLETE_BUFFER_DAYS = 50.0     # pooled lots get >= this long to finish

# Capacity reference for the operating-curve x-axis (paper's stated capacity).
const CAPACITY_WSPW = 10_200.0

# ---------------------------------------------------------------------------
# Numerical anchors from the paper (validation constants).

const RPT_PAPER = (p3 = 27.18, p4 = 15.96)          # Table II, days
const RPT_ORACLE = (p3 = 27.42, p4 = 16.10)         # offered-load arithmetic (analysis.md 3d)

# Per-area utilization: paper Table III (avg, max) and the offered-load
# arithmetic oracle (avg, max) from analysis.md 3c. Three-way table in E2.
const AREA_ORDER = ["Dielectric", "Diffusion", "Dry_Etch", "Implant", "Litho",
                    "Planar", "TF", "Wet_Etch", "Def_Met", "Litho_Met", "TF_Met"]
const UTIL_PAPER = Dict(                              # (avg%, max%)
    "Dielectric" => (85.0, 89.8), "Diffusion" => (84.1, 90.0),
    "Dry_Etch" => (86.0, 91.8), "Implant" => (58.2, 89.9),
    "Litho" => (86.6, 97.4), "Planar" => (71.2, 87.2),
    "TF" => (82.5, 90.3), "Wet_Etch" => (79.4, 89.7),
    "Def_Met" => (52.6, 84.0), "Litho_Met" => (90.1, 91.7),
    "TF_Met" => (46.1, 74.9))
const UTIL_ORACLE = Dict(                             # (avg%, max%) analysis.md 3c
    "Dielectric" => (80.3, 90.3), "Diffusion" => (80.0, 89.3),
    "Dry_Etch" => (85.7, 91.7), "Implant" => (58.4, 84.3),
    "Litho" => (84.9, 97.5), "Planar" => (58.3, 78.5),
    "TF" => (76.2, 88.2), "Wet_Etch" => (85.7, 96.7),
    "Def_Met" => (52.6, 84.0), "Litho_Met" => (90.1, 91.7),
    "TF_Met" => (46.0, 74.8))

# Operating-curve targets at 10,000 WSPW (paper): FF percentiles.
const FF_PAPER_10K = (p05 = 1.73, p50 = 1.85, p95 = 2.01, pmax = 2.37)

const WAFERS_PER_LOT = 25

# ===========================================================================
# 1. Loader -- plain-Julia CSV parsing (the extract script writes no field with
#    a comma, so a bare split(',') is safe).

struct ToolGroup
    area::String
    n_tools::Int
    availability::Float64
    batching::Bool
    cascading::Bool
    load::Float64
    unload::Float64
end

struct RouteStep
    step::Int                # local step (1..N)
    group::String
    unit::Symbol             # :Wafer | :Lot | :Batch
    pt::Float64
    pt_off::Float64
    cascade::Float64         # NaN if none
    batch_min::Int           # wafers; 0 if none
    batch_max::Int
    sample::Float64
end

function read_csv(path)
    lines = readlines(path)
    header = split(lines[1], ',')
    rows = [split(l, ',') for l in lines[2:end] if !isempty(l)]
    header, rows
end

pf(s) = isempty(s) ? NaN : parse(Float64, s)
pi0(s) = isempty(s) ? 0 : Int(round(parse(Float64, s)))

function load_toolgroups()
    _, rows = read_csv(joinpath(DATA, "toolgroups.csv"))
    tg = Dict{String,ToolGroup}()
    for r in rows
        tg[String(r[1])] = ToolGroup(String(r[2]), pi0(r[3]), pf(r[4]),
                                     r[5] == "YES", r[6] == "YES", pf(r[7]), pf(r[8]))
    end
    tg
end

function load_route(name)
    _, rows = read_csv(joinpath(DATA, name))
    steps = RouteStep[]
    for r in rows
        push!(steps, RouteStep(pi0(r[1]), String(r[2]), Symbol(r[3]),
                               pf(r[4]), pf(r[5]), pf(r[6]),
                               pi0(r[7]), pi0(r[8]), pf(r[9])))
    end
    steps
end

# ---------------------------------------------------------------------------
# Occupancy / latency per step (analysis.md 3c-d). `occ` is the tool-busy time
# a single execution demands (throughput view); `lat` is the residence a lot
# feels with no queueing. They differ only for lot-cascade steps, where the tool
# frees after one cascade interval but the lot stays for the full PT -- the
# difference is a latency DEFICIT paid later, at the infinite-server hub, so it
# adds to cycle time without consuming tool capacity. Availability enters as
# occ_inflated = occ / A (derate); the deficit uses the inflated occ so latency
# is never double-counted (max(0, lat - occ/A)).

lots_mid(s::RouteStep) = 0.5 * (s.batch_min + s.batch_max) / WAFERS_PER_LOT

function occ_lat(s::RouteStep, tg::ToolGroup)
    L, U = tg.load, tg.unload
    if s.unit == :Batch                       # whole-batch service, fill-independent
        base = s.pt + L + U
        return base, base
    elseif s.unit == :Wafer
        base = isnan(s.cascade) ? s.pt * WAFERS_PER_LOT + L + U :
                                  s.pt + s.cascade * (WAFERS_PER_LOT - 1) + L + U
        return base, base
    else                                      # :Lot
        if isnan(s.cascade)
            base = s.pt + L + U
            return base, base
        else
            return s.cascade + L + U, s.pt + L + U     # occ = throughput, lat = full PT
        end
    end
end

# ===========================================================================
# 2. Model builder.
#
# Global step ids: product 3 uses 1..583 (sink at 584); product 4 uses
# 1001..1343 (sink at 1344). A source stamps step = j0-1 (0 or 1000); the hub
# increments on deposit, so the first real step is reached with the mark already
# equal to its global id.
#
# DIFFUSION BATCHING DECISION (spec 4). Each of the 10 diffusion furnace groups
# is visited by 1-4 distinct (product, step) batch steps with different PTs. The
# data's batch criterion is "Same Product and Same Step", but Concourse's
# Batching gathers FCFS regardless of marks. We therefore SPLIT each furnace
# group into one Batching substation per (product, step), allocating the group's
# tools across substations by largest-remainder proportional to offered
# busy-minutes (group total preserved; every substation ends up with >=2 tools,
# so none is starved). This enforces homogeneous batches exactly, at the cost of
# lost furnace pooling flexibility -- a capacity-CONSERVATIVE approximation
# (dedicated tools can only raise utilization, never hide it). The alternative,
# a single pooled furnace with mixed batches, would violate the criterion and be
# optimistic (fuller batches). The mid-fill sanity check (analysis.md: diffusion
# max util ~89-90%) is what we hold the choice to in E2.

const P3_STEPS = Ref{Vector{RouteStep}}()
const P4_STEPS = Ref{Vector{RouteStep}}()

global_id(product, s) = product == 3 ? s : 1000 + s
seed_step(product) = product == 3 ? 0 : 1000
sink_step(product) = product == 3 ? 584 : 1344
sink_sym(product) = product == 3 ? :done3 : :done4

# Largest-remainder apportionment of `total` seats to integer weights, min 1.
function largest_remainder(weights::Vector{Float64}, total::Int)
    n = length(weights)
    n == 0 && return Int[]
    total < n && error("cannot give >=1 seat to $n substations from $total tools")
    sw = sum(weights)
    quota = [w / sw * total for w in weights]
    base = [max(1, floor(Int, q)) for q in quota]
    # If the min-1 floor already overshoots, strip from the largest.
    while sum(base) > total
        base[argmax(base)] -= 1
    end
    rem = total - sum(base)
    order = sortperm(quota .- floor.(quota); rev = true)
    for i in 1:rem
        base[order[mod1(i, n)]] += 1
    end
    base
end

"""
    build_model(tg, r3, r4; load, derate, rpt_mode, priority)

Compile the reduced HVLM fab. `load` is WSPW (release intervals scale as
10000/load). `derate` turns on the 1/A capacity inflation. `rpt_mode` sets every
batch minimum to 1 lot (the paper's RPT convention -- furnaces do not wait to
fill). `priority` gives hot lots non-preemptive precedence at every non-batch
tool.
"""
function build_model(tg, r3, r4; load = 10_000.0, derate = true,
                     rpt_mode = false, priority = true)
    net = QueueNetwork(param_names = (:dummy,))
    disc() = priority ? Priority(Mark(:prio)) : FCFS()

    # --- occupancy / deficit tables keyed by GLOBAL step id -----------------
    OCC = Dict{Int,Float64}()            # inflated tool-busy time per step
    DEF = Dict{Int,Float64}()            # lot-cascade latency deficit per step
    # destination of each reachable global step: :tool / :gate / :batch / :sink
    dest_kind = Dict{Int,Symbol}()
    dest_sym = Dict{Int,Symbol}()
    gate_p = Dict{Int,Float64}()         # gate -> execute probability
    gate_tool = Dict{Int,Symbol}()       # gate -> tool group station
    batch_of = Dict{Int,NamedTuple}()    # global step -> (sym, min, max)
    # per diffusion group: list of (global_step, per_lot_occ_weight)
    diff_steps = Dict{String,Vector{Tuple{Int,Float64}}}()

    for (product, steps) in ((3, r3), (4, r4))
        for s in steps
            g = tg[s.group]
            A = derate ? g.availability : 1.0
            occ, lat = occ_lat(s, g)
            occ_i = occ / A
            gid = global_id(product, s.step)
            OCC[gid] = occ_i
            DEF[gid] = max(0.0, lat - occ_i)
            if s.unit == :Batch
                dest_kind[gid] = :batch
                push!(get!(diff_steps, s.group, Tuple{Int,Float64}[]),
                      (gid, (s.pt + g.load + g.unload) / lots_mid(s)))
            elseif s.sample < 1.0
                dest_kind[gid] = :gate
                gate_p[gid] = s.sample
                gate_tool[gid] = Symbol(s.group)
            else
                dest_kind[gid] = :tool
                dest_sym[gid] = Symbol(s.group)
            end
        end
        dest_kind[sink_step(product)] = :sink
        dest_sym[sink_step(product)] = sink_sym(product)
    end

    # --- stations: tool groups (shared, re-entrant) -------------------------
    # One shared Opaque service law: it reads the step mark and looks the
    # inflated occupancy up in OCC, then draws Uniform(+-5%).
    tool_service = Opaque((θ, marks, te) -> begin
            o = max(get(OCC, Int(marks.step), 1e-6), 1e-9)
            Uniform(0.95 * o, 1.05 * o)
        end; marks = [:step])
    for (name, g) in tg
        g.batching && continue            # diffusion furnaces handled below
        if g.area == "Delay_32"
            station!(net, Symbol(name); servers = 1_000_000,
                     discipline = FCFS(), service = tool_service)
        else
            station!(net, Symbol(name); servers = g.n_tools,
                     discipline = disc(), service = tool_service)
        end
    end

    # --- stations: diffusion Batching substations ---------------------------
    for (grp, entries) in diff_steps
        g = tg[grp]
        weights = [w for (_, w) in entries]
        seats = largest_remainder(weights, g.n_tools)
        for (k, (gid, _)) in enumerate(entries)
            s_local = gid > 1000 ? gid - 1000 : gid
            product = gid > 1000 ? 4 : 3
            s = (product == 3 ? r3 : r4)[s_local]
            occ_i = OCC[gid]
            bmin = rpt_mode ? 1 : s.batch_min ÷ WAFERS_PER_LOT
            bmax = s.batch_max ÷ WAFERS_PER_LOT
            sym = Symbol("bt", gid)
            station!(net, sym; servers = seats[k], discipline = FCFS(),
                     batching = Batching(min = bmin, max = bmax),
                     service = Law(:Uniform, lower = Const(0.95 * occ_i),
                                   upper = Const(1.05 * occ_i)))
            batch_of[gid] = (sym = sym, min = bmin, max = bmax)
            route!(net, sym, Always(:hub))
        end
    end

    # --- stations: sampling gates -------------------------------------------
    for (gid, p) in gate_p
        sym = Symbol("g", gid)
        station!(net, sym; servers = 1_000_000, discipline = FCFS(),
                 service = Law(:Dirac, value = Const(0.0)))
        route!(net, sym, Probabilistic(gate_tool[gid] => p, :skiphub => 1 - p))
    end

    # --- shared hub + skip-hub ----------------------------------------------
    # Real hub: increment step, transport = Uniform(5,10)+deficit(previous step).
    hub_service = Opaque((θ, marks, te) -> begin
            d = get(DEF, Int(marks.step) - 1, 0.0)
            Uniform(5.0 + d, 10.0 + d)
        end; marks = [:step])
    station!(net, :hub; servers = 1_000_000, discipline = FCFS(),
             service = hub_service,
             remark = (step = Law(:Dirac, value = Mark(:step) + Const(1.0)),))
    station!(net, :skiphub; servers = 1_000_000, discipline = FCFS(),
             service = Law(:Dirac, value = Const(0.0)),
             remark = (step = Law(:Dirac, value = Mark(:step) + Const(1.0)),))

    # --- one ByMark over every reachable global step, shared by both hubs ----
    vals = sort!(collect(keys(dest_kind)))
    cutoffs = Float64[vals[i] + 0.5 for i in 1:length(vals) - 1]
    dests = Symbol[]
    for v in vals
        k = dest_kind[v]
        push!(dests, k == :batch ? batch_of[v].sym :
                     k == :gate  ? Symbol("g", v) :
                     dest_sym[v])
    end
    route!(net, :hub, ByMark(Mark(:step), cutoffs, dests))
    route!(net, :skiphub, ByMark(Mark(:step), cutoffs, dests))

    # non-batch tool groups route straight back to the hub
    for (name, g) in tg
        (g.batching) && continue
        route!(net, Symbol(name), Always(:hub))
    end

    # --- sinks and sources ---------------------------------------------------
    sink!(net, :done3)
    sink!(net, :done4)
    scale = 10_000.0 / load
    # (product, lot_type, prio, base interval)
    srcs = ((3, :reg, 2.0, 51.69), (3, :hot, 1.0, 2016.0),
            (4, :reg, 2.0, 51.69), (4, :hot, 1.0, 2016.0))
    for (product, lt, prio, iv) in srcs
        nm = Symbol("src_", product, "_", lt)
        source!(net, nm;
                interarrival = Law(:Dirac, value = Const(iv * scale)),
                mark = MarkLaw(
                    prod = Law(:Dirac, value = Const(float(product))),
                    prio = Law(:Dirac, value = Const(prio)),
                    step = Law(:Dirac, value = Const(float(seed_step(product))))))
        route!(net, nm, Always(:hub))
    end

    m = compile(net)
    return m
end

# ===========================================================================
# 3. Oracles computed in Julia from the reduced CSVs (no simulation). These
#    mirror analysis.py; they ignore rework (<2%, dropped from the reduced
#    schema) so they land a touch below the analysis.md numbers, which is why
#    the hard-coded RPT_ORACLE / UTIL_ORACLE constants above are the gate.

function rpt_oracle_jl(steps, tg)
    total = 0.0
    for s in steps
        g = tg[s.group]
        _, lat = occ_lat(s, g)
        total += s.sample * (lat + 7.5)      # expected executions * (latency + transport)
    end
    total / DAY
end

# ===========================================================================
# 4. Measurement: one streaming fold over the record. Because batch synthetic
#    jobs consume job ids, arrival order != job id, so we replay fire_changes
#    and read lifecycle from state membership: a job is BORN at its :arrival
#    (its id is the pre-fire next_id) and DIES when its own firing routes it to
#    a sink (it vanishes from st.jobs). `tool_idx` names the stations whose
#    time-average busy-server count we integrate for utilization.

function fold_record(m, rec; tool_idx = Int[], want_ct = false, t_start = 0.0,
                     wip_points = 0)
    params = m.params
    st = initial_state(m, Concourse.replaydraws(Concourse.INIT_KEY, rec.init, params))
    acc = zeros(length(tool_idx))                  # busy-server-time over [t_start, H]
    tprev = 0.0
    birth = Dict{Int,NTuple{3,Float64}}()          # id -> (prod, prio, birth time)
    comps = NTuple{4,Float64}[]                    # (prod, prio, cycle time, release)
    wgrid = wip_points > 0 ? collect(range(0.0, rec.horizon; length = wip_points)) : Float64[]
    wip = zeros(length(wgrid))
    gi = 1
    for i in eachindex(rec.key)
        t = rec.time[i]
        if !isempty(tool_idx)
            lo = max(tprev, t_start)               # accumulate only inside the window
            if t > lo
                dt = t - lo
                @inbounds for a in eachindex(tool_idx)
                    acc[a] += length(st.srv[tool_idx[a]]) * dt
                end
            end
        end
        if wip_points > 0
            n = Concourse.number_in_system(st)
            while gi <= length(wgrid) && wgrid[gi] <= t
                wip[gi] = n; gi += 1
            end
        end
        nid = st.next_id
        ds = Concourse.replaydraws(rec.key[i], rec.draws[i], params)
        st, _ = fire_changes(m, st, rec.key[i], t, ds)
        if want_ct
            k = rec.key[i]
            if k[1] == :arrival
                haskey(st.jobs, nid) && (mk = st.jobs[nid];
                    birth[nid] = (mk.prod, mk.prio, t))
            else
                j = Int(k[3])
                if haskey(birth, j) && !haskey(st.jobs, j)
                    (p, pr, bt) = birth[j]
                    push!(comps, (p, pr, t - bt, bt))
                    delete!(birth, j)
                end
            end
        end
        tprev = t
    end
    if !isempty(tool_idx)
        lo = max(tprev, t_start)
        @inbounds for a in eachindex(tool_idx)
            acc[a] += length(st.srv[tool_idx[a]]) * (rec.horizon - lo)
        end
    end
    if wip_points > 0
        n = Concourse.number_in_system(st)
        while gi <= length(wgrid); wip[gi] = n; gi += 1; end
    end
    busy = isempty(tool_idx) ? Float64[] : acc ./ (rec.horizon - t_start)
    return (busy = busy, comps = comps, wgrid = wgrid ./ DAY, wip = wip)
end

# ---------------------------------------------------------------------------
# Map each tool group to its station indices and total tool count (diffusion
# substations aggregate back to their parent group for reporting).
function group_station_map(m, tg, r3, r4)
    # collect diffusion substation symbols per group
    subs = Dict{String,Vector{Symbol}}()
    for (product, steps) in ((3, r3), (4, r4))
        for s in steps
            s.unit == :Batch || continue
            push!(get!(subs, s.group, Symbol[]), Symbol("bt", global_id(product, s.step)))
        end
    end
    gmap = Dict{String,Tuple{Vector{Int},Int}}()    # group -> (station idxs, total tools)
    for (name, g) in tg
        g.area == "Delay_32" && continue
        if g.batching
            idxs = [m.names[sym] for sym in unique(subs[name])]
            gmap[name] = (idxs, g.n_tools)
        else
            gmap[name] = ([m.names[Symbol(name)]], g.n_tools)
        end
    end
    gmap
end

# ===========================================================================
# 5. Experiments.

# --- E0: benchmark -------------------------------------------------------
function e0_benchmark(tg, r3, r4)
    println("== E0: benchmark ==")
    t_compile = @elapsed m = build_model(tg, r3, r4; load = E2_LOAD, derate = true)
    println("  stations = $(length(m.stations))   compile = $(round(t_compile, digits = 2)) s")
    flush(stdout)
    # Warm the fab to steady state (WIP ~1500 lots) BEFORE timing: from empty the
    # state is tiny and throughput is unrepresentatively high. We time a 20-day
    # window at full WIP by differencing a 30-day and a 50-day run.
    simulate(m, [0.0], 2.0 * DAY; seed = 1)          # JIT
    GC.gc()
    t30 = @elapsed rec30 = simulate(m, [0.0], 30.0 * DAY; seed = 7)
    n30 = length(rec30)
    t50 = @elapsed rec50 = simulate(m, [0.0], 50.0 * DAY; seed = 7)
    n50 = length(rec50)
    bytes = Base.summarysize(rec50)
    steady_evs = (n50 - n30) / (t50 - t30)           # events/s over the 30-50d window
    ev_per_day = (n50 - n30) / 20.0                  # steady firings per sim-day
    bpf = bytes / n50
    @printf("  steady (30-50 sim-day window, WIP ~1500): events/s = %.0f  firings/sim-day = %.0f  bytes/firing = %.1f\n",
            steady_evs, ev_per_day, bpf)
    @printf("  => a 1e7-firing record ~ %.0f sim-days, ~%.2f GB; the E2/E3 records (~5M) fit in RAM\n",
            1e7 / ev_per_day, 1e7 * bpf / 1e9)
    if steady_evs < 5000
        @printf("  WARNING: steady throughput %.0f/s below the 5000/s comfort floor.\n", steady_evs)
    end
    flush(stdout)
    (events_per_s = steady_evs, events_per_day = ev_per_day, bytes_per_firing = bpf,
     compile_s = t_compile)
end

# --- E1: raw processing time --------------------------------------------
function e1_rpt(tg, r3, r4)
    println("\n== E1: raw processing time (empty fab, rpt_mode) ==")
    # load = 1 WSPW makes the regular interval 51.69*10000 = 516900 min, far
    # longer than any lot's ~40000-min cycle time, so the fab holds at most one
    # lot per product at a time -> raw processing time with no queueing.
    m = build_model(tg, r3, r4; load = 1.0, derate = false, rpt_mode = true,
                    priority = false)
    horizon = (E1_N_LOTS + 1) * 51.69 * 10_000.0     # ~E1_N_LOTS lots per product
    rec = simulate(m, [0.0], horizon; seed = 3)
    fr = fold_record(m, rec; want_ct = true)
    comps = fr.comps
    ct3 = [c[3] for c in comps if c[1] == 3.0] ./ DAY
    ct4 = [c[3] for c in comps if c[1] == 4.0] ./ DAY
    orc3 = rpt_oracle_jl(r3, tg)
    orc4 = rpt_oracle_jl(r4, tg)
    @printf("  product 3: sim RPT = %.2f d (n=%d)   arith(jl,no-rework) = %.2f d   oracle = %.2f d   paper = %.2f d\n",
            mean(ct3), length(ct3), orc3, RPT_ORACLE.p3, RPT_PAPER.p3)
    @printf("  product 4: sim RPT = %.2f d (n=%d)   arith(jl,no-rework) = %.2f d   oracle = %.2f d   paper = %.2f d\n",
            mean(ct4), length(ct4), orc4, RPT_ORACLE.p4, RPT_PAPER.p4)
    g3 = abs(mean(ct3) - RPT_ORACLE.p3) / RPT_ORACLE.p3
    g4 = abs(mean(ct4) - RPT_ORACLE.p4) / RPT_ORACLE.p4
    @printf("  gate |sim-oracle|/oracle: p3 = %.2f%%  p4 = %.2f%%  (target <= 2%%)\n",
            100g3, 100g4)
    flush(stdout)
    (p3 = mean(ct3), p4 = mean(ct4), g3 = g3, g4 = g4, ct3 = ct3, ct4 = ct4)
end

# --- E2: utilization at 10,000 WSPW -------------------------------------
function e2_utilization(tg, r3, r4)
    println("\n== E2: utilization at $(Int(E2_LOAD)) WSPW ==")
    m = build_model(tg, r3, r4; load = E2_LOAD, derate = true, priority = true)
    gmap = group_station_map(m, tg, r3, r4)
    horizon = (E2_WARMUP_DAYS + E2_MEASURE_DAYS) * DAY
    @printf("  simulating %.0f sim-days (warmup %.0f + measure %.0f)...\n",
            (E2_WARMUP_DAYS + E2_MEASURE_DAYS), E2_WARMUP_DAYS, E2_MEASURE_DAYS)
    flush(stdout)
    t = @elapsed rec = simulate(m, [0.0], horizon; seed = 11)
    @printf("  %d firings in %.1fs (%.0f/s)\n", length(rec), t, length(rec) / t)
    flush(stdout)
    all_idx = Int[]
    for (_, (idxs, _)) in gmap, s in idxs
        push!(all_idx, s)
    end
    unique!(all_idx)
    # Single fold: busy fractions over the MEASUREMENT window (t > warmup) and
    # the WIP trajectory over the whole record (warmup diagnostic).
    fr = fold_record(m, rec; tool_idx = all_idx, t_start = E2_WARMUP_DAYS * DAY,
                     wip_points = 500)
    tgrid, wip = fr.wgrid, fr.wip
    busy = fr.busy
    busyd = Dict(all_idx[a] => busy[a] for a in eachindex(all_idx))
    # per group util = total busy servers / total tools
    gutil = Dict{String,Float64}()
    for (name, (idxs, ntot)) in gmap
        gutil[name] = sum(busyd[s] for s in idxs) / ntot
    end
    # aggregate per area
    println("\n  area        sim_avg  sim_max | oracle_avg oracle_max | paper_avg paper_max")
    arearows = Dict{String,Tuple{Float64,Float64}}()
    for area in AREA_ORDER
        gs = [name for (name, g) in tg if g.area == area]
        us = [100 * gutil[name] for name in gs]
        savg, smax = mean(us), maximum(us)
        arearows[area] = (savg, smax)
        oa, ox = UTIL_ORACLE[area]
        pa, px = UTIL_PAPER[area]
        @printf("  %-11s %7.1f  %7.1f | %9.1f %10.1f | %8.1f %8.1f\n",
                area, savg, smax, oa, ox, pa, px)
    end
    flush(stdout)
    (gutil = gutil, arearows = arearows, tgrid = tgrid, wip = wip, rec_len = length(rec))
end

# --- E3: operating curve -------------------------------------------------
function e3_operating_curve(tg, r3, r4)
    println("\n== E3: operating curve (FF percentiles vs load) ==")
    RPT_days = (p3 = RPT_PAPER.p3, p4 = RPT_PAPER.p4)
    pcts = [5, 25, 50, 75, 95]
    reg_curve = Dict{Int,Vector{Float64}}(p => Float64[] for p in pcts)
    hot_med = Float64[]
    split_half = Float64[]
    loads = E3_LOADS
    horizon = (E3_WARMUP_DAYS + E3_MEASURE_DAYS) * DAY
    warm = E3_WARMUP_DAYS * DAY
    for load in loads
        m = build_model(tg, r3, r4; load = load, derate = true, priority = true)
        t = @elapsed rec = simulate(m, [0.0], horizon; seed = 101)
        comps = fold_record(m, rec; want_ct = true).comps
        # FF = CT / RPT_paper(product); pool regular lots RELEASED after warmup
        # (release time = birth = comps[4]); hot lots overlaid separately.
        # Pool lots released in [warmup, horizon - buffer]: the upper bound gives
        # every pooled lot a long window to finish, so long-CT lots near capacity
        # are not preferentially right-censored out of the tail.
        rel_hi = horizon - E3_COMPLETE_BUFFER_DAYS * DAY
        regff = Float64[]
        hotff = Float64[]
        for (p, pr, ct, rel) in comps
            (warm < rel < rel_hi) || continue
            rptd = p == 3.0 ? RPT_days.p3 : RPT_days.p4
            ff = (ct / DAY) / rptd
            pr == 2.0 ? push!(regff, ff) : push!(hotff, ff)
        end
        qs = isempty(regff) ? fill(NaN, length(pcts)) : quantile(regff, pcts ./ 100)
        for (k, p) in enumerate(pcts)
            push!(reg_curve[p], qs[k])
        end
        push!(hot_med, isempty(hotff) ? NaN : median(hotff))
        # split-half dispersion of the median (stability diagnostic)
        h = length(regff) ÷ 2
        sh = h < 1 ? NaN : abs(median(regff[1:h]) - median(regff[h+1:end]))
        push!(split_half, sh)
        @printf("  load %5.0f WSPW (%.3f cap): n_reg=%d median FF=%.2f [5%%=%.2f 95%%=%.2f] hotFF=%.2f  split-half=%.3f  (%d firings, %.0fs)\n",
                load, load / CAPACITY_WSPW, length(regff), qs[3], qs[1], qs[5],
                isempty(hotff) ? NaN : median(hotff), sh, length(rec), t)
        flush(stdout)
    end
    (loads = loads, pcts = pcts, reg_curve = reg_curve, hot_med = hot_med,
     split_half = split_half)
end

# ===========================================================================
# 6. Figures.

function savefig_both(plt, name)
    for sub in (["..", "docs", "figures"], ["..", "docs", "src", "manual", "figures"])
        dir = joinpath(@__DIR__, sub...)
        mkpath(dir)
        savefig(plt, joinpath(dir, name))
    end
end

function figure_utilization(e2)
    areas = AREA_ORDER
    sim_avg = [e2.arearows[a][1] for a in areas]
    sim_max = [e2.arearows[a][2] for a in areas]
    ora_avg = [UTIL_ORACLE[a][1] for a in areas]
    pap_avg = [UTIL_PAPER[a][1] for a in areas]
    y = collect(1:length(areas))
    # Explicit ylims: horizontal `bar!` lengths otherwise leak into the y-axis
    # autoscale and squash all 11 category rows into the bottom ~10% of the
    # canvas (the original bug). Pinning the y-range to the category band makes
    # the bars fill the plot and the area labels legible.
    # Legend OUTSIDE the axes (:outerbottom, horizontal) so it never covers the
    # Diffusion/Dielectric bar ends or their simulated-max ticks.
    plt = plot(size = (950, 740), dpi = 150, left_margin = 12mm, bottom_margin = 6mm,
               top_margin = 5mm, right_margin = 8mm,
               legend = :outerbottom, legendcolumns = 3, legendfontsize = 8,
               title = "SMT2020 HVLM utilization by area (10,000 WSPW)",
               titlefontsize = 11, xlabel = "utilization of available capacity (%)",
               yticks = (y, areas), ytickfontsize = 8,
               ylims = (0.4, length(areas) + 0.6), xlim = (0, 105))
    bh = 0.27
    bar!(plt, y .+ bh, sim_avg; orientation = :h, bar_width = bh, label = "simulated avg",
         color = :steelblue, alpha = 0.9)
    bar!(plt, y, ora_avg; orientation = :h, bar_width = bh, label = "arithmetic avg",
         color = :darkorange, alpha = 0.9)
    bar!(plt, y .- bh, pap_avg; orientation = :h, bar_width = bh, label = "paper avg",
         color = :seagreen, alpha = 0.9)
    scatter!(plt, sim_max, y .+ bh; marker = (:vline, 8), color = :black,
             label = "simulated max")
    vline!(plt, [97.4]; ls = :dash, color = :red, label = "Litho bottleneck (97.4%)")
    savefig_both(plt, "smt2020_utilization.png")
    plt
end

function figure_operating_curve(e3)
    x = e3.loads ./ CAPACITY_WSPW
    p = e3.pcts
    plt = plot(size = (860, 560), dpi = 150, left_margin = 6mm, bottom_margin = 6mm,
               top_margin = 5mm, right_margin = 4mm, legend = :topleft,
               title = "SMT2020 HVLM operating curve: flow factor vs load",
               titlefontsize = 11, xlabel = "load / capacity (10,200 WSPW)",
               ylabel = "FF = cycle time / raw processing time")
    band_lo = e3.reg_curve[5]
    band_hi = e3.reg_curve[95]
    plot!(plt, x, band_hi; fillrange = band_lo, fillalpha = 0.20, color = :steelblue,
          lw = 0, label = "sim 5-95% band")
    plot!(plt, x, e3.reg_curve[50]; lw = 2.5, color = :steelblue, marker = :circle,
          ms = 4, label = "sim median FF")
    plot!(plt, x, e3.hot_med; lw = 2, color = :crimson, marker = :diamond, ms = 4,
          label = "sim hot-lot median FF")
    # paper reference values at 10,000 WSPW
    xr = 10_000.0 / CAPACITY_WSPW
    scatter!(plt, [xr, xr, xr], [FF_PAPER_10K.p50, FF_PAPER_10K.p05, FF_PAPER_10K.p95];
             marker = :star5, ms = 7, color = :seagreen,
             label = "paper 5/50/95% @10k")
    savefig_both(plt, "smt2020_operating_curve.png")
    plt
end

function figure_reentrant(tg, r3)
    # step index vs area, colored by area -- the "44 mask layers" sawtooth.
    areas = unique([tg[s.group].area for s in r3])
    aidx = Dict(a => i for (i, a) in enumerate(sort(areas)))
    xs = [s.step for s in r3]
    ys = [aidx[tg[s.group].area] for s in r3]
    plt = plot(size = (960, 520), dpi = 150, left_margin = 14mm, bottom_margin = 6mm,
               top_margin = 5mm, right_margin = 4mm, legend = false,
               title = "SMT2020 HVLM product 3 route: re-entrant flow (583 steps)",
               titlefontsize = 11, xlabel = "route step", ylabel = "process area",
               yticks = (1:length(aidx), sort(areas)))
    plot!(plt, xs, ys; lw = 0.8, color = :gray, alpha = 0.5)
    scatter!(plt, xs, ys; zcolor = ys, ms = 3, markerstrokewidth = 0,
             color = :turbo, colorbar = false)
    savefig_both(plt, "smt2020_reentrant.png")
    plt
end

function figure_wip(e2)
    plt = plot(size = (820, 460), dpi = 150, left_margin = 6mm, bottom_margin = 6mm,
               top_margin = 5mm, right_margin = 4mm, legend = :bottomright,
               title = "SMT2020 HVLM WIP ramp (warmup diagnostic, 10,000 WSPW)",
               titlefontsize = 11, xlabel = "simulated day", ylabel = "lots in system")
    plot!(plt, e2.tgrid, e2.wip; lw = 1.6, color = :steelblue, label = "WIP")
    vline!(plt, [E2_WARMUP_DAYS]; ls = :dash, color = :red,
           label = "warmup cut = $(Int(E2_WARMUP_DAYS)) d")
    savefig_both(plt, "smt2020_wip.png")
    plt
end

# ===========================================================================

function main()
    println("SMT2020 dataset-1 (HVLM) reduced fab model")
    tg = load_toolgroups()
    r3 = load_route("route_product3.csv")
    r4 = load_route("route_product4.csv")
    P3_STEPS[] = r3
    P4_STEPS[] = r4
    println("loaded: $(length(tg)) tool groups, route 3 = $(length(r3)) steps, ",
            "route 4 = $(length(r4)) steps")

    e0 = e0_benchmark(tg, r3, r4)
    e1 = e1_rpt(tg, r3, r4)
    e2 = e2_utilization(tg, r3, r4)
    e3 = e3_operating_curve(tg, r3, r4)

    println("\n== figures ==")
    figure_utilization(e2)
    figure_operating_curve(e3)
    figure_reentrant(tg, r3)
    figure_wip(e2)
    println("wrote smt2020_utilization / _operating_curve / _reentrant / _wip .png",
            " to docs/figures and docs/src/manual/figures")
    return (e0 = e0, e1 = e1, e2 = e2, e3 = e3)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
