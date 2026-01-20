*The following includes a list of changes to the framework that can be done immediately.*
*The order of items presented is in no particular order.*

---

Goals:

1. update
	- Stop
	- Stopped


TEMPLATE Msg Input
TEMPLATE Msg Output
TEMPLATE Msg: Execute Msg
TEMPLATE

2. Add in the Actor Index to the spawning

3. Template
	- check for ending in `jettl Msg` or `jettl Actor` instead of just `Msg` or `Actor`

4. run code to ensure it's running

5. Renaming Tool
	- For the Msgs, do not include any names that are apart of the actor overrides, to avoid any further naming conflicts i.e. cannot name `Setup Msg` since the `Setup.vi` already would exist and no point to run into naming conflict if you don't have to. Have a string list here that is hardcoded in tools.

6. Rescript Tool
	- rename msg rescript to rescript.
	- make the tree the same actor and Msg dropdown.
	- create a map that maps the indexes to the names of the functions (for Msgs and Actors separately) so that you can use the map elements to alter the correct functions by their name.
	- Two maps for look up between `Init X` and `Read X` i.e. Msg Input and Msg Output mapping.
	- Clean Up Wire invoke node where necessary

Would be cool.
could.. Should?.. go back to Base Actor and make it the same folder structure as TEMPLATE jettl Actor!