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









Setup AS a message.
- Always executes as first message.
- Enables to Setup again
- Eliminates the error queue. (Check for NOT A REFNUM in Create.vi to ensure that error didn’t occur at enqueue.)

Teardown ONLY bundles Teardown into State.
Teardown State methods should be deleted.

Receive State Methods should be deleted.

Handle DOES EVERYTHING.

repath the actor.vi in start async and alternate start async.vi.
delete the error shit in create.

Caller, Self, Nested moved to Actor.


Maybe, Queue Actor really just is Actor where the Event Actor is just a since Msg that is DD called Event Msg where the Event Msg internally is just an event strucure acting as the front panel!