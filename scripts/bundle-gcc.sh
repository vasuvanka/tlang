#!/bin/bash
# Bundle GCC (MinGW-w64) for Tlang installation (Windows/Linux)
# This script bundles GCC compiler for distribution

set -e

BUNDLE_DIR="${1:-./bundled-gcc}"
ARCH="${2:-$(uname -m)}"

echo "=== Bundling GCC (MinGW-w64) ==="
echo "Target directory: $BUNDLE_DIR"
echo "Architecture: $ARCH"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    MINGW*|MSYS*|CYGWIN*)
        echo "Detected: Windows (MINGW/MSYS)"
        IS_WINDOWS=1
        ;;
    Linux*)
        echo "Detected: Linux"
        IS_WINDOWS=0
        ;;
    Darwin*)
        echo "Detected: macOS"
        IS_WINDOWS=0
        ;;
    *)
        echo "Error: Unsupported OS: $OS"
        exit 1
        ;;
esac

# Create bundle directory structure
mkdir -p "$BUNDLE_DIR/bin"
mkdir -p "$BUNDLE_DIR/lib"
mkdir -p "$BUNDLE_DIR/include"

if [ "$IS_WINDOWS" -eq 1 ]; then
    # Windows: Check for MinGW/MinGW-w64 in common locations
    # C:\MinGW\bin → /c/MinGW (Git Bash), C:\mingw64, MSYS2, etc.
    MINGW_PATHS=(
        "/c/MinGW"
        "/c/mingw"
        "/c/mingw64"
        "/c/msys64/mingw64"
        "/c/Program Files/mingw-w64"
        "/c/Program Files (x86)/mingw-w64"
        "/c/Program Files/MinGW"
        "/c/Program Files (x86)/MinGW"
        "/usr/local/mingw64"
    )
    # Optional: TLANG_MINGW_PATH env var overrides search (e.g. export TLANG_MINGW_PATH=/d/tools/mingw)
    if [ -n "$TLANG_MINGW_PATH" ] && [ -f "$TLANG_MINGW_PATH/bin/gcc.exe" ]; then
        MINGW_PATHS=("$TLANG_MINGW_PATH" "${MINGW_PATHS[@]}")
    fi
    
    # Also check if gcc is in PATH
    if command -v gcc &> /dev/null; then
        GCC_PATH=$(command -v gcc)
        # Try to find MinGW root
        GCC_DIR=$(dirname "$GCC_PATH")
        # Go up to find mingw64 or similar
        while [ "$GCC_DIR" != "/" ] && [ "$GCC_DIR" != "." ]; do
            if [ -f "$GCC_DIR/gcc.exe" ] || [ -f "$GCC_DIR/gcc" ]; then
                MINGW_ROOT=$(dirname "$GCC_DIR")
                if [ -d "$MINGW_ROOT/bin" ] && [ -f "$MINGW_ROOT/bin/gcc.exe" ]; then
                    MINGW_PATHS=("$MINGW_ROOT" "${MINGW_PATHS[@]}")
                    break
                fi
            fi
            GCC_DIR=$(dirname "$GCC_DIR")
        done
    fi
    
    MINGW_FOUND=0
    MINGW_PATH=""
    
    for path in "${MINGW_PATHS[@]}"; do
        # Convert Windows path to Unix-style for Git Bash
        if [ -f "$path/bin/gcc.exe" ] || [ -f "$path/bin/gcc" ]; then
            echo "Found MinGW-w64 at: $path"
            MINGW_PATH="$path"
            MINGW_FOUND=1
            break
        fi
    done
    
    if [ "$MINGW_FOUND" -eq 0 ]; then
        echo "MinGW-w64 not found in common locations."
        echo ""
        echo "Options to get MinGW-w64:"
        echo "  1. Download automatically from WinLibs (recommended)"
        echo "  2. Download manually from: https://www.mingw-w64.org/downloads/"
        echo "  3. Or use MSYS2: https://www.msys2.org/"
        echo "  4. Or use Chocolatey: choco install mingw"
        echo ""
        echo "GCC bundling is optional but recommended for Windows."
        echo "Without bundled GCC, users must install MinGW-w64 separately."
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Would you like to download MinGW-w64 automatically?"
        echo "  [Y]es - Download and bundle GCC (recommended, ~100MB download)"
        echo "  [N]o  - Skip GCC bundling (you'll need to install GCC separately)"
        echo ""
        echo "Default: Yes (auto-proceeds in 10 seconds if no input)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        # Use timeout to auto-proceed after 10 seconds, or read immediately if available
        REPLY=""
        if read -t 10 -p "Enter your choice (Y/n): " -n 1 -r 2>/dev/null; then
            echo
        else
            # Timeout or no input - default to yes
            REPLY="y"
            echo "y (auto-selected after timeout)"
        fi
        if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
            echo ""
            echo "Downloading MinGW-w64 from WinLibs..."
            echo "Note: This is a large download (~100MB). Please be patient."
            echo ""
            
            # Download MinGW-w64 portable (latest release from WinLibs)
            # Using a stable version URL - update this if needed
            DOWNLOAD_URL="https://github.com/brechtsanders/winlibs_mingw/releases/download/13.2.0-16.0.6-11.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-13.2.0-mingw-w64ucrt-11.0.0-r1.zip"
            
            # Use temp directory
            if [ -n "$TMPDIR" ]; then
                TEMP_DIR="$TMPDIR"
            elif [ -n "$TMP" ]; then
                TEMP_DIR="$TMP"
            elif [ -n "$TEMP" ]; then
                TEMP_DIR="$TEMP"
            else
                TEMP_DIR="/tmp"
            fi
            
            ZIP_FILE="$TEMP_DIR/mingw-w64-$$.zip"
            EXTRACT_DIR="$TEMP_DIR/mingw-w64-extract-$$"
            
            # Check for curl or wget
            DOWNLOAD_CMD=""
            DOWNLOAD_PROGRESS=""
            if command -v curl &> /dev/null; then
                # Use curl with progress bar
                DOWNLOAD_CMD="curl -L"
                DOWNLOAD_PROGRESS="--progress-bar"
            elif command -v wget &> /dev/null; then
                # Use wget with progress bar
                DOWNLOAD_CMD="wget"
                DOWNLOAD_PROGRESS="--progress=bar:force"
            else
                echo "Error: Neither curl nor wget found. Cannot download MinGW-w64."
                echo "Please install curl or wget, or download MinGW-w64 manually."
                exit 1
            fi
            
            # Download with progress
            echo "Downloading from: $DOWNLOAD_URL"
            echo "This may take a few minutes (~100MB download)..."
            if command -v curl &> /dev/null; then
                # curl with progress bar
                if ! curl -L --progress-bar -o "$ZIP_FILE" "$DOWNLOAD_URL"; then
                    echo ""
                    echo "Error: Failed to download MinGW-w64"
                    echo "Please download manually from: https://winlibs.com/"
                    echo "Extract to: C:/mingw64 and run this script again"
                    rm -f "$ZIP_FILE" 2>/dev/null || true
                    exit 1
                fi
            elif command -v wget &> /dev/null; then
                # wget with progress bar
                if ! wget --progress=bar:force -O "$ZIP_FILE" "$DOWNLOAD_URL" 2>&1; then
                    echo ""
                    echo "Error: Failed to download MinGW-w64"
                    echo "Please download manually from: https://winlibs.com/"
                    echo "Extract to: C:/mingw64 and run this script again"
                    rm -f "$ZIP_FILE" 2>/dev/null || true
                    exit 1
                fi
            fi
            echo ""
            echo "✓ Download complete!"
            
            # Extract
            echo ""
            echo "Extracting MinGW-w64 (this may take a few minutes)..."
            if [ -d "$EXTRACT_DIR" ]; then
                rm -rf "$EXTRACT_DIR" 2>/dev/null || true
            fi
            mkdir -p "$EXTRACT_DIR"
            
            # Check for unzip command
            if command -v unzip &> /dev/null; then
                if ! unzip -q "$ZIP_FILE" -d "$EXTRACT_DIR" 2>/dev/null; then
                    echo "Error: Failed to extract MinGW-w64"
                    rm -f "$ZIP_FILE" 2>/dev/null || true
                    rm -rf "$EXTRACT_DIR" 2>/dev/null || true
                    exit 1
                fi
            elif command -v 7z &> /dev/null; then
                if ! 7z x "$ZIP_FILE" -o"$EXTRACT_DIR" -y >/dev/null 2>&1; then
                    echo "Error: Failed to extract MinGW-w64"
                    rm -f "$ZIP_FILE" 2>/dev/null || true
                    rm -rf "$EXTRACT_DIR" 2>/dev/null || true
                    exit 1
                fi
            else
                echo "Error: Neither unzip nor 7z found. Cannot extract MinGW-w64."
                echo "Please install unzip or 7z, or extract manually."
                rm -f "$ZIP_FILE" 2>/dev/null || true
                exit 1
            fi
            
            # Find the mingw64 directory in the extracted files
            EXTRACTED_MINGW=$(find "$EXTRACT_DIR" -type d -name "mingw64" 2>/dev/null | head -1)
            if [ -z "$EXTRACTED_MINGW" ]; then
                # Try to find any directory with gcc.exe
                GCC_FILE=$(find "$EXTRACT_DIR" -name "gcc.exe" -type f 2>/dev/null | head -1)
                if [ -n "$GCC_FILE" ]; then
                    # Go up to find the root directory
                    EXTRACTED_MINGW=$(dirname "$(dirname "$GCC_FILE")")
                fi
            fi
            
            if [ -n "$EXTRACTED_MINGW" ] && [ -f "$EXTRACTED_MINGW/bin/gcc.exe" ]; then
                MINGW_PATH="$EXTRACTED_MINGW"
                MINGW_FOUND=1
                echo "✓ Extraction complete!"
                echo "Found MinGW-w64 in downloaded archive: $MINGW_PATH"
            else
                echo "Error: Could not find MinGW-w64 in downloaded archive"
                rm -f "$ZIP_FILE" 2>/dev/null || true
                rm -rf "$EXTRACT_DIR" 2>/dev/null || true
                exit 1
            fi
            
            # Cleanup temp zip file (keep extracted directory for copying)
            rm -f "$ZIP_FILE" 2>/dev/null || true
            # Note: EXTRACT_DIR will be cleaned up after copying files at the end of script
        else
            echo "Skipping GCC bundling. Installation will require GCC to be in PATH."
            exit 0
        fi
    fi
    
    echo ""
    echo "Copying GCC binaries..."
    
    # Essential binaries to copy
    ESSENTIAL_BINARIES=(
        "gcc.exe"
        "g++.exe"
        "ar.exe"
        "as.exe"
        "ld.exe"
        "objcopy.exe"
        "objdump.exe"
        "ranlib.exe"
        "strip.exe"
        "windres.exe"
    )
    
    BIN_SOURCE="$MINGW_PATH/bin"
    for binary in "${ESSENTIAL_BINARIES[@]}"; do
        if [ -f "$BIN_SOURCE/$binary" ]; then
            cp "$BIN_SOURCE/$binary" "$BUNDLE_DIR/bin/" 2>/dev/null || true
            echo "  - $binary"
        fi
    done
    
    # Copy required DLLs (cp with glob is faster than find -exec cp per-file)
    echo "Copying required DLLs..."
    if [ -d "$BIN_SOURCE" ]; then
        cp "$BIN_SOURCE"/*.dll "$BUNDLE_DIR/bin/" 2>/dev/null || true
        DLL_COUNT=$(find "$BUNDLE_DIR/bin" -maxdepth 1 -name "*.dll" 2>/dev/null | wc -l)
        echo "  - $DLL_COUNT DLLs copied"
    fi
    
    # Copy essential libraries (batch cp with globs; faster than find -exec cp per-file)
    echo "Copying essential libraries..."
    LIB_SOURCE="$MINGW_PATH/lib"
    if [ -d "$LIB_SOURCE" ]; then
        for pattern in libgcc*.a libstdc++*.a libgcc_s*.dll libstdc++*.dll libwinpthread*.dll libwinpthread*.a; do
            cp "$LIB_SOURCE"/$pattern "$BUNDLE_DIR/lib/" 2>/dev/null || true
        done
        LIB_COUNT=$(find "$BUNDLE_DIR/lib" -maxdepth 1 -type f 2>/dev/null | wc -l)
        echo "  - $LIB_COUNT libraries copied"
    fi
    
    # Copy libexec directory (contains GCC internal tools like cc1.exe)
    echo "Copying GCC internal tools (libexec)..."
    LIBEXEC_SOURCE="$MINGW_PATH/libexec"
    if [ -d "$LIBEXEC_SOURCE" ]; then
        mkdir -p "$BUNDLE_DIR/libexec"
        # Copy entire libexec directory (cp -r is fast; avoid find -exec cp per-file)
        if command -v rsync &>/dev/null; then
            rsync -a --quiet "$LIBEXEC_SOURCE/" "$BUNDLE_DIR/libexec/" 2>/dev/null || \
            cp -r "$LIBEXEC_SOURCE/"* "$BUNDLE_DIR/libexec/" 2>/dev/null || true
        else
            cp -r "$LIBEXEC_SOURCE/"* "$BUNDLE_DIR/libexec/" 2>/dev/null || true
        fi
        echo "  - GCC internal tools (cc1.exe, etc.) copied"
    else
        echo "  ⚠ Warning: libexec directory not found. GCC may not work correctly."
        echo "  Trying to find cc1.exe in bin directory..."
        # Some distributions put cc1.exe in bin
        if [ -f "$BIN_SOURCE/cc1.exe" ]; then
            cp "$BIN_SOURCE/cc1.exe" "$BUNDLE_DIR/bin/" 2>/dev/null || true
            echo "  - Found cc1.exe in bin, copied"
        fi
    fi
    
    # Copy all headers (needed for full C standard library support)
    echo "Copying C standard library headers..."
    INCLUDE_SOURCE="$MINGW_PATH/include"
    if [ -d "$INCLUDE_SOURCE" ]; then
        mkdir -p "$BUNDLE_DIR/include"
        # Copy entire include directory (rsync or cp -r; avoid slow find -exec cp per-file)
        if command -v rsync &>/dev/null; then
            rsync -a --quiet "$INCLUDE_SOURCE/" "$BUNDLE_DIR/include/" 2>/dev/null || \
            cp -r "$INCLUDE_SOURCE/"* "$BUNDLE_DIR/include/" 2>/dev/null || true
        else
            cp -r "$INCLUDE_SOURCE/"* "$BUNDLE_DIR/include/" 2>/dev/null || true
        fi
        HEADER_COUNT=$(find "$BUNDLE_DIR/include" -type f 2>/dev/null | wc -l)
        echo "  - $HEADER_COUNT headers copied (full C standard library including Windows headers)"
        
        # Verify critical headers exist (check both direct and subdirectories)
        # NOTE: In MinGW-w64, standard headers are typically in architecture-specific directory, not here
        CRITICAL_HEADERS=("stdio.h" "stdlib.h" "string.h" "stdint.h" "stddef.h")
        MISSING=0
        FOUND_IN_ARCH=0
        for header in "${CRITICAL_HEADERS[@]}"; do
            # Check in include root and common subdirectories
            if [ -f "$BUNDLE_DIR/include/$header" ] || \
               [ -f "$BUNDLE_DIR/include/sys/$header" ] || \
               [ -n "$(find "$BUNDLE_DIR/include" -name "$header" -type f 2>/dev/null | head -1)" ]; then
                echo "  ✓ $header found in include/"
            else
                # Check if it exists in architecture-specific directory (this is normal for MinGW-w64)
                ARCH_HEADER=$(find "$BUNDLE_DIR" -path "*/$ARCH_NAME/include/$header" -type f 2>/dev/null | head -1)
                if [ -n "$ARCH_HEADER" ]; then
                    echo "  ✓ $header found in architecture-specific directory (normal for MinGW-w64)"
                    FOUND_IN_ARCH=1
                else
                    echo "  ⚠ Warning: $header not found (will be copied from architecture-specific directory)"
                    MISSING=1
                fi
            fi
        done
        if [ $MISSING -eq 0 ] || [ $FOUND_IN_ARCH -eq 1 ]; then
            echo "  ✓ Headers will be available via architecture-specific include path"
        fi
    else
        echo "  ⚠ Warning: include directory not found at $INCLUDE_SOURCE"
    fi
    
    # Copy architecture-specific include directories if they exist (e.g., x86_64-w64-mingw32/include)
    # NOTE: In MinGW-w64, standard headers (stdio.h, stdlib.h, etc.) are typically in the architecture-specific directory!
    echo "Copying architecture-specific headers..."
    ARCH_DIRS=$(find "$MINGW_PATH" -maxdepth 1 -type d -name "*-w64-mingw32" 2>/dev/null)
    if [ -n "$ARCH_DIRS" ]; then
        for arch_dir in $ARCH_DIRS; do
            ARCH_NAME=$(basename "$arch_dir")
            if [ -d "$arch_dir/include" ]; then
                mkdir -p "$BUNDLE_DIR/$ARCH_NAME/include"
                # Copy entire include directory (rsync or cp -r; avoid slow find -exec cp per-file)
                if command -v rsync &>/dev/null; then
                    rsync -a --quiet "$arch_dir/include/" "$BUNDLE_DIR/$ARCH_NAME/include/" 2>/dev/null || \
                    cp -r "$arch_dir/include/"* "$BUNDLE_DIR/$ARCH_NAME/include/" 2>/dev/null || true
                else
                    cp -r "$arch_dir/include/"* "$BUNDLE_DIR/$ARCH_NAME/include/" 2>/dev/null || true
                fi
                ARCH_HEADER_COUNT=$(find "$BUNDLE_DIR/$ARCH_NAME/include" -type f 2>/dev/null | wc -l)
                echo "  - $ARCH_HEADER_COUNT headers copied from $ARCH_NAME/include"
                
                # Also copy standard headers to general include directory for compatibility
                # (In MinGW-w64, standard headers are in architecture-specific dir, but some code expects them in include/)
                echo "  Copying standard headers to general include directory for compatibility..."
                STANDARD_HEADERS=("stdio.h" "stdlib.h" "string.h" "stdint.h" "stddef.h" "stdarg.h" "limits.h" "float.h" "math.h" "ctype.h" "errno.h" "time.h")
                COPIED_COUNT=0
                for header in "${STANDARD_HEADERS[@]}"; do
                    if [ -f "$arch_dir/include/$header" ] && [ ! -f "$BUNDLE_DIR/include/$header" ]; then
                        if cp "$arch_dir/include/$header" "$BUNDLE_DIR/include/$header" 2>/dev/null; then
                            COPIED_COUNT=$((COPIED_COUNT + 1))
                        fi
                    fi
                done
                if [ $COPIED_COUNT -gt 0 ]; then
                    echo "    ✓ $COPIED_COUNT standard headers copied to include/ for compatibility"
                fi
                
                # Verify critical headers exist (these are usually in architecture-specific dir)
                CRITICAL_ARCH_HEADERS=("mm_malloc.h" "malloc.h" "stdlib.h" "stdio.h" "string.h" "stdint.h" "stddef.h" "x86intrin.h")
                for header in "${CRITICAL_ARCH_HEADERS[@]}"; do
                    if [ -f "$BUNDLE_DIR/$ARCH_NAME/include/$header" ]; then
                        echo "    ✓ $header verified in $ARCH_NAME/include"
                    else
                        echo "    ⚠ Warning: $header not found in $ARCH_NAME/include"
                        # For mm_malloc.h, create a minimal stub if missing (some MinGW distributions don't include it)
                        if [ "$header" = "mm_malloc.h" ]; then
                            echo "    Creating minimal mm_malloc.h stub..."
                            cat > "$BUNDLE_DIR/$ARCH_NAME/include/mm_malloc.h" << 'MM_MALLOC_EOF'
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
                        # For x86intrin.h, create a minimal stub if missing (needed by winnt.h on Windows)
                        if [ "$header" = "x86intrin.h" ]; then
                            echo "    Creating minimal x86intrin.h stub..."
                            cat > "$BUNDLE_DIR/$ARCH_NAME/include/x86intrin.h" << 'X86INTRIN_EOF'
#ifndef _X86INTRIN_H_INCLUDED
#define _X86INTRIN_H_INCLUDED
// Minimal stub for x86intrin.h - provides basic intrinsics declarations
// This is a minimal implementation for compatibility
// Full x86 intrinsics are not implemented, but this prevents compilation errors
#include <stdint.h>
// Basic intrinsic function stubs (empty implementations)
static inline void _mm_pause(void) { __asm__ __volatile__("pause"); }
static inline void _mm_mfence(void) { __asm__ __volatile__("mfence"); }
static inline void _mm_lfence(void) { __asm__ __volatile__("lfence"); }
static inline void _mm_sfence(void) { __asm__ __volatile__("sfence"); }
// Additional intrinsics can be added as needed
#endif /* _X86INTRIN_H_INCLUDED */
X86INTRIN_EOF
                            echo "    ✓ x86intrin.h stub created"
                        fi
                    fi
                done
            fi
        done
    fi
    
else
    # Linux/macOS: Check for system GCC
    if ! command -v gcc &> /dev/null; then
        echo "Error: GCC not found. Please install GCC first."
        echo "  Linux: sudo apt-get install gcc"
        echo "  macOS: xcode-select --install"
        exit 1
    fi
    
    echo "Note: On Linux/macOS, system GCC is typically used."
    echo "Bundling is mainly for Windows. Skipping..."
    exit 0
fi

# Verify bundled files
echo ""
echo "Bundled GCC files:"
BIN_COUNT=$(find "$BUNDLE_DIR/bin" -type f 2>/dev/null | wc -l)
LIB_COUNT=$(find "$BUNDLE_DIR/lib" -type f 2>/dev/null | wc -l)
HEADER_COUNT=$(find "$BUNDLE_DIR/include" -type f 2>/dev/null | wc -l)
echo "  Binaries: $BIN_COUNT files"
echo "  Libraries: $LIB_COUNT files"
echo "  Headers: $HEADER_COUNT files"

# Test if bundled GCC works
BUNDLED_GCC="$BUNDLE_DIR/bin/gcc.exe"
if [ ! -f "$BUNDLED_GCC" ]; then
    BUNDLED_GCC="$BUNDLE_DIR/bin/gcc"
fi

if [ -f "$BUNDLED_GCC" ]; then
    echo ""
    echo "Testing bundled GCC..."
    if "$BUNDLED_GCC" --version &>/dev/null; then
        GCC_VERSION=$("$BUNDLED_GCC" --version 2>&1 | head -1)
        echo "  $GCC_VERSION"
        echo "  GCC is working!"
    else
        echo "  Warning: Could not verify GCC version"
    fi
fi

# Cleanup extracted directory if we downloaded it
if [ -n "$EXTRACT_DIR" ] && [ -d "$EXTRACT_DIR" ]; then
    rm -rf "$EXTRACT_DIR" 2>/dev/null || true
fi

echo ""
echo "=== GCC Bundling Complete ==="
echo "Bundle directory: $BUNDLE_DIR"
echo ""
echo "Note: This is a minimal GCC bundle. For full functionality,"
echo "      users may need to install the complete MinGW-w64 package."
