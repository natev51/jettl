*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

**THEN test with the UE code.**
maybe some kind of user event that comes with the framework that creates user events for the Stop Msg and the Stopped Msg?
These user events can then come native with the framework in case of IPC communication.

---

Teller to include Priority
reorganize the folder structure.

potentially reorder where the priority occurs for the Teller. Some functions would never call the priority, hence teller. So look at the poly VIs, and also the `Tell.vi` function.

---
  
Init Msg (function)
Init Msg Output (function)
Read Msg Output (function)
**and put the class output msg in a library so that other parts of the code cannot use the private class.**

---

msg rescript tool:
create a map that maps the indexes to the names of the functions so that you can use the map elements to alter the correct functions by their name.

Maybe this can be generalized to be used for all methods and functions used?

---

move the msg interface out of their libraries.

---

have the actors live in libraries that live in the library, same with messages.
We must ensure full encapsulation of private classes, have them live in their own dedicated libraries.

classes live in their own libraries.
Msg renaming to just the Name of the Msg for the top level library.
Actor renaming to just the Name of the Actor for the top level library.

---

Maybe errors are in a private library since they're private to the actor itself.

---

attributes and transport into their own folders and libraries, remember to rename as necessary before moving!! avoid naming conflicts!!!

---

![](../images/Pasted%20image%2020260114125703.png)

![](../images/Pasted%20image%2020260114162246.png)

---

update the Stop and Stopped libraries and all of their contents.

---

okay, so the refs SHOULD be independent of the Init.
Take this away. This will make things so much easier to understand too.