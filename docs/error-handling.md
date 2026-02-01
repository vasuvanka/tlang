# Error Handling

Tlang provides clear error messages and stack traces to help debug issues. Runtime error handling uses the **`error`** type and **`sunyam`** (nil): use `errors.New("msg")` and `okavela err != sunyam { ... }` (no `thappu` keyword in lexer).

## Compile-Time Errors

Tlang catches errors during compilation:

### Syntax Errors

**Example:**
```tl
@x int = 10  // Missing semicolon
```

**Error:**
```
Parser Error at file.tl:1:15: Expected Semicolon, but found EOF
```

### Type Errors

**Example:**
```tl
@x int = 10;
@y float = 3.14;
@sum = x + y;  // Type mismatch
```

**Error:**
```
Type Error: Cannot add int and float
```

### Undefined Variable

**Example:**
```tl
@x int = 10;
@result = y + 5;  // y not defined
```

**Error:**
```
Error: Undefined variable 'y'
```

## Error Messages

Tlang provides detailed error messages:

### Location Information

Errors include:
- **File name**: Which file has the error
- **Line number**: Which line
- **Column number**: Which column
- **Context**: Surrounding code

**Example:**
```
Parser Error at examples/hello.tl:5:12: Expected RightParen, but found Identifier

Context:
  3:     @name string = "Tlang";
  4:     @age int = 25;
  5:     fmt.Printf("Hello, %s\n", name;  // Missing closing paren
  6: }
```

### Stack Traces

For nested function calls, stack traces show the call chain:

```
Error in function 'processData'
  called from 'main'
  at examples/program.tl:10:5
```

## Runtime Errors

Some errors occur at runtime:

### File Not Found

```tl
@content string = io.ReadFile("nonexistent.txt");
// Returns empty string if file doesn't exist
```

**Handling:**
```tl
@content string = io.ReadFile("file.txt");
okavela strings.Index(content, "") == 0 {
    fmt.Printf("Error: File not found or empty\n");
}
```

### Invalid Conversion

```tl
@num int = strconv.Atoi("abc");
// Returns 0 on error
```

**Handling:**
```tl
@input string = "123";
@num int = strconv.Atoi(input);
okavela num == 0 {
    fmt.Printf("Error: Invalid number\n");
}
```

## Error Handling Patterns

### Check Return Values

```tl
@result int = io.WriteFile("output.txt", data);
okavela result == 0 {
    fmt.Printf("Error: Failed to write file\n");
    os.Exit(1);
}
```

### Validate Input

```tl
@filename string = args.Get(0);
okavela strings.Index(filename, "") == 0 {
    fmt.Printf("Error: Filename required\n");
    os.Exit(1);
}
```

### Check File Existence

```tl
@filename string = "config.txt";
@exists int = io.Exists(filename);
okavela exists == 0 {
    fmt.Printf("Error: File '%s' not found\n", filename);
    os.Exit(1);
}
```

### Validate Types

```tl
@input string = "123";
@num int = strconv.Atoi(input);
okavela num == 0 {
    fmt.Printf("Error: Invalid number '%s'\n", input);
    mallinchu;
}
```

## Debugging Tips

### Use Logging

```tl
log.SetLevel(0);  // DEBUG
log.Debug("Variable x = %d", x);
log.Debug("Entering function");
```

### Print Intermediate Values

```tl
@result int = calculate();
fmt.Printf("Debug: result = %d\n", result);
```

### Check Function Returns

```tl
@value int = someFunction();
okavela value == 0 {
    fmt.Printf("Error: Function returned 0\n");
}
```

## Common Errors

### Missing Semicolon

```tl
@x int = 10  // Error: Missing semicolon
```

**Fix:**
```tl
@x int = 10;  // Correct
```

### Mismatched Braces

```tl
okavela condition {
    // Missing closing brace
```

**Fix:**
```tl
okavela condition {
    // statements
}  // Correct
```

### Undefined Function

```tl
@result = unknownFunction();  // Error: Function not defined
```

**Fix:** Define the function or use correct name

### Type Mismatch

```tl
@x int = 10;
@y float = 3.14;
@sum = x + y;  // Error: Cannot mix types
```

**Fix:**
```tl
@x float = 10.0;
@y float = 3.14;
@sum float = x + y;  // Correct
```

## Best Practices

1. **Check return values** from functions that can fail
2. **Validate input** before processing
3. **Use logging** for debugging
4. **Handle errors explicitly** - don't ignore them
5. **Provide clear error messages** to users
6. **Exit gracefully** on fatal errors

## See Also

- [Language Reference](language-reference.md) - Syntax reference
- [Tutorial](tutorial.md) - Learning guide
- [log Library](libraries/log.md) - Logging functions
