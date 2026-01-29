# io - File I/O Library

The `io` library provides file reading, writing, and file system operations.

## Functions

### ReadFile

**`io.ReadFile(filename)`** - Read entire file as string

- `filename`: Path to file
- Returns: File contents as string, or empty string on error

**Example:**
```tl
@content string = io.ReadFile("data.txt");
fmt.Printf("File content:\n%s\n", content);
```

### WriteFile

**`io.WriteFile(filename, data)`** - Write string to file

- `filename`: Path to file
- `data`: String to write
- Returns: Number of bytes written, or 0 on error

**Example:**
```tl
@data string = "Hello from Tlang!\nLine 2";
@written int = io.WriteFile("output.txt", data);
fmt.Printf("Wrote %d bytes\n", written);
```

### Exists

**`io.Exists(path)`** - Check if file or directory exists

- `path`: Path to check
- Returns: 1 if exists, 0 otherwise

**Example:**
```tl
@exists int = io.Exists("file.txt");
okavela exists == 1 {
    fmt.Printf("File exists\n");
} lekapothe {
    fmt.Printf("File does not exist\n");
}
```

### IsDir

**`io.IsDir(path)`** - Check if path is directory

- `path`: Path to check
- Returns: 1 if directory, 0 otherwise

**Example:**
```tl
@isDir int = io.IsDir("/path/to/dir");
okavela isDir == 1 {
    fmt.Printf("Is a directory\n");
}
```

### ReadDir

**`io.ReadDir(dirname)`** - Read directory contents

- `dirname`: Directory path
- Returns: Newline-separated string of filenames

**Example:**
```tl
@files string = io.ReadDir(".");
fmt.Printf("Files:\n%s\n", files);
```

### Mkdir

**`io.Mkdir(name)`** - Create directory

- `name`: Directory path
- Returns: 1 on success, 0 on error

**Example:**
```tl
@result int = io.Mkdir("newdir");
okavela result == 1 {
    fmt.Printf("Directory created\n");
}
```

### Remove

**`io.Remove(name)`** - Remove file or directory

- `name`: Path to remove
- Returns: 1 on success, 0 on error

**Example:**
```tl
@result int = io.Remove("file.txt");
okavela result == 1 {
    fmt.Printf("File removed\n");
}
```

### Rename

**`io.Rename(oldpath, newpath)`** - Rename or move file

- `oldpath`: Current path
- `newpath`: New path
- Returns: 1 on success, 0 on error

**Example:**
```tl
@result int = io.Rename("old.txt", "new.txt");
okavela result == 1 {
    fmt.Printf("File renamed\n");
}
```

### Stat

**`io.Stat(path)`** - Get file information

- `path`: File path
- Returns: String with file info (size, mod time), or empty on error

**Example:**
```tl
@info string = io.Stat("file.txt");
fmt.Printf("File info: %s\n", info);
```

## Common Patterns

### Safe File Reading
```tl
@filename string = "data.txt";
@exists int = io.Exists(filename);
okavela exists == 1 {
    @content string = io.ReadFile(filename);
    fmt.Printf("Content: %s\n", content);
} lekapothe {
    fmt.Printf("File not found: %s\n", filename);
}
```

### Writing Configuration
```tl
@config string = "key1=value1\nkey2=value2";
@written int = io.WriteFile("config.txt", config);
okavela written > 0 {
    fmt.Printf("Config saved\n");
}
```

### Directory Listing
```tl
@files string = io.ReadDir(".");
@fileList string = files;
// Process fileList (newline-separated)
```

### File Backup
```tl
@original string = "data.txt";
@backup string = "data.txt.bak";
@content string = io.ReadFile(original);
@written int = io.WriteFile(backup, content);
okavela written > 0 {
    fmt.Printf("Backup created\n");
}
```

## Error Handling

Always check return values:

```tl
@result int = io.WriteFile("output.txt", data);
okavela result == 0 {
    fmt.Printf("Error: Failed to write file\n");
}
```

## Platform Notes

- Paths use forward slashes on all platforms
- File operations are synchronous
- Large files may require chunked reading (future feature)

## See Also

- [Tutorial - Lesson 9](tutorial.md#lesson-9-file-io)
- [filepath Library](filepath.md) - Path manipulation
- [Language Reference](language-reference.md)
