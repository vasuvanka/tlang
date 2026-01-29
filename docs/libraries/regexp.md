# regexp - Regular Expressions Library

The `regexp` library provides regular expression pattern matching and text processing.

## Functions

### Pattern Matching

**`regexp.Match(pattern, text)`** - Check if pattern matches text

- `pattern`: Regular expression pattern (string)
- `text`: Text to search (string)
- Returns: 1 if match found, 0 otherwise

**Example:**
```tl
@matches int = regexp.Match("[0-9]+", "abc123def");  // 1
@noMatch int = regexp.Match("[0-9]+", "abc");        // 0
```

### Finding Matches

**`regexp.Find(pattern, text)`** - Find first match

- `pattern`: Regular expression pattern (string)
- `text`: Text to search (string)
- Returns: First matching substring, or empty string if no match

**Example:**
```tl
@found string = regexp.Find("[0-9]+", "abc123def456");  // "123"
```

**`regexp.FindAll(pattern, text, maxMatches)`** - Find all matches

- `pattern`: Regular expression pattern (string)
- `text`: Text to search (string)
- `maxMatches`: Maximum number of matches to find (int)
- Returns: Newline-separated string of all matches

**Example:**
```tl
@all string = regexp.FindAll("[0-9]+", "abc123def456", 10);
// Returns: "123\n456"
```

### Replacing

**`regexp.Replace(pattern, text, repl)`** - Replace first match

- `pattern`: Regular expression pattern (string)
- `text`: Text to search and replace (string)
- `repl`: Replacement string (string)
- Returns: String with first match replaced

**Example:**
```tl
@replaced string = regexp.Replace("fox", "The fox jumps", "cat");
// Returns: "The cat jumps"
```

**`regexp.ReplaceAll(pattern, text, repl)`** - Replace all matches

- `pattern`: Regular expression pattern (string)
- `text`: Text to search and replace (string)
- `repl`: Replacement string (string)
- Returns: String with all matches replaced

**Example:**
```tl
@replaced string = regexp.ReplaceAll("\\s+", "hello   world", " ");
// Returns: "hello world"
```

### Splitting

**`regexp.Split(pattern, text)`** - Split text by pattern

- `pattern`: Regular expression pattern (string)
- `text`: Text to split (string)
- Returns: Newline-separated string of split parts

**Example:**
```tl
@split string = regexp.Split("\\s+", "a b c");
// Returns: "a\nb\nc"
```

## Regular Expression Syntax

Uses POSIX Extended Regular Expressions (ERE) syntax:

- `.` - Match any character
- `*` - Zero or more of preceding element
- `+` - One or more of preceding element
- `?` - Zero or one of preceding element
- `^` - Start of string
- `$` - End of string
- `[abc]` - Character class (matches a, b, or c)
- `[0-9]` - Character range (matches digits)
- `[^abc]` - Negated character class
- `(abc)` - Grouping
- `|` - Alternation (OR)
- `\\` - Escape character

## Common Patterns

### Email Validation
```tl
@email string = "user@example.com";
@valid int = regexp.Match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email);
```

### Phone Number
```tl
@phone string = "123-456-7890";
@valid int = regexp.Match("^[0-9]{3}-[0-9]{3}-[0-9]{4}$", phone);
```

### Extract Numbers
```tl
@text string = "Price: $123.45";
@number string = regexp.Find("[0-9]+\\.[0-9]+", text);
```

### Remove Whitespace
```tl
@text string = "hello   world";
@cleaned string = regexp.ReplaceAll("\\s+", text, " ");
```

## Notes

- Uses POSIX regex (regcomp/regexec) which is available on most Unix-like systems
- On Windows, requires a POSIX-compatible regex library or MinGW
- Patterns use extended regex syntax (REG_EXTENDED flag)
- FindAll and Split return newline-separated strings (since Tlang doesn't have arrays yet)
- Invalid patterns will return 0 for Match, empty string for Find, or original text for Replace

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
