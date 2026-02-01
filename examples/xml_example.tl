// encoding/xml library example
// Demonstrates XML encoding and decoding

@fmt = #dhimpu("std/fmt");
@xml = #dhimpu("std/xml");

#prarambham() {
    fmt.Printf("=== encoding/xml Library Examples ===\n\n");
    
    // XML Escaping
    fmt.Printf("--- XML Escaping ---\n");
    @text1 string = "<tag>value</tag>";
    @text2 string = "Hello & World";
    @text3 string = "Price: $100";
    
    @escaped1 string = xml.Escape(text1);
    @escaped2 string = xml.Escape(text2);
    @escaped3 string = xml.Escape(text3);
    
    fmt.Printf("Original: %s\n", text1);
    fmt.Printf("Escaped: %s\n", escaped1);
    fmt.Printf("\nOriginal: %s\n", text2);
    fmt.Printf("Escaped: %s\n", escaped2);
    fmt.Printf("\nOriginal: %s\n", text3);
    fmt.Printf("Escaped: %s\n", escaped3);
    
    // XML Unescaping
    fmt.Printf("\n--- XML Unescaping ---\n");
    @escaped string = "&lt;tag&gt;value&lt;/tag&gt;";
    @unescaped string = xml.Unescape(escaped);
    fmt.Printf("Escaped: %s\n", escaped);
    fmt.Printf("Unescaped: %s\n", unescaped);
    
    // XML Marshal
    fmt.Printf("\n--- XML Marshal ---\n");
    @xml1 string = xml.Marshal("string", "name", "John Doe");
    @xml2 string = xml.Marshal("int", "age", "30");
    @xml3 string = xml.Marshal("float", "price", "99.99");
    
    fmt.Printf("String: %s\n", xml1);
    fmt.Printf("Int: %s\n", xml2);
    fmt.Printf("Float: %s\n", xml3);
    
    // XML Unmarshal
    fmt.Printf("\n--- XML Unmarshal ---\n");
    @xmlData string = "<name>John Doe</name><age>30</age>";
    @name string = xml.Unmarshal(xmlData, "name");
    @age string = xml.Unmarshal(xmlData, "age");
    
    fmt.Printf("XML: %s\n", xmlData);
    fmt.Printf("Extracted name: %s\n", name);
    fmt.Printf("Extracted age: %s\n", age);
    
    // Round-trip test
    fmt.Printf("\n--- Round-Trip Test ---\n");
    @original string = "Hello <world>";
    @escapedTest string = xml.Escape(original);
    @unescapedTest string = xml.Unescape(escapedTest);
    fmt.Printf("Original: %s\n", original);
    fmt.Printf("Escaped: %s\n", escapedTest);
    fmt.Printf("Unescaped: %s\n", unescapedTest);
}

//

//

//

// === OUTPUT ===
// === encoding/xml Library Examples ===
//
// --- XML Escaping ---
// Original: <tag>value</tag>
// Escaped: Price: $100
//
// Original: Hello & World
// Escaped: Price: $100
//
// Original: Price: $100
// Escaped: Price: $100
//
// --- XML Unescaping ---
// Escaped: &lt;tag&gt;value&lt;/tag&gt;
// Unescaped: <tag>value</tag>
//
// --- XML Marshal ---
// String: <price>99.99</price>
// Int: <price>99.99</price>
// Float: <price>99.99</price>
//
// --- XML Unmarshal ---
// XML: <name>John Doe</name><age>30</age>
// Extracted name: 30
// Extracted age: 30
//
// --- Round-Trip Test ---
// Original: Hello <world>
// Escaped: Hello &lt;world&gt;
// Unescaped: Hello <world>
//
