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