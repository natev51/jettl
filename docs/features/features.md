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