# filepath - Path Manipulation Library

The `filepath` library provides cross-platform path manipulation functions.

## Functions

### Path Construction

**`filepath.Join(path1, path2)`** - Join path components

- `path1`, `path2`: Path components to join
- Returns: Joined path with proper separators
- Can be chained: `filepath.Join(filepath.Join("/usr", "local"), "bin")`

**Example:**
```tl
@path string = filepath.Join("/usr", "local", "bin");
// Returns: "/usr/local/bin" (Unix) or "\\usr\\local\\bin" (Windows)
```

### Path Components

**`filepath.Base(path)`** - Get filename from path

- `path`: Full path
- Returns: Filename component

**Example:**
```tl
@base string = filepath.Base("/usr/local/bin/file.txt");
// Returns: "file.txt"
```

**`filepath.Dir(path)`** - Get directory from path

- `path`: Full path
- Returns: Directory component

**Example:**
```tl
@dir string = filepath.Dir("/usr/local/bin/file.txt");
// Returns: "/usr/local/bin"
```

**`filepath.Ext(path)`** - Get file extension

- `path`: File path
- Returns: File extension (including dot)

**Example:**
```tl
@ext string = filepath.Ext("file.txt");
// Returns: ".txt"
```

### Path Cleaning

**`filepath.Clean(path)`** - Clean path (remove .., .)

- `path`: Path to clean
- Returns: Cleaned path

**Example:**
```tl
@clean string = filepath.Clean("/usr/../local/./bin");
// Returns: "/local/bin"
```

**`filepath.Abs(path)`** - Get absolute path

- `path`: Relative or absolute path
- Returns: Absolute path

**Example:**
```tl
@abs string = filepath.Abs("relative/path");
// Returns: "/current/dir/relative/path"
```

**`filepath.IsAbs(path)`** - Check if path is absolute

- `path`: Path to check
- Returns: 1 if absolute, 0 if relative

**Example:**
```tl
@isAbs1 int = filepath.IsAbs("/usr/local");  // 1
@isAbs2 int = filepath.IsAbs("relative");    // 0
```

### Path Splitting

**`filepath.Split(path)`** - Split directory and file

- `path`: Path to split
- Returns: String with format "dir|file"

**Example:**
```tl
@split string = filepath.Split("/usr/local/bin");
// Returns: "/usr/local|bin"
```

## Common Patterns

### Build Config Path
```tl
@home string = os.Getenv("HOME");
@configPath string = filepath.Join(home, ".config", "app.conf");
```

### Check File Extension
```tl
@filename string = "image.jpg";
@ext string = filepath.Ext(filename);
okavela strings.Contains(ext, ".jpg") {
    fmt.Printf("JPEG image\n");
}
```

### Get Directory of Current File
```tl
@filePath string = "/usr/local/bin/app";
@dir string = filepath.Dir(filePath);
fmt.Printf("Directory: %s\n", dir);
```

### Normalize Path
```tl
@dirty string = "/usr/../local/./bin";
@clean string = filepath.Clean(dirty);
// Returns: "/local/bin"
```

## Platform Notes

- Paths use forward slashes on all platforms (handled internally)
- Functions work correctly on both Unix and Windows
- Absolute paths: Unix uses `/`, Windows uses drive letters

## See Also

- [io Library](io.md) - File operations
- [os Library](os.md) - Operating system interface
- [Language Reference](../language-reference.md)
