# encoding/xml - XML Processing Library

The `encoding/xml` library provides XML encoding, decoding, and escaping functions.

## Functions

### Escaping

**`xml.Escape(text)`** - Escape XML special characters

- `text`: String to escape
- Returns: Escaped string

**Escaped Characters:**
- `<` → `&lt;`
- `>` → `&gt;`
- `&` → `&amp;`
- `"` → `&quot;`
- `'` → `&apos;`

**Example:**
```tl
@escaped string = xml.Escape("<tag>value</tag>");
// Returns: "&lt;tag&gt;value&lt;/tag&gt;"
```

**`xml.Unescape(text)`** - Unescape XML entities

- `text`: Escaped string
- Returns: Unescaped string

**Example:**
```tl
@unescaped string = xml.Unescape("&lt;tag&gt;value&lt;/tag&gt;");
// Returns: "<tag>value</tag>"
```

### Encoding/Decoding

**`xml.Marshal(type, name, value)`** - Encode value to XML

- `type`: Type name ("string", "int", "float")
- `name`: XML tag name
- `value`: Value to encode
- Returns: XML string

**Example:**
```tl
@xml string = xml.Marshal("string", "name", "John Doe");
// Returns: "<name>John Doe</name>"

@xml2 string = xml.Marshal("int", "age", "30");
// Returns: "<age>30</age>"
```

**`xml.Unmarshal(xml, tag)`** - Decode XML string

- `xml`: XML string
- `tag`: Tag name to extract
- Returns: Value from XML tag

**Example:**
```tl
@xml string = "<name>John Doe</name><age>30</age>";
@name string = xml.Unmarshal(xml, "name");
@age string = xml.Unmarshal(xml, "age");
// name: "John Doe", age: "30"
```

## Common Patterns

### Escape XML Content

```tl
@content string = "Price: $100 & tax";
@escaped string = xml.Escape(content);
// Use in XML: <price>Price: $100 &amp; tax</price>
```

### Build XML Document

```tl
@name string = xml.Marshal("string", "name", "John");
@age string = xml.Marshal("int", "age", "30");
@xml string = fmt.Sprintf("<person>%s%s</person>", name, age);
```

### Parse XML

```tl
@xml string = "<user><name>John</name><email>john@example.com</email></user>";
@name string = xml.Unmarshal(xml, "name");
@email string = xml.Unmarshal(xml, "email");
```

## XML Entities

| Character | Entity |
|-----------|--------|
| `<` | `&lt;` |
| `>` | `&gt;` |
| `&` | `&amp;` |
| `"` | `&quot;` |
| `'` | `&apos;` |

## Notes

- Currently supports basic types (string, int, float)
- Complex nested structures require manual parsing
- Escaping handles all standard XML entities
- Unescaping reverses all standard entities

## See Also

- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
