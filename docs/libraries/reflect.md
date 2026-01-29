# reflect - Reflection Library

The `reflect` library provides runtime type information and value introspection, allowing programs to inspect types and values at runtime.

## Functions

### Type Information

**`reflect.TypeOf(type_name)`** - Get type information

- `type_name`: Type name as string ("int", "float", "string", "bool", "error")
- Returns: Type information string in format "name|kind|size"
  - `name`: Type name
  - `kind`: Type kind (0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer)
  - `size`: Size in bytes

**Example:**
```tl
@typeInfo string = reflect.TypeOf("int");
// Returns: "int|0|4" (name|kind|size)
fmt.Printf("Type info: %s\n", typeInfo);
```

**`reflect.TypeOfInt(value)`** - Get type info for int value

- `value`: Integer value
- Returns: Type information string

**Example:**
```tl
@info string = reflect.TypeOfInt(42);
// Returns: "int|0|4"
```

**`reflect.TypeOfFloat(value)`** - Get type info for float value

- `value`: Float value
- Returns: Type information string

**Example:**
```tl
@info string = reflect.TypeOfFloat(3.14);
// Returns: "float|1|8"
```

**`reflect.TypeOfString(value)`** - Get type info for string value

- `value`: String value
- Returns: Type information string

**Example:**
```tl
@info string = reflect.TypeOfString("hello");
// Returns: "string|2|8"
```

### Value Information

**`reflect.ValueOfInt(value)`** - Get value information for int

- `value`: Integer value
- Returns: Value information string in format "type|value"

**Example:**
```tl
@valueInfo string = reflect.ValueOfInt(42);
// Returns: "int|42"
fmt.Printf("Value: %s\n", valueInfo);
```

**`reflect.ValueOfFloat(value)`** - Get value information for float

- `value`: Float value
- Returns: Value information string in format "type|value"

**Example:**
```tl
@valueInfo string = reflect.ValueOfFloat(3.14159);
// Returns: "float|3.141590"
```

**`reflect.ValueOfString(value)`** - Get value information for string

- `value`: String value
- Returns: Value information string in format "type|value"

**Example:**
```tl
@valueInfo string = reflect.ValueOfString("Hello");
// Returns: "string|Hello"
```

### Type Properties

**`reflect.Kind(type_name)`** - Get type kind

- `type_name`: Type name as string
- Returns: Type kind integer
  - `0` = int
  - `1` = float
  - `2` = string
  - `3` = bool
  - `4` = error
  - `5` = pointer
  - `-1` = unknown

**Example:**
```tl
@kind int = reflect.Kind("int");
// Returns: 0
```

**`reflect.Size(type_name)`** - Get type size in bytes

- `type_name`: Type name as string
- Returns: Size in bytes

**Example:**
```tl
@size int = reflect.Size("int");
// Returns: 4 (on most systems)
```

**`reflect.Name(type_name)`** - Get type name

- `type_name`: Type name as string
- Returns: Type name string

**Example:**
```tl
@name string = reflect.Name("int");
// Returns: "int"
```

### Type Checks

**`reflect.IsInt(type_name)`** - Check if type is int

- `type_name`: Type name as string
- Returns: 1 if int, 0 otherwise

**Example:**
```tl
@isInt int = reflect.IsInt("int");
// Returns: 1
```

**`reflect.IsFloat(type_name)`** - Check if type is float

- `type_name`: Type name as string
- Returns: 1 if float, 0 otherwise

**Example:**
```tl
@isFloat int = reflect.IsFloat("float");
// Returns: 1
```

**`reflect.IsString(type_name)`** - Check if type is string

- `type_name`: Type name as string
- Returns: 1 if string, 0 otherwise

**Example:**
```tl
@isString int = reflect.IsString("string");
// Returns: 1
```

## Common Patterns

### Inspect Variable Type

```tl
@x int = 42;
@typeInfo string = reflect.TypeOfInt(x);
fmt.Printf("x type: %s\n", typeInfo);
```

### Compare Types

```tl
@type1 string = reflect.TypeOf("int");
@type2 string = reflect.TypeOf("float");
@kind1 int = reflect.Kind("int");
@kind2 int = reflect.Kind("float");

okavela kind1 == kind2 {
    fmt.Printf("Same type kind\n");
} lekapothe {
    fmt.Printf("Different type kinds\n");
}
```

### Type-Safe Operations

```tl
#processValue(value string, typeName string) {
    @kind int = reflect.Kind(typeName);
    
    okavela kind == 0 {
        // Handle int
        fmt.Printf("Processing integer\n");
    } lekapothe okavela kind == 1 {
        // Handle float
        fmt.Printf("Processing float\n");
    } lekapothe okavela kind == 2 {
        // Handle string
        fmt.Printf("Processing string\n");
    }
}
```

### Value Inspection

```tl
@x int = 100;
@y float = 3.14;
@z string = "test";

@xInfo string = reflect.ValueOfInt(x);
@yInfo string = reflect.ValueOfFloat(y);
@zInfo string = reflect.ValueOfString(z);

fmt.Printf("x: %s\n", xInfo);
fmt.Printf("y: %s\n", yInfo);
fmt.Printf("z: %s\n", zInfo);
```

## Type Kinds

| Kind | Value | Type |
|------|-------|------|
| Int | 0 | `int` |
| Float | 1 | `float` |
| String | 2 | `string` |
| Bool | 3 | `bool` |
| Error | 4 | `error` |
| Pointer | 5 | `*type` |

## Notes

- Reflection requires runtime type information
- Type registry is initialized on first use
- Maximum 100 types in registry
- Type information format: "name|kind|size"
- Value information format: "type|value"
- Works with basic types (int, float, string, bool, error)
- Pointer types are supported but limited

## Limitations

- No support for struct types (nirmanam) yet
- No support for map types (jatha) yet
- No support for interface types yet
- Limited to basic type introspection
- Cannot modify values through reflection

## See Also

- [Type System](../type-system.md) - Type system documentation
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
