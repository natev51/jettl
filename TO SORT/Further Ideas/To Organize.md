
First, note that you can launch and send a message to an actor from any LabVIEW code, not just other actors. The tricky part is getting answers *back* from that actor. This is where the bridge (or adapter, or shim code) comes in.
Start off by creating a proper actor. It does whatever you need it to do (perhaps it handles hardware), and follows all the rules - no data communication except through actor queues, and no reply messages! This lets you reuse the actor in pure AF applications as well as your current mixed environment.
Then you create the bridge/adapter actor. This actor sits between your calling code and your 'pure' actor. It interacts with the pure actor in a strict AF style. But since its caller isn't an actor, you can break the rules when sending data to that caller.
Give the bridge/adapter a set of standard messages that match the ones you will send to its nested actor. (This is trivial if you use interfaces.) These are just pass-throughs; the bridge will just forward them to its nested actor.
Also give the bridge one or more reference objects. Use DVRs for tags, or queues for streaming data or messages. The calling code can create these objects and pass them to the bridge at startup, or the bridge can create them and send them to the caller, perhaps as a message. (The former is easier, but you may need to do the latter if the calling VI goes out of memory before the actor terminates - this is common in TestStand systems.)
When the pure nested actor sends data to the bridge, the bridge stores that data in the appropriate reference object.
The calling code pulls data from those reference objects as and where it needs to do so. For example, if the caller is a regular queue driven message handler, you might pass the QMH queue into the bridge actor. When the bridge actor receives a message from its nested actor, it creates a message for the QMH, gives it the data from the nested actor, and sends the message to the QMH.
If the calling code is NOT a QMH, then I wouldn't forward messages (since the caller isn't message driven). I would wrap all of the code to talk to the bridge in a class, with Create/Destroy VIs to launch the bridge actor, VIs that send commands (by sending a message), and VIs that read data (by accessing DVRs or queues).

---

Debug

In the Spawn Logic.vi, can decorate the Core Actor with some debug Actor that gets DDd at runtime depending on the debug implementation. This could occur ONLY for the Spawn Root though so that it only needs to occur in one place for an application.
Inputs for Actor Layers and Application Actor Layers i.e. all layers have these layered actors for every actor i.e. Debug Actor wraps Core Actor.



Aside, maybe the Spawn and Spawn Root have their own functions that couple directly into that function, just like the Panel Actor has inputs from other function calls to initialize it.
So a potential Debug Actor could be a DETT actor.


On the topic of debug, care has been taken to not include any diagram disable structures yo prevent unnecessary build issues.

---

Creating references in parent before child spins up is a recipe for disaster since when the parent stops, the reference since created in the parent (but still used by the child) will be released leading to the child actor doing operations on a released reference.
Best practice: create and release references in the same actor.

It’s the reason jettl always creates its own event references. Lifetime is guaranteed.

---

Target info

no way to preserve the queue reference across machines.

---

State Pattern

https://www.youtube.com/watch?v=N12L5D78MAA
https://www.youtube.com/watch?v=HewNBC4TjKs
https://www.youtube.com/watch?v=IM8ZU1af6wQ&list=PLvDxiIkwuMQsxPk5KC9B1kdJboV-9GJKh&index=22

This is true, you would have to drop the Entry from Actor Core.. keep Exit in Actor Core works.. it gets tricky since Entry and Exit are DD output terminals. It makes sense because you want the same object coming out of Entry and Exit: but what if you wanted to change state WITHIN Entry? Then Entry would need to have a SD output terminal since this is not the same object coming out. This could be addressed if the AF was instead a composed class instead of inherited class (since you need to change the parent actor data with substitute actor). I think I'm just rambling now.. I will say though, Allen, that the Entry and Exit can be put into their own interface. And then implementation could occur in the concrete classes (ie Context AND concrete states)
“Not allowing a state change in Entry or Exit was intentional. Logically, you need to fully enter or exit a state before you can change states. So that infinite transitioning of states cannot occur”

https://www.youtube.com/watch?v=GRDoyn1mNAI&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=18
https://www.youtube.com/watch?v=yVzT5ZqUuVU&list=PLvDxiIkwuMQtGtstTGKpYpoMVi1Lj07EP&index=19

---

Add in a Spawn Msg in the jettl library which is just a wrapper for the Spawn function.

---

TDSM

note a presentation by Ethan stern
Something like all around periodic message
So actor is launched for timing, but the actor that spawned it holds the truth for the state of the periodic message in case of timing issues where the child sends another message after sending. This behavior can be handled in the inspect override.

---

TDMS idea from CButch

I mostly use TDSM internally, but one thing to possibly note is that it sends a message periodically - that doesn't imply that they are executed periodically. In particular, if the duration of the message execution can become long, or the Actor might be busy with other things (consider, perhaps, sporadically unavailable hardware with a significant timeout period for messaging, which you want to reconnect to when available), then you might have a very large queue allocated before you reconnect. That has consequences for memory usage and also the time taken to process a large number of messages (even if individually quick) once reconnected or whatever.
In those cases, I tend to send a normal message and have it send a TDSM at the end with only one copy, rather than an infinite number - this ensures there's only ever one copy in the queue, regardless of execution time.

---

Maybe instead of monitoring the queue, etc
The tell messages are (in a wrapper actor!) put into a log and marked as not read (organized by timestamp), then when the message is being acted upon, then the “listened to msg” = True for the message matching the timestamp can be marked as read. This will allow the system to properly allow for knowing how many msgs haven’t been executed, etc.


Also, for an inter actor system, can wrap around Core Actor (using spawn root) the functionality of holding DVRs as some mediator process to allocate sending messages across the tree via user events. This is a single application only method for publisher-subscriber, by using the decorated actor methodology.

---

Intra application LabVIEW, with non-jettl code:

before spawn, pass in the queue or event references you want it to use to send out any data.

---

Notes on building exes:

One of the checkboxes removes unused VIs from libraries. That one is particularly pernicious.

Also check for Conditional Disable Structures that have broken code in the `RUN_TIME_ENGINE==TRUE` frame.

Unchecking Disconnect type definition and remove unused polymorhic instance solved the issue

---

For the stuff, have a tree with the path to the fright as well.


Also, note the tools do allow changes to occur on dependencies! Just what is in the project under development.

Creating an actor after an actor has already been created can ONLY be placed in the private folder for the actor already created.
What about messages? Well, maybe a message can ONLY be created after an actor has been created and must be placed in either the public or private folder? If this isn’t the case, what’s the use case for having messages be standalone? So here’s a reason: no coupling the message to the actor. So where would this exist then, just on its own? But then there’s a potential namespacing issue right? Maybe an option when creating a TEMPLATE Msg to either be 1. in the project, 2. Private msg folder of actor library, 3. Public msg folder of actor library.
On this topic, actor has the same options, with stipulation that only one top level actor library can be in a project.

---

Msg Forwarding:

Read Parent Attributes to Read Unified Msg Set to see if parent implements the msg.
> "Is there a clean way to check if a message belongs to a certain interface?
check incoming messages and forward them to parent if they are part of a certain interface (think messages from nested GUI actors that simply want to be routed to main controller)"

https://www.vipm.io/package/zyah_solutions_lib_zyah_af_msg_forwarding/
Our method depends on the Msg being created by the scripting tools and put in the default location relative to the interface:
![[Images/Msg Forward.png]]

---

jettl Feature: Ability for other actors to be spawned in setup!!!!!!!!!!

---

Network Endpoints

https://www.youtube.com/live/1ubKjLSnFi0?si=mvIoviRpQWjLijJ1

---

RT Testing

justACS
Wherever possible, decouple your RT actors from the hardware and RT APIs - wrap those calls in a class, and then create abstract parent classes or interfaces for them. Then, replace those classes with mock objects and unit test the actors extensively on your desktop target. You can't test for timing, obviously, or for issues arising from hardware calls, but you can eliminate issues related to your control logic.

---

Reentry section:
Everything is shared clone except for:
`………`

Notable methods that deal with reentry to be talked about:
`………`

---

System designer

jettl does this:
identify when an actor calls a "Tell Self.vi", etc. This works to visualize messages between Actors since jettl mandatorily needs to know where the message goes at edit time i.e. the relative actor relation!

2. Being able to point it to a Project and have it statically analyze and create the diagram.
3. Being able to turn on a "highlight execution" mode to visually see messages as they are sent and received.



Aside:
option on creation of the Message to make the message a
1. private internal Message, 
2. fully public Message.


Aside on msgs:
*All Messages are tied to an Interface*
Even though as developers of the actor, we know that the message is to be returned to itself (by using Tell Self), so from the message point of view, it's still abstract in that it is being sent out to *somewhere..*, it just so happens that the message comes back to yourself.

---

jettl Tools (msg Rescript tool):
Make a private map for the VI Refs for the name to the index to easily use for scripting instead of the arbitrary indexes.

Good info in here, old news though from 10/2024
![[Images/DBomm Interfaces.png]]

---

Panel stuff

+1 Panel Actors spin off that doesn't have monitored actor inheritance and embedded Events for UI Actors Indicators creation. Allows scripting for events along with UI capability that Panel Actors has. Package on Allen’s gitlab.

---

Generic Documentation:
Use the ideas presented by Q before linked here.
Automatic genreation of stuff from the error methods.
These errors don't actually need the Error at the end, rather just look in the proper virtual folder that the scripting tools use.
use of anit-doc.

---

In spawn, get the Persistent Actor instances from the private data to decorate.
Persistent is the same throughout the application.

---

PPL advice: shock house

My top list would just be, pick a location for your PPL and stick with it. It doesn't matter what folder, just pick a folder. We use C:\Program Files\[CompanyName].

I would name the library/class/ppl with the same name. It makes it easier to know where things came from and debug them.

Always check the box in the PPL build spec for "Exclude dependent packed libraries" in Additional Exclusions. Otherwise it will copy the dependent PPLs to wherever you build your new one.

Each Library is its own project.

---

Panel Actor and UE Event scripting

I did implement an unmonitored version of the Panel Actor. It was a simple matter of changing Panel Actor's inheritance and then removing reference to some Monitored Actor functionality (that I didn't much care for anyway). Most of the work was actually fixing the examples. There were no other changes to Derrick's code. I made the repo public facing, but I haven't pushed the packages to VIPM yet. I should probably do so before NI Connect. Anyway, repo here: https://gitlab.com/justACS/mgi-panel-manager-unmonitored
It includes an imperfect first pass at a UI Events template based on Panel Actor that I've been using with customers.





Actor hierarchy inspector debug actor in Spawn actor persistent

---

EXAMPLES SHOULD be in Example finder for VIPM
Keywords like jettl, actor, etc should have this be first when searched

---

bowser for example on examples

Make sure examples come up on VIPM for the install page

---

Msg renaming idea, actors that implement the message

tried this out and it worked great for renaming the message class, but I had issues getting it to rename the method in the actor. Is it something I'm doing wrong or have others had this issue?

Have a unique hash for the interface message and have that be generated in the overridden method description, etc. so that the method itself KNOWS (not necessarily where to look for the message) but at least can find what the message is (if loaded into memory).
Unique interface message identifier in description.
Maybe instead, have it be in the library description. Can have other information here for uniquely identifying if the message has been scripted.




Effectively:
developer could "select" which functionalities to add to the unified actor


Msg forwarding:
this new iteration replaces forwarding directions/instructions by actor inheritance with explicit registration for forwarding




Call (have Booleans for before and after in Inspect.vi)
So that case structure afterwards can call “Call Non-Unified Msg.vi” DD.



in order to use a forwarding tool, messages still need to be in the unified msg set. But must register for the messages before setup to put these “non-implemented” messages in the msg set. Or some other msg set? That way these messages being told still need to be validated that certain messages are in the “unified msg set” OR “Non-Implemented Msg Set”. Yes, there can be overlapped msgs in both msg sets!! In case not in unified msg set, then check if in non-implemented msg set.

---

can't get trace data from VIs in vi.lib.

But it would be good if our tooling supported PPLs.

There aren’t any hooks in jettl, the entire API has public read-only methods everywhere to access or gain access to the internals via a combination of method calls.


Just like spawning, the observer pattern used will have a blocking call when subscribing / registering for a topic by creating its own child actor, with the necessary private data internal to talk with the broker and it’s child actors.
Can use the Root flag to see if a message has been overridden.



Oh! And the non-implemented msgs can of course be dynamic since inserting or removing from set can happen depending on which external actor you’re communicating with.



Lumos in DQMH?



Default of Actor being a DD override???? In template??
JUST as a placeholder if anything.



Get rid of the Stop when Parent Stopped. This is mandatory behavior. Comment this in Stopped.

---

-Payload method browser
-Payload destination browser
-Private data accessor re-scripter

Documentation
Antidoc
Include
-Actor Calling/Launching Hierarchy
-Messaging Schematic

- Class Browser. My thought on this is similar to the dynamic dispatch window but for a class where we can see BDs from each method without having to open a bunch of VIs. Sort of like a class is presented in text languages
- Some way to diagram or document which messages a class can handle, and which library/actor/interface they belong to


My concept for what a documentation tool would generate as a graphical representation of an AF project.
![[Images/Graphical Rep.png]]
Each main box is a running actor, with the nested boxes showing inheritance levels. The levels with * have an override of Actor Core that includes a While Loop or subVI running parallel with the Call Parent Node. The launches lines come off of the level of Actor Core that calls Launch Nested Actor.
The diagram above could be built by static analysis of code or analysis of DETT output (with AF debug logging enabled).



Have the Actor Ref be in the Actor Template!!!



Note for Find Local Msg Set:
SLM: 
There is "Go To Parent **CLASS**", but no equivalent for parent interfaces. There isn't a unique parent interface, so it would need to be Find functionality. Personally, I just use the "Show Class Hierarchy" when I need to find the parent interfaces.


Tool idea:
General OOP though:
For interfaces, here is what might be nice: right click on a method and if it's overridden from an interface then it gives you an option to go to parent method in the interface
That would be just as useful for class inheritance (perhaps more... you mostly only need to go to the interface implementation for refactoring since they're usually no-ops, whereas class implementations might actually contain functionality).



I think a documentation tool will be very valuable. Also for new users. If they understand quicker/easier what's going on than they won't be overwhelmed or putt off as fast. Also more and attractive examples (including that documentation) can be a resource for people to explore Actor Framework.





For those new to AF, I think the tools that have the most benefit relate to documentation, testing and visualization.
Other tools (like actor/class refactoring) might be more attractive to users who've been using AF already.


Should these be our four broad categories of focus for improvements to the tooling? Namely:
1-Documentation - auto-documentation that can be run on existing projects
2-Testing/Unit Testing - automated testing as much as possible
3-Visualization - Actor Calling and Messaging Diagrams
4-Generation/Maintenance - More user-friendly generation and, standardized templates, etc
5- refactoring tools - Agile development means more refactoring


Tool Something like:
Open AF Payload Method




Documentation that:
My discoverability challenge is how can I easily see all the messages that I can send to an actor and all the messages it can generate/send to the caller. There is no easy way to do this! I can look in the actor's library, but there I can only see messages that are specific to that actor. I need to know that it inherits from another actor or actors or even an interface (which isn't obvious in the project) and then look for all those messages and do so recursively.

---

Interfaces:
Here is another one and someone correct me if I am wrong, because I haven't played with interfaces and AF messaging too much yet. If I have an Actor that is intended to be a subactor. It sends messages to its caller via an interface as opposed to abstract messages. Great! Fewer classes. All for it. EXCEPT. In order for that to work, the caller has to inherit from whatever interface the nested actor is using to send messages to its caller. How do you clearly communicate that when you hand that actor off to another developer to use in another project? How is that discoverable? and what if I don't care about recieving any messages back from it? With abstract messages, I could just not supply a concrete child and I would still work and just be a no-op. With interfaces, I would still have to inherit from the interface, correct? Am I thinking about that problem right? Do you just include the interface in your Actor library? so then it gets distributed with your actor? and its just common knowledge that the caller has to inherit from this interface? Wouldn't that add some weird coupling? Maybe this as all covered in Allen's course and I should just go take the new course.
"Make it easier for people to discover which messages an actor can send or receive" A way to do that would be with some sort of standard location or naming convention for the "incoming" and "outgoing" interfaces. A tool for that would look like either some sort of template to start from or a scripting tool that you could invoke


Need a convention for folder structure and naming, virtual folder names.



Inspiration actor hierarchy inspector, available DETT hooks necessary?


Tools of interest:
Bowzer the Browser
Actor Hierarchy Inspector
Events for UI Actor Indicators
Open af payload
Panel actors
State pattern actor

---

Here is the list we generated from GDevCon N.A.:

Bug to Fix:
- AF Debug Traces Circular Dependency

Tools Available or that We Wish We Had:
- Network Endpoint Actors (Have - <@698284997106335765>)
- Actor Hierarchy Inspector (Have - <@698284997106335765>)
- Panel Actor (new release without Monitored Actor dependency, <@698284997106335765> is working on it, bug after July 31st)
- Test panels, Actor Tester (<@711353780397932614> started one but doesn't find all messages, <@460922496007274497> to look into it)
- Unit Test with Caraya (<@698284997106335765> has examples of doing this)
- Events for UI Actors (<@698284997106335765> started it Dan to look into adding to it)
- Documentation, AntiDoc plugin (<@698284997106335765> has started this with other collaborators. Will reach out if more help needed)
- DETT plugins (no work yet but a potential for UML and sequence diagraming in LabVIEW)
- Python Sequence Diagram parsing (exists but would like more work to be done to make it an easy built-in tool)
- Open AF Payload (Have, Zyah made it. <@460922496007274497> ) This tool helps to find the method a message is calling.
- Bowzer the Browser (Have, Zyah made it. <@460922496007274497> ) This tool helps to navigate between your Actors (Actor Cores and Messages)
- Examples and CTI (<@709845571313336440> to look into cleaning up some of his examples)
- Message Monitor (<@1198120469765832786> looking into this) This would be more like a logger/monitor showing run-time message sends and payload.
- Actor System Designer (<@711301523027656774> looking into this) This tool would provide a system level diagram of Actors and Actor Calling Hierarchy.
- Actor Framework Message Forwarding (Have Zyah made it. <@460922496007274497> ) Automatically can forward message through the Calling Hierarchy
- Marketing
- Need more AF presentations at events
- <@711301523027656774> to create a presentation on Panel Actors and QControls




jettl Timer like DNatt:
I'm thinking some more introductory examples are in order. I was considering following your lead and doing a live demo where I create a timer. That would have the dual benefit of demonstrating AF and giving a comparison to DQMH. If I do this, I would refer the audience to your presentation. I was planning on reaching out to the Consortium about creating several such example pairs.


Presentation idea:
"So, You're the CLAD on the AF Team" could be a game changer if done correctly.



Observer pattern:
MVA Framework
I saw the presentations when it came out. If I recall correctly, the MVA framework relies on a mediator to bypass the standard tree hierarchy. I also seem to recall that it relies on messages to the mediator to relay data packets to the actors. (Feel free to correct me if I am misremembering.) It seemed like a lot of work to avoid the tree, so I never got into it.




State pattern
![[Images/State Pattern.png]]

---

Static documentation, browser utility
where message is listened to and who can tell the message.Further, from which subvi
One suggestion: I tend to make a lot of "private" messages by marking them as private within the actor library. I don't know if this is common practice or not? But I do it because I have my actors send messages to themselves from their helper loop a lot, but I don't want anyone other than itself to send it that message. I think it would be nice if private messages could be marked in the navigator in some way, or even have an option to hide them all together if you just want to know the public interface of an actor.
C:\Program Files\National Instruments\LabVIEW 2020\resource\Framework\Providers\API\mxLvSCCGetCallers.vifor finding all callers. Requires a project provider ref though.Find all instances only finds instances in VIs that are open. Find all callers doesn't care if the callers are open or not.


I am also figuring out a way to display the actor class hierarchy and where they are launched.
Spawn is polymorphic, or static for a particular actor. Instead of Init, it uses its own Spawn function to the actor.


get rid of the jettl virtual folder


Multiple actors in one library, but there is a main actor with other libraries that contain actors, but they must be private. Rule VI analyzer can check.

---

Per Actor based window that allows you to scroll through the
Actor Overrides and Msg Overrides

Looks in the Actor Overrides -> Extended virtual folder
Looks in the Msg Overrides virtual


For plugin architecture, can have a dropdown function that allows you to drop a factory pattern for async spawning an actor that is not known at edit time.

---

For the tool that creates the implemented msg with recurse:
Make sure that the controls and indicators are in the correct positions so that it is easy for the developer to properly change the control / indicator position. What about for the Actor as well, have this be consistent location for control / indicators.