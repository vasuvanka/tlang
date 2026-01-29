// doc - Documentation Generation library
// Provides documentation generation from code comments similar to Go's godoc

pub fn generate_doc_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // doc.ExtractComments - Extract comments from source code
    code.push_str("// doc.ExtractComments - Extract comments from source code\n");
    code.push_str("char* doc_ExtractComments(const char* source) {\n");
    code.push_str("    static char result[8192];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(source);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    int in_single_line = 0;\n");
    code.push_str("    int in_multi_line = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {\n");
    code.push_str("        // Check for single-line comment //\n");
    code.push_str("        if (i < len - 1 && source[i] == '/' && source[i + 1] == '/') {\n");
    code.push_str("            in_single_line = 1;\n");
    code.push_str("            i++; // Skip second /\n");
    code.push_str("            continue;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        // Check for multi-line comment start /*\n");
    code.push_str("        if (i < len - 1 && source[i] == '/' && source[i + 1] == '*') {\n");
    code.push_str("            in_multi_line = 1;\n");
    code.push_str("            i++; // Skip *\n");
    code.push_str("            continue;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        // Check for multi-line comment end */\n");
    code.push_str("        if (i < len - 1 && source[i] == '*' && source[i + 1] == '/') {\n");
    code.push_str("            in_multi_line = 0;\n");
    code.push_str("            i++; // Skip /\n");
    code.push_str("            if (pos > 0 && result[pos - 1] != '\\n') {\n");
    code.push_str("                result[pos++] = '\\n';\n");
    code.push_str("            }\n");
    code.push_str("            continue;\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        // Extract comment content\n");
    code.push_str("        if (in_single_line || in_multi_line) {\n");
    code.push_str("            if (source[i] == '\\n') {\n");
    code.push_str("                in_single_line = 0;\n");
    code.push_str("                result[pos++] = '\\n';\n");
    code.push_str("            } else if (source[i] != '\\r') {\n");
    code.push_str("                result[pos++] = source[i];\n");
    code.push_str("            }\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // doc.Format - Format documentation text
    code.push_str("// doc.Format - Format documentation text (basic formatting)\n");
    code.push_str("char* doc_Format(const char* text) {\n");
    code.push_str("    static char result[8192];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(text);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    int in_code = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {\n");
    code.push_str("        // Simple formatting: preserve newlines, trim extra spaces\n");
    code.push_str("        if (text[i] == '\\n') {\n");
    code.push_str("            result[pos++] = '\\n';\n");
    code.push_str("            // Skip multiple spaces after newline\n");
    code.push_str("            while (i + 1 < len && text[i + 1] == ' ') i++;\n");
    code.push_str("        } else if (text[i] != '\\r') {\n");
    code.push_str("            result[pos++] = text[i];\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // doc.Generate - Generate documentation from source file
    code.push_str("// doc.Generate - Generate documentation from source file\n");
    code.push_str("char* doc_Generate(const char* filename) {\n");
    code.push_str("    static char result[16384];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    FILE* file = fopen(filename, \"r\");\n");
    code.push_str("    if (file == NULL) {\n");
    code.push_str("        strcpy(result, \"Error: Could not open file\\n\");\n");
    code.push_str("        return result;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Read file into buffer\n");
    code.push_str("    char source[8192];\n");
    code.push_str("    size_t read = fread(source, 1, sizeof(source) - 1, file);\n");
    code.push_str("    source[read] = '\\0';\n");
    code.push_str("    fclose(file);\n");
    code.push_str("    \n");
    code.push_str("    // Extract comments\n");
    code.push_str("    char* comments = doc_ExtractComments(source);\n");
    code.push_str("    \n");
    code.push_str("    // Format and add header\n");
    code.push_str("    strcat(result, \"# Documentation\\n\\n\");\n");
    code.push_str("    strcat(result, \"Generated from: \");\n");
    code.push_str("    strcat(result, filename);\n");
    code.push_str("    strcat(result, \"\\n\\n\");\n");
    code.push_str("    strcat(result, comments);\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // doc.Write - Write documentation to file
    code.push_str("// doc.Write - Write documentation to file\n");
    code.push_str("int doc_Write(const char* filename, const char* content) {\n");
    code.push_str("    FILE* file = fopen(filename, \"w\");\n");
    code.push_str("    if (file == NULL) {\n");
    code.push_str("        return 0;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(content);\n");
    code.push_str("    int written = fwrite(content, 1, len, file);\n");
    code.push_str("    fclose(file);\n");
    code.push_str("    \n");
    code.push_str("    return written;\n");
    code.push_str("}\n\n");
    
    // doc.ParseFunctionDocs - Parse function documentation
    code.push_str("// doc.ParseFunctionDocs - Parse function documentation from comments\n");
    code.push_str("char* doc_ParseFunctionDocs(const char* source, const char* func_name) {\n");
    code.push_str("    static char result[2048];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    // Simple implementation: find function and extract preceding comment\n");
    code.push_str("    char search[256];\n");
    code.push_str("    snprintf(search, sizeof(search), \"#%s\", func_name);\n");
    code.push_str("    \n");
    code.push_str("    const char* func_pos = strstr(source, search);\n");
    code.push_str("    if (func_pos == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    // Look backwards for comment\n");
    code.push_str("    const char* comment_start = func_pos;\n");
    code.push_str("    int found_comment = 0;\n");
    code.push_str("    \n");
    code.push_str("    // Simple backward search for // or /*\n");
    code.push_str("    for (const char* p = func_pos - 1; p >= source && p >= func_pos - 500; p--) {\n");
    code.push_str("        if (p[0] == '/' && p[1] == '/') {\n");
    code.push_str("            comment_start = p + 2;\n");
    code.push_str("            found_comment = 1;\n");
    code.push_str("            break;\n");
    code.push_str("        }\n");
    code.push_str("        if (p[0] == '*' && p[-1] == '/') {\n");
    code.push_str("            comment_start = p + 1;\n");
    code.push_str("            found_comment = 1;\n");
    code.push_str("            break;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    if (!found_comment) return result;\n");
    code.push_str("    \n");
    code.push_str("    // Extract comment until function\n");
    code.push_str("    int len = func_pos - comment_start;\n");
    code.push_str("    if (len > sizeof(result) - 1) len = sizeof(result) - 1;\n");
    code.push_str("    strncpy(result, comment_start, len);\n");
    code.push_str("    result[len] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
