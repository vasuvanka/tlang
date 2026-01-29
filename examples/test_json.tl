// Test cases for json library

#prarambham() {
    fmt.Printf("=== json Library Tests ===\n");
    
    // Marshal tests - String
    @jsonStr1 string = json.Marshal("string", "Hello");
    @jsonStr2 string = json.Marshal("string", "World with \"quotes\"");
    fmt.Printf("Marshal string 'Hello': %s\n", jsonStr1);
    fmt.Printf("Marshal string with quotes: %s\n", jsonStr2);
    
    // Marshal tests - Int
    @jsonInt1 string = json.Marshal("int", "42");
    @jsonInt2 string = json.Marshal("int", "-123");
    @jsonInt3 string = json.Marshal("int", "0");
    fmt.Printf("Marshal int 42: %s\n", jsonInt1);
    fmt.Printf("Marshal int -123: %s\n", jsonInt2);
    fmt.Printf("Marshal int 0: %s\n", jsonInt3);
    
    // Marshal tests - Float
    @jsonFloat1 string = json.Marshal("float", "3.14");
    @jsonFloat2 string = json.Marshal("float", "-2.5");
    @jsonFloat3 string = json.Marshal("float", "0.0");
    fmt.Printf("Marshal float 3.14: %s\n", jsonFloat1);
    fmt.Printf("Marshal float -2.5: %s\n", jsonFloat2);
    fmt.Printf("Marshal float 0.0: %s\n", jsonFloat3);
    
    // Marshal tests - Bool
    @jsonBool1 string = json.Marshal("bool", "true");
    @jsonBool2 string = json.Marshal("bool", "false");
    fmt.Printf("Marshal bool true: %s\n", jsonBool1);
    fmt.Printf("Marshal bool false: %s\n", jsonBool2);
    
    // Marshal tests - Unknown type
    @jsonUnknown string = json.Marshal("unknown", "value");
    fmt.Printf("Marshal unknown type: %s\n", jsonUnknown);
    
    // Unmarshal tests - String
    @unmarshalStr1 string = json.Unmarshal("\"Hello\"", "string");
    @unmarshalStr2 string = json.Unmarshal("\"World\"", "string");
    fmt.Printf("Unmarshal string '\"Hello\"': %s\n", unmarshalStr1);
    fmt.Printf("Unmarshal string '\"World\"': %s\n", unmarshalStr2);
    
    // Unmarshal tests - Int
    @unmarshalInt1 string = json.Unmarshal("42", "int");
    @unmarshalInt2 string = json.Unmarshal("-123", "int");
    fmt.Printf("Unmarshal int '42': %s\n", unmarshalInt1);
    fmt.Printf("Unmarshal int '-123': %s\n", unmarshalInt2);
    
    // Unmarshal tests - Float
    @unmarshalFloat1 string = json.Unmarshal("3.14", "float");
    @unmarshalFloat2 string = json.Unmarshal("-2.5", "float");
    fmt.Printf("Unmarshal float '3.14': %s\n", unmarshalFloat1);
    fmt.Printf("Unmarshal float '-2.5': %s\n", unmarshalFloat2);
    
    // Unmarshal tests - Bool
    @unmarshalBool1 string = json.Unmarshal("true", "bool");
    @unmarshalBool2 string = json.Unmarshal("false", "bool");
    fmt.Printf("Unmarshal bool 'true': %s\n", unmarshalBool1);
    fmt.Printf("Unmarshal bool 'false': %s\n", unmarshalBool2);
    
    // Round-trip test
    @original string = "Test String";
    @marshaled string = json.Marshal("string", original);
    @unmarshaled string = json.Unmarshal(marshaled, "string");
    fmt.Printf("Round-trip test:\n");
    fmt.Printf("  Original: %s\n", original);
    fmt.Printf("  Marshaled: %s\n", marshaled);
    fmt.Printf("  Unmarshaled: %s\n", unmarshaled);
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.29s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_json.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_json.tl:8:67: Expected RightParen, but found Identifier("quotes")
//
// Context (most recent call last):
//   1: while parsing variable declaration
//   2: while parsing function declaration
//
//
//   8 |     @jsonStr2 string = json.Marshal("string", "World with \"quotes\"");
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_json.tl` (exit code: 1)
//
