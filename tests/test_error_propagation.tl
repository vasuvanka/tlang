// Tests for error propagation with ? operator
// Covers: @x = f()?, f()? as statement, chained propagation

@fmt = #dhimpu("std/fmt");
@testing = #dhimpu("std/testing");

// Helper: returns (int, string) - value and error
#safeDivide(a int, b int) (int, string) {
    okavela b == 0 {
        mallinchu (0, "division by zero");
    }
    mallinchu (a / b, sunyam);
}

// Wrapper that propagates error - returns (0, "division by zero") when called with 0
#expectError() (int, string) {
    @_ int = safeDivide(10, 0)?;
    mallinchu (0, sunyam);
}

// Statement-level ? then return
#stmtPropSuccess() (int, string) {
    safeDivide(8, 4)?;
    mallinchu (2, sunyam);
}

// Statement-level ? - error case
#stmtPropError() (int, string) {
    safeDivide(8, 0)?;
    mallinchu (0, sunyam);
}

// Chained propagation
#computeQuotient(num int, denom int) (int, string) {
    @q int = safeDivide(num, denom)?;
    mallinchu (q, sunyam);
}

#testChainedProp() {
    testing.Log("Testing error propagation with ?");
    
    // Test 1: Single variable with ? - success
    @r int = safeDivide(10, 2)?;
    testing.AssertEqual(5, r, "Single var ? success");
    
    // Test 2: Single variable with ? - error propagation (captured via wrapper)
    @t (int, string) = expectError();
    testing.Assert(t.field1 != sunyam, "Error propagated from single var ?");
    
    // Test 3: Statement-level ? - success
    @t2 (int, string) = stmtPropSuccess();
    testing.AssertEqual(2, t2.field0, "Stmt ? success");
    testing.Assert(t2.field1 == sunyam, "No error");
    
    // Test 4: Statement-level ? - error propagation
    @t3 (int, string) = stmtPropError();
    testing.Assert(t3.field1 != sunyam, "Error propagated from stmt ?");
    
    // Test 5: Chained propagation - success
    @q int = computeQuotient(21, 3)?;
    testing.AssertEqual(7, q, "Chained propagation success");
    
    // Test 6: Chained propagation - error
    @t4 (int, string) = computeQuotient(21, 0);
    testing.Assert(t4.field1 != sunyam, "Error propagated through chain");
}

// ============================================
// Main test runner
// ============================================
#prarambham() {
    fmt.Printf("=== Error Propagation Test Suite ===\n\n");
    
    testing.Run("testChainedProp", testChainedProp);
    
    testing.Summary();
}
