# Tlang Build System

The Tlang build system provides a modern, efficient way to build Tlang projects with support for dependency management, incremental compilation, and single static binary generation (compile once, run anywhere).

## Features

✅ **Project Configuration** - `config.toml` manifest file  
✅ **Dependency Management** - Local and remote dependency resolution  
✅ **Build Caching** - Incremental compilation using file hashes  
✅ **Incremental Compilation** - Only recompiles changed files and their dependents ⭐ **NEW**  
✅ **Dependency Tracking** - Tracks file dependencies to determine what needs rebuilding  
✅ **Static Binaries** - Single executable bundle (compile once, run anywhere)  
✅ **Optimization** - Configurable optimization levels  
✅ **Debug Support** - Optional debug symbols  

## Quick Start

### Initialize a Project

```bash
tlang init [app_name] [directory]
```

This creates:
- `config.toml` - Project manifest with name and version "1.0.0"
- `src/prarambham.tl` - Entry point file with hello world program
- Sets `entry_file = "src/prarambham.tl"` in config.toml

**Example:**
```bash
tlang init                    # Initialize current directory
tlang init myapp              # Initialize with app name "myapp"
tlang init myapp ./myproject  # Initialize with app name in specific directory
```

### Build a Project

```bash
tlang build [directory]
```

This will:
1. Read `config.toml` manifest
2. Resolve dependencies
3. Compile Tlang to C
4. Compile C to static binary
5. Output to `target/` directory

### Go get style: automatic dependency fetch

When you **run** or **compile** a program, the compiler looks for `config.toml` in the current directory or the directory of the input file. If it finds one and it lists **HTTP** or **Git** dependencies, it automatically downloads any missing packages into `dependencies/` before building (like `go get`).

- **`tlang run program.tl`** or **`tlang compile program.tl`** will fetch remote deps from `config.toml` if present.
- **HTTP**: `http = "https://github.com/user/repo/archive/main.zip"` (or any `.zip`/`.tar.gz` URL).
- **Git** (GitHub only for now): `git = "https://github.com/user/repo"` or `git = "https://github.com/user/repo", branch = "main"` or `tag = "v1.0"`. The compiler downloads the repo as a ZIP from GitHub and extracts it to `dependencies/<name>`.
- Path dependencies are not fetched; they must already exist on disk.

You do not need to run `tlang add` first when using run/compile; fetching happens automatically.

### Clean Build Artifacts

```bash
tlang clean [directory]
```

This removes:
- `target/` directory (compiled binaries)
- `.tlang_cache/` directory (build cache)

## Incremental Compilation ⭐ **NEW**

The build system now supports incremental compilation, which significantly speeds up rebuilds by only recompiling files that have changed or depend on changed files.

### How It Works

1. **File Change Detection**: Each source file is hashed (SHA256) and compared with cached hashes
2. **Dependency Tracking**: The system tracks which files import which other files
3. **Dependent Recompilation**: When a file changes, all files that import it are also marked for recompilation
4. **Build Config Tracking**: Changes to build configuration (optimization, flags, etc.) trigger full rebuild

### Benefits

- **Faster Builds**: Only changed files are recompiled
- **Automatic**: Works transparently - no special commands needed
- **Smart**: Understands dependencies between files
- **Safe**: Always produces correct results

### Example

```bash
# First build - compiles everything
$ tlang build
Building project: myapp
Compiling...
Build complete: target/myapp

# Edit one file
$ echo "// comment" >> src/utils.tl

# Second build - only recompiles changed files
$ tlang build
Building project: myapp
📦 Incremental compilation: 2 of 10 files need recompilation
Compiling...
Build complete: target/myapp
```

### Cache Location

The build cache is stored in `.tlang_cache/` directory in your project root:
- `cache.json` - File hashes and dependency information
- Automatically created and managed by the build system

### Cache Invalidation

The cache is automatically invalidated when:
- Source files change (detected by hash comparison)
- Build configuration changes (optimization, flags, etc.)
- Dependencies change (imported files are modified)

### Manual Cache Clearing

To force a full rebuild, clear the cache:

```bash
tlang clean
tlang build
```

## Project Configuration (`config.toml`)

The project manifest file is `config.toml` located in the project root. The build system reads it for **dependency resolution** and for the **entry point** (`entry_file`); if `entry_file` is not set, it auto-detects `prarambham.tl`, `main.tl`, or `{package_name}.tl`. For a full example see `examples/config.toml.example`.

Example `config.toml`:

```toml
[package]
name = "myapp"
version = "0.1.0"
description = "My Tlang application"
author = "Your Name"

[build]
output_dir = "target"
binary_name = "myapp"
static_link = true      # Compile once, run anywhere
optimize = "speed"      # "none", "size", or "speed"
debug = false           # Include debug symbols
compiler_flags = []     # Additional compiler flags
linker_flags = []       # Additional linker flags

[[dependencies]]
name = "utils"
path = "./libs/utils"
version = "0.1.0"
```

### Configuration Options

#### `[package]`
- `name` - Project name (required)
- `version` - Version string (default: "0.1.0")
- `description` - Project description
- `author` - Author name

#### `[build]`
- `output_dir` - Output directory for build artifacts (default: "target")
- `binary_name` - Name of the generated binary (default: "app")
- `entry_file` - Entry point file for the project (optional). If not specified, auto-detects `prarambham.tl`, `main.tl`, or `{package_name}.tl`
- `static_link` - Static linking for standalone binary (default: true)
- `optimize` - Optimization level: "none", "size", or "speed" (default: "speed")
- `debug` - Include debug symbols (default: false)
- `compiler_flags` - Additional GCC/Clang flags
- `linker_flags` - Additional linker flags

#### `[[dependencies]]`
- `name` - Dependency name
- `path` - Local path or URL to dependency
- `version` - Version string (optional)

## Build Process

### 1. Source Collection
The build system automatically discovers all `.tl` files in the project directory.

### 2. Change Detection
File hashes are computed and compared against the build cache to determine if recompilation is needed.

### 3. Dependency Resolution
Dependencies listed in `config.toml` are resolved, including:
- **Direct dependencies** - Listed in `[dependencies]`
- **Indirect dependencies** - Transitive dependencies automatically resolved
- **Lock file** - `config.lock` ensures reproducible builds

### 4. Compilation
- **Tlang → C**: Tlang source is compiled to C code
- **C → Binary**: C code is compiled to a static binary

### 5. Output
The final binary is placed in the `output_dir` (default: `target/`).

## Static Linking (Compile Once, Run Anywhere)

By default, `static_link = true` creates a standalone binary that:
- ✅ Contains all dependencies statically linked
- ✅ Can run on systems without Tlang installed
- ✅ No external library dependencies (except system libc)
- ✅ Works across different Linux distributions

**Example:**
```bash
# Build on Ubuntu
tlang build

# Copy binary to CentOS (no Tlang needed)
scp target/myapp user@centos-server:/tmp/

# Run directly
/tmp/myapp
```

### Static Linking Considerations

- **Binary Size**: Static binaries are larger (~2-5MB vs ~100KB)
- **OpenSSL**: Static linking includes OpenSSL libraries
- **System Compatibility**: Binary must match target architecture (x86_64, ARM, etc.)

## Build Caching

The build system uses file hashing to detect changes:

- **Cache Location**: `.tlang_cache/` in project root
- **Cache Format**: JSON file with file paths and SHA256 hashes
- **Incremental Builds**: Only changed files trigger recompilation

**Cache Benefits:**
- Faster builds for large projects
- Automatic change detection
- No manual dependency tracking

## Dependency Management

### Local Dependencies

```toml
[[dependencies]]
name = "utils"
path = "./libs/utils"
```

The dependency path can be:
- Relative to project root: `./libs/utils`
- Absolute path: `/path/to/dependency`
- Package directory: `utils` (searches in project root)

### Remote Dependencies (Future)

```toml
[[dependencies]]
name = "http-client"
path = "https://github.com/vasuvanka/tlang-http-client"
version = "1.0.0"
```

*Note: Remote dependencies are planned but not yet implemented.*

## Optimization Levels

### `optimize = "none"`
- No optimizations (`-O0`)
- Fastest compilation
- Largest binary size
- Best for debugging

### `optimize = "size"`
- Size optimizations (`-Os`)
- Smaller binary
- Slower execution
- Good for embedded systems

### `optimize = "speed"` (default)
- Speed optimizations (`-O2`)
- Faster execution
- Larger binary
- Best for production

## Debug Builds

Enable debug symbols:

```toml
[build]
debug = true
```

Then debug with GDB/LLDB:
```bash
gdb target/myapp
```

See [Debugging Guide](debugging-guide.md) for details.

## Build Commands

### `tlang build [directory]`
Build the project. Outputs a static binary to `target/`.

**Options:**
- Automatically detects changes
- Uses cached builds when possible
- Creates static binary by default
- If directory not specified, uses current directory

**Example:**
```bash
tlang build           # Build current directory
tlang build ./myapp  # Build specified directory
```

### `tlang clean [directory]`
Remove all build artifacts:
- `target/` directory
- `.tlang_cache/` directory
- If directory not specified, uses current directory

### `tlang init [directory]`
Initialize a new project:
- Creates `config.toml` with defaults
- Creates `main.tl` if it doesn't exist
- If directory not specified, uses current directory
- Creates directory if it doesn't exist

**Example:**
```bash
tlang init           # Initialize current directory
tlang init myproject # Initialize new directory
```

### `tlang add <package>@<version> [directory]`
Add a package dependency:
- Adds dependency to `config.toml`
- Creates default path dependency
- If directory not specified, uses current directory

**Example:**
```bash
tlang add utils@0.1.0           # Add to current directory
tlang add utils@0.1.0 ./myapp  # Add to specified directory
```

### `tlang remove <package> [directory]`
Remove a package dependency:
- Removes dependency from `config.toml`
- If directory not specified, uses current directory

**Example:**
```bash
tlang remove utils           # Remove from current directory
tlang remove utils ./myapp  # Remove from specified directory
```

### `tlang upgrade <package|.|*> [directory]`
Upgrade package(s) to latest version:
- Upgrades specific package or all packages (`.` or `*`)
- Updates version in `config.toml`
- Currently only supports path dependencies
- If directory not specified, uses current directory

**Example:**
```bash
tlang upgrade utils          # Upgrade specific package
tlang upgrade .              # Upgrade all packages
tlang upgrade *              # Upgrade all packages (alternative)
```

## Integration with Existing Workflow

### Using with `tlangc`

The build system is compatible with the existing `tlangc` compiler:

```bash
# Traditional way
tlangc main.tl output.c
gcc -o app output.c -lm

# New build system way
tlang build
# Binary ready at target/app
```

### CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Tlang
        run: cargo install --path .
      - name: Build
        run: tlang build
      - name: Upload artifact
        uses: actions/upload-artifact@v2
        with:
          name: binary
          path: target/app
```

## Troubleshooting

### Build Fails: "No C compiler found"
Install a C compiler:
- **Linux**: `sudo apt-get install build-essential`
- **macOS**: Install Xcode Command Line Tools
- **Windows**: Install MinGW or Visual Studio Build Tools

### Static Linking Fails
- Ensure OpenSSL development libraries are installed
- Try `static_link = false` for dynamic linking
- Check linker flags in `config.toml`

### Cache Issues
Clear the cache:
```bash
tlang clean
```

### Binary Too Large
- Set `optimize = "size"`
- Consider dynamic linking: `static_link = false`
- Remove debug symbols: `debug = false`

## Lock File (config.lock)

The build system automatically generates `config.lock` (similar to `Cargo.lock`) that:
- Locks exact versions of all dependencies
- Tracks direct and indirect dependencies
- Stores checksums for integrity
- Ensures reproducible builds

**Note:** Commit `config.lock` to version control for applications.

## See Also

- [Manifest Reference](manifest.md) - Complete `config.toml` documentation
- [Getting Started Guide](getting-started.md)
- [Debugging Guide](debugging-guide.md)
- [Package System](packages.md)
