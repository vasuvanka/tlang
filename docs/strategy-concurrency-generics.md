# Strategy: Concurrency and Generics

This document is the placeholder for the **concurrency** and **generics** strategy for Tlang, aligned with Phase 2 (Growth) in the PRD. Both features are post-MVP.

---

## 1. Generics

### 1.1 Goals (TBD)

- Reuse without duplication (functions and data structures over multiple types).
- Type safety and C backend–friendly codegen.
- Familiarity with Go-style generics where applicable.

### 1.2 Design and Implementation

- **Syntax:** TBD  
- **Approach (monomorphization vs type erasure vs hybrid):** TBD  
- **Phased implementation:** TBD  
- **C codegen:** TBD  

---

## 2. Concurrency

### 2.1 Goals (TBD)

- Support for servers and CLIs (multiple connections, background tasks).
- Optional IoT-friendly concurrency (small runtime, predictable memory).
- Safety and alignment with small-binary goals.

### 2.2 Model: 1:1 Threads First (Decided)

**Decision:** Start with **1:1 OS threads + channels** (CSP). Optional **M:N lightweight tasks** later, behind the same channel API.

- **Phase A (first):** 1:1 threads; one OS thread per logical task; channels for communication. Simple C codegen (pthreads + small channel struct).
- **Phase B (optional):** M:N tasks for many I/O-bound connections; same channel syntax.

Full rationale and patterns: **[Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md)**.

### 2.3 Syntax (Decided)

- **Channels:** Reuse existing **`<-` (move)** for both send and receive:
  - **Send:** `ch <- value;` (move value into channel)
  - **Receive:** `@data = <- ch;` (value moves out of channel)
- **Spawn:** `tlang #fn(args);` — run function in a new OS thread.
- **Close:** `sunyam(ch);` (optional). WaitGroup (implemented: Add/Done/Wait) for “wait N tasks”.

Telugu keywords (e.g. pampu, cheyu) remain optional aliases for later review; the language uses `<-` and `tlang` in the first phase.

### 2.4 Design and Implementation

- **Model:** 1:1 threads + channels (Phase A); optional M:N later (Phase B).  
- **Syntax:** `<-` for channel send/receive; `tlang #fn(...)` for spawn; see §2.3.  
- **Phased implementation:** See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md) §1.2, §2.  
- **C runtime / codegen:** pthreads + channel struct (queue + mutex + cond); see architecture doc.  

---

## 3. References

- **[Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md)** — decided design: 1:1 threads, channels with `<-`, spawn with `tlang`, patterns, C codegen, IoT.
- [PRD — Phase 2 (Growth)](../_bmad-output/planning-artifacts/prd.md): Generics, concurrency.
- [REVIEW_AND_ROADMAP.md](REVIEW_AND_ROADMAP.md): Phase 5 concurrency tasks; roadmap timeline.
- [Porting guide](porting-guide.md): Channels and spawn supported; generics not yet supported.
- [Small binaries & IoT](small-binaries-iot.md): Impact on binary size.
