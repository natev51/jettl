# Non-Normative

This page collects ideas, inspirations, and references that are explicitly **not** part of the normative jettl contract.

Use this material as a scratchpad and roadmap input. If a section becomes a real commitment, move it into a normative document (Core Model / Runtime / Tooling) and replace it here with a link.

## Ideas That Could Be Implemented


### Spawn Async Child jettl Msg

Add this to jettl library which effectively wraps `Async Spawn Child.vi`.

> **TODO:** Specify:
>
> - **What UX improvement the wrapper provides**: Instead of direct calling, can be told as a message, listened to as a msg, delay told as a message, etc.
> - **What it standardizes (defaults, logging, error handling)**: Not entirely sure what this standardizes.
> - **How it is tested**: No test is necessary, what do you think?

### Faster Lookup for Default Instantiations

This is a performance idea. Look ups for comparing default instantiations. Instead, use strings as they’re unique to the actor system. That way, you don’t have to instantiate objects, causing more overhead, and instead just pass out the string identifier. That means that the underlying “Msgs” and “Unified Msgs” are instead strings for faster lookup. That means adding a polymorphic with string output for the message name, used for quick lookup.

### Init Msg Performance Boost

The following has not been confirmed. Msg object passthrough may have better performance (test by creating subVI around instantiation and bundling to see which takes more time to do (VI Profiler), if it is the instantiation, then we change to pass the object around (same for output..) have to have output object as well.). instantiates the object once and passes as input datatype. This means to manipulate the object back in and write the data back in (override currently what is in the object private data). that dumb trick for arrays from the init reads to happen for the Msg Object as well! So the reordering of the front panel connections. Could just be explicit and have a map for input and output. Have the object manipulation be at the top of the message method for the interface.

### Inline the preallocated execution methods

Currently, all preallocated execution methods are not inlined. This should likely change for the future, but for now is used to benchmark where the most overhead is located using the `VI Profiler`. Most benchmarking tests must be conducted to optimize the framework for maximum throughput.
## Known Architectural Open Questions

These questions are intentionally tracked here until they are resolved and moved into a canonical owner page (Core Model / Runtime / API Reference).

> **JUSTIFICATION**: These questions previously existed as “out of band” notes. Recording them here makes the current uncertainty visible to readers and creates a clear backlog for tightening the contract.

1. Is priority part of the public contract?
2. Are Core Actors vs Edge Actors formally distinct or just conceptual?
3. Is “No Relation” messaging supported or only conceptual?
4. Is forwarding part of the framework or just a pattern?
5. What stability policy applies to APIs?
6. What minimum acceptance tests define Core Model compliance?
7. Is the Stop contract fully specified for all failure modes?
8. Should Channel Wire transport exist?
9. Is plugin architecture first-class or user-land?
10. Is Spawn Parent real or exploratory?
## Broker / Mediator

Resources:

- https://bitbucket.org/composedsystems/mva-framework/src/master/
- https://bitbucket.org/composedsystems/stream/src/master/

Communicating between targets, this is preliminary scratch work:

![broker-startup-scratch](../Images/broker-startup-scratch.jpeg)  
*This is preliminary scratch work for a broker pattern, breaking hierarchical communication.*

Also, for an inter-actor system (in separate instances/applications/targets), you can wrap around a Core Actor (for spawn root) the functionality of holding DVRs as some mediator process to allocate telling messages across the tree via user events.

This is a single-application-only method for publisher-subscriber, by using the decorated actor methodology.

##### Observer-style subscription

Just like spawning, the observer pattern used will have a blocking call when subscribing/registering for a topic by creating its own child actor, with the necessary private data internal to talk with the broker and its child actors.

This could be a `Core Actor`.

You can put a non-reentrant method call in `Setup.vi` for a given actor which can put setup information to a by-reference “thing” in the application.

Telling events across the tree via the `No Relation` type, maybe this should be a strategy pattern with classes to allow more options developers can create more concrete instantiations.

##### Mediator / Assembler

Note these ideas are slightly antipatterns, but are here nonetheless as ideas.

A mediator-based design is inherently dataflow-friendly and avoids memory leaks because actor spawning is serialized and coordinated through the mediator. Each actor instance is spawned at most once at a time under mediator control.

Actor spawning can be enforced by placing a non-reentrant VI inside the `Spawn` override, ensuring that concurrent instantiation cannot occur.

Actors may only shut down when explicitly instructed by the mediator. The mediator maintains authoritative knowledge of all actor references and determines which actors are permitted to tell messages to which recipients. This centralized reference management naturally supports observer-style interactions, including publisher–subscriber relationships.

Deadlocks cannot occur because the mediator processes interactions sequentially. While this introduces a potential bottleneck, that tradeoff is intrinsic to mediator or broker-based architectures and is often acceptable for the guarantees it provides.

The mediator functions as the system’s routing authority: it forwards messages only to actors holding valid references for the intended interaction. Individual actors are isolated from one another and are aware only of the mediator—not of other actors in the system.

Conceptually, this resembles the existing framework, with the key distinction that messages are routed through the mediator. Because the mediator holds references to all actors, it can forward messages to the appropriate recipients based on those references.

The actor itself still maintains references to its own `Self`, `Parent`, and `Children`; however, the mediator also tracks these relationships and governs how references may be used. The actor does not know other actors exist—it only interacts with the mediator.

This architecture supports the observer pattern cleanly. Actor references exist in exactly two places: the mediator and the actor itself. The mediator always retains the authoritative set of references and provides actors with only the references necessary for their permitted interactions.

Additionally, the mediator knows which messages an actor can handle through a unified messaging model. Because messages are defined via interfaces, the mediator can determine—at edit time—which messages an actor supports by inspecting the interfaces it implements. Message validation and routing decisions occur in the mediator, not in the actor.

At a higher level, this mediator can be viewed as a concrete component that encapsulates application-level business logic, coordinating a set of more specialized and reusable subcomponents. In practice, this mediator often corresponds to a top-level actor.

###### Multiple Application Instances

For multi-application scenarios, one approach is to introduce an application-level mediator that coordinates communication between individual application mediators. This suggests a layered mediator structure:

- Each application instance contains its own internal mediator.
- A higher-level mediator facilitates communication between application mediators.
- When multiple application instances are running, their top-level mediators exchange references and coordinate cross-application messaging.

If two applications need to communicate, each retains its own mediator. One possible extension is an additional mediator layer above both, responsible for managing inter-application interactions.

###### Assembler Role

An assembler may be used strictly to construct actors and distribute references required for observer-style relationships. Actors request construction and reference wiring through the assembler, rather than directly creating or discovering other actors.

> **JUSTIFICATION**: This section was moved from *Usage* because it is explicitly exploratory and not something the project is committing to as a recommended jettl pattern in the near term. Keeping it here preserves the ideas without teaching it as “the way.”

## Presentations

### “So, you're on the jettl team”

> **TODO:** Outline:
>
> - **Audience**: Those who will be working with jettl as their framework.
> - **Goal**: Overview best practices, key concepts, packages on VIPM, packages being developed, etc.
> - **Key sections**: Not sure yet, suggestions?
> - **Demo(s)**: Not sure yet, suggestions?

### “Intro to jettl”

Download on VIPM

Related channels (where updates and content typically appear):

- GitHub
- VIPM
- YouTube

> **TODO:** Add:
>
> - **A VIPM screenshot (most recent)**: Will do later.
> - **Install instructions (1–3 bullets)**: Suggestions?
> - **The first demo**: Suggestions?
> - **Common pitfalls**: Suggestions?

Resources of inspiration:

- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)
- [GDevCon ANZ #2 - Workers for LabVIEW: Building Modular, Scalable and Asynchronous Apps- Peter Scarfe](https://www.youtube.com/watch?v=wJg3K2tdSuQ)

> **TODO:** At the end of the presentation, include further topics and link to existing videos for each.
>
> - **Topic 1**: Not created yet.
> - **Topic 2**: Not created yet.
> - **Topic 3**: Not created yet.

## Immediate Changes

*The following includes a list of changes to the framework that can be done immediately.*  
*The order of items presented is in no particular order.*

- change jettl Tools project name to Tools. change the jettl Tools menu to jettl. Add sub menus.

- tools -> jettl, include menus for
  - Edittime
  - Runtime

- Root Loop issue outlined in:
  - [GDevCon ANZ #2 - Workers for LabVIEW: Building Modular, Scalable and Asynchronous Apps- Peter Scarfe](https://www.youtube.com/watch?v=wJg3K2tdSuQ)

- Add additional functions for Actor Index i.e. = Edge, = Mid, = Core, etc. This will be by user request for common functionality.

- **Implement the Msg Stuffs**

- Attributes Poly VIs (put into libraries with same method name, all preallo)
	- `Read Parent Attributes`
	- `Read Self Attributes`
	- `Read Child Attributes` (UID input)
	Have these Read methods be in here i.e. `VI Ref`, `Unified Msgs`, etc.

- Stop message is not a reversible action, where the
	- `Parent` is told the `Stopping jettl Msg`
	- All `Children` are told the `Stopping jettl Msg`
	- `Self` is put in the Lifetime of "Stopping", or if it has children, "Stopping Waiting On Children"

- Change the palette to reflect the current changes.

- checks for the Root Actors and Msg Self inputs are valid.

- Stop is just a stop, common in the framework for procedurally leading to stopping the actor and all children actors by what is called **Orderly Stopping**. Because of **Orderly Stopping**, this means that the root actor will exist longer than any children it spawns. This gives rise to the `Terminate Msg`. This is a specialty message which by-passes jettl logic to terminate the program, mostly likely in case of an emergency. This `Terminate Msg`, which is told to one actor is immediately told to all actors with Priority in the tree hierarchy by telling the root, and propagating down the tree. It is therefore uncommon to use the Terminate Msg. But has been created for these emergency reasons. In this instance, the **Orderly Stopping** is still obeyed, but different instructions are carried out depending on developer code.
	Aside: Code smell, if there are three actors in a system and they're grandparent, parent, child: if the parent stops and is waiting for child to stop (due to orderly stopping!) and the teardown for parent should execute fast (such as turning pumps to their zero set point speed **(critical)**), then this is probably a code smell since this logic of controlling the set point speed should itself be contained within it's own actor as a child. Basically, have a `Children Allowed` boolean flag on spawn methods. That way, these actors are identified as the lowest level control actors, controlling their own processes, not a high level entity that is a parent to other actors. This means these actors take direct responsibility for tearing down when stopping, without needing to wait on their children, because by definition they do not have any children. On the contrary, instead a private data boolean flag can be used in each individual layer and the unified actor takes the union of these booleans and determines if the actor as a whole can have children.

- gRPC Actor idea: Since jettl uses the ISP, the messages are unique and because type defs are defined in the message, by best practice. This allows for easy finding for creating .proto files for gRPC. These are all messages in the same way so a proto file is effectively just a list of jettl Msg libraries

## Resources

> **RESPONSE**: Please take the following TODO and integrate them into the documentation.

> **TODO:** Fill in curated links and repos.
>
> - **Official repo(s)**: https://github.com/natev51/jettl
> - **VIPM package**: https://www.vipm.io/package/nathan_davis_lib_jettl/
> - **Example repos**: https://github.com/natev51/jettl
> - **Recommended talks (top 5)**: None published so far.
> - **Recommended Packages**: I need to do this, currently none exist, but this will be very useful.

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

- **Which “Ideas” are highest leverage in the next 1–2 months?**: Good question, I can prioritize them?
- **Which “Ideas” are intentionally long-term?**: I don’t know, can you help me prioritize them?
- **What should never become part of the normative contract?**: Suggestions?
- **Which ecosystem/tooling features are most important for adoption?**: All specified, though I moved these to a different section.
