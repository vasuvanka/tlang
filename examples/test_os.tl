// Test cases for os library

#prarambham() {
    fmt.Printf("=== os Library Tests ===\n");
    
    // Getenv tests
    @home string = os.Getenv("HOME");
    @path string = os.Getenv("PATH");
    @user string = os.Getenv("USER");
    @nonexistent string = os.Getenv("TLANG_NONEXISTENT_VAR");
    
    fmt.Printf("Getenv('HOME'): %s\n", home);
    fmt.Printf("Getenv('PATH'): %s (length > 0: %d)\n", path, strings.Index(path, ""));
    fmt.Printf("Getenv('USER'): %s\n", user);
    fmt.Printf("Getenv('TLANG_NONEXISTENT_VAR'): '%s' (should be empty)\n", nonexistent);
    
    // Getwd test
    @cwd string = os.Getwd();
    fmt.Printf("Getwd: %s\n", cwd);
    fmt.Printf("Getwd is absolute: %d\n", filepath.IsAbs(cwd));
    
    // Setenv and Getenv combination
    @testVar string = "TLANG_TEST_VAR";
    @testValue string = "test_value_123";
    
    @setResult int = os.Setenv(testVar, testValue);
    fmt.Printf("Setenv('%s', '%s'): %d\n", testVar, testValue, setResult);
    
    @getValue string = os.Getenv(testVar);
    fmt.Printf("Getenv('%s'): %s (expected: '%s')\n", testVar, getValue, testValue);
    
    // Test Chdir (be careful with this in tests)
    @originalCwd string = os.Getwd();
    fmt.Printf("Original CWD: %s\n", originalCwd);
    
    // Note: Chdir tests should be done carefully to avoid breaking test environment
    fmt.Printf("Chdir tests skipped (would change working directory)\n");
}

//

//

//

// === OUTPUT ===
// === os Library Tests ===
// Getenv('HOME'): 
// Getenv('PATH'): c:\Users\vanka\.cursor\extensions\vadimcn.vscode-lldb-1.12.1\bin;C:\Program Files\Python312\Scripts\;C:\Program Files\Python312\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Git\cmd;C:\ProgramData\chocolatey\bin;C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin;C:\Users\vanka\AppData\Local\nvm;C:\nvm4w\nodejs;C:\Program Files\nodejs\;C:\Program Files\cursor\resources\app\bin;C:\Program Files\Docker\Docker\resources\bin;C:\Program Files\Go\bin;C:\ProgramData\mingw64\mingw64\bin;C:\Users\vanka\AppData\Local\Programs\Python\Launcher\;%PNPM_HOME%;C:\Users\vanka\scoop\shims;C:\Users\vanka\.cargo\bin;C:\Users\vanka\AppData\Local\Microsoft\WindowsApps;C:\Users\vanka\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\vanka\go\bin;C:\Users\vanka\.deno\bin;C:\ProgramData\chocolatey\bin;C:\Users\vanka\AppData\Local\Microsoft\WindowsApps;C:\Users\vanka\AppData\Local\nvm;C:\nvm4w\nodejs;C:\Users\vanka\AppData\Roaming\npm;C:\Users\vanka\go\bin;C:\Users\vanka\AppData\Local\Programs\Antigravity\bin (length > 0: 0)
// Getenv('USER'): 
// Getenv('TLANG_NONEXISTENT_VAR'): '' (should be empty)
// Getwd: C:\Users\vanka\github.com\vasuvanka\tlang
// Getwd is absolute: 1
// Setenv('TLANG_TEST_VAR', 'test_value_123'): 0
// Getenv('TLANG_TEST_VAR'): test_value_123 (expected: 'test_value_123')
// Original CWD: C:\Users\vanka\github.com\vasuvanka\tlang
// Chdir tests skipped (would change working directory)
//
