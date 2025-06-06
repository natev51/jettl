# LVCAM - LabVIEW Composed Actor Model

*Insert Image of LVCAM*

`LVCAM` is a lightweight library used for decorating classes with Actor methods via composition and implementation of the `Actor` interface.

## Motivation

For a little over a year (currently 2025), I have had success designing applications to interface instruments to our nuclear fusion experiments, control XY stage motors to correlate and display 3D images via a topological laser readout, and perform PID autotune algorithms for high efficiency RF antenna matching circuits. I wrote all of these applications using the [National Instruments Actor Framework](https://education.ni.com/badges/resources/984/actor-framework). Along the way, having learned about the [SOLID Design Principles](https://en.wikipedia.org/wiki/SOLID) and [Design Patterns](https://en.wikipedia.org/wiki/Software_design_pattern), I had been eager to apply these principles and design patterns. Being intimately involved with the source code of the [Actor Framework](https://education.ni.com/badges/resources/984/actor-framework), I ventured to build a library that uses common elements from the Actor Framework, Derrick Bommarito's [lv-artifex](https://github.com/illuminated-g/lv-artifex), and the many talks given by [Dmitry Sagatelyan](https://forums.ni.com/t5/LabVIEW-Champions-Directory/LabVIEW-Champion-Dmitry-Sagatelyan/ta-p/3536802) on the Agile Software Design Principles, SOLID principles, and Context-Agnostic Actors. `LVCAM` was born.

## Advantage

- **Advantage One**: This is an advantage

## Abstractions

`Actor`: Provides abstraction for methods that are wrapped and optionally decorated in `Dev Actor`. 

### Implementations

`Self Actor`: Encapsulates the state and references to other actors. Providing the concrete implementation for messages.

## Examples

The `Dev Actor` is currently the only example, which also show cases the `Panel` add-on.

This is where you should start when learning `LVCAM`, by example.

## Add-ons

`LVCAM` is minimal, and extended functionality using the dependency inversion priciple of composing in interfaces (and potentially implementing them) include:

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