These messages follow the Interface Segregation Principle (ISP) by having one method in the messages interface.

All messages come from an interface and follow ISP where one message belongs to one interface.
If there is a naming issue, that is a good thing.
It means in the dependencies, you should be packaging modules so you don't run into naming issues.

---

Messages with Type Definitions as inputs:
Type definitions as inputs SHOULD be in the library, not the class they're implemented in.
This is fundamentally an exercise in dependency inversion.
Cluster message with type def inside of the library containing the message.
Good practice to put the type def here and NOT in the class that implements the message.
This takes care of otherwise awful circular dependencies.

---

![](docs/images/msg-poly-selection.png)
*Polymorphic Message.*

![](docs/images/msg-implemented-recurse.png)
*Message implementation.*

---

Private Messages:
Putting msg library into Private Msg folder

Certain messages within an actor library are intended to be private. These messages are sent by the actor to itself and are not meant to be told by external actors.
Private messages should be clearly marked in the browser, or optionally hidden entirely, so that developers can easily distinguish between private and public messages.

Private messages that aren't exposed to external callers: Library access scope.

---

*All Messages are tied to an Interface.*
Even though as developers of the actor, we know that the message is to be returned to itself (by using Tell Self), so from the message point of view, it's still abstract in that it is being sent out to *somewhere..*, it just so happens that the message comes back to yourself.

---

`No-Children Actors` are actors that cannot spawn children. These are actors that only message with their parent and cannot have children to message with.

Since a parent must spawn a child, the parent knows the messages the child will tell it, since these are statically defined through the `Tell Parent.vi` for any particular message. Therefore, there could be a runtime check that a parent cannot spawn a child if the parent does not implement all of the messages.

Suppose an actor is intended to be used as a child actor which communicates with it's parent.

For this to work, the parent must implement the interface methods that the child uses for message communication. This requirement is communicated to other developers through the generated documentation for the child actor, which explicitly lists the messages the actor can tell to the parent and messages the child actor has implemented.

If the parent does not care about listening to any messages from the child, it is not required to implement the interface, and the message methods are effectively no-ops. This can be handled either in the parent by overriding `Call Inspect.vi`, or in the child by overriding `Tell Parent Inspect.vi`, depending on where the default behavior is most appropriate.