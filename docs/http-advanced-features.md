# HTTP Advanced Features

## Overview

The HTTP library now supports advanced features including PUT/DELETE methods, custom headers, and automatic redirect handling.

## New Functions

### HTTP Methods

All standard HTTP methods are now supported:

1. **`http.Get(url)`** - HTTP GET request (with automatic redirects)
2. **`http.Post(url, data)`** - HTTP POST request
3. **`http.Put(url, data)`** - HTTP PUT request
4. **`http.Delete(url)`** - HTTP DELETE request
5. **`http.Head(url)`** - HTTP HEAD request (headers only) ⭐ **NEW**
6. **`http.Options(url)`** - HTTP OPTIONS request ⭐ **NEW**
7. **`http.Patch(url, data)`** - HTTP PATCH request ⭐ **NEW**
8. **`http.Trace(url)`** - HTTP TRACE request ⭐ **NEW**
9. **`http.Connect(url)`** - HTTP CONNECT request ⭐ **NEW**

### Custom Headers

3. **`http.PostWithHeaders(url, data, headers)`** - POST with custom headers
   - `url`: Target URL
   - `data`: Request body data
   - `headers`: Custom headers string (format: `"Header1: Value1\r\nHeader2: Value2"`)
   - Returns: HTTP response body (caller must free), or NULL on error

4. **`http.Request(url, method, headers, body)`** - Generic HTTP request
   - `url`: Target URL
   - `method`: HTTP method ("GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH", "TRACE", "CONNECT", or any custom method)
   - `headers`: Custom headers string or NULL
   - `body`: Request body or NULL
   - Returns: HTTP response body (caller must free), or NULL on error

5. **`http.PatchWithHeaders(url, data, headers)`** - PATCH with custom headers ⭐ **NEW**
   - `url`: Target URL
   - `data`: Request body data
   - `headers`: Custom headers string or NULL
   - Returns: HTTP response body (caller must free), or NULL on error

### Redirect Handling

6. **`http.GetWithRedirects(url, max_redirects)`** - GET with redirect handling
   - `url`: Target URL
   - `max_redirects`: Maximum number of redirects to follow (default: 5)
   - Returns: HTTP response body (caller must free), or NULL on error
   - Automatically follows redirects (301, 302, 307, 308)
   - Supports both absolute and relative redirect URLs

7. **`http.Get(url)`** - Enhanced GET with automatic redirects
   - Now automatically handles redirects (calls `http.GetWithRedirects` with max_redirects=5)
   - Same behavior as before, but with redirect support

## Usage Examples

### All HTTP Methods

```tl
// GET - Retrieve resource
@getResponse string = http.Get("https://api.example.com/resource");

// POST - Create resource
@postResponse string = http.Post("https://api.example.com/resource", "data");

// PUT - Update resource
@putResponse string = http.Put("https://api.example.com/resource/1", "updated data");

// DELETE - Delete resource
@deleteResponse string = http.Delete("https://api.example.com/resource/1");

// HEAD - Get headers only (no body)
@headResponse string = http.Head("https://api.example.com/resource");

// OPTIONS - Get allowed methods
@optionsResponse string = http.Options("https://api.example.com/resource");

// PATCH - Partial update
@patchResponse string = http.Patch("https://api.example.com/resource/1", "partial data");

// TRACE - Echo request (diagnostic)
@traceResponse string = http.Trace("https://api.example.com/resource");

// CONNECT - Establish tunnel (for proxies)
@connectResponse string = http.Connect("https://api.example.com/resource");
```

### PUT Request

```tl
@url string = "http://api.example.com/resource/123";
@data string = "{\"name\": \"Updated Name\"}";
@response string = http.Put(url, data);
okavela response != sunyam {
    fmt.Printf("Response: %s\n", response);
}
```

### DELETE Request

```tl
@url string = "http://api.example.com/resource/123";
@response string = http.Delete(url);
okavela response != sunyam {
    fmt.Printf("Response: %s\n", response);
}
```

### Custom Headers

```tl
@url string = "http://api.example.com/data";
@data string = "{\"key\": \"value\"}";
@headers string = "Content-Type: application/json\r\nAuthorization: Bearer token123\r\n";
@response string = http.PostWithHeaders(url, data, headers);
```

### Generic Request

```tl
@url string = "http://api.example.com/custom";
@method string = "PATCH";
@headers string = "Content-Type: application/json\r\n";
@body string = "{\"patch\": \"data\"}";
@response string = http.Request(url, method, headers, body);
```

### Redirect Handling

```tl
// Automatically follows up to 5 redirects
@url string = "http://example.com/redirect";
@response string = http.Get(url);

// Or specify max redirects
@response2 string = http.GetWithRedirects(url, 10);
```

## Implementation Details

### Redirect Handling

- Automatically detects redirect status codes: 301, 302, 307, 308
- Extracts `Location` header from redirect responses
- Handles both absolute URLs (`http://example.com/path`) and relative URLs (`/path`)
- For relative URLs, constructs full URL using original request's scheme and host
- Limits redirect following to prevent infinite loops

### Custom Headers

- Headers must be in format: `"HeaderName: Value\r\n"`
- Multiple headers can be provided, each ending with `\r\n`
- Content-Type is automatically added for POST requests if not provided
- Headers are appended to the request after the Host header

### Status Code Extraction

- Helper function `http_get_status_code()` extracts HTTP status code from response
- Used internally for redirect detection
- Can be used to check response status

## Limitations

1. **HTTPS/TLS**: Not yet implemented. HTTPS URLs (port 443) will attempt connection but will fail without TLS support. Requires OpenSSL integration.

2. **Redirect Methods**: Only GET requests automatically follow redirects. PUT/DELETE/POST redirects are not automatically followed (by HTTP specification, they should not be).

3. **Header Validation**: Headers are not validated for correctness. Invalid headers may cause server errors.

4. **Response Size**: Response buffer is limited to 16KB. Larger responses may be truncated.

## Future Enhancements

- [ ] HTTPS/TLS support (OpenSSL integration)
- [ ] Response header parsing
- [ ] Cookie handling
- [ ] Request timeout support
- [ ] Connection pooling
- [ ] HTTP/2 support

## See Also

- [HTTP/Networking Status](http-networking-status.md)
- [Network Library](net.md)
- [HTTP Examples](../examples/http_advanced_example.tl)
