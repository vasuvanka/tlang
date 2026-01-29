# Tlang Examples Guide

This guide provides practical examples and patterns for common programming tasks in Tlang.

## Table of Contents

1. [Basic Examples](#basic-examples)
2. [File Operations](#file-operations)
3. [String Processing](#string-processing)
4. [Mathematical Operations](#mathematical-operations)
5. [Error Handling](#error-handling)
6. [Complete Programs](#complete-programs)
7. [Real-World Examples](../examples/real-world-examples/README.md) ⭐ **NEW** - Practical applications

## Basic Examples

### Hello World

```tl
#prarambham() {
    fmt.Printf("Hello, World!\n");
}
```

### Variables and Types

```tl
#prarambham() {
    @name string = "Tlang";
    @version int = 1;
    @pi float = 3.14159;
    @isActive int = 1;
    
    fmt.Printf("Name: %s, Version: %d, PI: %.2f\n", name, version, pi);
}
```

### Functions

```tl
#add(a int, b int) int {
    mallinchu a + b;
}

#prarambham() {
    @result int = add(5, 3);
    fmt.Printf("5 + 3 = %d\n", result);
}
```

## File Operations

### Read File

```tl
#prarambham() {
    @filename string = "data.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 1 {
        @content string = io.ReadFile(filename);
        fmt.Printf("File content:\n%s\n", content);
    } lekapothe {
        fmt.Printf("File not found: %s\n", filename);
    }
}
```

### Write File

```tl
#prarambham() {
    @data string = "Hello from Tlang!\nThis is line 2.";
    @written int = io.WriteFile("output.txt", data);
    okavela written > 0 {
        fmt.Printf("Wrote %d bytes\n", written);
    }
}
```

### File Processing

```tl
#prarambham() {
    @input string = "input.txt";
    @output string = "output.txt";
    
    @content string = io.ReadFile(input);
    @upper string = strings.ToUpper(content);
    @written int = io.WriteFile(output, upper);
    
    fmt.Printf("Processed %d bytes\n", written);
}
```

## String Processing

### String Manipulation

```tl
#prarambham() {
    @text string = "  Hello World  ";
    
    // Trim whitespace
    @trimmed string = strings.TrimSpace(text);
    
    // Convert case
    @upper string = strings.ToUpper(trimmed);
    @lower string = strings.ToLower(trimmed);
    
    // Check contains
    @hasHello int = strings.Contains(lower, "hello");
    
    fmt.Printf("Original: '%s'\n", text);
    fmt.Printf("Trimmed: '%s'\n", trimmed);
    fmt.Printf("Upper: %s\n", upper);
    fmt.Printf("Has 'hello': %d\n", hasHello);
}
```

### String Formatting

```tl
#prarambham() {
    @name string = "Alice";
    @age int = 30;
    @height float = 1.65;
    
    @message string = fmt.Sprintf("Name: %s, Age: %d, Height: %.2f", name, age, height);
    fmt.Printf("%s\n", message);
}
```

### Regular Expressions

```tl
#prarambham() {
    @text string = "Contact: user@example.com or admin@test.com";
    
    // Find email addresses
    @emails string = regexp.FindAll("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}", text, 10);
    fmt.Printf("Found emails:\n%s\n", emails);
    
    // Replace
    @replaced string = regexp.ReplaceAll("@", text, "[at]");
    fmt.Printf("Replaced: %s\n", replaced);
}
```

## Mathematical Operations

### Basic Math

```tl
#prarambham() {
    @x float = 16.0;
    @sqrt float = math.Sqrt(x);
    @power float = math.Pow(2.0, 3.0);
    @pi float = math.Pi();
    
    fmt.Printf("sqrt(16) = %f\n", sqrt);
    fmt.Printf("2^3 = %f\n", power);
    fmt.Printf("PI = %f\n", pi);
}
```

### Distance Calculation

```tl
#distance(x1 float, y1 float, x2 float, y2 float) float {
    @dx float = x2 - x1;
    @dy float = y2 - y1;
    mallinchu math.Sqrt(dx * dx + dy * dy);
}

#prarambham() {
    @dist float = distance(0.0, 0.0, 3.0, 4.0);
    fmt.Printf("Distance: %f\n", dist);  // 5.0
}
```

## Error Handling

### File Error Handling

```tl
#prarambham() {
    @filename string = "config.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 0 {
        fmt.Printf("Error: File '%s' not found\n", filename);
        os.Exit(1);
    }
    
    @content string = io.ReadFile(filename);
    okavela strings.Index(content, "") == 0 {
        fmt.Printf("Error: File is empty\n");
        os.Exit(1);
    }
    
    fmt.Printf("File loaded successfully\n");
}
```

### Input Validation

```tl
#prarambham() {
    @input string = "123";
    @num int = strconv.Atoi(input);
    
    okavela num == 0 {
        fmt.Printf("Error: Invalid number\n");
        mallinchu;
    }
    
    fmt.Printf("Number: %d\n", num);
}
```

## Complete Programs

### Text Analyzer

```tl
#prarambham() {
    @filename string = "input.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 0 {
        fmt.Printf("Error: File not found\n");
        os.Exit(1);
    }
    
    @content string = io.ReadFile(filename);
    @upper string = strings.ToUpper(content);
    @lower string = strings.ToLower(content);
    
    fmt.Printf("Original: %s\n", content);
    fmt.Printf("Uppercase: %s\n", upper);
    fmt.Printf("Lowercase: %s\n", lower);
    
    // Count occurrences
    @hasHello int = strings.Contains(content, "hello");
    fmt.Printf("Contains 'hello': %d\n", hasHello);
}
```

### Configuration Reader

```tl
#prarambham() {
    @configFile string = "config.txt";
    @exists int = io.Exists(configFile);
    
    okavela exists == 1 {
        @content string = io.ReadFile(configFile);
        fmt.Printf("Configuration loaded:\n%s\n", content);
    } lekapothe {
        fmt.Printf("Creating default configuration\n");
        @defaultConfig string = "debug=false\nport=8080\n";
        io.WriteFile(configFile, defaultConfig);
    }
}
```

### Logging Example

```tl
#prarambham() {
    log.SetLevel(1);  // INFO
    log.Info("Application starting");
    
    @filename string = "data.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 1 {
        log.Info("File found");
        @content string = io.ReadFile(filename);
        log.Printf("Read %d characters", strings.Index(content, ""));
    } lekapothe {
        log.Warn("File not found, using defaults");
    }
    
    log.Info("Application completed");
}
```

## More Examples

Check the `examples/` directory in the repository for more complete examples:

- `hello.tl` - Basic hello world
- `factorial.tl` - Recursive functions
- `loops.tl` - Loop examples
- `io_example.tl` - File I/O examples
- `regexp_example.tl` - Regular expression examples
- `rand_example.tl` - Random number examples
- `log_example.tl` - Logging examples

## See Also

- [Tutorial](tutorial.md) - Step-by-step learning
- [Language Reference](language-reference.md) - Complete syntax reference
- [Standard Library](standard-library.md) - Library documentation
