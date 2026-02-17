# API Reference

This page is a **map of the public surface area**: what you call, where it lives, and how it is intended to be used.

> **JUSTIFICATION**: The other pages focus on *concepts*, *contracts*, and *patterns*. This page exists so developers can quickly answer: “Which VI do I call for X?” without rereading conceptual documentation.

## Stability Labels

Every public API should be tagged as one of:

- **Stable**: supported for production use; changes follow a compatibility policy.
- **Experimental**: usable, but may change between releases.
- **Internal**: used by the framework and templates; not intended for direct application code.

> **TODO:** Decide the compatibility policy for **Stable** APIs (e.g., semantic versioning expectations, deprecation window, “breaking changes only on major versions”, etc.).

## Palette Index

The canonical way to discover callable APIs is the LabVIEW palettes:

- **Palette root**: `Data Communication → jettl`
- **Tools root**: `Tools → jettl Tools`

> **TODO:** Add a screenshot of the palette structure and label which sub-palettes correspond to the sections below.

## Actor API

### Spawning

| API (VI) | Stability | Purpose | Notes |
|---|---|---|---|
| `Async Spawn Child.vi` | Stable/Experimental (decide) | Spawn a child actor asynchronously. | Mentioned in docs as the canonical child-spawn mechanism. |
| `Spawn.vi` (override) | Internal | Actor-layer lifecycle hook during spawn. | Implemented/overridden inside actor layers. |
| `Actor.vi` | Internal | Main actor loop entry point for an actor layer. | Only the outer layer typically owns the actual loop. |

> **TODO:** Add the “inline root spawn” entry points used from `Main.vi`, including their exact VI names and connector pane expectations.

### Lifetime

| API (VI) | Stability | Purpose | Notes |
|---|---|---|---|
| `Setup.vi` (override) | Internal | Setup-time initialization. | See Core Model for setup-time messaging constraints. |
| `Start.vi` (override) | Internal | Transition into normal message handling. | |
| `Stop.vi` (override) | Internal/Stable (decide) | Initiate shutdown. | Stop flag contract lives in Core Model. |
| `Teardown.vi` (override) | Internal | Release resources / unwind. | |
| `Stopped` (message) | Stable | Notification that an actor has fully stopped. | Observed by parent/root. |
| `Finalize.vi` (override) | Internal | End-of-turn hook. | |

> **TODO:** Confirm which of these are intended to be overridden by users vs “framework only”.

## Messaging API

| API (VI) | Stability | Purpose | Notes |
|---|---|---|---|
| `Tell Self.vi` | Stable | Tell a message to `Self`. | Destination is statically known (Self). |
| `Tell Parent.vi` | Stable | Tell a message to `Parent`. | Requires a parent relationship. |
| `Tell Child.vi` | Stable | Tell a message to a named child. | Usually paired with a `Child UID` mapping. |
| `Call Inspect.vi` | Internal/Experimental (decide) | Runtime inspection hook for message execution. | Often used by debug/monitor layers. |
| `Read Listened To Msg.vi` | Internal/Experimental (decide) | Determine whether an inspected message was listened to. | Used to validate “called vs told” invariants. |

> **JUSTIFICATION**: The docs reference these VIs by name in multiple places. Centralizing them here reduces duplication and gives one place to attach stability labels.

## Attributes API

Attributes are accessed through read-only classes and interfaces (see Core Model for visibility rules).

| API (VI) | Stability | Purpose | Notes |
|---|---|---|---|
| `Attributes.lvclass:Read VI Ref.vi` | Stable | Read the actor’s VI reference (for panel/subpanel patterns). | Example introspection chain referenced in Core Model. |

> **TODO:** Populate the “blessed” attribute accessor chains once the final Attributes API is enumerated (Self/Parent/Child access patterns).

## Errors

All framework errors are documented and namespaced under:

- `jettl.lvlib:Error.lvlib`

> **TODO:** Add a short table of the most common error codes and their meaning once the catalog is finalized.

## Tooling API

Tooling lives under the LabVIEW **Tools** menu:

- `Tools → jettl Tools`

Current native tools referenced in the docs:

- **Rescript**
- **Rename**
- **Template**

> **TODO:** Add each tool’s on-disk path and a one-line “when to use it” entry.

## Interfaces and Classes Index

> **TODO:** Add an index of key framework types:
>
> - Actor interface
> - Transport interfaces (Queue/Event)
> - Teller interfaces/classes
> - Attributes interfaces/classes
> - Msg base type(s)
>
> The goal is discoverability, not restating semantics.
