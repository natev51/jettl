Caraya
LUnit

One thing I feel that AF (or other frameworks) could borrow from DQMH is the amount of scripting built in. I especially think that an automatically generated test panel is feasible. As simple as a scripted event structure that provides buttons for all messages the Actor expects, and then have it listen and display payloads (serialized) from  all methods defined in any interfaces the Actor has available.

---

Unit testing
With the Actor interface, this model is interface-composition based with the decorator Pattern, so unit testing is built in by decorating one of the core actors with a unit test actor.

One can see immediately that an infinite number of actors can be decorated, leading to a powerful feature of the interface-composition based decorator pattern.