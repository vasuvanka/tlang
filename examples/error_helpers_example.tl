// Error handling with helper functions example
// Demonstrates using errors library for better error handling

@fmt = #dhimpu("std/fmt");
@errors = #dhimpu("std/errors");

// ============================================
// Using errors.New to create errors
// ============================================
#validateInput(value int) error {
    okavela value < 0 {
        mallinchu errors.New("value cannot be negative");
    }
    okavela value > 100 {
        mallinchu errors.New("value cannot exceed 100");
    }
    mallinchu sunyam;
}

// ============================================
// Using errors.Errorf for formatted errors
// ============================================
#processValue(value int) error {
    okavela value < 0 {
        @msg string = fmt.Sprintf("invalid value: %d (must be >= 0)", value);
        mallinchu errors.New(msg);
    }
    mallinchu sunyam;
}

// ============================================
// Using errors.Wrap to add context
// ============================================
#readConfig(filename string) error {
    okavela filename == "" {
        mallinchu errors.New("filename cannot be empty");
    }
    // Simulate file read error
    @err error = errors.New("file not found");
    okavela err != sunyam {
        // Wrap error with context
        mallinchu errors.Wrap(err, "failed to read config");
    }
    mallinchu sunyam;
}

// ============================================
// Using errors.IsNil for nil checks
// ============================================
#checkError(err error) {
    okavela errors.IsNil(err) == 0 {
        fmt.Printf("Error occurred: %s\n", err);
    } lekapothe {
        fmt.Printf("No error\n");
    }
}

#prarambham() {
    fmt.Printf("=== Error Helpers Example ===\n\n");
    
    // Test 1: errors.New
    fmt.Printf("--- Test 1: errors.New ---\n");
    @err1 error = validateInput(50);
    checkError(err1);
    
    @err2 error = validateInput(-5);
    checkError(err2);
    
    fmt.Printf("\n");
    
    // Test 2: errors.Errorf (via fmt.Sprintf)
    fmt.Printf("--- Test 2: Formatted Errors ---\n");
    @err3 error = processValue(42);
    checkError(err3);
    
    @err4 error = processValue(-10);
    checkError(err4);
    
    fmt.Printf("\n");
    
    // Test 3: errors.Wrap
    fmt.Printf("--- Test 3: Error Wrapping ---\n");
    @err5 error = readConfig("config.txt");
    checkError(err5);
    
    @err6 error = readConfig("");
    checkError(err6);
    
    fmt.Printf("\n");
    
    // Test 4: errors.IsNil
    fmt.Printf("--- Test 4: errors.IsNil ---\n");
    @err7 error = sunyam;
    okavela errors.IsNil(err7) == 1 {
        fmt.Printf("Error is nil (no error)\n");
    }
    
    @err8 error = errors.New("test error");
    okavela errors.IsNil(err8) == 0 {
        fmt.Printf("Error is not nil: %s\n", err8);
    }
    
    fmt.Printf("\n=== Error Helpers Example Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.26s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\error_helpers_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\error_helpers_example.tl:12:32: Expected type (int, float, string, bool, struct, interface, jatha[key]value, *type, or [N]type)
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   12 | #validateInput(value int) error {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\error_helpers_example.tl` (exit code: 1)
//
