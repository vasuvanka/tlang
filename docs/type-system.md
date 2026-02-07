# Type System

Tlang's type system provides type safety with optional type inference.

## Basic Types

### Integer (`int`)

Whole numbers, positive or negative.

```tl
@x int = 42;
@y int = -10;
@z int = 0;
```

**Range:** Platform-dependent (typically 32-bit or 64-bit)

### Float (`float`)

Floating point numbers (real numbers).

```tl
@pi float = 3.14159;
@negative float = -0.5;
@zero float = 0.0;
```

**Precision:** Double precision (64-bit)

### String (`string`)

Text strings, sequences of characters.

```tl
@name string = "Tlang";
@empty string = "";
@multiline string = "Line 1\nLine 2";
```

**Encoding:** UTF-8 compatible

### Boolean (`bool`)

Boolean values. In Tlang, booleans are represented as integers:
- `1` = true
- `0` = false

```tl
@isActive int = 1;   // true
@isInactive int = 0; // false
```

### Void (`void`)

No value. Used as function return type for functions that don't return a value.

```tl
#printMessage(msg string) {
    fmt.Printf("%s\n", msg);
}
```

## Type Inference

Tlang can infer types from initial values:

```tl
@x = 10;        // Inferred as int
@y = 3.14;      // Inferred as float
@z = "hello";   // Inferred as string
@b = 1;         // Inferred as int (use 1/0 for boolean)
```

**Rules:**
- Type inference only works with initial values
- Must provide either type annotation or initial value
- Cannot infer from `nil` or empty value

## Explicit Type Annotations

You can explicitly specify types:

```tl
@x int = 10;
@y float = 3.14;
@name string = "Tlang";
```

**When to use explicit types:**
- For clarity and documentation
- When initializing with zero value
- When type might be ambiguous

## Pointer Types

Pointers allow indirect access to values.

### Pointer Declaration

```tl
@x int = 10;
@ptr *int = &x;      // Pointer to int
@value int = *ptr;    // Dereference pointer
```

### Nested Pointers

```tl
@x int = 10;
@ptr *int = &x;
@pptr **int = &ptr;   // Pointer to pointer
```

### Pointer Operations

```tl
@x int = 10;
@ptr *int = &x;      // Get address
@value int = *ptr;    // Get value
@ptr = &x;            // Assign address
```

## Channel Type

Channels are used for concurrency (CSP style). Declare with `channel[elementType]`; optional capacity for buffered channels.

```tl
@ch channel[int];           // unbuffered
@ch2 channel[int] = 10;     // buffered, capacity 10
ch <- 42;                   // send
@x int = <- ch;             // receive
sunyam(ch);                 // close (optional)
```

See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md).

## WaitGroup Type

WaitGroup lets you wait until a number of spawned tasks have finished. Declare with `WaitGroup`; no initializer needed.

```tl
@wg WaitGroup;       // create
wg.Add(2);           // expect 2 tasks to complete
tlang #worker(wg);   // worker receives wg and calls wg.Done() when done
tlang #worker2(wg);
wg.Wait();           // block until counter reaches 0
```

Methods: `Add(n)` (add n to the counter), `Done()` (decrement by one), `Wait()` (block until counter is 0). See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md).

## Composite Types

### Structs

Structs allow you to group related data together:

```tl
nirmanam Person {
    name string;
    age int;
    email string;
}

@person Person = Person{name: "Alice", age: 30, email: "alice@example.com"};
fmt.Printf("Name: %s\n", person.name);
```

### Maps

Maps provide key-value storage:

```tl
@scores jatha[string]int;
scores["Alice"] = 95;
@score int = scores["Alice"];
```

### Interfaces

Interfaces define method contracts that types can implement:

```tl
interface Writer {
    Write(data string) int;
}

interface Reader {
    Read() string;
}

// Interfaces are implemented using function pointer tables (vtables)
// A type implements an interface by providing methods matching the interface signature
```

## Type Conversion

Tlang supports two ways to convert types:

### Go-Style Type Conversion

Use type conversion syntax for direct conversions:

```tl
@x int = 10;
@y float = float(x);        // int to float
@z int = int(3.14);         // float to int
@str string = string(123);  // int to string
@num int = int("456");      // string to int (uses strconv.Atoi)
@flag int = bool(1);        // int to bool
```

**Supported Conversions:**
- `int(x)` - Convert to integer
- `float(x)` - Convert to float
- `string(x)` - Convert to string
- `bool(x)` - Convert to boolean

### Library Functions

You can also use library functions for type conversion:

#### String to Number

```tl
@num int = strconv.Atoi("123");
@f float = strconv.ParseFloat("3.14");
@b int = strconv.ParseBool("true");
```

#### Number to String

```tl
@str string = strconv.Itoa(123);
@str2 string = strconv.FormatFloat(3.14);
@str3 string = strconv.FormatBool(1);
```

**Note:** Type conversion syntax (`int(x)`, `float(x)`, etc.) internally uses the `strconv` library functions when converting from strings.

## Type Safety

Tlang enforces type safety at compile time:

```tl
@x int = 10;
@y float = 3.14;
@sum = x + y;  // Error: cannot mix int and float
```

**Type checking:**
- Variables must match declared types
- Function parameters must match types
- Return values must match return types
- Operations must use compatible types

## Zero Values

Variables without initial values have zero values:

```tl
@x int;        // 0
@y float;      // 0.0
@z string;     // "" (empty string)
@b int;        // 0 (false)
```

## Constants

Constants are immutable values with inferred or explicit types:

```tl
@PI float = 3.14159;
@APP_NAME string = "MyApp";
@MAX_SIZE int = 100;
```

**Rules:**
- Constants must have initial values
- Constants cannot be reassigned
- Constants can use type inference

## Type Compatibility

### Numeric Types

- `int` and `int` - Compatible
- `float` and `float` - Compatible
- `int` and `float` - Not directly compatible (requires conversion)

### String Types

- All strings are compatible
- String literals are `string` type

### Boolean Types

- Booleans are integers (`1` or `0`)
- Compatible with integer operations

## Best Practices

1. **Use explicit types** for clarity when needed
2. **Use type inference** for simple cases
3. **Convert types explicitly** when mixing numeric types
4. **Use constants** for immutable values
5. **Check return values** from conversion functions

## See Also

- [Language Reference](language-reference.md) - Complete syntax
- [Tutorial](tutorial.md) - Learning guide
