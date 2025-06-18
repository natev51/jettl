don't override abstract methods in inherited interfaces.


Stop Core Doesn't always happen after pre launch init, here it does in the error case

wish i had the ability to tell my nesteds
inside of actor to stop
i wish i had that stop functionality
23:23
https://youtu.be/N6X9KyJJ-D4?feature=shared


Auto-stop? (T) default behavior cannot change


Event Actor
1. Has One Caller Queue Actor
2. Is a Nested Event Actor of Queue Actor
3. Is a Self Event Actor

Queue Actor
1. Has One Caller Queue Actor
2. Is a Nested Queue Actor of Queue Actor
3. Is a Self Queue Actor


- Queue Msg To Caller (Both)
- Queue Msg To Self (Queue Actor only)
- Queue Msg To Nested (Queue Actor only)
- Event Msg To Caller (DNE)
- Event Msg To Self (Event Actor only)
- Event Msg To Nested (Queue Actor only)


