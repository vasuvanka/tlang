// JSON automatic serialization example

@fmt = #dhimpu("std/fmt");
@json = #dhimpu("std/json");

// Define structs for automatic JSON serialization
nirmanam Person {
    name string;
    age int;
    email string;
}

nirmanam Address {
    street string;
    city string;
    zip int;
}

nirmanam Employee {
    person Person;
    address Address;
    salary float;
    active int;  // bool
}

#prarambham() {
    fmt.Printf("=== JSON Automatic Serialization Example ===\n\n");
    
    // Create a Person struct
    @person Person = Person{name: "Alice", age: 30, email: "alice@example.com"};
    
    // Automatic JSON serialization - Go-style syntax!
    @jsonPerson string = json.Marshal(person);
    fmt.Printf("Person JSON: %s\n", jsonPerson);
    
    // Create nested struct
    @address Address = Address{street: "123 Main St", city: "New York", zip: 10001};
    @employee Employee = Employee{
        person: person,
        address: address,
        salary: 75000.50,
        active: 1
    };
    
    // Automatic JSON serialization for nested structs
    @jsonEmployee string = json.Marshal(employee);
    fmt.Printf("Employee JSON: %s\n", jsonEmployee);
    
    // Arrays in structs are automatically serialized
    fmt.Printf("\n=== JSON Automatic Serialization Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.29s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_auto_example.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_auto_example.tl:10:1: Expected field name
//
//
//   10 |     name string;
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\json_auto_example.tl` (exit code: 1)
//
