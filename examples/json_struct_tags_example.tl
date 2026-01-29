// JSON Struct Tags Example
// Demonstrates Go-like struct tags for automatic schema validation

dhimpu "fmt" as fmt;
dhimpu "json" as json;

// Define struct with tags for JSON field mapping and validation
nirmanam Person {
    Name string `json:"name" validate:"required"`;
    Age int `json:"age" validate:"required"`;
    Email string `json:"email"`;
    Active int `json:"active" validate:"required"`;
}

#prarambham() {
    fmt.Printf("=== JSON Struct Tags Example ===\n\n");
    
    // ============================================
    // Test 1: Valid JSON matching struct schema
    // ============================================
    fmt.Printf("--- Test 1: Valid JSON ---\n");
    @valid_json string = "{\"name\": \"John\", \"age\": 30, \"email\": \"john@example.com\", \"active\": true}";
    @err error = json_validate_person(valid_json);
    okavela err != sunyam {
        fmt.Printf("Validation failed: %s\n", err);
    } lekapothe {
        fmt.Printf("JSON is valid against Person schema\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: Missing required field
    // ============================================
    fmt.Printf("--- Test 2: Missing Required Field ---\n");
    @invalid_json string = "{\"name\": \"John\", \"email\": \"john@example.com\"}";  // Missing age and active
    @err2 error = json_validate_person(invalid_json);
    okavela err2 != sunyam {
        fmt.Printf("Caught missing field: %s\n", err2);
    } lekapothe {
        fmt.Printf("Should have caught missing field\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Wrong field type
    // ============================================
    fmt.Printf("--- Test 3: Wrong Field Type ---\n");
    @wrong_type_json string = "{\"name\": \"John\", \"age\": \"thirty\", \"email\": \"john@example.com\", \"active\": true}";
    @err3 error = json_validate_person(wrong_type_json);
    okavela err3 != sunyam {
        fmt.Printf("Caught type mismatch: %s\n", err3);
    } lekapothe {
        fmt.Printf("Should have caught type mismatch\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 4: Unmarshal with struct tags
    // ============================================
    fmt.Printf("--- Test 4: Unmarshal with Struct Tags ---\n");
    @json_data string = "{\"name\": \"Alice\", \"age\": 25, \"email\": \"alice@example.com\", \"active\": true}";
    @person *Person = json_unmarshal_person(json_data);
    okavela person != sunyam {
        fmt.Printf("Unmarshaled successfully\n");
        fmt.Printf("   Name: %s\n", person->Name);
        fmt.Printf("   Age: %d\n", person->Age);
        fmt.Printf("   Email: %s\n", person->Email);
        fmt.Printf("   Active: %d\n", person->Active);
    } lekapothe {
        fmt.Printf("Failed to unmarshal\n");
    }
    
    fmt.Printf("\n=== JSON Struct Tags Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_tags_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_tags_example.tl:11:1: Expected field name
//
//
//   11 |     Name string `json:"name" validate:"required"`;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_tags_example.tl` (exit code: 1)
//
