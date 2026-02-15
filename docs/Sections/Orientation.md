# Orientation

These docs are written for LabVIEW developers seeking a proficient understanding of jettl.

## Status and contributions

This is a living document. Contributions are welcome; see the GitHub README for community channels.

## Reading path

Recommended order:

1. **Orientation** (this page)
2. **Glossary** (canonical definitions) — [Glossary](Glossary.md)
3. **Core Model** (normative semantics and contracts) — [Core Model](Core%20Model.md)
4. **Runtime** (deployment behavior and constraints) — [Runtime](Runtime.md)
5. **Tooling** (build/test/debug/document workflows) — [Tooling](Tooling.md)
6. **Usage** (patterns and examples) — [Usage](Usage.md)
7. **Non-Normative** (ideas and inspiration) — [Non-Normative](Non-Normative.md)

## What jettl is

jettl is an interface-driven actor framework for LabVIEW, designed for building systems that remain understandable as they scale.

At a high level:

- Actors form a strict **tree** of relationships: `Self`, one `Parent`, and zero or more `Child` actors.
- Work is expressed as **messages** (defined by interfaces) that actors **tell** to each other.
- Runtime actors are often composed from multiple **actor layers** (decoration) that form a **unified actor**.

For definitions of these terms, see the [Glossary](Glossary.md). For the normative rules, see the [Core Model](Core%20Model.md).

## Goals

What jettl aims to enable for developers:

1. **Documentation** — documentation for actors and message contracts.
2. **Unit testing** — testable actors through composition and decoration.
3. **Visualization** — actor spawning and message-flow diagrams.
4. **Generation and maintenance** — standardized templates and automation.
5. **Refactoring** — support an agile, modular development style.

## Philosophy

- Assume you cannot control **message execution order**.  
  See the canonical contract in [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering).
- Prefer explicit contracts and static structure over emergent coupling.
- Prefer composition (interfaces + decoration) over inheritance.

## Constraints and non-goals

jettl is intentionally conservative about dependencies and editor features:

- No dependencies (outside of native LabVIEW).
- No circular dependencies.
- No password protection.
- No malleable VIs.
- No XNodes.
- RT compatible.
- PPL compatible.
- No diagram disable structures (use explicit structures instead).

> TODO: Confirm whether each constraint is a hard rule or a current implementation choice.
>
> - **No dependencies:** (Hard rule / Current choice)  
> - **No circular dependencies:** (Hard rule / Current choice)  
> - **No password protection:** (Hard rule / Current choice)  
> - **No malleable VIs:** (Hard rule / Current choice)  
> - **No XNodes:** (Hard rule / Current choice)  
> - **RT compatible:** (Hard rule / Current choice)  
> - **PPL compatible:** (Hard rule / Current choice)  
> - **No diagram disable structures:** (Hard rule / Current choice)

## Core mental model

A minimal mental model that makes the rest of the documentation easier:

- **Relationships are relative**, not address-based. Most developer code reasons in `Self`, `Parent`, and `Child`.
- **Messages are interface-driven**. A message method belongs to an interface; actors implement interfaces to handle messages.
- **Telling is explicit**. The caller chooses where the message goes (`Tell Self`, `Tell Parent`, `Tell Child`).
- **Layers compose**. A unified actor is an ordered stack of actor layers. Messages may recurse down the stack.

When you want detail:

- Definitions: [Glossary](Glossary.md)
- Normative semantics: [Core Model](Core%20Model.md)
- Patterns and examples: [Usage](Usage.md)

## Documentation and naming conventions

### LabVIEW virtual folder naming

![project-view-actor](../Images/project-view-actor.png)

> TODO: Fill in the recommended virtual folder layout below (this is documentation for how a *project* should look in LabVIEW).
>
> - **Core Actors/**:
> - **Edge Actors/**:
> - **Base Actor/**:
> - **Private Actors/**:
> - **Msgs/**:
> - **Private Msgs/**:
> - **Unified Msgs/**:
> - **(Other)**:

## Best practices

These are non-normative guidelines. When a guideline relies on a normative rule, the guideline links to the canonical section.

1. Develop business logic in a separate library and use that library in actor code. This decouples logic from the actor and improves testability.
2. Prefer default scheduling behavior. Use priority only when you also define the ordering model and acceptance tests.  
   See: [Scheduling and Priority](Runtime.md#scheduling-and-priority).
3. Name message methods with enough context (often ~3–4 words) to reduce naming collisions when overriding.
4. Do not split the central object wire, except in pure read methods (e.g., `Read X.vi`) that do not output the object.
5. Prefer calling functions and methods on palettes (treat palette functions as the public surface).  
   See: [Public API vs Internal Code](Tooling.md#public-api-vs-internal-code).
6. Manage reference lifetime explicitly: create and release references in the same actor whenever possible.  
   See the canonical rationale in [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership).

## Coding conventions

These are non-normative guidelines; the canonical style guide lives in [Tooling](Tooling.md).

- All Boolean logic is positive logic.
- `Read*` and `Write*` methods do only what their name implies: read or write with no additional behavior.

## Feedback questions

> TODO: Fill these in to calibrate how opinionated the docs should be.
>
> - **Primary user persona:** (Framework user / Framework contributor / Both)  
> - **Typical project scale:** (Small / Medium / Large)  
> - **Primary domain:** (TestStand, UI apps, embedded/RT, instrumentation, other)  
> - **What is the single most common failure mode you want jettl to prevent?**:
>
> TODO: If you have one “north star” example project, link it here.
>
> - **Example project (repo path or description)**:
