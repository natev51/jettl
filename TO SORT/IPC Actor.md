Inter-application communication.
Best practice to have one and only one root actor.
That means if we need to message across a boundary to another application, then we would need to have the actor that communicates across the boundary NOT be the Root actor (since it shouldn’t communicate across the boundary), which means it’s dedicated child should be the one to communicate across the boundary.

---

Parallel between Bridge Actor AND unit testing since these conditions aren’t pure jettl applications.

---




---

relating ideas:
IPC Actor, Test Actor, Bridge Actor

---

the parent that creates the child will pass to it its unified msg set. So that when the IPC Actor receives a msg, it will have access to the parents unified msg set and can properly be forwarded along as a normal message without needing to be executed in the IPC Actor.

---

so in the inspect override of the IPC Actor, the message will set the output boolean to false so the message doesn't execute AND the message (assuming in parent's unified msg set) will be sent to the parent. This makes the IPC Actor a reuse actor, independent of what messages it receives.

Now, this is the same for messages that come from the parent and go to the other IPC Actor.

---

The Bridge Actor is still an actor, it's just that it is used as 