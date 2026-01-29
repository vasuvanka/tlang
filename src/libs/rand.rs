// rand - Random Number Generation library
// Ported from Go's math/rand package

pub fn generate_rand_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <time.h>\n");
    code.push_str("\n");
    
    // Global random seed (initialized on first use)
    code.push_str("static int rand_initialized = 0;\n");
    code.push_str("static unsigned int rand_seed = 0;\n\n");
    
    // Initialize random number generator if not already initialized
    code.push_str("static void rand_init() {\n");
    code.push_str("    if (!rand_initialized) {\n");
    code.push_str("        rand_seed = (unsigned int)time(NULL);\n");
    code.push_str("        srand(rand_seed);\n");
    code.push_str("        rand_initialized = 1;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // Int - Random integer
    code.push_str("// rand.Int - Random integer\n");
    code.push_str("int rand_Int() {\n");
    code.push_str("    rand_init();\n");
    code.push_str("    return rand();\n");
    code.push_str("}\n\n");
    
    // Intn - Random integer in range [0, n)
    code.push_str("// rand.Intn - Random integer in range [0, n)\n");
    code.push_str("int rand_Intn(int n) {\n");
    code.push_str("    if (n <= 0) return 0;\n");
    code.push_str("    rand_init();\n");
    code.push_str("    return rand() % n;\n");
    code.push_str("}\n\n");
    
    // Float64 - Random float in [0.0, 1.0)
    code.push_str("// rand.Float64 - Random float in [0.0, 1.0)\n");
    code.push_str("double rand_Float64() {\n");
    code.push_str("    rand_init();\n");
    code.push_str("    return (double)rand() / (double)(RAND_MAX + 1.0);\n");
    code.push_str("}\n\n");
    
    // Float64Range - Random float in range [min, max)
    code.push_str("// rand.Float64Range - Random float in range [min, max)\n");
    code.push_str("double rand_Float64Range(double min, double max) {\n");
    code.push_str("    if (max <= min) return min;\n");
    code.push_str("    rand_init();\n");
    code.push_str("    double range = max - min;\n");
    code.push_str("    return min + (rand_Float64() * range);\n");
    code.push_str("}\n\n");
    
    // Seed - Seed random number generator
    code.push_str("// rand.Seed - Seed random number generator\n");
    code.push_str("void rand_Seed(int seed) {\n");
    code.push_str("    rand_seed = (unsigned int)seed;\n");
    code.push_str("    srand(rand_seed);\n");
    code.push_str("    rand_initialized = 1;\n");
    code.push_str("}\n\n");
    
    // UUID - Generate UUID v4 (random UUID)
    code.push_str("// rand.UUID - Generate UUID v4 (random UUID)\n");
    code.push_str("char* rand_UUID() {\n");
    code.push_str("    static char uuid[37]; // 36 chars + null terminator\n");
    code.push_str("    rand_init();\n");
    code.push_str("    \n");
    code.push_str("    // Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx\n");
    code.push_str("    // where x is any hexadecimal digit and y is one of 8, 9, A, or B\n");
    code.push_str("    const char hex[] = \"0123456789abcdef\";\n");
    code.push_str("    \n");
    code.push_str("    int i = 0;\n");
    code.push_str("    for (int pos = 0; pos < 36; pos++) {\n");
    code.push_str("        if (pos == 8 || pos == 13 || pos == 18 || pos == 23) {\n");
    code.push_str("            uuid[pos] = '-';\n");
    code.push_str("        } else if (pos == 14) {\n");
    code.push_str("            // Version 4 identifier\n");
    code.push_str("            uuid[pos] = '4';\n");
    code.push_str("        } else if (pos == 19) {\n");
    code.push_str("            // Variant identifier (8, 9, a, or b)\n");
    code.push_str("            char variants[] = \"89ab\";\n");
    code.push_str("            uuid[pos] = variants[rand_Intn(4)];\n");
    code.push_str("        } else {\n");
    code.push_str("            uuid[pos] = hex[rand_Intn(16)];\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    uuid[36] = '\\0';\n");
    code.push_str("    return uuid;\n");
    code.push_str("}\n\n");
    
    // RandomString - Generate random string of given length
    code.push_str("// rand.RandomString - Generate random string of given length\n");
    code.push_str("char* rand_RandomString(int length) {\n");
    code.push_str("    static char result[1024]; // Max 1023 characters\n");
    code.push_str("    if (length <= 0) {\n");
    code.push_str("        result[0] = '\\0';\n");
    code.push_str("        return result;\n");
    code.push_str("    }\n");
    code.push_str("    if (length >= sizeof(result)) {\n");
    code.push_str("        length = sizeof(result) - 1;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    rand_init();\n");
    code.push_str("    const char chars[] = \"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\";\n");
    code.push_str("    int chars_len = 62; // 26 lowercase + 26 uppercase + 10 digits\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < length; i++) {\n");
    code.push_str("        result[i] = chars[rand_Intn(chars_len)];\n");
    code.push_str("    }\n");
    code.push_str("    result[length] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // Shuffle - Shuffle array in place (note: requires array support, placeholder for now)
    code.push_str("// rand.Shuffle - Shuffle array in place\n");
    code.push_str("// Note: Requires array support in Tlang (placeholder implementation)\n");
    code.push_str("void rand_Shuffle(int* arr, int len) {\n");
    code.push_str("    if (arr == NULL || len <= 1) return;\n");
    code.push_str("    rand_init();\n");
    code.push_str("    \n");
    code.push_str("    // Fisher-Yates shuffle algorithm\n");
    code.push_str("    for (int i = len - 1; i > 0; i--) {\n");
    code.push_str("        int j = rand_Intn(i + 1);\n");
    code.push_str("        // Swap arr[i] and arr[j]\n");
    code.push_str("        int temp = arr[i];\n");
    code.push_str("        arr[i] = arr[j];\n");
    code.push_str("        arr[j] = temp;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // Choice - Random element from array (note: requires array support, placeholder for now)
    code.push_str("// rand.Choice - Random element from string array\n");
    code.push_str("// Note: Requires array support in Tlang (placeholder implementation)\n");
    code.push_str("char* rand_Choice(char** arr, int len) {\n");
    code.push_str("    if (arr == NULL || len <= 0) {\n");
    code.push_str("        static char empty[1] = \"\";\n");
    code.push_str("        return empty;\n");
    code.push_str("    }\n");
    code.push_str("    rand_init();\n");
    code.push_str("    int index = rand_Intn(len);\n");
    code.push_str("    return arr[index];\n");
    code.push_str("}\n\n");
    
    code
}
