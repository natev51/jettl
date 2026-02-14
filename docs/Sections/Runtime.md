# Runtime

This document covers runtime characteristics and deployment constraints for jettl, including RT targets, scheduling considerations, PPL packaging, executables, and benchmarking.

Sections marked **Guidelines**, **Ideas**, or **Notes** are non-normative.

## Real-Time Targets

### Guidelines

For testing, decouple RT actors from hardware dependencies and RT-specific APIs. Encapsulate all hardware and RT calls behind classes with well-defined interfaces. Substitute these implementations with mock objects and unit test on the desktop target.

This approach cannot validate timing behavior or hardware-specific failure modes, but it is highly effective at isolating and eliminating defects in the control logic.

> **TODO:** Fill in your RT validation strategy.
>
> - **Target(s)**: Can you be more detailed with examples?
> - **Timing constraints**: Can you be more detailed with examples?
> - **Hardware failure modes to validate on-target**: Can you be more detailed with examples?
> - **Desktop test coverage goal**: Can you be more detailed with examples?
> - **On-target test coverage goal**: Can you be more detailed with examples?

## Scheduling and Priority

### Context

The core philosophy is: actors should assume they cannot control message execution order (see [Scheduling and Ordering](Core%20Model.md#scheduling-and-ordering)).

### Guidelines

- Prefer designs that do not require ordering assumptions.
- If you introduce message priority, define:
  - what priority means,
  - where it is honored,
  - and what it does *not* guarantee.

> **TODO:** Fill in jettl priority semantics (if priority exists).
>
> - **Does jettl expose message priority?**: Yes, it is a Boolean flag to either tell a message that is received in a FIFO (first in first out) or with priority where the message is put at the front of the FIFO.
> - **If yes, where is it honored?**: Can you be more detailed with example?
> - **What does priority guarantee?**: That the message with be put at the front of the FIFO.
> - **What does priority NOT guarantee?**: If other messages also have priority, temporally, it is not guaranteed which with be listened to first.
> - **Acceptance tests**: Can you be more detailed with example?

## Packed Project Libraries (PPL)

### Overview

jettl is also released as a PPL.

- PPL support: jettl comes as a single library, so it is packed into a PPL without external dependencies.
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
*jettl PPL API. Note that the functions are not expanded, there are many in here with details in their comments.*

> **TODO:** Fill in the exact migration steps for your repo layout.
> Can you please be more detailed with example?
> 1. :
> 2. :
> 3. :

Due to extensive use of making functions, methods, classes, interfaces, and libraries private, the resultant PPL is ULTRA-lightweight. The PPL builds are shown below.

![](../Images/actor-ppl.png)
*Actor PPL API. After a primary build, the next PPL build took 9 seconds.*

![](../Images/msg-ppl.png)
*Msg PPL API. After a primary build, the next PPL build took 8 seconds.*

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

In development mode, message classes are loaded into memory specific to the actor that can listen to them.

In short: a message class lives in a library which also contains the interface that an actor implements for the message. Since the actor must load message interfaces into memory due to the static linking to an interface, the library must be loaded; therefore the message class in that same library should also be loaded.

### Further Reading

- [GLA Summit 2022: Ludicrous Ways to Fix Broken LabVIEW Code](https://www.youtube.com/watch?v=kF_9DFPTZPc) @00:37:52-00:43:43
- [NI Forum: project mass compile - how does it work](https://forums.ni.com/t5/LabVIEW/project-mass-compile-how-does-it-work/m-p/4266014#M1242702)
- [Large LabVIEW Project Development Techniques](https://www.youtube.com/watch?v=7zS3Q_K71XY) @00:32:13

## Plugin Architecture

### Ideas

For plugin architecture, consider factory pattern that spawns an actor not known at edit time.

> **TODO:** Fill in plugin constraints and how they interact with “statically typed messaging.”
> Can you please be more detailed and provide example?
> - **How plugins are discovered**:
> - **How plugin actor types are selected**:
> - **How message contracts are validated**:
> - **Fallback behavior if contracts are not met**:

## Benchmarking

### Goals

- Measure message rate for trigger messages i.e. message without inputs or output data.
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

- **What is the performance target for message throughput (Queue vs Event)?**: The performance throughput is 100 us.
- **Which runtime targets must be supported (Desktop, RT, built executable, PPL, PPL-in-exe)?**: Desktop, RT, built executables, PPL, PPL-in-exe are targets that must be supported.
- **Which transport is the default recommendation and why?**: Events since they are most often used with user events and panels. Queues are for performance and Notifiers are specialty.
- **What part of the runtime behavior is considered a stable contract vs an implementation detail?**: Can you be more detailed with example?
- **What is your minimum supported LabVIEW version and how does it affect runtime behavior?**: LabVIEW 2020 is the minimum supported LabVIEW version and runtime behavior is not effected, to my knowledge between this version and the latest version of LabVIEW. LabVIEW 2020 is the minimum supported version since interfaces were introduced to the language in LV2020.
