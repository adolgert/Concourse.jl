# F1 completed: SRPT's ordering key is remaining size — a mark minus a clock
# age — so it reads the A1 bookkeeping (te live, bank banked) rather than a
# pure mark expression. With Dirac service laws the whole trajectory is
# deterministic given arrival times, which gives an exact preemption oracle.

function srpt_station(sizelaw)
    net = QueueNetwork(param_names = (:lambda,))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = sizelaw))
    station!(net, :cpu; discipline = SRPT(), servers = 1,
             service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu))
    route!(net, :cpu, Always(:done))
    compile(net)
end

wanted("srpt preemption trace is exact for dirac sizes") &&
@testset "srpt preemption trace is exact for dirac sizes" begin
    # Job 1 (size 3) arrives at t=0; job 2 (size 1) arrives at t=1 and
    # preempts (remaining 2 > 1); job 2 completes at t=2; job 1 resumes with
    # banked age 1 (te shifts to 1) and completes at t=4.
    m = srpt_station(Law(:Uniform, a = Const(0.0), b = Const(1.0)))
    cpu = Int32(m.names[:cpu])
    arr = (:arrival, Int32(m.names[:arrive]), Concourse.JobId(0))
    k1 = (:service, cpu, Concourse.JobId(1))
    k2 = (:service, cpu, Concourse.JobId(2))
    dl(size) = Concourse.DrawList([:size => size])
    st = Concourse.initial_state(m)

    st, d = fire_changes(m, st, arr, 0.0, Concourse.replaydraws(arr, dl(3.0), m.params))
    @test (:enable, k1) in d && st.te[k1] == 0.0
    @test clock_distribution(m, [1.0], k1, st).value == 3.0

    st, d = fire_changes(m, st, arr, 1.0, Concourse.replaydraws(arr, dl(1.0), m.params))
    @test (:disable, k1) in d && (:enable, k2) in d
    @test st.bank[k1] == 1.0 && !haskey(st.te, k1)
    @test st.te[k2] == 1.0

    st, d = fire_changes(m, st, k2, 2.0, Concourse.replaydraws(k2, Concourse.DrawList(), m.params))
    @test (:enable, k1) in d
    @test st.te[k1] == 1.0 && !haskey(st.bank, k1)   # resumes with its age
    # The resumed clock's declared law: Dirac(3) anchored te=1 fires at t=4.
    @test clock_distribution(m, [1.0], k1, st).value == 3.0
end

wanted("srpt with equal sizes degenerates to fcfs and matches m/d/1") &&
@testset "srpt with equal sizes degenerates to fcfs and matches m/d/1" begin
    m = srpt_station(Law(:Dirac, value = Const(0.5)))
    θ = [1.0]                       # ρ = 0.5, P-K with CV = 0: L = 0.75
    est, se = replicate(r -> time_average(number_in_system, m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, 0.75)
    # Equal remaining sizes must never preempt.
    _, states = simulate(m, θ, 500.0; seed = 41, keep_states = true, debug = true)
    @test all(isempty(st.bank) for st in states)
end

wanted("srpt undercuts fcfs mean number at the same load") &&
@testset "srpt undercuts fcfs mean number at the same load" begin
    # SRPT minimizes E[N] among all disciplines; with variable sizes at
    # ρ = 0.8 the gap is large. Same seeds pair the arrival processes and
    # marks (keyed streams), so the difference is low-variance.
    sizelaw = Law(:Uniform, a = Const(0.4), b = Const(1.6))
    ms = srpt_station(sizelaw)
    net = QueueNetwork(param_names = (:lambda,))
    source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))),
            mark = MarkLaw(size = sizelaw))
    station!(net, :cpu; service = Law(:Dirac, value = Mark(:size)))
    sink!(net, :done)
    route!(net, :arrive, Always(:cpu)); route!(net, :cpu, Always(:done))
    mf = compile(net)
    θ = [0.8]
    diffs = [time_average(number_in_system, mf, simulate(mf, θ, 2000.0; seed = 600 + r)) -
             time_average(number_in_system, ms, simulate(ms, θ, 2000.0; seed = 600 + r))
             for r in 1:12]
    @test mean(diffs) - 4 * std(diffs) / sqrt(12) > 0
end

wanted("f4 replay reproduces srpt banking exactly") &&
@testset "f4 replay reproduces srpt banking exactly" begin
    m = srpt_station(Law(:Uniform, a = Const(0.4), b = Const(1.6)))
    rec, live = simulate(m, [1.2], 400.0; seed = 9, keep_states = true, debug = true)
    folded = replay(m, rec)
    @test all(states_equal(a, b) for (a, b) in zip(live, folded))
    @test any(!isempty(st.bank) for st in live)   # preemption actually occurred
end
