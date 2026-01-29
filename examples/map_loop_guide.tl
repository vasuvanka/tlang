// Complete guide to looping over maps in Tlang

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Map Looping Guide ===\n\n");
    
    // Create a map: jatha[string]int
    @scores jatha[string]int = map_create(0, 0);
    
    // Add some entries
    @k1 string = "Alice";
    @v1 int = 95;
    map_set(scores, &k1, &v1);
    
    @k2 string = "Bob";
    @v2 int = 87;
    map_set(scores, &k2, &v2);
    
    @k3 string = "Charlie";
    @v3 int = 92;
    map_set(scores, &k3, &v3);
    
    @k4 string = "Diana";
    @v4 int = 88;
    map_set(scores, &k4, &v4);
    
    fmt.Printf("Map has %d entries\n\n", len(scores));
    
    // ============================================
    // Method 1: Range loop with key and value
    // ============================================
    fmt.Printf("Method 1: Iterate with key and value\n");
    malli key, value := varasa scores {
        fmt.Printf("  %s scored %d\n", key, value);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Method 2: Range loop with key only
    // ============================================
    fmt.Printf("Method 2: Iterate with key only\n");
    malli key := varasa scores {
        @score int = *(int*)map_get(scores, &key);
        fmt.Printf("  %s: %d\n", key, score);
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Method 3: Filter during iteration
    // ============================================
    fmt.Printf("Method 3: Filter entries (scores >= 90)\n");
    malli key, value := varasa scores {
        okavela value >= 90 {
            fmt.Printf("  High score: %s with %d\n", key, value);
        }
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Method 4: Calculate sum during iteration
    // ============================================
    fmt.Printf("Method 4: Calculate total score\n");
    @total int = 0;
    malli key, value := varasa scores {
        total = total + value;
    }
    fmt.Printf("  Total: %d\n", total);
    fmt.Printf("  Average: %d\n", total / len(scores));
    
    fmt.Printf("\n");
    
    // ============================================
    // Method 5: Modify map during iteration
    // ============================================
    fmt.Printf("Method 5: Add bonus points\n");
    malli key, value := varasa scores {
        @newValue int = value + 5;
        map_set(scores, &key, &newValue);
    }
    
    fmt.Printf("Updated scores:\n");
    malli key, value := varasa scores {
        fmt.Printf("  %s: %d\n", key, value);
    }
    
    fmt.Printf("\n=== Map Looping Guide Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.32s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_loop_guide.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_loop_guide.tl:36:15: Unexpected token: Comma
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   36 |     malli key, value := varasa scores {
//    |    ^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\map_loop_guide.tl` (exit code: 1)
//
