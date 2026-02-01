# Tlang Changelog

## Version 0.1.0 - Latest

### New Features

#### Standard library path (`std/<package>`)
- Standard library packages live under **`libs/std/<package>`** and are imported with **`#dhimpu("std/<package>")`**.
- Use `@fmt = #dhimpu("std/fmt")`, `#dhimpu("std/math")`, etc. (alias inferred from path).
- Added `libs/std/README.md` describing the layout and available packages.
- Relative imports unchanged: `#dhimpu("./utils")` for local packages.

#### Testing Library
- Added `testing` library for unit testing (similar to Go's testing package)
  - `testing.Run(name, testFunc)` - Run test functions
  - `testing.Assert(condition, message)` - Basic assertion
  - `testing.AssertEqual(expected, actual, message)` - Integer equality assertion
  - `testing.AssertEqualFloat(expected, actual, epsilon, message)` - Float equality assertion
  - `testing.AssertEqualString(expected, actual, message)` - String equality assertion
  - `testing.Fail(message)` - Mark test as failed
  - `testing.Skip(message)` - Skip test
  - `testing.Log(message)` - Log during test
  - `testing.Summary()` - Print test summary
  - `testing.GetFailed()` - Get failed assertion count

#### Command-Line Arguments
- Added `args` library for accessing command-line arguments
  - `args.Count()` - Get argument count
  - `args.Get(index)` - Get argument at index
  - `args.Program()` - Get program name
  - Arguments automatically initialized in `main()`

#### Installation Support
- Added `install.sh` for Linux/Unix installation
- Added `install.ps1` for Windows installation
- Created `tlang` wrapper command with subcommands:
  - `tlang compile <file.tl>` - Compile Tlang file
  - `tlang run <file.tl>` - Compile and run
  - `tlang test <file.tl>` - Run tests

#### Cryptographic Library (Phase 1-3 Complete)
- **Phase 1 (Essential):**
  - Added `crypto.AESGCMEncrypt()` and `crypto.AESGCMDecrypt()` - Authenticated encryption
  - Added `crypto.ChaCha20Poly1305Encrypt()` and `crypto.ChaCha20Poly1305Decrypt()` - Modern stream cipher
  - Added `crypto.PBKDF2()` - Password-based key derivation
- **Phase 2 (Important):**
  - Added `crypto.RSAGenerateKeyPair()`, `crypto.RSAEncrypt()`, `crypto.RSADecrypt()` - RSA public key cryptography
  - Added `crypto.RSASign()` and `crypto.RSAVerify()` - RSA digital signatures
  - Added `crypto.ECCGenerateKeyPair()`, `crypto.ECDSASign()`, `crypto.ECDSAVerify()` - Elliptic curve cryptography
  - Added `crypto.Argon2Hash()` and `crypto.Argon2Verify()` - Modern password hashing
- **Phase 3 (Useful):**
  - Added `crypto.Ed25519GenerateKeyPair()`, `crypto.Ed25519Sign()`, `crypto.Ed25519Verify()` - Modern signature scheme
  - Added `crypto.BcryptHash()` and `crypto.BcryptVerify()` - Password hashing (for compatibility)
  - Added `crypto.Scrypt()` - Memory-hard key derivation
- **Additional:**
  - Added `crypto.AESEncrypt()` and `crypto.AESDecrypt()` - AES encryption (CBC, ECB modes)
  - Added `crypto.DESEncrypt()` and `crypto.DESDecrypt()` - DES encryption (legacy)
  - Added `crypto.GenerateKey()` - Random key generation
- **OpenSSL Integration:**
  - All cryptographic functions use OpenSSL for production-ready security
  - OpenSSL libraries are automatically bundled during installation
  - Fallback mechanisms for systems without OpenSSL

### Changes

#### C compilation (Windows)
- On Windows, `-static` and `-static-libgcc`/`-static-libstdc++` are no longer passed to gcc by default (MinGW often lacks static CRT).
- When the C compiler fails with no message, a manual build command is suggested (e.g. `gcc -o output.exe output.c -lm -lws2_32`).

#### Removed Features
- Removed built-in `print()`, `print_num()`, and `input_num()` functions
- Users should now use `fmt.Printf()` for output

#### New Keywords
- Added `@@` (double @) for constant declarations
  - Syntax: `@@name type = value;` or `@@name = value;`
  - Constants are immutable (enforced by C compiler)

### Documentation
- Added `README_INSTALL.md` - Installation guide
- Added `docs/OPENSSL_SETUP.md` - OpenSSL setup and troubleshooting guide
- Added `docs/libraries/crypto.md` - Comprehensive crypto library documentation
- Added `docs/crypto-algorithm-suggestions.md` - Algorithm recommendations and status
- Added `examples/README_TESTING.md` - Testing library documentation
- Added `examples/README_ARGS.md` - Command-line arguments documentation
- Added `examples/test_example.tl` - Testing library example
- Added `examples/args_example.tl` - Command-line arguments example
- Added `examples/const_example.tl` - Constants example
- Added `examples/crypto_encryption_example.tl` - Symmetric encryption examples
- Added `examples/crypto_advanced_example.tl` - Advanced crypto examples
- Added `examples/crypto_publickey_example.tl` - Public key cryptography examples
- Added `examples/crypto_phase3_example.tl` - Phase 3 algorithms examples (Ed25519, bcrypt, scrypt)

### Examples Updated
- All examples updated to use `fmt.Printf()` instead of `print()`/`print_num()`
- Updated examples: `hello.tl`, `arithmetic.tl`, `factorial.tl`, `loops.tl`, `comments.tl`, `main_example.tl`, `type_inference.tl`, `test_comments.tl`

#### Package and Import System
- Added `potlam` (package) declaration support
  - Package declaration must be first statement in file
  - Defaults to `main` if not specified
- Added `techu` (import) statement support
  - Import standard libraries: `techu "fmt"`
  - Import local files: `techu "./utils"`
  - Import from parent: `techu "../common"`
  - Built-in libraries automatically detected
- **Import Aliases** ⭐
  - Support for `techu "path" as alias` syntax
  - Use shorter names for long package paths
  - Example: `techu "./very/long/package/path" as vlp`
- **Circular Dependency Detection** ⭐
  - Detects and reports circular import dependencies
  - Prevents infinite recursion during package loading
  - Clear error messages for circular dependencies
- **Package-Level Exports** ⭐
  - Package-level variables and constants are now exported
  - Functions, variables, and constants from packages are available
  - Export visibility can be refined (currently all exported)
- Added package resolver module (`src/package.rs`)
  - Resolves import paths to files
  - Handles relative and absolute paths
  - Detects built-in standard libraries
  - Recursively resolves package dependencies
  - Circular dependency detection
- Updated compiler to handle multiple files
  - Main program and imported packages are compiled together
  - Functions from imported packages are included in generated code
  - Import aliases properly handled in function calls
- Created example files:
  - `examples/utils.tl` - Example utility package
  - `examples/package_example.tl` - Demonstrates package usage
  - `examples/package_alias_example.tl` - Demonstrates import aliases

#### Arrays and Slices
- Added fixed-size array support: `[5]int`, `[10]float`
- Added variable-size slice support: `[]int`, `[]string`
- Added array literals: `{1, 2, 3, 4, 5}`
- Added array indexing: `arr[0]`, `arr[i]`
- Added slice expressions: `arr[1:3]`, `arr[:3]`, `arr[1:]`
- Added `len()` function for arrays and slices
- Added `cap()` function for slices
- Added `append()` function for slices
- Created example files:
  - `examples/array_example.tl` - Array examples
  - `examples/slice_example.tl` - Slice examples

#### Default Value Initialization
- All variables now initialize with default values if no value provided
  - `int` → `0`
  - `float` → `0.0`
  - `string` → `""`
  - `bool` → `0` (false)
  - Arrays → All elements initialized to defaults
  - Slices → `NULL` (empty)
- Created example file:
  - `examples/default_values_example.tl` - Demonstrates default values

#### Structs and Maps
- Added struct definition support (`amarika`)
  - Struct syntax: `amarika Person { name string; age int; }`
  - Struct literals: `Person{name: "Alice", age: 30}`
  - Field access: `person.name`, `person.age`
  - Structs can be used as types, function parameters, and return values
- Added map type support (`rasi`)
  - Map syntax: `rasi[string]int`, `rasi[int]string`
  - Map operations: `map[key]`, `map[key] = value`
  - Map literals: `rasi[string]int{"key1": 1, "key2": 2}`
- **Automatic JSON Serialization for Structs** ⭐
  - Compiler automatically generates `json_marshal_<structname>()` functions
  - All struct fields automatically serialized to JSON
  - Nested structs fully supported
  - Arrays and slices in structs automatically handled
  - No manual field serialization required!
- Extended JSON library for complex types
  - `json.MarshalSlice()` / `json.MarshalSliceEnhanced()` - Encode slices/arrays to JSON
  - `json.MarshalStruct()` - Manual struct encoding (legacy)
  - **`json.MarshalMap()` - Automatic map serialization** ⭐
    - Automatically serializes all key-value pairs in a map
    - Supports string, int, float keys
    - Supports int, float, string, bool values
  - `json.MarshalAny()` - Generic marshal function
- **Map Runtime Implementation** ⭐
  - Full hash table implementation for maps
  - `map_create()` - Create new map
  - `map_set()` - Set key-value pair
  - `map_get()` - Get value by key
  - `map_len()` - Get map size
  - Automatic memory management
- Created example files:
  - `examples/struct_example.tl` - Demonstrates struct usage
  - `examples/map_example.tl` - Demonstrates map usage
  - `examples/json_advanced_example.tl` - JSON with structs, maps, and slices
  - `examples/json_auto_example.tl` - Automatic JSON serialization

#### Interfaces
- Added interface definition support
  - Interface syntax: `interface Writer { Write(data string) int; }`
  - Interface types: `interface Writer`
  - Method signatures in interfaces
- Interface implementation
  - Interfaces generate C structs with function pointer tables (vtables)
  - Similar to Go's interface implementation pattern
  - Interface struct contains vtable pointer and data pointer
- Created example file:
  - `examples/interface_example.tl` - Demonstrates interface definitions

#### Map Operations Enhancement
- Added `delete()` function for maps
  - Syntax: `delete(map, key)`
  - Removes key-value pair from map
  - Automatically frees memory
- Added `len()` function support for maps
  - Syntax: `len(map)`
  - Returns number of key-value pairs in map
  - Uses `map_len()` runtime function
- Added map iteration support ⭐
  - Range-based loop: `malli key, value := range map { ... }`
  - Key-only iteration: `malli key := range map { ... }`
  - Uses map iterator (MapIterator) for efficient iteration
  - Supports iteration over all map entries
- Enhanced map runtime
  - Added `map_delete()` function
  - Added `map_iter()` and `map_next()` for iteration
  - MapIterator struct for safe iteration
- Created example files:
  - `examples/map_operations_example.tl` - Demonstrates delete(), len(), and iteration
  - `examples/map_iteration_example.tl` - Demonstrates map iteration with range loops

#### Error Handling Verification & Improvements ⭐
- Verified error handling implementation
  - ✅ Error creation (`thappu "message"`) works correctly
  - ✅ Error checking (`thappu err ayithe { ... }`) works correctly
  - ✅ Error return (`pampu thappu "message"`) works correctly
  - ✅ Nil values (`sunyam`) work correctly
- Added `errors` standard library
  - `errors.New(message)` - Create new error
  - `errors.Errorf(format, arg1)` - Format error message
  - `errors.Wrap(err, context)` - Wrap error with context
  - `errors.IsNil(err)` - Check if error is nil
  - `errors.Unwrap(err)` - Get underlying error (placeholder)
- Created comprehensive documentation
  - `docs/error-handling-verification.md` - Complete verification report
  - `docs/error-handling-improvements.md` - Improvement plan
  - `docs/libraries/errors.md` - Errors library documentation
- Created example files:
  - `examples/error_handling_comprehensive.tl` - All error patterns
  - `examples/error_helpers_example.tl` - Using errors library
- Limitations documented:
  - Multiple return values not supported (e.g., `(int, error)`)
  - Error propagation operator not supported (e.g., `?`)
  - Error wrapping works but requires manual string concatenation

#### JSON Unmarshal Enhancements ⭐
- Enhanced JSON parsing capabilities
  - `json.UnmarshalString(json)` - Parse JSON strings with escape sequence handling
  - `json.UnmarshalInt(json)` - Parse JSON numbers to integers
  - `json.UnmarshalFloat(json)` - Parse JSON numbers to floats
  - `json.UnmarshalBool(json)` - Parse JSON booleans
  - `json.UnmarshalArray(json, elem_type)` - Parse JSON arrays to slices
  - Enhanced `json.Unmarshal()` - Improved type conversion
- Added JSON parser infrastructure
  - JSON parser state structure
  - Whitespace skipping
  - Escape sequence handling in strings
  - Number parsing (integers and floats)
  - Boolean parsing (true/false)
  - Basic array parsing
- Created example file:
  - `examples/json_unmarshal_example.tl` - Demonstrates all unmarshal functions
- Updated documentation:
  - `docs/json-unmarshal-status.md` - Status and implementation details
  - `docs/json-unmarshal-verification.md` - Verification report
  - `docs/libraries/json.md` - Updated with new functions
- Current status:
  - ✅ Basic types (string, int, float, bool) fully supported
  - ✅ Arrays/slices parsing supported
  - ✅ Struct unmarshaling - **NEW** ⭐ Automatic with compiler-generated functions
  - ✅ Nested structures - **NEW** ⭐ Fully supported
  - ✅ Map unmarshaling - **NEW** ⭐ `json.UnmarshalMap()` with full type support
- Map unmarshaling implementation:
  - Added `json_GetObjectKeys()` - Extract all keys from JSON objects
  - Added `json.UnmarshalMap(json, key_type, value_type)` - Parse JSON objects to maps
  - Supports all key types: string, int, float
  - Supports all value types: int, float, string, bool
  - Handles empty objects gracefully
  - Proper memory management
  - Created example file: `examples/json_map_unmarshal_example.tl`

#### HTTP/Networking Implementation ⭐
- Implemented full HTTP client and server support
  - Added `net` library with cross-platform socket support
  - Implemented DNS resolution (`net.ResolveHost`)
  - Implemented TCP socket operations (`net.Dial`, `net.Send`, `net.Recv`, `net.Close`)
  - Implemented HTTP server socket operations (`net.Listen`, `net.Accept`)
  - Cross-platform support: Windows (Winsock2) and POSIX (sys/socket.h)
- HTTP Client implementation:
  - `http.Get(url)` - Make HTTP GET requests (fully functional)
  - `http.Post(url, data)` - Make HTTP POST requests (fully functional)
  - Automatic URL parsing (host, port, path extraction)
  - HTTP response parsing (extracts body from headers)
  - Proper connection management
- HTTP Server implementation:
  - `http.ListenAndServe(addr, handler)` - Start HTTP server (enhanced implementation) ⭐
  - Listens on specified port
  - Accepts and handles connections
  - Full request parsing (method, path, headers, body) - **NEW** ⭐
  - Handler function support - **NEW** ⭐ Function pointer for custom request handling
  - Request routing - **NEW** ⭐ Basic path-based routing
  - Response generation helpers - **NEW** ⭐ `http.Response()`, `http.JSONResponse()`, `http.HTMLResponse()`
  - Query parameter extraction - **NEW** ⭐ `http_get_query_param()`
  - Proper HTTP status codes (200, 404, 400, 500) - **NEW** ⭐
- Created example files:
  - `examples/http_client_example.tl` - HTTP GET and POST examples
  - `examples/http_server_example.tl` - HTTP server example
  - `examples/http_server_advanced_example.tl` - Enhanced server example ⭐
  - `examples/http_server_routing_example.tl` - Routing example ⭐
  - `examples/net_example.tl` - Network utilities examples
- Created documentation:
  - `docs/http-server-guide.md` - Complete HTTP server guide ⭐
- Current status:
  - ✅ Socket support (cross-platform)
  - ✅ DNS resolution
  - ✅ HTTP client (GET, POST, PUT, DELETE)
  - ✅ HTTP server (enhanced) - **NEW** ⭐ Full request parsing, routing, handlers
  - ✅ Advanced HTTP features - PUT/DELETE, redirects, custom headers fully supported
  - ⚠️ HTTPS/TLS not yet implemented (requires OpenSSL)
- Struct unmarshaling implementation:
  - Added `json_GetObjectValue()` - Extract field values from JSON objects
  - Added `json.UnmarshalStruct()` - Generic struct unmarshaling helper
  - Compiler now generates `json_unmarshal_<structname>()` functions automatically
  - Supports all field types: int, float, string, bool, nested structs, slices, arrays
  - Missing fields handled gracefully (default to zero values)
  - Created example file: `examples/json_struct_unmarshal_example.tl`

#### Go-Style Package Visibility ⭐
- Implemented Go-style export rules
  - Uppercase first letter = exported (public)
  - Lowercase first letter = unexported (private)
- Added `PackageResolver::is_exported()` helper function
- Updated package loading to only export uppercase identifiers
- Updated code generation to only generate exported functions from imported packages
- Visibility applies to:
  - Functions (`#Add()` vs `#add()`)
  - Variables (`@Counter` vs `@counter`)
  - Constants (`@@MaxValue` vs `@@maxValue`)
  - Structs (`amarika Point` vs `amarika point`)
  - Interfaces (`interface Writer` vs `interface writer`)
- Created example files:
  - `examples/package_visibility_example.tl` - Demonstrates exported vs unexported identifiers
  - `examples/package_import_example.tl` - Shows how to use exported identifiers from other packages
- Created documentation:
  - `docs/package-visibility.md` - Complete guide to package visibility rules
- Multiple Return Values and Error Propagation ⭐
  - Added tuple type support `(type1, type2, ...)` for multiple return values
  - Functions can now return multiple values: `#func() (int, error)`
  - Added tuple literal syntax: `(value, error)` in return statements
  - Added multiple assignment: `@a, @b = func()` - assigns tuple return to multiple variables
  - Added error propagation operator `?`: `expr?` automatically checks and returns errors
  - Tuple return types generate structs automatically (`Tuple_int_charptr` for `(int, error)`)
  - Error propagation works with both tuple returns and single error returns
  - Parser enhancements:
    - Parse tuple types in function signatures
    - Parse tuple literals in return statements
    - Parse multiple variable declarations with tuple assignment
    - Parse `?` operator for error propagation
  - Code generation enhancements:
    - Generate tuple structs for multiple return types
    - Generate struct literals for tuple returns
    - Generate multiple variable assignments from tuple returns
    - Generate error checks for `?` operator
  - Created example file: `examples/multiple_return_values_example.tl`
  - Created documentation: `docs/multiple-return-values.md`
- JSON Validation and Enhanced Error Messages ⭐
  - Added `json.Validate(json)` - Validates JSON syntax with detailed error messages
  - Added `json.ValidateSchema(json, schema)` - Validates JSON against schema
  - Enhanced JSON parser with position tracking (line/column numbers)
  - Improved error messages with context and position information
  - Schema format: `"field1:type1,field2:type2,..."` with types: string, int, float, bool, array, object
  - Error messages include line/column numbers for better debugging
  - Created example file: `examples/json_validation_example.tl`
  - Updated documentation: `docs/libraries/json.md`
- Go-like Struct Tags for JSON Schema Validation ⭐
  - Added struct tag support: `field type `json:"fieldname" validate:"required"``
  - Parser now parses backtick-delimited struct tags
  - Automatic schema generation from struct tags
  - Compiler generates `json_validate_<structname>()` functions automatically
  - JSON field name mapping via `json:"fieldname"` tag
  - Validation rules via `validate:"required"` tag (future: min, max, etc.)
  - No need for separate schema strings - schema comes from struct definition
  - Created example file: `examples/json_struct_tags_example.tl`
  - Updated documentation: `docs/libraries/json.md`
