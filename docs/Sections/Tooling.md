# Tooling

This document covers the developer workflow for jettl: scripting tools, packaging, debugging, testing, documentation generation, and the shared readability/style conventions used across the codebase.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Documentation Maintenance

This section is for contributors maintaining the documentation set itself (structure, ownership, and style rules).

> **JUSTIFICATION**: These rules previously lived outside the docs. Bringing them into *Tooling* makes them discoverable and keeps “how to work on the project” in one canonical place.

### Repository Structure

```text
README.md
docs/
  ├── jettl Documentation.md
  ├── Images/
  └── Sections/
        ├── Orientation.md
        ├── Glossary.md
        ├── Core Model.md
        ├── Runtime.md
        ├── Tooling.md
        ├── Usage.md
        ├── API Reference.md
        └── Non-Normative.md
```

### Image Rules

- Files in `docs/Sections/` use:

  ```markdown
  ![image-name](../Images/image-name.png)
  ```

- `docs/jettl Documentation.md` uses:

  ```markdown
  ![image-name](Images/image-name.png)
  ```

- `README.md` uses:

  ```markdown
  ![image-name](docs/Images/image-name.png)
  ```

**Alt text rule:** for repository images, the alt text MUST match the filename base exactly (e.g., `actor-ppl` for `actor-ppl.png`).

### Canonical Ownership Map

Each concept has exactly one canonical “owner page”. Avoid duplicating definitions or contracts across pages.

| Concept Type | Canonical Owner |
| --- | --- |
| Terminology / Definitions | `Glossary.md` |
| Normative contracts (actors, messaging, lifetime, errors, attributes, reentrancy) | `Core Model.md` |
| Deployment constraints (RT, PPL, executables, benchmarking, scheduling implementation) | `Runtime.md` |
| Developer workflows, tooling, style rules | `Tooling.md` |
| Patterns and example architectures | `Usage.md` |
| Backlog ideas / inspiration / speculative concepts | `Non-Normative.md` |
| Public API surface map | `API Reference.md` |
| Reading path and mental model | `Orientation.md` |
| Public landing page | `README.md` |

### Terminology Discipline

- Use **tell**, never “send”.
- Definitions live in `Glossary.md`. Other pages should link to the glossary instead of redefining terms.

### Collaboration Protocol for Doc Changes

When making a documentation change, include brief inline rationale using:

```markdown
> **JUSTIFICATION**: why the change was made.
```

Keep justifications close to the change they explain.

## LabVIEW Virtual Folder Naming

![project-view-actor](../Images/project-view-actor.png)  
*Project view for an actor being developed.*

Above is a recommended virtual folder structure for an actor library. This layout is intentionally stable so tooling and developer habits can align to it.

> **JUSTIFICATION**: This content previously lived in *Orientation*. It is part of “how we organize and maintain code”, which is canonical Tooling territory.

### Recommended Virtual Folder Layout (Actor Library)

- `Actor Overrides/Variant/Extended`  
  Best practice to quickly find actor overrides. Place modified lifecycle methods here so “what changed” is visible at a glance.
- `Msg Overrides/`  
  Best practice to quickly find message overrides (implemented interface message methods).
- `Private Actors/` (optional)  
  Supporting actors tightly coupled to the containing actor library (kept private so they cannot be reused accidentally).
- `Private Msgs/` (optional)  
  Self-messages or tightly-coupled message libraries kept private to the containing actor library.

## Tools

### Notes for All Tools

- All external tools belong in the same common location: `Tools -> jettl Tools`.
  - If a tool is company/name specific and credit should be preserved, place it under a subfolder, for example: `Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME`.
- Tool scripting cannot change items in the dependencies. Only those selected under the chosen target are affected (e.g., **My Computer** or an **RT Target**).
- **Requirement:** tools MUST support PPL workflows. This is being actively developed.

> **TODO:** Tool UI improvement idea:
>
> - **Show the on-disk path in the tree view (right side column)**

### Minimum Tool Quality Bar

A jettl tool is considered “shippable” when it meets the following baseline expectations:

- **Supports PPL workflows**  
  - Tool operates on source (unpacked) projects and treats PPL outputs as read-only artifacts.
  - Tool does not require PPLs to be present to operate on source code.
- **Supports source-distribution (non-PPL)**  
  - Tool works on a standard LabVIEW project containing libraries/classes in source form.
- **Does not break VI Analyzer**  
  - Tool output should remain VI Analyzer clean (or include a known, documented exception list).
- **Can be run on a project subset**  
  - Tool can target selected libraries/actors instead of requiring a whole-project run.
- **Dry-run mode (when applicable)**  
  - Tool can report intended changes without applying them (especially important for rename/move tools).
- **Undo/rollback strategy**  
  - Tool produces a change report (what moved/renamed/scripted) so reverting is straightforward (typically via source control).

> **JUSTIFICATION**: The previous text asked for “examples and ideas”. This converts that request into a concrete acceptance bar that can later be refined.

## Current Native Tools

### Rescript

How to use:

- Only the left two inputs on the interface method can be scripted.
- Only the right two outputs on the interface method can be scripted.

Future cleanup idea in `Script Msg.vi`:

- Clean up wire via invoke node: `Wire -> CleanUpWire`.

> **TODO:** Document:
>
> - **Tool location (palette + on-disk)**:
> - **Supported connector panes**:
> - **Common failure modes**:
> - **Examples (before/after)**:

### Rename

Actor and message renaming:

- Takes the library(s) and properly puts them in a hierarchical map where the names are unique depending on their path/hierarchy of library(s).

> **TODO:** Document:
>
> - **Scope of rename (actor only / msg only / both)**: Both are available.
> - **How uniqueness is determined**: Path + name.
> - **How collisions are resolved**: Collisions cannot occur due to the tool checking preexisting names and paths before a rename is applied.
> - **What is *not* renamed (examples)**:
>   - Items in dependencies (PPLs, `vi.lib`, reuse libraries) are not modified.
>   - Built artifacts (PPL outputs, executables) are not modified.
>   - Documentation text is not modified unless you explicitly opt into a docs-update mode (if added later).

### Template

> **TODO:** Fill in the template tool behavior.
>
> - **What it generates**: Template for the actor or msg.
> - **Where it places files**: In the project's directory (intentionally fixed to keep repo layout consistent).
> - **How it picks names**: Defaults to `TEMPLATE`.
> - **How it handles existing items**: If the name already exists in memory, the TEMPLATE cannot be created due to a validation check.

## Current External Tools

None


## Tooling Vision

Tools either implemented or envisioned:

- Rescript
- Rename
- Template generator
- Implemented message generator
- Message destination viewer
- Actor browser
- PPL conversion tool
- Debug layer (DETT integration)
- Test panel generator
- Documentation generator

Unclear items (to resolve in the docs/tooling roadmap): which tools are production-ready vs exploratory.

> **TODO:** Maintain a simple maturity table once tool status is known.
>
> | Tool | Status (Production / Beta / Idea) | Notes |
> |---|---|---|
> | Rescript | : | : |
> | Rename | : | : |
> | Template generator | : | : |
> | Implemented message generator | : | : |
> | Message destination viewer | : | : |
> | Actor browser | : | : |
> | PPL conversion tool | : | : |
> | Debug layer | : | : |
> | Test panel generator | : | : |
> | Documentation generator | : | : |

> **JUSTIFICATION**: This list existed as an assumed roadmap outside the docs. Capturing it here makes tooling direction visible and gives a single place to track maturity decisions.
## Tool Ideas

> Sections under **Tool Ideas** are non-normative.

### Moving Msg and Actor Libraries

Moving actors and msgs on disk, and also in Project Explorer into the correct destination:

- into `Private Msgs` folder of an actor, or
- out of any library to the top level target.

Messages creation questions:

- Maybe a message can ONLY be created after an actor has been created and must be placed in either the public or private folder?
- If messages can be standalone (no coupling to an actor), where do they live to avoid namespacing issues?

Possible template msg placement options:

1. In the project under target
2. Private msg virtual folder of actor library
3. Public msg virtual folder of actor library

Actor creation has similar options. Idea: Only one top-level actor library can be in a project. Creating an actor in the same project after an actor has already been created can only be placed in the private folder for the actor already created.

Message classification idea:

1. Private internal message
2. Fully public message

### Forward Msg

Since an actor can access its parent’s parent relation (and so forth), use `Read Root.vi` to determine whether a parent (grandparent, etc.) is the root.

This can show if a parent above has access to a message or if a message is registered.

Two forwarding strategies:

- **Static registration**: defined during `Setup.vi` / `Spawn.vi`.
- **Dynamic lookup**: tell the message to the parent and let the parent decide whether it can route it based on what it has registered.

How msg forwarding can be implemented to parent:

- An actor can recurse through `Parent -> Parent -> ...` and look at each parent `Unified Msgs`.

To child:

- Going down the tree can look at the `Unified Msgs` of children it has, then its children, etc.

Possible implementation sketch:

- `Read Parent Attributes -> Read Unified Msgs` to see if parent implements the msg; recurse parents upward.

Or:

- Explicit registration for forwarding on `Setup.vi` / `Spawn.vi`.

Forwarding constraints:

- In order to use a forwarding tool, messages still need to be in the `Unified Msgs`.
- Consider a `Non-Implemented Msgs`:
  - Forwarded messages appear in `Non-Implemented Msgs`.
  - Overlap is allowed: a msg can exist in both `Unified Msgs` and `Non-Implemented Msgs`.
  - If not in `Unified Msgs`, check `Non-Implemented Msgs`.

The `Non-Implemented Msgs` set can be dynamic (depending on external actors).

### Implement Msg

#### Generate Implemented Msg

Workflow idea:

1. Select actor.
2. Select msg to implement, tied to single interface.
3. In `Msg Overrides` virtual folder, override interface method.
4. Put the poly of that msg with recurse selected.
5. Wire up recurse as necessary.

Effectively: developers could “select” which msgs an actor can implement.

This combats the case where many interfaces/classes are loaded and one wants to implement a msg tied to an interface, but would otherwise need to scroll through a long inheritance hierarchy. This tool would bypass non-msg classes and provide a dropdown of only messages one can implement, filtered and sorted alphabetically.

Descriptions can help message naming:

Use parsing to get the unique identifier associated with a message in the description.

Example:

"Msg UID: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

where the Msg UID is generated when creating the TEMPLATE Msg and stored in the interface message method description.

Msg renaming idea:

- Actors that implement the message can be found in the interface method description via the unique hash. Store the identifier in the interface method description so tooling can track scripting and interface coupling.

When creating the implemented msg with `Recurse.vi`:

- (Would be nice) Ensure controls/indicators are positioned consistently so developers can quickly adjust them.

Implement message interface AND populate that interface’s message method with `Recurse.vi` and necessary wiring.

Reference:

- [Programmatically add a parent interface to a class](https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580)

#### Un-Generate Implemented Msg

Removes a message from an actor that no longer implements the message interface.

Additionally:

- If the developer un-implements the interface tied to the overridden method, then this becomes a non-interface-tied message method. A cleanup action should remove the orphan override.

Side idea:

- Static tool to find “implemented message methods” where the class does not implement the message method's interface. This occurs using the UID within the interface message method.
  - This message method can never be executed without an interface to dynamic dispatch into this message method.

### Msg Destination Viewer

Where messages go, relative to an individual actor (both to and from):

- Implemented messages (by searching implemented interfaces)
- Outbound messages to `Parent`, `Child`, `Reply` (found by finding `Tell Self`, etc. for particular messages)

Tracing through subVI calls may be required for `Tell Child.vi` since the exact child destination is not always a single constant wire at the callsite.

> **JUSTIFICATION**: The previous draft included an inline editorial question. This section now explicitly states why destination tracing can be non-trivial (subVIs, dynamic string building), which is the technical reason the tool is challenging.

### Monitor Msg Traffic

Since one cannot monitor a queue status, overriding the tell messages in a wrapper actor can put each told message into a log and mark as not read (organized by timestamp).

Then when the message is being acted upon (in `Call Inspect.vi` with `Msg Listened To.vi`), the matching timestamp can be marked as read.

This allows the system to infer how many msgs haven’t been executed (how many are effectively “in the queue”) since the message destination is known before the message is told.

Initialization requires:

- Self Attributes
- Parent Attributes

Note: child information is redundant since you can construct everything with Self and Parent Attributes combination.

After telling a message, log the **Tell Time**.

After listening to a message, log the **Listened Time**.

> **TODO:** Define:
>
> - **Log schema**: This logging can occur via holding these in a separate queue and getting its status of how large it is.
> - **Correlation IDs**: SHA1
> - **How to handle message cancellation / stop**:

### PPL Conversion

Take an actor and its messages and convert to PPL.

### Create Errors in a Folder

This is something that could be implemented, but it is unclear whether it should be implemented with the `--error` flag suffix.

- `placement--error.vi`

> **TODO:** Define:
>
> - **Where “placement errors” live**: These would live in an Error virtual folder that the scripting tool would target.
> - **Naming convention**: the general error name before the `--error.vi`.
> - **How tools discover them**: either scanning for the `--error.vi` suffix or scanning a dedicated Error virtual folder.

### Ref Tools

Tool for scripting User Events functions for value change (signaling) or value change. There could be future other ones. Currently, there is the placeholder for the polymorphic VI for either case of value change or value change (signaling).

Notes:

- Script the methods (for user events) as public API so that all parts of the actor (and only that actor, since Refs are private to actor) can access them.
- These scripted methods should be decoupled from message scripting; they are called from inside implemented message methods.

### Navigating Msg Methods

- Right click a `Method.vi` in the project → script finds the interface it is overridden from and navigate to the parent method in the interface by focusing on it.
- Right click the interface method → script finds all instances where the method is implemented in actors in the current project (including dependencies), providing a dropdown of targets and implementing actors.

This will have to deal with polymorphic method calls (not only interface methods) for better system understanding.

> **JUSTIFICATION**: The earlier draft included an inline editorial question. The core point is that tooling must handle both interface overrides and poly wrappers to provide reliable navigation.

### Actor Browser

Per-actor window that allows you to scroll through:

- `Actor Overrides -> Variant -> Extended`
- `Msg Overrides`

Looks in the above respective virtual folders.

## Packaging and Distribution

### VIPM

It is a goal to keep the jettl VIPM as one package for ease on the developer, without needing to think about multiple packages and their versions.

This library is compatible with **LV 2020 and beyond**.

Note: If using LV2020, consider using **LV 2020 SP1** due to issues resolved here:

- [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html?srsltid=AfmBOooUbuV9waHiF74KkrteQY7SRCENumzj1XCdQMWldAIuQMDW1sM6)

> **JUSTIFICATION**: Packaging, distribution, and “how users install/run tools” are part of the developer workflow, so they live in Tooling (not Runtime).

### Examples Packaging Notes

Examples are distributed through both VIPM and the LabVIEW Example Finder.

- **Example Finder discoverability**:
  - Set meaningful keywords (for example: `jettl`, `actor`, `messaging`) so examples appear at the top of searches.
  - Keep examples self-contained: a user should be able to run them without additional project setup beyond installing the package.
- **VIPM “Show Examples” behavior**:
  - Ensure example VIs/projects are included in the VIPM package build and installed into a consistent examples folder.
  - Include a short README or front-panel instructions inside the example so users know what success looks like.

> **TODO:** Capture the exact on-disk install location used by the package (and whether it matches LabVIEW’s default examples directory).

## Debug

### DETT Debug Actor

`DETT Debug jettl Actor` is a Core actor layer. It asynchronously spawns a window actor layer that takes in lifecycle information. This can be done in many methods such as `Start.vi`.

- In `Spawn.vi`, if `Root = True`, start another async process which gets its data by reference.
- All actors spawned afterward have this persistent core layer registered in their `Spawn.vi`.
- Only do this for the outermost actor by checking `Read Actor Index`:
  - The outermost actor is known by checking the array length of the `Actors` array (how many actors make up the unified actor).

Note: cannot get DETT trace data from VIs in `vi.lib`. This note might prove useful depending on what needs to be accessed by DETT trace data.

#### Testing / Debugging Notes

Since `Actor.vi` is NOT a formal decorator method, only the outermost layer actor `Actor.vi` will be executed.

An advanced scheme of wrapping an “outer layer” can occur where the wrapping layer(s) have the actor decorator method within. This allows only the DD methods outside of the `Actor.vi` to be executed.

### Base Debug jettl Actor

This is effectively an event logger.

- A file is created for EACH actor in a central temp application directory to log necessary events/actions that occur in an actor (separate files prevent resource contention: each actor writes to its own file).
- A timestamp with a call chain / class hierarchy are logged with events, etc.

### Runtime Message Inspection

Incorporate the ping msg and the debug/base-debug libraries as core layers.

At runtime, messages can be inspected in `Inspect Call.vi` and timestamped to show the system while it is executing.

> **TODO:** Decide:
>
> - **What is the default on/off behavior for debug layers?**
> - **Where logs are written**
> - **Log format**
> - **How logs are correlated across actors**

## Unit Tests

### Test Frameworks

- Caraya
- LUnit
- Approval tests (separate projects can be used to perform unit tests)

### Unit Testing with Decoration

Unit tests can be implemented by using a Unit Test jettl Actor as a core actor layer.

### Test Panel

Automatically generated test panel:

- Provide controls/inputs for all messages the actor expects (listen and display payloads for all methods defined in any interfaces the actor has available). This is similar to the DQMH test panel.

This supports designing modular actors without dependencies on other actors.

### Logging Actor State for Tests

To determine unit test cases, the actor object can be logged before and after message method execution, along with its inputs and outputs for the message. This reveals how a method behaves in production, which helps define test cases.

> **TODO:** Fill in:
>
> - **Which unit testing approach is blessed (decoration vs harness VI vs both)**
> - **How test panels are generated (tool name + workflow)**: LabVIEW scripting upon actor creation.
> - **How payloads are serialized (format + schema versioning)**
> - **How actor state is extracted safely**: At the output of the `Actor.vi` and examining the `Actors` in the `Self Attributes`.

## Documentation Tooling

### Actor Msg Documentation

Use `Tell Self.vi`, `Tell Parent.vi`, and `Tell Child.vi` to visualize messages outgoing from an actor under inspection. Since jettl requires the destination to be known at edit time via the relative actor relation.

Potential outputs:

- Messages an actor can implement (by finding parent message interfaces)
- Messages an actor can tell to `Self`, `Parent`, and `Child` (inspecting `Tell Self.vi`, `Tell Parent.vi`, `Tell Child.vi`)
- Actor spawning hierarchy to stitch actor msg destinations together to form documentation for an actor system.

Diagram generation can be done by static analysis of code or analysis of DETT output at runtime.

### AntiDoc Integration

> **TODO:** Decide whether AntiDoc is a required dependency or an optional integration, and document the integration points.

### Tell Child Destination Problem

Since spawning children is dynamic, even with `Tell Child.vi`, extra steps must be taken to ensure understanding of where a message will go to which child.

Define, at edit time, which messages are routed to which child actor.

One approach:

- Locate calls to `Tell Child.vi` → Find Callers.
- Resolve the target child by tracing the destination input back through `Format Into String` to the associated `Child UIDs` enum (or encapsulate destination selection in dedicated methods).
- This lets tooling determine the destination name statically, so it’s clear where the message will be told at run time.

This approach only works when the destination string is a straightforward `Format Into String` + enum pattern.

If the destination is modified elsewhere (built dynamically, manipulated as a string, or selected via conditional logic), scripting cannot reliably infer the destination.

For clarity and maintainability, keep message routing as static as possible:

- Create a dedicated method using `Tell Child.vi` for the specific message, and wire the enum through `Format Into String` internally.
- Avoid intermediate string manipulation or conditional destination selection when you want tooling to accurately show message destinations.

> **TODO:** Decide whether this pattern is:
>
> - **A recommended pattern**: The above with specific `Tell Child.vi` of the specific message with enum and format to string is recommended.
> - **Only used for tooling but not required**: This is currently a best practice.

## Readability and Style Guide

### No Helper Loops

**NO helper loops.**

Best practice: instead of helper loops, spin up another actor. Pass the necessary information as a message method that is private to the actor spawning the child and make this message private and the actor being spawned private to the actor.

Private Actor virtual folder allows actors to live within another actor’s library.

Separating concerns via child actors should be normal: for example, controller vs view.

Best practice: if an actor needs an event helper loop, make this helper loop an event actor that is tightly coupled to the actor by placing the event actor in the same library as the actor.

### No Property Nodes For Accessors

Property nodes are not used due to banner color not being displayed.

Reference:

- [Using a Message Broker with DQMH Actors for High Speed/Throughput Data logging](https://www.youtube.com/watch?v=jNBAvNQJyO8&list=PLvDxiIkwuMQvrSQIqy_it5Q7-sGvM4XX8&index=3) @7:33

### Use of Nested Libraries

Nested libraries are used since each nested library defines its own access scope controlling which parts have access to other parts.

### Composition over Inheritance

Fundamentally, class inheritance should not occur for actors.

Instead, for something like a HAL, use dependency inversion with the strategy pattern to pick and choose the implementation used for that actor by composing in the interface for the HAL.

Remember to decouple the framework from the implementation details as per agile software development principles.

### Default Function and Method Conventions

These *could* be set up in the LabVIEW .ini, but is not forced upon the developer. This is how jettl was developed.

Default function:

- Icon: ctrl+shift+k, left justified, not capital, red text
- Private
- Connector pane: error out
- preallocated

Default SD:

- Icon: ctrl+shift+k, left justified, not capital, red text
- Private
- Connector pane: class in, error out
- preallocated

Default DD:

- Icon: ctrl+shift+k, left justified, not capital, black text
- Public (has to be)
- Connector pane: class in, error out
- Shared clone

Note the "lv_new_vi.vi" plugin which can be used to customize new VIs when they are created.

### Class IO and Error IO

Reserved connector pane terminals:

- The top-left and top-right terminals are reserved for the containing `Class in` and `Class out`.
- The bottom-left and bottom-right terminals are reserved for `Error in` and `Error out`.

If a function has an output class, it SHOULD be wired by the developer since internally the class may be changed.

Possible VI Analyzer test:

- Check that the `Class out` terminal has a valid wire connection.

Connector pane guidelines:

- **Class IO (class/interface terminals)**: top-left and/or top-right
- **Error IO**: bottom-left and/or bottom-right
- **Typical inputs**: two left middle and/or bottom middle terminals
- **Class specific inputs**: top middle inputs for functions/methods specifically designed to wrap class functionality of a different containing class
- **Outputs**: right middle terminals, but if more outputs are necessary, the bottom middle can be used.

A static analyzer can ensure reserved terminals contain only expected types.

References:

- [An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k) @23:59
- [Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA) @45:21

### Virtual Folders

Virtual folders are not saved on disk; they are only convenience in the LabVIEW project.

This is helpful for finding things on disk in a repeatable fashion. A class should contain only class member functions/methods/controls.

Organizing virtual folder contents improves discoverability.

Reference:

- [Large LabVIEW Project Development Techniques](https://youtu.be/7zS3Q_K71XY?si=VZXcWRaCqc0C4tWh) @00:14:08-00:14:46

### Color Scheme

Banner colors and class wire colors should match.

jettl coloring scheme:

- Purple Library: RGB (166,153,182)
- Blue Interface: RGB (104,136,190)
- Green Class: RGB (110,149,108)

How to remember:

"Look down at the green grass, look up to the blue sky, and look further to the purple galaxy."

These are the levels of abstraction and containerization.

### Icons

Banner:

- Shows library/interface/class name in text.
- Color of banner name text indicates access scope of containing library/interface/class.
- Color of banner indicates a library/interface/class container.

Rest of icon:

- Text of method name.
- Color of method name text indicates access scope of method/control (red = private, black = public).

### Function vs Method

A function is a VI that does not have `Class IO` for the containing class it is contained in. If contained in a library, it is not a method and must not use the upper-left/upper-right class terminals.

A method is a VI that has one or both of its `Class IO` connector pane terminals for the containing interface/class it resides in. A library cannot contain methods, only functions.

### Access Scope

Only public and private.

Interfaces, classes, and methods have text in the banner/icon that are black (public) and red (private).

Class private data icons:

- Blank entirely.
- If something is added, ensure the text is red since the private data is a private control.

Encapsulation rule:

- Emphasis is put on encapsulated classes as classes (maybe container libraries) marked private.
- Only functions and interfaces should be exposed to the outside world. Classes should be marked private to encourage developers not allowing external code to couple to these concretions.
- All classes should be marked as private to the library containing them.

This prevents external use of concrete classes and encourages dependency inversion with interfaces, mitigating circular dependencies.

Nested libraries should be private unless they contain public functions/methods.

Rules:

- Interfaces and classes must be contained in at least one library.

Public vs private methods/functions:

- Public: only the actor’s API surface—messages and actor API methods that define how other components interact with the actor.
- Private: methods and functions created to implement behavior.

### Ownership Terminals and Mutability Signals

Class/interface ownership terminals:

- The upper-left terminal (and upper-right, if present) indicates the class/interface wire that owns the banner method.
- Reserve the upper-left and upper-right connector pane terminals only for the class/interface wire for the method that the class/interface contains.

Mutability and readability conventions:

- If the same class type comes in and is passed out horizontally, callers should assume the class may have been mutated (whether it actually was or not).
- This convention most commonly applies to:
  - the class/interface wire (upper-left to upper-right)
  - the error cluster (lower-left to lower-right)

Immutable pass-through is an antipattern:

- If an input class is immutable and you only wire it to output to preserve dataflow/serialization, that is an antipattern because it falsely implies mutation of that datatype. This provides difficulty in readability.
- If you need sequencing (for example, to serialize operations), use a Flat Sequence Structure rather than passing the class through solely for serialization.

Apply the same rule to the error wire:

- The error wire should not be used for serialization.
- If you need explicit sequencing without implying mutation, use a Flat Sequence Structure rather than relying on the error wire.

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

- **Which tooling items are “must ship” vs “nice to have”?**: All tools are must ship. Do you have suggestions for more tools?
- **Which tools must support PPL workflows on day 1?**: Ideally, all of these tools should support PPLs. Though, on second thought.. I am not sure since the rename tool shouldn't change a PPL. I am actually unsure.
- **What is your canonical palette/layout for tools?**: Everything is under the jettl menu under Tools. There are sub categories that are for runtime / edit time tools.
- **How should tools behave in a repo with multiple targets/projects?**: Ideally every project contains one target and one actor. Tools should operate on a single project at a time on one target. Multiple actors can exist in a project, but there is a main actor which privately encapsulates other actors in its `Private Actors` virtual folder.
- **What is your standard debug story (DETT vs logging vs probes vs all)?**: DETT.
- **What is your standard unit test story (Caraya vs LUnit vs approval tests vs all)?**: LUnit
- **Which documentation outputs are required (diagrams, tables, generated pages)?**: Ideally, all of these.
- **Which readability rules should be enforced by analyzer vs only documented?**: Good question, let's say all.
