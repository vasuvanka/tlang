# Interface Definition Usage – Analysis

## Summary

**Verdict: Interfaces are only partially useful in the current state.** The design and codegen (vtables, constructors) exist, but a **parser bug** blocks normal usage, and there is **no type-level enforcement** or ergonomic polymorphism. Fixing the parser and documenting the manual pattern would make them useful; otherwise consider them experimental.

---

## What Is Implemented

### 1. **Interface definition (parser + AST)**
- `interface Name { Method1() type1; Method2() type2; }` is parsed.
- Method signatures: name, parameter list, optional return type.
- **Interface embedding**: `interface ReadWriter { interface Reader; interface Writer; Close(); }` is supported (methods from embedded interfaces are merged during codegen).

### 2. **Interface type in the type system**
- `Type::Interface { name }` for named interfaces (e.g. `Shape`).
- `interface{}` (Type::Any) for “any” type, allowed **only** as map value type (e.g. `jatha[string]interface{}`).
- In C output, interface types become `void*`; no distinct representation.

### 3. **Struct “method” tracking**
- Functions named `StructName_MethodName` (e.g. `Rectangle_Area`, `Circle_Perimeter`) are recorded in `struct_methods` during codegen.
- Used only for **interface satisfaction checking** (no separate type-check phase).

### 4. **Interface satisfaction (codegen)**
- After generating structs and functions, the compiler:
  - For each interface, scans all structs.
  - Checks that the struct has a function `StructName_MethodName` for each interface method, with matching parameter count (excluding receiver) and return type.
- **No compile-time error** is emitted when a struct does **not** satisfy an interface; the compiler simply does not generate a vtable for that pair.

### 5. **Vtable and constructor generation**
- For each (struct, interface) pair that satisfies the interface:
  - A **vtable** is emitted: `static InterfaceName_vtable structname_vtable_interfacename = { .Method = (void*)StructName_Method, ... };`
  - A **constructor** is emitted: `InterfaceName* NewStructName_InterfaceName(StructName* s)` that allocates the interface struct, sets `vtable` and `data = (void*)s`.
- The **global** `NewInterfaceName(void* data)` constructor is also generated but is less useful than the struct-specific one.

### 6. **Usage pattern (when it works)**
- You must **manually**:
  1. Call `NewCircle_Shape(&circle)` to get a `Shape*`.
  2. Call methods via `shape->vtable->Area(shape->data)` (and cast/use result as needed).
- There is **no** language-level “assign struct to interface variable” or “call method on interface value”; everything goes through the generated C and the vtable.

---

## Current Blockers

### 1. **Parser bug: newlines in interface body**
- **Symptom**: `Expected method name in interface` at the first method line (e.g. line 7 in `interface Shape { Area() float; ... }`).
- **Cause**: After `{`, the parser does **not** skip `Token::Newline`. The loop expects either `Interface` (embedding) or `Identifier`/`HashIdentifier` (method name). On a new line, the current token is `Newline`, so it fails.
- **Impact**: Any interface whose methods are not on the same line as `{` fails to parse. So **real-world interface definitions are currently unusable** unless methods are written on one line (e.g. `interface Shape { Area() float; Perimeter() float; }`).

### 2. **No compile-time enforcement**
- If you **use** a struct as an interface (e.g. by calling `NewFoo_Shape(&foo)`), the compiler does **not** check that `Foo` actually satisfies `Shape`.
- If a struct is **intended** to implement an interface but is missing a method, you get **no error**; you only see a problem at C compile/link time (e.g. missing or wrong function).

### 3. **No language-level polymorphism**
- You cannot write something like:
  - `@shape Shape = circle` (implicit conversion to interface type), or
  - `@shape Shape = NewCircle_Shape(&circle)` with a proper `Shape` type in Tlang.
- Interface types are represented as `void*` in C; the language does not expose a dedicated “interface variable” abstraction with method calls.

### 4. **Ergonomic and type-safety gaps**
- Method calls through the interface require manual vtable/data handling and casting.
- `interface{}` is only for map values, not a general “any” type.
- No way to declare “function that takes any type implementing interface X” in a type-safe way at the Tlang level.

---

## What Works Today (if parser is fixed)

- **Single-line interface** (e.g. `interface Shape { Area() float; Perimeter() float; }`) may parse.
- **Struct “methods”** in the form `#StructName_MethodName(receiver *StructName, ...) ReturnType` are discovered and used for satisfaction.
- **Vtables and constructors** are generated for satisfying (struct, interface) pairs.
- **Manual polymorphism**: call `NewCircle_Shape(&circle)`, then use `shape->vtable->Area(shape->data)` in generated C (or from Tlang code that compiles to such C).

So the **backend (codegen)** is largely there; the **frontend (parsing and type model)** is what limits usefulness.

---

## Recommendations

### Option A – Make interfaces useful (recommended if you keep them)
1. **Fix the parser**: In `parse_interface_def`, inside the `while !matches!(self.current_token, Token::RightBrace)` loop, skip `Token::Newline` (and optionally `Token::Semicolon`) before parsing the next method or embedded interface. That will allow multi-line interface definitions.
2. **Add satisfaction errors**: When a struct is **used** as an interface type (e.g. via a constructor call `NewX_Interface(...)`), or in a dedicated “implements”/usage check pass, verify that the struct satisfies the interface; otherwise emit a **compile error** with a clear message (e.g. “Struct X does not satisfy interface Y: missing method M”).
3. **Document the pattern**: In `docs/interfaces.md`, state clearly that today polymorphism is **manual**: you must call `NewStruct_Interface(&value)` and use the generated C vtable/data pattern, and that satisfaction is checked only for vtable generation (and optionally in the new pass above).

### Option B – Treat as experimental
- If you do not want to invest in the above:
  - **Document** that interfaces are experimental and that multi-line definitions are currently broken.
  - **Avoid** relying on them in critical paths or examples until the parser and (optionally) satisfaction checks are fixed.

### Option C – Simplify or remove
- If the goal is to keep the language minimal and you do not need Go-style interfaces:
  - You could **deprecate** interface definitions and keep only `interface{}` for map values.
  - Or **simplify** to “duck typing” or “structural typing” later without the current vtable/constructor machinery.

---

## Conclusion

- **Design and codegen**: Interface definitions, embedding, vtables, and constructors are implemented and could support a manual, C-style polymorphic pattern.
- **Usability**: A **parser bug** (no newline skipping in interface body) makes normal multi-line interface definitions fail, so the feature is **not practically usable** as-is.
- **Usefulness**: With the parser fixed and optional satisfaction checking, interfaces become **useful** for documentation, contract clarity, and manual polymorphism. Without those, they are **not very useful** and can be misleading (look like Go interfaces but behave differently and break on normal formatting).

**Suggested next step:** Fix the interface parser (skip newlines/semicolons in the interface body), then add a simple satisfaction check and document the current manual usage pattern. That would make interface definitions clearly useful in the current state.
