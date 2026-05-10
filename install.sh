#!/bin/bash
# Tlang Installation Script for Linux/Unix
# Single-link install: curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash
# Or with options: curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.sh | bash -s -- --install-method git

set -e

# Bootstrap: if not run from repo, clone and re-exec install.sh from clone
if [ ! -f "Cargo.toml" ] || [ ! -f "install.sh" ]; then
    REPO_URL="${TLANG_REPO_URL:-https://github.com/vasuvanka/tlang.git}"
    BRANCH="${TLANG_BRANCH:-main}"
    INSTALL_TEMP="${TMPDIR:-/tmp}/tlang-install-$$"
    echo "=== Tlang single-link install ==="
    echo "Cloning $REPO_URL (branch: $BRANCH)..."
    if ! command -v git &>/dev/null; then
        echo "Error: git is required. Install git and try again."
        exit 1
    fi
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_TEMP"
    cd "$INSTALL_TEMP"
    export USER_INSTALL=1
    export TLANG_NONINTERACTIVE=1
    chmod +x install.sh
    exec ./install.sh "$@"
fi

echo "=== Tlang Installation Script ==="
echo ""
echo "This script will:"
echo "  1. Clean any existing Tlang installation"
echo "  2. Bundle GCC compiler (Windows only)"
echo "  3. Bundle OpenSSL libraries"
echo "  4. Build Tlang compiler from source"
echo "  5. Install binaries and create wrapper script"
echo "  6. Configure PATH (if needed)"
echo ""

# Detect installation directory
# Default to user home directory (no sudo required)
# Use SYSTEM_INSTALL=1 for system-wide installation to /usr/local
if [ -n "$SYSTEM_INSTALL" ]; then
    INSTALL_DIR="${INSTALL_DIR:-/usr/local}"
    # All Tlang executables go to tlang/bin for better organization
    TLANG_BIN_DIR="$INSTALL_DIR/tlang/bin"
    # Wrapper script goes to standard bin for PATH access
    WRAPPER_BIN_DIR="$INSTALL_DIR/bin"
    TLANG_BIN="$WRAPPER_BIN_DIR/tlang"
    
    # Check if running as root (for system-wide install)
    # Request sudo ONCE at the beginning for all operations
    if [ "$EUID" -ne 0 ]; then
        echo "Note: Installing to $INSTALL_DIR requires root privileges."
        echo "To install to user directory, run: ./install.sh (without SYSTEM_INSTALL)"
        echo ""
        echo "This script will request sudo privileges ONCE for the entire installation."
        echo "All operations (bundling, copying files, etc.) will run in the same session."
        echo ""
        read -p "Continue with sudo? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        # Test sudo access once - this will prompt for password
        # On Windows (MINGW), sudo might not support -v, so test with a simple command
        echo "Testing sudo access (you may be prompted for your password)..."
        if command -v sudo &> /dev/null; then
            # Try to test sudo - on Linux/Mac use -v, on Windows use a simple command
            if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
                # Windows: test with a simple command that requires no output
                if ! sudo true 2>/dev/null; then
                    echo "Error: Could not obtain sudo privileges"
                    exit 1
                fi
            else
                # Linux/Mac: use -v to validate credentials
                if ! sudo -v 2>/dev/null; then
                    echo "Error: Could not obtain sudo privileges"
                    exit 1
                fi
                # Keep sudo session alive for the duration of the script (Linux/Mac only)
                ( while true; do sudo -n true 2>/dev/null; sleep 60; kill -0 "$$" || exit; done 2>/dev/null ) &
            fi
        else
            echo "Warning: sudo command not found. Proceeding without sudo (may fail on protected directories)."
        fi
        SUDO="sudo"
    else
        SUDO=""
    fi
else
    # User installation (default) - no sudo required
    INSTALL_DIR="${INSTALL_DIR:-$HOME/.local}"
    # All Tlang executables go to tlang/bin for better organization
    TLANG_BIN_DIR="$INSTALL_DIR/tlang/bin"
    # Wrapper script goes to standard bin for PATH access
    WRAPPER_BIN_DIR="$INSTALL_DIR/bin"
    TLANG_BIN="$WRAPPER_BIN_DIR/tlang"
    SUDO=""
fi

echo "Installing to: $INSTALL_DIR"
echo "Tlang executables: $TLANG_BIN_DIR"
echo "Wrapper script: $TLANG_BIN"
echo ""

# ============================================================================
# Clean existing installation if it exists
# ============================================================================
# Before installing, remove any existing Tlang installation to ensure a clean
# setup. This prevents conflicts from old binaries, libraries, or bundled tools.
# ============================================================================
if [ -f "$TLANG_BIN" ] || [ -d "$INSTALL_DIR/tlang" ] || [ -f "$TLANG_BIN_DIR/tlangc" ] || [ -f "$TLANG_BIN_DIR/tlangc.exe" ] || [ -f "$WRAPPER_BIN_DIR/tlangc" ] || [ -f "$WRAPPER_BIN_DIR/tlangc.exe" ]; then
    echo "Existing Tlang installation detected. Cleaning up..."
    echo ""
    
    # ------------------------------------------------------------------------
    # Remove wrapper script and binaries
    # ------------------------------------------------------------------------
    # Remove the main wrapper script (tlang command)
    if [ -f "$TLANG_BIN" ]; then
        echo "  Removing: $TLANG_BIN"
        $SUDO rm -f "$TLANG_BIN" 2>/dev/null || true
    fi
    
    # Remove compiler binary (tlangc) from both old and new locations
    if [ -f "$TLANG_BIN_DIR/tlangc" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlangc"
        $SUDO rm -f "$TLANG_BIN_DIR/tlangc" 2>/dev/null || true
    fi
    if [ -f "$TLANG_BIN_DIR/tlangc.exe" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlangc.exe"
        $SUDO rm -f "$TLANG_BIN_DIR/tlangc.exe" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlangc" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlangc"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlangc" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlangc.exe" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlangc.exe"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlangc.exe" 2>/dev/null || true
    fi
    
    # Remove build system binary (tlang-build) from both old and new locations
    if [ -f "$TLANG_BIN_DIR/tlang-build" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlang-build"
        $SUDO rm -f "$TLANG_BIN_DIR/tlang-build" 2>/dev/null || true
    fi
    if [ -f "$TLANG_BIN_DIR/tlang-build.exe" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlang-build.exe"
        $SUDO rm -f "$TLANG_BIN_DIR/tlang-build.exe" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlang-build" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlang-build"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlang-build" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlang-build.exe" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlang-build.exe"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlang-build.exe" 2>/dev/null || true
    fi
    
    # Remove porting tool binary (tlang-port) from both old and new locations
    if [ -f "$TLANG_BIN_DIR/tlang-port" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlang-port"
        $SUDO rm -f "$TLANG_BIN_DIR/tlang-port" 2>/dev/null || true
    fi
    if [ -f "$TLANG_BIN_DIR/tlang-port.exe" ]; then
        echo "  Removing: $TLANG_BIN_DIR/tlang-port.exe"
        $SUDO rm -f "$TLANG_BIN_DIR/tlang-port.exe" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlang-port" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlang-port"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlang-port" 2>/dev/null || true
    fi
    if [ -f "$WRAPPER_BIN_DIR/tlang-port.exe" ]; then
        echo "  Removing: $WRAPPER_BIN_DIR/tlang-port.exe"
        $SUDO rm -f "$WRAPPER_BIN_DIR/tlang-port.exe" 2>/dev/null || true
    fi
    
    # ------------------------------------------------------------------------
    # Remove Tlang directory and all its contents
    # ------------------------------------------------------------------------
    # This includes:
    #   - lib/     : Bundled OpenSSL libraries and other dependencies
    #   - mingw/   : Bundled GCC compiler (Windows only)
    #   - include/ : Header files (if any)
    if [ -d "$INSTALL_DIR/tlang" ]; then
        echo "  Removing: $INSTALL_DIR/tlang"
        $SUDO rm -rf "$INSTALL_DIR/tlang" 2>/dev/null || true
    fi
    
    echo "  ✓ Cleanup complete"
    echo ""
fi

# Define library directory
LIB_DIR="$INSTALL_DIR/tlang/lib"
BUNDLE_TEMP_DIR="./bundled-openssl-temp"
GCC_BUNDLE_TEMP_DIR="./bundled-gcc-temp"

# Detect if we're on Windows (MINGW/MSYS)
IS_WINDOWS=0
if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
    IS_WINDOWS=1
fi

# Bundle GCC (MinGW) - Windows only. Uses deps/windows/mingw from repo (no lookup/download).
if [ "$IS_WINDOWS" -eq 1 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Step 1/6: Bundling GCC (MinGW) compiler..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    BUNDLED_GCC=0
    DEPS_MINGW="deps/windows/mingw"
    if [ -d "$DEPS_MINGW" ] && [ -f "$DEPS_MINGW/bin/gcc.exe" ]; then
        echo "  Using prebuilt MinGW from $DEPS_MINGW"
        mkdir -p "$GCC_BUNDLE_TEMP_DIR"
        if command -v rsync &>/dev/null; then
            rsync -a --quiet "$DEPS_MINGW/" "$GCC_BUNDLE_TEMP_DIR/" 2>/dev/null || cp -r "$DEPS_MINGW"/* "$GCC_BUNDLE_TEMP_DIR/" 2>/dev/null || true
        else
            cp -r "$DEPS_MINGW"/* "$GCC_BUNDLE_TEMP_DIR/" 2>/dev/null || true
        fi
        if [ -f "$GCC_BUNDLE_TEMP_DIR/bin/gcc.exe" ]; then
            echo "✓ GCC compiler bundled from deps"
            BUNDLED_GCC=1
        fi
    fi
    if [ "$BUNDLED_GCC" -eq 0 ]; then
        # Auto-copy from system MinGW to deps (no prompts)
        MINGW_PATHS=(
            "/c/MinGW" "/c/mingw" "/c/mingw64" "/c/msys64/mingw64"
            "/c/Program Files/mingw-w64" "/c/Program Files/MinGW"
        )
        [ -n "$TLANG_MINGW_PATH" ] && [ -f "$TLANG_MINGW_PATH/bin/gcc.exe" ] && MINGW_PATHS=("$TLANG_MINGW_PATH" "${MINGW_PATHS[@]}")
        MINGW_FOUND=""
        for p in "${MINGW_PATHS[@]}"; do
            if [ -f "$p/bin/gcc.exe" ]; then
                MINGW_FOUND="$p"
                break
            fi
        done
        if [ -n "$MINGW_FOUND" ]; then
            echo "  Copying MinGW from $MINGW_FOUND to $DEPS_MINGW ..."
            if [ -f "scripts/copy-mingw-to-deps.ps1" ]; then
                powershell -ExecutionPolicy Bypass -File "scripts/copy-mingw-to-deps.ps1" "$MINGW_FOUND" 2>/dev/null || true
            fi
            if [ -f "$DEPS_MINGW/bin/gcc.exe" ]; then
                mkdir -p "$GCC_BUNDLE_TEMP_DIR"
                cp -r "$DEPS_MINGW"/* "$GCC_BUNDLE_TEMP_DIR/" 2>/dev/null || true
                [ -f "$GCC_BUNDLE_TEMP_DIR/bin/gcc.exe" ] && BUNDLED_GCC=1 && echo "✓ GCC compiler copied to deps and bundled"
            fi
        fi
    fi
    if [ "$BUNDLED_GCC" -eq 0 ]; then
        echo "  No MinGW found. Will require system GCC in PATH."
    fi
    echo ""
fi

# Bundle OpenSSL
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2/6: Bundling OpenSSL libraries..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
BUNDLED_OPENSSL=0
if [ -f "scripts/bundle-openssl.sh" ]; then
    chmod +x scripts/bundle-openssl.sh
    # On Windows, try PowerShell script first, then bash script
    if [ "$IS_WINDOWS" -eq 1 ] && [ -f "scripts/bundle-openssl.ps1" ]; then
        if powershell -ExecutionPolicy Bypass -File "scripts/bundle-openssl.ps1" "$BUNDLE_TEMP_DIR" 2>/dev/null; then
            # Check if bundling was successful
            if [ -d "$BUNDLE_TEMP_DIR/lib" ] && [ "$(ls -A $BUNDLE_TEMP_DIR/lib 2>/dev/null)" ]; then
                echo "OpenSSL libraries bundled successfully"
                BUNDLED_OPENSSL=1
            else
                echo "Warning: OpenSSL bundling produced no libraries. Will use system OpenSSL."
            fi
        else
            echo "Warning: Could not bundle OpenSSL. Will use system OpenSSL."
        fi
    elif ./scripts/bundle-openssl.sh "$BUNDLE_TEMP_DIR" 2>/dev/null; then
        # Check if bundling was successful
        if [ -d "$BUNDLE_TEMP_DIR/lib" ] && [ "$(ls -A $BUNDLE_TEMP_DIR/lib 2>/dev/null)" ]; then
            echo "OpenSSL libraries bundled successfully"
            BUNDLED_OPENSSL=1
        else
            echo "Warning: OpenSSL bundling produced no libraries. Will use system OpenSSL."
        fi
    else
        echo "Warning: Could not bundle OpenSSL. Will use system OpenSSL."
    fi
fi

# Check for OpenSSL (fallback to system)
echo ""
PKG_SUDO=""
CAN_USE_SUDO=0
if [ "$EUID" -eq 0 ]; then
    CAN_USE_SUDO=1
elif command -v sudo &> /dev/null; then
    # If we can run sudo non-interactively
    if sudo -n true 2>/dev/null; then
        CAN_USE_SUDO=1
        PKG_SUDO="sudo"
    # Or if we have a TTY and it's not a non-interactive installation
    elif [ -t 0 ] && [ "$TLANG_NONINTERACTIVE" != "1" ]; then
        CAN_USE_SUDO=1
        PKG_SUDO="sudo"
    fi
fi

echo "Step 3/6: Checking for OpenSSL..."
if ! command -v openssl &> /dev/null && [ -z "$BUNDLED_OPENSSL" ]; then
    echo "OpenSSL not found. Checking if we can install it..."
    if [ "$CAN_USE_SUDO" -eq 1 ]; then
        echo "Installing OpenSSL development libraries..."
        if command -v apt-get &> /dev/null; then
        $PKG_SUDO apt-get update
        $PKG_SUDO apt-get install -y libssl-dev pkg-config
    elif command -v yum &> /dev/null; then
        $PKG_SUDO yum install -y openssl-devel pkg-config
    elif command -v dnf &> /dev/null; then
        $PKG_SUDO dnf install -y openssl-devel pkg-config
    elif command -v pacman &> /dev/null; then
        $PKG_SUDO pacman -S --noconfirm openssl pkg-config
    elif command -v brew &> /dev/null; then
        brew install openssl pkg-config
    else
        echo "Warning: Could not detect package manager. Please install OpenSSL development libraries manually:"
        echo "  - Debian/Ubuntu: sudo apt-get install libssl-dev pkg-config"
        echo "  - RHEL/CentOS: sudo yum install openssl-devel pkg-config"
        echo "  - Fedora: sudo dnf install openssl-devel pkg-config"
        echo "  - Arch: sudo pacman -S openssl pkg-config"
        echo "  - macOS: brew install openssl pkg-config"
        echo ""
        echo "Continuing without OpenSSL (some features may not work)."
    fi
    else
        echo "Warning: Cannot install OpenSSL automatically. Please install it manually:"
        echo "  sudo apt-get install -y libssl-dev pkg-config"
        echo "Continuing without OpenSSL (some features may not work)."
    fi
else
    echo "OpenSSL found: $(openssl version)"
fi

# Check for pkg-config
if ! command -v pkg-config &> /dev/null; then
    echo "  pkg-config not found. Checking if we can install it..."
    if [ "$CAN_USE_SUDO" -eq 1 ]; then
        echo "  Installing pkg-config..."
        if command -v apt-get &> /dev/null; then
        $PKG_SUDO apt-get install -y pkg-config
    elif command -v yum &> /dev/null; then
        $PKG_SUDO yum install -y pkg-config
    elif command -v dnf &> /dev/null; then
        $PKG_SUDO dnf install -y pkg-config
    elif command -v pacman &> /dev/null; then
        $PKG_SUDO pacman -S --noconfirm pkg-config
    elif command -v brew &> /dev/null; then
        brew install pkg-config
    fi
    else
        echo "  Warning: Cannot install pkg-config automatically. Please install it manually:"
        echo "    sudo apt-get install -y pkg-config"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4/6: Building Tlang compiler from source..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "This may take a few minutes (downloading Rust dependencies and compiling)..."
echo ""

# Ensure Rust/Cargo is available (auto-install if missing, no prompts)
if ! command -v cargo &>/dev/null; then
    echo "Rust not found. Installing rustup (non-interactive)..."
    if command -v curl &>/dev/null; then
        curl -sSf https://sh.rustup.rs | sh -s -- -y -q --default-toolchain stable 2>/dev/null || true
    elif command -v wget &>/dev/null; then
        wget -qO- https://sh.rustup.rs | sh -s -- -y -q --default-toolchain stable 2>/dev/null || true
    else
        echo "Error: Rust required. Install from https://rustup.rs"
        exit 1
    fi
    if [ -f "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi
fi
if ! command -v cargo &>/dev/null; then
    echo "Error: Rust/cargo not found after install. Add to PATH: export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    exit 1
fi

# Build with progress indicators - cargo automatically shows progress for downloads and compilation
# Build with proper environment for Windows
echo "Building Tlang compiler (this may take a few minutes)..."
BUILD_LOG="/tmp/tlang_build_$$.log"

if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
    # On Windows (Git Bash), check for GNU toolchain first (recommended)
    echo "Checking Rust toolchain..."
    CURRENT_TOOLCHAIN=$(rustup show active-toolchain 2>/dev/null | awk '{print $1}')
    
    if [[ "$CURRENT_TOOLCHAIN" == *"gnu"* ]]; then
        echo "  ✓ Using GNU toolchain (recommended for Git Bash)"
        export CARGO_TARGET_DIR="$(pwd)/target"
        # Ensure bundled GCC is in PATH for C dependencies during Rust build
        if [ "$BUNDLED_GCC" -eq 1 ] && [ -d "$GCC_BUNDLE_TEMP_DIR/bin" ]; then
            export PATH="$GCC_BUNDLE_TEMP_DIR/bin:$PATH"
            # Also add libexec/gcc/<version> to PATH for cc1.exe
            if [ -d "$GCC_BUNDLE_TEMP_DIR/libexec/gcc" ]; then
                GCC_VERSION_DIR=$(find "$GCC_BUNDLE_TEMP_DIR/libexec/gcc" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)
                if [ -n "$GCC_VERSION_DIR" ]; then
                    export PATH="$GCC_VERSION_DIR:$PATH"
                fi
            fi
        fi
        if ! cargo build --release 2>&1 | tee "$BUILD_LOG"; then
            echo ""
            echo "  ❌ Build failed. Check the error messages above."
            echo "  Build log saved to: $BUILD_LOG"
            echo ""
            echo "  Common issues:"
            echo "    - Missing C compiler for Rust dependencies (zstd-sys, etc.)"
            echo "    - If using bundled GCC, ensure it's properly extracted"
            echo "    - Try: export PATH=\"$GCC_BUNDLE_TEMP_DIR/bin:\$PATH\""
            rm -f "$BUILD_LOG"
            exit 1
        fi
        rm -f "$BUILD_LOG"
    elif [[ "$CURRENT_TOOLCHAIN" == *"msvc"* ]]; then
        echo "  ⚠ Using MSVC toolchain (may have issues in Git Bash)"
        echo "  Attempting to build with MSVC..."
        
        export CARGO_TARGET_DIR="$(pwd)/target"
        export TMPDIR="${TMPDIR:-/tmp}"
        export TEMP="${TEMP:-/tmp}"
        
        if ! cargo build --release 2>&1 | tee "$BUILD_LOG"; then
            echo ""
            echo "  ⚠ MSVC linker error detected. This is a known issue in Git Bash."
            echo ""
            echo "  🔧 Quick Fix: Switch to GNU toolchain (recommended):"
            echo "     rustup toolchain install stable-x86_64-pc-windows-gnu"
            echo "     rustup default stable-x86_64-pc-windows-gnu"
            echo "     Then run ./install.sh again"
            echo ""
            echo "  Alternative: Build from PowerShell/CMD instead of Git Bash"
            echo ""
            rm -f "$BUILD_LOG"
            exit 1
        fi
        rm -f "$BUILD_LOG"
    else
        # Unknown toolchain, try to build anyway
        echo "  Building with current toolchain..."
        export CARGO_TARGET_DIR="$(pwd)/target"
        if ! cargo build --release 2>&1 | tee "$BUILD_LOG"; then
            echo ""
            echo "  ❌ Build failed. Consider switching to GNU toolchain:"
            echo "     rustup toolchain install stable-x86_64-pc-windows-gnu"
            echo "     rustup default stable-x86_64-pc-windows-gnu"
            rm -f "$BUILD_LOG"
            exit 1
        fi
        rm -f "$BUILD_LOG"
    fi
else
    # Unix-like systems
    cargo build --release
fi

# Check for binaries (handle Windows .exe extension)
BINARIES_FOUND=0
if [ -f "target/release/tlangc" ] || [ -f "target/release/tlangc.exe" ]; then
    if [ -f "target/release/tlang-build" ] || [ -f "target/release/tlang-build.exe" ]; then
        if [ -f "target/release/tlang-port" ] || [ -f "target/release/tlang-port.exe" ]; then
            BINARIES_FOUND=1
        fi
    fi
fi

if [ "$BINARIES_FOUND" -eq 0 ]; then
    echo "Error: Build failed or binaries not found"
    echo ""
    echo "Expected binaries:"
    echo "  - target/release/tlangc (or tlangc.exe on Windows)"
    echo "  - target/release/tlang-build (or tlang-build.exe on Windows)"
    echo "  - target/release/tlang-port (or tlang-port.exe on Windows)"
    echo ""
    echo "Checking what files exist in target/release/:"
    ls -la target/release/ 2>/dev/null || echo "  target/release/ directory not found"
    exit 1
fi
echo "✓ Build completed successfully"
echo ""

# Create directories
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5/6: Installing binaries and creating directories..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Creating installation directories..."
# Create directories for Tlang installation
# All executables go to tlang/bin for better organization
$SUDO mkdir -p "$TLANG_BIN_DIR"
$SUDO mkdir -p "$WRAPPER_BIN_DIR"
$SUDO mkdir -p "$LIB_DIR"

# Install bundled GCC if available (Windows only)
# Install GCC executables to tlang/bin for unified executable location
if [ "$IS_WINDOWS" -eq 1 ] && [ "$BUNDLED_GCC" -eq 1 ] && [ -d "$GCC_BUNDLE_TEMP_DIR/bin" ]; then
    echo "  Installing bundled GCC compiler..."
    GCC_DIR="$INSTALL_DIR/tlang/mingw"
    # GCC executables go to tlang/bin for unified location
    GCC_BIN_DIR="$TLANG_BIN_DIR"
    GCC_LIB_DIR="$GCC_DIR/lib"
    GCC_INCLUDE_DIR="$GCC_DIR/include"
    
    $SUDO mkdir -p "$GCC_BIN_DIR"
    $SUDO mkdir -p "$GCC_LIB_DIR"
    $SUDO mkdir -p "$GCC_INCLUDE_DIR"
    
    # Copy GCC binaries, lib, include (use rsync when available for speed)
    if command -v rsync &>/dev/null; then
        $SUDO rsync -a --quiet "$GCC_BUNDLE_TEMP_DIR/bin/" "$GCC_BIN_DIR/" 2>/dev/null || $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/bin/"* "$GCC_BIN_DIR/" 2>/dev/null || true
        if [ -d "$GCC_BUNDLE_TEMP_DIR/lib" ]; then
            $SUDO rsync -a --quiet "$GCC_BUNDLE_TEMP_DIR/lib/" "$GCC_LIB_DIR/" 2>/dev/null || $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/lib/"* "$GCC_LIB_DIR/" 2>/dev/null || true
        fi
        if [ -d "$GCC_BUNDLE_TEMP_DIR/include" ]; then
            $SUDO rsync -a --quiet "$GCC_BUNDLE_TEMP_DIR/include/" "$GCC_INCLUDE_DIR/" 2>/dev/null || $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/include/"* "$GCC_INCLUDE_DIR/" 2>/dev/null || true
            echo "  ✓ GCC headers copied"
        fi
    else
        $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/bin/"* "$GCC_BIN_DIR/" 2>/dev/null || true
        [ -d "$GCC_BUNDLE_TEMP_DIR/lib" ] && $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/lib/"* "$GCC_LIB_DIR/" 2>/dev/null || true
        if [ -d "$GCC_BUNDLE_TEMP_DIR/include" ]; then
            $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/include/"* "$GCC_INCLUDE_DIR/" 2>/dev/null || true
            echo "  ✓ GCC headers copied"
        fi
    fi
    # Copy architecture-specific include directories if they exist (e.g., x86_64-w64-mingw32/include)
    ARCH_DIRS=$(find "$GCC_BUNDLE_TEMP_DIR" -maxdepth 1 -type d -name "*-w64-mingw32" 2>/dev/null)
    if [ -n "$ARCH_DIRS" ]; then
        for arch_dir in $ARCH_DIRS; do
            ARCH_NAME=$(basename "$arch_dir")
            if [ -d "$arch_dir/include" ]; then
                $SUDO mkdir -p "$GCC_DIR/$ARCH_NAME/include"
                # Copy entire include directory (cp -r is fast; avoid find -exec cp per-file)
                if command -v rsync &>/dev/null; then
                    $SUDO rsync -a --quiet "$arch_dir/include/" "$GCC_DIR/$ARCH_NAME/include/" 2>/dev/null || \
                    $SUDO cp -r "$arch_dir/include/"* "$GCC_DIR/$ARCH_NAME/include/" 2>/dev/null || true
                else
                    $SUDO cp -r "$arch_dir/include/"* "$GCC_DIR/$ARCH_NAME/include/" 2>/dev/null || true
                fi
                echo "  ✓ Architecture-specific headers ($ARCH_NAME) copied"
                
                # Verify critical headers were copied
                CRITICAL_ARCH_HEADERS=("mm_malloc.h" "malloc.h" "stdlib.h")
                for header in "${CRITICAL_ARCH_HEADERS[@]}"; do
                    if [ -f "$GCC_DIR/$ARCH_NAME/include/$header" ]; then
                        echo "    ✓ $header verified"
                    else
                        echo "    ⚠ Warning: $header not found"
                        # For mm_malloc.h, create a minimal stub if missing (some MinGW distributions don't include it)
                        if [ "$header" = "mm_malloc.h" ]; then
                            echo "    Creating minimal mm_malloc.h stub..."
                            $SUDO tee "$GCC_DIR/$ARCH_NAME/include/mm_malloc.h" > /dev/null << 'MM_MALLOC_EOF'
#ifndef _MM_MALLOC_H_INCLUDED
#define _MM_MALLOC_H_INCLUDED
#include <stdlib.h>
#include <malloc.h>
// Minimal stub for mm_malloc.h - provides basic functionality
static inline void* _mm_malloc(size_t size, size_t align) {
    (void)align; // Alignment parameter ignored in stub
    return malloc(size);
}
static inline void _mm_free(void* ptr) {
    free(ptr);
}
#endif /* _MM_MALLOC_H_INCLUDED */
MM_MALLOC_EOF
                            echo "    ✓ mm_malloc.h stub created"
                        fi
                    fi
                done
            fi
        done
    fi
    # Copy libexec directory (contains GCC internal tools like cc1.exe)
    GCC_LIBEXEC_DIR="$GCC_DIR/libexec"
    if [ -d "$GCC_BUNDLE_TEMP_DIR/libexec" ]; then
        $SUDO mkdir -p "$GCC_LIBEXEC_DIR"
        if command -v rsync &>/dev/null; then
            $SUDO rsync -a --quiet "$GCC_BUNDLE_TEMP_DIR/libexec/" "$GCC_LIBEXEC_DIR/" 2>/dev/null || $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/libexec/"* "$GCC_LIBEXEC_DIR/" 2>/dev/null || true
        else
            $SUDO cp -r "$GCC_BUNDLE_TEMP_DIR/libexec/"* "$GCC_LIBEXEC_DIR/" 2>/dev/null || true
        fi
        echo "  ✓ GCC internal tools (libexec) copied"
    fi
    
    # Cleanup temp directory
    rm -rf "$GCC_BUNDLE_TEMP_DIR" 2>/dev/null || true
    
    echo ""
    echo "✓ GCC compiler successfully installed!"
    echo "  Installation path: $GCC_DIR"
    echo "  GCC will be automatically used by tlang wrapper script"
    
    # Verify and display GCC version
    BUNDLED_GCC_EXE="$GCC_BIN_DIR/gcc.exe"
    if [ ! -f "$BUNDLED_GCC_EXE" ]; then
        BUNDLED_GCC_EXE="$GCC_BIN_DIR/gcc"
    fi
    if [ -f "$BUNDLED_GCC_EXE" ]; then
        if "$BUNDLED_GCC_EXE" --version &>/dev/null; then
            GCC_VERSION=$("$BUNDLED_GCC_EXE" --version 2>&1 | head -1)
            echo "  Installed GCC version: $GCC_VERSION"
        else
            echo "  GCC installed and ready to use"
        fi
    fi
    echo ""
fi

# Install bundled OpenSSL if available
if [ "$BUNDLED_OPENSSL" -eq 1 ] && [ -d "$BUNDLE_TEMP_DIR/lib" ]; then
    echo "  Installing bundled OpenSSL libraries..."
    $SUDO cp -r "$BUNDLE_TEMP_DIR/lib/"* "$LIB_DIR/" 2>/dev/null || true
    if [ -d "$BUNDLE_TEMP_DIR/include" ]; then
        $SUDO mkdir -p "$LIB_DIR/../include"
        $SUDO cp -r "$BUNDLE_TEMP_DIR/include/"* "$LIB_DIR/../include/" 2>/dev/null || true
    fi
    # Cleanup temp directory
    rm -rf "$BUNDLE_TEMP_DIR" 2>/dev/null || true
    echo "  ✓ OpenSSL libraries installed to: $LIB_DIR"
fi

# Install binaries to tlang/bin (unified executable location)
echo "  Installing tlangc compiler..."
$SUDO cp "target/release/tlangc" "$TLANG_BIN_DIR/tlangc" 2>/dev/null || $SUDO cp "target/release/tlangc.exe" "$TLANG_BIN_DIR/tlangc.exe" 2>/dev/null || true
$SUDO chmod +x "$TLANG_BIN_DIR/tlangc" 2>/dev/null || $SUDO chmod +x "$TLANG_BIN_DIR/tlangc.exe" 2>/dev/null || true
echo "    ✓ tlangc installed to $TLANG_BIN_DIR"

echo "  Installing tlang-build tool..."
$SUDO cp "target/release/tlang-build" "$TLANG_BIN_DIR/tlang-build" 2>/dev/null || $SUDO cp "target/release/tlang-build.exe" "$TLANG_BIN_DIR/tlang-build.exe" 2>/dev/null || true
$SUDO chmod +x "$TLANG_BIN_DIR/tlang-build" 2>/dev/null || $SUDO chmod +x "$TLANG_BIN_DIR/tlang-build.exe" 2>/dev/null || true
echo "    ✓ tlang-build installed to $TLANG_BIN_DIR"

echo "  Installing tlang-port tool..."
$SUDO cp "target/release/tlang-port" "$TLANG_BIN_DIR/tlang-port" 2>/dev/null || $SUDO cp "target/release/tlang-port.exe" "$TLANG_BIN_DIR/tlang-port.exe" 2>/dev/null || true
$SUDO chmod +x "$TLANG_BIN_DIR/tlang-port" 2>/dev/null || $SUDO chmod +x "$TLANG_BIN_DIR/tlang-port.exe" 2>/dev/null || true
echo "    ✓ tlang-port installed to $TLANG_BIN_DIR"

# Create tlang wrapper script
echo "  Creating tlang wrapper script..."
# Use temporary file to avoid tee.exe window popup on Windows
TEMP_WRAPPER=$(mktemp /tmp/tlang_wrapper_XXXXXX.sh 2>/dev/null || echo "/tmp/tlang_wrapper_$$.sh")
cat > "$TEMP_WRAPPER" << 'EOF'
#!/bin/bash
# Tlang wrapper script
# Compiles .tl files and optionally runs them

# Helper function to find binary (handles Windows .exe extension)
# Looks in tlang/bin directory (unified executable location)
find_binary() {
    local bin_name="$1"
    local script_dir="$(dirname "$0")"
    local install_base="$(dirname "$script_dir")"
    local tlang_bin_dir="$install_base/tlang/bin"
    
    # First try in tlang/bin (unified location)
    local bin_path="$tlang_bin_dir/$bin_name"
    if [ -f "$bin_path" ] && [ -x "$bin_path" ]; then
        echo "$bin_path"
        return 0
    fi
    
    # Try with .exe extension (Windows) in tlang/bin
    if [ -f "$bin_path.exe" ]; then
        echo "$bin_path.exe"
        return 0
    fi
    
    # Fallback: try in script directory (for backward compatibility)
    bin_path="$script_dir/$bin_name"
    if [ -f "$bin_path" ] && [ -x "$bin_path" ]; then
        echo "$bin_path"
        return 0
    fi
    
    # Try with .exe extension (Windows) in script directory
    if [ -f "$bin_path.exe" ]; then
        echo "$bin_path.exe"
        return 0
    fi
    
    # Binary not found
    echo ""
    return 1
}

# Get script directory and binary paths (handle Windows .exe)
SCRIPT_DIR="$(dirname "$0")"
INSTALL_BASE="$(dirname "$SCRIPT_DIR")"
# All Tlang executables are in tlang/bin (unified location)
TLANG_BIN_DIR="$INSTALL_BASE/tlang/bin"
# GCC libraries/headers are in tlang/mingw, but executables are in tlang/bin
GCC_DIR="$INSTALL_BASE/tlang/mingw"
# GCC executables are now in tlang/bin (unified location)
BUNDLED_GCC="$TLANG_BIN_DIR/gcc.exe"
if [ ! -f "$BUNDLED_GCC" ]; then
    BUNDLED_GCC="$TLANG_BIN_DIR/gcc"
fi

# Find tlangc in tlang/bin directory
TLANGC_BIN="$TLANG_BIN_DIR/tlangc"
if [ ! -f "$TLANGC_BIN" ] && [ ! -f "$TLANG_BIN_DIR/tlangc.exe" ]; then
    # Fallback: try in script directory (for backward compatibility)
    TLANGC_BIN=$(find_binary "tlangc")
    if [ -z "$TLANGC_BIN" ]; then
        echo "Error: tlangc binary not found in $TLANG_BIN_DIR or $SCRIPT_DIR" >&2
        exit 1
    fi
else
    if [ -f "$TLANG_BIN_DIR/tlangc.exe" ]; then
        TLANGC_BIN="$TLANG_BIN_DIR/tlangc.exe"
    fi
fi

# Function to find C compiler (check bundled GCC first, then system)
find_compiler() {
    # Check bundled GCC first (Windows)
    # GCC executables are now in TLANG_BIN_DIR (unified location)
    # Try multiple path variations for Windows compatibility
    local test_paths=(
        "$BUNDLED_GCC"
        "$TLANG_BIN_DIR/gcc.exe"
        "$TLANG_BIN_DIR/gcc"
        "$GCC_DIR/bin/gcc.exe"
        "$GCC_DIR/bin/gcc"
        "$INSTALL_BASE/tlang/mingw/bin/gcc.exe"
        "$INSTALL_BASE/tlang/mingw/bin/gcc"
    )
    
    for test_path in "${test_paths[@]}"; do
        # Use test -f and test -x, or try to execute with --version
        if [ -f "$test_path" ] 2>/dev/null; then
            # Try to execute it to verify it works
            if "$test_path" --version >/dev/null 2>&1; then
                echo "$test_path"
                return 0
            fi
        fi
    done
    
    # Check system GCC
    if command -v gcc &> /dev/null; then
        echo "gcc"
        return 0
    fi
    
    # Check system GCC with .exe extension (Windows)
    if command -v gcc.exe &> /dev/null; then
        echo "gcc.exe"
        return 0
    fi
    
    # Check system clang
    if command -v clang &> /dev/null; then
        echo "clang"
        return 0
    fi
    
    # Check system clang with .exe extension (Windows)
    if command -v clang.exe &> /dev/null; then
        echo "clang.exe"
        return 0
    fi
    
    # Compiler not found
    echo ""
    return 1
}

# Handle version flags first
if [ $# -eq 0 ]; then
    echo "Usage: tlang <command> [options]"
    echo ""
    echo "Commands:"
    echo "  compile <file.tl> [output]     - Compile Tlang file to executable binary"
    echo "  run [file.tl] [args]          - Compile and run Tlang file (auto-detects adhi.tl/main.tl if not specified)"
    echo "  test <file.tl>                - Run tests in Tlang file"
    echo "  build [dir]                   - Build project (compile once, run anywhere)"
    echo "  init [app_name] [dir]         - Initialize new project with config.toml"
    echo "  clean [dir]                   - Clean build artifacts"
    echo "  add <package>@<version> [dir]  - Add a package dependency"
    echo "  get <git|url> [dir]           - Fetch package from Git or URL and add to project"
    echo "  remove <package> [dir]        - Remove a package dependency"
    echo "  upgrade <package|.|*> [dir]   - Upgrade package(s) to latest version"
    echo "  port <url|package|file> [dest]- Convert Go/Rust to Tlang"
    echo "  version                      - Show installed version"
    echo "  help [command]                - Show help (optionally for a command)"
    echo ""
    echo "Flags:"
    echo "  --version, -v                - Show version"
    echo ""
    exit 1
fi

# Handle version flags
if [ "$1" = "--version" ] || [ "$1" = "-v" ] || [ "$1" = "version" ]; then
    "$TLANGC_BIN" --version 2>&1
    exit $?
fi

COMMAND="$1"
shift

case "$COMMAND" in
    compile)
        if [ $# -eq 0 ]; then
            echo "Error: No file specified"
            exit 1
        fi
        FILE="$1"
        if [ ! -f "$FILE" ]; then
            echo "Error: File not found: $FILE"
            exit 1
        fi
        
        # Determine target directory (use execution directory)
        EXEC_DIR="$(pwd)"
        TARGET_DIR="$EXEC_DIR/target"
        FILE_BASE="$(basename "$FILE" .tl)"
        
        # Create target directory if it doesn't exist
        mkdir -p "$TARGET_DIR"
        
        # Determine output binary name
        if [ $# -ge 2 ]; then
            OUTPUT_BIN="$2"
        else
            # Use target directory with filename
            if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
                OUTPUT_BIN="$TARGET_DIR/$FILE_BASE.exe"
            else
                OUTPUT_BIN="$TARGET_DIR/$FILE_BASE"
            fi
        fi
        
        # Compile Tlang to C file in target directory
        C_FILE="$TARGET_DIR/$FILE_BASE.c"
        echo "Compiling to: $C_FILE"
        "$TLANGC_BIN" "$FILE" "$C_FILE" 2>&1
        if [ $? -ne 0 ]; then
            exit 1
        fi
        
        # Find C compiler (bundled GCC first, then system)
        CC=$(find_compiler)
        if [ -z "$CC" ]; then
            echo "Error: No C compiler found (gcc or clang)" >&2
            echo "Please install a C compiler:" >&2
            echo "  - Windows: Install MinGW-w64 or MSVC Build Tools" >&2
            echo "  - Linux: sudo apt-get install gcc" >&2
            echo "  - macOS: xcode-select --install" >&2
            rm -f "$TEMP_C"
            exit 1
        fi
        
        # Check if using bundled GCC and set library paths
        IS_BUNDLED_GCC=0
        # Check if using bundled GCC (executables are in TLANG_BIN_DIR, not GCC_DIR/bin)
        if [ "$CC" = "$BUNDLED_GCC" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc.exe" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc" ]; then
            IS_BUNDLED_GCC=1
        fi
        
        # Compile C to binary with OpenSSL support
        SCRIPT_DIR="$(dirname "$0")"
        INSTALL_BASE="$(dirname "$SCRIPT_DIR")"
        OPENSSL_LIB_DIR="$INSTALL_BASE/lib"
        
        # Setup library paths and include paths for bundled GCC
        LIB_PATHS=()
        INCLUDE_PATHS=()
        if [ "$IS_BUNDLED_GCC" -eq 1 ]; then
            LIB_PATHS=("-L$GCC_DIR/lib")
            # Add include paths for bundled GCC headers (critical for finding stdio.h, stdlib.h, etc.)
            # MinGW-w64 typically has headers in include/ and possibly x86_64-w64-mingw32/include/
            # IMPORTANT: Architecture-specific include should come FIRST so headers like mm_malloc.h are found
            ARCH_INCLUDE=$(find "$GCC_DIR" -type d -name "*-w64-mingw32" 2>/dev/null | head -1)
            if [ -n "$ARCH_INCLUDE" ] && [ -d "$ARCH_INCLUDE/include" ]; then
                # Add architecture-specific include FIRST (higher priority)
                INCLUDE_PATHS=("-I$ARCH_INCLUDE/include")
            fi
            # Then add general include directory
            if [ -d "$GCC_DIR/include" ]; then
                INCLUDE_PATHS=("${INCLUDE_PATHS[@]}" "-I$GCC_DIR/include")
            fi
            # Set environment variables for bundled GCC to find its internal tools
            export PATH="$GCC_DIR/bin:$PATH"
            # GCC looks for cc1.exe in libexec/gcc/<version>/ or in the same directory
            if [ -d "$GCC_DIR/libexec/gcc" ]; then
                # Find the GCC version directory
                GCC_VERSION_DIR=$(find "$GCC_DIR/libexec/gcc" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)
                if [ -n "$GCC_VERSION_DIR" ]; then
                    export PATH="$GCC_VERSION_DIR:$PATH"
                fi
            fi
        fi
        
        if [ -d "$OPENSSL_LIB_DIR" ] && ([ -f "$OPENSSL_LIB_DIR/libssl.so" ] || [ -f "$OPENSSL_LIB_DIR/libssl.a" ]); then
            # Use bundled OpenSSL
            "$CC" -DUSE_OPENSSL -o "$OUTPUT_BIN" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -L"$OPENSSL_LIB_DIR" -lssl -lcrypto -Wl,-rpath,"$OPENSSL_LIB_DIR" 2>&1
        else
            # Use system OpenSSL
            "$CC" -DUSE_OPENSSL -o "$OUTPUT_BIN" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -lssl -lcrypto 2>&1
        fi
        
        COMPILE_RESULT=$?
        
        if [ $COMPILE_RESULT -eq 0 ]; then
            echo "Compilation successful!"
            echo "  C file: $C_FILE"
            echo "  Executable: $OUTPUT_BIN"
        else
            echo "Error: Failed to compile C to binary" >&2
            echo "C file saved at: $C_FILE" >&2
            exit 1
        fi
        ;;
    run)
        # Auto-detect entry file if not specified
        FILE=""
        PROGRAM_ARGS=()
        
        # Check if first argument is a file (ends with .tl) or just arguments
        if [ $# -eq 0 ]; then
            # No arguments - try to auto-detect entry file
            FILE=""
        elif [ -f "$1" ] || [ "${1%.tl}" != "$1" ]; then
            # First argument is a file or looks like a file path
            FILE="$1"
            shift  # Remove file from args
            PROGRAM_ARGS=("$@")  # Remaining args go to program
        else
            # First argument doesn't look like a file - treat as program arguments
            # Auto-detect entry file
            PROGRAM_ARGS=("$@")
        fi
        
        # Auto-detect entry file if not set
        if [ -z "$FILE" ]; then
            # Try to find entry file in current directory
            # Priority: 1) config.toml entry_file, 2) adhi.tl, 3) main.tl
            
            # Check for config.toml and read entry_file
            if [ -f "config.toml" ]; then
                ENTRY_FILE=$(grep -E "^entry_file\s*=" config.toml | head -1 | sed 's/.*=\s*"\([^"]*\)".*/\1/' | sed "s/.*=\s*'\([^']*\)'.*/\1/" | sed 's/.*=\s*\([^[:space:]]*\).*/\1/')
                if [ -n "$ENTRY_FILE" ] && [ -f "$ENTRY_FILE" ]; then
                    FILE="$ENTRY_FILE"
                fi
            fi
            
            # Fallback to common entry file names
            if [ -z "$FILE" ]; then
                if [ -f "adhi.tl" ]; then
                    FILE="adhi.tl"
                elif [ -f "main.tl" ]; then
                    FILE="main.tl"
                elif [ -f "src/adhi.tl" ]; then
                    FILE="src/adhi.tl"
                elif [ -f "src/main.tl" ]; then
                    FILE="src/main.tl"
                fi
            fi
            
            if [ -z "$FILE" ]; then
                echo "Error: No file specified and no entry file found"
                echo "Looking for: adhi.tl, main.tl, src/adhi.tl, src/main.tl, or entry_file in config.toml"
                exit 1
            fi
        fi
        
        if [ ! -f "$FILE" ]; then
            echo "Error: File not found: $FILE"
            exit 1
        fi
        
        # Determine target directory (use execution directory, not file's directory)
        # This ensures files are written relative to where the command is run
        EXEC_DIR="$(pwd)"
        TARGET_DIR="$EXEC_DIR/target"
        FILE_BASE="$(basename "$FILE" .tl)"
        
        # Create target directory if it doesn't exist
        mkdir -p "$TARGET_DIR"
        
        # Compile to C file in target directory (relative to execution directory)
        C_FILE="$TARGET_DIR/$FILE_BASE.c"
        if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
            BIN_FILE="$TARGET_DIR/$FILE_BASE.exe"
        else
            BIN_FILE="$TARGET_DIR/$FILE_BASE"
        fi
        
        # Compile Tlang to C file in target directory (quiet mode like Go)
        "$TLANGC_BIN" "$FILE" "$C_FILE" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            # If quiet compilation fails, show errors
            "$TLANGC_BIN" "$FILE" "$C_FILE" 2>&1
            exit 1
        fi
        
        # Find C compiler (bundled GCC first, then system)
        CC=$(find_compiler)
        if [ -z "$CC" ]; then
            echo "Error: No C compiler found (gcc or clang)" >&2
            echo "Please install a C compiler:" >&2
            echo "  - Windows: Install MinGW-w64 or MSVC Build Tools" >&2
            echo "  - Linux: sudo apt-get install gcc" >&2
            echo "  - macOS: xcode-select --install" >&2
            exit 1
        fi
        
        # Check if using bundled GCC and set library paths
        IS_BUNDLED_GCC=0
        # Check if using bundled GCC (executables are in TLANG_BIN_DIR, not GCC_DIR/bin)
        if [ "$CC" = "$BUNDLED_GCC" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc.exe" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc" ]; then
            IS_BUNDLED_GCC=1
        fi
        
        # Compile C to binary with OpenSSL support
        # Use bundled OpenSSL if available, otherwise system OpenSSL
        SCRIPT_DIR="$(dirname "$0")"
        INSTALL_BASE="$(dirname "$SCRIPT_DIR")"
        OPENSSL_LIB_DIR="$INSTALL_BASE/lib"
        
        # Setup library paths and include paths for bundled GCC
        LIB_PATHS=()
        INCLUDE_PATHS=()
        if [ "$IS_BUNDLED_GCC" -eq 1 ]; then
            LIB_PATHS=("-L$GCC_DIR/lib")
            # Add include paths for bundled GCC headers (critical for finding stdio.h, stdlib.h, etc.)
            # MinGW-w64 typically has headers in include/ and possibly x86_64-w64-mingw32/include/
            # IMPORTANT: Architecture-specific include should come FIRST so headers like mm_malloc.h are found
            ARCH_INCLUDE=$(find "$GCC_DIR" -type d -name "*-w64-mingw32" 2>/dev/null | head -1)
            if [ -n "$ARCH_INCLUDE" ] && [ -d "$ARCH_INCLUDE/include" ]; then
                # Add architecture-specific include FIRST (higher priority)
                INCLUDE_PATHS=("-I$ARCH_INCLUDE/include")
            fi
            # Then add general include directory
            if [ -d "$GCC_DIR/include" ]; then
                INCLUDE_PATHS=("${INCLUDE_PATHS[@]}" "-I$GCC_DIR/include")
            fi
            # Set environment variables for bundled GCC to find its internal tools
            export PATH="$GCC_DIR/bin:$PATH"
            # GCC looks for cc1.exe in libexec/gcc/<version>/ or in the same directory
            if [ -d "$GCC_DIR/libexec/gcc" ]; then
                # Find the GCC version directory
                GCC_VERSION_DIR=$(find "$GCC_DIR/libexec/gcc" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)
                if [ -n "$GCC_VERSION_DIR" ]; then
                    export PATH="$GCC_VERSION_DIR:$PATH"
                fi
            fi
        fi
        
        # Compile C to binary (quiet mode like Go, only show errors)
        COMPILE_OUTPUT=""
        if [ -d "$OPENSSL_LIB_DIR" ] && ([ -f "$OPENSSL_LIB_DIR/libssl.so" ] || [ -f "$OPENSSL_LIB_DIR/libssl.a" ]); then
            # Use bundled OpenSSL
            COMPILE_OUTPUT=$("$CC" -DUSE_OPENSSL -o "$BIN_FILE" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -L"$OPENSSL_LIB_DIR" -lssl -lcrypto -Wl,-rpath,"$OPENSSL_LIB_DIR" 2>&1)
        else
            # Use system OpenSSL (or no OpenSSL if not available)
            # Try with OpenSSL first, fallback to without if it fails
            COMPILE_OUTPUT=$("$CC" -DUSE_OPENSSL -o "$BIN_FILE" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -lssl -lcrypto 2>&1)
            if [ $? -ne 0 ]; then
                # Try without OpenSSL (for simple programs that don't need it)
                COMPILE_OUTPUT=$("$CC" -o "$BIN_FILE" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" 2>&1)
            fi
        fi
        
        if [ $? -ne 0 ]; then
            # Show compilation errors (like Go does)
            echo "$COMPILE_OUTPUT" >&2
            echo "Error: C compilation failed" >&2
            echo "C file saved at: $C_FILE" >&2
            exit 1
        fi
        
        # Run binary with program arguments (if any) - like go run
        if [ ${#PROGRAM_ARGS[@]} -gt 0 ]; then
            "$BIN_FILE" "${PROGRAM_ARGS[@]}"
        else
            "$BIN_FILE"
        fi
        EXIT_CODE=$?
        
        # Clean up binary after running (like go run does)
        # Keep C file for debugging, but remove binary to mimic go run behavior
        rm -f "$BIN_FILE" 2>/dev/null || true
        
        exit $EXIT_CODE
        ;;
    build)
        # Build project - use provided directory or current directory
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        (cd "$PROJECT_DIR" && "$BUILD_BIN" build)
        ;;
    init)
        # Initialize project - app_name [directory]
        # If first arg is a directory (exists or starts with . or /), treat as directory
        # Otherwise treat as app name
        if [ $# -eq 0 ]; then
            PROJECT_DIR="."
            APP_NAME=""
        elif [ -d "$1" ] || [ "${1#.}" != "$1" ] || [ "${1#/}" != "$1" ]; then
            # First arg looks like a directory
            PROJECT_DIR="$1"
            APP_NAME=""
        else
            # First arg is app name
            APP_NAME="$1"
            PROJECT_DIR="${2:-.}"
        fi
        
        if [ ! -d "$PROJECT_DIR" ]; then
            mkdir -p "$PROJECT_DIR" || exit 1
        fi
        
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        
        if [ -n "$APP_NAME" ]; then
            (cd "$PROJECT_DIR" && "$BUILD_BIN" init "$APP_NAME")
        else
            (cd "$PROJECT_DIR" && "$BUILD_BIN" init)
        fi
        ;;
    clean)
        # Clean project - use provided directory or current directory
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        cd "$PROJECT_DIR" || exit 1
        "$BUILD_BIN" clean
        ;;
    test)
        if [ $# -eq 0 ]; then
            echo "Error: No file specified"
            exit 1
        fi
        FILE="$1"
        if [ ! -f "$FILE" ]; then
            echo "Error: File not found: $FILE"
            exit 1
        fi
        
        # Determine target directory (use execution directory)
        EXEC_DIR="$(pwd)"
        TARGET_DIR="$EXEC_DIR/target"
        FILE_BASE="$(basename "$FILE" .tl)"
        
        # Create target directory if it doesn't exist
        mkdir -p "$TARGET_DIR"
        
        # Compile and run test file
        C_FILE="$TARGET_DIR/$FILE_BASE.c"
        if [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]]; then
            BIN_FILE="$TARGET_DIR/$FILE_BASE.exe"
        else
            BIN_FILE="$TARGET_DIR/$FILE_BASE"
        fi
        
        echo "Compiling to: $C_FILE"
        "$TLANGC_BIN" "$FILE" "$C_FILE" 2>&1
        if [ $? -ne 0 ]; then
            exit 1
        fi
        # Find C compiler (bundled GCC first, then system)
        CC=$(find_compiler)
        if [ -z "$CC" ]; then
            echo "Error: No C compiler found (gcc or clang)" >&2
            echo "Please install a C compiler:" >&2
            echo "  - Windows: Install MinGW-w64 or MSVC Build Tools" >&2
            echo "  - Linux: sudo apt-get install gcc" >&2
            echo "  - macOS: xcode-select --install" >&2
            exit 1
        fi
        
        # Check if using bundled GCC and set library paths
        IS_BUNDLED_GCC=0
        # Check if using bundled GCC (executables are in TLANG_BIN_DIR, not GCC_DIR/bin)
        if [ "$CC" = "$BUNDLED_GCC" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc.exe" ] || [ "$CC" = "$TLANG_BIN_DIR/gcc" ]; then
            IS_BUNDLED_GCC=1
        fi
        
        # Use bundled OpenSSL if available
        SCRIPT_DIR="$(dirname "$0")"
        INSTALL_BASE="$(dirname "$SCRIPT_DIR")"
        OPENSSL_LIB_DIR="$INSTALL_BASE/lib"
        
        # Setup library paths and include paths for bundled GCC
        LIB_PATHS=()
        INCLUDE_PATHS=()
        if [ "$IS_BUNDLED_GCC" -eq 1 ]; then
            LIB_PATHS=("-L$GCC_DIR/lib")
            # Add include paths for bundled GCC headers (critical for finding stdio.h, stdlib.h, etc.)
            # MinGW-w64 typically has headers in include/ and possibly x86_64-w64-mingw32/include/
            # IMPORTANT: Architecture-specific include should come FIRST so headers like mm_malloc.h are found
            ARCH_INCLUDE=$(find "$GCC_DIR" -type d -name "*-w64-mingw32" 2>/dev/null | head -1)
            if [ -n "$ARCH_INCLUDE" ] && [ -d "$ARCH_INCLUDE/include" ]; then
                # Add architecture-specific include FIRST (higher priority)
                INCLUDE_PATHS=("-I$ARCH_INCLUDE/include")
            fi
            # Then add general include directory
            if [ -d "$GCC_DIR/include" ]; then
                INCLUDE_PATHS=("${INCLUDE_PATHS[@]}" "-I$GCC_DIR/include")
            fi
            # Set environment variables for bundled GCC to find its internal tools
            export PATH="$GCC_DIR/bin:$PATH"
            # GCC looks for cc1.exe in libexec/gcc/<version>/ or in the same directory
            if [ -d "$GCC_DIR/libexec/gcc" ]; then
                # Find the GCC version directory
                GCC_VERSION_DIR=$(find "$GCC_DIR/libexec/gcc" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -1)
                if [ -n "$GCC_VERSION_DIR" ]; then
                    export PATH="$GCC_VERSION_DIR:$PATH"
                fi
            fi
        fi
        
        if [ -d "$OPENSSL_LIB_DIR" ] && ([ -f "$OPENSSL_LIB_DIR/libssl.so" ] || [ -f "$OPENSSL_LIB_DIR/libssl.a" ]); then
            # Use bundled OpenSSL
            "$CC" -DUSE_OPENSSL -o "$BIN_FILE" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -L"$OPENSSL_LIB_DIR" -lssl -lcrypto -Wl,-rpath,"$OPENSSL_LIB_DIR" 2>&1
        else
            # Use system OpenSSL
            "$CC" -DUSE_OPENSSL -o "$BIN_FILE" "$C_FILE" -lm "${INCLUDE_PATHS[@]}" "${LIB_PATHS[@]}" -lssl -lcrypto 2>&1
        fi
        
        if [ $? -ne 0 ]; then
            echo "Error: C compilation failed" >&2
            echo "C file saved at: $C_FILE" >&2
            exit 1
        fi
        "$BIN_FILE"
        EXIT_CODE=$?
        # Note: C file and binary are kept in target/ directory for debugging
        exit $EXIT_CODE
        ;;
    add)
        # Add package - package@version [directory]
        if [ $# -eq 0 ]; then
            echo "Error: Package name required"
            echo "Usage: tlang add <package>@<version> [directory]"
            exit 1
        fi
        PACKAGE_SPEC="$1"
        shift
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        (cd "$PROJECT_DIR" && "$BUILD_BIN" add "$PACKAGE_SPEC")
        ;;
    get)
        # Fetch package from Git or URL and add to project - url [directory]
        if [ $# -eq 0 ]; then
            echo "Error: URL required"
            echo "Usage: tlang get <git|url> [directory]"
            echo "  Example: tlang get https://github.com/user/repo"
            exit 1
        fi
        PACKAGE_URL="$1"
        shift
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        (cd "$PROJECT_DIR" && "$BUILD_BIN" add "$PACKAGE_URL")
        ;;
    remove)
        # Remove package - package [directory]
        if [ $# -eq 0 ]; then
            echo "Error: Package name required"
            echo "Usage: tlang remove <package> [directory]"
            exit 1
        fi
        PACKAGE_NAME="$1"
        shift
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        (cd "$PROJECT_DIR" && "$BUILD_BIN" remove "$PACKAGE_NAME")
        ;;
    upgrade)
        # Upgrade package - package|.|* [directory]
        if [ $# -eq 0 ]; then
            echo "Error: Package name required (use '.' or '*' for all packages)"
            echo "Usage: tlang upgrade <package|.|*> [directory]"
            exit 1
        fi
        PACKAGE_SPEC="$1"
        shift
        PROJECT_DIR="${1:-.}"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo "Error: Directory not found: $PROJECT_DIR"
            exit 1
        fi
        BUILD_BIN=$(find_binary "tlang-build")
        if [ -z "$BUILD_BIN" ]; then
            echo "Error: tlang-build binary not found" >&2
            exit 1
        fi
        (cd "$PROJECT_DIR" && "$BUILD_BIN" upgrade "$PACKAGE_SPEC")
        ;;
    help)
        if [ $# -ge 1 ]; then
            case "$1" in
                compile) echo "tlang compile <file.tl> [output] - Compile Tlang file to executable binary"; exit 0 ;;
                run) echo "tlang run [file.tl] [args] - Compile and run (auto-detects adhi.tl/main.tl)" ; exit 0 ;;
                test) echo "tlang test <file.tl> - Run tests in Tlang file"; exit 0 ;;
                build) echo "tlang build [dir] - Build project"; exit 0 ;;
                init) echo "tlang init [app_name] [dir] - Initialize new project"; exit 0 ;;
                clean) echo "tlang clean [dir] - Clean build artifacts"; exit 0 ;;
                add) echo "tlang add <package>@<version> [dir] - Add package dependency"; exit 0 ;;
                get) echo "tlang get <git|url> [dir] - Fetch package from Git/URL and add to project"; exit 0 ;;
                remove) echo "tlang remove <package> [dir] - Remove package dependency"; exit 0 ;;
                upgrade) echo "tlang upgrade <package|.|*> [dir] - Upgrade package(s)"; exit 0 ;;
                port) echo "tlang port <url|package|file> [dest] - Convert Go/Rust to Tlang"; exit 0 ;;
                version) echo "tlang version - Show installed version"; exit 0 ;;
                *) echo "Unknown command: $1"; exit 1 ;;
            esac
        fi
        # No args: show full help (handled by initial block above, but we reach here if user ran "tlang help")
        echo "Usage: tlang <command> [options]"
        echo ""
        echo "Commands:"
        echo "  compile <file.tl> [output]     - Compile Tlang file to executable binary"
        echo "  run [file.tl] [args]          - Compile and run Tlang file (auto-detects adhi.tl/main.tl if not specified)"
        echo "  test <file.tl>                - Run tests in Tlang file"
        echo "  build [dir]                   - Build project (compile once, run anywhere)"
        echo "  init [app_name] [dir]         - Initialize new project with config.toml"
        echo "  clean [dir]                   - Clean build artifacts"
        echo "  add <package>@<version> [dir]  - Add a package dependency"
        echo "  get <git|url> [dir]           - Fetch package from Git or URL and add to project"
        echo "  remove <package> [dir]        - Remove a package dependency"
        echo "  upgrade <package|.|*> [dir]   - Upgrade package(s) to latest version"
        echo "  port <url|package|file> [dest]- Convert Go/Rust to Tlang"
        echo "  version                      - Show installed version"
        echo "  help [command]                - Show help (optionally for a command)"
        echo ""
        echo "Flags:"
        echo "  --version, -v                - Show version"
        exit 0
        ;;
    version)
        # Show version (handled above, but keep for consistency)
        "$TLANGC_BIN" --version 2>&1
        ;;
    port)
        # Port Go code to Tlang
        shift
        PORT_BIN=$(find_binary "tlang-port")
        if [ -z "$PORT_BIN" ]; then
            echo "Error: tlang-port binary not found" >&2
            exit 1
        fi
        "$PORT_BIN" "$@"
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Run 'tlang' for usage information"
        exit 1
        ;;
esac
EOF

# Copy temporary file to final location with sudo if needed
$SUDO cp "$TEMP_WRAPPER" "$TLANG_BIN"
$SUDO chmod +x "$TLANG_BIN"
# Cleanup temporary file
rm -f "$TEMP_WRAPPER" 2>/dev/null || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 6/6: Configuring PATH..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Checking if $WRAPPER_BIN_DIR and $TLANG_BIN_DIR are in PATH..."

# Check if WRAPPER_BIN_DIR (for tlang wrapper) and TLANG_BIN_DIR (for all executables) are in PATH
WRAPPER_IN_PATH=0
TLANG_BIN_IN_PATH=0
if [[ ":$PATH:" == *":$WRAPPER_BIN_DIR:"* ]]; then
    WRAPPER_IN_PATH=1
fi
if [[ ":$PATH:" == *":$TLANG_BIN_DIR:"* ]]; then
    TLANG_BIN_IN_PATH=1
fi

if [ "$WRAPPER_IN_PATH" -eq 0 ] || [ "$TLANG_BIN_IN_PATH" -eq 0 ]; then
    echo "  ⚠ PATH configuration needed"
    echo "  Attempting to configure PATH..."
    if [ -n "$SYSTEM_INSTALL" ]; then
        echo "Add these lines to your ~/.bashrc or ~/.zshrc:"
        echo "  export PATH=\"\$PATH:$WRAPPER_BIN_DIR\"  # For tlang wrapper"
        echo "  export PATH=\"\$PATH:$TLANG_BIN_DIR\"    # For all Tlang executables"
    else
        # User installation - try to add to shell config automatically
        SHELL_CONFIG=""
        # On Windows Git Bash, check for .bashrc first, then .bash_profile
        if [ -f "$HOME/.bashrc" ]; then
            SHELL_CONFIG="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        elif [ -f "$HOME/.zshrc" ]; then
            SHELL_CONFIG="$HOME/.zshrc"
        elif [ -f "$HOME/.profile" ]; then
            SHELL_CONFIG="$HOME/.profile"
        fi
        
        if [ -n "$SHELL_CONFIG" ]; then
            PATH_ADDED=0
            # Add wrapper bin directory (for tlang command)
            if [ "$WRAPPER_IN_PATH" -eq 0 ]; then
                ESCAPED_WRAPPER_BIN_DIR=$(echo "$WRAPPER_BIN_DIR" | sed 's/[\/&]/\\&/g')
                if ! grep -q "$ESCAPED_WRAPPER_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null && ! grep -q "$WRAPPER_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
                    echo "  Adding $WRAPPER_BIN_DIR to PATH in $SHELL_CONFIG..."
                    # Check if file ends with newline
                    if [ -s "$SHELL_CONFIG" ] && [ "$(tail -c 1 "$SHELL_CONFIG" 2>/dev/null)" != "" ]; then
                        echo "" >> "$SHELL_CONFIG"
                    fi
                    echo "# Tlang wrapper script directory" >> "$SHELL_CONFIG"
                    echo "export PATH=\"\$PATH:$WRAPPER_BIN_DIR\"" >> "$SHELL_CONFIG"
                    PATH_ADDED=1
                    # Verify it was written
                    if grep -q "$WRAPPER_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
                        echo "    ✓ Added wrapper PATH entry to $SHELL_CONFIG (verified)"
                    else
                        echo "    ⚠ Warning: PATH entry may not have been written correctly"
                    fi
                fi
            fi
            
            # Add Tlang bin directory (for all executables: tlangc, tlang-build, tlang-port, gcc, etc.)
            if [ "$TLANG_BIN_IN_PATH" -eq 0 ]; then
                ESCAPED_TLANG_BIN_DIR=$(echo "$TLANG_BIN_DIR" | sed 's/[\/&]/\\&/g')
                if ! grep -q "$ESCAPED_TLANG_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null && ! grep -q "$TLANG_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
                    echo "  Adding $TLANG_BIN_DIR to PATH in $SHELL_CONFIG..."
                    echo "# Tlang executables directory (tlangc, tlang-build, tlang-port, gcc, etc.)" >> "$SHELL_CONFIG"
                    echo "export PATH=\"\$PATH:$TLANG_BIN_DIR\"" >> "$SHELL_CONFIG"
                    PATH_ADDED=1
                    # Verify it was written
                    if grep -q "$TLANG_BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
                        echo "    ✓ Added Tlang executables PATH entry to $SHELL_CONFIG (verified)"
                    else
                        echo "    ⚠ Warning: PATH entry may not have been written correctly"
                    fi
                fi
            fi
            
            if [ "$PATH_ADDED" -eq 1 ]; then
                echo ""
                echo "  ✓ PATH configured successfully!"
                echo "  To use Tlang in this terminal, run:"
                echo "    1. source $SHELL_CONFIG"
                echo "    2. Or restart your terminal"
                echo ""
                echo "  To verify PATH is set:"
                echo "    1. echo \$PATH | grep $TLANG_BIN_DIR"
                echo "    2. Or: which tlang"
            else
                echo "  ✓ PATH already configured in $SHELL_CONFIG"
                echo "  To verify: grep '$TLANG_BIN_DIR' $SHELL_CONFIG"
            fi
        else
            echo "  ⚠ No shell configuration file found."
            echo ""
            echo "  Please manually add these lines to your shell configuration file:"
            echo "      export PATH=\"\$PATH:$WRAPPER_BIN_DIR\"  # For tlang wrapper"
            echo "      export PATH=\"\$PATH:$TLANG_BIN_DIR\"    # For all Tlang executables"
            echo ""
            echo "  After adding, run: source ~/.bashrc  (or restart terminal)"
        fi
    fi
else
    echo "  ✓ PATH already configured"
    if [ "$WRAPPER_IN_PATH" -eq 1 ]; then
        echo "    ✓ $WRAPPER_BIN_DIR is in PATH (for tlang wrapper)"
    fi
    if [ "$TLANG_BIN_IN_PATH" -eq 1 ]; then
        echo "    ✓ $TLANG_BIN_DIR is in PATH (for all executables)"
    fi
fi
echo ""

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "=== Installation Complete ==="
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Tlang wrapper script: $TLANG_BIN"
echo "Tlang executables:    $TLANG_BIN_DIR"
echo "  - tlangc (compiler)"
echo "  - tlang-build (build system)"
echo "  - tlang-port (porting tool)"
if [ "$IS_WINDOWS" -eq 1 ] && [ "$BUNDLED_GCC" -eq 1 ]; then
    echo "  - gcc.exe (bundled compiler)"
    echo ""
    echo "GCC compiler bundled and ready to use"
fi
echo ""
echo "All executables are in: $TLANG_BIN_DIR"
echo ""
echo ""
echo "Usage:"
echo "  tlang run [file.tl] [args]   - Compile and run (like 'go run'), auto-detects entry file"
echo "  tlang compile <file.tl> [output] - Compile to executable (like 'go build')"
echo "  tlang port <url|file> [dest] - Convert Go/Rust to Tlang"
echo "  tlang get <url> [dir]       - Fetch package from Git/URL and add to project"
echo "  tlang test <file.tl>        - Run tests"
echo "  tlang build [dir]           - Build project"
echo "  tlang init [app_name] [dir] - Initialize project"
echo "  tlang clean [dir]           - Clean build artifacts"
echo "  tlang add <pkg>@<ver> [dir] - Add package dependency"
echo "  tlang remove <pkg> [dir]    - Remove package dependency"
echo "  tlang upgrade <pkg|.|*> [dir] - Upgrade package(s)"
echo "  tlang version              - Show installed version"
echo "  tlang help [command]       - Show help"
echo ""
