# Tlang Development Guide

This guide is for developers working on the Tlang compiler itself.

## Building the Compiler

### Build All Binaries

```bash
cargo build --release
```

This builds:
- `tlangc` - Main Tlang compiler
- `tlang-build` - Build system and package manager
- `tlang-lsp` - Language Server Protocol server
- `tlang-port` - Go to Tlang porting tool

### Run Specific Binary

Since there are multiple binaries, specify which one to run:

```bash
# Run main compiler
cargo run --bin tlangc -- examples/hello.tl

# Run main compiler with subcommand (optional)
cargo run --bin tlangc -- run examples/hello.tl

# Run build system
cargo run --bin tlang-build -- build

# Run LSP server
cargo run --bin tlang-lsp

# Run porting tool
cargo run --bin tlang-port -- main.go main.tl
```

### Default Binary

The default binary is set to `tlangc` in `Cargo.toml`, so you can also use:

```bash
# This runs tlangc by default
cargo run -- examples/hello.tl

# With optional subcommand
cargo run -- run examples/hello.tl
```

**Note:** The `tlangc` compiler now accepts optional subcommands ("run", "build", "compile") for better compatibility, but they are simply ignored and the next argument is treated as the filename.

## Testing

### Run Tests

```bash
cargo test
```

### Test Compiler on Example Files

```bash
# Test compilation
cargo run --bin tlangc -- examples/hello.tl output.c

# Test build system
cargo run --bin tlang-build -- build examples/
```

## Development Workflow

1. **Make changes** to Rust source code
2. **Build** with `cargo build` or `cargo build --release`
3. **Test** with `cargo test`
4. **Run** specific binary with `cargo run --bin <binary>`
5. **Install** with `./install.sh` (Linux/macOS) or `.\install.ps1` (Windows)

## Project Structure

```
tlang/
├── src/
│   ├── main.rs              # tlangc binary (main compiler)
│   ├── lib.rs               # Library code
│   ├── bin/
│   │   ├── tlang-build.rs   # Build system
│   │   ├── tlang-lsp.rs     # LSP server
│   │   └── tlang-port.rs    # Porting tool
│   ├── lexer.rs             # Lexical analysis
│   ├── parser.rs            # Syntax parsing
│   ├── codegen.rs           # C code generation
│   ├── type_inference.rs    # Type checking
│   ├── build/               # Build system modules
│   └── libs/                # Standard library generators
├── examples/                # Example Tlang programs
├── docs/                     # Documentation
└── Cargo.toml               # Rust project configuration
```

## Common Commands

```bash
# Build release binaries
cargo build --release

# Run compiler on a file
cargo run --bin tlangc -- file.tl output.c

# Run build system
cargo run --bin tlang-build -- build

# Run LSP (for IDE integration)
cargo run --bin tlang-lsp

# Run porting tool
cargo run --bin tlang-port -- main.go main.tl

# Check code (without building)
cargo check

# Format code
cargo fmt

# Lint code
cargo clippy
```

## See Also

- [Getting Started](getting-started.md) - User guide
- [Build System](build-system.md) - Project build system
- [Language Reference](language-reference.md) - Tlang syntax
