## Tools

### Notes For All Tools

All external tools belong in the same common location: `Tools` -> `jettl Tools`.
Please place them in this common location, helping developers easily find your tool!
> Of course, please place company / name specific tools in their own folder as well if further credit should be given to your tool i.e. Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME.

---

Tools do allow changes to occur on dependencies. Only those selected under the target specified.

---

could add: Have in the tree the path to the right as well.

---

Requirement for tools: supports PPLs.

### Current Native Tools
### Rescript

How To Use:
Only the left two inputs can be scripted.
Only the right two outputs can be scripted.

Future clean up: `Script Msg.vi`:
Clean Up Wire
invoke node, wire, CleanUpWire
### Rename

both actor and msg renaming:
take the library(s) it is contained in and properly put them in a hierarchical map where the names are in fact unique depending on their path/hierarchy of library(s).

### Template



### Current External Tools

None
### Tool Ideas

### Moving Msg and Actor Libraries

Moving Actors and Msgs on disk.
also in project explorer into the correct destination
- into Private Msg Folder of an actor, or
- out of any library to the top level target.

Creating an actor after an actor has already been created can only be placed in the private folder for the actor already created.
What about messages? Well, maybe a message can ONLY be created after an actor has been created and must be placed in either the public or private folder? If this isn’t the case, what’s the use case for having messages be standalone? So here’s a reason: no coupling the message to the actor. So where would this exist then, just on its own? But then there’s a potential name spacing issue right? Maybe an option when creating a TEMPLATE Msg to either be 1. in the project, 2. Private msg folder of actor library, 3. Public msg folder of actor library.
On this topic, actor has the same options, with stipulation that only one top level actor library can be in a project.

Make the message a
1. private internal Message, 
2. fully public Message.
### Forward Msg

By further accessing parents parents, can look at the `Read Root.vi` to find if the parent is the root.
This can show if a parent above has access to this message or if the message is registered (has to be static registration unless you want to just send the message to the parent and it figures out the registration it has, which then if the actor is handling the message can look at what has been dynamically registered and send accordingly.)

how msg forwarding can be implemented to parent:
An actor can recurse through it's parents parents parents, etc at look each parents unified msg set.

to child:
Or going down the tree can look at the unified msg set of the children it has, then it's children, etc.


`Read Parent Attributes` to `Read Unified Msgs` to see if parent implements the msg, can recurse the parents, parents, parent, etc.
OR
Explicit registration for forwarding on `Setup.vi`.

in order to use a forwarding tool, messages still need to be in the `Unified Msgs`. But must register for the messages before setup to put these “non-implemented” messages in the `Msgs`. Or some other `msgs`? That way these messages being told still need to be validated that certain messages are in the `Unified msgs` OR `Non-Implemented Msgs`. Yes, there can be overlapped msgs in both msgs!! In case not in `unified msgs`, then check if in `non-implemented msgs`.

The non-implemented msgs can of course be dynamic since inserting or removing from set can happen depending on which external actor you’re communicating with.
### Generate Implemented Msg

1. Select Actor
2. Select interface msg to implement
3. in msg overrides -> default virtual folder, override interface method
4. put the poly of that msg with recurse selected
5. wire up recurse as necessary

Effectively developer could "select" which Msgs to add to the actor.

This combats when many interfaces and classes loaded and one wants to have actor implement a msg that is tied to interface.
This tool would bypass all classes not tied to a message and have a dropdown of only messages one can implement.
This helps since one doesn't need to search through the laborious tree search for the name and hierarchy of the messages method.

Descriptions for message naming:
Use .ini parsing to get the unique identifier associated with message in the description.
i.e.

```
$
[Msg]
"UID": e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
$
```

where the UID is generated when creating the TEMPLATE Msg.

---

Msg renaming idea, actors that implement the message
Have a unique hash for the interface message and have that be generated in the overridden method description, etc. so that the method itself KNOWS (not necessarily where to look for the message) but at least can find what the message is (if loaded into memory).
Unique interface message identifier in description.
Maybe instead, have it be in the library description. Can have other information here for uniquely identifying if the message has been scripted.

---

When creating the implemented msg with `Recurse.vi`:
Make sure that the controls and indicators are in the correct positions so that it is easy for the developer to properly change the control / indicator position.
For the Actor override, have this be consistent location for control / indicators.

---

Implement message interface AND populates that interfaces message method with 'Recurse.vi' and necessary wiring.
[Programmatically add a parent interface to a class](https://forums.ni.com/t5/LabVIEW/Programmatically-add-a-parent-interface-to-a-class/td-p/4239580)


### Un-Generate Implemented Msg

Removes message from actor.

Additionally:
> If the developer un-implements the interface that is tired to the overridden method, then this is a non-interface tied message method.
> Side idea:
> Tool idea: This is a static tool.
> For implemented message methods that class doesn't implement the interface i.e. a message that cannot ever be executed since not tied to implemented interface.. **OR CAN IT?**
> When a interface message is implemented, but messages method is not implemented.

### Msg Destination Viewer

Where messages go, relative to the actor (both to and from).
- implemented messages
- outbound messages to parent, child, reply (can only be within the method call being enacted since that is where the teller interface comes from, have to trace it back through subVI calls if necessary.)

### PPL Conversion

Take an actor and it's messages and convert to PPL.

### Create Errors in some folder.

the `placement--error.vi`

### Ref Tools

Tool for scripting User Events functions.
Also, note that it is probably best to script the methods (for user events) as public API so that other parts of the project can access them, think about private actors to the one who is sharing it's references, you want to be able to share these events around.
Also, if you play nicely, this can lead to an easier distributed broker since the reference and the scripted value change events are public.
Tool above for scripting the events.
is it better to have these user events from the scripting to be messages??

### Navigating Msg Methods

- Right click a `Method.vi`, finds the interface it's overridden from and goes to the parent method in the interface.
- Right clicking the interface method finds all instances where the method is implemented.

This will have to deal with the polymorphic method calls rather than just the interface method for better understanding of the system.

### Actor Browser

Per Actor based window that allows you to scroll through the
- Actor Overrides
- Msg Overrides

Looks in the respective virtual folder.
## VIPM

This library is compatible with **LV 2020 and beyond**.
Note: If using LV2020, please consider using *LV 2020 SP1* and due to issues resolved here: [LabVIEW 2020 SP1 Bug Fixes](https://www.ni.com/en/support/documentation/bugs/20/labview-2020-sp1-bug-fixes.html?srsltid=AfmBOooUbuV9waHiF74KkrteQY7SRCENumzj1XCdQMWldAIuQMDW1sM6).
## Debug

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


## Unit Tests

Caraya
LUnit

Approval Tests
Come with the ability to create separate projects to perform unit tests.

One thing I feel that AF (or other frameworks) could borrow from DQMH is the amount of scripting built in. I especially think that an automatically generated test panel is feasible. As simple as a scripted event structure that provides buttons for all messages the Actor expects, and then have it listen and display payloads (serialized) from  all methods defined in any interfaces the Actor has available.

---

Unit testing
With the Actor interface, this model is interface-composition based with the decorator Pattern, so unit testing is built in by decorating one of the core actors with a unit test actor.

One can see immediately that an infinite number of actors can be decorated, leading to a powerful feature of the interface-composition based decorator pattern.

---

Unit Testing
The actor object can be logged before and after method execution, along with its inputs to determine potential use case unit tests to be tested for!
Some kind of Actor can be a wrapper that takes this information and logs it to file.

---

DD output terminal on the `Actor.vi` prevents the object wire from changing at runtime.

---

**Test Panel**
Automatically generated test panel providing controls / necessary inputs for all messages the actor expects.
Have the test panel display payloads from messages received.
This is to design modular Actors without dependencies of other Actors.
Which messages the Actor is able to tell and to which relative actor.

`Actor.vi`
Yes. The actor does not need to have an output, but for testing purposes it is nice to have it be an output to look at the object after actor was done executing if ran by itself.
Also, to ensure the object is the same throughout its lifetimes the DD output terminal ensures this to be true.
Output terminals are available primarily for testing purposes, when one wants to unit test this actor and directly get its state / error.
## Documentation

Actor Msg Documentation

Use `Tell Self.vi`, `Tell Parent`,  and `Tell Child.vi` to visualize messages between Actors since jettl mandatorily needs to know where the message goes at edit time i.e. the relative actor relation.
Being able to point it to an actor and have it statically analyze and create the diagram for each actor.

---

Antidoc integration.

- Msg method browser
- Msg destination browser

- Actor spawning hierarchy (display actor hierarchy and where they are spawned. This is known when the `Start` has executed.)
- Msg Browser

Documentation:
- Messages an actor can implement
- Messages an actor can tell to `Self`, `Parent`, and `Children`


Diagram could be built by static analysis of code or analysis of DETT output.

---

Tell Child Destination problem

Since spawning children are dynamic, extra steps must be taken to ensure understanding of where a message will go to which child.

Define, at edit time, which messages are routed to which child actor.

You can do this with scripting by locating calls to `Tell Child.vi` and then resolving the target child by tracing the input back through the `Format Into String` primitive to the associated `Child UIDs` enum. This lets the tooling determine the destination name statically, so it’s clear where the message will be sent at run time.

This approach only works when the destination string is a straightforward `Format Into String` + enum pattern. If the string is modified elsewhere, built dynamically, or selected via conditional logic (for example, choosing between two enums), the script will not be able to reliably infer the destination. This shouldn't be used nonetheless, and should be static for easiest code readability.

For clarity and maintainability, keep message routing as static as possible: use an enum wired into `Format Into String` to represent the child target, and avoid intermediate string manipulation or conditional destination selection when you want tooling to accurately show message destinations.
## Readability

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

**Object IO and Error IO**

The top left and top right connector panes are reserved for the containing object input and object output
The bottom left and bottom right connector panes are reserved for error input and object output


If a function has output object, it SHOULD be wired by the developer.
> VI analyzer test that looks if that terminal has an associated wire connection i.e. wire reference is valid from scripting.

Connector Pane
* **Object IO (class/interface terminals)**: top-left and/or top-right
* **Error IO**: bottom-left and/or bottom-right.
* **Typical inputs**: two left middle and/or bottom middle terminals.
* **Object Specific Inputs**: top middle inputs for functions/methods specifically designed to wrap functionality of an object.
* **Outputs**: right middle terminals.

A Static Analyzer can ensure those reserved terminals contain **only** the expected types (e.g., prevents unrelated controls/indicators from occupying the object/error positions).

[An End to Brainless Programming - Darren Nattinger](https://www.youtube.com/watch?v=pS1UBZzKl9k)@23:59
Input and output on conn pane.

[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@45:21
Follow this rule that an object in MUST be an object passed out for the same color wire horizontally across the method / function call.

---

Virtual folders are not saved on disc.
These are only convenience in the LabVIEW project.
Organizing virtual folder contents, very helpful with keeping name spacing consistent. [Large LabVIEW Project Development Techniques](https://youtu.be/7zS3Q_K71XY?si=VZXcWRaCqc0C4tWh)@:14:08-14:46

---

**Color scheme**

Coloring
Banner colors, easy to see if interface method is on the class object wire since they’re different colors! And ALWAYS the same colors for banner and object wire!
[Your LabVIEW Code Is a Work of Art... But I Can't Read It by Darren Nattinger. GDevCon N.A. 2024](https://www.youtube.com/watch?v=AHOZ7fiuWCA)@40:34

jettl coloring scheme:
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

Public vs. private methods/functions
Public: only the actor’s API surface—i.e., messages and actor API methods that define how other components interact with the actor.
Private: any additional helper methods or functions created to implement behavior should be private to the actor.

---

Class/Interface ownership terminals. The upper-left terminal (and upper-right, if present) indicates the class/interface wire that owns the banner method. This signals to the developer that the VI is a method contained by that class/interface. Reserve the upper-left and upper-right connector pane terminals only for the class/interface wire for the method that the class/interface contains. Library functions are not methods and are not contained by a class/interface. As a result, library functions must not use the upper-left/upper-right object terminals.

Mutability and readability conventions. If the same object type comes in and is passed out horizontally, callers should assume that object may have been mutated (whether it actually was or not).This convention most commonly applies to the class/interface wire (upper-left to upper-right) and the error cluster (lower-left to lower-right).

Immutable pass-through is an antipattern. If the input object is immutable and you are only wiring it to the output to preserve dataflow/serialization, that is an antipattern because it falsely implies mutation. In this case, do not wire the immutable object to the connector pane output. If you need sequencing (for example, to serialize operations), use a Flat Sequence Structure rather than passing the object through solely for serialization.

Apply the same rule to the error wire, the error wire should not be used for serialization. If you need explicit sequencing without implying mutation, embrace the Flat Sequence Structure (or another explicit sequencing construct) rather than relying on the error wire.