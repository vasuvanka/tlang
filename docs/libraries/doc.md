# doc - Documentation Generation Library

The `doc` library provides documentation generation from code comments, similar to Go's `godoc` tool.

## Functions

### Extracting Comments

**`doc.ExtractComments(source)`** - Extract comments from source code

- `source`: Source code string
- Returns: Extracted comments as string
- Extracts both single-line (`//`) and multi-line (`/* */`) comments

**Example:**
```tl
@source string = io.ReadFile("myfile.tl");
@comments string = doc.ExtractComments(source);
fmt.Printf("Comments:\n%s\n", comments);
```

### Formatting

**`doc.Format(text)`** - Format documentation text

- `text`: Documentation text
- Returns: Formatted text
- Basic formatting: preserves newlines, trims extra spaces

**Example:**
```tl
@raw_text string = "  Line 1  \n  Line 2  ";
@formatted string = doc.Format(raw_text);
```

### Generating Documentation

**`doc.Generate(filename)`** - Generate documentation from source file

- `filename`: Path to source file
- Returns: Generated documentation as string
- Extracts comments and formats them with file header

**Example:**
```tl
@docs string = doc.Generate("examples/hello.tl");
fmt.Printf("%s\n", docs);
```

**`doc.Write(filename, content)`** - Write documentation to file

- `filename`: Output file path
- `content`: Documentation content
- Returns: Number of bytes written

**Example:**
```tl
@docs string = doc.Generate("myfile.tl");
@written int = doc.Write("myfile.md", docs);
fmt.Printf("Wrote %d bytes\n", written);
```

### Parsing Function Documentation

**`doc.ParseFunctionDocs(source, func_name)`** - Parse function documentation

- `source`: Source code string
- `func_name`: Function name (without # prefix)
- Returns: Documentation string for the function
- Extracts comments preceding the function definition

**Example:**
```tl
@source string = io.ReadFile("myfile.tl");
@func_docs string = doc.ParseFunctionDocs(source, "add");
fmt.Printf("Function docs:\n%s\n", func_docs);
```

## Comment Formats

### Single-Line Comments

```tl
// This is a single-line comment
#myFunction() {
    // This comment will be extracted
}
```

### Multi-Line Comments

```tl
/*
 * This is a multi-line comment
 * that spans multiple lines
 * and will be extracted as documentation
 */
#myFunction() {
    // Function body
}
```

## Common Patterns

### Generate Documentation for File

```tl
@docs string = doc.Generate("src/mymodule.tl");
doc.Write("docs/mymodule.md", docs);
```

### Extract All Comments

```tl
@source string = io.ReadFile("myfile.tl");
@comments string = doc.ExtractComments(source);
fmt.Printf("All comments:\n%s\n", comments);
```

### Document Specific Function

```tl
@source string = io.ReadFile("myfile.tl");
@func_docs string = doc.ParseFunctionDocs(source, "calculateSum");
fmt.Printf("calculateSum documentation:\n%s\n", func_docs);
```

### Build Documentation Site

```tl
#generateDocs() {
    @files string[] = io.ReadDir("src");
    // Process each file and generate docs
    // Write to docs/ directory
}
```

## Documentation Format

The generated documentation includes:

1. **Header**: File name and generation info
2. **Comments**: All extracted comments from the source
3. **Formatting**: Basic text formatting applied

Example output:
```
# Documentation

Generated from: examples/hello.tl

This is a comment from the source file.
Another comment line.
```

## Notes

- Comments are extracted from source code
- Function documentation looks for comments preceding function definitions
- Maximum 8KB for extracted comments
- Maximum 16KB for generated documentation
- Works with both `//` and `/* */` comment styles

## See Also

- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
- [Best Practices](../best-practices.md) - Documentation best practices
