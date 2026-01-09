*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

Both Rename and Msg Rescript
scripting
Init -> Init Msg
Init -> Init Msg Output
Output -> Read Msg Output

---

**THEN test with the UE code.**
maybe some kind of user event that comes with the framework that creates user events for the Stop Msg and the Stopped Msg?
These user events can then come native with the framework in case of IPC communication.