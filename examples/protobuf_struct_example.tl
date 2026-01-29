// Protocol Buffers Struct Example
// Demonstrates automatic struct marshaling/unmarshaling

dhimpu "fmt" as fmt;
dhimpu "protobuf" as protobuf;

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
}

#prarambham() {
    fmt.Printf("=== Protocol Buffers Struct Example ===\n\n");
    
    // ============================================
    // Example 1: Simple Struct Marshaling
    // ============================================
    fmt.Printf("--- Example 1: Simple Struct ---\n");
    
    @person Person = Person{
        name: "Alice",
        age: 30,
        email: "alice@example.com",
        active: 1
    };
    
    // Automatic marshaling - compiler generates protobuf_marshal_person()
    size_t size;
    char* data = protobuf_marshal_person(&person, &size);
    
    okavela data != sunyam {
        fmt.Printf("Encoded %zu bytes\n", size);
        fmt.Printf("Binary data (hex): ");
        malli i := varasa size {
            fmt.Printf("%02x ", (unsigned char)data[i]);
        }
        fmt.Printf("\n\n");
        
        // Unmarshal
        Person* decoded = protobuf_unmarshal_person(data, size);
        okavela decoded != sunyam {
            fmt.Printf("Decoded Person:\n");
            fmt.Printf("  Name: %s\n", decoded->name);
            fmt.Printf("  Age: %d\n", decoded->age);
            fmt.Printf("  Email: %s\n", decoded->email);
            fmt.Printf("  Active: %d\n", decoded->active);
            
            // Free decoded strings
            free(decoded->name);
            free(decoded->email);
            free(decoded);
        }
        
        free(data);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Example 2: Nested Struct
    // ============================================
    fmt.Printf("--- Example 2: Nested Struct ---\n");
    
    @user User = User{
        name: "Bob",
        age: 25,
        address: Address{
            street: "123 Main St",
            city: "Springfield",
            zip: 12345
        }
    };
    
    size_t user_size;
    char* user_data = protobuf_marshal_user(&user, &user_size);
    
    okavela user_data != sunyam {
        fmt.Printf("Encoded nested struct: %zu bytes\n", user_size);
        
        // Unmarshal
        User* decoded_user = protobuf_unmarshal_user(user_data, user_size);
        okavela decoded_user != sunyam {
            fmt.Printf("Decoded User:\n");
            fmt.Printf("  Name: %s\n", decoded_user->name);
            fmt.Printf("  Age: %d\n", decoded_user->age);
            fmt.Printf("  Address:\n");
            fmt.Printf("    Street: %s\n", decoded_user->address.street);
            fmt.Printf("    City: %s\n", decoded_user->address.city);
            fmt.Printf("    Zip: %d\n", decoded_user->address.zip);
            
            // Free decoded strings
            free(decoded_user->name);
            free(decoded_user->address.street);
            free(decoded_user->address.city);
            free(decoded_user);
        }
        
        free(user_data);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Example 3: Size Comparison
    // ============================================
    fmt.Printf("--- Example 3: Size Comparison ---\n");
    
    // JSON equivalent would be:
    // {"name":"Alice","age":30,"email":"alice@example.com","active":1}
    // JSON size: ~57 bytes
    
    size_t protobuf_size;
    char* protobuf_data = protobuf_marshal_person(&person, &protobuf_size);
    
    okavela protobuf_data != sunyam {
        fmt.Printf("Protobuf size: %zu bytes\n", protobuf_size);
        fmt.Printf("JSON equivalent: ~57 bytes\n");
        fmt.Printf("Size reduction: ~%.1f%%\n", (1.0 - (double)protobuf_size / 57.0) * 100.0);
        free(protobuf_data);
    }
    
    fmt.Printf("\n=== Protocol Buffers Struct Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.32s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\protobuf_struct_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\protobuf_struct_example.tl:11:1: Expected field name
//
//
//   11 |     name string;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\protobuf_struct_example.tl` (exit code: 1)
//
