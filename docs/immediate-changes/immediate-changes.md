The following includes a list of changes to the framework that can be done immediately.
The order of items presented is in no particular order.

---

Rename tool
change the scripting to rename the TEMPLATE Refs at it's object front panel names.

Also, note that it is probably best to script the methods (for user events) as public API so that other parts of the project can access them, think about private actors to the one who is sharing it's references, you want to be able to share these events around.
Also, if you play nicely, this can lead to an easier distributed broker since the reference and the scripted value change events are public.
Tool above for scripting the events.