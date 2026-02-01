
[The Errors of our Ways | Stephen Loftus-Mercer GDevCon N.A. 2021](https://www.youtube.com/watch?v=00TZxeyt8_A) @52:08
'That was handled, or I wouldn't have been called' - SLM

---

Errors

No error goes unrecognized.
No error goes unnoticed in the framework, everything is reported (except for releasing references).

Why are there are so many error case structures?
Unless they have an error input, all functions/methods are assumed to run unconditionally when they are called

Errors should not be used for serialization. Object serialization should also not be used. But there isn't a great way to show this in LabVIEW. Therefore, object serialization is fine, but do ensure that errors are not used for serialization.
DO NOT pass a data type from the input to the output of the method for the *sole purpose* of serialization. An indication that the data in the data type will *potentially* be manipulated is when a data type is being passed in and out through a method such as the Object IO and Error IO. This provides difficulty for readability since the developer does not know if the error is being manipulated by the method. Understand that other developers will not know your intent and will assume that the data in the datatype will be manipulated. These are the most common data types.
Unless a data type can be manipulated, then the data type should not have an output if there is an input. Not wiring the outputs gets rid of this thinking entirely for better readability.
If a method must be serialized, embrace a structure. The most common way to enforce this is with the flat sequence structure and implicitly with the case structure.