# Glossary

This glossary is the **canonical** home for shared terminology across the jettl documentation.

## Collaboration workflow

When you answer questions embedded in the docs, reply directly under the question using:

```markdown
> **RESPONSE:** YOUR TEXT HERE
```

## Terminology discipline (doc-wide)

- Use **tell** (not “send”) when describing message delivery.
- If a term is overloaded, refine it here by giving it a single precise definition and updating callers to link back to it.

---

## Actor

A single layer in a decoration stack: one class instance that implements the `Actor` interface.

## Actor Layer

A synonym for **Actor** when the layering/decoration context is important.

## Unified Actor

The composed view of a running actor formed by stacking multiple **Actor Layers** together.

## Base Actor

The built-in innermost actor layer provided by jettl. It anchors the unified actor’s behavior and is present in every unified actor unless an advanced developer replaces it.

## Core Actors

A Root-scoped set of persistent actor layers that are composed into every descendant actor spawned under that Root.

## Edge Actors

A Root-scoped set of persistent actor layers that are composed into every descendant actor spawned under that Root, typically used for boundary/outer concerns.

## Root

The root unified actor of an application actor tree.

## Self

The current actor, used for relative relations and for `Tell Self`.

## Parent

The actor that spawned (or otherwise owns the lifetime of) a child actor.

## Child

A spawned actor that has a parent–child relationship with another actor.

## No Relation

Two actors are “No Relation” when they do not share the same Root and do not have a parent–child relationship.

## Message

An interface-backed unit of communication that an actor can **listen to** (handle) and that another actor (or non-actor caller) can **tell**.

## Msgs

The set of message methods implemented by a single actor layer.

## Unified Msgs

The union of message methods implemented across all layers in a unified actor.

## Tell

To deliver a message to a destination actor through a jettl telling API (for example: `Tell Self`, `Tell Parent`, `Tell Child`).

## Transport

The mechanism an actor uses to carry messages at runtime (for example: Queue, Event, Notifier).

## Turn

One execution cycle of an actor (one “loop pass” through its event/processing structure).

## Finalize

A lifecycle hook invoked at the end of each actor execution turn.

## Attributes

Read-only metadata/state exposed for the Self/Parent/Child relations of an actor (for example: VI ref, actor refs, unified messaging data).

## Teller

The API surface responsible for telling messages and enforcing destination/relationship rules.

## Introspection chain

A stable sequence of read-only calls used to obtain information from a unified actor (for example: `Attributes → Read VI Ref`).

## Unhandled message

A message that was told to an actor but was not listened to/handled before the actor stopped or otherwise declined to process it.

## Private Actor

A supporting actor that is intended to be used only within the library that contains it (and is typically marked private).

## Private Message

A message intended to be told only by the actor itself (Self messaging) and not by external callers.

## Bridge actor

An adapter actor that connects non-jettl code to jettl actors. Toward jettl, it behaves like a normal actor; toward non-actors, it exposes conventional LabVIEW integration points (queues, user events, DVRs).

## Decoration (decorator pattern)

The mechanism for stacking multiple actor layers into a unified actor, where each layer may implement or extend message handling.

## Broker / mediator (pattern)

A coordination pattern where a central actor (or actor layer) owns routing and/or reference distribution. This is currently treated as non-normative unless explicitly committed in the docs.

---

## Add a new term (template)

Copy/paste this when you introduce a new glossary entry:

```markdown
## TERM NAME

DEFINITION.

> TODO: Clarify/confirm any ambiguity.
>
> - **Open question:**  
> - **Decision:**  
```
