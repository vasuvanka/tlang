// JSON Validation Example
// Demonstrates JSON syntax validation and schema validation

@fmt = #dhimpu("std/fmt");
@json = #dhimpu("std/json");

#prarambham() {
    fmt.Printf("=== JSON Validation Example ===\n\n");
    
    // ============================================
    // Test 1: Valid JSON
    // ============================================
    fmt.Printf("--- Test 1: Valid JSON ---\n");
    @valid_json string = "{\"name\": \"John\", \"age\": 30}";
    @err error = json.Validate(valid_json);
    okavela err != sunyam {
        fmt.Printf("Validation failed: %s\n", err);
    } lekapothe {
        fmt.Printf("JSON is valid\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: Invalid JSON (unclosed bracket)
    // ============================================
    fmt.Printf("--- Test 2: Invalid JSON (unclosed bracket) ---\n");
    @invalid_json string = "{\"name\": \"John\", \"age\": 30";  // Missing closing brace
    @err2 error = json.Validate(invalid_json);
    okavela err2 != sunyam {
        fmt.Printf("Caught error: %s\n", err2);
    } lekapothe {
        fmt.Printf("Should have caught error\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Schema Validation - Valid
    // ============================================
    fmt.Printf("--- Test 3: Schema Validation - Valid ---\n");
    @data string = "{\"name\": \"John\", \"age\": 30, \"active\": true}";
    @schema string = "name:string,age:int,active:bool";
    @err3 error = json.ValidateSchema(data, schema);
    thappu err3 okavela {
        fmt.Printf("Schema validation failed: %s\n", err3);
    } lekapothe {
        fmt.Printf("JSON matches schema\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 4: Schema Validation - Missing Field
    // ============================================
    fmt.Printf("--- Test 4: Schema Validation - Missing Field ---\n");
    @data2 string = "{\"name\": \"John\"}";  // Missing "age" field
    @schema2 string = "name:string,age:int";
    @err4 error = json.ValidateSchema(data2, schema2);
    okavela err4 != sunyam {
        fmt.Printf("Caught missing field: %s\n", err4);
    } lekapothe {
        fmt.Printf("Should have caught missing field\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 5: Schema Validation - Wrong Type
    // ============================================
    fmt.Printf("--- Test 5: Schema Validation - Wrong Type ---\n");
    @data3 string = "{\"name\": \"John\", \"age\": \"thirty\"}";  // age should be int
    @schema3 string = "name:string,age:int";
    @err5 error = json.ValidateSchema(data3, schema3);
    okavela err5 != sunyam {
        fmt.Printf("Caught type mismatch: %s\n", err5);
    } lekapothe {
        fmt.Printf("Should have caught type mismatch\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 6: Schema Validation - Array Type
    // ============================================
    fmt.Printf("--- Test 6: Schema Validation - Array Type ---\n");
    @data4 string = "{\"items\": [1, 2, 3], \"count\": 3}";
    @schema4 string = "items:array,count:int";
    @err6 error = json.ValidateSchema(data4, schema4);
    okavela err6 != sunyam {
        fmt.Printf("Schema validation failed: %s\n", err6);
    } lekapothe {
        fmt.Printf("JSON matches schema (with array)\n");
    }
    
    fmt.Printf("\n=== JSON Validation Example Complete ===\n");
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.34s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl`
// Unexpected character: \
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl:46:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    46 |     @err3 error = json.ValidateSchema(data, schema);
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl:4:30: warning: missing terminating " character
//     4 | samooham adhi;
//       |                              ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl:4:30: error: missing terminating " character
//     4 | samooham adhi;
//       |                              ^    
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl:5:5: error: 'name' undeclared (first use in this function); did you mean 'tzname'?
//     5 | 
//       |     ^   
//       |     tzname
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl:5:5: note: each undeclared identifier is reported only once for each function it appears in
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_validation_example.tl` (exit code: 1)
//
