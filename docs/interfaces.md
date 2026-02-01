# Interfaces (Removed)

Interface support has been **removed** from Tlang for now. It was only partially implemented (parser bugs, no type-level enforcement, manual vtable usage).

For details and possible future directions, see [interface-analysis.md](interface-analysis.md).

You can still use **structs** and **functions** (e.g. `#Rectangle_Area(rect *Rectangle) float`) for the same patterns; there is no polymorphic interface type.

**Maps with “any” value type:** Use **`jatha[string]nirmanam{}`** instead of `jatha[string]interface{}`. The type `nirmanam{}` is allowed only as the value type of a map (e.g. `@m jatha[string]nirmanam{} = ...`).
