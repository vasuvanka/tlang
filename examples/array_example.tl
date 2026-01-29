// Array examples - Go-like array support in Tlang

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Array Examples ===\n\n");
    
    // Fixed-size array declaration
    fmt.Printf("--- Fixed-Size Arrays ---\n");
    @numbers [5]int = {1, 2, 3, 4, 5};
    fmt.Printf("Array: ");
    @!i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("%d ", numbers[i]);
    }
    fmt.Printf("\n");
    
    // Array with type inference
    fmt.Printf("\n--- Array Type Inference ---\n");
    @scores = {95, 87, 92, 78, 88};
    fmt.Printf("Scores: ");
    @!j int = 0;
    malli j < 5; j = j + 1 {
        fmt.Printf("%d ", scores[j]);
    }
    fmt.Printf("\n");
    
    // Array of strings
    fmt.Printf("\n--- String Arrays ---\n");
    @names [3]string = {"Alice", "Bob", "Charlie"};
    @!k int = 0;
    malli k < 3; k = k + 1 {
        fmt.Printf("Name[%d]: %s\n", k, names[k]);
    }
    
    // Array length using len()
    fmt.Printf("\n--- Array Length ---\n");
    @arr [10]int = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    @length int = len(arr);
    fmt.Printf("Array length: %d\n", length);
    
    // Array indexing
    fmt.Printf("\n--- Array Indexing ---\n");
    @first int = arr[0];
    @last int = arr[9];
    fmt.Printf("First element: %d\n", first);
    fmt.Printf("Last element: %d\n", last);
    
    // Array of floats
    fmt.Printf("\n--- Float Arrays ---\n");
    @prices [4]float = {10.5, 20.75, 30.25, 40.0};
    @!m int = 0;
    malli m < 4; m = m + 1 {
        fmt.Printf("Price[%d]: %.2f\n", m, prices[m]);
    }
    
    // Array operations
    fmt.Printf("\n--- Array Operations ---\n");
    @!sum int = 0;
    @!n int = 0;
    malli n < len(arr); n = n + 1 {
        sum = sum + arr[n];
    }
    fmt.Printf("Sum of array elements: %d\n", sum);
    
    // Array as function parameter (example)
    fmt.Printf("\n--- Array Usage ---\n");
    @data [5]int = {10, 20, 30, 40, 50};
    @avg float = (data[0] + data[1] + data[2] + data[3] + data[4]) / 5.0;
    fmt.Printf("Average: %.2f\n", avg);
    
    fmt.Printf("\n=== Array Examples Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// === Array Examples ===
//
// --- Fixed-Size Arrays ---
// Array: 2 
//
// --- Array Type Inference ---
// Scores: 87 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 92 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 78 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 88 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 0 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 3 
//
// --- Array Type Inference ---
// Scores: 87 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 92 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 78 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 88 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 0 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 4 
//
// --- Array Type Inference ---
// Scores: 87 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 92 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 78 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 88 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 0 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 5 
//
// --- Array Type Inference ---
// Scores: 87 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 92 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 78 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 88 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 0 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 470 
//
// --- Array Type Inference ---
// Scores: 87 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 92 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 78 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 88 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// 0 
//
// --- String Arrays ---
// Name[1]: Bob
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[2]: Charlie
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Name[3]: ‹ÇH‹\$0H‹t$8HƒÄ _ÃÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌH‰\$H‰t$WAVAWHƒì H‹L‹ñH‹H…Ò„ê
//
// --- Array Length ---
// Array length: 10
//
// --- Array Indexing ---
// First element: 1
// Last element: 10
//
// --- Float Arrays ---
// Price[1]: 20.75
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[2]: 30.25
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[3]: 40.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Price[4]: 0.00
//
// --- Array Operations ---
// Sum of array elements: 2
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 5
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 9
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 14
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 20
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 27
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 35
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 44
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 54
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
// Sum of array elements: 2079935052
//
// --- Array Usage ---
// Average: 30.00
//
// === Array Examples Complete ===
//
