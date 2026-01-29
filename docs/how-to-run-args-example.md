# How to Run args_example.tl

This guide shows you how to compile and run the `args_example.tl` program with command-line arguments.

## Quick Start

### Method 1: Using `tlang run` (Recommended)

The easiest way is to use the `tlang run` command, which compiles and runs in one step:

```bash
# Navigate to examples directory
cd examples

# Run with arguments
tlang run args_example.tl --help

# Or with multiple arguments
tlang run args_example.tl arg1 arg2 arg3

# Or with --version flag
tlang run args_example.tl --version
```

**Note:** The `tlang run` command automatically passes all arguments after the filename to the compiled program.

### Method 2: Compile to Executable (Recommended for Distribution)

For production use, compile to an executable binary that you can distribute:

Compile directly to an executable binary:

```bash
# Navigate to examples directory
cd examples

# Compile to executable (output name is optional)
tlang compile args_example.tl args_example

# Or let it auto-generate name (removes .tl extension)
tlang compile args_example.tl

# Run the executable with arguments
./args_example --help
./args_example arg1 arg2 arg3
./args_example --version
```

**Windows (PowerShell):**
```powershell
cd examples
tlang compile args_example.tl args_example.exe
# Or auto-generate name
tlang compile args_example.tl

.\args_example.exe --help
.\args_example.exe arg1 arg2 arg3
.\args_example.exe --version
```

**Note:** The `tlang compile` command now directly produces an executable binary. It automatically:
1. Compiles Tlang to C (temporary file)
2. Compiles C to binary with OpenSSL support
3. Cleans up the temporary C file

## Expected Output

### Running with `--help`:
```
Program: ./args_example
Number of arguments: 2

Arguments:
  [0] ./args_example
  [1] --help

Usage: ./args_example [options]
Options:
  --help    Show this help message
  --version Show version information
```

### Running with `--version`:
```
Program: ./args_example
Number of arguments: 2

Arguments:
  [0] ./args_example
  [1] --version

Tlang version 0.1.0
```

### Running with regular arguments:
```
Program: ./args_example
Number of arguments: 4

Arguments:
  [0] ./args_example
  [1] arg1
  [2] arg2
  [3] arg3
```

## Troubleshooting

### Error: "tlang: command not found"
Make sure Tlang is installed and in your PATH:
```bash
# Check installation
tlang version

# If not found, add to PATH or use full path
/path/to/tlang/bin/tlang run args_example.tl --help
```

### Error: "gcc: command not found"
Install a C compiler:
- **Linux:** `sudo apt-get install gcc` (Debian/Ubuntu) or `sudo yum install gcc` (RHEL/CentOS)
- **macOS:** Install Xcode Command Line Tools: `xcode-select --install`
- **Windows:** Install MinGW or use MSVC

### Missing imports error
Make sure the file has the required imports:
```tl
samooham adhi;

dhimpu "fmt";
dhimpu "args";
dhimpu "strings";
```

## See Also

- [args library documentation](../docs/libraries/args.md) - Complete args library reference
- [Getting Started Guide](../docs/getting-started.md) - General Tlang usage
- [Examples README](../examples/README.md) - More examples
