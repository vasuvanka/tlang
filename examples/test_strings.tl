// Test cases for strings library

@fmt = #dhimpu("std/fmt");
@strings = #dhimpu("std/strings");

#prarambham() {
    fmt.Printf("=== strings Library Tests ===\n");
    
    @text string = "Hello World";
    @empty string = "";
    @longText string = "The quick brown fox jumps over the lazy dog";
    
    // Contains tests
    fmt.Printf("Contains('Hello'): %d\n", strings.Contains(text, "Hello"));
    fmt.Printf("Contains('World'): %d\n", strings.Contains(text, "World"));
    fmt.Printf("Contains('xyz'): %d\n", strings.Contains(text, "xyz"));
    fmt.Printf("Contains in empty: %d\n", strings.Contains(empty, "test"));
    
    // HasPrefix tests
    fmt.Printf("HasPrefix('Hello'): %d\n", strings.HasPrefix(text, "Hello"));
    fmt.Printf("HasPrefix('World'): %d\n", strings.HasPrefix(text, "World"));
    fmt.Printf("HasPrefix(''): %d\n", strings.HasPrefix(text, ""));
    
    // HasSuffix tests
    fmt.Printf("HasSuffix('World'): %d\n", strings.HasSuffix(text, "World"));
    fmt.Printf("HasSuffix('Hello'): %d\n", strings.HasSuffix(text, "Hello"));
    fmt.Printf("HasSuffix(''): %d\n", strings.HasSuffix(text, ""));
    
    // Index tests
    fmt.Printf("Index('World'): %d\n", strings.Index(text, "World"));
    fmt.Printf("Index('o'): %d\n", strings.Index(text, "o"));
    fmt.Printf("Index('xyz'): %d\n", strings.Index(text, "xyz"));
    fmt.Printf("Index(''): %d\n", strings.Index(text, ""));
    
    // ToUpper tests
    fmt.Printf("ToUpper: %s\n", strings.ToUpper(text));
    fmt.Printf("ToUpper lowercase: %s\n", strings.ToUpper("hello"));
    fmt.Printf("ToUpper mixed: %s\n", strings.ToUpper("HeLLo WoRLd"));
    
    // ToLower tests
    fmt.Printf("ToLower: %s\n", strings.ToLower(text));
    fmt.Printf("ToLower uppercase: %s\n", strings.ToLower("HELLO"));
    fmt.Printf("ToLower mixed: %s\n", strings.ToLower("HeLLo WoRLd"));
    
    // TrimSpace tests
    fmt.Printf("TrimSpace('  hello  '): '%s'\n", strings.TrimSpace("  hello  "));
    fmt.Printf("TrimSpace('\\thello\\t'): '%s'\n", strings.TrimSpace("	hello	"));
    fmt.Printf("TrimSpace('\\nworld\\n'): '%s'\n", strings.TrimSpace("\nworld\n"));
    fmt.Printf("TrimSpace('no spaces'): '%s'\n", strings.TrimSpace("no spaces"));
}

//

//

//

// === OUTPUT ===
// === strings Library Tests ===
// Contains('Hello'): 1
// Contains('World'): 1
// Contains('xyz'): 0
// Contains in empty: 0
// HasPrefix('Hello'): 1
// HasPrefix('World'): 0
// HasPrefix(''): 1
// HasSuffix('World'): 1
// HasSuffix('Hello'): 0
// HasSuffix(''): 1
// Index('World'): 6
// Index('o'): 4
// Index('xyz'): -1
// Index(''): 0
// ToUpper: HELLO WORLD
// ToUpper lowercase: HELLO
// ToUpper mixed: HELLO WORLD
// ToLower: hello world
// ToLower uppercase: hello
// ToLower mixed: hello world
// TrimSpace('  hello  '): 'hello'
// TrimSpace('\thello\t'): 'hello'
// TrimSpace('\nworld\n'): 'world'
// TrimSpace('no spaces'): 'no spaces'
//
