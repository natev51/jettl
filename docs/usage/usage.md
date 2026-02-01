## Examples


Continuous measurement and logging

---

Hello World
Don't need to send yourself Stop for Hello World. Just have Stop itself at the end of the Hello World Msg.

---

EXAMPLES SHOULD be in Example finder for VIPM
Keywords like jettl, actor, etc should have this be first when searched

Make sure examples come up on VIPM for the install page
bowser for example on examples

---

DNatt creating a timer introductory example. That would have the dual benefit of demonstrating jettl and giving a comparison to DQMH. Referring the audience to the DNatt Presentation.
## Reuse Actors

This section goes over reuse actors that have either been implemented or can be implemented, external to the core library.

### Panel Actors

Separate repo that has this reuse actor.
Common functionality to update the front panel state
includes the window operation and subpanels with unique passing of actor ref reference to the parent (from when it spawns as a child!), no need to pass around the subpanel reference.
Wire in as a persistent layer.

Usefulness of having `Actor Ref` as an input before `Setup.vi` and `Start.vi` allows for the Parent to have access to the `Actor Ref`, that means that the Parent has access to put that method in its subpanel instead of sending the child across the parents subpanel.

Inspiration:
[MGI Panel Manager - Unmonitored](https://gitlab.com/justACS/mgi-panel-manager-unmonitored)

Sub Panels
After the child has spawned, the parent has access to Child Attributes, which has ‘VI Ref’, so can easily put this VI Ref into a Sub Panel here. And further, since you directly have access to the VI Ref of the Child Attributes, can modularize where front panels are in Actor front panel of Self i.e. changing around panels.
Advanced Application: Interchangeable front panels where you have two created actors, and ability to toggle front panel displays as either being in the subpanel.

Open in Start
Close in Teardown

Of course Queue Actors and Notifier Actors can have front panels. Though, there shouldn't be control and indicator terminals since this would be functionality specific for an event actor. Instead, the Queue Actor would primarily have subpanel control references.

### Broker

Resources:
https://bitbucket.org/composedsystems/mva-framework/src/master/
https://bitbucket.org/composedsystems/stream/src/master/

---

Communicating between targets

![](../images/broker-startup-scratch.jpeg)

---

Also, for an inter actor system, can wrap around Core Actor (using spawn root) the functionality of holding DVRs as some mediator process to allocate sending messages across the tree via user events. This is a single application only method for publisher-subscriber, by using the decorated actor methodology.

---

Just like spawning, the observer pattern used will have a blocking call when subscribing / registering for a topic by creating its own child actor, with the necessary private data internal to talk with the broker and it’s child actors.
This could be a `Core Actor`.
Can put a non-reentrant method call in `Setup.vi` for a given actor which can put setup information to a by-reference `thing` in the application.

---

Sending events across the tree via the No Relation type

---

Mediator / Assembler Wrapper

A mediator-based design is inherently dataflow-friendly and avoids memory leaks because actor creation is serialized and coordinated through the mediator. Each actor instance is created at most once at a time under mediator control.

Actor spawning can be enforced by placing a non-reentrant VI inside the `Spawn` override, ensuring that concurrent instantiation cannot occur.

Actors may only shut down when explicitly instructed by the mediator. The mediator maintains authoritative knowledge of all actor references and determines which actors are permitted to send messages to which recipients. This centralized reference management naturally supports observer-style interactions, including publisher–subscriber relationships.

Deadlocks cannot occur because the mediator processes interactions sequentially. While this introduces a potential bottleneck, that tradeoff is intrinsic to mediator or broker-based architectures and is often acceptable for the guarantees it provides.

The mediator functions as the system’s routing authority: it forwards messages only to actors holding valid references for the intended interaction. Individual actors are isolated from one another and are aware only of the mediator—not of other actors in the system.

Conceptually, this resembles the existing framework, with the key distinction that messages are routed through the mediator. Because the mediator holds references to all actors, it can forward messages to the appropriate recipients based on those references. The actor itself still maintains references to its own `Self`, `Parent`, and `Children`; however, the mediator also tracks these relationships and governs how references may be used. The actor does not know other actors exist—it only interacts with the mediator.

This architecture supports the observer pattern cleanly. Actor references exist in exactly two places: the mediator and the actor itself. The mediator always retains the authoritative set of references and provides actors with only the references necessary for their permitted interactions.

Additionally, the mediator knows which messages an actor can handle through a unified messaging model. Because messages are defined via interfaces, the mediator can determine—at edit time—which messages an actor supports by inspecting the interfaces it implements. Message validation and routing decisions occur in the mediator, not in the actor.

At a higher level, this mediator can be viewed as a concrete component that encapsulates application-level business logic, coordinating a set of more specialized and reusable subcomponents. In practice, this mediator often corresponds to a top-level actor.

---

Multiple Application Instances

For multi-application scenarios, one approach is to introduce an application-level mediator that coordinates communication between individual application mediators. This suggests a layered mediator structure:
- Each application instance contains its own internal mediator.
- A higher-level mediator facilitates communication between application mediators.
- When multiple application instances are running, their top-level mediators exchange references and coordinate cross-application messaging.

If two applications need to communicate, each retains its own mediator. One possible extension is an additional mediator layer above both, responsible for managing inter-application interactions.

---

Assembler Role

An assembler may be used strictly to construct actors and distribute references required for observer-style relationships. Actors request construction and reference wiring through the assembler, rather than directly creating or discovering other actors.

### Bridge Actors

Used to connect to non-jettl code via user events.
Bridge Actors between jettl and non jettl LabVIEW Applications.

Intra application LabVIEW, with non-jettl code:
before spawn, pass in the queue or event references you want it to use to send out any data. To establish bidirectional communication.

---
---
You can spawn an actor and tell it messages from any LabVIEW code, not only from other actors. The primary challenge is receiving messages from that actor. This is the role of a **bridge (adapter or shim)**.

#### 1. Create a pure actor

Start by creating a proper actor that performs the required work (for example, hardware interaction). This actor must strictly follow jettl rules:
* All communication occurs through actor messaging.
* No shared data access.
* No reply messages to non-actors.
By keeping this actor “pure,” it remains reusable in fully jettl–based applications as well as in mixed environments.
#### 2. Create a bridge (adapter) actor

Next, introduce a bridge actor that sits between the calling (non-actor) code and the pure actor.
* Toward the pure actor, the bridge behaves like a normal jettl actor and follows all jettl rules.
* Toward the caller, the bridge is allowed to break jettl rules, since the caller is not an actor.
This separation preserves correctness and reusability while enabling integration with legacy or non-jettl code.
#### 3. Define pass-through command messages

The bridge actor should expose a set of standard messages that mirror those accepted by the nested pure actor.
* These messages are simple pass-throughs.
* The bridge forwards them directly to the pure actor.
* This is straightforward to implement when using interfaces.
#### 4. Establish return paths using reference objects

Because the caller is not message-driven in the jettl sense, returned data must flow through reference objects:
* Use **DVRs** for tagged or state-style data.
* Use **queues** for telling data or asynchronous notifications.
These references can be:
* Created by the calling code and passed to the bridge at startup (simplest approach), or
* Created by the bridge and returned to the caller (useful when the caller VI may go out of memory before the actor shuts down, which is common in TestStand-based systems).
#### 5. Handle data from the pure actor

When the nested pure actor sends data to the bridge:
* The bridge receives the message.
* The bridge stores the data in the appropriate reference object (DVR or queue).
#### 6. Consume data in the calling code

The calling code retrieves data from the reference objects as needed.
For example:
* If the caller is a **QMH**, pass the QMH queue into the bridge.
* When the bridge receives data from the pure actor, it constructs a QMH message and enqueues it with the received data.
If the caller is **not** message-driven:
* Do not forward messages directly.
* Instead, wrap all bridge interaction in a class that provides:
  * Create/Destroy VIs to launch and shut down the bridge actor.
  * Command VIs that send messages to the bridge.
  * Data access VIs that read from DVRs or queues.
This pattern cleanly encapsulates the actor interaction while presenting a conventional API to non-jettl code.

---


**THEN test with the UE code.**
maybe some kind of user event that comes with jettl that creates user events for the Stop Msg and the Stopped Msg?
These user events can then come native with jettl in case of IPC communication.

### Periodic Messaging

This has to come from another entity that determines timing of when to tell a message. Ethan Stern has a presentation on this topic somewhere on all around periodic message 

A specialty actor is spawned for timing. The actor that spawned it holds the truth for the state of the periodic message in case of timing issues where the child sends another message after sending. This behavior can be handled in the `Inspect.vi` override.

Tells a message periodically doesn't imply that the messages are executed periodically.
Tell a message and have it tell with only one copy, this ensures there's only ever one copy in the queue.

---

Init.vi Inputs:  
- Msg Strategy
- Period

Process.vi
- unbundle Period
- timeout case: unbundle Msg to send to Creator.vi

---

An actor should not have in its own timeout way to do something periodically such as send itself a message every 100 ms.
Instead it must create a periodic messaging actor which in its timeout sends the message to the actor that requires the periodic message. Separate the concerns.



time delayed send message. Could be some actor that is created that periodically sends out a trigger message with some kind of unique data input that signifies to the parent that this is the action that needs to be taken for periodic message handling.
This way the concerns are separated and the handling of messages is strictly governed by the parent actor itself.

---

This could be an event actor, but notifiers work well with timing.
If it was an event actor, then the event actor would have to wait for the next event to occur via the timeout case in the event loop.
But there would be interruptions in the event loop, which would cause the event actor to not be able to send messages at the correct time.

### Monitor Msg Traffic

Since one cannot monitor a queue status, overriding the tell messages in a wrapper actor can each be put into a log and marked as not read (organized by timestamp). Then when the message is being acted upon i.e.  `Listened To Msg` = `True` for the message matching the timestamp can be marked as read. This will allow the system to properly allow for knowing how many Msgs haven’t been executed i.e. how many are in the queue since the message destination is known before the message is told.

Initialization requires:
- Self Attributes
- Parent Attributes
Note: Child information is redundant information since can construct everything with Self and Parent Attributes. Think relative relations.

After telling message, logs to file the **Time**
After listening to a message (in `Call Inspect.vi` with `Msg Listened To.vi`), logs to file the **Listened Time**
## Design Patterns

### Decorator Pattern

**Class Inheritance to SPaIC**

SPaIC: Subtype Polymorphism and Interface Composition

![](../images/dec_1.jpeg)
![](../images/dec_2.jpeg)
![](../images/dec_3.jpeg)

---

jettl Dynamic Decorator Pattern
Note you can swap around the Way these are wrapped!
Your Actor
Panel Actor
Actor

---

### State Pattern

**Resources**:
[State Pattern – Design Patterns (ep 17)](https://www.youtube.com/watch?v=N12L5D78MAA)
[State of Grace - The State Pattern in LabVIEW](https://www.youtube.com/watch?v=HewNBC4TjKs)
[Powerful Design with the Gang of Four - Tom McQuillan and Sam Taggart](https://www.youtube.com/watch?v=IM8ZU1af6wQ&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=22)
[A Class Act: Simple Design Patterns to Improve Code Quality, Allen C Smith - GDevCon N.A. 2023](https://www.youtube.com/watch?v=GRDoyn1mNAI&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=18)
[A Class Act - Allen C Smith(JustACS) - GDevCon#4](https://www.youtube.com/watch?v=yVzT5ZqUuVU&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19)

State must not be modified in `Entry.vi`. Disallowing state transitions in both `Entry.vi` and `Exit.vi` is intentional. A state must be fully entered or fully exited before a transition is permitted. This constraint prevents infinite state transitions and enforces a well defined state lifecycle.

---

Context classes should be private, since only interface objects should be composed into a class.  
Dependency Inversion Principle.  
Since the context class is private to the library it is in (and the State Interface with its concrete state classes), public static dispatch methods can be used in the context class AND concrete state classes without worrying that they'll be used outside the library since the context class is private.  

### Factory Pattern

The Factory Pattern is used to create instances of actors without specifying the exact class of the actor that will be created.  
This allows for greater modularity in the actor design.  
Easy Factory pattern integration with actor interface for plug and play architectures such as PPLs.
