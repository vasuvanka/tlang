# testing/benchmark - Benchmarking Library

The `testing/benchmark` library provides benchmarking functionality to measure code performance, similar to Go's `testing/benchmark` package.

## Functions

### Starting and Stopping Benchmarks

**`benchmark.Start(name)`** - Start a benchmark

- `name`: Benchmark name (string)
- Starts timing the benchmark

**Example:**
```tl
benchmark.Start("my_operation");
// ... code to benchmark ...
@duration float = benchmark.Stop("my_operation");
```

**`benchmark.Stop(name)`** - Stop benchmark and return duration

- `name`: Benchmark name (string)
- Returns: Duration in seconds (float)
- Returns -1.0 if benchmark not found or not running

**Example:**
```tl
benchmark.Start("calculation");
@result int = expensive_calculation();
@duration float = benchmark.Stop("calculation");
fmt.Printf("Took %.6f seconds\n", duration);
```

### Reporting

**`benchmark.Report(name)`** - Report benchmark results

- `name`: Benchmark name (string)
- Prints benchmark name and duration

**Example:**
```tl
benchmark.Start("test");
// ... code ...
benchmark.Stop("test");
benchmark.Report("test");  // Prints: BENCHMARK test: 0.123456 seconds
```

**`benchmark.Reset(name)`** - Reset benchmark

- `name`: Benchmark name (string)
- Resets benchmark state

**Example:**
```tl
benchmark.Reset("my_benchmark");
```

### Getting Duration

**`benchmark.GetDuration(name)`** - Get current duration without stopping

- `name`: Benchmark name (string)
- Returns: Current duration in seconds (float)
- Does not stop the benchmark

**Example:**
```tl
benchmark.Start("long_operation");
// ... some work ...
@elapsed float = benchmark.GetDuration("long_operation");
fmt.Printf("Elapsed: %.6f seconds\n", elapsed);
// ... continue work ...
@total float = benchmark.Stop("long_operation");
```

## Common Patterns

### Simple Benchmark

```tl
benchmark.Start("operation");
// Code to benchmark
@result int = perform_operation();
@duration float = benchmark.Stop("operation");
fmt.Printf("Operation took %.6f seconds\n", duration);
```

### Multiple Benchmarks

```tl
benchmark.Start("operation1");
operation1();
@d1 float = benchmark.Stop("operation1");

benchmark.Start("operation2");
operation2();
@d2 float = benchmark.Stop("operation2");

fmt.Printf("Operation 1: %.6f seconds\n", d1);
fmt.Printf("Operation 2: %.6f seconds\n", d2);
```

### Comparing Performance

```tl
// Benchmark algorithm A
benchmark.Start("algorithm_a");
@result_a int = algorithm_a();
@time_a float = benchmark.Stop("algorithm_a");

// Benchmark algorithm B
benchmark.Start("algorithm_b");
@result_b int = algorithm_b();
@time_b float = benchmark.Stop("algorithm_b");

fmt.Printf("Algorithm A: %.6f seconds\n", time_a);
fmt.Printf("Algorithm B: %.6f seconds\n", time_b);
okavela time_a < time_b {
    fmt.Printf("Algorithm A is faster\n");
} lekapothe {
    fmt.Printf("Algorithm B is faster\n");
}
```

## Notes

- Benchmarks use `clock()` from `<time.h>` for timing
- Duration is returned in seconds as a float
- Maximum 100 concurrent benchmarks
- Benchmarks are identified by name (string)
- Use unique names for different benchmarks

## See Also

- [testing Library](testing.md) - Unit testing framework
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
