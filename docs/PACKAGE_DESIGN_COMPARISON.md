# Package Design: Existing vs Proposed

## Recommended: `dhimpu "path" as alias`

**Using an alias is the preferred import style:**

- **Explicit:** `fmt.Printf` shows the symbol comes from `fmt`.
- **No clashes:** Multiple packages can export the same name; you choose with the alias.
- **Short names when you want:** `dhimpu "strings" as s` then `s.Trim(...)`.
- **Already supported:** Parser, codegen, and resolver handle `dhimpu "path" as alias` and `alias.Symbol` → `alias_Symbol` in C.

Example:
```tl
dhimpu "fmt" as fmt;
dhimpu "./utils" as u;

#prarambham() {
    fmt.Printf("Hello\n");
    @x int = u.Sum(...);
}
```

---

## Summary (current behaviour)

| Aspect | **Current** |
|--------|--------------|
| Package declaration | **None** – no package declaration at top of file |
| Import | **`dhimpu "path" as alias;`** (recommended; alias required for clarity) |
| How to use imports | Qualified: `alias.Printf(...)`, `alias.Sum(...)` |
| Export rule | Capital letter = exported (Go-style) |

---

## 1. Current design

- **Parser** (`parser.rs`): Parses `dhimpu "path" [as alias];` at top, then rest of program. No package declaration.
- **AST** (`ast.rs`): `Program { imports: Vec<ImportInfo>, statements }`; `ImportInfo { path, alias }`.
- **Package resolver** (`package.rs`): Derives package name from import path when loading (e.g. `"fmt"` → `"fmt"`, `"./utils"` → `"utils"`). Root program is `"main"` in dependency graph.
- **Codegen** (`codegen.rs`): Builds `import_aliases` from path → alias. Emits `alias.func` as `alias_func` in C.
- **Usage**: Files use `dhimpu "path" as alias;`; calls are qualified: `fmt.Printf`, `utils.Sum`.

---

## 2. Proposed design (what you want)

- **No `samooham`** at top of file.
- **Only** `dhimpu <file path>`.
- After `dhimpu "foo"`, all **exported** (Capital) functions/structs from that file are available **directly** in the current file:
  - `Printf(...)` instead of `fmt.Printf(...)`
  - `Sum(...)` instead of `utils.Sum(...)`

So the main change is: **import = bring exported names into scope without a prefix**.

---

## 3. Comparison and trade-offs

### 3.1 Removing `samooham` (no package declaration)

**Pros**
- Less boilerplate; one less line in every file.
- File identity can be inferred from path (e.g. entry point = file you compile; others = libraries).

**Cons / things to define**
- **Entry point**: Today “main” is identified by `samooham adhi` + presence of `#prarambham()`. Without `samooham`, you need a rule, e.g.:
  - “The compiled file is always the main program,” and/or
  - “`#prarambham()` exists in this file ⇒ this file is the main program.”
- **Package identity for tooling**: Build/cache/deps today can use `program.package_name`. You’d derive a logical name from path (e.g. `"adhi"` for the main file, last segment of path for others) and use that only internally.

**Suggestion:** Make `samooham` optional. If absent, set `program.package_name` from context:
- Main file being compiled → `Some("adhi")`.
- Loaded as dependency → `Some(last_component(import_path))` (e.g. `"./utils"` → `"utils"`).  
No grammar change; only change defaults in parser/package layer.

---

### 3.2 Direct use of symbols (no prefix after `dhimpu`)

**Pros**
- Shorter, less repetitive: `Printf(...)` instead of `fmt.Printf(...)`.
- Feels more “script-like” and convenient for small programs.

**Cons**
- **Name clashes**: Two packages exporting the same name (e.g. both have `Print`) → ambiguous. You must either:
  - Disallow and error (“Print is exported by both fmt and log”), or
  - Allow `dhimpu "path" as alias` and use **only** qualified form for that import (`log.Print`), or
  - Let user choose which one is “default” and force the other to be qualified.
- **Discoverability**: `Printf` alone doesn’t show which package it comes from; you have to look at imports.
- **Semantics**: You need a clear rule: “direct use = search only among symbols exported by current file’s `dhimpu` list.”

**Recommendation:** Prefer **`dhimpu "path" as alias`** everywhere. It avoids name clashes, keeps call sites explicit (`alias.Symbol`), and allows short aliases when desired (e.g. `as fmt`, `as s`). Optional future addition: `dhimpu "path";` (no alias) could bring exported names into scope for direct use, with a compile-time error if two such imports export the same name.

---

## 4. Implementation impact (by component)

### 4.1 Parser (`parser.rs`)

- **Optional `samooham`:** Already effectively optional in structure; you only need to stop requiring it and set `package_name` when missing (see above).
- **`dhimpu`:** Grammar can stay as is: `dhimpu <string|identifier> [as alias];`. No change needed for “direct use” – that’s resolution/codegen.

### 4.2 AST (`ast.rs`)

- Keep `Program { package_name, imports, statements }` and `ImportInfo { path, alias }`.
- Optional: add a flag per import like `bring_into_scope: bool` (true when no `as alias`) if you want to represent “direct” vs “qualified-only” in the AST; otherwise you can infer from `alias.is_none()`.

### 4.3 Package resolver (`package.rs`)

- **No change** to resolution logic: you still resolve path → file, load it, collect exported (Capital) names.  
- **Optional:** When building `PackageInfo` for a file that has no `samooham`, set `name` from path (e.g. last segment) so tools and codegen have a stable package id.

### 4.4 Name resolution / semantic pass (new or extend existing)

You need a place that answers: “For this bare identifier `X` in a function call or type, which package does it come from?”

- **Today:** Only `package.ident` is resolved (in codegen via `import_aliases`); bare `ident` is “current package or global.”
- **Proposed:** Bare `ident` that is Capital and not defined in current file ⇒ must come from exactly one `dhimpu "path";` (no alias) that exports `ident`. If zero or multiple, error.

So either:
- Add a small **resolution pass** after parse: for each bare exported-name use, bind it to an import (and optionally attach that to the AST), or
- Do the same in **codegen**: when emitting `FunctionCall { name: "Printf", ... }`, look up which import exports `Printf` and emit the right C name (e.g. `fmt_Printf`). You must then also **check** that no two imports export the same name when both are “direct” (no alias).

### 4.5 Codegen (`codegen.rs`)

- **With alias:** Unchanged: `alias.Foo` → `alias_Foo` in C.
- **Without alias (direct):** For each `dhimpu "path";`, you have a logical package name (e.g. from path). When generating a call to a bare `Printf`, resolve `Printf` to that package and emit `path_last_segment_Printf` (e.g. `fmt_Printf`). So C naming stays `package_func`; only the Tlang side allows omitting the package in the source.
- **Imported package emission:** Ensure functions from imported packages are emitted with the **same** C prefix (e.g. `fmt_Printf`) that you use at call sites. Right now, imported packages’ functions are generated with `generate_statement` and may not be getting that prefix; that’s a separate bug/cleanup to fix so that “direct” and “qualified” both line up.

---

## 5. Suggested order of changes

1. **Make `samooham` optional**
   - Parser: if no `samooham` seen, set `package_name = Some("adhi")` for the main file (or derive from filename); for loaded packages, set from import path in `PackageResolver`.
   - Linter/formatter: treat “missing package” as optional, not error.

2. **Implement “direct” use for `dhimpu "path";` (no alias)**
   - Build a map: “symbol → package” from all `dhimpu "path";` (no alias) and their exported names.
   - On clash (same symbol from two such imports), error with a clear message.
   - In codegen, for `FunctionCall { name }` (and similar for types): if `name` is not `package.ident` and is exported from exactly one direct import, use that package for the C name.

3. **Keep `dhimpu "path" as alias;`**
   - Only qualified use (`alias.Symbol`). No names in global scope from that import. No change to current behavior.

4. **Tests**
   - File with no `samooham`, only `dhimpu "fmt";`, and `Printf(...)` in `#prarambham()`.
   - File with both `dhimpu "fmt";` and `dhimpu "log";` and bare `Print` → must error (clash).
   - File with `dhimpu "fmt" as fmt;` and `fmt.Printf(...)` → unchanged behavior.

---

## 6. Summary table (what to change)

| Component      | Change |
|----------------|--------|
| Parser         | Treat `samooham` as optional; default `package_name` when missing. |
| AST            | Optional: add `bring_into_scope` or keep inferring from `alias.is_none()`. |
| Package        | No change; optionally set package name from path when file has no `samooham`. |
| Resolution     | New or extended: resolve bare Capital identifiers to exactly one “direct” import; error on clash. |
| Codegen        | For bare `FunctionCall`/type use, resolve to package and emit `pkg_symbol`; ensure imported code is emitted with same prefix. |
| Linter/format  | Allow missing `samooham`; optional warning. |

This gives you the desired “no package declaration + use Capital names directly after `dhimpu <file path>`” while keeping qualified imports for clarity and disambiguating clashes.
