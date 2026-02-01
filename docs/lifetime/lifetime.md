`Stop.vi'
- always starts as `False`
- only be changed to `True` in  `Stop.vi`
- can never be changed back to `False`

`Should Stop.vi`
`Stop` = TRUE
OR
Error (then Stops)
outputs `Can Stop` = True
Error from `Finalize.vi` means that the actor should stop, hence Stop will be called, if not called already.