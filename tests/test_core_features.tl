// Comprehensive test suite for core Tlang language features
// Tests: Keywords, Types, Variables, Basic Operations

dhimpu "fmt" as fmt;
dhimpu "testing" as testing;

// ============================================
// Test 1: Variable Declarations
// ============================================
#testVariableDeclarations() {
    testing.Log("Testing variable declarations");
    
    // Immutable variables
    @x int = 10;
    @y float = 3.14;
    @z string = "hello";
    @flag int = 1;  // bool as int
    
    testing.Assert(x == 10, "Immutable int variable");
    testing.Assert(y > 3.0 && y < 4.0, "Immutable float variable");
    testing.AssertEqualString("hello", z, "Immutable string variable");
    testing.Assert(flag == 1, "Boolean as int");
    
    // Mutable variables
    @!count int = 0;
    count = count + 1;
    testing.Assert(count == 1, "Mutable variable assignment");
    
    // Type inference
    @inferred = 42;
    testing.Assert(inferred == 42, "Type inference");
}

// ============================================
// Test 2: Basic Types
// ============================================
#testBasicTypes() {
    testing.Log("Testing basic types");
    
    // Integers
    @a int = 42;
    @b int = -10;
    @c int = 0;
    testing.Assert(a == 42, "Positive int");
    testing.Assert(b == -10, "Negative int");
    testing.Assert(c == 0, "Zero int");
    
    // Floats
    @f1 float = 3.14;
    @f2 float = -0.5;
    @f3 float = 0.0;
    testing.Assert(f1 > 3.0 && f1 < 4.0, "Positive float");
    testing.Assert(f2 < 0.0, "Negative float");
    testing.Assert(f3 == 0.0, "Zero float");
    
    // Strings
    @s1 string = "hello";
    @s2 string = "";
    @s3 string = "world";
    testing.AssertEqualString("hello", s1, "Non-empty string");
    testing.AssertEqualString("", s2, "Empty string");
    testing.AssertEqualString("world", s3, "Another string");
    
    // Booleans (as int)
    @true_val int = 1;
    @false_val int = 0;
    testing.Assert(true_val == 1, "True value");
    testing.Assert(false_val == 0, "False value");
}

// ============================================
// Test 3: Arithmetic Operations
// ============================================
#testArithmetic() {
    testing.Log("Testing arithmetic operations");
    
    @a int = 10;
    @b int = 3;
    
    testing.AssertEqual(13, a + b, "Addition");
    testing.AssertEqual(7, a - b, "Subtraction");
    testing.AssertEqual(30, a * b, "Multiplication");
    testing.AssertEqual(3, a / b, "Integer division");
    testing.AssertEqual(1, a % b, "Modulo");
    
    // Float arithmetic
    @f1 float = 10.0;
    @f2 float = 3.0;
    testing.AssertEqualFloat(13.0, f1 + f2, 0.001, "Float addition");
    testing.AssertEqualFloat(7.0, f1 - f2, 0.001, "Float subtraction");
    testing.AssertEqualFloat(30.0, f1 * f2, 0.001, "Float multiplication");
    testing.AssertEqualFloat(3.333, f1 / f2, 0.1, "Float division");
}

// ============================================
// Test 4: Comparison Operations
// ============================================
#testComparisons() {
    testing.Log("Testing comparison operations");
    
    @a int = 10;
    @b int = 5;
    @c int = 10;
    
    testing.Assert(a > b, "Greater than");
    testing.Assert(b < a, "Less than");
    testing.Assert(a >= c, "Greater than or equal");
    testing.Assert(c <= a, "Less than or equal");
    testing.Assert(a == c, "Equal");
    testing.Assert(a != b, "Not equal");
}

// ============================================
// Test 5: Logical Operations
// ============================================
#testLogicalOps() {
    testing.Log("Testing logical operations");
    
    @true_val int = 1;
    @false_val int = 0;
    
    testing.Assert(true_val && true_val, "AND - both true");
    testing.Assert(!(true_val && false_val), "AND - one false");
    testing.Assert(true_val || false_val, "OR - one true");
    testing.Assert(!(false_val || false_val), "OR - both false");
    testing.Assert(!false_val, "NOT - false");
    testing.Assert(!true_val == 0, "NOT - true");
}

// ============================================
// Test 6: String Operations
// ============================================
#testStringOps() {
    testing.Log("Testing string operations");
    
    @s1 string = "hello";
    @s2 string = "world";
    @s3 string = s1 + " " + s2;
    
    testing.AssertEqualString("hello world", s3, "String concatenation");
    
    // String length test (simplified - just check non-empty)
    testing.Assert(s1 != sunyam, "String is not null");
}

// ============================================
// Test 7: Pointers
// ============================================
#testPointers() {
    testing.Log("Testing pointers");
    
    @x int = 42;
    @ptr *int = &x;
    
    testing.Assert(*ptr == 42, "Pointer dereference");
    
    *ptr = 100;
    testing.Assert(x == 100, "Pointer modification");
}

// ============================================
// Test 8: Type Conversions
// ============================================
#testTypeConversions() {
    testing.Log("Testing type conversions");
    
    @i int = 42;
    @f float = float(i);
    testing.AssertEqualFloat(42.0, f, 0.001, "Int to float");
    
    @f2 float = 3.14;
    @i2 int = int(f2);
    testing.AssertEqual(3, i2, "Float to int");
    
    @s string = "123";
    // Note: strconv.Atoi would be used in real code
    testing.AssertEqualString("123", s, "String representation");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Core Features Test Suite ===\n\n");
    
    testing.Run("testVariableDeclarations", testVariableDeclarations);
    testing.Run("testBasicTypes", testBasicTypes);
    testing.Run("testArithmetic", testArithmetic);
    testing.Run("testComparisons", testComparisons);
    testing.Run("testLogicalOps", testLogicalOps);
    testing.Run("testStringOps", testStringOps);
    testing.Run("testPointers", testPointers);
    testing.Run("testTypeConversions", testTypeConversions);
    
    testing.Summary();
}
