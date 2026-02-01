// Test cases for fmt library

@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("=== fmt Library Tests ===\n");
    
    // Test Printf with various format specifiers
    fmt.Printf("Integer: %d\n", 42);
    fmt.Printf("Float: %f\n", 3.14159);
    fmt.Printf("String: %s\n", "Hello");
    fmt.Printf("Multiple: %d, %f, %s\n", 10, 2.5, "test");
    
    // Test Sprintf
    @result1 string = fmt.Sprintf("Number: %d", 123);
    @result2 string = fmt.Sprintf("Float: %.2f", 3.14159);
    @result3 string = fmt.Sprintf("String: %s", "World");
    
    fmt.Printf("Sprintf result 1: %s\n", result1);
    fmt.Printf("Sprintf result 2: %s\n", result2);
    fmt.Printf("Sprintf result 3: %s\n", result3);
}

//

//

//

// === OUTPUT ===
// === fmt Library Tests ===
// Integer: 42
// Float: 3.141590
// String: Hello
// Multiple: 10, 2.500000, test
// Sprintf result 1: String: World
// Sprintf result 2: String: World
// Sprintf result 3: String: World
//
