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