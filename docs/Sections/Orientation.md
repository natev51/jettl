# Orientation

These docs are written for LabVIEW developers seeking a proficient understanding of jettl.

## Status and Contributions

This is a living document. Contributions are welcome; see the GitHub README for contribution channels.

> **TODO:** Capture contribution workflow details here (keep it short and actionable).
>
> - **Where to file issues**:
> - **Preferred PR structure**:
> - **Style checks (if any)**:

## Reading Path

Recommended order:

1. **Orientation** (this page)
2. **Core Model** (normative semantics and contracts)
3. **Runtime** (execution behavior, scheduling, RT/PPL/executables)
4. **Tooling** (build/test/debug workflows)
5. **Usage** (patterns and examples)
6. **Non-Normative** (ideas, inspiration, and external references)

## Goals

What jettl aims to accomplish for developers:

1. **Documentation** — documentation for actors.
2. **Unit Testing** — testing on actors.
3. **Visualization** — actor spawning and messaging diagrams.
4. **Generation and Maintenance** — standardized templates.
5. **Refactoring** — support an agile development philosophy.

> **TODO:** Make each goal measurable (even roughly).
>
> - **Documentation success criteria**:
> - **Unit testing success criteria**:
> - **Visualization success criteria**:
> - **Generation/maintenance success criteria**:
> - **Refactoring success criteria**:

## Philosophy

- Always assume you cannot control the order that messages execute.
- Prefer explicit contracts and static structure over emergent coupling.
- Prefer composition (interfaces + decoration) over inheritance.

## Core Mental Model

- **Relative actor relations**: every actor has `Self`, one `Parent`, and zero or more `Child` actors.
- **Layering**: an *actor* is one layer; a *unified actor* is the composition of all layers.
- **Messaging**: messages are interface-driven; destinations are known at edit time via strongly-typed tell APIs.

For precise definitions, see [Terminology](Core%20Model.md#terminology).

## Lifecycle Symmetry

The lifecycle is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

For the normative stop contract, see [Lifetime Model](Core%20Model.md#lifetime-model).

## Feature Summary

- **Relative Actor Relations** — each actor has `Self`, one `Parent`, and N `Child` actors.
- **Address Abstraction** — actor addresses are abstracted away unless advanced testing requires them.
- **Hierarchical Messaging** — messages follow the actor tree (`Self`, `Parent`, `Child`).
- **Interface Composition and Decoration** — wrap actors dynamically via a common `Actor` interface.
- **By-Value Event Loop** — the central object wire flows through the event structure (by-value design).
- **Message Output** — messages can return outputs for layer-to-layer composition.
- **Transport Agnostic** — Queue, Event, and Notifier transports.
- **Statically Typed Messaging** — interfaces + analyzers support predictable relationships.
- **Child UID Mapping** — child UIDs are statically named and mapped internally.

## Constraints and Non-Goals

- No dependencies (outside of native LabVIEW).
- No circular dependencies.
- No password protection.
- No malleable VIs.
- No XNodes.
- RT compatible.
- PPL compatible.
- No diagram disable structures (use explicit structures instead).

> **TODO:** Add rationale for the top constraints (one sentence each).
>
> - **No dependencies rationale**:
> - **No circular dependencies rationale**:
> - **No password protection rationale**:
> - **No malleable VIs rationale**:
> - **No XNodes rationale**:
> - **No diagram disable structures rationale**:

## Documentation and Naming Conventions

### LabVIEW Virtual Folder Naming

![Project View for Actor being developed](../Images/project-view-actor.png)  
*Project view for an actor being developed.*

> **TODO:** Fill in the recommended virtual folder layout below.
>
> Keep this list stable; tooling and developer habits will align to it.

- **Actor library virtual folders**:
  - `Core Actors/`:
  - `Edge Actors/`:
  - `Base Actor/`:
  - `Private Actors/`:
  - `Msgs/`:
  - `Private Msgs/`:
  - `Unified Msgs/`:

> **TODO:** If any of these folders are optional, specify the rule.
>
> - **Optional folders**:
> - **When they appear**:

## Best Practices

These are non-normative guidelines.

1. Develop business logic in a separate library and use that library in actor code. This decouples logic from the actor and improves testability.
2. Prefer designs that do not rely on message ordering. If you introduce priority, also define ordering rules and acceptance tests (see [Scheduling and Priority](Runtime.md#scheduling-and-priority)).
3. Name message methods with enough context (often ~3–4 words) to reduce naming collisions when overriding.
4. Do not split the central object wire, except in pure read methods (e.g., `Read X.vi`) that do not output the object.
5. Prefer calling functions and methods on the palettes.
6. Manage reference lifetime explicitly: create and destroy references in the same actor whenever possible. For deeper rationale, see [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership).

> **TODO:** Add a “why it matters” sentence to each best practice.
>
> - **Best practice 1 rationale**:
> - **Best practice 2 rationale**:
> - **Best practice 3 rationale**:
> - **Best practice 4 rationale**:
> - **Best practice 5 rationale**:
> - **Best practice 6 rationale**:

## Coding Conventions

These are non-normative guidelines.

- All Boolean logic is positive logic.
- `Read*` and `Write*` methods should do only what their name implies: read or write with no additional behavior.

For the full style guide (icons, connector panes, access scope, wiring conventions), see [Readability and Style Guide](Tooling.md#readability-and-style-guide).

## Rationale Links

- Rationale for the Teller and Attributes libraries is documented under [Attributes](Core%20Model.md#attributes).

## Feedback Questions

> Answer these in-line as the docs evolve. Short answers are fine.

- **What is jettl in one sentence?**:
- **What is jettl not (one sentence)?**:
- **Top 3 reasons to choose jettl over other patterns/frameworks**:
- **Top 3 ways users misuse jettl today**:
- **What is the smallest “hello world” actor tree worth documenting?**:
- **What is the first “real” example you want new users to build?**:
- **What part of the mental model is hardest for new users?**:
- **Which terms are still ambiguous and need sharper definitions?**:
