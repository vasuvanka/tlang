# args - Command-Line Arguments Library

The `args` library provides access to command-line arguments.

## Functions

### Initialization

**`args.Init(argc, argv)`** - Initialize arguments (called automatically)

- `argc`: Argument count
- `argv`: Argument vector
- Called automatically in generated `main` function
- Usually not called manually

### Argument Access

**`args.Count()`** - Get number of arguments

- Returns: Number of command-line arguments (excluding program name)

**Example:**
```tl
#prarambham() {
    @count int = args.Count();
    fmt.Printf("Number of arguments: %d\n", count);
}
```

**`args.Get(index)`** - Get argument by index

- `index`: Argument index (0-based, 0 = first argument)
- Returns: Argument string, or empty string if index out of range

**Example:**
```tl
#prarambham() {
    @arg1 string = args.Get(0);  // First argument
    @arg2 string = args.Get(1);  // Second argument
    fmt.Printf("Arg 1: %s, Arg 2: %s\n", arg1, arg2);
}
```

**`args.Program()`** - Get program name

- Returns: Program name (first argument, argv[0])

**Example:**
```tl
#prarambham() {
    @prog string = args.Program();
    fmt.Printf("Program: %s\n", prog);
}
```

## Common Patterns

### Process All Arguments
```tl
#prarambham() {
    @count int = args.Count();
    @i int = 0;
    malli i < count; i = i + 1 {
        @arg string = args.Get(i);
        fmt.Printf("Argument %d: %s\n", i, arg);
    }
}
```

### Check for Required Arguments
```tl
#prarambham() {
    @count int = args.Count();
    okavela count < 1 {
        fmt.Printf("Usage: program <filename>\n");
        os.Exit(1);
    }
    @filename string = args.Get(0);
    // Process filename
}
```

### Parse Options
```tl
#prarambham() {
    @count int = args.Count();
    @i int = 0;
    malli i < count; i = i + 1 {
        @arg string = args.Get(i);
        okavela strings.HasPrefix(arg, "-") {
            // Handle option
            fmt.Printf("Option: %s\n", arg);
        } lekapothe {
            // Handle argument
            fmt.Printf("Argument: %s\n", arg);
        }
    }
}
```

### Get Program Name
```tl
#prarambham() {
    @prog string = args.Program();
    fmt.Printf("Running: %s\n", prog);
}
```

## Example Usage

```tl
#prarambham() {
    @prog string = args.Program();
    @count int = args.Count();
    
    fmt.Printf("Program: %s\n", prog);
    fmt.Printf("Arguments: %d\n", count);
    
    @i int = 0;
    malli i < count; i = i + 1 {
        @arg string = args.Get(i);
        fmt.Printf("  [%d] %s\n", i, arg);
    }
}
```

**Run:**
```bash
./program arg1 arg2 arg3
```

**Output:**
```
Program: ./program
Arguments: 3
  [0] arg1
  [1] arg2
  [2] arg3
```

## Notes

- Arguments are 0-indexed (first argument is index 0)
- Program name is available via `args.Program()`
- Empty string is returned for out-of-range indices
- Arguments are automatically initialized in `main` function

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
