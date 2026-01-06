
![[clean propagation.png]]
*Minimal bend wiring philosophy = Write code for maximum readability. Notice error wire and object verticality has plenty of room between. Object wires through for IO methods. Input only methods are a couple spaces beneath. And errors follow the method calls. All wires have minimal bends. Note even this isn't great, should instead reorganize and **please** use flat sequence structure! Note that the error wire should always be pushed to the back of the block diagram. Other wires of course can move over the error wire, but wires should NOT move over the object wire.*

[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:00-12:18

---

jettl features
- No Dependencies (outside of native LV)
- No Circular Dependencies
- No Password Protection  
- No Malleable VIs
- No XNodes
- No PPLs
- RT Compatible

---

**Control Refs**

> Use of value property is generally discouraged in VIs unless you’re having to do it with a control reference inside of a SubVI -DNatt [Improving Your LabVIEW Code with the VI Analyzer](https://forums.ni.com/t5/VI-Analyzer-Enthusiasts/Improving-Your-LabVIEW-Code-with-the-VI-Analyzer/m-p/3415352)@12:26

Why did I call it Control Refs and not another one Indicator Refs? Answer: LabVIEW identifies indicators as controls.

> Tip: You may place in clusters (make sure they’re type defs) in the Control Refs cluster to differentiate controls, indicators, sub panels, etc.

Minimize the use of references put into the Control Refs cluster. Instead maximize their use in the event structure for better readability.
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@00:45:46
Only use when these control refs are used in message methods OR methods constrained in message methods. Otherwise, if there is a method call in the event structure, do you best to wire in the VI Server control reference to the method as an input instead of passing the entire object wire into the method.

---

Interchangeable front panels
Where you have two created actors, and ability to toggle front panel displays as either being in the subpanel.

![[statepatternactors.png]]
*[The State of the Art for Actor Framework](https://www.youtube.com/watch?v=gz_6FTE1__8&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19) @21:33.*

---

Convincing yourself of Unhandled Msgs working
Panel Close? Event with Stop Tell Self followed by another Stop Tell Self (order doesn't matter, they're executed in parallel anyway.)
See if that Msg, in Destroy was an Unhandled Msg ie 1bd with array of Msgs.

---

