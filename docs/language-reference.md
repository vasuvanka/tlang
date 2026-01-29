# Tlang Language Reference

Complete reference for Tlang syntax, keywords, and language features.

## Table of Contents

1. [File Structure](#file-structure)
2. [Keywords](#keywords)
3. [Data Types](#data-types)
4. [Variables](#variables)
5. [Functions](#functions)
6. [Control Flow](#control-flow)
7. [Operators](#operators)
8. [Comments](#comments)
9. [Packages](#packages)
10. [Type System](#type-system)

## File Structure

### File Extension
Tlang source files use the `.tl` extension.

### Entry Point
Every Tlang program must have a `#prarambham()` function as the entry point:

```tl
#prarambham() {
    // Program starts here
}
```

## Keywords

### Telugu Keywords

| Keyword | English | Usage |
|---------|---------|-------|
| `@` | var | Variable declaration |
| `#` | func | Function declaration |
| `#prarambham` | main | Entry point function |
| `okavela` | if | Conditional statement |
| `lekapothe` | else | Alternative branch |
| `malli` | for | Loop construct |
| `mallinchu` | return | Return from function |
| `agu` | break | Exit loop |
| `konasagu` | continue | Skip to next iteration |
| `nirmanam` | struct | Structure type |
| `jatha` | map | Map type |
| `samooham` | package | Package declaration |
| `dhimpu` | import | Import package |
| `thappu` | error | Error keyword |
| `sunyam` | nil | Nil/null value |
| `interface` | interface | Interface type |

### Reserved Words
- `int`, `float`, `string`, `bool`, `void` - Type names
- `true`, `false` - Boolean literals

## Data Types

### Basic Types

| Type | Description | Example |
|------|-------------|---------|
| `int` | Integer numbers | `42`, `-10` |
| `float` | Floating point numbers | `3.14`, `-0.5` |
| `string` | Text strings | `"hello"`, `"world"` |
| `bool` | Boolean (1 or 0) | `1`, `0` |
| `void` | No value | Function return type |

### Pointer Types

```tl
@x *int;        // Pointer to int
@y *float;      // Pointer to float
@z **int;       // Pointer to pointer to int
```

### Type Inference

Types can be inferred from initial values:

```tl
@x = 10;        // Inferred as int
@y = 3.14;      // Inferred as float
@z = "hello";   // Inferred as string
```

## Variables

### Declaration Syntax

```tl
@variableName type = value;
```

### Immutability

**Variables in Tlang are immutable by default:**
- Variables cannot be reassigned after declaration
- Variables cannot be redeclared in the same scope
- To change a value, declare a new variable instead

```tl
@x int = 10;
// x = 20;  // ERROR: Cannot assign to variable 'x'
@x2 int = 20;  // OK: New variable declaration

// @x int = 30;  // ERROR: Variable 'x' is already declared in this scope
```

### Examples

```tl
@name string = "Tlang";
@age int = 25;
@height float = 1.75;
@isActive int = 1;  // 1 for true, 0 for false

// Type inference
@x = 10;        // int
@y = 3.14;      // float
@z = "test";    // string

// Without initial value
@count int;
```

### Scope and Shadowing

Variables can be shadowed in different scopes:

```tl
@x int = 10;
okavela x > 5 {
    @x int = 50;  // OK: Different scope, shadows outer x
    fmt.Printf("Inner x: %d\n", x);  // Prints 50
}
fmt.Printf("Outer x: %d\n", x);  // Prints 10
```


## Functions

### Function Declaration

```tl
#functionName(param1 type1, param2 type2) returnType {
    // function body
    mallinchu value;
}
```

### Examples

```tl
// Simple function
#greet(name string) {
    fmt.Printf("Hello, %s!\n", name);
}

// Function with return value
#add(a int, b int) int {
    mallinchu a + b;
}

// Function with multiple return values
#divide(a int, b int) (int, int) {
    mallinchu a / b, a % b;
}

// Void function
#printMessage(msg string) {
    fmt.Printf("%s\n", msg);
}
```

### Entry Point

```tl
#prarambham() {
    // Program entry point
}
```

## Control Flow

### Conditional Statements

```tl
okavela condition {
    // statements
}

okavela condition {
    // statements
} lekapothe {
    // statements
}

okavela condition1 {
    // statements
} lekapothe okavela condition2 {
    // statements
} lekapothe {
    // statements
}
```

### Loops

**For loop:**
```tl
@i int = 0;
malli (i < 10; i = i + 1) {
    // statements
}
```

**While-style loop:**
```tl
@i int = 0;
malli i < 10 {
    // statements
    i = i + 1;
}
```

**Range-based loop (for maps, slices, arrays):**
```tl
// Iterate over map with key and value
malli key, value := varasa map {
    fmt.Printf("%s: %d\n", key, value);
}

// Iterate over map with key only
malli key := varasa map {
    fmt.Printf("Key: %s\n", key);
}

// Iterate over slice/array
malli index := varasa slice {
    fmt.Printf("Index: %d\n", index);
}
```

**Break and Continue:**
```tl
@i int = 0;
malli i < 10; i = i + 1 {
    okavela i == 5 {
        agu;  // break
    }
    okavela i % 2 == 0 {
        konasagu;  // continue
    }
    // statements
}
```

## Type Conversion

Tlang supports Go-style type conversion syntax:

```tl
@x int = 10;
@y float = float(x);        // int to float
@z int = int(3.14);         // float to int
@str string = string(123);  // int to string
@num int = int("456");      // string to int
@flag int = bool(1);        // int to bool
```

**Supported Conversions:**
- `int(x)` - Convert to integer
- `float(x)` - Convert to float
- `string(x)` - Convert to string
- `bool(x)` - Convert to boolean

**Note:** Type conversion uses appropriate library functions internally (e.g., `strconv.Atoi` for string to int).

## Operators

### Arithmetic Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `a + b` |
| `-` | Subtraction | `a - b` |
| `*` | Multiplication | `a * b` |
| `/` | Division | `a / b` |
| `%` | Modulo | `a % b` |
| `^` | Power | `a ^ b` |

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `==` | Equal | `a == b` |
| `!=` | Not equal | `a != b` |
| `<` | Less than | `a < b` |
| `>` | Greater than | `a > b` |
| `<=` | Less than or equal | `a <= b` |
| `>=` | Greater than or equal | `a >= b` |

### Logical Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `&&` | Logical AND | `a && b` |
| `\|\|` | Logical OR | `a \|\| b` |
| `!` | Logical NOT | `!a` |

### Assignment Operators

```tl
@x int = 10;        // Assignment
@x = x + 1;         // Increment
@x = x - 1;         // Decrement
@x = x * 2;         // Multiply and assign
@x = x / 2;         // Divide and assign
```

## Comments

### Single-line Comments

```tl
// This is a single-line comment
@x int = 10;  // Comment after code
```

### Multi-line Comments

```tl
/* This is a
   multi-line comment */

/* Single line comment */
```

## Packages

### Package Declaration

Every Tlang file can declare a package name:

```tl
samooham adhi;
samooham utils;
samooham mypackage;
```

- Package declaration must be the first statement in a file
- Only one package declaration per file
- If no package is declared, it defaults to `main`
- Package name is used for organizing code and imports

### Import Statements

Import other packages to use their functions:

```tl
samooham adhi;

dhimpu "fmt";           // Import standard library
dhimpu "./utils";       // Import local file (relative path)
dhimpu "../common";     // Import from parent directory
dhimpu "mypackage";     // Import from search paths
dhimpu "math" as m;     // Import with alias
```

### Package Visibility (Go-style Exports)

Tlang follows Go's visibility rules: **identifiers starting with an uppercase letter are exported (public)**, while those starting with a lowercase letter are **unexported (private)**.

**Exported identifiers** (can be used by other packages):
- Functions: `#Add()`, `#Calculate()`
- Variables: `@Counter`, `@GlobalValue`
- Variables: `@MaxValue`, `@DefaultConfig`
- Structs: `nirmanam Point`, `nirmanam User`
- Interfaces: `interface Writer`, `interface Reader`

**Unexported identifiers** (only available within the same package):
- Functions: `#helper()`, `#internal()`
- Variables: `@counter`, `@internalValue`
- Variables: `@minValue`, `@defaultConfig`
- Structs: `nirmanam point`, `nirmanam user`
- Interfaces: `interface writer`, `interface reader`

**Example:**

```tl
// In utils.tl package
samooham utils;

// Exported - can be used by other packages
#Add(a int, b int) int {
    mallinchu a + b;
}

// Unexported - only available in this package
#subtract(a int, b int) int {
    mallinchu a - b;
}

// In main.tl
samooham adhi;
dhimpu "./utils" as utils;

#prarambham() {
    @result int = utils.Add(5, 3);  // OK - Add is exported
    // utils.subtract(5, 3);        // Error - subtract is unexported
}
```

See [Package Visibility Guide](package-visibility.md) for complete documentation.

**Import Syntax:**
- `dhimpu "path"` - Import package from path
- `dhimpu "path" as alias` - Import with alias (e.g., `dhimpu "./utils" as u`)
- Imports must come after package declaration, before other statements
- Built-in standard libraries (fmt, math, strings, etc.) are automatically available
- Local files use relative paths: `./filename` or `../directory/filename`

**Import Aliases:**
```tl
dhimpu "fmt";
dhimpu "./utils" as u;  // Use 'u' instead of 'utils'
dhimpu "../common" as common;  // Explicit alias

#prarambham() {
    fmt.Printf("Hello\n");      // Standard import
    @result int = u.sum(numbers);  // Using alias
}
```

**Example:**

```tl
// main.tl
samooham adhi;

dhimpu "fmt";
dhimpu "./utils";

#prarambham() {
    @numbers []int = {1, 2, 3, 4, 5};
    @sum int = utils.sum(numbers);
    fmt.Printf("Sum: %d\n", sum);
}
```

```tl
// utils.tl
samooham utils;

#sum(numbers []int) int {
    @total int = 0;
    @i int = 0;
    malli i < len(numbers); i = i + 1 {
        total = total + numbers[i];
    }
    mallinchu total;
}
```

**Package Resolution:**
- Standard library packages (fmt, math, etc.) are built-in
- Relative imports (`./` or `../`) resolve relative to current file
- Absolute imports search in current directory and search paths
- Package functions are called with dot notation: `package.function()`

## Type System

### Type Annotations

```tl
@x int = 10;              // Explicit type
@y = 20;                  // Inferred as int
@z float = 3.14;          // Explicit float
@name string = "Tlang";   // Explicit string
```

### Type Conversion

Use library functions for type conversion:

```tl
@num int = strconv.Atoi("123");
@str string = strconv.Itoa(456);
@f float = strconv.ParseFloat("3.14");
```

### Pointers

```tl
@x int = 10;
@ptr *int = &x;  // Pointer to x
@value int = *ptr;  // Dereference pointer
```

### Structs

```tl
nirmanam Person {
    name string;
    age int;
}

@person Person = Person{name: "Alice", age: 30};
fmt.Printf("Name: %s\n", person.name);
```

### Maps

```tl
@scores jatha[string]int;
scores["Alice"] = 95;
@score int = scores["Alice"];

// Map operations
@length int = len(scores);  // Get map size
delete(scores, "Alice");    // Delete key from map

// Map iteration
malli key, value := varasa scores {
    fmt.Printf("%s: %d\n", key, value);
}
```

### Interfaces

```tl
interface Writer {
    Write(data string) int;
}

interface Reader {
    Read() string;
}

// Interfaces define method signatures that types must implement
// A struct implements an interface by having methods matching the interface
```

## Library Functions

All standard library functions use dot notation:

```tl
fmt.Printf("Hello\n");
strings.ToUpper("hello");
math.Sqrt(16.0);
io.ReadFile("file.txt");
```

See [Standard Library](standard-library.md) for complete reference.

## Examples

### Complete Program

```tl
#prarambham() {
    @name string = "Tlang";
    @version int = 1;
    
    fmt.Printf("Welcome to %s v%d!\n", name, version);
    
    @i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("Count: %d\n", i);
    }
}

#greet(name string) {
    fmt.Printf("Hello, %s!\n", name);
}
```

## Best Practices

1. **Use explicit types** when clarity is important
2. **Use type inference** for simple cases
3. **Name functions clearly** - use descriptive names
4. **Keep functions small** - one responsibility per function
5. **Use constants** for magic numbers and strings
6. **Format code consistently** - use consistent indentation

## See Also

- [Tutorial](tutorial.md) - Step-by-step learning guide
- [Standard Library](standard-library.md) - Library reference
- [Examples](examples.md) - Code examples
