# Tooling

This document covers the developer workflow for jettl: scripting tools, packaging, debugging, testing, documentation generation, and the shared readability/style conventions used across the codebase.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Tools

### Notes for All Tools

- All external tools belong in the same common location: `Tools -> jettl Tools`.
  - If a tool is company/name specific and credit should be preserved, place it under a subfolder, for example: `Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME`.

- Tool scripting cannot change items in the dependencies. Only those selected under the chosen target are affected i.e. My Computer or a RT Target.

- **Requirement:** tools MUST support PPL workflows. This is being actively developed.

> **TODO:** Tool UI improvement idea:
>
> - **Show the on-disk path in the tree view (right side column)**:

> **TODO:** Define the minimum tool quality bar.
> Can you please be more detailed with examples and ideas?
> - **Supports PPLs**:
> - **Supports source-distribution (non-PPL)**:
> - **Does not break VI Analyzer**:
> - **Can be run on a project subset**:
> - **Dry-run mode available (if applicable)**:
> - **Undo strategy / rollback notes**:

### Current Native Tools

#### Rescript

How to use:

- Only the left two inputs on the interface method can be scripted.
- Only the right two outputs on the interface method can be scripted.

Future cleanup idea in `Script Msg.vi`:
- Clean up wire via invoke node: `Wire -> CleanUpWire`.

> **TODO:** Document:
> Can you please be more detailed with examples and ideas?
> - **Tool location (palette + on-disk)**:
> - **Supported connector panes**:
> - **Common failure modes**:
> - **Examples (before/after)**:

#### Rename

Both actor and message renaming:

- Takes the library(s) and properly puts them in a hierarchical map where the names are unique depending on their path/hierarchy of library(s).

> **TODO:** Document:
>
> - **Scope of rename (actor only / msg only / both)**: Both are available.
> - **How uniqueness is determined**: path and name.
> - **How collisions are resolved**: Collisions cannot occur due to the tool checking preexisting names and paths before a rename of the same name is trying to be fulfilled.
> - **What is *not* renamed**: Can you please be more detailed with examples and ideas?

#### Template

> **TODO:** Fill in the template tool behavior.
>
> - **What it generates**: Template for the actor or msg.
> - **Where it places files**: In the projects directory, this cannot be changed due to best practice.
> - **How it picks names**: defaults to `TEMPLATE`.
> - **How it handles existing items**: if the name already exists in memory, the TEMPLATE cannot be created due to a validation check.

### Current External Tools

None

### Tool Ideas

> Sections under **Tool Ideas** are non-normative.

#### Moving Msg and Actor Libraries

Moving actors and msgs on disk, and also in Project Explorer into the correct destination:

- into Private Msgs folder of an actor, or
- out of any library to the top level target.

Messages creation questions:

- Maybe a message can ONLY be created after an actor has been created and must be placed in either the public or private folder?
- If messages can be standalone (no coupling to an actor), where do they live to avoid name-spacing issues?

Possible template msg placement options:

1. In the project under target
2. Private msg virtual folder of actor library
3. Public msg virtual folder of actor library

Actor creation has similar options. Idea: Only one top-level actor library can be in a project. Creating an actor in the same project after an actor has already been created can only be placed in the private folder for the actor already created.

Message classification idea:

1. Private internal message
2. Fully public message

#### Forward Msg

Since an actor can access it's parents parent relation (and so forth), use `Read Root.vi` to determine whether a parent (grandparent, etc) is the root.

This can show if a parent above has access to a message or if a message is registered.

Two forwarding strategies:

- **Static registration**: defined during `Setup.vi` / `Spawn.vi`.
- **Dynamic lookup**: tell the message to the parent and let the parent decide whether it can route it based on what it has registered.

How msg forwarding can be implemented to parent:

- An actor can recurse through `Parent -> Parent -> ...` and look at each parent `Unified Msgs`.

To child:

- Going down the tree can look at the `Unified Msgs` of the children it has, then its children, etc.

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

#### Implement Msg

##### Generate Implemented Msg

Workflow idea:

1. Select actor.
2. Select msg to implement, tied to single interface.
3. In `Msg Overrides` virtual folder, override interface method.
4. Put the poly of that msg with recurse selected.
5. Wire up recurse as necessary.

Effectively: developers could “select” which msgs an actor can implement.

This combats the case where many interfaces/classes are loaded and one wants to implement a msg tied to an interface, but would otherwise need to scroll through a long inheritance hierarchy, attempting to find the interface. This tool would bypass non-msg classes and provide a dropdown of only messages one can implement, filtered and sorted alphabetically

Descriptions can help message naming:

Use parsing to get the unique identifier associated with a message in the description.

Example:

"Msg UID: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

where the Msg UID is generated when creating the TEMPLATE Msg and here within ""s. 

Msg renaming idea:

- Actors that implement the message can be found in the `Interface Message Method` description via the unique hash. Store the identifier in the message method description for the interface. Useful for tracking whether a msg has been scripted an tied to the `Interface Message Method`.

When creating the implemented msg with `Recurse.vi`:

- (Would be nice) Ensure controls/indicators are positioned consistently so developers can quickly adjust them.

Implement message interface AND populate that interface’s message method with `Recurse.vi` and necessary wiring.

Reference:

- [Programmatically add a parent interface to a class](https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580)

##### Un-Generate Implemented Msg

Removes a message from an actor that doesn't anymore implement the message interface.

Additionally:

- If the developer un-implements the interface tied to the overridden method, then this becomes a non-interface-tied message method, an action should be taken at this step to remove the message method override.

Side idea:

- Static tool to find “implemented message methods” (where the class does not implement the message method's interface), this occurs using the UID within the interface message method.
  - This message method can never be executed without an interface to dynamic dispatch into this message method.

#### Msg Destination Viewer

Where messages go, relative to an individual actor (both to and from):

- Implemented messages (by searching implemented interfaces)
- Outbound messages to `Parent`, `Child`, `Reply` (found by finding `Tell Self`, etc for particular messages.)


> I DO NOT UNDERSTAND WHY YOU HAVE REFORMATTED THIS SENTENCE THIS WAY, CAN YOU BE EXPLICIT WITH WHY THIS IS HERE? This can be done only within the method call being enacted since that is where the teller interface comes from.

Tracing through subVI calls may be required for `Tell Child.vi` since the exact child is currently not linked in it's own encapsulated method call.

#### PPL Conversion

Take an actor and its messages and convert to PPL.

#### Create Errors in a Folder

- `placement--error.vi`

> **TODO:** Define:
>
> - **Where “placement errors” live**:
> - **Naming convention**:
> - **How tools discover them**:

#### Ref Tools

Tool for scripting User Events functions.

Notes:

- It is probably best to script the methods (for user events) as public API so other parts of the project can access them.
- Consider whether user events created by scripting should be represented as messages.

#### Navigating Msg Methods

- Right click a `Method.vi` → find the interface it is overridden from and navigate to the parent method in the interface.
- Right click the interface method → find all instances where the method is implemented.

This will have to deal with polymorphic method calls (not only interface methods) for better system understanding.

#### Actor Browser

Per-actor window that allows you to scroll through:

- Actor overrides
- Msg overrides

Looks in the respective virtual folder.

## Packaging and Distribution

### VIPM

This library is compatible with **LV 2020 and beyond**.

Note: If using LV2020, consider using **LV 2020 SP1** due to issues resolved here:

- [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html?srsltid=AfmBOooUbuV9waHiF74KkrteQY7SRCENumzj1XCdQMWldAIuQMDW1sM6)

### Examples Packaging Notes

Examples should be discoverable through the LabVIEW Example Finder and through VIPM.

- Keywords like `jettl`, `actor`, etc. should make examples appear at/near the top of searches.
- Ensure examples appear on the VIPM install page.
- Consider Bowzer (the browser) for examples browsing.

Example idea:

- Darren Nattinger creating a timer introductory example would demonstrate jettl and provide a comparison point to DQMH, while referencing his presentation.

> **TODO:** Define the release checklist for examples.
>
> - **Example Finder category**:
> - **VIPM keywords**:
> - **Minimum number of examples per release**:
> - **Examples CI validation (mass compile, VI Analyzer, etc.)**:

## Debug

### Debug with Probes

Debug with probes:

- Way for the hierarchy debug to link to custom probes before running to view how particular pieces of data change with reentrant VIs.
- Is there a way the editor can discover custom probes and display their internals on another front panel?

### DETT Debug Actor

`DETT Debug jettl Actor`.

Sketch:

- In `Spawn.vi`, if `Root = True`, start another async process which gets its data by reference.
- All actors spawned afterward have a persistent core layer registered in their `Spawn.vi`.
- Only do this for the outermost actor by checking the `Actor Index`:
  - The outermost actor is known by checking the array length of the `Actors` array (how many actors make up the unified actor).

Note: cannot get DETT trace data from VIs in `vi.lib`.

### Testing / Debugging Notes

Since `Actor.vi` is NOT a decorator method, only the outer local actor `Actor.vi` will be executed.

An advanced scheme of wrapping an “outer layer” can occur where the wrapping layer(s) have the actor decorator method within. This allows only the DD methods outside of the `Actor.vi` to be executed.

### Base Debug Actor

This is effectively an event logger.

- A file is created for EACH actor in a central temp application directory.
- A time stamp with a call chain / object hierarchy are logged with events, etc.
- Separate files prevent resource contention: each actor writes to its own file.

### Runtime Message Inspection

Incorporate the ping msg and the debug/base-debug libraries as intermediate layers.

At runtime, messages can be inspected in `Call Inspect.vi` and timestamped to show the system while it is executing.

> **TODO:** Decide:
>
> - **What is the default on/off behavior for debug layers?**:
> - **Where logs are written**:
> - **Log format**:
> - **How logs are correlated across actors**:

## Unit Tests

### Test Frameworks

- Caraya
- LUnit
- Approval tests (separate projects can be used to perform unit tests)

### Unit Testing with Decoration

Since the actor model is interface-composition based with the decorator pattern, unit testing can be implemented by decorating a core actor with a unit test actor.

An infinite number of actors can be decorated, enabling advanced testing functionality.

### Test Panel

Automatically generated test panel:

- Provide controls/inputs for all messages the actor expects.
- Listen and display payloads (serialized) from all methods defined in any interfaces the actor has available.

This supports designing modular actors without dependencies on other actors.

### Logging Actor State for Tests

The actor object can be logged before and after method execution, along with its inputs, to determine unit test cases.

`Actor.vi` output terminal notes:

- The actor does not need an output, but for testing it is useful to have an output to read final state/error when the actor ran alone.
- The DD output terminal on `Actor.vi` prevents the object wire from changing at runtime.
- Output terminals are available primarily for testing purposes.

> **TODO:** Fill in:
>
> - **Which unit testing approach is blessed (decoration vs harness VI vs both)**:
> - **How test panels are generated (tool name + workflow)**:
> - **How payloads are serialized (format + schema versioning)**:
> - **How actor state is extracted safely**:

## Documentation Tooling

### Actor Msg Documentation

Use `Tell Self.vi`, `Tell Parent.vi`, and `Tell Child.vi` to visualize messages between actors, since jettl requires the destination to be known at edit time via the relative actor relation.

Potential outputs:

- Messages an actor can implement
- Messages an actor can tell to `Self`, `Parent`, and `Child`
- Actor spawning hierarchy

Diagram generation can be done by static analysis of code or analysis of DETT output.

### AntiDoc Integration

Ideas:

- AntiDoc integration
- Msg method browser
- Msg destination browser
- Actor hierarchy inspector
- Message monitor (logger/monitor showing run-time message tells)
- Actor system designer: system-level diagram of actor spawning hierarchy
- Actor framework message forwarding
- Open AF payload
- Bowzer the Browser
- State pattern actor
- Examples and CTI

### Tell Child Destination Problem

Since spawning children are dynamic, extra steps must be taken to ensure understanding of where a message will go to which child.

Define, at edit time, which messages are routed to which child actor.

One approach:

- Locate calls to `Tell Child.vi`.
- Resolve the target child by tracing the destination input back through the `Format Into String` primitive to the associated `Child UIDs` enum.
- This lets tooling determine the destination name statically, so it’s clear where the message will be told at run time.

This approach only works when the destination string is a straightforward `Format Into String` + enum pattern.

If the destination is modified elsewhere (built dynamically, manipulated as a string, or selected via conditional logic), scripting cannot reliably infer the destination.

For clarity and maintainability, keep message routing as static as possible:

- Use an enum wired into `Format Into String` to represent the child target.
- Avoid intermediate string manipulation or conditional destination selection when you want tooling to accurately show message destinations.

> **TODO:** Decide whether this pattern is:
>
> - **A recommended pattern**:
> - **A required pattern (enforced by analyzer)**:
> - **Only used for tooling but not required**:

## Readability and Style Guide

> Please find a home for these other readability and style guidelines:
> 
> For the full style guide on icons, connector panes, access scope, and wiring conventions.
> 
> These are non-normative guidelines.
> 
> - All Boolean logic is positive logic.
> - `Read*` and `Write*` methods should do only what their name implies: read or write with no additional behavior.

### No Helper Loops

**NO helper loops.**

Best practice: instead of helper loops, spin up another actor.

Private Actor virtual folder allows actors to live within another actor’s library.

Separating concerns via child actors should be normal: for example, controller vs view.

Example: if a queue actor needs an event helper loop, make this helper loop an event actor that is tightly coupled to the queue actor by placing the event actor in the same library as the queue actor.

### No Property Nodes

Property Nodes are not used due to banner color not being displayed.

Reference:

- [Using a Message Broker with DQMH Actors for High Speed/Throughput Data logging](https://www.youtube.com/watch?v=jNBAvNQJyO8&list=PLvDxiIkwuMQvrSQIqy_it5Q7-sGvM4XX8&index=3) @7:33

### Nested Libraries

Nested libraries reason:

Each nested library defines its own access scope controlling which parts have access to other parts.

### Composition over Inheritance

Fundamentally, class inheritance should not occur for actors.

Instead, for something like a HAL, use dependency inversion with the strategy pattern to pick and choose the implementation used for that actor.

### Default Function and Method Conventions

Default function:

- Icon: ctrl+shift+k, left justified, not capital, red text
- Private
- Connector pane: error out
- Shared clone

Default SD:

- Icon: ctrl+shift+k, left justified, not capital, red text
- Private
- Connector pane: object in, error out
- Shared clone

Default DD:

- Icon: ctrl+shift+k, left justified, not capital, black text
- Public (has to be)
- Connector pane: object in, error out
- Shared clone

### Object IO and Error IO

Reserved connector pane terminals:

- The top-left and top-right terminals are reserved for the containing object input and object output.
- The bottom-left and bottom-right terminals are reserved for error input and error output.

If a function has an output object, it SHOULD be wired by the developer.

Possible VI Analyzer test:

- Check that the object output terminal has a valid wire connection.

Connector pane guidelines:

- **Object IO (class/interface terminals)**: top-left and/or top-right
- **Error IO**: bottom-left and/or bottom-right
- **Typical inputs**: two left middle and/or bottom middle terminals
- **Object specific inputs**: top middle inputs for functions/methods specifically designed to wrap object functionality
- **Outputs**: right middle terminals

A static analyzer can ensure reserved terminals contain only expected types.

References:

- [An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k) @23:59
- [Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA) @45:21

### Virtual Folders

Virtual folders are not saved on disk; they are only convenience in the LabVIEW project.

Organizing virtual folder contents is helpful for keeping name-spacing consistent.

Reference:

- [Large LabVIEW Project Development Techniques](https://youtu.be/7zS3Q_K71XY?si=VZXcWRaCqc0C4tWh) @00:14:08-00:14:46

### Color Scheme

Banner colors and object wire colors should match.

jettl coloring scheme:

- Purple Library: RGB (166,153,182)
- Blue Interface: RGB (104,136,190)
- Green Class: RGB (110,149,108)

How to remember:

"Look down at the green grass, look up to the blue sky, and look further to the purple galaxy."

### Icons

Banner:

- Shows library/interface/class name.
- Color of banner name text indicates access scope of containing library/interface/class.
- Color of banner indicates a library/interface/class container.
- Text of method name.
- Color of method name text indicates access scope of method/control.

### Function vs Method

A function is a VI that does not have object IO for the containing object it is contained in.

A method is a VI that has one or both of its object IO connector pane terminals.

Library functions are not methods and must not use the upper-left/upper-right object terminals.

### Access Scope

Only public and private.

Interfaces, classes, and methods have text in the banner/icon that are black (public) and red (private).

Class private data icons:

- Blank entirely.
- If something is added, ensure the text is red since the private data is a private control.

Encapsulation rule:

- Emphasis is put on encapsulated classes as classes (maybe container libraries) marked private.
- Only functions and interfaces should be exposed to the outside world.
- All classes should be marked as private to the library containing them.

This prevents external use of concrete classes and encourages dependency inversion with interfaces, mitigating circular dependencies.

Nested libraries should be private unless they contain public functions/methods.

Rules:

- Interfaces and classes must be contained in at least one library.

Public vs private methods/functions:

- Public: only the actor’s API surface—messages and actor API methods that define how other components interact with the actor.
- Private: helper methods and functions created to implement behavior.

### Ownership Terminals and Mutability Signals

Class/interface ownership terminals:

- The upper-left terminal (and upper-right, if present) indicates the class/interface wire that owns the banner method.
- Reserve the upper-left and upper-right connector pane terminals only for the class/interface wire for the method that the class/interface contains.

Mutability and readability conventions:

- If the same object type comes in and is passed out horizontally, callers should assume the object may have been mutated (whether it actually was or not).
- This convention most commonly applies to:
  - the class/interface wire (upper-left to upper-right)
  - the error cluster (lower-left to lower-right)

Immutable pass-through is an antipattern:

- If an input object is immutable and you only wire it to output to preserve dataflow/serialization, that is an antipattern because it falsely implies mutation.
- If you need sequencing (for example, to serialize operations), use a Flat Sequence Structure rather than passing the object through solely for serialization.

Apply the same rule to the error wire:

- The error wire should not be used for serialization.
- If you need explicit sequencing without implying mutation, use a Flat Sequence Structure (or another explicit sequencing construct) rather than relying on the error wire.

## Feedback Questions

- **Which tooling items are “must ship” vs “nice to have”?**:
- **Which tools must support PPL workflows on day 1?**:
- **What is your canonical palette/layout for tools?**:
- **How should tools behave in a repo with multiple targets/projects?**:
- **What is your standard debug story (DETT vs logging vs probes vs all)?**:
- **What is your standard unit test story (Caraya vs LUnit vs approval tests vs all)?**:
- **Which documentation outputs are required (diagrams, tables, generated pages)?**:
- **Which readability rules should be enforced by analyzer vs only documented?**:
