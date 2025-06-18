# Create / Launch

Should Launch exist or does Create do the job?


# Event Actor

Event structure: Teardown Event
This is where the Teardown method goes?


# Events

- Queue Msg To Caller (Both) -> Msg To Caller
- Queue Msg To Self (Queue Actor only) -> Msg To Self
- Queue Msg To Nested (Queue Actor only) -> Msg To Nested
---------------- Inputs ARE EVENT INTERFACE!
- Event Msg To Caller (DNE)
- Event Msg To Self (Event Actor only) -> Event To Self
- Event Msg To Nested (Queue Actor only) -> Event To Nested