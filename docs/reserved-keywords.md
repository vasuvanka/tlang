# Tlang Reserved Keywords

Complete list of reserved keywords and symbols, **aligned with the lexer/parser implementation**. Use this as the canonical reference for keyword usage and examples.

> **Quick Navigation:** [Essential Keywords](#essential-keywords) | [All Keywords](#all-keywords-by-category) | [Quick Reference](#quick-reference-table) | [Common Patterns](#common-patterns)

## Quick Reference Table

| Tlang | English | Category | Priority |
|-------|---------|----------|----------|
| `@` | var | Declaration | ⭐⭐⭐ Essential |
| `#` | func | Declaration | ⭐⭐⭐ Essential |
| `#prarambham()` | main | Declaration | ⭐⭐⭐ Essential |
| `okavela` | if | Control Flow | ⭐⭐⭐ Essential |
| `lekapothe` | else | Control Flow | ⭐⭐⭐ Essential |
| `malli` | for | Control Flow | ⭐⭐⭐ Essential |
| `mallinchu` | return | Control Flow | ⭐⭐⭐ Essential |
| `@!` | var (mutable) | Declaration | ⭐⭐ Common |
| `#dhimpu("path")` | import | Package | ⭐⭐ Common |
| `nirmanam` | struct | Type | ⭐⭐ Common |
| `jatha` | map | Type | ⭐⭐ Common |
| `agu` | break | Control Flow | ⭐ Common |
| `konasagu` | continue | Control Flow | ⭐ Common |
| `<-` | move | Ownership | ⚡ Advanced |
| `varasa` | for loop over map (key/value) | Loop | ⚡ Advanced |
| `Type{}` / `Type{ field: value }` | struct literal | Create/allocate | ⚡ Advanced |

**Legend:** ⭐⭐⭐ Essential (learn first) | ⭐⭐ Common (learn soon) | ⭐ Occasional | ⚡ Advanced

## Essential Keywords (Start Here)

These 7 keywords cover 90% of Tlang code. Master these first:

### 1. Variable Declaration: `@`
```tl
@x int = 10              // Immutable variable (semicolon optional)
@name string = "Tlang"   // Type inference: @name = "Tlang" also works
```

### 2. Function Declaration: `#`
```tl
#add(a int, b int) int {
    mallinchu a + b
}
```

### 3. Entry Point: `#prarambham()`
```tl
#prarambham() {
    // Your program starts here
}
```

### 4. Conditional: `okavela` / `lekapothe`
```tl
okavela x > 0 {
    // if branch
} lekapothe {
    // else branch
}

// else-if: use lekapothe okavela
okavela x > 10 {
    // ...
} lekapothe okavela x > 5 {
    // ...
} lekapothe {
    // ...
}
```

### 5. Loop: `malli`
```tl
// C-style for loop
malli (@!i int = 0; i < 10; i = i + 1) {
    // ...
}

// Infinite loop
malli {
    // ...
}

// Range loop
malli key := varasa map {
    // ...
}
```

### 6. Return: `mallinchu`
```tl
mallinchu value    // Return with value
mallinchu          // Return void
```

### 7. Mutable Variable: `@!`
```tl
@!counter int = 0
counter = counter + 1   // Only @! variables can be reassigned
```

## All Keywords by Category

### Declaration Keywords

| Keyword | Syntax | Description | Example | Priority |
|---------|--------|-------------|---------|----------|
| `@` | `@variableName` | Immutable variable declaration | `@x int = 10;` | ⭐⭐⭐ |
| `@!` | `@!variableName` | Mutable variable declaration | `@!counter int = 0;` | ⭐⭐ |
| `#` | `#functionName` | Function declaration | `#add(a int, b int) int { ... }` | ⭐⭐⭐ |
| `#prarambham` | `#prarambham()` | Entry point function (main) | `#prarambham() { ... }` | ⭐⭐⭐ |

**Key Concept:** Variables are **immutable by default**. Use `@!` only when you need to reassign.

### Control Flow Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| `okavela` | if | Conditional statement | `okavela condition { ... }` | ⭐⭐⭐ |
| `lekapothe` | else | Alternative branch (also else-if) | `okavela x > 0 { ... } lekapothe { ... }` | ⭐⭐⭐ |
| `malli` | for | Loop construct | `malli (init; condition; update) { ... }` | ⭐⭐⭐ |
| `mallinchu` | return | Return from function | `mallinchu value;` | ⭐⭐⭐ |
| `agu` | break | Exit loop | `agu;` | ⭐ |
| `konasagu` | continue | Skip to next iteration | `konasagu;` | ⭐ |

**Note:** `lekapothe` is used for both `else` and `else if` branches:
- `} lekapothe {` → else
- `} lekapothe okavela condition {` → else if

### Package and Import Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| `#dhimpu("path")` | import | Import package (use `@variable = #dhimpu("path")`) | `@fmt = #dhimpu("std/fmt")` then `fmt.Printf` | ⭐⭐ |

**Note:** Use **`@variable = #dhimpu("path")`** (e.g. `@fmt = #dhimpu("std/fmt")` then `fmt.*`). Standard library: `std/<package>`. Relative: `./utils`, etc. No explicit package or alias keyword.

### Type Definition Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| `nirmanam` | struct | Structure type definition | `nirmanam Person { ... }` | ⭐⭐ |
| `jatha` | map | Map type | `jatha[string]int`, `jatha[string]nirmanam{}` | ⭐⭐ |

For map values of any type, use **`nirmanam{}`** (only as map value): `jatha[string]nirmanam{}`.

### Type Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `int` | Integer type | `@x int = 10;` | ⭐⭐⭐ |
| `float` | Floating point type | `@y float = 3.14;` | ⭐⭐⭐ |
| `string` | String type | `@name string = "Tlang";` | ⭐⭐⭐ |
| `bool` | Boolean type | `@flag bool = true;` | ⭐⭐⭐ |
| `void` | No return type | `#print() void { ... }` or omit: `#print() { ... }` | ⭐⭐ |
| `error` | Error type | `#read() (string, error) { ... }` | ⭐⭐ |

### Memory and Ownership Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `!` | Mutable modifier | `@!x int = 10;` | ⭐⭐ |
| `<-` | Move / ownership transfer | `@y = <- x;` (replaces former `jarugu` keyword) | ⚡ |

**Move (`<-`):**
```tl
@original string = "hello"
@moved string = <- original
// original is no longer valid (ownership transferred)
```

### Error Handling Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| (error type) | error | Use `errors.New("msg")` and `okavela err != sunyam { ... }` | ⭐ |
| `sunyam` | nil / free | Nil value **or** free memory: `sunyam(ptr)` | `@x *int = sunyam`; `sunyam(ptr)` | ⭐ |

### Loop Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `varasa` | For loop over map (key/value) | `malli key := varasa map { ... }` or `malli key, value := varasa map { ... }` | ⚡ |

### Struct literals (create / allocate)

Use **`Type{}`** or **`Type{ field: value, ... }`** to create struct values. No separate allocation keyword.

- **Value (stack):** `@person Person = Person{ name: "hello", age: 12 }` or `@person Person = Person{}`
- **Pointer (heap):** `@person *Person = Person{ name: "hello", age: 12 }` or `@person *Person = Person{}` — compiler allocates and initializes.
- **Maps:** use `nirmanam(jatha[key]value)` for empty map, or `jatha[K]V{"k": v}` for literal with entries.

**Example (struct literal + sunyam to free):**
```tl
nirmanam Person {
    name string
    age int
}

#prarambham() {
    @person *Person = Person{ name: "Alice", age: 30 }
    okavela person == sunyam {
        fmt.Printf("Memory allocation failed\n")
        mallinchu
    }
    @other *Person = <- person   // move ownership
    sunyam(other)                // free: same keyword as nil value
}
```

**Note:** `sunyam` is used two ways: as the **nil value** (`@x = sunyam`, `okavela err != sunyam`) and as **free** (`sunyam(ptr)` to release memory).

### Boolean Literals

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `true` | Boolean true (1) | `@flag bool = true;` | ⭐⭐⭐ |
| `false` | Boolean false (0) | `@flag bool = false;` | ⭐⭐⭐ |

**Note:** `true` and `false` are treated as identifiers in the lexer but are reserved boolean literals.

### Special Identifiers

These are not strictly reserved keywords but have special meaning:

| Identifier | Description | Usage | Priority |
|------------|-------------|-------|----------|
| `prarambham` | Entry point function name | `#prarambham() { ... }` | ⭐⭐⭐ |
| `varasa` | For loop over map only (key/value) | `malli key := varasa map { ... }` or `malli key, value := varasa map { ... }` | ⚡ |

**Note:** `sunyam` is used two ways: (1) **nil value** — `@x *int = sunyam`, `okavela err != sunyam`; (2) **free** — `sunyam(ptr)` to release memory. `nil` is **not** a keyword. `prarambham` is the entry point; `varasa` is used only in for loops over a map (key, or key and value). **Removed:** samooham, thappu, jarugu (use `<-` instead of jarugu).

## Common Patterns

### Pattern 1: Basic Program Structure
```tl
@fmt = #dhimpu("std/fmt")  // use as fmt.Printf (variable = import name)

#prarambham() {
    @name string = "Tlang"
    fmt.Printf("Hello, %s!\n", name)
}
```
Semicolons are optional; newline can terminate statements.

### Pattern 2: Conditional Logic
```tl
okavela score >= 90 {
    fmt.Printf("Grade: A\n")
} lekapothe okavela score >= 80 {
    fmt.Printf("Grade: B\n")
} lekapothe {
    fmt.Printf("Grade: C or below\n")
}
```

### Pattern 3: Loops
```tl
// Counted loop
malli (@!i int = 0; i < 10; i = i + 1) {
    fmt.Printf("%d\n", i)
}

// For loop over map (key, or key and value)
@scores jatha[string]int = jatha[string]int{"Alice": 95, "Bob": 87}
malli name := varasa scores {
    fmt.Printf("%s: %d\n", name, scores[name])
}
malli name, score := varasa scores {
    fmt.Printf("%s: %d\n", name, score)
}
```

### Pattern 4: Function with Error Handling

**Option A – manual check:**
```tl
#readFile(path string) (string, error) {
    // ...
    okavela err != sunyam {
        mallinchu sunyam, err
    }
    mallinchu content, sunyam
}
```

**Option B – `?` ("try" shorthand):**

In Tlang, `?` acts as a **try shorthand**. If a function returns a tuple `(result, error)`, applying `?` will:

1. **Check** if `error` is not `sunyam`.
2. **If an error exists** — immediately `mallinchu` (return) that error to the caller.
3. **If no error exists** — unwrap the result (bind the value).

Single variable (bind only the value; propagate error):
```tl
#readFile(path string) (string, error) {
    @data string = readFile("config.txt")?
    mallinchu data, sunyam
}
```

Multiple variables (bind value and error; still propagate on non-sunyam):
```tl
@content, @err string, error = readFile(path)?
```

For single-variable form (`@data = f()?`) give an explicit type when the RHS is a call, e.g. `@data string = readFile("config.txt")?`. Use `err` (or similar) for the error variable; `error` is a reserved type name.

### Pattern 5: Struct Definition
```tl
nirmanam Person {
    name string
    age int
}

#prarambham() {
    @p Person = Person{name: "Alice", age: 30}
    fmt.Printf("%s is %d years old\n", p.name, p.age)
}
```

## Operators (Not Keywords, But Reserved Symbols)

These symbols are reserved and cannot be used as identifiers:

| Symbol | Name | Usage | Priority |
|--------|------|-------|----------|
| `+` | Plus | Arithmetic addition | ⭐⭐⭐ |
| `-` | Minus | Arithmetic subtraction, unary negation | ⭐⭐⭐ |
| `*` | Multiply | Arithmetic multiplication, pointer dereference | ⭐⭐⭐ |
| `/` | Divide | Arithmetic division | ⭐⭐⭐ |
| `%` | Modulo | Remainder operator | ⭐⭐ |
| `^` | Power | Exponentiation | ⭐ |
| `==` | Equal | Equality comparison | ⭐⭐⭐ |
| `!=` | Not equal | Inequality comparison | ⭐⭐⭐ |
| `<` | Less than | Comparison | ⭐⭐⭐ |
| `>` | Greater than | Comparison | ⭐⭐⭐ |
| `<=` | Less than or equal | Comparison | ⭐⭐⭐ |
| `>=` | Greater than or equal | Comparison | ⭐⭐⭐ |
| `=` | Assign | Assignment (for mutable variables) | ⭐⭐⭐ |
| `<-` | Move | Ownership transfer: `@y = <- x;` | ⚡ |
| `&` | Ampersand | Immutable borrow | ⚡ |
| `&mut` | Ampersand mut | Mutable borrow | ⚡ |
| `?` | Question mark | Try shorthand: check error ≠ sunyam → return error; else unwrap result | ⭐⭐ |
| `(` `)` | Parentheses | Grouping, function calls | ⭐⭐⭐ |
| `{` `}` | Braces | Blocks, struct literals | ⭐⭐⭐ |
| `[` `]` | Brackets | Arrays, slices, indexing | ⭐⭐⭐ |
| `,` | Comma | Separator | ⭐⭐⭐ |
| `;` | Semicolon | Statement terminator (optional; newline can terminate) | ⭐⭐⭐ |
| `.` | Dot | Member access | ⭐⭐⭐ |
| `:` | Colon | Type annotation, map literals | ⭐⭐⭐ |
| `` ` `` | Backtick | Struct tags | ⚡ |

## Summary by Category

### Control Flow (6 keywords)
- `okavela`, `lekapothe`, `malli`, `mallinchu`, `agu`, `konasagu`

**Note:** `lekapothe` is used for both else and else-if branches.

### Declaration (5 keywords/symbols)
- `@`, `@!`, `#`, `#prarambham`

### Package/Import (1 keyword)
- `#dhimpu` (import; use `@variable = #dhimpu("path")`, e.g. `@fmt = #dhimpu("std/fmt")`)

### Type Definition (3 keywords)
- `nirmanam`, `jatha`

### Type names (5 keywords; void = omit return type)
- `int`, `float`, `string`, `bool`, `error` — type names in lexer. No `void` keyword; omit return type for no value.

### Memory/Ownership
- `!`, `<-` (move; `jarugu` was replaced by `<-`)
- Struct: `Type{}`, `Type{ field: value }` (no separate keyword). Maps: `nirmanam(jatha[K]V)` for empty map.

### Error Handling
- `sunyam` — nil value **or** free: `sunyam(ptr)`; use `errors.New()` and `okavela err != sunyam` for errors
- `?` (try shorthand): for `(result, error)` — check error ≠ sunyam → mallinchu error; else unwrap result

### Boolean Literals (2)
- `true`, `false`

### Special identifiers (lexer: Identifier, parser/codegen: special use)
- `prarambham` — entry point: `#prarambham() { ... }`
- `varasa` — for loop over map only: `malli key := varasa map { ... }` or `malli key, value := varasa map { ... }`
- Use `sunyam` for nil; `nil` is not a keyword.

## Total count (matches lexer/parser)

- **Lexer keywords:** okavela, lekapothe, malli, mallinchu, agu, konasagu, nirmanam, jatha, sunyam; types: int, float, string, bool, error. Move: `<-` (replaced `jarugu`).
- **Declaration symbols:** `@`, `@!`, `#` (and `#prarambham`, `#dhimpu` as identifiers after `#`).
- **Special identifiers:** prarambham (entry), varasa (for loop over map only); true, false (boolean literals).
- **Removed:** samooham, thappu, jarugu (use `<-` instead of jarugu).

## Rules for Identifiers

1. **Cannot use reserved keywords** as variable, function, or type names
2. **Cannot use reserved symbols** as identifiers
3. **Case-sensitive:** `Okavela` is different from `okavela`; use the lowercase keyword `okavela` (not as an identifier)
4. **Valid identifier characters:** Letters, numbers, underscore (`_`)
5. **Cannot start with number:** `@1var` is invalid, `@var1` is valid

## Examples of Invalid Identifiers

```tl
// ❌ Cannot use keywords as identifiers
@okavela int = 10        // ERROR: 'okavela' is a keyword
#malli() { }             // ERROR: 'malli' is a keyword
nirmanam nirmanam { }    // ERROR: 'nirmanam' is a keyword

// ❌ Cannot use type names as identifiers
@int int = 10            // ERROR: 'int' is a type name
@string string = "hi"    // ERROR: 'string' is a type name

// ❌ Cannot use boolean literals as identifiers
@true bool = false       // ERROR: 'true' is a literal
```

## Examples of Valid Identifiers

```tl
// ✅ Valid identifiers
@myVariable int = 10
@my_function string = "hello"
@var123 int = 42
@_temp int = 0

// ✅ Using keywords in strings (allowed)
@message string = "okavela condition"
```

## Language Comparison

For developers coming from other languages:

| Concept | Go | Rust | Tlang |
|---------|----|----|-------|
| Variable | `var x int` | `let x: i32` | `@x int` |
| Mutable | `var x int` (always mutable) | `let mut x: i32` | `@!x int` |
| Function | `func add()` | `fn add()` | `#add()` |
| Main | `func main()` | `fn main()` | `#prarambham()` |
| If/Else | `if/else` | `if/else` | `okavela/lekapothe` |
| Loop | `for` | `for` or `loop` | `malli` |
| Return | `return` | `return` | `mallinchu` |
| Struct | `type S struct` | `struct S` | `nirmanam S` |
| Map | `map[K]V` | `HashMap<K, V>` | `jatha[K]V` |
| Import | `import` | `use` | `dhimpu` |
| Move | (N/A) | `std::move` / ownership | `<-` (e.g. `@y = <- x`) |
| Try/error | `if err != nil` | `?` operator | `?` (try shorthand) |

## Common Mistakes to Avoid

1. **Forgetting `@!` for reassignable variables**
   ```tl
   @x int = 10
   x = 20   // ❌ ERROR: Cannot assign to immutable variable

   @!x int = 10
   x = 20   // ✅ OK
   ```

2. **Using `ledha` instead of `lekapothe`**
   ```tl
   okavela x > 0 {
   } ledha {   // ❌ ERROR: 'ledha' is not a keyword

   okavela x > 0 {
   } lekapothe {   // ✅ OK
   ```

3. **Confusing `@` and `@!`**
   - `@` = immutable (default, most common)
   - `@!` = mutable (only when needed)

4. **Using manual error checks instead of `?` (try shorthand)** — `?` checks error ≠ sunyam, returns error, else unwraps:
   ```tl
   @content, @err string, error = readFile(path)
   okavela err != sunyam { mallinchu sunyam, err }   // verbose

   @content, @err string, error = readFile(path)?   // ✅ try shorthand: same effect
   ```

5. **Semicolons are optional** — newlines between statements act as terminators (Go-style). Use semicolons when putting multiple statements on one line: `@x int = 10; @y int = 20`

## Learning Path

### Week 1: Essential Keywords
- `@`, `@!`, `#`, `#prarambham()`, `okavela`, `lekapothe`, `malli`, `mallinchu`
- Types: `int`, `string`, `float`, `bool`

### Week 2: Common Patterns
- `@!`, `#dhimpu`, `nirmanam`, `jatha`
- Error handling: `errors.New()`, `okavela err != sunyam`, `sunyam`, and `?` (try shorthand: check error → return; else unwrap)

### Week 3: Advanced Features
- `<-` (move), `varasa`, struct literals `Type{}` / `Type{ field: value }`
- Ownership and borrowing: `&`, `&mut`

## See Also

- [Keywords and Operators](keywords-operators.md) - Detailed usage of each keyword
- [Language Reference](language-reference.md) - Complete syntax reference
- [Best Practices](best-practices.md) - Naming conventions
- [Getting Started](getting-started.md) - Quick start guide
- [Tutorial](tutorial.md) - Step-by-step learning
