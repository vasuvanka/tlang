// encoding/csv - CSV Processing library
// Provides CSV file reading and writing

pub fn generate_csv_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // Helper: Parse CSV line
    code.push_str("static void parse_csv_line(const char* line, char result[][256], int* count) {\n");
    code.push_str("    *count = 0;\n");
    code.push_str("    int len = strlen(line);\n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    int field_start = 0;\n");
    code.push_str("    int in_quotes = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len && *count < 100; i++) {\n");
    code.push_str("        if (line[i] == '\"') {\n");
    code.push_str("            in_quotes = !in_quotes;\n");
    code.push_str("        } else if (line[i] == ',' && !in_quotes) {\n");
    code.push_str("            // End of field\n");
    code.push_str("            int field_len = i - field_start;\n");
    code.push_str("            if (field_len > 255) field_len = 255;\n");
    code.push_str("            strncpy(result[*count], line + field_start, field_len);\n");
    code.push_str("            result[*count][field_len] = '\\0';\n");
    code.push_str("            // Remove quotes if present\n");
    code.push_str("            if (result[*count][0] == '\"' && result[*count][field_len-1] == '\"') {\n");
    code.push_str("                memmove(result[*count], result[*count] + 1, field_len - 2);\n");
    code.push_str("                result[*count][field_len - 2] = '\\0';\n");
    code.push_str("            }\n");
    code.push_str("            (*count)++;\n");
    code.push_str("            field_start = i + 1;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Last field\n");
    code.push_str("    if (field_start < len) {\n");
    code.push_str("        int field_len = len - field_start;\n");
    code.push_str("        if (field_len > 255) field_len = 255;\n");
    code.push_str("        strncpy(result[*count], line + field_start, field_len);\n");
    code.push_str("        result[*count][field_len] = '\\0';\n");
    code.push_str("        // Remove quotes if present\n");
    code.push_str("        int flen = strlen(result[*count]);\n");
    code.push_str("        if (flen > 0 && result[*count][0] == '\"' && result[*count][flen-1] == '\"') {\n");
    code.push_str("            memmove(result[*count], result[*count] + 1, flen - 2);\n");
    code.push_str("            result[*count][flen - 2] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("        (*count)++;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // csv.Read - Read CSV file (returns newline-separated records, fields separated by |)
    code.push_str("// csv.Read - Read CSV file\n");
    code.push_str("char* csv_Read(const char* filename) {\n");
    code.push_str("    static char result[65536];  // 64KB buffer\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    FILE* file = fopen(filename, \"r\");\n");
    code.push_str("    if (file == NULL) {\n");
    code.push_str("        return result;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    char line[1024];\n");
    code.push_str("    int first_line = 1;\n");
    code.push_str("    \n");
    code.push_str("    while (fgets(line, sizeof(line), file) != NULL) {\n");
    code.push_str("        // Remove newline\n");
    code.push_str("        int len = strlen(line);\n");
    code.push_str("        if (len > 0 && line[len-1] == '\\n') {\n");
    code.push_str("            line[len-1] = '\\0';\n");
    code.push_str("        }\n");
    code.push_str("        \n");
    code.push_str("        if (!first_line) {\n");
    code.push_str("            strcat(result, \"\\n\");\n");
    code.push_str("        }\n");
    code.push_str("        first_line = 0;\n");
    code.push_str("        \n");
    code.push_str("        // Parse line and join fields with |\n");
    code.push_str("        char fields[100][256];\n");
    code.push_str("        int field_count = 0;\n");
    code.push_str("        parse_csv_line(line, fields, &field_count);\n");
    code.push_str("        \n");
    code.push_str("        for (int i = 0; i < field_count; i++) {\n");
    code.push_str("            if (i > 0) strcat(result, \"|\");\n");
    code.push_str("            strcat(result, fields[i]);\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    fclose(file);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // csv.Write - Write CSV file
    code.push_str("// csv.Write - Write CSV file\n");
    code.push_str("int csv_Write(const char* filename, const char* data) {\n");
    code.push_str("    FILE* file = fopen(filename, \"w\");\n");
    code.push_str("    if (file == NULL) {\n");
    code.push_str("        return 0;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Data format: newline-separated records, | separated fields\n");
    code.push_str("    int len = strlen(data);\n");
    code.push_str("    int written = 0;\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < len; i++) {\n");
    code.push_str("        if (data[i] == '|') {\n");
    code.push_str("            fputc(',', file);\n");
    code.push_str("            written++;\n");
    code.push_str("        } else if (data[i] == '\\n') {\n");
    code.push_str("            fputc('\\n', file);\n");
    code.push_str("            written++;\n");
    code.push_str("        } else {\n");
    code.push_str("            fputc(data[i], file);\n");
    code.push_str("            written++;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    fclose(file);\n");
    code.push_str("    return written;\n");
    code.push_str("}\n\n");
    
    // csv.ParseLine - Parse single CSV line
    code.push_str("// csv.ParseLine - Parse single CSV line (returns | separated fields)\n");
    code.push_str("char* csv_ParseLine(const char* line) {\n");
    code.push_str("    static char result[2048];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    char fields[100][256];\n");
    code.push_str("    int field_count = 0;\n");
    code.push_str("    parse_csv_line(line, fields, &field_count);\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < field_count; i++) {\n");
    code.push_str("        if (i > 0) strcat(result, \"|\");\n");
    code.push_str("        strcat(result, fields[i]);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
