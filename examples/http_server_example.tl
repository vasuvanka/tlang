// HTTP Server Example
// Demonstrates basic HTTP server

@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");

#prarambham() {
    fmt.Printf("=== HTTP Server Example ===\n");
    fmt.Printf("Starting server on :8080\n");
    fmt.Printf("Visit http://localhost:8080 in your browser\n");
    fmt.Printf("Press Ctrl+C to stop\n\n");

    // Start HTTP server
    // Note: This will block and handle requests
    // http.ListenAndServe(":8080", sunyam);
}

//

//

//

// === OUTPUT ===
// === HTTP Server Example ===
// Starting server on :8080
// Visit http://localhost:8080 in your browser
// Press Ctrl+C to stop
//
//
