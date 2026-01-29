// flag - Command-Line Flag Parsing library
// Ported from Go's flag package

pub fn generate_flag_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // Maximum number of flags
    code.push_str("#define MAX_FLAGS 64\n");
    code.push_str("#define MAX_FLAG_NAME 64\n");
    code.push_str("#define MAX_FLAG_VALUE 256\n");
    code.push_str("#define MAX_ARGS 128\n");
    code.push_str("\n");
    
    // Flag structure
    code.push_str("typedef struct {\n");
    code.push_str("    char name[MAX_FLAG_NAME];\n");
    code.push_str("    char type;  // 's'=string, 'i'=int, 'f'=float, 'b'=bool\n");
    code.push_str("    char value[MAX_FLAG_VALUE];\n");
    code.push_str("    char default_value[MAX_FLAG_VALUE];\n");
    code.push_str("    char usage[256];\n");
    code.push_str("    int is_set;\n");
    code.push_str("} Flag;\n\n");
    
    // Global flag storage
    code.push_str("static Flag flags[MAX_FLAGS];\n");
    code.push_str("static int flag_count = 0;\n");
    code.push_str("static int flag_parsed = 0;\n");
    code.push_str("static char non_flag_args[MAX_ARGS][MAX_FLAG_VALUE];\n");
    code.push_str("static int non_flag_count = 0;\n\n");
    
    // Helper: Find flag by name
    code.push_str("static int find_flag(const char* name) {\n");
    code.push_str("    for (int i = 0; i < flag_count; i++) {\n");
    code.push_str("        if (strcmp(flags[i].name, name) == 0) {\n");
    code.push_str("            return i;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    return -1;\n");
    code.push_str("}\n\n");
    
    // Helper: Register flag
    code.push_str("static int register_flag(const char* name, char type, const char* default_val, const char* usage) {\n");
    code.push_str("    if (flag_count >= MAX_FLAGS) return -1;\n");
    code.push_str("    \n");
    code.push_str("    strncpy(flags[flag_count].name, name, MAX_FLAG_NAME - 1);\n");
    code.push_str("    flags[flag_count].name[MAX_FLAG_NAME - 1] = '\\0';\n");
    code.push_str("    flags[flag_count].type = type;\n");
    code.push_str("    strncpy(flags[flag_count].default_value, default_val, MAX_FLAG_VALUE - 1);\n");
    code.push_str("    flags[flag_count].default_value[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("    strncpy(flags[flag_count].value, default_val, MAX_FLAG_VALUE - 1);\n");
    code.push_str("    flags[flag_count].value[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("    strncpy(flags[flag_count].usage, usage, 255);\n");
    code.push_str("    flags[flag_count].usage[255] = '\\0';\n");
    code.push_str("    flags[flag_count].is_set = 0;\n");
    code.push_str("    \n");
    code.push_str("    return flag_count++;\n");
    code.push_str("}\n\n");
    
    // flag.String - Define string flag
    code.push_str("// flag.String - Define string flag\n");
    code.push_str("char* flag_String(const char* name, const char* default_val, const char* usage) {\n");
    code.push_str("    static char result[MAX_FLAG_VALUE];\n");
    code.push_str("    int idx = register_flag(name, 's', default_val, usage);\n");
    code.push_str("    if (idx < 0) {\n");
    code.push_str("        result[0] = '\\0';\n");
    code.push_str("        return result;\n");
    code.push_str("    }\n");
    code.push_str("    strncpy(result, flags[idx].value, MAX_FLAG_VALUE - 1);\n");
    code.push_str("    result[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // flag.Int - Define integer flag
    code.push_str("// flag.Int - Define integer flag\n");
    code.push_str("int flag_Int(const char* name, int default_val, const char* usage) {\n");
    code.push_str("    char default_str[32];\n");
    code.push_str("    snprintf(default_str, sizeof(default_str), \"%d\", default_val);\n");
    code.push_str("    int idx = register_flag(name, 'i', default_str, usage);\n");
    code.push_str("    if (idx < 0) return default_val;\n");
    code.push_str("    return atoi(flags[idx].value);\n");
    code.push_str("}\n\n");
    
    // flag.Bool - Define boolean flag
    code.push_str("// flag.Bool - Define boolean flag\n");
    code.push_str("int flag_Bool(const char* name, int default_val, const char* usage) {\n");
    code.push_str("    char default_str[32];\n");
    code.push_str("    snprintf(default_str, sizeof(default_str), \"%d\", default_val);\n");
    code.push_str("    int idx = register_flag(name, 'b', default_str, usage);\n");
    code.push_str("    if (idx < 0) return default_val;\n");
    code.push_str("    return atoi(flags[idx].value) != 0;\n");
    code.push_str("}\n\n");
    
    // flag.Float64 - Define float flag
    code.push_str("// flag.Float64 - Define float flag\n");
    code.push_str("double flag_Float64(const char* name, double default_val, const char* usage) {\n");
    code.push_str("    char default_str[32];\n");
    code.push_str("    snprintf(default_str, sizeof(default_str), \"%f\", default_val);\n");
    code.push_str("    int idx = register_flag(name, 'f', default_str, usage);\n");
    code.push_str("    if (idx < 0) return default_val;\n");
    code.push_str("    return atof(flags[idx].value);\n");
    code.push_str("}\n\n");
    
    // flag.Parse - Parse command-line arguments
    code.push_str("// flag.Parse - Parse command-line arguments\n");
    code.push_str("void flag_Parse() {\n");
    code.push_str("    if (flag_parsed) return;\n");
    code.push_str("    flag_parsed = 1;\n");
    code.push_str("    \n");
    code.push_str("    int argc = args_Count();  // args_Count() returns number of args (excluding program name)\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < argc; i++) {\n");
    code.push_str("        char arg[MAX_FLAG_VALUE];\n");
    code.push_str("        strncpy(arg, args_Get(i), MAX_FLAG_VALUE - 1);\n");
    code.push_str("        arg[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("        \n");
    code.push_str("        // Check if it's a flag (starts with -)\n");
    code.push_str("        if (arg[0] == '-' && arg[1] != '\\0') {\n");
    code.push_str("            char* name = arg + 1;  // Skip -\n");
    code.push_str("            char* value = NULL;\n");
    code.push_str("            \n");
    code.push_str("            // Check for =value format\n");
    code.push_str("            char* eq = strchr(name, '=');\n");
    code.push_str("            if (eq != NULL) {\n");
    code.push_str("                *eq = '\\0';\n");
    code.push_str("                value = eq + 1;\n");
    code.push_str("            } else if (i + 1 < argc) {\n");
    code.push_str("                // Check if next arg is a value (not a flag)\n");
    code.push_str("                char next[MAX_FLAG_VALUE];\n");
    code.push_str("                strncpy(next, args_Get(i + 1), MAX_FLAG_VALUE - 1);\n");
    code.push_str("                next[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("                if (next[0] != '-') {\n");
    code.push_str("                    value = next;\n");
    code.push_str("                    i++;  // Skip next arg\n");
    code.push_str("                }\n");
    code.push_str("            }\n");
    code.push_str("            \n");
    code.push_str("            // Find and set flag\n");
    code.push_str("            int idx = find_flag(name);\n");
    code.push_str("            if (idx >= 0) {\n");
    code.push_str("                if (value != NULL) {\n");
    code.push_str("                    strncpy(flags[idx].value, value, MAX_FLAG_VALUE - 1);\n");
    code.push_str("                    flags[idx].value[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("                } else if (flags[idx].type == 'b') {\n");
    code.push_str("                    // Boolean flag: -flag sets to 1\n");
    code.push_str("                    strcpy(flags[idx].value, \"1\");\n");
    code.push_str("                }\n");
    code.push_str("                flags[idx].is_set = 1;\n");
    code.push_str("            }\n");
    code.push_str("        } else {\n");
    code.push_str("            // Non-flag argument\n");
    code.push_str("            if (non_flag_count < MAX_ARGS) {\n");
    code.push_str("                strncpy(non_flag_args[non_flag_count], arg, MAX_FLAG_VALUE - 1);\n");
    code.push_str("                non_flag_args[non_flag_count][MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("                non_flag_count++;\n");
    code.push_str("            }\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // flag.Args - Get non-flag arguments
    code.push_str("// flag.Args - Get non-flag arguments (returns newline-separated string)\n");
    code.push_str("char* flag_Args() {\n");
    code.push_str("    static char result[4096];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < non_flag_count; i++) {\n");
    code.push_str("        if (i > 0) strcat(result, \"\\n\");\n");
    code.push_str("        strcat(result, non_flag_args[i]);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // flag.GetString - Get string flag value
    code.push_str("// flag.GetString - Get string flag value\n");
    code.push_str("char* flag_GetString(const char* name) {\n");
    code.push_str("    static char result[MAX_FLAG_VALUE];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    int idx = find_flag(name);\n");
    code.push_str("    if (idx >= 0) {\n");
    code.push_str("        strncpy(result, flags[idx].value, MAX_FLAG_VALUE - 1);\n");
    code.push_str("        result[MAX_FLAG_VALUE - 1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // flag.GetInt - Get integer flag value
    code.push_str("// flag.GetInt - Get integer flag value\n");
    code.push_str("int flag_GetInt(const char* name) {\n");
    code.push_str("    int idx = find_flag(name);\n");
    code.push_str("    if (idx >= 0) {\n");
    code.push_str("        return atoi(flags[idx].value);\n");
    code.push_str("    }\n");
    code.push_str("    return 0;\n");
    code.push_str("}\n\n");
    
    // flag.GetBool - Get boolean flag value
    code.push_str("// flag.GetBool - Get boolean flag value\n");
    code.push_str("int flag_GetBool(const char* name) {\n");
    code.push_str("    int idx = find_flag(name);\n");
    code.push_str("    if (idx >= 0) {\n");
    code.push_str("        return atoi(flags[idx].value) != 0;\n");
    code.push_str("    }\n");
    code.push_str("    return 0;\n");
    code.push_str("}\n\n");
    
    // flag.GetFloat64 - Get float flag value
    code.push_str("// flag.GetFloat64 - Get float flag value\n");
    code.push_str("double flag_GetFloat64(const char* name) {\n");
    code.push_str("    int idx = find_flag(name);\n");
    code.push_str("    if (idx >= 0) {\n");
    code.push_str("        return atof(flags[idx].value);\n");
    code.push_str("    }\n");
    code.push_str("    return 0.0;\n");
    code.push_str("}\n\n");
    
    code
}
