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

### 2.2 Model: Green Thread vs 1:1 Thread

**Open design question:** Does Tlang intend to use a **Green Thread** model (like Go’s goroutines: many lightweight tasks on a small pool of OS threads) or a **1:1 thread** model (one OS thread per logical task)?

- **Green threads:** Familiar to Go users; good for I/O-bound and many small tasks; requires a scheduler/runtime.
- **1:1 threads:** Simpler mental model; maps directly to OS; may be heavier for many tasks.

*Decision deferred; to be revisited later.*

### 2.3 Candidate Keywords for Async Tasks (for later review)

The following Telugu-derived words are recorded here for future concurrency/async syntax. **Do not treat as reserved yet; to be checked and decided later.**

| Word   | Meaning (Telugu) | Possible use        |
|--------|------------------|---------------------|
| **pampu** | send             | e.g. send to channel, spawn/send task |
| **cheyu** | do               | e.g. do (run) async task              |

These may be used for spawning tasks, sending on channels, or similar constructs once the concurrency model is chosen.

### 2.4 Design and Implementation

- **Model (green vs 1:1 vs async):** TBD (see §2.2).  
- **Syntax (spawn, channels, sync; pampu/cheyu):** TBD (see §2.3).  
- **Phased implementation:** TBD  
- **C runtime / codegen:** TBD  

---

## 3. References

- [PRD — Phase 2 (Growth)](../_bmad-output/planning-artifacts/prd.md): Generics, concurrency.
- [REVIEW_AND_ROADMAP.md](REVIEW_AND_ROADMAP.md): Concurrency (goroutines, channels); generics (syntax, type parameters, constraints).
- [Porting guide](porting-guide.md): Channels/goroutines and generics not yet supported.
- [Small binaries & IoT](small-binaries-iot.md): Impact on binary size.
