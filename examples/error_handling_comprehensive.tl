// Comprehensive error handling examples
// Demonstrates all error handling patterns in Tlang. Use errors.New() and okavela err != sunyam.

@fmt = #dhimpu("std/fmt");
@errors = #dhimpu("std/errors");

// ============================================
// Pattern 1: Function returning only error
// ============================================
#validateAge(age int) error {
    okavela age < 0 {
        mallinchu errors.New("age cannot be negative");
    }
    okavela age > 150 {
        mallinchu errors.New("age is too large");
    }
    mallinchu sunyam;  // No error
}

// ============================================
// Pattern 2: Error checking with if-else
// ============================================
#processUser(age int) {
    @err error = validateAge(age);
    okavela err != sunyam {
        fmt.Printf("Validation failed: %s\n", err);
        mallinchu;  // Early return
    } lekapothe {
        fmt.Printf("Age %d is valid\n", age);
    }
}

// ============================================
// Pattern 3: Error creation and assignment
// ============================================
#createError() error {
    @msg string = "custom error message";
    @err error = errors.New(msg);
    mallinchu err;
}

// ============================================
// Pattern 4: Nil check
// ============================================
#checkNil() {
    @err error = sunyam;
    okavela err == sunyam {
        fmt.Printf("Error is nil (no error)\n");
    }
    okavela err != sunyam {
        fmt.Printf("Error is not nil\n");
    }
}

// ============================================
// Pattern 5: Error propagation (manual)
// ============================================
#readFile(filename string) error {
    // Simulate file read
    okavela filename == "" {
        mallinchu errors.New("filename cannot be empty");
    }
    // In real implementation, would check if file exists
    mallinchu sunyam;
}

#processFile(filename string) error {
    @err error = readFile(filename);
    okavela err != sunyam {
        mallinchu err;  // Propagate error
    }
    // Process file here
    mallinchu sunyam;
}

// ============================================
// Pattern 6: Multiple error checks
// ============================================
#validateUser(name string, age int) error {
    okavela name == "" {
        mallinchu errors.New("name cannot be empty");
    }
    @err error = validateAge(age);
    okavela err != sunyam {
        mallinchu err;
    }
    mallinchu sunyam;
}

// ============================================
// Pattern 7: Error in conditional
// ============================================
#safeDivide(a int, b int) error {
    okavela b == 0 {
        mallinchu errors.New("division by zero");
    }
    @result int = a / b;
    fmt.Printf("Result: %d\n", result);
    mallinchu sunyam;
}

#prarambham() {
    fmt.Printf("=== Comprehensive Error Handling Examples ===\n\n");
    
    // Test 1: Basic error validation
    fmt.Printf("--- Test 1: Age Validation ---\n");
    @err1 error = validateAge(25);
    okavela err1 != sunyam {
        fmt.Printf("Error: %s\n", err1);
    } lekapothe {
        fmt.Printf("Age 25 is valid\n");
    }
    
    @err2 error = validateAge(-5);
    okavela err2 != sunyam {
        fmt.Printf("Error: %s\n", err2);
    }
    
    fmt.Printf("\n");
    
    // Test 2: Error propagation
    fmt.Printf("--- Test 2: Error Propagation ---\n");
    @err3 error = processFile("data.txt");
    okavela err3 != sunyam {
        fmt.Printf("File processing failed: %s\n", err3);
    } lekapothe {
        fmt.Printf("File processed successfully\n");
    }
    
    @err4 error = processFile("");
    okavela err4 != sunyam {
        fmt.Printf("File processing failed: %s\n", err4);
    }
    
    fmt.Printf("\n");
    
    // Test 3: Multiple validations
    fmt.Printf("--- Test 3: Multiple Validations ---\n");
    @err5 error = validateUser("Alice", 30);
    okavela err5 != sunyam {
        fmt.Printf("Validation failed: %s\n", err5);
    } lekapothe {
        fmt.Printf("User validated successfully\n");
    }
    
    @err6 error = validateUser("", 30);
    okavela err6 != sunyam {
        fmt.Printf("Validation failed: %s\n", err6);
    }
    
    fmt.Printf("\n");
    
    // Test 4: Nil checks
    fmt.Printf("--- Test 4: Nil Checks ---\n");
    checkNil();
    
    @err7 error = createError();
    okavela err7 != sunyam {
        fmt.Printf("Created error: %s\n", err7);
    }
    
    fmt.Printf("\n");
    
    // Test 5: Safe operations
    fmt.Printf("--- Test 5: Safe Operations ---\n");
    @err8 error = safeDivide(10, 2);
    okavela err8 != sunyam {
        fmt.Printf("Division failed: %s\n", err8);
    }
    
    @err9 error = safeDivide(10, 0);
    okavela err9 != sunyam {
        fmt.Printf("Division failed: %s\n", err9);
    }
    
    fmt.Printf("\n=== Error Handling Examples Complete ===\n");
}
