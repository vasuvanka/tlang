// Example showing how to import and use exported identifiers from another package

dhimpu "fmt" as fmt;
dhimpu "./utils" as utils;

#prarambham() {
    fmt.Printf("=== Package Import Example ===\n\n");
    
    // Can call exported function from utils package
    @sum int = utils.Add(10, 20);
    fmt.Printf("utils.Add(10, 20) = %d\n", sum);
    
    // Can access exported constant
    fmt.Printf("utils.MaxValue = %d\n", utils.MaxValue);
    
    // Can use exported struct
    @p utils.Point;
    p.X = 5;
    p.Y = 10;
    fmt.Printf("Point: X=%d, Y=%d\n", p.X, p.Y);
    
    // ERROR: Cannot access unexported identifiers from another package
    // The following would cause compilation errors:
    // utils.subtract(10, 5);  // Error: unexported function
    // utils.minValue;         // Error: unexported constant
    // utils.internalCounter;  // Error: unexported variable
    // utils.point;            // Error: unexported struct
    
    fmt.Printf("\n=== Package Import Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_import_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_import_example.tl:19:14: Unexpected token: Dot
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   19 |     @p utils.Point;
//    |    ^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\package_import_example.tl` (exit code: 1)
//
