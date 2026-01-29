// bytes - Byte Operations library
// Ported from Go's bytes package

pub fn generate_bytes_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <string.h>\n\n");
    
    // Contains
    code.push_str("// bytes.Contains - Check if bytes contain subslice\n");
    code.push_str("int bytes_Contains(const char* b, int len, const char* sub, int sublen) {\n");
    code.push_str("    if (sublen == 0) return 1;\n");
    code.push_str("    if (sublen > len) return 0;\n");
    code.push_str("    for (int i = 0; i <= len - sublen; i++) {\n");
    code.push_str("        if (memcmp(b + i, sub, sublen) == 0) {\n");
    code.push_str("            return 1;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    return 0;\n");
    code.push_str("}\n\n");
    
    // Index
    code.push_str("// bytes.Index - Find index of subslice\n");
    code.push_str("int bytes_Index(const char* b, int len, const char* sub, int sublen) {\n");
    code.push_str("    if (sublen == 0) return 0;\n");
    code.push_str("    if (sublen > len) return -1;\n");
    code.push_str("    for (int i = 0; i <= len - sublen; i++) {\n");
    code.push_str("        if (memcmp(b + i, sub, sublen) == 0) {\n");
    code.push_str("            return i;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    return -1;\n");
    code.push_str("}\n\n");
    
    // Equal
    code.push_str("// bytes.Equal - Compare two byte slices\n");
    code.push_str("int bytes_Equal(const char* a, int lenA, const char* b, int lenB) {\n");
    code.push_str("    if (lenA != lenB) return 0;\n");
    code.push_str("    return memcmp(a, b, lenA) == 0 ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    code
}
