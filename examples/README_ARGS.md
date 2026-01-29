# Tlang Command-Line Arguments

The `args` library provides access to command-line arguments, similar to Go's `os.Args`.

## Functions

- **`args.Count()`** - Get number of command-line arguments
  - Returns: Integer count (includes program name as arg[0])

- **`args.Get(index)`** - Get argument at index
  - `index`: Argument index (0 = program name, 1 = first argument, etc.)
  - Returns: String value of argument, or empty string if index is invalid

- **`args.Program()`** - Get program name (equivalent to args.Get(0))
  - Returns: String program name

## Example Usage

```tl
#prarambham() {
    @argCount int = args.Count();
    @programName string = args.Program();
    
    fmt.Printf("Program: %s\n", programName);
    fmt.Printf("Arguments: %d\n", argCount);
    
    @i int = 0;
    malli i = 0; i < argCount; i = i + 1 {
        fmt.Printf("  [%d] %s\n", i, args.Get(i));
    }
}
```

## Running with Arguments

```bash
# Compile
tlang compile args_example.tl

# Compile C to binary
gcc -o args_example args_example.c -lm

# Run with arguments
./args_example arg1 arg2 arg3

# Or using tlang run
tlang run args_example.tl arg1 arg2 arg3
```

## Output Example

```
Program: ./args_example
Arguments: 4
  [0] ./args_example
  [1] arg1
  [2] arg2
  [3] arg3
```

## Common Patterns

### Check for help flag

```tl
ayithe args.Count() > 1 {
    @firstArg string = args.Get(1);
    ayithe strings.Contains(firstArg, "--help") {
        fmt.Printf("Usage: %s [options]\n", args.Program());
        os.Exit(0);
    }
}
```

### Process flags

```tl
@i int = 1;
malli i = 1; i < args.Count(); i = i + 1 {
    @arg string = args.Get(i);
    ayithe strings.HasPrefix(arg, "--") {
        // Process flag
        fmt.Printf("Flag: %s\n", arg);
    } lekapothe {
        // Process positional argument
        fmt.Printf("Argument: %s\n", arg);
    }
}
```
