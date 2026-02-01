Caraya
LUnit

Approval Tests
Come with the ability to create separate projects to perform unit tests.

One thing I feel that AF (or other frameworks) could borrow from DQMH is the amount of scripting built in. I especially think that an automatically generated test panel is feasible. As simple as a scripted event structure that provides buttons for all messages the Actor expects, and then have it listen and display payloads (serialized) from  all methods defined in any interfaces the Actor has available.

---

Unit testing
With the Actor interface, this model is interface-composition based with the decorator Pattern, so unit testing is built in by decorating one of the core actors with a unit test actor.

One can see immediately that an infinite number of actors can be decorated, leading to a powerful feature of the interface-composition based decorator pattern.

---

Unit Testing
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!
Some kind of Actor can be a wrapper that takes this information and logs it to file.

---

DD output terminal on the `Actor.vi` prevents the object wire from changing at runtime.

---

**Test Panel**
Automatically generated test panel providing controls / necessary inputs for all messages the actor expects.
Have the test panel display payloads from messages received.
This is to design modular Actors without dependencies of other Actors.
Which messages the Actor is able to tell and to which relative actor.

`Actor.vi`
Yes. The actor does not need to have an output, but for testing purposes it is nice to have it be an output to look at the object after actor was done executing if ran by itself.
Also, to ensure the object is the same throughout its lifetimes the DD output terminal ensures this to be true.
Output terminals are available primarily for testing purposes, when one wants to unit test this actor and directly get its state / error.