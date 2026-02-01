## RT
For testing, decouple RT actors from hardware dependencies and RT-specific APIs. Encapsulate all hardware and RT calls behind classes with well-defined interfaces. Substitute these implementations with mock objects and unit test on the desktop target. While this approach cannot validate timing behavior or hardware-specific failure modes, it is highly effective at isolating and eliminating defects in the control logic.


## PPL
jettl released as a PPL.

---

Executable with PPLs, does the stuff still load and display the msgs on the front panel??

---

When building:

- Pick a single location for PPLs such as `C:\PPLs\[CompanyName]`.
- Name the PPL the same as the library.
- Check Exclude dependent packed libraries
- Each Library is its own project.

---

For plugin architecture, can have a dropdown function that allows you to drop a factory pattern for async spawning an actor that is not known at edit time.

---

PPL support
 comes as a single library, so it can be packed into a PPL without external dependencies.

To change a class to use the PPL version of jettl is to change the
- implemented interface to the PPL one and
- compose in the PPL Interface.

---

xnodes and malleable VIs cause build issues with PPLs, hence they do not exist in jettl.

For more information on PPLs, Darren Nattinger and Derrick Bommarito have excellent content:
- [DebuggingSymptoms - Packed Project Library PPL Dependencies - Searching for Dependencies Dialog When Running Executable](https://forums.ni.com/t5/Community-Documents/Debugging-Symptoms-Packed-Project-Library-PPL-Dependencies/ta-p/4107786)
- [PPLNamespaced Dependencies - Strategy/Design Discussion - Development Issues](https://forums.ni.com/t5/LabVIEW/PPL-Namespaced-Dependencies-Strategy-Design-Discussion/td-p/4276248)
- [LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022](https://www.youtube.com/watch?v=HKcEYkksW_o)
- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc)

**This may require a jettl Tools rewrite to accommodate for PPLs.**

## Executables

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
## Benchmarking

what is message rate for trigger messages?
So tell the self 100000 messages and take the average until the stopped message is received in the parent.
How fast does an bare actor get spawned to when the stopped message is listened to?

---

