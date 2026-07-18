# Concourse.jl

Concourse builds queueing-network models. It compiles each network to a
generalized semi-Markov process (GSMP), simulates it with
[CompetingClocks.jl](https://github.com/adolgert/CompetingClocks.jl), and
estimates derivatives of simulation output with
[ClockGradients.jl](https://github.com/adolgert/ClockGradients.jl). The same
model value drives the simulator and every derivative estimator.

## Quickstart

An M/M/1 queue: Poisson arrivals at rate λ = 1, one server at rate μ = 2.
The long-run number of jobs in the system should be ρ/(1−ρ) = 1 at
utilization ρ = λ/μ = 0.5.

```@example quickstart
using Concourse
net = QueueNetwork(param_names = (:lambda, :mu))
source!(net, :arrive; interarrival = Law(:Exponential, scale = inv(Param(:lambda))))
station!(net, :counter; discipline = FCFS(), servers = 1,
         service = Law(:Exponential, scale = inv(Param(:mu))))
sink!(net, :done)
route!(net, :arrive, Always(:counter))
route!(net, :counter, Always(:done))
model = compile(net)
record = simulate(model, [1.0, 2.0], 2000.0; seed = 42)
time_average(number_in_system, model, record)
```

The simulation agrees with the formula. That check — simulation against
closed-form theory, on the page — is the pattern this documentation repeats
wherever theory exists.

## Where to start

- **New to queueing theory?** Start with [Queues](queues/jobs_servers.md), a
  tutorial that teaches queueing through pictures and simulations you can run.
- **Know queueing and want to do research with this tool?** Start with the
  [Manual](manual/record_replay.md): records and replay, trajectory
  splitting, gradient estimation, statistical analysis.
- **Want to understand or extend the design?** Start with the
  [Developer](developer/architecture.md) section, which explains the
  three-layer architecture and the reasoning behind the model contract.

The [Reference](reference/surface.md) section documents every exported name,
grouped by architectural layer.
