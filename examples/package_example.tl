// Package and import example

@fmt = #dhimpu("std/fmt");
@utils = #dhimpu("./utils");

#prarambham() {
    fmt.Printf("=== Package and Import Example ===\n\n");
    
    // Use functions from utils package
    @numbers []int = {10, 20, 30, 40, 50};
    
    fmt.Printf("Numbers: ");
    @i int = 0;
    malli i < len(numbers); i = i + 1 {
        fmt.Printf("%d ", numbers[i]);
    }
    fmt.Printf("\n\n");
    
    @total int = utils.sum(numbers);
    fmt.Printf("Sum of numbers: %d\n", total);
    
    @maxVal int = utils.max(numbers);
    fmt.Printf("Maximum value: %d\n", maxVal);
    
    @minVal int = utils.min(numbers);
    fmt.Printf("Minimum value: %d\n", minVal);
    
    @avg float = utils.average(numbers);
    fmt.Printf("Average: %.2f\n", avg);
    
    fmt.Printf("\n=== Package Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_example.tl:16:32: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   16 |     malli i < len(numbers); i = i + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_example.tl` (exit code: 1)
//
