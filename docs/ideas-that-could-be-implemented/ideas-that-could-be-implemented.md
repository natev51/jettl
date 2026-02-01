Implement Channel Wire Msg Transport

---

Spawn Parent idea
`Spawn Parent.vi` (Root input) So an actor can spawn it's parent.
Would be used to spawn an actor and that actor can spawn its parent.
That way instead of launching the application, one would just have the intermediate connection run first, then the root actor and all other actors from there.

---

Add in a `Async Spawn Child jettl Msg` in the jettl library which is just a wrapper for the `Async Spawn Child.vi`.

---

Error serialization

Add another wire on the bottom of the method call, either through the connector pane, or wrap the function with another function with the same connector pane, but allow two more slots at the bottom
Map connector panes
Some kind of dynamic function call

DNatt type of splitters for labVIEW code where this enforces data flow, better than wire serializaion
