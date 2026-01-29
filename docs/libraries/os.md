# os - Operating System Interface Library

The `os` library provides operating system interface functions.

## Functions

### Environment Variables

**`os.Getenv(key)`** - Get environment variable

- `key`: Environment variable name
- Returns: Value of environment variable, or empty string if not set

**Example:**
```tl
@home string = os.Getenv("HOME");
@path string = os.Getenv("PATH");
fmt.Printf("Home: %s\n", home);
```

**`os.Setenv(key, value)`** - Set environment variable

- `key`: Environment variable name
- `value`: Value to set
- Returns: 1 on success, 0 on failure

**Example:**
```tl
@result int = os.Setenv("MY_VAR", "my_value");
okavela result == 1 {
    fmt.Printf("Environment variable set\n");
}
```

### Working Directory

**`os.Getwd()`** - Get current working directory

- Returns: Current working directory path

**Example:**
```tl
@cwd string = os.Getwd();
fmt.Printf("Current directory: %s\n", cwd);
```

**`os.Chdir(dir)`** - Change directory

- `dir`: Directory path to change to
- Returns: 1 on success, 0 on failure

**Example:**
```tl
@result int = os.Chdir("/tmp");
okavela result == 1 {
    fmt.Printf("Changed directory\n");
}
```

### Program Control

**`os.Exit(code)`** - Exit program with status code

- `code`: Exit status code (0 = success, non-zero = error)
- Program terminates immediately

**Example:**
```tl
okavela errorCondition {
    fmt.Printf("Error occurred\n");
    os.Exit(1);
}
```

## Common Patterns

### Check Environment Variable
```tl
@debug string = os.Getenv("DEBUG");
okavela strings.Contains(debug, "1") {
    fmt.Printf("Debug mode enabled\n");
}
```

### Get User Home Directory
```tl
@home string = os.Getenv("HOME");
@configPath string = filepath.Join(home, ".config", "app.conf");
```

### Exit on Error
```tl
@fileExists int = io.Exists("required.txt");
okavela fileExists == 0 {
    fmt.Printf("Required file not found\n");
    os.Exit(1);
}
```

## Platform Notes

- Environment variable names are case-sensitive on Unix, case-insensitive on Windows
- Paths use forward slashes on all platforms
- Exit codes: 0 = success, non-zero = error

## See Also

- [io Library](io.md) - File operations
- [filepath Library](filepath.md) - Path manipulation
- [Language Reference](../language-reference.md)
