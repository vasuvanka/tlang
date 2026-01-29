// HTTP Server with Routing Example
// Demonstrates HTTP server with path-based routing

dhimpu "fmt" as fmt;
dhimpu "http" as http;
dhimpu "json" as json;

// Handler function for routing requests
#handler(method string, path string, body string) string {
    // API routes
    okavela path == "/api/users" {
        okavela method == "GET" {
            mallinchu http.JSONResponse(200, "[{\"id\": 1, \"name\": \"John\"}, {\"id\": 2, \"name\": \"Jane\"}]");
        }
        okavela method == "POST" {
            fmt.Printf("Creating user: %s\n", body);
            mallinchu http.JSONResponse(201, "{\"message\": \"User created\"}");
        }
    }
    
    // Hello endpoint with query parameter support
    okavela path == "/hello" {
        mallinchu http.JSONResponse(200, "{\"message\": \"Hello, World!\"}");
    }
    
    // Home page
    okavela path == "/" {
        @html string = "<html><body><h1>Welcome to Tlang HTTP Server</h1>";
        @html string = html + "<p>Try: <a href='/api/users'>/api/users</a></p></body></html>";
        mallinchu http.HTMLResponse(200, html);
    }
    
    // 404 for unknown routes
    mallinchu http.JSONResponse(404, "{\"error\": \"Not found\"}");
}

#prarambham() {
    fmt.Printf("=== HTTP Server with Routing Example ===\n");
    fmt.Printf("Starting server on :8080\n");
    fmt.Printf("Try these URLs:\n");
    fmt.Printf("  http://localhost:8080/\n");
    fmt.Printf("  http://localhost:8080/api/users\n");
    fmt.Printf("  http://localhost:8080/hello\n");
    fmt.Printf("Press Ctrl+C to stop\n\n");
    
    // Start HTTP server with custom handler
    http.ListenAndServe(":8080", handler);
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_routing_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_routing_example.tl:15:53: Expected RightParen, but found Identifier("id")
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   15 |             mallinchu http.JSONResponse(200, "[{\"id\": 1, \"name\": \"John\"}, {\"id\": 2, \"name\": \"Jane\"}]");
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_routing_example.tl` (exit code: 1)
//
