# Multiple Return Values and Error Propagation

## Overview

Tlang now supports Go-style multiple return values and error propagation, making error handling more ergonomic.

## Multiple Return Values

### Function Declaration

Functions can return multiple values using tuple syntax:

```tl
#divide(a int, b int) (int, error) {
    okavela b == 0 {
        mallinchu (0, errors.New("division by zero"));
    }
    mallinchu (a / b, sunyam);
}
```

### Tuple Return Type

- Syntax: `(type1, type2, ...)`
- Example: `(int, error)`, `(string, int, error)`
- The compiler generates a struct to hold multiple return values

### Returning Tuples

Return multiple values using tuple literal syntax:

```tl
mallinchu (value, sunyam);  // Return value and nil error
mallinchu (0, errors.New("error message"));  // Return zero value and error
```

### Receiving Multiple Values

Assign multiple return values to multiple variables:

```tl
@result, @err (int, error) = divide(10, 2);
okavela err != sunyam {
    fmt.Printf("Error: %s\n", err);
} lekapothe {
    fmt.Printf("Result: %d\n", result);
}
```

## Error Propagation

### The `?` Operator

The `?` operator automatically checks for errors and returns early if an error occurs:

```tl
#safeDivide(a int, b int) (int, error) {
    // If divide fails, automatically return error
    @result, @err (int, error) = divide(a, b)?;
    // If we get here, no error occurred
    mallinchu (result, sunyam);
}
```

### How It Works

1. **With Tuple Returns**: `expr?` checks the error field (typically last field)
   - If error is not NULL, returns the error immediately
   - Otherwise, continues with the value

2. **With Error Returns**: `expr?` checks if the error is not NULL
   - If error exists, returns it
   - Otherwise, continues

### Usage Examples

```tl
// Error propagation with tuple return
@result, @err (int, error) = divide(10, 2)?;
// If divide returns error, this function returns immediately

// Error propagation in expression
@value int = someFunction()?;
// If someFunction returns error, return error immediately
```

## Implementation Details

### Tuple Struct Generation

When a function returns `(int, error)`, the compiler generates:

```c
typedef struct Tuple_int_charptr {
    int field0;
    char* field1;
} Tuple_int_charptr;
```

### Return Statement

Returning `(value, error)` generates:

```c
return (Tuple_int_charptr){.field0 = value, .field1 = error};
```

### Multiple Assignment

Assigning `@a, @b = func()` generates:

```c
auto _tuple_result = func();
auto a = _tuple_result.field0;
auto b = _tuple_result.field1;
```

### Error Propagation

The `?` operator generates:

```c
auto _tuple_result = func();
if (_tuple_result.field1 != NULL) return _tuple_result.field1;
// Continue with value
```

## Examples

### Basic Multiple Return Values

```tl
#divide(a int, b int) (int, error) {
    okavela b == 0 {
        mallinchu (0, errors.New("division by zero"));
    }
    mallinchu (a / b, sunyam);
}

#prarambham() {
    @result, @err (int, error) = divide(10, 2);
    okavela err != sunyam {
        fmt.Printf("Error: %s\n", err);
    } lekapothe {
        fmt.Printf("Result: %d\n", result);
    }
}
```

### Error Propagation

```tl
#safeDivide(a int, b int) (int, error) {
    // Automatically return error if divide fails
    @result, @err (int, error) = divide(a, b)?;
    mallinchu (result, sunyam);
}

#prarambham() {
    @result, @err (int, error) = safeDivide(20, 4);
    okavela err != sunyam {
        fmt.Printf("Error: %s\n", err);
    } lekapothe {
        fmt.Printf("Result: %d\n", result);
    }
}
```

### Chaining with Error Propagation

```tl
#processData(data string) (string, error) {
    @step1, @err1 (string, error) = validate(data)?;
    @step2, @err2 (string, error) = transform(step1)?;
    @step3, @err3 (string, error) = finalize(step2)?;
    mallinchu (step3, sunyam);
}
```

## Limitations

1. **Tuple Literal Syntax**: Currently, tuple literals must be in return statements or assignments. Standalone tuple literals are not yet fully supported.

2. **Type Inference**: Tuple types must be explicitly specified in function signatures and variable declarations.

3. **Error Field Position**: Error propagation assumes the error is the last field in the tuple. This is the Go convention.

4. **Nested Tuples**: Nested tuples (tuples containing tuples) are not yet supported.

## Best Practices

1. **Error as Last Field**: Always put the error as the last field: `(value, error)`

2. **Check Errors**: Always check errors after multiple assignment:
   ```tl
   @result, @err (int, error) = divide(10, 2);
   okavela err != sunyam {
       // Handle error
   }
   ```

3. **Use Error Propagation**: Use `?` operator to simplify error handling:
   ```tl
   @result, @err (int, error) = divide(a, b)?;
   // If error, function returns immediately
   ```

4. **Error Messages**: Use descriptive error messages:
   ```tl
   mallinchu (0, errors.New("division by zero: cannot divide by 0"));
   ```

## See Also

- [Error Handling Guide](error-handling.md)
- [Language Reference](language-reference.md)
- [Examples](../examples/multiple_return_values_example.tl)
