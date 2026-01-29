// Comprehensive Test Suite for All Tlang Standard Libraries
// This file tests all library functions with various inputs and edge cases

#prarambham() {
    fmt.Printf("=== Starting Library Test Suite ===\n\n");
    
    // ========== fmt Library Tests ==========
    fmt.Printf("--- Testing fmt Library ---\n");
    @formatted string = fmt.Sprintf("Number: %d, Float: %f, String: %s\n", 42, 3.14, "test");
    fmt.Printf("Sprintf result: %s", formatted);
    
    // ========== strings Library Tests ==========
    fmt.Printf("\n--- Testing strings Library ---\n");
    
    // Contains
    @text string = "Hello World";
    @contains1 int = strings.Contains(text, "Hello");
    @contains2 int = strings.Contains(text, "xyz");
    fmt.Printf("Contains('Hello'): %d (expected: 1)\n", contains1);
    fmt.Printf("Contains('xyz'): %d (expected: 0)\n", contains2);
    
    // HasPrefix
    @hasPrefix1 int = strings.HasPrefix(text, "Hello");
    @hasPrefix2 int = strings.HasPrefix(text, "World");
    fmt.Printf("HasPrefix('Hello'): %d (expected: 1)\n", hasPrefix1);
    fmt.Printf("HasPrefix('World'): %d (expected: 0)\n", hasPrefix2);
    
    // HasSuffix
    @hasSuffix1 int = strings.HasSuffix(text, "World");
    @hasSuffix2 int = strings.HasSuffix(text, "Hello");
    fmt.Printf("HasSuffix('World'): %d (expected: 1)\n", hasSuffix1);
    fmt.Printf("HasSuffix('Hello'): %d (expected: 0)\n", hasSuffix2);
    
    // Index
    @index1 int = strings.Index(text, "World");
    @index2 int = strings.Index(text, "xyz");
    fmt.Printf("Index('World'): %d (expected: 6)\n", index1);
    fmt.Printf("Index('xyz'): %d (expected: -1)\n", index2);
    
    // ToUpper
    @upper string = strings.ToUpper(text);
    fmt.Printf("ToUpper: %s (expected: HELLO WORLD)\n", upper);
    
    // ToLower
    @lower string = strings.ToLower("HELLO WORLD");
    fmt.Printf("ToLower: %s (expected: hello world)\n", lower);
    
    // TrimSpace
    @trimmed string = strings.TrimSpace("  Hello World  ");
    fmt.Printf("TrimSpace: '%s' (expected: 'Hello World')\n", trimmed);
    
    // ========== math Library Tests ==========
    fmt.Printf("\n--- Testing math Library ---\n");
    
    // Constants
    @pi float = math.Pi();
    @e float = math.E();
    fmt.Printf("Pi: %f (expected: ~3.141593)\n", pi);
    fmt.Printf("E: %f (expected: ~2.718282)\n", e);
    
    // Basic operations
    @abs1 float = math.Abs(-5.5);
    @abs2 float = math.Abs(5.5);
    fmt.Printf("Abs(-5.5): %f (expected: 5.5)\n", abs1);
    fmt.Printf("Abs(5.5): %f (expected: 5.5)\n", abs2);
    
    @max float = math.Max(10.0, 20.0);
    @min float = math.Min(10.0, 20.0);
    fmt.Printf("Max(10, 20): %f (expected: 20.0)\n", max);
    fmt.Printf("Min(10, 20): %f (expected: 10.0)\n", min);
    
    // Square root and power
    @sqrt float = math.Sqrt(16.0);
    @pow float = math.Pow(2.0, 3.0);
    fmt.Printf("Sqrt(16): %f (expected: 4.0)\n", sqrt);
    fmt.Printf("Pow(2, 3): %f (expected: 8.0)\n", pow);
    
    // Exponential and logarithms
    @exp float = math.Exp(1.0);
    @log float = math.Log(math.E());
    @log10 float = math.Log10(100.0);
    fmt.Printf("Exp(1): %f (expected: ~2.718282)\n", exp);
    fmt.Printf("Log(e): %f (expected: ~1.0)\n", log);
    fmt.Printf("Log10(100): %f (expected: 2.0)\n", log10);
    
    // Trigonometric functions
    @sin float = math.Sin(0.0);
    @cos float = math.Cos(0.0);
    @tan float = math.Tan(0.0);
    fmt.Printf("Sin(0): %f (expected: 0.0)\n", sin);
    fmt.Printf("Cos(0): %f (expected: 1.0)\n", cos);
    fmt.Printf("Tan(0): %f (expected: 0.0)\n", tan);
    
    // Inverse trigonometric
    @asin float = math.Asin(0.0);
    @acos float = math.Acos(1.0);
    @atan float = math.Atan(0.0);
    fmt.Printf("Asin(0): %f (expected: 0.0)\n", asin);
    fmt.Printf("Acos(1): %f (expected: 0.0)\n", acos);
    fmt.Printf("Atan(0): %f (expected: 0.0)\n", atan);
    
    // Rounding functions
    @ceil float = math.Ceil(3.7);
    @floor float = math.Floor(3.7);
    @round float = math.Round(3.7);
    @trunc float = math.Trunc(3.7);
    fmt.Printf("Ceil(3.7): %f (expected: 4.0)\n", ceil);
    fmt.Printf("Floor(3.7): %f (expected: 3.0)\n", floor);
    fmt.Printf("Round(3.7): %f (expected: 4.0)\n", round);
    fmt.Printf("Trunc(3.7): %f (expected: 3.0)\n", trunc);
    
    // ========== strconv Library Tests ==========
    fmt.Printf("\n--- Testing strconv Library ---\n");
    
    // String to int
    @num1 int = strconv.Atoi("123");
    @num2 int = strconv.Atoi("-456");
    fmt.Printf("Atoi('123'): %d (expected: 123)\n", num1);
    fmt.Printf("Atoi('-456'): %d (expected: -456)\n", num2);
    
    // Int to string
    @str1 string = strconv.Itoa(123);
    @str2 string = strconv.Itoa(-456);
    fmt.Printf("Itoa(123): %s (expected: '123')\n", str1);
    fmt.Printf("Itoa(-456): %s (expected: '-456')\n", str2);
    
    // String to float
    @float1 float = strconv.ParseFloat("3.14");
    @float2 float = strconv.ParseFloat("-2.5");
    fmt.Printf("ParseFloat('3.14'): %f (expected: 3.14)\n", float1);
    fmt.Printf("ParseFloat('-2.5'): %f (expected: -2.5)\n", float2);
    
    // Float to string
    @floatStr1 string = strconv.FormatFloat(3.14, 2);
    @floatStr2 string = strconv.FormatFloat(-2.5, 1);
    fmt.Printf("FormatFloat(3.14, 2): %s\n", floatStr1);
    fmt.Printf("FormatFloat(-2.5, 1): %s\n", floatStr2);
    
    // String to bool
    @bool1 int = strconv.ParseBool("true");
    @bool2 int = strconv.ParseBool("false");
    @bool3 int = strconv.ParseBool("1");
    @bool4 int = strconv.ParseBool("0");
    fmt.Printf("ParseBool('true'): %d (expected: 1)\n", bool1);
    fmt.Printf("ParseBool('false'): %d (expected: 0)\n", bool2);
    fmt.Printf("ParseBool('1'): %d (expected: 1)\n", bool3);
    fmt.Printf("ParseBool('0'): %d (expected: 0)\n", bool4);
    
    // Bool to string
    @boolStr1 string = strconv.FormatBool(1);
    @boolStr2 string = strconv.FormatBool(0);
    fmt.Printf("FormatBool(1): %s (expected: 'true')\n", boolStr1);
    fmt.Printf("FormatBool(0): %s (expected: 'false')\n", boolStr2);
    
    // ========== os Library Tests ==========
    fmt.Printf("\n--- Testing os Library ---\n");
    
    // Getenv
    @home string = os.Getenv("HOME");
    @path string = os.Getenv("PATH");
    fmt.Printf("Getenv('HOME'): %s\n", home);
    fmt.Printf("Getenv('PATH'): %s (length: %d)\n", path, strings.Index(path, ""));
    
    // Getwd
    @cwd string = os.Getwd();
    fmt.Printf("Getwd: %s\n", cwd);
    
    // Setenv (test setting a test variable)
    @setResult int = os.Setenv("TLANG_TEST", "test_value");
    @testValue string = os.Getenv("TLANG_TEST");
    fmt.Printf("Setenv('TLANG_TEST'): %d\n", setResult);
    fmt.Printf("Getenv('TLANG_TEST'): %s (expected: 'test_value')\n", testValue);
    
    // ========== time Library Tests ==========
    fmt.Printf("\n--- Testing time Library ---\n");
    
    // Now
    @now long = time.Now();
    fmt.Printf("Now: %ld\n", now);
    
    // Format
    @formatted1 string = time.Format(now, "%Y-%m-%d");
    @formatted2 string = time.Format(now, "%H:%M:%S");
    fmt.Printf("Format(now, '%%Y-%%m-%%d'): %s\n", formatted1);
    fmt.Printf("Format(now, '%%H:%%M:%%S'): %s\n", formatted2);
    
    // Parse (test with a known timestamp format)
    @testTime string = "2024-01-01 12:00:00";
    @parsed long = time.Parse(testTime, "%Y-%m-%d %H:%M:%S");
    fmt.Printf("Parse('2024-01-01 12:00:00'): %ld\n", parsed);
    
    // Sleep (test with milliseconds to avoid long waits)
    fmt.Printf("Sleeping 100ms...\n");
    time.SleepMilliseconds(100);
    fmt.Printf("Sleep complete\n");
    
    // ========== filepath Library Tests ==========
    fmt.Printf("\n--- Testing filepath Library ---\n");
    
    // Join
    @joined1 string = filepath.Join("/usr", "local");
    @joined2 string = filepath.Join("dir1", "dir2");
    fmt.Printf("Join('/usr', 'local'): %s\n", joined1);
    fmt.Printf("Join('dir1', 'dir2'): %s\n", joined2);
    
    // Base
    @base1 string = filepath.Base("/usr/local/bin");
    @base2 string = filepath.Base("file.txt");
    fmt.Printf("Base('/usr/local/bin'): %s (expected: 'bin')\n", base1);
    fmt.Printf("Base('file.txt'): %s (expected: 'file.txt')\n", base2);
    
    // Dir
    @dir1 string = filepath.Dir("/usr/local/bin");
    @dir2 string = filepath.Dir("file.txt");
    fmt.Printf("Dir('/usr/local/bin'): %s (expected: '/usr/local')\n", dir1);
    fmt.Printf("Dir('file.txt'): %s (expected: '.')\n", dir2);
    
    // Ext
    @ext1 string = filepath.Ext("file.txt");
    @ext2 string = filepath.Ext("file.tar.gz");
    @ext3 string = filepath.Ext("noextension");
    fmt.Printf("Ext('file.txt'): %s (expected: '.txt')\n", ext1);
    fmt.Printf("Ext('file.tar.gz'): %s (expected: '.gz')\n", ext2);
    fmt.Printf("Ext('noextension'): %s (expected: '')\n", ext3);
    
    // Clean
    @clean1 string = filepath.Clean("/usr/../local/./bin");
    @clean2 string = filepath.Clean("./dir/../file");
    fmt.Printf("Clean('/usr/../local/./bin'): %s\n", clean1);
    fmt.Printf("Clean('./dir/../file'): %s\n", clean2);
    
    // IsAbs
    @isAbs1 int = filepath.IsAbs("/absolute/path");
    @isAbs2 int = filepath.IsAbs("relative/path");
    fmt.Printf("IsAbs('/absolute/path'): %d (expected: 1)\n", isAbs1);
    fmt.Printf("IsAbs('relative/path'): %d (expected: 0)\n", isAbs2);
    
    // Split
    @split1 string = filepath.Split("/usr/local/bin");
    fmt.Printf("Split('/usr/local/bin'): %s\n", split1);
    
    // Abs (test with relative path)
    @abs1 string = filepath.Abs("test.txt");
    fmt.Printf("Abs('test.txt'): %s\n", abs1);
    
    // ========== io Library Tests ==========
    fmt.Printf("\n--- Testing io Library ---\n");
    
    // WriteFile
    @testContent string = "This is a test file content\nLine 2\nLine 3";
    @written int = io.WriteFile("test_lib_output.txt", testContent);
    fmt.Printf("WriteFile: wrote %d bytes\n", written);
    
    // ReadFile
    @readContent string = io.ReadFile("test_lib_output.txt");
    fmt.Printf("ReadFile: read %d characters\n", strings.Index(readContent, ""));
    fmt.Printf("Content matches: %d\n", strings.Contains(readContent, "test file"));
    
    // Exists
    @exists1 int = io.Exists("test_lib_output.txt");
    @exists2 int = io.Exists("nonexistent_file.txt");
    fmt.Printf("Exists('test_lib_output.txt'): %d (expected: 1)\n", exists1);
    fmt.Printf("Exists('nonexistent_file.txt'): %d (expected: 0)\n", exists2);
    
    // IsDir
    @isDir1 int = io.IsDir(".");
    @isDir2 int = io.IsDir("test_lib_output.txt");
    fmt.Printf("IsDir('.'): %d (expected: 1)\n", isDir1);
    fmt.Printf("IsDir('test_lib_output.txt'): %d (expected: 0)\n", isDir2);
    
    // Stat
    @stat string = io.Stat("test_lib_output.txt");
    fmt.Printf("Stat('test_lib_output.txt'): %s\n", stat);
    
    // Mkdir
    @mkdirResult int = io.Mkdir("test_lib_dir", 0755);
    fmt.Printf("Mkdir('test_lib_dir'): %d\n", mkdirResult);
    
    // ReadDir
    @dirContents string = io.ReadDir(".");
    fmt.Printf("ReadDir('.'): found files/dirs\n");
    
    // Rename
    @renameResult int = io.Rename("test_lib_output.txt", "test_lib_renamed.txt");
    fmt.Printf("Rename: %d\n", renameResult);
    
    // Cleanup
    io.Remove("test_lib_renamed.txt");
    io.Remove("test_lib_dir");
    fmt.Printf("Cleanup: removed test files\n");
    
    // ========== bytes Library Tests ==========
    fmt.Printf("\n--- Testing bytes Library ---\n");
    
    // Note: bytes functions require length parameters
    // These are lower-level and may need special handling
    @bytesTest string = "Hello World";
    @bytesLen int = strings.Index(bytesTest, ""); // Get length approximation
    fmt.Printf("Bytes test string: %s (length: %d)\n", bytesTest, bytesLen);
    
    // ========== sort Library Tests ==========
    fmt.Printf("\n--- Testing sort Library ---\n");
    
    // Note: sort functions work on arrays, which may need special syntax
    // These tests would require array support in Tlang
    fmt.Printf("Sort library requires array support (to be tested when arrays are implemented)\n");
    
    // ========== json Library Tests ==========
    fmt.Printf("\n--- Testing json Library ---\n");
    
    // Marshal
    @jsonStr string = json.Marshal("string", "Hello");
    @jsonInt string = json.Marshal("int", "42");
    @jsonFloat string = json.Marshal("float", "3.14");
    @jsonBool string = json.Marshal("bool", "true");
    fmt.Printf("Marshal string: %s\n", jsonStr);
    fmt.Printf("Marshal int: %s\n", jsonInt);
    fmt.Printf("Marshal float: %s\n", jsonFloat);
    fmt.Printf("Marshal bool: %s\n", jsonBool);
    
    // Unmarshal
    @unmarshalStr string = json.Unmarshal("\"Hello\"", "string");
    @unmarshalInt string = json.Unmarshal("42", "int");
    fmt.Printf("Unmarshal string: %s\n", unmarshalStr);
    fmt.Printf("Unmarshal int: %s\n", unmarshalInt);
    
    // ========== http Library Tests ==========
    fmt.Printf("\n--- Testing http Library (Placeholder) ---\n");
    
    @httpGet string = http.Get("https://example.com");
    @httpPost string = http.Post("https://example.com", "data");
    fmt.Printf("http.Get (placeholder): %s", httpGet);
    fmt.Printf("http.Post (placeholder): %s", httpPost);
    
    fmt.Printf("\n=== Test Suite Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_all_libs.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_all_libs.tl:243:17: Variable 'abs1' is already declared in this scope
//
// Context (most recent call last):
//   1: while parsing variable declaration
//   2: while parsing function declaration
//
//
//   243 |     @abs1 string = filepath.Abs("test.txt");
//    |    ^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_all_libs.tl` (exit code: 1)
//
