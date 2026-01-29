// JSON Serialization and Deserialization Demo
// Comprehensive example showing how JSON works in Tlang

dhimpu "fmt" as fmt;
dhimpu "json" as json;

// Example structs
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}

nirmanam Address {
    street string;
    city string;
    zip int;
}

nirmanam Employee {
    name string;
    age int;
    address Address;  // Nested struct
    salary float;
    active int;
}

#prarambham() {
    fmt.Printf("=== JSON Serialization & Deserialization Demo ===\n\n");
    
    // ============================================
    // 1. BASIC TYPES - Manual Serialization
    // ============================================
    fmt.Printf("--- 1. Basic Types ---\n");
    @nameJson string = json.Marshal("string", "Alice");
    @ageJson string = json.Marshal("int", "30");
    @salaryJson string = json.Marshal("float", "75000.50");
    @activeJson string = json.Marshal("bool", "1");
    
    fmt.Printf("Name JSON:   %s\n", nameJson);
    fmt.Printf("Age JSON:    %s\n", ageJson);
    fmt.Printf("Salary JSON: %s\n", salaryJson);
    fmt.Printf("Active JSON: %s\n", activeJson);
    fmt.Printf("\n");
    
    // Deserialize basic types
    @name string = json.Unmarshal(nameJson, "string");
    @age string = json.Unmarshal(ageJson, "int");
    fmt.Printf("Deserialized - Name: %s, Age: %s\n", name, age);
    fmt.Printf("\n");
    
    // ============================================
    // 2. STRUCT SERIALIZATION (Automatic)
    // ============================================
    fmt.Printf("--- 2. Struct Serialization (Automatic) ---\n");
    
    // Create a Person struct
    @person Person = Person{
        name: "Alice",
        age: 30,
        email: "alice@example.com",
        active: 1
    };
    
    // Automatic serialization - Go-style syntax!
    @personJson string = json.Marshal(person);
    fmt.Printf("Person JSON: %s\n", personJson);
    fmt.Printf("\n");
    
    // ============================================
    // 3. STRUCT DESERIALIZATION (Automatic)
    // ============================================
    fmt.Printf("--- 3. Struct Deserialization (Automatic) ---\n");
    
    @jsonInput string = "{\"name\": \"Bob\", \"age\": 25, \"email\": \"bob@example.com\", \"active\": 1}";
    fmt.Printf("Input JSON:  %s\n", jsonInput);
    
    // Automatic deserialization - compiler generates json_unmarshal_person()
    @person2 Person* = json_unmarshal_person(jsonInput);
    okavela person2 != sunyam {
        fmt.Printf("Deserialized Person:\n");
        fmt.Printf("  Name:   %s\n", person2.name);
        fmt.Printf("  Age:    %d\n", person2.age);
        fmt.Printf("  Email:  %s\n", person2.email);
        fmt.Printf("  Active: %d\n", person2.active);
        
        // Clean up
        free(person2.name);
        free(person2.email);
        free(person2);
    }
    fmt.Printf("\n");
    
    // ============================================
    // 4. NESTED STRUCTS (Automatic)
    // ============================================
    fmt.Printf("--- 4. Nested Structs (Automatic) ---\n");
    
    @address Address = Address{
        street: "123 Main St",
        city: "New York",
        zip: 10001
    };
    
    @employee Employee = Employee{
        name: "Charlie",
        age: 35,
        address: address,
        salary: 85000.75,
        active: 1
    };
    
    // Serialize nested struct - Go-style syntax!
    @employeeJson string = json.Marshal(employee);
    fmt.Printf("Employee JSON: %s\n", employeeJson);
    fmt.Printf("\n");
    
    // Deserialize nested struct
    @jsonEmployee string = "{\"name\": \"David\", \"age\": 28, \"address\": {\"street\": \"456 Oak Ave\", \"city\": \"Boston\", \"zip\": 02101}, \"salary\": 90000.0, \"active\": 1}";
    fmt.Printf("Input JSON: %s\n", jsonEmployee);
    
    @employee2 Employee* = json_unmarshal_employee(jsonEmployee);
    okavela employee2 != sunyam {
        fmt.Printf("Deserialized Employee:\n");
        fmt.Printf("  Name:   %s\n", employee2.name);
        fmt.Printf("  Age:    %d\n", employee2.age);
        fmt.Printf("  Address:\n");
        fmt.Printf("    Street: %s\n", employee2.address.street);
        fmt.Printf("    City:   %s\n", employee2.address.city);
        fmt.Printf("    Zip:    %d\n", employee2.address.zip);
        fmt.Printf("  Salary: %.2f\n", employee2.salary);
        fmt.Printf("  Active: %d\n", employee2.active);
        
        // Clean up
        free(employee2.name);
        free(employee2.address.street);
        free(employee2.address.city);
        free(employee2);
    }
    fmt.Printf("\n");
    
    // ============================================
    // 5. ROUND-TRIP TEST
    // ============================================
    fmt.Printf("--- 5. Round-Trip Test (Serialize -> Deserialize) ---\n");
    
    @original Person = Person{
        name: "Eve",
        age: 32,
        email: "eve@example.com",
        active: 1
    };
    
    // Serialize - Go-style syntax!
    @serialized string = json.Marshal(original);
    fmt.Printf("Serialized:   %s\n", serialized);
    
    // Deserialize
    @deserialized Person* = json_unmarshal_person(serialized);
    okavela deserialized != sunyam {
        fmt.Printf("Deserialized:\n");
        fmt.Printf("  Name:   %s (original: %s)\n", deserialized.name, original.name);
        fmt.Printf("  Age:    %d (original: %d)\n", deserialized.age, original.age);
        fmt.Printf("  Email:  %s (original: %s)\n", deserialized.email, original.email);
        fmt.Printf("  Active: %d (original: %d)\n", deserialized.active, original.active);
        
        // Verify round-trip
        @match int = (deserialized.name == original.name && 
                     deserialized.age == original.age &&
                     deserialized.email == original.email &&
                     deserialized.active == original.active);
        fmt.Printf("\nRound-trip successful: %d\n", match);
        
        free(deserialized.name);
        free(deserialized.email);
        free(deserialized);
    }
    fmt.Printf("\n");
    
    // ============================================
    // 6. MISSING FIELDS HANDLING
    // ============================================
    fmt.Printf("--- 6. Missing Fields Handling ---\n");
    
    @partialJson string = "{\"name\": \"Frank\", \"age\": 40}";
    fmt.Printf("Partial JSON (missing email, active): %s\n", partialJson);
    
    @person3 Person* = json_unmarshal_person(partialJson);
    okavela person3 != sunyam {
        fmt.Printf("Deserialized (missing fields default to zero):\n");
        fmt.Printf("  Name:   %s\n", person3.name);
        fmt.Printf("  Age:    %d\n", person3.age);
        fmt.Printf("  Email:  %s (empty if missing)\n", person3.email ? person3.email : "(null)");
        fmt.Printf("  Active: %d (defaults to 0)\n", person3.active);
        
        free(person3.name);
        free(person3.email);
        free(person3);
    }
    
    fmt.Printf("\n=== JSON Demo Complete ===\n");
}
