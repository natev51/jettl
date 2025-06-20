wish i had the ability to tell my nesteds
inside of actor to stop
i wish i had that stop functionality
23:23
https://youtu.be/N6X9KyJJ-D4?feature=shared


# Creating 
Event Actor
1. Has One Caller Queue Actor
2. Is a Nested Event Actor of Queue Actor
3. Is a Self Event Actor

Queue Actor
1. Has One Caller Queue Actor
2. Is a Nested Queue Actor of Queue Actor
3. Is a Self Queue Actor


A Queue Actor can create both Queue Actors and Event Actors.
Whereas an Event Actor cannot Create either, this is an important framework constraint.
**Return to this**

# private messages

Private messages that aren’t exposed to external callers: Library access scope.
With this, put the Last Ack Mag in jettl Library and make access scope private on library?


# references

jettl Queue Actor: Obtains and releases its own references.
jettl Event Actor: Creates, Registers, Unregisters, and Destroys its own references.


# In general notes

don't override abstract methods in inherited interfaces.

Caller, Self, Nested moved to Actor.


Maybe, Queue Actor really just is Actor where the Event Actor is just a since Msg that is DD called Event Msg where the Event Msg internally is just an event strucure acting as the front panel!

Some kind of Event Msg, just like the Loop.vi that is executed as talked about above.














# State Pattern

Context class should be private, since only interfaces should be composed into a class.
Dependency Inversion Principle.

Since the context class is private to the library it is in (and the State Interface with its concrete state classes), public static dispatch methods can be used in the context class AND concrete state classes without worrying that they'll be used outside the library since the context class is private.


Event Create (not message)
Event Last Ack (not message)
Event Teardown (not message)

Queue Actor inheritance for:
Create (Input to Queue Actor)
Setup
Teardown
Last Ack (Input to Queue Actor)