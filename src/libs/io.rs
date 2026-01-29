// io - File I/O Operations library
// Ported from Go's io and os packages

pub fn generate_io_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <errno.h>\n");
    
    // Platform-specific includes
    code.push_str("#ifdef _WIN32\n");
    code.push_str("#include <windows.h>\n");
    code.push_str("#include <direct.h>\n");
    code.push_str("#include <io.h>\n");
    code.push_str("#include <sys/stat.h>\n");
    code.push_str("#define stat _stat\n");
    code.push_str("#ifndef S_ISDIR\n");
    code.push_str("#define S_ISDIR(m) (((m) & _S_IFMT) == _S_IFDIR)\n");
    code.push_str("#endif\n");
    code.push_str("#else\n");
    code.push_str("#include <unistd.h>\n");
    code.push_str("#include <sys/stat.h>\n");
    code.push_str("#include <dirent.h>\n");
    code.push_str("#endif\n");
    code.push_str("\n");
    
    // Helper function to get file size
    code.push_str("static long get_file_size(FILE* fp) {\n");
    code.push_str("    long pos = ftell(fp);\n");
    code.push_str("    fseek(fp, 0, SEEK_END);\n");
    code.push_str("    long size = ftell(fp);\n");
    code.push_str("    fseek(fp, pos, SEEK_SET);\n");
    code.push_str("    return size;\n");
    code.push_str("}\n\n");
    
    // ReadFile - Read entire file as string
    code.push_str("// io.ReadFile - Read entire file as string\n");
    code.push_str("char* io_ReadFile(const char* filename) {\n");
    code.push_str("    static char buffer[65536]; // 64KB buffer\n");
    code.push_str("    FILE* fp = fopen(filename, \"rb\");\n");
    code.push_str("    if (!fp) {\n");
    code.push_str("        return \"\";\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    long size = get_file_size(fp);\n");
    code.push_str("    if (size >= sizeof(buffer) - 1) {\n");
    code.push_str("        size = sizeof(buffer) - 1;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    size_t read = fread(buffer, 1, size, fp);\n");
    code.push_str("    buffer[read] = '\\0';\n");
    code.push_str("    fclose(fp);\n");
    code.push_str("    return buffer;\n");
    code.push_str("}\n\n");
    
    // WriteFile - Write string to file
    code.push_str("// io.WriteFile - Write string to file, returns bytes written\n");
    code.push_str("int io_WriteFile(const char* filename, const char* data) {\n");
    code.push_str("    FILE* fp = fopen(filename, \"wb\");\n");
    code.push_str("    if (!fp) {\n");
    code.push_str("        return -1;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(data);\n");
    code.push_str("    size_t written = fwrite(data, 1, len, fp);\n");
    code.push_str("    fclose(fp);\n");
    code.push_str("    return (int)written;\n");
    code.push_str("}\n\n");
    
    // ReadDir - Read directory contents (returns newline-separated string)
    code.push_str("// io.ReadDir - Read directory contents (returns newline-separated string)\n");
    code.push_str("char* io_ReadDir(const char* dirname) {\n");
    code.push_str("    static char result[8192]; // 8KB buffer\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    WIN32_FIND_DATA findData;\n");
    code.push_str("    char pattern[512];\n");
    code.push_str("    snprintf(pattern, sizeof(pattern), \"%s\\\\*\", dirname);\n");
    code.push_str("    HANDLE hFind = FindFirstFileA(pattern, &findData);\n");
    code.push_str("    if (hFind == INVALID_HANDLE_VALUE) {\n");
    code.push_str("        return \"\";\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    do {\n");
    code.push_str("        if (strlen(result) + strlen(findData.cFileName) + 2 < sizeof(result)) {\n");
    code.push_str("            if (result[0] != '\\0') strcat(result, \"\\n\");\n");
    code.push_str("            strcat(result, findData.cFileName);\n");
    code.push_str("        }\n");
    code.push_str("    } while (FindNextFileA(hFind, &findData));\n");
    code.push_str("    \n");
    code.push_str("    FindClose(hFind);\n");
    code.push_str("#else\n");
    code.push_str("    DIR* dir = opendir(dirname);\n");
    code.push_str("    if (!dir) {\n");
    code.push_str("        return \"\";\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    struct dirent* entry;\n");
    code.push_str("    while ((entry = readdir(dir)) != NULL) {\n");
    code.push_str("        // Skip . and ..\n");
    code.push_str("        if (strcmp(entry->d_name, \".\") == 0 || strcmp(entry->d_name, \"..\") == 0) {\n");
    code.push_str("            continue;\n");
    code.push_str("        }\n");
    code.push_str("        if (strlen(result) + strlen(entry->d_name) + 2 < sizeof(result)) {\n");
    code.push_str("            if (result[0] != '\\0') strcat(result, \"\\n\");\n");
    code.push_str("            strcat(result, entry->d_name);\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    closedir(dir);\n");
    code.push_str("#endif\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // Mkdir - Create directory
    code.push_str("// io.Mkdir - Create directory\n");
    code.push_str("int io_Mkdir(const char* name, int perm) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    (void)perm; // Windows doesn't use permissions the same way\n");
    code.push_str("    return _mkdir(name);\n");
    code.push_str("#else\n");
    code.push_str("    return mkdir(name, (mode_t)perm);\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // Remove - Remove file or directory
    code.push_str("// io.Remove - Remove file or directory\n");
    code.push_str("int io_Remove(const char* name) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    struct stat st;\n");
    code.push_str("    if (stat(name, &st) != 0) {\n");
    code.push_str("        return -1;\n");
    code.push_str("    }\n");
    code.push_str("    if (S_ISDIR(st.st_mode)) {\n");
    code.push_str("        return _rmdir(name);\n");
    code.push_str("    } else {\n");
    code.push_str("        return remove(name);\n");
    code.push_str("    }\n");
    code.push_str("#else\n");
    code.push_str("    struct stat st;\n");
    code.push_str("    if (stat(name, &st) != 0) {\n");
    code.push_str("        return -1;\n");
    code.push_str("    }\n");
    code.push_str("    if (S_ISDIR(st.st_mode)) {\n");
    code.push_str("        return rmdir(name);\n");
    code.push_str("    } else {\n");
    code.push_str("        return remove(name);\n");
    code.push_str("    }\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // Rename - Rename/move file
    code.push_str("// io.Rename - Rename/move file\n");
    code.push_str("int io_Rename(const char* oldpath, const char* newpath) {\n");
    code.push_str("    return rename(oldpath, newpath);\n");
    code.push_str("}\n\n");
    
    // Exists - Check if file/directory exists
    code.push_str("// io.Exists - Check if file/directory exists\n");
    code.push_str("int io_Exists(const char* path) {\n");
    code.push_str("#ifdef _WIN32\n");
    code.push_str("    return _access(path, 0) == 0 ? 1 : 0;\n");
    code.push_str("#else\n");
    code.push_str("    return access(path, F_OK) == 0 ? 1 : 0;\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");
    
    // IsDir - Check if path is directory
    code.push_str("// io.IsDir - Check if path is directory\n");
    code.push_str("int io_IsDir(const char* path) {\n");
    code.push_str("    struct stat st;\n");
    code.push_str("    if (stat(path, &st) != 0) {\n");
    code.push_str("        return 0;\n");
    code.push_str("    }\n");
    code.push_str("    return S_ISDIR(st.st_mode) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // Stat - Get file information (returns formatted string: "size:1234,isdir:0,mtime:1234567890")
    code.push_str("// io.Stat - Get file information (returns formatted string)\n");
    code.push_str("char* io_Stat(const char* path) {\n");
    code.push_str("    static char result[256];\n");
    code.push_str("    struct stat st;\n");
    code.push_str("    if (stat(path, &st) != 0) {\n");
    code.push_str("        return \"\";\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    snprintf(result, sizeof(result), \"size:%ld,isdir:%d,mtime:%ld\", \n");
    code.push_str("             (long)st.st_size, S_ISDIR(st.st_mode) ? 1 : 0, (long)st.st_mtime);\n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    code
}
