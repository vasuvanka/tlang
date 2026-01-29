// encoding/hex library example
// Demonstrates hexadecimal encoding and decoding

dhimpu "fmt" as fmt;
dhimpu "hex" as hex;

#prarambham() {
    fmt.Printf("=== encoding/hex Library Examples ===\n\n");
    
    @data string = "Hello, World!";
    
    // Encode to hex
    fmt.Printf("--- Encoding ---\n");
    @encoded string = hex.Encode(data);
    fmt.Printf("Original: %s\n", data);
    fmt.Printf("Encoded: %s\n", encoded);
    fmt.Printf("Length: %d (expected: %d)\n", strings.Index(encoded, ""), strings.Index(data, "") * 2);
    
    // Decode from hex
    fmt.Printf("\n--- Decoding ---\n");
    @decoded string = hex.Decode(encoded);
    fmt.Printf("Encoded: %s\n", encoded);
    fmt.Printf("Decoded: %s\n", decoded);
    @match int = (data == decoded);
    fmt.Printf("Round-trip successful: %d (expected: 1)\n", match);
    
    // EncodeBytes
    fmt.Printf("\n--- EncodeBytes ---\n");
    @bytesEncoded string = hex.EncodeBytes(data, strings.Index(data, ""));
    fmt.Printf("Data: %s\n", data);
    fmt.Printf("Encoded: %s\n", bytesEncoded);
    
    // DecodeBytes
    fmt.Printf("\n--- DecodeBytes ---\n");
    @bytesDecoded string = hex.DecodeBytes(bytesEncoded);
    fmt.Printf("Encoded: %s\n", bytesEncoded);
    fmt.Printf("Decoded: %s\n", bytesDecoded);
    
    // Binary data example
    fmt.Printf("\n--- Binary Data Example ---\n");
    @binary string = "\\x48\\x65\\x6C\\x6C\\x6F";  // "Hello" in hex
    @hexStr string = "48656C6C6F";
    @decodedBinary string = hex.Decode(hexStr);
    fmt.Printf("Hex string: %s\n", hexStr);
    fmt.Printf("Decoded: %s\n", decodedBinary);
    
    // Different data types
    fmt.Printf("\n--- Different Data Types ---\n");
    @text1 string = "ABC";
    @text2 string = "123";
    @text3 string = "Hello World";
    
    @hex1 string = hex.Encode(text1);
    @hex2 string = hex.Encode(text2);
    @hex3 string = hex.Encode(text3);
    
    fmt.Printf("'%s' -> %s\n", text1, hex1);
    fmt.Printf("'%s' -> %s\n", text2, hex2);
    fmt.Printf("'%s' -> %s\n", text3, hex3);
}

//

//

//

//

//

// === OUTPUT ===
// === encoding/hex Library Examples ===
//
// --- Encoding ---
// Original: Hello, World!
// Encoded: 48656c6c6f2c20576f726c6421
// Length: 0 (expected: 0)
//
// --- Decoding ---
// Encoded: 48656c6c6f2c20576f726c6421
// Decoded: Hello, World!
// Round-trip successful: 0 (expected: 1)
//
// --- EncodeBytes ---
// Data: Hello, World!
// Encoded: 
//
// --- DecodeBytes ---
// Encoded: 
// Decoded: 
//
// --- Binary Data Example ---
// Hex string: 48656C6C6F
// Decoded: Hello
//
// --- Different Data Types ---
// 'ABC' -> 48656c6c6f20576f726c64
// '123' -> 48656c6c6f20576f726c64
// 'Hello World' -> 48656c6c6f20576f726c64
//
