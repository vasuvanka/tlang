// Loop examples - Go-style
// Go only has 'malli' loop (no while)

@fmt = #dhimpu("std/fmt");

#prarambham() {
    fmt.Printf("Malli loop: ");
    @i int = 0;
    malli i = 0; i < 5; i = i + 1 {
        fmt.Printf("%d ", i);
    }
    
    // Go-style infinite loop using malli
    fmt.Printf("\nInfinite loop (break after 3): ");
    @j int = 0;
    malli {
        okavela j >= 3 {
            agu;
        }
        fmt.Printf("%d ", j);
        j = j + 1;
    }
    fmt.Printf("\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\loops.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\loops.tl:11:14: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   11 |     malli i = 0; i < 5; i = i + 1 {
//    |    ^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\loops.tl` (exit code: 1)
//
