// Real-World Example 4: CLI Tool
// A command-line utility with subcommands and options

dhimpu "fmt" as fmt;
dhimpu "args" as args;
dhimpu "strings" as strings;
dhimpu "io" as io;

// Show help message
#showHelp(programName string) {
    fmt.Printf("Usage: %s <command> [options]\n\n", programName);
    fmt.Printf("Commands:\n");
    fmt.Printf("  count <file>     Count lines, words, and characters in a file\n");
    fmt.Printf("  search <dir>     Search for files in a directory\n");
    fmt.Printf("  info <file>      Show file information\n");
    fmt.Printf("  version         Show version information\n");
    fmt.Printf("  help            Show this help message\n\n");
    fmt.Printf("Options:\n");
    fmt.Printf("  --verbose, -v    Enable verbose output\n");
    fmt.Printf("  --help, -h       Show help for a command\n");
}

// Count lines, words, and characters
#countFile(filename string, verbose int) {
    @content string = io.ReadFile(filename);
    okavela content == sunyam {
        fmt.Printf("Error: Could not read file %s\n", filename);
        mallinchu;
    }
    
    @lines int = 1;  // Start at 1 (last line may not have newline)
    @words int = 0;
    @chars int = len(content);
    
    malli (@!i int = 0; i < len(content); i = i + 1) {
        @ch byte = content[i];
        okavela ch == '\n' {
            lines = lines + 1;
        }
        okavela ch == ' ' || ch == '\t' || ch == '\n' {
            words = words + 1;
        }
    }
    
    fmt.Printf("File: %s\n", filename);
    fmt.Printf("  Lines:      %d\n", lines);
    fmt.Printf("  Words:      %d\n", words);
    fmt.Printf("  Characters: %d\n", chars);
    
    okavela verbose != 0 {
        fmt.Printf("  Size:       %d bytes\n", chars);
    }
}

// Search for files in directory
#searchFiles(dir string, verbose int) {
    okavela !io.Exists(dir) {
        fmt.Printf("Error: Directory %s does not exist\n", dir);
        mallinchu;
    }
    
    okavela !io.IsDir(dir) {
        fmt.Printf("Error: %s is not a directory\n", dir);
        mallinchu;
    }
    
    @files string = io.ReadDir(dir);
    fmt.Printf("Files in %s:\n", dir);
    fmt.Printf("%s\n", files);
}

// Show file information
#showFileInfo(filename string) {
    okavela !io.Exists(filename) {
        fmt.Printf("Error: File %s does not exist\n", filename);
        mallinchu;
    }
    
    @info string = io.Stat(filename);
    @content string = io.ReadFile(filename);
    
    fmt.Printf("File Information: %s\n", filename);
    fmt.Printf("  Stats: %s\n", info);
    okavela content != sunyam {
        fmt.Printf("  Size:  %d bytes\n", len(content));
        
        // Count lines manually
        @lines int = 1;
        malli (@!i int = 0; i < len(content); i = i + 1) {
            okavela content[i] == '\n' {
                lines = lines + 1;
            }
        }
        fmt.Printf("  Lines: %d\n", lines);
    }
}

#prarambham() {
    @argCount int = args.Count();
    @programName string = args.Program();
    
    okavela argCount < 2 {
        showHelp(programName);
        mallinchu;
    }
    
    @command string = args.Get(1);
    @verbose int = 0;
    
    // Check for verbose flag
    malli (@!i int = 2; i < argCount; i = i + 1) {
        @arg string = args.Get(i);
        okavela arg == "--verbose" || arg == "-v" {
            verbose = 1;
        }
    }
    
    // Handle commands
    okavela command == "help" || command == "--help" || command == "-h" {
        showHelp(programName);
    } lekapothe okavela command == "version" {
        fmt.Printf("%s version 1.0.0\n", programName);
    } lekapothe okavela command == "count" {
        okavela argCount < 3 {
            fmt.Printf("Error: count requires a filename\n");
            fmt.Printf("Usage: %s count <file>\n", programName);
        } lekapothe {
            @filename string = args.Get(2);
            countFile(filename, verbose);
        }
    } lekapothe okavela command == "search" {
        okavela argCount < 3 {
            fmt.Printf("Error: search requires a directory\n");
            fmt.Printf("Usage: %s search <directory>\n", programName);
        } lekapothe {
            @dir string = args.Get(2);
            searchFiles(dir, verbose);
        }
    } lekapothe okavela command == "info" {
        okavela argCount < 3 {
            fmt.Printf("Error: info requires a filename\n");
            fmt.Printf("Usage: %s info <file>\n", programName);
        } lekapothe {
            @filename string = args.Get(2);
            showFileInfo(filename);
        }
    } lekapothe {
        fmt.Printf("Error: Unknown command '%s'\n", command);
        fmt.Printf("Run '%s help' for usage information\n", programName);
    }
}
