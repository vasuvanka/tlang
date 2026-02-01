# Building Tlang from Source

**New to Tlang?** See the [Getting Started Guide](docs/getting-started.md) for install, your first program, and run/compile—everything you need to get going.

This guide explains how to clone Tlang from GitHub and build it locally to make the `tlang` command line tool available.

## Prerequisites

Before building Tlang, ensure you have the following installed:

### Required

1. **Rust** (latest stable version)
   - Install from [rustup.rs](https://rustup.rs/)
   - Verify: `rustc --version`

2. **C Compiler**
   - **Linux**: `gcc` or `clang`
     ```bash
     # Debian/Ubuntu
     sudo apt-get install build-essential
     
     # RHEL/CentOS/Fedora
     sudo yum install gcc  # or: sudo dnf install gcc
     
     # Arch Linux
     sudo pacman -S base-devel
     ```
   - **macOS**: Xcode Command Line Tools
     ```bash
     xcode-select --install
     ```
   - **Windows**: 
     - MinGW-w64: Download from [mingw-w64.org](https://www.mingw-w64.org/)
     - Or Visual Studio Build Tools: Download from [Visual Studio](https://visualstudio.microsoft.com/downloads/)

3. **OpenSSL Development Libraries** (for cryptographic functions)
   - **Linux**:
     ```bash
     # Debian/Ubuntu
     sudo apt-get install libssl-dev pkg-config
     
     # RHEL/CentOS
     sudo yum install openssl-devel pkg-config
     
     # Fedora
     sudo dnf install openssl-devel pkg-config
     
     # Arch Linux
     sudo pacman -S openssl pkg-config
     ```
   - **macOS**:
     ```bash
     brew install openssl pkg-config
     ```
   - **Windows**: 
     - Download from [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html)
     - Or use vcpkg: `vcpkg install openssl:x64-windows`

### Optional

- **Git** (for cloning the repository)
  - Usually pre-installed on Linux/macOS
  - Windows: Download from [git-scm.com](https://git-scm.com/)

## Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/vasuvanka/tlang.git

# Navigate to the project directory
cd tlang
```

## Step 2: Build the Compiler

### Quick Build (Development)

```bash
# Build in debug mode (faster compilation, larger binary)
cargo build

# Binary will be at: target/debug/tlangc
```

### Release Build (Recommended for Production)

```bash
# Build in release mode (optimized, smaller binary)
cargo build --release

# Binary will be at: target/release/tlangc
```

### Build with OpenSSL Support

If you have OpenSSL installed:

```bash
cargo build --release --features tls
```

## Step 3: Install the Binary

### Option A: System-wide Installation (Linux/macOS)

```bash
# Copy binary to /usr/local/bin (requires sudo)
sudo cp target/release/tlangc /usr/local/bin/tlangc
sudo chmod +x /usr/local/bin/tlangc

# Verify installation
tlangc --version
```

### Option B: User Installation (No sudo required)

```bash
# Create local bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy binary
cp target/release/tlangc ~/.local/bin/tlangc
chmod +x ~/.local/bin/tlangc

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/.local/bin"

# Verify installation
tlangc --version
```

### Option C: Use Installation Scripts

**Linux/macOS:**
```bash
# Make script executable
chmod +x install.sh

# Run installation (system-wide, requires sudo)
sudo ./install.sh

# Or user installation (no sudo)
USER_INSTALL=1 ./install.sh
```

**Windows:**
```powershell
# Run PowerShell script as Administrator
powershell -ExecutionPolicy Bypass -File install.ps1

# Or user installation
$env:USER_INSTALL=1
powershell -ExecutionPolicy Bypass -File install.ps1
```

## Step 4: Create the `tlang` Wrapper Script

The `tlangc` binary is the compiler. For convenience, you may want a `tlang` wrapper script that provides subcommands like `tlang run`, `tlang compile`, etc.

### Linux/macOS

Create `/usr/local/bin/tlang` (or `~/.local/bin/tlang` for user install):

```bash
#!/bin/bash
# Tlang wrapper script

case "$1" in
    run)
        shift
        tlangc run "$@"
        ;;
    compile)
        shift
        tlangc compile "$@"
        ;;
    build)
        shift
        tlangc build "$@"
        ;;
    --version|-v|version)
        tlangc --version
        ;;
    *)
        echo "Usage: tlang {run|compile|build|--version} [options]"
        exit 1
        ;;
esac
```

Make it executable:
```bash
sudo chmod +x /usr/local/bin/tlang
```

### Windows

Create `tlang.ps1` in your PATH:

```powershell
# Tlang wrapper script for PowerShell

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

switch ($Command) {
    "run" {
        tlangc run $Arguments
    }
    "compile" {
        tlangc compile $Arguments
    }
    "build" {
        tlangc build $Arguments
    }
    {$_ -in "--version", "-v", "version"} {
        tlangc --version
    }
    default {
        Write-Host "Usage: tlang {run|compile|build|--version} [options]"
        exit 1
    }
}
```

## Step 5: Verify Installation

Test that everything works:

```bash
# Check version
tlangc --version
# or
tlang --version

# Create a test file
cat > hello.tl << 'EOF'
@fmt = #dhimpu("std/fmt");
#dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("Hello, Tlang!\n");
}
EOF

# Compile and run
tlang compile hello.tl
./hello  # or hello.exe on Windows

# Or use run command
tlang run hello.tl
```

## Troubleshooting

### "Command not found" after installation

- **Linux/macOS**: Make sure the installation directory is in your PATH
  ```bash
  echo $PATH  # Check current PATH
  export PATH="$PATH:/usr/local/bin"  # Add if missing
  ```
- **Windows**: Restart your terminal/PowerShell after installation

### C compiler not found

- **Linux**: Install `build-essential` (Debian/Ubuntu) or `gcc` (RHEL/CentOS)
- **macOS**: Install Xcode Command Line Tools: `xcode-select --install`
- **Windows**: Install MinGW-w64 or Visual Studio Build Tools

### OpenSSL not found

- **Linux**: Install `libssl-dev` (Debian/Ubuntu) or `openssl-devel` (RHEL/CentOS)
- **macOS**: `brew install openssl`
- **Windows**: Download and install OpenSSL for Windows

### Rust not found

Install Rust using rustup:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Build errors

1. **Clean and rebuild**:
   ```bash
   cargo clean
   cargo build --release
   ```

2. **Update dependencies**:
   ```bash
   cargo update
   cargo build --release
   ```

3. **Check Rust version**:
   ```bash
   rustc --version  # Should be 1.70.0 or later
   rustup update
   ```

## Development Build

For development, you can use:

```bash
# Debug build (faster, includes debug symbols)
cargo build

# Run directly without installation
cargo run -- compile hello.tl

# Run tests
cargo test
```

## Next Steps

- Read the [Getting Started Guide](docs/getting-started.md)
- Explore [Examples](examples/)
- Check the [Language Reference](docs/language-reference.md)
- Run the test suite:
  - **Linux/macOS**: `./tests/run_all_tests.sh`
  - **Windows**: `tests\run_all_tests.bat`

## Additional Resources

- [Installation Guide](README_INSTALL.md) - Detailed installation instructions
- [Development Guide](docs/development.md) - Contributing to Tlang
- [Language Documentation](docs/) - Complete language reference
- [Examples](examples/) - Code examples and tutorials
- [Small Binaries & IoT](docs/small-binaries-iot.md) - Keep build size small for IoT devices and microcontrollers
- [Zero-Deps, Cross-Compile & Deploy](docs/zero-deps-cross-deploy.md) - Static binaries, cross-compile (Windows/Linux/macOS), deployable images
- [Strategy: Concurrency and Generics](docs/strategy-concurrency-generics.md) - Phased plan for adding concurrency and generics (Phase 2)

## Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section above
2. Review [GitHub Issues](https://github.com/vasuvanka/tlang/issues)
3. Check the [Documentation](docs/)

---

**Happy Coding with Tlang! 🚀**
