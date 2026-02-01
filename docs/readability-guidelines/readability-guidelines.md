**NO Helper Loops!**
Best practice: Instead of helper loops, spin up another actor.

Private Actor virtual folder allows actors to live within another actors library.
Separating the concerns of actors should be a normality where there’s the controller and view.
Think for an actor system, a queue actor that needs an event helper loop. Rather, make this helper loop an event actor that is tightly coupled to the queue actor by having the event actor in the same library as the queue actor.

Helper Loops
Instead of helper loops, spawn a child actor. This maintains a single loop within an actor. This emphasizes not branching the actor object to different loops.

---

**No Property Nodes!**

Property Nodes are not used due to banner color not being displayed.

[Using a Message Broker with DQMH Actors for High Speed/Throughput Data logging](https://www.youtube.com/watch?v=jNBAvNQJyO8&list=PLvDxiIkwuMQvrSQIqy_it5Q7-sGvM4XX8&index=3)
@7:33

---

Nested Libraries Reason:
Each nested library defines it's own access scope controlling which parts have access to other parts which can hide from the public.

---

Fundamentally, class inheritance should not occur for actors.
Instead, (for something like a HAL) use dependency inversion with the strategy pattern to pick and choose the implementation to use for THAT actor.

---

Default function
Icon: ctrl+shift+k, left justified, not capital, red text
private
conn pane: error out
Shared clone

Default SD
Icon: ctrl+shift+k, left justified, not capital, red text
private
conn pane: object in, error out
Shared clone

Default DD
Icon: ctrl+shift+k, left justified, not capital, black text
public (has to be)
conn pane: object in, error out
Shared clone

---

The top left and top right connector panes are reserved for the containing object input and object output
The bottom left and bottom right connector panes are reserved for error input and object output

---

Virtual folders are not saved on disc.
These are only convenience in the LabVIEW project.

---

**Color scheme**

Purple Library: RGB (166,153,182)
Blue Interface: RGB (104,136,190)
Green Class: RGB (110,149,108)

How to remember:
"Look down at the green grass, look up to the blue sky, and look further to the purple galaxy."



Icons

Banner
Shows library/interface/class name.
Color of banner name text indicates access scope of containing library/interface/class.
Color of banner indicates a library/interface/class container.
Text of method name.
Color of method name text indicates access scope of method/control

---

Function vs Method:
A function is a VI that does not have object IO for the containing object they're contained in, if they are contained in the object.
A method is a VI that has one or both of it's object IO conn panes of the containing object.

---

Access Scope

Only public and private.
Interfaces, classes, and methods have text in the banner/icon that are black (public) and red (private).

Classes icon for private data is blank entirely. Nonetheless, if something is added ensure the text is red since the private data is a private control.

Emphasis is put on encapsulated classes are classes (maybe container libraries) marked private.
Class encapsulation is used for decoupling concrete implementations to the outside world. Only functions and interfaces should be exposed to the outside world. All classes should be marked as private to the library containing them.
That way, developers are not allowed to use the classes outside of the containing library, leading to use of dependency inversion with interfaces and help with mitigating circular dependencies.
Further, libraries contained within other libraries should be marked private unless these libraries contain public function/method calls, then the library could remain public.

Rules:
- Interfaces and classes must be contained in at least one library

---

