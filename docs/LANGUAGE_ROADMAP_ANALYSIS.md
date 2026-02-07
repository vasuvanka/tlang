# Tlang Language Roadmap & Current State — Analysis

This document summarizes the **current state** of Tlang and the **roadmap** as of the latest documentation (REVIEW_AND_ROADMAP.md, strategy docs, changelog).

---

## 1. Current State Summary

| Aspect | Status |
|--------|--------|
| **Version** | 0.1.0 |
| **Overall** | Functional for real-world programming with core data structures |
| **Compiler** | Rust-based, compiles to C; single binary (tlangc) + LSP (tlang-lsp) |
| **Install** | install.sh / install.ps1; `tlang` wrapper: compile, run, test |

### 1.1 Language Core — Implemented

- **Types:** `int`, `float`, `string`, `bool`, `void`; pointers (`*T`, `**T`); type inference.
- **Variables:** Immutable by default (`@x`), mutable (`@!x`).
- **Control flow:** `okavela`/`lekapothe`, `malli`, `agu`/`konasagu`.
- **Data structures:** Arrays `[N]T`, slices `[]T` (append, len, cap), structs (`nirmanam`), maps (`jatha`).
- **Functions:** Full support; entry point `#prarambham()`.
- **Packages:** `@var = #dhimpu("path")`; relative/absolute paths; circular dependency detection; Go-style visibility (uppercase = exported).
- **Error handling:** `error` type, `sunyam` (nil), `okavela err != sunyam { ... }`.
- **Memory:** Borrow checker (Rust-style ownership/borrowing); no GC.

### 1.2 Standard Library — 34 Modules

- **Core:** fmt, strings, strconv, math  
- **System:** os, io, filepath, time  
- **Data/encoding:** json (full: structs, arrays, maps), bytes, sort, hex, base64, csv, xml, **protobuf** (struct marshaling; no repeated/map/enum yet)  
- **Networking:** **http** (client + server, TLS), net (sockets, DNS)  
- **Crypto:** AES-GCM, ChaCha20-Poly1305, RSA, ECC, Ed25519, Argon2, Bcrypt, Scrypt (OpenSSL-backed)  
- **Other:** regexp, rand, log, testing, args, flag, bufio, unicode, reflect, doc, testing/benchmark, errors  

### 1.3 Tooling & Infra

- **LSP:** Completion, go-to-definition, hover, diagnostics, formatting, symbols.
- **Linter:** Built-in (`src/linter.rs`).
- **Formatter:** Built-in (`src/formatter.rs`).
- **Build system:** config.toml, dependency management, lockfile, **incremental compilation** (hash-based cache, dependency tracking).
- **Examples:** 50+ examples; 5 real-world (REST server, file tool, pipeline, CLI, config manager).

### 1.4 Intentionally Removed / Not Present

- **Interfaces:** Removed (was partial; parser bugs, no type-level enforcement). Use structs + functions or `jatha[string]nirmanam{}` for “any” map values.
- **Concurrency:** Channels and spawn implemented (`channel[T]`, `ch <- value`, `@x = <- ch`, `tlang #fn(args)`); see [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md).
- **Generics:** No type parameters or generic functions/types.

---

## 2. Roadmap (from REVIEW_AND_ROADMAP.md)

### Phases — Status

| Phase | Goal | Status |
|-------|------|--------|
| **Phase 1** | Core data structures (arrays, slices, structs, maps) | ✅ Complete |
| **Phase 2** | Package system (imports, visibility, multi-file) | ✅ Complete |
| **Phase 3** | Enhanced stdlib (JSON, Protobuf, HTTP) | ✅ Complete |
| **Phase 4** | Language enhancements (interfaces removed; error/type improvements) | ⚠️ Partial |
| **Phase 5** | Advanced (concurrency, generics) | ❌ Not started |
| **Phase 6** | Developer experience (LSP, build, testing) | ✅ LSP + build done; debugger/coverage optional |
| **Phase 7** | Documentation & community | Ongoing |

### 2.1 Done (No Longer on Roadmap as “To Do”)

- Arrays/slices, structs, maps (incl. iteration, delete, len).
- Package system with visibility and circular-dep detection.
- JSON (struct/slice/map marshal/unmarshal, validation).
- HTTP/HTTPS client and server, TLS, net layer.
- LSP, linter, formatter, incremental build.
- Protocol Buffers (basic + struct marshaling; no repeated/map/enum).
- Borrow checker, 50+ examples, real-world examples.

### 2.2 Partially Done / To Verify

- **Error handling:** Implemented but “may need verification”; error propagation patterns and wrapping not yet added.
- **Package system:** No `init()`-style package initialization; “export visibility” noted as refinable.
- **Protobuf:** Repeated fields, maps, enums, struct tags for field numbers — future.

### 2.3 Planned (Explicit Next Steps)

**Near term (roadmap “Next 3 Months” — high level):**

1. **Concurrency foundation**  
   **Design decided:** 1:1 OS threads + channels (CSP). Channels: `ch <- value` (send), `@x = <- ch` (receive). Spawn: `tlang #fn(args);` → pthread on Unix, direct call on Windows. See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md). Implementation: channel type + C runtime, spawn → pthread_create + wrapper (done).

2. **Generics design**  
   Syntax and type parameters; monomorphization vs type erasure; C codegen.  
   *Strategy doc: fully TBD.*

3. **Polish & v1.0 prep**  
   Performance tuning, docs, migration guides, community.

**Medium / lower priority:**

- Error handling: verify implementation, add propagation, wrapping, better messages.
- Type system: type aliases, assertions, (optional) type switches.
- Debugger: debug symbols, GDB/LLDB, source mapping.
- Testing: coverage, benchmarking integration, fixtures.
- Docs: API reference generator, video tutorials, performance guide.
- Technical debt: error messages, codegen size/speed, type inference and errors.

### 2.4 Explicitly Deferred / Low Priority

- **Concurrency:** “Very high” effort (e.g. 6–8 weeks); design not decided (see strategy-concurrency-generics.md).
- **Generics:** “Very high” effort (e.g. 8–10 weeks); “may not be necessary for v1.0”.
- **Interfaces:** Removed; no current plan to reintroduce.
- **Struct methods:** Optional future enhancement.
- **Package init:** Future enhancement.

---

## 3. Strategy Gaps (from strategy-concurrency-generics.md)

- **Generics:** Goals, syntax, monomorphization vs type erasure, phased plan, C codegen — all TBD.
- **Concurrency:** **Design decided** — see [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md). Model: 1:1 threads + channels (CSP). Syntax: `<-` for channel send/receive, `tlang #fn(...)` for spawn. C runtime: pthreads + channel struct. Optional Telugu keywords (pampu, cheyu) remain for later review.

---

## 4. Version Goals (from REVIEW_AND_ROADMAP)

- **0.2.0 (3 months):** Arrays, structs, maps, packages, JSON, 50+ examples, tests, incremental build, Protobuf — **all marked done.**
- **1.0 (12 months):** Core language, full stdlib, HTTP, LSP, production-ready compiler, real-world apps — **largely achieved except concurrency/generics and some polish.**

So the doc treats **core and stdlib as 1.0-ready**; **concurrency and generics** are the main open roadmap items for “growth” beyond 1.0.

---

## 5. Recommendations (Condensed)

1. **Treat current state as “MVP / 1.0 core”**  
   Servers, CLIs, system tools, and most stdlib use cases are supported; interfaces are intentionally absent.

2. **Lock roadmap decisions before big work:**  
   Concurrency (model + syntax) and generics (syntax + codegen strategy) should be decided and written into the strategy doc before multi-week implementations.

3. **Short-term focus:**  
   Error-handling verification and small improvements, type-system clarity, debugger support, and docs/community have clearer scope than concurrency/generics.

4. **Track “post-MVP” separately:**  
   Concurrency and generics are explicitly post-MVP in the strategy doc; keeping them as a separate “Phase 2 (Growth)” roadmap avoids overloading 1.0 scope.

---

*Source: REVIEW_AND_ROADMAP.md, strategy-concurrency-generics.md, interfaces.md, CHANGELOG.md, and related docs. Last aligned: February 2025.*
