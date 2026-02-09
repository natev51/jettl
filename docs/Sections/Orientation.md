# Orientation

These docs are written for LabVIEW developers seeking a proficient understanding of jettl.

## Status and Contributions

This is a living document. Contributions are welcome; see the GitHub README for contribution channels.

> **TODO:** Capture contribution workflow details here (keep it short and actionable).
>
> - **Where to file issues**: File issues here: https://github.com/natev51/jettl/issues
> - **Preferred PR structure**: I don't have a current PR structure, can you suggest one?
> - **Style checks (if any)**: For the coding style checks, refer to documentation here on `Readability`.

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

1. **Documentation** — documentation for actors and messaging.
2. **Unit Testing** — testing on actors and their associated messages.
3. **Visualization** — actor spawning and messaging diagrams.
4. **Generation and Maintenance** — standardized templates.
5. **Refactoring** — support an agile development philosophy to readily refactor code and deliver product quickly.

> **TODO:** Make each goal measurable (even roughly).
>
> - **Documentation success criteria**: Can you please provide examples?
> - **Unit testing success criteria**: Can you please provide examples?
> - **Visualization success criteria**: Can you please provide examples?
> - **Generation/maintenance success criteria**: Can you please provide examples?
> - **Refactoring success criteria**: Can you please provide examples?

## Philosophy

- Always assume you cannot control the order that messages execute.
- Prefer explicit contracts and static structure.
- Prefer composition of interfaces by dependency inversion and decoration over class based inheritance.

## Core Mental Model

- **Relative actor relations**: every actor has `Self`, one `Parent` (if not the `Root`), and zero or more `Child` actors.
- **Layering**: an *actor* is one layer and an actor layer is interchangeable; a *unified actor* is the composition of all layers.
- **Messaging**: messages are interface-driven; destinations are known at edit time via strongly-typed tell APIs.

For precise definitions, see [Terminology](Core%20Model.md#terminology).

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
- **By-Value Event Loop** — the central object wire flows through the event structure (by-value design) encouraging to not branch the object wire.
- **Message Output** — messages can return outputs for a number of reasons including layer-to-layer transfer of data.
- **Transport Agnostic** — Queue, Event, and Notifier transports.
- **Statically Typed Messaging** — interfaces + analyzers support static relationships known at edit time via strongly-typed tell APIs.
- **Child UID Mapping** — child UIDs are statically named and mapped internally for convenience of Child Actor messaging.

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
> - **No dependencies rationale**: no external dependencies to other libraries, jettl is written in pure LabVIEW without external dependencies needed to be downloaded.
> - **No circular dependencies rationale**: The architecture is interface driven, leading to relationships being entirely abstract relationships, decoupling circular dependencies. This can be further explored through Factory Pattern where actors are truly independent of calling code by the Actor interface, being loaded via PPLs through disk.
> - **No password protection rationale**: The source code can easily be explored and understanding of the framework has no roadblocks enabling a open source mindset for development.
> - **No malleable VIs rationale**: Malleable VIs lead to build issues and are not used entirely.
> - **No XNodes rationale**: XNodes lead to build issues and are not used entirely.
> - **No diagram disable structures rationale**: Errors otherwise not caught in diagram disable structures lead to build issues and are not used entirely.

## Documentation and Naming Conventions

### LabVIEW Virtual Folder Naming

![](../Images/project-view-actor.png)  
*Project view for an actor being developed.*

Above is the folder structure for an actor. This is what makes the most sense at the present writing. Many of the method and function calls will not be used or manipulated. These are outlined in the comments for each method and function.

> **TODO:** Fill in the recommended virtual folder layout below.
>
> Keep this list stable; tooling and developer habits will align to it.

- **Actor library virtual folders**:
  - `Actor Overrides/Variant/Extended`: This folder is best practice to easily find actor overrides. Place the modified methods from the Default folder into this folder to easily find which methods have extended functionality.
  - `Msg Overrides/`: This folder is best practice to easily find msg overrides. Place message methods that have been overridden here. Note in the future, a tool will be developed that will automatically generate the message methods and perform the necessary interface implementation. 
  - `Private Actors/`: This folders are optional. This should be a private folder the developer creates to place in Actors that are tightly coupled to the containing actors `X jettl Actor.lvlib` so that these private actors cannot be used elsewhere in the application.
  - `Private Msgs/`: This folders are optional. This should be a private folder the developer creates to place in Msgs that are tightly coupled to the containing actors `X jettl Actor.lvlib` so that these private msgs cannot be used elsewhere in the application.

## Best Practices

These are non-normative guidelines.

1. Develop business logic in a separate library and use that library in actor code. This decouples logic from the actor and improves testability for the separate library, independent of the framework.
2. Prefer designs that do not rely on message ordering. If you introduce priority messaging, also define ordering rules and acceptance tests (see [Scheduling and Priority](Runtime.md#scheduling-and-priority)).
3. Name message methods with enough context (often ~3–4 words) to reduce naming collisions when overriding the message method in the actor that implements it.
4. Do not split the central object wire, except in pure read methods (e.g., `Read X.vi`) that do not pass through the input object to the output.
5. Prefer calling functions and methods on the palettes. Other functions and method calls are available, but are public only because they are used in the template, not necessarily because they can be reused. For more information, see PLACEHOLDER.
6. Manage reference lifetime explicitly: create and destroy references in the same actor whenever possible. For deeper rationale, see [Reference Lifetime and Ownership](Core%20Model.md#reference-lifetime-and-ownership).

> **TODO:** Add a “why it matters” sentence to each best practice.
>
> - **Best practice 1 rationale**: If a PID algorithm is developed, the associated objects and function calls should be in their own API, and tested for that library. Then that PID library can be implemented in the actor by use of composition of interfaces or calling functions.
> - **Best practice 2 rationale**: Assume that messages will arrive in any order and design the actor with this in mind where at any point in the actors lifetime, it can accept any message, even ones it does not implement.
> - **Best practice 3 rationale**: Naming collisions happen most often with simple names. For example, messages cannot be named `Setup jettl Msg` since there is already an overridden Setup method that exists in the actor method list. Therefore, the scripting does not allow this name. The same can be said for other message names such as `Acquire jettl Msg`. There very well could be a library in the future from another API that has this method name that needs to be overridden, therefore it is best to preventatively name the messages specifically to their intent to describe the message intent without being too general, leading to eventual refactor.
> - **Best practice 4 rationale**: As it is encouraged to maintain the state for each actor, this means the central object wire for should not be branched to follow the by value design for the actor.
> - **Best practice 5 rationale**: There are functions that otherwise exist in the library that can be used but are specific for template method calls apart of the topology of the jettl flow. For advanced functionality, such as inter process communication (IPC) and network communication, some function calls are necessary to effectively communicate between application layers with certainty to convey this to other developers.
> - **Best practice 6 rationale**: References created in a parent, but used in a child will not have a guaranteed lifetime in the perspective of the child since the reference goes out of memory when the parent is stopped, therefore the child having no control over the parent lifetime since these are asynchronous processes will have a reference which will never fully be guaranteed to exist.

## Feedback Questions

> Answer these in-line as the docs evolve. Short answers are fine.

- **What is jettl in one sentence?**: A modern actor model implementation in LabVIEW that enables strict messaging between dynamic wrapping of actors. 
- **What is jettl not (one sentence)?**: I don't know, can you be specific with what you mean?
- **Top 3 reasons to choose jettl over other patterns/frameworks**: strict messaging routing, known at edit time. dynamic wrapping of actor layers, abstract implementation through interface coupling.
- **Top 3 ways users misuse jettl today**: I don't know, can you give examples?
- **What is the smallest “hello world” actor tree worth documenting?**: An actor that wraps the Base Actor (native to jettl) and uses the stop message (native to jettl).
- **What is the first “real” example you want new users to build?**: Continuous Logging and Measurement with mock objects.
- **What part of the mental model is hardest for new users?**: I don't know, what are some examples?
- **Which terms are still ambiguous and need sharper definitions?**: I don't know, what do you think?
