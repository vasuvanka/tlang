// os - Operating System Interface library
// Ported from Go's os package

pub fn generate_os_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("#include <windows.h>\n");
    code.push_str("#include <io.h>\n");
    code.push_str("#else\n");
    code.push_str("#include <unistd.h>\n");
    code.push_str("#endif\n\n");
    
    // Getenv
    code.push_str("// os.Getenv - Get environment variable\n");
    code.push_str("char* os_Getenv(const char* key) {\n");
    code.push_str("    char* value = getenv(key);\n");
    code.push_str("    return value ? value : \"\";\n");
    code.push_str("}\n\n");
    
    // Setenv - Windows-compatible implementation
    code.push_str("// os.Setenv - Set environment variable\n");
    code.push_str("int os_Setenv(const char* key, const char* value) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    // Windows: use _putenv_s or SetEnvironmentVariable\n");
    code.push_str("    char* env_str = (char*)malloc(strlen(key) + strlen(value) + 2);\n");
    code.push_str("    if (!env_str) return -1;\n");
    code.push_str("    sprintf(env_str, \"%s=%s\", key, value);\n");
    code.push_str("    int result = _putenv(env_str);\n");
    code.push_str("    free(env_str);\n");
    code.push_str("    return result == 0 ? 0 : -1;\n");
    code.push_str("#else\n");
    code.push_str("    return setenv(key, value, 1);\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // Exit
    code.push_str("// os.Exit - Exit program with status code\n");
    code.push_str("void os_Exit(int code) {\n");
    code.push_str("    exit(code);\n");
    code.push_str("}\n\n");
    
    // Getwd
    code.push_str("// os.Getwd - Get current working directory\n");
    code.push_str("char* os_Getwd() {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    if (getcwd(buffer, sizeof(buffer)) != NULL) {\n");
    code.push_str("        return buffer;\n");
    code.push_str("    }\n");
    code.push_str("    return \"\";\n");
    code.push_str("}\n\n");
    
    // Chdir
    code.push_str("// os.Chdir - Change directory\n");
    code.push_str("int os_Chdir(const char* path) {\n");
    code.push_str("    return chdir(path);\n");
    code.push_str("}\n\n");
    
    code
}
