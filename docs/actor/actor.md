
![](docs/images/actor-transport-queue.png)
*Queue Actor.*

![](docs/images/actor-transport-event.png)
*Event Actor.*

![](docs/images/actor-transport-notifier.png)
*Notifier Actor.*

---

`Finalize`: A lifecycle hook invoked at the end of each actor execution turn.

---

`No Relation`: Defined more formally as not having the same root.

---

the edge actors and core actors are persistent for every actor in the application. That means that if the root actor spawned has the `Debug jettl Actor` as one of the actors in the `Core Actors` input, this instance of the `Debug jettl Actor` will be used for each of the child actors that are spawned. The actor that is always persistent is the `Base jettl Actor`.

---

The entire jettl API has public read-only methods everywhere to gain access to the internals via a combination of method calls. These combinations of method calls can be used in wrapped actors to get necessary information of the `Unified Actor`.

---

Private Actors:
Multiple actors in one library, but there is a main actor with other libraries that contain actors, but they must be private. Rule VI analyzer can check.

---

Since jettl uses the decorator pattern, all DD methods are overridden with functionality. No override methods are available, simply move the method to the extended virtual folder (for developer experience) and append functionality as necessary.
jettl does not require ever modifying class inheritance since class inheritance is not recommended. Recommended practice is using interface implementation for all classes mixed with dependency inversion.

---

**Child UIDs**

The goal is a fully static, deterministic system that still supports dynamic behavior. In practice, that means the `Child UIDs.ctl` is static.

Under the hood, UIDs are stored as strings in `Child Attributes Map.ctl`, but the `Child UIDs.ctl` enum is the developer-facing abstraction. The enum represents the different UIDs used for child actors. Because each actor defines its own private enum, the runtime mechanism is a string mapping that can be validated to ensure it only maps enum elements to their corresponding string values.

This provides two benefits:
* Actor code uses enums exclusively, avoiding the fragility of stringly-typed identifiers.
* The internal string representation remains compatible with mapping needs.

The enum currently is edited manually. There could be a tool in the future that scripts this action.

---

`Tell Self Inspect.vi`, `Tell Parent Inspect.vi`, `Tell Child Inspect.vi` override example:
Actor messages told to actors that don't have the msg in their `Unified Msgs` determines where messages are allowed to go for a given actor (e.g., **Self**, **Parent**, **Child**) based on static selection a polymorphic message destination at edit time. Uses that knowledge to prevent invalid message paths if the relationship required by a message is not satisfied, an error will be generated at runtime preventing runtime messaging errors. Further, a static analyzer test can eliminate these runtime errors where a message is sent to an actor that cannot handle it.

This adds a defensive fallback by decorating the code in a case structure that safely handles “received but not implemented” messages by allowing an unexpected message through.

---

**Refs**

> Use of value property is generally discouraged in VIs unless you’re having to do it with a control reference inside of a SubVI -DNatt [Improving Your LabVIEW Code with the VI Analyzer](https://forums.ni.com/t5/VI-Analyzer-Enthusiasts/Improving-Your-LabVIEW-Code-with-the-VI-Analyzer/m-p/3415352)@12:26

> Tip: You may place in clusters (make sure they’re type defs) in the Refs cluster to differentiate controls, indicators, sub panels, etc.

Tend to minimize the use of references put into the Refs cluster. Instead maximize their use in the event structure for better readability.
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:45:46
Only use when these refs are used in message methods OR methods constrained in message methods. Otherwise, if there is a method call in the event structure, do you best to wire in the VI Server control reference to the method as an input instead of passing the entire object wire into the method.

---

Actor Layers
Actor layers where actors decorate each other:
- Implementing a Msg means functionality will likely be extended
- otherwise not implementing a Msg means the Msg is a no-op when it is called since it's not implemented.

This is how the `Msg or Recurse.vi` works: checks `Msgs` and determines if that actor layer has implemented that messages method or recurse to the next actor layer, reiterating until the innermost layer is called.

---

Idea for Two actor types for development

To reinforce separation of concerns, support two kinds of actors:

- Pure business logic.
- No front panel requirement.
and
- UI and event handling wrappers.
- Responsible for user interaction, message routing, and presentation concerns.  

A reusable Actor can wrap actors that do not have a front panel, providing a consistent UI/event-handling shell without coupling to the the actor layer with UI requirements.

---

Designing an actor
Start from the abstract. In architecture work, the high-level structure matters more than low-level implementation details. The objective is to define modular components and the relationships between them so they compose into a cohesive system.

A common decomposition includes **acquisition**, **analysis**, **presentation/display**, and **logging**. These concerns are often coordinated as a sequence, but they should remain **decoupled**: each has a distinct responsibility and should be able to function independently of the others. This lets you define system behavior (contracts) before committing to specific implementations.

Design **from interfaces to classes**. Begin by specifying interfaces that capture the required behavior, then implement those interfaces with concrete classes.

Prefer strong, static structure and clear boundaries. Keep components modular and independent wherever possible. Dependencies are inevitable, but they should point to **abstractions** (interfaces), which tend to change less frequently than concrete implementations.

Method access scope: The default should be that all methods are marked private (except DD methods).

Standardize rescripted methods/functions on the 4x2x2x4 connector pane pattern, consistent with connector pane guidelines.

Keep signatures small: excluding the object reference and error terminals, methods/functions should have 0–2 inputs and 0-2 outputs. If additional inputs are required, bundle them into a typedef cluster rather than expanding the connector pane.

Class private data Icons
Remove the default cube/box element from class icons.
Rely on banner and wire color conventions for identification; the cube provides minimal semantic value and is not needed to distinguish classes from interfaces.

---

Spawning an actor:
[Errors are Values; Please Treat Them That Way (Ethan Stern)](https://www.youtube.com/watch?v=8vhYLlaXaQU&list=PLvDxiIkwuMQtiOZ_WWbk6ZCXfeAKxtwo-)@17:28
Constructors (Init Actor.vi and Init Msg.vi) do not throw errors. Fundamentally, when an object is instantiated, there should not be an error that occurs.

Constructors should not throw errors. In particular any work that might fail (I/O, resource acquisition, configuration validation, etc.) should be moved into a separate method such as `Setup.vi`, where failures can be handled explicitly as part of the actor’s startup.