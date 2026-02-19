// testing - Unit Testing library
// Ported from Go's testing package

pub fn generate_testing_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <math.h>\n");
    code.push_str("\n");
    
    // Test context structure
    code.push_str("// Test context structure\n");
    code.push_str("typedef struct {\n");
    code.push_str("    char name[256];\n");
    code.push_str("    int failed;\n");
    code.push_str("    int skipped;\n");
    code.push_str("    int passed;\n");
    code.push_str("} TestContext;\n\n");
    
    // Global test context
    code.push_str("static TestContext current_test = {0};\n");
    code.push_str("static int total_tests = 0;\n");
    code.push_str("static int total_passed = 0;\n");
    code.push_str("static int total_failed = 0;\n\n");
    
    // Fixture: optional setup/teardown (run before/after each test)
    code.push_str("static void (*testing_setup_fn)(void) = NULL;\n");
    code.push_str("static void (*testing_teardown_fn)(void) = NULL;\n\n");
    
    // Output format: 0=default, 1=TAP, 2=dot
    code.push_str("static int testing_output_mode = 0;\n");
    code.push_str("#define TESTING_MODE_DEFAULT 0\n");
    code.push_str("#define TESTING_MODE_TAP     1\n");
    code.push_str("#define TESTING_MODE_DOT     2\n\n");
    code.push_str("void testing_EnableTAP(int on) { testing_output_mode = on ? TESTING_MODE_TAP : TESTING_MODE_DEFAULT; }\n\n");
    code.push_str("void testing_SetDotMode(int on) { testing_output_mode = on ? TESTING_MODE_DOT : TESTING_MODE_DEFAULT; }\n\n");
    code.push_str("static int testing_fail_header_done = 0;\n");
    code.push_str("static void testing_print_fail_header(void) {\n");
    code.push_str("    if (testing_fail_header_done) return;\n");
    code.push_str("    testing_fail_header_done = 1;\n");
    code.push_str("    if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("        printf(\"# FAIL: %s\\n\", current_test.name);\n");
    code.push_str("    } else if (testing_output_mode != TESTING_MODE_DOT) {\n");
    code.push_str("        printf(\"    --- FAIL: %s\\n\", current_test.name);\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    code.push_str("// testing.RegisterSetup - Set function to run before each test\n");
    code.push_str("void testing_RegisterSetup(void (*fn)(void)) {\n");
    code.push_str("    testing_setup_fn = fn;\n");
    code.push_str("}\n\n");
    
    code.push_str("// testing.RegisterTeardown - Set function to run after each test\n");
    code.push_str("void testing_RegisterTeardown(void (*fn)(void)) {\n");
    code.push_str("    testing_teardown_fn = fn;\n");
    code.push_str("}\n\n");
    
    // testing.Run - Run a test function (calls setup before, teardown after if registered)
    code.push_str("// testing.Run - Run a test function\n");
    code.push_str("int testing_Run(const char* name, void (*test_func)()) {\n");
    code.push_str("    strncpy(current_test.name, name, sizeof(current_test.name) - 1);\n");
    code.push_str("    current_test.name[sizeof(current_test.name) - 1] = '\\0';\n");
    code.push_str("    current_test.failed = 0;\n");
    code.push_str("    current_test.skipped = 0;\n");
    code.push_str("    current_test.passed = 0;\n");
    code.push_str("    testing_fail_header_done = 0;\n");
    code.push_str("    \n");
    code.push_str("    if (testing_output_mode == TESTING_MODE_DOT) {\n");
    code.push_str("        /* dot mode: no RUN line */\n");
    code.push_str("    } else if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("        if (total_tests == 0) printf(\"TAP version 13\\n\");\n");
    code.push_str("    } else {\n");
    code.push_str("        printf(\"RUN   %s\\n\", name);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    if (testing_setup_fn) testing_setup_fn();\n");
    code.push_str("    test_func();\n");
    code.push_str("    if (testing_teardown_fn) testing_teardown_fn();\n");
    code.push_str("    \n");
    code.push_str("    total_tests++;\n");
    code.push_str("    if (current_test.failed > 0) {\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"not ok %d - %s\\n\", total_tests, name);\n");
    code.push_str("        } else if (testing_output_mode == TESTING_MODE_DOT) {\n");
    code.push_str("            printf(\"F\"); fflush(stdout);\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"FAIL  %s\\n\", name);\n");
    code.push_str("        }\n");
    code.push_str("        total_failed++;\n");
    code.push_str("        return 1;\n");
    code.push_str("    } else {\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"ok %d - %s\\n\", total_tests, name);\n");
    code.push_str("        } else if (testing_output_mode == TESTING_MODE_DOT) {\n");
    code.push_str("            printf(\".\"); fflush(stdout);\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"PASS  %s\\n\", name);\n");
    code.push_str("        }\n");
    code.push_str("        total_passed++;\n");
    code.push_str("        return 0;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.Assert - Assert that condition is true
    code.push_str("// testing.Assert - Assert that condition is true\n");
    code.push_str("void testing_Assert(int condition, const char* message) {\n");
    code.push_str("    if (!condition) {\n");
    code.push_str("        testing_print_fail_header();\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"# %s\\n\", message ? message : \"assertion failed\");\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"    message: %s\\n\", message ? message : \"assertion failed\");\n");
    code.push_str("        }\n");
    code.push_str("        current_test.failed++;\n");
    code.push_str("    } else {\n");
    code.push_str("        current_test.passed++;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.AssertEqual - Assert that two values are equal
    code.push_str("// testing.AssertEqual - Assert that two integers are equal\n");
    code.push_str("void testing_AssertEqual(int expected, int actual, const char* message) {\n");
    code.push_str("    if (expected != actual) {\n");
    code.push_str("        testing_print_fail_header();\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"# %s: expected %d, got %d\\n\", message ? message : \"values not equal\", expected, actual);\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"    message: %s\\n\", message ? message : \"values not equal\");\n");
    code.push_str("            printf(\"    expected: %d\\n\", expected);\n");
    code.push_str("            printf(\"    got:      %d\\n\", actual);\n");
    code.push_str("        }\n");
    code.push_str("        current_test.failed++;\n");
    code.push_str("    } else {\n");
    code.push_str("        current_test.passed++;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.AssertEqualFloat - Assert that two floats are equal (with epsilon)
    code.push_str("// testing.AssertEqualFloat - Assert that two floats are equal (within epsilon)\n");
    code.push_str("void testing_AssertEqualFloat(double expected, double actual, double epsilon, const char* message) {\n");
    code.push_str("    double diff = expected > actual ? expected - actual : actual - expected;\n");
    code.push_str("    if (diff > epsilon) {\n");
    code.push_str("        testing_print_fail_header();\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"# %s: expected %f, got %f\\n\", message ? message : \"floats not equal\", expected, actual);\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"    message: %s\\n\", message ? message : \"floats not equal\");\n");
    code.push_str("            printf(\"    expected: %f\\n\", expected);\n");
    code.push_str("            printf(\"    got:      %f (diff %f)\\n\", actual, diff);\n");
    code.push_str("        }\n");
    code.push_str("        current_test.failed++;\n");
    code.push_str("    } else {\n");
    code.push_str("        current_test.passed++;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.AssertEqualString - Assert that two strings are equal
    code.push_str("// testing.AssertEqualString - Assert that two strings are equal\n");
    code.push_str("void testing_AssertEqualString(const char* expected, const char* actual, const char* message) {\n");
    code.push_str("    if (strcmp(expected, actual) != 0) {\n");
    code.push_str("        testing_print_fail_header();\n");
    code.push_str("        if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("            printf(\"# %s: expected '%s', got '%s'\\n\", message ? message : \"strings not equal\", expected, actual);\n");
    code.push_str("        } else {\n");
    code.push_str("            printf(\"    message: %s\\n\", message ? message : \"strings not equal\");\n");
    code.push_str("            printf(\"    expected: \\\"%s\\\"\\n\", expected);\n");
    code.push_str("            printf(\"    got:      \\\"%s\\\"\\n\", actual);\n");
    code.push_str("        }\n");
    code.push_str("        current_test.failed++;\n");
    code.push_str("    } else {\n");
    code.push_str("        current_test.passed++;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.Fail - Mark test as failed
    code.push_str("// testing.Fail - Mark test as failed\n");
    code.push_str("void testing_Fail(const char* message) {\n");
    code.push_str("    testing_print_fail_header();\n");
    code.push_str("    if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("        printf(\"# %s\\n\", message ? message : \"test failed\");\n");
    code.push_str("    } else {\n");
    code.push_str("        printf(\"    FAIL: %s\\n\", message ? message : \"test failed\");\n");
    code.push_str("    }\n");
    code.push_str("    current_test.failed++;\n");
    code.push_str("}\n\n");
    
    // testing.Skip - Skip the current test
    code.push_str("// testing.Skip - Skip the current test\n");
    code.push_str("void testing_Skip(const char* message) {\n");
    code.push_str("    printf(\"    SKIP: %s\\n\", message ? message : \"test skipped\");\n");
    code.push_str("    current_test.skipped++;\n");
    code.push_str("}\n\n");
    
    // testing.Log - Log a message during test
    code.push_str("// testing.Log - Log a message during test\n");
    code.push_str("void testing_Log(const char* message) {\n");
    code.push_str("    if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("        printf(\"# LOG: %s\\n\", message ? message : \"\");\n");
    code.push_str("    } else {\n");
    code.push_str("        printf(\"    LOG: %s\\n\", message ? message : \"\");\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.Summary - Print test summary
    code.push_str("// testing.Summary - Print test summary\n");
    code.push_str("void testing_Summary() {\n");
    code.push_str("    if (testing_output_mode == TESTING_MODE_TAP) {\n");
    code.push_str("        printf(\"1..%d\\n\", total_tests);\n");
    code.push_str("    } else if (testing_output_mode == TESTING_MODE_DOT) {\n");
    code.push_str("        printf(\"\\n\");\n");
    code.push_str("    }\n");
    code.push_str("    printf(\"\\n=== Test Summary ===\\n\");\n");
    code.push_str("    printf(\"Total tests: %d\\n\", total_tests);\n");
    code.push_str("    printf(\"Passed: %d\\n\", total_passed);\n");
    code.push_str("    printf(\"Failed: %d\\n\", total_failed);\n");
    code.push_str("    if (total_failed > 0) {\n");
    code.push_str("        printf(\"RESULT: FAILED\\n\");\n");
    code.push_str("    } else {\n");
    code.push_str("        printf(\"RESULT: PASSED\\n\");\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // testing.GetFailed - Get number of failed assertions in current test
    code.push_str("// testing.GetFailed - Get number of failed assertions in current test\n");
    code.push_str("int testing_GetFailed() {\n");
    code.push_str("    return current_test.failed;\n");
    code.push_str("}\n\n");
    
    code
}
