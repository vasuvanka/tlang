// Error handling example
// Demonstrates error type and sunyam (nil). Use errors.New() to create errors; check with okavela err != sunyam.

@fmt = #dhimpu("std/fmt");
@errors = #dhimpu("std/errors");

#divide(a int, b int) error {
    okavela b == 0 {
        mallinchu errors.New("division by zero");
    }
    mallinchu sunyam;
}

#prarambham() {
    fmt.Printf("=== Error Handling Examples ===\n\n");
    
    // Test division
    @err error = divide(10, 2);
    okavela err != sunyam {
        fmt.Printf("Error: %s\n", err);
    } lekapothe {
        fmt.Printf("Division successful (no error)\n");
    }
    
    // Test error case
    @err2 error = divide(10, 0);
    okavela err2 != sunyam {
        fmt.Printf("Caught error: %s\n", err2);
    }
    
    // Nil check
    @value string = sunyam;
    okavela value == sunyam {
        fmt.Printf("Value is nil (sunyam)\n");
    }
    
    // Create error
    @myError error = errors.New("something went wrong");
    fmt.Printf("Error message: %s\n", myError);
    
    // Check if error is nil
    okavela myError != sunyam {
        fmt.Printf("Error is not nil\n");
    }
}
