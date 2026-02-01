# Zero-Dependency Executables, Cross-Compilation & Deployable Images

This document describes how to build Tlang programs so that the **executable has zero runtime dependencies**, can be **cross-compiled** (e.g. build for Linux/macOS from Windows and vice versa), and can be **deployed on any Windows, Linux, or macOS** with almost zero changes.

---

## 1. Zero-Dependency Executables

### 1.1 Goal

The output binary should run without requiring:

- DLLs or shared libraries on the target machine
- A specific Visual C++ runtime or glibc version
- OpenSSL (or other libs) installed on the host

Everything needed is **statically linked** into the executable.

### 1.2 Build System (`tlang build`)

In `config.toml`:

```toml
[build]
static_link = true   # Default: produce a static binary
optimize = "size"    # Optional: smaller binary
```

With `static_link = true`, the build system passes `-static` to the C compiler (gcc/clang). On Windows with MinGW, use additional linker flags so the C runtime is also static (see below).

### 1.3 Single-File Compile (`tlangc compile`)

When you run `tlangc compile program.tl app`, the compiler now passes:

- **gcc/clang:** `-Os`, `-s`, and **`-static`** so the binary is optimized for size, stripped, and statically linked.
- **Windows (MinGW gcc):** Also `-static-libgcc` and `-static-libstdc++` so the C runtime is not a dependency.
- **macOS:** `-static` is not passed (macOS system libs are typically dynamic); the binary is still standalone and runs on compatible macOS versions.

For **OpenSSL**: If your program uses crypto, you must have **static** OpenSSL libraries (e.g. `libssl.a`, `libcrypto.a`) and pass the path to them; otherwise the linker may pull in shared libs. See your OS/MinGW docs for building static OpenSSL.

### 1.4 Platform Notes

| Platform | Zero-deps approach | Notes |
|----------|--------------------|--------|
| **Windows** | MinGW with `-static` + `-static-libgcc` `-static-libstdc++` | Use MinGW-w64; link against static OpenSSL if you use crypto. |
| **Linux (glibc)** | `-static` with gcc | glibc often does not support full static linking; you may see linker warnings or failures. |
| **Linux (musl)** | Use musl-based toolchain (e.g. Alpine, or `musl-gcc`) with `-static` | Produces fully static binaries that run on almost any Linux. |
| **macOS** | No `-static` (compiler omits it on macOS); use system clang | For “portable” macOS binaries, Binary runs on same or newer macOS (e.g. build on macOS 12, run on 12+). For ARM (Apple Silicon) vs x86_64, build on target arch or use cross-compile. |

**Recommendation for Linux zero-deps:** Build inside an **Alpine Linux** container (musl-based) or install `musl-tools` and use `musl-gcc`; then pass `-static`. The resulting binary will have no runtime dependencies on the target Linux.

---

## 2. Cross-Compilation (Build for Linux/macOS from Windows and Vice Versa)

### 2.1 Goal

- On **Windows:** build a Tlang program that produces a **Linux** or **macOS** executable (e.g. for CI or deployment).
- On **Linux:** build a Tlang program that produces a **Windows** or **macOS** executable (e.g. for distribution).
- On **macOS:** build a Tlang program that produces a **Windows** or **Linux** executable (e.g. for distribution).

Tlang compiles **Tlang → C**; the **C compiler** determines the target. So cross-compilation means using a **cross C compiler** (and optionally a cross-linker) for the target OS.

### 2.2 Approach

1. **Install a cross-compiler** for the target platform.
2. **Invoke that compiler** when compiling the generated C to a binary (instead of the native `gcc`/`clang`).

Today the Tlang compiler and build system **auto-detect** the native C compiler (gcc, clang, or MSVC). Cross-compilation is **not yet built in**; it is done by:

- **Option A (manual):** Generate C with Tlang, then run the cross-compiler yourself:
  ```bash
  tlangc compile program.tl -o program.c   # or use build, then take the .c
  x86_64-w64-mingw32-gcc -Os -s -static -o program.exe program.c -lm   # Linux/macOS → Windows
  x86_64-linux-gnu-gcc -Os -s -static -o program program.c -lm          # Windows → Linux (if you have a Linux-target gcc on Windows)
  clang -Os -s -o program program.c -lm -target x86_64-apple-darwin      # Linux/Windows → macOS (with appropriate SDK)
  ```
- **Option B (future):** Add a `--target` flag or config (e.g. `target = "x86_64-pc-windows-gnu"`) and have the build system call the appropriate cross-compiler. **TBD.**

### 2.3 Cross-Compiler Setup

| Host | Target | Cross-compiler to install | Notes |
|------|--------|---------------------------|--------|
| **Linux** | Windows | `mingw-w64` (e.g. `x86_64-w64-mingw32-gcc`) | Package: `mingw-w64` (Debian/Ubuntu). Produces `.exe` with no dependency on Linux libs. |
| **Linux** | macOS | `clang` with `-target x86_64-apple-darwin` or `aarch64-apple-darwin` + SDK | Requires macOS SDK (e.g. from Xcode or osxcross). |
| **macOS** | Windows | `mingw-w64` (e.g. via Homebrew: `x86_64-w64-mingw32-gcc`) | Produces `.exe` for Windows. |
| **macOS** | Linux | Cross gcc (e.g. osxcross or Docker) | Build inside Linux container or use cross-compiler. |
| **Windows** | Linux | MXE or similar; or WSL + gcc | MXE: https://mxe.cc. Or build inside WSL/Docker with native Linux gcc. |
| **Windows** | macOS | `clang` with Darwin target + SDK | Requires macOS SDK; often done via CI on macOS. |
| **Linux** | Linux (other arch) | e.g. `gcc-aarch64-linux-gnu` | For ARM targets (e.g. Raspberry Pi). |

**Example (Linux host → Windows executable):**

```bash
# Install MinGW cross-compiler (Debian/Ubuntu)
sudo apt-get install mingw-w64

# Build Tlang program to C
tlangc compile myapp.tl -o myapp.c

# Cross-compile C to Windows executable (static)
x86_64-w64-mingw32-gcc -Os -s -static -static-libgcc -static-libstdc++ -o myapp.exe myapp.c -lm
```

The resulting `myapp.exe` can be copied to any Windows machine (same architecture) and run with **zero dependencies** (no extra DLLs).

---

## 3. Deployable Images (Run on Any Windows / Linux / macOS with Almost Zero Changes)

### 3.1 Goal

- **Windows:** Produce a single folder or zip (e.g. “image”) containing the `.exe` (and optional README) that can be copied to any Windows machine and run with no install step.
- **Linux:** Same idea: a tarball or folder with the static binary (and optional README) that runs on any Linux (same arch) with no install step.
- **macOS:** Same idea: a folder or DMG with the binary (and optional README) that runs on same or newer macOS (same arch: x86_64 or arm64).

“Almost zero changes” means: no installing DLLs, no installing packages, no config—just copy and run (subject to architecture: x86_64 binary on x86_64, etc.).

### 3.2 What to Ship

| Platform | Contents | How to run |
|----------|----------|------------|
| **Windows** | `myapp.exe` (statically linked) | Copy folder; run `myapp.exe`. Optional: `README.txt` with usage. |
| **Linux** | `myapp` (statically linked, e.g. musl) | Copy folder; `chmod +x myapp`; run `./myapp`. Optional: `README` with usage. |
| **macOS** | `myapp` (no extension; built with clang) | Copy folder; `chmod +x myapp`; run `./myapp`. Optional: `README` with usage. Same arch (x86_64 or arm64) as build. |

No installers required if the binary is fully static (Windows/Linux) or uses system libs (macOS). You can zip (Windows), tarball (Linux/macOS), or DMG (macOS) the folder for distribution.

### 3.3 Build and Package Workflow (Example)

**Windows image (build on Windows or cross from Linux/macOS):**

```bash
# Build static Windows .exe (on Windows with MinGW, or on Linux/macOS with mingw-w64)
# ... (tlangc compile or tlang build with static_link = true and cross-compiler)

# Create deploy folder
mkdir myapp-windows
cp myapp.exe myapp-windows/
echo "Run myapp.exe" > myapp-windows/README.txt
# Zip: myapp-windows.zip
```

**Linux image (build on Linux, ideally with musl for zero deps):**

```bash
# Build static Linux binary (e.g. in Alpine or with musl-gcc)
# ... (tlangc compile or tlang build with static_link = true)

# Create deploy folder
mkdir myapp-linux
cp myapp myapp-linux/
chmod +x myapp-linux/myapp
echo "Run ./myapp" > myapp-linux/README
# Tar: tar czvf myapp-linux.tar.gz myapp-linux/
```

**macOS image (build on macOS):**

```bash
# Build binary on macOS (tlangc compile or tlang build; no -static on macOS)
# ... (tlangc compile or tlang build with static_link = true)

# Create deploy folder
mkdir myapp-macos
cp myapp myapp-macos/
chmod +x myapp-macos/myapp
echo "Run ./myapp" > myapp-macos/README
# Tar: tar czvf myapp-macos.tar.gz myapp-macos/
# Or create a DMG for distribution
```

Users on any Windows, Linux, or macOS of the same architecture can unzip/untar and run with **zero dependencies** (or minimal system libs on macOS) and **almost zero changes** (no install, no config).

---

## 4. Summary Checklist

| Requirement | Action |
|-------------|--------|
| **Zero dependencies** | Use `static_link = true` in config.toml; for `tlangc compile`, the compiler passes `-static` on Windows/Linux (and on Windows MinGW, `-static-libgcc` `-static-libstdc++`). On macOS, `-static` is omitted; binary uses system libs. On Linux, prefer musl for fully static. |
| **Build for Linux from Windows** | Install a Linux-target cross-compiler (e.g. via MXE/WSL) or build in Docker/WSL; compile the generated C with that compiler. |
| **Build for Windows from Linux/macOS** | Install `mingw-w64`; compile the generated C with `x86_64-w64-mingw32-gcc` (and `-static` etc.). |
| **Build for macOS from Linux/Windows** | Use clang with `-target x86_64-apple-darwin` or `aarch64-apple-darwin` and macOS SDK (e.g. osxcross); or build on macOS. |
| **Deploy on any Windows** | Ship a static `.exe` in a folder/zip; user copies and runs. |
| **Deploy on any Linux** | Ship a static binary (musl-built) in a folder/tarball; user copies and runs. |
| **Deploy on any macOS** | Ship binary (no extension) in a folder/tarball/DMG; user copies and runs (same arch). |

---

## 5. See Also

- [Build system](build-system.md) — `config.toml`, `static_link`, compiler flags
- [Small binaries & IoT](small-binaries-iot.md) — Size optimization and linker flags
- [Manifest](manifest.md) — `[build]` options
