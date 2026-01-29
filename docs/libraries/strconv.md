# strconv - String Conversion Library

The `strconv` library provides functions to convert between strings and numeric types.

## Functions

### String to Number

**`strconv.Atoi(s)`** - Convert string to integer

- `s`: String to convert
- Returns: Integer value, or 0 on error

**Example:**
```tl
@num int = strconv.Atoi("123");  // 123
@zero int = strconv.Atoi("abc"); // 0 (error)
```

**`strconv.ParseFloat(s)`** - Convert string to float

- `s`: String to convert
- Returns: Float value, or 0.0 on error

**Example:**
```tl
@f float = strconv.ParseFloat("3.14");  // 3.14
```

**`strconv.ParseBool(s)`** - Convert string to boolean

- `s`: String to convert ("true", "false", "1", "0")
- Returns: 1 for true, 0 for false

**Example:**
```tl
@b1 int = strconv.ParseBool("true");   // 1
@b2 int = strconv.ParseBool("false");  // 0
@b3 int = strconv.ParseBool("1");      // 1
```

### Number to String

**`strconv.Itoa(i)`** - Convert integer to string

- `i`: Integer to convert
- Returns: String representation

**Example:**
```tl
@str string = strconv.Itoa(123);  // "123"
```

**`strconv.FormatFloat(f)`** - Convert float to string

- `f`: Float to convert
- Returns: String representation

**Example:**
```tl
@str string = strconv.FormatFloat(3.14);  // "3.14"
```

**`strconv.FormatBool(b)`** - Convert boolean to string

- `b`: Boolean (1 or 0)
- Returns: "true" or "false"

**Example:**
```tl
@str1 string = strconv.FormatBool(1);  // "true"
@str2 string = strconv.FormatBool(0);  // "false"
```

## Common Patterns

### Reading Numbers from Input
```tl
@input string = "42";
@num int = strconv.Atoi(input);
fmt.Printf("Number: %d\n", num);
```

### Formatting Numbers for Display
```tl
@age int = 25;
@message string = fmt.Sprintf("Age: %s", strconv.Itoa(age));
```

### Parsing Configuration
```tl
@config string = "debug=true";
@debug int = strconv.ParseBool("true");
```

## See Also

- [fmt Library](fmt.md) - String formatting
- [Language Reference](../language-reference.md)
