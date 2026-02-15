# jettl Documentation

This documentation is organized in reading order. Start with Orientation, then use the Glossary and Core Model as your reference for definitions and contracts.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

> Note: Pages live in `docs/Sections/`. Images live in `docs/Images/`.

## Start here

- [Orientation](Sections/Orientation.md)  
  What jettl is, why it exists, and how to read these docs.

## Reference

- [Glossary](Sections/Glossary.md)  
  Canonical definitions. Other pages link here rather than redefining terms.
- [Core Model](Sections/Core%20Model.md)  
  Normative semantics: actors, messaging, lifetime/stop contract, errors, attributes, and reentrancy.
- [Runtime](Sections/Runtime.md)  
  Runtime behavior and deployment constraints (RT, PPLs, executables, benchmarking).
- [API Reference](Sections/API%20Reference.md)  
  The public surface area: palettes, interfaces, classes, and stability notes.

## Developer workflow

- [Tooling](Sections/Tooling.md)  
  Build, package, debug, test, document, and maintain jettl-based systems.

## How-to

- [Usage](Sections/Usage.md)  
  Patterns, examples, and practical recipes.

## Non-normative

- [Non-Normative](Sections/Non-Normative.md)  
  Ideas, inspiration, external references, and backlog material that is explicitly not part of the formal contract.

## Documentation conventions

### Canonical ownership and cross-links

Concepts are defined once, in a single authoritative section. Everywhere else:

- Use a one-sentence summary.
- Link to the canonical definition/contract section.

> TODO: Confirm the canonical ownership map below (edit inline if you disagree).
>
> - **Definitions (terms):** Glossary  
> - **Normative behavior contracts:** Core Model  
> - **Deployment / performance behavior:** Runtime  
> - **Developer workflows + coding conventions:** Tooling  
> - **Patterns + examples:** Usage  
> - **Future ideas / inspiration:** Non-Normative

### TODO and collaboration workflow

All TODOs use fill-in templates so you can answer inline without restructuring the document.

Recommended response format (so your replies are machine-searchable and visually distinct):

```markdown
> **RESPONSE:** YOUR TEXT HERE (YOU CAN USE ALL CAPS IF YOU WANT)
```

> TODO: Confirm the response marker you want to standardize on.
>
> - **Preferred marker format**:
> - **Do you want date stamps on replies?**:
> - **Do you want question IDs (e.g., Q-CORE-01)?**:

### Link and image rules

File names include capitalization and spaces; links must match exactly.

- Encode spaces in links as `%20`.
- GitHub paths are case-sensitive: `Images/` ≠ `images/`.

Image rules (debugging-friendly):

- The alt text matches the image base name.
- No empty `[]` remains.

For pages under `docs/Sections/`:

```markdown
![image-name](../Images/image-name.png)
```

For this file under `docs/`:

```markdown
![image-name](Images/image-name.png)
```

For `README.md` at repo root:

```markdown
![image-name](docs/Images/image-name.png)
```

## Find place for these new additions

If you temporarily park scratch notes here, treat this as an inbox. Each item should be relocated into its canonical section and replaced with a short link.

> TODO: Paste new additions here as bullet points (one per line), then annotate with the intended destination.
>
> - **Addition:**  
>   **Proposed destination:** (Orientation / Glossary / Core Model / Runtime / Tooling / Usage / Non-Normative)  
>   **Notes:**  
>   > TODO: If ambiguous, write the question here.
