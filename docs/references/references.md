It’s the reason `jettl Actors` always creates their own event references release their own references. Lifetime is guaranteed.
Creating references in parent before child spawns is a bad practice since when the parent stops, the reference created in the parent (but still used by the child) will be released leading to the child actor doing operations on a released reference, throwing errors.

---

