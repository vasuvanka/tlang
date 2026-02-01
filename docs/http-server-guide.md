# HTTP Server Guide

Build web servers and REST API servers with Tlang.

## Overview

Tlang provides a complete HTTP server implementation for building:
- **Web Servers** - Serve HTML pages and static content
- **REST API Servers** - Build JSON APIs for applications
- **Microservices** - Create lightweight backend services

## Basic Usage

### Starting a Server

```tl
#prarambham() {
    // Start server on port 8080
    http.ListenAndServe(":8080", sunyam);
}
```

### Address Format

- `":8080"` - Listen on all interfaces, port 8080
- `"localhost:8080"` - Listen on localhost, port 8080
- `"0.0.0.0:8080"` - Listen on all interfaces, port 8080

## Request Parsing

The server automatically parses incoming HTTP requests into:
- **Method**: GET, POST, PUT, DELETE, etc.
- **Path**: Request path (e.g., `/api/users`)
- **Headers**: All HTTP headers
- **Body**: Request body (for POST, PUT, etc.)

### Request Structure

Internally, requests are parsed into an `HTTPRequest` structure:
```c
typedef struct HTTPRequest {
    char method[16];      // GET, POST, etc.
    char path[512];       // Request path
    char* headers;        // Request headers
    char* body;           // Request body
} HTTPRequest;
```

## Handler Functions

### Handler Function Signature

Handler functions have the following signature:
```c
char* handler(const char* method, const char* path, const char* body);
```

- `method`: HTTP method (GET, POST, PUT, DELETE, etc.)
- `path`: Request path
- `body`: Request body (NULL if no body)
- Returns: Response body string (caller will free), or NULL for 404

### Default Handler

If no handler is provided (NULL), the server uses a default handler that returns:
```
Method: <method>
Path: <path>
```

### Custom Handler Example

```tl
// Note: In Tlang, function pointers are not yet fully supported
// This shows the concept - handlers would be C functions
// For now, use the default handler or implement routing logic in your code
```

## Response Generation

### Basic Response

```tl
// http.Response creates a complete HTTP response
@response string = http.Response(200, "text/plain", "Hello, World!");
```

### JSON Response

```tl
@json string = "{\"message\": \"Hello\"}";
@response string = http.JSONResponse(200, json);
```

### HTML Response

```tl
@html string = "<html><body><h1>Hello</h1></body></html>";
@response string = http.HTMLResponse(200, html);
```

### Status Codes

Common status codes:
- `200` - OK
- `400` - Bad Request
- `404` - Not Found
- `500` - Internal Server Error

## Routing

### Basic Routing

The server includes a routing helper function:

```c
char* http_RouteHandler(
    const char** routes,      // Array of route patterns
    HTTPHandler* handlers,    // Array of handler functions
    int route_count,          // Number of routes
    const char* method,       // HTTP method
    const char* path,         // Request path
    const char* body          // Request body
);
```

### Route Matching

Routes use simple prefix matching:
- Route `/api` matches `/api`, `/api/users`, `/api/data`, etc.
- Route `/` matches all paths
- First matching route is used

### Example Routing

```c
// Define routes
const char* routes[] = {"/api", "/hello", "/"};
HTTPHandler handlers[] = {api_handler, hello_handler, default_handler};

// In handler, use router
char* response = http_RouteHandler(routes, handlers, 3, method, path, body);
```

## Query Parameters

### Extract Query Parameters

```c
char* value = http_get_query_param(path, "name");
// For URL: /hello?name=Alice
// Returns: "Alice"
```

## Request Processing Flow

1. **Accept Connection**: Server accepts incoming TCP connection
2. **Read Request**: Reads HTTP request from socket
3. **Parse Request**: Extracts method, path, headers, body
4. **Call Handler**: Calls handler function with parsed request
5. **Generate Response**: Creates HTTP response with status code and body
6. **Send Response**: Sends response to client
7. **Close Connection**: Closes TCP connection

## Example: Web Server

```tl
@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");

#handler(method string, path string, body string) string {
    // Home page
    okavela path == "/" {
        @html string = "<html><head><title>Tlang Web Server</title></head>";
        @html string = html + "<body><h1>Welcome to Tlang!</h1>";
        @html string = html + "<p><a href='/about'>About</a></p></body></html>";
        mallinchu http.HTMLResponse(200, html);
    }
    
    // About page
    okavela path == "/about" {
        mallinchu http.HTMLResponse(200, "<html><body><h1>About</h1><p>Built with Tlang</p></body></html>");
    }
    
    // 404 Not Found
    mallinchu http.HTMLResponse(404, "<html><body><h1>404 - Page Not Found</h1></body></html>");
}

#prarambham() {
    fmt.Printf("Web server running at http://localhost:8080\n");
    http.ListenAndServe(":8080", handler);
}
```

## Example: REST API Server

```tl
@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");
@json = #dhimpu("std/json");

#handler(method string, path string, body string) string {
    // GET /api/users - List users
    okavela method == "GET" {
        okavela path == "/api/users" {
            @users string = "[{\"id\": 1, \"name\": \"John\"}, {\"id\": 2, \"name\": \"Jane\"}]";
            mallinchu http.JSONResponse(200, users);
        }
        
        okavela path == "/api/health" {
            mallinchu http.JSONResponse(200, "{\"status\": \"ok\"}");
        }
    }
    
    // POST /api/users - Create user
    okavela method == "POST" {
        okavela path == "/api/users" {
            // Process body (JSON data)
            fmt.Printf("Received: %s\n", body);
            mallinchu http.JSONResponse(201, "{\"message\": \"User created\"}");
        }
    }
    
    // 404 for unknown routes
    mallinchu http.JSONResponse(404, "{\"error\": \"Not found\"}");
}

#prarambham() {
    fmt.Printf("API server running at http://localhost:3000\n");
    http.ListenAndServe(":3000", handler);
}
```

## Example: Simple Server (Default Handler)

```tl
@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");

#prarambham() {
    fmt.Printf("Starting server on :8080\n");
    
    // Start server with default handler
    // The server will parse requests and show method/path
    http.ListenAndServe(":8080", sunyam);
}
```

## Advanced Features

### Custom Headers in Response

To add custom headers, you can modify the response generation:

```c
// In your handler, create custom response
char* custom_response = http_make_response(200, "application/json", json_body);
// Then modify to add custom headers before sending
```

### Error Handling

The server handles errors gracefully:
- **Bad Request (400)**: Invalid HTTP request format
- **Not Found (404)**: Handler returns NULL
- **Internal Server Error (500)**: Handler error (can be added)

### Request Headers

Request headers are available in the parsed request structure. You can extract specific headers:

```c
// In handler, parse headers from req->headers
// Headers are in format: "Header1: Value1\r\nHeader2: Value2\r\n"
```

## Limitations

1. **Concurrent Connections**: Server handles one request at a time. Multiple concurrent connections are queued.

2. **Advanced Routing**: Current routing uses simple prefix matching. More advanced routing (regex, parameters) can be added.

3. **Handler Functions**: In Tlang, function pointers are not yet fully supported. Handlers must be C functions for now.

4. **Request Size**: Request buffer is limited to 8KB. Larger requests may be truncated.

5. **Response Size**: Response buffer is limited to 4KB. Larger responses may need chunking.

## Future Enhancements

- [ ] Concurrent connection handling (threading or async)
- [ ] Advanced routing (regex patterns, path parameters)
- [ ] Middleware support
- [ ] Static file serving
- [ ] WebSocket support
- [ ] Request/response streaming
- [ ] Cookie handling
- [ ] Session management

## See Also

- [HTTP/Networking Status](http-networking-status.md)
- [HTTP Advanced Features](http-advanced-features.md)
- [Network Library](net.md)
- [HTTP Server Examples](../examples/http_server_advanced_example.tl)
