// log - Logging library
// Ported from Go's log package

pub fn generate_log_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <time.h>\n");
    code.push_str("#include <stdarg.h>\n");
    code.push_str("\n");
    
    // Log level constants
    code.push_str("// Log levels\n");
    code.push_str("#define LOG_DEBUG 0\n");
    code.push_str("#define LOG_INFO 1\n");
    code.push_str("#define LOG_WARN 2\n");
    code.push_str("#define LOG_ERROR 3\n");
    code.push_str("#define LOG_FATAL 4\n\n");
    
    // Global log state
    code.push_str("// Global log state\n");
    code.push_str("static FILE* log_file = NULL;\n");
    code.push_str("static int log_level = LOG_INFO; // Default to INFO\n");
    code.push_str("static int log_initialized = 0;\n");
    code.push_str("static char log_filename[256] = \"\";\n\n");
    
    // Initialize log (open stdout by default)
    code.push_str("static void log_init() {\n");
    code.push_str("    if (!log_initialized) {\n");
    code.push_str("        log_file = stdout;\n");
    code.push_str("        log_initialized = 1;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // Get current timestamp string
    code.push_str("static void log_get_timestamp(char* buffer, int size) {\n");
    code.push_str("    time_t now = time(NULL);\n");
    code.push_str("    struct tm* tm_info = localtime(&now);\n");
    code.push_str("    strftime(buffer, size, \"%Y-%m-%d %H:%M:%S\", tm_info);\n");
    code.push_str("}\n\n");
    
    // Get log level name
    code.push_str("static const char* log_level_name(int level) {\n");
    code.push_str("    switch (level) {\n");
    code.push_str("        case LOG_DEBUG: return \"DEBUG\";\n");
    code.push_str("        case LOG_INFO: return \"INFO\";\n");
    code.push_str("        case LOG_WARN: return \"WARN\";\n");
    code.push_str("        case LOG_ERROR: return \"ERROR\";\n");
    code.push_str("        case LOG_FATAL: return \"FATAL\";\n");
    code.push_str("        default: return \"UNKNOWN\";\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // Internal log function
    code.push_str("static void log_write(int level, const char* message) {\n");
    code.push_str("    log_init();\n");
    code.push_str("    \n");
    code.push_str("    // Check if message should be logged based on level\n");
    code.push_str("    if (level < log_level) {\n");
    code.push_str("        return;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    char timestamp[32];\n");
    code.push_str("    log_get_timestamp(timestamp, sizeof(timestamp));\n");
    code.push_str("    \n");
    code.push_str("    fprintf(log_file, \"[%s] [%s] %s\\n\", timestamp, log_level_name(level), message);\n");
    code.push_str("    fflush(log_file);\n");
    code.push_str("}\n\n");
    
    // log.Print - Print log message (defaults to INFO level)
    code.push_str("// log.Print - Print log message (INFO level)\n");
    code.push_str("void log_Print(const char* message) {\n");
    code.push_str("    log_write(LOG_INFO, message);\n");
    code.push_str("}\n\n");
    
    // log.Printf - Formatted log message (INFO level)
    code.push_str("// log.Printf - Formatted log message (INFO level)\n");
    code.push_str("void log_Printf(const char* format, ...) {\n");
    code.push_str("    log_init();\n");
    code.push_str("    \n");
    code.push_str("    if (LOG_INFO < log_level) {\n");
    code.push_str("        return;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    char timestamp[32];\n");
    code.push_str("    log_get_timestamp(timestamp, sizeof(timestamp));\n");
    code.push_str("    \n");
    code.push_str("    fprintf(log_file, \"[%s] [INFO] \", timestamp);\n");
    code.push_str("    \n");
    code.push_str("    va_list args;\n");
    code.push_str("    va_start(args, format);\n");
    code.push_str("    vfprintf(log_file, format, args);\n");
    code.push_str("    va_end(args);\n");
    code.push_str("    \n");
    code.push_str("    fprintf(log_file, \"\\n\");\n");
    code.push_str("    fflush(log_file);\n");
    code.push_str("}\n\n");
    
    // log.Debug - Debug level log
    code.push_str("// log.Debug - Debug level log\n");
    code.push_str("void log_Debug(const char* message) {\n");
    code.push_str("    log_write(LOG_DEBUG, message);\n");
    code.push_str("}\n\n");
    
    // log.Info - Info level log
    code.push_str("// log.Info - Info level log\n");
    code.push_str("void log_Info(const char* message) {\n");
    code.push_str("    log_write(LOG_INFO, message);\n");
    code.push_str("}\n\n");
    
    // log.Warn - Warning level log
    code.push_str("// log.Warn - Warning level log\n");
    code.push_str("void log_Warn(const char* message) {\n");
    code.push_str("    log_write(LOG_WARN, message);\n");
    code.push_str("}\n\n");
    
    // log.Error - Error level log
    code.push_str("// log.Error - Error level log\n");
    code.push_str("void log_Error(const char* message) {\n");
    code.push_str("    log_write(LOG_ERROR, message);\n");
    code.push_str("}\n\n");
    
    // log.Fatal - Log and exit program
    code.push_str("// log.Fatal - Log and exit program\n");
    code.push_str("void log_Fatal(const char* message) {\n");
    code.push_str("    log_write(LOG_FATAL, message);\n");
    code.push_str("    exit(1);\n");
    code.push_str("}\n\n");
    
    // log.SetOutput - Set log output file
    code.push_str("// log.SetOutput - Set log output file\n");
    code.push_str("int log_SetOutput(const char* filename) {\n");
    code.push_str("    // Close existing file if open and not stdout/stderr\n");
    code.push_str("    if (log_file != NULL && log_file != stdout && log_file != stderr) {\n");
    code.push_str("        fclose(log_file);\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Open new file\n");
    code.push_str("    log_file = fopen(filename, \"a\"); // Append mode\n");
    code.push_str("    if (log_file == NULL) {\n");
    code.push_str("        return 0; // Failed to open file\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    strncpy(log_filename, filename, sizeof(log_filename) - 1);\n");
    code.push_str("    log_filename[sizeof(log_filename) - 1] = '\\0';\n");
    code.push_str("    log_initialized = 1;\n");
    code.push_str("    return 1; // Success\n");
    code.push_str("}\n\n");
    
    // log.SetLevel - Set log level
    code.push_str("// log.SetLevel - Set log level\n");
    code.push_str("void log_SetLevel(int level) {\n");
    code.push_str("    if (level >= LOG_DEBUG && level <= LOG_FATAL) {\n");
    code.push_str("        log_level = level;\n");
    code.push_str("    }\n");
    code.push_str("}\n\n");
    
    // log.GetLevel - Get current log level
    code.push_str("// log.GetLevel - Get current log level\n");
    code.push_str("int log_GetLevel() {\n");
    code.push_str("    return log_level;\n");
    code.push_str("}\n\n");
    
    // log.Reset - Reset to stdout
    code.push_str("// log.Reset - Reset log output to stdout\n");
    code.push_str("void log_Reset() {\n");
    code.push_str("    if (log_file != NULL && log_file != stdout && log_file != stderr) {\n");
    code.push_str("        fclose(log_file);\n");
    code.push_str("    }\n");
    code.push_str("    log_file = stdout;\n");
    code.push_str("    log_level = LOG_INFO;\n");
    code.push_str("    log_filename[0] = '\\0';\n");
    code.push_str("}\n\n");
    
    code
}
