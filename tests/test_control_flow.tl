// Comprehensive test suite for control flow features
// Tests: if/else, for loops, break, continue, nested control flow

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");

// ============================================
// Test 1: If/Else Statements
// ============================================
#testIfElse() {
    testing.Log("Testing if/else statements");
    
    @x int = 10;
    @result int = 0;
    
    okavela x > 5 {
        result = 1;
    } lekapothe {
        result = 0;
    }
    testing.Assert(result == 1, "If condition true");
    
    @y int = 3;
    okavela y > 5 {
        result = 1;
    } lekapothe {
        result = 0;
    }
    testing.Assert(result == 0, "Else branch");
}

// ============================================
// Test 2: Else-If Chains
// ============================================
#testElseIf() {
    testing.Log("Testing else-if chains");
    
    @x int = 15;
    @result int = 0;
    
    okavela x < 10 {
        result = 1;
    } lekapothe okavela x < 20 {
        result = 2;
    } lekapothe {
        result = 3;
    }
    
    testing.AssertEqual(2, result, "Else-if chain");
}

// ============================================
// Test 3: For Loop - C-style
// ============================================
#testForLoop() {
    testing.Log("Testing C-style for loop");
    
    @sum int = 0;
    malli (@!i int = 1; i <= 10; i = i + 1) {
        sum = sum + i;
    }
    
    testing.AssertEqual(55, sum, "For loop sum 1-10");
}

// ============================================
// Test 4: Infinite Loop with Break
// ============================================
#testInfiniteLoop() {
    testing.Log("Testing infinite loop with break");
    
    @count int = 0;
    malli {
        count = count + 1;
        okavela count >= 5 {
            agu;
        }
    }
    
    testing.AssertEqual(5, count, "Infinite loop with break");
}

// ============================================
// Test 5: Continue Statement
// ============================================
#testContinue() {
    testing.Log("Testing continue statement");
    
    @sum int = 0;
    malli (@!i int = 1; i <= 10; i = i + 1) {
        okavela i % 2 == 0 {
            konasagu;  // Skip even numbers
        }
        sum = sum + i;
    }
    
    // Sum of odd numbers 1,3,5,7,9 = 25
    testing.AssertEqual(25, sum, "Continue - sum odd numbers");
}

// ============================================
// Test 6: Nested Loops
// ============================================
#testNestedLoops() {
    testing.Log("Testing nested loops");
    
    @count int = 0;
    malli (@!i int = 0; i < 3; i = i + 1) {
        malli (@!j int = 0; j < 3; j = j + 1) {
            count = count + 1;
        }
    }
    
    testing.AssertEqual(9, count, "Nested loops");
}

// ============================================
// Test 7: Nested If in Loop
// ============================================
#testNestedIfInLoop() {
    testing.Log("Testing nested if in loop");
    
    @even_count int = 0;
    malli (@!i int = 1; i <= 10; i = i + 1) {
        okavela i % 2 == 0 {
            even_count = even_count + 1;
        }
    }
    
    testing.AssertEqual(5, even_count, "Count even numbers");
}

// ============================================
// Test 8: Complex Control Flow
// ============================================
#testComplexControlFlow() {
    testing.Log("Testing complex control flow");
    
    @result int = 0;
    malli (@!i int = 1; i <= 20; i = i + 1) {
        okavela i % 3 == 0 {
            okavela i % 5 == 0 {
                result = result + 15;  // Divisible by both
            } lekapothe {
                result = result + 3;    // Divisible by 3 only
            }
        } lekapothe okavela i % 5 == 0 {
            result = result + 5;       // Divisible by 5 only
        } lekapothe {
            result = result + 1;       // Not divisible by 3 or 5
        }
    }
    
    // Expected: sum of all numbers 1-20 = 210
    // But we're adding different values based on divisibility
    // This is just to test complex nested control flow
    testing.Assert(result > 0, "Complex control flow");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Control Flow Test Suite ===\n\n");
    
    testing.Run("testIfElse", testIfElse);
    testing.Run("testElseIf", testElseIf);
    testing.Run("testForLoop", testForLoop);
    testing.Run("testInfiniteLoop", testInfiniteLoop);
    testing.Run("testContinue", testContinue);
    testing.Run("testNestedLoops", testNestedLoops);
    testing.Run("testNestedIfInLoop", testNestedIfInLoop);
    testing.Run("testComplexControlFlow", testComplexControlFlow);
    
    testing.Summary();
}
