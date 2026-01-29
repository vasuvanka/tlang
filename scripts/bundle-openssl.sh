#!/bin/bash
# Bundle OpenSSL libraries for Tlang installation
# This script downloads and bundles OpenSSL libraries for distribution

set -e

BUNDLE_DIR="${1:-./bundled-openssl}"
ARCH="${2:-$(uname -m)}"

echo "=== Bundling OpenSSL Libraries ==="
echo "Target directory: $BUNDLE_DIR"
echo "Architecture: $ARCH"
echo ""

# Create bundle directory
mkdir -p "$BUNDLE_DIR/lib"
mkdir -p "$BUNDLE_DIR/include"
mkdir -p "$BUNDLE_DIR/bin"

# Detect OS
OS="$(uname -s)"
case "$OS" in
    MINGW*|MSYS*|CYGWIN*)
        echo "Detected: Windows (MINGW/MSYS)"
        echo "Note: On Windows, OpenSSL bundling is handled by bundle-openssl.ps1"
        echo "For now, using system OpenSSL or skipping bundling."
        echo "OpenSSL bundling skipped (use bundle-openssl.ps1 for Windows)"
        exit 0
        ;;
    Linux*)
        echo "Detected: Linux"
        
        # Check if OpenSSL is installed
        if ! command -v openssl &> /dev/null; then
            echo "Error: OpenSSL not found. Please install OpenSSL development libraries first."
            echo "  Debian/Ubuntu: sudo apt-get install libssl-dev"
            echo "  RHEL/CentOS: sudo yum install openssl-devel"
            exit 1
        fi
        
        # Find OpenSSL libraries
        OPENSSL_LIB_DIR=""
        if [ -f "/usr/lib/x86_64-linux-gnu/libssl.so" ]; then
            OPENSSL_LIB_DIR="/usr/lib/x86_64-linux-gnu"
        elif [ -f "/usr/lib64/libssl.so" ]; then
            OPENSSL_LIB_DIR="/usr/lib64"
        elif [ -f "/usr/lib/libssl.so" ]; then
            OPENSSL_LIB_DIR="/usr/lib"
        else
            # Try pkg-config
            OPENSSL_LIB_DIR=$(pkg-config --variable=libdir openssl 2>/dev/null || echo "")
        fi
        
        if [ -z "$OPENSSL_LIB_DIR" ] || [ ! -d "$OPENSSL_LIB_DIR" ]; then
            echo "Error: Could not find OpenSSL library directory"
            exit 1
        fi
        
        echo "Found OpenSSL libraries at: $OPENSSL_LIB_DIR"
        
        # Copy shared libraries
        if [ -f "$OPENSSL_LIB_DIR/libssl.so" ]; then
            cp "$OPENSSL_LIB_DIR/libssl.so"* "$BUNDLE_DIR/lib/" 2>/dev/null || true
            cp "$OPENSSL_LIB_DIR/libcrypto.so"* "$BUNDLE_DIR/lib/" 2>/dev/null || true
        fi
        
        # Copy static libraries if available
        if [ -f "$OPENSSL_LIB_DIR/libssl.a" ]; then
            cp "$OPENSSL_LIB_DIR/libssl.a" "$BUNDLE_DIR/lib/" 2>/dev/null || true
            cp "$OPENSSL_LIB_DIR/libcrypto.a" "$BUNDLE_DIR/lib/" 2>/dev/null || true
        fi
        
        # Copy headers
        OPENSSL_INCLUDE_DIR=$(pkg-config --variable=includedir openssl 2>/dev/null || echo "/usr/include")
        if [ -d "$OPENSSL_INCLUDE_DIR/openssl" ]; then
            cp -r "$OPENSSL_INCLUDE_DIR/openssl" "$BUNDLE_DIR/include/" 2>/dev/null || true
        fi
        
        echo "OpenSSL libraries bundled successfully"
        ;;
        
    Darwin*)
        echo "Detected: macOS"
        
        # Check for Homebrew OpenSSL
        if [ -d "/usr/local/opt/openssl" ]; then
            OPENSSL_DIR="/usr/local/opt/openssl"
        elif [ -d "/opt/homebrew/opt/openssl" ]; then
            OPENSSL_DIR="/opt/homebrew/opt/openssl"
        else
            echo "Error: OpenSSL not found. Install with: brew install openssl"
            exit 1
        fi
        
        echo "Found OpenSSL at: $OPENSSL_DIR"
        
        # Copy libraries
        if [ -d "$OPENSSL_DIR/lib" ]; then
            cp "$OPENSSL_DIR/lib/libssl."* "$BUNDLE_DIR/lib/" 2>/dev/null || true
            cp "$OPENSSL_DIR/lib/libcrypto."* "$BUNDLE_DIR/lib/" 2>/dev/null || true
        fi
        
        # Copy headers
        if [ -d "$OPENSSL_DIR/include/openssl" ]; then
            cp -r "$OPENSSL_DIR/include/openssl" "$BUNDLE_DIR/include/" 2>/dev/null || true
        fi
        
        echo "OpenSSL libraries bundled successfully"
        ;;
        
    *)
        echo "Error: Unsupported OS: $OS"
        echo "Please bundle OpenSSL manually or use system OpenSSL"
        exit 1
        ;;
esac

# Verify bundled files
echo ""
echo "Bundled files:"
ls -lh "$BUNDLE_DIR/lib/" 2>/dev/null || echo "No libraries found"
echo ""
echo "=== OpenSSL Bundling Complete ==="
echo "Bundle directory: $BUNDLE_DIR"
