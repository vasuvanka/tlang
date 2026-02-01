# Mutable Variables (`@!`) Guide

## Overview

Tlang supports mutable variables through the `@!` keyword. All variables are **immutable by default** for safety, and you must explicitly declare mutability with `@!`.

## Syntax

```tl
// Immutable variable (default)
@variableName type = value;
@x int = 10;

// Mutable variable
@!variableName type = value;
@!counter int = 0;
```

## Basic Usage

### Declaration

```tl
// Immutable - cannot be reassigned
@name string = "Alice";
// name = "Bob";  // ERROR: Cannot assign to immutable variable

// Mutable - can be reassigned
@!counter int = 0;
counter = 10;        // OK
counter = counter + 1;  // OK
```

### Assignment

```tl
@!x int = 10;
x = 20;              // Simple assignment
x = x + 5;           // Assignment with expression
x = x * 2;           // Assignment with calculation
```

## Common Use Cases

### 1. Loop Counters

```tl
@!i int = 0;
malli i < 10; i = i + 1 {
    fmt.Printf("%d\n", i);
}
```

### 2. Accumulators

```tl
@!sum int = 0;
@numbers [5]int = {1, 2, 3, 4, 5};
@!i int = 0;
malli i < 5; i = i + 1 {
    sum = sum + numbers[i];
}
fmt.Printf("Sum: %d\n", sum);
```

### 3. State Management

```tl
@!score int = 0;
@!level int = 1;
@!lives int = 3;

okavela hitEnemy {
    score = score + 100;
    level = level + 1;
}
```

### 4. String Updates

```tl
@!message string = "Hello";
message = "Hello, World!";
message = fmt.Sprintf("Count: %d", count);
```

### 5. Array/Map Modifications

```tl
// Mutable array
@!arr [5]int = {1, 2, 3, 4, 5};
arr[0] = 10;
arr[1] = 20;

// Mutable map
@!scores jatha[string]int;
scores["Alice"] = 95;
scores["Alice"] = 100;  // Update existing entry
```

### 6. Struct Field Modifications

```tl
nirmanam Person {
    @!age int;
    @!name string;
}

@!person Person = Person{age: 30, name: "Alice"};
person.age = 31;
person.name = "Bob";
```

## Scope and Shadowing

```tl
@!outer int = 100;

okavela outer > 50 {
    // Inner scope can have its own mutable variable
    @!inner int = 200;
    
    // Can modify outer scope mutable variable
    outer = 150;
    
    // Inner variable shadows outer (different variable)
    @!outer int = 300;  // New variable in inner scope
}
```

## Compile-Time Safety

The compiler enforces immutability at compile time:

```tl
@x int = 10;
// x = 20;  // ERROR: Cannot assign to variable 'x': variables are immutable by default

// Solution 1: Use @!
@!y int = 10;
y = 20;  // OK

// Solution 2: Create new variable
@z int = 20;  // New immutable variable
```

## Error Messages

When you try to assign to an immutable variable, you get a clear error:

```
Cannot assign to variable 'x': variables are immutable by default. 
Use '@!x' to declare a mutable variable, or use a new variable declaration instead.
```

## Best Practices

### ✅ Do Use `@!` For:

- **Loop counters and iterators**
  ```tl
  @!i int = 0;
  ```

- **Accumulators and totals**
  ```tl
  @!sum int = 0;
  @!count int = 0;
  ```

- **State that changes**
  ```tl
  @!gameState GameState;
  @!connection Connection;
  ```

- **Buffers being modified**
  ```tl
  @!buffer []byte;
  @!items []Item;
  ```

- **Configuration that changes at runtime**
  ```tl
  @!currentLevel int = 1;
  @!debugMode int = 0;
  ```

### ❌ Don't Use `@!` For:

- **Constants** (use regular `@` variables)
  ```tl
  @PI float = 3.14159;  // Not @!
  ```

- **Values that don't change**
  ```tl
  @userName string = "Alice";  // Immutable is fine
  @config map = loadConfig();  // Doesn't need to change
  ```

- **Function parameters** (immutable by default)
  ```tl
  #process(data string) {  // 'data' is immutable
      // data = "new";  // ERROR
  }
  ```

- **Read-only data**
  ```tl
  @readOnlyData string = "shared";  // Immutable for safety
  ```

## Examples

### Complete Example

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    // Immutable variable
    @name string = "Tlang";
    fmt.Printf("Language: %s\n", name);
    
    // Mutable counter
    @!count int = 0;
    count = count + 1;
    fmt.Printf("Count: %d\n", count);
    
    // Mutable loop variable
    @!i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("Iteration: %d\n", i);
    }
    
    // Mutable accumulator
    @!sum int = 0;
    @numbers [3]int = {10, 20, 30};
    @!j int = 0;
    malli j < 3; j = j + 1 {
        sum = sum + numbers[j];
    }
    fmt.Printf("Sum: %d\n", sum);
}
```

## Implementation Details

### How It Works

1. **Parser**: Recognizes `@!` syntax and tracks mutability in `mutable_vars` HashMap
2. **Type Checking**: Verifies mutability before allowing assignment
3. **Code Generation**: Generates non-const C variables for mutable declarations
4. **Scope Handling**: Properly checks mutability across nested scopes

### Generated C Code

```c
// Immutable variable
const int x = 10;

// Mutable variable
int counter = 0;
counter = 10;  // Allowed
```

## See Also

- [Immutability Analysis](immutability-analysis.md) - Detailed pros and cons
- [Keywords and Operators](keywords-operators.md) - Complete syntax reference
- [Best Practices](best-practices.md) - Coding guidelines
