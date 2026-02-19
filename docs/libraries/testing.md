# testing - Unit Testing Library

The `testing` library provides a testing framework similar to Go's testing package.

## Functions

### Test Execution

**`testing.Run()`** - Run all tests

- Executes all test functions
- Returns: 1 if all tests passed, 0 if any failed

**Example:**
```tl
#prarambham() {
    @result int = testing.Run();
    okavela result == 1 {
        fmt.Printf("All tests passed!\n");
    } lekapothe {
        fmt.Printf("Some tests failed\n");
    }
}
```

### Assertions

**`testing.Assert(condition)`** - Assert condition is true

- `condition`: Boolean expression (1 or 0)
- Fails test if condition is false

**Example:**
```tl
#testAddition() {
    @result int = add(2, 3);
    testing.Assert(result == 5);
}
```

**`testing.AssertEqual(expected, actual)`** - Assert two values are equal

- `expected`: Expected value
- `actual`: Actual value
- Fails test if values differ

**Example:**
```tl
#testString() {
    @result string = strings.ToUpper("hello");
    testing.AssertEqual("HELLO", result);
}
```

**`testing.AssertEqualFloat(expected, actual, epsilon)`** - Assert floats are equal

- `expected`: Expected float value
- `actual`: Actual float value
- `epsilon`: Tolerance for comparison
- Fails test if difference exceeds epsilon

**Example:**
```tl
#testFloat() {
    @result float = math.Sqrt(16.0);
    testing.AssertEqualFloat(4.0, result, 0.001);
}
```

**`testing.AssertEqualString(expected, actual)`** - Assert strings are equal

- `expected`: Expected string
- `actual`: Actual string
- Fails test if strings differ

**Example:**
```tl
#testString() {
    @result string = strings.ToUpper("hello");
    testing.AssertEqualString("HELLO", result);
}
```

### Test Control

**`testing.Fail()`** - Mark test as failed

- Explicitly fail the current test

**Example:**
```tl
#testSomething() {
    okavela errorCondition {
        testing.Fail();
    }
}
```

**`testing.Skip()`** - Skip current test

- Skip the current test (doesn't count as failure)

**Example:**
```tl
#testPlatformSpecific() {
    okavela platform == "windows" {
        testing.Skip();
    }
    // Test code
}
```

### Test fixtures (setup / teardown)

**`testing.RegisterSetup(fn)`** - Run a function before each test

- `fn`: A function with no parameters and no return value (e.g. `#mySetup()`)
- Use for initializing shared state, opening resources, or resetting globals before every test

**`testing.RegisterTeardown(fn)`** - Run a function after each test

- `fn`: A function with no parameters and no return value (e.g. `#myTeardown()`)
- Use for cleaning up resources or resetting state after every test

Setup runs before each `testing.Run(...)` and teardown runs after. Only one setup and one teardown can be registered; calling Register again overwrites.

**Example:**
```tl
@!shared_count int = 0;

#setupFixture() {
    shared_count = 0;
}

#teardownFixture() {
    shared_count = 0;  // optional cleanup
}

#testOne() {
    testing.AssertEqual(0, shared_count, "setup reset");
    shared_count = shared_count + 1;
}

#prarambham() {
    testing.RegisterSetup(setupFixture);
    testing.RegisterTeardown(teardownFixture);
    testing.Run("testOne", testOne);
    testing.Summary();
}
```

See `tests/test_fixtures_example.tl` for a full example.

### Logging

**`testing.Log(message)`** - Log test message

- `message`: Message to log
- Only shown if test fails

**Example:**
```tl
#testSomething() {
    testing.Log("Testing addition");
    @result int = add(2, 3);
    testing.AssertEqual(5, result);
}
```

### Output format (TAP, dot, default)

**`testing.EnableTAP(on)`** - Use TAP (Test Anything Protocol) output

- `on`: 1 to enable, 0 for default. When enabled, prints `TAP version 13`, then `ok N - name` / `not ok N - name` per test, then `1..N` in Summary. Failure details are printed as `#` diagnostic lines. Useful for CI/parsing.

**`testing.SetDotMode(on)`** - Use dot output (compact)

- `on`: 1 to enable, 0 for default. When enabled, prints only `.` for each pass and `F` for each fail (no RUN/PASS/FAIL lines). Summary still prints at the end.

**Default format:** RUN / PASS / FAIL lines and structured failure output (e.g. `--- FAIL: testname`, then `message:`, `expected:`, `got:` on separate lines for AssertEqual).

**Example (TAP):**
```tl
#prarambham() {
    testing.EnableTAP(1);
    testing.Run("testFoo", testFoo);
    testing.Summary();  // prints 1..N
}
```

### Test Summary

**`testing.Summary()`** - Get test summary

- Returns: String with test summary (passed, failed, skipped counts)

**Example:**
```tl
#prarambham() {
    testing.Run();
    @summary string = testing.Summary();
    fmt.Printf("%s\n", summary);
}
```

**`testing.GetFailed()`** - Get list of failed tests

- Returns: Newline-separated string of failed test names

**Example:**
```tl
#prarambham() {
    testing.Run();
    @failed string = testing.GetFailed();
    okavela strings.Index(failed, "") > 0 {
        fmt.Printf("Failed tests:\n%s\n", failed);
    }
}
```

## Writing Tests

### Test Function Naming

Test functions should start with `test`:

```tl
#testAddition() {
    // Test code
}

#testStringOperations() {
    // Test code
}
```

### Example Test Suite

```tl
#testMath() {
    testing.Log("Testing math functions");
    @sqrt float = math.Sqrt(16.0);
    testing.AssertEqualFloat(4.0, sqrt, 0.001);
    
    @power float = math.Pow(2.0, 3.0);
    testing.AssertEqualFloat(8.0, power, 0.001);
}

#testStrings() {
    testing.Log("Testing string functions");
    @upper string = strings.ToUpper("hello");
    testing.AssertEqualString("HELLO", upper);
    
    @has int = strings.Contains("hello world", "world");
    testing.Assert(has == 1);
}

#prarambham() {
    @result int = testing.Run();
    @summary string = testing.Summary();
    fmt.Printf("%s\n", summary);
    
    okavela result == 0 {
        @failed string = testing.GetFailed();
        fmt.Printf("Failed tests:\n%s\n", failed);
        os.Exit(1);
    }
}
```

## Best Practices

1. **One assertion per test** - Keep tests focused
2. **Use descriptive names** - `testAddition` not `test1`
3. **Test edge cases** - Empty strings, zero values, etc.
4. **Use appropriate assertions** - `AssertEqualFloat` for floats
5. **Log context** - Use `testing.Log()` for debugging

## Running tests and benchmarks together

From the `tests/` directory you can run:

- **Tests only:** `./run_all_tests.sh` (Bash) or `run_all_tests.bat` (Windows)
- **Benchmarks only:** `./run_benchmarks.sh` or `run_benchmarks.bat` — runs programs that use `std/benchmark` (e.g. `bench_math.tl`, `examples/benchmark_example.tl`)
- **Tests then benchmarks:** `./run_tests_and_benchmarks.sh` or `run_tests_and_benchmarks.bat`

So `tlang test <file.tl>` runs a single file; the scripts above run the full test suite and/or benchmark suite.

## Test coverage

You can run the test suite with **line coverage** (gcov). The compiler emits `#line` directives so coverage reports can map back to `.tl` source.

- **Linux/macOS (Bash):** from the `tests/` directory run:
  ```bash
  ./run_tests_with_coverage.sh
  ```
- **Windows (CMD):** from the `tests/` directory run:
  ```bat
  run_tests_with_coverage.bat
  ```

Requirements: `gcc` with gcov (same as for normal builds). Output is written to `tests/coverage_out/`: `.gcov` files and a short summary (lines executed). Use `gcov` or `lcov`/`genhtml` for detailed or HTML reports.

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
