// filepath library example

dhimpu "fmt" as fmt;
dhimpu "filepath" as filepath;

#prarambham() {
    // Join path components
    @path1 string = "/usr";
    @path2 string = "local";
    @joined string = filepath.Join(path1, path2);
    fmt.Printf("Joined path: %s\n", joined);
    
    // Chain multiple joins
    @fullPath string = filepath.Join(filepath.Join("/usr", "local"), "bin");
    fmt.Printf("Full path: %s\n", fullPath);
    
    // Get base (filename)
    @base string = filepath.Base("/usr/local/bin/program");
    fmt.Printf("Base: %s\n", base);
    
    // Get directory
    @dir string = filepath.Dir("/usr/local/bin/program");
    fmt.Printf("Dir: %s\n", dir);
    
    // Get extension
    @ext string = filepath.Ext("document.txt");
    fmt.Printf("Extension: %s\n", ext);
    
    // Clean path (remove .. and .)
    @dirty string = "/usr/../local/./bin";
    @clean string = filepath.Clean(dirty);
    fmt.Printf("Cleaned: %s -> %s\n", dirty, clean);
    
    // Get absolute path
    @relPath string = "relative/path";
    @absPath string = filepath.Abs(relPath);
    fmt.Printf("Absolute: %s\n", absPath);
    
    // Check if absolute
    @isAbs1 int = filepath.IsAbs("/absolute/path");
    @isAbs2 int = filepath.IsAbs("relative/path");
    fmt.Printf("Is absolute (/absolute/path): %d\n", isAbs1);
    fmt.Printf("Is absolute (relative/path): %d\n", isAbs2);
    
    // Split path (returns "dir|file")
    @split string = filepath.Split("/usr/local/bin");
    fmt.Printf("Split result: %s\n", split);
    // Note: Split returns "dir|file" format, you can parse it if needed
}

//

//

//

//

//

// === OUTPUT ===
// Joined path: \usr\local
// Full path: bin
// Base: program
// Dir: \usr\local\bin
// Extension: .txt
// Cleaned: /usr/../local/./bin -> \\local\bin
// Absolute: C:\Users\vanka\github.com\vasuvanka\tlang\relative\path
// Is absolute (/absolute/path): 0
// Is absolute (relative/path): 0
// Split result: \usr\local|bin
//
