# JSON Serialization & Deserialization Guide

This guide explains how JSON serialization and deserialization works in Tlang, including the automatic compiler-generated functions.

## Overview

Tlang provides **automatic JSON serialization** for structs with **Go-style syntax**! When you define a struct, the compiler automatically generates functions internally:

1. **`json.Marshal(value)`** - Go-style syntax! Automatically detects struct type ⭐
2. **`json_unmarshal_<structname>(json)`** - Deserializes JSON string to struct

## How It Works

### Step 1: Define a Struct

```tl
nirmanam Person {
    name string;
    age int;
    email string;
    active int;  // bool
}
```

### Step 2: Compiler Auto-Generates Functions

When the compiler sees this struct definition, it automatically generates C code internally. You use the Go-style `json.Marshal()` syntax, and the compiler calls the generated function:

#### Internal: `json_marshal_person(Person* s)`

**Generated C Code:**
```c
char* json_marshal_person(Person* s) {
    static char buffer[16384];
    strcpy(buffer, "{");
    int first = 1;
    
    // Field: name (string)
    if (!first) strcat(buffer, ", ");
    first = 0;
    strcat(buffer, "\"name\":");
    if (s->name) {
        strcat(buffer, json_escape(s->name));
    } else {
        strcat(buffer, "null");
    }
    
    // Field: age (int)
    if (!first) strcat(buffer, ", ");
    first = 0;
    strcat(buffer, "\"age\":");
    char val_str[64];
    snprintf(val_str, sizeof(val_str), "%d", s->age);
    strcat(buffer, val_str);
    
    // Field: email (string)
    // ... similar code ...
    
    // Field: active (bool)
    // ... similar code ...
    
    strcat(buffer, "}");
    return buffer;
}
```

#### `json_unmarshal_person(const char* json)`

**Generated C Code:**
```c
Person* json_unmarshal_person(const char* json) {
    Person* s = (Person*)malloc(sizeof(Person));
    if (!s) return NULL;
    
    // Initialize all fields to zero
    memset(s, 0, sizeof(*s));
    
    // Unmarshal field: name
    const char* name_json = json_GetObjectValue(json, "name");
    if (name_json) {
        s->name = json_UnmarshalString(name_json);
        free((void*)name_json);
    }
    
    // Unmarshal field: age
    const char* age_json = json_GetObjectValue(json, "age");
    if (age_json) {
        s->age = json_UnmarshalInt(age_json);
        free((void*)age_json);
    }
    
    // ... similar for other fields ...
    
    return s;
}
```

## Usage Examples

### Serialization (Struct → JSON)

```tl
nirmanam Person {
    name string;
    age int;
    email string;
}

#prarambham() {
    // Create a struct instance
    @person Person = Person{
        name: "Alice",
        age: 30,
        email: "alice@example.com"
    };
    
    // Go-style syntax - automatically detects struct type!
    @json string = json.Marshal(person);
    fmt.Printf("JSON: %s\n", json);
    // Output: {"name":"Alice","age":30,"email":"alice@example.com"}
    
    // Also works with pointers
    @personPtr Person* = kotha Person;
    personPtr.name = "Bob";
    @json2 string = json.Marshal(personPtr);  // Works with pointers too!
}
```

### Deserialization (JSON → Struct)

```tl
#prarambham() {
    @json string = "{\"name\": \"Bob\", \"age\": 25, \"email\": \"bob@example.com\"}";
    
    // Automatic deserialization - just call the generated function!
    @person Person* = json_unmarshal_person(json);
    okavela person != sunyam {
        fmt.Printf("Name: %s\n", person.name);
        fmt.Printf("Age: %d\n", person.age);
        fmt.Printf("Email: %s\n", person.email);
        
        // Don't forget to free!
        free(person.name);
        free(person.email);
        free(person);
    }
}
```

## Supported Field Types

### Basic Types

| Tlang Type | JSON Type | Serialization | Deserialization |
|------------|-----------|---------------|-----------------|
| `int` | Number | `snprintf("%d")` | `json_UnmarshalInt()` |
| `float` | Number | `snprintf("%.6g")` | `json_UnmarshalFloat()` |
| `string` | String | `json_escape()` | `json_UnmarshalString()` |
| `bool` (int) | Boolean | `"true"/"false"` | `json_UnmarshalBool()` |

### Complex Types

| Tlang Type | JSON Type | How It Works |
|------------|-----------|--------------|
| `Struct` | Object | Recursive call to internal `json_marshal_<nestedstruct>()` |
| `[]Type` (Slice) | Array | `json_MarshalSliceEnhanced()` |
| `[N]Type` (Array) | Array | Loop through elements, serialize each |
| `jatha[K]V` (Map) | Object | `json.MarshalMap()` |

## Nested Structs

Nested structs are automatically handled recursively:

```tl
nirmanam Address {
    street string;
    city string;
    zip int;
}

nirmanam Person {
    name string;
    address Address;  // Nested struct
}

#prarambham() {
    @person Person = Person{
        name: "Alice",
        address: Address{
            street: "123 Main St",
            city: "New York",
            zip: 10001
        }
    };
    
    @json string = json.Marshal(person);
    // Output: {"name":"Alice","address":{"street":"123 Main St","city":"New York","zip":10001}}
    
    // Deserialize
    @jsonInput string = "{\"name\": \"Bob\", \"address\": {\"street\": \"456 Oak Ave\", \"city\": \"Boston\", \"zip\": 02101}}";
    @person2 Person* = json_unmarshal_person(jsonInput);
    okavela person2 != sunyam {
        fmt.Printf("City: %s\n", person2.address.city);  // Nested access!
        free(person2.name);
        free(person2.address.street);
        free(person2.address.city);
        free(person2);
    }
}
```

## Arrays and Slices

Arrays and slices in structs are automatically serialized:

```tl
nirmanam Data {
    numbers []int;
    tags [5]string;
}

#prarambham() {
    @data Data = Data{
        numbers: {1, 2, 3},
        tags: {"go", "rust", "tlang", "", ""}
    };
    
    @json string = json.Marshal(data);
    // Output: {"numbers":[1,2,3],"tags":["go","rust","tlang","",""]}
}
```

## Missing Fields Handling

When deserializing, missing fields default to zero values:

```tl
@json string = "{\"name\": \"Alice\"}";  // Missing age and email
@person Person* = json_unmarshal_person(json);
// person.age = 0 (default)
// person.email = NULL (default)
```

## Memory Management

⚠️ **Important**: When you unmarshal a struct, you must free all string fields and the struct itself:

```tl
@person Person* = json_unmarshal_person(json);
okavela person != sunyam {
    // Use person...
    
    // Free string fields
    free(person.name);
    free(person.email);
    
    // Free the struct
    free(person);
}
```

## Complete Example

```tl
dhimpu "fmt" as fmt;
dhimpu "json" as json;

nirmanam Person {
    name string;
    age int;
    email string;
}

#prarambham() {
    // 1. Serialize (Struct → JSON) - Go-style syntax!
    @person Person = Person{
        name: "Alice",
        age: 30,
        email: "alice@example.com"
    };
    @json string = json.Marshal(person);  // Clean Go-style syntax!
    fmt.Printf("Serialized: %s\n", json);
    
    // Also works with pointers
    @personPtr Person* = kotha Person;
    personPtr.name = "Bob";
    @json2 string = json.Marshal(personPtr);  // Works with pointers too!
    
    // 2. Deserialize (JSON → Struct)
    @person2 Person* = json_unmarshal_person(json);
    okavela person2 != sunyam {
        fmt.Printf("Deserialized:\n");
        fmt.Printf("  Name: %s\n", person2.name);
        fmt.Printf("  Age: %d\n", person2.age);
        fmt.Printf("  Email: %s\n", person2.email);
        
        // 3. Clean up
        free(person2.name);
        free(person2.email);
        free(person2);
    }
}
```

## How the Compiler Does It

1. **Parser** (`src/parser.rs`): Parses struct definitions
2. **Code Generator** (`src/codegen.rs`): 
   - `generate_struct_json_marshal()` - Generates marshal function
   - `generate_struct_json_unmarshal()` - Generates unmarshal function
3. **Runtime Library** (`src/libs/json.rs`): Provides helper functions:
   - `json_GetObjectValue()` - Extract field value from JSON
   - `json_UnmarshalString()` - Parse JSON string
   - `json_UnmarshalInt()` - Parse JSON number
   - `json_escape()` - Escape strings for JSON
   - `json_MarshalSliceEnhanced()` - Serialize arrays/slices

## Key Functions Generated

For each struct `Person`, the compiler generates:

| Function | Purpose | Returns |
|----------|---------|---------|
| `json_marshal_person(Person* s)` | Internal: Serialize struct to JSON (called by `json.Marshal`) | `char*` (JSON string) |
| `json_unmarshal_person(const char* json)` | Deserialize JSON to struct | `Person*` (allocated struct) |
| `json_validate_person(const char* json)` | Validate JSON against struct schema | `char*` (error message or NULL) |

## Best Practices

1. **Always check for NULL** after unmarshaling:
   ```tl
   @person Person* = json_unmarshal_person(json);
   okavela person == sunyam {
       fmt.Printf("Failed to unmarshal\n");
       mallinchu;
   }
   ```

2. **Always free allocated memory**:
   ```tl
   free(person.name);
   free(person.email);
   free(person);
   ```

3. **Use Go-style syntax** - Clean and automatic:
   ```tl
   // ✅ Good - Go-style syntax
   @json string = json.Marshal(person);
   
   // ✅ Also good - Direct function call
   @json string = json.Marshal(person);
   
   // ❌ Bad - Don't manually serialize
   @json string = fmt.Sprintf("{\"name\":\"%s\",\"age\":%d}", person.name, person.age);
   ```

4. **Handle missing fields gracefully**:
   ```tl
   okavela person.email != sunyam {
       fmt.Printf("Email: %s\n", person.email);
   } lekapothe {
       fmt.Printf("Email: (not provided)\n");
   }
   ```

## See Also

- [JSON Library Documentation](libraries/json.md) - Complete API reference
- [JSON Examples](../examples/json_*.tl) - More examples
- [JSON Serialization Demo](../examples/real-world-examples/json_serialization_demo.tl) - Comprehensive demo
