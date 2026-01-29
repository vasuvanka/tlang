// rand library example
// Demonstrates random number generation, UUID, and random strings

dhimpu "fmt" as fmt;
dhimpu "rand" as rand;
dhimpu "strings" as strings;

#prarambham() {
    fmt.Printf("=== rand Library Examples ===\n\n");
    
    // Seed the random number generator (optional)
    rand.Seed(12345);
    
    // Int - Random integer
    fmt.Printf("--- Random Integers ---\n");
    @rand1 int = rand.Int();
    @rand2 int = rand.Int();
    fmt.Printf("Random integer 1: %d\n", rand1);
    fmt.Printf("Random integer 2: %d\n", rand2);
    
    // Intn - Random integer in range [0, n)
    fmt.Printf("\n--- Random Integers in Range ---\n");
    @dice int = rand.Intn(6) + 1; // Simulate dice roll (1-6)
    @lottery int = rand.Intn(100); // Random number 0-99
    fmt.Printf("Dice roll: %d\n", dice);
    fmt.Printf("Lottery number (0-99): %d\n", lottery);
    
    // Float64 - Random float in [0.0, 1.0)
    fmt.Printf("\n--- Random Floats ---\n");
    @float1 float = rand.Float64();
    @float2 float = rand.Float64();
    fmt.Printf("Random float 1: %f\n", float1);
    fmt.Printf("Random float 2: %f\n", float2);
    
    // Float64Range - Random float in range
    fmt.Printf("\n--- Random Floats in Range ---\n");
    @temp float = rand.Float64Range(20.0, 30.0); // Temperature between 20-30
    @price float = rand.Float64Range(10.0, 100.0); // Price between 10-100
    fmt.Printf("Temperature (20-30): %f\n", temp);
    fmt.Printf("Price (10-100): %f\n", price);
    
    // UUID - Generate UUID v4
    fmt.Printf("\n--- UUID Generation ---\n");
    @uuid1 string = rand.UUID();
    @uuid2 string = rand.UUID();
    @uuid3 string = rand.UUID();
    fmt.Printf("UUID 1: %s\n", uuid1);
    fmt.Printf("UUID 2: %s\n", uuid2);
    fmt.Printf("UUID 3: %s\n", uuid3);
    
    // Verify UUID format (should be 36 characters with dashes)
    @uuidLen int = strings.Index(uuid1, "");
    fmt.Printf("UUID length: %d (expected: 36)\n", uuidLen);
    @hasDashes int = strings.Contains(uuid1, "-");
    fmt.Printf("Has dashes: %d (expected: 1)\n", hasDashes);
    
    // RandomString - Generate random strings
    fmt.Printf("\n--- Random String Generation ---\n");
    @str8 string = rand.RandomString(8);
    @str16 string = rand.RandomString(16);
    @str32 string = rand.RandomString(32);
    @str64 string = rand.RandomString(64);
    
    fmt.Printf("Random string (8 chars): %s\n", str8);
    fmt.Printf("Random string (16 chars): %s\n", str16);
    fmt.Printf("Random string (32 chars): %s\n", str32);
    fmt.Printf("Random string (64 chars): %s\n", str64);
    
    // Generate multiple random strings
    fmt.Printf("\n--- Multiple Random Strings ---\n");
    @i int = 0;
    malli i = 0; i < 5; i = i + 1 {
        @random string = rand.RandomString(12);
        fmt.Printf("Random string %d: %s\n", i + 1, random);
    }
    
    // Seed example - same seed produces same sequence
    fmt.Printf("\n--- Seed Example ---\n");
    rand.Seed(42);
    @seq1 int = rand.Intn(100);
    @seq2 int = rand.Intn(100);
    @seq3 int = rand.Intn(100);
    
    rand.Seed(42); // Reset to same seed
    @seq1b int = rand.Intn(100);
    @seq2b int = rand.Intn(100);
    @seq3b int = rand.Intn(100);
    
    fmt.Printf("Sequence with seed 42: %d, %d, %d\n", seq1, seq2, seq3);
    fmt.Printf("Sequence with seed 42 (reset): %d, %d, %d\n", seq1b, seq2b, seq3b);
    @match1 int = (seq1 == seq1b);
    @match2 int = (seq2 == seq2b);
    @match3 int = (seq3 == seq3b);
    fmt.Printf("First values match: %d (expected: 1)\n", match1);
    fmt.Printf("Second values match: %d (expected: 1)\n", match2);
    fmt.Printf("Third values match: %d (expected: 1)\n", match3);
    
    // Practical examples
    fmt.Printf("\n--- Practical Examples ---\n");
    
    // Generate session ID
    @sessionId string = rand.RandomString(32);
    fmt.Printf("Session ID: %s\n", sessionId);
    
    // Generate API key
    @apiKey string = rand.RandomString(64);
    fmt.Printf("API Key: %s\n", apiKey);
    
    // Generate transaction ID (UUID)
    @txnId string = rand.UUID();
    fmt.Printf("Transaction ID: %s\n", txnId);
    
    // Random password
    @password string = rand.RandomString(16);
    fmt.Printf("Random password: %s\n", password);
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\rand_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\rand_example.tl:74:14: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   74 |     malli i = 0; i < 5; i = i + 1 {
//    |    ^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\rand_example.tl` (exit code: 1)
//
