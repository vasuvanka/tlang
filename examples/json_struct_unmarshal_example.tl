// JSON Struct Unmarshal Example
// Demonstrates automatic struct unmarshaling from JSON

@fmt = #dhimpu("std/fmt");
@json = #dhimpu("std/json");

// Define a Person struct
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}

// Define a nested struct
nirmanam Address {
    street string;
    city string;
    zip int;
}

nirmanam User {
    name string;
    age int;
    address Address;
    scores []int;
}

#prarambham() {
    fmt.Printf("=== JSON Struct Unmarshal Examples ===\n\n");
    
    // ============================================
    // Test 1: Simple Struct Unmarshal
    // ============================================
    fmt.Printf("--- Test 1: Simple Struct ---\n");
    @json1 string = "{\"name\": \"Alice\", \"age\": 30, \"email\": \"alice@example.com\", \"active\": 1}";
    fmt.Printf("JSON: %s\n", json1);
    
    @person *Person = json_unmarshal_person(json1);
    okavela person != sunyam {
        fmt.Printf("Unmarshaled Person:\n");
        fmt.Printf("  Name: %s\n", person->name);
        fmt.Printf("  Age: %d\n", person->age);
        fmt.Printf("  Email: %s\n", person->email);
        fmt.Printf("  Active: %d\n", person->active);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: Struct with Missing Fields
    // ============================================
    fmt.Printf("--- Test 2: Struct with Missing Fields ---\n");
    @json2 string = "{\"name\": \"Bob\", \"age\": 25}";
    fmt.Printf("JSON: %s\n", json2);
    
    @person2 *Person = json_unmarshal_person(json2);
    okavela person2 != sunyam {
        fmt.Printf("Unmarshaled Person (missing fields):\n");
        fmt.Printf("  Name: %s\n", person2->name);
        fmt.Printf("  Age: %d\n", person2->age);
        fmt.Printf("  Email: %s\n", person2->email ? person2->email : "(null)");
        fmt.Printf("  Active: %d\n", person2->active);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Nested Struct
    // ============================================
    fmt.Printf("--- Test 3: Nested Struct ---\n");
    @json3 string = "{\"name\": \"Charlie\", \"age\": 35, \"address\": {\"street\": \"123 Main St\", \"city\": \"Springfield\", \"zip\": 12345}, \"scores\": [95, 87, 92]}";
    fmt.Printf("JSON: %s\n", json3);
    
    @user *User = json_unmarshal_user(json3);
    okavela user != sunyam {
        fmt.Printf("Unmarshaled User:\n");
        fmt.Printf("  Name: %s\n", user->name);
        fmt.Printf("  Age: %d\n", user->age);
        fmt.Printf("  Address:\n");
        fmt.Printf("    Street: %s\n", user->address.street);
        fmt.Printf("    City: %s\n", user->address.city);
        fmt.Printf("    Zip: %d\n", user->address.zip);
        fmt.Printf("  Scores: ");
        okavela user->scores != sunyam {
            malli i := varasa user->scores {
                fmt.Printf("%d ", user->scores[i]);
            }
        }
        fmt.Printf("\n");
    }
    
    fmt.Printf("\n=== JSON Struct Unmarshal Examples Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.27s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_unmarshal_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_unmarshal_example.tl:11:1: Expected field name
//
//
//   11 |     name string;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_struct_unmarshal_example.tl` (exit code: 1)
//
