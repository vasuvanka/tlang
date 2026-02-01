// Package import with alias example

@fmt = #dhimpu("std/fmt");
@u = #dhimpu("./utils");  // Import with alias

#prarambham() {
    fmt.Printf("=== Package Alias Example ===\n\n");
    
    // Use functions from utils package with alias
    @numbers []int = {10, 20, 30, 40, 50};
    
    // Use alias 'u' instead of 'utils'
    @total int = u.sum(numbers);
    fmt.Printf("Sum of numbers: %d\n", total);
    
    @maxVal int = u.max(numbers);
    fmt.Printf("Maximum value: %d\n", maxVal);
    
    fmt.Printf("\n=== Package Alias Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.34s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_alias_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\./utils.tl:1:1: Error parsing package './utils': Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\./utils.tl:11:32: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_alias_example.tl` (exit code: 1)
//
