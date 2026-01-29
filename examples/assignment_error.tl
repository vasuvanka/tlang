// This file demonstrates assignment errors
// It should NOT compile successfully

#prarambham() {
    @x int = 10;
    x = 20;  // ERROR: Cannot assign to variable 'x': variables are immutable
    
    @y string = "hello";
    y = "world";  // ERROR: Cannot assign to variable 'y': variables are immutable
}

//

//

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\assignment_error.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\assignment_error.tl:6:8: Cannot assign to variable 'x': variables are immutable by default. Use '@!x' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   6 |     x = 20;  // ERROR: Cannot assign to variable 'x': variables are immutable
//    |    ^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\assignment_error.tl` (exit code: 1)
//
