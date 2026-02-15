# Glossary

This page contains **canonical definitions**. Other pages reference these terms rather than redefining them.

> TODO: If you introduce a new term anywhere in the docs, add it here (or link to where it is defined canonically).

## Core terms

- **Actor:** A single actor *layer* (one class instance that implements the `Actor` interface).
- **Actor Layer:** Synonym for **Actor** in the context of decoration: one layer in the unified actor stack.
- **Unified Actor:** The unified view of a running actor, formed by composing multiple actor layers into a single runtime entity.
- **Root:** The root actor of an application’s actor tree.
- **Parent:** The actor that spawned the current actor (exactly one, except for the Root).
- **Child:** An actor spawned by the current actor (zero or more).
- **No Relation:** Two actors are “No Relation” when they do not share the same Root.
- **Turn:** One execution cycle of an actor (one “loop turn” in the actor’s event structure).
- **Finalize:** A lifecycle hook invoked at the end of each actor execution turn.

## Messaging terms

- **Message:** A unit of work expressed as an interface method plus its message class implementation.
- **Tell:** The act of delivering a message to an actor via a specific relationship (`Self`, `Parent`, or `Child`).  
  A tell operation is *explicit* about the relationship and does not imply ordering guarantees.  
  See the normative contract: [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering).
- **Msgs:** The set of message methods implemented by a single actor layer.
- **Unified Msgs:** The union of messages implemented across all layers in the unified actor.

## Persistence terms

- **Core Actors:** Persistent actor layers that appear in every actor instance under a given Root (shared by spawning semantics).
- **Edge Actors:** Persistent actor layers that appear in every actor instance under a given Root, typically closer to the “outer edge” of the unified actor (wrapping the user actor layer).
- **Base Actor:** The innermost persistent actor layer that is always present (native to jettl).

> TODO: Tighten the Core vs Edge distinction so it is mechanically verifiable.
>
> - **Core Actors responsibilities:**  
> - **Edge Actors responsibilities:**  
> - **How a developer decides where a new persistent layer belongs:**  
> - **How tooling enforces the decision (if at all):**  

## Transport terms

- **Transport:** The underlying mechanism used to deliver messages to an actor (Queue, Event, Notifier).  
  Canonical behavior is defined in: [Actor Transports](Core%20Model.md#actor-transports).

## Documentation terms

- **Normative:** A rule that defines framework semantics. Violations are considered bugs or contract breaks.
- **Non-normative:** Guidance, rationale, ideas, or inspiration that does not define the contract.

> TODO: Confirm your exact interpretation of “normative” for this project.
>
> - **What MUST be stable across versions**:
> - **What MAY change without notice**:
