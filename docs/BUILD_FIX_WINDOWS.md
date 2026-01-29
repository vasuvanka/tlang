# Windows Build Fix Guide

## Problem: MSVC Linker Errors in Git Bash

If you see errors like:
```
link: extra operand 'C:/Users/...'
link: missing operand after ' ■'
```

This is a known issue when using the **MSVC toolchain** in **Git Bash**.

## Solution: Use GNU Toolchain (Recommended for Git Bash)

### Quick Fix

```bash
# Install GNU toolchain
rustup toolchain install stable-x86_64-pc-windows-gnu

# Set as default
rustup default stable-x86_64-pc-windows-gnu

# Clean and rebuild
cargo clean
cargo build --release
```

### Verify Toolchain

```bash
rustup show
# Should show: stable-x86_64-pc-windows-gnu (active, default)
```

## Alternative Solutions

### Option 1: Build from PowerShell/CMD
If you prefer to keep MSVC toolchain:
1. Open PowerShell or CMD (not Git Bash)
2. Run: `.\install.sh` or `cargo build --release`

### Option 2: Install Visual Studio Build Tools
1. Download from: https://visualstudio.microsoft.com/downloads/
2. Install "Desktop development with C++" workload
3. This may fix MSVC linker issues

## Why GNU Toolchain?

- ✅ Works perfectly with Git Bash
- ✅ Uses MinGW-w64 (same as bundled GCC)
- ✅ No path separator issues
- ✅ Better compatibility with Unix-like tools
- ✅ Same performance as MSVC

## Switching Back to MSVC

If you need MSVC toolchain later:
```bash
rustup default stable-x86_64-pc-windows-msvc
```
