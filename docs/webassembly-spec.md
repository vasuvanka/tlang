# Tlang WebAssembly Target — Specification & Roadmap

This document defines the goals, scope, and roadmap for compiling Tlang to WebAssembly (WASM).

---

## 1. Goals

| Goal | Description |
|------|-------------|
| **Run in browser** | Tlang programs compile to WASM and run in browsers without plugins |
| **Run on edge** | Deploy to Cloudflare Workers, Fastly Compute, Deno Deploy, etc. |
| **Single codebase** | Same Tlang source compiles to native (C) or WASM |
| **Minimal runtime** | No GC; predictable memory; small WASM output |

---

## 2. Non-Goals (v1)

| Non-Goal | Reason |
|----------|--------|
| Full stdlib in WASM | Many stdlib modules (os, net, file) have no WASM equivalent; use subset |
| DOM/Window access | Requires JS interop; out of scope for initial target |
| Multi-threading (WASM threads) | Complex; defer to later phase |

---

## 3. Architecture

### 3.1 Compilation Path

```
Tlang (.tl) → [existing] C codegen → C target
                   ↓
            [new] WASM codegen → WASM target
```

**Option A:** Add WASM backend to codegen (emit WASM text/binary instead of C).  
**Option B:** Keep C codegen; add C→WASM step (Emscripten, wasi-sdk/Clang).  
**Recommendation:** Option B first — reuse C compiler; Emscripten/wasi-sdk can compile C to WASM. Faster to ship.

### 3.2 Target Environments

| Environment | Use case |
|-------------|----------|
| **Browser** | Interactive demos, playground, small tools |
| **WASI** | Serverless, edge functions, CLI in WASM runtime |
| **Node.js** | Run Tlang via `node --experimental-wasm-modules` |

---

## 4. Phase Roadmap

### Phase 1: Feasibility (TBD)

- [ ] Define WASM subset of Tlang (no pointers? no channels? restrict to what WASM supports)
- [ ] Prototype: compile minimal Tlang program (e.g. `#prarambham()` hello) to C, then C→WASM via Emscripten or wasi-sdk
- [ ] Document restrictions and unsupported features

---

### Phase 2: Core Subset (TBD)

- [ ] Support: int, float, string (via linear memory), bool, arrays, structs
- [ ] Support: functions, control flow (okavela, malli), basic arithmetic
- [ ] Restrict or remove: pointers, channels, spawn, os/net, file I/O
- [ ] Output: WASM binary + JS glue (if browser) or standalone WASM (if WASI)

---

### Phase 3: Standard Library Subset (TBD)

- [ ] Define `std/wasm` or `std/wasi` — subset of stdlib that works in WASM
- [ ] Implement: fmt (basic), strings, math, json (if needed)
- [ ] Document: which stdlib modules are WASM-compatible

---

### Phase 4: Tooling & Integration (TBD)

- [ ] `tlang compile hello.tl --target wasm` or `tlang build --target wasm`
- [ ] Integrate Emscripten or wasi-sdk in build pipeline
- [ ] Playground: run Tlang in browser via WASM

---

### Phase 5: Optimizations (TBD)

- [ ] Reduce WASM size (strip unused code, minify)
- [ ] Optional: WASM-native codegen (skip C) for better output

---

## 5. Technical Constraints

| Constraint | Implication |
|------------|-------------|
| **WASM has no GC** | Compatible with Tlang's no-GC model |
| **WASM has linear memory** | Strings, slices, maps need custom allocator |
| **WASM has no system calls** | os, net, file I/O require WASI or JS interop |
| **WASM has no threads (v1)** | Channels/spawn would need different semantics |

---

## 6. Success Criteria

- [ ] `tlang compile hello.tl --target wasm` produces a valid `.wasm` file
- [ ] Hello-world WASM runs in browser (via HTML + JS loader)
- [ ] Hello-world WASM runs via `wasmtime` or similar WASI runtime
- [ ] Documentation: "Tlang for WebAssembly" guide

---

## 7. References

- [WebAssembly specification](https://webassembly.github.io/spec/)
- [WASI](https://wasi.dev/)
- [Emscripten](https://emscripten.org/)
- [wasi-sdk](https://github.com/WebAssembly/wasi-sdk)
- [Clang WebAssembly target](https://clang.llvm.org/docs/WebAssembly.html)

---

*Last updated: February 2025*
