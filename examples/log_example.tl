// log library example
// Demonstrates structured logging with different levels

@fmt = #dhimpu("std/fmt");
@log = #dhimpu("std/log");
@io = #dhimpu("std/io");

#prarambham() {
    fmt.Printf("=== log Library Examples ===\n\n");
    
    // Basic logging
    fmt.Printf("--- Basic Logging ---\n");
    log.Print("This is a basic log message");
    log.Printf("Formatted message: %s with number: %d", "hello", 42);
    
    // Different log levels
    fmt.Printf("\n--- Log Levels ---\n");
    log.Debug("This is a debug message");
    log.Info("This is an info message");
    log.Warn("This is a warning message");
    log.Error("This is an error message");
    
    // Set log level to filter messages
    fmt.Printf("\n--- Log Level Filtering ---\n");
    fmt.Printf("Setting log level to WARN (only WARN and ERROR will show)\n");
    log.SetLevel(2); // WARN level
    log.Debug("This debug message will NOT appear");
    log.Info("This info message will NOT appear");
    log.Warn("This warning message WILL appear");
    log.Error("This error message WILL appear");
    
    // Reset to INFO level
    fmt.Printf("\n--- Reset to INFO Level ---\n");
    log.SetLevel(1); // INFO level
    log.Debug("This debug message will NOT appear");
    log.Info("This info message WILL appear");
    log.Warn("This warning message WILL appear");
    log.Error("This error message WILL appear");
    
    // Set to DEBUG level (show all)
    fmt.Printf("\n--- Set to DEBUG Level (show all) ---\n");
    log.SetLevel(0); // DEBUG level
    log.Debug("This debug message WILL appear");
    log.Info("This info message WILL appear");
    log.Warn("This warning message WILL appear");
    log.Error("This error message WILL appear");
    
    // Log to file
    fmt.Printf("\n--- Logging to File ---\n");
    @logFile string = "test.log";
    @result int = log.SetOutput(logFile);
    okavela result == 1 {
        log.Info("This message goes to the log file");
        log.Warn("Warning: This also goes to the file");
        log.Error("Error: File logging is working");
        fmt.Printf("Logs written to %s\n", logFile);
    } lekapothe {
        fmt.Printf("Failed to open log file: %s\n", logFile);
    }
    
    // Reset to stdout
    fmt.Printf("\n--- Reset to stdout ---\n");
    log.Reset();
    log.Info("Back to stdout logging");
    
    // Get current log level
    fmt.Printf("\n--- Get Current Log Level ---\n");
    @currentLevel int = log.GetLevel();
    fmt.Printf("Current log level: %d\n", currentLevel);
    
    // Practical example: Application logging
    fmt.Printf("\n--- Practical Example: Application Flow ---\n");
    log.SetLevel(1); // INFO
    log.Info("Application starting");
    log.Info("Loading configuration");
    log.Info("Connecting to database");
    log.Warn("Database connection slow (500ms)");
    log.Info("Application ready");
    
    // Error handling example
    fmt.Printf("\n--- Error Handling Example ---\n");
    @fileExists int = io.Exists("nonexistent.txt");
    okavela fileExists == 0 {
        log.Error("File not found: nonexistent.txt");
    } lekapothe {
        log.Info("File found: nonexistent.txt");
    }
    
    // Note: log.Fatal will exit the program, so we don't call it in this example
    // Uncomment the line below to test (will exit immediately):
    // log.Fatal("Fatal error: Application must exit");
    
    fmt.Printf("\n=== Log Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// === log Library Examples ===
//
// --- Basic Logging ---
// [2026-01-27 22:21:10] [INFO] This is a basic log message
// [2026-01-27 22:21:10] [INFO] Formatted message: hello with number: 42
//
// --- Log Levels ---
// [2026-01-27 22:21:10] [INFO] This is an info message
// [2026-01-27 22:21:10] [WARN] This is a warning message
// [2026-01-27 22:21:10] [ERROR] This is an error message
//
// --- Log Level Filtering ---
// Setting log level to WARN (only WARN and ERROR will show)
// [2026-01-27 22:21:10] [WARN] This warning message WILL appear
// [2026-01-27 22:21:10] [ERROR] This error message WILL appear
//
// --- Reset to INFO Level ---
// [2026-01-27 22:21:10] [INFO] This info message WILL appear
// [2026-01-27 22:21:10] [WARN] This warning message WILL appear
// [2026-01-27 22:21:10] [ERROR] This error message WILL appear
//
// --- Set to DEBUG Level (show all) ---
// [2026-01-27 22:21:10] [DEBUG] This debug message WILL appear
// [2026-01-27 22:21:10] [INFO] This info message WILL appear
// [2026-01-27 22:21:10] [WARN] This warning message WILL appear
// [2026-01-27 22:21:10] [ERROR] This error message WILL appear
//
// --- Logging to File ---
// Logs written to test.log
//
// --- Reset to stdout ---
// [2026-01-27 22:21:10] [INFO] Back to stdout logging
//
// --- Get Current Log Level ---
// Current log level: 1
//
// --- Practical Example: Application Flow ---
// [2026-01-27 22:21:10] [INFO] Application starting
// [2026-01-27 22:21:10] [INFO] Loading configuration
// [2026-01-27 22:21:10] [INFO] Connecting to database
// [2026-01-27 22:21:10] [WARN] Database connection slow (500ms)
// [2026-01-27 22:21:10] [INFO] Application ready
//
// --- Error Handling Example ---
// [2026-01-27 22:21:10] [ERROR] File not found: nonexistent.txt
//
// === Log Example Complete ===
//
