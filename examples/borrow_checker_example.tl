// Borrow Checker Example
// Demonstrates Tlang's ownership and borrowing system

@fmt = #dhimpu("std/fmt");

// Helper function that borrows data immutably
#printValue(value *int) {
    fmt.Printf("Value: %d\n", *value);
}

// Helper function that borrows data mutably
#incrementValue(value *int) {
    *value = *value + 1;
}

#prarambham() {
    fmt.Printf("=== Borrow Checker Example ===\n\n");
    
    // ========================================
    // 1. Basic Ownership
    // ========================================
    fmt.Printf("1. Basic Ownership:\n");
    
    // Immutable variable (default)
    @x int = 42;
    fmt.Printf("   Immutable x = %d\n", x);
    
    // Mutable variable
    @!y int = 10;
    fmt.Printf("   Mutable y = %d\n", y);
    y = 20;
    fmt.Printf("   After mutation: y = %d\n", y);
    
    // ========================================
    // 2. Immutable Borrowing
    // ========================================
    fmt.Printf("\n2. Immutable Borrowing:\n");
    
    @data int = 100;
    
    // Multiple immutable borrows are allowed
    @ref1 *int = &data;
    @ref2 *int = &data;
    
    fmt.Printf("   Original: %d\n", data);
    fmt.Printf("   Via ref1: %d\n", *ref1);
    fmt.Printf("   Via ref2: %d\n", *ref2);
    
    // Using borrowed values in functions
    printValue(&data);
    
    // ========================================
    // 3. Mutable Borrowing
    // ========================================
    fmt.Printf("\n3. Mutable Borrowing:\n");
    
    @!counter int = 0;
    fmt.Printf("   Before: counter = %d\n", counter);
    
    // Mutable borrow to modify
    incrementValue(&mut counter);
    fmt.Printf("   After increment: counter = %d\n", counter);
    
    incrementValue(&mut counter);
    incrementValue(&mut counter);
    fmt.Printf("   After 2 more: counter = %d\n", counter);
    
    // ========================================
    // 4. Copy Types
    // ========================================
    fmt.Printf("\n4. Copy Types (no move):\n");
    
    // Primitives are Copy types
    @a int = 5;
    @b int = a;  // a is copied, not moved
    fmt.Printf("   a = %d, b = %d (both valid)\n", a, b);
    
    @f1 float = 3.14;
    @f2 float = f1;  // f1 is copied
    fmt.Printf("   f1 = %.2f, f2 = %.2f (both valid)\n", f1, f2);
    
    @flag1 bool = true;
    @flag2 bool = flag1;  // flag1 is copied
    fmt.Printf("   flag1 = %d, flag2 = %d (both valid)\n", flag1, flag2);
    
    // ========================================
    // 5. Scope and Lifetime
    // ========================================
    fmt.Printf("\n5. Scope and Lifetime:\n");
    
    @outer int = 999;
    {
        // Inner scope
        @innerRef *int = &outer;  // OK: outer lives longer
        fmt.Printf("   Inner scope can borrow outer: %d\n", *innerRef);
        
        @innerVal int = 123;
        // innerVal will be dropped at end of this scope
    }
    // outer still valid
    fmt.Printf("   Outer still valid after inner scope: %d\n", outer);
    
    // ========================================
    // 6. Practical Example: Accumulator
    // ========================================
    fmt.Printf("\n6. Practical Example - Accumulator:\n");
    
    @!sum int = 0;
    @values [5]int = {1, 2, 3, 4, 5};
    
    @i int = 0;
    malli i < 5; i = i + 1 {
        // Borrow sum mutably to add
        @ref *int = &mut sum;
        *ref = *ref + values[i];
    }
    fmt.Printf("   Sum of [1,2,3,4,5] = %d\n", sum);
    
    fmt.Printf("\n=== Example Complete ===\n");
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\borrow_checker_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\borrow_checker_example.tl:15:13: Left side of assignment must be an identifier or member access
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   15 |     *value = *value + 1;
//    |    ^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\borrow_checker_example.tl` (exit code: 1)
//
