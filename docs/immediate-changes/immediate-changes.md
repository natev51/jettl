*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

**THEN test with the UE code.**
maybe some kind of user event that comes with the framework that creates user events for the Stop Msg and the Stopped Msg?
These user events can then come native with the framework in case of IPC communication.

---

msg rescript tool:
create a map that maps the indexes to the names of the functions so that you can use the map elements to alter the correct functions by their name.

---

update
- Stop
- Stopped

---

For the Msgs, do not include any names that are apart of the actor overrides, to avoid any further naming conflicts i.e. cannot name `Setup Msg` since the `Setup.vi` already would exist and no point to run into naming conflict if you don't have to. Have a string list here that is hardcoded in tools.
Update all the tools renaming etc.

---

rescript msg tool.
Two maps for look up between init and read I.e. Msg Input and Msg Output mapping.

---

rename msg rescript to rescript.

---

check the TEMPLATE methods for ending in `jettl Msg` or `jettl Actor` instead of just `Msg` or `Actor`

---

Attributes documentation.
`Actors` allow Self, Parent, and Children to see their state DIRECTLY AFTER Starting, helpful for persistent actors where their common method calls 









Maybe instead of passing the atrributes everywhere, just bundle them in at the beginning. so need to pass the attributes everywhere




Unified Actor

Decorator Actors
Persistent Decorator Actors
Persistent Core Actor

Persistent Decorator Actors+
Persistent Core Actor=
Persistent Actors


function for the persistent actors and persistent msgs. only in the spawn


Spawning documentation:
Use of inline: want to setup resources in the Main. So inline is there for the lifetime of the Main, and since references are created in main, then they are guaranteed to be alive for the application, assuming they have not been closed).
Bridge Actors.

template
Rename static XXXXX to just XXXXXX

---

Clean Up Wire invoke node

