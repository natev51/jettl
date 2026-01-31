
![](docs/images/msg-poly-selection.png)
*Polymorphic Message.*

![](docs/images/msg-implemented-recurse.png)
*Message implementation.*

Private Messages:
Putting msg library into Private Msg folder

---

*All Messages are tied to an Interface.*
Even though as developers of the actor, we know that the message is to be returned to itself (by using Tell Self), so from the message point of view, it's still abstract in that it is being sent out to *somewhere..*, it just so happens that the message comes back to yourself.