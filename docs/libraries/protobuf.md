# protobuf - Protocol Buffers Library

The `protobuf` library provides fast binary serialization as an alternative to JSON. Protocol Buffers offer:

- **Smaller size**: Typically 3-10x smaller than JSON
- **Faster encoding/decoding**: Binary format is faster to parse
- **Type safety**: Strong typing with field numbers
- **Backward compatibility**: Can add new fields without breaking old code

## Overview

Protocol Buffers use a binary wire format that is:
- **Compact**: Variable-length encoding for integers
- **Efficient**: No text parsing overhead
- **Cross-platform**: Works across different languages and systems

## When to Use Protobuf vs JSON

**Use Protobuf when:**
- Performance is critical (high-throughput systems)
- Network bandwidth is limited
- You need binary format (not human-readable)
- You're communicating between services

**Use JSON when:**
- Human readability is important
- Debugging and inspection is needed
- Working with web APIs (REST)
- Simpler integration with JavaScript/web

## Basic Types

### Encoding Functions

**`protobuf_encode_int32(buf, value)`** - Encode 32-bit signed integer
**`protobuf_encode_int64(buf, value)`** - Encode 64-bit signed integer
**`protobuf_encode_uint32(buf, value)`** - Encode 32-bit unsigned integer
**`protobuf_encode_bool(buf, value)`** - Encode boolean (0 or 1)
**`protobuf_encode_float(buf, value)`** - Encode 32-bit float
**`protobuf_encode_double(buf, value)`** - Encode 64-bit double
**`protobuf_encode_string(buf, str)`** - Encode string (length-delimited)

### Decoding Functions

**`protobuf_decode_int32(buf, &value)`** - Decode 32-bit signed integer
**`protobuf_decode_int64(buf, &value)`** - Decode 64-bit signed integer
**`protobuf_decode_uint32(buf, &value)`** - Decode 32-bit unsigned integer
**`protobuf_decode_bool(buf, &value)`** - Decode boolean
**`protobuf_decode_float(buf, &value)`** - Decode 32-bit float
**`protobuf_decode_double(buf, &value)`** - Decode 64-bit double
**`protobuf_decode_string(buf)`** - Decode string (returns allocated char*, caller must free)

## Buffer Management

### Creating and Managing Buffers

```tl
// Create a new buffer for encoding
ProtobufBuffer* buf = protobuf_buffer_new(256);

// Encode values
protobuf_encode_int32(buf, 42);
protobuf_encode_string(buf, "Hello");

// Get encoded data
char* data = protobuf_Marshal(buf);
size_t size = protobuf_Size(buf);

// Free buffer
protobuf_buffer_free(buf);
free(data);  // Free marshaled data
```

### Decoding from Binary Data

```tl
// Create buffer from binary data
ProtobufBuffer* buf = protobuf_Unmarshal(data, size);

// Decode values
int32_t value;
protobuf_decode_int32(buf, &value);

char* str = protobuf_decode_string(buf);

// Free buffer and decoded strings
free(str);
protobuf_buffer_free(buf);
```

## Field Encoding

Protocol Buffers use field numbers and wire types. Each field is encoded as:
- **Tag**: `(field_number << 3) | wire_type`
- **Value**: The actual encoded value

### Wire Types

- `PROTOBUF_WIRE_VARINT` (0) - Variable-length integers, booleans
- `PROTOBUF_WIRE_FIXED64` (1) - 64-bit fixed (double)
- `PROTOBUF_WIRE_LENGTH_DELIMITED` (2) - Strings, bytes, nested messages
- `PROTOBUF_WIRE_FIXED32` (5) - 32-bit fixed (float)

### Encoding Fields

```tl
ProtobufBuffer* buf = protobuf_buffer_new(256);

// Encode field 1 as int32
protobuf_encode_tag(buf, 1, PROTOBUF_WIRE_VARINT);
protobuf_encode_int32(buf, 42);

// Encode field 2 as string
protobuf_encode_tag(buf, 2, PROTOBUF_WIRE_LENGTH_DELIMITED);
protobuf_encode_string(buf, "Hello");

// Encode field 3 as double
protobuf_encode_tag(buf, 3, PROTOBUF_WIRE_FIXED64);
protobuf_encode_double(buf, 3.14159);
```

### Decoding Fields

```tl
ProtobufBuffer* buf = protobuf_Unmarshal(data, size);

int field_num, wire_type;
while (protobuf_decode_tag(buf, &field_num, &wire_type)) {
    okavela field_num == 1 {
        int32_t value;
        protobuf_decode_int32(buf, &value);
        fmt.Printf("Field 1: %d\n", value);
    } lekapothe okavela field_num == 2 {
        char* str = protobuf_decode_string(buf);
        fmt.Printf("Field 2: %s\n", str);
        free(str);
    } lekapothe okavela field_num == 3 {
        double value;
        protobuf_decode_double(buf, &value);
        fmt.Printf("Field 3: %f\n", value);
    }
}
```

## Example: Using Automatic Struct Serialization

```tl
dhimpu "fmt" as fmt;
dhimpu "protobuf" as protobuf;

// Define struct
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}

#prarambham() {
    // Create struct instance
    @person Person = Person{
        name: "Alice",
        age: 30,
        email: "alice@example.com",
        active: 1
    };
    
    // Automatic marshaling - compiler generates protobuf_marshal_person()
    size_t size;
    char* data = protobuf_marshal_person(&person, &size);
    
    okavela data != sunyam {
        fmt.Printf("Encoded %zu bytes\n", size);
        
        // Send over network, save to file, etc.
        // ...
        
        // Automatic unmarshaling - compiler generates protobuf_unmarshal_person()
        Person* decoded = protobuf_unmarshal_person(data, size);
        okavela decoded != sunyam {
            fmt.Printf("Name: %s, Age: %d\n", decoded->name, decoded->age);
            
            // Free decoded strings
            free(decoded->name);
            free(decoded->email);
            free(decoded);
        }
        
        free(data);
    }
}
```

**Note:** For low-level manual encoding/decoding, see the protobuf library C API documentation. The automatic struct serialization is the recommended approach for most use cases.

## Performance Comparison

Protocol Buffers are typically:
- **3-10x smaller** than JSON
- **2-5x faster** to encode/decode
- **Lower CPU usage** (no text parsing)

**Example:**
- JSON: `{"id":12345,"name":"Alice","active":true}` = 37 bytes
- Protobuf: ~15-20 bytes (varies by field numbers)

## Automatic Struct Serialization ✅ **NEW**

**Automatic Struct Marshaling** - The compiler automatically generates Protobuf marshal functions for each struct!

When you define a struct, the compiler automatically creates a `protobuf_marshal_<structname>()` function that serializes all fields.

**Example:**
```tl
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}

#prarambham() {
    @person Person = Person{name: "Alice", age: 30, email: "alice@example.com", active: 1};
    
    // Automatic serialization - no manual field handling needed!
    size_t size;
    char* data = protobuf_marshal_person(&person, &size);
    okavela data != sunyam {
        fmt.Printf("Encoded %zu bytes\n", size);
        free(data);
    }
}
```

**Features:**
- ✅ All struct fields automatically serialized
- ✅ Nested structs fully supported
- ✅ Proper field numbering (field 1, 2, 3, ...)
- ✅ Correct wire types for each field type

**Automatic Struct Deserialization** - The compiler automatically generates Protobuf unmarshal functions for each struct! ⭐

When you define a struct, the compiler automatically creates a `protobuf_unmarshal_<structname>()` function that deserializes binary data into struct instances.

**Example:**
```tl
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}

#prarambham() {
    // Assume we have binary protobuf data
    char* data = ...;  // From network, file, etc.
    size_t len = ...;
    
    // Automatic deserialization - no manual field handling needed!
    Person* person = protobuf_unmarshal_person(data, len);
    okavela person != sunyam {
        fmt.Printf("Name: %s, Age: %d\n", person->name, person->age);
        
        // Free decoded strings
        free(person->name);
        free(person->email);
        free(person);
    }
}
```

**Features:**
- ✅ All struct fields automatically deserialized
- ✅ Nested structs fully supported
- ✅ Unknown fields are skipped (backward compatibility)
- ✅ Missing fields default to zero values

## Limitations

### Current Implementation

- ✅ Basic types (int32, int64, uint32, bool, float, double, string)
- ✅ Varint encoding for integers
- ✅ Zigzag encoding for signed integers
- ✅ Length-delimited strings
- ✅ Field tag encoding/decoding
- ✅ Buffer management
- ✅ **Automatic struct marshaling/unmarshaling** ⭐ **NEW**
- ✅ **Nested structs support** ⭐ **NEW**
- ⚠️ **Arrays/repeated fields** (future)
- ⚠️ **Maps** (future)

### Field Numbering

The compiler automatically assigns field numbers starting from 1:
- Field 1: First struct field
- Field 2: Second struct field
- Field 3: Third struct field
- etc.

**Note:** For production use, you may want to use struct tags to specify custom field numbers (future enhancement).

### Future Enhancements

- Automatic struct marshaling/unmarshaling (compiler-generated)
- Support for repeated fields (arrays)
- Nested message support
- Map support
- Enum support
- Oneof fields

## Best Practices

### 1. Field Numbering

- Use field numbers 1-15 for frequently used fields (1 byte tag)
- Use field numbers 16-2047 for less frequent fields (2 byte tag)
- Reserve field numbers 19000-19999 for internal use
- Never reuse field numbers (for backward compatibility)

### 2. Memory Management

- Always free buffers with `protobuf_buffer_free()`
- Free decoded strings returned by `protobuf_decode_string()`
- Free marshaled data returned by `protobuf_Marshal()`

### 3. Error Handling

- Check return values of encode/decode functions
- Verify buffer capacity before encoding large data
- Handle NULL returns from decode functions

## See Also

- [JSON Library](json.md) - JSON encoding/decoding
- [Language Reference](../language-reference.md) - Complete language syntax
- [Examples](../examples.md) - Code examples
