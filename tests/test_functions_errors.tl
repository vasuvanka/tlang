// Comprehensive test suite for functions and error handling
// Tests: Functions, Return values, Error handling, Multiple returns

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");

// ============================================
// Test 1: Simple Functions
// ============================================
#add(a int, b int) int {
    mallinchu a + b;
}

#testSimpleFunctions() {
    testing.Log("Testing simple functions");
    
    @result int = add(5, 3);
    testing.AssertEqual(8, result, "Simple function call");
    
    @result2 int = add(10, 20);
    testing.AssertEqual(30, result2, "Another function call");
}

// ============================================
// Test 2: Functions with No Return
// ============================================
#increment(@!x int*) void {
    *x = *x + 1;
}

#testVoidFunctions() {
    testing.Log("Testing void functions");
    
    @value int = 10;
    increment(&value);
    testing.AssertEqual(11, value, "Void function modifies parameter");
}

// ============================================
// Test 3: Functions with Multiple Parameters
// ============================================
#calculate(a int, b int, c int) int {
    mallinchu a * b + c;
}

#testMultipleParameters() {
    testing.Log("Testing functions with multiple parameters");
    
    @result int = calculate(2, 3, 4);
    testing.AssertEqual(10, result, "Multiple parameters");
}

// ============================================
// Test 4: Functions Returning Structs
// ============================================
nirmanam Point {
    x int;
    y int;
}

#createPoint(x int, y int) Point {
    mallinchu Point{x: x, y: y};
}

#testFunctionReturnStruct() {
    testing.Log("Testing functions returning structs");
    
    @p Point = createPoint(10, 20);
    testing.AssertEqual(10, p.x, "Function returns struct - x");
    testing.AssertEqual(20, p.y, "Function returns struct - y");
}

// ============================================
// Test 5: Error Handling - Basic
// ============================================
#divide(a int, b int) (int, string) {
    okavela b == 0 {
        mallinchu (0, "division by zero");
    }
    mallinchu (a / b, sunyam);
}

#testErrorHandling() {
    testing.Log("Testing error handling");
    
    @result int;
    @err string;
    result, err = divide(10, 2);
    
    testing.AssertEqual(5, result, "Division result");
    testing.Assert(err == sunyam, "No error for valid division");
    
    result, err = divide(10, 0);
    testing.AssertEqual(0, result, "Division by zero result");
    testing.Assert(err != sunyam, "Error for division by zero");
}

// ============================================
// Test 6: Error Propagation
// ============================================
#safeDivide(a int, b int) (int, string) {
    okavela b == 0 {
        mallinchu (0, "division by zero");
    }
    mallinchu (a / b, sunyam);
}

#calculateAverage(sum int, count int) (float, string) {
    okavela count == 0 {
        mallinchu (0.0, "count is zero");
    }
    @result int;
    @err string;
    result, err = safeDivide(sum, count);
    okavela err != sunyam {
        mallinchu (0.0, err);
    }
    mallinchu (float(result), sunyam);
}

#testErrorPropagation() {
    testing.Log("Testing error propagation");
    
    @avg float;
    @err string;
    avg, err = calculateAverage(100, 5);
    
    testing.AssertEqualFloat(20.0, avg, 0.1, "Average calculation");
    testing.Assert(err == sunyam, "No error for valid average");
    
    avg, err = calculateAverage(100, 0);
    testing.Assert(err != sunyam, "Error propagated for invalid input");
}

// ============================================
// Test 7: Recursive Functions
// ============================================
#factorial(n int) int {
    okavela n <= 1 {
        mallinchu 1;
    }
    mallinchu n * factorial(n - 1);
}

#testRecursion() {
    testing.Log("Testing recursive functions");
    
    @result int = factorial(5);
    testing.AssertEqual(120, result, "Factorial of 5");
    
    @result2 int = factorial(0);
    testing.AssertEqual(1, result2, "Factorial of 0");
}

// ============================================
// Test 8: Function Pointers (if supported)
// ============================================
#applyOperation(a int, b int, op int) int {
    okavela op == 1 {
        mallinchu a + b;
    } lekapothe okavela op == 2 {
        mallinchu a * b;
    } lekapothe {
        mallinchu a - b;
    }
}

#testFunctionBehavior() {
    testing.Log("Testing function behavior");
    
    @result1 int = applyOperation(5, 3, 1);  // Add
    testing.AssertEqual(8, result1, "Operation - add");
    
    @result2 int = applyOperation(5, 3, 2);  // Multiply
    testing.AssertEqual(15, result2, "Operation - multiply");
    
    @result3 int = applyOperation(5, 3, 0);  // Subtract
    testing.AssertEqual(2, result3, "Operation - subtract");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Functions & Error Handling Test Suite ===\n\n");
    
    testing.Run("testSimpleFunctions", testSimpleFunctions);
    testing.Run("testVoidFunctions", testVoidFunctions);
    testing.Run("testMultipleParameters", testMultipleParameters);
    testing.Run("testFunctionReturnStruct", testFunctionReturnStruct);
    testing.Run("testErrorHandling", testErrorHandling);
    testing.Run("testErrorPropagation", testErrorPropagation);
    testing.Run("testRecursion", testRecursion);
    testing.Run("testFunctionBehavior", testFunctionBehavior);
    
    testing.Summary();
}
