// strings - String operations library
// Ported from Go's strings package

pub fn generate_strings_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <string.h>\n");
    code.push_str("#include <ctype.h>\n\n");
    
    // Contains
    code.push_str("// strings.Contains - Checks if string contains substring\n");
    code.push_str("int strings_Contains(const char* s, const char* substr) {\n");
    code.push_str("    return strstr(s, substr) != NULL ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // HasPrefix
    code.push_str("// strings.HasPrefix - Checks if string has prefix\n");
    code.push_str("int strings_HasPrefix(const char* s, const char* prefix) {\n");
    code.push_str("    size_t len = strlen(prefix);\n");
    code.push_str("    return strncmp(s, prefix, len) == 0 ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // HasSuffix
    code.push_str("// strings.HasSuffix - Checks if string has suffix\n");
    code.push_str("int strings_HasSuffix(const char* s, const char* suffix) {\n");
    code.push_str("    size_t len_s = strlen(s);\n");
    code.push_str("    size_t len_suffix = strlen(suffix);\n");
    code.push_str("    if (len_suffix > len_s) return 0;\n");
    code.push_str("    return strcmp(s + len_s - len_suffix, suffix) == 0 ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // Index
    code.push_str("// strings.Index - Returns index of substring\n");
    code.push_str("int strings_Index(const char* s, const char* substr) {\n");
    code.push_str("    char* pos = strstr(s, substr);\n");
    code.push_str("    return pos ? (int)(pos - s) : -1;\n");
    code.push_str("}\n\n");
    
    // Substring - Returns s[start:end] (end exclusive). Uses static buffer, max 4096 chars.
    code.push_str("// strings.Substring - Returns substring from start to end (end exclusive)\n");
    code.push_str("char* strings_Substring(const char* s, int start, int end) {\n");
    code.push_str("    static char buffer[4096];\n");
    code.push_str("    if (!s || start < 0 || end <= start) { buffer[0] = '\\0'; return buffer; }\n");
    code.push_str("    size_t len = strlen(s);\n");
    code.push_str("    if ((size_t)start >= len) { buffer[0] = '\\0'; return buffer; }\n");
    code.push_str("    if ((size_t)end > len) end = (int)len;\n");
    code.push_str("    int n = end - start;\n");
    code.push_str("    if (n >= 4096) n = 4095;\n");
    code.push_str("    strncpy(buffer, s + start, n);\n");
    code.push_str("    buffer[n] = '\\0';\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // ToUpper
    code.push_str("// strings.ToUpper - Converts to uppercase\n");
    code.push_str("char* strings_ToUpper(const char* s) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    strncpy(buffer, s, sizeof(buffer) - 1);\n");
    code.push_str("    buffer[sizeof(buffer) - 1] = '\\0';\n");
    code.push_str("    for (int i = 0; buffer[i]; i++) {\n");
    code.push_str("        buffer[i] = toupper(buffer[i]);\n");
    code.push_str("    }\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // ToLower
    code.push_str("// strings.ToLower - Converts to lowercase\n");
    code.push_str("char* strings_ToLower(const char* s) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    strncpy(buffer, s, sizeof(buffer) - 1);\n");
    code.push_str("    buffer[sizeof(buffer) - 1] = '\\0';\n");
    code.push_str("    for (int i = 0; buffer[i]; i++) {\n");
    code.push_str("        buffer[i] = tolower(buffer[i]);\n");
    code.push_str("    }\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // TrimSpace
    code.push_str("// strings.TrimSpace - Removes leading and trailing whitespace\n");
    code.push_str("char* strings_TrimSpace(const char* s) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    int start = 0;\n");
    code.push_str("    int end = strlen(s) - 1;\n");
    code.push_str("    while (isspace(s[start]) && start <= end) start++;\n");
    code.push_str("    while (isspace(s[end]) && end >= start) end--;\n");
    code.push_str("    int len = end - start + 1;\n");
    code.push_str("    if (len < 0) len = 0;\n");
    code.push_str("    strncpy(buffer, s + start, len);\n");
    code.push_str("    buffer[len] = '\\0';\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    code
}
