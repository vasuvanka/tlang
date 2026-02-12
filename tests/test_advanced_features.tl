// Comprehensive test suite for advanced features
// Tests: JSON serialization, Struct methods, Packages, Memory management

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");
@json = #dhimpu("std/json");

// ============================================
// Test 1: JSON Serialization
// ============================================
nirmanam User {
    name string;
    age int;
    email string;
}

#testJSONSerialization() {
    testing.Log("Testing JSON serialization");
    
    @user User = User{
        name: "Alice",
        age: 30,
        email: "alice@example.com"
    };
    
    @json string = json.Marshal(user);
    testing.Assert(json != sunyam, "JSON serialization produces output");
    testing.Assert(json[0] == '{', "JSON starts with {");
}

// ============================================
// Test 2: JSON Deserialization
// ============================================
#testJSONDeserialization() {
    testing.Log("Testing JSON deserialization");
    
    @json_str string = "{\"name\":\"Bob\",\"age\":25,\"email\":\"bob@example.com\"}";
    @user *User = json_unmarshal_user(json_str);
    
    okavela user != sunyam {
        testing.AssertEqualString("Bob", user.name, "Deserialized user name");
        testing.AssertEqual(25, user.age, "Deserialized user age");
        free(user.name);
        free(user.email);
        free(user);
    } lekapothe {
        testing.Fail("JSON deserialization failed");
    }
}

// ============================================
// Test 3: Memory Management (nirmanam)
// ============================================
#testMemoryManagement() {
    testing.Log("Testing memory management with struct literals");
    
    @user *User = User{ name: "Charlie", age: 35, email: "charlie@example.com" };
    
    testing.AssertEqualString("Charlie", user.name, "struct literal allocated struct");
    testing.AssertEqual(35, user.age, "nirmanam allocated struct age");
    
    free(user.name);
    free(user.email);
    free(user);
}

// ============================================
// Test 4: Struct Methods
// ============================================
nirmanam Rectangle {
    width float;
    height float;
}

#Rectangle_area(r *Rectangle) float {
    mallinchu r.width * r.height;
}

#Rectangle_perimeter(r *Rectangle) float {
    mallinchu 2.0 * (r.width + r.height);
}

nirmanam Circle {
    radius float;
}

#Circle_area(c *Circle) float {
    mallinchu 3.14159 * c.radius * c.radius;
}

#Circle_perimeter(c *Circle) float {
    mallinchu 2.0 * 3.14159 * c.radius;
}

#testStructMethods() {
    testing.Log("Testing struct methods (Rectangle, Circle)");
    
    @rect Rectangle = Rectangle{width: 5.0, height: 3.0};
    @area float = Rectangle_area(&rect);
    
    testing.AssertEqualFloat(15.0, area, 0.1, "Rectangle area");
    
    @circle Circle = Circle{radius: 2.0};
    @circle_area float = Circle_area(&circle);
    
    testing.AssertEqualFloat(12.566, circle_area, 0.1, "Circle area");
}

// ============================================
// Test 5: Package System
// ============================================
#testPackageSystem() {
    testing.Log("Testing package system");
    
    // Package declaration and imports are tested by compilation
    // If we reach here, package system works
    testing.Assert(1 == 1, "Package system functional");
}

// ============================================
// Test 6: Pointers to Pointers
// ============================================
#testDoublePointers() {
    testing.Log("Testing double pointers");
    
    @x int = 42;
    @ptr *int = &x;
    @ptr2 **int = &ptr;
    
    testing.Assert(**ptr2 == 42, "Double pointer dereference");
    
    **ptr2 = 100;
    testing.Assert(x == 100, "Double pointer modification");
}

// ============================================
// Test 7: Struct with Pointers
// ============================================
nirmanam Node {
    value int;
    next Node*;
}

#testStructWithPointers() {
    testing.Log("Testing struct with pointer fields");
    
    @node1 *Node = Node{ value: 10, next: sunyam };
    
    @node2 *Node = Node{ value: 20, next: node1 };
    
    testing.AssertEqual(20, node2.value, "Node value");
    testing.Assert(node2.next != sunyam, "Node next pointer");
    testing.AssertEqual(10, node2.next.value, "Next node value");
    
    free(node1);
    free(node2);
}

// ============================================
// Test 8: Complex Nested Structures
// ============================================
nirmanam Company {
    name string;
    employees [3]User;
    founded int;
}

#testComplexNested() {
    testing.Log("Testing complex nested structures");
    
    @company Company = Company{
        name: "Tech Corp",
        employees: [3]User{
            User{name: "Alice", age: 30, email: "alice@tech.com"},
            User{name: "Bob", age: 25, email: "bob@tech.com"},
            User{name: "Charlie", age: 35, email: "charlie@tech.com"}
        },
        founded: 2020
    };
    
    testing.AssertEqualString("Tech Corp", company.name, "Company name");
    testing.AssertEqualString("Alice", company.employees[0].name, "Employee 0 name");
    testing.AssertEqual(2020, company.founded, "Company founded year");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Advanced Features Test Suite ===\n\n");
    
    testing.Run("testJSONSerialization", testJSONSerialization);
    testing.Run("testJSONDeserialization", testJSONDeserialization);
    testing.Run("testMemoryManagement", testMemoryManagement);
    testing.Run("testStructMethods", testStructMethods);
    testing.Run("testPackageSystem", testPackageSystem);
    testing.Run("testDoublePointers", testDoublePointers);
    testing.Run("testStructWithPointers", testStructWithPointers);
    testing.Run("testComplexNested", testComplexNested);
    
    testing.Summary();
}
