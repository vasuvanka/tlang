// Package visibility example - demonstrates Go-style exports
// Uppercase identifiers are exported (public), lowercase are unexported (private)

dhimpu "fmt" as fmt;

// Exported function (uppercase) - can be used by other packages
#Add(a int, b int) int {
    mallinchu a + b;
}

// Unexported function (lowercase) - only available within this package
#subtract(a int, b int) int {
    mallinchu a - b;
}

// Exported constant (uppercase)
@MaxValue int = 100;

// Unexported constant (lowercase)
@minValue int = 0;

// Exported variable (uppercase)
@Counter int = 0;

// Unexported variable (lowercase)
@internalCounter int = 0;

// Exported struct (uppercase)
nirmanam Point {
    @X int;
    @Y int;
}

// Unexported struct (lowercase)
nirmanam point {
    @x int;
    @y int;
}

#prarambham() {
    fmt.Printf("=== Package Visibility Example ===\n\n");
    
    // Can call exported function
    @result int = Add(5, 3);
    fmt.Printf("Add(5, 3) = %d\n", result);
    
    // Can call unexported function (within same package)
    @diff int = subtract(10, 4);
    fmt.Printf("subtract(10, 4) = %d\n", diff);
    
    // Can access exported constant
    fmt.Printf("MaxValue = %d\n", MaxValue);
    
    // Can access unexported constant (within same package)
    fmt.Printf("minValue = %d\n", minValue);
    
    fmt.Printf("\n=== Package Visibility Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_visibility_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_visibility_example.tl:32:1: Expected field name
//
//
//   32 |     @X int;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_visibility_example.tl` (exit code: 1)
//
