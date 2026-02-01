// encoding/base64 library example
// Demonstrates base64 encoding and decoding

@fmt = #dhimpu("std/fmt");
@base64 = #dhimpu("std/base64");

#prarambham() {
    fmt.Printf("=== encoding/base64 Library Examples ===\n\n");
    
    // Encode string to base64
    fmt.Printf("--- String Encoding ---\n");
    @text string = "Hello, Tlang!";
    @encoded string = base64.Encode(text);
    fmt.Printf("Original: %s\n", text);
    fmt.Printf("Encoded: %s\n", encoded);
    
    // Decode base64 string
    fmt.Printf("\n--- String Decoding ---\n");
    @decoded string = base64.Decode(encoded);
    fmt.Printf("Encoded: %s\n", encoded);
    fmt.Printf("Decoded: %s\n", decoded);
    
    // Round-trip test
    fmt.Printf("\n--- Round-Trip Test ---\n");
    @original string = "Base64 encoding test";
    @encoded2 string = base64.Encode(original);
    @decoded2 string = base64.Decode(encoded2);
    @match int = (original == decoded2);
    fmt.Printf("Original: %s\n", original);
    fmt.Printf("Encoded: %s\n", encoded2);
    fmt.Printf("Decoded: %s\n", decoded2);
    fmt.Printf("Match: %d (expected: 1)\n", match);
    
    // Encode bytes
    fmt.Printf("\n--- Byte Array Encoding ---\n");
    @bytes string = "72|101|108|108|111";  // "Hello" as bytes
    @encodedBytes string = base64.EncodeBytes(bytes);
    fmt.Printf("Bytes: %s\n", bytes);
    fmt.Printf("Encoded: %s\n", encodedBytes);
    
    // Decode bytes
    fmt.Printf("\n--- Byte Array Decoding ---\n");
    @decodedBytes string = base64.DecodeBytes(encodedBytes);
    fmt.Printf("Encoded: %s\n", encodedBytes);
    fmt.Printf("Decoded bytes: %s\n", decodedBytes);
    
    // Test with different data
    fmt.Printf("\n--- Various Data Types ---\n");
    @data1 string = "A";
    @data2 string = "AB";
    @data3 string = "ABC";
    @data4 string = "ABCD";
    
    @enc1 string = base64.Encode(data1);
    @enc2 string = base64.Encode(data2);
    @enc3 string = base64.Encode(data3);
    @enc4 string = base64.Encode(data4);
    
    fmt.Printf("'%s' -> %s\n", data1, enc1);
    fmt.Printf("'%s' -> %s\n", data2, enc2);
    fmt.Printf("'%s' -> %s\n", data3, enc3);
    fmt.Printf("'%s' -> %s\n", data4, enc4);
    
    // Verify decoding
    fmt.Printf("\n--- Verification ---\n");
    @dec1 string = base64.Decode(enc1);
    @dec2 string = base64.Decode(enc2);
    @dec3 string = base64.Decode(enc3);
    @dec4 string = base64.Decode(enc4);
    
    fmt.Printf("Decoded '%s': %s (match: %d)\n", enc1, dec1, (data1 == dec1));
    fmt.Printf("Decoded '%s': %s (match: %d)\n", enc2, dec2, (data2 == dec2));
    fmt.Printf("Decoded '%s': %s (match: %d)\n", enc3, dec3, (data3 == dec3));
    fmt.Printf("Decoded '%s': %s (match: %d)\n", enc4, dec4, (data4 == dec4));
}

//

//

//

//

//

// === OUTPUT ===
// === encoding/base64 Library Examples ===
//
// --- String Encoding ---
// Original: Hello, Tlang!
// Encoded: SGVsbG8sIFRsYW5nIQ==
//
// --- String Decoding ---
// Encoded: SGVsbG8sIFRsYW5nIQ==
// Decoded: Hello, Tlang
//
// --- Round-Trip Test ---
// Original: Base64 encoding test
// Encoded: QmFzZTY0IGVuY29kaW5nIHRlc3Q=
// Decoded: Base64 encoding te
// Match: 0 (expected: 1)
//
// --- Byte Array Encoding ---
// Bytes: 72|101|108|108|111
// Encoded: SGVsbG8=
//
// --- Byte Array Decoding ---
// Encoded: SGVsbG8=
// Decoded bytes: 72|101|108
//
// --- Various Data Types ---
// 'A' -> QUJDRA==
// 'AB' -> QUJDRA==
// 'ABC' -> QUJDRA==
// 'ABCD' -> QUJDRA==
//
// --- Verification ---
// Decoded 'QUJDRA==': ABC (match: 0)
// Decoded 'QUJDRA==': ABC (match: 0)
// Decoded 'QUJDRA==': ABC (match: 0)
// Decoded 'QUJDRA==': ABC (match: 0)
//
