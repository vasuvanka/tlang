# url - URL Parsing and Manipulation Library

The `url` library provides URL parsing, encoding, and manipulation functions.

## Functions

### URL Parsing

**`url.Parse(rawurl)`** - Parse URL into components

- `rawurl`: URL string to parse
- Returns: Formatted string with format "scheme|host|path|query"

**Example:**
```tl
@parsed string = url.Parse("https://example.com/path?query=value");
fmt.Printf("Parsed: %s\n", parsed);
// Output: "https|example.com|/path|query=value"
```

### Query String Encoding

**`url.QueryEscape(s)`** - Escape query string

- `s`: String to escape
- Returns: Percent-encoded string

**Example:**
```tl
@escaped string = url.QueryEscape("hello world");
fmt.Printf("Escaped: %s\n", escaped);  // "hello%20world"
```

**`url.QueryUnescape(s)`** - Unescape query string

- `s`: Percent-encoded string
- Returns: Unescaped string

**Example:**
```tl
@unescaped string = url.QueryUnescape("hello%20world");
fmt.Printf("Unescaped: %s\n", unescaped);  // "hello world"
```

### Path Encoding

**`url.PathEscape(s)`** - Escape URL path

- `s`: String to escape
- Returns: Percent-encoded string (path-safe)

**Example:**
```tl
@escaped string = url.PathEscape("user profile");
fmt.Printf("Escaped: %s\n", escaped);  // "user%20profile"
```

**`url.PathUnescape(s)`** - Unescape URL path

- `s`: Percent-encoded string
- Returns: Unescaped string

**Example:**
```tl
@unescaped string = url.PathUnescape("user%20profile");
fmt.Printf("Unescaped: %s\n", unescaped);  // "user profile"
```

### Path Joining

**`url.JoinPath(base, path)`** - Join URL path components

- `base`: Base URL or path
- `path`: Path component to join
- Returns: Joined path with proper slashes

**Example:**
```tl
@joined string = url.JoinPath("https://example.com", "/api/users");
fmt.Printf("Joined: %s\n", joined);  // "https://example.com/api/users"
```

## Common Patterns

### Building URLs

```tl
@base string = "https://api.example.com";
@endpoint string = "/v1/users";
@userID string = "123";
@fullPath string = url.JoinPath(url.JoinPath(base, endpoint), userID);
@query string = url.QueryEscape("John Doe");
@finalURL string = fmt.Sprintf("%s?name=%s", fullPath, query);
```

### Parsing URLs

```tl
@url string = "https://example.com/path?key=value";
@parsed string = url.Parse(url);
// parsed format: "scheme|host|path|query"
// Can split by "|" to get components
```

### Encoding Query Parameters

```tl
@name string = "John Doe";
@email string = "user@example.com";
@nameEncoded string = url.QueryEscape(name);
@emailEncoded string = url.QueryEscape(email);
@query string = fmt.Sprintf("name=%s&email=%s", nameEncoded, emailEncoded);
```

### Decoding Query Parameters

```tl
@encoded string = "hello%20world%21";
@decoded string = url.QueryUnescape(encoded);
fmt.Printf("Decoded: %s\n", decoded);  // "hello world!"
```

## URL Parse Format

The `url.Parse()` function returns a string with format:
```
scheme|host|path|query
```

**Example:**
- Input: `"https://example.com/api/users?id=1"`
- Output: `"https|example.com|/api/users|id=1"`

To extract components:
```tl
@parsed string = url.Parse("https://example.com/path?query=value");
// Use string functions to split by "|"
```

## Notes

- Query escaping encodes spaces as `%20`, special characters as `%XX`
- Path escaping preserves `/` characters (doesn't encode them)
- `JoinPath` handles trailing/leading slashes automatically
- Percent-encoding uses uppercase hex digits (`%XX`)

## See Also

- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
