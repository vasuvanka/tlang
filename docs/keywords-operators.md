# Keywords and Operators Reference

**For the keyword list and usage (aligned with lexer/parser), see [Reserved Keywords](reserved-keywords.md).** This document focuses on **operators** and **mutable variables** (`@!`).

## Keywords (summary — see reserved-keywords.md for full list)

### Variable Declaration

**`@`** - Variable declaration (immutable by default)

```tl
@variableName type = value;
@x int = 10;
@name string = "Tlang";
```

**`@!`** - Mutable variable declaration

```tl
@!variableName type = value;
@!counter int = 0;
counter = counter + 1;  // OK: mutable
counter = 100;          // OK: can reassign
```

**Key Points:**
- Variables declared with `@!` can be reassigned
- Use `@!` for loop counters, accumulators, and stateful variables
- Immutable variables (`@`) cannot be reassigned - compiler error if attempted
- Assignment syntax: `variableName = value;` (only works with `@!` variables)
- Mutable variables are generated as non-const in C code

**Syntax:**
```tl
// Mutable variable with explicit type
@!counter int = 0;

// Mutable variable with type inference
@!sum = 0;  // Inferred as int

// Mutable string
@!message string = "Hello";
message = "World";  // OK

// Mutable array
@!arr [5]int = {1, 2, 3, 4, 5};
arr[0] = 10;  // OK: can modify elements
```

**When to use `@!`:**

1. **Loop counters and accumulators**
   ```tl
   @!i int = 0;
   malli i < 10; i = i + 1 {
       // loop body
   }
   
   @!sum int = 0;
   malli i = 0; i < 10; i = i + 1 {
       sum = sum + i;
   }
   ```

2. **Stateful objects**
   ```tl
   @!gameState GameState = GameState{};
   @!connection Connection;
   ```

3. **Buffers and collections being modified**
   ```tl
   @!buffer []byte;
   @!items []Item;
   @!scores jatha[string]int;
   ```

4. **Configuration that changes at runtime**
   ```tl
   @!currentLevel int = 1;
   @!debugMode int = 0;
   ```

5. **Variables that need to be updated**
   ```tl
   @!userCount int = 0;
   userCount = userCount + 1;  // Increment
   ```

**When NOT to use `@!`:**

1. **Function parameters** (immutable by default)
   ```tl
   #process(data string) {  // 'data' is immutable
       // data = "new";  // ERROR: Cannot assign to parameter
   }
   ```


3. **Values that don't change after initialization**
   ```tl
   @userName string = "Alice";  // Immutable is fine
   @config map = loadConfig();  // Doesn't need to change
   ```

4. **Shared/read-only data**
   ```tl
   @readOnlyData string = "shared";  // Immutable for safety
   ```

**Examples:**

```tl
// ✅ Good: Mutable for loop counter
@!i int = 0;
malli i < 10; i = i + 1 {
    fmt.Printf("%d\n", i);
}

// ✅ Good: Mutable accumulator
@!total int = 0;
@numbers [5]int = {1, 2, 3, 4, 5};
@!j int = 0;
malli j < 5; j = j + 1 {
    total = total + numbers[j];
}

// ✅ Good: Mutable state
@!score int = 0;
@!level int = 1;
score = score + 100;
level = level + 1;

// ❌ Bad: Unnecessary mutability
@!userName string = "Alice";  // Doesn't change
@!pi float = 3.14159;         // Mutable variable

// ❌ Error: Assigning to immutable
@x int = 10;
// x = 20;  // ERROR: Cannot assign to variable 'x'
```

**Compile-Time Safety:**
- Attempting to assign to an immutable variable causes a compile error
- Error message: `"Cannot assign to variable 'x': variables are immutable by default. Use '@!x' to declare a mutable variable"`
- This prevents accidental mutations and makes code safer

### Function Declaration

**`#`** - Function declaration

```tl
#functionName(params) returnType {
    // function body
}
```

**`#prarambham`** - Entry point function (main)

```tl
#prarambham() {
    // Program starts here
}
```

### Control Flow

**`okavela`** - If statement (Telugu for "if")

```tl
okavela condition {
    // statements
}
```

**`lekapothe`** - Else statement (Telugu for "else")

```tl
okavela condition {
    // statements
} lekapothe {
    // statements
}
```

**`malli`** - For loop (Telugu for "again")

```tl
// Standard for loop (C-style)
@!i int = 0;
malli i < 10; i = i + 1 {
    // statements
}

// Infinite loop
malli {
    // statements
    okavela condition {
        agu;  // break
    }
}

// For loop over map only (varasa — key, or key and value)
malli key := varasa map {
    // statements
}

malli key, value := varasa map {
    // statements
}
```

**Important:** Loop variables must be declared with `@!` if they are modified in the loop:

```tl
// ✅ Correct: Mutable loop counter
@!i int = 0;
malli i < 10; i = i + 1 {
    fmt.Printf("%d\n", i);
}

// ❌ Error: Immutable loop counter
@i int = 0;
malli i < 10; i = i + 1 {  // ERROR: Cannot assign to 'i'
    // ...
}
```

**`agu`** - Break statement (Telugu for "break")

```tl
agu;  // Exit loop
```

**`konasagu`** - Continue statement (Telugu for "continue")

```tl
konasagu;  // Skip to next iteration
```

**`mallinchu`** - Return statement (Telugu for "return")

```tl
mallinchu value;  // Return from function
mallinchu errors.New("error message");  // Return error
```


**Error handling** - Use `errors.New("msg")` and `okavela err != sunyam { ... }`

```tl
mallinchu errors.New("error message");  // Return error
@err error = errors.New("something went wrong");
okavela err != sunyam {  // Check for error
    // Handle error
}
```

**`sunyam`** - Nil/null value (Telugu for "zero/empty")

```tl
@value string = sunyam;  // Nil value
okavela value == sunyam {
    // Value is nil
}
```

### Types

**`int`** - Integer type

```tl
@x int = 42;
```

**`float`** - Floating point type

```tl
@pi float = 3.14;
```

**`string`** - String type

```tl
@name string = "Tlang";
```

**`bool`** - Boolean type (1 or 0)

```tl
@isActive int = 1;  // true
@isInactive int = 0;  // false
```

**`void`** - No value (function return type)

```tl
#printMessage(msg string) {
    fmt.Printf("%s\n", msg);
}
```

### Constants


### Structures and Maps

**`nirmanam`** - Struct type (Telugu for "struct")

```tl
nirmanam Person {
    @name string;
    @age int;
}
```

**`jatha`** - Map type (Telugu for "map")

```tl
@m jatha[string]int;
```

### Import

Use **`@variable = #dhimpu("path")`** (no explicit package keyword). See [Packages](packages.md) and [Reserved Keywords](reserved-keywords.md).

```tl
@fmt = #dhimpu("std/fmt");
@strings = #dhimpu("std/strings");
```

## Operators

### Ownership and Borrowing Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `&` | Immutable borrow | `@ref = &value` |
| `&mut` | Mutable borrow | `@ref = &mut value` |
| `*` | Dereference | `@copy = *ref` |
| `<-` | Move / channel send & receive | `@new = <- old` (move); `ch <- value` (send); `@x = <- ch` (receive) |

**Immutable Borrow (`&`)** - Create a read-only reference

```tl
@data int = 42;
@ref *int = &data;  // Immutable borrow
fmt.Printf("Value: %d\n", *ref);
```

**Mutable Borrow (`&mut`)** - Create a writable reference

```tl
@!data int = 42;
@ref *int = &mut data;  // Mutable borrow
*ref = 100;  // Modify through reference
```

**Dereference (`*`)** - Access the value behind a reference

```tl
@value int = 42;
@ref *int = &value;
@copy int = *ref;  // Dereference to get value
```

**Move and channels (`<-`)** - Ownership transfer and channel operations

```tl
@original string = "hello";
@moved string = <- original;
// original is no longer valid (move)

// Channels: send and receive use the same operator
@ch channel[int];
ch <- 42;           // send
@x int = <- ch;     // receive
```

Use `<-` for move; for channels, `ch <- value` is send and `<- ch` is receive.

### Arithmetic Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `a + b` |
| `-` | Subtraction | `a - b` |
| `*` | Multiplication | `a * b` |
| `/` | Division | `a / b` |
| `%` | Modulo | `a % b` |
| `^` | Power | `a ^ b` |

**Examples:**
```tl
@sum int = 10 + 5;        // 15
@diff int = 10 - 5;       // 5
@prod int = 10 * 5;       // 50
@quot int = 10 / 5;       // 2
@mod int = 10 % 3;        // 1
@power float = 2.0 ^ 3.0; // 8.0
```

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `==` | Equal | `a == b` |
| `!=` | Not equal | `a != b` |
| `<` | Less than | `a < b` |
| `>` | Greater than | `a > b` |
| `<=` | Less than or equal | `a <= b` |
| `>=` | Greater than or equal | `a >= b` |

**Examples:**
```tl
@eq int = (10 == 10);     // 1 (true)
@ne int = (10 != 5);      // 1 (true)
@lt int = (5 < 10);       // 1 (true)
@gt int = (10 > 5);       // 1 (true)
@le int = (5 <= 10);      // 1 (true)
@ge int = (10 >= 5);      // 1 (true)
```

### Logical Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `&&` | Logical AND | `a && b` |
| `\|\|` | Logical OR | `a \|\| b` |
| `!` | Logical NOT | `!a` |

**Examples:**
```tl
@and int = (1 && 1);      // 1 (true)
@or int = (1 || 0);       // 1 (true)
@not int = !0;             // 1 (true)
```

### Assignment Operators

**Basic Assignment:**
```tl
@x int = 10;  // Assign 10 to x
```

**Compound Assignment:**
```tl
@x int = 10;
@x = x + 1;   // Increment
@x = x - 1;   // Decrement
@x = x * 2;   // Multiply and assign
@x = x / 2;   // Divide and assign
```

### Pointer Operators

**`*`** - Pointer type / Dereference

```tl
@x int = 10;
@ptr *int = &x;    // Pointer to x
@value int = *ptr;  // Dereference pointer
```

**`&`** - Address of

```tl
@x int = 10;
@ptr *int = &x;  // Address of x
```

## Operator Precedence

Operators are evaluated in the following order (highest to lowest):

1. Parentheses `()`
2. Unary operators `!`, `-`, `*`, `&`
3. Multiplicative `*`, `/`, `%`
4. Additive `+`, `-`
5. Comparison `<`, `>`, `<=`, `>=`
6. Equality `==`, `!=`
7. Logical AND `&&`
8. Logical OR `||`
9. Assignment `=`

**Example:**
```tl
@result int = 2 + 3 * 4;      // 14 (not 20)
@result2 int = (2 + 3) * 4;   // 20
```

## Comments

**`//`** - Single-line comment

```tl
// This is a comment
@x int = 10;  // Comment after code
```

**`/* */`** - Multi-line comment

```tl
/* This is a
   multi-line comment */

/* Single line comment */
```

## Reserved words

For the full list and usage, see **[Reserved Keywords](reserved-keywords.md)** (matches lexer/parser).

- **Lexer keywords:** okavela, lekapothe, malli, mallinchu, agu, konasagu, nirmanam, jatha, sunyam; types: int, float, string, bool, error, channel. Move/channel: `<-` only (no `jarugu` keyword).
- **Declaration symbols:** `@`, `@!`, `#`. No explicit package or alias keyword.
- **Special identifiers:** prarambham (entry), varasa (range loop); true, false (boolean literals).

## See also

- [Reserved Keywords](reserved-keywords.md) — keyword list and usage (canonical)
- [Language Reference](language-reference.md) — complete syntax
- [Tutorial](tutorial.md) — learning guide
