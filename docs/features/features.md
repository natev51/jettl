- **Relative Actor Relations**.
Every Actor in the system has itself, called `Self`.
Along with one `Parent` and N many `Child` Actors.
- **Address Abstraction**.
The address of an Actor is abstracted away from the developer, unless more advanced testing required.
- **Messaging**.
Actor messaging follow a strict tree hierarchy of messaging.
Actors internally use events to send messages.
These messages are exclusively interface driven messages, fully abstracting the dependence between Actors.
- **Composition over inheritance**.
More specifically, interface composition.
Interface composition allows for dynamic wrapping of classes via their common `Actor` interface.
In particular, debugging, unit testing, etc.
Dynamic decoration of actors, opposed to static class inheritance.
- **Inline Object Manipulation in Event Structure**.
Every Actor comes with an event structure, which has the central object wire passed through it leading to a true by-value design.
- **Message Output**.
Messages have scripted outputs, such as message inputs, used for transporting data between decorated actors.
- **Message Transport Agnostic**.
There currently three actors that distinguish between Queue, Event, and Notifier messaging.
- **Statically Typed Messaging**.
All messages are interface coupled and statically determined execution provides for ease in understanding the relative actor system messaging.
- **Child Actor UID Mapping**.
Internally, Child Actor UIDs (Unique Identifiers) are automatically inserted into a map.

---

### Useful Things To Know

Attributes are static for an actor and are only instantiated when spawned.

---

jettl does not include any diagram disable structures.

---

Actors can be spawned in `Setup.vi`

---

jettl features
- No Dependencies (outside of native LV)
- No Circular Dependencies
- No Password Protection  
- No Malleable VIs
- No XNodes
- RT Compatible
- PPL Compatible

---

All Boolean logic is positive logic.

---

Actors that decorate other actors can interact with common method calls between layers, in particular with data defined by messages. Think about the input and output data for a message.

---

read and write methods do not have further functionality aside from reading and writing.

---

Best Practices jettl
1. Develop in a separate library and use this library in the actor code, that way the code used is decoupled from the Actor and can be tested independent of the actor.
2. Best practice: Tend to NOT use Priority when telling messages.
3. Naming Msgs: Somewhat detailed names ~3-4 words. This is due to mitigating naming issues when overriding the method names. For example, a message called `Begin Msg` is too simple where naming conflicts can occur for other overrides. A better name, depending on context, would be `Begin Pump Sequence Msg`.
4. Object wire must never be split unless a method that doesn't have the object at the output such as `Read XX.vi` and unbundles.
5. In `Setup.vi`, an actor can tell itself, it's parent, and any spawned children messages since resources have been setup before executing `Setup.vi`.
6. Only call functions and methods on the palettes.
7. Setup references in `Setup.vi`. These are async processes. If references are created in an actor (Actor A), but used in another actor (Actor B). If Actor A is destroyed (without closing the reference), but the reference is still being used in Actor B.. the reference will be destroyed leading to confusion of the developer since they hadn’t closed the reference in the Actor B. Takeaway: create and destroy references in the same actor. This is the exact reason the Self Attributes references are created in the actor being spawned. Because if the parent is stopped, the child actor will still have its references alive. In particular, when initializing the actor, take care to not create references in `Init.vi`, if you expect to destroy the references in the child actor, due to reasons above. Rather, move the creation of these references to `Setup.vi`.
