// time - Time Operations library
// Ported from Go's time package

pub fn generate_time_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <time.h>\n");
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("#include <windows.h>\n");
    code.push_str("#else\n");
    code.push_str("#include <unistd.h>\n");
    code.push_str("#endif\n\n");
    
    // Now - Current time as Unix timestamp
    code.push_str("// time.Now - Current time as Unix timestamp\n");
    code.push_str("long time_Now() {\n");
    code.push_str("    return (long)time(NULL);\n");
    code.push_str("}\n\n");
    
    // Sleep
    code.push_str("// time.Sleep - Sleep for specified seconds\n");
    code.push_str("void time_Sleep(int seconds) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    Sleep(seconds * 1000);\n");
    code.push_str("#else\n");
    code.push_str("    sleep(seconds);\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // SleepMilliseconds
    code.push_str("// time.SleepMilliseconds - Sleep for milliseconds\n");
    code.push_str("void time_SleepMilliseconds(int ms) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    Sleep(ms);\n");
    code.push_str("#else\n");
    code.push_str("    usleep(ms * 1000);\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // Format - Format Unix timestamp to string
    code.push_str("// time.Format - Format Unix timestamp to string\n");
    code.push_str("char* time_Format(long timestamp, const char* format) {\n");
    code.push_str("    static char buffer[128];\n");
    code.push_str("    struct tm* timeinfo;\n");
    code.push_str("    time_t t = (time_t)timestamp;\n");
    code.push_str("    timeinfo = localtime(&t);\n");
    code.push_str("    strftime(buffer, sizeof(buffer), format, timeinfo);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // Parse - Parse time string to Unix timestamp
    // strptime is POSIX-only, so we need a Windows-compatible implementation
    code.push_str("// time.Parse - Parse time string to Unix timestamp\n");
    code.push_str("long time_Parse(const char* timeStr, const char* format) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    // Windows: strptime is not available, use sscanf as fallback\n");
    code.push_str("    // This is a simplified implementation - full strptime would be more complex\n");
    code.push_str("    struct tm tm = {0};\n");
    code.push_str("    // Try common formats: \"%Y-%m-%d %H:%M:%S\" or \"%Y-%m-%d\"\n");
    code.push_str("    if (sscanf(timeStr, \"%d-%d-%d %d:%d:%d\", &tm.tm_year, &tm.tm_mon, &tm.tm_mday, &tm.tm_hour, &tm.tm_min, &tm.tm_sec) == 6) {\n");
    code.push_str("        tm.tm_year -= 1900;\n");
    code.push_str("        tm.tm_mon -= 1;\n");
    code.push_str("        return (long)mktime(&tm);\n");
    code.push_str("    } else if (sscanf(timeStr, \"%d-%d-%d\", &tm.tm_year, &tm.tm_mon, &tm.tm_mday) == 3) {\n");
    code.push_str("        tm.tm_year -= 1900;\n");
    code.push_str("        tm.tm_mon -= 1;\n");
    code.push_str("        return (long)mktime(&tm);\n");
    code.push_str("    }\n");
    code.push_str("    return -1; // error\n");
    code.push_str("#else\n");
    code.push_str("    struct tm tm = {0};\n");
    code.push_str("    if (strptime(timeStr, format, &tm) != NULL) {\n");
    code.push_str("        return (long)mktime(&tm);\n");
    code.push_str("    }\n");
    code.push_str("    return -1; // error\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    code
}
