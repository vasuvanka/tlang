// Test cases for io library

@fmt = #dhimpu("std/fmt");
@io = #dhimpu("std/io");

#prarambham() {
    fmt.Printf("=== io Library Tests ===\n");
    
    // WriteFile tests
    @content1 string = "Hello, World!\nThis is a test file.";
    @written1 int = io.WriteFile("test_io_file1.txt", content1);
    fmt.Printf("WriteFile('test_io_file1.txt'): wrote %d bytes\n", written1);
    
    @content2 string = "Line 1\nLine 2\nLine 3\n";
    @written2 int = io.WriteFile("test_io_file2.txt", content2);
    fmt.Printf("WriteFile('test_io_file2.txt'): wrote %d bytes\n", written2);
    
    // ReadFile tests
    @read1 string = io.ReadFile("test_io_file1.txt");
    fmt.Printf("ReadFile('test_io_file1.txt'): %s", read1);
    fmt.Printf("Content matches: %d\n", strings.Contains(read1, "Hello"));
    
    @read2 string = io.ReadFile("test_io_file2.txt");
    fmt.Printf("ReadFile('test_io_file2.txt'): %s", read2);
    
    // Exists tests
    @exists1 int = io.Exists("test_io_file1.txt");
    @exists2 int = io.Exists("test_io_file2.txt");
    @exists3 int = io.Exists("nonexistent_file_xyz.txt");
    
    fmt.Printf("Exists('test_io_file1.txt'): %d (expected: 1)\n", exists1);
    fmt.Printf("Exists('test_io_file2.txt'): %d (expected: 1)\n", exists2);
    fmt.Printf("Exists('nonexistent_file_xyz.txt'): %d (expected: 0)\n", exists3);
    
    // IsDir tests
    @isDir1 int = io.IsDir(".");
    @isDir2 int = io.IsDir("test_io_file1.txt");
    @isDir3 int = io.IsDir("..");
    
    fmt.Printf("IsDir('.'): %d (expected: 1)\n", isDir1);
    fmt.Printf("IsDir('test_io_file1.txt'): %d (expected: 0)\n", isDir2);
    fmt.Printf("IsDir('..'): %d (expected: 1)\n", isDir3);
    
    // Stat tests
    @stat1 string = io.Stat("test_io_file1.txt");
    fmt.Printf("Stat('test_io_file1.txt'): %s\n", stat1);
    
    // Mkdir tests
    @mkdirResult int = io.Mkdir("test_io_dir", 0755);
    fmt.Printf("Mkdir('test_io_dir'): %d\n", mkdirResult);
    
    @dirExists int = io.Exists("test_io_dir");
    @dirIsDir int = io.IsDir("test_io_dir");
    fmt.Printf("Created directory exists: %d, is directory: %d\n", dirExists, dirIsDir);
    
    // ReadDir tests
    @dirContents string = io.ReadDir(".");
    fmt.Printf("ReadDir('.'): found entries\n");
    fmt.Printf("Contains test files: %d\n", strings.Contains(dirContents, "test_io_file1"));
    
    // Rename tests
    @renameResult int = io.Rename("test_io_file1.txt", "test_io_renamed.txt");
    fmt.Printf("Rename('test_io_file1.txt' -> 'test_io_renamed.txt'): %d\n", renameResult);
    
    @renamedExists int = io.Exists("test_io_renamed.txt");
    @oldExists int = io.Exists("test_io_file1.txt");
    fmt.Printf("Renamed file exists: %d, old file exists: %d\n", renamedExists, oldExists);
    
    // Read renamed file
    @renamedContent string = io.ReadFile("test_io_renamed.txt");
    fmt.Printf("Read renamed file: %s", renamedContent);
    
    // Cleanup
    io.Remove("test_io_renamed.txt");
    io.Remove("test_io_file2.txt");
    io.Remove("test_io_dir");
    fmt.Printf("Cleanup: removed all test files and directories\n");
}

//

//

//

// === OUTPUT ===
// === io Library Tests ===
// WriteFile('test_io_file1.txt'): wrote 34 bytes
// WriteFile('test_io_file2.txt'): wrote 21 bytes
// ReadFile('test_io_file1.txt'): Hello, World!
// This is a test file.Content matches: 1
// ReadFile('test_io_file2.txt'): Line 1
// Line 2
// Line 3
// Exists('test_io_file1.txt'): 1 (expected: 1)
// Exists('test_io_file2.txt'): 1 (expected: 1)
// Exists('nonexistent_file_xyz.txt'): 0 (expected: 0)
// IsDir('.'): 1 (expected: 1)
// IsDir('test_io_file1.txt'): 0 (expected: 0)
// IsDir('..'): 1 (expected: 1)
// Stat('test_io_file1.txt'): size:34,isdir:0,mtime:1769532936
// Mkdir('test_io_dir'): 0
// Created directory exists: 1, is directory: 1
// ReadDir('.'): found entries
// Contains test files: 1
// Rename('test_io_file1.txt' -> 'test_io_renamed.txt'): 0
// Renamed file exists: 1, old file exists: 0
// Read renamed file: Hello, World!
// This is a test file.Cleanup: removed all test files and directories
//
