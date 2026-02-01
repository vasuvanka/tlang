// regexp library example
// Demonstrates regular expression operations

@fmt = #dhimpu("std/fmt");
@regexp = #dhimpu("std/regexp");

#prarambham() {
    fmt.Printf("=== regexp Library Examples ===\n\n");
    
    @text string = "The quick brown fox jumps over the lazy dog";
    @email string = "contact@example.com";
    @numbers string = "abc123def456ghi789";
    @spaces string = "hello   world    test";
    
    // Match - Check if pattern matches
    fmt.Printf("--- Match Tests ---\n");
    @match1 int = regexp.Match("fox", text);
    @match2 int = regexp.Match("cat", text);
    @match3 int = regexp.Match("[0-9]+", numbers);
    @match4 int = regexp.Match("^[a-z]+@[a-z]+\\.[a-z]+$", email);
    
    fmt.Printf("Match('fox' in text): %d (expected: 1)\n", match1);
    fmt.Printf("Match('cat' in text): %d (expected: 0)\n", match2);
    fmt.Printf("Match('[0-9]+' in numbers): %d (expected: 1)\n", match3);
    fmt.Printf("Match(email pattern): %d (expected: 1)\n", match4);
    
    // Find - Find first match
    fmt.Printf("\n--- Find Tests ---\n");
    @find1 string = regexp.Find("[a-z]{4}", text);
    @find2 string = regexp.Find("[0-9]+", numbers);
    @find3 string = regexp.Find("@[a-z]+", email);
    
    fmt.Printf("Find('[a-z]{4}' in text): %s\n", find1);
    fmt.Printf("Find('[0-9]+' in numbers): %s (expected: '123')\n", find2);
    fmt.Printf("Find('@[a-z]+' in email): %s\n", find3);
    
    // FindAll - Find all matches
    fmt.Printf("\n--- FindAll Tests ---\n");
    @findAll1 string = regexp.FindAll("[0-9]+", numbers, 10);
    @findAll2 string = regexp.FindAll("[a-z]{4,}", text, 10);
    
    fmt.Printf("FindAll('[0-9]+' in numbers):\n%s\n", findAll1);
    fmt.Printf("FindAll('[a-z]{4,}' in text):\n%s\n", findAll2);
    
    // Replace - Replace first match
    fmt.Printf("\n--- Replace Tests ---\n");
    @replace1 string = regexp.Replace("fox", text, "cat");
    @replace2 string = regexp.Replace("[0-9]+", numbers, "XXX");
    
    fmt.Printf("Replace('fox' -> 'cat'): %s\n", replace1);
    fmt.Printf("Replace('[0-9]+' -> 'XXX'): %s\n", replace2);
    
    // ReplaceAll - Replace all matches
    fmt.Printf("\n--- ReplaceAll Tests ---\n");
    @replaceAll1 string = regexp.ReplaceAll("\\s+", spaces, " ");
    @replaceAll2 string = regexp.ReplaceAll("[0-9]+", numbers, "N");
    @replaceAll3 string = regexp.ReplaceAll("[aeiou]", text, "*");
    
    fmt.Printf("ReplaceAll('\\\\s+' -> ' '): '%s'\n", replaceAll1);
    fmt.Printf("ReplaceAll('[0-9]+' -> 'N'): %s\n", replaceAll2);
    fmt.Printf("ReplaceAll('[aeiou]' -> '*'): %s\n", replaceAll3);
    
    // Split - Split by pattern
    fmt.Printf("\n--- Split Tests ---\n");
    @split1 string = regexp.Split("\\s+", text);
    @split2 string = regexp.Split("[0-9]+", numbers);
    @split3 string = regexp.Split(",", "apple,banana,cherry");
    
    fmt.Printf("Split by '\\\\s+':\n%s\n", split1);
    fmt.Printf("Split by '[0-9]+':\n%s\n", split2);
    fmt.Printf("Split by ',':\n%s\n", split3);
    
    // Email validation example
    fmt.Printf("\n--- Email Validation Example ---\n");
    @email1 string = "user@example.com";
    @email2 string = "invalid.email";
    @email3 string = "test@domain.co.uk";
    
    @valid1 int = regexp.Match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email1);
    @valid2 int = regexp.Match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email2);
    @valid3 int = regexp.Match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email3);
    
    fmt.Printf("Email '%s' valid: %d\n", email1, valid1);
    fmt.Printf("Email '%s' valid: %d\n", email2, valid2);
    fmt.Printf("Email '%s' valid: %d\n", email3, valid3);
    
    // Phone number extraction
    fmt.Printf("\n--- Phone Number Extraction ---\n");
    @phoneText string = "Call me at 123-456-7890 or 987-654-3210";
    @phonePattern string = "[0-9]{3}-[0-9]{3}-[0-9]{4}";
    @phones string = regexp.FindAll(phonePattern, phoneText, 10);
    
    fmt.Printf("Phone numbers found:\n%s\n", phones);
}

//

//

//

// === OUTPUT ===
// === regexp Library Examples ===
//
// --- Match Tests ---
// Match('fox' in text): 0 (expected: 1)
// Match('cat' in text): 0 (expected: 0)
// Match('[0-9]+' in numbers): 0 (expected: 1)
// Match(email pattern): 0 (expected: 1)
//
// --- Find Tests ---
// Find('[a-z]{4}' in text): 
// Find('[0-9]+' in numbers):  (expected: '123')
// Find('@[a-z]+' in email): 
//
// --- FindAll Tests ---
// FindAll('[0-9]+' in numbers):
//
// FindAll('[a-z]{4,}' in text):
//
//
// --- Replace Tests ---
// Replace('fox' -> 'cat'): abc123def456ghi789
// Replace('[0-9]+' -> 'XXX'): abc123def456ghi789
//
// --- ReplaceAll Tests ---
// ReplaceAll('\\s+' -> ' '): 'The quick brown fox jumps over the lazy dog'
// ReplaceAll('[0-9]+' -> 'N'): The quick brown fox jumps over the lazy dog
// ReplaceAll('[aeiou]' -> '*'): The quick brown fox jumps over the lazy dog
//
// --- Split Tests ---
// Split by '\\s+':
// apple,banana,cherry
// Split by '[0-9]+':
// apple,banana,cherry
// Split by ',':
// apple,banana,cherry
//
// --- Email Validation Example ---
// Email 'user@example.com' valid: 0
// Email 'invalid.email' valid: 0
// Email 'test@domain.co.uk' valid: 0
//
// --- Phone Number Extraction ---
// Phone numbers found:
//
//
