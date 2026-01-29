# Tlang Logging Library

The `log` library provides structured logging for debugging and monitoring, similar to Go's log package.

## Functions

### Basic Logging

- **`log.Print(message)`** - Print log message (INFO level)
  - `message`: Log message string
  - Defaults to INFO level
  - Outputs to stdout by default

- **`log.Printf(format, ...)`** - Formatted log message (INFO level)
  - `format`: Format string (like printf)
  - Additional arguments: Values to format
  - Supports standard printf format specifiers

### Log Levels

- **`log.Debug(message)`** - Debug level log
  - Lowest priority, for detailed debugging information

- **`log.Info(message)`** - Info level log
  - General informational messages (default level)

- **`log.Warn(message)`** - Warning level log
  - Warning messages for potentially problematic situations

- **`log.Error(message)`** - Error level log
  - Error messages for error conditions

- **`log.Fatal(message)`** - Log and exit program
  - Logs at FATAL level and immediately exits with code 1
  - Use for critical errors that prevent program continuation

### Configuration

- **`log.SetLevel(level)`** - Set log level
  - `level`: Integer log level (0=DEBUG, 1=INFO, 2=WARN, 3=ERROR)
  - Only messages at or above this level will be logged
  - Default: INFO (1)

- **`log.GetLevel()`** - Get current log level
  - Returns: Current log level as integer

- **`log.SetOutput(filename)`** - Set log output file
  - `filename`: Path to log file
  - Opens file in append mode
  - Returns: 1 on success, 0 on failure
  - All subsequent logs will be written to this file

- **`log.Reset()`** - Reset log output to stdout
  - Closes current log file (if any)
  - Resets output to stdout
  - Resets log level to INFO

## Log Levels

| Level | Value | Description |
|-------|-------|-------------|
| DEBUG | 0 | Detailed debugging information |
| INFO  | 1 | General informational messages (default) |
| WARN  | 2 | Warning messages |
| ERROR | 3 | Error messages |
| FATAL | 4 | Fatal errors (always logged) |

## Example Usage

```tl
#prarambham() {
    // Basic logging
    log.Print("Application started");
    log.Printf("Processing %d items", 42);
    
    // Different log levels
    log.Debug("Debug information");
    log.Info("Application is running");
    log.Warn("High memory usage detected");
    log.Error("Failed to connect to database");
    
    // Set log level to filter messages
    log.SetLevel(2); // Only WARN and ERROR
    log.Debug("This won't appear");
    log.Info("This won't appear");
    log.Warn("This will appear");
    log.Error("This will appear");
    
    // Log to file
    @result int = log.SetOutput("app.log");
    ayithe result == 1 {
        log.Info("This goes to app.log");
    }
    
    // Reset to stdout
    log.Reset();
    log.Info("Back to stdout");
    
    // Get current level
    @level int = log.GetLevel();
    fmt.Printf("Current log level: %d\n", level);
}
```

## Log Format

All log messages include:
- **Timestamp**: `YYYY-MM-DD HH:MM:SS` format
- **Level**: DEBUG, INFO, WARN, ERROR, or FATAL
- **Message**: The actual log message

Format: `[TIMESTAMP] [LEVEL] MESSAGE`

Example:
```
[2024-01-15 14:30:45] [INFO] Application started
[2024-01-15 14:30:46] [WARN] High memory usage detected
[2024-01-15 14:30:47] [ERROR] Failed to connect to database
```

## Common Use Cases

### Application Startup
```tl
log.Info("Application starting");
log.Info("Loading configuration");
log.Info("Application ready");
```

### Error Handling
```tl
@fileExists int = io.Exists("config.txt");
ayithe fileExists == 0 {
    log.Error("Configuration file not found");
    log.Fatal("Cannot continue without configuration");
}
```

### Debugging
```tl
log.SetLevel(0); // DEBUG
log.Debug("Variable value: %d", x);
log.Debug("Function entered");
```

### Production Logging
```tl
log.SetLevel(1); // INFO (hide debug messages)
log.SetOutput("production.log");
log.Info("Server started on port 8080");
```

### Conditional Logging
```tl
@debugMode int = 1;
ayithe debugMode == 1 {
    log.SetLevel(0); // DEBUG
} lekapothe {
    log.SetLevel(1); // INFO
}
```

## Notes

- Log messages are automatically flushed to output
- File logging uses append mode (doesn't overwrite existing logs)
- `log.Fatal()` immediately exits the program (use with caution)
- Log level filtering applies to all log functions except `Fatal`
- Default output is stdout, can be redirected to file with `SetOutput()`
- Timestamps use local time

## Platform Support

- Uses standard C library functions (fprintf, fopen, etc.)
- Available on all platforms (Windows, Linux, macOS, etc.)
- File paths are platform-specific (use forward slashes on Windows too)
