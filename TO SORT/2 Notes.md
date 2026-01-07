
Best Practice: Instead of helper loops, it is encouraged to spawn a child actor that acts as a helper loop. Fhis maintains a single loop within an actor. This emphasizes to not branch the actor object to different loops.

---

Advice: Always assume you cannot control the order that messages execute.

---

Advice: Msgs can be sent to Self and Parent in `Setup.vi`, only after the decorator method since register for events in the `Setup.vi` Base Actor method.

---

General Best Practice: If a function has output object, it SHOULD be wired.
> VI analyzer test that looks if that terminal has an associated wire connection.

---

Advice: Since `Actor.vi` is NOT a decorator method, that means only the outer local actor 'Actor.vi' will be executed!

---

General Best Practice: Only have top left and top right conn panes as Object in / Object out

---

'jettl': All Boolean logic is positive logic.

---

jettl: 'Actor.vi' Sets up and Tears down all references in the same call.

---

Errors signify that
- intended operation could not be performed, otherwise said also that
- Indication that a function could not complete it’s assigned task

[https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk](https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk)

An example of intermediate actors:
Since each error that can occur in a method is known, an Actor decorator, for example, can override this behavior by clearing errors as necessary. It is the default behavior to put all jettl errors on the error wire to expose the API to the developer, and the developer can decide which errors to ignore for each individual method.
For example, clearing errors that come from the Tell methods if an Address is not registered anymore.

Best Practice: Errors should be handled with the method that generates that error. For example, when an error occurs in a method, it is best to NOT handle the error in 'Error Handler.vi'. Rather, handle the error as necessary during execution of the method call (this means in decorated methods too, think in a decorated layer of actor, handling errors that come out of Create.vi in another layer).
This can be company specific intermediate actors.

'jettl': All know errors that can happen in jettl are documented in `jettl.lvlib:Error.lvlib`

Best Practice: For EVERY method / function call, you SHOULD KNOW EVERY ERROR that will come out of that method / function, and document it for the developer. Otherwise, the error *likely* was passed from a previous method / method. You will know this by the call chain.

[https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189](https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189)

---

https://www.youtube.com/watch?v=AHOZ7fiuWCA
timestamp 42:05
Embrace the flat sequence structure for serialization, NOT error wires.
An error wire input and output tells the developer that the error can be modified in the method!

---


### Hierarchy Monitor Intermediate Actor

Initialization requires:
- Self Attributes
- Parent Attributes
Note: Child information is redundant information since can construct everything with Self and Parent Attributes.

After sending message, logs to file the **Tell Time**
After receiving message, logs to file the **Receive Time**

**Start Time**
This logging should go into **Start.vi** wrapper actor

---

Intermediate Actor Logging  
EACH Actor can have an event logger.

File is created for EACH Actor in a central temp application directory, and a time stamp with a call chain / object hierarchy are logged with events etc. This way we can easily stream these values to disk as an internal actor logger.

Wrapper
For the Errors generated in the program..
In some actor layer, can override this default behavior by decorating the actor
This Actor Wrapper can come native as a reuse library.

### Wrappers

Advice: when decorating actors, they don’t know about each other, but decorated actoes can interact with common method calls between layers, this includes data defined by messages!

---

'jettl': Msgs are decoupled between layers
sending a message defined in an internal layer but not the outer actor or corr actor still means the message will be in the 'Unified Msg Set'.

---

Unit Testing idea
Other idea about unit testing:
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!

---

Sub Panels
After 'Spawn.vi', access to Child Attributes, which has Actor Ref, so can easily put this into a Sub Panel here. And further, can modularize where front panels are in Actor front panel of Self i.e. changing around panels since you directly have access to the Actor Ref of the Child Attributes.

---

`Stop.vi'
- always starts as `False`
- only be changed to `True` in  `Stop.vi`
- can never be changed to `False`

### Can Stop.vi

`Stop` = TRUE
OR
Error (then Stops)
outputs `Can Stop` = True

Note: unhandled error has occurred and the system cannot continue, hence Stop will be directly called.

### jettl Tools

Tool that allows actor to implement message interface AND auto populates that interfaces message method with 'Component.vi' and necessary wiring.
https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580

---

TEMPLATE
PD: open refs array

---

Actor / Msg Enum
Replace ALL string types with this one.

---

Target combo box:
- Rescript
- Template
- Rename


'jettl': 'Terminate` Msg sent to both parent and all children

Testing:
`Actor.vi` has output for potential debugging done outside of the scope of the framework ie for testing, running the `Actor.vi` on its own.

Testing:
So having a DD output terminal on the `Actor.vi` minimizes runtime errors preventing the object wire from changing AND for testing, by running the `Actor.vi` in isolation to gain insights to an actor without starting it up asynchronously.

---

Error:
Don’t have terminals on error IO unless they are errors.
This is the same philosophy used for the object IO terminals.

---

Fundamentally, a message cannot be sent to an actor that cannot implement that msg.
Also, a tool for determining if a message can be sent to sel like if there are multiple actor layers and a message sent to self but can receive locally but can in another layer.

---

Instead of class inheritance, the decorator pattern already has the methods overridden with functionality. So you don’t have to create a new override method, just move the method to the extended virtual folder (for developer experience) and append functionality as necessary.
jettl does not require ever modifying class inheritance since class inheritance is not recommended. Recommended practice is using interface implementation for all classes mixed with dependency inversion.

---

Standardize on Network Streams for LabVIEW communication between applications
Gives rise also to distributed system design having multiple hierarchies communicating with each other through their lowest created actors.

---

Revert back to 2020 (not SP1!)

---

jettl is a typed frameworks, you cannot send a message not in the msg set of the receiving actor (the type system prevents it)