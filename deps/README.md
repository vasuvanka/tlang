# Tlang Dependencies (OS-specific)

Pre-bundled dependencies for each platform. The install scripts use these—no lookup or download.

## Structure

```
deps/
  windows/
    mingw/       # MinGW (GCC) from C:\MinGW — see docs/MINGW_BUNDLE_COPY.md
  linux/
    (optional)   # Linux typically uses system gcc + OpenSSL
  macos/
    (optional)   # macOS typically uses system clang + OpenSSL
```

## Windows

Copy from `C:\MinGW` into `deps/windows/mingw/`:

- `bin/` — gcc.exe, cpp.exe, as.exe, ld.exe, ar.exe, ranlib.exe, *.dll
- `lib/` — lib/*, lib/gcc/mingw32/6.3.0/*
- `include/` — C headers
- `libexec/` — libexec/gcc/mingw32/6.3.0/cc1.exe, collect2.exe, etc.

**PowerShell (run from repo root):**
```powershell
$SRC = "C:\MinGW"
$DST = "deps\windows\mingw"
New-Item -ItemType Directory -Force -Path $DST | Out-Null
Copy-Item "$SRC\bin" -Destination "$DST\bin" -Recurse -Force
Copy-Item "$SRC\lib" -Destination "$DST\lib" -Recurse -Force
Copy-Item "$SRC\include" -Destination "$DST\include" -Recurse -Force
# libexec: only gcc part (not mingw-get)
New-Item -ItemType Directory -Force -Path "$DST\libexec\gcc\mingw32\6.3.0" | Out-Null
Copy-Item "$SRC\libexec\gcc\mingw32\6.3.0\*" -Destination "$DST\libexec\gcc\mingw32\6.3.0\" -Recurse -Force
```

See [docs/MINGW_BUNDLE_COPY.md](../docs/MINGW_BUNDLE_COPY.md) for full details.

## Linux / macOS

Use system packages:
- **Linux:** `apt install build-essential libssl-dev` (or equivalent)
- **macOS:** `xcode-select --install`, `brew install openssl`

Optional: add pre-bundled libs under `deps/linux/` or `deps/macos/` if needed later.
