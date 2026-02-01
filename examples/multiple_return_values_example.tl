// Multiple Return Values and Error Propagation Example
// Demonstrates Go-style (value, error) returns and error propagation

@fmt = #dhimpu("std/fmt");
@errors = #dhimpu("std/errors");

// Function with multiple return values: (int, error)
#divide(a int, b int) (int, error) {
    okavela b == 0 {
        mallinchu (0, errors.New("division by zero"));
    }
    mallinchu (a / b, sunyam);
}

// Function using error propagation
#safeDivide(a int, b int) (int, error) {
    // Use error propagation: if divide fails, automatically return error
    @result, @err (int, error) = divide(a, b)?;
    // If we get here, no error occurred
    mallinchu (result, sunyam);
}

#prarambham() {
    fmt.Printf("=== Multiple Return Values Example ===\n\n");
    
    // ============================================
    // Test 1: Multiple Return Values
    // ============================================
    fmt.Printf("--- Test 1: Multiple Return Values ---\n");
    @result, @err (int, error) = divide(10, 2);
    okavela err != sunyam {
        fmt.Printf("Error: %s\n", err);
    } lekapothe {
        fmt.Printf("Result: %d\n", result);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: Error Case
    // ============================================
    fmt.Printf("--- Test 2: Error Case ---\n");
    @result2, @err2 (int, error) = divide(10, 0);
    okavela err2 != sunyam {
        fmt.Printf("Error: %s\n", err2);
    } lekapothe {
        fmt.Printf("Result: %d\n", result2);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 3: Error Propagation
    // ============================================
    fmt.Printf("--- Test 3: Error Propagation ---\n");
    @result3, @err3 (int, error) = safeDivide(20, 4);
    okavela err3 != sunyam {
        fmt.Printf("Error: %s\n", err3);
    } lekapothe {
        fmt.Printf("Result: %d\n", result3);
    }
    
    fmt.Printf("\n=== Multiple Return Values Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\multiple_return_values_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\multiple_return_values_example.tl:10:34: Expected type (int, float, string, bool, struct, interface, jatha[key]value, *type, or [N]type)
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   10 | #divide(a int, b int) (int, error) {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\multiple_return_values_example.tl` (exit code: 1)
//
