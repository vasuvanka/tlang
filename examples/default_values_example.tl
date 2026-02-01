// Default values example - variables initialize with defaults if no value provided

@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("=== Default Values Example ===\n\n");
    
    // Integer defaults to 0
    @x int;
    fmt.Printf("int default: %d (expected: 0)\n", x);
    
    // Float defaults to 0.0
    @y float;
    fmt.Printf("float default: %.1f (expected: 0.0)\n", y);
    
    // String defaults to empty string
    @z string;
    fmt.Printf("string default: '%s' (expected: '')\n", z);
    @isEmpty int = (z == "");
    fmt.Printf("string is empty: %d (expected: 1)\n", isEmpty);
    
    // Bool defaults to false (0)
    @b bool;
    fmt.Printf("bool default: %d (expected: 0/false)\n", b);
    
    // Array defaults to all zeros
    @arr [5]int;
    fmt.Printf("array defaults: ");
    @i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("%d ", arr[i]);
    }
    fmt.Printf("(expected: 0 0 0 0 0)\n");
    
    // Float array defaults to all 0.0
    @farr [3]float;
    fmt.Printf("float array defaults: ");
    @j int = 0;
    malli j < 3; j = j + 1 {
        fmt.Printf("%.1f ", farr[j]);
    }
    fmt.Printf("(expected: 0.0 0.0 0.0)\n");
    
    // String array defaults to all empty strings
    @sarr [2]string;
    fmt.Printf("string array[0]: '%s' (expected: '')\n", sarr[0]);
    fmt.Printf("string array[1]: '%s' (expected: '')\n", sarr[1]);
    
    // Variables with explicit values still work
    @initialized int = 42;
    fmt.Printf("initialized int: %d (expected: 42)\n", initialized);
    
    // Type inference still works
    @inferred = 100;
    fmt.Printf("inferred int: %d (expected: 100)\n", inferred);
    
    // No type, no value - defaults to int with 0
    @defaulted;
    fmt.Printf("no type, no value: %d (expected: 0)\n", defaulted);
    
    fmt.Printf("\n=== Default Values Example Complete ===\n");
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\default_values_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\default_values_example.tl:32:21: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   32 |     malli i < 5; i = i + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\default_values_example.tl` (exit code: 1)
//
