# Non-Normative

This page collects ideas, inspirations, and references that are explicitly **not** part of the normative jettl contract.

Use this material as a scratchpad and roadmap input. If a section becomes a real commitment, move it into a normative document (Core Model / Runtime / Tooling) and replace it here with a link.

## Ideas That Could Be Implemented

### Channel Wire Msg Transport

Implement a Channel Wire message transport.

> **TODO:** Define:
>
> - **What problem the Channel Wire transport solves**:
> - **How it differs from Queue/Event/Notifier**:
> - **What contracts would be transport-invariant vs transport-specific**:
> - **Minimum acceptance tests**:

### Spawn Parent

Spawn Parent idea: `Spawn Parent.vi` (Root input), so an actor can spawn its parent.

Would be used to spawn an actor and that actor can spawn its parent.

That way, instead of launching the application “top down,” an intermediate connection can run first, then the Root actor and all other actors from there.

> **TODO:** Clarify:
>
> - **Why spawning a parent is needed (use cases)**:
> - **How this interacts with “Root” semantics**:
> - **What the ownership/lifetime rules are**:
> - **What prevents cycles**:

### Async Spawn Child Message Wrapper

Add an `Async Spawn Child jettl Msg` in the jettl library which is a wrapper for `Async Spawn Child.vi`.

> **TODO:** Specify:
>
> - **What UX improvement the wrapper provides**:
> - **What it standardizes (defaults, logging, error handling)**:
> - **How it is tested**:

### Error Serialization (Second Wire)

Error serialization idea:

- Add another wire on the bottom of the method call, either through the connector pane, or wrap the function with another function with the same connector pane, but allow two more slots at the bottom.
- Map connector panes.
- Some kind of dynamic function call.

DNatt type of splitters for LabVIEW code where this enforces dataflow, better than wire serialization.

> **TODO:** Tighten this into a concrete proposal.
>
> - **Problem statement**:
> - **Proposed API**:
> - **Compatibility constraints**:
> - **Migration strategy**:
> - **Prototype location**:

## Inspiration

Actor Framework tools and ecosystem ideas (as a checklist):

- Network Endpoint Actors
- Actor Hierarchy Inspector
- Panel Actor
- Test panels / Actor Tester
- Unit tests with Caraya
- Events for UI actor indicators
- Documentation tooling (AntiDoc plugin)
- DETT plugins for UML and sequence diagramming
- Open AF Payload
- Bowzer the Browser
- State pattern actor
- Examples and CTI
- Message monitor (logger/monitor showing run-time message tells)
- Actor system designer (system-level diagram of actor spawning hierarchy)
- Actor framework message forwarding

> **TODO:** For each item above, decide:
>
> - **Already exists in jettl**:
> - **Planned**:
> - **Out of scope**:
> - **Owner**:

## Presentations

### “So, you're on the jettl team”

> **TODO:** Outline:
>
> - **Audience**:
> - **Goal**:
> - **Key sections**:
> - **Demo(s)**:

### “Intro to jettl”

Most recent VIPM package note:

- Download on VIPM and search `jettl`.

Related channels (where updates typically appear):

- GitHub
- VIPM
- YouTube

> **TODO:** Add:
>
> - **A VIPM screenshot (most recent)**:
> - **Install instructions (1–3 bullets)**:
> - **The first demo**:
> - **Common pitfalls**:

Resources of inspiration:

- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)

> **TODO:** At the end of the presentation, include further topics and link to existing videos for each.
>
> - **Topic 1**:
> - **Topic 2**:
> - **Topic 3**:

## References

This rationale is captured (canonically) in [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership). It is repeated here as a convenient reminder:

It’s the reason `jettl Actors` always create their own event references and release their own references: lifetime is guaranteed.

Creating references in a parent before a child spawns is a bad practice since when the parent stops, the reference created in the parent (but still used by the child) will be released, leading to the child actor performing operations on a released reference and throwing errors.

## Immediate Changes

*The following includes a list of changes to the framework that can be done immediately.*  
*The order of items presented is in no particular order.*

- Add additional function calls for the actor index (for example: outer actor vs edge vs core actor).
- For developer code, add comments that explain whether code can be modified or is framework-owned (“DO NOT MODIFY”).
  - Example: `Init Actor` — DO NOT MODIFY!
- Add another object to Attributes called **Attributes Metadata**.
- Msg object passthrough
	- better performance (test by creating subVI around instantiation and bundling to see which takes more time to do, if it is the instantiation, then we change to pass the object around (same for output.. sad) have to have output object as well.)
	- that dumb trick for arrays from the init reads to happen for the Msg Object as well! So the reordering of the front panel connections. Could just be explicit and have a map for input and output.
	- instantiates the object once and passes as input datatype.
	- this means to manipulate the object back in and write the data back in (override currently what is in the object private data).
- replace TEMPLATE.vi in all methods with the private one. This may help with the circular dependency issue for inlining the preallocated.

- Cool change that can be made, implement a msgs input that executes these messages in their order before the main message handling loop, this is helpful for configuration data that is coupled through a message that otherwise wouldn't be need to be bundled into actor input. This would require another input for the actor input, so would need another function that has inputs for the `Actor Instantiation.vi` of `Edge Actors`, `Mid Actors`, and `Core Actors`. WHoas! Have this initial thing be a Queue driver msg handling, have there be an enum flag depending on which msg handler is handling. Oh...
- that means change the spawn function calls to have the necessary inputs. One Root interface method for edge, mid, and core. just the edge inputs for the Child. Maybe these three functions should be apart of the same poly. Function for `Setup Messages.vi` tied to interface that creates the message calls for each. wire in the init msg to the actor init.

- for the tools menu, could include sections for
	- Scripting
	- Debug
  what is the way to make "artificial" menu items without making more libraries?

> **TODO:** For each “immediate change,” define:
>
> - **Motivation**:
> - **Owner**:
> - **Acceptance test**:
> - **Target release**:

## Resources

> **TODO:** Fill in curated links and repos.
>
> - **Official repo(s)**:
> - **VIPM package**:
> - **Example repos**:
> - **Recommended talks (top 5)**:

## Feedback Questions

- **Which “Ideas” are highest leverage in the next 1–2 months?**:
- **Which “Ideas” are intentionally long-term?**:
- **What should never become part of the normative contract?**:
- **Which ecosystem/tooling features are most important for adoption?**:
