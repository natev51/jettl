# Non-Normative

This page collects ideas, inspirations, and references that are explicitly **not** part of the normative jettl contract.

If a section becomes a real commitment, move it into the appropriate canonical document (Core Model / Runtime / Tooling / Usage) and replace it here with a link.

## Ideas that could be implemented

### Channel Wire message transport

Implement a Channel Wire message transport.

> TODO: Define the proposal precisely.
>
> - **Problem this solves:**  
> - **How it differs from Queue/Event/Notifier:**  
> - **Transport-invariant contracts (if any):**  
> - **Transport-specific behavior:**  
> - **Minimum acceptance tests:**  

### Spawn parent

Idea: `Spawn Parent.vi` (Root input), so an actor can spawn its parent.

Would be used to start an intermediate actor first, then construct the Root actor and its subtree.

> TODO: Clarify the semantics and constraints.
>
> - **Primary use case(s):**  
> - **How this interacts with Root semantics:**  
> - **What prevents cycles:**  
> - **Ownership / lifetime rules:**  

### Async spawn child message wrapper

Add an `Async Spawn Child jettl Msg` that wraps `Async Spawn Child.vi`.

> TODO: Specify the UX improvement and the contract.
>
> - **What this standardizes (defaults, logging, error handling):**  
> - **What it does not standardize:**  
> - **How it is tested:**  

### Error serialization (second wire)

Idea: add a second explicit “serialization wire” terminal to encourage dataflow sequencing without abusing the error wire.

> TODO: Tighten this into a concrete proposal.
>
> - **Problem statement:**  
> - **Proposed API (sketch):**  
> - **Compatibility constraints:**  
> - **Migration strategy:**  
> - **Prototype location:**  

---

## Patterns (not yet committed)

### Broker mediator

This section captures the longer-form broker/mediator notes. Treat it as a roadmap idea until you explicitly commit to shipping a canonical broker actor.

Resources:

- `mva-framework` (bitbucket): https://bitbucket.org/composedsystems/mva-framework/src/master/
- `stream` (bitbucket): https://bitbucket.org/composedsystems/stream/src/master/

Communicating between targets:

![broker-startup-scratch](../Images/broker-startup-scratch.jpeg)

#### Mediator / assembler wrapper (notes)

A mediator-based design can centralize reference ownership and message routing:

- Actor creation can be serialized and coordinated through the mediator.
- Each actor instance is created at most once at a time under mediator control.
- Actors shut down only when explicitly instructed by the mediator.
- The mediator holds authoritative knowledge of actor references and determines which actors are permitted to tell messages to which recipients.

Tradeoffs:

- The mediator becomes a bottleneck by design.
- Correctness and observability improve, but peak throughput may decrease.



Additional notes (preserved):

- For an inter-actor system, one approach is to wrap around the Root (for example by using a Root-spawn wrapper) and introduce a by-reference mediator process (DVRs + user events) that coordinates publisher–subscriber behavior within a single application instance.
- Just like spawning, an observer pattern can use a blocking subscribe/register call that constructs a dedicated subscriber child actor holding the private data needed to talk with the broker and its children.
- “No Relation” messaging (cross-root) can be used for cross-tree event delivery, but treat it as an advanced escape hatch and document the contracts carefully.

Assembler role (preserved):

- An **assembler** may be used strictly to construct actors and distribute references required for observer-style relationships.
- Actors request construction and reference wiring through the assembler, rather than discovering other actors directly.

#### Multiple application instances (notes)

A layered mediator structure can coordinate multi-application messaging:

- Each application instance contains its own internal mediator.
- A higher-level mediator facilitates communication between application mediators.

> TODO: Decide whether “Broker/Mediator” will become:
>
> - **A Usage pattern (shippable and supported)**, or
> - **A library/reuse actor (versioned API)**, or
> - **An out-of-scope idea.**
>
> If it becomes committed, move it to the canonical home and leave a short summary here.

---

## Inspiration checklist

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

> TODO: For each item above, decide:
>
> - **Already exists in jettl:**  
> - **Planned:**  
> - **Out of scope:**  
> - **Owner:**  

---

## Presentations

### “So, you're on the jettl team”

> TODO: Outline the talk.
>
> - **Audience:**  
> - **Goal:**  
> - **Key sections:**  
> - **Demo(s):**  

### “Intro to jettl”

Most recent VIPM package note:

- Download on VIPM and search `jettl`.

Related channels:

- GitHub
- VIPM
- YouTube

> TODO: Add the minimum content.
>
> - **A VIPM screenshot (most recent):** `../Images/...`  
> - **Install instructions (1–3 bullets):**  
> - **The first demo:**  
> - **Common pitfalls:**  

Resources of inspiration:

- [Introduction to DQMH](https://www.youtube.com/@ShireyStudios1)
- [GLA Summit 2025: Introduction to Actor Framework by Casey May and Dan Hooks](https://www.youtube.com/watch?v=bTydOIjY84E)

---

## References (pointers)

Reference lifetime and ownership is defined canonically in [Core Model → Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership).

---

## Immediate changes

*This section is a short list of changes that could be done immediately. Keep it concrete and testable.*

> TODO: For each “immediate change,” define:
>
> - **Motivation:**  
> - **Owner:**  
> - **Acceptance test:**  
> - **Target release:**  

- Add additional function calls for “actor index” (outer actor vs edge vs core).
- Add comments in developer code that clarify whether code is framework-owned (“DO NOT MODIFY”).
  - Example: `Init Actor` — DO NOT MODIFY!
- Add another object to Attributes called **Attributes Metadata**.

---

## Resources

> TODO: Fill in curated links and repos.
>
> - **Official repo(s):**  
> - **VIPM package:**  
> - **Example repos:**  
> - **Recommended talks (top 5):**  
