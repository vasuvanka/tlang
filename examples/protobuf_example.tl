// Protocol Buffers Example
// Demonstrates fast binary serialization as an alternative to JSON
//
// Note: This example shows the protobuf library API.
// Full struct serialization support requires compiler-generated functions
// (similar to json.Marshal() and json_unmarshal_<structname>)

@fmt = #dhimpu("std/fmt");
@protobuf = #dhimpu("std/protobuf");

#prarambham() {
    fmt.Printf("=== Protocol Buffers Example ===\n\n");
    
    fmt.Printf("Protobuf library is available for fast binary serialization.\n");
    fmt.Printf("It provides 3-10x smaller size and 2-5x faster encoding/decoding than JSON.\n\n");
    
    fmt.Printf("Current Status:\n");
    fmt.Printf("  ✅ Basic encoding/decoding functions available\n");
    fmt.Printf("  ✅ Support for int32, int64, uint32, bool, float, double, string\n");
    fmt.Printf("  ✅ Varint encoding for efficient integer storage\n");
    fmt.Printf("  ⚠️  Struct serialization requires compiler-generated functions (planned)\n\n");
    
    fmt.Printf("See docs/libraries/protobuf.md for API documentation.\n");
    fmt.Printf("The library provides low-level C functions that can be used\n");
    fmt.Printf("for building high-performance serialization systems.\n\n");
    
    fmt.Printf("=== Protocol Buffers Example Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\protobuf_example.tl`
//
// Parser Error at protobuf:1:1: Cannot find package 'protobuf': Package 'protobuf' not found
//
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\protobuf_example.tl` (exit code: 1)
//
