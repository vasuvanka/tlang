# bufio - Buffered I/O Library

The `bufio` library provides buffered reading and writing for efficient file I/O operations.

## Functions

### Reading

**`bufio.NewReader(source)`** - Create buffered reader

- `source`: File path to read from
- Returns: Reader handle (integer), or -1 on error

**Example:**
```tl
@reader int = bufio.NewReader("file.txt");
okavela reader >= 0 {
    // Use reader
}
```

**`bufio.ReadLine(reader)`** - Read line from reader

- `reader`: Reader handle
- Returns: Line string (without newline), or empty string on EOF

**Example:**
```tl
@reader int = bufio.NewReader("file.txt");
@line string = bufio.ReadLine(reader);
fmt.Printf("Line: %s\n", line);
```

**`bufio.ReadBytes(reader, delim)`** - Read until delimiter

- `reader`: Reader handle
- `delim`: Delimiter character code (integer)
- Returns: String read until delimiter

**Example:**
```tl
@reader int = bufio.NewReader("file.txt");
@data string = bufio.ReadBytes(reader, 10);  // Read until newline (ASCII 10)
```

### Writing

**`bufio.NewWriter(dest)`** - Create buffered writer

- `dest`: File path to write to
- Returns: Writer handle (integer), or -1 on error

**Example:**
```tl
@writer int = bufio.NewWriter("output.txt");
okavela writer >= 0 {
    // Use writer
}
```

**`bufio.Write(writer, data)`** - Write data to writer

- `writer`: Writer handle
- `data`: String to write
- Returns: Number of bytes written

**Example:**
```tl
@writer int = bufio.NewWriter("output.txt");
@written int = bufio.Write(writer, "Hello, World!\n");
```

**`bufio.Flush(writer)`** - Flush buffer

- `writer`: Writer handle
- Writes buffered data to file

**Example:**
```tl
bufio.Write(writer, "Data");
bufio.Flush(writer);  // Ensure data is written
```

**`bufio.Close(handle)`** - Close reader or writer

- `handle`: Reader or writer handle
- Closes file and releases resources

**Example:**
```tl
bufio.Close(reader);
bufio.Close(writer);
```

## Common Patterns

### Read File Line by Line

```tl
@reader int = bufio.NewReader("file.txt");
okavela reader >= 0 {
    @line string = "";
    malli {
        line = bufio.ReadLine(reader);
        okavela strings.Index(line, "") == 0 {
            agu;  // EOF
        }
        // Process line
        fmt.Printf("Line: %s\n", line);
    }
    bufio.Close(reader);
}
```

### Write Multiple Lines

```tl
@writer int = bufio.NewWriter("output.txt");
okavela writer >= 0 {
    bufio.Write(writer, "Line 1\n");
    bufio.Write(writer, "Line 2\n");
    bufio.Write(writer, "Line 3\n");
    bufio.Flush(writer);
    bufio.Close(writer);
}
```

### Read Until Delimiter

```tl
@reader int = bufio.NewReader("file.txt");
@data string = bufio.ReadBytes(reader, 44);  // Read until comma (ASCII 44)
```

## Notes

- Reader handles are integers (0-15)
- Maximum 16 open readers/writers at once
- Always call `Close()` when done
- `Flush()` ensures data is written to disk
- Empty string from `ReadLine()` indicates EOF

## Benefits

- **Efficiency**: Buffered I/O reduces system calls
- **Performance**: Faster for large files
- **Convenience**: Line-by-line reading

## See Also

- [io Library](io.md) - Basic file I/O
- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
