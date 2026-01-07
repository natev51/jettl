incorporate the ping message and the debug / base debug libraries as intermediate actor.

At runtime, messages can be inspected in 'Msg Inspect.vi' and timestamped to show the system while it is executing.

Debug / Unit Test class wrapping.
Some kind of diagram disable in the developed actor `Decorator.vi`, surrounding the (yet to be made) `Debug.lvclass`.
That way debug code does not exist in Base classes, and is held exclusively in the `Base Debug.lvclass` / `Debug.lvclass` interface.