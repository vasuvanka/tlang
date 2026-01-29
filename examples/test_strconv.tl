// Test cases for strconv library

dhimpu "fmt" as fmt;
dhimpu "strconv" as strconv;

#prarambham() {
    fmt.Printf("=== strconv Library Tests ===\n");

    // Atoi tests
    fmt.Printf("Atoi('123'): %d\n", strconv.Atoi("123"));
    fmt.Printf("Atoi('-456'): %d\n", strconv.Atoi("-456"));
    fmt.Printf("Atoi('0'): %d\n", strconv.Atoi("0"));
    fmt.Printf("Atoi('999'): %d\n", strconv.Atoi("999"));

    // Itoa tests
    fmt.Printf("Itoa(123): %s\n", strconv.Itoa(123));
    fmt.Printf("Itoa(-456): %s\n", strconv.Itoa(-456));
    fmt.Printf("Itoa(0): %s\n", strconv.Itoa(0));
    fmt.Printf("Itoa(999): %s\n", strconv.Itoa(999));

    // ParseFloat tests
    fmt.Printf("ParseFloat('3.14'): %f\n", strconv.ParseFloat("3.14"));
    fmt.Printf("ParseFloat('-2.5'): %f\n", strconv.ParseFloat("-2.5"));
    fmt.Printf("ParseFloat('0.0'): %f\n", strconv.ParseFloat("0.0"));
    fmt.Printf("ParseFloat('123.456'): %f\n", strconv.ParseFloat("123.456"));

    // FormatFloat tests
    fmt.Printf("FormatFloat(3.14, 2): %s\n", strconv.FormatFloat(3.14, 2));
    fmt.Printf("FormatFloat(3.14159, 3): %s\n", strconv.FormatFloat(3.14159, 3));
    fmt.Printf("FormatFloat(-2.5, 1): %s\n", strconv.FormatFloat(-2.5, 1));
    fmt.Printf("FormatFloat(0.0, 0): %s\n", strconv.FormatFloat(0.0, 0));

    // ParseBool tests
    fmt.Printf("ParseBool('true'): %d\n", strconv.ParseBool("true"));
    fmt.Printf("ParseBool('false'): %d\n", strconv.ParseBool("false"));
    fmt.Printf("ParseBool('1'): %d\n", strconv.ParseBool("1"));
    fmt.Printf("ParseBool('0'): %d\n", strconv.ParseBool("0"));
    fmt.Printf("ParseBool('TRUE'): %d\n", strconv.ParseBool("TRUE"));

    // FormatBool tests
    fmt.Printf("FormatBool(1): %s\n", strconv.FormatBool(1));
    fmt.Printf("FormatBool(0): %s\n", strconv.FormatBool(0));
    fmt.Printf("FormatBool(5): %s\n", strconv.FormatBool(5)); // Non-zero = true
}

//

//

//

// === OUTPUT ===
// === strconv Library Tests ===
// Atoi('123'): 123
// Atoi('-456'): -456
// Atoi('0'): 0
// Atoi('999'): 999
// Itoa(123): 123
// Itoa(-456): -456
// Itoa(0): 0
// Itoa(999): 999
// ParseFloat('3.14'): 3.140000
// ParseFloat('-2.5'): -2.500000
// ParseFloat('0.0'): 0.000000
// ParseFloat('123.456'): 123.456000
// FormatFloat(3.14, 2): 3.14
// FormatFloat(3.14159, 3): 3.142
// FormatFloat(-2.5, 1): -2.5
// FormatFloat(0.0, 0): 0
// ParseBool('true'): 1
// ParseBool('false'): 0
// ParseBool('1'): 1
// ParseBool('0'): 0
// ParseBool('TRUE'): -1
// FormatBool(1): true
// FormatBool(0): false
// FormatBool(5): true
//
