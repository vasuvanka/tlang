# net/url - Network URL Utilities Library

The `net/url` library provides additional network URL utilities, complementing the `url` package.

## Functions

### URL Parsing

**`neturl.Parse(rawurl)`** - Parse network URL

- `rawurl`: URL string to parse
- Returns: Formatted string with format "scheme|user|host|port|path"

**Example:**
```tl
@parsed string = neturl.Parse("https://user:pass@example.com:8080/path");
// Returns: "https|user:pass|example.com|8080|/path"
```

### User Information

**`neturl.User(username, password)`** - Create user info string

- `username`: Username
- `password`: Password (can be empty string)
- Returns: User info string in format "username:password" or "username"

**Example:**
```tl
@user1 string = neturl.User("admin", "secret");
// Returns: "admin:secret"

@user2 string = neturl.User("guest", "");
// Returns: "guest"
```

### URL Components

**`neturl.Hostname(url)`** - Extract hostname from URL

- `url`: URL string
- Returns: Hostname (without port)

**Example:**
```tl
@hostname string = neturl.Hostname("https://example.com:8080/path");
// Returns: "example.com"
```

**`neturl.Port(url)`** - Extract port from URL

- `url`: URL string
- Returns: Port number, or empty string if no port

**Example:**
```tl
@port string = neturl.Port("https://example.com:8080/path");
// Returns: "8080"

@port2 string = neturl.Port("https://example.com/path");
// Returns: "" (empty)
```

## URL Parse Format

The `neturl.Parse()` function returns a string with format:
```
scheme|user|host|port|path
```

**Example:**
- Input: `"https://admin:secret@example.com:8080/api/users"`
- Output: `"https|admin:secret|example.com|8080|/api/users"`

## Common Patterns

### Build URL with Authentication

```tl
@username string = "admin";
@password string = "secret";
@host string = "example.com";
@port string = "8080";
@path string = "/api/data";

@userInfo string = neturl.User(username, password);
@fullURL string = fmt.Sprintf("https://%s@%s:%s%s", userInfo, host, port, path);
// Result: "https://admin:secret@example.com:8080/api/data"
```

### Extract Components

```tl
@url string = "https://user:pass@example.com:8080/path";
@hostname string = neturl.Hostname(url);
@port string = neturl.Port(url);
fmt.Printf("Host: %s, Port: %s\n", hostname, port);
```

### Parse and Use Components

```tl
@url string = "https://admin:secret@api.example.com:443/v1/data";
@parsed string = neturl.Parse(url);
// Extract components from parsed string (split by |)
```

## Differences from url Package

- **`url.Parse`**: Returns "scheme|host|path|query"
- **`neturl.Parse`**: Returns "scheme|user|host|port|path" (includes user info and port)

Use `neturl.Parse` when you need:
- User authentication information
- Port number extraction
- Network-specific URL parsing

## Notes

- User info format: "username:password" or "username"
- Port is empty string if not specified
- Hostname excludes port number
- Works with standard URL formats

## See Also

- [url Library](url.md) - Basic URL manipulation
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
