// bufio - Buffered I/O library
// Provides buffered reading and writing for efficiency

pub fn generate_bufio_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("\n");
    
    // Buffer structure
    code.push_str("#define BUFIO_BUFFER_SIZE 4096\n");
    code.push_str("\n");
    code.push_str("typedef struct {\n");
    code.push_str("    FILE* file;\n");
    code.push_str("    char buffer[BUFIO_BUFFER_SIZE];\n");
    code.push_str("    int pos;\n");
    code.push_str("    int size;\n");
    code.push_str("    int is_writer;\n");
    code.push_str("} BufIO;\n\n");
    
    // Global buffer storage
    code.push_str("static BufIO buffers[16];\n");
    code.push_str("static int buffer_count = 0;\n\n");
    
    // Helper: Find or create buffer
    code.push_str("static int find_or_create_buffer(const char* source, int is_writer) {\n");
    code.push_str("    // Find existing buffer\n");
    code.push_str("    for (int i = 0; i < buffer_count; i++) {\n");
    code.push_str("        if (buffers[i].file != NULL) {\n");
    code.push_str("            // Check if same file (simplified)\n");
    code.push_str("            return i;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Create new buffer\n");
    code.push_str("    if (buffer_count >= 16) return -1;\n");
    code.push_str("    \n");
    code.push_str("    FILE* file = fopen(source, is_writer ? \"w\" : \"r\");\n");
    code.push_str("    if (file == NULL) return -1;\n");
    code.push_str("    \n");
    code.push_str("    buffers[buffer_count].file = file;\n");
    code.push_str("    buffers[buffer_count].pos = 0;\n");
    code.push_str("    buffers[buffer_count].size = 0;\n");
    code.push_str("    buffers[buffer_count].is_writer = is_writer;\n");
    code.push_str("    \n");
    code.push_str("    return buffer_count++;\n");
    code.push_str("}\n\n");
    
    // bufio.NewReader - Create buffered reader
    code.push_str("// bufio.NewReader - Create buffered reader\n");
    code.push_str("int bufio_NewReader(const char* source) {\n");
    code.push_str("    return find_or_create_buffer(source, 0);\n");
    code.push_str("}\n\n");
    
    // bufio.ReadLine - Read line
    code.push_str("// bufio.ReadLine - Read line\n");
    code.push_str("char* bufio_ReadLine(int reader) {\n");
    code.push_str("    static char result[1024];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (reader < 0 || reader >= buffer_count) return result;\n");
    code.push_str("    if (buffers[reader].file == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    if (fgets(result, sizeof(result), buffers[reader].file) == NULL) {\n");
    code.push_str("        result[0] = '\\0';\n");
    code.push_str("        return result;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Remove newline\n");
    code.push_str("    int len = strlen(result);\n");
    code.push_str("    if (len > 0 && result[len-1] == '\\n') {\n");
    code.push_str("        result[len-1] = '\\0';\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // bufio.ReadBytes - Read until delimiter
    code.push_str("// bufio.ReadBytes - Read until delimiter\n");
    code.push_str("char* bufio_ReadBytes(int reader, int delim) {\n");
    code.push_str("    static char result[1024];\n");
    code.push_str("    result[0] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    if (reader < 0 || reader >= buffer_count) return result;\n");
    code.push_str("    if (buffers[reader].file == NULL) return result;\n");
    code.push_str("    \n");
    code.push_str("    int pos = 0;\n");
    code.push_str("    int ch;\n");
    code.push_str("    \n");
    code.push_str("    while ((ch = fgetc(buffers[reader].file)) != EOF && pos < sizeof(result) - 1) {\n");
    code.push_str("        if (ch == delim) {\n");
    code.push_str("            break;\n");
    code.push_str("        }\n");
    code.push_str("        result[pos++] = (char)ch;\n");
    code.push_str("    }\n");
    code.push_str("    result[pos] = '\\0';\n");
    code.push_str("    \n");
    code.push_str("    return result;\n");
    code.push_str("}\n\n");
    
    // bufio.NewWriter - Create buffered writer
    code.push_str("// bufio.NewWriter - Create buffered writer\n");
    code.push_str("int bufio_NewWriter(const char* dest) {\n");
    code.push_str("    return find_or_create_buffer(dest, 1);\n");
    code.push_str("}\n\n");
    
    // bufio.Write - Write data
    code.push_str("// bufio.Write - Write data\n");
    code.push_str("int bufio_Write(int writer, const char* data) {\n");
    code.push_str("    if (writer < 0 || writer >= buffer_count) return 0;\n");
    code.push_str("    if (buffers[writer].file == NULL) return 0;\n");
    code.push_str("    if (!buffers[writer].is_writer) return 0;\n");
    code.push_str("    \n");
    code.push_str("    int len = strlen(data);\n");
    code.push_str("    int written = fwrite(data, 1, len, buffers[writer].file);\n");
    code.push_str("    return written;\n");
    code.push_str("}\n\n");
    
    // bufio.Flush - Flush buffer
    code.push_str("// bufio.Flush - Flush buffer\n");
    code.push_str("void bufio_Flush(int writer) {\n");
    code.push_str("    if (writer < 0 || writer >= buffer_count) return;\n");
    code.push_str("    if (buffers[writer].file == NULL) return;\n");
    code.push_str("    if (!buffers[writer].is_writer) return;\n");
    code.push_str("    \n");
    code.push_str("    fflush(buffers[writer].file);\n");
    code.push_str("}\n\n");
    
    // bufio.Close - Close reader/writer
    code.push_str("// bufio.Close - Close reader/writer\n");
    code.push_str("void bufio_Close(int handle) {\n");
    code.push_str("    if (handle < 0 || handle >= buffer_count) return;\n");
    code.push_str("    if (buffers[handle].file == NULL) return;\n");
    code.push_str("    \n");
    code.push_str("    if (buffers[handle].is_writer) {\n");
    code.push_str("        fflush(buffers[handle].file);\n");
    code.push_str("    }\n");
    code.push_str("    fclose(buffers[handle].file);\n");
    code.push_str("    buffers[handle].file = NULL;\n");
    code.push_str("}\n\n");
    
    code
}
