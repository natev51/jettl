Only the actor with the internals of actor populated can be used at the outer layer.

Actor layers where actors decorate each other:
- Implementing a Msg means you will extend functionality to it
- otherwise not implementing a Msg means you won’t add functionality to the Msg when it is called.

This is how the `Msg Handler.vi` works: what messages use with the Msg Handler to deviate to checking if in Local Msg Set and determines where to call the messages method or defer to the next decorator, and reiterating until the core conditional is called.