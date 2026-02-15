# Orientation

This page establishes the mental model and reading path for jettl.

If you landed here from the repo root, you may prefer to start at the docs index: [jettl Documentation](../jettl%20Documentation.md).

## Reading path

Recommended top-down order:

1. **Orientation** (this page)
2. **Glossary** (canonical definitions): [Glossary](Glossary.md)
3. **Core Model** (normative contracts): [Core Model](Core%20Model.md)
4. **Runtime** (deployment + performance): [Runtime](Runtime.md)

Side doors (jump in when you need a “what do I call?” map or a workflow):

- [API Reference](API%20Reference.md)
- [Tooling](Tooling.md)
- [Usage](Usage.md)
- [Non-Normative](Non-Normative.md)


## Goals

What jettl aims to accomplish for developers:

1. **Documentation** — actor and message documentation that is easy to keep in sync.
2. **Unit testing** — unit testing built into the actor layering model.
3. **Visualization** — actor spawning and messaging diagrams.
4. **Generation and maintenance** — standardized templates and scripting tools.
5. **Refactoring** — a workflow that supports continuous change without drift.

## Lifecycle symmetry (pointer)

The lifecycle is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

Canonical contract: see [Core Model → Lifetime Model](Core%20Model.md#lifetime-model).

## Feature summary (high level)

- **Relative actor relations** — each actor has `Self`, one `Parent`, and N `Child` actors.
- **Address abstraction** — actor addresses are abstracted away unless advanced testing requires them.
- **Hierarchical messaging** — messages follow the actor tree (`Self`, `Parent`, `Child`).
- **Interface composition and decoration** — actors are wrapped dynamically via a common `Actor` interface.
- **By-value event loop** — the central object wire flows through the event structure (by-value design).
- **Message output** — messages can return outputs for layer-to-layer composition.
- **Transport agnostic** — Queue, Event, and Notifier transports.
- **Statically typed messaging** — interfaces + analyzers support predictable relationships.
- **Child UID mapping** — child UIDs are statically named and mapped internally.


## What is jettl?

> TODO: Write a public, one-sentence definition.
>
> - **jettl is:**

> TODO: Write the complementary “what jettl is not” sentence.
>
> - **jettl is not:**

## Core mental model

- **Relative relations**: every actor has `Self`, (usually) one `Parent`, and zero or more `Child` actors.
- **Layering**: a unified actor is the composition of multiple actor layers.
- **Messaging**: messages are interface-backed, and destinations are expressed via strongly typed tell APIs.

Canonical term definitions live in the [Glossary](Glossary.md).

## Design philosophy (high level)

- Assume you cannot control message execution order.
- Prefer explicit contracts and static structure.
- Prefer composition (interfaces + decoration) over inheritance.

See: [Core Model → Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering).

## Constraints and non-goals

These are project-level constraints that influence design and tooling:

- No dependencies (outside of native LabVIEW).
- No circular dependencies.
- No password protection.
- No malleable VIs.
- No XNodes.
- RT compatible.
- PPL compatible.
- Avoid diagram disable structures (prefer explicit structures instead).

> TODO: Add a one-sentence rationale for each constraint (keep them crisp).
>
> - **No dependencies rationale:**
> - **No circular dependencies rationale:**
> - **No password protection rationale:**
> - **No malleable VIs rationale:**
> - **No XNodes rationale:**
> - **Avoid diagram disable structures rationale:**

## How to use these docs

- Treat **Core Model** as the authoritative contract.
- Treat **Runtime** as the authoritative source for deployment behavior.
- Treat **Glossary** as the authoritative source for terminology.

When you respond to TODO questions, use:

```markdown
> **RESPONSE:** ...
```

## First success path (new user)

> TODO: Define the “30 minutes / 2 hours / 2 days” onboarding tasks.
>
> - **In 30 minutes, a new user can:**
> - **In 2 hours, a new user can:**
> - **In 2 days, a new user can:**

## Best practices (pointer list)

This page intentionally avoids deep guidance. Canonical best practices live in:

- [Usage](Usage.md)
- [Tooling → Readability and Style Guide](Tooling.md#readability-and-style-guide)
- [Core Model → Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership)
