Init.vi Inputs:  
- Msg Strategy
- Period

Process.vi
- unbundle Period
- timeout case: unbundle Msg to send to Creator.vi


#### Periodic Messaging
An actor should not have in its own timeout way to do something periodically such as send itself a message every 100 ms.
Instead it must create a periodic messaging actor which in its timeout sends the message to the actor that requires the periodic message. Separate the concerns.



time delayed send message. Could be some actor that is created that periodically sends out a trigger message with some kind of unique data input that signifies to the parent that this is the action that needs to be taken for periodic message handling.
This way the concerns are separated and the handling of messages is strictly governed by the parent actor itself.