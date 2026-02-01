

---



---



---



---



---



---



---



---



---








---

---



---





---









---

Mediator / Assembler Wrapper  
  
Mediator pattern is data flow friendly and DOES NOT cause memory leaks since a created Actor only occurs once at a time, through the mediator.

A Non-reentrant vi can be within the override of Spawn so that only one can occur at a time.

  
And can only shut down if the mediator says that the Actor should shut down.  
The mediator knows who has whose reference to send messages.  
This helps establish the observer pattern too.  
No deadlocks can occur since the mediator operates one by one.  
It is the all-knowing for the application, only forwarding messages to references that the message is intended for.  
An actor ever only knows about the mediator.  
  
Kind of the same framework you currently have.. just that the messages interact with a mediator that then (since it has references to everything) sends the message to the necessary actor.  
Note the Self Actor still has references to its Self, Parent, and Children.. it's just that the mediator ALSO knows who has these references and easily sends the message to those who have the reference that the message is going to has.  
This provides well for the observer pattern i.e. publisher and subscriber.  
There are effectively two places references are saved: Mediator and Self Actor.  
The Mediator always has the references and shares the necessary duplicates of references that pertain to the Self Actor since these are references to identify the Actor and how the mediator should allow the actor to interact with other actors (though, remember, the Actor doesn't know other actors exist.. only that there is a mediator).  
Further, the mediator knows which methods are messages of the actor through the Unified Msgs.  
This is known at compile time since messages are all through interfaces, allowing the mediator to know which messages the actor can execute by checking which interfaces the actor implements.  
This check happens in the mediator, not in the actor.  
  
Just thinking out loud, here is a concrete component that basically handles the business logic of the system with other sub business logic components that are more specialized / reusable. This can be thought of as some top level actor.  
  
Multiple application instances Idea:  
Application mediator that is between all.  
Or there is always a double layer of mediators?  
Where the top layer facilitates what the lower mediator does.. and when there is another application instance (which has its two mediators), the top mediators of both communicate to each other.  
The top mediators know about each other's references, so they can communicate with each other.  
  
If two applications are talking with each other, there now exist two mediators.  
An idea for this: there is again a mediator that is *above?* these two mediators?  
  
Assembler strictly for passing references to other Actors for the Observer Pattern.  
  
have to ASK the Assembler to create these.

---



---

Philosophy:
Always assume you cannot control the order that messages execute.

---



---


General Best Practice:
If a function has output object, it SHOULD be wired.
> VI analyzer test that looks if that terminal has an associated wire connection.

---

Testing / Debugging
Since `Actor.vi` is NOT a decorator method, that means only the outer local actor 'Actor.vi' will be executed.
An advanced scheme of wrapping an “outer layer” can occur where the wrapping layer(s) have the actor decorator method within. this allows only the DD methods outside of the Actor.vi to be executed. Very advanced, but remarkably helpful for advanced functionality in debugging and testing.

—-

Readability:
Only have top left and top right conn panes as Object in / Object out
Errors too

---

Feature
All Boolean logic is positive logic.

---

Errors signify that
- intended operation could not be performed, otherwise said also that
- Indication that a function could not complete it’s assigned task

[https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk](https://youtu.be/00TZxeyt8_A?si=C3kbhPJ4HtcmhOfk)

An example of intermediate actors:
Since each error that can occur in a method is known, an Actor decorator, for example, can override this behavior by clearing errors as necessary. It is the default behavior to put all jettl errors on the error wire to expose the API to the developer, and the developer can decide which errors to ignore for each individual method.


Best Practice: Errors should be handled with the method that generates that error. For example, when an error occurs in a method, it is best to handle the error as necessary during execution of the method call (this means in decorated methods too, think in a decorated layer of actor, handling errors that come out of Setup.vi in another layer).

—-

All errors that can occur in jettl are documented in `jettl.lvlib:Error.lvlib`

Best Practice: For EVERY method / function call, you SHOULD KNOW EVERY ERROR that will come out of that method / function, and document it for the developer. Otherwise, the error *likely* was passed from a previous method / function. You will know this by the call chain.

[https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189](https://forums.ni.com/t5/Actor-Framework-Discussions/Actor-Stopping-Error-Handling/m-p/3632216#M5189)

---

Errors

https://www.youtube.com/watch?v=AHOZ7fiuWCA
timestamp 42:05
Embrace the flat sequence structure for serialization, NOT error wires.
An error wire input and output tells the developer that the error can be modified in the method!

---

### Spawn Hierarchy Actor

Initialization requires:
- Self Attributes
- Parent Attributes
Note: Child information is redundant information since can construct everything with Self and Parent Attributes. Think relative relations.

After sending message, logs to file the **Time**
After listening to a message (in ‘Inspect.vi’ with ‘Msg Listened To.vi’), logs to file the **Listened Time**

---

Base Debug Actor
This is effectively an event logger.

File is created for EACH Actor in a central temp application directory, and a time stamp with a call chain / object hierarchy are logged with events etc. This way we can easily write these values to disk as an internal actor logger. These are separate files as to not compete with resources, writing to its own file, ensuring no other actor is also writing to that file.

—-

Generalized Error Actor
For the Errors generated in the program..
In some actor layer, can override this default behavior by overriding the ‘Finalize Turn.vi’

---

### Wrappers

Actors that decorate other actors can interact with common method calls between layers, in particular with data defined by messages. Think about the input and output data for a message.

---

Unified Msgs:
Msgs are decoupled between layers telling a message defined in an internal layer but not the outer actor or core actor still means the message would be in 'Unified Msgs'.

---

Unit Testing
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!

---

Panel Actor
Sub Panelsw
After 'Spawn.vi', access to Child Attributes, which has ‘VI Ref’, so can easily put this VI Ref into a Sub Panel here. And further, since you directly have access to the VI Ref of the Child Attributes, can modularize where front panels are in Actor front panel of Self i.e. changing around panels.

---

`Stop.vi'
- always starts as `False`
- only be changed to `True` in  `Stop.vi`
- can never be changed back to `False`

---

Should Stop.vi

`Stop` = TRUE
OR
Error (then Stops)
outputs `Can Stop` = True

Error from Finalize Turn.vi means that the actor should stop, hence Stop will be called, if not called already.

—-

### jettl Tools

Implement message interface AND auto populates that interfaces message method with 'Recurse.vi' and necessary wiring.
https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580

---

Testing:
DD output terminal on the `Actor.vi` prevents the object wire from changing

---



---
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

Revert back to 2020 (not SP1!)

---

jettl is a typed frameworks, you cannot send a message not in the msg set of the receiving actor (the type system prevents it)




---

the inline is good because it doesn't spawn an async process. This can be beneficial in case such as:
Can get outputs from the inline call i.e. Actor state and error information. This can help with dataflow to let some top level application know that the actor has stopped, wiring it's state/error for serialization to a user event, etc. No user event is needed to let the application know the actor has stopped, just wait for event after the actor has finished.
- You can have multiple of these in the same application, if you wish.

---

Readability: Connector Pane

Confirm that a VI adheres to connector-pane layout matches the expected pattern:
* **Object terminals (class/interface terminals)**: top-left and top-right
* **Error terminals**: bottom-left (**error in**) and/or bottom-right (**error out**).
* **Typical inputs**: two left middle and/or bottom middle terminals.
* **Object Specific Inputs**: top middle inputs for functions/methods specifically designed to wrap functionality of an object.
* **Outputs**: right middle terminals. Place **outputs** on the **right side** (typically two terminals).

A Static Analyzer can ensure those reserved terminals contain **only** the expected types (e.g., prevents unrelated controls/indicators from occupying the object/error positions).

Follow this rule that an object in MUST be an object passed out for the same color wire horizontally across the method / function call.
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:45:21

Input and output on conn pane:
[An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k)@00:23:59

—-
Message Destination

Actor messages are only sent to actors that have the msg in their “unified msgs” valid recipients:
* Determines where messages are allowed to go for a given actor (e.g., **self**, **parent**, **child**) based on static selection a polymorphic message destination at edit time. Uses that knowledge to prevent invalid message paths if the relationship required by a message is not satisfied, an error will be generated at runtime preventing runtime messaging errors.

A Static Analyzer test can eliminate these runtime errors where a message is sent to an actor that cannot handle it.

`Not In Unified Msgs.vi`: Even if the framework filters messages correctly at runtime, add a defensive fallback by decorating the message-handling code in a case structure that safely handles “received but not implemented” messages. This should never occur under normal operation, but it provides a clear debugging signal if a framework or configuration defect allows an unexpected message through.

**Static Child UIDs**

The goal is a fully static, deterministic system that still supports dynamic behavior. In practice, that means the `Static Child UIDs.ctl` is static.

Under the hood, UIDs are stored as strings in `Child Attributes Map.ctl`, but the `Static Child UIDs.ctl` enum is the developer-facing abstraction. The enum represents the different UIDs used for child actors. Because each actor defines its own private enum, the runtime mechanism is a string mapping that can be validated to ensure it only maps enum elements to their corresponding string values.

This provides two benefits:
* Actor code uses enums exclusively, avoiding the fragility of stringly-typed identifiers.
* The internal string representation remains compatible with mapping needs.

The enum currently is edited manually.