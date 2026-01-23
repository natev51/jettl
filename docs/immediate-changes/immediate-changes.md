*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

Goals:

7. Rescript Tool
	- Clean Up Wire invoke node where necessary

8. run code to ensure it's running

---

add in additional function calls for the actor index i.e. if it is the outer actor, if it is a persistent actor, 

---

more specific functions for `within unified msgs` and `within msgs`, both take the `actor` ? as an input.


---

Spawning:
Edge (1)
Near Edge (n)
Mid Edge (1)
Mid (n)
Mid Core (1)
Near Core (n)
Core (1)
Have some examples that show the relationships with some number of actors being wrapped.

---

`Init Msg Default.vi` which is JUST the instantiated object.
Change the `Init Msg Default` and `Init Actor Default` as necessary.

do this for the three messages
do this for the two messages

---

For the developer code, add comments that explain if can modify and touch or DO NOT MODIFY.
`Init Actor`: DO NOT modify!

---

implement the tell self inspect, tell parent inspect, tell child inspect, tell reply inspect