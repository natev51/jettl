
1. Always develop in your own library and develop actor code that depends on that library. That way the code used is decoupled from the Actor and can be tested independent of the actor.
2. Best practice: Tend to NOT use Priority Boolean when telling messages.
3. Naming Msgs: Somewhat detailed names ~3-4 words. This is due to mitigating naming issues when overriding the method names. For example, a message called `Begin Msg` is too simple where naming conflicts can occur for other overrides. A better name, depending on context, would be `Begin Pump Sequence Msg`.
4. Object wire must never be split unless:
	- directly going to a read only method or
	- unbundle
5. Before `Setup.vi`, an actor cannot send itself or it's parent messages since resources have not been setup.
6. Only call functions and methods on the palettes.
7. Setup references in `Setup.vi`. These are async processes. If references are created in an actor (Actor A), but used in another actor (Actor B). If Actor A is destroyed (without closing the reference), but the reference is still being used in Actor B.. the reference will be destroyed leading to confusion of the developer since they hadn’t closed the reference in the Actor B. Takeaway: create and destroy references in the same actor. This is the exact reason the Self Attributes references are created in the actor being created. Because if the creator is destroyed, the created actor will still have its references alive. In particular, when initializing the actor, take care to not create references in `Init.vi`, if you expect to destroy the references in the created actor, due to reasons above. Rather, move the creation of these references to `Setup.vi`.
