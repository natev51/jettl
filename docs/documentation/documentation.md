Actor Msg Documentation

Use `Tell Self.vi`, `Tell Parent`,  and `Tell Child.vi` to visualize messages between Actors since jettl mandatorily needs to know where the message goes at edit time i.e. the relative actor relation.
Being able to point it to an actor and have it statically analyze and create the diagram for each actor.

---

Antidoc integration.

- Msg method browser
- Msg destination browser

- Actor spawning hierarchy (display actor hierarchy and where they are spawned. This is known when the `Start` has executed.)
- Msg Browser

Documentation:
- Messages an actor can implement
- Messages an actor can tell to `Self`, `Parent`, and `Children`


Diagram could be built by static analysis of code or analysis of DETT output.

---

Tell Child Destination problem

Since spawning children are dynamic, extra steps must be taken to ensure understanding of where a message will go to which child.

Define, at edit time, which messages are routed to which child actor.

You can do this with scripting by locating calls to `Tell Child.vi` and then resolving the target child by tracing the input back through the `Format Into String` primitive to the associated `Child UIDs` enum. This lets the tooling determine the destination name statically, so it’s clear where the message will be sent at run time.

This approach only works when the destination string is a straightforward `Format Into String` + enum pattern. If the string is modified elsewhere, built dynamically, or selected via conditional logic (for example, choosing between two enums), the script will not be able to reliably infer the destination. This shouldn't be used nonetheless, and should be static for easiest code readability.

For clarity and maintainability, keep message routing as static as possible: use an enum wired into `Format Into String` to represent the child target, and avoid intermediate string manipulation or conditional destination selection when you want tooling to accurately show message destinations.