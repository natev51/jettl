
![](docs/images/actor-transport-queue.png)
*Queue Actor.*

![](docs/images/actor-transport-event.png)
*Event Actor.*

![](docs/images/actor-transport-notifier.png)
*Notifier Actor.*

---

`Finalize`: A lifecycle hook invoked at the end of each actor execution turn.

---

`No Relation`: Defined more formally as not having the same root.

---

the edge actors and core actors are persistent for every actor in the application. That means that if the root actor spawned has the `Debug jettl Actor` as one of the actors in the `Core Actors` input, this instance of the `Debug jettl Actor` will be used for each of the child actors that are spawned. The actor that is always persistent is the `Base jettl Actor`.

---

The entire jettl API has public read-only methods everywhere to gain access to the internals via a combination of method calls. These combinations of method calls can be used in wrapped actors to get necessary information of the `Unified Actor`.

---

Private Actors:
Multiple actors in one library, but there is a main actor with other libraries that contain actors, but they must be private. Rule VI analyzer can check.