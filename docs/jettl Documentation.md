# jettl Documentation

This documentation is organized in reading order. Start with Orientation, then read the Core Model.

Documents under **Reference** are normative unless a section is explicitly labeled **Guidelines**, **Ideas**, or **Notes**.

> **Doc layout**
>
> - Pages live in `Sections/`
> - Images live in `Images/`

## Start Here

- [Orientation](Sections/Orientation.md)  
  What jettl is, why it exists, and how to read these docs.

## Reference

- [Core Model](Sections/Core%20Model.md)  
  Actors, Messages, Lifetime, and the core behavioral contracts.
- [Runtime](Sections/Runtime.md)  
  Execution semantics, scheduling, and runtime-specific behavior (RT, PPL, executables).

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

## Feedback Questions

- **Primary audience (1–2 sentences)**: The primary audience are LabVIEW developers with a familiarity with object oriented programming in LabVIEW. Both beginners and experts benefit since the API internals are fully abstracted away from the developer.
- **What a new user should accomplish in 30 minutes**: Understand how to implement a Hello World example by creating an actor and creating a message.
- **What a new user should accomplish in 2 hours**: create a two actor system with bidirectional communication by using the native tools that come with jettl.
- **What a new user should accomplish in 2 days**: Develop a four actor system with best practices with a few messages with Type Defs and become intimate with the native tools that encourage continuous refactoring.
- **Top 5 misconceptions to prevent**: This is a great question that I need to think more about, can you please give example misconceptions?
- **What belongs in Reference vs Usage vs Non-Normative**: I don't have a preference for what goes in which section, or if these names are appropriate. This works for now and I am open to suggestions.

`Find place for these new additions:`

Please ensure that things are not repeated across documentation, links are helpful, but instead of repeating information that is stated in a different section (due to changes in the future would require changing the information in two places), instead write a quick sentence with a link to show where more details would be found.
I am also adding in the README.md file which is in the same directory as `docs`, therefore any images in README.md will also come from the `docs\images` folder.
Please make the necessary changes for a simple README.md that belongs on a GitHub page. Please give suggestions and ideas in the README.md that I can respond to.
Please also incorporate any changes that are under the `Find place for these new additions:` in the `jettl Documentation.md`. Please ask clarifying questions where they should go with a TODO comment in the markdown file they are inserted in. Please make future suggestions in the markdown files under a TODO that I can respond to there. Any high level suggestions, you make make this apart of your response.
I have responded in all capital letters for my responses (such as CAN YOU PLEASE EXPLAIN THIS) so that you can easily understand my direct responses to you, opposed to general edits I have made in the documentation. Is responding in all capital letters good? What formatting is easiest for you? Making the all capital letters bold? italicized? underlined? How would it be easiest to discern these?