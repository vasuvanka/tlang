// Mutable variables example (@!)
// Demonstrates mutable variables and assignments

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Mutable Variables Example ===\n\n");
    
    // Immutable variable (default)
    @x int = 10;
    fmt.Printf("Immutable x = %d\n", x);
    
    // Cannot reassign immutable variable:
    // x = 20;  // ERROR: Cannot assign to variable 'x': variables are immutable by default
    
    // Mutable variable with @!
    @!counter int = 0;
    fmt.Printf("Mutable counter = %d\n", counter);
    
    // Can reassign mutable variable
    counter = 10;
    fmt.Printf("After assignment: counter = %d\n", counter);
    
    // Increment mutable variable
    counter = counter + 1;
    fmt.Printf("After increment: counter = %d\n", counter);
    
    // Loop with mutable counter
    fmt.Printf("\n--- Loop with Mutable Counter ---\n");
    @!i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("  i = %d\n", i);
    }
    
    // Accumulator pattern
    fmt.Printf("\n--- Accumulator Pattern ---\n");
    @!sum int = 0;
    @numbers [5]int = {1, 2, 3, 4, 5};
    @j int = 0;
    malli j < 5; j = j + 1 {
        sum = sum + numbers[j];
    }
    fmt.Printf("Sum of numbers = %d\n", sum);
    
    // Mutable string
    fmt.Printf("\n--- Mutable String ---\n");
    @!message string = "Hello";
    fmt.Printf("Initial: %s\n", message);
    message = "Hello, Tlang!";
    fmt.Printf("After assignment: %s\n", message);
    
    // Comparison: Immutable vs Mutable
    fmt.Printf("\n--- Immutable vs Mutable ---\n");
    @immutableValue int = 42;  // Never changes
    @!mutableValue int = 42;  // Can change
    
    fmt.Printf("Immutable: %d (cannot change)\n", immutableValue);
    fmt.Printf("Mutable: %d\n", mutableValue);
    
    mutableValue = 100;
    fmt.Printf("Mutable after change: %d\n", mutableValue);
    fmt.Printf("Immutable still: %d\n", immutableValue);
    
    fmt.Printf("\n=== Mutable Variables Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_example.tl:42:21: Cannot assign to variable 'j': variables are immutable by default. Use '@!j' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   42 |     malli j < 5; j = j + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\mutable_example.tl` (exit code: 1)
//
