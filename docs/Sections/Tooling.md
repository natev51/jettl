# Tooling

This document covers build, package, debug, test, document, and maintain workflows for jettl-based systems.

Normative semantics are defined in the [Core Model](Core%20Model.md). This page is mostly **guidelines** and **practices**.

## Public API vs internal code

A consistent contributor workflow depends on a clear distinction between:

- **Public API**: what users are expected to call (palettes, documented VIs, stable interfaces).
- **Internal code**: implementation details that may change.

Guidelines:

- Prefer calling functions and methods from palettes.
- If a VI is not on a palette and not referenced by the [API Reference](API%20Reference.md), treat it as internal.

> TODO: Define the stability policy in one place.
>
> - **What counts as public API**:
> - **What counts as internal**:
> - **How breaking changes are communicated**:

## Tools

### Notes for all tools

All external tools belong in the same common location:

- `Tools/`
  - `jettl Tools/`
    - `YOURNAME/`
      - `YOURTOOLNAME/`

This helps developers find tools quickly and consistently.

Additional notes:

- Tools may operate on dependencies, but only those selected under the specified target.
- Tools SHOULD support PPL workflows.

> TODO: Confirm whether “PPL support” is a hard requirement for every tool.
>
> - **Hard requirement? (Yes/No)**:
> - **If yes, what does “PPL support” mean for a tool**:
> - **How tooling is validated**:

### Current native tools

#### Rescript

How to use:

- Only the two left inputs can be scripted.
- Only the two right outputs can be scripted.

Future cleanup note:

- `Script Msg.vi` could auto-clean wires by invoking `Clean Up Wire` (Invoke Node + wire reference).

> TODO: Document Rescript’s exact scope (what it modifies and what it refuses to modify).
>
> - **Inputs supported**:
> - **Outputs supported**:
> - **Connector pane requirements**:
> - **Failure modes**:

#### Rename

Rename tool ideas/requirements:

- Add a feature to include dependencies.
- Add an option to include or exclude `.ctl` changes.

> TODO: Define the Rename tool contract.
>
> - **What it renames**:
> - **What it never renames**:
> - **Dependency behavior**:
> - **How it handles typedefs**:

#### Template

> TODO: Describe the template generator outputs.
>
> - **Actor template name pattern**:
> - **Message template name pattern**:
> - **Where templates are placed in the project**:
> - **How scoping rules are enforced**:

### Current external tools

> TODO: List external tooling that jettl depends on or integrates with.
>
> - **Tool name**:
> - **Purpose**:
> - **Link**:

### Tool ideas

The subsections below capture design exploration for future tools.

#### Moving message and actor libraries

Tool idea: move actors and messages on disk and in project explorer into the correct destination:

- into a Private Msg folder for an actor, or
- out of any library to the top-level target.

Notes/questions:

- Creating an actor after an actor has already been created may imply the new actor must be placed in the private folder for the existing actor.
- Messages might be created:
  1. at the project level (standalone),
  2. in the Private Msg folder of an actor library, or
  3. in the Public Msg folder of an actor library.

This raises naming and coupling questions.

> TODO: Decide the allowed creation locations for messages.
>
> - **Standalone messages allowed? (Yes/No)**:
> - **If yes, what are the constraints (naming, scoping, packaging)**:
> - **If no, how do you prevent the tool from creating them**:
>
> TODO: Decide the message visibility categories.
>
> - **Private internal message**:
> - **Fully public message**:

#### Forward message tool

A tool that generates a forwarding message, allowing a parent to forward a message to a child.

> TODO: Define the exact generated artifact.
>
> - **Generated message name pattern**:
> - **Where the message lives**:
> - **How forwarding preserves typed destinations**:

#### Generate implemented messages documentation

Idea: generate “Implemented Messages” documentation for an actor.

Approach:

- Hash all message methods (destination: Self/Parent/Child + interface method signature).
- Compare hashed signatures against the actor’s implemented methods.
- Output a view with:
  - methods implemented by each actor layer
  - union of methods implemented by the unified actor
  - explicit destination constraints

> TODO: Decide where this artifact lives and how it is consumed.
>
> - **Output format (Markdown/HTML/UI)**:
> - **Storage location**:
> - **How it stays up to date**:

#### Un-generate implemented messages

Tool idea: undo generated artifacts cleanly.

> TODO: Define what “un-generate” means (delete files, revert VIs, etc.).
>
> - **Artifacts removed**:
> - **Safety checks**:

#### Message destination viewer

Idea: a tool that lets you select an actor and visualize which messages it can:

- implement
- tell to Self
- tell to Parent
- tell to each Child UID

See also canonical constraints in [Strongly-typed message destinations](Core%20Model.md#strongly-typed-message-destinations).

> TODO: Choose a first UI for this tool.
>
> - **UI form (tree, matrix, graph)**:
> - **Minimum viable feature set**:
> - **How it handles large projects**:

#### PPL conversion tool

Tool idea: convert a project or library into a PPL-friendly structure.

> TODO: Define conversion scope.
>
> - **Inputs**:
> - **Outputs**:
> - **What it refuses to modify**:

#### Error generation tool

Tool idea: create errors inside a target folder.

> TODO: Define how error codes are allocated and how duplicates are prevented.
>
> - **Error code allocation strategy**:
> - **Collision detection**:
> - **Doc updates (Error catalog)**:

#### Reference tools

Tool idea: tools that help manage refnum usage patterns.

- Replace ref clusters with explicit wiring where possible.
- Audit ref lifetime ownership (link to canonical rule: [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership)).

> TODO: Define which ref patterns you want to discourage.
>
> - **Ref cluster usage discouraged? (Yes/No)**:
> - **Allowed ref patterns**:
> - **Tool enforcement strategy**:

#### Navigating message methods

Tool idea: click from a message interface method to all implementing actors, and from an actor to all message methods it implements.

> TODO: Define navigation entry points.
>
> - **From interface → implementations**:
> - **From actor → implemented interfaces**:
> - **From tell site → destination actor**:

#### Actor browser

Tool idea: browse actor hierarchy and locate spawn sites.

> TODO: Define the actor browser features.
>
> - **Hierarchy view**:
> - **Spawn-site links**:
> - **Filtering/search**:

## VIPM

This library is compatible with **LabVIEW 2020 and later**.

Note: if using LabVIEW 2020, consider using **LabVIEW 2020 SP1** due to bug fixes:
- [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html)

> TODO: Confirm the supported LabVIEW version policy and where it is enforced.
>
> - **Minimum supported version**:
> - **Maximum tested version**:
> - **RT constraints**:

## Debug

### Debug with probes

Idea: hierarchy-aware debug tooling that links to custom probes before running, enabling inspection of how data changes across reentrant VIs.

> TODO: Specify how probes are discovered and displayed.
>
> - **Probe discovery mechanism**:
> - **Where probe UIs appear**:
> - **How probes are attached**:

### DETT debug actor layer

Idea: a `DETT Debug jettl Actor` layer.

Possible approach:

- In `Spawn.vi`, if `Root = TRUE`, start an async process that receives data by reference.
- Because all actors spawned under the Root share this persistent core layer, each actor registers into the debug layer.
- The outermost actor can be detected by inspecting the unified actor stack length.

Note:

- DETT trace data cannot be captured from VIs in `vi.lib`.

> TODO: Decide whether DETT integration is a first-class feature.
>
> - **Feature priority**:
> - **Minimum DETT artifacts desired (UML/sequence/trace)**:
> - **How it is enabled/disabled**:

### Advanced wrapping for testing/debugging

Since `Actor.vi` is not itself a decorator method, only the outermost local actor’s `Actor.vi` executes.

An advanced wrapping scheme can place the actor decorator method within wrapping layers, allowing only DD methods outside of `Actor.vi` to execute. This can enable advanced debugging and testing functionality.

> TODO: Clarify whether you want to rely on this scheme or treat it as an internal trick.
>
> - **Publicly supported? (Yes/No)**:
> - **If yes, how is it documented and tested**:

### Base debug actor (event logger)

Idea: an event logger that creates a separate file per actor in a central temp application directory, and logs timestamps with a call chain / object hierarchy.

Rationale:

- separate files avoid resource contention (no shared writer)
- logs are easier to attribute per actor

Additional idea:

- incorporate a “Ping” message and intermediate debug libraries.

At runtime, messages can be inspected in `Call Inspect.vi` and timestamped.

> TODO: Specify the log format and retention policy.
>
> - **Log format (JSON/TDMS/text)**:
> - **File naming scheme**:
> - **Retention strategy**:
> - **How logs are correlated across actors**:

## Unit tests

Framework and ecosystem options mentioned:

- Caraya
- LUnit

### Approval tests

Approval tests can work well when you can generate stable artifacts.

> TODO: Define the approval artifact(s) you want (and how they are generated).
>
> - **Artifact type**:
> - **How it is generated**:
> - **How diffs are reviewed**:

### Generated test panel

A tool-generated test panel is feasible:

- an event structure with buttons for all messages the actor expects
- the panel listens and displays payloads (serialized) from all methods defined in any interfaces the actor exposes

### Decorating with a unit test actor

Because jettl is interface-composition based with the decorator pattern, unit testing can be implemented by decorating one of the core actors with a unit test actor.

### Logging actor state before/after method execution

A wrapper actor can log:

- actor object before execution
- inputs
- actor object after execution

This can identify potential test cases.

Note:

- A DD output terminal on `Actor.vi` prevents the object wire from changing at runtime.

> TODO: Decide whether the `Actor.vi` DD output is part of the official testing contract.
>
> - **Is it required? (Yes/No)**:
> - **If required, how is it enforced**:
> - **If optional, how is it documented**:

## Documentation

### Actor/message documentation

Use `Tell Self.vi`, `Tell Parent.vi`, and `Tell Child.vi` to visualize messages between actors because jettl requires the destination relationship to be known at edit time.

Goal:

- point a tool at an actor
- statically analyze
- create a diagram for each actor showing message relationships

Potential integrations:

- AntiDoc integration
- message method browser
- message destination browser
- actor spawning hierarchy (spawn tree)
- message browser

Diagrams could be built by:

- static analysis of code, or
- analysis of DETT output

> TODO: Pick the first “documentation generator” feature.
>
> - **Feature**:
> - **Output format**:
> - **How it is validated**:

### Tell Child destination problem

Because spawning children is dynamic, extra steps are required to understand where `Tell Child.vi` messages go.

A static approach:

- locate calls to `Tell Child.vi`
- resolve the target child by tracing the input back through a `Format Into String` primitive wired from the `Child UIDs` enum

This lets tooling determine the destination name statically, so it’s clear where the message will be told at runtime.

Constraints:

- this only works when the destination string is a straightforward `Format Into String` + enum pattern
- if the string is modified elsewhere, built dynamically, or selected via conditional logic, the tool cannot reliably infer the destination

Guideline:

- keep routing as static as possible when you want tooling to infer destinations

## Readability

This section is a style guide. It is non-normative but strongly recommended for long-term maintainability.

### No helper loops

Instead of helper loops, spawn a child actor. This maintains a single loop within an actor and avoids branching the actor object into multiple loops.

Use Private Actor virtual folders to keep tightly coupled helper actors inside the main actor library.

### No property nodes (guideline)

Property nodes are discouraged in jettl code. One motivation: property nodes can obscure visual cues like banner colors.

Reference: [Using a Message Broker with DQMH Actors for High Speed/Throughput Data logging](https://www.youtube.com/watch?v=jNBAvNQJyO8&list=PLvDxiIkwuMQvrSQIqy_it5Q7-sGvM4XX8&index=3) @7:33

> TODO: Clarify the exact policy on property nodes (hard ban vs “avoid when possible”).
>
> - **Policy**:
> - **Allowed exceptions**:

### Nested libraries rationale

Each nested library defines its own access scope, which can hide internal components from the public surface and reduce namespace collisions.

### Avoid inheritance for actors

Fundamentally, class inheritance should not occur for actors.

Instead, use dependency inversion with strategies to select implementations without introducing inheritance coupling.

### Defaults for new VIs

Default function:

- icon: Ctrl+Shift+K, left-justified, not capital, red text
- access scope: private
- connector pane: error out
- reentrancy: shared clone

Default static dispatch method:

- icon: Ctrl+Shift+K, left-justified, not capital, red text
- access scope: private
- connector pane: object in, error out
- reentrancy: shared clone

Default dynamic dispatch method:

- icon: Ctrl+Shift+K, left-justified, not capital, black text
- access scope: public (required for DD)
- connector pane: object in, error out
- reentrancy: shared clone

### Connector pane conventions

Reserved terminals:

- **Object I/O (class/interface terminals)**: top-left and/or top-right
- **Error I/O**: bottom-left and/or bottom-right
- **Typical inputs**: left middle and/or bottom middle terminals
- **Outputs**: right middle terminals
- **Object-specific inputs**: top middle inputs for functions/methods that wrap object-specific behavior

If a function has an output object, it SHOULD be wired by the developer.

> TODO: Define the analyzer rule to enforce connector pane reservation and wiring.
>
> - **Reserved terminal types (object/error)**:
> - **How to detect violations**:
> - **Rule exceptions (if any)**:

References:

- [An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k) @23:59
- [Your LabVIEW Code Is a Work of Art... But I Can't Read It - Darren Nattinger (GDevCon N.A. 2024)](https://www.youtube.com/watch?v=AHOZ7fiuWCA) @45:21

### Virtual folders

Virtual folders are not saved on disk; they exist for organization in the LabVIEW project.

They help keep namespacing consistent.

Reference: [Large LabVIEW Project Development Techniques](https://youtu.be/7zS3Q_K71XY?si=VZXcWRaCqc0C4tWh) @14:08–14:46

### Color scheme

Banner colors enable quick identification of libraries/interfaces/classes and help verify object-wire ownership visually.

Reference: [Your LabVIEW Code Is a Work of Art... But I Can't Read It - Darren Nattinger (GDevCon N.A. 2024)](https://www.youtube.com/watch?v=AHOZ7fiuWCA) @40:34

jettl coloring scheme:

- Purple Library: RGB (166,153,182)
- Blue Interface: RGB (104,136,190)
- Green Class: RGB (110,149,108)

Memory aid:

> “Look down at the green grass, look up to the blue sky, and look further to the purple galaxy.”

### Icons

Banner:

- shows library/interface/class name
- banner name text color indicates access scope
- banner color indicates the container type
- method name text
- method name text color indicates access scope of the method

### Function vs method terminology

- A **function** is a VI that does not have object I/O for the containing object.
- A **method** is a VI that has one or both object I/O terminals for the containing object.

### Access scope rules

Guidelines:

- Prefer only public and private.
- Interfaces, classes, and methods use banner text color:
  - black = public
  - red = private

Classes:

- private data icons should typically be blank; if something is added, private text should be red.

Encapsulation guidance:

- Classes are often marked private to the containing library to force dependency inversion through interfaces.
- Only functions and interfaces should be exposed publicly when possible.

Rules:

- Interfaces and classes must be contained in at least one library.
- Public methods/functions should be limited to the actor API surface (messages + actor API methods).
- Helper VIs should be private.

### Mutability and wiring conventions

If the same object type comes in and is passed out horizontally, callers should assume that object may have been mutated (even if it was not).

This applies most often to:

- class/interface wires (top-left → top-right)

If you need sequencing, use an explicit sequencing construct (flat sequence / case structure). Do not rely on error wiring as a sequencing mechanism; see the canonical contract:

- [Error Model → Serialization and Error Wires](Core%20Model.md#serialization-and-error-wires)
