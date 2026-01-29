# flag - Command-Line Flag Parsing Library

The `flag` library provides command-line flag parsing, similar to Go's flag package.

## Functions

### Defining Flags

**`flag.String(name, default, usage)`** - Define string flag

- `name`: Flag name (without `-`)
- `default`: Default value (string)
- `usage`: Usage description
- Returns: Default value (call before `flag.Parse()`)

**Example:**
```tl
@name string = flag.String("name", "Guest", "User name");
flag.Parse();
@value string = flag.GetString("name");
```

**`flag.Int(name, default, usage)`** - Define integer flag

- `name`: Flag name (without `-`)
- `default`: Default value (int)
- `usage`: Usage description
- Returns: Default value (call before `flag.Parse()`)

**Example:**
```tl
@port int = flag.Int("port", 8080, "Server port");
flag.Parse();
@value int = flag.GetInt("port");
```

**`flag.Bool(name, default, usage)`** - Define boolean flag

- `name`: Flag name (without `-`)
- `default`: Default value (1 for true, 0 for false)
- `usage`: Usage description
- Returns: Default value (call before `flag.Parse()`)

**Example:**
```tl
@debug int = flag.Bool("debug", 0, "Enable debug mode");
flag.Parse();
@value int = flag.GetBool("debug");
```

**`flag.Float64(name, default, usage)`** - Define float flag

- `name`: Flag name (without `-`)
- `default`: Default value (float)
- `usage`: Usage description
- Returns: Default value (call before `flag.Parse()`)

**Example:**
```tl
@price float = flag.Float64("price", 9.99, "Product price");
flag.Parse();
@value float = flag.GetFloat64("price");
```

### Parsing Flags

**`flag.Parse()`** - Parse command-line arguments

- Must be called after defining all flags
- Parses command-line arguments and sets flag values

**Example:**
```tl
@name string = flag.String("name", "Guest", "User name");
@port int = flag.Int("port", 8080, "Server port");
flag.Parse();  // Parse arguments
```

### Getting Flag Values

**`flag.GetString(name)`** - Get string flag value

- `name`: Flag name
- Returns: Flag value as string

**`flag.GetInt(name)`** - Get integer flag value

- `name`: Flag name
- Returns: Flag value as integer

**`flag.GetBool(name)`** - Get boolean flag value

- `name`: Flag name
- Returns: Flag value (1 or 0)

**`flag.GetFloat64(name)`** - Get float flag value

- `name`: Flag name
- Returns: Flag value as float

### Non-Flag Arguments

**`flag.Args()`** - Get non-flag arguments

- Returns: Newline-separated string of non-flag arguments

**Example:**
```tl
flag.Parse();
@args string = flag.Args();
// args contains all arguments that weren't flags
```

## Usage Patterns

### Basic Flag Parsing

```tl
#prarambham() {
    // Define flags
    @name string = flag.String("name", "Guest", "User name");
    @age int = flag.Int("age", 25, "User age");
    @debug int = flag.Bool("debug", 0, "Enable debug mode");
    
    // Parse arguments
    flag.Parse();
    
    // Get values
    @nameValue string = flag.GetString("name");
    @ageValue int = flag.GetInt("age");
    @debugValue int = flag.GetBool("debug");
    
    fmt.Printf("Name: %s, Age: %d, Debug: %d\n", nameValue, ageValue, debugValue);
}
```

**Run:**
```bash
./program -name=Alice -age=30 -debug
```

### Flag Formats

Flags can be specified in multiple formats:

```bash
# With equals sign
./program -name=Alice -port=8080

# With space (next argument)
./program -name Alice -port 8080

# Boolean flags (no value needed)
./program -debug -verbose
```

### Non-Flag Arguments

```tl
#prarambham() {
    @name string = flag.String("name", "Guest", "User name");
    flag.Parse();
    
    @args string = flag.Args();
    fmt.Printf("Non-flag arguments:\n%s\n", args);
}
```

**Run:**
```bash
./program -name=Alice file1.txt file2.txt
```

**Output:**
```
Non-flag arguments:
file1.txt
file2.txt
```

### Server Configuration Example

```tl
#prarambham() {
    @host string = flag.String("host", "localhost", "Server host");
    @port int = flag.Int("port", 8080, "Server port");
    @debug int = flag.Bool("debug", 0, "Enable debug mode");
    @timeout int = flag.Int("timeout", 30, "Request timeout");
    
    flag.Parse();
    
    @hostValue string = flag.GetString("host");
    @portValue int = flag.GetInt("port");
    @debugValue int = flag.GetBool("debug");
    @timeoutValue int = flag.GetInt("timeout");
    
    fmt.Printf("Starting server on %s:%d\n", hostValue, portValue);
    okavela debugValue == 1 {
        fmt.Printf("Debug mode enabled\n");
    }
    fmt.Printf("Timeout: %d seconds\n", timeoutValue);
}
```

**Run:**
```bash
./server -host=0.0.0.0 -port=9090 -debug -timeout=60
```

## Notes

- Flags must be defined **before** calling `flag.Parse()`
- Flag names should not include the `-` prefix
- Boolean flags can be set by just including `-flag` (no value needed)
- Non-flag arguments are available via `flag.Args()`
- Default values are used if flags are not provided
- Maximum 64 flags can be defined
- Maximum 128 non-flag arguments supported

## See Also

- [args Library](args.md) - Basic command-line arguments
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
