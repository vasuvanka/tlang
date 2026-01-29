# log - Logging Library

The `log` library provides structured logging for debugging and monitoring.

## Functions

### Basic Logging

**`log.Print(message)`** - Print log message (INFO level)

- `message`: Log message string
- Defaults to INFO level
- Outputs to stdout by default

**Example:**
```tl
log.Print("Application started");
```

**`log.Printf(format, ...)`** - Formatted log message (INFO level)

- `format`: Format string (like printf)
- Additional arguments: Values to format
- Supports standard printf format specifiers

**Example:**
```tl
log.Printf("Processing %d items", 42);
```

### Log Levels

**`log.Debug(message)`** - Debug level log

- Lowest priority, for detailed debugging information

**Example:**
```tl
log.Debug("Variable value: 42");
```

**`log.Info(message)`** - Info level log

- General informational messages (default level)

**Example:**
```tl
log.Info("Application is running");
```

**`log.Warn(message)`** - Warning level log

- Warning messages for potentially problematic situations

**Example:**
```tl
log.Warn("High memory usage detected");
```

**`log.Error(message)`** - Error level log

- Error messages for error conditions

**Example:**
```tl
log.Error("Failed to connect to database");
```

**`log.Fatal(message)`** - Log and exit program

- Logs at FATAL level and immediately exits with code 1
- Use for critical errors that prevent program continuation

**Example:**
```tl
log.Fatal("Critical error: Cannot continue");
// Program exits here
```

### Configuration

**`log.SetLevel(level)`** - Set log level

- `level`: Integer log level (0=DEBUG, 1=INFO, 2=WARN, 3=ERROR)
- Only messages at or above this level will be logged
- Default: INFO (1)

**Example:**
```tl
log.SetLevel(0);  // DEBUG - show all
log.SetLevel(1);  // INFO - default
log.SetLevel(2);  // WARN - only warnings and errors
log.SetLevel(3);  // ERROR - only errors
```

**`log.GetLevel()`** - Get current log level

- Returns: Current log level as integer

**Example:**
```tl
@level int = log.GetLevel();
fmt.Printf("Current log level: %d\n", level);
```

**`log.SetOutput(filename)`** - Set log output file

- `filename`: Path to log file
- Opens file in append mode
- Returns: 1 on success, 0 on failure
- All subsequent logs will be written to this file

**Example:**
```tl
@result int = log.SetOutput("app.log");
okavela result == 1 {
    log.Info("This goes to app.log");
}
```

**`log.Reset()`** - Reset log output to stdout

- Closes current log file (if any)
- Resets output to stdout
- Resets log level to INFO

**Example:**
```tl
log.Reset();
log.Info("Back to stdout");
```

## Log Levels

| Level | Value | Description |
|-------|-------|-------------|
| DEBUG | 0 | Detailed debugging information |
| INFO  | 1 | General informational messages (default) |
| WARN  | 2 | Warning messages |
| ERROR | 3 | Error messages |
| FATAL | 4 | Fatal errors (always logged) |

## Log Format

All log messages include:
- **Timestamp**: `YYYY-MM-DD HH:MM:SS` format
- **Level**: DEBUG, INFO, WARN, ERROR, or FATAL
- **Message**: The actual log message

Format: `[TIMESTAMP] [LEVEL] MESSAGE`

**Example:**
```
[2024-01-15 14:30:45] [INFO] Application started
[2024-01-15 14:30:46] [WARN] High memory usage detected
[2024-01-15 14:30:47] [ERROR] Failed to connect to database
```

## Common Patterns

### Application Startup
```tl
log.Info("Application starting");
log.Info("Loading configuration");
log.Info("Application ready");
```

### Error Handling
```tl
@fileExists int = io.Exists("config.txt");
okavela fileExists == 0 {
    log.Error("Configuration file not found");
    log.Fatal("Cannot continue without configuration");
}
```

### Debugging
```tl
log.SetLevel(0);  // DEBUG
log.Debug("Variable value: %d", x);
log.Debug("Function entered");
```

### Production Logging
```tl
log.SetLevel(1);  // INFO (hide debug messages)
log.SetOutput("production.log");
log.Info("Server started on port 8080");
```

## Notes

- Log messages are automatically flushed to output
- File logging uses append mode (doesn't overwrite existing logs)
- `log.Fatal()` immediately exits the program (use with caution)
- Log level filtering applies to all log functions except `Fatal`
- Default output is stdout, can be redirected to file with `SetOutput()`
- Timestamps use local time

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
