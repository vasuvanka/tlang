# Best Practices

Guidelines for writing clean, maintainable Tlang code.

## Code Style

### Naming Conventions

**Variables:** Use descriptive names, camelCase

```tl
// Good
@userName string = "Alice";
@itemCount int = 10;

// Bad
@u string = "Alice";
@c int = 10;
```

**Functions:** Use descriptive names, start with verb

```tl
// Good
#calculateTotal(items int) int {
    // ...
}

#getUserName() string {
    // ...
}

// Bad
#calc(items int) int {
    // ...
}

#name() string {
    // ...
}
```

**Constants:** Use UPPER_CASE

```tl
// Good
@MAX_SIZE int = 100;
@APP_NAME string = "MyApp";

// Bad
@maxSize int = 100;  // Should use UPPER_CASE for constants
```

### Formatting

**Indentation:** Use consistent indentation (spaces or tabs)

```tl
// Good
okavela condition {
    @x int = 10;
    fmt.Printf("%d\n", x);
}

// Bad
okavela condition {
@x int = 10;
fmt.Printf("%d\n", x);
}
```

**Spacing:** Use spaces around operators

```tl
// Good
@sum int = a + b;
@result int = (x + y) * 2;

// Bad
@sum int = a+b;
@result int = (x+y)*2;
```

## Variable Declarations

### Use Explicit Types When Needed

```tl
// Good - explicit type for clarity
@count int = 0;
@name string = "";

// Good - type inference for simple cases
@x = 10;
@pi = 3.14;
```

### Initialize Variables

```tl
// Good
@count int = 0;
@name string = "";

// Avoid uninitialized variables when possible
@count int;  // Only if you'll assign before use
```

### Use Constants for Magic Numbers

```tl
// Good
@MAX_RETRIES int = 3;
@TIMEOUT int = 30;

@i int = 0;
malli i < MAX_RETRIES; i = i + 1 {
    // ...
}

// Bad
@i int = 0;
malli i < 3; i = i + 1 {  // Magic number
    // ...
}
```

## Functions

### Keep Functions Small

```tl
// Good - single responsibility
#calculateTotal(items int) int {
    @total int = 0;
    @i int = 0;
    malli i < items; i = i + 1 {
        total = total + getItemPrice(i);
    }
    mallinchu total;
}

// Bad - does too much
#processEverything() {
    // 100 lines of code
}
```

### Use Descriptive Names

```tl
// Good
#getUserById(id int) User {
    // ...
}

#validateEmail(email string) int {
    // ...
}

// Bad
#get(id int) User {
    // ...
}

#check(email string) int {
    // ...
}
```

### Return Early

```tl
// Good
#processFile(filename string) {
    @exists int = io.Exists(filename);
    okavela exists == 0 {
        fmt.Printf("File not found\n");
        mallinchu;
    }
    // Process file
}

// Bad - nested conditionals
#processFile(filename string) {
    @exists int = io.Exists(filename);
    okavela exists == 1 {
        // Process file (deeply nested)
    }
}
```

## Error Handling

### Check Return Values

```tl
// Good
@result int = io.WriteFile("output.txt", data);
okavela result == 0 {
    fmt.Printf("Error: Failed to write file\n");
    os.Exit(1);
}

// Bad - ignoring errors
io.WriteFile("output.txt", data);
```

### Validate Input

```tl
// Good
#processInput(input string) {
    okavela strings.Index(input, "") == 0 {
        fmt.Printf("Error: Empty input\n");
        mallinchu;
    }
    // Process input
}
```

### Use Logging

```tl
// Good
log.Info("Processing file");
@result int = processFile();
okavela result == 0 {
    log.Error("Failed to process file");
    mallinchu;
}
log.Info("File processed successfully");
```

## Control Flow

### Prefer Early Returns

```tl
// Good
#processData(data string) {
    okavela strings.Index(data, "") == 0 {
        mallinchu;
    }
    // Process data
}

// Bad - nested conditionals
#processData(data string) {
    okavela strings.Index(data, "") > 0 {
        // Process data (nested)
    }
}
```

### Use Clear Conditions

```tl
// Good
@isValid int = validateInput(input);
okavela isValid == 1 {
    // Process
}

// Bad - complex condition
okavela (x > 10 && y < 20) || (z == 5 && w != 0) {
    // Hard to understand
}
```

## Comments

### Write Self-Documenting Code

```tl
// Good - code is clear
@userCount int = getUserCount();
@maxUsers int = 100;
okavela userCount >= maxUsers {
    fmt.Printf("User limit reached\n");
}

// Bad - needs comment to understand
@uc int = getUC();  // What is uc?
@mu int = 100;      // What is mu?
okavela uc >= mu {   // What does this check?
    // ...
}
```

### Comment Why, Not What

```tl
// Good - explains why
// Use binary search for O(log n) performance
@result int = binarySearch(items, target);

// Bad - states the obvious
// Increment counter
@count = count + 1;
```

## Library Usage

### Use Standard Library

```tl
// Good
@upper string = strings.ToUpper(text);
@sqrt float = math.Sqrt(16.0);

// Bad - reimplementing library functions
// (unless you have a specific reason)
```

### Handle Library Errors

```tl
// Good
@num int = strconv.Atoi(input);
okavela num == 0 {
    fmt.Printf("Error: Invalid number\n");
    mallinchu;
}

// Bad - assuming success
@num int = strconv.Atoi(input);
// Use num without checking
```

## Performance

### Avoid Unnecessary Operations

```tl
// Good
@exists int = io.Exists(filename);
okavela exists == 1 {
    @content string = io.ReadFile(filename);
}

// Bad - reading file even if it doesn't exist
@content string = io.ReadFile(filename);
okavela strings.Index(content, "") > 0 {
    // Process
}
```

### Use Appropriate Data Types

```tl
// Good
@count int = 0;        // Use int for counts
@price float = 9.99;   // Use float for prices

// Bad
@count float = 0.0;    // Unnecessary precision
@price int = 9;       // Loses precision
```

## Testing

### Write Testable Code

```tl
// Good - pure function, easy to test
#add(a int, b int) int {
    mallinchu a + b;
}

// Bad - side effects, hard to test
#process() {
    @file string = io.ReadFile("hardcoded.txt");
    fmt.Printf("%s\n", file);
    // Can't test without file
}
```

### Test Edge Cases

```tl
#testAddition() {
    // Test normal case
    testing.AssertEqual(5, add(2, 3));
    
    // Test edge cases
    testing.AssertEqual(0, add(0, 0));
    testing.AssertEqual(-1, add(0, -1));
}
```

## Summary

1. **Write clear, descriptive code** - Code should be self-documenting
2. **Handle errors explicitly** - Don't ignore return values
3. **Keep functions small** - Single responsibility
4. **Use meaningful names** - Variables and functions should be descriptive
5. **Follow conventions** - Consistent style throughout codebase
6. **Test your code** - Write tests for important functions
7. **Use standard library** - Don't reinvent the wheel
8. **Comment when needed** - Explain why, not what

## See Also

- [Language Reference](language-reference.md) - Complete syntax
- [Tutorial](tutorial.md) - Learning guide
- [Examples](examples.md) - Code examples
