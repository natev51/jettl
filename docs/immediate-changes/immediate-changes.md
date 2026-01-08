*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

Rename tool
change the scripting to rename the TEMPLATE Refs at it's object front panel names
**Name Ref**

Both Rename and Msg Rescript
scripting
Init -> Init Msg
Init -> Init Msg Output
Output -> Read Msg Output

---

Find Local Msg Set can occur in spawning. Since can iterate on every decoration, outputs the local msg set array that is found and appends to an array which appends to another array of all decorations, which goes into the Union Local Msg Set function.
This ensemble can go into its own function too, this function puts out “Unified Msg Set”

Now, there might be some renaming for these clusters again..

---

Check that UID is not blank
create a function that can be dropped around for this.