# Concurrency Architecture & Patterns — Suggestions for Tlang

This document suggests a **concurrent architecture** and **patterns** that fit Tlang’s goals: compiles to C, no GC, borrow checker, servers/CLIs, and optional small binaries (IoT). It is input for the strategy in [strategy-concurrency-generics.md](strategy-concurrency-generics.md).

---

## 1. Recommended Architecture: CSP + Lightweight Tasks

### 1.1 Why CSP (Channel-Based) Fits Tlang

- **Communicating Sequential Processes:** “Don’t communicate by sharing memory; share memory by communicating.” Aligns with Tlang’s immutability and borrow checker: move ownership across channels instead of shared mutable state.
- **C codegen:** Channels can map to a small C runtime (bounded queues, mutex/cond or lock-free where appropriate). No need for a full green-thread scheduler in v1; you can start with **1:1 threads + channels** and add a lightweight task layer later.
- **Predictable memory:** Bounded channels and explicit sends/receives give predictable allocation; good for IoT and small binaries if the runtime is kept minimal.

### 1.2 Suggested Model: Phased

| Phase | Model | Use case |
|-------|--------|----------|
| **Phase A** | **1:1 OS threads + channels** | Servers (one thread per connection or worker), CLIs (background tasks). No scheduler; C codegen is straightforward (pthreads + a small channel struct). |
| **Phase B** (optional) | **Lightweight tasks (M:N)** | Many I/O-bound tasks (e.g. thousands of connections). Requires a small scheduler and stack management; can be a separate “concurrency stdlib” so IoT builds can omit it. |

**Recommendation:** Start with **Phase A** (1:1 threads + channels). It gives you:

- Clear mental model (one thread = one OS thread).
- Easy mapping to C (pthreads, mutex, cond).
- Channel-based patterns (CSP) without a custom scheduler.
- Option to add M:N later behind the same channel API so existing code keeps working.

---

## 2. Core Primitives to Implement First

### 2.1 Channels (ఛానల్ / channel)

- **Unbuffered:** `send` blocks until `receive`; good for synchronization and handoffs.
- **Buffered:** Bounded capacity; send blocks only when full. Keeps memory bounded.

#### Using `<-` (move) for both send and receive

Tlang already reserves `<-` for **move** (ownership transfer): `@y = <- x` means “value moves from `x` to `y`” (destination on the left, source on the right). The same operator can be used for channel send and receive:

| Operation | Syntax | Reading |
|-----------|--------|--------|
| **Send**  | `ch <- data` | Move `data` into `ch` (channel is destination). |
| **Receive** | `@data = <- ch` | Value moves out of `ch` into `data` (channel is source). |

**Why one symbol for both:**

- **Consistent with move:** Arrow always means “from source → to destination.” Send: source = variable, destination = channel. Receive: source = channel, destination = variable.
- **No extra keyword:** Reuses the existing `<-` token; no need for `pampu`/receive keyword or a second operator.
- **Disambiguation by position:** `ch <- data` is send (channel on left). `<- ch` is a receive expression (channel on right). Parser can tell them apart from context.
- **Avoid `<<` for channels:** Using `ch << data` would overload `<<` (often used for bit-shift or streams elsewhere). Sticking to `<-` keeps “channel = move” as the single concept.

**Suggested syntax:**

```tl
// Create
@ch channel[int];               // unbuffered
@chBuffered channel[int] = 10;  // buffered, cap 10

// Send: move value into channel
ch <- value;

// Receive: value moves out of channel
@x int = <- ch;

// Close (optional)
sunyam(ch);
```

- **C codegen:** A small struct (queue + mutex + cond or semaphore); send/receive become C functions that lock, push/pop, signal/wait.

### 2.2 Spawning a Task (tlang)

- **1:1 model:** “Run this function in a new OS thread.” Implemented: C codegen uses `pthread_create` + wrapper (Unix); on Windows, direct call for now.

Suggested syntax:

```tl
tlang #other_task(42);           // run in new thread, no return
@result int = tlang #compute();  // if you add “future” later
```

- Keep **no shared mutable state** by default: pass data via arguments and channels; borrow checker can enforce “no shared mutable refs across threads” (e.g. only `mallinchu` ownership or channel send).

### 2.3 Synchronization (Minimal Set)

- **Channels** for communication and implicit synchronization (primary).
- **Mutex (optional):** Only if you introduce “shared mutable” explicitly (e.g. `@!mutex` protected section). Prefer channels first so the common case stays shared-nothing.
- **WaitGroup (implemented):** “Wait until N tasks finish.” Syntax: `@wg WaitGroup;` then `wg.Add(n)`, `wg.Done()` (in each task), and `wg.Wait()`. Implemented with counter + mutex + cond (pthread on Unix; stubs on Windows). Useful for worker pools and server shutdown.

---

## 3. Recommended Patterns

### 3.1 CSP: Producer–Consumer

One or more producers send on a channel; one or more consumers receive. Bounded channel keeps memory under control.

```tl
// Producer (e.g. run in own thread via tlang #producer())
#producer() {
    malli {
        // ... produce work ...
        ch <- work;
    }
    sunyam(ch);
}

// Consumer
#consumer() {
    malli {
        @item int = 0;
        @ok int = 0;
        item, ok = <- ch;       // receive + closed flag (hypothetical multi-return)
        okavela ok == 0 { agu; }
        // process item
    }
}
```

### 3.2 Worker Pool (Fixed Number of Workers)

- One channel for work items; N workers (N threads) receive and process.
- Good for servers (N = number of cores or small multiple) and for limiting concurrency.
- Use a **WaitGroup** to wait until all workers finish (e.g. shutdown): `@wg WaitGroup;` `wg.Add(N);` spawn N workers that each call `wg.Done();` then `wg.Wait();`.

### 3.3 Pipeline (Stages Connected by Channels)

- Stage 1 sends to channel A, stage 2 receives from A and sends to B, etc.
- Each stage can be one thread (or one task per stage). Clear data flow and no shared state.

### 3.4 Request–Response over Channels

- For each “request” you allocate a channel (or use a struct with a response channel). Client sends request, blocks on response channel; server receives, computes, sends reply. Fits RPC-like patterns without shared memory.

### 3.5 Fan-Out / Fan-In

- **Fan-out:** One channel feeds multiple workers (each receive competes for work).
- **Fan-in:** Multiple producers send to one channel; one consumer (or pipeline stage) receives. Both map cleanly to channels and 1:1 threads.

### 3.6 Select (Multi-Channel Wait) — Later

- “Wait on multiple channels; proceed on the first ready.” Very useful for servers and timeouts. Requires a `select` primitive in the runtime (e.g. poll multiple queues/events). Can be Phase B or a follow-up.

---

## 4. Safety and Borrow Checker

- **Ownership across threads:** Allow **moving** values (including ownership) across channel send; no shared mutable references between threads unless you introduce an explicit “shared” type (e.g. mutex-protected).
- **No shared mutable by default:** Borrow checker can enforce: only one owner or one mutable borrow at a time; sending on a channel can “move” ownership so the receiver is the new owner. This avoids data races in the common case.
- **Channel as shared capability:** The channel handle itself can be shared (e.g. clone/copy for send-only or receive-only); implementation uses internal mutex in the C runtime, not user-visible shared mutable state.

---

## 5. IoT / Small Binary Consideration

- **Optional concurrency runtime:** If the binary is built without “concurrency stdlib” (no channels, no spawn), link only single-threaded C; no pthreads, no channel structs. Keeps IoT/small builds minimal.
- **Bounded channels only:** Fixed capacity and no unbounded queues so memory is predictable.
- **No mandatory scheduler:** With 1:1 threads, the “runtime” is just pthreads + a small channel layer; no green-thread stack allocator or scheduler in the minimal build.

---

## 6. Summary Table

| Item | Suggestion |
|------|------------|
| **Model (first)** | 1:1 OS threads + channels (CSP) |
| **Later (optional)** | M:N lightweight tasks, same channel API |
| **Primitives** | Channels (unbuffered + buffered), spawn (tlang), close, WaitGroup (Add/Done/Wait) |
| **Patterns** | Producer–consumer, worker pool, pipeline, request–response, fan-out/fan-in |
| **Safety** | Ownership/move across channels; no shared mutable across threads by default |
| **C codegen** | pthreads + small channel struct (queue + mutex + cond) |
| **IoT** | Optional concurrency; omit channel/spawn for smallest builds |

---

## 7. References

- [Strategy: Concurrency and Generics](strategy-concurrency-generics.md) — current placeholder.
- [REVIEW_AND_ROADMAP.md](REVIEW_AND_ROADMAP.md) — Phase 5 (Concurrency).
- [Small binaries & IoT](small-binaries-iot.md) — binary size and linking.
- [Porting guide](porting-guide.md) — channels and spawn supported; syntax mapping for Go.

---

*This is a suggestion document for the Tlang concurrency design. Implementation details (syntax, C ABI, and keyword choices like `<-` for channel send/receive and tlang for spawn) should be aligned with the language team and strategy-concurrency-generics.md.*
