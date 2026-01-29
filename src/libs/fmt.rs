// fmt - Formatting and I/O library
// Ported from Go's fmt package

pub fn generate_fmt_lib() -> String {
    let mut code = String::new();
    
    // Print functions
    code.push_str("// fmt.Print - Prints arguments without newline\n");
    code.push_str("void fmt_Print(const char* format, ...) {\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vprintf(format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Println - Prints arguments with newline\n");
    code.push_str("void fmt_Println(const char* format, ...) {\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vprintf(format, args);\n");
    code.push_str("    printf(\"\\n\");\n");
    code.push_str("    va_end(args);\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Printf - Formatted printing\n");
    code.push_str("void fmt_Printf(const char* format, ...) {\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vprintf(format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Sprint - Returns formatted string\n");
    code.push_str("char* fmt_Sprint(const char* format, ...) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vsnprintf(buffer, sizeof(buffer), format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Sprintf - Returns formatted string\n");
    code.push_str("char* fmt_Sprintf(const char* format, ...) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vsnprintf(buffer, sizeof(buffer), format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Scan - Reads from stdin\n");
    code.push_str("int fmt_Scan(const char* format, ...) {\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    int result = vscanf(format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code.push_str("// fmt.Scanf - Formatted input\n");
    code.push_str("int fmt_Scanf(const char* format, ...) {\n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    int result = vscanf(format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
