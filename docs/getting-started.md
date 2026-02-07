# Getting Started with Tlang

This guide will help you get started with Tlang, from installation to writing your first program.

## Table of Contents

1. [Installation](#installation)
2. [Your First Program](#your-first-program)
3. [Compiling and Running](#compiling-and-running)
4. [Understanding the Basics](#understanding-the-basics)
5. [Packages and Dependencies](#packages-and-dependencies)
6. [Next Steps](#next-steps)

## Installation

### Prerequisites

- **Rust**: Tlang compiler is written in Rust. Install from [rustup.rs](https://rustup.rs/)
- **C Compiler**: Tlang compiles to C, so you need a C compiler:
  - **Linux**: `gcc` (usually pre-installed)
  - **macOS**: `clang` (comes with Xcode Command Line Tools)
  - **Windows**: MinGW or Visual Studio Build Tools
- **OpenSSL** (for crypto in the standard library): development libraries per platform. **Windows**: [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html). **Linux/macOS**: see [Installation Guide](../README_INSTALL.md#installing-prerequisites) for package names (`libssl-dev`, `openssl-devel`, `brew install openssl`, etc.).

For full prerequisite install commands per platform, see the [Installation Guide](../README_INSTALL.md).

### Installing Tlang

#### One-line install (Linux/macOS, WSL)

You can install without cloning the repo first (rustup-style). Prerequisites: Rust, C compiler, OpenSSL dev libs (see above). The script clones the repo and runs the install (user install, no sudo).

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vasuvanka/tlang/main/install-curl.sh | sh
```

Use `--proto '=https'` and `--tlsv1.2` for a secure connection; you can open the URL in a browser to inspect the script before running. After install, add to PATH if needed: `export PATH="$PATH:$HOME/.local/bin"`. Verify with `tlang --version` or `tlangc --version`. **Windows:** use [install.ps1](../README_INSTALL.md) or build from source; curl-pipe install is for Linux/macOS/WSL only.

#### Linux/macOS (clone and install)

```bash
# Clone the repository
git clone https://github.com/vasuvanka/tlang.git
cd tlang

# Build the compiler
cargo build --release

# Install (optional)
./install.sh
```

#### Windows

```powershell
# Clone the repository
git clone https://github.com/vasuvanka/tlang.git
cd tlang

# Build the compiler
cargo build --release

# Install (optional)
.\install.ps1
```

#### Build from source only (no install script)

You can use the compiler without running any install script. After `cargo build --release`, the binary is at `target/release/tlangc` (Linux/macOS) or `target/release/tlangc.exe` (Windows). Run it from the project root (e.g. `./target/release/tlangc --version`), or add that directory to your PATH. To put the binary on your PATH without using the scripts, see the [Installation Guide](../README_INSTALL.md) “Manual Installation” section.

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
@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("Hello, World!\n");
}
```

### Understanding the Code

- `@fmt = #dhimpu("std/fmt");` - Import the standard library `fmt` package; use `fmt.Printf` in code
- `#prarambham()` - Entry point function (like `main` in other languages)
- `fmt.Printf()` - Formatted print from the standard library
- `\n` - Newline character

### Compile and Run

**Compile to a binary, then run it:**

```bash
tlang compile hello.tl hello
./hello
# Output: Hello, World!
# Windows: hello.exe
```

**Or use `tlang run` to compile, build, and run in one step:**

```bash
tlang run hello.tl
# Compiles to C, builds the binary, runs it. Output: Hello, World!
```

If your project has a `config.toml` with dependencies (HTTP or Git), `run` and `compile` automatically fetch missing packages into `dependencies/` before building (go get style). See [Packages and Dependencies](#packages-and-dependencies) and [Build System](build-system.md).

For more on run options (e.g. auto-detect entry file, passing arguments), see the [Run Guide](tlang-run-guide.md).

## Compiling and Running

### Basic Compilation

Compile directly to an executable binary:

```bash
tlang compile program.tl program
./program
```

Or use the default output name (binary is named `output` or `output.exe` on Windows):

```bash
tlang compile program.tl
./output
# Windows: output.exe
```

Verify the binary runs (e.g. produces expected output). If the compiler reports an error, it will show file, line, column, and a message (and a source snippet for syntax/parse errors); see [Compile Command – Tlang source errors](compile-command.md#tlang-source-errors-syntax-type-imports) for the format. For full compile options (default vs custom output name, C compiler requirements), see the [Compile Command](compile-command.md) guide. Both `tlang compile` and `tlangc compile` work.

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

**Run vs compile-then-run:** Use `tlang run` for quick development (compile + build + run in one step; no permanent binary by default). Use `tlang compile` when you want a persistent executable or to distribute it. Both commands automatically fetch remote dependencies from `config.toml` if present. The produced binary runs on the same platform where you built it (Linux, Windows, or macOS); see [Compile Command – Supported platforms](compile-command.md#supported-platforms) for details.

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

### Concurrency (channels, spawn, WaitGroup)

Tlang supports **channels** (CSP-style), **spawn** (run a function in a new OS thread), and **WaitGroup** (wait until N tasks finish). On Unix, spawn uses pthreads; on Windows it currently runs the function directly.

```tl
// Channels: create, send, receive, close
@ch channel[int];              // unbuffered
@ch2 channel[int] = 10;        // buffered, capacity 10
ch <- 42;
@x int = <- ch;
sunyam(ch);

// Spawn: run function in a new thread
tlang #worker(99);

// WaitGroup: wait until N tasks finish
@wg WaitGroup;
wg.Add(2);
tlang #task1(wg);   // task1 calls wg.Done() when done
tlang #task2(wg);   // task2 calls wg.Done() when done
wg.Wait();          // blocks until both done
```

See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md) for design and patterns.

### Packages and Dependencies

- **Imports:** Use `@alias = #dhimpu("path")` to import a package, then call `alias.Function()` or use `alias` types. Standard library: `@fmt = #dhimpu("std/fmt")`, `@math = #dhimpu("std/math")`, etc. Local or relative: `@utils = #dhimpu("./utils")`.
- **Projects with config.toml:** For multi-file or dependency-based projects, add a `config.toml` in the project root. List dependencies (path, HTTP, or Git). When you run `tlang run` or `tlang compile`, the compiler finds `config.toml`, **fetches any missing HTTP/Git dependencies** into `dependencies/`, then compiles. No need to run a separate “get” or “add” step (go get style).
- **Dependency sources in config.toml:**
  - **path** – Local directory (e.g. `path = "./libs/utils"`).
  - **http** – Direct URL to a ZIP or tar.gz (e.g. a GitHub archive URL).
  - **git** – GitHub repo (e.g. `git = "https://github.com/user/repo"`, optional `branch` or `tag`). Fetched as an archive and extracted to `dependencies/<name>`.

See [Packages and Modules](packages.md) for import rules and visibility, and [Build System](build-system.md) for `config.toml` and dependency management.

### Output

Use `fmt.Printf` for formatted output:

```tl
@name string = "Tlang";
@version int = 1;
fmt.Printf("Welcome to %s v%d!\n", name, version);
```

## Next Steps

1. **Learn the Language**: Follow the [Tutorial](tutorial.md) for step-by-step learning
2. **Explore Examples**: Check the `examples/` directory. For **servers, CLIs, and system tools** (MVP scope), the language and standard library are sufficient—see [Real-World Examples](../examples/real-world-examples/README.md) and [HTTP Server Guide](http-server-guide.md), or run `examples/args_example.tl` for command-line arguments. Imports use **`@variable = #dhimpu("path")`** (e.g. `@fmt = #dhimpu("std/fmt")` then `fmt.Printf`); there is no explicit package or alias keyword.
3. **Read the Reference**: See [Language Reference](language-reference.md)
4. **Use Libraries**: Explore the [Standard Library](standard-library.md)
5. **Concurrency**: Use channels (`ch <- value`, `@x = <- ch`), spawn (`tlang #fn(args)`), and WaitGroup (`wg.Add(n)`, `wg.Done()`, `wg.Wait()`). See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md).
6. **Projects and config:** For multi-file projects, add `config.toml` with dependencies and optional entry point. When you `tlang run` or `tlang compile`, the compiler fetches remote deps (HTTP/Git) automatically. See [Build System](build-system.md) and `examples/config.toml.example`.

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
