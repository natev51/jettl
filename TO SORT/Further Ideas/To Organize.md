


---





---



---



---



---






---



---



---








---








---



---



---



---












---




---

---



---



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

`Read Parent Attributes` to `Read Unified Msgs` to see if parent implements the msg, can recurse the parents, parents, parent, etc.
OR
Explicit registration for forwarding on `Setup.vi`.





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