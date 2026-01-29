// Interface example - demonstrates interface definitions and usage

dhimpu "fmt" as fmt;

// Define an interface for shapes that can calculate area
interface Shape {
    Area() float;
    Perimeter() float;
}

// Define a Rectangle struct
nirmanam Rectangle {
    width float;
    height float;
}

// Define a Circle struct
nirmanam Circle {
    radius float;
}

// Function to calculate rectangle area
#Rectangle_Area(rect *Rectangle) float {
    mallinchu rect.width * rect.height;
}

// Function to calculate rectangle perimeter
#Rectangle_Perimeter(rect *Rectangle) float {
    mallinchu 2.0 * (rect.width + rect.height);
}

// Function to calculate circle area
#Circle_Area(circle *Circle) float {
    mallinchu 3.14159 * circle.radius * circle.radius;
}

// Function to calculate circle perimeter
#Circle_Perimeter(circle *Circle) float {
    mallinchu 2.0 * 3.14159 * circle.radius;
}

#prarambham() {
    fmt.Printf("=== Interface Example ===\n\n");
    
    // Create a rectangle
    @rect Rectangle = Rectangle{width: 5.0, height: 3.0};
    
    // Create a circle
    @circle Circle = Circle{radius: 2.5};
    
    // Calculate areas using interface methods
    @rectArea float = Rectangle_Area(&rect);
    @rectPerimeter float = Rectangle_Perimeter(&rect);
    
    @circleArea float = Circle_Area(&circle);
    @circlePerimeter float = Circle_Perimeter(&circle);
    
    fmt.Printf("Rectangle:\n");
    fmt.Printf("  Area: %.2f\n", rectArea);
    fmt.Printf("  Perimeter: %.2f\n", rectPerimeter);
    
    fmt.Printf("\nCircle:\n");
    fmt.Printf("  Area: %.2f\n", circleArea);
    fmt.Printf("  Perimeter: %.2f\n", circlePerimeter);
    
    fmt.Printf("\n=== Interface Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_example.tl:9:1: Expected method name in interface
//
//
//   9 |     Area() float;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_example.tl` (exit code: 1)
//
