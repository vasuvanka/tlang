// io library example

dhimpu "fmt" as fmt;
dhimpu "io" as io;

#prarambham() {
    // Write a file
    @written int = io.WriteFile("test.txt", "Hello from Tlang io library!");
    fmt.Printf("Written %d bytes to test.txt\n", written);
    
    // Read the file back
    @content string = io.ReadFile("test.txt");
    fmt.Printf("File content: %s\n", content);
    
    // Check if file exists
    @exists int = io.Exists("test.txt");
    fmt.Printf("File exists: %d\n", exists);
    
    // Check if it's a directory
    @isDir int = io.IsDir("test.txt");
    fmt.Printf("Is directory: %d\n", isDir);
    
    // Get file information
    @info string = io.Stat("test.txt");
    fmt.Printf("File info: %s\n", info);
    
    // Read current directory
    @files string = io.ReadDir(".");
    fmt.Printf("Current directory contents:\n%s\n", files);
    
    // Create a directory
    @mkdirResult int = io.Mkdir("test_dir", 0755);
    fmt.Printf("Mkdir result: %d\n", mkdirResult);
    
    // Check if directory exists
    @dirExists int = io.Exists("test_dir");
    fmt.Printf("Directory exists: %d\n", dirExists);
    
    // Rename the file
    @renameResult int = io.Rename("test.txt", "renamed.txt");
    fmt.Printf("Rename result: %d\n", renameResult);
    
    // Clean up
    io.Remove("renamed.txt");
    io.Remove("test_dir");
    fmt.Printf("Cleanup complete\n");
}

//

//

//

// === OUTPUT ===
// Written 28 bytes to test.txt
// File content: Hello from Tlang io library!
// File exists: 1
// Is directory: 0
// File info: size:28,isdir:0,mtime:1769532660
// Current directory contents:
// .
// ..
// .cargo
// .gitignore
// .vscode
// BUILD.md
// bundled-gcc-temp
// bundled-openssl-temp
// Cargo.lock
// Cargo.toml
// CHANGELOG.md
// docs
// examples
// install.ps1
// install.sh
// output.c
// output.exe
// README_INSTALL.md
// run_all_examples.py
// scripts
// src
// target
// test.txt
// tests
// vscode-extension
// __pycache__
// Mkdir result: 0
// Directory exists: 1
// Rename result: 0
// Cleanup complete
//
