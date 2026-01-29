# encoding/hex - Hexadecimal Encoding Library

The `encoding/hex` library provides hexadecimal encoding and decoding functions.

## Functions

### Encoding

**`hex.Encode(data)`** - Encode string to hexadecimal

- `data`: String to encode
- Returns: Hexadecimal string (lowercase)

**Example:**
```tl
@encoded string = hex.Encode("Hello");
fmt.Printf("Encoded: %s\n", encoded);  // "48656c6c6f"
```

**`hex.EncodeBytes(data, length)`** - Encode byte data to hexadecimal

- `data`: Byte data (string)
- `length`: Length of data (or -1 to use string length)
- Returns: Hexadecimal string (lowercase)

**Example:**
```tl
@data string = "ABC";
@encoded string = hex.EncodeBytes(data, 3);
fmt.Printf("Encoded: %s\n", encoded);  // "414243"
```

### Decoding

**`hex.Decode(encoded)`** - Decode hexadecimal string

- `encoded`: Hexadecimal string to decode
- Returns: Decoded string

**Example:**
```tl
@encoded string = "48656c6c6f";
@decoded string = hex.Decode(encoded);
fmt.Printf("Decoded: %s\n", decoded);  // "Hello"
```

**`hex.DecodeBytes(encoded)`** - Decode hexadecimal to bytes

- `encoded`: Hexadecimal string to decode
- Returns: Decoded byte data (string)

**Example:**
```tl
@encoded string = "414243";
@decoded string = hex.DecodeBytes(encoded);
fmt.Printf("Decoded: %s\n", decoded);  // "ABC"
```

## Common Patterns

### Round-Trip Encoding

```tl
@original string = "Hello, World!";
@encoded string = hex.Encode(original);
@decoded string = hex.Decode(encoded);
@match int = (original == decoded);  // Should be 1
```

### Binary Data Representation

```tl
@data string = "\\x48\\x65\\x6C\\x6C\\x6F";  // "Hello"
@hexStr string = hex.Encode(data);
fmt.Printf("Hex: %s\n", hexStr);
```

### Debugging Data

```tl
@data string = "Some binary data";
@hex string = hex.Encode(data);
fmt.Printf("Data in hex: %s\n", hex);
```

## Notes

- All hex output is lowercase
- Invalid hex strings return empty string on decode
- Hex strings must have even length (pairs of hex digits)
- Maximum input size: 4KB for encoding, 2KB hex input for decoding

## See Also

- [crypto/hash Library](crypto.md) - Cryptographic hashing (also produces hex output)
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
