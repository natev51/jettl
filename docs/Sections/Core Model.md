# Core Model

This document defines the core semantics of jettl: the actor model, the messaging model, and the lifetime/stop contract.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Terminology

Canonical term definitions live in the [Glossary](Glossary.md).

> **JUSTIFICATION**: The previous draft defined terminology directly in this file. Moving definitions into the Glossary eliminates duplication and keeps the Core Model focused on normative contracts.

## Actor Model

### Actor Transports

![actor-transport-queue](../Images/actor-transport-queue.png)  
*Queue Actor.*

![actor-transport-event](../Images/actor-transport-event.png)  
*Event Actor.*

#### Guidelines

| Transport | Best For                   | Avoid When                            | Notes                                                                                             |
| --------- | -------------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Queue     | Performance / throughput   | IPC / event-structure-centric designs | Message throughput tends to be better; implementation is independent of UI-thread event handling. |
| Event     | Front panel events and IPC | Maximum throughput is required        | Use for event-structure-specific code, including dynamic event registration.                      |
|           |                            |                                       |                                                                                                   |

> **TODO:** Add a short transport decision guide (keep it beginner-friendly):
>
> - **Default recommendation**: Event (especially for UI and user-event-centric designs)
> - **When to pick Queue**: highest throughput and minimal coupling to event structures

Acceptance tests have not been performed or explored in the present writing.

### Persistence: Core Actors, Edge Actors, and Base Actor

#### Contracts

- **Core Actors** and **Edge Actors** are persistent layers for every actor in the application that are descendants of the same Root.
- If the Root actor is spawned with a given layer included in **Core Actors**, then that single instance of the Core Actor layer is composed into every child actor spawned under that Root.
- **Base jettl Actor** MUST be the innermost layer of the unified actor, unless an advanced developer provides their own Base layer (which effectively changes internal framework behavior). This is typically reserved for testing/debugging or deep framework experimentation.

### Introspection and the Unified Actor

#### Concepts

jettl exposes public **read-only** accessors for inspecting runtime state shared by the unified actor (for example, to support subpanel placement, debug layers, or runtime validation).

> **Terminology note:** the term “introspection chain” refers to a stable sequence of `Read *` calls that retrieves some piece of state (typically from Attributes).

> **TODO:** List “supported” introspection chains (by intent), and tag them as **Stable** vs **Internal**.
>
> - In these docs, “supported” means: documented, expected to remain compatible, and safe for application code to call.

| Intent | Example Call Chain | Stability (Stable/Internal/Experimental) | Notes |
| --- | --- | --- | --- |
| Find the VI Ref for a child actor (for subpanel placement) | `Attributes.lvclass:Read VI Ref.vi` | Stable | The exact internal storage may change, but the accessor contract should not. |

### Private Actors

#### Contracts

- A library MAY contain multiple actors that are marked private to the containing actor (for example, in a `Private Actors` virtual folder).
- Only one actor SHOULD be the primary entry point for an actor library; tightly coupled supporting actors should remain private to the library.
- Supporting actors in the library SHOULD be private to the containing actor library.

#### Guidelines

- A future tool MAY enforce “supporting actors are private” via a VI Analyzer test.

### Actor Layers

#### Concepts

Actors can decorate each other in layers.

- If a layer implements a Msg method, functionality is extended in that layer.
- If a layer does not implement a Msg method, that Msg method is effectively a no-op at that layer.

`Msg or Recurse.vi` checks `Msgs` for the current layer. Additional appended logic determines whether the current layer implements the message method; if not, it recurses to the next layer until the innermost layer is called (typically the Base).

### Child UIDs

#### Contracts

- `Child UIDs.ctl` enum is a static developer-facing string used for keeping track of Child UIDs that are known at edit time.

#### Implementation Notes

- Internally, UIDs are stored as strings in `Child Attributes Map.ctl`.
- Each actor defines its own private enum for child UIDs.
  - A runtime string mapping MAY be validated to ensure it only maps enum elements to their corresponding string values via the `Format Into String` primitive.

#### Rationale

- Actor code uses enums exclusively, avoiding stringly-typed identifiers which are easy to mistype and do not propagate rename updates across unrelated constants.
- The internal string representation remains compatible with mapping needs.

#### Guidelines

- The enum is currently edited manually.
- A future tool MAY automate enum updates.

### Message Routing Inspection Overrides

#### Concepts

Overrides such as `Tell Self Inspect.vi`, `Tell Parent Inspect.vi`, and `Tell Child Inspect.vi` can enforce where Msgs are allowed to go (e.g., **Self**, **Parent**, **Child**) based on static destination selection at edit time.

#### Contracts

- If a Msg requires a relationship that is not satisfied, and a routing inspection override is in effect, an error MUST be generated at runtime to prevent invalid message paths.
- A future static analyzer test SHOULD eliminate these runtime errors by catching invalid messaging paths earlier.
  - One possible approach: inspect implemented interfaces and child relationships to determine which Msg methods can legally flow between two actors. If a required Msg is missing on either side, surface the violation statically.

#### Implementation Notes

A defensive fallback can be implemented by decorating message handling with a case structure that safely handles “received but not implemented” messages.

One approach: a Core Actor layer overrides the necessary inspection hooks to parse message inputs, then checks private data (shared across overrides in the same turn) to decide whether to allow/deny the message.

## Messaging Model

### Messages and Interfaces

#### Contracts

- All Msgs come from an interface (this is a scripted action).
- Msgs follow the Interface Segregation Principle: one Msg method belongs to one interface.
  - This supports tooling: documentation generation, message validation (preventing runtime errors), and test generation.

#### Guidelines

- If naming conflicts appear for message naming, treat them as a signal that module boundaries and packaging need adjustment.
  - Refactor early; jettl tooling (rename/rescript) exists to keep refactors low-friction.

### Tell Semantics

#### Contracts

- A **tell** schedules a Msg for later execution on the destination actor (asynchronous work).
- Destinations are chosen explicitly as a relative relationship: `Self`, `Parent`, or `Child` (with a specific Child UID mapping).
- A successful tell MUST enqueue/emit exactly one Msg instance into the destination transport.
  - “Successful” here means the tell API returns without error.
- A told Msg is not guaranteed to be executed:
  - An actor may stop before listening to all pending messages.

> **JUSTIFICATION**: The earlier draft implied “told messages are always delivered” without distinguishing *enqueue/delivery* from *execution*. This version makes the contract explicit: tell schedules work; execution depends on actor lifetime and transport semantics.

### Scheduling and Ordering

#### Guidelines

- Callers SHOULD assume they cannot control the order that messages execute.
- If ordering is required, serialize explicitly (e.g., a single message representing the sequence, a state machine, or an explicit serialization structure).

For priority semantics (if any), see [Scheduling and Priority](Runtime.md#scheduling-and-priority).

### Message Inputs, Outputs, and Type Definitions

#### Contracts

- Type definitions used as Msg inputs SHOULD be located in the containing Msg library, if possible.
  - This prevents circular dependencies and keeps “message + data shape” co-located.

#### Rationale

This supports dependency inversion and avoids circular dependencies.

### Polymorphic Selection and Implementation

![msg-poly-selection](../Images/msg-poly-selection.png)  
*Polymorphic Msg.*

![msg-implemented-recurse](../Images/msg-implemented-recurse.png)  
*Msg implementation.*

These images illustrate the typical implementation pattern:

- An interface-defined Msg method exists (the “contract”).
- An actor implements that interface and overrides the Msg method.
- The override uses a “poly + recurse” structure so layers can extend behavior while still delegating to inner layers.

> **TODO:** Keep these screenshots aligned with the current template:
>
> - If template wiring changes, recapture:
>   - `../Images/msg-poly-selection.png`
>   - `../Images/msg-implemented-recurse.png`

> **JUSTIFICATION**: The previous draft contained “Why is this here?” notes. This section now states the intent: these images are the visual reference for the template pattern.

### Private Messages

#### Concepts

Certain Msgs are intended to be private (self-messages) and not told by external actors.

Place these Msgs in the `Private Msgs` virtual folder so they are private to the containing actor library and cannot be called externally.

#### Contracts

- Private Msgs SHOULD be marked private to the containing actor library.
- Msgs not exposed to external callers MUST be restricted via library access scope.

### No-Children Actors

See the definition of **No-Children Actor** in the [Glossary](Glossary.md#no-children-actor).

#### Contracts

- If a Parent spawns a Child, the Parent SHOULD implement all interfaces required by the Child for Child → Parent messaging.
- A runtime check MAY prevent spawning if the Parent does not implement required Child → Parent messages (this could also be enforced by a VI Analyzer test).
- If the Parent does not implement an interface, message methods are effectively no-ops; default behavior MAY be handled in the Parent (`Call Inspect.vi`) or the Child (`Tell Parent Inspect.vi`).

#### Implementation Notes

- `Call Inspect.vi` SHOULD internally use `Read Listened To Msg.vi` to ensure the message being inspected was listened to and not normally called with `Call.vi` for that particular message.

### Setup-Time Messaging

#### Contracts

- Msgs MAY be told to `Self` and `Parent` (and any spawned children) in `Setup.vi`.
  - Parent attributes are already known in Setup, so Parent-directed tells are well-defined.
  - Children may be spawned in Setup, enabling Setup-time configuration before normal message processing begins.
- Actors MAY be spawned in `Setup.vi`.
- Spawning is the only intentionally synchronous relationship: a parent can fail a spawn and thereby fail the higher-level startup sequence.
  - After startup completes, normal message processing is asynchronous.

> **JUSTIFICATION**: The previous draft mixed several ideas (spawn synchronization, patterns, race-condition avoidance) in one paragraph. This rewrite separates contracts (what is allowed) from rationale (why you would do it).

### Unified Messages

#### Concepts

- Msgs are decoupled between layers.
- If a Msg is implemented in only one layer, it still appears in `Unified Msgs`.
  - A common case: `Stop` and `Stopped` are implemented in the Base Actor, even if outer layers do not implement them.

### Telling Unimplemented Messages

#### Concepts

A Msg can be told to an actor that has not implemented that Msg.

This behavior can be modified by Core Actor layers (for example, to reject unimplemented messages, to log them, or to treat them as no-ops).

### Unhandled Messages

#### Notes

A practical test for validating `Unhandled Msgs` behavior:

1. Add a `Panel Close?` event to an event actor.
2. Tell `Stop` to `Self` here.
3. Tell `Stop` to `Self` again after the above `Stop`.
4. Verify the second `Stop` Msg is captured as an unhandled message to confirm one of the `Stop` Msgs was not handled (because the actor is already stopping and will not execute additional messages).

### Messages Producing Output Data

#### Concepts

Msg methods can output data.

#### Rationale

This enables wrapper layers to consume inner-layer outputs for things such as logging, auditing, metrics, or trace enrichment without re-computing the same data.

Example: a layer performs analysis and returns the analyzed data as part of the Msg output, allowing an outer layer to log or publish it without repeating the analysis.

#### Ideas

- Consider an output (e.g., a log interface output) on terminal 1 that can be dependency injected with a developer-provided concrete implementation such as detected events for starting and stopping given certain message outputs.

### Strongly-Typed Message Destinations

#### Contracts

- jettl enforces a strongly typed messaging system where the Msg destination is known at edit time (relative `Self`, `Parent`, or `Child` with a specific UID mapping).
- An edit-time analysis (via VI Analyzer or an actor-layer analyzer) SHOULD determine allowed spawn relationships by validating message contracts bidirectionally:
  - What the parent can **tell to** and **listen to** its child.
  - What the child can **tell to** and **listen to** its parent.
  - This supports documentation generation.

#### Documentation Implications

Documentation tooling SHOULD be able to display which messages flow to and from `Self`, including:

- `Self → Self`
- `Parent → Self`
- `Child (with UID) → Self`
- `Parent ← Self`
- `Child (with UID) ← Self`

(`Self ← Self` is redundant and can be omitted.)

#### Scripting Constraints

- Only the two left input terminals are valid for scripting Msg inputs; other inputs are ignored.
  - If more than two inputs are required, define a typedef cluster in the Msg library.
- Only the two right output terminals are valid for scripting Msg outputs; other outputs are ignored.

## Lifetime Model

### Lifecycle Pairs

The lifetime is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

### Stop Contract

#### Contracts

- `Stop.vi`:
  - The internal stop flag starts as `False`.
  - The stop flag may only transition to `True` inside `Stop.vi`.
  - The stop flag is monotonic: it cannot be changed back to `False`.
- `Should Stop.vi`:
  - An actor should stop when the stop flag is `TRUE` **OR** when an error occurs.
  - Outputs `Can Stop = TRUE` when stopping conditions are met.
  - An error from `Finalize.vi` MUST imply the actor should stop; `Stop.vi` will be called if not already called.

> **NOTE:** Telling `Stop` multiple times is expected to be idempotent in effect (the first `Stop` initiates shutdown; subsequent `Stop` Msgs may become unhandled).

## Spawning Model

### Call vs Async Spawning of Root

#### Concepts

Call spawning exists to support resource setup in the Main actor. If references are created in Main and not closed, they are guaranteed to be alive for the application lifetime.

#### Notes

- Call does not spawn an async actor.
- Call can be used to obtain outputs (actor state and error information) after the call completes, enabling straightforward dataflow signaling that the root actor has stopped.
- Multiple call spawns can exist in the same application (multiple roots can occur in the same application).

### Spawning Children

All children are spawned asynchronously.

## Error Model

### Error Catalog

#### Contracts

- All errors that can occur in jettl are documented in `jettl.lvlib:Error.lvlib`.

### Error Handling Principles

#### Contracts

- No error goes unrecognized.
- No error goes unnoticed in the framework; everything is reported (except for releasing references).

#### Concepts

- Unless a function/method has an error input, it is assumed to run unconditionally when called.

View this resource on error handling: [How I Approach Errors and Multiple Error Collection in LabVIEW](https://www.youtube.com/watch?v=2Vjk3of5d1Q&list=LL&index=1)

### Serialization and Error Wires

#### Contracts

- Errors MUST NOT intentionally be used for serialization.
  - A datatype MUST NOT be passed from input to output solely for sequencing.
  - The most common misuse is the error wire.

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

![clean-propagation](../Images/clean-propagation.png)  
*Minimal bend wiring philosophy: prioritize readability. Keep the error wire pushed to the back. Avoid wires crossing over the object wire. Prefer explicit serialization structures over error-wire serialization (this is not shown in the image).*

## Reference Lifetime and Ownership

This section defines ownership rules for reference-like resources (queues, DVRs, user events, VI refs, app refs, etc.).

> **JUSTIFICATION**: Orientation referenced “Reference Lifetime and Ownership”, but the Core Model did not yet contain a canonical contract. Adding this section fulfills the ownership map requirement (“reference ownership rules” belong in Core Model).

### Contracts

- The actor that **creates** a reference is its **owner**.
- Owners MUST close/destroy the references they create.
- Non-owners MUST NOT close/destroy references they did not create.
- If a reference is shared across actors, the owner MUST guarantee the reference outlives all consumers.
  - Common strategy: create shared references in the Root (or another actor with a known-long lifetime), and destroy them after the tree has fully stopped.
- When practical, prefer *local ownership*:
  - create and destroy references within the same actor layer or unified actor that uses them.

### Rationale

Actors are asynchronous. If a child relies on a reference created by a parent, the child cannot assume the parent will outlive that reference unless the design explicitly guarantees it.

## Attributes

`Read *` and `Write *` methods should do only what their name implies: read or write with no additional behavior.

> **TODO:** If there is a specific rationale for the Teller and Attributes libraries beyond what’s captured below, keep it here (Attributes semantics live in Core Model).

### Concepts

Actors allow `Self`, `Parent`, and `Child` relations to inspect unified actor state after start. This is useful for persistent actors, debugging, and comparing current state to an earlier snapshot.

Example: if an actor is spawned with its front panel shown, the parent can determine whether the child panel should also be displayed as a subpanel.

### Contracts

- Most Attributes are instantiated when the actor is spawned.
  - The remaining Attributes are instantiated just before Setup and after Start / Teardown in Starting.
- Attribute access is read-only via method calls.

### Visibility and Timing

| Item | Value |
| --- | --- |
| Who can read attributes | `Self`, `Parent`, and `Child` relations that share the same Root. Actors with **No Relation** MUST NOT be able to read attributes. |
| When attributes become readable | Most attributes are readable during `Setup.vi` and `Start.vi` / `Teardown` in Starting. The unified actor is updated after start completes; if `Setup.vi` throws an error, the actor state is still updated after teardown completes. |
| Mutability rules | Read-only method calls only. |
| Thread-safety / by-value rules | Attribute data is by-value, except for reference-like fields (e.g., App Ref, VI Ref). |
| Introspection chains considered stable | All attribute introspection chains are considered stable. |

> **TODO:** If “when readable” needs to be precise per field, add a table with concrete examples.
>
> Example intent: “VI Ref is valid during Setup” vs “Actors array is not finalized until after Start”.

| Attribute Field | First Valid Phase | Updated Phase | Notes |
| --- | --- | --- | --- |
| *(example)* `VI Ref` | Spawn/Setup | Stable after Start | Used for panel/subpanel patterns. |
| *(example)* `Actors` (unified stack) | Setup (partial) | After Start / after Teardown-on-error | Outer layers can inspect final composition. |

### Rationale: Teller and Attributes Libraries

The Teller and Attributes libraries are implemented as libraries containing interfaces and classes rather than collections of typedef clusters.

- **Encapsulation and controlled initialization**  
  Classes encapsulate private data. Using `Init.vi`, the class private data is instantiated a single time, after which multiple **read-only** methods provide access. This enforces the intended lifecycle and prevents developers from directly modifying the underlying data.
- **Read-only access enforced with interfaces**  
  Interfaces define and enforce read-only access patterns through method contracts. Typedef clusters do not provide a comparable mechanism to restrict writes.
- **Accessor discoverability and maintainability**  
  Avoid clusters in favor of objects with explicit accessor methods (anemic classes), since access points are easier to locate and reason about. These accessors are implemented as **method calls**, not property nodes.

## Reentrancy

### Guidelines

A goal of jettl is to use reentrant method calls to preserve true asynchronous behavior.

Recommended conventions:

- For **dynamic dispatch** (DD) methods: jettl commonly uses **Shared clone** reentrancy.
- For **non-DD** methods: jettl commonly prefers **Preallocated** reentrancy. If that does not work, use one of:
  1. **Preallocated (no inline)**
  2. **Shared**
  in that order. Comments should outline these design decisions.

Current benchmarking note:

- Currently, preallocated (inline) is not used for any method/function calls. This is strictly because benchmarking is being performed on the effects of each method call to optimize throughput.
- Note: the VI Profiler cannot evaluate inline function/method calls.

References:
- [Quick! Drop Your VI Execution Time!](https://www.youtube.com/watch?v=24t-D7_BmjM)
- [Run time Code Analysis in LabVIEW](https://www.youtube.com/watch?v=dTqKZmFFyw8)

> **TODO:** Fill in concrete exceptions and the rationale.
>
> - **Non-reentrant calls allowed in jettl (if any)**:
> - **Methods forced to Shared (non-DD)**:
> - **Methods forced to Preallocated (no inline)**:
> - **Bookmark tag used for decisions**: `reentrancy`

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

> Answer these to tighten the normative contract and reduce ambiguity.

- **What does “Turn” mean in each transport (Queue/Event)?**: It means the same thing as the definition outlined in the Glossary.
- **Does jettl guarantee “at-most-once” delivery for a told message? If not, what are the failure modes?**: A successful tell enqueues exactly one Msg; however, execution is not guaranteed because an actor may stop before listening to all pending Msgs.
- **What is the canonical definition of “unhandled message” (and when is it recorded)?**: Unhandled messages are messages that were delivered/told but not listened to (and therefore not executed) before stop; they may be recorded during teardown for diagnostics.
- **Which introspection chains are guaranteed stable across releases?**: All attribute accessor chains are intended to be stable. Non-attribute internal chains should be treated as internal unless documented in the API Reference.
- **Which behaviors are intentionally transport-specific vs transport-invariant?**: Transport mechanics and performance are transport-specific; the messaging model (tell semantics, relative destinations, no ordering guarantees) is transport-invariant unless explicitly called out.
- **What error policy is part of the framework contract vs intentionally left to Core Actors?**: The stop-on-error behavior is defined in `Should Stop.vi`. Recovery policies beyond that (e.g., clearing selected errors, retries) are intentionally left to decorating layers that explicitly own policy.
- **Which attributes are guaranteed readable during `Setup.vi` vs only after `Start.vi`?**: Most attributes are readable during `Setup.vi`; the unified actor composition and some fields (like the final `Actors` stack) may not be finalized until after `Start.vi` (or after `Teardown` if Setup fails).
- **What is the minimum test suite required to validate “Core Model compliance”?**: Suggested baseline acceptance tests:
  1. **Tell semantics**: a successful tell enqueues one Msg; invalid destinations produce errors when inspection overrides are enabled.
  2. **Ordering**: show that ordering is not guaranteed (e.g., interleaved tells from multiple sources).
  3. **Stop idempotence**: multiple `Stop` tells result in one shutdown; additional stops become unhandled.
  4. **Unhandled messages**: pending messages are surfaced/recorded on teardown as designed.
  5. **Attribute visibility**: verify which fields are readable in Setup/Start/Teardown.
  6. **Reference ownership**: verify that shared references are not closed by non-owners and remain valid for intended lifetimes.
