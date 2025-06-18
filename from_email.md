# Create / Launch

Should Launch exist or does Create do the job?


# Event Actor

Event structure: Teardown Event
This is where the Teardown method goes?


# Events

Instead of inheriting from Msg.lvclass, inherit from Event.lvclass.
Note that events are not sent to Callers, Self, or Nested.. nor are there messages.
This is purely sending an Event.

*rename "Send.vi" with "Enqueue.vi"

Replace:
“Enqueue Name.vi” and “Msg To Caller.vi” with
"Generate Name.vi” and “Event.vi”

The reading for the above is simple, "Enqueue Name Msg To Caller" and "Generate Name Event"