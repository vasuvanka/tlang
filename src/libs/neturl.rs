// net/url - Network URL Utilities library
// Additional network URL utilities (complements url package)

pub fn generate_neturl_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // neturl.Parse - Parse network URL (same as url.Parse but with user info support)
    code.push_str("// neturl.Parse - Parse network URL\n");
    code.push_str("char* neturl_Parse(const char* rawurl) {\n");
    code.push_str("    static char result[512];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char scheme[64] = \"\";\n");
    code.push_str("    char user[128] = \"\";\n");
    code.push_str("    char host[256] = \"\";\n");
    code.push_str("    char port[16] = \"\";\n");
    code.push_str("    char path[256] = \"\";\n");
    code.push_str("    \n");
    code.push_str("    // Find scheme\n");
    code.push_str("    const char* scheme_end = strstr(rawurl, \"://\");\n");
    code.push_str("    if (scheme_end != NULL) {\n");
    code.push_str("        int scheme_len = scheme_end - rawurl;\n");
    code.push_str("        if (scheme_len < sizeof(scheme)) {\n");
    code.push_str("            strncpy(scheme, rawurl, scheme_len);\n");
    code.push_str("            scheme[scheme_len] = '\\0';\n");
    code.push_str("            rawurl = scheme_end + 3;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Find user info\n");
    code.push_str("    const char* at_pos = strchr(rawurl, '@');\n");
    code.push_str("    const char* host_start = rawurl;\n");
    code.push_str("    if (at_pos != NULL) {\n");
    code.push_str("        int user_len = at_pos - rawurl;\n");
    code.push_str("        if (user_len < sizeof(user)) {\n");
    code.push_str("            strncpy(user, rawurl, user_len);\n");
    code.push_str("            user[user_len] = '\\0';\n");
    code.push_str("            host_start = at_pos + 1;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Find path start\n");
    code.push_str("    const char* path_start = strchr(host_start, '/');\n");
    code.push_str("    const char* colon_pos = strchr(host_start, ':');\n");
    code.push_str("    \n");
    code.push_str("    // Extract host and port\n");
    code.push_str("    const char* port_start = NULL;\n");
    code.push_str("    if (colon_pos != NULL && (path_start == NULL || colon_pos < path_start)) {\n");
    code.push_str("        // Has port\n");
    code.push_str("        int host_len = colon_pos - host_start;\n");
    code.push_str("        if (host_len < sizeof(host)) {\n");
    code.push_str("            strncpy(host, host_start, host_len);\n");
    code.push_str("            host[host_len] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("        port_start = colon_pos + 1;\n");
    code.push_str("        if (path_start != NULL) {\n");
    code.push_str("            int port_len = path_start - port_start;\n");
    code.push_str("            if (port_len < sizeof(port)) {\n");
    code.push_str("                strncpy(port, port_start, port_len);\n");
    code.push_str("                port[port_len] = '\\0';\n");
    code.push_str("            }\n");
    code.push_str("        } else {\n");
    code.push_str("            strncpy(port, port_start, sizeof(port) - 1);\n");
    code.push_str("            port[sizeof(port) - 1] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    } else {\n");
    code.push_str("        // No port\n");
    code.push_str("        if (path_start != NULL) {\n");
    code.push_str("            int host_len = path_start - host_start;\n");
    code.push_str("            if (host_len < sizeof(host)) {\n");
    code.push_str("                strncpy(host, host_start, host_len);\n");
    code.push_str("                host[host_len] = '\\0';\n");
    code.push_str("            }\n");
    code.push_str("        } else {\n");
    code.push_str("            strncpy(host, host_start, sizeof(host) - 1);\n");
    code.push_str("            host[sizeof(host) - 1] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Extract path\n");
    code.push_str("    if (path_start != NULL) {\n");
    code.push_str("        strncpy(path, path_start, sizeof(path) - 1);\n");
    code.push_str("        path[sizeof(path) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Format: scheme|user|host|port|path\n");
    code.push_str("    snprintf(result, sizeof(result), \"%s|%s|%s|%s|%s\", scheme, user, host, port, path);\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // neturl.User - Create user info string
    code.push_str("// neturl.User - Create user info string\n");
    code.push_str("char* neturl_User(const char* username, const char* password) {\n");
    code.push_str("    static char result[256];\n");
    code.push_str("    if (password != NULL && strlen(password) > 0) {\n");
    code.push_str("        snprintf(result, sizeof(result), \"%s:%s\", username, password);\n");
    code.push_str("    } else {\n");
    code.push_str("        strncpy(result, username, sizeof(result) - 1);\n");
    code.push_str("        result[sizeof(result) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // neturl.Hostname - Extract hostname from URL
    code.push_str("// neturl.Hostname - Extract hostname from URL\n");
    code.push_str("char* neturl_Hostname(const char* url) {\n");
    code.push_str("    static char result[256];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char* parsed = neturl_Parse(url);\n");
    code.push_str("    // Format: scheme|user|host|port|path\n");
    code.push_str("    // Extract host (3rd field)\n");
    code.push_str("    \n");
    code.push_str("    char* fields[5];\n");
    code.push_str("    int field_count = 0;\n");
    code.push_str("    char* copy = strdup(parsed);\n");
    code.push_str("    char* token = strtok(copy, \"|\");\n");
    code.push_str("    \n");
    code.push_str("    while (token != NULL && field_count < 5) {\n");
    code.push_str("        fields[field_count++] = token;\n");
    code.push_str("        token = strtok(NULL, \"|\");\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    if (field_count >= 3) {\n");
    code.push_str("        strncpy(result, fields[2], sizeof(result) - 1);\n");
    code.push_str("        result[sizeof(result) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    free(copy);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // neturl.Port - Extract port from URL
    code.push_str("// neturl.Port - Extract port from URL\n");
    code.push_str("char* neturl_Port(const char* url) {\n");
    code.push_str("    static char result[16];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char* parsed = neturl_Parse(url);\n");
    code.push_str("    // Format: scheme|user|host|port|path\n");
    code.push_str("    // Extract port (4th field)\n");
    code.push_str("    \n");
    code.push_str("    char* fields[5];\n");
    code.push_str("    int field_count = 0;\n");
    code.push_str("    char* copy = strdup(parsed);\n");
    code.push_str("    char* token = strtok(copy, \"|\");\n");
    code.push_str("    \n");
    code.push_str("    while (token != NULL && field_count < 5) {\n");
    code.push_str("        fields[field_count++] = token;\n");
    code.push_str("        token = strtok(NULL, \"|\");\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    if (field_count >= 4 && strlen(fields[3]) > 0) {\n");
    code.push_str("        strncpy(result, fields[3], sizeof(result) - 1);\n");
    code.push_str("        result[sizeof(result) - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    free(copy);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
