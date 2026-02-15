# API Reference

This page is a concrete “what do I call?” map for jettl.

- **Conceptual semantics** live in the Core Model: see [Core Model](Core%20Model.md).
- **Runtime behavior and deployment constraints** live in Runtime: see [Runtime](Runtime.md).
- This file is intentionally organized by **call surface**, not by conceptual layering.

## Stability / maturity labels

Use these labels consistently for every public entry in this file.

- **Stable** — backwards compatible (or a documented migration path exists).
- **Beta** — expected to change; used by early adopters.
- **Experimental** — may be removed or redesigned without notice.
- **Deprecated** — supported for now but scheduled for removal.

> TODO: Define how you want to express versioned stability.
>
> - **Do you want semantic versioning (SemVer) for the VIPM package?**  
> - **If yes, what triggers MAJOR vs MINOR vs PATCH?**  

## Module / palette index

Fill this in as a discoverability map. The goal is: “I need X → which palette/module contains it?”.

| Module / Palette | Purpose | Primary entry points | Notes |
|---|---|---|---|
| **Actor** |  |  |  |
| **Messaging (Msgs)** |  |  |  |
| **Teller (Tell APIs)** |  |  |  |
| **Attributes / Introspection** |  |  |  |
| **Errors** |  |  |  |
| **Tooling** |  |  |  |

> TODO: Add any missing modules you expose publicly (for example: Transports, Testing, Debug).

---

## Actor API

### Spawn / construction

> TODO: List the canonical spawn calls and their intent.
>
> - **Inline spawn Root (VI name):**  
> - **Async spawn Root (VI name):**  
> - **Async spawn Child (VI name):**  
> - **Blocking behavior (if any):**  

#### Template (copy/paste per call)

```markdown
#### CALL NAME

- **Stability:** Stable | Beta | Experimental | Deprecated  
- **Purpose:**  
- **When to use:**  
- **Inputs:**  
- **Outputs:**  
- **Errors:**  
- **Threading / reentrancy notes:**  
- **Related concepts:** (link to Core Model sections)  
- **Examples:** (link to Usage examples, screenshots)  
```

### Lifecycle hooks

This section maps the lifecycle methods you override/implement and how they relate.

> TODO: Confirm the canonical names and ordering.
>
> - **Init hook(s):**  
> - **Setup hook(s):**  
> - **Start hook(s):**  
> - **Stop hook(s):**  
> - **Teardown hook(s):**  
> - **Finalize hook(s):**  

### Actor “layer” API (decoration)

> TODO: List the public extension points for wrapper layers.
>
> - **Decorator method(s) that wrappers override:**  
> - **Rules for calling recurse / next layer:**  
> - **Where output data from messages is consumed:**  

---

## Messaging API

### Tell APIs (Self / Parent / Child)

This is the most common “what do I call?” question.

> TODO: Fill in the exact VI names for tell calls.
>
> - **Tell Self:**  
> - **Tell Parent:**  
> - **Tell Child:**  
> - **Tell No Relation (if supported):**  

> TODO: Capture any optional knobs (priority, timeout, error policy, validation).
>
> - **Priority exposed?**  
> - **Validation behavior when a message is not implemented:**  
> - **Where policy lives (Core Actors vs Base Actor vs caller):**  

### Message creation / scripting

> TODO: Document the generated artifacts and where they live.
>
> - **Message interface naming pattern:**  
> - **Message class naming pattern:**  
> - **Where typedef inputs should live:** (link to Core Model)  

### Message outputs

Messages can return outputs for wrapper layers.

- Canonical contract: see [Messages Producing Output Data](Core%20Model.md#messages-producing-output-data).

> TODO: Decide whether you want a *convention* for output terminal usage across all messages.
>
> - **Output terminal 1 reserved for:**  
> - **Output terminal 2 reserved for:**  

---

## Attributes / introspection

- Canonical semantics: see [Attributes](Core%20Model.md#attributes).

> TODO: List the stable introspection chains you want to guarantee long-term.
>
> | Intent | Example chain | Stability | Notes |
> |---|---|---|---|
> |  |  |  |  |

---

## Errors

- Canonical semantics: see [Error Model](Core%20Model.md#error-model).

### Error catalog

> TODO: Link to the error library and list the “top 10” errors new users hit.
>
> - **Error library path:**  
> - **Top error #1:**  
> - **Top error #2:**  
> - **…**  

---

## Tools API

This section maps “editor tooling” to how developers discover and run it.

> TODO: Fill in a tool index.
>
> | Tool | Menu location | Purpose | Inputs | Outputs |
> |---|---|---|---|---|
> | Rescript | Tools → jettl Tools →  |  |  |  |
> | Rename | Tools → jettl Tools →  |  |  |  |
> | Template | Tools → jettl Tools →  |  |  |  |

---

## Interfaces / classes index

This section is a names-only index for fast lookup.

> TODO: Populate the index from your public surface.
>
> - **Interfaces**
>   - 
> - **Classes**
>   - 

