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