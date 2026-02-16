# Glossary

This page is the **canonical source of truth** for jettl terminology. Other pages should **link here** instead of redefining terms.

> **JUSTIFICATION**: The docs previously duplicated definitions across multiple pages (especially in *Core Model*). Centralizing terminology prevents drift and keeps each page focused on its purpose (e.g., *Core Model* = contracts, *Usage* = patterns).

## Actor

One layer in the decoration stack: a single class instance that implements the `Actor` interface.

> See also: [Actor Layer](#actor-layer), [Unified Actor](#unified-actor)

## Actor Layer

Synonym for [Actor](#actor) when discussing layering explicitly.

Use **Actor Layer** when you need to distinguish between:
- a single decorated layer, and
- the composed running unit (the [Unified Actor](#unified-actor)).

## Unified Actor

The unified view of a running actor, formed by composing multiple [Actor Layers](#actor-layer) into a single execution unit.

- A unified actor has one transport, one message-handling loop, and one set of runtime [Attributes](#attributes).
- Messages may be implemented by any layer in the stack.

## Actor Tree

The strict hierarchical structure of actors in an application:

- one [Root](#root),
- each actor has at most one [Parent](#parent) (except the Root),
- each actor may have zero or more [Child](#child) actors.

## Root

The root unified actor of an application actor tree.

- All actors in a tree share the same Root.
- Root identity is used to define relationships such as [No Relation](#no-relation).

## Self

The *relative actor relation* that refers to the current actor instance.

## Parent

The *relative actor relation* that refers to the actor that spawned the current actor.

If the current actor is the [Root](#root), it has no Parent.

## Child

A spawned actor that is a direct descendant of a Parent in the [Actor Tree](#actor-tree).


## No-Children Actor

A leaf actor: an actor that does not spawn any child actors.

This term is most often used when documenting Parent/Child message contracts: a leaf actor may still tell messages to its parent, but it does not have its own child-spawn responsibilities.
## No Relation

Two actors are **No Relation** when they do **not** share the same [Root](#root) and do **not** have a Parent/Child relationship.

## Base Actor

The built-in, innermost actor layer provided by jettl.

- It is always present in every [Unified Actor](#unified-actor) unless an advanced developer provides a replacement base layer (typically for testing/debugging or framework experimentation).

## Core Actors

A Root-scoped set of persistent actor layers that are composed into every child actor spawned under that Root.

These layers typically implement cross-cutting concerns (e.g., logging, metrics, debugging, policy enforcement).

## Edge Actors

A Root-scoped set of persistent actor layers that are composed into every child actor spawned under that Root, typically used for “outer boundary” concerns.

Edge layers are advanced and are typically avoided in beginner-focused designs.

## Actor Index

A runtime notion of where a layer sits in the decoration stack for a unified actor.

Example intent: determine whether the currently executing layer is the outermost layer (useful for “only do this once per unified actor” behavior).

## Transport

The mechanism used to deliver told messages to an actor.

jettl supports multiple transports (e.g., Queue, Event, Notifier). Transport selection affects delivery mechanics and performance characteristics, but does not change the high-level *messaging model* unless explicitly called out.

## Msg

A message object/class that represents a unit of asynchronous work to be executed by an actor.

A Msg is always associated with an interface-defined message method.

> Terminology discipline: use **Msg** (and **tell**) consistently; avoid the term “send”.

## Msgs

The set of message methods implemented by a single [Actor Layer](#actor-layer).

## Unified Msgs

The union of message methods implemented across all layers for a [Unified Actor](#unified-actor).

## Tell

To enqueue/emit a [Msg](#msg) to a destination actor relation (e.g., [Self](#self), [Parent](#parent), [Child](#child)) through the actor’s [Transport](#transport).

A tell is conceptually “fire-and-forget”: it schedules work to occur later on the destination actor’s turn processing.

## Destination

The statically selected relationship used when telling a message:

- **Self**
- **Parent**
- **Child** (usually with an additional identifier; see [Child UID](#child-uid))

jettl’s “strongly typed destinations” discipline means the relative destination is known at edit time.

## Child UID

A developer-facing identifier used to name child relationships at edit time.

In many jettl codebases this is represented as an enum (`Child UIDs.ctl`) that maps to an internal string key used to index child data (e.g., a child attributes map).

## Turn

One execution cycle of an actor’s message handling loop.

A single turn typically includes: receiving/listening to a message (or timeout), executing the associated message method(s), and running end-of-turn hooks such as [Finalize](#finalize).

## Finalize

A lifecycle hook invoked at the end of each actor execution [Turn](#turn).

## Stop

The lifecycle action (and commonly also a message) that initiates actor shutdown.

The normative shutdown semantics (monotonic stop flag, idempotence expectations, teardown behavior) are defined in the Core Model lifetime contract.

## Stopped

The lifecycle notification (and commonly also a message) that indicates an actor has finished stopping and is no longer processing turns.

## Setup

A lifecycle phase invoked during actor startup, before the actor begins normal message processing.

## Start

A lifecycle phase invoked after Setup when startup is successful enough to begin normal message processing.

## Teardown

A lifecycle phase invoked during startup failure recovery and/or shutdown sequences to release resources and unwind partial setup.

## Attributes

Read-only runtime state made available for introspection.

Actors can typically read:
- **Self attributes**
- **Parent attributes**
- **Child attributes** (for known children)

The Core Model defines visibility and timing rules for when specific attribute fields become valid.

## Listen

To accept a told message from the transport as the next unit of work to execute.

In some jettl implementations this is the moment a message transitions from “pending” to “being handled”.

## Listened To Msg

A message that has been listened to (accepted for execution) by the actor during a turn.

This concept is frequently used by inspection tooling to distinguish:
- messages that were merely told/enqueued, from
- messages that were actually processed.

## Unhandled Msg

A message that was delivered/told to an actor but was not listened to (and therefore not executed) before the actor stopped.

Some systems record unhandled messages during teardown to support diagnostics and acceptance tests.
