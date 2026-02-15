# API Reference

This page is the **canonical index** of the public surface area of jettl: palettes, interfaces, classes, tools, and stability notes.

It is intentionally structured so you can keep conceptual documentation (Orientation/Core Model/Runtime) clean while still giving developers a concrete “what do I call?” reference.

> TODO: Confirm whether this file should be normative (“public contract”) or descriptive (“what exists today”).
>
> - **Status (Normative / Descriptive)**:
> - **If normative, what is the compatibility policy?**:

## Stability levels

Recommended categories:

- **Stable:** intended for application developers; breaking changes are exceptional.
- **Internal:** may change as implementation evolves; avoid calling directly.
- **Experimental:** available for feedback; expect iteration.

> TODO: Confirm the stability labels you want to standardize on.
>
> - **Allowed labels**:
> - **How labels are surfaced (doc tags, VI descriptions, palettes)**:

## Palettes

> TODO: List palette categories exactly as they appear in LabVIEW and map them to canonical responsibilities.
>
> | Palette path | Purpose | Stability | Notes |
> |---|---|---|---|
> | Data Communication → jettl → … | | | |

## Actor API

> TODO: List the canonical actor-facing VIs/methods.
>
> | Name | Type (VI/DD/Interface) | Purpose | Inputs | Outputs | Stability |
> |---|---|---|---|---|---|
> | Spawn… | | | | | |
> | Stop… | | | | | |
> | Stopped… | | | | | |

Key concepts:

- Relationships are explicit (`Self`, `Parent`, `Child`) — see [Glossary](Glossary.md).
- Normative contracts for lifetime and errors live in [Core Model](Core%20Model.md).

## Messaging API

> TODO: Describe the canonical “message shape” and how developers create and tell messages.
>
> - **Message interface rule (one method per interface)**:
> - **How message classes are named**:
> - **How polymorphic tell VIs are used**:
> - **How recursion works (Msg or Recurse)**:

See normative semantics in: [Messaging Model](Core%20Model.md#messaging-model).

## Attributes and introspection API

> TODO: List the stable read-only accessors and how to use them safely.
>
> | Intent | Call chain | Stability | Notes |
> |---|---|---|---|
> | Read unified msgs | | | |
> | Read actor relations | | | |
> | Read attributes | | | |

See: [Introspection and the Unified Actor](Core%20Model.md#introspection-and-the-unified-actor).

## Errors

- Canonical error catalog: `jettl.lvlib:Error.lvlib`  
  See: [Error Catalog](Core%20Model.md#error-catalog)

> TODO: Add a table of errors that users should expect, with “when it happens” guidance.
>
> | Error code | Meaning | Typical cause | Typical fix |
> |---|---|---|---|

## Tools API

> TODO: List the tooling entry points (Rescript/Rename/Templates/etc.) and document safety constraints.
>
> | Tool | Purpose | Safe usage checklist | PPL compatibility | Notes |
> |---|---|---|---|---|

See: [Tooling](Tooling.md).

## Interfaces and classes index

> TODO: Create a complete index of public interfaces/classes. This is the piece that prevents “mystery APIs.”
>
> | Name | Kind (Interface/Class/Library) | Owned by (Core/Tooling/etc.) | Stability | Notes |
> |---|---|---|---|---|
