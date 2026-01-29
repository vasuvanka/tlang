# Linter Warnings Support

## Overview

The Tlang linter now supports comprehensive warnings for:
1. **Unused imports** - Detects imports that are never used
2. **Unused declarations** - Detects unused variables, functions, and constants
3. **Dead code** - Detects unreachable code after return/break/continue statements

## Warning Codes

| Code | Level | Description |
|------|-------|-------------|
| W002 | Warning | Unused import |
| W003 | Warning | Unused parameter |
| W006 | Warning | Unused function |
| W007 | Warning | Unused variable |
| W008 | Warning | Dead code (unreachable) |

## Features

### 1. Unused Imports Detection

Detects imports that are declared but never used in the code.

**Example:**
```tl
samooham adhi;

dhimpu "fmt";
dhimpu "math";  // W002: Unused import: 'math'

#prarambham() {
    fmt.Printf("Hello\n");
    // math is never used
}
```

### 2. Unused Variable Detection

Detects variables that are declared but never read.

**Example:**
```tl
samooham adhi;

dhimpu "fmt";

#prarambham() {
    @x int = 10;  // W007: Unused variable: 'x'
    @y int = 20;
    fmt.Printf("%d\n", y);  // Only y is used
}
```

**Note:** Variables prefixed with `_` are ignored (e.g., `@_temp`).

### 3. Unused Function Detection

Detects functions that are defined but never called.

**Example:**
```tl
samooham adhi;

dhimpu "fmt";

#helper() {  // W006: Unused function: '#helper'
    fmt.Printf("Helper\n");
}

#prarambham() {
    fmt.Printf("Main\n");
    // helper is never called
}
```

**Note:** The entry point function `#prarambham` is always considered used.

### 4. Dead Code Detection

Detects code that is unreachable after return, break, or continue statements.

**Example:**
```tl
samooham adhi;

dhimpu "fmt";

#prarambham() {
    fmt.Printf("Before\n");
    mallinchu 42;
    fmt.Printf("After\n");  // W008: Unreachable code
}
```

**Also detects:**
- Code after `agu` (break)
- Code after `konasagu` (continue)
- Code after `thappu` (error return)
- Code after if-else where both branches return

## Usage

### During Build

Warnings are automatically shown during the build process:

```bash
tlang build
```

**Output:**
```
Building project: myapp
Linting...
⚠ 2 warning(s):
  example.tl:3:1 [W002] Unused import: 'math'
  example.tl:5:1 [W007] Unused variable: 'x'
Compiling...
```

### Lint Command

You can also lint files directly:

```bash
tlang lint
```

### In VS Code / Cursor

Warnings are shown in the Problems panel and as underlines in the editor when using the Tlang extension.

## Configuration

### Suppressing Warnings

You can suppress specific warnings by prefixing identifiers with `_`:

```tl
@_unused int = 10;  // No warning for unused variable
```

Or by using a comment (future feature):
```tl
// tlang:ignore W007
@unused int = 10;
```

## Best Practices

1. **Remove unused imports** - Keep your code clean
2. **Remove unused variables** - Or prefix with `_` if intentionally unused
3. **Remove dead code** - It's confusing and adds maintenance burden
4. **Review unused functions** - They might be needed for future use or should be removed

## Implementation Details

The linter performs three passes:

1. **Declaration Pass**: Collects all declarations (imports, variables, functions) with their locations
2. **Usage Pass**: Collects all usages (function calls, variable reads, import references)
3. **Analysis Pass**: Compares declarations vs usages and reports unused items

### Scope Tracking

The linter tracks:
- Global scope (package level)
- Function scope
- Block scope (if, for, etc.)

Variables are only considered unused if they're not used in their declaring scope or any nested scope.

## Future Enhancements

- [ ] Unused constant detection
- [ ] Unused struct field detection
- [ ] Unused interface method detection
- [ ] Configurable warning levels
- [ ] Warning suppression comments
- [ ] Export analysis (functions exported but never used externally)

## See Also

- [Linter Documentation](../src/linter.rs) - Implementation details
- [Build System](build-system.md) - How linting integrates with builds
- [Best Practices](best-practices.md) - Code quality guidelines
