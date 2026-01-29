# errors - Error Handling Utilities

The `errors` library provides helper functions for error handling patterns, similar to Go's `errors` package.

## Functions

### `errors.New(message)`

Creates a new error with the given message.

**Parameters:**
- `message`: Error message string

**Returns:**
- `error`: New error (allocated string)

**Example:**
```tl
@err error = errors.New("something went wrong");
okavela err != sunyam {
    fmt.Printf("Error: %s\n", err);
}
```

### `errors.Errorf(format, arg1)`

Creates a formatted error message.

**Parameters:**
- `format`: Format string (like `fmt.Sprintf`)
- `arg1`: First argument for formatting

**Returns:**
- `error`: Formatted error message

**Note:** Currently supports single argument. For multiple arguments, use `fmt.Sprintf` with `errors.New`.

**Example:**
```tl
@value int = 42;
@err error = errors.Errorf("invalid value: %d", value);
```

### `errors.Wrap(err, context)`

Wraps an existing error with additional context.

**Parameters:**
- `err`: Existing error to wrap
- `context`: Context message to prepend

**Returns:**
- `error`: Wrapped error with context

**Note:** Frees the original error and returns a new one.

**Example:**
```tl
#processFile(filename string) error {
    @err error = readFile(filename);
    okavela err != sunyam {
        mallinchu errors.Wrap(err, "failed to process file");
    }
    mallinchu sunyam;
}
```

### `errors.IsNil(err)`

Checks if an error is nil (no error).

**Parameters:**
- `err`: Error to check

**Returns:**
- `int`: `1` if error is nil, `0` if error exists

**Example:**
```tl
@err error = someFunction();
okavela errors.IsNil(err) == 0 {
    fmt.Printf("Error occurred: %s\n", err);
}
```

### `errors.Unwrap(err)`

Gets the underlying error (placeholder for future use).

**Parameters:**
- `err`: Error to unwrap

**Returns:**
- `error`: Underlying error (currently returns the error itself)

**Note:** This is a placeholder for future error wrapping features.

## Usage Patterns

### Pattern 1: Creating Errors
```tl
#validate(value int) error {
    okavela value < 0 {
        mallinchu errors.New("value cannot be negative");
    }
    mallinchu sunyam;
}
```

### Pattern 2: Error Wrapping
```tl
#process() error {
    @err error = readData();
    okavela err != sunyam {
        mallinchu errors.Wrap(err, "processing failed");
    }
    mallinchu sunyam;
}
```

### Pattern 3: Formatted Errors
```tl
#checkValue(value int) error {
    okavela value < 0 {
        @msg string = fmt.Sprintf("invalid value: %d", value);
        mallinchu errors.New(msg);
    }
    mallinchu sunyam;
}
```

### Pattern 4: Nil Checking
```tl
@err error = someFunction();
okavela errors.IsNil(err) == 1 {
    fmt.Printf("Success\n");
} lekapothe {
    fmt.Printf("Error: %s\n", err);
}
```

## Best Practices

1. **Use `errors.New()` for simple errors**
   ```tl
   mallinchu errors.New("file not found");
   ```

2. **Use `errors.Wrap()` to add context**
   ```tl
   @err error = readFile("data.txt");
   okavela err != sunyam {
       mallinchu errors.Wrap(err, "failed to load config");
   }
   ```

3. **Use `errors.IsNil()` for explicit nil checks**
   ```tl
   okavela errors.IsNil(err) == 0 {
       // Handle error
   }
   ```

4. **Combine with `fmt.Sprintf` for formatted errors**
   ```tl
   @msg string = fmt.Sprintf("error at line %d: %s", line, reason);
   mallinchu errors.New(msg);
   ```

## Memory Management

- `errors.New()` and `errors.Errorf()` allocate memory for error strings
- `errors.Wrap()` frees the original error and allocates a new one
- Caller is responsible for error memory (no automatic garbage collection)

## See Also

- [Error Handling Guide](../error-handling.md)
- [Error Handling Examples](../../examples/error_handling_comprehensive.tl)
- [Error Helpers Example](../../examples/error_helpers_example.tl)
