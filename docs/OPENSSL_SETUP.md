# OpenSSL Setup for Tlang

Tlang requires OpenSSL for cryptographic functions (AES, ChaCha20-Poly1305, PBKDF2, hashing, etc.). This document explains how OpenSSL is integrated into Tlang.

## Automatic Setup

The installation scripts (`install.sh` and `install.ps1`) automatically:
1. Check for OpenSSL installation
2. Install OpenSSL development libraries if missing (Linux/Unix)
3. Configure the build to use OpenSSL
4. Link OpenSSL when compiling generated C code

## Manual Setup

### Linux/Unix

**Install OpenSSL development libraries:**

```bash
# Debian/Ubuntu
sudo apt-get install libssl-dev pkg-config

# RHEL/CentOS
sudo yum install openssl-devel pkg-config

# Fedora
sudo dnf install openssl-devel pkg-config

# Arch Linux
sudo pacman -S openssl pkg-config

# macOS
brew install openssl pkg-config
```

**Verify installation:**
```bash
openssl version
pkg-config --modversion openssl
```

### Windows

**Option 1: Win32 OpenSSL (Recommended)**
1. Download from: https://slproweb.com/products/Win32OpenSSL.html
2. Install to default location: `C:\OpenSSL-Win64`
3. The installation script will detect it automatically

**Option 2: vcpkg**
```powershell
vcpkg install openssl:x64-windows
```

**Option 3: Manual Installation**
- Download OpenSSL binaries
- Extract to `C:\OpenSSL-Win64`
- Ensure `C:\OpenSSL-Win64\lib` contains `libssl.lib` and `libcrypto.lib`

## Compiling with OpenSSL

### Automatic (via tlang wrapper)

The `tlang run` and `tlang test` commands automatically compile with OpenSSL:

```bash
tlang run program.tl  # Automatically uses -DUSE_OPENSSL -lssl -lcrypto
```

### Manual Compilation

When compiling generated C code manually:

**Linux/Unix:**
```bash
gcc -DUSE_OPENSSL -o program output.c -lm -lssl -lcrypto
```

**Windows (MinGW):**
```bash
gcc -DUSE_OPENSSL -o program.exe output.c -lm -lssl -lcrypto
```

**Windows (MSVC):**
```cmd
cl /DUSE_OPENSSL output.c /Fe:program.exe /link libssl.lib libcrypto.lib
```

## Verifying OpenSSL Support

### Check if OpenSSL is linked

After compiling, you can verify OpenSSL is linked:

**Linux/Unix:**
```bash
ldd program | grep ssl
# Should show: libssl.so => /usr/lib/x86_64-linux-gnu/libssl.so
```

**Windows:**
```powershell
dumpbin /dependents program.exe | findstr ssl
# Should show: libssl.dll and libcrypto.dll
```

### Test in Tlang code

```tl
#prarambham() {
    // This will use OpenSSL if available
    @hash string = hash.SHA256("test");
    fmt.Printf("Hash: %s\n", hash);
    
    // If OpenSSL is not available, you'll get a warning
    // and a placeholder implementation will be used
}
```

## Troubleshooting

### "OpenSSL not found" during installation

**Linux/Unix:**
- The installation script will attempt to install OpenSSL automatically
- If it fails, install manually using your package manager
- Ensure `pkg-config` is also installed

**Windows:**
- Download and install OpenSSL manually
- Ensure it's installed to `C:\OpenSSL-Win64` (or set `OPENSSL_DIR` environment variable)
- Restart your terminal after installation

### "undefined reference to `SSL_*`" errors

This means OpenSSL libraries are not being linked. Solutions:

1. **Check OpenSSL is installed:**
   ```bash
   pkg-config --libs openssl  # Linux/Unix
   ```

2. **Ensure you're using the wrapper:**
   ```bash
   tlang run program.tl  # Uses OpenSSL automatically
   ```

3. **Manual compilation - add OpenSSL flags:**
   ```bash
   gcc -DUSE_OPENSSL output.c -o program -lssl -lcrypto
   ```

### "OpenSSL version mismatch"

If you see version mismatch errors:

1. **Linux/Unix:** Update OpenSSL via package manager
2. **Windows:** Reinstall OpenSSL to match your compiler architecture (x64 vs x86)

### macOS specific issues

On macOS, OpenSSL might be in a non-standard location:

```bash
# If using Homebrew
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

# Then build
cargo build --release
```

## OpenSSL Features Used

Tlang uses the following OpenSSL features:

- **Hashing:** MD5, SHA1, SHA256, SHA512, HMAC
- **Symmetric Encryption:** AES (CBC, GCM), DES, 3DES
- **Stream Ciphers:** ChaCha20-Poly1305
- **Key Derivation:** PBKDF2
- **Random Number Generation:** RAND_bytes()

## Without OpenSSL

If OpenSSL is not available, Tlang will:
- Compile successfully
- Use placeholder implementations for crypto functions
- **Warning:** Placeholder implementations are **NOT cryptographically secure**
- Only suitable for testing, not production

**Always use OpenSSL for production applications!**

## Security Notes

1. **Always compile with OpenSSL** for production use
2. **Keep OpenSSL updated** - security vulnerabilities are discovered regularly
3. **Use authenticated encryption** (AES-GCM, ChaCha20-Poly1305) when possible
4. **Never use placeholder implementations** in production
5. **Verify OpenSSL is linked** before deploying applications

## See Also

- [Crypto Library Documentation](libraries/crypto.md) - Cryptographic functions
- [Installation Guide](README_INSTALL.md) - Full installation instructions
- [OpenSSL Documentation](https://www.openssl.org/docs/) - Official OpenSSL docs
