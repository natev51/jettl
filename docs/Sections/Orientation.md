# Orientation

These docs are written for LabVIEW developers seeking a proficient understanding of jettl.

## Status and Contributions

This is a living document. Contributions are welcome; see the GitHub README for contribution channels.

> **TODO:** Keep this section short and actionable; it should be enough to onboard a first-time contributor in <10 minutes.

- **Where to file issues**: File issues here: https://github.com/natev51/jettl/issues
- **Preferred PR structure (suggested)**:
  1. **Problem statement** (what pain is being fixed?)
  2. **Change summary** (what changed, at a high level?)
  3. **Scope** (which docs / libraries / tools are affected?)
  4. **Verification** (VI Analyzer results, unit tests, or a short manual checklist)
  5. **Screenshots** (if UI or documentation visuals changed)
- **Style checks**:
  - Follow the [Readability and Style Guide](Tooling.md#readability-and-style-guide).
  - If a tool modifies VIs on disk, include a short note about rollback (e.g., “revert this commit”).

> **JUSTIFICATION**: The docs previously asked contributors questions (“can you suggest a PR structure?”). Replacing that with a concrete default reduces friction and improves consistency across contributions.

## Reading Path

Recommended order:

1. **Orientation** (this page)
2. **Glossary** (canonical terminology; read once, reference often)
3. **Core Model** (normative semantics and contracts)
4. **API Reference** (what to call; stability labels)
5. **Runtime** (execution behavior, scheduling, RT/PPL/executables)
6. **Tooling** (build/test/debug workflows)
7. **Usage** (patterns and examples)
8. **Non-Normative** (ideas, inspiration, and external references)

## Goals

What jettl aims to accomplish for developers:

1. **Documentation** — documentation for actors and messaging.
2. **Unit Testing** — testing on actors and their associated messages.
3. **Visualization** — actor spawning and messaging diagrams.
4. **Generation and Maintenance** — standardized templates.
5. **Refactoring** — support an agile development philosophy to refactor safely and frequently.

### Measuring Progress (Suggested)

> **TODO:** Replace the “suggested” targets below with your actual targets once you have baseline results.

- **Documentation success criteria (suggested)**:
  - Given an actor library, tooling can produce a page that lists:
    - the actor’s public messages (by interface),
    - the actor’s outbound tells (Self/Parent/Child),
    - and the actor’s spawn relationships (child aliases).
- **Unit testing success criteria (suggested)**:
  - Each shipped example or reusable actor has at least one automated test project (desktop target) that runs headless.
- **Visualization success criteria (suggested)**:
  - For an actor tree, tooling can generate a diagram that is stable across runs (diff-friendly output).
- **Generation/maintenance success criteria (suggested)**:
  - Creating an actor + creating a message are both template-driven and take <2 minutes of manual wiring.
- **Refactoring success criteria (suggested)**:
  - Rename/rescript operations are repeatable, and changes remain VI Analyzer clean.

> **JUSTIFICATION**: These criteria convert “goals” into outcomes you can validate over time without committing to exact numbers before you have a baseline.

## Philosophy

- Always assume you cannot control the order that messages execute.
- Prefer explicit contracts and static structure.
- Prefer composition of interfaces (dependency inversion) and decoration over class-based inheritance.

## Core Mental Model

- **Relative actor relations**: every actor has `Self`, one `Parent` (if not the `Root`), and zero or more `Child` actors.
- **Layering**: an actor is one layer; a unified actor is the composition of all layers.
- **Messaging**: messages are interface-driven; destinations are chosen explicitly via strongly-typed tell APIs.

For precise terminology, see the [Glossary](Glossary.md).


## Working Principles

These are the currently assumed architectural principles. Treat them as the working baseline; if any are incorrect, update the docs where the principle is canonically owned (Glossary/Core Model/Runtime/Tooling).

> **JUSTIFICATION**: These principles were previously implicit. Making them explicit helps new users build the right mental model early and highlights where the contract is intentionally conservative (e.g., no ordering guarantees).

1. The actor tree is strict and hierarchical.
2. Messaging is interface-driven.
3. Destinations are chosen explicitly (`Self`, `Parent`, `Child`).
4. Ordering is not guaranteed (design assuming out-of-order execution).
5. `Stop` is intended to be idempotent in effect (first stop initiates shutdown; subsequent stops do not “restart” or “double stop”).
6. The error wire must not be used for serialization (see [Serialization and Error Wires](Core%20Model.md#serialization-and-error-wires)).
7. Reference ownership should be local to the creator whenever practical (see [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership)).
8. Decoration is preferred over inheritance for actors.
9. Core Actors and Edge Actors are persistent layers under a Root.
10. jettl avoids: XNodes, malleable VIs, circular dependencies, and diagram disable structures.

For unsettled areas, see [Known Architectural Open Questions](Non-Normative.md#known-architectural-open-questions).
## Lifecycle Symmetry

The lifecycle is expressed as symmetric pairs:

- **Spawn** / **Stopped**
- **Setup** / **Teardown**
- **Start** / **Stop**

For the normative stop contract, see [Lifetime Model](Core%20Model.md#lifetime-model).

## Feature Summary

- **Relative Actor Relations** — each actor has `Self`, one `Parent` (if not the `Root`), and N `Child` actors.
- **Address Abstraction** — actor addresses are abstracted away through the Transport interface.
- **Hierarchical Messaging** — messages follow the actor tree (`Self`, `Parent`, `Child`).
- **Interface Composition and Decoration** — wrap actors dynamically via the common `Actor` interface.
- **By-Value Event Loop** — the central object wire flows through the event structure (by-value design); avoid branching the object wire.
- **Message Output** — messages can return outputs to transfer information across layers without re-computation.
- **Transport Agnostic** — Queue and Event transports.
- **Statically Typed Messaging** — interfaces + analyzers support static relationships known at edit time via strongly-typed tell APIs.
- **Child Alias Mapping** — child aliases are statically named and mapped internally for convenience of Child Actor messaging.

## Constraints and Non-Goals

- No dependencies (outside of native LabVIEW).
- No circular dependencies.
- No password protection.
- No malleable VIs.
- No XNodes.
- RT compatible.
- PPL compatible.
- No diagram disable structures (use explicit structures instead).

### Rationale (One Sentence Each)

- **No dependencies**: keep installation friction low and keep build graphs predictable.
- **No circular dependencies**: preserve long-term maintainability; circular coupling makes refactoring brittle.
- **No password protection**: make the framework readable and auditable for teams adopting it.
- **No malleable VIs**: avoid known build/tooling friction in packaged and executable deployments.
- **No XNodes**: avoid build and distribution fragility.
- **No diagram disable structures**: disabled code often hides broken diagrams until late in the build/release process.

> **JUSTIFICATION**: The rationale previously existed as partial notes; rewriting it into consistent one-sentence explanations makes constraints understandable without turning Orientation into a deep design treatise.

## Documentation and Naming Conventions

Documentation structure, virtual folder conventions, and image rules are maintained in [Tooling](Tooling.md#documentation-maintenance).

> **JUSTIFICATION**: These conventions are part of the developer workflow (Tooling’s canonical responsibility). Orientation now links to the canonical section instead of duplicating the details.

## Best Practices

These are non-normative guidelines.

1. Develop business logic in a separate library and use that library in actor code. This decouples logic from the actor and improves testability for the separate library, independent of the framework.
2. Prefer designs that do not rely on message ordering. If you introduce priority messaging, also define ordering rules and acceptance tests (see [Scheduling and Priority](Runtime.md#scheduling-and-priority)).
3. Name message methods with enough context (often ~3–4 words) to reduce naming collisions when overriding message methods in actors.
4. Do not split the central object wire, except in pure read methods (e.g., `Read X.vi`) that do not pass through the input object to the output.
5. Prefer calling functions and methods from the palettes. Many VIs are public only because they are required by templates; treat the [API Reference](API%20Reference.md) as the canonical map for what is intended to be called directly.
6. Manage reference lifetime explicitly: create and destroy references in the same actor whenever possible. For deeper rationale, see [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership).

### Why It Matters (Rationale)

- **Best practice 1 rationale**: If a PID algorithm is developed, the associated objects and function calls should be in their own API, and tested for that library. Then that PID library can be implemented in the actor by use of composition of interfaces or calling functions.
- **Best practice 2 rationale**: Assume that messages will arrive in any order and design the actor with this in mind. At any point in the actor’s lifetime it may receive any message, including ones it does not implement.
- **Best practice 3 rationale**: Naming collisions happen most often with generic names. For example, messages cannot be named `Setup jettl Msg` because `Setup.vi` already exists as a lifecycle override. Specific names reduce collisions and reduce refactor churn later.
- **Best practice 4 rationale**: Maintain actor state on the central object wire; branching it undermines the by-value design and makes state evolution harder to reason about.
- **Best practice 5 rationale**: Template-support VIs may be public for technical reasons; using only palette/API-reference entry points reduces accidental coupling to internals.
- **Best practice 6 rationale**: References created in a parent but used in a child do not have a guaranteed lifetime from the child’s perspective. Because actors are asynchronous, the child cannot assume the parent will outlive the reference.

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

> Answer these in-line as the docs evolve. Short answers are fine.

- **What is jettl in one sentence?**: A modern actor model implementation in LabVIEW that enables strict messaging and dynamic wrapping (decoration) of actor layers.
- **What is jettl not (one sentence)?**: A synchronous call/return framework or a general-purpose message broker; it is an asynchronous actor model with explicit hierarchical destinations.
- **Top 3 reasons to choose jettl over other patterns/frameworks**: strict message routing known at edit time, dynamic wrapping of actor layers, and interface-driven APIs that enable tooling (documentation/testing/refactoring).
- **Top 3 ways users misuse jettl today**: relying on message ordering, sharing mutable references across actors without ownership rules, and implementing “helper loops” instead of splitting concerns into actors.
- **What is the smallest “hello world” actor tree worth documenting?**: One actor layer wrapping the Base Actor, with a single message (or UI action) that tells `Stop` and observes `Stopped`.
- **What is the first “real” example you want new users to build?**: Continuous logging and measurement with mock objects (desktop), then swap mocks for real implementations.
- **What part of the mental model is hardest for new users?**: Layering (unified actor vs actor layers) and the consequences of “no ordering guarantees”.
- **Which terms are still ambiguous and need sharper definitions?**: Core vs Edge actor layers, what “priority” guarantees (if anything), and what behavior is transport-specific vs transport-invariant.
