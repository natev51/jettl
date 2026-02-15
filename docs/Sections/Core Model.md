# Core Model

This document defines the **normative semantics** of jettl: the Actor model, the Messaging model, and the Lifetime/stop contract.

Sections explicitly labeled **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Terminology

Canonical definitions live in: [Glossary](Glossary.md).

This document uses the glossary terms as normative building blocks.

## Actor Model

### Actor transports

Actors may be implemented with different message transports.

![actor-transport-queue](../Images/actor-transport-queue.png)  
*Queue Actor.*

![actor-transport-event](../Images/actor-transport-event.png)  
*Event Actor.*

![actor-transport-notifier](../Images/actor-transport-notifier.png)  
*Notifier Actor.*

| Transport | Best For | Avoid When | Notes |
|---|---|---|---|
| Queue | Performance and throughput | UI-driven event handling | Message throughput is typically best because delivery is not constrained by the UI thread. |
| Event | Front panel events and IPC-style interactions | Sustained high-rate throughput | Use for event-structure-centric code, including dynamic event registration. |
| Notifier | “Last value” style update notifications | General-purpose message delivery | Specialty transport. Treat as experimental until you have benchmarks and tests. |

> TODO: Convert this table into a decision guide with concrete criteria.
>
> - **Throughput threshold that motivates Queue transport**:
> - **UI/event criteria that motivates Event transport**:
> - **Legitimate Notifier use cases**:
> - **Transport-specific acceptance tests**:

### Persistence: Core Actors, Edge Actors, and Base Actor

#### Contracts

- **Core Actors** and **Edge Actors** MUST be persistent layers for every actor spawned under a given Root.
- If the Root actor is spawned with `Debug jettl Actor` included in **Core Actors**, then that same instance of `Debug jettl Actor` MUST be used for each child actor spawned under that Root.
- **Base Actor** MUST be the innermost layer of the unified actor.

> TODO: Make the persistence contract mechanically checkable.
>
> - **Where the Core/Edge/Base stacks are configured (file/VI/palette)**:
> - **How an analyzer can verify the configured stacks**:
> - **What a violation looks like at runtime**:

### Decoration, actor layers, and recursion

#### Concepts

Actors can decorate each other in layers.

- If a layer implements a message method, that layer extends functionality for that message.
- If a layer does not implement a message method, that message is a no-op at that layer.

`Msg or Recurse.vi` checks the layer’s **Msgs** and determines whether the current layer implements the message method. If not implemented, it recurses to the next layer until the innermost layer is called.

> TODO: Add a diagram showing “outer → inner” recursion for a single message call.
>
> - **Diagram filename (under docs/Images/)**:
> - **Which example actor the diagram is based on**:

### Introspection and the unified actor

#### Concepts

The jettl API exposes public read-only accessors that can be used to read internals. Wrapped actors can use these read-only method chains to obtain the necessary information from the unified actor.

#### Contracts

- Introspection accessors exposed as public API MUST be read-only from the caller’s perspective.
- If an accessor is considered internal (not part of the stability contract), it MUST be documented as internal in the [API Reference](API%20Reference.md).

> TODO: List canonical introspection chains by intent, and label each chain’s stability.
>
> | Intent | Example call chain | Stability (Stable / Internal) | Notes |
> |---|---|---|---|
> | | | | |

### Private actors

#### Contracts

- A library MAY contain multiple actors.
- Exactly one actor SHOULD be the primary entry point for that library.
- Supporting actors in the library SHOULD be private to the containing actor library.

#### Guidelines

- Enforce “supporting actors are private” via a VI Analyzer rule.

> TODO: Define the analyzer rule precisely.
>
> - **Rule name**:
> - **What it checks (path/library scope/etc.)**:
> - **False positives to avoid**:

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

> TODO: Decide whether the UID mapping is part of the stable contract.
>
> - **Is the internal string mapping stable API or internal detail?**:
> - **If internal, what is the stable surface the user relies on?**:

### Message routing inspection overrides

#### Concepts

Overrides such as `Tell Self Inspect.vi`, `Tell Parent Inspect.vi`, and `Tell Child Inspect.vi` can enforce where messages are allowed to go (e.g., **Self**, **Parent**, **Child**) based on static destination selection at edit time.

#### Contracts

- If a message requires a relationship that is not satisfied, an error MUST be generated at runtime to prevent invalid message paths.
- A static analyzer test SHOULD eliminate these runtime errors by catching invalid messaging paths earlier.

#### Implementation notes

A defensive fallback can be implemented by decorating message handling in a case structure that safely handles “received but not implemented” messages by allowing an unexpected message through.

> TODO: Define the exact invalid-path error(s) and where they live.
>
> - **Error code(s)**:
> - **Where documented (Error.lvlib path)**:
> - **When thrown (which inspect override)**:

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
- The act of telling a message MUST NOT imply ordering guarantees beyond those provided by the chosen transport and the explicit design of the receiver.

#### Guidelines

- Prefer designs that do not require ordering assumptions.
- If ordering is required, serialize explicitly (for example: a single message representing the sequence, a state machine, or an explicit serialization structure).

Runtime-specific discussion lives in: [Scheduling and Priority](Runtime.md#scheduling-and-priority).

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

> TODO: Confirm these screenshots are current and rename files if needed.
>
> - **Source VIs used for screenshots**:
> - **Screenshots up to date? (Yes/No)**:
> - **If no, replacement filenames**:

### Private messages

#### Concepts

Certain messages are intended to be private (self-messages) and not told by external actors.

#### Contracts

- Private messages SHOULD be marked private to the containing actor library.
- Messages not exposed to external callers MUST be restricted via library access scope.

> TODO: Define the concrete mechanism developers should use to mark a message “private.”
>
> - **Library scope rule**:
> - **Naming convention (if any)**:
> - **Tooling support (if any)**:

### No-children actors

#### Definition

- **No-children actor**: an actor that cannot spawn children. It only messages with its parent and cannot have child messaging relationships.

#### Contracts

- If a Parent spawns a Child, the Parent SHOULD implement all interfaces required by the Child for Child → Parent messaging.
- A runtime check MAY prevent spawning if the Parent does not implement required Child → Parent messages.
- If the Parent does not implement an interface, message methods are effectively no-ops, and default behavior MAY be handled in the Parent (`Call Inspect.vi`) or the Child (`Tell Parent Inspect.vi`).

#### Implementation notes

- `Call Inspect.vi` SHOULD internally use `Read Listened To Msg.vi` to ensure the message being inspected was listened to (not normally called inline).

> TODO: Decide whether the “runtime check prevents spawn” is a requirement or a future idea.
>
> - **Is the runtime prevention check implemented today? (Yes/No)**:
> - **If yes, where?**:
> - **If no, do you want it? (Yes/No)**:

### Setup-time messaging

#### Contracts

- Messages MAY be told to Self and Parent (and any children spawned) in `Setup.vi`.
- Actors MAY be spawned in `Setup.vi`.

### Unified messages

#### Concepts

- Messages are decoupled between layers.
- Telling a message defined in an internal layer but not in the outer actor or Core Actor still means the message appears in **Unified Msgs**.

### Telling unimplemented messages

#### Concepts

A message can be told to an actor that has not implemented that message. This behavior can be modified in Core Actors.

> TODO: Define the default behavior when a message is told but unimplemented.
>
> - **Default behavior (drop? record as unhandled? error?)**:
> - **Where the behavior is implemented**:
> - **How Core Actors may change it**:

### Unhandled messages

#### Notes

A practical test for validating `Unhandled Msgs` behavior:

1. Add a `Panel Close?` event.
2. Tell `Stop` to Self.
3. Tell `Stop` to Self again.
4. Verify the second `Stop` message is captured as an unhandled message (for example: 1bd with an array of messages).

> TODO: Promote this into a repeatable test case (unit test or manual checklist).
>
> - **Test name**:
> - **Where it lives**:
> - **Expected artifacts (logs, counters, UI)**:

### Messages producing output data

#### Concepts

Messages can output data.

#### Rationale

This enables wrapper layers to consume inner-layer outputs for logging, auditing, metrics, or trace enrichment without re-computing or re-deriving the same data.

#### Ideas

- Consider a common output (for example, a log interface output) on terminal 1 that can be dependency injected with a developer-provided concrete implementation.

> TODO: Decide whether message outputs are part of the public contract (and what stability guarantees apply).
>
> - **Are message outputs stable API?**:
> - **Constraints on outputs (types, performance)**:
> - **Tooling implications**:

### Strongly-typed message destinations

#### Contracts

- jettl enforces a strongly typed messaging system where the message destination is known at edit time.
- An edit-time analysis (for example: VI Analyzer or an actor-layer analyzer) SHOULD determine allowed spawn relationships by validating message contracts bidirectionally:
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

> TODO: Confirm whether these scripting constraints are a permanent contract or an implementation choice.
>
> - **Permanent constraint? (Yes/No)**:
> - **If it ever changes, what is the migration plan?**:

## Lifetime Model

### Lifecycle pairs

The lifetime is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

The normative stop contract is defined below.

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

> TODO: Define any additional “stop reasons” that are part of the public contract.
>
> - **Stop on error policy (always/conditional)**:
> - **Errors that are treated as “normal stop”**:
> - **Errors that are treated as “fault”**:

## Spawning Model

### Inline vs async spawning

#### Concepts

Inline spawning exists to support resource setup in the Main actor. If references are created in Main and not released, they are guaranteed to be alive for the application lifetime.

#### Notes

- Inline does not spawn an async process.
- Inline can be used to obtain outputs (actor state and error information) after the call completes, enabling straightforward dataflow signaling that an actor has stopped.
- Multiple inline spawns can exist in the same application.

### Reference lifetime and ownership

#### Guidelines

- Prefer creating and releasing references in the same actor.
- If a reference is created in Actor A and used in Actor B, define ownership explicitly:
  - Who is responsible for releasing it.
  - Which actor is allowed to outlive the other.
- Prefer creating references in `Setup.vi` (not `Init.vi`) when the reference lifetime should match the actor lifetime.

#### Rationale

If a parent actor creates a reference that a child actor uses, and the parent actor stops while the child continues to run, the reference can become invalid in a way that is difficult to diagnose. Treat reference ownership as part of the actor contract: the creator should typically be the owner and should release it, unless ownership is explicitly transferred.

> TODO: Provide one concrete example that demonstrates a real failure caused by unclear ownership.
>
> - **Example description**:
> - **Reference type**:
> - **Observed failure mode**:
> - **How jettl’s guidance prevents it**:

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

#### Rationale

In jettl, the error wire is treated as data, not as a sequencing token. Using error wiring purely to force execution order:

- hides true dependencies (the diagram no longer shows *why* something must be ordered)
- increases wiring noise and reduces readability
- makes refactoring harder (implicit sequencing blocks safe parallelization)
- makes it easy to accidentally rely on “order” that was never part of the intended contract

#### Guidelines

- If ordering is required, use explicit sequencing constructs:
  - a flat sequence structure (common)
  - a case structure (when sequencing is conditional)
  - an explicit “sequence” message / state machine in the messaging model (when the order is part of behavior)
- If you need a value only to keep dataflow order, redesign the API or introduce an explicit sequencing mechanism rather than passing the value through unchanged.

> TODO: Add one concrete example of the anti-pattern and the corrected pattern.
>
> - **Anti-pattern screenshot filename**:
> - **Corrected pattern screenshot filename**:
> - **Where the example lives (repo path)**:
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

## Attributes

### Concepts

Actors allow `Self`, `Parent`, and `Child` relations to inspect unified actor state directly after start. This is helpful for persistent actors, debugging, and comparing current state to an earlier snapshot.

Example: if an actor is spawned with its front panel shown, the parent can determine whether the child panel should also be displayed as a subpanel.

### Contracts

- Attributes are static for an actor and MUST only be instantiated when the actor is spawned.

> TODO: Fill in the canonical attribute contract details.
>
> - **Who can read attributes** (Self/Parent/Child/No Relation):  
> - **When attributes become readable** (Init/Setup/Start/After Start):  
> - **Mutability rules** (read-only vs write):  
> - **Thread-safety / by-value rules**:  
> - **Introspection chains considered stable**:  

### Rationale: Teller and Attributes libraries

The Teller and Attributes libraries are implemented as libraries containing interfaces and classes rather than collections of typedef clusters.

- **Encapsulation and controlled initialization**  
  Classes encapsulate private data. Using `Init.vi`, class private data is instantiated a single time, after which multiple read-only methods provide access. This enforces the intended lifecycle and prevents developers from directly modifying underlying data (a risk that is difficult to avoid with typedef clusters).
- **Read-only access can be enforced with interfaces**  
  Interfaces define and enforce read-only access patterns through method contracts. Typedef clusters do not provide a comparable mechanism to restrict writes—any caller with the cluster can modify it.
- **Accessor discoverability and maintainability**  
  Avoid clusters in favor of objects with explicit accessor methods. Accessors are implemented as method calls (not property nodes).

## Reentrancy

### Constraints

- Preallocated reentrancy cannot be used for dynamic dispatch.

### Guidelines

A goal of jettl is to use only reentrant method calls for a true asynchronous framework.

Sequentially:

- For dynamic dispatch methods, use Shared (because preallocated is not available for DD).
- For non-DD methods, the default may be preallocated with inline; if that is incompatible, fall back to:
  - reentrancy preallocated no inline, or
  - reentrancy shared

> TODO: List concrete exceptions and the rationale for each.
>
> - **Exception (VI / method):**  
>   **Why it is not shared-clone default:**  
>   **Impact if changed:**  
>
> TODO: If you track these decisions via bookmarks, document the convention.
>
> - **Bookmark tag used (e.g., reentrancy)**:
> - **How to review all reentrancy decisions**:
