# Getting Started with Tlang

This guide will help you get started with Tlang, from installation to writing your first program.

## Table of Contents

1. [Installation](#installation)
2. [Your First Program](#your-first-program)
3. [Compiling and Running](#compiling-and-running)
4. [Understanding the Basics](#understanding-the-basics)
5. [Next Steps](#next-steps)

## Installation

### Prerequisites

- **Rust**: Tlang compiler is written in Rust. Install from [rustup.rs](https://rustup.rs/)
- **C Compiler**: Tlang compiles to C, so you need a C compiler:
  - **Linux**: `gcc` (usually pre-installed)
  - **macOS**: `clang` (comes with Xcode Command Line Tools)
  - **Windows**: MinGW or Visual Studio Build Tools

### Installing Tlang

#### Linux/macOS

```bash
# Clone the repository
git clone https://github.com/yourusername/tlang.git
cd tlang

# Build the compiler
cargo build --release

# Install (optional)
./install.sh
```

#### Windows

```powershell
# Clone the repository
git clone https://github.com/yourusername/tlang.git
cd tlang

# Build the compiler
cargo build --release

# Install (optional)
.\install.ps1
```

### Verify Installation

After installation, verify Tlang is working:

```bash
tlang --version
# or
tlangc --version
```

## Your First Program

Create a file named `hello.tl`:

```tl
#prarambham() {
    fmt.Printf("Hello, World!\n");
}
```

### Understanding the Code

- `#prarambham()` - Entry point function (like `main` in other languages)
- `fmt.Printf()` - Formatted print function from the standard library
- `\n` - Newline character

### Compile and Run

```bash
# Compile directly to executable
tlang compile hello.tl

# Run
./hello
# Output: Hello, World!
```

Or use the `tlang run` command:

```bash
# Explicit file
tlang run hello.tl

# Auto-detect entry file (prarambham.tl, main.tl, or from config.toml)
tlang run
```

## Compiling and Running

### Basic Compilation

Compile directly to an executable binary:

```bash
tlang compile program.tl program
./program
```

Or let it auto-generate the output name (removes .tl extension):

```bash
tlang compile program.tl
./program
```

### Using the tlang Wrapper

The `tlang` command provides convenient shortcuts:

```bash
# Compile and run (explicit file)
tlang run program.tl

# Compile and run (auto-detect entry file)
tlang run

# Compile to executable
tlang compile program.tl

# Run tests
tlang test
```

## Understanding the Basics

### Variables

Declare variables with `@`:

```tl
@x int = 10;
@name string = "Tlang";
@pi float = 3.14;
```

Type inference works too:

```tl
@x = 10;        // Inferred as int
@y = 3.14;      // Inferred as float
@z = "hello";   // Inferred as string
```

### Functions

Declare functions with `#`:

```tl
#greet(name string) {
    fmt.Printf("Hello, %s!\n", name);
}

#prarambham() {
    greet("World");
}
```

### Control Flow

**Conditional statements:**

```tl
@age int = 18;
okavela age >= 18 {
    fmt.Printf("Adult\n");
} lekapothe {
    fmt.Printf("Minor\n");
}
```

**Loops:**

```tl
@i int = 0;
malli i < 10; i = i + 1 {
    fmt.Printf("%d\n", i);
}
```

### Output

Use `fmt.Printf` for formatted output:

```tl
@name string = "Tlang";
@version int = 1;
fmt.Printf("Welcome to %s v%d!\n", name, version);
```

## Next Steps

1. **Learn the Language**: Follow the [Tutorial](tutorial.md) for step-by-step learning
2. **Explore Examples**: Check the `examples/` directory
3. **Read the Reference**: See [Language Reference](language-reference.md)
4. **Use Libraries**: Explore the [Standard Library](standard-library.md)

## Common Issues

### "Command not found: tlang"

- Make sure you've run the install script
- Check that `~/.local/bin` (Linux) or the install directory (Windows) is in your PATH

### "gcc: command not found" or "No C compiler found"

- **Windows:** Install MinGW - see [Installing MinGW](install-mingw.md) guide
- **Linux:** Install gcc:
  - Debian/Ubuntu: `sudo apt-get install gcc`
  - Fedora: `sudo dnf install gcc`
  - Arch: `sudo pacman -S gcc`
- **macOS:** Install Xcode Command Line Tools: `xcode-select --install`
  - macOS: Install Xcode Command Line Tools
  - Windows: Install MinGW or Visual Studio Build Tools

### Compilation Errors

- Check your syntax matches the examples
- Ensure all library functions use dot notation (e.g., `fmt.Printf`)
- See [Error Handling](error-handling.md) for debugging tips

## Resources

- **Examples**: See `examples/` directory in the repository
- **Language Reference**: [Language Reference](language-reference.md)
- **Standard Library**: [Standard Library Overview](standard-library.md)
- **Community**: Check the main repository for discussions

Happy coding with Tlang! 🚀
