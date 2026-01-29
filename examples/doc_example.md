# Documentation

Generated from: examples/doc_example.tl

 Documentation generation example
 Demonstrates doc library
 
 * This is a multi-line comment
 * that can be extracted as documentation
 
 This is a single-line comment for a function
 Add two numbers
 Read source file
 Extract comments
 Generate documentation
 Parse function documentation
 Write documentation to file



 === OUTPUT ===
 === Documentation Generation Examples ===

 Extracted Comments:
  Documentation generation example
  Demonstrates doc library

  * This is a multi-line comment
  * that can be extracted as documentation

  This is a single-line comment for a function
  Add two numbers
  Read source file
  Extract comments
  Generate documentation
  Parse function documentation
  Write documentation to file


  === OUTPUT ===
  ERROR: Execution failed
  COMPILATION ERROR:
  Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
  Compiling C to binary using gcc...

      Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.26s
       Running `target\debug\tlangc.exe compile 'C:\Users\vanka\github.com\vasuvanka\tlang\examples\doc_example.tl'`
  Ã¢Å“â€” C compilation failed:


  C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
  error: process didn't exit successfully: `target\debug\tlangc.exe compile 'C:\Users\vanka\github.com\vasuvanka\tlang\examples\doc_example.tl'` (exit code: 1)



 ---

 Generated Documentation:
 # Documentation

 Generated from: examples/doc_example.tl

  Documentation generation example
  Demonstrates doc library

  * This is a multi-line comment
  * that can be extracted as documentation

  This is a single-line comment for a function
  Add two numbers
  Read source file
  Extract comments
  Generate documentation
  Parse function documentation
  Write documentation to file


  === OUTPUT ===
  ERROR: Execution failed
  COMPILATION ERROR:
  Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
  Compiling C to binary using gcc...

      Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.26s
       Running `target\debug\tlangc.exe compile 'C:\Users\vanka\github.com\vasuvanka\tlang\examples\doc_example.tl'`
  Ã¢Å“â€” C compilation failed:


  C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
  error: process didn't exit successfully: `target\debug\tlangc.exe compile 'C:\Users\vanka\github.com\vasuvanka\tlang\examples\doc_example.tl'` (exit code: 1)



 ---

 Function 'add' documentation:
  This is a single-line comment for a function



 Wrote 1011 bytes to doc_example.md

