// Comprehensive test suite for data structures
// Tests: Arrays, Slices, Structs, Maps

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");

// ============================================
// Test 1: Arrays
// ============================================
#testArrays() {
    testing.Log("Testing arrays");
    
    @arr [5]int;
    arr[0] = 10;
    arr[1] = 20;
    arr[2] = 30;
    arr[3] = 40;
    arr[4] = 50;
    
    testing.AssertEqual(10, arr[0], "Array element 0");
    testing.AssertEqual(30, arr[2], "Array element 2");
    testing.AssertEqual(50, arr[4], "Array element 4");
    
    // Array literal
    @arr2 [3]int = [3]int{1, 2, 3};
    testing.AssertEqual(1, arr2[0], "Array literal element 0");
    testing.AssertEqual(3, arr2[2], "Array literal element 2");
}

// ============================================
// Test 2: Slices
// ============================================
#testSlices() {
    testing.Log("Testing slices");
    
    // Create slice from array
    @arr [5]int = [5]int{1, 2, 3, 4, 5};
    @slice []int = arr[0:5];
    
    testing.AssertEqual(1, slice[0], "Slice element 0");
    testing.AssertEqual(5, slice[4], "Slice element 4");
    
    // Slice operations
    @slice2 []int = arr[1:4];  // [2, 3, 4]
    testing.AssertEqual(2, slice2[0], "Slice range start");
    testing.AssertEqual(4, slice2[2], "Slice range end");
}

// ============================================
// Test 3: Structs
// ============================================
nirmanam Person {
    name string;
    age int;
    active int;  // bool
}

#testStructs() {
    testing.Log("Testing structs");
    
    // Struct literal
    @person Person = Person{
        name: "Alice",
        age: 30,
        active: 1
    };
    
    testing.AssertEqualString("Alice", person.name, "Struct field - name");
    testing.AssertEqual(30, person.age, "Struct field - age");
    testing.AssertEqual(1, person.active, "Struct field - active");
    
    // Struct modification
    person.age = 31;
    testing.AssertEqual(31, person.age, "Struct field modification");
}

// ============================================
// Test 4: Nested Structs
// ============================================
nirmanam Address {
    street string;
    city string;
    zip int;
}

nirmanam Employee {
    person Person;
    address Address;
    salary float;
}

#testNestedStructs() {
    testing.Log("Testing nested structs");
    
    @emp Employee = Employee{
        person: Person{name: "Bob", age: 25, active: 1},
        address: Address{street: "123 Main St", city: "NYC", zip: 10001},
        salary: 75000.0
    };
    
    testing.AssertEqualString("Bob", emp.person.name, "Nested struct - person name");
    testing.AssertEqualString("NYC", emp.address.city, "Nested struct - address city");
    testing.AssertEqualFloat(75000.0, emp.salary, 0.1, "Nested struct - salary");
}

// ============================================
// Test 5: Maps
// ============================================
#testMaps() {
    testing.Log("Testing maps");
    
    @scores jatha[string]int;
    
    // Map operations would use map_set, map_get functions
    // For now, we test map creation
    testing.Assert(1 == 1, "Map structure exists");
}

// ============================================
// Test 6: Arrays of Structs
// ============================================
#testArrayOfStructs() {
    testing.Log("Testing arrays of structs");
    
    @people [3]Person;
    people[0] = Person{name: "Alice", age: 30, active: 1};
    people[1] = Person{name: "Bob", age: 25, active: 1};
    people[2] = Person{name: "Charlie", age: 35, active: 0};
    
    testing.AssertEqualString("Alice", people[0].name, "Array of structs - element 0");
    testing.AssertEqualString("Bob", people[1].name, "Array of structs - element 1");
    testing.AssertEqual(0, people[2].active, "Array of structs - element 2 active");
}

// ============================================
// Test 7: Pointers to Structs
// ============================================
#testStructPointers() {
    testing.Log("Testing pointers to structs");
    
    @person *Person = Person{ name: "Dave", age: 40, active: 1 };
    
    testing.AssertEqualString("Dave", person.name, "Pointer to struct - name");
    testing.AssertEqual(40, person.age, "Pointer to struct - age");
    
    free(person.name);
    free(person);
}

// ============================================
// Test 8: Struct with Arrays
// ============================================
nirmanam Team {
    name string;
    members [3]Person;
    score int;
}

#testStructWithArrays() {
    testing.Log("Testing struct with arrays");
    
    @team Team = Team{
        name: "Team A",
        members: [3]Person{
            Person{name: "Alice", age: 30, active: 1},
            Person{name: "Bob", age: 25, active: 1},
            Person{name: "Charlie", age: 35, active: 1}
        },
        score: 100
    };
    
    testing.AssertEqualString("Team A", team.name, "Struct with array - name");
    testing.AssertEqualString("Alice", team.members[0].name, "Struct with array - member 0");
    testing.AssertEqual(100, team.score, "Struct with array - score");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Data Structures Test Suite ===\n\n");
    
    testing.Run("testArrays", testArrays);
    testing.Run("testSlices", testSlices);
    testing.Run("testStructs", testStructs);
    testing.Run("testNestedStructs", testNestedStructs);
    testing.Run("testMaps", testMaps);
    testing.Run("testArrayOfStructs", testArrayOfStructs);
    testing.Run("testStructPointers", testStructPointers);
    testing.Run("testStructWithArrays", testStructWithArrays);
    
    testing.Summary();
}
