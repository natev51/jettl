# jettl

[![vipm-installs](https://www.vipm.io/package/nathan_davis_lib_jettl/badge.svg?metric=installs)](https://www.vipm.io/package/nathan_davis_lib_jettl/)
[![vipm-stars](https://www.vipm.io/package/nathan_davis_lib_jettl/badge.svg?metric=stars)](https://www.vipm.io/package/nathan_davis_lib_jettl/)
[![discord](https://img.shields.io/badge/Discord-%235865F2.svg?logo=discord&logoColor=white)](https://discord.gg/tVkvTyBxqa)

jettl is a modern LabVIEW actor model implementation for building scalable applications with interface-backed messaging and composable actor layers.

> TODO: Tighten the one-sentence definition for the repo landing page.
>
> - **jettl is:**  
> - **jettl is not:**  

---


## Acknowledgements

- Dedicated to [Stephen Loftus-Mercer](https://www.linkedin.com/in/stephen-loftus-mercer/) for pioneering work introducing interfaces to the LabVIEW environment.
- Inspired by the [National Instruments Actor Framework](https://github.com/ni/actor-framework) and the community that has built tools and shared discussions around it.

---

## Documentation

Start here:

- [docs/jettl Documentation](docs/jettl%20Documentation.md)

Key pages (reading order):

- [Orientation](docs/Sections/Orientation.md)
- [Glossary](docs/Sections/Glossary.md)
- [Core Model](docs/Sections/Core%20Model.md)
- [Runtime](docs/Sections/Runtime.md)

Side doors:

- [API Reference](docs/Sections/API%20Reference.md)
- [Tooling](docs/Sections/Tooling.md)
- [Usage](docs/Sections/Usage.md)

---

## High-level architecture

jettl is built around three ideas:

1. **Actor tree (relative relations)** — each actor has `Self`, (usually) one `Parent`, and zero or more `Child` actors.
2. **Layering (decoration)** — a running actor is a *unified actor* composed from multiple actor layers.
3. **Messaging (tell APIs)** — messages are interface-backed and delivered via tell calls where destinations are expressed through relative relations.

For the normative contract, see [Core Model](docs/Sections/Core%20Model.md).

---

## Example usage (minimal)

Because jettl is a LabVIEW framework, “usage” is best expressed as a repeatable editor workflow.

> TODO: Point this to a real example path in the repo once you add it.
>
> - **Hello world example path:**  

Suggested minimal steps:

1. Install via VIPM.
2. Use the template tooling to create a new actor library.
3. Create a message (interface + message class) and implement it on your actor.
4. Spawn your actor and tell the message.
5. Stop the actor and confirm `Stopped` is observed.

For canonical examples and patterns, see [Usage](docs/Sections/Usage.md).

---

## Installation

- [Install on VIPM](https://www.vipm.io/package/nathan_davis_lib_jettl/)

### Palettes

1. Open the palettes.
2. `Data Communication` → `jettl`

### Tools menu

1. `Tools` pull-down menu
2. `jettl Tools`

### Examples

In LabVIEW:

1. `Help` pull-down menu
2. `Find Examples`
3. Search for: `jettl`

In VIPM:

1. Search `jettl`
2. Right click `jettl`
3. `Get Info`
4. `Show Examples`

---


---

## Documentation structure

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

---

## Design philosophy

- Assume you cannot control message execution order.
- Prefer explicit contracts and static structure.
- Prefer composition (interfaces + decoration) over inheritance.
- Avoid using error wires or pass-through object wires solely for serialization.

See [Orientation](docs/Sections/Orientation.md) and [Core Model](docs/Sections/Core%20Model.md).

---

## Roadmap / open questions

Answer these inline to tighten priorities and reduce drift:

> TODO: Decide your near-term focus.
>
> - **Top 3 adoption blockers today:**  
> - **Top 3 framework changes to ship next:**  
> - **Top 3 tooling changes to ship next:**  

> TODO: Decide your compatibility commitments.
>
> - **Minimum supported LabVIEW version:**  
> - **Must-support targets:** Desktop | RT | executable | PPL | PPL-in-exe  

> TODO: Decide your stability policy.
>
> - **Do you want SemVer for the package?**  
> - **What triggers breaking changes?**  

---

## Community

- YouTube: https://www.youtube.com/@nathandavis6612
- Discord: https://discord.gg/tVkvTyBxqa
- Contact: [Discord](https://discord.com/users/445084342931423232) or [LinkedIn](https://www.linkedin.com/in/nathan-davis-0b020a348/)

---

## Troubleshooting: images not rendering on GitHub

Common causes:

- Wrong relative path after moving files.
- Case mismatch in filename (GitHub is case-sensitive).
- Spaces in filenames not URL-encoded in links (`%20`).
- Image extension mismatch (`.png` vs `.jpg` vs `.jpeg`).
- Image not committed on the branch you are viewing.

Palette reference:

![palette](docs/Images/palette.png)
