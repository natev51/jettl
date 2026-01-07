This section goes over reuse actors that have either been implemented or can be implemented, external to the core library.

### Panel Actors

Separate repo that has this reuse actor.
Common functionality to update the front panel state
includes the window operation and subpanels with unique passing of actor ref reference to the parent (from when it spawns as a child!), no need to pass around the subpanel reference.
Wire in as a persistent layer.

Usefulness of having `Actor Ref` as an input before `Setup.vi` and `Start.vi` allows for the Parent to have access to the `Actor Ref`, that means that the Parent has access to put that method in its subpanel instead of sending the child across the parents subpanel.

### Broker

Resources:
https://bitbucket.org/composedsystems/mva-framework/src/master/
https://bitbucket.org/composedsystems/stream/src/master/
https://www.vipm.io/package/national_instruments_lib_ni_network_endpoint_actors/

---

Communicating between targets

![](../images/broker-startup-scratch.jpeg)

---

Confirm working by:
With a boolean message,
Do a network stream on My Computer between two applications.
then with My Computer and RT

---

Identify the unique application instance by using the property for `Read Application Ref.vi` and convert to bytes for unique identifier.

An external note on this:
Endpoint Name/Context Uniqueness: If you have multiple applications on the same machine using network streams, you need to manage endpoint naming carefully. Only one application can use the default context (empty context in the URL) on a given computer . So if you run two executables that both create an endpoint named “DataStream” in default context, you’ll get a conflict. The solution is to assign a context name in the URL for at least one of them (e.g. //localhost:MyAppContext/DataStream). This adds complexity, but it’s a limitation to note: endpoint names are effectively global within a machine’s context space.

---

Intra application: user events
There’s not cross tree communication, but there is pseudo cross tree communication with user events.

Inter LabVIEW application: network streams

Inter non LabVIEW application: TCP

---


### Bridge Actors

Used to connect to non-jettl code via user events.
Bridge Actors between jettl and non jettl LabVIEW Applications.

---
---
You can launch an actor and send it messages from any LabVIEW code, not only from other actors. The primary challenge is receiving results back from that actor. This is the role of a **bridge (adapter or shim)**.

#### 1. Create a pure actor

Start by creating a proper actor that performs the required work (for example, hardware interaction). This actor must strictly follow Actor Framework rules:
* All communication occurs through actor messaging.
* No shared data access.
* No reply messages to non-actors.
By keeping this actor “pure,” it remains reusable in fully Actor Framework–based applications as well as in mixed environments.
#### 2. Create a bridge (adapter) actor

Next, introduce a bridge actor that sits between the calling (non-actor) code and the pure actor.
* Toward the pure actor, the bridge behaves like a normal AF actor and follows all AF rules.
* Toward the caller, the bridge is allowed to break AF rules, since the caller is not an actor.
This separation preserves correctness and reusability while enabling integration with legacy or non-AF code.
#### 3. Define pass-through command messages

The bridge actor should expose a set of standard messages that mirror those accepted by the nested pure actor.
* These messages are simple pass-throughs.
* The bridge forwards them directly to the pure actor.
* This is straightforward to implement when using interfaces.
#### 4. Establish return paths using reference objects

Because the caller is not message-driven in the AF sense, returned data must flow through reference objects:
* Use **DVRs** for tagged or state-style data.
* Use **queues** for streaming data or asynchronous notifications.
These references can be:
* Created by the calling code and passed to the bridge at startup (simplest approach), or
* Created by the bridge and returned to the caller (useful when the caller VI may go out of memory before the actor shuts down, which is common in TestStand-based systems).
#### 5. Handle data from the pure actor

When the nested pure actor sends data to the bridge:
* The bridge receives the message.
* The bridge stores the data in the appropriate reference object (DVR or queue).
#### 6. Consume data in the calling code

The calling code retrieves data from the reference objects as needed.
For example:
* If the caller is a **QMH**, pass the QMH queue into the bridge.
* When the bridge receives data from the pure actor, it constructs a QMH message and enqueues it with the received data.
If the caller is **not** message-driven:
* Do not forward messages directly.
* Instead, wrap all bridge interaction in a class that provides:
  * Create/Destroy VIs to launch and shut down the bridge actor.
  * Command VIs that send messages to the bridge.
  * Data access VIs that read from DVRs or queues.
This pattern cleanly encapsulates the actor interaction while presenting a conventional API to non-AF code.
---
---

---
---
First, note that you can launch and send a message to an actor from any LabVIEW code, not just other actors. The tricky part is getting answers *back* from that actor. This is where the bridge (or adapter, or shim code) comes in.
Start off by creating a proper actor. It does whatever you need it to do (perhaps it handles hardware), and follows all the rules - no data communication except through actor queues, and no reply messages! This lets you reuse the actor in pure AF applications as well as your current mixed environment.
Then you create the bridge/adapter actor. This actor sits between your calling code and your 'pure' actor. It interacts with the pure actor in a strict AF style. But since its caller isn't an actor, you can break the rules when sending data to that caller.
Give the bridge/adapter a set of standard messages that match the ones you will send to its nested actor. (This is trivial if you use interfaces.) These are just pass-throughs; the bridge will just forward them to its nested actor.
Also give the bridge one or more reference objects. Use DVRs for tags, or queues for streaming data or messages. The calling code can create these objects and pass them to the bridge at startup, or the bridge can create them and send them to the caller, perhaps as a message. (The former is easier, but you may need to do the latter if the calling VI goes out of memory before the actor terminates - this is common in TestStand systems.)
When the pure nested actor sends data to the bridge, the bridge stores that data in the appropriate reference object.
The calling code pulls data from those reference objects as and where it needs to do so. For example, if the caller is a regular queue driven message handler, you might pass the QMH queue into the bridge actor. When the bridge actor receives a message from its nested actor, it creates a message for the QMH, gives it the data from the nested actor, and sends the message to the QMH.
If the calling code is NOT a QMH, then I wouldn't forward messages (since the caller isn't message driven). I would wrap all of the code to talk to the bridge in a class, with Create/Destroy VIs to launch the bridge actor, VIs that send commands (by sending a message), and VIs that read data (by accessing DVRs or queues).

---
---
