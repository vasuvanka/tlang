# Tlang Installation Guide

This guide explains how to install Tlang on Linux and Windows.

## Prerequisites

Tlang requires:
- **Rust** (for building the compiler)
- **C compiler** (gcc or clang for Linux, gcc or MSVC for Windows)
- **OpenSSL development libraries** (for cryptographic functions)

### Installing Prerequisites

**Linux/Unix:**
```bash
# Debian/Ubuntu
sudo apt-get install build-essential libssl-dev pkg-config

# RHEL/CentOS
sudo yum install gcc openssl-devel pkg-config

# Fedora
sudo dnf install gcc openssl-devel pkg-config

# Arch Linux
sudo pacman -S base-devel openssl pkg-config

# macOS
brew install openssl pkg-config
```

**Windows:**
- Install [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html) (recommended: Win64 OpenSSL v3.x)
- Or use vcpkg: `vcpkg install openssl:x64-windows`
- Install a C compiler: MinGW-w64 or Visual Studio Build Tools

## Linux/Unix Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/vasuvanka/tlang.git
cd tlang

# Run installation script (will check and install OpenSSL if needed)
chmod +x install.sh
sudo ./install.sh
```

### User Installation (No sudo)

```bash
USER_INSTALL=1 ./install.sh
```

This will install to `~/.local/bin`. Make sure it's in your PATH:

```bash
export PATH="$PATH:$HOME/.local/bin"
```

### Manual Installation

```bash
# Build the compiler
cargo build --release

# Copy binary to a directory in your PATH
sudo cp target/release/tlangc /usr/local/bin/tlangc
sudo chmod +x /usr/local/bin/tlangc

# Create wrapper script
sudo tee /usr/local/bin/tlang > /dev/null << 'EOF'
#!/bin/bash
# ... (see install.sh for full script)
EOF
sudo chmod +x /usr/local/bin/tlang
```

## Windows Installation

### Quick Install

1. Open PowerShell as Administrator
2. Navigate to the Tlang directory
3. Run:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

### User Installation (No Admin)

```powershell
$env:USER_INSTALL=1
powershell -ExecutionPolicy Bypass -File install.ps1
```

### Manual Installation

1. Build the compiler:
```powershell
cargo build --release
```

2. Copy `target\release\tlangc.exe` to a directory in your PATH (e.g., `C:\Program Files\tlang\bin`)

3. Create a wrapper script `tlang.ps1` in the same directory (see `install.ps1` for the script)

4. Add the directory to your PATH environment variable

## Verification

After installation, verify it works:

```bash
# Linux
tlang --version

# Windows
tlang --version
```

## Usage

### Compile a Tlang file

```bash
tlang compile hello.tl
# or
tlangc hello.tl output.c
```

### Compile and run

```bash
tlang run hello.tl
```

### Run tests

```bash
tlang test test_example.tl
```

## Uninstallation

### Linux

```bash
sudo rm /usr/local/bin/tlangc
sudo rm /usr/local/bin/tlang
```

### Windows

1. Remove the installation directory (e.g., `C:\Program Files\tlang`)
2. Remove the directory from your PATH environment variable

## Troubleshooting

### "Command not found" after installation

- **Linux**: Make sure the installation directory is in your PATH. Restart your terminal or run:
  ```bash
  export PATH="$PATH:/usr/local/bin"
  ```

- **Windows**: Restart your terminal or PowerShell session after installation.

### Permission denied

- **Linux**: Use `sudo` for system-wide installation, or use `USER_INSTALL=1` for user installation
- **Windows**: Run PowerShell as Administrator

### C compiler not found

The `tlang run` and `tlang test` commands require a C compiler:

- **Linux**: Install `gcc`: `sudo apt-get install gcc` (Debian/Ubuntu) or `sudo yum install gcc` (RHEL/CentOS)
- **Windows**: Install MinGW-w64 or Visual Studio Build Tools

### OpenSSL not found

Tlang requires OpenSSL for cryptographic functions:

- **Linux**: Install `libssl-dev`: `sudo apt-get install libssl-dev` (Debian/Ubuntu) or `sudo yum install openssl-devel` (RHEL/CentOS)
- **Windows**: Download and install [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html) to `C:\OpenSSL-Win64`
- **macOS**: `brew install openssl`

The installation script will attempt to install OpenSSL automatically on Linux/Unix systems.

## Building from Source

```bash
# Clone repository
git clone https://github.com/vasuvanka/tlang.git
cd tlang

# Build
cargo build --release

# Binary will be at: target/release/tlangc (Linux) or target/release/tlangc.exe (Windows)
```
