# jettl

*Insert Image of jettl*

`jettl` is a lightweight library used for decorating classes with Actor methods via composition and implementation of the `Actor` interface.

## Motivation

For a little over a year (currently 2025), I have had success designing applications to interface instruments to our nuclear fusion experiments, control XY stage motors to correlate and display 3D images via a topological scanning laser readout, and perform PID autotune algorithms for high efficiency RF antenna matching circuits. I wrote all of these applications using the [National Instruments Actor Framework](https://education.ni.com/badges/resources/984/actor-framework). Along the way, having learned about the [SOLID Design Principles](https://en.wikipedia.org/wiki/SOLID) and [Design Patterns](https://en.wikipedia.org/wiki/Software_design_pattern), I had been eager to apply these principles and design patterns. Being intimately involved with the source code of the [Actor Framework](https://education.ni.com/badges/resources/984/actor-framework), I ventured to build a library that uses common elements from the Actor Framework, Derrick Bommarito's [lv-artifex](https://github.com/illuminated-g/lv-artifex), and the many talks given by [Dmitry Sagatelyan](https://forums.ni.com/t5/LabVIEW-Champions-Directory/LabVIEW-Champion-Dmitry-Sagatelyan/ta-p/3536802) on the Agile Software Design Principles, SOLID principles, and Context-Agnostic Actors. `jettl` was born.

## Advantage

- **Advantage One**: This is an advantage

## Abstractions

`Actor`: Provides abstraction for methods that are wrapped and optionally decorated in `Dev Actor`. 

### Implementations

`jettl`: Encapsulates the state and references to other actors. Providing the concrete implementation for messages.

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

## Philosophy

### Dev Actor
- Internal (VF): As a baseline, everything is a static method, which is private and are found in the internal folder.
- Implemented (VF): Dynamic dispatch are public and MUST be implemented by an interface to follow SOLID principles. For example, (Actor (VF)) the Actor methods are overrides from the Actor Interface. Another example, (Msg (VF)) the Msg methods are overrides from the respective Msg Interface. For example, (Other (VF)) other interface implementations.

Actor messages must be implemented since called in algorithm.
Other DD from Actor interface do not since not called in algorithm.

## TODO

### Would be Nice

Use the Event and Other methods (in Dev Panel) in Dev Actor.
There are of course other methods that can be created, such as the auto generated references in the private data of Dev Panel.
See the Other folder for examples.


Look down at the green grass, look up to the blue sky, and look further to the purple galaxy.
Purple Library RGB (0,0,0) 
Blue Interface RGB (0,0,0) 
Green Class RGB (0,0,0)


jettl: "#Should be preserve?" in Launch jettl


Replace all strings with the \code option


Does the same happen for objects, that also happens with references?
Have dedicated method in Dev Panel that takes the obejct, unbundles the object and rewrites the object into a new initialized object
(forum trick you posted about)


Maybe these should resemble the Msgs?


Way to tell is to destroy Dev Actor, but Dev Panel keeps running.
With a “Button”, THAT DOESNT NEED TO BE ASSOCIATED WITH A MSG, property node to change “String Indicator Text”

Refs (Interface)
Dev Panel Refs (Class) has get / set methods

Input of TSC and Refs (Interface) DD
TSC to Bundle by name

