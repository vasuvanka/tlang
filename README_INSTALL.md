# Tlang Installation Guide

![Tlang logo (అ / Aa)](https://vasuvanka.github.io/tlang/tlang-logo.png)

This guide explains how to install Tlang on Linux and Windows.

## Single install (no separate C compiler)

On **Windows**, the install script can **bundle MinGW-w64 (GCC)** so you do not need to install a C compiler separately. Run `./install.sh` (or `install.ps1`); when prompted, allow it to download and bundle GCC. Then `tlang compile`, `tlang run`, and `tlangc compile` will use the bundled compiler automatically.

On **Linux/macOS**, the script uses the system compiler (gcc/clang); install it once (e.g. `apt install build-essential` or `xcode-select --install`).

The **tlangc** and **tlang-build** binaries look for **gcc** in the same directory as the executable first (bundled install layout). If found, they use it and set `PATH` so the compiler can find its internal tools. So a single Tlang install (with bundled GCC on Windows) is enough—no separate C compiler step for end users.

## Single-link installation (any OS)

One URL per platform; the script clones the repo (if needed) and runs the installer. Prerequisites: **Rust**, **C compiler** (or use bundled GCC on Windows), **OpenSSL** dev libs. Base URL used below: `https://raw.githubusercontent.com/vasuvanka/tlang/main`. You can host the same scripts at your own domain (e.g. `https://tlang.dev`) and set `TLANG_REPO_URL` / `TLANG_BRANCH` if needed.

**Linux / macOS / WSL (bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash
```
With options: `curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash -s -- --install-method git`

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/vasuvanka/tlang/main/install.ps1 | iex
```

**Windows (CMD):**
```cmd
curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.cmd -o install.cmd && install.cmd && del install.cmd
```
Or download `install.cmd`, run it, then delete it. To use a custom base URL: `set TLANG_INSTALL_URL=https://your-domain.com` before running.

## Prerequisites (for building Tlang from source)

Tlang requires:
- **Rust** (for building the compiler)
- **C compiler** (gcc or clang for Linux, gcc or MSVC for Windows)—or use the bundled GCC from the install script on Windows
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

### One-line install (curl, no clone)

Install without cloning the repo (Linux, macOS, WSL). Same as [Single-link installation](#single-link-installation-any-os)—use `install.sh` directly:

```bash
curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash
```

Alternative (legacy): `curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vasuvanka/tlang/main/install-curl.sh | sh`

Then add to PATH if needed: `export PATH="$PATH:$HOME/.local/bin"`. Verify: `tlang --version` or `tlangc --version`. **Windows:** use [Single-link installation](#single-link-installation-any-os) (PowerShell or CMD) or [Windows Installation](#windows-installation).

### Quick Install (clone then script)

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

You can install the toolchain using only Cargo, without running the install scripts:

```bash
# Clone repository
git clone https://github.com/vasuvanka/tlang.git
cd tlang

# Build
cargo build --release

# Binary will be at: target/release/tlangc (Linux/macOS) or target/release/tlangc.exe (Windows)
```

You can run the compiler from that path (e.g. `./target/release/tlangc --version`). Optionally, copy the binary to a directory in your PATH or run the install script (see [Manual Installation](#manual-installation) above).

---

© VasuVanka
