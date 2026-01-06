This section goes over reuse actors that have either been implemented or can be implemented, external to the core library.

### Panel Actors

Separate repo that has this reuse actor.
Common functionality to update the front panel state
includes the window operation and subpanels with unique passing of actor ref reference to the parent (from when it spawns as a child!), no need to pass around the subpanel reference.
Wire in as a persistent layer.

### Broker

https://bitbucket.org/composedsystems/mva-framework/src/master/
https://bitbucket.org/composedsystems/stream/src/master/

---

Communicating between targets

![](../images/IMG_7841.jpeg)