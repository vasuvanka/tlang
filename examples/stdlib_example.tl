// Standard Library Examples
// Function names use dot notation (e.g., fmt.Printf, math.Sqrt)

dhimpu "fmt" as fmt;
dhimpu "strings" as strings;
dhimpu "math" as math;
dhimpu "strconv" as strconv;

#prarambham() {
    // fmt library
    fmt.Printf("Hello from fmt.Printf! Number: %d\n", 42);
    
    // strings library
    @text string = "Hello World";
    @upper string = strings.ToUpper(text);
    @lower string = strings.ToLower(text);
    @hasHello int = strings.Contains(text, "Hello");
    
    fmt.Printf("Original: %s\n", text);
    fmt.Printf("Upper: %s\n", upper);
    fmt.Printf("Lower: %s\n", lower);
    fmt.Printf("Contains 'Hello': %d\n", hasHello);
    
    // math library
    @sqrt float = math.Sqrt(16.0);
    @power float = math.Pow(2.0, 3.0);
    @pi float = math.Pi();
    
    fmt.Printf("Square root of 16: %f\n", sqrt);
    fmt.Printf("2^3: %f\n", power);
    fmt.Printf("Pi: %f\n", pi);
    
    // strconv library
    @numStr string = "123";
    @num int = strconv.Atoi(numStr);
    @numBack string = strconv.Itoa(num);
    
    fmt.Printf("String to int: %d\n", num);
    fmt.Printf("Int to string: %s\n", numBack);
    
    // time library
    @now long = time.Now();
    @formatted string = time.Format(now, "%Y-%m-%d %H:%M:%S");
    
    fmt.Printf("Current time: %ld\n", now);
    fmt.Printf("Formatted: %s\n", formatted);
}

//

//

//

// === OUTPUT ===
// Hello from fmt.Printf! Number: 42
// Original: Hello World
// Upper: HELLO WORLD
// Lower: hello world
// Contains 'Hello': 1
// Square root of 16: 4.000000
// 2^3: 8.000000
// Pi: 3.141593
// String to int: 123
// Int to string: 123
// Current time: 1769532929
// Formatted: 2026-01-27 22:25:29
//
