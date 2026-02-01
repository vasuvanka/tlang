// Benchmarking example
// Demonstrates testing/benchmark library

@fmt = #dhimpu("std/fmt");
@benchmark = #dhimpu("std/benchmark");

#fibonacci(n int) int {
    okavela n <= 1 {
        mallinchu n;
    }
    mallinchu fibonacci(n - 1) + fibonacci(n - 2);
}

#prarambham() {
    fmt.Printf("=== Benchmarking Examples ===\n\n");
    
    // Benchmark fibonacci calculation
    benchmark.Start("fibonacci_10");
    @result1 int = fibonacci(10);
    @duration1 float = benchmark.Stop("fibonacci_10");
    fmt.Printf("Fibonacci(10) = %d\n", result1);
    fmt.Printf("Duration: %.6f seconds\n", duration1);
    benchmark.Report("fibonacci_10");
    
    fmt.Printf("\n");
    
    // Benchmark larger calculation
    benchmark.Start("fibonacci_20");
    @result2 int = fibonacci(20);
    @duration2 float = benchmark.Stop("fibonacci_20");
    fmt.Printf("Fibonacci(20) = %d\n", result2);
    fmt.Printf("Duration: %.6f seconds\n", duration2);
    benchmark.Report("fibonacci_20");
    
    fmt.Printf("\n");
    
    // Get duration without stopping
    benchmark.Start("test_benchmark");
    @i int = 0;
    malli i < 1000; i = i + 1 {
        @sum int = i + i;
    }
    @current_duration float = benchmark.GetDuration("test_benchmark");
    fmt.Printf("Current duration: %.6f seconds\n", current_duration);
    @final_duration float = benchmark.Stop("test_benchmark");
    fmt.Printf("Final duration: %.6f seconds\n", final_duration);
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
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\benchmark_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\benchmark_example.tl:42:24: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   42 |     malli i < 1000; i = i + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\benchmark_example.tl` (exit code: 1)
//
