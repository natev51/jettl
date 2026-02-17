# jettl Documentation

This documentation is organized in reading order. Start with **Orientation**, then read the **Glossary**, then move into the **Core Model**.

Documents under **Reference** are normative unless a section is explicitly labeled **Guidelines**, **Ideas**, or **Notes**.

> **Doc layout**
>
> - Pages live in `Sections/`
> - Images live in `Images/`

## Quickstart

1. Install jettl via VIPM.
> **RESPONSE**: provide the link for VIPM, or cross link to another part of the documentation.
2. Open the shipped examples (Example Finder keyword: `jettl`).
3. Read: Orientation → Glossary → Core Model.
4. Examine the “Hello World” actor, then extend it with one message and accompanying implemented message method override.

## Start Here

- [Orientation](Sections/Orientation.md)  
  What jettl is, why it exists, and how to read these docs.
- [Glossary](Sections/Glossary.md)  
  Canonical definitions for jettl terminology (single source of truth).

## Reference

- [Core Model](Sections/Core%20Model.md)  
  Actors, Msgs, Lifetime, and the core behavioral contracts.
- [Runtime](Sections/Runtime.md)  
  Execution semantics, scheduling, and runtime-specific behavior (RT, PPL, executables).
- [API Reference](Sections/API%20Reference.md)  
  The public surface map: “what do I call?” (with stability labels).

## Developer Workflow

- [Tooling](Sections/Tooling.md)  
  Tooling, packaging, debugging, testing, and documentation generation.
- [Readability and Style Guide](Sections/Tooling.md#readability-and-style-guide)  
  Coding conventions and readability rules used across jettl.

## How-To

- [Usage](Sections/Usage.md)  
  Patterns, examples, and practical recipes.

## Non-Normative

- [Non-Normative](Sections/Non-Normative.md)  
  Ideas, inspirations, references, and material that is explicitly not part of the formal contract.

> **RESPONSE**: Please take the following Feedback Questions and integrate them into the documentation.
## Feedback Questions

- **Primary audience (1–2 sentences)**: The primary audience are LabVIEW developers with a familiarity with object oriented programming in LabVIEW. Both beginners and experts benefit since the API internals are fully abstracted away from the developer. This is highly intuitive and procedural in the method execution. It just takes time to learn the ropes.
- **What a new user should accomplish in 30 minutes**: Understand how to implement a Hello World example by creating an actor and creating a message. Use the example that ships.
- **What a new user should accomplish in 2 hours**: create a two actor system with bidirectional communication by using the native tools that come with jettl.
- **What a new user should accomplish in 2 days**: Develop a four actor system with best practices with a few messages with Type Defs and become intimate with the native tools that encourage continuous refactoring.
- **Top 5 misconceptions to prevent**:
> **RESPONSE**: This is a great question that I need to think more about, can you please give example misconceptions?
- **What belongs in Reference vs Usage vs Non-Normative**:
> **RESPONSE**: I don't have a preference for what goes in which section, or if these names are appropriate. This works for now and I am open to suggestions.
