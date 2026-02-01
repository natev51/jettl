All external tools belong in the same common location: `Tools` -> `jettl Tools`.
Please place them in this common location, helping developers easily find your tool!
> Of course, please place company / name specific tools in their own folder as well if further credit should be given to your tool i.e. Tools -> jettl Tools -> YOURNAME -> YOURTOOLNAME.

---

## Notes Across the Board

Tools do allow changes to occur on dependencies. Only those selected under the target specified.

---

could add: Have in the tree the path to the right as well.

---

Requirement for tools: supports PPLs.

## Current Native Tools
### Rescript

How To Use:
Only the left two inputs can be scripted.
Only the right two outputs can be scripted.

Future clean up: `Script Msg.vi`:
Clean Up Wire
invoke node, wire, CleanUpWire
## Rename

both actor and msg renaming:
take the library(s) it is contained in and properly put them in a hierarchical map where the names are in fact unique depending on their path/hierarchy of library(s).

### Template



## Current External Tools

None
## Tool Ideas

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