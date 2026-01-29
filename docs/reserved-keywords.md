# Tlang Reserved Keywords

Complete list of all reserved keywords in Tlang that cannot be used as identifiers.

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
| `dhimpu` | import | Package | ⭐⭐ Common |
| `nirmanam` | struct | Type | ⭐⭐ Common |
| `jatha` | map | Type | ⭐⭐ Common |
| `agu` | break | Control Flow | ⭐ Common |
| `konasagu` | continue | Control Flow | ⭐ Common |
| `interface` | interface | Type | ⭐ Common |
| `jarugu` | move | Ownership | ⚡ Advanced |
| `varasa` | range | Loop | ⚡ Advanced |
| `kotha` | new | Memory | ⚡ Advanced |

**Legend:** ⭐⭐⭐ Essential (learn first) | ⭐⭐ Common (learn soon) | ⭐ Occasional | ⚡ Advanced

## Essential Keywords (Start Here)

These 7 keywords cover 90% of Tlang code. Master these first:

### 1. Variable Declaration: `@`
```tl
@x int = 10;              // Immutable variable
@name string = "Tlang";   // Type inference: @name = "Tlang" also works
```

### 2. Function Declaration: `#`
```tl
#add(a int, b int) int {
    mallinchu a + b;
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
mallinchu value;    // Return with value
mallinchu;          // Return void
```

### 7. Mutable Variable: `@!`
```tl
@!counter int = 0;
counter = counter + 1;  // Only @! variables can be reassigned
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
| `dhimpu` | import | Import package | `dhimpu "fmt" as fmt;` | ⭐⭐ |
| `as` | as | Import alias | `dhimpu "fmt" as f;` | ⭐ |

### Type Definition Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| `nirmanam` | struct | Structure type definition | `nirmanam Person { ... }` | ⭐⭐ |
| `jatha` | map | Map type | `jatha[string]int` | ⭐⭐ |
| `interface` | interface | Interface type definition | `interface Writer { ... }` | ⭐ |
| `interface{}` | any/unknown | Map value type only (unknown type, like Go's interface{}) | `jatha[string]interface{}` | ⭐ |

### Type Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `int` | Integer type | `@x int = 10;` | ⭐⭐⭐ |
| `float` | Floating point type | `@y float = 3.14;` | ⭐⭐⭐ |
| `string` | String type | `@name string = "Tlang";` | ⭐⭐⭐ |
| `bool` | Boolean type | `@flag bool = true;` | ⭐⭐⭐ |
| `void` | No return type | `#print() void { ... }` | ⭐⭐ |
| `error` | Error type | `#read() (string, error) { ... }` | ⭐⭐ |

### Memory and Ownership Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `!` | Mutable modifier | `@!x int = 10;` | ⭐⭐ |
| `jarugu` | Explicit ownership transfer | `@y = jarugu x;` | ⚡ |

### Error Handling Keywords

| Keyword | English | Description | Example | Priority |
|---------|---------|-------------|---------|----------|
| (error type) | error | Use `errors.New("msg")` and `okavela err != sunyam { ... }` | ⭐ |
| `sunyam` | nil | Nil/null value | `@x *int = sunyam;` | ⭐ |

### Loop Keywords

| Keyword | Description | Example | Priority |
|---------|-------------|---------|----------|
| `varasa` | Range-based iteration | `malli key := varasa map { ... }` | ⚡ |
| `kotha` | Memory allocation | `@ptr Type* = kotha Type;` | ⚡ |

**Example:**
```tl
nirmanam Person {
    name string;
    age int;
}

#prarambham() {
    @person Person* = kotha Person;  // Allocates memory for Person struct
    okavela person == sunyam {
        fmt.Printf("Memory allocation failed\n");
        mallinchu;
    }
    person->name = "Alice";
    person->age = 30;
    // ... use person ...
    free(person);  // Don't forget to free!
}
```

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
| `nil` | Alternative to `sunyam` (if supported) | `@x *int = nil;` | ⭐ |
| `varasa` | Used in varasa-based loops | `malli key := varasa map { ... }` | ⚡ |

**Note:** `prarambham`, `nil`, and `varasa` are identifiers but have special semantic meaning.

## Common Patterns

### Pattern 1: Basic Program Structure
```tl
dhimpu "fmt" as fmt;

#prarambham() {
    @name string = "Tlang";
    fmt.Printf("Hello, %s!\n", name);
}
```

### Pattern 2: Conditional Logic
```tl
okavela score >= 90 {
    fmt.Printf("Grade: A\n");
} lekapothe okavela score >= 80 {
    fmt.Printf("Grade: B\n");
} lekapothe {
    fmt.Printf("Grade: C or below\n");
}
```

### Pattern 3: Loops
```tl
// Counted loop
malli (@!i int = 0; i < 10; i = i + 1) {
    fmt.Printf("%d\n", i);
}

// Range over map
@scores jatha[string]int = jatha[string]int{"Alice": 95, "Bob": 87};
malli name := varasa scores {
    fmt.Printf("%s: %d\n", name, scores[name]);
}
```

### Pattern 4: Function with Error Handling
```tl
#readFile(path string) (string, error) {
    // ... file reading logic
    okavela error != sunyam {
        mallinchu sunyam, error;
    }
    mallinchu content, sunyam;
}
```

### Pattern 5: Struct Definition
```tl
nirmanam Person {
    name string;
    age int;
}

#prarambham() {
    @p Person = Person{name: "Alice", age: 30};
    fmt.Printf("%s is %d years old\n", p.name, p.age);
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
| `&` | Ampersand | Immutable borrow | ⚡ |
| `&mut` | Ampersand mut | Mutable borrow | ⚡ |
| `?` | Question mark | Error propagation | ⚡ |
| `(` `)` | Parentheses | Grouping, function calls | ⭐⭐⭐ |
| `{` `}` | Braces | Blocks, struct literals | ⭐⭐⭐ |
| `[` `]` | Brackets | Arrays, slices, indexing | ⭐⭐⭐ |
| `,` | Comma | Separator | ⭐⭐⭐ |
| `;` | Semicolon | Statement terminator | ⭐⭐⭐ |
| `.` | Dot | Member access | ⭐⭐⭐ |
| `:` | Colon | Type annotation, map literals | ⭐⭐⭐ |
| `` ` `` | Backtick | Struct tags | ⚡ |

## Summary by Category

### Control Flow (6 keywords)
- `okavela`, `lekapothe`, `malli`, `mallinchu`, `agu`, `konasagu`

**Note:** `lekapothe` is used for both else and else-if branches.

### Declaration (5 keywords/symbols)
- `@`, `@!`, `#`, `#prarambham`

### Package/Import (2 keywords)
- `dhimpu`, `as`

### Type Definition (3 keywords)
- `nirmanam`, `jatha`, `interface`

### Type Names (6 keywords)
- `int`, `float`, `string`, `bool`, `void`, `error`

### Memory/Ownership (3 keywords)
- `!`, `jarugu`, `kotha`

### Error Handling
- `sunyam` (nil); use `errors.New()` and `okavela err != sunyam` for errors

### Boolean Literals (2)
- `true`, `false`

### Special Identifiers (3)
- `prarambham`, `nil`, `varasa`

## Total Count

- **Reserved Keywords:** 29
- **Reserved Symbols:** 20+
- **Special Identifiers:** 3
- **Boolean Literals:** 2

## Rules for Identifiers

1. **Cannot use reserved keywords** as variable, function, or type names
2. **Cannot use reserved symbols** as identifiers
3. **Case-sensitive:** `Okavela` is different from `okavela` (but don't use either)
4. **Valid identifier characters:** Letters, numbers, underscore (`_`)
5. **Cannot start with number:** `@1var` is invalid, `@var1` is valid

## Examples of Invalid Identifiers

```tl
// ❌ Cannot use keywords as identifiers
@okavela int = 10;        // ERROR: 'okavela' is a keyword
#malli() { ... }          // ERROR: 'malli' is a keyword
nirmanam nirmanam { ... } // ERROR: 'nirmanam' is a keyword

// ❌ Cannot use type names as identifiers
@int int = 10;            // ERROR: 'int' is a type name
@string string = "hi";    // ERROR: 'string' is a type name

// ❌ Cannot use boolean literals as identifiers
@true bool = false;       // ERROR: 'true' is a literal
```

## Examples of Valid Identifiers

```tl
// ✅ Valid identifiers
@myVariable int = 10;
@my_function string = "hello";
@var123 int = 42;
@_temp int = 0;

// ✅ Using keywords in strings (allowed)
@message string = "okavela condition";
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

## Common Mistakes to Avoid

1. **Forgetting `@!` for reassignable variables**
   ```tl
   @x int = 10;
   x = 20;  // ❌ ERROR: Cannot assign to immutable variable
   
   @!x int = 10;
   x = 20;  // ✅ OK
   ```

2. **Using `ledha` instead of `lekapothe`**
   ```tl
   okavela x > 0 {
   } ledha {  // ❌ ERROR: 'ledha' is not a keyword
   
   okavela x > 0 {
   } lekapothe {  // ✅ OK
   ```

3. **Confusing `@` and `@!`**
   - `@` = immutable (default, most common)
   - `@!` = mutable (only when needed)

4. **Missing semicolons in some contexts**
   ```tl
   @x int = 10  // ❌ Missing semicolon
   @x int = 10; // ✅ OK
   ```

## Learning Path

### Week 1: Essential Keywords
- `@`, `@!`, `#`, `#prarambham()`, `okavela`, `lekapothe`, `malli`, `mallinchu`
- Types: `int`, `string`, `float`, `bool`

### Week 2: Common Patterns
- `@!`, `dhimpu`, `nirmanam`, `jatha`
- Error handling: `errors.New()`, `okavela err != sunyam`, `sunyam`

### Week 3: Advanced Features
- `jarugu`, `varasa`, `interface`, `kotha`
- Ownership and borrowing: `&`, `&mut`

## See Also

- [Keywords and Operators](keywords-operators.md) - Detailed usage of each keyword
- [Language Reference](language-reference.md) - Complete syntax reference
- [Best Practices](best-practices.md) - Naming conventions
- [Getting Started](getting-started.md) - Quick start guide
- [Tutorial](tutorial.md) - Step-by-step learning
