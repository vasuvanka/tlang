# Compile Command - Generate Executable Binaries

## Overview

The compile command compiles Tlang source code to an executable binary in one step. Use `tlang compile` (if you have the `tlang` wrapper) or `tlangc compile`. A single command performs both steps:
1. Compiles Tlang → C (intermediate `.c` file)
2. Compiles C → Executable binary (invokes gcc/clang/MSVC)

## Usage

### Basic Syntax

```bash
tlang compile <input_file> [output_name]
# or
tlangc compile <input_file> [output_name]
```

### Examples

```bash
# Compile to default binary name (output.exe on Windows, output on Linux/macOS)
tlang compile program.tl
# or: tlangc compile program.tl

# Compile to custom binary name
tlang compile program.tl myapp
# or: tlangc compile program.tl myapp
# Creates myapp.exe (Windows) or myapp (Linux/macOS)
```

## How It Works

1. **Tlang → C**: Compiles your `.tl` file to C code
   - Intermediate C file: `output.c` (or `{output_name}.c` if specified)
   
2. **C → Binary**: Automatically compiles the C code to an executable
   - Binary: `output.exe` (Windows) or `output` (Linux/macOS)
   - Or: `{output_name}.exe` / `{output_name}` if specified

## Requirements

### C Compiler

The `compile` command requires a C compiler to be installed:

- **Linux/macOS**: `gcc` or `clang`
- **Windows**: `gcc`, `clang`, or `cl` (MSVC)

**Installation:**

- **Linux (Debian/Ubuntu)**: `sudo apt-get install gcc`
- **macOS**: `xcode-select --install` (includes clang)
- **Windows**: Install [MinGW-w64](https://www.mingw-w64.org/) or [MSVC Build Tools](https://visualstudio.microsoft.com/downloads/)

### OpenSSL (Optional)

If your program uses crypto/SSL libraries, OpenSSL development libraries are needed:

- **Linux**: `sudo apt-get install libssl-dev`
- **macOS**: `brew install openssl`
- **Windows**: Included with MinGW or MSVC

## Supported platforms

The binary produced by `tlang compile` runs on the **same platform** (and architecture) where you built it:

| Platform | Binary form | Notes |
|----------|-------------|--------|
| **Linux** | `./output` or `./myapp` (no extension) | Use `chmod +x` if needed. Built with gcc/clang on Linux. |
| **Windows** | `output.exe` or `myapp.exe` | Built with MinGW (gcc/clang) or MSVC (`cl`) on Windows. |
| **macOS** | `./output` or `./myapp` (no extension) | Built with clang (Xcode Command Line Tools) on macOS. Same architecture (x86_64 or arm64) as build. |

The executable is native to the host: build on Linux → runs on Linux; build on Windows → runs on Windows; build on macOS → runs on macOS. For **cross-compilation** (e.g. build on Linux for Windows) or **static binaries for distribution**, see [Zero-deps and cross-deploy](zero-deps-cross-deploy.md).

## Output Files

### Default Behavior

```bash
tlang compile program.tl
# or: tlangc compile program.tl
```

**Creates:**
- `output.c` - Intermediate C file (kept for debugging)
- `output.exe` (Windows) or `output` (Linux/macOS) - Executable binary

### Custom Output Name

```bash
tlang compile program.tl myapp
# or: tlangc compile program.tl myapp
```

**Creates:**
- `myapp.c` - Intermediate C file
- `myapp.exe` (Windows) or `myapp` (Linux/macOS) - Executable binary

## Error Handling

### Tlang source errors (syntax, type, imports)

When your Tlang source has a compile-time error (syntax, type, or import), the compiler stops and prints an error that includes:

- **File, line, and column** – e.g. `Parser Error at program.tl:3:5: unexpected token`
- **Message** – a short description of what went wrong (e.g. unexpected token, type mismatch, package not found)
- **Source snippet** – for parse/lex errors, the compiler also prints the offending line and a caret (`^`) under the column so you can fix it quickly

Example:

```
Parser Error at hello.tl:2:10: unexpected token

  2 | #prarambham() { x
    |          ^
```

Use the file and line number to open the right spot in your editor; the message and snippet tell you what to fix. For more on error types and the compile flow, see [Getting Started](getting-started.md).

### No C Compiler Found

If no C compiler is detected:

```
Warning: No C compiler found. C file generated but binary not compiled.
Install gcc, clang, or MSVC to compile to binary.
C file available at: output.c
```

**Solution**: Install a C compiler (see Requirements above)

### C Compilation Errors

If C compilation fails:

```
✗ C compilation failed:
[compiler error messages]

C file is available at: output.c
```

**Solution**: 
- Check the error messages
- The C file is preserved for debugging
- Fix issues in your Tlang code or C compiler setup

## Comparison with Other Commands

| Command | Output | Use Case |
|---------|--------|----------|
| `tlangc program.tl` | `output.c` | Generate C code only |
| `tlangc compile program.tl` | `output.exe` + `output.c` | Generate executable binary |
| `tlangc run program.tl` | `output.c` | Quick testing (C only) |
| `tlang build` | Binary in `target/` | Full project build with dependencies |

## Examples

### Example 1: Simple Program

```bash
# Compile hello.tl to executable
tlangc compile examples/hello.tl hello

# Run the executable
./hello.exe    # Windows
./hello        # Linux/macOS
```

### Example 2: With Arguments

```bash
# Compile args_example.tl
tlangc compile examples/args_example.tl args_example

# Run with arguments
./args_example.exe --help
./args_example.exe arg1 arg2 arg3
```

### Example 3: Default Output

```bash
# Compile without specifying output name
tlangc compile program.tl

# Creates: output.exe (or output on Linux/macOS)
./output.exe
```

## Compiler Detection

The `compile` command automatically detects available C compilers in this order:

1. **gcc** (GNU Compiler Collection)
2. **clang** (LLVM Compiler)
3. **cl** (Microsoft Visual C++ - Windows only)

The first available compiler is used.

## Compiler Flags

The compile command uses these flags:

- **Optimization**: `-O2` (speed optimization)
- **Math library**: `-lm` (linked automatically)
- **OpenSSL**: `-lssl -lcrypto` (if OpenSSL is used in code)
- **Output**: `-o {binary_name}`

## Troubleshooting

### "No C compiler found"

**Problem**: No C compiler is installed or not in PATH.

**Solution**:
1. Install a C compiler (gcc, clang, or MSVC)
2. Ensure it's in your system PATH
3. Verify with: `gcc --version` or `clang --version`

### "C compilation failed"

**Problem**: C code has errors or missing libraries.

**Common causes**:
- Missing OpenSSL libraries
- Syntax errors in generated C code
- Missing system libraries

**Solution**:
1. Check the error message for specific issues
2. Install missing libraries (e.g., `libssl-dev` on Linux)
3. Review the generated `output.c` file for issues

### Binary not executable

**Problem**: On Linux/macOS, binary might not have execute permissions.

**Solution**:
```bash
chmod +x output
./output
```

## Best Practices

1. **Use descriptive names**: `tlangc compile program.tl myapp` instead of default
2. **Keep C files**: The intermediate `.c` file is useful for debugging
3. **Test after compilation**: Always test your binary after compilation
4. **Use build system for projects**: For multi-file projects, use `tlang build`

## See Also

- [Getting Started](getting-started.md) - Basic compilation
- [Build System](build-system.md) - Full project builds
- [Development Guide](development.md) - Compiler development
