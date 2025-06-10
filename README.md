# jettl

*Insert Image of jettl*

`jettl` is a lightweight library used for decorating classes with Actor methods via composition and implementation of the `Actor` interface.

## Motivation

For a little over a year (currently 2025), I have had success designing applications to interface instruments to our nuclear fusion experiments, control XY stage motors to correlate and display 3D images via a topological laser readout, and perform PID autotune algorithms for high efficiency RF antenna matching circuits. I wrote all of these applications using the [National Instruments Actor Framework](https://education.ni.com/badges/resources/984/actor-framework). Along the way, having learned about the [SOLID Design Principles](https://en.wikipedia.org/wiki/SOLID) and [Design Patterns](https://en.wikipedia.org/wiki/Software_design_pattern), I had been eager to apply these principles and design patterns. Being intimately involved with the source code of the [Actor Framework](https://education.ni.com/badges/resources/984/actor-framework), I ventured to build a library that uses common elements from the Actor Framework, Derrick Bommarito's [lv-artifex](https://github.com/illuminated-g/lv-artifex), and the many talks given by [Dmitry Sagatelyan](https://forums.ni.com/t5/LabVIEW-Champions-Directory/LabVIEW-Champion-Dmitry-Sagatelyan/ta-p/3536802) on the Agile Software Design Principles, SOLID principles, and Context-Agnostic Actors. `jettl` was born.

## Advantage

- **Advantage One**: This is an advantage

## Abstractions

`Actor`: Provides abstraction for methods that are wrapped and optionally decorated in `Dev Actor`. 

### Implementations

`Self Actor`: Encapsulates the state and references to other actors. Providing the concrete implementation for messages.

## Examples

The `Dev Actor` is currently the only example, which also show cases the `Panel` add-on.

This is where you should start when learning `jettl`, by example.

## Add-ons

`jettl` is minimal, and extended functionality using the dependency inversion priciple of composing in interfaces (and potentially implementing them) include:

- `Panel` displaying windows (and soon subpanels)

Along with scripting tools including:

- Creating wrapper methods of classes / interfaces
- Creating decorator methods
- Creating Messages

## Best Practices

*Insert Best Practices .md here*

## Design Decisions

*Insert Design Decisions .md here*

## Benchmarks

*Insert Benchmarks .md here*

# TODO

## Orphan Actors

Maybe there can be a Boolean that is “Can be Orphan?” Kind of a bypass to the orderly shutdown.
So that when the caller closes
When creating a nested actor, Boolean flag that says if actor can be orphaned.
So when going through orderly shutdown, the caller won’t care about the nested actor last ack since it’s last ack will be removed (knowing that it had already been marked as can be orphan)

## Philosophy

### Msg
All messages come from an interface and follow ISP where one message belongs to one interface. If there is a naming issue, that is a good thing.. it means in the dependencies, you should be packaging modules so you don’t run into naming issues.

### Dev Actor
- Internal (VF): Static methods are private and in the internal folder
- Implemented (VF): Dynamic dispatch are public and MUST be implemented by an interface to follow SOLID principles. For example, (Actor (VF)) the Actor methods are overrides from the Actor Interface. Another example, (Msg (VF)) the Msg methods are overrides from the respective Msg Interface. For example, (Other (VF)) other interface implementations.

Actor messages must be implemented since called in algorithm.
Other DD from Actor interface do not since not called in algorithm.

Actors do not have accessors.
Classes / interfaces composed in a development actor can have accessors.. sure. Maybe there’s something with state that is different

### Modular UI
Since the UIs and its references dependency is NOT dependent on the actor, we can unit test the UIs.

###


VIPM .vi lib
jettl (VF)