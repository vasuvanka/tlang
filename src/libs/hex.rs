// encoding/hex - Hexadecimal Encoding library
// Provides hex encoding and decoding functions

pub fn generate_hex_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <ctype.h>\n");
    code.push_str("\n");
    
    // Helper: Convert hex char to value
    code.push_str("static int hex_char_to_value(char c) {\n");
    code.push_str("    if (c >= '0' && c <= '9') return c - '0';\n");
    code.push_str("    if (c >= 'a' && c <= 'f') return c - 'a' + 10;\n");
    code.push_str("    if (c >= 'A' && c <= 'F') return c - 'A' + 10;\n");
    code.push_str("    return -1;\n");
    code.push_str("}\n\n");
    
    // hex.Encode - Encode string to hex
    code.push_str("// hex.Encode - Encode string to hex\n");
    code.push_str("char* hex_Encode(const char* data) {\n");
    code.push_str("    static char result[8192];  // 4KB input max\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(data);\n");
    code.push_str("    if (len * 2 >= sizeof(result)) {\n");
    code.push_str("        len = (sizeof(result) - 1) / 2;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    const char* hex_chars = \"0123456789abcdef\";\n");
    code.push_str("    for (int i = 0; i < len; i++) {\n");
    code.push_str("        unsigned char byte = (unsigned char)data[i];\n");
    code.push_str("        result[i * 2] = hex_chars[(byte >> 4) & 0x0F];\n");
    code.push_str("        result[i * 2 + 1] = hex_chars[byte & 0x0F];\n");
    code.push_str("    }\n");
    code.push_str("    result[len * 2] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // hex.Decode - Decode hex string
    code.push_str("// hex.Decode - Decode hex string\n");
    code.push_str("char* hex_Decode(const char* encoded) {\n");
    code.push_str("    static char result[4096];  // 2KB hex input max\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(encoded);\n");
    code.push_str("    if (len % 2 != 0) {\n");
    code.push_str("        return result;  // Invalid hex string\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    int result_len = len / 2;\n");
    code.push_str("    if (result_len >= sizeof(result)) {\n");
    code.push_str("        result_len = sizeof(result) - 1;\n");
    code.push_str("        len = result_len * 2;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len; i += 2) {\n");
    code.push_str("        int high = hex_char_to_value(encoded[i]);\n");
    code.push_str("        int low = hex_char_to_value(encoded[i + 1]);\n");
    code.push_str("        \n");
    code.push_str("        if (high < 0 || low < 0) {\n");
    code.push_str("            return result;  // Invalid hex character\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        result[i / 2] = (char)((high << 4) | low);\n");
    code.push_str("    }\n");
    code.push_str("    result[result_len] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // hex.EncodeBytes - Encode byte data (same as Encode for strings)
    code.push_str("// hex.EncodeBytes - Encode byte data (same as Encode)\n");
    code.push_str("char* hex_EncodeBytes(const char* data, int length) {\n");
    code.push_str("    static char result[8192];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (length < 0) length = strlen(data);\n");
    code.push_str("    if (length * 2 >= sizeof(result)) {\n");
    code.push_str("        length = (sizeof(result) - 1) / 2;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    const char* hex_chars = \"0123456789abcdef\";\n");
    code.push_str("    for (int i = 0; i < length; i++) {\n");
    code.push_str("        unsigned char byte = (unsigned char)data[i];\n");
    code.push_str("        result[i * 2] = hex_chars[(byte >> 4) & 0x0F];\n");
    code.push_str("        result[i * 2 + 1] = hex_chars[byte & 0x0F];\n");
    code.push_str("    }\n");
    code.push_str("    result[length * 2] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // hex.DecodeBytes - Decode hex to bytes (same as Decode)
    code.push_str("// hex.DecodeBytes - Decode hex to bytes (same as Decode)\n");
    code.push_str("char* hex_DecodeBytes(const char* encoded) {\n");
    code.push_str("    return hex_Decode(encoded);\n");
    code.push_str("}\n\n");
    
    code
}
