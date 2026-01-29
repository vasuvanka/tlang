// JSON Map Unmarshal Example
// Demonstrates unmarshaling JSON objects into maps

dhimpu "fmt" as fmt;
dhimpu "json" as json;

#prarambham() {
    fmt.Printf("=== JSON Map Unmarshal Examples ===\n\n");
    
    // ============================================
    // Test 1: String-Int Map
    // ============================================
    fmt.Printf("--- Test 1: String-Int Map ---\n");
    @json1 string = "{\"Alice\": 95, \"Bob\": 87, \"Charlie\": 92}";
    fmt.Printf("JSON: %s\n", json1);
    
    // key_type: 0=string, value_type: 0=int
    @scores jatha[string]int = json.UnmarshalMap(json1, 0, 0);
    okavela scores != sunyam {
        fmt.Printf("Unmarshaled Map:\n");
        fmt.Printf("  Length: %d\n", len(scores));
        
        // Access values
        @aliceKey string = "Alice";
        @aliceScore int = *(int*)map_get(scores, &aliceKey);
        fmt.Printf("  Alice: %d\n", aliceScore);
        
        @bobKey string = "Bob";
        @bobScore int = *(int*)map_get(scores, &bobKey);
        fmt.Printf("  Bob: %d\n", bobScore);
        
        // Iterate over map
        fmt.Printf("  All entries:\n");
        malli key, value := varasa scores {
            fmt.Printf("    %s: %d\n", key, value);
        }
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: String-String Map
    // ============================================
    fmt.Printf("--- Test 2: String-String Map ---\n");
    @json2 string = "{\"name\": \"Alice\", \"email\": \"alice@example.com\", \"city\": \"Springfield\"}";
    fmt.Printf("JSON: %s\n", json2);
    
    // key_type: 0=string, value_type: 2=string
    @data jatha[string]string = json.UnmarshalMap(json2, 0, 2);
    okavela data != sunyam {
        fmt.Printf("Unmarshaled Map:\n");
        fmt.Printf("  Length: %d\n", len(data));
        
        // Iterate over map
        malli key, value := varasa data {
            fmt.Printf("    %s: %s\n", key, value);
        }
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: String-Float Map
    // ============================================
    fmt.Printf("--- Test 3: String-Float Map ---\n");
    @json3 string = "{\"pi\": 3.14159, \"e\": 2.71828, \"sqrt2\": 1.41421}";
    fmt.Printf("JSON: %s\n", json3);
    
    // key_type: 0=string, value_type: 1=float
    @constants jatha[string]float = json.UnmarshalMap(json3, 0, 1);
    okavela constants != sunyam {
        fmt.Printf("Unmarshaled Map:\n");
        fmt.Printf("  Length: %d\n", len(constants));
        
        // Iterate over map
        malli key, value := varasa constants {
            fmt.Printf("    %s: %.5f\n", key, value);
        }
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 4: String-Bool Map
    // ============================================
    fmt.Printf("--- Test 4: String-Bool Map ---\n");
    @json4 string = "{\"active\": true, \"verified\": false, \"premium\": true}";
    fmt.Printf("JSON: %s\n", json4);
    
    // key_type: 0=string, value_type: 3=bool
    @flags jatha[string]int = json.UnmarshalMap(json4, 0, 3);
    okavela flags != sunyam {
        fmt.Printf("Unmarshaled Map:\n");
        fmt.Printf("  Length: %d\n", len(flags));
        
        // Iterate over map
        malli key, value := varasa flags {
            fmt.Printf("    %s: %s\n", key, value ? "true" : "false");
        }
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 5: Empty Map
    // ============================================
    fmt.Printf("--- Test 5: Empty Map ---\n");
    @json5 string = "{}";
    fmt.Printf("JSON: %s\n", json5);
    
    @empty jatha[string]int = json.UnmarshalMap(json5, 0, 0);
    okavela empty != sunyam {
        fmt.Printf("Unmarshaled Map:\n");
        fmt.Printf("  Length: %d\n", len(empty));
    }
    
    fmt.Printf("\n=== JSON Map Unmarshal Examples Complete ===\n");
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.27s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl`
// Unexpected character: \
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl:46:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    46 |     fmt.Printf("--- Test 2: String-String Map ---\n");
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl:4:25: warning: missing terminating " character
//     4 | samooham adhi;
//       |                         ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl:4:25: error: missing terminating " character
//     4 | samooham adhi;
//       |                         ^    
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl:5:5: error: 'Alice' undeclared (first use in this function); did you mean 'Slice'?
//     5 | 
//       |     ^    
//       |     Slice
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl:5:5: note: each undeclared identifier is reported only once for each function it appears in
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_map_unmarshal_example.tl` (exit code: 1)
//
