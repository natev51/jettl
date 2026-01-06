**Test Panel**
Automatically generated test panel providing controls / necessary inputs for all messages the actor expects.
Have the test panel display payloads from messages received.
This is to design modular Actors without dependencies of other Actors.
Which messages the Actor is able to send and to which relative actor.

`Actor.vi`
Yes. The actor does not need to have an output, but for testing purposes it is nice to have it be an output to look at the object after actor was done executing if ran by itself.
Also, to ensure the object is the same throughout its lifetimes the DD output terminal ensures this to be true.
Output terminals are available primarily for testing purposes, when one wants to unit test this actor and directly get its state / error.