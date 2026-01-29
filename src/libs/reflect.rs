// reflect - Reflection library
// Provides runtime type information and value introspection

pub fn generate_reflect_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // Type information structure
    code.push_str("// Type information structure\n");
    code.push_str("typedef struct {\n");
    code.push_str("    char name[64];\n");
    code.push_str("    int kind;  // 0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer\n");
    code.push_str("    int size;  // Size in bytes\n");
    code.push_str("} TypeInfo;\n\n");
    
    // Value information structure
    code.push_str("// Value information structure\n");
    code.push_str("typedef struct {\n");
    code.push_str("    TypeInfo* type;\n");
    code.push_str("    void* value;\n");
    code.push_str("    char string_repr[256];\n");
    code.push_str("} ValueInfo;\n\n");
    
    // Type registry (max 100 types)
    code.push_str("#define MAX_TYPES 100\n");
    code.push_str("static TypeInfo type_registry[MAX_TYPES];\n");
    code.push_str("static int type_count = 0;\n\n");
    
    // Helper: Register type
    code.push_str("static TypeInfo* register_type(const char* name, int kind, int size) {\n");
    code.push_str("    if (type_count >= MAX_TYPES) return NULL;\n");
    code.push_str("    \n");
    code.push_str("    TypeInfo* t = &type_registry[type_count++];\n");
    code.push_str("    strncpy(t->name, name, sizeof(t->name) - 1);\n");
    code.push_str("    t->name[sizeof(t->name) - 1] = '\\0';\n");
    code.push_str("    t->kind = kind;\n");
    code.push_str("    t->size = size;\n");
    code.push_str("    \n");
    code.push_str("    return t;\n");
    code.push_str("}\n\n");
    
    // Initialize type registry
    code.push_str("static void init_type_registry() {\n");
    code.push_str("    static int initialized = 0;\n");
    code.push_str("    if (initialized) return;\n");
    code.push_str("    initialized = 1;\n");
    code.push_str("    \n");
    code.push_str("    register_type(\"int\", 0, sizeof(int));\n");
    code.push_str("    register_type(\"float\", 1, sizeof(double));\n");
    code.push_str("    register_type(\"string\", 2, sizeof(char*));\n");
    code.push_str("    register_type(\"bool\", 3, sizeof(int));\n");
    code.push_str("    register_type(\"error\", 4, sizeof(char*));\n");
    code.push_str("    register_type(\"pointer\", 5, sizeof(void*));\n");
    code.push_str("}\n\n");
    
    // reflect.TypeOf - Get type information
    code.push_str("// reflect.TypeOf - Get type information\n");
    code.push_str("char* reflect_TypeOf(const char* type_name) {\n");
    code.push_str("    static char result[128];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    init_type_registry();\n");
    code.push_str("    \n");
    code.push_str("    // Find type in registry\n");
    code.push_str("    for (int i = 0; i < type_count; i++) {\n");
    code.push_str("        if (strcmp(type_registry[i].name, type_name) == 0) {\n");
    code.push_str("            snprintf(result, sizeof(result), \"%s|%d|%d\", \n");
    code.push_str("                     type_registry[i].name, \n");
    code.push_str("                     type_registry[i].kind, \n");
    code.push_str("                     type_registry[i].size);\n");
    code.push_str("            return result;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Return unknown type\n");
    code.push_str("    snprintf(result, sizeof(result), \"unknown|0|0\");\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // reflect.TypeOfInt - Get type info for int value
    code.push_str("// reflect.TypeOfInt - Get type info for int value\n");
    code.push_str("char* reflect_TypeOfInt(int value) {\n");
    code.push_str("    return reflect_TypeOf(\"int\");\n");
    code.push_str("}\n\n");
    
    // reflect.TypeOfFloat - Get type info for float value
    code.push_str("// reflect.TypeOfFloat - Get type info for float value\n");
    code.push_str("char* reflect_TypeOfFloat(double value) {\n");
    code.push_str("    return reflect_TypeOf(\"float\");\n");
    code.push_str("}\n\n");
    
    // reflect.TypeOfString - Get type info for string value
    code.push_str("// reflect.TypeOfString - Get type info for string value\n");
    code.push_str("char* reflect_TypeOfString(const char* value) {\n");
    code.push_str("    return reflect_TypeOf(\"string\");\n");
    code.push_str("}\n\n");
    
    // reflect.ValueOf - Get value information
    code.push_str("// reflect.ValueOf - Get value information (for int)\n");
    code.push_str("char* reflect_ValueOfInt(int value) {\n");
    code.push_str("    static char result[128];\n");
    code.push_str("    snprintf(result, sizeof(result), \"int|%d\", value);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // reflect.ValueOfFloat - Get value information for float
    code.push_str("// reflect.ValueOfFloat - Get value information for float\n");
    code.push_str("char* reflect_ValueOfFloat(double value) {\n");
    code.push_str("    static char result[128];\n");
    code.push_str("    snprintf(result, sizeof(result), \"float|%.6f\", value);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // reflect.ValueOfString - Get value information for string
    code.push_str("// reflect.ValueOfString - Get value information for string\n");
    code.push_str("char* reflect_ValueOfString(const char* value) {\n");
    code.push_str("    static char result[512];\n");
    code.push_str("    if (value == NULL) {\n");
    code.push_str("        snprintf(result, sizeof(result), \"string|NULL\");\n");
    code.push_str("    } else {\n");
    code.push_str("        snprintf(result, sizeof(result), \"string|%s\", value);\n");
    code.push_str("    }\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // reflect.Kind - Get type kind
    code.push_str("// reflect.Kind - Get type kind (0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer)\n");
    code.push_str("int reflect_Kind(const char* type_name) {\n");
    code.push_str("    init_type_registry();\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < type_count; i++) {\n");
    code.push_str("        if (strcmp(type_registry[i].name, type_name) == 0) {\n");
    code.push_str("            return type_registry[i].kind;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return -1;  // Unknown type\n");
    code.push_str("}\n\n");
    
    // reflect.Size - Get type size
    code.push_str("// reflect.Size - Get type size in bytes\n");
    code.push_str("int reflect_Size(const char* type_name) {\n");
    code.push_str("    init_type_registry();\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < type_count; i++) {\n");
    code.push_str("        if (strcmp(type_registry[i].name, type_name) == 0) {\n");
    code.push_str("            return type_registry[i].size;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return 0;  // Unknown type\n");
    code.push_str("}\n\n");
    
    // reflect.Name - Get type name
    code.push_str("// reflect.Name - Get type name\n");
    code.push_str("char* reflect_Name(const char* type_name) {\n");
    code.push_str("    static char result[64];\n");
    code.push_str("    init_type_registry();\n");
    code.push_str("    \n");
    code.push_str("    for (int i = 0; i < type_count; i++) {\n");
    code.push_str("        if (strcmp(type_registry[i].name, type_name) == 0) {\n");
    code.push_str("            strncpy(result, type_registry[i].name, sizeof(result) - 1);\n");
    code.push_str("            result[sizeof(result) - 1] = '\\0';\n");
    code.push_str("            return result;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    strcpy(result, \"unknown\");\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // reflect.IsInt - Check if type is int
    code.push_str("// reflect.IsInt - Check if type is int\n");
    code.push_str("int reflect_IsInt(const char* type_name) {\n");
    code.push_str("    return reflect_Kind(type_name) == 0;\n");
    code.push_str("}\n\n");
    
    // reflect.IsFloat - Check if type is float
    code.push_str("// reflect.IsFloat - Check if type is float\n");
    code.push_str("int reflect_IsFloat(const char* type_name) {\n");
    code.push_str("    return reflect_Kind(type_name) == 1;\n");
    code.push_str("}\n\n");
    
    // reflect.IsString - Check if type is string
    code.push_str("// reflect.IsString - Check if type is string\n");
    code.push_str("int reflect_IsString(const char* type_name) {\n");
    code.push_str("    return reflect_Kind(type_name) == 2;\n");
    code.push_str("}\n\n");
    
    code
}
