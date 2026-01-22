These docs are a self-contained document written for LabVIEW developers seeking a proficient understanding of jettl.

These docs are a living document and contributions are welcome through the means of the GitHub README.

This document is meant to be a complete guide to the jettl framework, outlining a starting point for understanding the design philosophy and implementation details.

---

Hello World
Don't need to send yourself Stop for Hello World. Just have Stop itself at the end of the Hello World Msg.

---

Unit testing
With the Actor interface, this model is interface-composition based with the decorator Pattern, so unit testing is built in by decorating one of the internal actors with a unit test actor.

One can see immediately that an infinite number of actors can be decorated, leading to a powerful feature of the interface-composition based decorator pattern.

---

State pattern  
Context classes should be private, since only interface objects should be composed into a class.  
Dependency Inversion Principle.  
Since the context class is private to the library it is in (and the State Interface with its concrete state classes), public static dispatch methods can be used in the context class AND concrete state classes without worrying that they'll be used outside the library since the context class is private.  

Factory Pattern  
The Factory Pattern is used to create instances of actors without specifying the exact class of the actor that will be created.  
This allows for greater modularity in the actor design.  
Easy Factory pattern integration with actor interface for plug and play architectures.  
PPLs.

---

Periodic messaging
This could be an event actor, but notifiers work well with timing.
If it was an event actor, then the event actor would have to wait for the next event to occur via the timeout case in the event loop.
But there would be interruptions in the event loop, which would cause the event actor to not be able to send messages at the correct time.

---

Msg
These messages follow the Interface Segregation Principle (ISP) by having one method in the messages interface.

All messages come from an interface and follow ISP where one message belongs to one interface.
If there is a naming issue, that is a good thing.
It means in the dependencies, you should be packaging modules so you don't run into naming issues.


Private Messages

Private messages that aren't exposed to external callers: Library access scope.

---

Observer pattern
Sending events across the tree via the No Relation type

---

Messages with Type Definitions

Type definitions as inputs SHOULD be in the library, not the class they're implemented in.
This is fundamentally an exercise in dependency inversion.

Cluster message with type def inside of the library.
Good practice to put the type def here and NOT in the class that implements the message.
This takes care of otherwise awful circular dependencies.

---

Errors

[The Errors of our Ways | Stephen Loftus-Mercer GDevCon N.A. 2021](https://www.youtube.com/watch?v=00TZxeyt8_A) @52:08
'That was handled, or I wouldn't have been called' - SLM

---

PPL support
 comes as a single library, so it can be packed into a PPL without external dependencies.

To change a class to use the PPL version of jettl is to change the

implemented interface to the PPL one and
compose in the PPL Interface.


jettl does not include:

xnodes
malleable VIs

xnodes and malleable VIs cause build issues with PPLs, hence they do not exist in jettl.


For more information on PPLs, Darren Nattinger and Derrick Bommarito have excellent content:
\begin{itemize}
    \item \href{https://forums.ni.com/t5/Community-Documents/Debugging-Symptoms-Packed-Project-Library-PPL-Dependencies/ta-p/4107786}{DebuggingSymptoms - Packed Project Library PPL Dependencies - Searching for Dependencies Dialog When Running Executable}
    \item \href{https://forums.ni.com/t5/LabVIEW/PPL-Namespaced-Dependencies-Strategy-Design-Discussion/td-p/4276248}{PPLNamespaced Dependencies - Strategy/Design Discussion - Development Issues}
    \item \href{https://www.youtube.com/watch?v=HKcEYkksW_o}{LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022}
\end{itemize}

—-

Readability:

The top left and top right connector panes are reserved for the containing object input and object output
The bottom left and bottom right connector panes are reserved for error input and object output


Virtual folders are not saved on disc.
These are only convenience in the LabVIEW project.

—-

Color scheme

"Look down at the green grass, look up to the blue sky, and look further to the purple galaxy."

Purple Library: RGB (166,153,182)
Blue Interface: RGB (104,136,190)
Green Class: RGB (110,149,108)

Icons

Banner
Shows library/interface/class name.
Color of banner name text indicates access scope of containing library/interface/class.
Color of banner indicates a library/interface/class container.
Text of method name.
Color of method name text indicates access scope of method/control

---

Access Scope

Only public and private.
Interfaces, classes, and methods have text in the banner/icon that are black (public) and red (private).

Classes icon for private data is blank entirely. Nonetheless, if something is added ensure the text is red since the private data is a private control.

Emphasis is put on encapsulated classes are classes (maybe container libraries) marked private.
Class encapsulation. Any class should be marked as private to the library containing them.
That way, developers are not allowed to use the classes outside of the containing library, leading to use of dependency inversion with interfaces and help with mitigating circular dependencies.
Further, libraries contained within other libraries should be marked private.

Rules:
Nested Libraries should be marked private, otherwise, put the nested library outside the containing library.
Classes should be contained in at least one library
Interfaces and classes must be contained in at least one library

—-

Errors

No error goes unrecognized.

Why are there are so many error case structures?
All functions/methods in are assumed to run unconditionally when they are called.

Also, no serialization of errors.


Abandoning IO Serialization:
An indication that the data in the data type will *potentially* be manipulated is when a data type is being passed in and out through a method.
Unless a data type can be manipulated in an Interface, then the data type should not have an output.

If a method must be serialized, embrace the flat sequence structure / error case structure.
DO NOT pass a data type from the input to the output of the method for the *sole purpose* of serialization.
Understand that other developers will not know your intent and will assume that the data in the datatype will be manipulated.
Not wiring the outputs gets rid of this thinking entirely for better readability.
Further, do not serialize by using an error cluster input and output.
This provides difficulty for readability since the developer does not know if the error is being manipulated by the method.

No error goes unnoticed in the framework, everything is reported (except for releasing references).

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

Helper Loops
Instead of helper loops, spawn a child actor. This maintains a single loop within an actor. This emphasizes not branching the actor object to different loops.

---

Philosophy:
Always assume you cannot control the order that messages execute.

---

Details of Interest:
Msgs can be sent to Self and Parent (and any children spawned) in Setup.vi.

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

