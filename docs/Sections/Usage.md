# Usage

This document collects practical patterns, recipes, and example-oriented guidance for building systems with jettl.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Examples

Examples are discoverable through the LabVIEW Example Finder and through VIPM.

- Keywords like `jettl`, `actor`, etc. make examples appear at the top of searches in the Example Finder.
- Examples appear on the VIPM install page.

### Continuous Measurement and Logging

This is an extension of the main example that ships with LabVIEW, implemented in jettl.

> **TODO:** Define:
>
> - **What is being measured**:
> - **Where measurements are recorded**:
> - **Message shape (typedef)**:
> - **Expected rates / throughput targets**:

### Hello World

Telling the stop message to self via a button on front panel with event structure.
Don't need to tell yourself `Stop` for Hello World. Just have `Stop` itself at the end of the Hello World msg.

> **TODO:** Link to a concrete Hello World example (code + screenshot).
>
> - **Example location (repo path or VIPM example name)**:
> - **What the user should observe**:

> Note: For VIPM/Example Finder distribution details, see [Examples Packaging Notes](Tooling.md#examples-packaging-notes).

### Timer

Darren Nattinger creating a timer introductory example would demonstrate jettl and provide a comparison point to DQMH, while referencing his presentation [Introduction to DQMH](https://www.youtube.com/watch?v=AiEgO8bXQz8).

### Acquisition, Analysis, Logger

This would be an excellent follow up to this great presentation:
[GDevCon ANZ #2 - Round 1: AF vs DQMH – Karina Taylor and Chris Virgona](https://www.youtube.com/watch?v=eYdnxcF5-9g)

## Reuse Actors

This section goes over reuse actors that have either been implemented or can be implemented. These actors would either be core actors, mid actors, or edge actors.

These reuse actors should live in their own repositories, that can be packaged up and shared with the community.

### Exist

> **TODO:** List which reuse actors are already implemented, and where they live (repo/package name).

### Do Not Yet Exist

#### gRPC Actors

> **RESPONSE**: I have added this section here, clean up as necessary:
> 
> Since jettl uses the ISP, the messages are unique and because type defs are defined in the message, by best practice. This allows for easy finding for creating .proto files for gRPC. These are all messages in the same way so a proto file is effectively just a list of jettl Msg libraries
#### Panel Actors

Common functionality to update the front panel state including those for window operations and subpanel operations:

- passing of `VI Ref` to the parent (from when it spawns as a child) occurs natively.

Usefulness of having `VI Ref` as an input before `Setup.vi` and `Start.vi`:

- allows for the parent to have access to the `VI Ref`
- that means the parent has access to put that method in its subpanel instead of passing the child across the parent's subpanel

Inspiration:

- [MGI Panel Manager - Unmonitored](https://gitlab.com/justACS/mgi-panel-manager-unmonitored)

Subpanels notes:

- After the child has spawned, the parent has access to `Child Attributes`, which has `VI Ref`, so it can place that `VI Ref` into a subpanel.
- Since you directly have access to the VI ref of the `Child Attributes`, you can modularize where front panels are in the actor front panel of `Self` by changing around panels.
- Advanced application: interchangeable front panels where you have two spawned child actors, and the ability to toggle front panel displays as either being in the subpanel.

Common Lifecycle convention:

- Open in `Start`
- Close in `Teardown`

Queue actors can have front panels. Though, not strictly true, there shouldn't be control and indicator terminals for these actors since this would be functionality specific for an event actor. Instead, a queue actor would primarily have subpanel control references.

> **TODO:** Document:
>
> - **Where Panel Actors live (repo / package name)**: Their own repository.
> - **Which layer (Core vs Edge) they belong in**: Either.
> - **Minimal example**: A parent puts its child `VI Ref` in one of its subpanels.

#### Broker / Mediator (Roadmap Idea)

A broker/mediator pattern is a useful thought exercise for breaking strict hierarchical communication, especially for multi-target or multi-application systems.

This material is intentionally not committed as a recommended pattern in the near term.

- Canonical discussion: [Non-Normative → Broker / Mediator](Non-Normative.md#broker--mediator)

> **JUSTIFICATION**: The original Usage page contained a long broker/mediator exploration, but also noted it is likely an antipattern and not something to commit to. Moving the full content to *Non-Normative* keeps Usage focused on recommended, teachable patterns while preserving the exploration.

#### Periodic Messaging jettl Actor

Properly timed message streams have to come from another entity that determines timing of when to tell a message. Ethan Stern has a presentation where he talks about periodic messaging.
[2019 ACLA Ethan Stern Complex AF Avoid The Pitfalls Of Bad Asynchronous Programming](https://www.youtube.com/watch?v=39E2LUGOBxc)@32:51.

This Periodic Messaging jettl Actor is spawned for timing. The actor that spawned it holds the truth for the state of the periodic message in case of timing issues where the child tells another message after telling. This behavior can be handled in the `Inspect Call.vi` override by checking the state and ignoring messages received.

There probably needs to be a unique identifier of the Periodic Messaging jettl Actor in case another instance is spawned and there needs to be metadata in the message to discern where the message has come from / or if the Periodic Messaging jettl Actor has stopped, but another one has been spawned, sending another message.

This is a different unique identifier, which could be tied to the actor instance which by LabVIEW definition will always be unique identifier. Further on this, a function could be made in the framework that gets the `Instance ID`, which is different from the `Alias`.

“Tells a message periodically” does not imply the messages are executed periodically, but rather that the messages are told periodically. Of course the resolution is limited to 1 ms as the low end tell rate as defined through the event structure.

Idea: Tell a message and have it tell with only one copy; this ensures there's only ever one copy in the queue.

Sketch:

`Init Actor.vi` inputs:

- `Msg`
- `Period (ms)

`Actor.vi`:

- unbundle `Period (ms)`
- timeout case: unbundle Msg to tell to `Parent.vi`

Guideline:

- An actor should not have in its own timeout way to do something periodically such as tell itself a message every 100 ms.
- Instead it must create a periodic messaging actor which in its timeout tells the message to the actor that requires the periodic message. Separate the concerns and guarantee timing.

Additional notes:

- If it was an event actor, it would have to wait for the next event to occur via the timeout case in the event loop.
- Interruptions in the event loop can prevent correct periodic timing; this must be thought about.

## Integration Patterns

### Bridge Actors

> **RESPONSE**: I have added this portion here, please find a way to integrate the rest of this quote  into this section (as normal text).
>
> After the root actor has launched, sending messages to actors directly from non-actor code is considered a code smell. This bypasses the actor-to-actor messaging model and breaks encapsulation.
> 
> Instead, use a Bridge Actor that exposes a user event to the external environment. The event handler inside the Bridge Actor can then translate the external stimulus into the appropriate typed message and forward it to the correct relative actor through standard actor messaging.
> 
> This preserves:
> - Actor isolation
> - Supervision hierarchy integrity
> - Consistent message routing semantics

Bridge actors are used to connect jettl actors to **non-jettl** LabVIEW code (for example, QMHs, test harnesses, or legacy systems).

> **JUSTIFICATION**: Bridge actors are an integration strategy, not a reuse actor. This section was moved out of “Reuse Actors” so it’s easier to find when a team is mixing jettl and non-jettl code.

Used to connect to non-jettl code via user events.

Bridge actors connect jettl and non-jettl LabVIEW applications.

Intra-application LabVIEW with non-jettl code:

- Before spawn, pass in the references you want the actor to use to send and receive data, to establish bidirectional communication between the jettl and non-jettl LabVIEW code.

You can spawn an actor and tell it messages from any LabVIEW code, not only from other actors. The primary challenge is receiving messages from that actor to the non-jettl code. This is the role of a **bridge (adapter or shim)**.

#### 1. Create a pure actor

Start by creating a proper actor that performs the required work. This actor must strictly follow jettl rules:

- All communication occurs through messaging.
- No shared data access.
- No reply messages to non-actors.

By keeping this actor “pure,” it remains reusable in fully jettl–based applications as well as in mixed environments.

#### 2. Create a bridge (adapter) actor

Next, introduce a bridge actor that sits between the calling (non-actor) code and the pure actor.

- Toward the pure actor, the bridge behaves like a normal jettl actor and follows all jettl rules by using the `Tell Self` type of message.
- Toward the caller, the bridge is allowed to break jettl rules, since the caller is not an actor.

This separation preserves correctness and reusability while enabling integration with non-jettl code.

#### 3. Define pass-through command messages

The messages the bridge actor can accept are found by reading the `Unified Msgs` for `Self` and its parents’ `Unified Msgs`.

- These messages are simple pass-through forwarding messages.
- The bridge forwards them directly to the pure actor `Parent`.

#### 4. Establish return paths using reference objects

Because the caller may not be message-driven in the jettl sense, returned data must flow through reference objects:

- Use **DVRs** for tagged or state-style data.
- Use **queues** for telling data or asynchronous notifications.

These references can be:

- Created by the calling code and passed to the bridge at startup (simplest approach), or
- Created by the bridge and returned to the caller (useful when the caller VI may go out of memory before the actor shuts down, which is common in TestStand-based systems).

#### 5. Handle data from the pure actor

When the Parent pure actor produces data for the bridge:

- The bridge receives the message.
- The bridge sends the data to the appropriate reference object (DVR or queue) that connects to the non-jettl code.

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

- Test with the user event code.
- Possibly: provide a user event helper that creates user events for `Stop Msg` and `Stopped Msg` (useful for IPC-style integrations).

> **TODO:** Capture the canonical bridge pattern as a diagram and a minimal working example.

## Design Patterns

### Decorator Pattern

**Class Inheritance to SPaIC**

SPaIC: Subtype Polymorphism and Interface Composition

![dec_1](../Images/dec_1.jpeg)  
![dec_2](../Images/dec_2.jpeg)  
![dec_3](../Images/dec_3.jpeg)

jettl dynamic decorator pattern:

- You can swap around the way these are wrapped.
- Example conceptual stack:
  - Your Actor
  - Panel Actor
  - Base Actor

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

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

- **Which 3 examples are “required reading” for new users?**: All examples.
- **Which reuse actors are already implemented vs only planned?**: All are currently planned.
- **For each reuse actor, what is the stable API surface?**: The messages it implements.
- **Which patterns should be enforced vs only recommended?**: All patterns are recommended.
- **Which of the “Broker/Mediator” ideas do you want to commit to in the near term?**: I do not wish to commit to these ideas, rather they are ideas that are likely to exist for others to implement. This broker/mediator will not be implemented in jettl unless there is strong reason to do so since this breaks the encapsulation for tree hierarchy of messaging.
