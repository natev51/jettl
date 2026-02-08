# Core Model

This document defines the core semantics of jettl: the actor model, the messaging model, and the lifetime/stop contract.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Terminology

### Definitions

- **Actor**: A single layer in the decoration stack (one class instance that implements the `Actor` interface).
- **Actor Layer**: Synonym for **Actor** when discussing layering explicitly.
- **Unified Actor**: The unified view of a running actor, formed by composing multiple actor layers.
- **Msgs**: The set of message methods implemented by a single actor layer.
- **Unified Msgs**: The union of messages implemented across all layers in the unified actor.
- **Turn**: One execution cycle of an actor.
- **Finalize**: A lifecycle hook invoked at the end of each actor execution turn.
- **Root**: The root actor of an application actor tree.
- **No Relation**: Two actors are “No Relation” when they do not have the same Root.
- **Core Actors**: A Root-scoped set of persistent actor layers that are composed into every descendant actor spawned under that Root.
- **Edge Actors**: A Root-scoped set of persistent actor layers that are composed into every descendant actor spawned under that Root, typically used for “outer boundary” concerns.
- **Base Actor**: The built-in, innermost actor layer provided by jettl. It is always present in every unified actor.

> **TODO:** If “Core Actors” vs “Edge Actors” has a sharper semantic boundary than “inner set vs outer set,” capture it here.
>
> - **Core Actors semantic boundary**:
> - **Edge Actors semantic boundary**:

## Actor Model

### Actor Transports

![Queue Actor transport](../Images/actor-transport-queue.png)  
*Queue Actor.*

![Event Actor transport](../Images/actor-transport-event.png)  
*Event Actor.*

![Notifier Actor transport](../Images/actor-transport-notifier.png)  
*Notifier Actor.*

#### Guidelines

| Transport | Best For | Avoid When | Notes |
|---|---|---|---|
| Queue | Performance / throughput | IPC / event-structure-centric designs | Message throughput tends to be better; implementation is independent of UI-thread event handling. |
| Event | Front panel events and IPC | Maximum throughput is required | Use for event-structure-specific code, including dynamic event registration. |
| Notifier | “Last value wins” notifications | You need proven behavior at scale | Specialty transport; feature exists but is not tested as extensively as Queue/Event. Treat as specialized/experimental until covered by tests and benchmarks. |

> **TODO:** Add a short “when to use each transport” decision guide.
>
> - **Default transport recommendation**:
> - **When to pick Queue**:
> - **When to pick Event**:
> - **When to pick Notifier**:

> **TODO:** Fill in acceptance tests for each transport.

| Transport | Required Test | Expected Result | Notes |
|---|---|---|---|
| Queue |  |  |  |
| Event |  |  |  |
| Notifier |  |  |  |

### Persistence: Core Actors, Edge Actors, and Base Actor

#### Contracts

- `Core Actors` and `Edge Actors` MUST be persistent layers for every actor in the application.
- If the Root actor is spawned with `Debug jettl Actor` included in `Core Actors`, then that instance of `Debug jettl Actor` MUST be used for each child actor spawned under that Root.
- `Base jettl Actor` MUST be the innermost layer of the unified actor.

### Introspection and the Unified Actor

#### Concepts

The jettl API exposes public read-only accessors that can be used to read internals. Wrapped actors can use these read-only method chains to obtain the necessary information from the `Unified Actor`.

> **TODO:** List the “blessed” introspection chains (by intent), and which ones are stable contracts vs internal conveniences.
>
> Duplicate the row for additional chains.

| Intent | Example Call Chain | Stability (Stable/Internal) | Notes |
|---|---|---|---|
|  |  |  |  |

### Private Actors

#### Contracts

- A library MAY contain multiple actors.
- Only one actor SHOULD be the primary entry point.
- Supporting actors in the library SHOULD be Private to the containing actor library.

#### Guidelines

- Enforce “supporting actors are private” via a VI Analyzer rule.

### Actor Layers

#### Concepts

Actors can decorate each other in layers.

- If a layer implements a Message, functionality will be extended in that layer.
- If a layer does not implement a Message, that Message is effectively a no-op at that layer.

`Msg or Recurse.vi` checks `Msgs` and determines whether the current layer implements the message method. If not implemented, it recurses to the next layer until the innermost layer is called.

### Child UIDs

#### Contracts

- `Child UIDs.ctl` MUST be static (developer-facing abstraction).

#### Implementation Notes

- Internally, UIDs are stored as strings in `Child Attributes Map.ctl`.
- Each actor defines its own private enum for child UIDs.
- A runtime string mapping MAY be validated to ensure it only maps enum elements to their corresponding string values.

#### Rationale

- Actor code uses enums exclusively, avoiding stringly-typed identifiers.
- The internal string representation remains compatible with mapping needs.

#### Guidelines

- The enum is currently edited manually.
- A future tool MAY automate enum updates.

### Message Routing Inspection Overrides

#### Concepts

Overrides such as `Tell Self Inspect.vi`, `Tell Parent Inspect.vi`, and `Tell Child Inspect.vi` can enforce where Messages are allowed to go (e.g., **Self**, **Parent**, **Child**) based on static destination selection at edit time.

#### Contracts

- If a Message requires a relationship that is not satisfied, an error MUST be generated at runtime to prevent invalid message paths.
- A static analyzer test SHOULD eliminate these runtime errors by catching invalid messaging paths earlier.

#### Implementation Notes

A defensive fallback can be implemented by decorating message handling in a case structure that safely handles “received but not implemented” messages by allowing an unexpected message through.

## Messaging Model

### Messages and Interfaces

#### Contracts

- All Messages MUST come from an interface.
- Messages follow the Interface Segregation Principle: one Message method belongs to one interface.

#### Guidelines

- If naming conflicts appear, treat them as a signal that module boundaries and packaging need adjustment.

### Scheduling and Ordering

#### Guidelines

- Callers SHOULD assume they cannot control the order that messages execute.
- If ordering is required, serialize explicitly (e.g., a single message representing the sequence, a state machine, or an explicit serialization structure).

For priority semantics (if any), see [Scheduling and Priority](Runtime.md#scheduling-and-priority).

### Message Inputs and Type Definitions

#### Contracts

- Type definitions used as Message inputs SHOULD be located in the Message library.

#### Rationale

This supports dependency inversion and avoids circular dependencies.

### Polymorphic Selection and Implementation

![Polymorphic Message selection](../Images/msg-poly-selection.png)  
*Polymorphic Message.*

![Message implementation and recursion](../Images/msg-implemented-recurse.png)  
*Message implementation.*

> **TODO:** If these images drift from the current implementation, update:
>
> - `../Images/msg-poly-selection.png`:
> - `../Images/msg-implemented-recurse.png`:

### Private Messages

#### Concepts

Certain messages are intended to be private (self-messages) and not told by external actors.

#### Contracts

- Private messages SHOULD be marked private to the containing actor library.
- Messages not exposed to external callers MUST be restricted via library access scope.

### No-Children Actors

#### Definitions

- **No-Children Actor**: An actor that cannot spawn children. It only messages with its parent and cannot have child messaging relationships.

#### Contracts

- If a Parent spawns a Child, the Parent SHOULD implement all interfaces required by the Child for Child → Parent messaging.
- A runtime check MAY prevent spawning if the Parent does not implement required Child → Parent messages.
- If the Parent does not implement an interface, message methods are effectively no-ops, and default behavior MAY be handled in the Parent (`Call Inspect.vi`) or the Child (`Tell Parent Inspect.vi`).

#### Implementation Notes

- `Call Inspect.vi` SHOULD internally use `Read Listened To Msg.vi` to ensure the message being inspected was listened to and not normally called inline.

### Setup-Time Messaging

#### Contracts

- Messages MAY be told to Self and Parent (and any children spawned) in `Setup.vi`.
- Actors MAY be spawned in `Setup.vi`.

### Unified Messages

#### Concepts

- Messages are decoupled between layers.
- Telling a message defined in an internal layer but not in the outer actor or Core Actor still means the message appears in `Unified Msgs`.

### Telling Unimplemented Messages

#### Concepts

A message can be told to an actor that has not implemented that message. This behavior can be modified in `Core Actors`.

### Unhandled Messages

#### Notes

A practical test for validating `Unhandled Msgs` behavior:

1. Add a `Panel Close?` event.
2. Tell `Stop` to `Self`.
3. Tell `Stop` to `Self` again.
4. Verify the second `Stop` message is captured as an unhandled message (e.g., 1bd with an array of messages).

### Messages Producing Output Data

#### Concepts

Messages can output data.

#### Rationale

This enables wrapper layers to consume inner-layer outputs for logging, auditing, metrics, or trace enrichment without re-computing or re-deriving the same data.

#### Ideas

- Consider a common output (e.g., a log interface output) on terminal 1 that can be dependency injected with a developer-provided concrete implementation.

### Strongly-Typed Message Destinations

#### Contracts

- jettl enforces a strongly typed messaging system where the message destination is known at edit time.
- An edit-time analysis (e.g., via VI Analyzer or an actor-layer analyzer) SHOULD determine allowed spawn relationships by validating message contracts bidirectionally:
  - What the parent can **tell to** and **listen to** its child.
  - What the child can **tell to** and **listen to** its parent.

#### Documentation Implications

Documentation tooling SHOULD be able to display which messages flow to and from `Self`, including:

- `Self → Self`
- `Parent → Self`
- `Child (with UID) → Self`
- `Self → Parent`
- `Self → Child (with UID)`

(`Self ← Self` is redundant and can be omitted.)

#### Scripting Constraints

- Only the two left input terminals are valid for scripting message inputs; other inputs are ignored.
- If more than two inputs are required, define a typedef cluster in the message library.
- Only the two right output terminals are valid for scripting message outputs; other outputs are ignored.

## Lifetime Model

### Lifecycle Pairs

The lifetime is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

### Stop Contract

#### Contracts

- `Stop.vi`:
  - MUST start as `False`.
  - MUST only be changed to `True` inside `Stop.vi`.
  - MUST NOT be changed back to `False`.

- `Should Stop.vi`:
  - MUST stop when `Stop` is `TRUE` **OR** an error occurs.
  - MUST output `Can Stop = TRUE` when stopping conditions are met.
  - An error from `Finalize.vi` MUST imply the actor should stop; `Stop.vi` will be called if not already called.

## Spawning Model

### Inline vs Async Spawning

#### Concepts

Inline spawning exists to support resource setup in the Main actor. If references are created in Main and not closed, they are guaranteed to be alive for the application lifetime.

#### Notes

- Inline does not spawn an async process.
- Inline can be used to obtain outputs (actor state and error information) after the call completes, enabling straightforward dataflow signaling that an actor has stopped.
- Multiple inline spawns can exist in the same application.

### Reference Lifetime and Ownership

#### Guidelines

- Prefer creating and destroying references in the same actor.
- If a reference is created in Actor A and used in Actor B, define ownership explicitly:
  - Who is responsible for closing it.
  - Which actor is allowed to outlive the other.
- Prefer creating references in `Setup.vi` (not `Init.vi`) when the reference lifetime should match the actor lifetime.

#### Rationale

If a parent actor creates a reference that a child actor uses, and the parent actor stops while the child continues to run, the reference can become invalid in a way that is difficult to diagnose. Treat reference ownership as part of the actor contract: the creator should typically be the owner and should close it, unless ownership is explicitly transferred.

Additional rationale (practical framing):

- This is why jettl actors create and own their own event references and release their own references: the actor lifetime is guaranteed for those references.
- Creating references in a parent before a child spawns is usually a bad practice: when the parent stops, references created in the parent (but still used by the child) can be released, leading to the child performing operations on an invalid reference.

> **TODO:** Capture explicit ownership patterns you want to bless (keep it small).
>
> - **Common ownership pattern 1**:
> - **Common ownership pattern 2**:
> - **Common ownership pattern 3**:

## Error Model

### Error Catalog

#### Contracts

- All errors that can occur in jettl MUST be documented in `jettl.lvlib:Error.lvlib`.

### Error Handling Principles

#### Contracts

- No error goes unrecognized.
- No error goes unnoticed in the framework; everything is reported (except for releasing references).

#### Concepts

- Unless a function/method has an error input, it is assumed to run unconditionally when called.

### Serialization and Error Wires

#### Contracts

- Errors MUST NOT be used for serialization.
- A datatype MUST NOT be passed from input to output solely for serialization.

#### Guidelines

- If a method must be serialized, prefer an explicit structure (commonly a flat sequence structure; sometimes a case structure).

### Where Errors Are Handled

#### Guidelines

- Errors SHOULD be handled by the method or layer that introduces the error, unless a different layer explicitly owns the recovery policy.
- A decorating layer MAY handle errors from inner layers when that layer is explicitly responsible for policy (e.g., `Error Handling jettl Actor`), logging, or translation.
- A decorating layer SHOULD NOT silently swallow errors from inner layers unless that behavior is an explicit part of its contract.

#### Implementation Notes

A generalized error-handling Core Actor can override default behavior (e.g., clearing selected errors in `Finalize.vi`) while still exposing errors on the error wire for developer control.

### Wiring Readability

![Minimal bend wiring philosophy](../Images/clean-propagation.png)  
*Minimal bend wiring philosophy: prioritize readability. Keep the error wire pushed to the back. Avoid wires crossing over the object wire. Prefer explicit serialization structures over error-wire serialization.*

## Attributes

### Concepts

Actors allow `Self`, `Parent`, and `Child` relations to inspect unified actor state after start. This is useful for persistent actors, debugging, and comparing current state to an earlier snapshot.

One example: if an actor is spawned with its front panel shown, the parent can determine whether the child panel should also be displayed as a subpanel.

### Contracts

- Attributes MUST be instantiated when the actor is spawned.
- Attribute access MUST be read-only via method calls (no direct mutation by callers).

### Visibility and Timing

| Item | Value |
|---|---|
| Who can read attributes | `Self`, `Parent`, and `Child` relations that share the same Root. Actors with **No Relation** MUST NOT be able to read attributes. |
| When attributes become readable | Most attributes are readable during `Setup.vi` and `Start.vi`. The unified actor is updated after start completes; if `Setup.vi` throws an error, the actor state is updated after teardown completes. |
| Mutability rules | Read-only method calls only. |
| Thread-safety / by-value rules | Attribute data is by-value, except for reference-like fields (e.g., App Ref, VI Ref). |
| Introspection chains considered stable | All attribute introspection chains are considered stable. |

> **TODO:** If “when readable” needs to be precise per field, add a table:

| Attribute Field | First Valid Phase | Updated Phase | Notes |
|---|---|---|---|
|  |  |  |  |

### Rationale: Teller and Attributes Libraries

The Teller and Attributes libraries are implemented as libraries containing interfaces and classes rather than collections of typedef clusters.

- **Encapsulation and controlled initialization**  
  Classes encapsulate private data. Using `Init.vi`, the class private data is instantiated a single time, after which multiple **read-only** methods provide access. This enforces the intended lifecycle and prevents developers from directly modifying the underlying data.
- **Read-only access can be enforced with interfaces**  
  Interfaces define and enforce read-only access patterns through method contracts. Typedef clusters do not provide a comparable mechanism to restrict writes.
- **Accessor discoverability and maintainability**  
  Avoid clusters in favor of objects with explicit accessor methods, since access points are easier to locate and reason about. These accessors are implemented as **method calls**, not property nodes.

## Reentrancy

### Constraints

- Preallocated reentrancy cannot be used for dynamic dispatch.

### Guidelines

A goal of jettl is to use only reentrant method calls to preserve true asynchronous behavior.

- For dynamic dispatch (DD) methods: use **Shared** clone reentrancy (preallocated is not available for DD).
- For non-DD methods: default to **Preallocated (inline)**. If that does not work, use one of:
  - **Preallocated (no inline)**
  - **Shared**

> **TODO:** Fill in concrete exceptions and the rationale.
>
> - **Non-reentrant calls allowed in jettl (if any)**:
> - **Methods forced to Shared (non-DD)**:
> - **Methods forced to Preallocated (no inline)**:
> - **Bookmark tag used for decisions**: `reentrancy`

## Feedback Questions

> Answer these to tighten the normative contract and reduce ambiguity.

- **What does “Turn” mean in each transport (Queue/Event/Notifier)?**:
- **Does jettl guarantee “at-most-once” delivery for a told message? If not, what are the failure modes?**:
- **What is the canonical definition of “unhandled message” (and when is it recorded)?**:
- **Which introspection chains are guaranteed stable across releases?**:
- **Which behaviors are intentionally transport-specific vs transport-invariant?**:
- **What error policy is part of the framework contract vs intentionally left to Core Actors?**:
- **Which attributes are guaranteed readable during `Setup.vi` vs only after `Start.vi`?**:
- **What is the minimum test suite required to validate “Core Model compliance”?**:
