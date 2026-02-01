# Borrow Checker and Ownership System

Tlang implements a Rust-style borrow checker for compile-time memory safety without garbage collection.

## Overview

The borrow checker enforces these rules at compile time:

1. **Each value has exactly one owner** - When a variable is assigned to another, ownership transfers (moves)
2. **When the owner goes out of scope, the value is dropped** - No garbage collection needed
3. **Values can be borrowed** - Either multiple immutable borrows OR one mutable borrow
4. **References cannot outlive their referent** - No dangling pointers

## Syntax

### Mutable Variables

By default, variables are immutable. Use `@!` to declare mutable variables:

```tl
// Immutable variable (default)
@x int = 10;
// x = 20;  // ERROR: cannot assign to immutable variable

// Mutable variable
@!y int = 10;
y = 20;  // OK
```

### Borrowing

Use `&` for immutable borrow and `&mut` for mutable borrow:

```tl
@data string = "hello";

// Immutable borrow - multiple allowed
@ref1 *string = &data;
@ref2 *string = &data;  // OK: multiple immutable borrows

// Mutable borrow - only one allowed
@!buffer string = "world";
@!Ref *string = &mut buffer;
// @!Ref2 *string = &mut buffer;  // ERROR: already mutably borrowed
```

### Dereferencing

Use `*` to dereference a reference:

```tl
@value int = 42;
@ref *int = &value;
@copy int = *ref;  // Dereference to get value
```

### Explicit Move

Use `<-` for explicit ownership transfer:

```tl
@original string = "hello";
@moved string = <- original;
// fmt.Printf("%s", original);  // ERROR: use after move
```

Use `<-` for move/ownership transfer; the `jarugu` keyword was replaced by `<-`.

## Ownership Rules

### Move Semantics

When a non-Copy type is assigned, ownership is transferred:

```tl
@s1 string = "hello";
@s2 string = s1;  // s1 is moved to s2
// fmt.Printf("%s", s1);  // ERROR: s1 has been moved
fmt.Printf("%s\n", s2);  // OK: s2 owns the string
```

### Copy Types

Primitive types (`int`, `float`, `bool`) are Copy types and are not moved with `<-`:

```tl
@x int = 42;
@y int = x;  // x is copied, not moved
fmt.Printf("x=%d, y=%d\n", x, y);  // Both still valid
```

### Borrowing Rules

1. **Multiple immutable borrows are allowed:**

```tl
@data int = 42;
@ref1 *int = &data;
@ref2 *int = &data;
@ref3 *int = &data;  // All OK
```

2. **Only one mutable borrow at a time:**

```tl
@!data int = 42;
@ref1 *int = &mut data;
// @ref2 *int = &mut data;  // ERROR: already mutably borrowed
```

3. **Cannot mix mutable and immutable borrows:**

```tl
@!data int = 42;
@immut *int = &data;
// @!_ref *int = &mut data;  // ERROR: already borrowed immutably
```

### Lifetime and Scope

References cannot outlive the data they refer to:

```tl
#dangling() *int {
    @local int = 42;
    mallinchu &local;  // ERROR: local will be dropped
}

#valid() int {
    @outer int = 42;
    {
        @inner *int = &outer;  // OK: inner scope, outer still alive
        @copy int = *inner;
    }  // inner reference dropped here
    mallinchu outer;  // OK: outer still valid
}
```

## Error Messages

The borrow checker produces clear, helpful error messages:

### Use After Move

```
error[E0382]: borrow of moved value: `data`
  --> line 5
  |
  | value moved to `other` at line 3
  | value used here after move
```

### Double Mutable Borrow

```
error[E0499]: cannot borrow `data` as mutable more than once at a time
  --> line 8
  |
  | first mutable borrow: `ref1`
  | second mutable borrow: `ref2`
```

### Mutable Borrow While Immutable Exists

```
error[E0502]: cannot borrow `data` as mutable because it is also borrowed as immutable
  --> line 6
  |
  | immutable borrow(s) by: ref1, ref2
```

### Dangling Reference

```
error[E0597]: `local` does not live long enough
  --> line 10
  |
  | `local` dropped here while still borrowed by `ref`
```

## Best Practices

### 1. Prefer Immutable by Default

```tl
// Good: immutable unless mutation needed
@config Config = loadConfig();

// Only use @!when needed
@!counter int = 0;
```

### 2. Borrow Instead of Move When Possible

```tl
// Instead of moving:
#processData(data Data) {
    // data is moved into function
}

// Prefer borrowing:
#processData(data *Data) {
    // data is borrowed, caller keeps ownership
}
```

### 3. Limit Mutable Borrow Scope

```tl
@!buffer string = "";
{
    @ref *string = &mut buffer;
    // Use ref...
}  // ref dropped here
// buffer can be borrowed again
```

### 4. Use Explicit Move for Clarity

```tl
// When intentionally transferring ownership:
@channel Channel = createChannel();
spawn(<- channel);  // Ownership transfer with <-
```

## Integration with Build System

The borrow checker runs automatically during `tlang build`:

```bash
$ tlang build
Building project: myapp
Linting...
Checking ownership...  # Borrow checker runs here
Compiling...
Build complete: target/myapp
```

Borrow check errors will halt the build:

```bash
$ tlang build
Building project: myapp
Linting...
Checking ownership...

✗ Borrow check failed with 1 error(s):
myapp.tl:
error[E0382]: borrow of moved value: `data`
  --> line 15
  |
  | value moved to `other` at line 12
  | value used here after move
```

## Comparison with Other Languages

| Feature | Tlang | Rust | Go | C |
|---------|-------|------|-----|---|
| Ownership | ✅ Compile-time | ✅ Compile-time | ❌ GC | ❌ Manual |
| Borrow Checking | ✅ Compile-time | ✅ Compile-time | ❌ | ❌ |
| Memory Safety | ✅ Guaranteed | ✅ Guaranteed | ✅ GC | ❌ Manual |
| Zero-cost | ✅ No runtime | ✅ No runtime | ❌ GC overhead | ✅ No overhead |

## See Also

- [Type System](type-system.md)
- [Language Reference](language-reference.md)
- [Best Practices](best-practices.md)
