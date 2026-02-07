# Concurrency Roadmap

Roadmap for Tlang concurrency: design, status, and next steps. See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md) for the full design.

---

## 1. Design (decided)

| Phase | Model | Use case |
|-------|--------|----------|
| **Phase A** | **1:1 OS threads + channels** | Servers, CLIs, background tasks. C codegen: pthreads + channel struct. |
| **Phase B** (optional) | **M:N lightweight tasks** | Many I/O-bound tasks; same channel API. |

**Syntax:**

| Construct | Syntax |
|-----------|--------|
| Channel type | `channel[elementType]` or `channel[elementType] = capacity` |
| Send | `ch <- value` |
| Receive | `@x = <- ch` |
| Close | `sunyam(ch)` |
| Spawn | `tlang #fn(args)` |
| WaitGroup | `@wg WaitGroup;` `wg.Add(n);` `wg.Done();` `wg.Wait();` |

---

## 2. Current status

### Implemented

- [x] **Channel type** — `channel[int]`, `channel[int] = 10` (unbuffered / buffered)
- [x] **Send** — `ch <- value`
- [x] **Receive** — `@x = <- ch` (and `<-` for move)
- [x] **Close** — `sunyam(ch)` for channels
- [x] **Spawn** — `tlang #fn(args);` maps to `pthread_create` (wrapper + thread on Unix; direct call on Windows)
- [x] **C channel runtime** — `TlangCh`, create/send/recv/close (pthread on non-Windows; stubs on Windows)
- [x] **Parser, type inference, codegen** for channels and spawn
- [x] **Documentation** — getting started, language reference, porting guide, etc.
- [x] **WaitGroup** — `@wg WaitGroup;` `wg.Add(n);` `wg.Done();` `wg.Wait();` (C: mutex + cond on Unix; stubs on Windows)

### Not yet done
- [ ] **Select** — wait on multiple channels (Phase B or follow-up)
- [ ] **Windows** — full channel/spawn on Windows (pthreads-win32 or native API)
- [ ] **Borrow checker** — explicit rules for channel send/receive and cross-thread moves
- [ ] **Pattern docs** — producer-consumer, worker pool, pipeline examples in docs

---

## 3. Implementation tasks (from main roadmap)

| Task | Status |
|------|--------|
| Implement channel type and create (unbuffered / buffered) | Done |
| Implement send (`ch <- value`) and receive (`@x = <- ch`) with C runtime | Done |
| Implement spawn (`tlang #fn(...)`) mapping to pthreads | Done (pthread_create + wrapper; Windows: direct call) |
| Add optional close and WaitGroup/join | Done |
| Document patterns (producer-consumer, worker pool, pipeline) | Pending |

---

## 4. Timeline (from REVIEW_AND_ROADMAP)

**Month 1: Concurrency foundation**

- **Week 1–2:** Design and plan — done (1:1 + channels, `<-`, `tlang` spawn, C runtime).
- **Week 3–4:** Implement basic concurrency — done (channels + spawn + WaitGroup with pthread on Unix).

**Next steps (priority)**

1. ~~Implement **pthread_create** for `tlang #fn(args)`~~ — Done.
2. ~~**WaitGroup**~~ — Done: `WaitGroup` type, `wg.Add(n)`, `wg.Done()`, `wg.Wait()` (mutex + cond on Unix).
3. **Windows**: either document “Unix only for now” or add a small Windows threading path for channels/spawn.
4. **Select** and **M:N tasks** remain Phase B / later.

---

## 5. Summary

| Item | Status |
|------|--------|
| **Model** | 1:1 OS threads + channels (CSP); Phase B (M:N) optional later |
| **Channels** | Implemented (unbuffered + buffered, send/receive/close) |
| **Spawn** | Implemented: real threads via pthread on Unix; direct call on Windows |
| **C runtime** | Channel runtime + spawn wrappers (pthread on non-Windows); Windows: stubs/direct call |
| **Docs** | Architecture, getting started, reference, porting updated |
| **Next** | Select, then Windows as needed |

---

## 6. Usage examples

- **Getting started:** [Getting Started – Concurrency](getting-started.md#concurrency-channels-spawn-waitgroup) and [Language Reference – Concurrency](language-reference.md#concurrency).
- **Full example (channels + spawn + WaitGroup):** [Language Reference – Concurrency](language-reference.md#concurrency) and test file `tests/test_concurrency.tl`.
- **Worker-pool pattern:** [Concurrency Architecture – Worker Pool](concurrency-architecture-suggestions.md#32-worker-pool-fixed-number-of-workers).

---

## 7. References

- [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md) — design and patterns
- [REVIEW_AND_ROADMAP.md](REVIEW_AND_ROADMAP.md) — Phase 5 and timeline
- [Strategy: Concurrency and Generics](strategy-concurrency-generics.md) — strategy summary
