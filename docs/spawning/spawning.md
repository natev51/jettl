Use of inline: want to setup resources in the Main. So inline is there for the lifetime of the Main, and since references are created in main, then they are guaranteed to be alive for the application, assuming they have not been closed).

---

Bridge Actors.

![](../images/alternate-start-async.png)

---

the inline doesn't spawn an async process. This can be beneficial in case such as:
Can get outputs from the inline call i.e. Actor state and error information. This can help with dataflow to let some top level application know that the actor has stopped since the inline function has finished executing, wiring it's state/error for serialization to a user event, etc. No user event is needed to let the application know the actor has stopped, just wait for event after the actor has finished.
- You can have multiple of these in the same application.