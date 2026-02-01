## Ideas That Could Be Implemented

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

## Inspiration

Actor Framework Tools:
- Network Endpoint Actors
- Actor Hierarchy Inspector
- Panel Actor
- Test panels, Actor Tester
- Unit Test with Caraya
- Events for UI Actor Indicators
- Documentation, AntiDoc plugin
- DETT plugins for UML and sequence diagraming
- Open AF Payload
- Bowzer the Browser
- State Pattern Actor
- Examples and CTI
- Message Monitor This would be more like a logger/monitor showing run-time message tells.
- Actor System Designer - This tool would provide a system level diagram of Actor Spawning Hierarchy.
- Actor Framework Message Forwarding
## Presentations

"So, you're on the jettl team"

---

"Intro to jettl"

**picture of VIPM jettl package, most recent.**
*Download on VIPM, search `jettl`.*

**Resources of Inspiration**
- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)


Please check out the github, VIPM, and youtube for more information.

At the end with further topics, list them with already made videos links for all.
## References

It’s the reason `jettl Actors` always creates their own event references release their own references. Lifetime is guaranteed.
Creating references in parent before child spawns is a bad practice since when the parent stops, the reference created in the parent (but still used by the child) will be released leading to the child actor doing operations on a released reference, throwing errors.

---


## Immediate Changes

*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---
---

add in additional function calls for the actor index i.e. if it is the outer actor, if it is a edge, core, etc actor 

---

For the developer code, add comments that explain if can modify and touch or DO NOT MODIFY.
`Init Actor`: DO NOT modify!

---


Add another Object to the Attributes called Attributes Metadata
## Resources


