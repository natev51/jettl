# Create / Launch

Should Launch exist or does Create do the job?

Only Queue Actors can create Queue Actors and Event Actors.
Event actors cannot create either.
Further, because of these rules, only queue actors can receive the Last Ack from Nesteds. This is respectively the Queue Last Ack and Event Last Ack. Event Actors cannot receive either Last Ack.
These Last Ack messages are not used by the developer. These occur in the framework itself, though functionality can be wrapped in the developed queue actor.


# Event Actor

Event structure: Teardown Event
This is where the Teardown method goes?


# Events

- Queue Msg To Caller (Both) -> Msg To Caller
- Queue Msg To Self (Queue Actor only) -> Msg To Self
- Queue Msg To Nested (Queue Actor only) -> Msg To Nested
---------------- Inputs ARE EVENT INTERFACE!
- Event Msg To Caller (DNE)
- Event Msg To Self (Event Actor only) -> Event To Self           (delete?)

Event doesn’t dequeue a message, rather the Event is immediately after "Name.vi". And this message is just to generate an event.
Generate Event private, instead of using that in the Event Msg To Self, INSTEAD put in the Msg.vi to be DDispatched right there to generate the event :)

---
Sharing around Message Enqueuer object which has Queue DVRs inside

Queue Actor doesn’t allow this. The jettl Queue Actor is abstracted away by the Queue Actor. The Msg Queue DVRs cannot be accessed. They of course could be with accessors, which are intentionally not there to avoid sharing Msg Q DVRs.
THIS IS THE CASE, UNLESS EVENT ACTORS ARE USED. Then you CAN share references.

On the other hand, the Event Actor can be shared around and can give another queue actor or event actor the 

Sharing around the Ex Event Actor object and bundling into ExEx Queue Actor to a separate “Ex Event Actor” label of Event Actor type allows for sharing of references.
This is a wrapper wrapping a wrapper.
ExEx Event Actor wraps Ex Event Actor wraps jettl Event Actor all through the Event Actor composed Interface.
---


the event and ququqe msg To ... DONT HAVE ERROR OUTPUT, HAVE THE OBJECT OUT AND MERGE ERROR INSIDE.
do this ^^^^ it's easiest.. for now.