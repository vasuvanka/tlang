# bytes - Byte Operations Library

The `bytes` library provides byte manipulation functions.

## Functions

**`bytes.Contains(data, length, subslice, subLength)`** - Check if bytes contain subslice

- `data`: Byte data (string)
- `length`: Length of data
- `subslice`: Subslice to find (string)
- `subLength`: Length of subslice
- Returns: 1 if found, 0 otherwise

**Example:**
```tl
@data string = "Hello";
@found int = bytes.Contains(data, 5, "ell", 3);  // 1
```

**`bytes.Index(data, length, subslice, subLength)`** - Find index of subslice

- `data`: Byte data (string)
- `length`: Length of data
- `subslice`: Subslice to find (string)
- `subLength`: Length of subslice
- Returns: Index of first occurrence, or -1 if not found

**Example:**
```tl
@data string = "Hello";
@index int = bytes.Index(data, 5, "ell", 3);  // 1
```

**`bytes.Equal(a, aLen, b, bLen)`** - Compare two byte slices

- `a`, `b`: Byte data (strings)
- `aLen`, `bLen`: Lengths of data
- Returns: 1 if equal, 0 otherwise

**Example:**
```tl
@a string = "Hello";
@b string = "Hello";
@equal int = bytes.Equal(a, 5, b, 5);  // 1
```

## Notes

- Byte operations work on string data
- Length parameters are required for proper bounds checking
- Functions are similar to strings library but work at byte level

## See Also

- [strings Library](strings.md) - String operations
- [Language Reference](../language-reference.md)
