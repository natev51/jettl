The following includes a list of changes to the framework that can be done immediately.
The order of items presented is in no particular order.

---

Rename tool
change the scripting to rename the TEMPLATE Refs at it's object front panel names AND containing library.

Also, note that it is probably best to script the methods (for user events) as public API so that other parts of the project can access them, think about private actors to the one who is sharing it's references, you want to be able to share these events around.
Also, if you play nicely, this can lead to an easier distributed broker since the reference and the scripted value change events are public.
Tool above for scripting the events.
is it better to have these user events from the scripting to be messages??

`Find Local Msg Set`
`Union Unified Msg`

change these to functions and just call the functions where they internally recurse the layers?
That way they're not overridable in the TEMPLATE Actor?
Maybe invert them where the DD is in the function call???


---
---
---

Add back the Init.vi for all tree msg transports..?
That way these can still be tested well.
change the functions to be public, for testing purposes. this exposes the API well.

---
---
---
