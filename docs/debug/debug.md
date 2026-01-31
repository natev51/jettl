Debug with probes
Way for the hierarchy debug to link to custom probes before running to view how particular pieces of data change with reentrant VIs. Is there a way the editor can grab into the code base to find custom probes and display their internals on some other front panel?

---

`DETT Debug jettl Actor`.
Can check in the `Spawn.vi` if the `Root` = `True`, then another async process is started which gets it's data by reference since all actors spawned afterward have this persistent core layer which is registered in their own `Spawn.vi`, but only for the outermost actor by checking the `Actor Index` to ensure it is the outermost actor. The outer most actor is known by checking the array length of the `Actors` array to see how many actors make up the `Unified Actor`.

---

