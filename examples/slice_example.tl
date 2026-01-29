// Slice examples - Variable-size arrays (slices) in Tlang

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Slice Examples ===\n\n");
    
    // Slice declaration with type
    fmt.Printf("--- Slice Declaration ---\n");
    @numbers []int = {1, 2, 3, 4, 5};
    fmt.Printf("Slice length: %d\n", len(numbers));
    
    // Slice with type inference
    fmt.Printf("\n--- Slice Type Inference ---\n");
    @scores = {95, 87, 92, 78, 88};
    fmt.Printf("Scores slice length: %d\n", len(scores));
    
    // Empty slice
    fmt.Printf("\n--- Empty Slice ---\n");
    @empty []int;
    fmt.Printf("Empty slice length: %d (expected: 0)\n", len(empty));
    
    // Slice indexing
    fmt.Printf("\n--- Slice Indexing ---\n");
    @data []int = {10, 20, 30, 40, 50};
    @first int = data[0];
    @second int = data[1];
    fmt.Printf("First element: %d\n", first);
    fmt.Printf("Second element: %d\n", second);
    
    // Slice operations
    fmt.Printf("\n--- Slice Operations ---\n");
    @arr []int = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    fmt.Printf("Original slice length: %d\n", len(arr));
    
    // Slice expression [start:end]
    fmt.Printf("\n--- Slice Expressions ---\n");
    // Note: Slice expressions like arr[1:3] will be supported
    // For now, we demonstrate basic slice usage
    
    // Append to slice
    fmt.Printf("\n--- Append to Slice ---\n");
    @items []int = {1, 2, 3};
    fmt.Printf("Before append, length: %d\n", len(items));
    @items2 []int = append(items, 4);
    fmt.Printf("After append, length: %d\n", len(items2));
    
    // String slices
    fmt.Printf("\n--- String Slices ---\n");
    @names []string = {"Alice", "Bob", "Charlie"};
    @i int = 0;
    malli i < len(names); i = i + 1 {
        fmt.Printf("Name[%d]: %s\n", i, names[i]);
    }
    
    // Slice capacity
    fmt.Printf("\n--- Slice Capacity ---\n");
    @slice []int = {1, 2, 3};
    fmt.Printf("Slice length: %d\n", len(slice));
    fmt.Printf("Slice capacity: %d\n", cap(slice));
    
    // Slice from array
    fmt.Printf("\n--- Slice from Array ---\n");
    @fixedArray [5]int = {10, 20, 30, 40, 50};
    // Convert array to slice (conceptual - in Go this is automatic)
    fmt.Printf("Fixed array length: %d\n", len(fixedArray));
    
    fmt.Printf("\n=== Slice Examples Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.27s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\slice_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\slice_example.tl:54:30: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   54 |     malli i < len(names); i = i + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\slice_example.tl` (exit code: 1)
//
