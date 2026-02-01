// HTTP Advanced Features Example
// Demonstrates PUT, DELETE, custom headers, and redirects

@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");

#prarambham() {
    fmt.Printf("=== HTTP Advanced Features Examples ===\n\n");
    
    // ============================================
    // Test 1: HTTP PUT Request
    // ============================================
    fmt.Printf("--- Test 1: HTTP PUT Request ---\n");
    @putUrl string = "http://httpbin.org/put";
    @putData string = "{\"name\": \"Alice\", \"age\": 30}";
    fmt.Printf("PUT to: %s\n", putUrl);
    fmt.Printf("Data: %s\n", putData);
    
    @putResponse string = http.Put(putUrl, putData);
    okavela putResponse != sunyam {
        fmt.Printf("Response (first 200 chars):\n%.200s\n", putResponse);
    } lekapothe {
        fmt.Printf("Error: Failed to PUT\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: HTTP DELETE Request
    // ============================================
    fmt.Printf("--- Test 2: HTTP DELETE Request ---\n");
    @deleteUrl string = "http://httpbin.org/delete";
    fmt.Printf("DELETE: %s\n", deleteUrl);
    
    @deleteResponse string = http.Delete(deleteUrl);
    okavela deleteResponse != sunyam {
        fmt.Printf("Response (first 200 chars):\n%.200s\n", deleteResponse);
    } lekapothe {
        fmt.Printf("Error: Failed to DELETE\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Custom Headers
    // ============================================
    fmt.Printf("--- Test 3: Custom Headers ---\n");
    @postUrl string = "http://httpbin.org/post";
    @postData string = "{\"test\": \"data\"}";
    @customHeaders string = "Content-Type: application/json\r\nX-Custom-Header: MyValue\r\n";
    fmt.Printf("POST with custom headers to: %s\n", postUrl);
    
    @postResponse string = http.PostWithHeaders(postUrl, postData, customHeaders);
    okavela postResponse != sunyam {
        fmt.Printf("Response (first 300 chars):\n%.300s\n", postResponse);
    } lekapothe {
        fmt.Printf("Error: Failed to POST with headers\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 4: Redirect Handling
    // ============================================
    fmt.Printf("--- Test 4: Redirect Handling ---\n");
    @redirectUrl string = "http://httpbin.org/redirect/2";
    fmt.Printf("GET with redirects: %s\n", redirectUrl);
    fmt.Printf("(This URL redirects 2 times)\n");
    
    @redirectResponse string = http.Get(redirectUrl);
    okavela redirectResponse != sunyam {
        fmt.Printf("Response (first 200 chars):\n%.200s\n", redirectResponse);
    } lekapothe {
        fmt.Printf("Error: Failed to handle redirects\n");
    }
    
    fmt.Printf("\n=== HTTP Advanced Features Examples Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
// Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// Compiling C to binary using gcc...
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.29s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl`
// Unexpected character: \
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl:46:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    46 |     // ============================================
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl:5:27: warning: missing terminating " character
//     5 | 
//       |                           ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl:5:27: error: missing terminating " character
//     5 | 
//       |                           ^    
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl:6:5: error: 'name' undeclared (first use in this function); did you mean 'tzname'?
//     6 | @fmt = #dhimpu("std/fmt");
//       |     ^~~~
//       |     tzname
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl:6:5: note: each undeclared identifier is reported only once for each function it appears in
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\http_advanced_example.tl` (exit code: 1)
//
