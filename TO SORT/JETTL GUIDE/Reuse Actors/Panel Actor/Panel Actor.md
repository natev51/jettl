Separate repo that has this reuse actor.
Common functionality to update the front panel state
includes the window operation and subpanels with unique passing of actor ref reference to the parent (from when it spawns as a child!), no need to pass around the subpanel reference.
Wire in as a persistent layer.