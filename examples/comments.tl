// Comments example
// Demonstrates single-line and multi-line comments

@fmt = #dhimpu("std/fmt");

/* This is a multi-line comment
   that spans multiple lines
   and can contain anything */

// Package-level constants
@X int = 10; // Single-line comment after code

/* Single-line style multi-line comment */

@Y int = 20;

#prarambham() {
    /* Comment inside function */
    @sum int = X + Y;
    fmt.Printf("Sum: %d\n", sum);
}

//

//

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
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl`
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl:45:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    45 | // C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl: In function 'adhi':
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl:2:22: error: 'X' undeclared (first use in this function)
//     2 | // Demonstrates single-line and multi-line comments
//       |                      ^
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl:2:22: note: each undeclared identifier is reported only once for each function it appears in
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl:2:26: error: 'Y' undeclared (first use in this function); did you mean 'CY'?
//     2 | // Demonstrates single-line and multi-line comments
//       |                          ^
//       |                          CY
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\comments.tl` (exit code: 1)
//
