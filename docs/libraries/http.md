# http - HTTP Library

The `http` library provides full HTTP client and server functionality with support for all HTTP methods.

## HTTP Client Methods

### Standard Methods

**`http.Get(url)`** - HTTP GET request
- `url`: URL to request
- Returns: HTTP response body (caller must free), or NULL on error
- Automatically handles redirects (up to 5 by default)

**`http.GetWithRedirects(url, max_redirects)`** - HTTP GET with custom redirect limit
- `url`: URL to request
- `max_redirects`: Maximum number of redirects to follow
- Returns: HTTP response body (caller must free), or NULL on error

**`http.Post(url, data)`** - HTTP POST request
- `url`: URL to post to
- `data`: Data to post
- Returns: HTTP response body (caller must free), or NULL on error

**`http.PostWithHeaders(url, data, headers)`** - HTTP POST with custom headers
- `url`: URL to post to
- `data`: Data to post
- `headers`: Custom headers string (format: "Header1: Value1\r\nHeader2: Value2") or NULL
- Returns: HTTP response body (caller must free), or NULL on error

**`http.Put(url, data)`** - HTTP PUT request
- `url`: URL to update
- `data`: Data to send
- Returns: HTTP response body (caller must free), or NULL on error

**`http.Delete(url)`** - HTTP DELETE request
- `url`: URL to delete
- Returns: HTTP response body (caller must free), or NULL on error

### Additional HTTP Methods ⭐ **NEW**

**`http.Head(url)`** - HTTP HEAD request
- `url`: URL to request
- Returns: HTTP response headers only (no body), or NULL on error
- Used to retrieve headers without downloading the body

**`http.Options(url)`** - HTTP OPTIONS request
- `url`: URL to query
- Returns: HTTP response body (caller must free), or NULL on error
- Used to describe communication options for the target resource

**`http.Patch(url, data)`** - HTTP PATCH request
- `url`: URL to partially update
- `data`: Data to send
- Returns: HTTP response body (caller must free), or NULL on error
- Used for partial modifications to a resource

**`http.PatchWithHeaders(url, data, headers)`** - HTTP PATCH with custom headers
- `url`: URL to partially update
- `data`: Data to send
- `headers`: Custom headers string or NULL
- Returns: HTTP response body (caller must free), or NULL on error

**`http.Trace(url)`** - HTTP TRACE request
- `url`: URL to trace
- Returns: HTTP response body (caller must free), or NULL on error
- Used for diagnostic purposes, echoes the request back

**`http.Connect(url)`** - HTTP CONNECT request
- `url`: URL to connect to
- Returns: HTTP response body (caller must free), or NULL on error
- Used to establish a tunnel to the server (typically for HTTPS proxies)

### Generic Request Method

**`http.Request(url, method, headers, body)`** - Generic HTTP request
- `url`: URL to request
- `method`: HTTP method string (GET, POST, PUT, DELETE, HEAD, OPTIONS, PATCH, TRACE, CONNECT, or any custom method)
- `headers`: Custom headers string or NULL
- `body`: Request body or NULL
- Returns: HTTP response body (caller must free), or NULL on error
- Use this for custom HTTP methods or full control over the request

## HTTP Server

**`http.ListenAndServe(port, handler_func)`** - Start HTTP server
- `port`: Port number to listen on
- `handler_func`: Handler function that receives (method, path, body) and returns response body
- Blocks and serves requests indefinitely

**Example:**
```tl
#handler(method string, path string, body string) string {
    okavela method == "GET" {
        mallinchu "Hello from GET request!";
    }
    mallinchu "Method: " + method + ", Path: " + path;
}

#prarambham() {
    http.ListenAndServe("8080", handler);
}
```

## Features

✅ **All HTTP Methods Supported:**
- GET, POST, PUT, DELETE
- HEAD, OPTIONS, PATCH, TRACE, CONNECT
- Custom methods via `http.Request()`

✅ **Advanced Features:**
- Automatic redirect handling
- Custom headers support
- Request/response parsing
- Cross-platform socket support (POSIX/Windows)
- DNS resolution
- **HTTPS/TLS support** ⭐ (with OpenSSL)

✅ **HTTPS/TLS Support:** ⭐ **NEW**
- Full HTTPS support with OpenSSL integration
- Automatic TLS handshake and certificate validation
- Secure connections for all HTTP methods
- Compile with `-DUSE_OPENSSL` and link against OpenSSL to enable

## Examples

### Example 1: Basic GET Request (HTTP)

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    @response string = http.Get("http://api.example.com/data");
    okavela response != sunyam {
        fmt.Printf("Response: %s\n", response);
    }
}
```

### Example 1b: HTTPS GET Request ⭐ **NEW**

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    // HTTPS automatically uses TLS when compiled with OpenSSL
    @response string = http.Get("https://api.example.com/data");
    okavela response != sunyam {
        fmt.Printf("Response: %s\n", response);
    }
}
```

**Note:** To enable HTTPS, compile with:
```bash
gcc -DUSE_OPENSSL -o program program.c -lssl -lcrypto
```

### Example 2: POST with JSON

```tl
@json string = "{\"name\": \"John\", \"age\": 30}";
@headers string = "Content-Type: application/json\r\n";
@response string = http.PostWithHeaders("https://api.example.com/users", json, headers);
```

### Example 3: All HTTP Methods

```tl
// GET
@getResponse string = http.Get("https://api.example.com/resource");

// POST
@postResponse string = http.Post("https://api.example.com/resource", "data");

// PUT
@putResponse string = http.Put("https://api.example.com/resource/1", "updated data");

// DELETE
@deleteResponse string = http.Delete("https://api.example.com/resource/1");

// HEAD (headers only)
@headResponse string = http.Head("https://api.example.com/resource");

// OPTIONS
@optionsResponse string = http.Options("https://api.example.com/resource");

// PATCH
@patchResponse string = http.Patch("https://api.example.com/resource/1", "partial data");

// TRACE
@traceResponse string = http.Trace("https://api.example.com/resource");

// CONNECT (for proxies)
@connectResponse string = http.Connect("https://api.example.com/resource");
```

### Example 4: Custom Method

```tl
// Use generic Request for custom methods
@response string = http.Request("https://api.example.com/resource", "CUSTOM_METHOD", NULL, NULL);
```

## HTTPS/TLS Support ⭐

HTTPS is fully supported when compiled with OpenSSL. The library automatically detects HTTPS URLs (port 443 or `https://` scheme) and uses TLS connections.

### Compilation

To enable HTTPS support, compile with OpenSSL:

**Linux/macOS:**
```bash
gcc -DUSE_OPENSSL -o program program.c -lssl -lcrypto
```

**Windows (MinGW):**
```bash
gcc -DUSE_OPENSSL -o program.exe program.c -lssl -lcrypto
```

**Windows (MSVC):**
```bash
cl /DUSE_OPENSSL program.c /link libssl.lib libcrypto.lib
```

### Features

- ✅ Automatic TLS handshake
- ✅ Certificate validation (enabled by default)
- ✅ Server Name Indication (SNI) support
- ✅ Works with all HTTP methods (GET, POST, PUT, DELETE, etc.)
- ✅ Secure redirect handling

### Example

```tl
@fmt = #dhimpu("std/fmt");

#prarambham() {
    // HTTPS request - automatically uses TLS
    @response string = http.Get("https://www.example.com");
    okavela response != sunyam {
        fmt.Printf("Secure response received!\n");
    }
}
```

## See Also

- `docs/http-server-guide.md` - HTTP server guide
- `docs/http-advanced-features.md` - Advanced HTTP features
- `docs/http-networking-status.md` - Implementation status
