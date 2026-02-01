Notes when building exes:

Check Conditional Disable Structures for broken code in `RUN_TIME_ENGINE==TRUE`.

Uncheck
- Disconnect type definition
- Remove unused polymorhic instance
-  removes unused VIs from libraries

---

[GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc) @00:37:52-00:43:43.
[NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)

[Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY)@00:32:13.

---

`Find Msgs.vi` functions properly in the executable. In development mode, the message classes are loaded into memory specific to the actor that can receive them. We have taken care to use method calls that can be used in the runtime / real time. In short, a message class lives in a library which also contains the interface that an actor implements for the message. Since the actor must load it's parents into memory (i.e. message interfaces), then the library must also be loaded since it contains the interface. Hence, the message class in that same library ALSO should be loaded since it is apart of the library.