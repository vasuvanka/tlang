// encoding/base64 - Base64 Encoding library
// Provides base64 encoding and decoding functionality

pub fn generate_base64_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // Base64 character table
    code.push_str("// Base64 character table\n");
    code.push_str("static const char base64_chars[] = \n");
    code.push_str("    \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\";\n\n");
    
    // Helper: Get character index in base64 table
    code.push_str("static int base64_char_index(char c) {\n");
    code.push_str("    if (c >= 'A' && c <= 'Z') return c - 'A';\n");
    code.push_str("    if (c >= 'a' && c <= 'z') return c - 'a' + 26;\n");
    code.push_str("    if (c >= '0' && c <= '9') return c - '0' + 52;\n");
    code.push_str("    if (c == '+') return 62;\n");
    code.push_str("    if (c == '/') return 63;\n");
    code.push_str("    return -1;  // Invalid character\n");
    code.push_str("}\n\n");
    
    // base64.Encode - Encode string to base64
    code.push_str("// base64.Encode - Encode string to base64\n");
    code.push_str("char* base64_Encode(const char* data) {\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (data == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(data);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len; i += 3) {\n");
    code.push_str("        unsigned char byte1 = (unsigned char)data[i];\n");
    code.push_str("        unsigned char byte2 = (i + 1 < len) ? (unsigned char)data[i + 1] : 0;\n");
    code.push_str("        unsigned char byte3 = (i + 2 < len) ? (unsigned char)data[i + 2] : 0;\n");
    code.push_str("        \n");
    code.push_str("        // Encode 3 bytes into 4 base64 characters\n");
    code.push_str("        result[pos++] = base64_chars[(byte1 >> 2) & 0x3F];\n");
    code.push_str("        result[pos++] = base64_chars[((byte1 & 0x3) << 4) | ((byte2 >> 4) & 0xF)];\n");
    code.push_str("        \n");
    code.push_str("        if (i + 1 < len) {\n");
    code.push_str("            result[pos++] = base64_chars[((byte2 & 0xF) << 2) | ((byte3 >> 6) & 0x3)];\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = '=';\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (i + 2 < len) {\n");
    code.push_str("            result[pos++] = base64_chars[byte3 & 0x3F];\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = '=';\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (pos >= sizeof(result) - 1) break;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // base64.Decode - Decode base64 string
    code.push_str("// base64.Decode - Decode base64 string\n");
    code.push_str("char* base64_Decode(const char* encoded) {\n");
    code.push_str("    static char result[3072];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (encoded == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(encoded);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    // Remove padding\n");
    code.push_str("    while (len > 0 && encoded[len - 1] == '=') len--;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len; i += 4) {\n");
    code.push_str("        if (i + 3 >= len) break;\n");
    code.push_str("        \n");
    code.push_str("        int idx1 = base64_char_index(encoded[i]);\n");
    code.push_str("        int idx2 = base64_char_index(encoded[i + 1]);\n");
    code.push_str("        int idx3 = base64_char_index(encoded[i + 2]);\n");
    code.push_str("        int idx4 = base64_char_index(encoded[i + 3]);\n");
    code.push_str("        \n");
    code.push_str("        if (idx1 < 0 || idx2 < 0 || idx3 < 0 || idx4 < 0) break;\n");
    code.push_str("        \n");
    code.push_str("        // Decode 4 base64 characters into 3 bytes\n");
    code.push_str("        unsigned char byte1 = (idx1 << 2) | ((idx2 >> 4) & 0x3);\n");
    code.push_str("        unsigned char byte2 = ((idx2 & 0xF) << 4) | ((idx3 >> 2) & 0xF);\n");
    code.push_str("        unsigned char byte3 = ((idx3 & 0x3) << 6) | idx4;\n");
    code.push_str("        \n");
    code.push_str("        result[pos++] = byte1;\n");
    code.push_str("        \n");
    code.push_str("        if (encoded[i + 2] != '=') {\n");
    code.push_str("            result[pos++] = byte2;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (encoded[i + 3] != '=') {\n");
    code.push_str("            result[pos++] = byte3;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (pos >= sizeof(result) - 1) break;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // base64.EncodeBytes - Encode byte array (represented as string with | separator)
    code.push_str("// base64.EncodeBytes - Encode byte array to base64\n");
    code.push_str("char* base64_EncodeBytes(const char* data) {\n");
    code.push_str("    // Data format: byte1|byte2|byte3 (pipe-separated bytes as strings)\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (data == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    // Convert pipe-separated bytes to actual bytes\n");
    code.push_str("    unsigned char bytes[1024];\n");
    code.push_str("    int byte_count = 0;\n");
    code.push_str("    \n");
    code.push_str("    char* copy = strdup(data);\n");
    code.push_str("    char* token = strtok(copy, \"|\");\n");
    code.push_str("    \n");
    code.push_str("    while (token != NULL && byte_count < sizeof(bytes)) {\n");
    code.push_str("        bytes[byte_count++] = (unsigned char)atoi(token);\n");
    code.push_str("        token = strtok(NULL, \"|\");\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    free(copy);\n");
    code.push_str("    \n");
    code.push_str("    // Encode bytes\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < byte_count; i += 3) {\n");
    code.push_str("        unsigned char byte1 = bytes[i];\n");
    code.push_str("        unsigned char byte2 = (i + 1 < byte_count) ? bytes[i + 1] : 0;\n");
    code.push_str("        unsigned char byte3 = (i + 2 < byte_count) ? bytes[i + 2] : 0;\n");
    code.push_str("        \n");
    code.push_str("        result[pos++] = base64_chars[(byte1 >> 2) & 0x3F];\n");
    code.push_str("        result[pos++] = base64_chars[((byte1 & 0x3) << 4) | ((byte2 >> 4) & 0xF)];\n");
    code.push_str("        \n");
    code.push_str("        if (i + 1 < byte_count) {\n");
    code.push_str("            result[pos++] = base64_chars[((byte2 & 0xF) << 2) | ((byte3 >> 6) & 0x3)];\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = '=';\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (i + 2 < byte_count) {\n");
    code.push_str("            result[pos++] = base64_chars[byte3 & 0x3F];\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = '=';\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (pos >= sizeof(result) - 1) break;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // base64.DecodeBytes - Decode base64 to byte array (returns pipe-separated bytes)
    code.push_str("// base64.DecodeBytes - Decode base64 to byte array\n");
    code.push_str("char* base64_DecodeBytes(const char* encoded) {\n");
    code.push_str("    static char result[3072];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (encoded == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(encoded);\n");
    code.push_str("    unsigned char bytes[1024];\n");
    code.push_str("    int byte_count = 0;\n");
    code.push_str("    \n");
    code.push_str("    // Remove padding\n");
    code.push_str("    while (len > 0 && encoded[len - 1] == '=') len--;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len; i += 4) {\n");
    code.push_str("        if (i + 3 >= len) break;\n");
    code.push_str("        \n");
    code.push_str("        int idx1 = base64_char_index(encoded[i]);\n");
    code.push_str("        int idx2 = base64_char_index(encoded[i + 1]);\n");
    code.push_str("        int idx3 = base64_char_index(encoded[i + 2]);\n");
    code.push_str("        int idx4 = base64_char_index(encoded[i + 3]);\n");
    code.push_str("        \n");
    code.push_str("        if (idx1 < 0 || idx2 < 0 || idx3 < 0 || idx4 < 0) break;\n");
    code.push_str("        \n");
    code.push_str("        bytes[byte_count++] = (idx1 << 2) | ((idx2 >> 4) & 0x3);\n");
    code.push_str("        \n");
    code.push_str("        if (encoded[i + 2] != '=') {\n");
    code.push_str("            bytes[byte_count++] = ((idx2 & 0xF) << 4) | ((idx3 >> 2) & 0xF);\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (encoded[i + 3] != '=') {\n");
    code.push_str("            bytes[byte_count++] = ((idx3 & 0x3) << 6) | idx4;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (byte_count >= sizeof(bytes)) break;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Convert bytes to pipe-separated string\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    for (int i = 0; i < byte_count; i++) {\n");
    code.push_str("        if (i > 0) result[pos++] = '|';\n");
    code.push_str("        pos += snprintf(result + pos, sizeof(result) - pos, \"%d\", bytes[i]);\n");
    code.push_str("        if (pos >= sizeof(result) - 1) break;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
