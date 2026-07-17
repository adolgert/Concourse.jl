# Model Summary: Quarton.jl Queueing Theory Package

## Overview

Quarton.jl represents queueing theory through a bipartite graph model where jobs (tokens) flow between two types of nodes: queues and servers. The design emphasizes extensibility through abstract types and strategy patterns, allowing users to customize behavior at multiple points of variation.

## Core Conceptual Model

### The Bipartite Graph Structure

The fundamental constraint is that **jobs alternate between queues and servers**:
- When a job leaves a queue, it must go to a server
- When a job leaves a server, it must go to a queue
- Every server has exactly one input queue
- Queues and servers can have multiple outputs

This creates a bipartite directed graph where there are no queue-to-queue or server-to-server edges.

### Event-Driven Simulation

The system operates through discrete events triggered by servers completing work:

1. A server completes processing a token at time `T`
2. The server becomes available and sends its token to downstream queue(s)
3. The queue that received the token checks if any downstream servers are available
4. The queue that feeds the completed server checks if it can start new work on that server
5. Time advances to the next server completion event

## Main Object Types

### 1. Tokens (Jobs/Work)

**Abstract Type**: `Token`

**Implementations**:
- `Work` - Basic token with workload, creation time, and accumulated delay
- `CountedWork` - Token with an additional `mark` field for routing decisions

**Purpose**: Represents jobs flowing through the system. Tokens carry:
- Workload amount (affects service time)
- Creation timestamp (for measuring response time)
- Accumulated delay (time spent in queues)
- Optional state for routing decisions

**Point of Variation**: Users can define custom token types by subtyping `Token` and implementing:
- `workload(t)` - Returns work amount
- `created(t)` - Returns creation time
- `create!(t, when)` - Sets creation time
- `add_delay!(t, delay)` - Accumulates queue delay
- `delay(t)` - Returns total delay

### 2. Queues

**Abstract Type**: `Queue`

**Implementations**:
- `FIFOQueue{T}` - First-in-first-out queue
- `RandomQueue{T}` - Randomly selects next job
- `FiniteFIFOQueue{T}` - FIFO with capacity limit (drops excess jobs)
- `InfiniteSourceQueue{T}` - Generates new tokens on demand
- `SummarySink{T}` - Collects completion statistics

**Purpose**: Queues hold tokens and decide which tokens go to which available servers.

**Key Methods**:
- `push!(q, token, when)` - Add token to queue at time `when`
- `update_downstream!(q, downstream, when, rng)` - Called when downstream servers become available; decides which tokens move to which servers
- `length(q)` - Current queue size
- `total_work(q)` - Sum of workload in queue

**Point of Variation**: Users can create custom queues by:
- Subtyping `Queue`
- Implementing storage (how tokens are held)
- Implementing `update_downstream!` (which tokens go to which servers)
- Tracking custom metrics (throughput, drops, etc.)

**Distinction**: Special subtypes exist for sources (`SourceQueue`) and sinks (`SinkQueue`) that generate or absorb tokens respectively.

### 3. Servers

**Abstract Type**: `Server`

**Implementations**:
- `ModifyServer` - Processes tokens at a specified rate, optionally modifying them
- `ArrivalServer` - Generates arrivals at a specified rate (pairs with `InfiniteSourceQueue`)

**Purpose**: Servers process tokens for random time durations, then send them to downstream queues.

**Key Components**:
- `rate` - Processing rate (converts token workload to Exponential distribution)
- `modify_token` - Function to transform token state during processing
- `disbursement` - Strategy for choosing destination queue(s)

**Key Methods**:
- `rate(s, token)` - Returns distribution for processing time
- `modify!(s, token, when)` - Modifies token state
- `update_downstream!(s, downstream, when, rng)` - Delegates to disbursement strategy

**Point of Variation**: Users can create custom servers by:
- Subtyping `Server`
- Implementing `rate(s, token)` for custom time distributions
- Implementing `modify!(s, token, when)` for token transformations
- Implementing `update_downstream!` for custom routing logic

### 4. Assignment Strategies (Disbursement)

**Abstract Type**: `Assignment`

**Implementations**:
- `RoundRobin` - Cycles through destination queues
- `RandomAssignment` - Randomly selects destination
- `ShortestQueueAssignment` - Chooses queue with fewest jobs
- `LeastWorkLeft` - Chooses queue with least total workload
- `SizeIntervalAssignment` - Routes based on token properties (SITA policy)

**Purpose**: Encapsulates the decision logic for where tokens go when leaving a server. This is the "task assignment policy" in queueing theory.

**Key Method**:
- `update_downstream!(a, downstream, when, rng)` - Implements routing logic

**Point of Variation**: Users can define custom routing strategies by:
- Subtyping `Assignment`
- Implementing `update_downstream!` with access to:
  - `queues(downstream)` - All downstream queues
  - `queues_with_role(downstream, role)` - Queues matching a role
  - `finished_job(downstream)` - The token being routed
  - Queue properties like `length()` and `total_work()`

### 5. QueueModel

**Type**: `QueueModel{T<:Token}`

**Purpose**: The top-level container that holds the entire queueing network.

**Components**:
- `network::BiGraph` - The bipartite graph structure
- `server::Vector{Server}` - All servers
- `queue::Vector{Queue}` - All queues
- `server_available::Vector{Bool}` - Server busy/idle state
- `server_tokens::Vector{T}` - Current token each server is processing
- `server_role::Dict` - Role labels for queue→server edges
- `queue_role::Dict` - Role labels for server→queue edges

**Key Methods**:
- `add_server!(m, server, name)` - Register a server
- `add_queue!(m, queue, name)` - Register a queue
- `connect!(m, source, target, role)` - Create edge with role label
- `@pipe!` - Macro for convenient connection: `@pipe! model source => target :role`
- `check_model(m)` - Validates graph structure
- `step!(m, trajectory, event)` - Advances simulation by one event

**Role Labels**: Edges can be labeled with symbols (`:only`, `:high`, `:low`, etc.) to enable routing decisions based on connection semantics rather than just topology.

### 6. Trajectory

**Type**: `Trajectory`

**Purpose**: Manages the simulation execution and random number generation.

**Components**:
- `sampler::SSA` - Stochastic simulation algorithm (First-to-Fire)
- `time::Float64` - Current simulation time
- `rng::Xoshiro` - Random number generator
- `modified_servers::Set{Int}` - Tracking for event propagation
- `modified_queues::Set{Int}` - Tracking for event propagation

**Key Methods**:
- `next(t)` - Returns `(when, which_server)` for next event
- `start!(t, server, rate)` - Schedule server completion
- `stop!(t, server_id, time)` - Mark server completion

**Separation of Concerns**: The trajectory is separate from the model, which:
- Allows multiple trajectories to share one model (parallel sampling)
- Enables model analysis without simulation (e.g., likelihood evaluation)
- Supports immutable model definitions

### 7. Downstream Flyweights

**Types**: `QueueDownstream`, `ServerDownstream`

**Purpose**: Provide limited views of the model to queues and servers during their `update_downstream!` calls. These are the "flyweight pattern" - lightweight proxies that don't store state themselves.

**QueueDownstream** provides:
- `available_servers(d)` - Which downstream servers are idle
- `push!(d, server, token)` - Start a server with a token

**ServerDownstream** provides:
- `finished_job(d)` - The token just completed
- `queues(d)` - All downstream queues
- `queues_with_role(d, role)` - Queues matching role label
- `push!(d, queue, when)` - Send token to a queue

This design allows queues and servers to make local decisions without direct access to global state.

## Points of Variation

The package provides extensibility through multiple mechanisms:

### 1. Token State
Create custom token types to carry domain-specific state (priorities, resource requirements, etc.).

### 2. Queue Policies
- Storage mechanism (FIFO, priority, random, etc.)
- Which server gets the next job
- Which job goes to which server
- Capacity limits and overflow behavior

### 3. Server Behavior
- Service time distributions (Exponential, Gamma, deterministic, etc.)
- Token modification during service
- Self-routing back to own queue (e.g., for multi-pass processing)

### 4. Routing Strategies (Assignment)
- Random, round-robin, shortest-queue, least-work-left
- Content-based routing (SITA)
- Custom policies based on token properties, queue states, or global system state

### 5. Network Topology
The bipartite graph allows arbitrary connections:
- Single queue → multiple servers (server farm)
- Multiple servers → single queue (merge point)
- Cyclic networks (tokens return to previous queues)
- Role-labeled edges for semantic routing

### 6. Observation and Metrics
Queues track metrics like:
- Response time, waiting time, service time
- Queue length, throughput
- Custom metrics via subtyping

## Interaction Patterns

### Initialization Pattern
```julia
model = QueueModel{Work}()
source = InfiniteSourceQueue{Work}()
queue = FIFOQueue{Work}()
sink = SummarySink{Work}()
arrival = ArrivalServer(3.0)
server = ModifyServer(5.0)

@pipe! model source => arrival :only
@pipe! model arrival => queue :only
@pipe! model queue => server :only
@pipe! model server => sink :only

check_model(model)
```

### Simulation Pattern
```julia
trajectory = Trajectory(seed)
activate!(model, trajectory, arrival, Work())

while time < max_time
    when, which = next(trajectory)
    step!(model, trajectory, (when, which))
end
```

### Event Flow
1. `next(trajectory)` → returns next server completion time
2. `step!(model, trajectory, event)` → processes completion:
   - `stop!` marks server as available
   - Server's `update_downstream!` sends token to queue(s)
   - Each affected queue's `update_downstream!` tries to start servers
3. Process repeats

### Custom Assignment Example
```julia
# Route based on token mark value
assign = SizeIntervalAssignment(token ->
    token.mark == 1 ? :around : :out
)
server = ModifyServer(rate, disbursement=assign)

@pipe! model server => queue1 :around
@pipe! model server => queue2 :out
```

## Design Philosophy

### Bipartite Constraint
This is not just a graph - the alternation between queues and servers is fundamental to how queueing models decompose events. It reflects the dual nature of queueing systems: holding (queues) and processing (servers).

### Strategy Pattern
Rather than subclassing servers with different routing behaviors, the package uses composition with `Assignment` strategies. This allows mixing and matching behaviors.

### Separation of Model and Trajectory
The model is immutable after `check_model()`. All mutable state lives in:
- The `Trajectory` (simulation time, RNG, pending events)
- The `QueueModel`'s dynamic state vectors (`server_available`, `server_tokens`)

This supports the use cases mentioned in the docs: parallel sampling, likelihood evaluation, sensitivity analysis.

### Local Decision Making
Queues and servers make decisions based on local views (via flyweights) rather than global system state. This design:
- Enforces modularity
- Prevents unintended dependencies
- Makes the event propagation explicit and auditable
- Reflects the distributed nature of real queueing systems

### Role-Based Routing
Edge labels (roles) decouple topology from semantics. A server can send tokens to multiple queues and let the assignment strategy decide based on role meanings (`:high`, `:low`, `:retry`, etc.) rather than queue identities.

## Summary

Quarton.jl models queueing systems as bipartite graphs where tokens flow between queues (storage + selection) and servers (processing + routing). The main extensibility points are:

1. **Token types** - carry custom state
2. **Queue implementations** - control storage and server selection
3. **Server implementations** - control processing and token modification
4. **Assignment strategies** - control routing to queues
5. **Network topology** - arbitrary bipartite graphs with role-labeled edges
6. **Metrics collection** - tracked in queues and sinks

The design separates concerns (model vs. trajectory), uses composition over inheritance (assignment strategies), and provides local views (flyweights) to enforce modularity while allowing sophisticated routing and scheduling policies.
