These docs are a self-contained document written for LabVIEW developers seeking a proficient understanding of jettl.

These docs are a living document and contributions are welcome through the means of the socials on the GitHub README.

This document is meant to be a complete guide to the jettl framework, outlining a starting point for understanding the design philosophy and implementation details.

---

What jettl aims to accomplish for developers:
1. Documentation - Documentation for actors
2. Unit Testing - Testing on actors
3. Visualization - Actor Spawning and Messaging Diagrams
4. Generation/Maintenance - Standardized templates
5. Refactoring - Agile development philosophy

---

Need a convention for folder structure and naming, virtual folder names.

---

Symmetry across the lifecycle pairs:
* **Spawn and Stopped**
* **Setup and Teardown**
* **Start and Stop**

**Unified Definitions**
- An **actor** represents a single layer.
- A **unified actor** represents the unification of multiple layer actors.
- This maps cleanly to having both a **Msgs** (per layer) and a **Unified Msgs** (across the unified actor).