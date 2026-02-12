# MinGW Bundle — Copy from C:\MinGW to Repo

Copy these files from `C:\MinGW` into `deps/windows/mingw/` in the repo. The install script will use them without any lookup.

## Target structure in repo

```
tlang/
  deps/
    windows/
      mingw/
        bin/       (executables + DLLs)
        lib/       (libraries, crt, lib/gcc/...)
        include/   (C headers)
        libexec/   (cc1.exe, collect2.exe, etc.)
```

---

## 1. From C:\MinGW\bin → deps/windows/mingw/bin/

### Executables (required)
| File | Purpose |
|------|---------|
| gcc.exe | C compiler driver |
| cpp.exe | C preprocessor |
| g++.exe | C++ (needed if Rust deps use it during tlang build) |
| as.exe | Assembler |
| ld.exe | Linker |
| ar.exe | Archiver |
| ranlib.exe | Archive indexer |
| objcopy.exe | Object copy |
| objdump.exe | Object dump |
| strip.exe | Strip symbols |
| windres.exe | Resource compiler |

### DLLs (required — gcc.exe won't run without these)
| File | Purpose |
|------|---------|
| libgcc_s_dw2-1.dll | GCC runtime (critical) |
| libgmp-10.dll | GCC dependency |
| libmpfr-4.dll | GCC dependency |
| libmpc-3.dll | GCC dependency |
| libmingwex-0.dll | MinGW runtime |
| mingwm10.dll | MinGW runtime |
| libstdc++-6.dll | C++ runtime (if g++ used) |
| libisl-15.dll | Optional (loop optimizations) |
| libquadmath-0.dll | Optional (quad math) |
| libatomic-1.dll | Optional |
| libgomp-1.dll | Optional (OpenMP) |
| zlib1.dll | Optional |
| pthreadGC-3.dll | Optional (pthreads) |

**Minimum set:** gcc.exe, cpp.exe, as.exe, ld.exe, ar.exe, ranlib.exe + all DLLs in bin (copy `*.dll`).

---

## 2. From C:\MinGW\libexec → deps/windows/mingw/libexec/

Copy the **entire** `libexec` folder:
```
C:\MinGW\libexec\gcc\mingw32\6.3.0\
  cc1.exe          ← C compiler backend (required)
  cc1plus.exe      ← C++ backend (if g++ used)
  collect2.exe     ← Linker wrapper (required)
  liblto_plugin-0.dll
  lto1.exe
  lto-wrapper.exe
```

**Do NOT copy** `libexec\mingw-get\` — that's the MinGW installer, not needed.

---

## 3. From C:\MinGW\include → deps/windows/mingw/include/

Copy the **entire** `include` folder (stdio.h, stdlib.h, string.h, windows.h, etc. and subdirs: sys/, ddk/, gdiplus/, GL/, libltdl/).

---

## 4. From C:\MinGW\lib → deps/windows/mingw/lib/

### From C:\MinGW\lib\ (root)
| Files | Purpose |
|-------|---------|
| crt1.o, crt2.o, dllcrt1.o, dllcrt2.o, crtbegin.o, crtend.o | Startup code |
| libgcc.a, libgcc_s.a, libmingwex.a, libmingw32.a | Core libs |
| libmsvcrt.a, libmoldname.a | C runtime |
| libm.a | Math |
| All lib*.a you need | Windows API import libs |

### From C:\MinGW\lib\gcc\mingw32\6.3.0\
Copy the **entire** `lib\gcc\mingw32\6.3.0\` directory:
- libgcc.a, libgcc_eh.a, libgcc_s.a
- libatomic.a, libquadmath.a, libssp.a, libgomp.a
- libstdc++.a, libsupc++.a
- crtbegin.o, crtend.o, crtfastmath.o
- include/, include-fixed/

---

## Quick copy commands (PowerShell)

Run from repo root:

```powershell
$SRC = "C:\MinGW"
$DST = "deps\windows\mingw"

# Bin
New-Item -ItemType Directory -Force -Path "$DST\bin" | Out-Null
Copy-Item "$SRC\bin\gcc.exe","$SRC\bin\g++.exe","$SRC\bin\cpp.exe","$SRC\bin\as.exe","$SRC\bin\ld.exe","$SRC\bin\ar.exe","$SRC\bin\ranlib.exe","$SRC\bin\objcopy.exe","$SRC\bin\objdump.exe","$SRC\bin\strip.exe","$SRC\bin\windres.exe" -Destination "$DST\bin\" -ErrorAction SilentlyContinue
Copy-Item "$SRC\bin\*.dll" -Destination "$DST\bin\" -ErrorAction SilentlyContinue

# Libexec (only gcc part, not mingw-get)
New-Item -ItemType Directory -Force -Path "$DST\libexec\gcc\mingw32\6.3.0" | Out-Null
Copy-Item "$SRC\libexec\gcc\mingw32\6.3.0\*" -Destination "$DST\libexec\gcc\mingw32\6.3.0\" -Recurse -ErrorAction SilentlyContinue

# Include
Copy-Item "$SRC\include\*" -Destination "$DST\include\" -Recurse -Force -ErrorAction SilentlyContinue

# Lib
Copy-Item "$SRC\lib\*" -Destination "$DST\lib\" -Recurse -Force -ErrorAction SilentlyContinue
```

---

## After copying

1. Verify: `deps\windows\mingw\bin\gcc.exe --version`
2. Ensure `deps\windows\mingw\libexec\gcc\mingw32\6.3.0\cc1.exe` exists
3. Commit to repo (or use Git LFS if size is large)

The install script will detect `deps/windows/mingw/` and use it directly—no download or path lookup.
