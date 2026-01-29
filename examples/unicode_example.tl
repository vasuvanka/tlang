// unicode library example
// Demonstrates Unicode character classification and manipulation

dhimpu "fmt" as fmt;
dhimpu "unicode" as unicode;

#prarambham() {
    fmt.Printf("=== unicode Library Examples ===\n\n");
    
    // Character classification
    fmt.Printf("--- Character Classification ---\n");
    @ch1 int = 65;  // 'A'
    @ch2 int = 97;  // 'a'
    @ch3 int = 48;  // '0'
    @ch4 int = 32;  // ' ' (space)
    
    @isLetter1 int = unicode.IsLetter(ch1);
    @isLetter2 int = unicode.IsLetter(ch2);
    @isDigit int = unicode.IsDigit(ch3);
    @isSpace int = unicode.IsSpace(ch4);
    
    fmt.Printf("'%c' is letter: %d (expected: 1)\n", ch1, isLetter1);
    fmt.Printf("'%c' is letter: %d (expected: 1)\n", ch2, isLetter2);
    fmt.Printf("'%c' is digit: %d (expected: 1)\n", ch3, isDigit);
    fmt.Printf("'%c' is space: %d (expected: 1)\n", ch4, isSpace);
    
    // Case conversion
    fmt.Printf("\n--- Case Conversion ---\n");
    @lower int = 97;  // 'a'
    @upper int = 65;  // 'A'
    
    @toUpper int = unicode.ToUpper(lower);
    @toLower int = unicode.ToLower(upper);
    
    fmt.Printf("'%c' to upper: '%c'\n", lower, toUpper);
    fmt.Printf("'%c' to lower: '%c'\n", upper, toLower);
    
    // Case checking
    fmt.Printf("\n--- Case Checking ---\n");
    @ch5 int = 90;  // 'Z'
    @ch6 int = 122; // 'z'
    
    @isUpper1 int = unicode.IsUpper(ch5);
    @isUpper2 int = unicode.IsUpper(ch6);
    @isLower1 int = unicode.IsLower(ch5);
    @isLower2 int = unicode.IsLower(ch6);
    
    fmt.Printf("'%c' is upper: %d (expected: 1)\n", ch5, isUpper1);
    fmt.Printf("'%c' is upper: %d (expected: 0)\n", ch6, isUpper2);
    fmt.Printf("'%c' is lower: %d (expected: 0)\n", ch5, isLower1);
    fmt.Printf("'%c' is lower: %d (expected: 1)\n", ch6, isLower2);
    
    // Character validation example
    fmt.Printf("\n--- Character Validation ---\n");
    @testChars string = "A1a 0";
    fmt.Printf("Testing characters in: %s\n", testChars);
    fmt.Printf("Note: Character-by-character processing requires string indexing support\n");
}

//

//

//

// === OUTPUT ===
// === unicode Library Examples ===
//
// --- Character Classification ---
// 'A' is letter: 1 (expected: 1)
// 'a' is letter: 1 (expected: 1)
// '0' is digit: 1 (expected: 1)
// ' ' is space: 1 (expected: 1)
//
// --- Case Conversion ---
// 'a' to upper: 'A'
// 'A' to lower: 'a'
//
// --- Case Checking ---
// 'Z' is upper: 1 (expected: 1)
// 'z' is upper: 0 (expected: 0)
// 'Z' is lower: 0 (expected: 0)
// 'z' is lower: 1 (expected: 1)
//
// --- Character Validation ---
// Testing characters in: A1a 0
// Note: Character-by-character processing requires string indexing support
//
