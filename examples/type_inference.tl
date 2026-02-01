// Type inference examples
// Demonstrates automatic type inference from values

@fmt = #dhimpu("std/fmt");

#prarambham() {
    // Integer inference
    @x = 10;
    fmt.Printf("x is inferred as int: %d\n", x);
    
    // Float inference
    @y = 3.14;
    fmt.Printf("y is inferred as float: %f\n", y);
    
    // String inference
    @name = "Tlang";
    fmt.Printf("name is inferred as string: %s\n", name);
    
    // Boolean inference
    @isActive = true;
    fmt.Printf("isActive is inferred as bool: ");
    okavela isActive {
        fmt.Printf("true\n");
    } lekapothe {
        fmt.Printf("false\n");
    }
    
    // Explicit types still work
    @count int = 42;
    fmt.Printf("count is explicitly int: %d\n", count);
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.34s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_inference.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_inference.tl:25:1: Expected field name in struct literal
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   25 |         fmt.Printf("true\n");
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_inference.tl` (exit code: 1)
//
