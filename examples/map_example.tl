// Map example - demonstrates map usage

@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("=== Map Example ===\n\n");
    
    // Create a map: jatha[string]int
    @scores jatha[string]int;
    
    // Set map values
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    scores["Charlie"] = 92;
    
    // Get map values
    @aliceScore int = scores["Alice"];
    @bobScore int = scores["Bob"];
    
    fmt.Printf("Scores:\n");
    fmt.Printf("  Alice: %d\n", aliceScore);
    fmt.Printf("  Bob: %d\n", bobScore);
    fmt.Printf("  Charlie: %d\n", scores["Charlie"]);
    
    fmt.Printf("\n=== Map Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.34s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_example.tl:14:22: Left side of assignment must be an identifier or member access
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   14 |     scores["Alice"] = 95;
//    |    ^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_example.tl` (exit code: 1)
//
