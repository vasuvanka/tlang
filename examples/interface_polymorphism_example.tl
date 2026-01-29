// Interface polymorphism example

dhimpu "fmt" as fmt;

// Define an interface for geometric shapes
interface Shape {
    Area() float;
    Perimeter() float;
    Name() string;
}

// Rectangle struct
nirmanam Rectangle {
    width float;
    height float;
}

// Circle struct
nirmanam Circle {
    radius float;
}

// Rectangle methods
#Rectangle_Area(rect *Rectangle) float {
    mallinchu rect.width * rect.height;
}

#Rectangle_Perimeter(rect *Rectangle) float {
    mallinchu 2.0 * (rect.width + rect.height);
}

#Rectangle_Name(rect *Rectangle) string {
    mallinchu "Rectangle";
}

// Circle methods
#Circle_Area(circle *Circle) float {
    mallinchu 3.14159 * circle.radius * circle.radius;
}

#Circle_Perimeter(circle *Circle) float {
    mallinchu 2.0 * 3.14159 * circle.radius;
}

#Circle_Name(circle *Circle) string {
    mallinchu "Circle";
}

// Function that works with any Shape interface
#printShapeInfo(shapeName string, area float, perimeter float) {
    fmt.Printf("%s:\n", shapeName);
    fmt.Printf("  Area: %.2f\n", area);
    fmt.Printf("  Perimeter: %.2f\n", perimeter);
    fmt.Printf("\n");
}

#prarambham() {
    fmt.Printf("=== Interface Polymorphism Example ===\n\n");
    
    // Create different shapes
    @rect Rectangle = Rectangle{width: 5.0, height: 3.0};
    @circle Circle = Circle{radius: 2.5};
    
    // Calculate properties using interface methods
    @rectArea float = Rectangle_Area(&rect);
    @rectPerimeter float = Rectangle_Perimeter(&rect);
    @rectName string = Rectangle_Name(&rect);
    
    @circleArea float = Circle_Area(&circle);
    @circlePerimeter float = Circle_Perimeter(&circle);
    @circleName string = Circle_Name(&circle);
    
    // Use interface methods polymorphically
    printShapeInfo(rectName, rectArea, rectPerimeter);
    printShapeInfo(circleName, circleArea, circlePerimeter);
    
    fmt.Printf("=== Interface Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.29s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_polymorphism_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_polymorphism_example.tl:9:1: Expected method name in interface
//
//
//   9 |     Area() float;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\interface_polymorphism_example.tl` (exit code: 1)
//
