// encoding/xml - XML Processing library
// Provides XML encoding and decoding

pub fn generate_xml_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // xml.Escape - Escape XML special characters
    code.push_str("// xml.Escape - Escape XML special characters\n");
    code.push_str("char* xml_Escape(const char* text) {\n");
    code.push_str("    static char result[8192];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(text);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 10; i++) {\n");
    code.push_str("        switch (text[i]) {\n");
    code.push_str("            case '<':\n");
    code.push_str("                strcat(result, \"&lt;\");\n");
    code.push_str("                pos += 4;\n");
    code.push_str("                break;\n");
    code.push_str("            case '>':\n");
    code.push_str("                strcat(result, \"&gt;\");\n");
    code.push_str("                pos += 4;\n");
    code.push_str("                break;\n");
    code.push_str("            case '&':\n");
    code.push_str("                strcat(result, \"&amp;\");\n");
    code.push_str("                pos += 5;\n");
    code.push_str("                break;\n");
    code.push_str("            case '\"':\n");
    code.push_str("                strcat(result, \"&quot;\");\n");
    code.push_str("                pos += 6;\n");
    code.push_str("                break;\n");
    code.push_str("            case '\\'':\n");
    code.push_str("                strcat(result, \"&apos;\");\n");
    code.push_str("                pos += 6;\n");
    code.push_str("                break;\n");
    code.push_str("            default:\n");
    code.push_str("                result[pos++] = text[i];\n");
    code.push_str("                result[pos] = '\\0';\n");
    code.push_str("                break;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // xml.Unescape - Unescape XML entities
    code.push_str("// xml.Unescape - Unescape XML entities\n");
    code.push_str("char* xml_Unescape(const char* text) {\n");
    code.push_str("    static char result[8192];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(text);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {\n");
    code.push_str("        if (text[i] == '&') {\n");
    code.push_str("            if (strncmp(text + i, \"&lt;\", 4) == 0) {\n");
    code.push_str("                result[pos++] = '<';\n");
    code.push_str("                i += 3;  // Skip &lt;\n");
    code.push_str("            } else if (strncmp(text + i, \"&gt;\", 4) == 0) {\n");
    code.push_str("                result[pos++] = '>';\n");
    code.push_str("                i += 3;  // Skip &gt;\n");
    code.push_str("            } else if (strncmp(text + i, \"&amp;\", 5) == 0) {\n");
    code.push_str("                result[pos++] = '&';\n");
    code.push_str("                i += 4;  // Skip &amp;\n");
    code.push_str("            } else if (strncmp(text + i, \"&quot;\", 6) == 0) {\n");
    code.push_str("                result[pos++] = '\"';\n");
    code.push_str("                i += 5;  // Skip &quot;\n");
    code.push_str("            } else if (strncmp(text + i, \"&apos;\", 6) == 0) {\n");
    code.push_str("                result[pos++] = '\\'';\n");
    code.push_str("                i += 5;  // Skip &apos;\n");
    code.push_str("            } else {\n");
    code.push_str("                result[pos++] = text[i];\n");
    code.push_str("            }\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = text[i];\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // xml.Marshal - Encode value to XML (basic types)
    code.push_str("// xml.Marshal - Encode value to XML (basic types)\n");
    code.push_str("char* xml_Marshal(const char* type, const char* name, const char* value) {\n");
    code.push_str("    static char result[1024];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char* escaped = xml_Escape(value);\n");
    code.push_str("    \n");
    code.push_str("    if (strcmp(type, \"string\") == 0) {\n");
    code.push_str("        snprintf(result, sizeof(result), \"<%s>%s</%s>\", name, escaped, name);\n");
    code.push_str("    } else if (strcmp(type, \"int\") == 0) {\n");
    code.push_str("        snprintf(result, sizeof(result), \"<%s>%s</%s>\", name, value, name);\n");
    code.push_str("    } else if (strcmp(type, \"float\") == 0) {\n");
    code.push_str("        snprintf(result, sizeof(result), \"<%s>%s</%s>\", name, value, name);\n");
    code.push_str("    } else {\n");
    code.push_str("        snprintf(result, sizeof(result), \"<%s>%s</%s>\", name, escaped, name);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // xml.Unmarshal - Decode XML string (basic types)
    code.push_str("// xml.Unmarshal - Decode XML string (basic types)\n");
    code.push_str("char* xml_Unmarshal(const char* xml, const char* tag) {\n");
    code.push_str("    static char result[512];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char start_tag[128];\n");
    code.push_str("    snprintf(start_tag, sizeof(start_tag), \"<%s>\", tag);\n");
    code.push_str("    char end_tag[128];\n");
    code.push_str("    snprintf(end_tag, sizeof(end_tag), \"</%s>\", tag);\n");
    code.push_str("    \n");
    code.push_str("    const char* start = strstr(xml, start_tag);\n");
    code.push_str("    if (start == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    start += strlen(start_tag);\n");
    code.push_str("    const char* end = strstr(start, end_tag);\n");
    code.push_str("    if (end == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    int len = end - start;\n");
    code.push_str("    if (len >= sizeof(result)) len = sizeof(result) - 1;\n");
    code.push_str("    \n");
    code.push_str("    strncpy(result, start, len);\n");
    code.push_str("    result[len] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    // Unescape\n");
    code.push_str("    char* unescaped = xml_Unescape(result);\n");
    code.push_str("    strcpy(result, unescaped);\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
