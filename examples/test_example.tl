// Testing library example
// Demonstrates unit testing with testing package

// Test function for addition
#test_Addition() {
    @a int = 10;
    @b int = 20;
    @result int = a + b;
    
    testing.AssertEqual(30, result, "Addition test");
}

// Test function for string operations
#test_StringOperations() {
    @text string = "Hello";
    @upper string = strings.ToUpper(text);
    
    testing.AssertEqualString("HELLO", upper, "ToUpper test");
    testing.Assert(strings.Contains(text, "ell") == 1, "Contains test");
}

// Test function for math operations
#test_MathOperations() {
    @sqrt float = math.Sqrt(16.0);
    testing.AssertEqualFloat(4.0, sqrt, 0.0001, "Square root test");
    
    @pow float = math.Pow(2.0, 3.0);
    testing.AssertEqualFloat(8.0, pow, 0.0001, "Power test");
}

// Test function with failure example
#test_WillFail() {
    testing.AssertEqual(1, 2, "This test will fail");
}

// Main test runner
#prarambham() {
    fmt.Printf("=== Running Tests ===\n\n");
    
    testing.Run("test_Addition", test_Addition);
    testing.Run("test_StringOperations", test_StringOperations);
    testing.Run("test_MathOperations", test_MathOperations);
    testing.Run("test_WillFail", test_WillFail);
    
    testing.Summary();
}

//

//

//

// === OUTPUT ===
// === Running Tests ===
//
// RUN   test_Addition
// PASS  test_Addition
// RUN   test_StringOperations
// PASS  test_StringOperations
// RUN   test_MathOperations
// PASS  test_MathOperations
// RUN   test_WillFail
//     ASSERT FAILED: This test will fail (expected 1, got 2)
// FAIL  test_WillFail
//
// === Test Summary ===
// Total tests: 4
// Passed: 3
// Failed: 1
// RESULT: FAILED
//
