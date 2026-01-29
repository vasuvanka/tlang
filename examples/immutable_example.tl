// Immutable variables example
// Demonstrates that variables are immutable by default

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Immutable Variables Example ===\n\n");
    
    // Declare variables - they are immutable
    @x int = 10;
    @y int = 20;
    @name string = "Tlang";
    
    fmt.Printf("x = %d\n", x);
    fmt.Printf("y = %d\n", y);
    fmt.Printf("name = %s\n", name);
    
    // Variables cannot be reassigned - this would cause a compile error:
    // x = 30;  // ERROR: Cannot assign to variable 'x': variables are immutable
    
    // Instead, declare a new variable
    @x2 int = 30;
    fmt.Printf("x2 = %d\n", x2);
    
    // Variables cannot be redeclared in the same scope
    // @x int = 40;  // ERROR: Variable 'x' is already declared in this scope
    
    // Different scopes can have variables with the same name (shadowing)
    okavela x > 5 {
        @xInner int = 50;  // Use different name to avoid shadowing confusion
        fmt.Printf("xInner in if block = %d\n", xInner);
    }
    
    fmt.Printf("x in outer scope = %d\n", x);
    
    // Function parameters are also immutable
    @result int = add(x, y);
    fmt.Printf("Result: %d\n", result);
}

#add(a int, b int) int {
    // Parameters a and b are immutable
    // a = 100;  // ERROR: Cannot assign to parameter
    mallinchu a + b;
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
// Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// Compiling C to binary using gcc...
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\immutable_example.tl`
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\immutable_example.tl:45:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    45 |     // a = 100;  // ERROR: Cannot assign to parameter
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\immutable_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\immutable_example.tl:16:24: error: implicit declaration of function 'add' [-Wimplicit-function-declaration]
//    16 |     fmt.Printf("x = %d\n", x);
//       |                        ^~~
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\immutable_example.tl` (exit code: 1)
//
