# Usage

This document collects practical patterns, recipes, and example-oriented guidance for building systems with jettl.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Examples

### Continuous Measurement and Logging

> **TODO:** Define:
>
> - **What is being measured**:
> - **Where measurements are recorded**:
> - **Message shape (typedef)**:
> - **Expected rates / throughput targets**:

### Hello World

Don't need to tell yourself `Stop` for Hello World. Just have `Stop` itself at the end of the Hello World msg.

> **TODO:** Link to a concrete Hello World example (code + screenshot).
>
> - **Example location (repo path or VIPM example name)**:
> - **What the user should observe**:

> Note: For VIPM/Example Finder distribution details, see [Examples Packaging Notes](Tooling.md#examples-packaging-notes).

## Reuse Actors

This section goes over reuse actors that have either been implemented or can be implemented, external to the core library.

### Panel Actors

Separate repo that has this reuse actor.

Common functionality to update the front panel state:

- includes window operations and subpanels
- unique passing of actor ref reference to the parent (from when it spawns as a child), no need to pass around the subpanel reference
- wire in as a persistent layer

Usefulness of having `Actor Ref` as an input before `Setup.vi` and `Start.vi`:

- allows for the parent to have access to the `Actor Ref`
- that means the parent has access to put that method in its subpanel instead of passing the child across the parent's subpanel

Inspiration:

- [MGI Panel Manager - Unmonitored](https://gitlab.com/justACS/mgi-panel-manager-unmonitored)

Subpanels notes:

- After the child has spawned, the parent has access to Child Attributes, which has `VI Ref`, so it can place that VI ref into a subpanel.
- Since you directly have access to the VI ref of the Child Attributes, you can modularize where front panels are in the actor front panel of `Self` by changing around panels.
- Advanced application: interchangeable front panels where you have two created actors, and the ability to toggle front panel displays as either being in the subpanel.

Lifecycle convention:

- Open in `Start`
- Close in `Teardown`

Queue actors and notifier actors can also have front panels. Though, there shouldn't be control and indicator terminals since this would be functionality specific for an event actor. Instead, a queue actor would primarily have subpanel control references.

> **TODO:** Document:
>
> - **Where Panel Actors live (repo / package name)**:
> - **Which layer (Core vs Edge) they belong in**:
> - **Minimal example**:

### Broker

Resources:

- https://bitbucket.org/composedsystems/mva-framework/src/master/
- https://bitbucket.org/composedsystems/stream/src/master/

Communicating between targets:

![Broker startup scratch](../Images/broker-startup-scratch.jpeg)

Also, for an inter-actor system, you can wrap around a Core Actor (using spawn root) the functionality of holding DVRs as some mediator process to allocate telling messages across the tree via user events.

This is a single-application-only method for publisher-subscriber, by using the decorated actor methodology.

#### Observer-style subscription

Just like spawning, the observer pattern used will have a blocking call when subscribing/registering for a topic by creating its own child actor, with the necessary private data internal to talk with the broker and its child actors.

This could be a `Core Actor`.

You can put a non-reentrant method call in `Setup.vi` for a given actor which can put setup information to a by-reference “thing” in the application.

Telling events across the tree via the No Relation type.

#### Mediator / Assembler Wrapper

A mediator-based design is inherently dataflow-friendly and avoids memory leaks because actor creation is serialized and coordinated through the mediator. Each actor instance is created at most once at a time under mediator control.

Actor spawning can be enforced by placing a non-reentrant VI inside the `Spawn` override, ensuring that concurrent instantiation cannot occur.

Actors may only shut down when explicitly instructed by the mediator. The mediator maintains authoritative knowledge of all actor references and determines which actors are permitted to tell messages to which recipients. This centralized reference management naturally supports observer-style interactions, including publisher–subscriber relationships.

Deadlocks cannot occur because the mediator processes interactions sequentially. While this introduces a potential bottleneck, that tradeoff is intrinsic to mediator or broker-based architectures and is often acceptable for the guarantees it provides.

The mediator functions as the system’s routing authority: it forwards messages only to actors holding valid references for the intended interaction. Individual actors are isolated from one another and are aware only of the mediator—not of other actors in the system.

Conceptually, this resembles the existing framework, with the key distinction that messages are routed through the mediator. Because the mediator holds references to all actors, it can forward messages to the appropriate recipients based on those references.

The actor itself still maintains references to its own `Self`, `Parent`, and `Children`; however, the mediator also tracks these relationships and governs how references may be used. The actor does not know other actors exist—it only interacts with the mediator.

This architecture supports the observer pattern cleanly. Actor references exist in exactly two places: the mediator and the actor itself. The mediator always retains the authoritative set of references and provides actors with only the references necessary for their permitted interactions.

Additionally, the mediator knows which messages an actor can handle through a unified messaging model. Because messages are defined via interfaces, the mediator can determine—at edit time—which messages an actor supports by inspecting the interfaces it implements. Message validation and routing decisions occur in the mediator, not in the actor.

At a higher level, this mediator can be viewed as a concrete component that encapsulates application-level business logic, coordinating a set of more specialized and reusable subcomponents. In practice, this mediator often corresponds to a top-level actor.

##### Multiple Application Instances

For multi-application scenarios, one approach is to introduce an application-level mediator that coordinates communication between individual application mediators. This suggests a layered mediator structure:

- Each application instance contains its own internal mediator.
- A higher-level mediator facilitates communication between application mediators.
- When multiple application instances are running, their top-level mediators exchange references and coordinate cross-application messaging.

If two applications need to communicate, each retains its own mediator. One possible extension is an additional mediator layer above both, responsible for managing inter-application interactions.

##### Assembler Role

An assembler may be used strictly to construct actors and distribute references required for observer-style relationships. Actors request construction and reference wiring through the assembler, rather than directly creating or discovering other actors.

> **TODO:** Decide whether “Broker/Mediator” belongs in:
>
> - **Usage (as a reusable pattern)**, or
> - **Non-Normative (as a roadmap idea)**.
>
> If it moves, keep a short summary here and link to the canonical page.

### Bridge Actors

Used to connect to non-jettl code via user events.

Bridge actors connect jettl and non-jettl LabVIEW applications.

Intra-application LabVIEW with non-jettl code:

- Before spawn, pass in the queue or event references you want it to use to publish any data, to establish bidirectional communication.

You can spawn an actor and tell it messages from any LabVIEW code, not only from other actors. The primary challenge is receiving messages from that actor. This is the role of a **bridge (adapter or shim)**.

#### 1. Create a pure actor

Start by creating a proper actor that performs the required work (for example, hardware interaction). This actor must strictly follow jettl rules:

- All communication occurs through actor messaging.
- No shared data access.
- No reply messages to non-actors.

By keeping this actor “pure,” it remains reusable in fully jettl–based applications as well as in mixed environments.

#### 2. Create a bridge (adapter) actor

Next, introduce a bridge actor that sits between the calling (non-actor) code and the pure actor.

- Toward the pure actor, the bridge behaves like a normal jettl actor and follows all jettl rules.
- Toward the caller, the bridge is allowed to break jettl rules, since the caller is not an actor.

This separation preserves correctness and reusability while enabling integration with legacy or non-jettl code.

#### 3. Define pass-through command messages

The bridge actor should expose a set of standard messages that mirror those accepted by the nested pure actor.

- These messages are simple pass-throughs.
- The bridge forwards them directly to the pure actor.
- This is straightforward to implement when using interfaces.

#### 4. Establish return paths using reference objects

Because the caller is not message-driven in the jettl sense, returned data must flow through reference objects:

- Use **DVRs** for tagged or state-style data.
- Use **queues** for telling data or asynchronous notifications.

These references can be:

- Created by the calling code and passed to the bridge at startup (simplest approach), or
- Created by the bridge and returned to the caller (useful when the caller VI may go out of memory before the actor shuts down, which is common in TestStand-based systems).

#### 5. Handle data from the pure actor

When the nested pure actor produces data for the bridge:

- The bridge receives the message.
- The bridge stores the data in the appropriate reference object (DVR or queue).

#### 6. Consume data in the calling code

The calling code retrieves data from the reference objects as needed.

For example:

- If the caller is a **QMH**, pass the QMH queue into the bridge.
- When the bridge receives data from the pure actor, it constructs a QMH message and enqueues it with the received data.

If the caller is **not** message-driven:

- Do not forward messages directly.
- Instead, wrap all bridge interaction in a class that provides:
  - Create/Destroy VIs to launch and shut down the bridge actor.
  - Command VIs that tell messages to the bridge.
  - Data access VIs that read from DVRs or queues.

This pattern encapsulates the actor interaction while presenting a conventional API to non-jettl code.

Bridge validation note:

- Then test with the user event code.
- Possibly: provide a user event helper that creates user events for `Stop Msg` and `Stopped Msg` (useful for IPC-style integrations).

> **TODO:** Capture the canonical bridge pattern as a diagram and a minimal working example.

### Periodic Messaging

This has to come from another entity that determines timing of when to tell a message. Ethan Stern has a presentation on periodic messaging.

A specialty actor is spawned for timing. The actor that spawned it holds the truth for the state of the periodic message in case of timing issues where the child tells another message after telling. This behavior can be handled in the `Inspect.vi` override.

“Tells a message periodically” does not imply the messages are executed periodically.

Tell a message and have it tell with only one copy; this ensures there's only ever one copy in the queue.

Sketch:

Init.vi inputs:

- Msg strategy
- Period

Process.vi:

- unbundle Period
- timeout case: unbundle Msg to tell to `Creator.vi`

Guideline:

- An actor should not have in its own timeout way to do something periodically such as tell itself a message every 100 ms.
- Instead it must create a periodic messaging actor which in its timeout tells the message to the actor that requires the periodic message. Separate the concerns.

Additional notes:

- This could be an event actor, but notifiers work well with timing.
- If it was an event actor, it would have to wait for the next event to occur via the timeout case in the event loop.
- Interruptions in the event loop can prevent correct periodic timing.

### Monitor Msg Traffic

Since one cannot monitor a queue status, overriding the tell messages in a wrapper actor can put each told message into a log and mark as not read (organized by timestamp).

Then when the message is being acted upon (in `Call Inspect.vi` with `Msg Listened To.vi`), the matching timestamp can be marked as read.

This allows the system to infer how many msgs haven’t been executed (how many are effectively “in the queue”) since the message destination is known before the message is told.

Initialization requires:

- Self Attributes
- Parent Attributes

Note: child information is redundant since you can construct everything with Self and Parent Attributes.

After telling a message, log the **Time**.

After listening to a message, log the **Listened Time**.

> **TODO:** Define:
>
> - **Log schema**:
> - **Correlation IDs**:
> - **How to handle message cancellation / stop**:

## Design Patterns

### Decorator Pattern

**Class Inheritance to SPaIC**

SPaIC: Subtype Polymorphism and Interface Composition

![Decorator pattern 1](../Images/dec_1.jpeg)  
![Decorator pattern 2](../Images/dec_2.jpeg)  
![Decorator pattern 3](../Images/dec_3.jpeg)

jettl dynamic decorator pattern:

- You can swap around the way these are wrapped.
- Example conceptual stack:
  - Your actor
  - Panel actor
  - Base actor

### State Pattern

Resources:

- [State Pattern – Design Patterns (ep 17)](https://www.youtube.com/watch?v=N12L5D78MAA)
- [State of Grace - The State Pattern in LabVIEW](https://www.youtube.com/watch?v=HewNBC4TjKs)
- [Powerful Design with the Gang of Four - Tom McQuillan and Sam Taggart](https://www.youtube.com/watch?v=IM8ZU1af6wQ&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=22)
- [A Class Act: Simple Design Patterns to Improve Code Quality, Allen C Smith - GDevCon N.A. 2023](https://www.youtube.com/watch?v=GRDoyn1mNAI&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=18)
- [A Class Act - Allen C Smith(JustACS) - GDevCon#4](https://www.youtube.com/watch?v=yVzT5ZqUuVU&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=19)

State must not be modified in `Entry.vi`.

Disallowing state transitions in both `Entry.vi` and `Exit.vi` is intentional. A state must be fully entered or fully exited before a transition is permitted. This constraint prevents infinite state transitions and enforces a well-defined state lifecycle.

Context classes should be private, since only interface objects should be composed into a class.

Dependency Inversion Principle:

Since the context class is private to the library it is in (and the State Interface with its concrete state classes), public static dispatch methods can be used in the context class AND concrete state classes without worrying that they'll be used outside the library since the context class is private.

### Factory Pattern

The Factory Pattern is used to create instances of actors without specifying the exact class of the actor that will be created.

This allows for greater modularity in the actor design.

Easy Factory pattern integration with actor interface for plug-and-play architectures such as PPLs.

## Feedback Questions

- **Which 3 examples are “required reading” for new users?**:
- **Which reuse actors are already implemented vs only planned?**:
- **For each reuse actor, what is the stable API surface?**:
- **Which patterns should be enforced vs only recommended?**:
- **Which of the “Broker/Mediator” ideas do you want to commit to in the near term?**:
