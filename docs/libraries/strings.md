# strings - String Operations Library

The `strings` library provides string manipulation functions, similar to Go's strings package.

## Functions

### Contains

**`strings.Contains(s, substr)`** - Check if string contains substring

- `s`: String to search
- `substr`: Substring to find
- Returns: 1 if found, 0 otherwise

**Example:**
```tl
@text string = "Hello World";
@hasHello int = strings.Contains(text, "Hello");  // 1
@hasHi int = strings.Contains(text, "Hi");        // 0
```

### HasPrefix

**`strings.HasPrefix(s, prefix)`** - Check if string has prefix

- `s`: String to check
- `prefix`: Prefix to check
- Returns: 1 if has prefix, 0 otherwise

**Example:**
```tl
@url string = "https://example.com";
@isHttps int = strings.HasPrefix(url, "https://");  // 1
```

### HasSuffix

**`strings.HasSuffix(s, suffix)`** - Check if string has suffix

- `s`: String to check
- `suffix`: Suffix to check
- Returns: 1 if has suffix, 0 otherwise

**Example:**
```tl
@filename string = "file.txt";
@isTxt int = strings.HasSuffix(filename, ".txt");  // 1
```

### Index

**`strings.Index(s, substr)`** - Find index of substring

- `s`: String to search
- `substr`: Substring to find
- Returns: Index of first occurrence, or -1 if not found

**Example:**
```tl
@text string = "Hello World";
@index int = strings.Index(text, "World");  // 6
@notFound int = strings.Index(text, "xyz"); // -1
```

### ToUpper

**`strings.ToUpper(s)`** - Convert string to uppercase

- `s`: String to convert
- Returns: Uppercase string

**Example:**
```tl
@text string = "Hello World";
@upper string = strings.ToUpper(text);  // "HELLO WORLD"
```

### ToLower

**`strings.ToLower(s)`** - Convert string to lowercase

- `s`: String to convert
- Returns: Lowercase string

**Example:**
```tl
@text string = "Hello World";
@lower string = strings.ToLower(text);  // "hello world"
```

### TrimSpace

**`strings.TrimSpace(s)`** - Remove leading and trailing whitespace

- `s`: String to trim
- Returns: Trimmed string

**Example:**
```tl
@text string = "  Hello World  ";
@trimmed string = strings.TrimSpace(text);  // "Hello World"
```

## Common Patterns

### Case-insensitive Comparison
```tl
@input string = "Hello";
@upper string = strings.ToUpper(input);
okavela strings.Contains(upper, "HELLO") {
    fmt.Printf("Found!\n");
}
```

### File Extension Check
```tl
@filename string = "image.jpg";
okavela strings.HasSuffix(filename, ".jpg") {
    fmt.Printf("JPEG image\n");
}
```

### String Validation
```tl
@email string = "user@example.com";
okavela strings.Contains(email, "@") {
    fmt.Printf("Valid email format\n");
}
```

## See Also

- [Tutorial - Lesson 7](tutorial.md#lesson-7-strings)
- [Language Reference](language-reference.md)
