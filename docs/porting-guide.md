# Go to Tlang Porting Guide

The `tlang-port` tool helps convert Go packages to Tlang syntax automatically.

## Installation

The `tlang-port` binary is included with the Tlang installation. After installing Tlang, you can use it directly:

```bash
tlang-port <go_file> [output_file]
tlang-port <directory> [output_directory]
```

## Usage

### Convert Single File

```bash
# Convert main.go to main.tl
tlang-port main.go main.tl

# Convert with auto-generated output name (main.go -> main.tl)
tlang-port main.go
```

### Convert Directory

```bash
# Convert entire Go package directory
tlang-port ./go-package ./tlang-package

# Convert with auto-generated output directory
tlang-port ./go-package
```

## Conversion Mappings

### Keywords

| Go | Tlang | Example |
|----|-------|---------|
| `package` | `samooham` | `package main` → `samooham adhi;` |
| `import` | `dhimpu` | `import "fmt"` → `dhimpu "fmt";` |
| `func` | `#` | `func add()` → `#add()` |
| `func main()` | `#prarambham()` | `func main()` → `#prarambham()` |
| `var` | `@` | `var x int` → `@x int` |
| `const` | `@` | `const PI = 3.14` → `@PI = 3.14` |
| `if` | `okavela` | `if condition` → `okavela condition` |
| `else` | `lekapothe` | `else` → `lekapothe` |
| `for` | `malli` | `for i < 10` → `malli i < 10` |
| `return` | `mallinchu` | `return value` → `mallinchu value` |
| `break` | `agu` | `break` → `agu` |
| `continue` | `konasagu` | `continue` → `konasagu` |
| `struct` | `nirmanam` | `struct Person` → `nirmanam Person` |
| `map` | `jatha` | `map[string]int` → `jatha[string]int` |
| `nil` | `sunyam` | `nil` → `sunyam` |

### Types

| Go Type | Tlang Type | Notes |
|---------|------------|-------|
| `int`, `int8`, `int16`, `int32`, `int64` | `int` | All Go integer types map to `int` |
| `uint`, `uint8`, `uint16`, `uint32`, `uint64` | `int` | All Go unsigned types map to `int` |
| `float32`, `float64` | `float` | All Go float types map to `float` |
| `string` | `string` | Same |
| `bool` | `int` | Tlang uses `int` (1/0) for booleans |
| `byte` | `int` | Maps to `int` |
| `rune` | `int` | Maps to `int` |
| `error` | `error` | Same |

### Error Handling

| Go Pattern | Tlang Pattern |
|-----------|---------------|
| `if err != nil { ... }` | `okavela err != sunyam { ... }` |
| `return nil` | `mallinchu sunyam` |
| `return err` | `mallinchu err` |

### Variable Declarations

| Go | Tlang |
|----|-------|
| `var x int = 10` | `@x int = 10;` |
| `var x = 10` | `@x = 10;` |
| `var x int` | `@x int;` |
| `const PI = 3.14` | `@PI = 3.14;` |
| `x := 10` | `@x = 10;` |

### Structs

| Go | Tlang |
|----|-------|
| ```go<br>type Person struct {<br>    Name string<br>    Age int<br>}``` | ```tl<br>nirmanam Person {<br>    @Name string;<br>    @Age int;<br>}``` |

### For Loops

| Go | Tlang |
|----|-------|
| `for i := 0; i < 10; i++ { ... }` | `@i int = 0; malli i < 10; i = i + 1 { ... }` |
| `for key, value := range map { ... }` | `malli key, value := varasa map { ... }` |
| `for { ... }` | `malli { ... }` |

### Type Conversions

| Go | Tlang |
|----|-------|
| `int(x)` | `int(x)` (same) |
| `float64(x)` | `float(x)` |
| `string(x)` | `string(x)` (same) |

## Examples

### Example 1: Simple Go Program

**Go (`main.go`):**
```go
package main

import "fmt"

func main() {
    var x int = 10
    var y float64 = 3.14
    fmt.Printf("x = %d, y = %f\n", x, y)
}
```

**Converted Tlang (`main.tl`):**
```tl
samooham adhi;

dhimpu "fmt";

#prarambham() {
    @x int = 10;
    @y float = 3.14;
    fmt.Printf("x = %d, y = %f\n", x, y);
}
```

### Example 2: Error Handling

**Go:**
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Printf("Error: %s\n", err)
        return
    }
    fmt.Printf("Result: %d\n", result)
}
```

**Converted Tlang:**
```tl
#divide(a int, b int) (int, error) {
    okavela b == 0 {
        mallinchu 0, errors.New("division by zero");
    }
    mallinchu a / b, sunyam;
}

#prarambham() {
    @result int;
    @err error;
    result, err = divide(10, 0);
    okavela err != sunyam {
        fmt.Printf("Error: %s\n", err);
        mallinchu;
    }
    fmt.Printf("Result: %d\n", result);
}
```

## Limitations

The porting tool uses regex-based conversion, which has some limitations:

1. **Complex Expressions**: May not handle all edge cases in complex expressions
2. **Struct Methods**: Go struct methods need manual conversion to Tlang function syntax
3. **Interfaces**: Interface definitions may need manual adjustment
4. **Channels/Goroutines**: Not supported (Tlang doesn't have concurrency yet)
5. **Generics**: Not supported (Tlang doesn't have generics yet)
6. **Defer/Recover**: Not supported (Tlang doesn't have defer/recover)

## Post-Conversion Steps

After using `tlang-port`, you should:

1. **Review the converted code** - Check for any conversion issues
2. **Fix struct methods** - Convert Go methods to standalone functions
3. **Update imports** - Ensure all imports are available in Tlang
4. **Test compilation** - Run `tlangc` to check for errors
5. **Fix type issues** - Adjust any type mismatches
6. **Update error handling** - Verify error handling patterns work correctly

## Tips

1. **Start with simple packages** - Convert simple utility packages first
2. **Test incrementally** - Convert and test one file at a time
3. **Keep Go source** - Don't delete original Go files until Tlang version works
4. **Use version control** - Commit before and after conversion for easy comparison
5. **Manual review** - Always review converted code for correctness

## See Also

- [Language Reference](language-reference.md) - Tlang syntax reference
- [Type System](type-system.md) - Type conversion guide
- [Error Handling](error-handling.md) - Error handling patterns
- [Packages](packages.md) - Package system documentation
