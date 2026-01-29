// Map iteration example

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Map Iteration Example ===\n\n");
    
    // Create a map: jatha[string]int
    @scores jatha[string]int = map_create(0, 0);
    
    // Add entries
    @k1 string = "Alice";
    @v1 int = 95;
    map_set(scores, &k1, &v1);
    
    @k2 string = "Bob";
    @v2 int = 87;
    map_set(scores, &k2, &v2);
    
    @k3 string = "Charlie";
    @v3 int = 92;
    map_set(scores, &k3, &v3);
    
    fmt.Printf("Map size: %d\n\n", len(scores));
    
    // Iterate with key and value
    fmt.Printf("All entries (key and value):\n");
    malli key, value := varasa scores {
        fmt.Printf("  %s: %d\n", key, value);
    }
    
    fmt.Printf("\n=== Map Iteration Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.33s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_iteration_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_iteration_example.tl:30:15: Unexpected token: Comma
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   30 |     malli key, value := varasa scores {
//    |    ^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_iteration_example.tl` (exit code: 1)
//
