# fmt - Formatting and I/O Library

The `fmt` library provides formatted I/O operations, similar to Go's fmt package.

## Functions

### Printf

**`fmt.Printf(format, ...)`** - Print formatted string to stdout

- `format`: Format string with format specifiers
- Additional arguments: Values to format
- Returns: void

**Format Specifiers:**
- `%d` - Integer
- `%f` - Float
- `%s` - String
- `%c` - Character
- `%%` - Literal %

**Example:**
```tl
@name string = "Tlang";
@version int = 1;
@pi float = 3.14159;

fmt.Printf("Welcome to %s v%d!\n", name, version);
fmt.Printf("PI = %.2f\n", pi);
```

### Sprintf

**`fmt.Sprintf(format, ...)`** - Format string and return as string

- `format`: Format string with format specifiers
- Additional arguments: Values to format
- Returns: Formatted string

**Example:**
```tl
@name string = "Alice";
@age int = 30;
@message string = fmt.Sprintf("Name: %s, Age: %d", name, age);
fmt.Printf("%s\n", message);
```

## Common Patterns

### Printing Variables
```tl
@x int = 10;
@y float = 3.14;
@name string = "test";

fmt.Printf("x = %d, y = %.2f, name = %s\n", x, y, name);
```

### Formatting Numbers
```tl
@num float = 123.456;
fmt.Printf("Default: %f\n", num);      // 123.456000
fmt.Printf("2 decimals: %.2f\n", num); // 123.46
fmt.Printf("Integer: %d\n", 42);       // 42
```

### Building Strings
```tl
@result string = fmt.Sprintf("Result: %d", 42);
// Use result in other operations
```

## See Also

- [Tutorial - Lesson 1](tutorial.md#lesson-1-hello-world)
- [Language Reference](language-reference.md)
