# Tlang Documentation

Welcome to the comprehensive documentation for Tlang, a simple compiled programming language inspired by Go, with Telugu keywords.

## 🚀 Quick Start

### Installation

```bash
# Linux/macOS
./install.sh

# Windows
.\install.ps1
```

### Your First Program

```tl
dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("Hello, Tlang!\n");
}
```

Save as `hello.tl` and run:
```bash
# Quick run (for development)
tlang run hello.tl

# Or compile to executable (for distribution)
tlang compile hello.tl
./hello
```

### Porting from Go

Convert Go packages to Tlang:
```bash
tlang port main.go main.tl
tlang port ./go-package ./tlang-package
```

See [Porting Guide](porting-guide.md) for details.

## 📚 Documentation Index

### Getting Started
- **[Getting Started Guide](getting-started.md)** - Installation, first program, and basic concepts
- **[Language Tutorial](tutorial.md)** - Step-by-step learning guide from basics to advanced

### Language Reference
- **[Language Reference](language-reference.md)** - Complete syntax and language features
- **[Keywords and Operators](keywords-operators.md)** - All keywords, operators, and their usage

### Standard Library
- **[Standard Library Overview](standard-library.md)** - Overview of all available libraries
- **[fmt - Formatting](libraries/fmt.md)** - Formatted I/O operations
- **[strings - String Operations](libraries/strings.md)** - String manipulation functions
- **[math - Mathematics](libraries/math.md)** - Mathematical functions and constants
- **[strconv - String Conversion](libraries/strconv.md)** - String to number conversions
- **[os - Operating System](libraries/os.md)** - OS interface functions
- **[time - Time Operations](libraries/time.md)** - Time and date functions
- **[io - File I/O](libraries/io.md)** - File reading and writing
- **[filepath - Path Manipulation](libraries/filepath.md)** - Path handling functions
- **[regexp - Regular Expressions](libraries/regexp.md)** - Pattern matching
- **[rand - Random Numbers](libraries/rand.md)** - Random number generation
- **[log - Logging](libraries/log.md)** - Structured logging
- **[testing - Unit Testing](libraries/testing.md)** - Testing framework
- **[args - Command Arguments](libraries/args.md)** - Command-line arguments
- **[bytes - Byte Operations](libraries/bytes.md)** - Byte manipulation
- **[sort - Sorting](libraries/sort.md)** - Array sorting
- **[json - JSON](libraries/json.md)** - JSON encoding/decoding
- **[unicode - Unicode](libraries/unicode.md)** - Unicode character utilities
- **[encoding/csv - CSV](libraries/csv.md)** - CSV file processing
- **[encoding/xml - XML](libraries/xml.md)** - XML processing
- **[encoding/base64 - Base64](libraries/base64.md)** - Base64 encoding/decoding
- **[net/url - Network URL](libraries/neturl.md)** - Network URL utilities
- **[bufio - Buffered I/O](libraries/bufio.md)** - Buffered I/O operations
- **[testing/benchmark - Benchmarking](libraries/benchmark.md)** - Performance benchmarking
- **[doc - Documentation](libraries/doc.md)** - Documentation generation
- **[reflect - Reflection](libraries/reflect.md)** - Runtime type information

### Examples
- **[Examples Guide](examples.md)** - Code examples and patterns

### Advanced Topics
- **[Packages and Modules](packages.md)** - Package system, imports, and module organization
- **[Package Visibility](package-visibility.md)** - Export rules and visibility guidelines
- **[Type System](type-system.md)** - Types, type inference, and pointers
- **[Borrow Checker](borrow-checker.md)** - Ownership and borrowing for memory safety
- **[Mutable Variables](mutable-variables.md)** - Using `@!` for mutable variables
- **[Constants vs Immutable Variables](constants-vs-immutable-variables.md)** - Using `@` for constants
- **[Immutability Analysis](immutability-analysis.md)** - Pros and cons of immutability-by-default
- **[Error Handling](error-handling.md)** - Error messages and debugging
- **[Best Practices](best-practices.md)** - Coding conventions and tips
- **[Porting Guide](porting-guide.md)** - Convert Go packages to Tlang

### Developer Tools
- **[VS Code / Cursor Extension](vscode-extension.md)** - Install and configure the Tlang extension for VS Code and Cursor
- **[Installing MinGW](install-mingw.md)** - Install C compiler for binary compilation

### Reference
- **[Reserved Keywords](reserved-keywords.md)** - Complete list of all Tlang keywords
- **[Compile Command](compile-command.md)** - Compile Tlang directly to executable binaries

## 📖 Language Philosophy

Tlang follows Go's philosophy:
- **Simplicity**: One way to do things
- **Explicitness**: Clear and readable code
- **Compile-time safety**: Catch errors early
- **Fast compilation**: Quick feedback loop

## 🎯 Key Features

- Telugu keywords for better readability
- Type inference from values
- Comprehensive standard library
- Compiles to C for portability
- Clear error messages with stack traces

## 📝 File Extension

Tlang source files use the `.tl` extension.

## 🤝 Contributing

Found an issue or want to contribute? Check the main repository for contribution guidelines.
