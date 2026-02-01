// JSON example with slices, structs, and maps

@fmt = #dhimpu("std/fmt");
@json = #dhimpu("std/json");

// Define a Person struct for JSON
nirmanam Person {
    name string;
    age int;
    email string;
}

#prarambham() {
    fmt.Printf("=== JSON Advanced Example ===\n\n");
    
    // 1. JSON with slices (arrays)
    @numbers []int = {1, 2, 3, 4, 5};
    @jsonArray string = json.MarshalSlice(numbers, "int");
    fmt.Printf("JSON Array: %s\n", jsonArray);
    
    // 2. JSON with strings
    @name string = "Alice";
    @jsonName string = json.Marshal("string", name);
    fmt.Printf("JSON String: %s\n", jsonName);
    
    // 3. JSON with struct (manual serialization)
    @person Person = Person{name: "Bob", age: 25, email: "bob@example.com"};
    @nameJson string = json.Marshal("string", person.name);
    @ageJson string = json.Marshal("int", fmt.Sprintf("%d", person.age));
    @emailJson string = json.Marshal("string", person.email);
    @jsonStruct string = json.MarshalStruct(fmt.Sprintf("\"name\":%s,\"age\":%s,\"email\":%s", nameJson, ageJson, emailJson));
    fmt.Printf("JSON Struct: %s\n", jsonStruct);
    
    // 4. JSON with map (manual serialization)
    @key1 string = json.Marshal("string", "score1");
    @val1 string = json.Marshal("int", "95");
    @key2 string = json.Marshal("string", "score2");
    @val2 string = json.Marshal("int", "87");
    @jsonMap string = json.MarshalMap(fmt.Sprintf("%s:%s,%s:%s", key1, val1, key2, val2));
    fmt.Printf("JSON Map: %s\n", jsonMap);
    
    fmt.Printf("\n=== JSON Advanced Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_advanced_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_advanced_example.tl:10:1: Expected field name
//
//
//   10 |     name string;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_advanced_example.tl` (exit code: 1)
//
