// Struct example - demonstrates struct definition and usage

@fmt = #dhimpu("std/fmt");

// Define a Person struct
nirmanam Person {
    name string;
    age int;
    email string;
}

// Define a Point struct
nirmanam Point {
    x float;
    y float;
}

#prarambham() {
    fmt.Printf("=== Struct Example ===\n\n");
    
    // Create a Person struct
    @person Person = Person{name: "Alice", age: 30, email: "alice@example.com"};
    
    fmt.Printf("Person:\n");
    fmt.Printf("  Name: %s\n", person.name);
    fmt.Printf("  Age: %d\n", person.age);
    fmt.Printf("  Email: %s\n", person.email);
    
    fmt.Printf("\n");
    
    // Create a Point struct
    @point Point = Point{x: 3.5, y: 7.2};
    
    fmt.Printf("Point:\n");
    fmt.Printf("  X: %.2f\n", point.x);
    fmt.Printf("  Y: %.2f\n", point.y);
    
    fmt.Printf("\n=== Struct Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.32s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\struct_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\struct_example.tl:9:1: Expected field name
//
//
//   9 |     name string;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\struct_example.tl` (exit code: 1)
//
