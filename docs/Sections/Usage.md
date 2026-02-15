# Usage

This document collects practical patterns and examples for using jettl.

Normative semantics are defined in the [Core Model](Core%20Model.md). If a section below depends on a contract, it links to the canonical contract rather than restating it.

## Examples

### Continuous measurement and logging

> TODO: Define the canonical “continuous measurement + logging” example.
>
> - **Actors involved (Acquisition / Analysis / Logging / UI)**:
> - **Message flow (high-level)**:
> - **Transport choice (Queue/Event/Notifier) and why**:
> - **Expected throughput goal**:

### Hello World

Goal: a minimal actor that starts, handles one message, and stops cleanly.

Guideline:

- You do not need to tell `Stop` to `Self` in a trivial “Hello World” example. Instead, have the actor stop itself at the end of the Hello World message.

> TODO: Link the canonical Hello World example.
>
> - **Example name**:
> - **Location (repo path or VIPM Example Finder name)**:
> - **What the user should observe**:

### Timer / periodic trigger example

A timer example is a strong introductory example because it demonstrates:

- periodic message telling
- stop behavior
- comparison points to other frameworks

There is a relevant presentation by Darren Nattinger on timers/periodic messaging (use it as a learning reference).

> TODO: Specify the timer example behavior.
>
> - **Tick interval**:
> - **Drift expectations**:
> - **Stop semantics**:
> - **How the timer is tested**:

### Example discovery (VIPM)

Example distribution is a packaging concern (canonical discussion belongs in [Tooling → VIPM](Tooling.md#vipm)).

> TODO: Decide how examples are discovered.
>
> - **VIPM Example Finder keywords**:
> - **Example folder path (repo)**:
> - **Which example appears first in search results**:

## Reusable actors

This section lists reusable actor components implemented outside the core library (or intended to be).

### Panel actors

A reusable “panel actor” can standardize common UI concerns:

- updating front panel state
- window operations
- subpanel hosting
- consistent parent/child setup

Guideline:

- A panel actor can be a persistent layer in the unified actor stack.

> TODO: Fill in the canonical reference for panel actors.
>
> - **Repo / package name**:
> - **Where documentation lives**:
> - **Minimum feature set**:
> - **How it integrates with message contracts**:

## Integration patterns

### Bridge (adapter) actors

Bridge actors adapt non-jettl code (or legacy architectures) to jettl’s actor/message model.

This is an integration pattern (not a reusable actor by itself).

> TODO: Confirm the primary integration targets.
>
> - **Primary legacy integration target (QMH/TestStand/UI loop/other)**:
> - **Primary IPC mechanism (queues/user events/DVRs/other)**:

#### Key idea

You can spawn an actor and tell it messages from any LabVIEW code, not only from other actors. The primary challenge is receiving data *from* that actor. This is the role of a **bridge (adapter/shim)**.

#### Pattern steps

1. **Create a pure actor**  
   Create an actor that performs the required work (for example: hardware interaction). This actor should be “pure”:

   - all communication occurs through actor messaging
   - no shared data access
   - no direct callbacks to non-actors

   By keeping this actor pure, it remains reusable in fully jettl-based applications and in mixed environments.

2. **Create a bridge actor**  
   Introduce a bridge actor that sits between the calling (non-actor) code and the pure actor.

   - toward the pure actor, the bridge behaves like a normal jettl actor and follows all jettl rules
   - toward the caller, the bridge is allowed to break jettl rules, since the caller is not an actor

3. **Define pass-through command messages**  
   The bridge actor should expose a set of messages that mirror those accepted by the nested pure actor.

   - these are pass-through messages
   - the bridge forwards them directly to the pure actor
   - interfaces make this straightforward

4. **Establish return paths using reference objects**  
   Because the caller is not message-driven in the jettl sense, returned data usually flows through reference objects:

   - **DVRs** for tagged/state-style data
   - **queues** for streaming or asynchronous notifications
   - **user events** for UI integrations

   These references can be:

   - created by the calling code and passed to the bridge at startup (simplest), or
   - created by the bridge and returned to the caller (useful when the caller VI may go out of memory before the actor shuts down, common in TestStand systems)

5. **Handle data from the pure actor**  
   When the pure actor produces data, it tells messages to the bridge. The bridge receives the message and writes the data to the appropriate reference object (DVR/queue/user event).

6. **Consume data in the calling code**  
   The calling code retrieves data from the reference objects as needed.

   Example (QMH integration):

   - pass the QMH queue into the bridge
   - when the bridge receives data from the pure actor, it constructs a QMH message and enqueues it with the received data

   If the caller is not message-driven:

   - do not forward messages directly into the caller
   - wrap the bridge interaction in a class that provides:
     - Create/Destroy VIs to launch and shut down the bridge actor
     - command VIs that tell messages to the bridge
     - data access VIs that read from DVRs/queues

> TODO: Add a concrete bridge example and keep it working.
>
> - **Pure actor responsibility**:
> - **Bridge actor responsibility**:
> - **References created by caller vs by bridge**:
> - **What is the shutdown sequence**:
>
> TODO: If you want jettl to ship helper utilities for this pattern, specify them.
>
> - **Helper VIs/classes desired**:
> - **Which reference types to support (DVR/queue/user event)**:
> - **Where they live (core vs tooling)**:

### Broker / mediator pattern

A broker / mediator design is discussed as a non-normative idea in:

- [Non-Normative → Broker / Mediator](Non-Normative.md#broker--mediator)

This avoids duplicating speculative architecture in the usage guide.

### Periodic messaging

Periodic triggers must come from an entity responsible for timing.

Guidelines:

- Do not put periodic work inside an actor’s own timeout case as “tell Self every 100 ms.”
- Instead, create a **periodic messaging actor** (or wrapper layer) whose single responsibility is timing, and have it tell a trigger message to the actor that owns the behavior.

Key nuance:

- Telling a message periodically does not imply the message is *executed* periodically (see: [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering)).
- If you want “at most one outstanding tick,” design the tick message/transport so only one copy can be pending.

Implementation sketch (template):

- `Init.vi` inputs:
  - **Msg strategy**:
  - **Period**:
- `Process.vi`:
  - unbundle `Period`
  - in timeout case: unbundle the message to tell to the creator/owner

Transport note:

- This could be an Event Actor, but Notifiers can work well for timing semantics.
- For an Event Actor, the event loop timeout defines tick cadence, but event handling can introduce jitter.

> TODO: Choose one canonical periodic messaging approach and document it fully.
>
> - **Canonical approach (timer actor vs wrapper layer)**:
> - **Why**:
> - **How “at most one outstanding tick” is enforced**:
> - **Acceptance test for jitter/drift**:

### Monitor message traffic

Since one cannot directly monitor queue depth in a robust way, one approach is to override the tell operations in a wrapper actor and log:

- the time a message is told (timestamp)
- the time it is listened to (timestamp)

This enables derived metrics like “messages not yet executed” by comparing told vs listened timestamps.

A workable instrumentation approach:

- Initialization requires:
  - **Self attributes**
  - **Parent attributes**
- Child information is redundant if you can derive it from Self and Parent attributes.

Logging idea:

- After telling a message: log **Tell Time**
- When listening to a message (for example, in `Call Inspect.vi` with `Msg Listened To.vi`): log **Listened Time**

> TODO: Decide whether this belongs in a built-in debug layer or a separate add-on.
>
> - **Owner (Core/Edge add-on vs external package)**:
> - **Log sink (file/UI/queue)**:
> - **Performance overhead budget**:
> - **How to enable/disable per actor**:

## Design patterns

These patterns are used heavily in jettl-based systems.

### Decorator pattern

jettl uses dynamic decoration: actor layers wrap other actor layers through a common `Actor` interface.

![dec_1](../Images/dec_1.jpeg)

![dec_2](../Images/dec_2.jpeg)

![dec_3](../Images/dec_3.jpeg)

> TODO: Add a short “decoration walkthrough” that ties the pictures to concrete jettl concepts.
>
> - **Which example actor stack is shown**:
> - **Which layer is considered “user actor”**:
> - **Which layers are Core vs Edge**:
> - **One message call traced through the layers**:

### State pattern

Use the state pattern when:

- an actor’s behavior changes based on a small, explicit set of states
- you want to keep message methods small by delegating to state objects

> TODO: Provide one concrete state machine example.
>
> - **States**:
> - **State transitions**:
> - **Which messages trigger transitions**:

### Factory pattern

Factory patterns are useful when:

- an actor must select which implementation to spawn based on configuration
- a plugin architecture selects from multiple concrete implementations

See also: [Runtime → Plugin architectures](Runtime.md#plugin-architectures).

> TODO: Provide the canonical factory example and explain how it interacts with typed destinations.
>
> - **Factory inputs**:
> - **Spawned actor variants**:
> - **How message contracts are enforced**:

## Feedback questions

> TODO: Answer these to guide which examples and patterns should become first-class docs.
>
> - **Top 3 examples you want new users to run first**:
> - **Top 3 integration patterns you see in real projects**:
> - **Most confusing part of the framework for new users**:
