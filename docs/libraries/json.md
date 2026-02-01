# json - JSON Library

The `json` library provides JSON encoding and decoding. The API has been simplified to use only `json.Marshal` and `json.Unmarshal` methods, with automatic handling of structs, arrays, and maps through compiler-generated functions.

## Functions

**`json.Marshal(type, value)`** - Encode value to JSON string

- `type`: Type name ("string", "int", "float", "bool")
- `value`: Value to encode (string representation)
- Returns: JSON string

**Example:**
```tl
@json string = json.Marshal("string", "Hello");
// Returns: "\"Hello\""

@json2 string = json.Marshal("int", "42");
// Returns: "42"
```

**`json.Unmarshal(json, type)`** - Decode JSON string to value (Enhanced)

- `json`: JSON string
- `type`: Expected type ("string", "int", "float", "bool")
- Returns: Decoded value as string

**Example:**
```tl
@value string = json.Unmarshal("\"Hello\"", "string");
// Returns: "Hello"

@num string = json.Unmarshal("42", "int");
// Returns: "42"
```

**Note:** The JSON library supports Go-style syntax:
- **`json.Marshal(value)`** - Automatic struct marshaling (Go-style) ⭐
  - Automatically detects struct type and calls internal `json_marshal_<structname>`
  - Works with both direct structs and pointers
  - Example: `json.Marshal(person)` or `json.Marshal(personPtr)`
- **`json.Marshal(type, value)`** - For basic types (legacy)
- **`json.Unmarshal(json, type)`** - For basic types
- **`json_unmarshal_<structname>(json)`** - Automatic struct unmarshaling (compiler-generated) ⭐

**Internal Helpers (used by compiler-generated code):**
- Internal helpers (`json_UnmarshalString`, `json_UnmarshalInt`, `json_UnmarshalArray`, `json_UnmarshalMap`, etc.) are used automatically by compiler-generated struct unmarshal functions

**Validation Functions:** ⭐ **NEW**

- **`json.Validate(json)`** - Validate JSON syntax
  - Returns: `NULL` if valid, error message string if invalid
  - Checks: bracket matching, string termination, valid JSON structure
  - Includes position information in error messages

- **`json.ValidateSchema(json, schema)`** - Validate JSON against schema
  - `json`: JSON string to validate
  - `schema`: Schema string in format `"field1:type1,field2:type2,..."`
  - Types: `string`, `int`, `float`, `bool`, `array`, `object`
  - Returns: `NULL` if valid, error message string if invalid
  - Checks: required fields, field types, structure

- **`json_validate_<structname>(json)`** - Validate JSON against struct schema (automatic) ⭐ **NEW**
  - Automatically generated for each struct with tags
  - Uses struct tags to build schema automatically
  - Returns: `NULL` if valid, error message string if invalid

**Example:**
```tl
// Validate JSON syntax
@err error = json.Validate("{\"name\": \"John\"}");
okavela err != sunyam {
    fmt.Printf("Invalid JSON: %s\n", err);
}

// Validate against schema
@schema string = "name:string,age:int";
@err2 error = json.ValidateSchema("{\"name\": \"John\", \"age\": 30}", schema);
okavela err2 != sunyam {
    fmt.Printf("Schema validation failed: %s\n", err2);
}

// Define struct with tags
nirmanam Person {
    Name string `json:"name" validate:"required"`;
    Age int `json:"age" validate:"required"`;
}

// Automatic validation using struct tags
@err3 error = json_validate_person("{\"name\": \"John\", \"age\": 30}");
okavela err3 != sunyam {
    fmt.Printf("Validation failed: %s\n", err3);
}
```

**Example:**
```tl
// Basic types - use json.Unmarshal
@str string = json.Unmarshal("\"Hello\\nWorld\"", "string");
@num string = json.Unmarshal("42", "int");
@pi string = json.Unmarshal("3.14159", "float");
@flag string = json.Unmarshal("true", "bool");

// Structs - use compiler-generated function
nirmanam Person {
    name string;
    age int;
}
@json string = "{\"name\": \"John\", \"age\": 30}";
@person *Person = json_unmarshal_person(json);  // Automatic!

// Arrays and maps in structs are handled automatically
nirmanam Data {
    items []int;
    scores jatha[string]int;
}
@data *Data = json_unmarshal_data(json_data);  // Arrays and maps parsed automatically!
```

## Supported Types

- `string` - JSON strings
- `int` - JSON numbers (integers)
- `float` - JSON numbers (floats)
- `bool` - JSON booleans

## Automatic Serialization

**Automatic Struct Serialization** - The compiler automatically generates JSON marshal functions for each struct!

When you define a struct, the compiler automatically creates an internal `json_marshal_<structname>()` function that is called by `json.Marshal()`.

**Example:**
```tl
nirmanam Person {
    name string;
    age int;
    email string;
}

#prarambham() {
    @person Person = Person{name: "Alice", age: 30, email: "alice@example.com"};
    
    // Go-style syntax - automatic struct detection!
    @json string = json.Marshal(person);
    fmt.Printf("JSON: %s\n", json);
    // Output: {"name":"Alice","age":30,"email":"alice@example.com"}
    
    // Also works with pointers
    @personPtr *Person = Person{};
    personPtr.name = "Bob";
    @json2 string = json.Marshal(personPtr);
}
```

**Features:**
- ✅ All struct fields automatically serialized
- ✅ Nested structs fully supported
- ✅ Arrays and slices in structs automatically handled
- ✅ Proper JSON escaping for strings
- ✅ Null handling for optional fields

**Automatic Struct Deserialization** - The compiler automatically generates JSON unmarshal functions for each struct! ⭐

When you define a struct, the compiler automatically creates a `json_unmarshal_<structname>()` function that deserializes JSON objects into struct instances.

**Example:**
```tl
nirmanam Person {
    name string;
    age int;
    email string;
}

#prarambham() {
    @json string = "{\"name\": \"Alice\", \"age\": 30, \"email\": \"alice@example.com\"}";
    
    // Automatic deserialization - no manual field handling needed!
    @person *Person = json_unmarshal_person(json);
    okavela person != sunyam {
        fmt.Printf("Name: %s, Age: %d\n", person->name, person->age);
    }
}
```

**Features:**
- ✅ All struct fields automatically deserialized
- ✅ Nested structs fully supported
- ✅ Arrays and slices in structs automatically handled
- ✅ Missing fields handled gracefully (default to zero values)
- ✅ Type conversion (string to int, float, bool)

## Extended Functions

**`json.MarshalSlice(slice, elem_type)`** - Encode slice/array to JSON array

- `slice`: Slice pointer (Slice*)
- `elem_type`: Element type string ("int", "string", "float", "bool")
- Returns: JSON array string

**`json.MarshalSliceEnhanced(slice, elem_type)`** - Enhanced version with float and bool support

**Example:**
```tl
@numbers []int = {1, 2, 3, 4, 5};
@jsonArray string = json.MarshalSliceEnhanced(numbers, "int");
// Returns: "[1, 2, 3, 4, 5]"
```

**`json.MarshalStruct(json_fields)`** - Manual struct encoding (legacy, use automatic serialization instead)

**`json.MarshalMap(map)`** - Automatic map encoding ⭐

- `map`: Map pointer (Map*)
- Returns: JSON object string with all key-value pairs automatically serialized

**Example:**
```tl
@scores jatha[string]int = map_create(0, 0);
map_set(scores, &"Alice", &95);
map_set(scores, &"Bob", &87);

@json string = json.MarshalMap(scores);
// Returns: {"Alice":95,"Bob":87}
```

**Features:**
- ✅ Automatically serializes all map entries
- ✅ Supports string, int, float keys
- ✅ Supports int, float, string, bool values
- ✅ Proper JSON formatting with escaping

**`json.UnmarshalMap(json, key_type, value_type)`** - Automatic map decoding ⭐

- `json`: JSON object string
- `key_type`: Key type code (0=string, 1=int, 2=float)
- `value_type`: Value type code (0=int, 1=float, 2=string, 3=bool)
- Returns: Map pointer (Map*) with all key-value pairs parsed

**Example:**
```tl
@json string = "{\"Alice\": 95, \"Bob\": 87, \"Charlie\": 92}";
// key_type: 0=string, value_type: 0=int
@scores jatha[string]int = json.UnmarshalMap(json, 0, 0);

// Access values
@aliceKey string = "Alice";
@aliceScore int = *(int*)map_get(scores, &aliceKey);

// Iterate over map
malli key, value := varasa scores {
    fmt.Printf("%s: %d\n", key, value);
}
```

**Features:**
- ✅ Automatically parses all JSON object entries
- ✅ Supports string, int, float keys
- ✅ Supports int, float, string, bool values
- ✅ Handles empty objects gracefully
- ✅ Proper memory management

## Limitations

### Marshal (Encoding) ✅ **FULLY SUPPORTED**
- ✅ Basic types fully supported
- ✅ Slices/arrays fully supported
- ✅ Structs automatically serialized
- ✅ Maps automatically serialized

### Unmarshal (Decoding) ✅ **FULLY SUPPORTED**
- ✅ Basic types (string, int, float, bool)
- ✅ Arrays/slices - **NEW** ⭐
- ✅ Structs - **NEW** ⭐ Automatic unmarshaling with compiler-generated functions
- ✅ Nested structures - Fully supported
- ✅ Maps - Fully supported with `jatha` type

## Example Usage

```tl
#prarambham() {
    // Encode
    @json string = json.Marshal("string", "Hello World");
    fmt.Printf("JSON: %s\n", json);
    
    // Decode
    @value string = json.Unmarshal(json, "string");
    fmt.Printf("Value: %s\n", value);
}
```

## See Also

- [Language Reference](../language-reference.md)
