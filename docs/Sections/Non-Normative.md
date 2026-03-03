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

1. Are Core Actors vs Edge Actors formally distinct or just conceptual?
2. Is “No Relation” messaging supported or only conceptual?
3. Is forwarding part of the framework or just a pattern?
4. What stability policy applies to APIs?
5. What minimum acceptance tests define Core Model compliance?
6. Is the Stop contract fully specified for all failure modes?
7. Should Channel Wire transport exist?
8. Is plugin architecture first-class or user-land?
9. Is Spawn Parent real or exploratory?
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

- Add additional functions for Actor Index i.e. = Edge, = Mid, = Core, etc. This will be by user request for common functionality.

- TEMPLATE TOOL: add in a function call in creating the template which creates in the library a SHA256 that is a for loop that outputs the "unique" value for the `Msg ID`.

- Message and actor naming limitation when using the rename Tool:
	- We only allow "space" and capital/lowercase letters, that's it.
	- There must contain at least one "space" within the name.
Justifications, when reading messages for the outside world, these characters are not allowed. This helps name spacing and clarity of intent.

- RENAME TOOL: Excluded names, update the names for the template msg and actor for name spacing excluded names. This could instead be programmatic by checking the library under question for the VI names already present.

docs:
When developing, only use poly VIs found on the palette.

- Async Actor.vi
Make non reentrant, put highlight execution on. What is the recreated execution for:
1. Two Roots spawning at the same time?
2. Root spawning child
What are the executions for these? Because we want to leak the first reference. And we want to know what to do, in the nonreentrant case without having the uninitialized shift register.

- revisit the spawn function calls.

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


---
---
---
---


## `Stop` and **Orderly Stopping**

`Stop` is a standard lifecycle signal that initiates **Orderly Stopping**.

**Orderly Stopping Invariant**

> A parent actor MUST outlive all of its children.

This invariant is strictly enforced across the entire actor tree.

### State Transitions

When an actor receives `Stop`:

1. **If the actor has children**
   → Transition to `StoppingWithChildren`.

2. **If the actor has no children**
   → Transition directly to `StoppingWithoutChildren`.

---

### `StoppingWithChildren`

In this state:

* The actor instructs all direct children to stop.
* The actor continues processing messages (including application messages).
* The actor does *not* execute teardown yet.
* The actor waits until all children report `Stopped`.

Each child recursively applies the same logic:

1. Stop its own children first.
2. Execute teardown.
3. Notify parent with `Stopped`.

When the parent’s child set becomes empty:

→ Transition to `StoppingWithoutChildren`.

---

### `StoppingWithoutChildren`

In this state:

* The actor executes teardown.
* The actor notifies its parent that it has `Stopped`.
* The actor terminates.

---

### Contractual Rule

> All finalization logic MUST reside in teardown, never in `Stop`.

`Stop` initiates lifecycle transition.
Teardown performs cleanup.

---

## State Semantics Clarification

### `StoppingWithChildren`

An actor in this state:

* Has begun the stopping process.
* Has not executed teardown.
* Continues processing application messages.
* Is waiting for children to stop.
* Cannot spawn new children (assumed invariant — see questions below).

When children are exhausted:

→ Transition to `StoppingWithoutChildren`.

---

### `StoppingWithoutChildren`

* Teardown executes.
* Actor reports `Stopped`.
* Actor is stopped.

---

# Architectural Aside — Control Logic Smell

Consider:

```
Grandparent
  └── Parent
        └── Child
```

If:

* Parent receives `Stop`.
* Parent must wait for Child to stop.
* Parent teardown includes urgent safety logic (e.g., immediately setting pump speed to zero).

This indicates architectural misplacement of responsibility.

### Why This Is a Smell

Urgent control logic should not depend on waiting for subordinate actors to terminate. If teardown latency matters, the control logic is positioned too high in the hierarchy.

---

## Corrective Principle — Leaf Actors

A **Leaf Actor**:

* Cannot have children.
* Owns direct control of physical or critical processes.
* Executes teardown immediately upon entering `StoppingWithoutChildren`.

Critical, real-time responsibilities belong at leaf level.

---

## Structural Mechanism

Each actor contains:

```plaintext
Leaf : boolean (private data)
```

### Corrected Semantics

* `Leaf = true` → Actor CANNOT spawn children.
* `Leaf = false` → Actor MAY spawn children.

(Default must be explicitly defined.)

This flag is static and determined at edit-time.

### Unified Actor Rule

For composite or layered actors:

```
UnifiedLeaf = OR(all layer Leaf flags)
```

If any layer requires leaf behavior, the unified actor is treated as a Leaf Actor.

This ensures:

* Explicit architectural intent.
* Prevention of accidental hierarchy expansion.
* Guaranteed immediate teardown capability for lowest-level controllers.

---

# Critical Clarifications Required

Your answers resolved several design points, but there are still structural ambiguities that will matter in edge cases.

---

### 1. Message Processing During `StoppingWithChildren`

You stated that application messages are still processed.

**Clarification needed:**

* May new children be spawned in this state?
* If yes, Orderly Stopping can become non-terminating.
* If no, this must be an enforced invariant.

---

### 2. Idempotency of `Stop`

* If an actor already in `StoppingWithChildren` receives another `Stop`, is it ignored?
* Should `Stop` be idempotent?

---

### 3. Child Acknowledgment Contract

When a child reports `Stopped`:

* Is this guaranteed exactly once?
* What prevents duplicate or lost `Stopped` signals?
* Is this framework-enforced or developer-enforced?

---

### 4. Teardown Determinism

You stated full teardown always executes, even during termination.

* Is teardown required to be synchronous and blocking?
* Or may it be asynchronous and message-driven?
* If asynchronous, how is termination completion defined?

---

# Toward Formalization

You asked:

> How can I formally model the lifecycle as a deterministic state machine?

At minimum, you will need:

### Explicit States

* `Started`
* `StoppingWithChildren`
* `StoppingWithoutChildren`
* `Stopped`

### Explicit Guards

* `children.count > 0`
* `children.count == 0`
* `received Stop`
* `received Terminate`
* `received ChildStopped`

### Explicit Prohibitions

* No child spawning in stopping states.
* No state regression.
* No teardown execution before children complete.

Without these, formal verification is not possible.

---

# Follow-Up Questions

**Q1:** Should child spawning be strictly forbidden once an actor has entered any stopping state?
**Q2:** Should `Stop` and `Terminate` be modeled as distinct states, or as context flags within the same state machine?
**Q3:** Do you intend to eventually prove termination of the actor tree under all shutdown scenarios, or is this a pragmatic contract rather than a formally verified guarantee?


maybe there is some merit to ONLY using a type def for the message input and only one input. This makes scripting much easier. This would also be easier for the gRPC since only the type def information will be sent across