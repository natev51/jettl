# Runtime

This document covers runtime characteristics and deployment constraints for jettl, including RT targets, scheduling considerations, PPL packaging, executables, and benchmarking.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Real-Time Targets

### Guidelines

For testing, decouple RT actors from hardware dependencies and RT-specific APIs. Encapsulate all hardware and RT calls behind classes with well-defined interfaces. Substitute these implementations with mock objects and unit test on the desktop target.

This approach cannot validate timing behavior or hardware-specific failure modes, but it is highly effective at isolating and eliminating defects in the control logic.

> **TODO:** Fill in your RT validation strategy.
>
> - **Target(s)**:
> - **Timing constraints**:
> - **Hardware failure modes to validate on-target**:
> - **Desktop test coverage goal**:
> - **On-target test coverage goal**:

## Scheduling and Priority

### Context

The core philosophy is: callers should assume they cannot control message execution order (see [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering)).

### Guidelines

- Prefer designs that do not require ordering assumptions.
- If you introduce message priority, define:
  - what priority means,
  - where it is honored (which transports / which queues),
  - and what it does *not* guarantee.

> **TODO:** Fill in jettl priority semantics (if priority exists).
>
> - **Does jettl expose message priority?**:
> - **If yes, where is it honored?**:
> - **What does priority guarantee?**:
> - **What does priority NOT guarantee?**:
> - **Acceptance tests**:

## Packed Project Libraries

### Overview

jettl can be released as a PPL.

- PPL support: jettl comes as a single library, so it can be packed into a PPL without external dependencies.
- xnodes and malleable VIs can cause build issues with PPLs; this is one reason they do not exist in jettl.

### Build Guidelines

- Pick a single location for PPLs such as `C:\\PPLs\\[CompanyName]`.
- Name the PPL the same as the library.
- Check “Exclude dependent packed libraries”.
- Each library is its own project.

### Using the PPL Version of jettl

To change a class to use the PPL version of jettl:

- Change the implemented interface to the PPL interface.
- Compose in the PPL interface.

This has not been directly tested and should be cautioned for the time being. This section will be updated when tooling becomes more mature.

![](../Images/jettl-ppl.png)
*jettl PPL API. Note that the functions are not shown, there are many in here with details in their comments.*

> **TODO:** Fill in the exact migration steps for your repo layout.
>
> 1. :
> 2. :
> 3. :


![](../Images/actor-ppl.png)
*Actor PPL API. After a primary build, the next build took 9 seconds.*

![](../Images/msg-ppl.png)
*Msg PPL API. After a primary build, the next build took 8 seconds.*

Notice how the API of the PPL beautifully encapsulates all private functionality, leaving the Public API.

### PPL + Executable Validation Checklist

> **TODO:** Validate PPL behavior inside an executable and record results.

| Check | Expected | Observed | Notes |
|---|---|---|---|
| Executable launches and loads PPLs | : | : | : |
| Message discovery UI still populates (for example, “msgs on the front panel”) | : | : | : |
| `Find Msgs.vi` works in the executable | : | : | : |
| No dependency-search dialogs at runtime | : | : | : |

### Further Reading

- [DebuggingSymptoms - Packed Project Library PPL Dependencies - Searching for Dependencies Dialog When Running Executable](https://forums.ni.com/t5/Community-Documents/Debugging-Symptoms-Packed-Project-Library-PPL-Dependencies/ta-p/4107786)
- [PPLNamespaced Dependencies - Strategy/Design Discussion - Development Issues](https://forums.ni.com/t5/LabVIEW/PPL-Namespaced-Dependencies-Strategy-Design-Discussion/td-p/4276248)
- [LUDICROUS ways to Fix Broken LabVIEW Code with Darren Nattinger | GDevConNA 2022](https://www.youtube.com/watch?v=HKcEYkksW_o)
- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc)

> **TODO:** Capture whether `jettl Tools` requires changes to fully support PPL workflows.
>
> - **Tool impacted**:
> - **What breaks**:
> - **Workaround**:
> - **Planned fix**:

## Executables

### Build Notes

Notes when building executables:

- Check Conditional Disable Structures for broken code when `RUN_TIME_ENGINE==TRUE`.
- Consider unchecking (based on your build policy):
  - Disconnect type definition
  - Remove unused polymorphic instance (removes unused VIs from libraries)

### Runtime Behavior Notes

`Find Msgs.vi` functions properly in the executable.

In development mode, message classes are loaded into memory specific to the actor that can receive them.

In short: a message class lives in a library which also contains the interface that an actor implements for the message. Since the actor must load message interfaces into memory, the library must be loaded; therefore the message class in that same library should also be loaded.

### Further Reading

- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc) @00:37:52-00:43:43
- [NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)
- [Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY) @00:32:13

## Plugin Architecture

### Ideas

For plugin architecture, consider a dropdown or factory pattern that selects and spawns an actor not known at edit time.

> **TODO:** Fill in plugin constraints and how they interact with “statically typed messaging.”
>
> - **How plugins are discovered**:
> - **How plugin actor types are selected**:
> - **How message contracts are validated**:
> - **Fallback behavior if contracts are not met**:

## Benchmarking

### Goals

- Measure message rate for trigger messages.
- Measure spawn-to-stopped latency for a baseline actor.

### Example Benchmark Sketch

- Tell `Self` 100000 messages and compute average throughput until `Stopped` is observed by the parent.
- Measure how fast a bare actor goes from spawn to when the parent observes `Stopped`.

> **TODO:** Fill in the benchmarking protocol so results are reproducible.
>
> | Metric | Setup | Procedure | Result | Notes |
> |---|---|---|---|---|
> | Message throughput | : | : | : | : |
> | Spawn → Stopped latency | : | : | : | : |
> | CPU usage | : | : | : | : |
> | Memory usage | : | : | : | : |

## Feedback Questions

- **What is the performance target for message throughput (Queue vs Event)?**:
- **Which runtime targets must be supported (Desktop, RT, built executable, PPL, PPL-in-exe)?**:
- **Which transport is the default recommendation and why?**:
- **What part of the runtime behavior is considered a stable contract vs an implementation detail?**:
- **What is your minimum supported LabVIEW version and how does it affect runtime behavior?**:
