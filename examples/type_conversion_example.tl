// Type conversion examples
// Demonstrates Go-style type conversion: int(x), float(x), string(x), bool(x)

dhimpu "fmt" as fmt;

#prarambham() {
    fmt.Printf("=== Type Conversion Examples ===\n\n");
    
    // ============================================
    // int() - Convert to integer
    // ============================================
    fmt.Printf("--- int() Conversion ---\n");
    
    @x float = 3.14;
    @y int = int(x);  // float to int
    fmt.Printf("int(3.14) = %d\n", y);
    
    @str string = "123";
    @num int = int(str);  // string to int (uses strconv.Atoi)
    fmt.Printf("int(\"123\") = %d\n", num);
    
    @flag int = 1;
    @boolAsInt int = int(flag);  // bool to int
    fmt.Printf("int(1) = %d\n", boolAsInt);
    
    // ============================================
    // float() - Convert to float
    // ============================================
    fmt.Printf("\n--- float() Conversion ---\n");
    
    @a int = 42;
    @b float = float(a);  // int to float
    fmt.Printf("float(42) = %f\n", b);
    
    @str2 string = "3.14";
    @f float = float(str2);  // string to float (uses strconv.ParseFloat)
    fmt.Printf("float(\"3.14\") = %f\n", f);
    
    // ============================================
    // string() - Convert to string
    // ============================================
    fmt.Printf("\n--- string() Conversion ---\n");
    
    @num2 int = 456;
    @str3 string = string(num2);  // int to string (uses strconv.Itoa)
    fmt.Printf("string(456) = %s\n", str3);
    
    @pi float = 3.14159;
    @str4 string = string(pi);  // float to string (uses strconv.FormatFloat)
    fmt.Printf("string(3.14159) = %s\n", str4);
    
    @boolVal int = 1;
    @str5 string = string(boolVal);  // bool to string (uses strconv.FormatBool)
    fmt.Printf("string(1) = %s\n", str5);
    
    // ============================================
    // bool() - Convert to boolean
    // ============================================
    fmt.Printf("\n--- bool() Conversion ---\n");
    
    @num3 int = 5;
    @bool1 int = bool(num3);  // int to bool (non-zero = true)
    fmt.Printf("bool(5) = %d\n", bool1);
    
    @num4 int = 0;
    @bool2 int = bool(num4);  // int to bool (zero = false)
    fmt.Printf("bool(0) = %d\n", bool2);
    
    @str6 string = "true";
    @bool3 int = bool(str6);  // string to bool (uses strconv.ParseBool)
    fmt.Printf("bool(\"true\") = %d\n", bool3);
    
    // ============================================
    // Practical Examples
    // ============================================
    fmt.Printf("\n--- Practical Examples ---\n");
    
    // Converting user input (string) to number
    @userInput string = "42";
    @age int = int(userInput);
    fmt.Printf("User age: %d\n", age);
    
    // Converting number to string for display
    @price float = 19.99;
    @priceStr string = string(price);
    fmt.Printf("Price: $%s\n", priceStr);
    
    // Type conversion in calculations
    @count int = 10;
    @average float = float(count) / 3.0;  // Convert to float for division
    fmt.Printf("Average: %f\n", average);
    
    fmt.Printf("\n=== Type Conversion Examples Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.33s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_conversion_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_conversion_example.tl:17:17: Unexpected token: IntType
//
// Context (most recent call last):
//   1: while parsing variable declaration
//   2: while parsing function declaration
//
//
//   17 |     @y int = int(x);  // float to int
//    |    ^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\type_conversion_example.tl` (exit code: 1)
//
