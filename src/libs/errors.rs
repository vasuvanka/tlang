// errors - Error handling utilities library
// Provides helper functions for error handling patterns

pub fn generate_errors_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <stdlib.h>\n\n");
    
    // errors.New - Create new error with message
    code.push_str("// errors.New - Create new error\n");
    code.push_str("char* errors_New(const char* msg) {\n");
    code.push_str("    if (!msg) return NULL;\n");
    code.push_str("    int len = strlen(msg);\n");
    code.push_str("    char* err = (char*)malloc(len + 1);\n");
    code.push_str("    if (!err) return NULL;\n");
    code.push_str("    strcpy(err, msg);\n");
    code.push_str("    return err;\n");
    code.push_str("}\n\n");
    
    // errors.Errorf - Format error message (simplified - uses sprintf)
    code.push_str("// errors.Errorf - Format error message\n");
    code.push_str("// Note: Simplified - uses sprintf for formatting\n");
    code.push_str("char* errors_Errorf(const char* format, const char* arg1) {\n");
    code.push_str("    static char buffer[1024];\n");
    code.push_str("    snprintf(buffer, sizeof(buffer), format, arg1);\n");
    code.push_str("    int len = strlen(buffer);\n");
    code.push_str("    char* err = (char*)malloc(len + 1);\n");
    code.push_str("    if (!err) return NULL;\n");
    code.push_str("    strcpy(err, buffer);\n");
    code.push_str("    return err;\n");
    code.push_str("}\n\n");
    
    // errors.Wrap - Wrap error with context
    code.push_str("// errors.Wrap - Wrap error with context message\n");
    code.push_str("char* errors_Wrap(char* err, const char* context) {\n");
    code.push_str("    if (!err) return NULL;\n");
    code.push_str("    if (!context) return err;\n");
    code.push_str("    int err_len = strlen(err);\n");
    code.push_str("    int ctx_len = strlen(context);\n");
    code.push_str("    char* wrapped = (char*)malloc(err_len + ctx_len + 3);\n");
    code.push_str("    if (!wrapped) return err;\n");
    code.push_str("    snprintf(wrapped, err_len + ctx_len + 3, \"%s: %s\", context, err);\n");
    code.push_str("    free(err);  // Free original error\n");
    code.push_str("    return wrapped;\n");
    code.push_str("}\n\n");
    
    // errors.IsNil - Check if error is nil
    code.push_str("// errors.IsNil - Check if error is nil\n");
    code.push_str("int errors_IsNil(char* err) {\n");
    code.push_str("    return err == NULL ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // errors.Unwrap - Get underlying error (for future use)
    code.push_str("// errors.Unwrap - Get underlying error (placeholder)\n");
    code.push_str("char* errors_Unwrap(char* err) {\n");
    code.push_str("    // For now, just return the error itself\n");
    code.push_str("    // In future, could extract wrapped error\n");
    code.push_str("    return err;\n");
    code.push_str("}\n\n");
    
    code
}
