// Map operations example - demonstrates delete(), len(), and iteration

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Map Operations Example ===\n\n");
    
    // Create a map: jatha[string]int
    @scores jatha[string]int = map_create(0, 0);  // 0=string key, 0=int value
    
    // Set map values
    @key1 string = "Alice";
    @val1 int = 95;
    map_set(scores, &key1, &val1);
    
    @key2 string = "Bob";
    @val2 int = 87;
    map_set(scores, &key2, &val2);
    
    @key3 string = "Charlie";
    @val3 int = 92;
    map_set(scores, &key3, &val3);
    
    fmt.Printf("Initial map:\n");
    fmt.Printf("  Length: %d\n", len(scores));
    fmt.Printf("  Alice: %d\n", *(int*)map_get(scores, &key1));
    fmt.Printf("  Bob: %d\n", *(int*)map_get(scores, &key2));
    fmt.Printf("  Charlie: %d\n", *(int*)map_get(scores, &key3));
    
    fmt.Printf("\n");
    
    // Delete a key
    delete(scores, "Bob");
    fmt.Printf("After deleting Bob:\n");
    fmt.Printf("  Length: %d\n", len(scores));
    
    fmt.Printf("\n");
    
    // Iterate over map
    fmt.Printf("Iterating over map:\n");
    malli key, value := varasa scores {
        fmt.Printf("  %s: %d\n", key, value);
    }
    
    fmt.Printf("\n=== Map Operations Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_operations_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_operations_example.tl:28:38: Unexpected token: IntType
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   28 |     fmt.Printf("  Alice: %d\n", *(int*)map_get(scores, &key1));
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_operations_example.tl` (exit code: 1)
//
