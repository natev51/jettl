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

---
---
---

Insert here.


---
---
---

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


## `Stop` and **Coordinated Shutdown**

`Stop` is a standard lifecycle signal that initiates **Coordinated Shutdown**.

**Coordinated Shutdown Invariant**

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
* If yes, Coordinated Shutdown can become non-terminating.
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

---
---
---
---
---
---

# jettl Tools

Tools -> jettl Tools ->
- Edittime
- Runtime

—
Template Tool:“Msg ID Generator.vi”: creates in the library description (other places too) a SHA1 (string) that is a parallel for loop that comprise a Msg ID. JSON Format:[“Msg ID”: “”]
—
Any naming Tool (“Rename” / “Poly VI Alias” generation) must have:- one, two, or three words- no more than two spaces- cannot start with space- cannot have two spaces in a row- All words start with capital letter (could be enforced under the hood while typing)- only alphabetical letters allowed- total character limit of 200
Why: Easy for icon text display for Actors and Msgs
“Excluded Names.vi”: checked programmatically for the library for the (either)- VI names already present
- Alias Names already present
—

# Coordinated Shutdown

ONLY exists in the Root Actor.

—

Coordinated Shutdown guarantees that Root Actor always outlives Leaf Actors.

—

# Spawning

Only Root needs to address the Root Loop problem since Leaf Actors will always will be spawned after Root has been spawned.

Root Async Actor.vi
Make non reentrant, put highlight execution on. What is the recreated execution for:
- Two Roots spawning one after another?
What are the executions for these? Because we want to leak the first reference. And we want to know what to do, in the nonreentrant case without having the uninitialized shift register.
—
New DVR in “Async Actor.vi”. In “Setting Up”, delete DVR in Leaf Actor, then New DVR. This ties the lifetime of the DVR to the Actor being spawned (Root or Leaf).
Root Actor:- “Write Unified Root Actor”- “Read Unified Root Actor”
Leaf Actor:- “Write Unified Root Actor”- “Read Unified Root Actor”
—

# Msgs

- Always know what Base Root Actor and Base Leaf Actor messages are implemented.
- Spawning Root Actor (with input of Core Actors), their messages can be saved as “Implemented Core Msgs”.
UNFINISHED

—

Transport DVR

—

# General Actor Concepts

Root should be HIGHLY functional, minimizing overhead of DD calls and other logic.

—

No recursion in Root Actor.

—

Root cannot use Tell Root (this one is the only one that instantiates classes)

—

Find Msgs can have a DD output?

—

# General

Use of jettl:Some VIs in the jettl.lvlib are public since they’re used in the Actors. Some of these methods should not be used, though it is not clear which by inspecting the library.Therefore, we distinguish public function calls (no method calls) that can be used ans only those defined through polymorphic VIs, which are all found on the palette.
—
Delete “Root Call.vi”
—
Get rid of jettl in namesGet rid of Root Actor -> RootGet rid of Leaf Actor -> Leafs (Leaves correct spelling but let’s keep it “simple”)
—
Due to bugs with DVRs and classes, all DVRs are Type Def clusters.
—
DVR.. maybe don’t use read only parallel access, and only use the read/write with data wired through.This is more deterministic and not prone to race conditions.


# Random

Since unconditionally calling Async Elements in “Setting Up.vi”:Put Decorator for Actor.vi IN Actor.viThen the enqueue of Async Elements occurs in “Base Actor.lvclass”.
—
Shit, can do the same for the Find Msgs? And output an array of the Msgs, then can index the array to properly get the correct Msgs for each Actor.DON’T be afraid to append functionality to decorator methods.Think about rewriting Recurse where this is a decorator method.
Think about rewriting Decorator -> Init Actor DVR
—
Avoid ANY UI Thread transfer:https://www.youtube.com/watch?v=Zc8Xx9AFqtc @22:59

Google: Set Control Values By Index.Use THIS instead of property nodes by mapping the control ref to the indexes at initialization.Maybe.. Refs bundle at start ALSO has the This VI and App Ref.
—
The Actor.ctl doesn’t need to be DVR in private data!Or does wrapping in DVR provide faster performance?
—
But do take consideration to have pass through Object for Read methods TO avoid memory copieshttps://youtu.be/Zc8Xx9AFqtc?si=Di0mG8iJLwI-5Eif@31:24OR Just co sided being diligent and use flat sequence structure to enforce serial execution. As suggested in video (by Eli Kerry, not error wire though!, flat sequence)Single frame flat sequence enforced ordering to avoid memory copies.—
https://www.youtube.com/watch?v=Zc8Xx9AFqtc @ 37:47Inline works for the Find Msgs VI with the inline setting since the block diagram is ABSORBED into the containing diagram, so the variant DOES work?
—
Greg NEVER changes the defaults for VI Properties
https://www.youtube.com/watch?v=Zc8Xx9AFqtc @ 45:38

# Msg DVR

jettl strives to be the gold standard in DVRs, memory, and performance optimization.
Application lifetime guarantee of Root and Leafs.
Leaf Defines in it’s private data (outermost layer for fastest lookup without DD calls to innermost layer) the:- “Msg DVR Root Buffer DVR”:”Array of Msg DVRs”- “Msg DVR Leaf Buffer DVR”:”Array of Msg DVRs”

All Actors are persistent for the application.
“Lifetime Root:Queue” created in Root Actor and when all Leaf Actors have told their Stopped Msg, then the Root Actor enqueues this and all Leaf Actors can then finish executing. Otherwise they continue executing messages.

Therefore, the Msg DVR lifetime is just in the Leaf Actor that created it. DVR is deleted in Root and the Msg.ctl is gotten there using “Swap Values.vi”.
Notice that Leaf can only Tell Self and Tell Root by pulling from the “Msg DVR Leaf Buffer DVR”.In Leaf, there is a check to ensure the Msg DVR is at at least the specified “Msg DVR Root Buffer Size:I32” of preallocated Msg DVRs (as defined by Root, but in private data of Base Leaf).
By framework definition, all Leaf Actors are persistent and spawned at the beginning of the Root Spawn. Therefore, Leafs have the same lifetime as Root. For the complete lifetime, refer to documentation. 

Root does NOT create Msg DVRs.

In the Leafs, a function is used to add Msg DVRs to the Buffers. Look into optimization by James Powell Memory in LabVIEW @build array section.
Note to keep the Write to DVR time SMALL as to not lock resources from Root.Could be very smart and when filling the buffer back up creates New Msg DVRs (from parallel For Loop) and chucks a bunch into the “Msg DVR Root Buffers DVR”. 
—

Msg DVR preallocation in Leafs:Preallocate Msg DVRs to memory in the Leafs.Use “Swap Values.vi” with IPES delete from array at first index, wire in 0. But this changes size of array.. so that’s out. So is there a way to slide the array to the left, pop the 0th element (valid Msg DVR) and add a default Msg DVR to end of array. Remember, the goal is for the array to remain the same size (for performance reasons, not allocating more memory for different size arrays)) when ready to use the Msg DVR.
NOTE: That means in Root, in the “Name.vi”, when Tell Leaf, for a given Leaf can only accept one message, otherwise will pull from same index.
WAIT: Can parallel Reads happen in parallel? What is the most memory/performance efficient?https://forums.ni.com/t5/LabVIEW/DVR-Parallel-Read-Access/td-p/3645659
Detail: always use the same SIZE array for Buffer, where the buffer chunk assigned (build array) never goes above array size defined, rest are always default Msg DVRs.Checks if (say) halfway point is a not a ref.https://lavag.org/topic/15546-are-you-misusing-the-not-a-refnum-function-and-putting-your-app-at-risk/
Can be a debugging entity that readily checks the size of the buffers i.e. in “Finalizing Turn.vi”.
These Msg DVR Buffers ARE themselves DVRs that (by definition) only the Root and Leaf have access to.Let’s see.. this asks the question how large of a buffer size should be preallocated (can LabVIEW handle / bottle neck of absolute message transport speed of Root) to each of the Leaf Buffers?
James Powell Memory in LabVIEW:Build array memory optimized @ 1/4 timestamp.
Maybe there’s a dedicated “Priority” message (under the hood) that tells Leaf to allocate more memory to Msg DVR Buffer.

—
Documentation:In Root Actor, since the Tell Leaf function calls are statically typed in the “Name.vi” in Root Actor, this directly determines WHERE messages are told from and to to fill out the entirety of the tree hierarchy of mesaaging

# Memory

https://www.youtube.com/watch?v=dIGHfybWCG4 @ 25:02





# Working

Two Interfaces in Msg Library:
- Root:“TEMPLATE Root Msg.lvclass”- “TEMPLATE.vi”
- Leaf:TEMPLATE Leaf Msg.lvclass”- “TEMPLATE Before.vi”- “TEMPLATE After.vi”
Interfaces in jett:
- “Root Execute.vi”
- “Leaf Execute.vi”
^^^^Have to come back to this..

Huh…. Maybe no runtime checks as to not throw errors.. minimize errors that can be thrown in Root Actor. Here that means checks for if a Leaf can accept a message, whatever, just tell it. The Leaf will auto ignore it and delete the reference.

—
—

—
- DVR Specifics:
All DVRs are Type Def clusters. But, some of the type defs have inside them interfaces (which are instantiated as classes at runtime). Therefore Mark As Modifier (on the IPES input) is not used in jettl unless:
1. This is a write operation **AND**
2. A dynamic dispatch method is called within the IPES.
This could change in the future, note:
https://lavag.org/topic/7761-in-place-element-structure-mark-as-modifier/
https://lavag.org/topic/19685-dvr-and-error-handling/
https://forums.ni.com/t5/LabVIEW/Mark-as-modifier-in-place-of-structure/td-p/2028072
https://www.ni.com/docs/en-US/bundle/labview-api-ref/page/structures/in-place-element-structure.html#:~:text=You%20can%20right%2Dclick%20a,data%20and%20avoid%20race%20conditions
https://forums.ni.com/t5/LabVIEW/Manipulating-DVR-Data-Is-this-correct/m-p/3211893
https://forums.ni.com/t5/LabVIEW/quot-Data-Value-Reference-quot-and-quot-In-Place-Element/td-p/1558466
https://www.ni.com/docs/en-US/bundle/labview/page/caveats-and-recommendations-for-using-in-place-element-structures.html
https://www.ni.com/docs/en-US/bundle/labview/page/storing-data-and-reducing-data-copies-with-data-value-references.html#:~:text=Storing%20Data%20and%20Reducing%20Data%20Copies%20with,value%20references%20to%20store%20large%20data%20sets.
https://medium.com/@thomas.zilliox/sharing-memory-between-modules-and-loops-in-labview-287e14e4039e
https://www.youtube.com/watch?v=VIWzjnkqz1Q
https://www.youtube.com/watch?v=lPwLTCtgYDo
https://forums.ni.com/t5/LabVIEW/Anyone-else-having-DVR-In-place-element-structure-bug-error-1556/td-p/4320674
https://forums.ni.com/t5/LabVIEW/Pointers-in-Labview/m-p/1242534#M525059
https://forums.ni.com/t5/LabVIEW/Reference-to-a-variable/m-p/4038233#M1158672
https://www.ni.com/docs/en-US/bundle/labview-api-ref/page/functions/data-value-reference-read-write-element.html?srsltid=AfmBOoonDb0eZCRmaWPO4N9VNUrYt9_UCMS-Xoeok8eylPlcB3ber5dI
https://www.youtube.com/watch?v=DTbqR0H-e8g
https://lavag.org/topic/10983-dvr-vs-pointer/
https://www.ni.com/docs/en-US/bundle/labview/page/storing-data-and-reducing-data-copies-with-data-value-references.html?srsltid=AfmBOop8BAUarAnSy6KhSo8oJHJ-6_S7GbU5qGuWa3Pkd82RajZvUnJi
and many other discussions on DVRs in LabVIEW.

---

Stopped is the final message that can be read by the Root Actor from a Leaf Actor.Leaf Actor lifetime: Only when the Root Actor listens to Stopped will the Leaf Actor be able to go out of scope (from a queue that is dequeued after the Tell Root Stopped Msg in “Tearing Down.vi”. This guarantees lifetime of messages told before Stopped, but not after Stopped since the Msg DVR (tied to the Leaf lifetime) goes out of scope after Stopped message.
“Stopped Listened To:BoolQueue” AFTER Stopped as Dequeue (In Stopped reads “Stopped Listened To” and enqueues TRUE.
Add “Stopped Listened To:boolQueue” to “Leaf Unified Actor.ctl” and is created and bundled at the “Update Unified Actor.vi” in “Setting Up.vi” for Leaf Actor.

---

Root listens to Msg, ALWAYS forwards to Leaf. There is a check in Leaf Actor that only allows Msgs to be told to Root if Root Implements that Msg (different interface, but nonetheless same library). 

Care is taken to not create data copies anywhere in Root (hence the use of Msg DVR). Due to changing of the Msg DVR lifetime to the Root Actor, the Msg DVR is deleted and a new DVR with the same type def data, of course the Teller is updated again in Root. Rethink the Teller, since the Teller is only important in the Leaf Actors.

--

Clusters implemented as DVRs:
- `Root Actor.ctl`
- `Leaf Actor.ctl`
- `Base Root Actor.ctl`
- `Base Leaf Actor.ctl`
- `Msg.ctl`

---

jettl is used ONLY as a PPL. If the developer is curious about the underlying functionality, then they should (as any other language) go to the git repository and examine the source code for further learning. Further, the documentation is the source of truth for the framework for both decisions behind the design of the source code along with usability of the jettl framework.

---

GOTCHA! Access Scope on Interfaces / Classes:
Even though their libraries are private, the interface can still be implemented in other interfaces / classes **Rule: even if an interface is private to a library AND (to be more strict) the interface is marked private, other classes outside the library can still implement the interface.** While interfaces themselves can be set to private access scope within a project library, this primarily restricts which other VIs can _use_ or _call_ the interface, not which classes can _implement_ it. The same can be said for classes.
Now, where this is a GOTCHA! If your interface is marked private to a containing library and that library is built into a PPL, NOW if you were to use that PPL, classes that otherwise could implement the interface (non-PPL), cannot implement the interface (PPL) SINCE the interface is private to the PPL and is not available in the PPL since it was marked as private!
SO. Best practice for code development (non-PPL) to side step this rule above in LabVIEW (IMO the private scope on an interface / class or library containing (say) a public interface / class should be more restrictive and not let other interfaces/classes implement the interface/class if the interface/class is private to interfaces/classes outside of the containing library) is to not implement an interface (or inherit from a class) that is private to a containing library or public but containing library is private that that class/interface is not apart of.

---

Constraint: a mesaage can only be told, it cannot be directly called.

—


Msg DVR
DVRs for messages, memory copies being created when telling user events. He addressed this in the example with a DVR as the payload. Lifetimes are guaranteed and the deleting of DVRs occurs under the hood.
https://youtu.be/zR6qe2POhFk?si=QVWJH4omuairiQLv @18:57

—

For Root Actor:
SubVI for the Release Transport and put it RIGHT when the Actor shouldn’t handle anymore messages! ie when “Stopping without children”.

For Leaf Actors:
Same, but location RIGHT when stop hits.

—

Unhandled messages, make sure to delete the DVR.

--

Telling messages: a purely static design.
By framework design, Root ONLY listens to messages it has implemented. This eliminates message checks, minimizing overhead in Root. This check is done in the Leaf Actor before telling message to Root. The Leaf Actor checks the Root Actor “Implemented Msgs” set.

Root Msgs:
Inbound:
- Implemented Msgs (these are inbound)
Outbound:
- Tell Leaf (statically determined).

Leaf Msgs:
Inbound:
- Implemented Msgs (if not implemented, then no-op) this is a design flaw that should be detected by documentation / analyzer, since statically typed spawning)

Outbound:
- Tell Root (checks if Root implements, otherwise error).
- Tell Self

—
Leaf Actors are easy to document, they:
- Tell Msg to Root
- Tell Msg to Self
—


Leaf Actors:
Leaf cannot be spawned unless Root Implemented all Msgs Leaf tells. This prevents runtime errors that otherwise would occur if trying to tell a message to Root Actor that doesn’t have it in it’s “Implemented Msgs” set. That means that the Implemented Msgs check is NOT necessary! WOW!

—

ALREADY STATED:
New DVR in Spawner and delete DVR in Spawnee, New DVR there.

—

DVR:
Messaging is purely hierarchical AND FAST due to DVRs. Minimize overhead in Root when listening to messages and forwarding.
Msg DVR should have knowledge of Root and Leaf? 

—

ALREADY STATED:
Spawning a Leaf Actor, checks if the Leaf Actor can:
- listen to all messages available from Root (Poly VI for Leaf string and message name) (this action should be scripted, WOULD need to be statically tied to an alias.)

Goal: Very static system is what jettl aims for.
The only “dynamic” part of the system is the decorations of Leaf Actors. But this is actually static since there are Poly VIs for the spawned actor with its alias.
“Alias Name.vi” Poly Actor that is scripted to statically type the Leaf Actors. This makes the spawning of Leaf Actors static, within that DD method call. (Note it is DD not for overriding, but to declare to the compiler that the object in is the SAME object out, this will minimize memory copies and lead to better performance.)

Statically determining spawning should be determined at edit time.

This would work with Factory Pattern PPLs, so long as they’re known at edit time. Therefore, Factory Pattern is discouraged since it is dynamic.

jettl aims to be a heavily typed system when everything is known at edit time. Minimizing dynamics at runtime, therefore preventing bugs and errors from occurring.

—

jettl has two actor types:
- Root
- Leaf
As defined through their containing library name.
(Take away the Private Actors virtual private folder).
Constraint: One Root Actor and N many Leaf Actors.

Root Actor:
N many decorators (note more decorations means more DD overhead).
Root Base Actor is always innermost.
(Define the Leaf Actors Core Actors here).

Leaf Actors:
Decorator Actors
Core Actors (defined in Root Actor).
(Get rid of Edge Actors)

—

Root Actor Transport:
Queue (DVR). Queue used instead of Event for maximum performance as it is a 1:1 transport.
MINIMUM LOGIC for maximum throughput of messages.

Leaf Actor Transport:
Event (DVR). Event used due to ability to 1:N message external entities in an application and control events.

—

Root Actor Spawning:
Note spawning is blocking so spawning in the lifetime of Root is NOT allowed. This must occur upon initialization. Errors from a Leaf to the Root Actor is an automatic shutdown. HANDLE ERRORS IN LEAF otherwise automatic shutdown.

—

Create libraries with Poly VIs inside:
- Read Base Root Actor DVR
- Read Decorator Root Actor DVR
- Read Base Lead Actor DVR
- Read Decorator Leaf Actor DVR
- Read Msg DVR

—

THIS IS A REPEAT:

Root Actor:
- Tell Leaf

Leaf Actor:
- Tell Self
- Tell Root

—

Get rid of jettl in the names!

—

No more Parent, Child
Rename to Root and Leaf

—

Delete:
- Read Unified Actor.lvlib
- Read Base Actor.lvlib

---

Buffer DVR is a Type Def Cluster:
- array of Msg DVRs
- Current Index
(in Root, Read/Write since updating Buffer DVR)

Current Index is incremented after reading (Swap Values.vi)
Check instead the Current Index if above “value” in array. Then new DVRs that replace default Msg DVRs array elements BEFORE the Current Index, and of course at the end, update Current index to 0.



























































































































































