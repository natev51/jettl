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

Errors library private.

---

update
- Stop
- Stopped

---

**All** Decorator method have functions inside.

So you would be calling the function in normal code, not the methods themselves.
Have these function calls on the palette.
Don't calls methods in `Actor Overrides` and `Msg Overrides`, just the functions in the palette.

Note, palette contains ALL function calls that can be made, no need to venture to the library for them, just look in the palettes. If they were not meant to be touched, they would be private. Though, be careful, some functions are exposed specifically for being able to get details about the actor in testing and debugging situations.

---

For the Msgs, do not include any names that are apart of the actor overrides, to avoid any further naming conflicts i.e. cannot name `Setup Msg` since the `Setup.vi` already would exist and no point to run into naming conflict if you don't have to. Have a string list here that is hardcoded in tools.
Update all the tools renaming etc.

---

tools map of init conn pane to output conn pane

---

return to errors on inputs for the message stuff.

---

