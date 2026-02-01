// JSON Unmarshal examples
// Demonstrates parsing JSON strings into Tlang values

@fmt = #dhimpu("std/fmt");
@json = #dhimpu("std/json");

#prarambham() {
    fmt.Printf("=== JSON Unmarshal Examples ===\n\n");
    
    // ============================================
    // Test 1: Unmarshal String
    // ============================================
    fmt.Printf("--- Test 1: Unmarshal String ---\n");
    @json1 string = "\"hello world\"";
    @str string = json.UnmarshalString(json1);
    fmt.Printf("JSON: %s\n", json1);
    fmt.Printf("Parsed: %s\n", str);
    
    @json2 string = "\"Hello\\nWorld\"";
    @str2 string = json.UnmarshalString(json2);
    fmt.Printf("JSON: %s\n", json2);
    fmt.Printf("Parsed: %s\n", str2);
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: Unmarshal Int
    // ============================================
    fmt.Printf("--- Test 2: Unmarshal Int ---\n");
    @json3 string = "42";
    @num int = json.UnmarshalInt(json3);
    fmt.Printf("JSON: %s\n", json3);
    fmt.Printf("Parsed: %d\n", num);
    
    @json4 string = "-100";
    @num2 int = json.UnmarshalInt(json4);
    fmt.Printf("JSON: %s\n", json4);
    fmt.Printf("Parsed: %d\n", num2);
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Unmarshal Float
    // ============================================
    fmt.Printf("--- Test 3: Unmarshal Float ---\n");
    @json5 string = "3.14159";
    @pi float = json.UnmarshalFloat(json5);
    fmt.Printf("JSON: %s\n", json5);
    fmt.Printf("Parsed: %.5f\n", pi);
    
    @json6 string = "-42.5";
    @neg float = json.UnmarshalFloat(json6);
    fmt.Printf("JSON: %s\n", json6);
    fmt.Printf("Parsed: %.1f\n", neg);
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 4: Unmarshal Bool
    // ============================================
    fmt.Printf("--- Test 4: Unmarshal Bool ---\n");
    @json7 string = "true";
    @flag1 int = json.UnmarshalBool(json7);
    fmt.Printf("JSON: %s\n", json7);
    fmt.Printf("Parsed: %d\n", flag1);
    
    @json8 string = "false";
    @flag2 int = json.UnmarshalBool(json8);
    fmt.Printf("JSON: %s\n", json8);
    fmt.Printf("Parsed: %d\n", flag2);
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 5: Unmarshal Array
    // ============================================
    fmt.Printf("--- Test 5: Unmarshal Array ---\n");
    @json9 string = "[1, 2, 3, 4, 5]";
    @arr []int = json.UnmarshalArray(json9, "int");
    okavela arr != sunyam {
        fmt.Printf("JSON: %s\n", json9);
        fmt.Printf("Array length: %d\n", len(arr));
        fmt.Printf("Elements: ");
        malli i := varasa arr {
            fmt.Printf("%d ", arr[i]);
        }
        fmt.Printf("\n");
    }
    
    @json10 string = "[\"hello\", \"world\", \"test\"]";
    @arr2 []string = json.UnmarshalArray(json10, "string");
    okavela arr2 != sunyam {
        fmt.Printf("JSON: %s\n", json10);
        fmt.Printf("Array length: %d\n", len(arr2));
        fmt.Printf("Elements: ");
        malli i := varasa arr2 {
            fmt.Printf("%s ", arr2[i]);
        }
        fmt.Printf("\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 6: Enhanced Unmarshal (generic)
    // ============================================
    fmt.Printf("--- Test 6: Enhanced Unmarshal ---\n");
    @json11 string = "\"test\"";
    @val1 string = json.Unmarshal(json11, "string");
    fmt.Printf("String: %s -> %s\n", json11, val1);
    
    @json12 string = "123";
    @val2 string = json.Unmarshal(json12, "int");
    fmt.Printf("Int: %s -> %s\n", json12, val2);
    
    @json13 string = "45.67";
    @val3 string = json.Unmarshal(json13, "float");
    fmt.Printf("Float: %s -> %s\n", json13, val3);
    
    @json14 string = "true";
    @val4 string = json.Unmarshal(json14, "bool");
    fmt.Printf("Bool: %s -> %s\n", json14, val4);
    
    fmt.Printf("\n=== JSON Unmarshal Examples Complete ===\n");
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
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl`
// Unexpected character: \
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:46:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    46 |     // ============================================
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:4:25: warning: missing terminating " character
//     4 | samooham adhi;
//       |                         ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:4:25: error: missing terminating " character
//     4 | samooham adhi;
//       |                         ^   
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:5:5: error: 'hello' undeclared (first use in this function)
//     5 | 
//       |     ^    
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:5:5: note: each undeclared identifier is reported only once for each function it appears in
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl:6:5: error: 'world' undeclared (first use in this function)
//     6 | @fmt = #dhimpu("std/fmt");
//       |     ^~~~~
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_unmarshal_example.tl` (exit code: 1)
//
