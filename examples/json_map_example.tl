// JSON automatic map serialization example

dhimpu "fmt" as fmt;
dhimpu "json" as json;

#prarambham() {
    fmt.Printf("=== JSON Automatic Map Serialization Example ===\n\n");
    
    // Create a map: jatha[string]int
    @scores jatha[string]int = map_create(0, 0);  // 0=string key, 0=int value
    
    // Set map values (using map_set)
    @key1 string = "Alice";
    @val1 int = 95;
    map_set(scores, &key1, &val1);
    
    @key2 string = "Bob";
    @val2 int = 87;
    map_set(scores, &key2, &val2);
    
    @key3 string = "Charlie";
    @val3 int = 92;
    map_set(scores, &key3, &val3);
    
    // Automatic JSON serialization for maps
    @jsonMap string = json.MarshalMap(scores);
    fmt.Printf("Map JSON: %s\n", jsonMap);
    
    // Create a map with string values
    @names jatha[int]string = map_create(1, 2);  // 1=int key, 2=string value
    @id1 int = 1;
    @name1 string = "Alice";
    map_set(names, &id1, &name1);
    
    @id2 int = 2;
    @name2 string = "Bob";
    map_set(names, &id2, &name2);
    
    @jsonNames string = json.MarshalMap(names);
    fmt.Printf("Names Map JSON: %s\n", jsonNames);
    
    fmt.Printf("\n=== JSON Automatic Map Serialization Complete ===\n");
}

//

//

//

// === OUTPUT ===
// === JSON Automatic Map Serialization Example ===
//
// Map JSON: {"Alice":95, "Bob":87, "Charlie":92}
// Names Map JSON: {"1":"Alice", "2":"Bob"}
//
// === JSON Automatic Map Serialization Complete ===
//
