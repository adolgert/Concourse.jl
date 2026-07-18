# The BCMP oracle (docs/bcmp_hpc.md): a multi-class network whose stations
# are all BCMP types has product form, so every station's mean occupancy is
# a closed form of the traffic equations. This is the strongest network-wide
# oracle in the charter: classes (marks), class-dependent PS laws, a
# class-independent FCFS station, a 64-server delay station, probabilistic
# routing, and a routing CYCLE, all checked at once within 4 SE.

function bcmp_hpc()
    net = QueueNetwork(param_names = (:lambda_debug, :lambda_prod))
    classmarks(login, comp, io, class) = MarkLaw(
        class = Law(:Dirac, value = Const(class)),
        login_s = Law(:Dirac, value = Const(login)),
        comp_s = Law(:Dirac, value = Const(comp)),
        io_s = Law(:Dirac, value = Const(io)))
    source!(net, :debug_in;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda_debug))),
            mark = classmarks(0.05, 1.0, 0.04, 0.0))
    source!(net, :prod_in;
            interarrival = Law(:Exponential, scale = inv(Param(:lambda_prod))),
            mark = classmarks(0.10, 6.0, 0.20, 1.0))
    station!(net, :login; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Gamma, shape = Const(2.0),
                           scale = Const(0.5) * Mark(:login_s)))
    station!(net, :sched; discipline = FCFS(), servers = 1,
             service = Law(:Exponential, scale = Const(0.15)))
    station!(net, :compute; discipline = FCFS(), servers = 64,
             service = Law(:Exponential, scale = Mark(:comp_s)))
    station!(net, :fs; discipline = ProcessorSharing(), servers = 1,
             service = Law(:Exponential, scale = Mark(:io_s)))
    sink!(net, :done)
    route!(net, :debug_in, Always(:login))
    route!(net, :prod_in, Always(:login))
    route!(net, :login, Always(:sched))
    route!(net, :sched, Always(:compute))
    route!(net, :compute, Probabilistic(:fs => 0.75, :done => 0.25))
    route!(net, :fs, Always(:compute))
    compile(net)
end

# Time-averaged number present at every station, in ONE replay pass — the
# replay dominates the testset's cost.
function bcmp_station_means(m, rec, stations)
    sts = replay(m, rec)
    times = vcat(rec.time, rec.horizon)
    tot = Dict(s => 0.0 for s in stations)
    t0 = 0.0
    for (i, t) in enumerate(times)
        dt = t - t0
        for s in stations
            tot[s] += dt * (length(sts[i].buf[s]) + length(sts[i].srv[s]) +
                            length(sts[i].hold[s]))
        end
        t0 = t
    end
    Dict(s => v / rec.horizon for (s, v) in tot)
end

wanted("bcmp hpc network matches the product form at every station") &&
@testset "bcmp hpc network matches the product form at every station" begin
    m = bcmp_hpc()
    θ = [2.0, 0.5]
    # Loads from the traffic equations (visits: login 1, sched 1, compute
    # 1/(1-p) = 4, fs p/(1-p) = 3), means from the per-type closed forms.
    ρ = (login = 2.0 * 0.05 + 0.5 * 0.10,
         sched = 2.5 * 0.15,
         comp = 4 * (2.0 * 1.0 + 0.5 * 6.0),
         fs = 3 * (2.0 * 0.04 + 0.5 * 0.20))
    want = (login = ρ.login / (1 - ρ.login), sched = ρ.sched / (1 - ρ.sched),
            compute = ρ.comp, fs = ρ.fs / (1 - ρ.fs))
    R = 10
    sids = [m.names[s] for s in (:login, :sched, :compute, :fs)]
    per = [bcmp_station_means(m, simulate(m, θ, 2000.0; seed = 4000 + r), sids)
           for r in 1:R]
    for (name, s) in zip((:login, :sched, :compute, :fs), sids)
        vals = [p[s] for p in per]
        est, se = mean(vals), std(vals) / sqrt(R)
        @test within4se(est, se, getfield(want, name))
    end
end
