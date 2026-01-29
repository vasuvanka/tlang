// strconv - String conversion library
// Ported from Go's strconv package

pub fn generate_strconv_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <stdio.h>\n\n");
    
    // Atoi - String to int
    code.push_str("// strconv.Atoi - String to integer\n");
    code.push_str("int strconv_Atoi(const char* s) {\n");
    code.push_str("    return atoi(s);\n");
    code.push_str("}\n\n");
    
    // Itoa - Int to string
    code.push_str("// strconv.Itoa - Integer to string\n");
    code.push_str("char* strconv_Itoa(int i) {\n");
    code.push_str("    static char buffer[32];\n");
    code.push_str("    snprintf(buffer, sizeof(buffer), \"%d\", i);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // ParseFloat
    code.push_str("// strconv.ParseFloat - String to float\n");
    code.push_str("double strconv_ParseFloat(const char* s) {\n");
    code.push_str("    return atof(s);\n");
    code.push_str("}\n\n");
    
    // FormatFloat
    code.push_str("// strconv.FormatFloat - Float to string\n");
    code.push_str("char* strconv_FormatFloat(double f, int prec) {\n");
    code.push_str("    static char buffer[64];\n");
    code.push_str("    char format[16];\n");
    code.push_str("    snprintf(format, sizeof(format), \"%%.%df\", prec);\n");
    code.push_str("    snprintf(buffer, sizeof(buffer), format, f);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // ParseBool
    code.push_str("// strconv.ParseBool - String to boolean\n");
    code.push_str("int strconv_ParseBool(const char* s) {\n");
    code.push_str("    if (strcmp(s, \"true\") == 0 || strcmp(s, \"1\") == 0) return 1;\n");
    code.push_str("    if (strcmp(s, \"false\") == 0 || strcmp(s, \"0\") == 0) return 0;\n");
    code.push_str("    return -1; // error\n");
    code.push_str("}\n\n");
    
    // FormatBool
    code.push_str("// strconv.FormatBool - Boolean to string\n");
    code.push_str("char* strconv_FormatBool(int b) {\n");
    code.push_str("    return b ? \"true\" : \"false\";\n");
    code.push_str("}\n\n");
    
    code
}
