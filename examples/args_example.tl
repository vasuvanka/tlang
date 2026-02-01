// Command-line arguments example
// Demonstrates accessing program arguments

@fmt = #dhimpu("std/fmt");
@args = #dhimpu("std/args");
@strings = #dhimpu("std/strings");

#prarambham() {
    @argCount int = args.Count();
    @programName string = args.Program();

    fmt.Printf("Program: %s\n", programName);
    fmt.Printf("Number of arguments: %d\n", argCount);
    fmt.Printf("\nArguments:\n");

    malli @!i int = 0; i < argCount; i = i + 1 {
        @arg string = args.Get(i);
        fmt.Printf("  [%d] %s\n", i, arg);
    }

    // Example: Check for specific flags
    okavela argCount > 1 {
        @firstArg string = args.Get(1);
        okavela strings.Contains(firstArg, "--help") {
            fmt.Printf("\nUsage: %s [options]\n", programName);
            fmt.Printf("Options:\n");
            fmt.Printf("  --help    Show this help message\n");
            fmt.Printf("  --version Show version information\n");
        } lekapothe okavela strings.Contains(firstArg, "--version") {
            fmt.Printf("\nTlang version 0.1.0\n");
        }
    }
}

//

//

//

//

//

// === OUTPUT ===
// Program: C:\Users\vanka\github.com\vasuvanka\tlang\output.exe
// Number of arguments: 2
//
// Arguments:
//   [0] C:\Users\vanka\github.com\vasuvanka\tlang\output.exe
//   [1] --help
//
// Usage: C:\Users\vanka\github.com\vasuvanka\tlang\output.exe [options]
// Options:
//   --help    Show this help message
//   --version Show version information
//
