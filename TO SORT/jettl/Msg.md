**Messages can have outputs!**
Rationale: It enables layered actors (actors that delegate to other layered actors) to use another inner layers output. For example, if an inner actor executes a method and produces analyzed data as its output, the wrapper layer can consume that output for purposes such as logging, auditing, metrics, or trace enrichment—without requiring the wrapper to re-compute or re-derive the same data or have to tell that data to a different actor.

> I would consider having a common output for all messages, such as a log interface output, on terminal 1, that can be dependency injected for the particular logging a developer would like to implement i.e. they would write their own concrete implementation.

---

