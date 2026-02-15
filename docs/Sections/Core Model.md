# Core Model

This document defines the normative semantics of jettl: the actor model, the messaging model, and the lifetime/stop contract.

Sections explicitly marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Terminology

Canonical definitions live in the [Glossary](Glossary.md). This file uses those terms without redefining them.

> TODO: Add any Core-Model-specific terms that are missing from the glossary (then link back here where the term matters).
>
> - **Missing term:**  
> - **Where it is used in the Core Model:**  

---

## Actor Model

### Actor transports

![actor-transport-queue](../Images/actor-transport-queue.png)  
*Queue actor transport.*

![actor-transport-event](../Images/actor-transport-event.png)  
*Event actor transport.*

![actor-transport-notifier](../Images/actor-transport-notifier.png)  
*Notifier actor transport.*

#### Guidelines

| Transport | Best for | Avoid when | Notes |
|---|---|---|---|
| Queue | Throughput and minimal UI-thread coupling | You need front-panel event integration | Typically higher throughput; independent of UI-thread event handling. |
| Event | UI work, front panel events, event-structure-centric designs | Maximum throughput is required | Use for event-structure-specific code including dynamic event registration. |
| Notifier | “Last value wins” notifications | You need proven behavior at scale | Treat as specialized/experimental until covered by tests and benchmarks. |

> TODO: Add a short transport decision guide.
>
> - **Default transport recommendation:**  
> - **Choose Queue when:**  
> - **Choose Event when:**  
> - **Choose Notifier when:**  

> TODO: Fill in acceptance tests per transport.
>
> | Transport | Required test | Expected result | Notes |
> |---|---|---|---|
> | Queue |  |  |  |
> | Event |  |  |  |
> | Notifier |  |  |  |

### Persistence: Core Actors, Edge Actors, and Base Actor

#### Contracts

- **Core Actors** and **Edge Actors** MUST be persistent layers for every actor in the application (Root-scoped persistence).
- If the Root actor is spawned with a given actor layer in **Core Actors** (for example, a debug layer), that same instance MUST be composed into every descendant actor spawned under that Root.
- The **Base Actor** MUST be the innermost layer of every unified actor.

> TODO: Confirm whether Edge Actors differ from Core Actors purely by “intended usage” or if there is a stricter semantic boundary.
>
> - **Core Actors semantic boundary:**  
> - **Edge Actors semantic boundary:**  

### Introspection and the unified actor

#### Concepts

jettl exposes public read-only accessors that allow actor layers to inspect unified actor state.

- Canonical definition of “introspection chain”: see [Glossary → Introspection chain](Glossary.md#introspection-chain).

> TODO: List the stable introspection chains you want to guarantee.
>
> | Intent | Example call chain | Stability (Stable/Internal) | Notes |
> |---|---|---|---|
> |  |  |  |  |

### Private actors

#### Contracts

- A library MAY contain multiple actors.
- Exactly one actor SHOULD be the primary entry point for that library.
- Supporting actors in the library SHOULD be private to the containing actor library.

#### Guidelines

- A future VI Analyzer rule SHOULD enforce “supporting actors are private”.

### Actor layers

#### Concepts

Actors can decorate each other in layers.

- If a layer implements a message, functionality is extended in that layer.
- If a layer does not implement a message, that message is a no-op at that layer.

`Msg or Recurse.vi` checks the layer’s **Msgs** and determines whether the current layer implements the message method. If not implemented, it recurses to the next layer until the innermost layer is called.

> TODO: Clarify the exact “no-op” semantics.
>
> - **Does a non-implemented message always recurse to the next layer?**  
> - **Is there any case where recursion stops early?**  

### Child UIDs

#### Contracts

- `Child UIDs.ctl` MUST be static (developer-facing abstraction).

#### Implementation notes

- Internally, UIDs are stored as strings in `Child Attributes Map.ctl`.
- Each actor defines its own private enum for child UIDs.
- A runtime string mapping MAY be validated to ensure it only maps enum elements to their corresponding string values.

#### Rationale

- Actor code uses enums exclusively, avoiding stringly-typed identifiers.
- The internal string representation remains compatible with mapping needs.

#### Guidelines

- The enum is currently edited manually.
- A future tool MAY automate enum updates.

### Message routing inspection overrides

#### Concepts

Overrides such as `Tell Self Inspect.vi`, `Tell Parent Inspect.vi`, and `Tell Child Inspect.vi` can enforce where messages are allowed to go (Self/Parent/Child) based on static destination selection at edit time.

#### Contracts

- If a message requires a relationship that is not satisfied, an error MUST be generated at runtime to prevent invalid message paths.
- A static analyzer test SHOULD eliminate these runtime errors by catching invalid messaging paths earlier.

#### Implementation notes

A defensive fallback can be implemented by decorating message handling in a case structure that safely handles “received but not implemented” messages.

---

## Messaging Model

### Messages and interfaces

#### Contracts

- All messages MUST come from an interface.
- Messages follow the Interface Segregation Principle: one message method belongs to one interface.

#### Guidelines

- If naming conflicts appear, treat them as a signal that module boundaries and packaging need adjustment.

### Scheduling and ordering

#### Contracts

- Callers MUST assume they cannot control the order that messages execute.

#### Notes

- For priority semantics (if any), see [Runtime → Scheduling and Priority](Runtime.md#scheduling-and-priority).

### Message inputs and type definitions

#### Contracts

- Type definitions used as message inputs SHOULD be located in the message library.

#### Rationale

This supports dependency inversion and avoids circular dependencies.

### Polymorphic selection and implementation

![msg-poly-selection](../Images/msg-poly-selection.png)  
*Polymorphic message selection.*

![msg-implemented-recurse](../Images/msg-implemented-recurse.png)  
*Message implementation and recursion.*

> TODO: If these images drift from the current implementation, update the screenshots and record the version where they were captured.
>
> - **../Images/msg-poly-selection.png captured in:**  
> - **../Images/msg-implemented-recurse.png captured in:**  

### Private messages

#### Concepts

Certain messages are intended to be private (Self messages) and not told by external actors.

#### Contracts

- Private messages SHOULD be marked private to the containing actor library.
- Messages not exposed to external callers MUST be restricted via library access scope.

### No-Children actors

#### Definitions

- Canonical definition: see [Glossary → No-Children actor](Glossary.md#no-children-actor).

#### Contracts

- If a parent spawns a child, the parent SHOULD implement all interfaces required by the child for Child → Parent messaging.
- A runtime check MAY prevent spawning if the parent does not implement required Child → Parent messages.
- If the parent does not implement an interface, message methods are effectively no-ops, and default behavior MAY be handled in the parent (`Call Inspect.vi`) or the child (`Tell Parent Inspect.vi`).

#### Implementation notes

- `Call Inspect.vi` SHOULD internally use `Read Listened To Msg.vi` to ensure the message being inspected was listened to and not normally called inline.

### Setup-time messaging

#### Contracts

- Messages MAY be told to Self and Parent (and any children spawned) in `Setup.vi`.
- Actors MAY be spawned in `Setup.vi`.

> TODO: Confirm whether you want to treat “spawning in Setup” as an encouraged pattern or an allowed but discouraged escape hatch.
>
> - **Policy:** encouraged | allowed | discouraged  
> - **Rationale:**  

### Unified messages

#### Concepts

- Messages are decoupled between layers.
- Telling a message defined in an internal layer but not in other layers still means the message appears in **Unified Msgs**.

### Telling unimplemented messages

#### Concepts

A message can be told to an actor that has not implemented that message. This behavior can be modified by wrapper layers (for example: Core Actors).

> TODO: Define the default policy and the allowed policy overrides.
>
> - **Default behavior when message is not implemented:**  
> - **Where the policy lives (Base/Core/Edge/Caller):**  

### Unhandled messages

#### Notes

A practical test for validating unhandled message tracking:

1. Add a `Panel Close?` event.
2. Tell `Stop` to `Self`.
3. Tell `Stop` to `Self` again.
4. Verify the second `Stop` message is captured as an unhandled message.

> TODO: Define the canonical meaning of “unhandled message” and when it is recorded.
>
> - **Definition:**  
> - **Recorded when:**  
> - **How developers surface/consume it:**  

### Messages producing output data

#### Concepts

Messages can output data.

#### Rationale

This enables wrapper layers to consume inner-layer outputs for logging, auditing, metrics, or trace enrichment without re-computing or re-deriving the same data.

#### Ideas

- Consider a common output (for example: a log interface output) on terminal 1 that can be dependency injected with a developer-provided concrete implementation.

### Strongly-typed message destinations

#### Contracts

- jettl enforces a strongly typed messaging system where the message destination is known at edit time.
- An edit-time analysis (for example: via VI Analyzer or an actor-layer analyzer) SHOULD determine allowed spawn relationships by validating message contracts bidirectionally:
  - What the parent can **tell to** and **listen to** its child.
  - What the child can **tell to** and **listen to** its parent.

#### Documentation implications

Documentation tooling SHOULD be able to display which messages flow to and from `Self`, including:

- `Self → Self`
- `Parent → Self`
- `Child (with UID) → Self`
- `Self → Parent`
- `Self → Child (with UID)`

(`Self ← Self` is redundant and can be omitted.)

#### Scripting constraints

- Only the two left input terminals are valid for scripting message inputs; other inputs are ignored.
- If more than two inputs are required, define a typedef cluster in the message library.
- Only the two right output terminals are valid for scripting message outputs; other outputs are ignored.

---

## Lifetime Model

### Lifecycle pairs

The lifetime is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

### Stop contract

#### Contracts

- `Stop.vi`:
  - MUST start as `False`.
  - MUST only be changed to `True` inside `Stop.vi`.
  - MUST NOT be changed back to `False`.

- `Should Stop.vi`:
  - MUST stop when `Stop` is `TRUE` **OR** an error occurs.
  - MUST output `Can Stop = TRUE` when stopping conditions are met.
  - An error from `Finalize.vi` MUST imply the actor should stop; `Stop.vi` will be called if not already called.

### Orderly stopping (parent/child shutdown)

This section captures “orderly stopping” expectations for actor trees.

> TODO: Confirm the exact shutdown handshake you want to commit to.
>
> - **Who tells Stop to whom (default):**  
> - **Does a parent wait for all children to stop?**  
> - **If yes, where is the join/await implemented?**  
> - **What happens if a child never stops?**  

> TODO: Add acceptance tests for orderly stopping.
>
> - **Acceptance test #1 (happy path):**  
> - **Acceptance test #2 (child refuses to stop):**  
> - **Acceptance test #3 (Stop told twice):**  

---

## Spawning Model

### Inline vs async spawning

#### Concepts

Inline spawning exists to support resource setup in the main caller. If references are created in main and not closed, they are guaranteed to be alive for the application lifetime.

#### Notes

- Inline does not spawn an async process.
- Inline can be used to obtain outputs (actor state and error information) after the call completes, enabling straightforward dataflow signaling that an actor has stopped.
- Multiple inline spawns can exist in the same application (multiple roots).

### Spawning children

All children are spawned asynchronously.

### Reference lifetime and ownership

#### Guidelines

- Prefer creating and destroying references in the same actor.
- If a reference is created in Actor A and used in Actor B, define ownership explicitly:
  - Who is responsible for closing it.
  - Which actor is allowed to outlive the other.
- Prefer creating references in `Setup.vi` (not `Init.vi`) when the reference lifetime should match the actor lifetime.

#### Rationale

If a parent actor creates a reference that a child actor uses, and the parent actor stops while the child continues to run, the reference can become invalid in a way that is difficult to diagnose. Treat reference ownership as part of the actor contract: the creator should typically be the owner and should close it, unless ownership is explicitly transferred.

> TODO: Define the small set of “recommended” ownership patterns you want to endorse.
>
> - **Pattern 1 name:**  
>   - **Intent:**  
>   - **When to use:**  
> - **Pattern 2 name:**  
>   - **Intent:**  
>   - **When to use:**  

---

## Error Model

### Error catalog

#### Contracts

- All errors that can occur in jettl MUST be documented in `jettl.lvlib:Error.lvlib`.

### Error handling principles

#### Contracts

- No error goes unrecognized.
- No error goes unnoticed in the framework; everything is reported (except for releasing references).

#### Concepts

- Unless a function/method has an error input, it is assumed to run unconditionally when called.

### Serialization and error wires

#### Contracts

- Errors MUST NOT be used for serialization.
- A datatype MUST NOT be passed from input to output solely for serialization.

#### Guidelines

- If a method must be serialized, prefer an explicit structure (commonly a flat sequence structure; sometimes a case structure).

### Where errors are handled

#### Guidelines

- Errors SHOULD be handled by the method or layer that introduces the error, unless a different layer explicitly owns the recovery policy.
- A decorating layer MAY handle errors from inner layers when that layer is explicitly responsible for policy (for example: `Error Handling jettl Actor`), logging, or translation.
- A decorating layer SHOULD NOT silently swallow errors from inner layers unless that behavior is an explicit part of its contract.

#### Implementation notes

A generalized error-handling Core Actor can override default behavior (for example: clearing selected errors in `Finalize.vi`) while still exposing errors on the error wire for developer control.

### Wiring readability

![clean-propagation](../Images/clean-propagation.png)  
*Minimal bend wiring philosophy: prioritize readability. Keep the error wire pushed to the back. Avoid wires crossing over the object wire. Prefer explicit serialization structures over error-wire serialization.*

---

## Attributes

### Concepts

Actors allow `Self`, `Parent`, and `Child` relations to inspect unified actor state after start.

One example: if an actor is spawned with its front panel shown, the parent can determine whether the child panel should be displayed as a subpanel.

### Contracts

- Attributes MUST be instantiated when the actor is spawned.
- Attribute access MUST be read-only via method calls.

> TODO: If “when readable” needs to be precise per attribute field, fill in the table.
>
> | Attribute field | First valid phase | Updated phase | Notes |
> |---|---|---|---|
> |  |  |  |  |

### Rationale: Teller and Attributes libraries

The Teller and Attributes libraries are implemented as libraries containing interfaces and classes rather than collections of typedef clusters.

- **Encapsulation and controlled initialization**: classes encapsulate private data. Using `Init.vi`, the class private data is instantiated once, after which multiple read-only methods provide access.
- **Read-only access can be enforced with interfaces**: interfaces define and enforce read-only access patterns through method contracts.
- **Accessor discoverability and maintainability**: prefer objects with explicit accessor methods over raw clusters for long-term maintainability.

---

## Reentrancy

### Constraints

- Preallocated reentrancy cannot be used for dynamic dispatch.

### Guidelines

A goal of jettl is to use only reentrant method calls to preserve true asynchronous behavior.

- For dynamic dispatch methods: use **Shared** clone reentrancy.
- For non-dynamic-dispatch methods: default to **Preallocated (inline)**. If that does not work, use:
  - **Preallocated (no inline)**, or
  - **Shared**.

> TODO: Fill in concrete exceptions and the rationale.
>
> - **Non-reentrant calls allowed in jettl (if any):**  
> - **Methods forced to Shared (non-DD):**  
> - **Methods forced to Preallocated (no inline):**  
> - **Bookmark tag used for decisions:** `reentrancy`
