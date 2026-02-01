// encoding/csv library example
// Demonstrates CSV file reading and writing

@fmt = #dhimpu("std/fmt");
@csv = #dhimpu("std/csv");

#prarambham() {
    fmt.Printf("=== encoding/csv Library Examples ===\n\n");
    
    // Create sample CSV file
    fmt.Printf("--- Creating Sample CSV File ---\n");
    @csvContent string = "name|age|city\nJohn|30|New York\nJane|25|London\nBob|35|Paris";
    @written int = csv.Write("sample.csv", csvContent);
    fmt.Printf("Wrote %d bytes to sample.csv\n", written);
    
    // Read CSV file
    fmt.Printf("\n--- Reading CSV File ---\n");
    @csvData string = csv.Read("sample.csv");
    fmt.Printf("CSV Data:\n%s\n", csvData);
    
    // Parse single line
    fmt.Printf("\n--- Parsing CSV Line ---\n");
    @line string = "Alice,28,Tokyo";
    @parsed string = csv.ParseLine(line);
    fmt.Printf("Line: %s\n", line);
    fmt.Printf("Parsed (| separated): %s\n", parsed);
    
    // Parse line with quotes
    fmt.Printf("\n--- Parsing CSV Line with Quotes ---\n");
    @line2 string = "\"John Doe\",30,\"New York, NY\"";
    @parsed2 string = csv.ParseLine(line2);
    fmt.Printf("Line: %s\n", line2);
    fmt.Printf("Parsed: %s\n", parsed2);
    
    // Write and read round-trip
    fmt.Printf("\n--- Round-Trip Test ---\n");
    @testData string = "field1|field2|field3\nvalue1|value2|value3";
    csv.Write("test.csv", testData);
    @readBack string = csv.Read("test.csv");
    @match int = (testData == readBack);
    fmt.Printf("Original: %s\n", testData);
    fmt.Printf("Read back: %s\n", readBack);
    fmt.Printf("Match: %d (expected: 1)\n", match);
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.32s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl`
// Unexpected character: \
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:46:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    46 | }
//       |     ^      
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:16:25: warning: missing terminating " character
//    16 |     fmt.Printf("Wrote %d bytes to sample.csv\n", written);
//       |                         ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:16:25: error: missing terminating " character
//    16 |     fmt.Printf("Wrote %d bytes to sample.csv\n", written);
//       |                         ^~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:17:5: error: 'John' undeclared (first use in this function)
//    17 | 
//       |     ^   
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:17:5: note: each undeclared identifier is reported only once for each function it appears in
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl:18:5: error: 'Doe' undeclared (first use in this function)
//    18 |     // Read CSV file
//       |     ^~~
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\csv_example.tl` (exit code: 1)
//
