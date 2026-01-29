// HTTPS Client Example
// Demonstrates making secure HTTPS requests with TLS/SSL support

dhimpu "fmt" as fmt;
dhimpu "http" as http;
dhimpu "strings" as strings;

#prarambham() {
    fmt.Printf("=== HTTPS Client Example ===\n\n");
    
    // Make HTTPS GET request
    fmt.Printf("Making HTTPS GET request to https://www.example.com...\n");
    @response string = http.Get("https://www.example.com");
    
    okavela response != sunyam {
        fmt.Printf("Response received (first 500 chars):\n");
        @preview string = strings.Substring(response, 0, 500);
        fmt.Printf("%s\n", preview);
        fmt.Printf("\n... (truncated)\n");
    } lekapothe {
        fmt.Printf("Error: Failed to get response\n");
        fmt.Printf("Note: HTTPS requires OpenSSL. Compile with -DUSE_OPENSSL and link against OpenSSL.\n");
    }
    
    fmt.Printf("\n=== HTTPS Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
// Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// Compiling C to binary using gcc...
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl`
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl:47:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    47 | //
//       |     ^      
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl:7:31: error: implicit declaration of function 'strings_Substring' [-Wimplicit-function-declaration]
//     7 | dhimpu "http" as http;
//       |                               ^                
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl:7:31: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\https_client_example.tl` (exit code: 1)
//
