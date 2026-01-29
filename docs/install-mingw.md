# Installing MinGW for Tlang

MinGW (Minimalist GNU for Windows) provides the `gcc` C compiler needed to compile Tlang programs to executable binaries.

## Quick Installation Options

### Option 1: Using MSYS2 (Recommended)

MSYS2 provides an easy way to install MinGW and manage packages.

1. **Download MSYS2:**
   - Visit: https://www.msys2.org/
   - Download the installer for your system (64-bit recommended)
   - Run the installer and follow the prompts

2. **Install MinGW:**
   - Open **MSYS2 MSYS** terminal (not MINGW64)
   - Update package database:
     ```bash
     pacman -Syu
     ```
   - Close and reopen the terminal, then run again:
     ```bash
     pacman -Syu
     ```
   - Install MinGW toolchain:
     ```bash
     pacman -S mingw-w64-x86_64-gcc
     pacman -S mingw-w64-x86_64-openssl  # For OpenSSL support
     ```

3. **Add to PATH:**
   - Add `C:\msys64\mingw64\bin` to your system PATH
   - Or use the MSYS2 MinGW 64-bit terminal (which has PATH pre-configured)

4. **Verify Installation:**
   ```bash
   gcc --version
   ```
   Should show: `gcc (MinGW-w64 x86_64-ucrt-posix-seh, built by Brecht Sanders) ...`

### Option 2: Using Chocolatey (Package Manager)

If you have Chocolatey installed:

```powershell
choco install mingw
```

Then add `C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin` to PATH.

### Option 3: Direct Download

1. **Download MinGW-w64:**
   - Visit: https://www.mingw-w64.org/downloads/
   - Or use WinLibs: https://winlibs.com/
   - Download the latest release (e.g., `mingw-w64-installer.exe`)

2. **Install:**
   - Run the installer
   - Select:
     - Architecture: `x86_64`
     - Threads: `posix` or `win32`
     - Exception: `seh` or `sjlj`
   - Choose installation directory (e.g., `C:\mingw64`)

3. **Add to PATH:**
   - Add `C:\mingw64\bin` to your system PATH
   - Restart your terminal/IDE

4. **Verify:**
   ```bash
   gcc --version
   ```

## Adding to PATH (Windows)

### Method 1: System Environment Variables (Permanent)

1. Press `Win + X` and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "System variables", find `Path` and click "Edit"
5. Click "New" and add:
   - `C:\msys64\mingw64\bin` (for MSYS2)
   - OR `C:\mingw64\bin` (for direct install)
6. Click "OK" on all dialogs
7. **Restart your terminal/IDE**

### Method 2: PowerShell (Current Session)

```powershell
$env:Path += ";C:\msys64\mingw64\bin"
```

### Method 3: Command Prompt (Current Session)

```cmd
set PATH=%PATH%;C:\msys64\mingw64\bin
```

## Verify Installation

After installation, verify in a **new** terminal:

```bash
gcc --version
```

Expected output:
```
gcc (MinGW-w64 x86_64-ucrt-posix-seh, built by Brecht Sanders) 13.2.0
Copyright (C) 2023 Free Software Foundation, Inc.
```

## Test with Tlang

Once MinGW is installed, test the compile command:

```bash
cargo run -- compile examples/args_example.tl args_example
```

You should see:
```
Compiled to C: args_example.c
Compiling C to binary using gcc...
✓ Binary compiled successfully: args_example.exe
```

Then run it:
```bash
.\args_example.exe --help
```

## Troubleshooting

### "gcc: command not found"

- **Check PATH:** Make sure MinGW `bin` directory is in your PATH
- **Restart terminal:** Close and reopen your terminal/IDE after adding to PATH
- **Verify installation:** Run `gcc --version` in the MinGW terminal (if using MSYS2)

### "No C compiler found" from Tlang

- Make sure `gcc` is accessible from your current terminal
- Try running `gcc --version` in the same terminal where you run `tlangc`
- If it works there, Tlang should find it too

### OpenSSL Errors

If you get OpenSSL linking errors:

1. **Install OpenSSL for MinGW:**
   ```bash
   # In MSYS2:
   pacman -S mingw-w64-x86_64-openssl
   ```

2. **Or download pre-built OpenSSL:**
   - Download from: https://slproweb.com/products/Win32OpenSSL.html
   - Install and add to PATH

### Alternative: Use MSVC (Visual Studio)

If MinGW doesn't work, you can use Microsoft Visual C++:

1. Install Visual Studio Build Tools or Visual Studio Community
2. Open "Developer Command Prompt for VS"
3. Tlang will automatically detect `cl.exe`

## Next Steps

Once MinGW is installed:

1. **Compile your first program:**
   ```bash
   cargo run -- compile examples/args_example.tl
   ```

2. **Run the executable:**
   ```bash
   .\output.exe --help
   ```

3. **Use in your projects:**
   ```bash
   tlangc compile myprogram.tl myprogram
   ./myprogram.exe
   ```

## See Also

- [Getting Started Guide](getting-started.md) - Learn Tlang basics
- [Build System](build-system.md) - Project-based compilation
- [Command Reference](command-reference.md) - All tlangc commands
