# jettl Documentation

This documentation is organized in reading order. Start with Orientation, then move into the Glossary and Core Model.

Documents under **Reference** are normative unless a section is explicitly labeled **Guidelines**, **Ideas**, or **Notes**.

> **Doc layout**
>
> - Pages live in `docs/Sections/`
> - Images live in `docs/Images/`

## Start here

- [Orientation](Sections/Orientation.md)  
  What jettl is, why it exists, and how to read these docs.
- [Glossary](Sections/Glossary.md)  
  Canonical definitions for shared terms.

## Reference (normative)

- [Core Model](Sections/Core%20Model.md)  
  Actors, messages, lifetime, errors, attributes, and the core behavioral contracts.
- [Runtime](Sections/Runtime.md)  
  Deployment constraints, scheduling/priority, RT, PPLs, executables, and benchmarking.

## API surface

- [API Reference](Sections/API%20Reference.md)  
  A concrete “what do I call?” map (methods, functions, classes, interfaces).

## Developer workflow

- [Tooling](Sections/Tooling.md)  
  Build, package, debug, test, generate docs, and enforce style.
- [Readability and Style Guide](Sections/Tooling.md#readability-and-style-guide)  
  Coding conventions and readability rules used across jettl.

## How-to

- [Usage](Sections/Usage.md)  
  Patterns, examples, and practical recipes.

## Non-normative

- [Non-Normative](Sections/Non-Normative.md)  
  Ideas, inspirations, and roadmap material that is explicitly not part of the formal contract.

---

## Documentation ownership map (canonical)

This section prevents drift by making “who owns what” explicit.

- **Orientation.md** owns:
  - reading path and mental model
  - project constraints and non-goals (high-level)
  - onboarding success path
- **Glossary.md** owns:
  - definitions for shared terms (actor, transport, message, tell, etc.)
- **Core Model.md** owns:
  - normative contracts (actors, messages, lifetime/stop, errors, attributes)
  - invariants and MUST/SHOULD requirements
- **Runtime.md** owns:
  - runtime/deployment behavior (RT, PPL, executable)
  - scheduling/priority semantics
  - performance targets and benchmarks
- **API Reference.md** owns:
  - “what do I call?” maps (methods/functions/classes/interfaces)
  - stability labels for the public surface
- **Tooling.md** owns:
  - editor tooling, packaging, debug/test workflows
  - readability and style conventions
- **Usage.md** owns:
  - examples and patterns
  - integration recipes (bridge actors, periodic messaging, etc.)
- **Non-Normative.md** owns:
  - ideas, inspirations, roadmap proposals

> TODO: If you add a new page, extend the ownership map and update the reading path.

## Folder structure (repo)

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
        ├── API Reference.md
        ├── Tooling.md
        ├── Usage.md
        └── Non-Normative.md
```

## Collaboration workflow

When you answer TODO prompts, respond directly under the question using:

```markdown
> **RESPONSE:** YOUR TEXT HERE
```

This keeps your responses machine-detectable and avoids collisions with normal prose.

## Feedback questions (for improving the doc set)

> TODO: Answer these to tighten the docs and reduce ambiguity.
>
> - **Primary audience (1–2 sentences):**  
> - **What a new user should accomplish in 30 minutes:**  
> - **What a new user should accomplish in 2 hours:**  
> - **What a new user should accomplish in 2 days:**  
> - **Top 5 misconceptions to prevent:**  
> - **Top 5 “sharp edges” in the API today:**  
> - **What belongs in Reference vs Usage vs Non-Normative (1–2 sentences):**  
