# Tlang Standard Library Test Suite

This directory contains comprehensive test cases for all Tlang standard library functions.

## Test Files

### Comprehensive Tests
- **`test_all_libs.tl`** - Complete test suite covering all libraries in one file

### Individual Library Tests
- **`test_fmt.tl`** - Tests for `fmt` library (Printf, Sprintf)
- **`test_strings.tl`** - Tests for `strings` library (Contains, HasPrefix, HasSuffix, Index, ToUpper, ToLower, TrimSpace)
- **`test_math.tl`** - Tests for `math` library (constants, arithmetic, trigonometric, rounding functions)
- **`test_strconv.tl`** - Tests for `strconv` library (Atoi, Itoa, ParseFloat, FormatFloat, ParseBool, FormatBool)
- **`test_os.tl`** - Tests for `os` library (Getenv, Setenv, Getwd)
- **`test_time.tl`** - Tests for `time` library (Now, Format, Parse, Sleep, SleepMilliseconds)
- **`test_filepath.tl`** - Tests for `filepath` library (Join, Base, Dir, Ext, Clean, Abs, Split, IsAbs)
- **`test_io.tl`** - Tests for `io` library (ReadFile, WriteFile, Exists, IsDir, Stat, Mkdir, ReadDir, Rename, Remove)
- **`test_json.tl`** - Tests for `json` library (Marshal, Unmarshal)

## Running Tests

### Run All Tests
```bash
cargo run -- examples/test_all_libs.tl
```

### Run Individual Library Tests
```bash
# Test fmt library
cargo run -- examples/test_fmt.tl

# Test strings library
cargo run -- examples/test_strings.tl

# Test math library
cargo run -- examples/test_math.tl

# Test strconv library
cargo run -- examples/test_strconv.tl

# Test os library
cargo run -- examples/test_os.tl

# Test time library
cargo run -- examples/test_time.tl

# Test filepath library
cargo run -- examples/test_filepath.tl

# Test io library
cargo run -- examples/test_io.tl

# Test json library
cargo run -- examples/test_json.tl
```

## Test Coverage

### fmt Library
- ✅ `fmt.Printf` - Formatted printing with various format specifiers
- ✅ `fmt.Sprintf` - Formatted string generation

### strings Library
- ✅ `strings.Contains` - Substring checking (including edge cases)
- ✅ `strings.HasPrefix` - Prefix checking
- ✅ `strings.HasSuffix` - Suffix checking
- ✅ `strings.Index` - Substring index finding
- ✅ `strings.ToUpper` - Uppercase conversion
- ✅ `strings.ToLower` - Lowercase conversion
- ✅ `strings.TrimSpace` - Whitespace trimming

### math Library
- ✅ Constants: `math.Pi`, `math.E`
- ✅ Basic operations: `math.Abs`, `math.Max`, `math.Min`
- ✅ Powers and roots: `math.Sqrt`, `math.Pow`
- ✅ Exponentials and logarithms: `math.Exp`, `math.Log`, `math.Log10`
- ✅ Trigonometric: `math.Sin`, `math.Cos`, `math.Tan`
- ✅ Inverse trigonometric: `math.Asin`, `math.Acos`, `math.Atan`
- ✅ Rounding: `math.Ceil`, `math.Floor`, `math.Round`, `math.Trunc`

### strconv Library
- ✅ `strconv.Atoi` - String to integer conversion
- ✅ `strconv.Itoa` - Integer to string conversion
- ✅ `strconv.ParseFloat` - String to float conversion
- ✅ `strconv.FormatFloat` - Float to string conversion
- ✅ `strconv.ParseBool` - String to boolean conversion
- ✅ `strconv.FormatBool` - Boolean to string conversion

### os Library
- ✅ `os.Getenv` - Get environment variables
- ✅ `os.Setenv` - Set environment variables
- ✅ `os.Getwd` - Get current working directory
- ⚠️ `os.Chdir` - Change directory (tested carefully to avoid breaking environment)
- ⚠️ `os.Exit` - Exit program (not tested as it would terminate)

### time Library
- ✅ `time.Now` - Get current Unix timestamp
- ✅ `time.Format` - Format timestamp to string with various formats
- ✅ `time.Parse` - Parse time string to Unix timestamp
- ✅ `time.Sleep` - Sleep for seconds
- ✅ `time.SleepMilliseconds` - Sleep for milliseconds

### filepath Library
- ✅ `filepath.Join` - Join path components (including chaining)
- ✅ `filepath.Base` - Get filename from path
- ✅ `filepath.Dir` - Get directory from path
- ✅ `filepath.Ext` - Get file extension
- ✅ `filepath.Clean` - Clean path (remove .., .)
- ✅ `filepath.Abs` - Get absolute path
- ✅ `filepath.Split` - Split directory and file
- ✅ `filepath.IsAbs` - Check if path is absolute

### io Library
- ✅ `io.ReadFile` - Read entire file as string
- ✅ `io.WriteFile` - Write string to file
- ✅ `io.ReadDir` - Read directory contents
- ✅ `io.Mkdir` - Create directory
- ✅ `io.Remove` - Remove file or directory
- ✅ `io.Rename` - Rename/move file
- ✅ `io.Exists` - Check if file/directory exists
- ✅ `io.IsDir` - Check if path is directory
- ✅ `io.Stat` - Get file information

### json Library
- ✅ `json.Marshal` - Encode values to JSON (string, int, float, bool)
- ✅ `json.Unmarshal` - Decode JSON to values
- ✅ Round-trip testing (marshal then unmarshal)

## Test Features

### Edge Cases
All test files include edge case testing:
- Empty strings
- Zero values
- Negative values
- Boundary conditions
- Invalid inputs

### Cross-Platform Compatibility
Tests are designed to work on both Windows and Unix-like systems:
- Path separators are handled automatically
- Environment variables are platform-agnostic
- File operations work cross-platform

### Cleanup
IO tests automatically clean up test files and directories after execution.

## Notes

- Some tests (like `os.Chdir` and `os.Exit`) are not fully tested to avoid breaking the test environment
- Array-based tests (for `sort` library) are noted but not implemented until array support is added
- HTTP library tests are minimal as the implementation is currently a placeholder
- Bytes library tests are limited as they require special length parameter handling

## Expected Output

Each test file prints:
1. Library name being tested
2. Function name and input
3. Actual result
4. Expected result (where applicable)

Example:
```
=== strings Library Tests ===
Contains('Hello'): 1
Contains('World'): 1
Contains('xyz'): 0
...
```

## Contributing

When adding new library functions:
1. Add test cases to the appropriate test file
2. Include edge cases and error conditions
3. Update this README with new test coverage
4. Ensure tests clean up any created files/directories
