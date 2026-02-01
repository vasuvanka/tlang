# Small Binaries & IoT / Microcontroller Strategy

Tlang targets IoT devices and microcontrollers where binary size matters. This document outlines how to keep **generated program** size small (the C binary from your Tlang code) and optionally how to reduce the **compiler/tool** size.

---

## 1. Generated program size (your Tlang app on the device)

These apply to the binary produced from your `.tl` code (the C output compiled with gcc/clang).

### Use size optimization when compiling to binary

- **`tlangc compile` (single-file):** The compiler now passes `-Os` (optimize for size) and `-s` (strip symbols) by default when compiling C to binary. For even smaller output you can compile the generated `.c` yourself with extra flags (see below).
- **Build system (`tlang build`):** In your project `config.toml`, set:
  ```toml
  [build]
  optimize = "size"   # -Os (recommended for IoT)
  debug = false       # no -g
  static_link = true  # optional: single standalone binary
  ```
  Use `optimize = "speed"` only when you need maximum performance and have enough flash/RAM.

### Recommended C compiler flags for smallest binaries

When compiling the generated C (or when adding `compiler_flags` / `linker_flags` in config.toml):

| Goal | Flags |
|------|--------|
| Size optimization | `-Os` (gcc/clang) or `-Oz` (clang only, often smaller than -Os) |
| Strip symbols | `-s` (or run `strip` on the binary after build) |
| Dead code elimination | `-ffunction-sections -fdata-sections` and linker `-Wl,--gc-sections` |
| No debug info | Omit `-g` in release builds |

Example for a minimal footprint (gcc/clang):

```bash
gcc -Os -s -ffunction-sections -fdata-sections -o app output.c -lm \
  -Wl,--gc-sections
```

In `config.toml`:

```toml
[build]
optimize = "size"
compiler_flags = ["-Os", "-ffunction-sections", "-fdata-sections", "-Wall"]
linker_flags = ["-Wl,--gc-sections", "-s"]
```

### Reduce what you pull in

- **Stdlib:** Only the Tlang standard library packages you `dhimpu` (import) are reflected in generated C. Avoid importing large packages (e.g. full JSON/HTTP) if you only need a tiny subset; future work may add “minimal” variants.
- **OpenSSL:** If your program does not use crypto, the generated C won’t define `USE_OPENSSL` and you won’t link `-lssl -lcrypto`, saving size.
- **Linking:** Prefer static linking only when you need one file; on constrained systems, dynamic linking can reduce per-app size if the same libc is shared.

---

## 2. Compiler and tool binary size (optional)

The Tlang compiler (`tlangc`), build system (`tlang-build`), and LSP (`tlang-lsp`) are Rust binaries. Making them smaller helps on resource-limited build hosts or when shipping tooling.

### Release build tuned for size

Build with the `release` profile (already size-conscious) or a dedicated small profile:

```bash
# Standard release (good balance)
cargo build --release

# Small compiler binary (smaller tlangc/tlang-build/tlang-lsp)
cargo build --profile release-small
```

The `release-small` profile in `Cargo.toml` uses:

- `opt-level = "z"` — optimize for size
- `lto = true` — link-time optimization (smaller binary, slower link)
- `codegen-units = 1` — better optimization, slower compile
- `strip = true` — remove symbols from the binary

Use this when disk space or download size for the tools matters more than build time.

### Optional features and dependencies

- TLS/OpenSSL is optional (`tls` feature). Disabling it reduces dependency code when you don’t need HTTPS in the build tooling.
- Future work may introduce a “minimal” feature set (e.g. no LSP, no network) for a minimal compiler binary; not yet implemented.

---

## 3. Checklist for IoT / microcontroller targets

| Item | Action |
|------|--------|
| Optimization | Use `optimize = "size"` in config.toml or rely on `tlangc compile` default (-Os). |
| Strip | Use `-s` or `strip` on the final binary. |
| Dead code | Add `-ffunction-sections -fdata-sections` and `-Wl,--gc-sections` when possible. |
| Debug | Set `debug = false` in config.toml for production. |
| Imports | Import only the stdlib packages you need. |
| Crypto | Omit crypto/OpenSSL in your Tlang code if not needed to avoid linking OpenSSL. |
| Compiler size | Use `cargo build --profile release-small` if you need smaller compiler binaries. |

---

## See also

- [Build system](build-system.md) — config.toml and `tlang build`
- [Getting started](getting-started.md) — install and first program
- [PRD — Technical success](../_bmad-output/planning-artifacts/prd.md) — “Light enough to run on IoT, drones, and microcontrollers”
