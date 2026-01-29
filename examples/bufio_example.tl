// bufio library example
// Demonstrates buffered I/O operations

dhimpu "fmt" as fmt;
dhimpu "bufio" as bufio;
dhimpu "io" as io;
dhimpu "strings" as strings;

#prarambham() {
    fmt.Printf("=== bufio Library Examples ===\n\n");
    
    // Create test file
    fmt.Printf("--- Creating Test File ---\n");
    @testData string = "Line 1\nLine 2\nLine 3\nEnd of file";
    io.WriteFile("test_bufio.txt", testData);
    fmt.Printf("Created test_bufio.txt\n");
    
    // Buffered reading
    fmt.Printf("\n--- Buffered Reading ---\n");
    @reader int = bufio.NewReader("test_bufio.txt");
    okavela reader >= 0 {
        @line1 string = bufio.ReadLine(reader);
        @line2 string = bufio.ReadLine(reader);
        @line3 string = bufio.ReadLine(reader);
        @line4 string = bufio.ReadLine(reader);
        
        fmt.Printf("Line 1: %s\n", line1);
        fmt.Printf("Line 2: %s\n", line2);
        fmt.Printf("Line 3: %s\n", line3);
        fmt.Printf("Line 4: %s\n", line4);
        
        bufio.Close(reader);
    } lekapothe {
        fmt.Printf("Failed to open file\n");
    }
    
    // Read until delimiter
    fmt.Printf("\n--- Read Until Delimiter ---\n");
    @reader2 int = bufio.NewReader("test_bufio.txt");
    okavela reader2 >= 0 {
        @data1 string = bufio.ReadBytes(reader2, 10);  // Read until newline (ASCII 10)
        fmt.Printf("Read until newline: %s\n", data1);
        bufio.Close(reader2);
    }
    
    // Buffered writing
    fmt.Printf("\n--- Buffered Writing ---\n");
    @writer int = bufio.NewWriter("output_bufio.txt");
    okavela writer >= 0 {
        @written1 int = bufio.Write(writer, "Hello ");
        @written2 int = bufio.Write(writer, "World!\n");
        @written3 int = bufio.Write(writer, "This is line 2\n");
        
        fmt.Printf("Wrote %d + %d + %d bytes\n", written1, written2, written3);
        
        bufio.Flush(writer);
        bufio.Close(writer);
        
        fmt.Printf("Data flushed and file closed\n");
        
        // Read back
        @content string = io.ReadFile("output_bufio.txt");
        fmt.Printf("File content:\n%s\n", content);
    } lekapothe {
        fmt.Printf("Failed to create writer\n");
    }
    
    // Line-by-line processing
    fmt.Printf("\n--- Line-by-Line Processing ---\n");
    @reader3 int = bufio.NewReader("test_bufio.txt");
    okavela reader3 >= 0 {
        @lineCount int = 0;
        @line string = "";
        malli {
            line = bufio.ReadLine(reader3);
            okavela strings.Index(line, "") == 0 {
                agu;  // Empty line means EOF
            }
            lineCount = lineCount + 1;
            fmt.Printf("Line %d: %s\n", lineCount, line);
        }
        fmt.Printf("Total lines: %d\n", lineCount);
        bufio.Close(reader3);
    }
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\bufio_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\bufio_example.tl:77:19: Cannot assign to variable 'line': variables are immutable by default. Use '@!line' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   77 |             line = bufio.ReadLine(reader3);
//    |    ^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\bufio_example.tl` (exit code: 1)
//
