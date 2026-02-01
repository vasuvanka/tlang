# Packages and Modules

Tlang's package system allows you to organize code into reusable modules. There is no package declaration at the top of files; use `#dhimpu` (import) to bring in other packages.

## Importing Packages

Use **`@variable = #dhimpu("path")`** to import a package. The variable you assign to is the name you use in code (e.g. `@fmt = #dhimpu("std/fmt")` then `fmt.Printf`). There is no explicit package or alias keyword—just assign the import to a variable.

```tl
@fmt = #dhimpu("std/fmt");        // use as fmt.Printf
@math = #dhimpu("std/math");      // use as math.Abs
@utils = #dhimpu("./utils");       // use as utils.HelperFunction (relative path)
```

### Qualified use

After `@variable = #dhimpu("path")`, use that variable to call functions or refer to types:

```tl
@fmt = #dhimpu("std/fmt");
@utils = #dhimpu("./utils");

#prarambham() {
    fmt.Printf("Hello\n");
    utils.HelperFunction();
}
```

## Package Visibility Rules

Tlang follows Go-style visibility rules:

- **Exported (Public)**: Identifiers starting with **uppercase** letter
- **Unexported (Private)**: Identifiers starting with **lowercase** letter

### Examples

```tl
// Exported - can be used by other packages
#PublicFunction() {
    // ...
}

#privateFunction() {  // Private - only within this package
    // ...
}

nirmanam PublicStruct {  // Exported struct
    Name string;  // Exported field
    age int;      // Private field
}

nirmanam privateStruct {  // Private struct
    // ...
}

@PublicVar int = 42;     // Exported variable
@privateVar int = 10;   // Private variable
```

**See:** `docs/package-visibility.md` for detailed visibility rules.

## Package Structure

### Single File Package

```tl
// utils.tl
#dhimpu("std/fmt");

#HelperFunction() {
    fmt.Printf("Helper called\n");
}
```

### Multiple Files Package

For larger packages, you can split code across multiple files in the same directory:

```
mypackage/
  ├── mod.tl      (main package file - entry point)
  ├── helper.tl   (additional code)
  └── types.tl    (type definitions)
```

**How it works:**
- All `.tl` files in the same directory are part of the same package
- When you import `mypackage`, the compiler looks for `mypackage.tl` or `mypackage/mod.tl`
- If `mod.tl` exists, it serves as the entry point, and other files in the directory are automatically included

**Example:**

```tl
// mypackage/mod.tl
@fmt = #dhimpu("std/fmt");

// Exported function
#PublicFunction() {
    fmt.Printf("Public function\n");
    helperFunction();  // Can call private functions from other files
}
```

```tl
// mypackage/helper.tl
// Private function - only accessible within this package
#helperFunction() {
    fmt.Printf("Helper called\n");
}
```

```tl
// mypackage/types.tl

// Exported struct
nirmanam Point {
    @X int;
    @Y int;
}
```

## Package Search Paths

The compiler searches for packages in the following order:

1. **Current directory** - Files in the same directory as the source file
2. **Relative paths** - `./utils`, `../shared`, `../../common`
3. **Standard library** - `stdlib/` directory (built-in packages)
4. **Custom search paths** - Additional paths configured via build system

### Resolution Rules

When you import a package, the compiler tries to find it in this order:

1. **Single file**: `package.tl` (e.g., `#dhimpu("utils")` → `utils.tl`)
2. **Directory with mod.tl**: `package/mod.tl` (e.g., `#dhimpu("mypackage")` → `mypackage/mod.tl`)
3. **Relative file**: `./utils.tl` or `../shared.tl`
4. **Standard library**: `stdlib/package.tl`

**Examples:**

```tl
// Assign import to a variable; use that variable in code:
@fmt = #dhimpu("std/fmt");           // use as fmt.* (finds stdlib/fmt.tl)
@utils = #dhimpu("./utils");          // use as utils.* (finds ./utils.tl or ./utils/mod.tl)
@common = #dhimpu("../common");      // use as common.* (finds ../common.tl or ../common/mod.tl)
@mypackage = #dhimpu("mypackage");   // use as mypackage.* (finds mypackage.tl or mypackage/mod.tl)
```

## Package Initialization (Future Enhancement)

**Status**: Not yet implemented

In the future, Tlang will support package initialization functions similar to Go's `init()`:

```tl
// Future syntax - not yet implemented
#init() {
    // This will run automatically when the package is imported
    fmt.Printf("Package utils initialized\n");
    // Setup code, initialization, etc.
}
```

**Planned Features:**
- Automatic execution of `init()` functions when package is imported
- Multiple `init()` functions per package (executed in order)
- Dependency-based initialization order

## Module Organization Best Practices

### 1. Keep Packages Focused

Each package should have a single, clear purpose:

```tl
// Good: math.tl - mathematical operations
#Sqrt(x float) float { /* ... */ }
#Pow(x float, y float) float { /* ... */ }

// Bad: utils.tl - everything mixed together
#MathFunction() { /* ... */ }
#StringFunction() { /* ... */ }
#FileFunction() { /* ... */ }
```

### 2. Use Descriptive Package Names

Use descriptive file/directory names for packages (e.g. `httputil.tl`, `jsonparser.tl`, `database.tl` rather than `util.tl`, `helper.tl`, `stuff.tl`).

### 3. Export Only What's Needed

Don't export internal implementation details:

```tl
// Exported - public API
#Parse(input string) *AST { 
    return parseInternal(input);
}

// Private - internal implementation
#parseInternal(input string) *AST {
    // ...
}
```

### 4. Group Related Types

Keep related structs, interfaces, and functions together:

```tl
nirmanam Request {
    Method string;
    Path string;
}

nirmanam Response {
    Status int;
    Body string;
}

#NewRequest(method string, path string) *Request { /* ... */ }
#SendRequest(req *Request) *Response { /* ... */ }
```

## Examples

### Example 1: Simple Utility Package

```tl
// mathutils.tl
@math = #dhimpu("std/math");

#Square(x float) float {
    return x * x;
}

#Cube(x float) float {
    return x * x * x;
}
```

```tl
// main.tl
@fmt = #dhimpu("std/fmt");
@mathutils = #dhimpu("./mathutils");  // use as mathutils.* (relative path)

#prarambham() {
    @result float = mathutils.Square(5.0);
    fmt.Printf("Square: %f\n", result);
}
```

### Example 2: Package with Types

```tl
// shapes.tl
nirmanam Circle {
    Radius float;
}

nirmanam Rectangle {
    Width float;
    Height float;
}

#Area(c *Circle) float {
    return 3.14159 * c.Radius * c.Radius;
}

#Area(r *Rectangle) float {
    return r.Width * r.Height;
}
```

### Example 3: Package with Constants

```tl
// constants.tl
@PI float = 3.14159;
@E float = 2.71828;
@MAX_SIZE int = 1024;
```

## Standard Library Packages

Tlang includes a standard library with many packages:

- **`fmt`** - Formatted I/O (Printf, Sprintf, etc.)
- **`strings`** - String manipulation
- **`math`** - Mathematical functions
- **`os`** - Operating system interface
- **`time`** - Time operations
- **`json`** - JSON encoding/decoding
- **`http`** - HTTP client and server
- **`net`** - Network operations
- And many more...

See `docs/libraries/` for documentation on each library.

## Circular Dependencies

The compiler detects and prevents circular dependencies:

```tl
// Error: Circular dependency detected
// Package A imports Package B
// Package B imports Package A
```

**Solution**: Refactor to remove the circular dependency, often by extracting shared code into a third package.

**Example of breaking a circular dependency:**

```tl
// Before: circular dependency
// packageA.tl
@packageB = #dhimpu("./packageB");
#FunctionA() { packageB.FunctionB(); }

// packageB.tl
@packageA = #dhimpu("./packageA");
#FunctionB() { packageA.FunctionA(); }
```

```tl
// After: extract shared code
// shared.tl
#SharedFunction() { /* ... */ }

// packageA.tl
@shared = #dhimpu("./shared");
#FunctionA() { shared.SharedFunction(); }

// packageB.tl
@shared = #dhimpu("./shared");
#FunctionB() { shared.SharedFunction(); }
```

## Troubleshooting

### Package Not Found

**Error**: `Package 'mypackage' not found`

**Solutions:**
1. Check the package name matches the file/directory name
2. Verify the file exists in the search path
3. For multi-file packages, ensure `mod.tl` exists
4. Check relative paths are correct (`./` vs `../`)

### Import Errors

**Error**: `Cannot use unexported identifier`

**Solution**: Make sure the identifier starts with an uppercase letter:
```tl
// ❌ Wrong
#privateFunction() { }

// ✅ Correct
#PublicFunction() { }
```

## Package Documentation (Future Enhancement)

**Status**: Not yet implemented

Future versions may support package-level documentation comments.

## See Also

- **[Package Visibility](package-visibility.md)** - Detailed visibility rules and export guidelines
- **[Language Reference](language-reference.md)** - Complete language syntax
- **[Porting Guide](porting-guide.md)** - Convert Go packages to Tlang
- **[Build System](build-system.md)** - Package management and dependencies
