# Usage

This document collects practical patterns, recipes, and example-oriented guidance for building systems with jettl.

- For the core semantic contract, see [Core Model](Core%20Model.md).
- For runtime behavior and performance constraints, see [Runtime](Runtime.md).
- For tooling workflows and readability conventions, see [Tooling](Tooling.md).

## Examples

### Hello world

Minimal goal: spawn an actor and stop it.

> TODO: Link to a concrete Hello World example (code + screenshot).
>
> - **Example location (repo path or VIPM example name):**  
> - **What the user should observe:**  
> - **Screenshot image (if available):** `../Images/...`

Notes:

- You do not need to tell `Stop` to `Self` for the simplest hello world. If the hello world message ends by transitioning the actor into a stopped state, the second tell is redundant.

> TODO: Confirm the exact recommended hello world pattern.
>
> - **Preferred pattern (1–2 sentences):**  
> - **Does the message call Stop internally, or does the caller tell Stop?**  

### Continuous measurement and logging

> TODO: Define the canonical measurement/logging example.
>
> - **What is being measured:**  
> - **Where measurements are recorded:**  
> - **Message shape (typedef):**  
> - **Expected rates / throughput targets:**  

> TODO: Decide whether this example ships in VIPM and the Example Finder.
>
> - **VIPM keyword(s):**  
> - **Example Finder category:**  
> - **Example name shown to users:**  

### Example distribution checklist (pointer)

For VIPM/Example Finder distribution details, see [Tooling → Examples packaging notes](Tooling.md#examples-packaging-notes).

---

## Integration patterns

### Bridge actors (connecting non-jettl code)

You can spawn an actor and tell it messages from any LabVIEW code, not only from other actors. The primary challenge is returning data back to non-actor code. A **bridge actor** (adapter/shim) is the standard pattern.

#### Pattern summary

1. **Create a pure actor** that performs the required work. This actor follows jettl rules strictly.
2. **Create a bridge actor** that translates between non-actor callers and the pure actor.
3. **Expose pass-through command messages** on the bridge that forward to the pure actor.
4. **Return data via reference objects** (queues, user events, DVRs), because non-actor callers are not listening to jettl messages.

> TODO: Capture the canonical bridge pattern as a diagram and a minimal working example.
>
> - **Diagram image:** `../Images/...`  
> - **Minimal example location:**  
> - **Which reference type(s) are recommended (queue, user event, DVR) and why:**  

#### Step-by-step template

> TODO: Fill in the details for your canonical bridge implementation.
>
> - **Bridge actor responsibilities:**  
> - **Pure actor responsibilities:**  
> - **Startup contract (what the caller must provide):**  
> - **Shutdown contract:**  
> - **How errors are surfaced to the caller:**  

---

## Reuse actors

This section covers reusable actors that exist (or can exist) outside the core library.

### Panel actors

A panel actor family provides common UI/front-panel functionality.

Notes (preserved and organized):

- Separate repo/package: this is a reuse actor family rather than core library functionality.
- Common functionality:
  - Update and coordinate front panel state.
  - Window operations and subpanels.
  - Passing the spawned actor ref to the parent (from when it spawns as a child) so you do not need to plumb subpanel references around manually.
  - Often composed as a persistent layer when UI observability is desired.

Subpanels:

- After the child has spawned, the parent can access Child Attributes, which includes a `VI Ref`. This can be inserted into a subpanel without additional glue.
- This enables interchangeable front panels: you can spawn multiple actors and toggle which child panel is shown in a subpanel.

Lifecycle convention:

- Open panel in `Start`.
- Close panel in `Teardown`.

Transport note:

- Queue actors and notifier actors can have front panels, but avoid adding control/indicator terminals that imply UI/event behavior.
- A queue actor is often paired with a UI/event wrapper (for example, a panel actor) that owns UI terminals and event logic.

Inspiration:

- [MGI Panel Manager - Unmonitored](https://gitlab.com/justACS/mgi-panel-manager-unmonitored)

> TODO: Document:
>
> - **Where panel actors live (repo / package name):**  
> - **Which layer they belong in (Core vs Edge vs non-persistent):**  
> - **Minimal example:**  
> - **Lifecycle convention (open/close hook names):**  

### Broker / mediator (canonical home)

A broker/mediator pattern is a larger architectural commitment.

- Canonical discussion lives in [Non-Normative → Broker/Mediator](Non-Normative.md#broker-mediator).

---

## Scheduling patterns

### Periodic messaging

A periodic message should usually be driven by a dedicated timing actor, rather than by a timeout case inside the actor that owns the business logic. “Told periodically” does not imply “handled periodically”.

> TODO: Capture the canonical periodic messaging actor API.
>
> - **Init inputs (period, strategy, other):**  
> - **How drift/jitter is handled:**  
> - **How cancellation/stop is handled:**  
> - **Transport recommendation (queue/event/notifier) and why:**  


Notes (preserved and organized):

- Timing should come from another entity that determines *when* to tell a message. A dedicated timing actor is the usual solution.
- The actor that spawns the timing actor holds the truth for periodic state (for example, cancellation and “only one in flight”).
- “Told periodically” does not imply “handled periodically”. For throughput-sensitive designs, consider policies that ensure only one copy is outstanding.

Sketch (keep concrete when you turn this into code):

- `Init.vi` inputs:
  - Period
  - Message strategy
- `Process.vi`:
  - Unbundle Period
  - Timeout case: unbundle the message to tell and forward it to the creator/target

Transport intuition:

- Notifiers can work well for timing/“last value wins”.
- Event-based timing often suffers from event loop interruptions; document drift/jitter behavior if you choose this.

---

## Observability patterns

### Monitor message traffic (canonical home)

This pattern is primarily a debugging/diagnostics story.

- Canonical write-up lives in [Tooling → Runtime message inspection](Tooling.md#runtime-message-inspection).

---

## Design patterns

### Decorator pattern

- Canonical semantics for layering live in [Core Model → Actor layers](Core%20Model.md#actor-layers).

![dec_1](../Images/dec_1.jpeg)
![dec_2](../Images/dec_2.jpeg)
![dec_3](../Images/dec_3.jpeg)

> TODO: Add a short caption for each diagram and confirm the intended layering order.
>
> - **dec_1 caption:**  
> - **dec_2 caption:**  
> - **dec_3 caption:**  

### State pattern

Resources:

- [State Pattern – Design Patterns (ep 17)](https://www.youtube.com/watch?v=N12L5D78MAA)
- [State of Grace - The State Pattern in LabVIEW](https://www.youtube.com/watch?v=HewNBC4TjKs)
- [Powerful Design with the Gang of Four - Tom McQuillan and Sam Taggart](https://www.youtube.com/watch?v=IM8ZU1af6wQ&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=22)
- [A Class Act: Simple Design Patterns to Improve Code Quality, Allen C Smith - GDevCon N.A. 2023](https://www.youtube.com/watch?v=GRDoyn1mNAI&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=18)
- [A Class Act - Allen C Smith (JustACS) - GDevCon #4](https://www.youtube.com/watch?v=yVzT5ZqUuVU&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19)

Guidelines:

- State should not be modified in `Entry.vi`.
- Disallowing state transitions in both `Entry.vi` and `Exit.vi` is intentional: a state must be fully entered or fully exited before a transition is permitted.

### Factory pattern

A factory pattern is used to create instances of actors without specifying the exact class of the actor that will be created.

> TODO: Provide a concrete factory pattern example tied to PPL/plugin usage.
>
> - **Example location:**  
> - **How contracts are validated:**  

---

## Feedback questions

> TODO: Answer these to keep the Usage section concrete and example-driven.
>
> - **Which 3 examples are “required reading” for new users?**  
> - **Which reuse actors are already implemented vs only planned?**  
> - **For each reuse actor, what is the stable API surface?**  
> - **Which patterns should be enforced vs only recommended?**  
