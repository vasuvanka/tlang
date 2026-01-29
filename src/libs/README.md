# Tlang Standard Library

This directory contains ported functions from Go's standard library, adapted for Tlang.

## Available Libraries

### ✅ fmt - Formatting and I/O
- `fmt_Printf` - Formatted printing with format specifiers
- `fmt_Sprintf` - Returns formatted string

**Example:**
```tl
#prarambham() {
    fmt_Printf("Number: %d, Float: %f\n", 42, 3.14);
    @result string = fmt_Sprintf("Value: %d", 100);
}
```

### ✅ strings - String Operations
- `strings_Contains` - Check if string contains substring
- `strings_HasPrefix` - Check if string has prefix
- `strings_HasSuffix` - Check if string has suffix
- `strings_Index` - Find index of substring
- `strings_ToUpper` - Convert to uppercase
- `strings_ToLower` - Convert to lowercase
- `strings_TrimSpace` - Remove leading/trailing whitespace

**Example:**
```tl
#prarambham() {
    @text string = "Hello World";
    @upper string = strings_ToUpper(text);
    @hasHello int = strings_Contains(text, "Hello");
}
```

### ✅ math - Mathematical Functions
- Constants: `math_Pi()`, `math_E()`
- Basic: `math_Abs`, `math_Max`, `math_Min`
- Powers: `math_Sqrt`, `math_Pow`, `math_Exp`
- Logarithms: `math_Log`, `math_Log10`
- Trigonometry: `math_Sin`, `math_Cos`, `math_Tan`, `math_Asin`, `math_Acos`, `math_Atan`
- Rounding: `math_Ceil`, `math_Floor`, `math_Round`, `math_Trunc`

**Example:**
```tl
#prarambham() {
    @sqrt float = math_Sqrt(16.0);
    @power float = math_Pow(2.0, 3.0);
    @pi float = math_Pi();
}
```

### ✅ strconv - String Conversions
- `strconv_Atoi` - String to int
- `strconv_Itoa` - Int to string
- `strconv_ParseFloat` - String to float
- `strconv_FormatFloat` - Float to string
- `strconv_ParseBool` - String to bool
- `strconv_FormatBool` - Bool to string

**Example:**
```tl
#prarambham() {
    @num int = strconv_Atoi("123");
    @str string = strconv_Itoa(456);
}
```

### ✅ os - Operating System Interface
- `os_Getenv` - Get environment variable
- `os_Setenv` - Set environment variable
- `os_Exit` - Exit program with status code
- `os_Getwd` - Get current working directory
- `os_Chdir` - Change directory

**Example:**
```tl
#prarambham() {
    @home string = os_Getenv("HOME");
    @cwd string = os_Getwd();
}
```

### ✅ time - Time Operations
- `time_Now` - Current time as Unix timestamp
- `time_Sleep` - Sleep for seconds
- `time_SleepMilliseconds` - Sleep for milliseconds
- `time_Format` - Format Unix timestamp to string
- `time_Parse` - Parse time string to Unix timestamp

**Example:**
```tl
#prarambham() {
    @now long = time_Now();
    @formatted string = time_Format(now, "%Y-%m-%d %H:%M:%S");
}
```

### ✅ bytes - Byte Operations
- `bytes_Contains` - Check if bytes contain subslice
- `bytes_Index` - Find index of subslice
- `bytes_Equal` - Compare two byte slices

**Example:**
```tl
#prarambham() {
    @data string = "Hello";
    @found int = bytes_Contains(data, 5, "ell", 3);
}
```

### ✅ sort - Sorting
- `sort_Ints` - Sort integer array
- `sort_Float64s` - Sort float array
- `sort_Strings` - Sort string array

**Example:**
```tl
#prarambham() {
    @arr[5] int = {3, 1, 4, 1, 5};
    sort_Ints(arr, 5);
}
```

### ✅ encoding/json - JSON
- `json_Marshal` - Encode value to JSON string (basic types)
- `json_Unmarshal` - Decode JSON string to value (basic types)

**Example:**
```tl
#prarambham() {
    @json string = json_Marshal("string", "Hello");
}
```

### ⚠️ net/http - HTTP (Placeholder)
- `http_Get` - HTTP GET request (placeholder)
- `http_Post` - HTTP POST request (placeholder)
- `http_ListenAndServe` - HTTP server (placeholder)

**Note:** HTTP functions are placeholders and require full socket implementation.

## Usage

All library functions are automatically available in Tlang programs. They are implemented as C runtime functions and included in the generated code.

**Important:** Function names use underscore notation (e.g., `fmt_Printf`, not `fmt.Printf`). Dot notation is not yet supported by the parser.

## Function Naming Convention

All library functions follow the pattern: `library_FunctionName`

- `fmt_Printf` (not `fmt.Printf`)
- `math_Sqrt` (not `math.Sqrt`)
- `strings_ToUpper` (not `strings.ToUpper`)
- `os_Getenv` (not `os.Getenv`)

This matches the C function naming convention used in the generated code.

## Platform Support

- **Windows**: Uses Windows API for os functions
- **Unix/Linux/Mac**: Uses POSIX functions
- All other libraries use standard C library functions

## See Also

- `libs/STATUS.md` - Detailed implementation status
- `examples/stdlib_example.tl` - Example usage
