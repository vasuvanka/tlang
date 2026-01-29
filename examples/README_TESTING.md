# Tlang Testing Library

The `testing` library provides unit testing functionality similar to Go's testing package.

## Functions

### Test Execution

- **`testing.Run(name, testFunc)`** - Run a test function
  - `name`: Test name (string)
  - `testFunc`: Function pointer to test function
  - Returns: 0 on success, 1 on failure

### Assertions

- **`testing.Assert(condition, message)`** - Assert that condition is true
  - `condition`: Boolean condition (int: 1 = true, 0 = false)
  - `message`: Optional error message (string)

- **`testing.AssertEqual(expected, actual, message)`** - Assert two integers are equal
  - `expected`: Expected integer value
  - `actual`: Actual integer value
  - `message`: Optional error message

- **`testing.AssertEqualFloat(expected, actual, epsilon, message)`** - Assert two floats are equal
  - `expected`: Expected float value
  - `actual`: Actual float value
  - `epsilon`: Tolerance for comparison
  - `message`: Optional error message

- **`testing.AssertEqualString(expected, actual, message)`** - Assert two strings are equal
  - `expected`: Expected string
  - `actual`: Actual string
  - `message`: Optional error message

### Test Control

- **`testing.Fail(message)`** - Mark test as failed
  - `message`: Error message

- **`testing.Skip(message)`** - Skip the current test
  - `message`: Skip reason

- **`testing.Log(message)`** - Log a message during test
  - `message`: Log message

### Test Information

- **`testing.GetFailed()`** - Get number of failed assertions in current test
  - Returns: Number of failed assertions

- **`testing.Summary()`** - Print test summary
  - Prints total tests, passed, failed, and overall result

## Example Usage

```tl
// Test function
#test_Addition() {
    @result int = 2 + 2;
    testing.AssertEqual(4, result, "2 + 2 should equal 4");
}

#test_String() {
    @text string = "Hello";
    @upper string = strings.ToUpper(text);
    testing.AssertEqualString("HELLO", upper, "ToUpper test");
}

#prarambham() {
    testing.Run("test_Addition", test_Addition);
    testing.Run("test_String", test_String);
    testing.Summary();
}
```

## Running Tests

```bash
# Compile and run test file
tlang test test_example.tl

# Or manually
tlangc test_example.tl test.c
gcc -o test test.c -lm
./test
```

## Test Output

Tests produce output like:

```
=== Running Tests ===

RUN   test_Addition
PASS  test_Addition
RUN   test_String
PASS  test_String

=== Test Summary ===
Total tests: 2
Passed: 2
Failed: 0
RESULT: PASSED
```
