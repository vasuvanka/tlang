// Comprehensive Mutable Variables Example
// Demonstrates all aspects of @!(mutable variables) in Tlang

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Comprehensive Mutable Variables Example ===\n\n");
    
    // ============================================
    // 1. Basic Mutable Variable Declaration
    // ============================================
    fmt.Printf("--- 1. Basic Mutable Variables ---\n");
    
    @immutableValue int = 10;      // Immutable - cannot be reassigned
    @!mutableValue int = 20;    // Mutable - can be reassigned
    
    fmt.Printf("Immutable: %d\n", immutableValue);
    fmt.Printf("Mutable: %d\n", mutableValue);
    
    // immutableValue = 30;  // ERROR: Cannot assign to immutable variable
    mutableValue = 30;  // OK: Mutable variable can be reassigned
    fmt.Printf("Mutable after assignment: %d\n", mutableValue);
    
    // ============================================
    // 2. Mutable Variables in Loops
    // ============================================
    fmt.Printf("\n--- 2. Mutable Variables in Loops ---\n");
    
    // Loop counter must be mutable
    @!i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("  Loop iteration: %d\n", i);
    }
    
    // Accumulator pattern
    @!sum int = 0;
    @numbers [5]int = {1, 2, 3, 4, 5};
    @!j int = 0;
    malli j < 5; j = j + 1 {
        sum = sum + numbers[j];
    }
    fmt.Printf("Sum of numbers: %d\n", sum);
    
    // ============================================
    // 3. Mutable Strings
    // ============================================
    fmt.Printf("\n--- 3. Mutable Strings ---\n");
    
    @!message string = "Hello";
    fmt.Printf("Initial: %s\n", message);
    message = "Hello, Tlang!";
    fmt.Printf("After assignment: %s\n", message);
    
    // ============================================
    // 4. Mutable Arrays and Slices
    // ============================================
    fmt.Printf("\n--- 4. Mutable Arrays and Slices ---\n");
    
    @!arr [5]int = {1, 2, 3, 4, 5};
    fmt.Printf("Array before: ");
    @!k int = 0;
    malli k < 5; k = k + 1 {
        fmt.Printf("%d ", arr[k]);
    }
    fmt.Printf("\n");
    
    // Modify array elements (array itself is mutable)
    arr[0] = 10;
    arr[1] = 20;
    fmt.Printf("Array after modification: ");
    @!l int = 0;
    malli l < 5; l = l + 1 {
        fmt.Printf("%d ", arr[l]);
    }
    fmt.Printf("\n");
    
    // Mutable slice
    @!slice []int = {10, 20, 30};
    fmt.Printf("Slice before: length=%d\n", len(slice));
    @!newSlice []int = append(slice, 40);
    fmt.Printf("Slice after append: length=%d\n", len(newSlice));
    
    // ============================================
    // 5. Mutable Maps
    // ============================================
    fmt.Printf("\n--- 5. Mutable Maps ---\n");
    
    @!scores jatha[string]int;
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    fmt.Printf("Alice's score: %d\n", scores["Alice"]);
    
    // Modify map entry
    scores["Alice"] = 100;
    fmt.Printf("Alice's updated score: %d\n", scores["Alice"]);
    
    // ============================================
    // 6. Mutable Struct Fields
    // ============================================
    fmt.Printf("\n--- 6. Mutable Structs ---\n");
    
    nirmanam Counter {
        @!value int;
        @!name string;
    }
    
    @!counter Counter = Counter{value: 0, name: "main"};
    fmt.Printf("Counter: %s = %d\n", counter.name, counter.value);
    
    counter.value = counter.value + 1;
    counter.name = "updated";
    fmt.Printf("Counter after update: %s = %d\n", counter.name, counter.value);
    
    // ============================================
    // 7. Scope and Shadowing
    // ============================================
    fmt.Printf("\n--- 7. Scope and Shadowing ---\n");
    
    @!outer int = 100;
    fmt.Printf("Outer scope mutable: %d\n", outer);
    
    okavela outer > 50 {
        // Inner scope can have its own mutable variable
        @!inner int = 200;
        fmt.Printf("Inner scope mutable: %d\n", inner);
        
        // Can modify outer scope mutable variable
        outer = 150;
        fmt.Printf("Modified outer from inner: %d\n", outer);
    }
    
    fmt.Printf("Outer after if block: %d\n", outer);
    
    // ============================================
    // 8. When to Use @!
    // ============================================
    fmt.Printf("\n--- 8. When to Use @!---\n");
    
    // ✅ Use @!for:
    // - Loop counters
    @!loopCounter int = 0;
    
    // - Accumulators
    @!total int = 0;
    
    // - State that changes
    @!gameScore int = 0;
    @!currentLevel int = 1;
    
    // - Buffers being modified
    @!buffer []byte;
    
    // ❌ Don't use @!for:
    // - Constants (use regular @ variables)
    @PI float = 3.14159;
    
    // - Values that don't change
    @userName string = "Alice";  // Immutable is fine
    
    // - Function parameters (immutable by default)
    // - Read-only data
    
    fmt.Printf("Game score: %d, Level: %d\n", gameScore, currentLevel);
    fmt.Printf("PI constant: %f\n", PI);
    fmt.Printf("User name: %s\n", userName);
    
    // ============================================
    // 9. Error: Assigning to Immutable
    // ============================================
    fmt.Printf("\n--- 9. Immutable Assignment Error ---\n");
    
    @readOnly int = 42;
    fmt.Printf("Read-only value: %d\n", readOnly);
    
    // The following would cause a compile error:
    // readOnly = 100;  // ERROR: Cannot assign to variable 'readOnly': variables are immutable by default
    
    // Solution: Use a new variable or make it mutable
    @newValue int = 100;
    fmt.Printf("New value: %d\n", newValue);
    
    // Or if you need to change it:
    @!changeable int = 42;
    changeable = 100;
    fmt.Printf("Changeable value: %d\n", changeable);
    
    fmt.Printf("\n=== Comprehensive Mutable Variables Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.34s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_comprehensive_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_comprehensive_example.tl:70:13: Left side of assignment must be an identifier or member access
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   70 |     arr[0] = 10;
//    |    ^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_comprehensive_example.tl` (exit code: 1)
//
