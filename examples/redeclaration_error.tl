// This file demonstrates redeclaration errors
// It should NOT compile successfully

#prarambham() {
    @x int = 10;
    @x int = 20;  // ERROR: Variable 'x' is already declared in this scope
    
    @y int = 30;
    @y string = "hello";  // ERROR: Variable 'y' is already declared in this scope
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\redeclaration_error.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\redeclaration_error.tl:6:11: Variable 'x' is already declared in this scope
//
// Context (most recent call last):
//   1: while parsing variable declaration
//   2: while parsing function declaration
//
//
//   6 |     @x int = 20;  // ERROR: Variable 'x' is already declared in this scope
//    |    ^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\redeclaration_error.tl` (exit code: 1)
//
