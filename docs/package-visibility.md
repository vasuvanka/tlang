# Package Visibility Rules

Tlang implements **Go-style visibility rules** for package-level identifiers. This provides a simple and consistent way to control what is accessible from other packages.

## Rule

**Identifiers starting with an uppercase letter are exported (public).**  
**Identifiers starting with a lowercase letter are unexported (private).**

## What Gets Exported?

The following types of identifiers follow visibility rules:

1. **Functions** - `#FunctionName()` vs `#functionName()`
2. **Variables** - `@VariableName` vs `@variableName`
3. **Variables** - `@ConstantName` vs `@constantName`
4. **Structs** - `nirmanam StructName` vs `nirmanam structName`
5. **Interfaces** - `interface InterfaceName` vs `interface interfaceName`

## Examples

### Exported Identifiers

```tl
// Package utils (no explicit package keyword)

// Exported function
#Add(a int, b int) int {
    mallinchu a + b;
}

// Exported constant
@MaxValue int = 100;

// Exported variable
@Counter int = 0;

// Exported struct
nirmanam Point {
    @X int;
    @Y int;
}

// Exported interface
interface Writer {
    #Write(data string) int;
}
```

### Unexported Identifiers

```tl
// Package utils (no explicit package keyword)

// Unexported function (only available in this package)
#subtract(a int, b int) int {
    mallinchu a - b;
}

// Unexported constant
@minValue int = 0;

// Unexported variable
@internalCounter int = 0;

// Unexported struct
nirmanam point {
    @x int;
    @y int;
}
```

### Using Exported Identifiers from Another Package

```tl
@fmt = #dhimpu("std/fmt");
@utils = #dhimpu("./utils");

#prarambham() {
    // Can use exported function
    @sum int = utils.Add(10, 20);
    
    // Can access exported constant
    fmt.Printf("Max: %d\n", utils.MaxValue);
    
    // Can use exported struct
    @p utils.Point;
    p.X = 5;
    p.Y = 10;
    
    // ERROR: Cannot access unexported identifiers
    // utils.subtract(10, 5);      // Error: unexported
    // utils.minValue;             // Error: unexported
    // utils.internalCounter;      // Error: unexported
}
```

## Benefits

1. **Simple Rule** - Just look at the first letter
2. **No Keywords** - No need for `public`/`private` keywords
3. **Consistent** - Same rule applies to all identifier types
4. **Go-Compatible** - Familiar to Go developers

## Implementation Details

- Visibility is checked at **package load time**
- Only exported identifiers are included in the package's export list
- Unexported identifiers are still generated in the C code, but are not accessible from other packages
- Attempting to access an unexported identifier from another package will result in a compilation error

## Best Practices

1. **Export only what's needed** - Keep internal implementation details unexported
2. **Use clear naming** - Exported functions should have descriptive names
3. **Package-level organization** - Group related exported functions together
4. **Documentation** - Document exported functions and their purpose

## See Also

- [Package System](language-reference.md#packages) - Package declaration and imports
- [Language Reference](language-reference.md) - Complete syntax guide
