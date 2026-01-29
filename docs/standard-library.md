# Tlang Standard Library

Complete reference for all standard library modules available in Tlang.

## Overview

Tlang provides a comprehensive standard library inspired by Go's standard library. All functions are available using dot notation (e.g., `fmt.Printf`, `strings.ToUpper`).

## Library Modules

### Core Libraries

1. **[fmt](libraries/fmt.md)** - Formatting and I/O
2. **[strings](libraries/strings.md)** - String operations
3. **[strconv](libraries/strconv.md)** - String conversions
4. **[math](libraries/math.md)** - Mathematical functions

### System Libraries

5. **[os](libraries/os.md)** - Operating system interface
6. **[io](libraries/io.md)** - File I/O operations
7. **[filepath](libraries/filepath.md)** - Path manipulation
8. **[time](libraries/time.md)** - Time and date operations

### Utility Libraries

9. **[regexp](libraries/regexp.md)** - Regular expressions
10. **[rand](libraries/rand.md)** - Random number generation
11. **[log](libraries/log.md)** - Structured logging
12. **[testing](libraries/testing.md)** - Unit testing framework
13. **[args](libraries/args.md)** - Command-line arguments
14. **[flag](libraries/flag.md)** - Command-line flag parsing

### Data Libraries

15. **[bytes](libraries/bytes.md)** - Byte operations
16. **[sort](libraries/sort.md)** - Array sorting
17. **[json](libraries/json.md)** - JSON encoding/decoding
18. **[protobuf](libraries/protobuf.md)** - Protocol Buffers binary serialization

### Security Libraries

18. **[crypto](libraries/crypto.md)** - Comprehensive cryptographic library
   - Hash functions (MD5, SHA1, SHA256, SHA512, HMAC)
   - Symmetric encryption (AES, DES, AES-GCM, ChaCha20-Poly1305)
   - Asymmetric encryption (RSA, ECDSA/ECC, Ed25519)
   - Key derivation (PBKDF2, scrypt, Argon2)
   - Password hashing (bcrypt, Argon2)

### Encoding Libraries

19. **[encoding/hex](libraries/hex.md)** - Hexadecimal encoding/decoding
20. **[encoding/base64](libraries/base64.md)** - Base64 encoding/decoding

### Web Libraries

21. **[url](libraries/url.md)** - URL parsing and manipulation
22. **[net/url](libraries/neturl.md)** - Network URL utilities
23. **[http](libraries/http.md)** - HTTP client/server with TLS support

### Text Processing Libraries

24. **[unicode](libraries/unicode.md)** - Unicode character utilities

### Data Format Libraries

25. **[encoding/csv](libraries/csv.md)** - CSV file processing
26. **[encoding/xml](libraries/xml.md)** - XML processing

### I/O Libraries

27. **[bufio](libraries/bufio.md)** - Buffered I/O operations

### Testing Libraries

28. **[testing/benchmark](libraries/benchmark.md)** - Performance benchmarking

### Documentation Libraries

29. **[doc](libraries/doc.md)** - Documentation generation from comments

### Reflection Libraries

30. **[reflect](libraries/reflect.md)** - Runtime type information and introspection

## Quick Reference

### fmt - Formatting

```tl
fmt.Printf("Hello, %s!\n", name);
@result string = fmt.Sprintf("Value: %d", 42);
```

### strings - String Operations

```tl
@has int = strings.Contains(text, "hello");
@upper string = strings.ToUpper(text);
@index int = strings.Index(text, "world");
```

### math - Mathematics

```tl
@sqrt float = math.Sqrt(16.0);
@power float = math.Pow(2.0, 3.0);
@pi float = math.Pi();
```

### io - File I/O

```tl
@content string = io.ReadFile("file.txt");
@written int = io.WriteFile("output.txt", data);
@exists int = io.Exists("file.txt");
```

### time - Time Operations

```tl
@now int = time.Now();
@formatted string = time.Format(now, "%Y-%m-%d");
time.Sleep(1);  // Sleep 1 second
```

### rand - Random Numbers

```tl
@num int = rand.Intn(100);
@uuid string = rand.UUID();
@random string = rand.RandomString(16);
```

### log - Logging

```tl
log.Info("Application started");
log.Printf("Processing %d items", count);
log.SetLevel(0);  // DEBUG
```

### flag - Flag Parsing

```tl
@name string = flag.String("name", "Guest", "User name");
@port int = flag.Int("port", 8080, "Server port");
flag.Parse();
@value string = flag.GetString("name");
```

### crypto - Cryptographic Operations

```tl
// Hash functions
@hash string = crypto.SHA256("Hello, World!");
@hmac string = crypto.HMAC("key", "data", "sha256");

// Symmetric encryption
@encrypted string = crypto.AESGCMEncrypt("data", "key", "aad");
@decrypted string = crypto.AESGCMDecrypt(encrypted, "key", "aad");

// Asymmetric encryption
@keys string = crypto.RSAGenerateKeyPair(2048);
@encrypted string = crypto.RSAEncrypt("data", publicKey);
@decrypted string = crypto.RSADecrypt(encrypted, privateKey);

// Digital signatures
@signature string = crypto.Ed25519Sign("document", privateKey);
@valid int = crypto.Ed25519Verify("document", signature, publicKey);

// Password hashing
@hash string = crypto.BcryptHash("password", 10);
@valid int = crypto.BcryptVerify("password", hash);

// Key derivation
@key string = crypto.Scrypt("password", "salt", 16384, 8, 1, 32);
```

### encoding/hex - Hexadecimal Encoding

```tl
@encoded string = hex.Encode("Hello");
@decoded string = hex.Decode(encoded);
```

### url - URL Manipulation

```tl
@parsed string = url.Parse("https://example.com/path?query=value");
@escaped string = url.QueryEscape("hello world");
@joined string = url.JoinPath("https://example.com", "/api/users");
```

### unicode - Character Utilities

```tl
@isLetter int = unicode.IsLetter(65);  // 'A'
@upper int = unicode.ToUpper(97);      // 'a' -> 'A'
```

### encoding/csv - CSV Processing

```tl
@csvData string = csv.Read("data.csv");
@parsed string = csv.ParseLine("name,age,city");
csv.Write("output.csv", csvData);
```

### encoding/xml - XML Processing

```tl
@xml string = xml.Marshal("string", "name", "John");
@escaped string = xml.Escape("<tag>value</tag>");
```

### encoding/base64 - Base64 Encoding

```tl
@encoded string = base64.Encode("Hello, Tlang!");
@decoded string = base64.Decode(encoded);
@bytes string = base64.EncodeBytes("72|101|108|108|111");
```

### net/url - Network URL Utilities

```tl
@parsed string = neturl.Parse("https://user:pass@example.com:8080/path");
@hostname string = neturl.Hostname("https://example.com:8080");
```

### bufio - Buffered I/O

```tl
@reader int = bufio.NewReader("file.txt");
@line string = bufio.ReadLine(reader);
@writer int = bufio.NewWriter("output.txt");
bufio.Write(writer, "data");
```

### testing/benchmark - Benchmarking

```tl
benchmark.Start("operation");
// ... code to benchmark ...
@duration float = benchmark.Stop("operation");
benchmark.Report("operation");
```

### doc - Documentation Generation

```tl
@docs string = doc.Generate("myfile.tl");
doc.Write("myfile.md", docs);
@func_docs string = doc.ParseFunctionDocs(source, "myFunction");
```

### reflect - Reflection

```tl
@typeInfo string = reflect.TypeOf("int");
@kind int = reflect.Kind("int");
@valueInfo string = reflect.ValueOfInt(42);
```

## Library Status

| Library | Status | Functions |
|---------|--------|-----------|
| fmt | ✅ Complete | Printf, Sprintf |
| strings | ✅ Complete | Contains, ToUpper, ToLower, Index, etc. |
| math | ✅ Complete | All mathematical functions |
| strconv | ✅ Complete | Atoi, Itoa, ParseFloat, etc. |
| os | ✅ Complete | Getenv, Setenv, Exit, etc. |
| time | ✅ Complete | Now, Sleep, Format, Parse |
| io | ✅ Complete | ReadFile, WriteFile, Exists, etc. |
| filepath | ✅ Complete | Join, Base, Dir, Ext, etc. |
| regexp | ✅ Complete | Match, Find, Replace, Split |
| rand | ✅ Complete | Int, Intn, UUID, RandomString |
| log | ✅ Complete | Print, Printf, Debug, Info, etc. |
| testing | ✅ Complete | Run, Assert, AssertEqual, etc. |
| args | ✅ Complete | Init, Count, Get, Program |
| flag | ✅ Complete | String, Int, Bool, Float64, Parse, Args |
| crypto | ✅ Complete | Hash functions (MD5, SHA1, SHA256, SHA512, HMAC), Symmetric encryption (AES, DES, AES-GCM, ChaCha20-Poly1305), Asymmetric encryption (RSA, ECDSA/ECC, Ed25519), Key derivation (PBKDF2, scrypt, Argon2), Password hashing (bcrypt, Argon2) |
| encoding/hex | ✅ Complete | Encode, Decode, EncodeBytes, DecodeBytes |
| encoding/csv | ✅ Complete | Read, Write, ParseLine |
| encoding/xml | ✅ Complete | Marshal, Unmarshal, Escape, Unescape |
| url | ✅ Complete | Parse, QueryEscape, PathEscape, JoinPath |
| net/url | ✅ Complete | Parse, Hostname, Port, User |
| unicode | ✅ Complete | IsLetter, IsDigit, ToUpper, ToLower, etc. |
| bufio | ✅ Complete | NewReader, ReadLine, NewWriter, Write, Flush |
| testing/benchmark | ✅ Complete | Start, Stop, Report, Reset, GetDuration |
| doc | ✅ Complete | ExtractComments, Format, Generate, Write, ParseFunctionDocs |
| reflect | ✅ Complete | TypeOf, ValueOf, Kind, Size, Name, IsInt, IsFloat, IsString |
| bytes | ✅ Complete | Contains, Index, Equal |
| sort | ✅ Complete | Ints, Float64s, Strings |
| json | ✅ Complete | Marshal, Unmarshal, auto struct/map serialization |
| http | ✅ Complete | Get, Post, Request, ListenAndServe with TLS/HTTPS |

## Usage Pattern

All libraries follow the same pattern:

```tl
libraryName.functionName(arguments)
```

Examples:

```tl
// fmt library
fmt.Printf("Hello\n");

// strings library
strings.ToUpper("hello");

// math library
math.Sqrt(16.0);

// io library
io.ReadFile("file.txt");
```

## Getting Help

For detailed documentation on each library:

- See individual library documentation in `docs/libraries/`
- Check examples in `examples/` directory
- Review [Tutorial](tutorial.md) for usage examples

## Contributing

Want to add more functions to a library? Check the implementation in `src/libs/` and follow the existing patterns.
