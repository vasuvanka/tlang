# Constants vs Immutable Variables

## Overview

Tlang uses a simple model: **all variables declared with `@` are immutable by default**. There is no separate constant syntax.

## Immutable Variables (`@`)

All variables declared with `@` are immutable:

```tl
@PI float = 3.14159;
@MAX_SIZE int = 100;
@APP_NAME string = "Tlang";
```

**Characteristics:**
- Cannot be reassigned after declaration
- Can be used anywhere a value is needed
- Generate as `const` in C code
- Type inference is supported

## When to Use Immutable Variables

Use regular `@` variables for:
- **Mathematical constants**: `@PI float = 3.14159;`
- **Configuration values**: `@MAX_SIZE int = 1000;`
- **Application constants**: `@APP_NAME string = "Tlang";`
- **Any value that shouldn't change**: `@DEFAULT_PORT int = 8080;`

## Mutable Variables (`@!`)

Use `@!` only when you need to reassign:

```tl
@!counter int = 0;
counter = counter + 1;  // OK: mutable
```

## Summary

- **`@variableName`** - Immutable variable (use for constants and regular variables)
- **`@!variableName`** - Mutable variable (use only when reassignment is needed)

There is no separate constant syntax. All immutable values use `@`.

## See Also

- [Mutable Variables](mutable-variables.md) - Using `@!` for mutable variables
- [Immutability Analysis](immutability-analysis.md) - Detailed analysis of immutability
