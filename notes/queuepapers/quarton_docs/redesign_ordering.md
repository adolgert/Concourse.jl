You made an insightful comment, that the only timed event in queueing theory is the server completing a job. That's the 
crux, that for queueing theory you want to be really careful about immediate events. They have to become first class, so 
much so that the framework will look more like a discrete event simulation in discrete time. That is, multiple immediate 
events need to happen predicatbly, in order when there is an order, randomly without bias when there is randomness. This 
isn't a focus of ChronoSim.jl and makes it inappropriate for simulating queueing theory. So helpful. So tell me Claude how a
 discrete event simulation with simultaneous events, such as immediate events, gives a user clear ways to specify the order 
and probability of immediate events? 

● This is a great question that gets at a fundamental tension in discrete event simulation. Let me think through the design
  space.

  The Problem: Simultaneous Events

  When a server completes at time t, several things happen "instantly":
  1. Token arrives at destination queue
  2. Queue selects which token to dispatch (maybe the new one, maybe an older one)
  3. Available servers receive tokens
  4. If multiple servers are available, which gets priority?
  5. If multiple queues feed one server, which queue wins?

  These aren't really "simultaneous"—there's a logical order. But specifying that order clearly is the design challenge.

  Approaches in the Literature

  1. Transaction Flow (GPSS, Arena style)

  The classic approach: tokens are "transactions" that move through a flowchart. The simulation maintains a future event 
  chain (timed) and a current event chain (immediate).

  Transaction arrives at queue
    → Queue selects transaction (policy: FIFO, priority, etc.)
    → Transaction SEIZES server (if available) or WAITS
    → After service, transaction RELEASES server
    → Released server triggers next transaction to SEIZE

  Order specification: Implicit in the flowchart. Transactions move step-by-step within a single time instant.

  Problem: The flowchart is the specification—hard to compose or analyze formally.

  ---
  2. Priority Levels (DEVS, SimPy)

  Assign numeric priorities to event types. Within a time instant, process in priority order.

  struct Event
      time::Float64
      priority::Int  # lower = higher priority
      action::Function
  end

  # Example priorities
  const ARRIVAL_PRIORITY = 1
  const SERVICE_COMPLETE_PRIORITY = 2
  const DISPATCH_PRIORITY = 3
  const COLLECT_STATS_PRIORITY = 100

  Order specification: Explicit numeric priorities.

  Problem:
  - What if two events have the same priority? Need a tiebreaker.
  - Priority numbers become magic constants scattered through code.
  - Hard to reason about: "Does dispatch happen before or after arrival?"

  ---
  3. Event Phases (Three-Phase Approach)

  Popularized by Tocher and refined by Pidd. Each time instant has three phases:

  1. A-phase: Advance clock to next scheduled event
  2. B-phase: Execute all bound events (unconditional, time-triggered)
  3. C-phase: Execute all conditional events (state-dependent) until none remain

  function simulate!(model)
      while !done(model)
          # A-phase: advance time
          t = next_event_time(model)
          advance_clock!(model, t)

          # B-phase: execute bound events at time t
          for event in bound_events_at(model, t)
              execute!(event, model)
          end

          # C-phase: execute conditional events until stable
          changed = true
          while changed
              changed = false
              for event in conditional_events(model)
                  if precondition(event, model)
                      execute!(event, model)
                      changed = true
                  end
              end
          end
      end
  end

  Order specification:
  - B-events (scheduled) happen before C-events (reactive)
  - C-events repeat until fixpoint

  Problem: Order within B-phase or C-phase is unspecified. If two C-events are both enabled, which fires first?

  ---
  4. Explicit Dependency DAG

  Make the causal structure explicit. Events declare what they depend on and what they produce.

  struct EventType
      name::Symbol
      reads::Vector{Symbol}    # state it examines
      writes::Vector{Symbol}   # state it modifies
      triggers::Vector{Symbol} # event types it can enable
  end

  # Server completion
  ServerComplete = EventType(
      :server_complete,
      reads = [:server_token],
      writes = [:server_available, :queue_tokens],
      triggers = [:queue_dispatch]
  )

  # Queue dispatch
  QueueDispatch = EventType(
      :queue_dispatch,
      reads = [:queue_tokens, :server_available],
      writes = [:queue_tokens, :server_token, :server_available],
      triggers = [:server_complete]  # enables next service
  )

  The framework topologically sorts based on reads/writes:
  - If A writes X and B reads X, then A before B
  - If no dependency, they can be concurrent or randomly ordered

  Order specification: Declarative—emerges from data dependencies.

  Problem: Cycles require special handling. What if dispatch both reads and writes server_available?

  ---
  5. Stratified Execution (My Proposal for Queueing)

  Combine phases with explicit ordering within phases. Each immediate event declares:
  - Stratum: Which phase it belongs to
  - Selection policy: How to choose among multiple enabled events in this stratum

  abstract type Stratum end
  struct TokenArrival <: Stratum end      # Tokens land in queues
  struct QueueSelection <: Stratum end    # Queues pick which token to offer
  struct ServerSelection <: Stratum end   # Servers pick which queue to accept from
  struct Dispatch <: Stratum end          # Actual token movement

  # Ordering
  stratum_order() = [TokenArrival, QueueSelection, ServerSelection, Dispatch]

  # Within-stratum policy
  abstract type SelectionPolicy end
  struct AllEnabled <: SelectionPolicy end           # Execute all (deterministic)
  struct RandomOne <: SelectionPolicy end            # Pick one uniformly at random
  struct WeightedRandom <: SelectionPolicy end       # Weighted by some attribute
  struct PriorityOrder <: SelectionPolicy end        # By priority field
  struct UserDefined <: SelectionPolicy end          # Custom comparator

  @stratum TokenArrival policy=AllEnabled
  @stratum QueueSelection policy=PriorityOrder(by=:queue_id)  # Deterministic
  @stratum ServerSelection policy=RandomOne  # Random tiebreaker
  @stratum Dispatch policy=AllEnabled

  Execution within a time instant:
  function execute_instant!(model, t)
      for S in stratum_order()
          execute_stratum!(model, S, t)
      end
  end

  function execute_stratum!(model, ::Type{S}, t) where S <: Stratum
      policy = selection_policy(S)
      while true
          enabled = [e for e in events_in_stratum(S) if precondition(e, model)]
          isempty(enabled) && break

          to_execute = select(policy, enabled, model)
          for e in to_execute
              fire!(e, model, t)
          end
      end
  end

  ---
  Applying This to Queueing Theory

  For Quarton specifically, I'd propose four strata:

  | Stratum    | What happens                                  | Policy         | Rationale
    |
  |------------|-----------------------------------------------|----------------|-------------------------------------------
  --|
  | Arrivals   | Completed tokens enter destination queues     | All            | No conflict—each token has one destination
    |
  | QueueLogic | Each queue decides which token(s) to offer    | All, per-queue | FIFO/priority/random is queue-local
    |
  | Contention | Resolve server↔queue conflicts                | User-specified | This is where the interesting policies
  live |
  | Commit     | Actually move tokens to servers, start clocks | All            | Just bookkeeping
    |

  The Contention stratum is where queueing theory gets interesting:
  - Multiple queues feeding one server → which queue wins?
  - Multiple servers fed by one queue → which server wins?
  - Token just arrived vs. token already waiting → which gets priority?

  Contention Resolution Patterns

  abstract type ContentionPolicy end

  # Server-centric: server chooses from its input queues
  struct ServerChooses <: ContentionPolicy
      policy::Symbol  # :round_robin, :longest_queue, :random, :priority
  end

  # Queue-centric: queue chooses from available servers  
  struct QueueChooses <: ContentionPolicy
      policy::Symbol  # :round_robin, :fastest_server, :random
  end

  # Centralized: global matching algorithm
  struct GlobalMatching <: ContentionPolicy
      algorithm::Symbol  # :greedy, :hungarian, :random_matching
  end

  # Probabilistic: weighted random based on rates/capacities
  struct ProportionalRouting <: ContentionPolicy
      weights::Function  # (queue, server) -> weight
  end

  Example: Central Server Model

       ┌──────┐
       │ CPU  │←──┬──────────────────┐
       └──────┘   │                  │
                  │    ┌──────┐      │
                  ├────│Disk 1│──────┤
                  │    └──────┘      │
                  │    ┌──────┐      │
                  └────│Disk 2│──────┘
                       └──────┘

  Jobs complete at CPU, go to Disk 1 or Disk 2 (probabilistically), then return to CPU.

  # Contention: CPU queue feeds one server, no conflict
  # Disk queues feed one server each, no conflict
  # But: CPU completion must choose disk probabilistically

  @contention cpu_to_disk begin
      when server_completes(:cpu)
      select_destination WeightedRandom([:disk1 => 0.6, :disk2 => 0.4])
  end

  @contention disk_to_cpu begin
      when server_completes(:disk1) || server_completes(:disk2)
      select_destination Fixed(:cpu_queue)
  end

  Example: Server Farm with Join-Shortest-Queue

                   ┌────────┐
              ┌────│Server 1│
              │    └────────┘
  ┌───────┐   │    ┌────────┐
  │Arrival│───┼────│Server 2│
  └───────┘   │    └────────┘
              │    ┌────────┐
              └────│Server 3│
                   └────────┘

  @contention arrival_routing begin
      when token_arrives(:arrival_queue)
      select_destination ShortestQueue([:q1, :q2, :q3])
      # If tie, policy specifies: :random, :first, :round_robin
      tie_breaker :random
  end

  ---
  Summary: Design Principles

  1. Separate timed from immediate: Timed events advance the clock. Immediate events resolve within an instant.
  2. Stratify immediate events: Group by logical phase (arrival → selection → contention → commit).
  3. Make ordering explicit: Within each stratum, specify:
    - Execute all? One at a time?
    - If one at a time: deterministic order? Random? Weighted?
  4. Contention is first-class: The "multiple queues, multiple servers" matching problem deserves dedicated abstractions.
  5. Iterate to fixpoint: Each stratum runs until no events are enabled, then moves to the next.
  6. Randomness must be controlled: When random tiebreaking is used, it should be:
    - Declared explicitly (not hidden in implementation)
    - Reproducible via RNG seeds
    - Documented in the model specification

  This is quite different from ChronoSim's focus on continuous-time hazards with occasional immediate events. For queueing
  theory, the immediate events are the model—the timed events are just pacing.


  Pidd's Textbook

  Michael Pidd. Computer Simulation in Management Science. Wiley.

  Multiple editions exist:
  - 4th Edition (1998): ISBN 978-0471979319 -
  https://www.amazon.com/Computer-Simulation-Management-Science-4th/dp/0471979317
  - https://www.wiley.com/en-us/Computer+Simulation+in+Management+Science%2C+5th+Edition-p-9780470092309

  This is the standard textbook treatment of the three-phase approach. Pidd was at Lancaster University and has chapters
  specifically on "The Three-phase Approach" and "Writing a Three-phase Simulation Program."

  Pidd's Paper on Three-Phase in Java

  Pidd, M. and Cassel, R.A. (1998). "Three Phase Simulation in Java." Proceedings of the 1998 Winter Simulation Conference.
  - https://www.researchgate.net/publication/3786557_Three_phase_simulation_in_Java

  ---
  Clarification

  I should be honest: while Tocher originated the three-phase approach (A-phase, B-phase, C-phase), and Pidd popularized it
  in his textbook, I was speaking loosely when I said "Pidd's three-phase approach." Pidd documented and taught Tocher's
  method; he didn't invent it. The 1963 Tocher book is the original source, and Pidd's textbook is the most accessible
  modern treatment.
  