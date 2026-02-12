// Sandarbham (సందర్భం) - Context: cancellation, deadlines, request-scoped values.
// Go-style context. Import: @sandarbham = #dhimpu("std/sandarbham");
//
// API (implementation is built-in C):
//   sandarbham.Background() -> context
//   sandarbham.TODO() -> context
//   sandarbham.Done(ctx) -> channel (closed when cancelled/deadline)
//   sandarbham.Err(ctx) -> int (0=ok, 1=cancelled, 2=deadline)
//   sandarbham.Deadline_ms(ctx) -> long
//   sandarbham.Deadline_ok(ctx) -> int
//   sandarbham.WithCancel(parent) -> context
//   sandarbham.Cancel(ctx)
//   sandarbham.WithDeadline(parent, deadline_ms) -> context
//   sandarbham.WithTimeout(parent, timeout_ms) -> context
//   sandarbham.WithValue(parent, key, value) -> context
//   sandarbham.Value(ctx, key) -> value
// See README.md for full documentation and examples.
