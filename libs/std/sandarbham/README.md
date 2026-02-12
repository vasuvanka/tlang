# Sandarbham (సందర్భం) — Context

Go-style **context** for cancellation, deadlines, and request-scoped values.  
Import: `@sandarbham = #dhimpu("std/sandarbham");`

## API (matches Go context)

| Tlang | Go | Description |
|-------|-----|-------------|
| `sandarbham.Background()` | `context.Background()` | Root context; never cancelled. |
| `sandarbham.TODO()` | `context.TODO()` | Placeholder when a real context will be added later. |
| `sandarbham.Done(ctx)` | `ctx.Done()` | Returns the done channel (closed when context is cancelled or deadline exceeded). On Windows, may be NULL. |
| `sandarbham.Err(ctx)` | `ctx.Err()` | After done: **0** = ok, **1** = cancelled, **2** = deadline exceeded. |
| `sandarbham.Deadline_ms(ctx)` | `ctx.Deadline()` (time) | Deadline as ms since Unix epoch; 0 if no deadline. |
| `sandarbham.Deadline_ok(ctx)` | `ctx.Deadline()` (bool) | 1 if deadline is set, 0 otherwise. |
| `sandarbham.WithCancel(parent)` | `context.WithCancel(parent)` | New context; cancel by calling `sandarbham.Cancel(ctx)`. |
| `sandarbham.Cancel(ctx)` | `cancel()` | Cancels the context (closes Done, sets Err to 1). |
| `sandarbham.WithDeadline(parent, deadline_ms)` | `context.WithDeadline(parent, t)` | New context that becomes done at `deadline_ms` (absolute, ms since epoch). |
| `sandarbham.WithTimeout(parent, timeout_ms)` | `context.WithTimeout(parent, d)` | New context that becomes done after `timeout_ms` milliseconds. |
| `sandarbham.WithValue(parent, key, value)` | `context.WithValue(parent, key, val)` | New context with request-scoped key-value. `key` and `value` are strings. |
| `sandarbham.Value(ctx, key)` | `ctx.Value(key)` | Returns the value for `key` from this context or any parent; empty/nil if not found. |

## Constants for Err()

- `0` — OK (not done)
- `1` — Cancelled (Cancel was called)
- `2` — Deadline exceeded (timeout or deadline passed)

## Example

```tl
@sandarbham = #dhimpu("std/sandarbham");
@time = #dhimpu("std/time");

#prarambham() {
    @ctx = sandarbham.Background();
    @ctx2 = sandarbham.WithTimeout(ctx, 5000);   // 5 s timeout
    // Pass ctx2 to DB/HTTP calls; they can check sandarbham.Err(ctx2) or receive from sandarbham.Done(ctx2).
    sandarbham.Cancel(ctx2);   // or let timeout fire
}
```

## WithCancel example

```tl
@ctx = sandarbham.Background();
@child = sandarbham.WithCancel(ctx);
// ... use child in a long-running operation ...
sandarbham.Cancel(child);   // signals child (and anything waiting on child.Done())
```

## Notes

- **Done** uses the channel runtime (pthread on non-Windows). On Windows, Done may be NULL.
- **WithDeadline / WithTimeout** use a timer thread (pthread) on non-Windows.
- **WithValue / Value**: key and value are implemented as C strings (const char* / void*). Use string keys (e.g. `"requestID"`) for request-scoped data.
