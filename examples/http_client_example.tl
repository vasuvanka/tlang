// HTTP Client Example
// Demonstrates HTTP GET and POST requests

@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");

#prarambham() {
    fmt.Printf("=== HTTP Client Examples ===\n\n");
    
    // ============================================
    // Test 1: HTTP GET Request
    // ============================================
    fmt.Printf("--- Test 1: HTTP GET Request ---\n");
    @url string = "http://httpbin.org/get";
    fmt.Printf("Requesting: %s\n", url);
    
    @response string = http.Get(url);
    okavela response != sunyam {
        fmt.Printf("Response:\n%s\n", response);
    } lekapothe {
        fmt.Printf("Error: Failed to get response\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: HTTP POST Request
    // ============================================
    fmt.Printf("--- Test 2: HTTP POST Request ---\n");
    @postUrl string = "http://httpbin.org/post";
    @postData string = "name=Alice&age=30";
    fmt.Printf("Posting to: %s\n", postUrl);
    fmt.Printf("Data: %s\n", postData);
    
    @postResponse string = http.Post(postUrl, postData);
    okavela postResponse != sunyam {
        fmt.Printf("Response:\n%s\n", postResponse);
    } lekapothe {
        fmt.Printf("Error: Failed to post\n");
    }
    
    fmt.Printf("\n=== HTTP Client Examples Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// === HTTP Client Examples ===
//
// --- Test 1: HTTP GET Request ---
// Requesting: http://httpbin.org/get
// Response:
// {
//   "args": {}, 
//   "headers": {
//     "Host": "httpbin.org", 
//     "X-Amzn-Trace-Id": "Root=1-6978eceb-64d3798f584fdf4d70b3dd11"
//   }, 
//   "origin": "103.160.27.147", 
//   "url": "http://httpbin.org/get"
// }
//
//
// --- Test 2: HTTP POST Request ---
// Posting to: http://httpbin.org/post
// Data: name=Alice&age=30
// Response:
// {
//   "args": {}, 
//   "data": "", 
//   "files": {}, 
//   "form": {
//     "age": "30", 
//     "name": "Alice"
//   }, 
//   "headers": {
//     "Content-Length": "17", 
//     "Content-Type": "application/x-www-form-urlencoded", 
//     "Host": "httpbin.org", 
//     "X-Amzn-Trace-Id": "Root=1-6978eceb-331040c3117271a516a0219d"
//   }, 
//   "json": null, 
//   "origin": "103.160.27.147", 
//   "url": "http://httpbin.org/post"
// }
//
//
// === HTTP Client Examples Complete ===
//
