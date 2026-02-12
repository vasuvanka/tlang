# Tlang Language Reanalysis

A single-pass reanalysis of the Tlang language based on the compiler, AST, stdlib, and docs (as of current codebase).

---

## 1. Overview

| Aspect | Summary |
|--------|---------|
| **What it is** | A compiled language with Telugu-inspired keywords that compiles to C. |
| **Entry point** | `#prarambham()` — generated as C `main()` that calls `prarambham()`. |
| **Import** | No package keyword; `@alias = #dhimpu("path")` binds a package to a variable; calls are `alias.Func()`. |
| **Stdlib** | Built-in: no .tl files for std; C is generated from Rust in `src/libs/*.rs`. Imports use `std/<name>` (e.g. `std/fmt`, `std/sandarbham`). |
| **Pipeline** | Lexer → Parser → (type inference, borrow checker) → Codegen → C → system compiler (gcc/clang). |

---

## 2. Syntax and Keywords (Lexer/Parser)

- **Variables:** `@name` (immutable), `@!name` (mutable). Type optional (inferred when possible).
- **Functions:** `#name(params) returnType { ... }`; return with `mallinchu expr;`.
- **Control flow:** `okavela` (if), `lekapothe` (else), `malli` (for: C-style, condition-only, or `malli key, value := varasa map`).
- **Loop control:** `agu` (break), `konasagu` (continue).
- **Types (keywords):** `int`, `float`, `string`, `bool`, `error`, `channel` (for `channel[elementType]`).
- **Literals / special:** `sunyam` (nil), `nirmanam` (struct), `jatha` (map), `varasa` (map iteration in for).
- **Operators:** `+ - * / % ^`, `== != < > <= >=`, `&& || !`, `=`; `<-` for channel send/receive and move.
- **Other:** `&` / `&mut` (borrow), `*` (deref), `?` (error propagate in AST), `nirmanam(Type)` (Kotha — allocate), `sunyam(expr)` (SunyamFree — release).

Comments: `//` and `/* */`. Semicolons optional (parser accepts newline as statement boundary).

---

## 3. Type System (AST + type_inference)

**Concrete types in AST:**  
`Int`, `Float`, `String`, `Bool`, `Void`, `Error`, `Pointer(Box<Type>)`, `Reference { inner, mutable }`, `Array { size, element_type }`, `Slice { element_type }`, `Struct { name }`, `Map { key_type, value_type }`, `Any`, `Tuple { types }`, `Owned { inner, lifetime }`, `Channel { element_type }`, `WaitGroup`.

**Inference:**  
From literals (number → int/float, string → string), binary ops (same type or int/float → float), array literals (element type from first element), index/slice (from array/slice type). Identifiers and function calls have no inferred type without a symbol table; codegen uses variable_types map filled during codegen.

**Structs:** `nirmanam Name { field type; ... }`. Literals: `Name{ field: expr, ... }`. Field access: `expr.field`.

**Maps:** `jatha[keyType]valueType`, indexing and iteration via `varasa` in for.

**Channels:** `channel[elementType]` or `channel[elementType] = capacity`. Send `ch <- value`, receive `@x = <- ch`, close `sunyam(ch)`.

**Tuples:** Multiple return values `(type1, type2)` and tuple literals in AST.

---

## 4. Execution Model and Codegen

- **Target:** C. Stdlib (slices, maps, channels, WaitGroup, all built-in libs) is emitted in one block; then program-specific C (globals, functions).
- **Functions:** Each Tlang function becomes a C function; `prarambham` becomes the entry; `main()` calls `prarambham()`.
- **Package calls:** `alias.Func(...)` → C name `alias_Func(...)` (dot replaced by underscore). Built-in packages have no .tl; their “exports” are just the C names emitted in libs.
- **Concurrency:** Channels and WaitGroup use a small C runtime (pthread on non-Windows); spawn is `tlang #name(args)` (pthread on Unix; on Windows runs in same thread). No `select` in parser/codegen.
- **Borrow checker:** Implemented in `borrow_checker.rs` (ownership, moves, borrows); runs before codegen. Affects whether code is accepted, not the shape of generated C.

---

## 5. Standard Library (Built-in)

All are **built-in** (no .tl on disk for std): `fmt`, `strings`, `strconv`, `math`, `os`, `io`, `filepath`, `time`, `regexp`, `rand`, `log`, `testing`, `args`, `flag`, `bytes`, `sort`, `json`, `unicode`, `csv`, `xml`, `url`, `neturl`, `bufio`, `benchmark`, `doc`, `reflect`, `crypto`, `hex`, `base64`, `http`, `errors`, `net`, `protobuf`, **`sandarbham`** (context).

Resolution: `std/<name>` is recognized as built-in; no file is loaded; a placeholder package with empty function list is used. Codegen always emits the full stdlib C (from `generate_all_libs()`), so any `alias.Func` that matches a generated C name works.

---

## 6. Packages and Imports

- **Import:** `@var = #dhimpu("path")`. Path can be `std/foo`, `./rel`, `../rel`, or a name (resolved from search paths).
- **Built-in:** `std/<name>` → no file; placeholder package; C from libs.
- **Non-std:** Resolved to a file (`<path>/mod.tl` or `<path>.tl`). Exported symbols: functions/vars/structs with uppercase-first names (Go-style).
- **Circular dependency:** Detected; build fails.

---

## 7. Tooling

- **tlangc:** `run` / `build` / `compile`; loads config.toml, fetches deps, compiles to C, invokes system compiler.
- **tlang-lsp:** LSP server (completion, hover, diagnostics, symbols, formatting). Stdlib completions are hardcoded (e.g. fmt.Printf, sandarbham.Background).
- **tlang-port:** Converts Go/Rust to Tlang; supports single file, directory, URL, and pkg.go.dev (fetch Go module zip and port package into folder).
- **tlang-build:** Build system (dependencies, cache, lockfile).
- **Linter and formatter:** Present in `src/linter.rs`, `src/formatter.rs`.

---

## 8. Gaps and Partial Features (vs docs)

- **Interfaces:** Docs say “partially supported” and reference interface-analysis.md; parser only mentions “Struct/interface type” in one branch. No full interface-as-contract or interface variables in the language.
- **Select:** Not in lexer/parser. Concurrency doc suggests “select (multi-channel wait)” for later.
- **Defer:** Not present in AST or codegen.
- **Error propagation:** AST has `ErrorPropagate` and `ErrorCheck`; real usage and codegen behavior need verification against tests/examples.
- **Type conversion:** Docs show `int(x)`, `float(x)`, etc.; implemented in codegen as C casts or library calls where applicable.
- **For-loop syntax:** Docs show both `malli (i < 10; i = i + 1)` and `malli i < 10`; parser implements the various for forms (init/condition/update and range-style with varasa).

---

## 9. Summary Table

| Area | Status |
|------|--------|
| Lexer/parser | Telugu keywords, channels, spawn, borrow/deref, structs, maps, slices, tuples |
| Types | int, float, string, bool, error, pointers, arrays, slices, structs, maps, channels, WaitGroup, tuples |
| Type inference | Literals, binary ops, array/slice/index; no full symbol-table-driven inference for all calls |
| Borrow checker | Ownership, move, borrow (&/&mut), use-after-move checks |
| Codegen | C with stdlib in one blob; prarambham → main; package.Func → package_Func |
| Stdlib | 35 built-in packages (incl. sandarbham); all C generated from Rust |
| Concurrency | Channels, spawn, WaitGroup; no select |
| Context | Sandarbham (Background, Done, Err, WithCancel, Cancel, WithDeadline, WithTimeout, WithValue, Value) |
| Interfaces | Not fully implemented |
| Select / defer | Not implemented |

This reanalysis reflects the current implementation; for normative syntax and semantics, the language reference and concurrency/architecture docs remain the primary spec.
