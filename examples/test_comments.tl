/* Multi-line comment test */
@ x int = 10;
@ y int = 20;
@ result int = x + y; /* inline comment */
#prarambham() {
    fmt.Printf("%d\n", result);
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_comments.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_comments.tl:2:2: Expected variable name after '@'
//
//
//   2 | @ x int = 10;
//    |    ^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_comments.tl` (exit code: 1)
//
