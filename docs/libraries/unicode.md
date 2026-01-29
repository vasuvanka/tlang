# unicode - Unicode Utilities Library

The `unicode` library provides Unicode character classification and manipulation functions.

## Functions

### Character Classification

**`unicode.IsLetter(r)`** - Check if character is a letter

- `r`: Character code (integer)
- Returns: 1 if letter, 0 otherwise

**Example:**
```tl
@isLetter int = unicode.IsLetter(65);  // 'A' -> 1
@isLetter2 int = unicode.IsLetter(48); // '0' -> 0
```

**`unicode.IsDigit(r)`** - Check if character is a digit

- `r`: Character code (integer)
- Returns: 1 if digit, 0 otherwise

**Example:**
```tl
@isDigit int = unicode.IsDigit(48);  // '0' -> 1
@isDigit2 int = unicode.IsDigit(65); // 'A' -> 0
```

**`unicode.IsSpace(r)`** - Check if character is whitespace

- `r`: Character code (integer)
- Returns: 1 if whitespace, 0 otherwise

**Example:**
```tl
@isSpace int = unicode.IsSpace(32);  // ' ' -> 1
@isSpace2 int = unicode.IsSpace(65); // 'A' -> 0
```

### Case Conversion

**`unicode.ToUpper(r)`** - Convert to uppercase

- `r`: Character code (integer)
- Returns: Uppercase character code

**Example:**
```tl
@upper int = unicode.ToUpper(97);  // 'a' -> 'A' (65)
```

**`unicode.ToLower(r)`** - Convert to lowercase

- `r`: Character code (integer)
- Returns: Lowercase character code

**Example:**
```tl
@lower int = unicode.ToLower(65);  // 'A' -> 'a' (97)
```

### Case Checking

**`unicode.IsUpper(r)`** - Check if uppercase

- `r`: Character code (integer)
- Returns: 1 if uppercase, 0 otherwise

**Example:**
```tl
@isUpper int = unicode.IsUpper(65);  // 'A' -> 1
@isUpper2 int = unicode.IsUpper(97); // 'a' -> 0
```

**`unicode.IsLower(r)`** - Check if lowercase

- `r`: Character code (integer)
- Returns: 1 if lowercase, 0 otherwise

**Example:**
```tl
@isLower int = unicode.IsLower(97);  // 'a' -> 1
@isLower2 int = unicode.IsLower(65); // 'A' -> 0
```

## Common Patterns

### Process String Character by Character

```tl
@text string = "Hello123";
@i int = 0;
malli i < strings.Index(text, ""); i = i + 1 {
    @ch int = text[i];
    okavela unicode.IsLetter(ch) == 1 {
        @upper int = unicode.ToUpper(ch);
        fmt.Printf("'%c' -> '%c'\n", ch, upper);
    }
}
```

### Validate Input

```tl
#isValidUsername(username string) int {
    @i int = 0;
    malli i < strings.Index(username, ""); i = i + 1 {
        @ch int = username[i];
        okavela !(unicode.IsLetter(ch) || unicode.IsDigit(ch)) {
            mallinchu 0;  // Invalid character
        }
    }
    mallinchu 1;  // Valid
}
```

### Count Character Types

```tl
@text string = "Hello World 123";
@letters int = 0;
@digits int = 0;
@spaces int = 0;

@i int = 0;
malli i < strings.Index(text, ""); i = i + 1 {
    @ch int = text[i];
    okavela unicode.IsLetter(ch) {
        letters = letters + 1;
    } lekapothe okavela unicode.IsDigit(ch) {
        digits = digits + 1;
    } lekapothe okavela unicode.IsSpace(ch) {
        spaces = spaces + 1;
    }
}
```

## Notes

- Character codes are integers (ASCII/Unicode code points)
- Functions use standard C library character classification
- Works with ASCII characters (0-127)
- For full Unicode support, would need UTF-8 decoding

## See Also

- [strings Library](strings.md) - String operations
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
