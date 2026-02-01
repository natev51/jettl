Debug with probes
Way for the hierarchy debug to link to custom probes before running to view how particular pieces of data change with reentrant VIs. Is there a way the editor can grab into the code base to find custom probes and display their internals on some other front panel?

---

`DETT Debug jettl Actor`.
Can check in the `Spawn.vi` if the `Root` = `True`, then another async process is started which gets it's data by reference since all actors spawned afterward have this persistent core layer which is registered in their own `Spawn.vi`, but only for the outermost actor by checking the `Actor Index` to ensure it is the outermost actor. The outer most actor is known by checking the array length of the `Actors` array to see how many actors make up the `Unified Actor`.

Note: can't get DETT trace data from VIs in vi.lib.

---

Testing / Debugging
Since `Actor.vi` is NOT a decorator method, that means only the outer local actor `Actor.vi` will be executed.
An advanced scheme of wrapping an “outer layer” can occur where the wrapping layer(s) have the actor decorator method within. this allows only the DD methods outside of the Actor.vi to be executed. Very advanced, but remarkably helpful for advanced functionality in debugging and testing.

---

Base Debug Actor
This is effectively an event logger.

File is created for EACH Actor in a central temp application directory, and a time stamp with a call chain / object hierarchy are logged with events etc. This way we can easily write these values to disk as an internal actor logger. These are separate files as to not compete with resources, writing to its own file, ensuring no other actor is also writing to that file.

---

incorporate the ping message and the debug / base debug libraries as intermediate actor.

At runtime, messages can be inspected in 'Call Inspect.vi' and timestamped to show the system while it is executing.

---

