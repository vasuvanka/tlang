// url - URL Parsing and Manipulation library
// Provides URL parsing and encoding/decoding functions

pub fn generate_url_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <ctype.h>\n");
    code.push_str("\n");
    
    // Helper: Check if character needs encoding
    code.push_str("static int needs_encoding(char c, int is_path) {\n");
    code.push_str("    if (isalnum(c)) return 0;\n");
    code.push_str("    if (is_path) {\n");
    code.push_str("        // Path-safe characters\n");
    code.push_str("        return !(c == '/' || c == '.' || c == '-' || c == '_' || c == '~');\n");
    code.push_str("    } else {\n");
    code.push_str("        // Query-safe characters\n");
    code.push_str("        return !(c == '-' || c == '_' || c == '.' || c == '~');\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // Helper: Percent-encode character
    code.push_str("static void percent_encode_char(char c, char* output) {\n");
    code.push_str("    sprintf(output, \"%%%02X\", (unsigned char)c);\n");
    code.push_str("}\n\n");
    
    // url.QueryEscape - Escape query string
    code.push_str("// url.QueryEscape - Escape query string\n");
    code.push_str("char* url_QueryEscape(const char* s) {\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(s);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 4; i++) {\n");
    code.push_str("        if (needs_encoding(s[i], 0)) {\n");
    code.push_str("            char encoded[4];\n");
    code.push_str("            percent_encode_char(s[i], encoded);\n");
    code.push_str("            strcat(result, encoded);\n");
    code.push_str("            pos += 3;\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = s[i];\n");
    code.push_str("            result[pos] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // url.QueryUnescape - Unescape query string
    code.push_str("// url.QueryUnescape - Unescape query string\n");
    code.push_str("char* url_QueryUnescape(const char* s) {\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(s);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {\n");
    code.push_str("        if (s[i] == '%' && i + 2 < len) {\n");
    code.push_str("            char hex[3] = {s[i+1], s[i+2], '\\0'};\n");
    code.push_str("            int value = strtol(hex, NULL, 16);\n");
    code.push_str("            result[pos++] = (char)value;\n");
    code.push_str("            i += 2;  // Skip %XX\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = s[i];\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // url.PathEscape - Escape URL path
    code.push_str("// url.PathEscape - Escape URL path\n");
    code.push_str("char* url_PathEscape(const char* s) {\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(s);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 4; i++) {\n");
    code.push_str("        if (needs_encoding(s[i], 1)) {\n");
    code.push_str("            char encoded[4];\n");
    code.push_str("            percent_encode_char(s[i], encoded);\n");
    code.push_str("            strcat(result, encoded);\n");
    code.push_str("            pos += 3;\n");
    code.push_str("        } else {\n");
    code.push_str("            result[pos++] = s[i];\n");
    code.push_str("            result[pos] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // url.PathUnescape - Unescape URL path
    code.push_str("// url.PathUnescape - Unescape URL path\n");
    code.push_str("char* url_PathUnescape(const char* s) {\n");
    code.push_str("    return url_QueryUnescape(s);  // Same logic\n");
    code.push_str("}\n\n");
    
    // url.Parse - Parse URL into components (returns formatted string)
    code.push_str("// url.Parse - Parse URL into components\n");
    code.push_str("char* url_Parse(const char* rawurl) {\n");
    code.push_str("    static char result[512];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char scheme[64] = \"\";\n");
    code.push_str("    char host[256] = \"\";\n");
    code.push_str("    char path[256] = \"\";\n");
    code.push_str("    char query[256] = \"\";\n");
    code.push_str("    \n");
    code.push_str("    // Find scheme (http://, https://, etc.)\n");
    code.push_str("    const char* scheme_end = strstr(rawurl, \"://\");\n");
    code.push_str("    if (scheme_end != NULL) {\n");
    code.push_str("        int scheme_len = scheme_end - rawurl;\n");
    code.push_str("        if (scheme_len < sizeof(scheme)) {\n");
    code.push_str("            strncpy(scheme, rawurl, scheme_len);\n");
    code.push_str("            scheme[scheme_len] = '\\0';\n");
    code.push_str("            rawurl = scheme_end + 3;  // Skip ://\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Find path start\n");
    code.push_str("    const char* path_start = strchr(rawurl, '/');\n");
    code.push_str("    const char* query_start = strchr(rawurl, '?');\n");
    code.push_str("    \n");
    code.push_str("    // Extract host\n");
    code.push_str("    if (path_start != NULL) {\n");
    code.push_str("        int host_len = path_start - rawurl;\n");
    code.push_str("        if (host_len < sizeof(host)) {\n");
    code.push_str("            strncpy(host, rawurl, host_len);\n");
    code.push_str("            host[host_len] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    } else if (query_start != NULL) {\n");
    code.push_str("        int host_len = query_start - rawurl;\n");
    code.push_str("        if (host_len < sizeof(host)) {\n");
    code.push_str("            strncpy(host, rawurl, host_len);\n");
    code.push_str("            host[host_len] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    } else {\n");
    code.push_str("        strncpy(host, rawurl, sizeof(host) - 1);\n");
    code.push_str("        host[sizeof(host) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Extract path\n");
    code.push_str("    if (path_start != NULL) {\n");
    code.push_str("        if (query_start != NULL) {\n");
    code.push_str("            int path_len = query_start - path_start;\n");
    code.push_str("            if (path_len < sizeof(path)) {\n");
    code.push_str("                strncpy(path, path_start, path_len);\n");
    code.push_str("                path[path_len] = '\\0';\n");
    code.push_str("            }\n");
    code.push_str("        } else {\n");
    code.push_str("            strncpy(path, path_start, sizeof(path) - 1);\n");
    code.push_str("            path[sizeof(path) - 1] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Extract query\n");
    code.push_str("    if (query_start != NULL) {\n");
    code.push_str("        strncpy(query, query_start + 1, sizeof(query) - 1);  // Skip ?\n");
    code.push_str("        query[sizeof(query) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Format result: scheme|host|path|query\n");
    code.push_str("    snprintf(result, sizeof(result), \"%s|%s|%s|%s\", scheme, host, path, query);\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // url.JoinPath - Join URL path components
    code.push_str("// url.JoinPath - Join URL path components\n");
    code.push_str("char* url_JoinPath(const char* base, const char* path) {\n");
    code.push_str("    static char result[512];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    // Remove trailing slash from base\n");
    code.push_str("    int base_len = strlen(base);\n");
    code.push_str("    while (base_len > 0 && base[base_len - 1] == '/') {\n");
    code.push_str("        base_len--;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Remove leading slash from path\n");
    code.push_str("    const char* path_start = path;\n");
    code.push_str("    while (*path_start == '/') {\n");
    code.push_str("        path_start++;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Join with single slash\n");
    code.push_str("    if (base_len > 0) {\n");
    code.push_str("        strncpy(result, base, base_len);\n");
    code.push_str("        result[base_len] = '\\0';\n");
    code.push_str("        if (*path_start) {\n");
    code.push_str("            strcat(result, \"/\");\n");
    code.push_str("            strcat(result, path_start);\n");
    code.push_str("        }\n");
    code.push_str("    } else {\n");
    code.push_str("        strcpy(result, path_start);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
