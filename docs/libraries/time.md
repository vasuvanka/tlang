# time - Time Operations Library

The `time` library provides time and date operations.

## Functions

### Current Time

**`time.Now()`** - Get current time as Unix timestamp

- Returns: Unix timestamp (seconds since January 1, 1970)

**Example:**
```tl
@now int = time.Now();
fmt.Printf("Current timestamp: %d\n", now);
```

### Sleep

**`time.Sleep(seconds)`** - Sleep for specified seconds

- `seconds`: Number of seconds to sleep (int)
- Blocks execution for the specified duration

**Example:**
```tl
fmt.Printf("Starting...\n");
time.Sleep(2);  // Sleep for 2 seconds
fmt.Printf("Done!\n");
```

**`time.SleepMilliseconds(ms)`** - Sleep for specified milliseconds

- `ms`: Number of milliseconds to sleep (int)
- Blocks execution for the specified duration

**Example:**
```tl
time.SleepMilliseconds(500);  // Sleep for 500ms
```

### Formatting

**`time.Format(timestamp, format)`** - Format Unix timestamp to string

- `timestamp`: Unix timestamp (int)
- `format`: Format string (strftime format)
- Returns: Formatted time string

**Format Specifiers:**
- `%Y` - Year (4 digits)
- `%m` - Month (01-12)
- `%d` - Day (01-31)
- `%H` - Hour (00-23)
- `%M` - Minute (00-59)
- `%S` - Second (00-59)
- `%A` - Weekday name
- `%B` - Month name

**Example:**
```tl
@now int = time.Now();
@formatted string = time.Format(now, "%Y-%m-%d %H:%M:%S");
fmt.Printf("Time: %s\n", formatted);
// Output: Time: 2024-01-15 14:30:45
```

**`time.Parse(format, timeString)`** - Parse time string to Unix timestamp

- `format`: Format string matching the time string
- `timeString`: Time string to parse
- Returns: Unix timestamp, or 0 on error

**Example:**
```tl
@timestamp int = time.Parse("%Y-%m-%d", "2024-01-15");
fmt.Printf("Timestamp: %d\n", timestamp);
```

## Common Patterns

### Current Date and Time
```tl
@now int = time.Now();
@date string = time.Format(now, "%Y-%m-%d");
@time string = time.Format(now, "%H:%M:%S");
fmt.Printf("Date: %s, Time: %s\n", date, time);
```

### Elapsed Time
```tl
@start int = time.Now();
// ... do work ...
time.Sleep(1);
@end int = time.Now();
@elapsed int = end - start;
fmt.Printf("Elapsed: %d seconds\n", elapsed);
```

### Timestamp Conversion
```tl
@timestamp int = time.Now();
@formatted string = time.Format(timestamp, "%A, %B %d, %Y");
fmt.Printf("Formatted: %s\n", formatted);
```

### Delay Execution
```tl
fmt.Printf("Message 1\n");
time.Sleep(1);
fmt.Printf("Message 2\n");
```

## Notes

- Unix timestamps are in seconds (not milliseconds)
- Format strings use strftime format specifiers
- Time is in local timezone
- Sleep functions block execution

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
