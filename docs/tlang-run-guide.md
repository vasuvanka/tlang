# tlang run - Developer Guide

The `tlang run` command is designed for quick development and testing. It compiles and runs your Tlang program in one step.

## Basic Usage

### Explicit File

```bash
tlang run program.tl
```

### Auto-Detection (Developer-Friendly)

If you don't specify a file, `tlang run` automatically detects the entry file:

```bash
# In your project directory
tlang run
```

**Detection Priority:**
1. `entry_file` from `config.toml` (if project has config.toml)
2. `prarambham.tl` in current directory
3. `main.tl` in current directory
4. `src/prarambham.tl`
5. `src/main.tl`

## Examples

### Example 1: Simple Program

```bash
# Create prarambham.tl
echo '@fmt = #dhimpu("std/fmt"); #prarambham() { fmt.Printf("Hello!\n"); }' > prarambham.tl

# Run it
tlang run
# Output: Hello!
```

### Example 2: With Arguments

```bash
# Run with command-line arguments
tlang run args_example.tl --help
tlang run args_example.tl arg1 arg2 arg3
```

### Example 3: Project with config.toml

```toml
# config.toml
[package]
name = "myapp"
version = "1.0.0"

[build]
entry_file = "src/app.tl"
```

```bash
# Auto-detects src/app.tl from config.toml
tlang run
```

### Example 4: Quick Testing

```bash
# Quick test without specifying file
cd my-project
tlang run --test-flag
```

## How It Works

1. **File Detection**: If no file specified, searches for entry files
2. **Compilation**: Compiles Tlang → C → binary (temporary files)
3. **Execution**: Runs the binary with provided arguments
4. **Cleanup**: Automatically removes temporary files

## Comparison with Other Commands

| Command | Use Case | Output |
|---------|----------|--------|
| `tlang run [file]` | Quick testing/development | Temporary binary (auto-deleted) |
| `tlang compile [file]` | Production builds | Permanent executable |
| `tlang build [dir]` | Project builds | Static binary in output directory |

## Tips for Developers

1. **Use `tlang run` for development** - Fast iteration cycle
2. **Use `tlang compile` for distribution** - Creates permanent executables
3. **Use `tlang build` for projects** - Handles dependencies and caching

## Common Patterns

### Development Workflow

```bash
# Edit your code
vim prarambham.tl

# Quick test
tlang run

# Test with arguments
tlang run --debug --verbose

# When ready, compile for distribution
tlang compile prarambham.tl myapp
```

### Project Workflow

```bash
# Initialize project
tlang init myapp

# Develop and test
tlang run

# Build for production
tlang build
```

## See Also

- [Getting Started](getting-started.md) - Installation and basics
- [Build System](build-system.md) - Project builds and dependencies
- [How to Run Args Example](how-to-run-args-example.md) - Running with arguments
