// Reflection example
// Demonstrates reflect library for runtime type information

@fmt = #dhimpu("std/fmt");
@reflect = #dhimpu("std/reflect");

#prarambham() {
    fmt.Printf("=== Reflection Examples ===\n\n");
    
    // Get type information
    fmt.Printf("--- Type Information ---\n");
    @intType string = reflect.TypeOf("int");
    @floatType string = reflect.TypeOf("float");
    @stringType string = reflect.TypeOf("string");
    @boolType string = reflect.TypeOf("bool");
    @errorType string = reflect.TypeOf("error");
    
    fmt.Printf("int type: %s\n", intType);
    fmt.Printf("float type: %s\n", floatType);
    fmt.Printf("string type: %s\n", stringType);
    fmt.Printf("bool type: %s\n", boolType);
    fmt.Printf("error type: %s\n", errorType);
    fmt.Printf("Format: name|kind|size\n");
    
    fmt.Printf("\n--- Type Properties ---\n");
    @intKind int = reflect.Kind("int");
    @intSize int = reflect.Size("int");
    @intName string = reflect.Name("int");
    
    fmt.Printf("int kind: %d (0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer)\n", intKind);
    fmt.Printf("int size: %d bytes\n", intSize);
    fmt.Printf("int name: %s\n", intName);
    
    fmt.Printf("\n--- Type Checks ---\n");
    @isInt int = reflect.IsInt("int");
    @isFloat int = reflect.IsFloat("float");
    @isString int = reflect.IsString("string");
    @isInt2 int = reflect.IsInt("float");
    
    fmt.Printf("Is 'int' an int? %d (expected: 1)\n", isInt);
    fmt.Printf("Is 'float' a float? %d (expected: 1)\n", isFloat);
    fmt.Printf("Is 'string' a string? %d (expected: 1)\n", isString);
    fmt.Printf("Is 'float' an int? %d (expected: 0)\n", isInt2);
    
    fmt.Printf("\n--- Value Information ---\n");
    @intValue int = 42;
    @floatValue float = 3.14159;
    @stringValue string = "Hello, Tlang!";
    
    @intInfo string = reflect.ValueOfInt(intValue);
    @floatInfo string = reflect.ValueOfFloat(floatValue);
    @stringInfo string = reflect.ValueOfString(stringValue);
    
    fmt.Printf("Value of int 42: %s\n", intInfo);
    fmt.Printf("Value of float 3.14159: %s\n", floatInfo);
    fmt.Printf("Value of string: %s\n", stringInfo);
    fmt.Printf("Format: type|value\n");
    
    fmt.Printf("\n--- TypeOf for Values ---\n");
    @typeOfInt string = reflect.TypeOfInt(100);
    @typeOfFloat string = reflect.TypeOfFloat(3.14);
    @testStr string = "test";
    @typeOfString string = reflect.TypeOfString(testStr);
    
    fmt.Printf("TypeOf(100): %s\n", typeOfInt);
    fmt.Printf("TypeOf(3.14): %s\n", typeOfFloat);
    fmt.Printf("TypeOf test string: %s\n", typeOfString);
    
    fmt.Printf("\n--- Type Comparison ---\n");
    @x int = 10;
    @y float = 10.0;
    @z string = "10";
    
    @xType string = reflect.TypeOfInt(x);
    @yType string = reflect.TypeOfFloat(y);
    @zType string = reflect.TypeOfString(z);
    
    fmt.Printf("x = 10, type: %s\n", xType);
    fmt.Printf("y = 10.0, type: %s\n", yType);
    fmt.Printf("z = 10 (string), type: %s\n", zType);
    
    @xKind int = reflect.Kind("int");
    @yKind int = reflect.Kind("float");
    @zKind int = reflect.Kind("string");
    
    fmt.Printf("x kind: %d, y kind: %d, z kind: %d\n", xKind, yKind, zKind);
    okavela xKind == yKind {
        fmt.Printf("x and y have same kind\n");
    } lekapothe {
        fmt.Printf("x and y have different kinds\n");
    }
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\reflect_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\reflect_example.tl:90:1: Expected field name in struct literal
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   90 |         fmt.Printf("x and y have same kind\n");
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\reflect_example.tl` (exit code: 1)
//
