[GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc) @00:37:52-00:43:43.
[NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)

[Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY)@00:32:13.

**Confirmed!**

> "Find Local Msg Set.vi" can function properly in the executable. In development mode, the message classes are loaded into memory specific to the actor that can receive them. Whereas, it has not been confirmed that this also occurs in an executable. We have taken care to use method calls that can be used in the runtime / real time. But have not confirmed. In short, a message class lives in a library which also contains the interface that an actor implements for the message. Since the actor must load it's parents into memory (i.e. message interfaces), then the library must also be loaded since it contains the interface. Hence, the message class in that same library ALSO should be loaded since it is apart of the library. On the same coin, this should also occur with the message function.


PPLs**
Although early in the jettl lifecycle, I am open to building the main jettl library into a PPL.
This may require a jettl Tools rewrite, but might be worth looking into.
I avoid PPLs because DNatt told me to.
I recommend these presentations before considering the use of using PPLs:
- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc)
- [LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022](https://www.youtube.com/watch?v=HKcEYkksW_o)