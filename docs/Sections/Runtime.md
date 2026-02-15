# Runtime

This document describes runtime behavior and deployment constraints: scheduling considerations, RT guidance, Packed Project Libraries (PPLs), executables, and benchmarking.

This page is primarily **guidelines and notes**. Normative contracts live in the [Core Model](Core%20Model.md).

## Scheduling and priority

The canonical ordering contract is defined in the Core Model: [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering).

Guidelines:

- Prefer designs that do not require message ordering assumptions.
- If you introduce priority or ordering constraints, write acceptance tests that prove the behavior under load.

> TODO: Document jettl’s exact priority model.
>
> - **Does the framework expose priority to users? (Yes/No)**:
> - **If yes, where is it configured?**:
> - **How does priority interact with each transport (Queue/Event/Notifier)?**:
> - **Acceptance test description**:

## Real-time targets (RT)

Guidelines for RT development:

- Decouple RT actors from hardware dependencies and RT-specific APIs.
- Encapsulate hardware and RT calls behind classes with well-defined interfaces.
- Substitute these implementations with mock objects and unit test the control logic on the desktop target.

This approach cannot validate timing behavior or hardware-specific failure modes, but it is highly effective at isolating and eliminating defects in the control logic.

> TODO: Define the RT support contract.
>
> - **Supported RT targets (cRIO, PXI, other)**:
> - **What “RT compatible” means (no UI, no dynamic VI loading, etc.)**:
> - **Known limitations**:
> - **Recommended test strategy (Desktop vs RT)**:

## Packed Project Libraries (PPL)

jettl is designed to be released as a PPL.

### Build guidelines

When building PPLs:

- Pick a single location for PPLs (example: `C:\PPLs\[CompanyName]`).
- Name the PPL the same as the library.
- Check **Exclude dependent packed libraries**.
- Prefer “each library is its own project” to keep dependency graphs explicit.

> TODO: Add a concrete build checklist with LabVIEW screenshots.
>
> - **Minimum LabVIEW version for PPL builds**:
> - **Project structure rules**:
> - **Build spec naming convention**:
> - **Common failure modes + fixes**:

### Compatibility notes

- XNodes and malleable VIs can cause build issues with PPLs; jettl avoids them.

Additional PPL resources (external):

- [DebuggingSymptoms - Packed Project Library PPL Dependencies - Searching for Dependencies Dialog When Running Executable](https://forums.ni.com/t5/Community-Documents/Debugging-Symptoms-Packed-Project-Library-PPL-Dependencies/ta-p/4107786)
- [PPLNamespaced Dependencies - Strategy/Design Discussion - Development Issues](https://forums.ni.com/t5/LabVIEW/PPL-Namespaced-Dependencies-Strategy-Design-Discussion/td-p/4276248)
- [LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022](https://www.youtube.com/watch?v=HKcEYkksW_o)
- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=7zS3Q_K71XY)

> TODO: Confirm whether jettl Tools requires changes to support PPL workflows.
>
> - **Tooling gaps identified**:
> - **Required changes**:
> - **Owner / priority**:

## Executables

Notes when building executables:

- Check Conditional Disable Structures for broken code in `RUN_TIME_ENGINE==TRUE`.
- Consider unchecking:
  - Disconnect type definition
  - Remove unused polymorphic instance
  - Removes unused VIs from libraries

More resources (external):

- [NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)
- [Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY) @00:32:13

> TODO: Validate runtime behavior for documentation tools inside an executable.
>
> - **Does Find Msgs.vi work in an executable? (Yes/No)**:
> - **If yes, what is the mechanism that keeps message classes loaded?**:
> - **If no, what is the mitigation?**:

## Plugin architectures

For plugin architectures, one approach is a factory pattern that selects an actor to spawn asynchronously (not known at edit time).

> TODO: Decide whether plugin support is a first-class goal.
>
> - **Is plugin architecture a primary use case? (Yes/No)**:
> - **What must be configurable at runtime**:
> - **What analyzer guarantees must still hold**:

## Benchmarking

Benchmarking questions worth answering (with numbers):

- Message rate for trigger messages (per transport).
- Time to spawn an actor until the `Stopped` message is listened to by the parent.

> TODO: Define a repeatable benchmark protocol.
>
> - **Hardware / OS / LabVIEW version**:
> - **Transport under test (Queue/Event/Notifier)**:
> - **Message payload size**:
> - **Test duration and warm-up**:
> - **Metrics reported (avg, p95, max)**:
> - **Where results are published (doc section / repo file)**:
