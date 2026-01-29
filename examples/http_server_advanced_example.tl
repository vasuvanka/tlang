// HTTP Server Advanced Example
// Demonstrates HTTP server with request parsing and routing

dhimpu "fmt" as fmt;
dhimpu "http" as http;
dhimpu "strings" as strings;

// Handler function for processing requests
#handler(method string, path string, body string) string {
    fmt.Printf("Request: %s %s\n", method, path);
    
    // API endpoints
    okavela strings.HasPrefix(path, "/api") {
        okavela path == "/api/status" {
            mallinchu http.JSONResponse(200, "{\"status\": \"running\", \"version\": \"1.0\"}");
        }
        okavela path == "/api/echo" {
            okavela method == "POST" {
                @response string = fmt.Sprintf("{\"echo\": \"%s\"}", body);
                mallinchu http.JSONResponse(200, response);
            }
            mallinchu http.JSONResponse(405, "{\"error\": \"Method not allowed\"}");
        }
        mallinchu http.JSONResponse(404, "{\"error\": \"API endpoint not found\"}");
    }
    
    // Static pages
    okavela path == "/" {
        @html string = "<html><head><title>Tlang Server</title></head><body>";
        @html string = html + "<h1>Welcome to Tlang HTTP Server</h1>";
        @html string = html + "<ul>";
        @html string = html + "<li><a href='/api/status'>API Status</a></li>";
        @html string = html + "<li><a href='/hello'>Hello Page</a></li>";
        @html string = html + "</ul></body></html>";
        mallinchu http.HTMLResponse(200, html);
    }
    
    okavela path == "/hello" {
        mallinchu http.HTMLResponse(200, "<html><body><h1>Hello, World!</h1></body></html>");
    }
    
    // 404 for unknown routes
    mallinchu http.HTMLResponse(404, "<html><body><h1>404 - Not Found</h1></body></html>");
}

#prarambham() {
    fmt.Printf("=== HTTP Server Advanced Example ===\n");
    fmt.Printf("Starting server on :8080\n");
    fmt.Printf("Try these URLs:\n");
    fmt.Printf("  http://localhost:8080/\n");
    fmt.Printf("  http://localhost:8080/api/status\n");
    fmt.Printf("  http://localhost:8080/hello\n");
    fmt.Printf("Press Ctrl+C to stop\n\n");
    
    http.ListenAndServe(":8080", handler);
}

//

//

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_advanced_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_advanced_example.tl:17:56: Expected RightParen, but found Identifier("status")
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   17 |             mallinchu http.JSONResponse(200, "{\"status\": \"running\", \"version\": \"1.0\"}");
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_server_advanced_example.tl` (exit code: 1)
//
