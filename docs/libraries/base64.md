# encoding/base64 - Base64 Encoding Library

The `encoding/base64` library provides base64 encoding and decoding functionality for strings and byte arrays.

## Functions

### String Encoding/Decoding

**`base64.Encode(data)`** - Encode string to base64

- `data`: String to encode
- Returns: Base64-encoded string

**Example:**
```tl
@text string = "Hello, Tlang!";
@encoded string = base64.Encode(text);
// Returns: "SGVsbG8sIFRsYW5nIQ=="
```

**`base64.Decode(encoded)`** - Decode base64 string

- `encoded`: Base64-encoded string
- Returns: Decoded string

**Example:**
```tl
@encoded string = "SGVsbG8sIFRsYW5nIQ==";
@decoded string = base64.Decode(encoded);
// Returns: "Hello, Tlang!"
```

### Byte Array Encoding/Decoding

**`base64.EncodeBytes(data)`** - Encode byte array to base64

- `data`: Byte array as pipe-separated string (e.g., "72|101|108|108|111")
- Returns: Base64-encoded string

**Example:**
```tl
@bytes string = "72|101|108|108|111";  // "Hello" as bytes
@encoded string = base64.EncodeBytes(bytes);
// Returns: "SGVsbG8="
```

**`base64.DecodeBytes(encoded)`** - Decode base64 to byte array

- `encoded`: Base64-encoded string
- Returns: Byte array as pipe-separated string

**Example:**
```tl
@encoded string = "SGVsbG8=";
@bytes string = base64.DecodeBytes(encoded);
// Returns: "72|101|108|108|111"
```

## Common Patterns

### Encode and Decode String

```tl
@text string = "Hello, World!";
@encoded string = base64.Encode(text);
@decoded string = base64.Decode(encoded);
fmt.Printf("Original: %s\n", text);
fmt.Printf("Encoded: %s\n", encoded);
fmt.Printf("Decoded: %s\n", decoded);
```

### Round-Trip Verification

```tl
@original string = "Test data";
@encoded string = base64.Encode(original);
@decoded string = base64.Decode(encoded);
@match int = (original == decoded);
okavela match == 1 {
    fmt.Printf("Round-trip successful!\n");
}
```

### Encode Binary Data

```tl
// Represent bytes as pipe-separated string
@bytes string = "65|66|67|68";  // "ABCD" as bytes
@encoded string = base64.EncodeBytes(bytes);
fmt.Printf("Encoded: %s\n", encoded);
```

### Decode to Bytes

```tl
@encoded string = "QUJDRA==";  // "ABCD" encoded
@bytes string = base64.DecodeBytes(encoded);
fmt.Printf("Bytes: %s\n", bytes);
// Process individual bytes if needed
```

## Base64 Format

Base64 encoding uses:
- **Characters**: A-Z, a-z, 0-9, +, /
- **Padding**: `=` characters for padding
- **Output**: Always multiple of 4 characters

**Encoding Rules:**
- 3 bytes → 4 base64 characters
- If input length is not multiple of 3, padding is added
- 1 byte → 2 base64 chars + 2 padding (`==`)
- 2 bytes → 3 base64 chars + 1 padding (`=`)

## Notes

- Maximum 4KB for encoded strings
- Maximum 3KB for decoded strings
- Byte arrays are represented as pipe-separated strings
- Padding is automatically handled
- Invalid base64 characters are ignored during decoding

## Use Cases

- **Data Transmission**: Encode binary data for text-based protocols
- **API Encoding**: Encode data for URL-safe transmission
- **Embedding**: Embed binary data in JSON/XML
- **Storage**: Store binary data in text format

## Examples

### Encode User Data

```tl
@username string = "user123";
@password string = "secret";
@credentials string = fmt.Sprintf("%s:%s", username, password);
@encoded string = base64.Encode(credentials);
fmt.Printf("Encoded credentials: %s\n", encoded);
```

### Decode API Response

```tl
@apiResponse string = "SGVsbG8gV29ybGQ=";
@decoded string = base64.Decode(apiResponse);
fmt.Printf("Response: %s\n", decoded);
```

## See Also

- [encoding/hex Library](hex.md) - Hexadecimal encoding
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
