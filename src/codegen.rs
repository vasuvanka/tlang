use crate::ast::*;
use std::collections::HashMap;

pub struct CodeGenerator {
    output: String,
    indent_level: usize,
    import_aliases: HashMap<String, String>, // Map of alias -> package path
    current_function_return_type: Option<crate::ast::Type>, // Track current function's return type for tuple literal generation
    interfaces: HashMap<String, Vec<(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)>>, // Track interfaces: name -> methods
    struct_methods: HashMap<String, Vec<(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)>>, // Track struct methods: StructName_MethodName -> signature
    source_filename: Option<String>, // Source filename for debug symbols (#line directives)
    current_line: usize, // Track current line number for debug symbols
    variable_types: HashMap<String, crate::ast::Type>, // Track variable types for pointer detection
    struct_definitions: HashMap<String, Vec<(String, crate::ast::Type)>>, // Track struct definitions: struct_name -> fields
}

impl CodeGenerator {
    pub fn new() -> Self {
        CodeGenerator {
            output: String::new(),
            indent_level: 0,
            import_aliases: HashMap::new(),
            current_function_return_type: None,
            interfaces: HashMap::new(),
            struct_methods: HashMap::new(),
            source_filename: None,
            current_line: 1,
            variable_types: HashMap::new(),
            struct_definitions: HashMap::new(),
        }
    }
    
    /// Set source filename for debug symbol generation
    pub fn set_source_filename(&mut self, filename: String) {
        self.source_filename = Some(filename);
    }
    
    /// Emit #line directive for source mapping (debug symbols)
    fn emit_line_directive(&mut self, line: usize) {
        if let Some(ref filename) = self.source_filename {
            // Escape backslashes and quotes in filename for C string
            let escaped_filename = filename.replace('\\', "\\\\").replace('"', "\\\"");
            self.write(&format!("#line {} \"{}\"\n", line, escaped_filename));
            self.current_line = line;
        }
    }
    
    fn indent(&mut self) {
        self.indent_level += 1;
    }
    
    fn dedent(&mut self) {
        if self.indent_level > 0 {
            self.indent_level -= 1;
        }
    }
    
    fn write(&mut self, s: &str) {
        self.output.push_str(s);
    }
    
    fn writeln(&mut self, s: &str) {
        for _ in 0..self.indent_level {
            self.write("    ");
        }
        self.write(s);
        self.write("\n");
    }
    
    pub fn generate(&mut self, program: &Program) -> String {
        self.generate_with_packages(program, &[])
    }
    
    pub fn generate_with_packages(&mut self, program: &Program, imported_packages: &[crate::package::PackageInfo]) -> String {
        // Emit initial #line directive if source filename is set
        if self.source_filename.is_some() {
            self.emit_line_directive(1);
        }
        // Build import alias map for function call resolution
        self.import_aliases.clear();
        for import_info in &program.imports {
            let package_path = import_info.path.clone();
            // Extract package name from path (e.g., "./utils" -> "utils", "fmt" -> "fmt")
            let package_name = package_path.split('/').last()
                .or_else(|| package_path.split('\\').last())
                .unwrap_or(&package_path)
                .trim_start_matches('.')
                .to_string();
            
            // Use alias if provided, otherwise use package name
            let alias = import_info.alias.as_ref()
                .map(|a| a.clone())
                .unwrap_or_else(|| package_name.clone());
            
            // Map alias to package name for function call resolution
            self.import_aliases.insert(alias, package_name);
        }
        // Generate C code as target (can be changed to assembly or LLVM IR later)
        self.write("#ifdef _WIN32\n");
        self.write("#include <winsock2.h>\n");
        self.write("#include <windows.h>\n");
        self.write("#endif\n");
        self.write("#include <stdio.h>\n");
        self.write("#include <stdlib.h>\n");
        self.write("#include <math.h>\n");
        self.write("#include <string.h>\n");
        self.write("\n");
        
        // Write import statements as comments
        if !program.imports.is_empty() {
            for import_info in &program.imports {
                if let Some(alias) = &import_info.alias {
                    self.write(&format!("// import {} as {}\n", import_info.path, alias));
                } else {
                    self.write(&format!("// import {}\n", import_info.path));
                }
            }
            self.write("\n");
        }
        
        // Generate forward declarations for types used by runtime functions
        self.generate_forward_declarations();
        
        // Generate slice runtime (before stdlib/runtime functions that use it)
        self.generate_slice_runtime();
        
        // Generate map runtime (before stdlib/runtime functions that use it)
        self.generate_map_runtime();

        // Generate runtime functions
        self.generate_runtime();
        
        // Generate functions and variables from imported packages (skip built-in libraries)
        // Build a map of package paths to aliases for proper function name resolution
        let mut package_to_alias: HashMap<String, String> = HashMap::new();
        for import_info in &program.imports {
            let alias = import_info.alias.as_ref()
                .map(|a| a.clone())
                .unwrap_or_else(|| {
                    // Extract package name from path
                    import_info.path.split('/').last()
                        .or_else(|| import_info.path.split('\\').last())
                        .unwrap_or(&import_info.path)
                        .trim_start_matches('.')
                        .to_string()
                });
            package_to_alias.insert(import_info.path.clone(), alias);
        }
        
        for pkg in imported_packages {
            // Skip built-in libraries - their functions are already in stdlib
            if pkg.program.statements.is_empty() && pkg.functions.is_empty() {
                // This is a built-in library placeholder, skip it
                continue;
            }
            
            // Find the alias for this package
            let path_str = pkg.path.to_string_lossy().to_string();
            let package_alias = package_to_alias.get(&pkg.name)
                .or_else(|| {
                    // Try to find by path
                    path_str.split('/').last()
                        .or_else(|| path_str.split('\\').last())
                        .and_then(|name| package_to_alias.get(name))
                })
                .map(|a| a.clone())
                .unwrap_or_else(|| pkg.name.clone());
            
            self.write(&format!("// Functions and variables from package '{}'", pkg.name));
            if package_alias != pkg.name {
                self.write(&format!(" (aliased as '{}')", package_alias));
            }
            self.write("\n");
            
            // Generate only exported functions (uppercase first letter)
            for stmt in &pkg.program.statements {
                if let Stmt::Function { name, .. } = stmt {
                    // Only generate exported functions (Go-style: uppercase first letter)
                    if crate::package::PackageResolver::is_exported(name) {
                        self.generate_statement(stmt);
                    }
                }
            }
            self.write("\n");
        }
        
        // Separate functions and top-level statements
        let mut functions = Vec::new();
        let mut top_level_stmts = Vec::new();
        let mut has_prarambham = false;
        
        for stmt in &program.statements {
            match stmt {
                Stmt::Function { name, .. } if name == "prarambham" => {
                    has_prarambham = true;
                    functions.push(stmt);
                }
                Stmt::Function { .. } => {
                    functions.push(stmt);
                }
                _ => {
                    top_level_stmts.push(stmt);
                }
            }
        }
        
        // Generate all functions first
        for stmt in &functions {
            self.generate_statement(stmt);
        }
        
        // After all structs and functions are generated, check interface satisfaction
        // and generate vtable initialization code
        self.generate_interface_vtables(&program.statements);
        
        // Generate main function (C entry point) if adhi exists, otherwise create one with top-level statements
        if !has_prarambham && !top_level_stmts.is_empty() {
            self.writeln("int main(int argc, char** argv) {");
            self.indent();
            self.writeln("args_Init(argc, argv);");
            
            for stmt in &top_level_stmts {
                self.generate_statement(stmt);
            }
            
            self.dedent();
            self.writeln("    return 0;");
            self.writeln("}");
        } else if has_prarambham {
            // If prarambham function exists, generate a C main() that calls it
            self.writeln("int main(int argc, char** argv) {");
            self.indent();
            self.writeln("args_Init(argc, argv);");
            self.writeln("prarambham();");
            self.dedent();
            self.writeln("    return 0;");
            self.writeln("}");
        }
        
        self.output.clone()
    }
    
    fn generate_forward_declarations(&mut self) {
        // Forward declarations for types used by runtime functions
        self.write("// Forward declarations for runtime types\n");
        self.write("typedef struct Slice Slice;\n");
        self.write("typedef struct MapEntry MapEntry;\n");
        self.write("typedef struct Map Map;\n");
        self.write("typedef struct MapIterator MapIterator;\n");
        self.write("\n");
        
        // Forward declarations for runtime functions that may be used before definition
        self.write("// Forward declarations for runtime functions\n");
        self.write("Slice* slice_create(void* data, int len, int cap);\n");
        self.write("Map* map_create(int key_type, int value_type);\n");
        self.write("int map_len(Map* m);\n");
        self.write("void* map_get(Map* m, void* key);\n");
        self.write("void map_set(Map* m, void* key, void* value);\n");
        self.write("MapIterator* map_iter(Map* m);\n");
        self.write("int map_next(MapIterator* iter, void** key_ptr, void** value_ptr);\n");
        self.write("void map_iter_free(MapIterator* iter);\n");
        self.write("char* json_UnmarshalString(const char* json);\n");
        self.write("Slice* json_UnmarshalArray(const char* json, const char* elem_type);\n");
        self.write("Map* json_UnmarshalMap(const char* json, int key_type, int value_type);\n");
        self.write("char* http_PostWithHeaders(const char* url, const char* data, const char* headers);\n");
        self.write("char* http_GetWithRedirects(const char* url, int max_redirects);\n");
        self.write("int net_Init(void);\n");
        self.write("void net_Cleanup(void);\n");
        self.write("int net_Dial(const char* host, int port);\n");
        self.write("int net_Send(int sockfd, const char* data, int len);\n");
        self.write("int net_Recv(int sockfd, char* buf, int len);\n");
        self.write("void net_Close(int sockfd);\n");
        self.write("int net_Listen(int port);\n");
        self.write("int net_Accept(int listenfd);\n");
        self.write("\n");
        
        // Forward declarations for POSIX functions that may not be available on Windows
        self.write("// Forward declarations for POSIX functions (Windows compatibility)\n");
        self.write("#ifdef _WIN32\n");
        self.write("// Windows: setenv is not available, use _putenv instead\n");
        self.write("int _putenv(const char* envstring);\n");
        self.write("#else\n");
        self.write("// POSIX: forward declare setenv\n");
        self.write("int setenv(const char* name, const char* value, int overwrite);\n");
        self.write("char* strptime(const char* s, const char* format, struct tm* tm);\n");
        self.write("#endif\n");
        self.write("\n");
    }
    
    fn generate_slice_runtime(&mut self) {
        // Slice structure: pointer, length, capacity
        self.write("// Slice structure for dynamic arrays\n");
        self.write("struct Slice {\n");
        self.write("    void* data;\n");
        self.write("    int len;\n");
        self.write("    int cap;\n");
        self.write("};\n\n");
        
        // Slice helper functions
        self.write("// Slice helper functions\n");
        self.write("int slice_len(Slice* s) { return s ? s->len : 0; }\n");
        self.write("int slice_cap(Slice* s) { return s ? s->cap : 0; }\n");
        self.write("void* slice_data(Slice* s) { return s ? s->data : NULL; }\n\n");
        
        // Slice creation from array literal
        self.write("// Create slice from array literal\n");
        self.write("Slice* slice_create(void* data, int len, int cap) {\n");
        self.write("    Slice* s = (Slice*)malloc(sizeof(Slice));\n");
        self.write("    if (!s) return NULL;\n");
        self.write("    s->data = data;\n");
        self.write("    s->len = len;\n");
        self.write("    s->cap = cap;\n");
        self.write("    return s;\n");
        self.write("}\n\n");
        
        // Slice append (simplified - grows by doubling)
        self.write("// Append to slice (simplified implementation)\n");
        self.write("Slice* slice_append(Slice* s, void* elem, size_t elem_size) {\n");
        self.write("    if (!s) {\n");
        self.write("        s = slice_create(malloc(elem_size), 0, 1);\n");
        self.write("        if (!s) return NULL;\n");
        self.write("    }\n");
        self.write("    if (s->len >= s->cap) {\n");
        self.write("        int new_cap = s->cap == 0 ? 1 : s->cap * 2;\n");
        self.write("        s->data = realloc(s->data, new_cap * elem_size);\n");
        self.write("        if (!s->data) return NULL;\n");
        self.write("        s->cap = new_cap;\n");
        self.write("    }\n");
        self.write("    memcpy((char*)s->data + s->len * elem_size, elem, elem_size);\n");
        self.write("    s->len++;\n");
        self.write("    return s;\n");
        self.write("}\n\n");
        
        // Slice from array/slice expression
        self.write("// Create slice from array/slice expression [start:end]\n");
        self.write("Slice* slice_create_slice(Slice* s, int start, int end) {\n");
        self.write("    if (!s || start < 0 || end < start) return NULL;\n");
        self.write("    if (end > s->len) end = s->len;\n");
        self.write("    Slice* new_slice = (Slice*)malloc(sizeof(Slice));\n");
        self.write("    if (!new_slice) return NULL;\n");
        self.write("    new_slice->data = (char*)s->data + start * sizeof(int); // Simplified - assumes int\n");
        self.write("    new_slice->len = end - start;\n");
        self.write("    new_slice->cap = s->cap - start;\n");
        self.write("    return new_slice;\n");
        self.write("}\n\n");
        
        // Helper to create slice from array literal
        self.write("// Create slice from array literal\n");
        self.write("Slice* slice_from_literal(void* arr, int len, size_t elem_size) {\n");
        self.write("    void* data = malloc(len * elem_size);\n");
        self.write("    if (!data) return NULL;\n");
        self.write("    memcpy(data, arr, len * elem_size);\n");
        self.write("    return slice_create(data, len, len);\n");
        self.write("}\n\n");
    }
    
    #[allow(dead_code)]
    fn generate_error_propagation_runtime(&mut self) {
        // Error propagation helper
        self.write("// Error propagation helper\n");
        self.write("// For expr? - checks error and returns if not NULL\n");
        self.write("static inline char* _error_propagate(char* err) {\n");
        self.write("    if (err != NULL) return err;\n");
        self.write("    return NULL;\n");
        self.write("}\n\n");
        
        // For tuple returns with error: (value, error)
        self.write("// Error propagation for tuple returns\n");
        self.write("// Checks error field and returns error if not NULL\n");
        self.write("// Usage: For functions returning (value, error), extract error and check\n");
        self.write("// This is a generic helper - specific tuple types will have their own helpers\n");
        self.write("\n");
    }
    
    fn generate_map_runtime(&mut self) {
        // Map structure: key-value pairs with hash table
        self.write("// Map structure for key-value storage\n");
        self.write("struct MapEntry {\n");
        self.write("    void* key;\n");
        self.write("    void* value;\n");
        self.write("    struct MapEntry* next;  // For chaining in hash table\n");
        self.write("};\n\n");
        
        self.write("struct Map {\n");
        self.write("    MapEntry** buckets;\n");
        self.write("    int bucket_count;\n");
        self.write("    int size;\n");
        self.write("    int key_type;  // 0=string, 1=int, 2=float\n");
        self.write("    int value_type; // 0=int, 1=float, 2=string, 3=bool\n");
        self.write("    size_t key_size;\n");
        self.write("    size_t value_size;\n");
        self.write("};\n\n");
        
        // Map helper functions
        self.write("// Map helper functions\n");
        self.write("Map* map_create(int key_type, int value_type) {\n");
        self.write("    Map* m = (Map*)malloc(sizeof(Map));\n");
        self.write("    if (!m) return NULL;\n");
        self.write("    m->bucket_count = 16;\n");
        self.write("    m->size = 0;\n");
        self.write("    m->key_type = key_type;\n");
        self.write("    m->value_type = value_type;\n");
        self.write("    m->buckets = (MapEntry**)calloc(m->bucket_count, sizeof(MapEntry*));\n");
        self.write("    m->key_size = (key_type == 0) ? sizeof(char*) : ((key_type == 1) ? sizeof(int) : sizeof(double));\n");
        self.write("    m->value_size = (value_type == 0) ? sizeof(int) : ((value_type == 1) ? sizeof(double) : ((value_type == 2) ? sizeof(char*) : sizeof(int)));\n");
        self.write("    return m;\n");
        self.write("}\n\n");
        
        self.write("int map_len(Map* m) { return m ? m->size : 0; }\n\n");
        
        // Simple hash function for strings
        self.write("static unsigned int map_hash_string(const char* s) {\n");
        self.write("    unsigned int hash = 5381;\n");
        self.write("    int c;\n");
        self.write("    while ((c = *s++)) hash = ((hash << 5) + hash) + c;\n");
        self.write("    return hash;\n");
        self.write("}\n\n");
        
        // Map get function
        self.write("void* map_get(Map* m, void* key) {\n");
        self.write("    if (!m || !key) return NULL;\n");
        self.write("    unsigned int hash;\n");
        self.write("    if (m->key_type == 0) {  // string key\n");
        self.write("        hash = map_hash_string(*(char**)key) % m->bucket_count;\n");
        self.write("    } else if (m->key_type == 1) {  // int key\n");
        self.write("        hash = (*(int*)key) % m->bucket_count;\n");
        self.write("    } else {  // float key\n");
        self.write("        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;\n");
        self.write("    }\n");
        self.write("    MapEntry* entry = m->buckets[hash];\n");
        self.write("    while (entry) {\n");
        self.write("        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {\n");
        self.write("            return entry->value;\n");
        self.write("        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {\n");
        self.write("            return entry->value;\n");
        self.write("        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {\n");
        self.write("            return entry->value;\n");
        self.write("        }\n");
        self.write("        entry = entry->next;\n");
        self.write("    }\n");
        self.write("    return NULL;\n");
        self.write("}\n\n");
        
        // Map set function
        self.write("void map_set(Map* m, void* key, void* value) {\n");
        self.write("    if (!m || !key) return;\n");
        self.write("    unsigned int hash;\n");
        self.write("    if (m->key_type == 0) {  // string key\n");
        self.write("        hash = map_hash_string(*(char**)key) % m->bucket_count;\n");
        self.write("    } else if (m->key_type == 1) {  // int key\n");
        self.write("        hash = (*(int*)key) % m->bucket_count;\n");
        self.write("    } else {  // float key\n");
        self.write("        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;\n");
        self.write("    }\n");
        self.write("    MapEntry* entry = m->buckets[hash];\n");
        self.write("    while (entry) {\n");
        self.write("        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {\n");
        self.write("            memcpy(entry->value, value, m->value_size);\n");
        self.write("            return;\n");
        self.write("        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {\n");
        self.write("            memcpy(entry->value, value, m->value_size);\n");
        self.write("            return;\n");
        self.write("        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {\n");
        self.write("            memcpy(entry->value, value, m->value_size);\n");
        self.write("            return;\n");
        self.write("        }\n");
        self.write("        entry = entry->next;\n");
        self.write("    }\n");
        self.write("    // Create new entry\n");
        self.write("    MapEntry* new_entry = (MapEntry*)malloc(sizeof(MapEntry));\n");
        self.write("    new_entry->key = malloc(m->key_size);\n");
        self.write("    new_entry->value = malloc(m->value_size);\n");
        self.write("    memcpy(new_entry->key, key, m->key_size);\n");
        self.write("    memcpy(new_entry->value, value, m->value_size);\n");
        self.write("    new_entry->next = m->buckets[hash];\n");
        self.write("    m->buckets[hash] = new_entry;\n");
        self.write("    m->size++;\n");
        self.write("}\n\n");
        
        // Map delete function
        self.write("// Delete key from map\n");
        self.write("void map_delete(Map* m, void* key) {\n");
        self.write("    if (!m || !key) return;\n");
        self.write("    unsigned int hash;\n");
        self.write("    if (m->key_type == 0) {  // string key\n");
        self.write("        hash = map_hash_string(*(char**)key) % m->bucket_count;\n");
        self.write("    } else if (m->key_type == 1) {  // int key\n");
        self.write("        hash = (*(int*)key) % m->bucket_count;\n");
        self.write("    } else {  // float key\n");
        self.write("        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;\n");
        self.write("    }\n");
        self.write("    MapEntry* entry = m->buckets[hash];\n");
        self.write("    MapEntry* prev = NULL;\n");
        self.write("    while (entry) {\n");
        self.write("        int match = 0;\n");
        self.write("        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {\n");
        self.write("            match = 1;\n");
        self.write("        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {\n");
        self.write("            match = 1;\n");
        self.write("        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {\n");
        self.write("            match = 1;\n");
        self.write("        }\n");
        self.write("        if (match) {\n");
        self.write("            if (prev) {\n");
        self.write("                prev->next = entry->next;\n");
        self.write("            } else {\n");
        self.write("                m->buckets[hash] = entry->next;\n");
        self.write("            }\n");
        self.write("            free(entry->key);\n");
        self.write("            free(entry->value);\n");
        self.write("            free(entry);\n");
        self.write("            m->size--;\n");
        self.write("            return;\n");
        self.write("        }\n");
        self.write("        prev = entry;\n");
        self.write("        entry = entry->next;\n");
        self.write("    }\n");
        self.write("}\n\n");
        
        // Map iteration helpers
        self.write("// Map iteration helpers\n");
        self.write("struct MapIterator {\n");
        self.write("    Map* map;\n");
        self.write("    int bucket_index;\n");
        self.write("    MapEntry* current_entry;\n");
        self.write("};\n\n");
        
        self.write("// Initialize map iterator\n");
        self.write("MapIterator* map_iter(Map* m) {\n");
        self.write("    if (!m) return NULL;\n");
        self.write("    MapIterator* iter = (MapIterator*)malloc(sizeof(MapIterator));\n");
        self.write("    if (!iter) return NULL;\n");
        self.write("    iter->map = m;\n");
        self.write("    iter->bucket_index = 0;\n");
        self.write("    iter->current_entry = NULL;\n");
        self.write("    // Find first entry\n");
        self.write("    for (int i = 0; i < m->bucket_count; i++) {\n");
        self.write("        if (m->buckets[i]) {\n");
        self.write("            iter->bucket_index = i;\n");
        self.write("            iter->current_entry = m->buckets[i];\n");
        self.write("            break;\n");
        self.write("        }\n");
        self.write("    }\n");
        self.write("    return iter;\n");
        self.write("}\n\n");
        
        self.write("// Get next key-value pair from iterator\n");
        self.write("int map_next(MapIterator* iter, void** key, void** value) {\n");
        self.write("    if (!iter || !iter->map) return 0;\n");
        self.write("    if (!iter->current_entry) return 0;\n");
        self.write("    \n");
        self.write("    *key = iter->current_entry->key;\n");
        self.write("    *value = iter->current_entry->value;\n");
        self.write("    \n");
        self.write("    // Move to next entry\n");
        self.write("    if (iter->current_entry->next) {\n");
        self.write("        iter->current_entry = iter->current_entry->next;\n");
        self.write("    } else {\n");
        self.write("        // Move to next bucket\n");
        self.write("        iter->bucket_index++;\n");
        self.write("        iter->current_entry = NULL;\n");
        self.write("        for (int i = iter->bucket_index; i < iter->map->bucket_count; i++) {\n");
        self.write("            if (iter->map->buckets[i]) {\n");
        self.write("                iter->bucket_index = i;\n");
        self.write("                iter->current_entry = iter->map->buckets[i];\n");
        self.write("                break;\n");
        self.write("            }\n");
        self.write("        }\n");
        self.write("    }\n");
        self.write("    return 1;\n");
        self.write("}\n\n");
    }
    
    fn generate_runtime(&mut self) {
        // Generate standard library functions
        self.writeln("// ========== Standard Library ==========");
        self.write(&self.generate_stdlib());
    }
    
    fn generate_stdlib(&self) -> String {
        // Use the libs module to generate all standard library functions
        crate::libs::generate_all_libs()
    }
    
    #[allow(dead_code)]
    fn _old_generate_stdlib(&self) -> String {
        // Old hardcoded implementation - kept for reference
        let mut code = String::new();
        
        // fmt library
        code.push_str("// fmt library\n");
        code.push_str("void fmt_Printf(const char* format, ...) {\n");
        code.push_str("    va_list args;\n");
        code.push_str("    va_start(args, format);\n");
        code.push_str("    vprintf(format, args);\n");
        code.push_str("    va_end(args);\n");
        code.push_str("}\n\n");
        
        code.push_str("char* fmt_Sprintf(const char* format, ...) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    va_list args;\n");
        code.push_str("    va_start(args, format);\n");
        code.push_str("    vsnprintf(buffer, sizeof(buffer), format, args);\n");
        code.push_str("    va_end(args);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        // strings library
        code.push_str("// strings library\n");
        code.push_str("int strings_Contains(const char* s, const char* substr) {\n");
        code.push_str("    return strstr(s, substr) != NULL ? 1 : 0;\n");
        code.push_str("}\n\n");
        
        code.push_str("int strings_HasPrefix(const char* s, const char* prefix) {\n");
        code.push_str("    size_t len = strlen(prefix);\n");
        code.push_str("    return strncmp(s, prefix, len) == 0 ? 1 : 0;\n");
        code.push_str("}\n\n");
        
        code.push_str("int strings_HasSuffix(const char* s, const char* suffix) {\n");
        code.push_str("    size_t len_s = strlen(s);\n");
        code.push_str("    size_t len_suffix = strlen(suffix);\n");
        code.push_str("    if (len_suffix > len_s) return 0;\n");
        code.push_str("    return strcmp(s + len_s - len_suffix, suffix) == 0 ? 1 : 0;\n");
        code.push_str("}\n\n");
        
        code.push_str("int strings_Index(const char* s, const char* substr) {\n");
        code.push_str("    char* pos = strstr(s, substr);\n");
        code.push_str("    return pos ? (int)(pos - s) : -1;\n");
        code.push_str("}\n\n");
        
        code.push_str("char* strings_ToUpper(const char* s) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    strncpy(buffer, s, sizeof(buffer) - 1);\n");
        code.push_str("    buffer[sizeof(buffer) - 1] = '\\0';\n");
        code.push_str("    for (int i = 0; buffer[i]; i++) {\n");
        code.push_str("        buffer[i] = toupper(buffer[i]);\n");
        code.push_str("    }\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        code.push_str("char* strings_ToLower(const char* s) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    strncpy(buffer, s, sizeof(buffer) - 1);\n");
        code.push_str("    buffer[sizeof(buffer) - 1] = '\\0';\n");
        code.push_str("    for (int i = 0; buffer[i]; i++) {\n");
        code.push_str("        buffer[i] = tolower(buffer[i]);\n");
        code.push_str("    }\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        code.push_str("char* strings_TrimSpace(const char* s) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    int start = 0;\n");
        code.push_str("    int end = strlen(s) - 1;\n");
        code.push_str("    while (isspace(s[start]) && start <= end) start++;\n");
        code.push_str("    while (isspace(s[end]) && end >= start) end--;\n");
        code.push_str("    int len = end - start + 1;\n");
        code.push_str("    if (len < 0) len = 0;\n");
        code.push_str("    strncpy(buffer, s + start, len);\n");
        code.push_str("    buffer[len] = '\\0';\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        // math library
        code.push_str("// math library\n");
        code.push_str("double math_Pi() { return 3.14159265358979323846; }\n");
        code.push_str("double math_E() { return 2.71828182845904523536; }\n");
        code.push_str("double math_Sqrt(double x) { return sqrt(x); }\n");
        code.push_str("double math_Pow(double x, double y) { return pow(x, y); }\n");
        code.push_str("double math_Abs(double x) { return fabs(x); }\n");
        code.push_str("double math_Max(double x, double y) { return x > y ? x : y; }\n");
        code.push_str("double math_Min(double x, double y) { return x < y ? x : y; }\n");
        code.push_str("double math_Sin(double x) { return sin(x); }\n");
        code.push_str("double math_Cos(double x) { return cos(x); }\n");
        code.push_str("double math_Tan(double x) { return tan(x); }\n");
        code.push_str("double math_Asin(double x) { return asin(x); }\n");
        code.push_str("double math_Acos(double x) { return acos(x); }\n");
        code.push_str("double math_Atan(double x) { return atan(x); }\n");
        code.push_str("double math_Exp(double x) { return exp(x); }\n");
        code.push_str("double math_Log(double x) { return log(x); }\n");
        code.push_str("double math_Log10(double x) { return log10(x); }\n");
        code.push_str("double math_Ceil(double x) { return ceil(x); }\n");
        code.push_str("double math_Floor(double x) { return floor(x); }\n");
        code.push_str("double math_Round(double x) { return round(x); }\n");
        code.push_str("double math_Trunc(double x) { return trunc(x); }\n\n");
        
        // strconv library
        code.push_str("// strconv library\n");
        code.push_str("int strconv_Atoi(const char* s) { return atoi(s); }\n");
        code.push_str("char* strconv_Itoa(int i) {\n");
        code.push_str("    static char buffer[32];\n");
        code.push_str("    snprintf(buffer, sizeof(buffer), \"%d\", i);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        code.push_str("double strconv_ParseFloat(const char* s) { return atof(s); }\n");
        code.push_str("char* strconv_FormatFloat(double f, int prec) {\n");
        code.push_str("    static char buffer[64];\n");
        code.push_str("    char format[16];\n");
        code.push_str("    snprintf(format, sizeof(format), \"%%.%df\", prec);\n");
        code.push_str("    snprintf(buffer, sizeof(buffer), format, f);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        code.push_str("int strconv_ParseBool(const char* s) {\n");
        code.push_str("    if (strcmp(s, \"true\") == 0 || strcmp(s, \"1\") == 0) return 1;\n");
        code.push_str("    if (strcmp(s, \"false\") == 0 || strcmp(s, \"0\") == 0) return 0;\n");
        code.push_str("    return -1; // error\n");
        code.push_str("}\n\n");
        
        code.push_str("char* strconv_FormatBool(int b) {\n");
        code.push_str("    return b ? \"true\" : \"false\";\n");
        code.push_str("}\n\n");
        
        // os library
        code.push_str("// os library\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("#include <windows.h>\n");
        code.push_str("#else\n");
        code.push_str("#include <unistd.h>\n");
        code.push_str("#endif\n");
        code.push_str("char* os_Getenv(const char* key) {\n");
        code.push_str("    char* value = getenv(key);\n");
        code.push_str("    return value ? value : \"\";\n");
        code.push_str("}\n\n");
        code.push_str("int os_Setenv(const char* key, const char* value) {\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("    return SetEnvironmentVariableA(key, value) ? 0 : -1;\n");
        code.push_str("#else\n");
        code.push_str("    return setenv(key, value, 1);\n");
        code.push_str("#endif\n");
        code.push_str("}\n\n");
        code.push_str("void os_Exit(int code) {\n");
        code.push_str("    exit(code);\n");
        code.push_str("}\n\n");
        code.push_str("char* os_Getwd() {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("    if (GetCurrentDirectoryA(sizeof(buffer), buffer) != 0) {\n");
        code.push_str("        return buffer;\n");
        code.push_str("    }\n");
        code.push_str("#else\n");
        code.push_str("    if (getcwd(buffer, sizeof(buffer)) != NULL) {\n");
        code.push_str("        return buffer;\n");
        code.push_str("    }\n");
        code.push_str("#endif\n");
        code.push_str("    return \"\";\n");
        code.push_str("}\n\n");
        code.push_str("int os_Chdir(const char* path) {\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("    return SetCurrentDirectoryA(path) ? 0 : -1;\n");
        code.push_str("#else\n");
        code.push_str("    return chdir(path);\n");
        code.push_str("#endif\n");
        code.push_str("}\n\n");
        
        // time library
        code.push_str("// time library\n");
        code.push_str("#include <time.h>\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("#include <windows.h>\n");
        code.push_str("#else\n");
        code.push_str("#include <unistd.h>\n");
        code.push_str("#endif\n");
        code.push_str("long time_Now() {\n");
        code.push_str("    return (long)time(NULL);\n");
        code.push_str("}\n\n");
        code.push_str("void time_Sleep(int seconds) {\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("    Sleep(seconds * 1000);\n");
        code.push_str("#else\n");
        code.push_str("    sleep(seconds);\n");
        code.push_str("#endif\n");
        code.push_str("}\n\n");
        code.push_str("void time_SleepMilliseconds(int ms) {\n");
        code.push_str("#ifdef _WIN32\n");
        code.push_str("    Sleep(ms);\n");
        code.push_str("#else\n");
        code.push_str("    usleep(ms * 1000);\n");
        code.push_str("#endif\n");
        code.push_str("}\n\n");
        code.push_str("char* time_Format(long timestamp, const char* format) {\n");
        code.push_str("    static char buffer[128];\n");
        code.push_str("    struct tm* timeinfo;\n");
        code.push_str("    time_t t = (time_t)timestamp;\n");
        code.push_str("    timeinfo = localtime(&t);\n");
        code.push_str("    strftime(buffer, sizeof(buffer), format, timeinfo);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        code.push_str("long time_Parse(const char* timeStr, const char* format) {\n");
        code.push_str("    struct tm tm = {0};\n");
        code.push_str("    if (strptime(timeStr, format, &tm) != NULL) {\n");
        code.push_str("        return (long)mktime(&tm);\n");
        code.push_str("    }\n");
        code.push_str("    return -1; // error\n");
        code.push_str("}\n\n");
        
        // bytes library
        code.push_str("// bytes library\n");
        code.push_str("int bytes_Contains(const char* b, int len, const char* sub, int sublen) {\n");
        code.push_str("    if (sublen == 0) return 1;\n");
        code.push_str("    if (sublen > len) return 0;\n");
        code.push_str("    for (int i = 0; i <= len - sublen; i++) {\n");
        code.push_str("        if (memcmp(b + i, sub, sublen) == 0) {\n");
        code.push_str("            return 1;\n");
        code.push_str("        }\n");
        code.push_str("    }\n");
        code.push_str("    return 0;\n");
        code.push_str("}\n\n");
        code.push_str("int bytes_Index(const char* b, int len, const char* sub, int sublen) {\n");
        code.push_str("    if (sublen == 0) return 0;\n");
        code.push_str("    if (sublen > len) return -1;\n");
        code.push_str("    for (int i = 0; i <= len - sublen; i++) {\n");
        code.push_str("        if (memcmp(b + i, sub, sublen) == 0) {\n");
        code.push_str("            return i;\n");
        code.push_str("        }\n");
        code.push_str("    }\n");
        code.push_str("    return -1;\n");
        code.push_str("}\n\n");
        code.push_str("int bytes_Equal(const char* a, int lenA, const char* b, int lenB) {\n");
        code.push_str("    if (lenA != lenB) return 0;\n");
        code.push_str("    return memcmp(a, b, lenA) == 0 ? 1 : 0;\n");
        code.push_str("}\n\n");
        
        // sort library
        code.push_str("// sort library\n");
        code.push_str("int int_compare(const void* a, const void* b) {\n");
        code.push_str("    int ia = *(const int*)a;\n");
        code.push_str("    int ib = *(const int*)b;\n");
        code.push_str("    return (ia > ib) - (ia < ib);\n");
        code.push_str("}\n\n");
        code.push_str("int float_compare(const void* a, const void* b) {\n");
        code.push_str("    double fa = *(const double*)a;\n");
        code.push_str("    double fb = *(const double*)b;\n");
        code.push_str("    return (fa > fb) - (fa < fb);\n");
        code.push_str("}\n\n");
        code.push_str("int string_compare(const void* a, const void* b) {\n");
        code.push_str("    const char** sa = (const char**)a;\n");
        code.push_str("    const char** sb = (const char**)b;\n");
        code.push_str("    return strcmp(*sa, *sb);\n");
        code.push_str("}\n\n");
        code.push_str("void sort_Ints(int* arr, int len) {\n");
        code.push_str("    qsort(arr, len, sizeof(int), int_compare);\n");
        code.push_str("}\n\n");
        code.push_str("void sort_Float64s(double* arr, int len) {\n");
        code.push_str("    qsort(arr, len, sizeof(double), float_compare);\n");
        code.push_str("}\n\n");
        code.push_str("void sort_Strings(char** arr, int len) {\n");
        code.push_str("    qsort(arr, len, sizeof(char*), string_compare);\n");
        code.push_str("}\n\n");
        
        // json library
        code.push_str("// json library\n");
        code.push_str("char* json_escape(const char* s) {\n");
        code.push_str("    static char buffer[4096];\n");
        code.push_str("    int j = 0;\n");
        code.push_str("    buffer[j++] = '\"';\n");
        code.push_str("    for (int i = 0; s[i] && j < sizeof(buffer) - 2; i++) {\n");
        code.push_str("        if (s[i] == '\"') {\n");
        code.push_str("            buffer[j++] = '\\\\';\n");
        code.push_str("            buffer[j++] = '\"';\n");
        code.push_str("        } else if (s[i] == '\\\\') {\n");
        code.push_str("            buffer[j++] = '\\\\';\n");
        code.push_str("            buffer[j++] = '\\\\';\n");
        code.push_str("        } else if (s[i] == '\\n') {\n");
        code.push_str("            buffer[j++] = '\\\\';\n");
        code.push_str("            buffer[j++] = 'n';\n");
        code.push_str("        } else {\n");
        code.push_str("            buffer[j++] = s[i];\n");
        code.push_str("        }\n");
        code.push_str("    }\n");
        code.push_str("    buffer[j++] = '\"';\n");
        code.push_str("    buffer[j] = '\\0';\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        code.push_str("char* json_Marshal(const char* type, const char* value) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    if (strcmp(type, \"string\") == 0) {\n");
        code.push_str("        snprintf(buffer, sizeof(buffer), \"%s\", json_escape(value));\n");
        code.push_str("    } else if (strcmp(type, \"int\") == 0) {\n");
        code.push_str("        snprintf(buffer, sizeof(buffer), \"%s\", value);\n");
        code.push_str("    } else if (strcmp(type, \"float\") == 0) {\n");
        code.push_str("        snprintf(buffer, sizeof(buffer), \"%s\", value);\n");
        code.push_str("    } else if (strcmp(type, \"bool\") == 0) {\n");
        code.push_str("        snprintf(buffer, sizeof(buffer), \"%s\", value);\n");
        code.push_str("    } else {\n");
        code.push_str("        snprintf(buffer, sizeof(buffer), \"null\");\n");
        code.push_str("    }\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        code.push_str("char* json_Unmarshal(const char* json, const char* type) {\n");
        code.push_str("    static char buffer[1024];\n");
        code.push_str("    if (json[0] == '\"' && json[strlen(json)-1] == '\"') {\n");
        code.push_str("        int len = strlen(json) - 2;\n");
        code.push_str("        strncpy(buffer, json + 1, len);\n");
        code.push_str("        buffer[len] = '\\0';\n");
        code.push_str("        return buffer;\n");
        code.push_str("    }\n");
        code.push_str("    strncpy(buffer, json, sizeof(buffer) - 1);\n");
        code.push_str("    buffer[sizeof(buffer) - 1] = '\\0';\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        
        // http library (placeholder)
        code.push_str("// http library (placeholder - requires socket implementation)\n");
        code.push_str("char* http_Get(const char* url) {\n");
        code.push_str("    static char buffer[4096];\n");
        code.push_str("    snprintf(buffer, sizeof(buffer), \"GET request to: %s\\n\", url);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        code.push_str("char* http_Post(const char* url, const char* data) {\n");
        code.push_str("    static char buffer[4096];\n");
        code.push_str("    snprintf(buffer, sizeof(buffer), \"POST request to: %s with data: %s\\n\", url, data);\n");
        code.push_str("    return buffer;\n");
        code.push_str("}\n\n");
        code.push_str("int http_ListenAndServe(const char* addr, void* handler) {\n");
        code.push_str("    return 0; // TODO: Implement actual HTTP server\n");
        code.push_str("}\n\n");
        
        code
    }
    
    fn generate_statement(&mut self, stmt: &Stmt) {
        match stmt {
            Stmt::Expression(expr) => {
                // Check if this is error propagation
                if let Expr::ErrorPropagate { expr: inner_expr } = expr {
                    // Error propagation: expr? -> if (err != NULL) return err;
                    let expr_str = self.generate_expression(inner_expr);
                    // For now, simplified: assume expr might return error or tuple with error
                    // In a full implementation, we'd check the return type
                    self.writeln(&format!("if ({} != NULL) return {};", expr_str, expr_str));
                } else {
                let expr_str = self.generate_expression(expr);
                self.writeln(&format!("{};", expr_str));
            }
            }
            Stmt::VariableDecl { name, type_annot, value, mutable } => {
                // If type is not specified, infer from value
                let inferred_type = if type_annot.is_none() && value.is_some() {
                    // Check if value is array literal
                    if let Some(Expr::ArrayLiteral { elements }) = value.as_ref() {
                        if !elements.is_empty() {
                            // Infer element type from first element
                            let elem_type = crate::type_inference::infer_type(&elements[0]);
                            if let Some(elem_typ) = elem_type {
                                // Check if type annotation suggests slice
                                if let Some(crate::ast::Type::Slice { .. }) = type_annot {
                                    Some(crate::ast::Type::Slice {
                                        element_type: Box::new(elem_typ),
                                    })
                                } else {
                                    // Default to array
                                    Some(crate::ast::Type::Array {
                                        size: elements.len(),
                                        element_type: Box::new(elem_typ),
                                    })
                                }
                            } else {
                                type_annot.clone()
                            }
                        } else {
                            // Empty array - can't infer, need explicit type
                            type_annot.clone()
                        }
                    } else {
                    crate::type_inference::infer_type(value.as_ref().unwrap())
                    }
                } else {
                    type_annot.clone()
                };
                
                let type_str = match &inferred_type {
                    Some(typ) => self.type_to_c_string(typ, false),
                    None => {
                        // If still can't infer, default to int
                        if value.is_some() {
                            "int".to_string() // Default fallback for value inference
                        } else {
                            // No type and no value - default to int with 0
                            "int".to_string()
                        }
                    }
                };
                
                // If we still don't have a type, create one (default to int)
                let final_type = inferred_type.clone().unwrap_or_else(|| crate::ast::Type::Int);
                
                // Track variable type for pointer detection
                if let Some(ref typ) = inferred_type {
                    self.variable_types.insert(name.clone(), typ.clone());
                }
                
                // Variables are immutable by default - generate as const only for immutable variables
                let var_type = if *mutable {
                    // Mutable variable - no const
                    type_str.clone()
                } else {
                    // Immutable variable - generate as const
                    if type_str.starts_with("const ") {
                        type_str.clone()
                    } else {
                        format!("const {}", type_str)
                    }
                };
                
                if let Some(val) = value {
                    // Check if this is a slice with array literal
                    if let Some(crate::ast::Type::Slice { .. }) = &inferred_type {
                        if let Expr::ArrayLiteral { elements } = val {
                            // Create slice from array literal
                            let elem_count = elements.len();
                            if elem_count > 0 {
                                // Generate temporary array for literal
                                let _temp_array_name = format!("{}_literal", name);
                                let _first_elem = self.generate_expression(&elements[0]);
                                // Infer element type
                                if let Some(elem_type) = crate::type_inference::infer_type(&elements[0]) {
                                    let elem_c_type = match elem_type {
                                        crate::ast::Type::Int => "int",
                                        crate::ast::Type::Float => "double",
                                        crate::ast::Type::String => "char*",
                                        crate::ast::Type::Bool => "int",
                                        _ => "int",
                                    };
                                    let elem_size = match elem_type {
                                        crate::ast::Type::Int => "sizeof(int)",
                                        crate::ast::Type::Float => "sizeof(double)",
                                        crate::ast::Type::String => "sizeof(char*)",
                                        crate::ast::Type::Bool => "sizeof(int)",
                                        _ => "sizeof(int)",
                                    };
                                    // Generate array literal
                                    let elems_str: Vec<String> = elements.iter().map(|e| self.generate_expression(e)).collect();
                                    self.writeln(&format!("{} {}_arr[{}] = {{{}}};", elem_c_type, name, elem_count, elems_str.join(", ")));
                                    self.writeln(&format!("{} {} = slice_from_literal({}_arr, {}, {});", var_type, name, name, elem_count, elem_size));
                                } else {
                                    // Fallback
                                    let val_str = self.generate_expression(val);
                                    self.writeln(&format!("{} {} = {};", var_type, name, val_str));
                                }
                            } else {
                                // Empty slice
                                self.writeln(&format!("{} {} = NULL;", var_type, name));
                            }
                        } else {
                            if let crate::ast::Type::Array { size, element_type } = &final_type {
                                // Array initialization with expression
                                let elem_type_str = self.type_to_c_string(element_type, false);
                                // If value is array literal, we can use it directly?
                                // generate_expression returns string representation.
                                // If it's a `{...}` string, it works for C array init.
                                let val_str = self.generate_expression(val);
                                self.writeln(&format!("{} {}[{}] = {};", elem_type_str, name, size, val_str));
                            } else {
                                let val_str = self.generate_expression(val);
                                self.writeln(&format!("{} {} = {};", var_type, name, val_str));
                            }
                        }
                    } else {
                        if let crate::ast::Type::Array { size, element_type } = &final_type {
                            let elem_type_str = self.type_to_c_string(element_type, false);
                            let val_str = self.generate_expression(val);
                            self.writeln(&format!("{} {}[{}] = {};", elem_type_str, name, size, val_str));
                        } else {
                            let val_str = self.generate_expression(val);
                            self.writeln(&format!("{} {} = {};", var_type, name, val_str));
                        }
                    }
                } else {
                    // Uninitialized variable - initialize with default value
                    if let crate::ast::Type::Array { size, element_type } = &final_type {
                        let elem_type_str = self.type_to_c_string(element_type, false);
                        self.writeln(&format!("{} {}[{}];", elem_type_str, name, size));
                        self.writeln(&format!("memset({}, 0, sizeof({}));", name, name));
                    } else {
                        let default_val = self.get_default_value(&final_type);
                        self.writeln(&format!("{} {} = {};", var_type, name, default_val));
                    }
                }
            }
            Stmt::MultiAssignment { names, value } => {
                // Handle multiple assignment: @a, @b = func()
                // Check if value uses error propagation
                let (value_expr, has_error_prop) = if let Expr::ErrorPropagate { expr: inner_expr } = value {
                    // Error propagation in assignment: @a, @err = func()?
                    // Generate: tuple result = func(); if (result.field1 != NULL) return result.field1;
                    let inner_str = self.generate_expression(inner_expr);
                    (inner_str, true)
                } else {
                    (self.generate_expression(value), false)
                };
                
                if names.len() > 1 {
                    // Multiple assignment from tuple return
                    // Generate: Tuple_... _tuple_result = func();
                    // Then extract each field
                    self.writeln(&format!("// Multiple assignment: {} variables", names.len()));
                    self.writeln(&format!("auto _tuple_result = {};", value_expr));
                    
                    // If error propagation, check error field (typically last field)
                    if has_error_prop {
                        let error_field_idx = names.len() - 1; // Assume last field is error
                        self.writeln(&format!("if (_tuple_result.field{} != NULL) return _tuple_result.field{};", 
                            error_field_idx, error_field_idx));
                    }
                    
                    for (i, name) in names.iter().enumerate() {
                        // Extract field from tuple
                        // Note: We need to know the types - for now, use auto
                        // In a full implementation, we'd track tuple types from function signature
                        self.writeln(&format!("auto {} = _tuple_result.field{};", name, i));
                    }
                } else {
                    // Single assignment - fallback
                    if has_error_prop {
                        // Error propagation with single value
                        self.writeln(&format!("auto {} = {};", names[0], value_expr));
                        self.writeln(&format!("if ({} != NULL) return {};", names[0], names[0]));
                    } else {
                        self.writeln(&format!("auto {} = {};", names[0], value_expr));
                    }
                }
            }
            Stmt::Assignment { name, value } => {
                let val_str = self.generate_expression(value);
                // Check if this is a map assignment (name contains map_get or is a Map*)
                // For now, handle as regular assignment - map assignments will be handled specially
                // when we detect map index expressions on the left side
                self.writeln(&format!("{} = {};", name, val_str));
            }
            Stmt::If {
                condition,
                then_block,
                else_block,
            } => {
                let cond_str = self.generate_expression(condition);
                self.writeln(&format!("if ({}) {{", cond_str));
                self.indent();
                for stmt in then_block {
                    self.generate_statement(stmt);
                }
                self.dedent();
                
                if let Some(else_block) = else_block {
                    self.writeln("} else {");
                    self.indent();
                    for stmt in else_block {
                        self.generate_statement(stmt);
                    }
                    self.dedent();
                }
                self.writeln("}");
            }
            Stmt::ForRange { key_var, value_var, iterable, body } => {
                // Generate varasa-based for loop for maps/slices/arrays
                let iterable_str = self.generate_expression(iterable);
                
                // Check if iterable is a map (contains "map" or is Map*)
                // We'll use a heuristic: if variable name suggests map or type is Map*
                if iterable_str.contains("map") || iterable_str.starts_with("map_") || 
                   iterable_str.ends_with("*") && !iterable_str.contains("slice") {
                    // Map iteration using iterator
                    let iter_name = format!("{}_iter", key_var);
                    let key_ptr = format!("{}_key_ptr", key_var);
                    let value_ptr = format!("{}_value_ptr", value_var.as_ref().map(|v| v.as_str()).unwrap_or("_"));
                    
                    self.writeln(&format!("MapIterator* {} = map_iter({});", iter_name, iterable_str));
                    self.writeln(&format!("void* {};", key_ptr));
                    if value_var.is_some() {
                        self.writeln(&format!("void* {};", value_ptr));
                    }
                    let value_ptr_arg = if value_var.is_some() { format!("&{}", value_ptr) } else { "NULL".to_string() };
                    self.writeln(&format!("while (map_next({}, &{}, {})) {{", 
                        iter_name, key_ptr, value_ptr_arg));
                    self.indent();
                    
                    // Declare key variable (assume string key for now)
                    self.writeln(&format!("char* {} = *(char**){};", key_var, key_ptr));
                    
                    // Declare value variable if provided (assume int value for now)
                    if let Some(val_var) = value_var {
                        self.writeln(&format!("int {} = *(int*){};", val_var, value_ptr));
                    }
                    
                    // Generate body
                    for stmt in body {
                        self.generate_statement(stmt);
                    }
                    
                    self.dedent();
                    self.writeln("}");
                    self.writeln(&format!("if ({}) free({});", iter_name, iter_name));
                } else {
                    // Slice/array iteration
                    // Use index-based iteration
                    let index_var = format!("{}_i", key_var);
                    self.writeln(&format!("for (int {} = 0; {} < len({}); {} = {} + 1) {{", 
                        index_var, index_var, iterable_str, index_var, index_var));
                    self.indent();
                    
                    // Declare key variable (index)
                    self.writeln(&format!("int {} = {};", key_var, index_var));
                    
                    // Declare value variable if provided
                    if let Some(val_var) = value_var {
                        self.writeln(&format!("int {} = {}[{}];", val_var, iterable_str, index_var));
                    }
                    
                    // Generate body
                    for stmt in body {
                        self.generate_statement(stmt);
                    }
                    
                    self.dedent();
                    self.writeln("}");
                }
            }
            Stmt::For {
                init,
                condition,
                update,
                body,
            } => {
                self.write("    for (");
                if let Some(init) = init {
                    match init.as_ref() {
                        Stmt::VariableDecl { name, type_annot, value, mutable: _ } => {
                            // Infer type if not specified
                            let inferred_type = if type_annot.is_none() && value.is_some() {
                                crate::type_inference::infer_type(value.as_ref().unwrap())
                            } else {
                                type_annot.clone()
                            };
                            
                            let type_str = match inferred_type {
                                Some(crate::ast::Type::Int) => "int".to_string(),
                                Some(crate::ast::Type::Float) => "double".to_string(),
                                Some(crate::ast::Type::String) => "char*".to_string(),
                                Some(crate::ast::Type::Bool) => "int".to_string(),
                                Some(crate::ast::Type::Error) => "char*".to_string(),
                                Some(crate::ast::Type::Void) => "void".to_string(),
                                Some(crate::ast::Type::Pointer(inner)) => {
                                    let inner_str = match inner.as_ref() {
                                        crate::ast::Type::Int => "int",
                                        crate::ast::Type::Float => "double",
                                        crate::ast::Type::String => "char*",
                                        crate::ast::Type::Bool => "int",
                                        crate::ast::Type::Error => "char*",
                                        crate::ast::Type::Void => "void",
                                        _ => "void",
                                    };
                                    format!("{}*", inner_str)
                                }
                                Some(crate::ast::Type::Reference { inner, .. }) => {
                                    let inner_str = match inner.as_ref() {
                                        crate::ast::Type::Int => "int",
                                        crate::ast::Type::Float => "double",
                                        crate::ast::Type::String => "char*",
                                        crate::ast::Type::Bool => "int",
                                        _ => "void",
                                    };
                                    format!("{}*", inner_str)
                                }
                                Some(crate::ast::Type::Array { element_type, size }) => {
                                    let elem_str = match element_type.as_ref() {
                                        crate::ast::Type::Int => "int",
                                        crate::ast::Type::Float => "double",
                                        crate::ast::Type::String => "char*",
                                        crate::ast::Type::Bool => "int",
                                        _ => "void",
                                    };
                                    format!("{}[{}]", elem_str, size)
                                }
                                Some(crate::ast::Type::Slice { .. }) => "Slice*".to_string(),
                                Some(crate::ast::Type::Struct { name }) => format!("{}", name),
                                Some(crate::ast::Type::Map { .. }) => "Map*".to_string(),
                                Some(crate::ast::Type::Interface { .. }) => "void*".to_string(),
                                Some(crate::ast::Type::Any) => "void*".to_string(),
                                Some(crate::ast::Type::Tuple { .. }) => "void*".to_string(),
                                Some(crate::ast::Type::Owned { inner, .. }) => {
                                    let inner_str = match inner.as_ref() {
                                        crate::ast::Type::Int => "int",
                                        crate::ast::Type::Float => "double",
                                        crate::ast::Type::String => "char*",
                                        crate::ast::Type::Bool => "int",
                                        _ => "void*",
                                    };
                                    inner_str.to_string()
                                }
                                None => "int".to_string(), // Default fallback
                            };
                            if let Some(val) = value {
                                let val_str = self.generate_expression(val);
                                self.write(&format!("{} {} = {}", type_str, name, val_str));
                            } else {
                                self.write(&format!("{} {}", type_str, name));
                            }
                        }
                        Stmt::Expression(expr) => {
                            let expr_str = self.generate_expression(expr);
                            self.write(&expr_str);
                        }
                        _ => {}
                    }
                }
                self.write("; ");
                if let Some(cond) = condition {
                    let cond_str = self.generate_expression(cond);
                    self.write(&cond_str);
                }
                self.write("; ");
                if let Some(upd) = update {
                    match upd.as_ref() {
                        Stmt::Expression(expr) => {
                            let expr_str = self.generate_expression(expr);
                            self.write(&expr_str);
                        }
                        Stmt::Assignment { name, value } => {
                            let val_str = self.generate_expression(value);
                            self.write(&format!("{} = {}", name, val_str));
                        }
                        _ => {}
                    }
                }
                self.write(") {\n");
                
                self.indent();
                for stmt in body {
                    self.generate_statement(stmt);
                }
                self.dedent();
                self.writeln("}");
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    let expr_str = self.generate_expression(e);
                    // If returning tuple literal, it's already formatted as struct literal
                    self.writeln(&format!("return {};", expr_str));
                } else {
                    self.writeln("return;");
                }
            }
            Stmt::Break => {
                self.writeln("break;");
            }
            Stmt::Continue => {
                self.writeln("continue;");
            }
            Stmt::Function { name, params, return_type, body, is_macro: _ } => {
                // Emit #line directive for debug symbols (approximate - function start)
                // Note: For precise line numbers, AST nodes would need to store source locations
                if self.source_filename.is_some() {
                    self.emit_line_directive(1); // Placeholder - would use actual line from AST if available
                }
                
                // Track struct methods for interface satisfaction checking
                // Method names are in format: StructName_MethodName
                if name.contains('_') {
                    let parts: Vec<&str> = name.split('_').collect();
                    if parts.len() >= 2 {
                        let struct_name = parts[0].to_string();
                        let method_name = parts[1..].join("_");
                        let method_sig = (method_name, params.clone(), return_type.clone());
                        self.struct_methods.entry(struct_name.clone())
                            .or_insert_with(Vec::new)
                            .push(method_sig);
                    }
                }
                
                // Store return type for tuple literal generation
                let old_return_type = self.current_function_return_type.clone();
                self.current_function_return_type = return_type.clone();
                
                // Handle tuple return type - generate struct
                if let Some(crate::ast::Type::Tuple { types }) = return_type {
                    // Generate tuple struct
                    let struct_name = format!("Tuple_{}", types.iter()
                        .map(|t| {
                            let t_str = self.type_to_c_string(t, false);
                            t_str.replace("*", "ptr").replace(" ", "_")
                        })
                        .collect::<Vec<_>>()
                        .join("_"));
                    
                    self.write(&format!("typedef struct {} {{\n", struct_name));
                    self.indent();
                    for (i, typ) in types.iter().enumerate() {
                        let field_type = self.type_to_c_string(typ, false);
                        self.writeln(&format!("{} field{};", field_type, i));
                    }
                    self.dedent();
                    self.writeln(&format!("}} {};", struct_name));
                    self.write("\n");
                    
                    // Generate function with tuple return
                    self.write(&format!("{} {}(", struct_name, name));
                    for (i, (param_name, param_type)) in params.iter().enumerate() {
                        if i > 0 {
                            self.write(", ");
                        }
                        let param_type_str = self.type_to_c_string(param_type, false);
                        self.write(&format!("{} {}", param_type_str, param_name));
                    }
                    self.write(") {\n");
                    self.indent();
                    for stmt in body {
                        self.generate_statement(stmt);
                    }
                    self.dedent();
                    self.writeln("}");
                } else {
                    // Single return type (existing code)
                    let return_type_str = match return_type {
                        Some(typ) => self.type_to_c_string(typ, false),
                    None => "void".to_string(),
                };
                
                self.write(&format!("{} {}(", return_type_str, name));
                for (i, (param_name, param_type)) in params.iter().enumerate() {
                    if i > 0 {
                        self.write(", ");
                    }
                        let param_type_str = self.type_to_c_string(param_type, false);
                    self.write(&format!("{} {}", param_type_str, param_name));
                }
                self.write(") {\n");
                self.indent();
                for stmt in body {
                    self.generate_statement(stmt);
                }
                self.dedent();
                self.writeln("}");
                }
                
                // Restore previous return type
                self.current_function_return_type = old_return_type;
            }
            Stmt::Block(statements) => {
                self.writeln("{");
                self.indent();
                for stmt in statements {
                    self.generate_statement(stmt);
                }
                self.dedent();
                self.writeln("}");
            }
            Stmt::Import { path, alias } => {
                // Import statement - just a comment in generated code
                // Functions from imports are already included via generate_with_packages
                if let Some(alias) = alias {
                    self.writeln(&format!("// import {} as {}", path, alias));
                } else {
                    self.writeln(&format!("// import {}", path));
                }
            }
            Stmt::StructDef { name, fields } => {
                // Track struct definition for type inference
                let fields_info: Vec<(String, crate::ast::Type)> = fields.iter()
                    .map(|(name, typ, _)| (name.clone(), typ.clone()))
                    .collect();
                self.struct_definitions.insert(name.clone(), fields_info.clone());
                
                // Generate C struct definition
                self.write(&format!("typedef struct {} {{\n", name));
                self.indent();
                for (field_name, field_type, _tags) in fields {
                    let field_type_str = self.type_to_c_string(field_type, false);
                    self.writeln(&format!("{} {};", field_type_str, field_name));
                }
                self.dedent();
                self.writeln(&format!("}} {};", name));
                self.write("\n");
                
                // Generate automatic JSON marshal/unmarshal functions
                self.generate_struct_json_marshal(name, &fields_info);
                self.generate_struct_json_unmarshal(name, &fields_info);
                
                // Generate automatic Protobuf marshal/unmarshal functions
                self.generate_struct_protobuf_marshal(name, &fields_info);
                self.generate_struct_protobuf_unmarshal(name, &fields_info);
                
                // Generate schema validation function from struct tags
                self.generate_struct_schema_validation(name, fields);
            }
            Stmt::InterfaceDef { name, methods, embedded } => {
                // Handle interface embedding - merge methods from embedded interfaces
                let mut all_methods = methods.clone();
                for embedded_name in embedded {
                    // Find embedded interface and merge its methods
                    if let Some(embedded_methods) = self.interfaces.get(embedded_name) {
                        all_methods.extend(embedded_methods.clone());
                    }
                }
                
                // Store interface definition for later satisfaction checking
                self.interfaces.insert(name.clone(), all_methods.clone());
                
                // Generate interface as a struct with function pointers
                // This is similar to Go's interface implementation
                self.write(&format!("// Interface: {}\n", name));
                if !embedded.is_empty() {
                    self.write(&format!("// Embedded interfaces: {}\n", embedded.join(", ")));
                }
                self.write(&format!("typedef struct {}_vtable {{\n", name));
                self.indent();
                for (method_name, params, return_type) in &all_methods {
                    let return_type_str = match return_type {
                        Some(typ) => self.type_to_c_string(typ, false),
                        None => "void".to_string(),
                    };
                    
                    // Generate function pointer type
                    let param_types: Vec<String> = params.iter()
                        .map(|(_, param_type)| self.type_to_c_string(param_type, false))
                        .collect();
                    let param_list = if param_types.is_empty() {
                        "void".to_string()
                    } else {
                        param_types.join(", ")
                    };
                    
                    self.writeln(&format!("{} (*{})({});", return_type_str, method_name, param_list));
                }
                self.dedent();
                self.writeln(&format!("}} {}_vtable;", name));
                self.write("\n");
                
                // Interface struct that contains vtable and data pointer
                self.write(&format!("typedef struct {} {{\n", name));
                self.indent();
                self.writeln(&format!("{}_vtable* vtable;", name));
                self.writeln("void* data;  // Pointer to implementing struct");
                self.dedent();
                self.writeln(&format!("}} {};", name));
                self.write("\n");
                
                // Generate helper function to create interface from struct
                self.generate_interface_constructor(name, &all_methods);
            }
        }
    }
    
    fn type_to_c_string(&self, typ: &crate::ast::Type, is_const: bool) -> String {
        // Track struct definitions for code generation
        // This is a simplified approach - in a full implementation, we'd track structs globally
        let const_prefix = if is_const { "const " } else { "" };
        match typ {
            crate::ast::Type::Int => format!("{}int", const_prefix),
            crate::ast::Type::Float => format!("{}double", const_prefix),
            crate::ast::Type::String => format!("{}char*", const_prefix),
            crate::ast::Type::Bool => format!("{}int", const_prefix),
            crate::ast::Type::Error => format!("{}char*", const_prefix),
            crate::ast::Type::Void => format!("{}void", const_prefix),
            crate::ast::Type::Pointer(inner) => {
                let inner_str = self.type_to_c_string(inner, false);
                format!("{}{}*", const_prefix, inner_str)
            }
            crate::ast::Type::Array { size, element_type } => {
                let elem_str = self.type_to_c_string(element_type, false);
                if *size == 0 {
                    // Variable-length array (inferred from literal)
                    format!("{}int", const_prefix) // Will be handled specially
                } else {
                    format!("{}{}[{}]", const_prefix, elem_str, size)
                }
            }
            crate::ast::Type::Slice { element_type: _ } => {
                // Slice is always a pointer to Slice struct
                format!("{}Slice*", const_prefix)
            }
            crate::ast::Type::Struct { name } => {
                // Struct type - use struct name directly
                format!("{}{}", const_prefix, name)
            }
            crate::ast::Type::Map { key_type: _, value_type: _ } => {
                // Map type - use a generic Map struct (we'll implement this)
                format!("{}Map*", const_prefix)
            }
            crate::ast::Type::Interface { name } => {
                // Interface type - use interface name directly
                format!("{}{}*", const_prefix, name)
            }
            crate::ast::Type::Any => {
                // interface{} - unknown/any type, use void* in C
                format!("{}void*", const_prefix)
            }
            crate::ast::Type::Tuple { types } => {
                // Tuple type - generate struct name
                let type_names: Vec<String> = types.iter()
                    .map(|t| {
                        let t_str = self.type_to_c_string(t, false);
                        // Sanitize type name for struct field (remove *, spaces, etc.)
                        t_str.replace("*", "ptr").replace(" ", "_")
                    })
                    .collect();
                format!("{}Tuple_{}", const_prefix, type_names.join("_"))
            }
            crate::ast::Type::Reference { inner, .. } => {
                // Reference type - generates as pointer in C
                let inner_str = self.type_to_c_string(inner, false);
                format!("{}{}*", const_prefix, inner_str)
            }
            crate::ast::Type::Owned { inner, .. } => {
                // Owned type - generates as the inner type in C
                self.type_to_c_string(inner, is_const)
            }
        }
    }
    
    fn get_default_value(&self, typ: &crate::ast::Type) -> String {
        match typ {
            crate::ast::Type::Int => "0".to_string(),
            crate::ast::Type::Float => "0.0".to_string(),
            crate::ast::Type::String => "\"\"".to_string(), // Empty string
            crate::ast::Type::Bool => "0".to_string(), // false
            crate::ast::Type::Error => "NULL".to_string(), // NULL for error type
            crate::ast::Type::Void => "".to_string(), // void has no value
            crate::ast::Type::Pointer(_) => "NULL".to_string(),
            crate::ast::Type::Array { size, element_type } => {
                // For arrays, generate zero-initialized array: {0} or {0, 0, ...}
                if *size == 0 {
                    "{}".to_string() // Empty array literal
                } else {
                    let default_elem = self.get_default_value(element_type);
                    let elems: Vec<String> = (0..*size).map(|_| default_elem.clone()).collect();
                    format!("{{{}}}", elems.join(", "))
                }
            }
            crate::ast::Type::Slice { element_type: _ } => {
                // Slice defaults to NULL (empty slice)
                "NULL".to_string()
            }
            crate::ast::Type::Struct { name: _ } => {
                // Struct defaults to zero-initialized struct (all fields zero)
                // This will be handled specially in variable declaration
                "{}".to_string()
            }
            crate::ast::Type::Map { key_type: _, value_type: _ } => {
                // Map defaults to NULL (empty map)
                "NULL".to_string()
            }
            crate::ast::Type::Interface { name: _ } => {
                // Interface defaults to NULL
                "NULL".to_string()
            }
            crate::ast::Type::Any => {
                // interface{} defaults to NULL
                "NULL".to_string()
            }
            crate::ast::Type::Reference { .. } => {
                // Reference defaults to NULL
                "NULL".to_string()
            }
            crate::ast::Type::Tuple { types } => {
                // Tuple defaults to all members defaulted
                let defaults: Vec<String> = types.iter()
                    .map(|t| self.get_default_value(t))
                    .collect();
                format!("{{{}}}", defaults.join(", "))
            }
            crate::ast::Type::Owned { inner, .. } => {
                // Owned type defaults to the inner type's default
                self.get_default_value(inner)
            }
        }
    }
    
    fn generate_expression(&mut self, expr: &Expr) -> String {
        match expr {
            Expr::Number(n) => n.to_string(),
            Expr::String(s) => format!("\"{}\"", s),
            Expr::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
            Expr::Nil => "NULL".to_string(), // Sunyam -> NULL
            Expr::Kotha { target_type } => {
                // kotha Type -> malloc(sizeof(Type))
                let type_str = self.type_to_c_string(target_type, false);
                // For pointer types, we need to allocate the pointed-to type
                let alloc_type = match target_type {
                    crate::ast::Type::Pointer(inner) => {
                        self.type_to_c_string(inner, false)
                    }
                    _ => type_str.clone(),
                };
                format!("({}*)malloc(sizeof({}))", type_str, alloc_type)
            },
            Expr::Identifier(name) => {
                // Check if this identifier is a struct type (for json.Marshal detection)
                // This is handled in FunctionCall special case
                name.clone()
            },
            Expr::BinaryOp { op, left, right } => {
                let left_str = self.generate_expression(left);
                let right_str = self.generate_expression(right);
                let op_str = match op {
                    BinaryOperator::Add => "+",
                    BinaryOperator::Subtract => "-",
                    BinaryOperator::Multiply => "*",
                    BinaryOperator::Divide => "/",
                    BinaryOperator::Modulo => "%",
                    BinaryOperator::Power => "pow",
                    BinaryOperator::Equal => "==",
                    BinaryOperator::NotEqual => "!=",
                    BinaryOperator::LessThan => "<",
                    BinaryOperator::GreaterThan => ">",
                    BinaryOperator::LessThanEqual => "<=",
                    BinaryOperator::GreaterThanEqual => ">=",
                    BinaryOperator::And => "&&",
                    BinaryOperator::Or => "||",
                };
                
                if op == &BinaryOperator::Power {
                    format!("pow({}, {})", left_str, right_str)
                } else {
                    format!("({} {} {})", left_str, op_str, right_str)
                }
            }
            Expr::UnaryOp { op, expr } => {
                let expr_str = self.generate_expression(expr);
                match op {
                    UnaryOperator::Negate => format!("-{}", expr_str),
                    UnaryOperator::Not => format!("!{}", expr_str),
                }
            }
            Expr::FunctionCall { name, args } => {
                // Special handling for len() function for arrays, slices, and maps
                if name == "len" && args.len() == 1 {
                    let arr_expr = self.generate_expression(&args[0]);
                    // Check if it's a map (Map*)
                    if arr_expr.contains("map") || arr_expr.starts_with("map_") {
                        return format!("map_len({})", arr_expr);
                    }
                    // Check if it's a slice (Slice*) or array
                    // For slices, use slice_len, for arrays use sizeof
                    // We'll use a heuristic: if it contains "slice" or is a pointer, use slice_len
                    if arr_expr.contains("slice") || arr_expr.ends_with("*") {
                        return format!("slice_len({})", arr_expr);
                    } else {
                        // Array: sizeof(arr) / sizeof(arr[0])
                        return format!("(sizeof({}) / sizeof(({})[0]))", arr_expr, arr_expr);
                    }
                }
                
                // Special handling for delete() function for maps
                if name == "delete" && args.len() == 2 {
                    let map_expr = self.generate_expression(&args[0]);
                    let key_expr = self.generate_expression(&args[1]);
                    // Check if first argument is a map
                    if map_expr.contains("map") || map_expr.starts_with("map_") {
                        return format!("map_delete({}, &{})", map_expr, key_expr);
                    }
                }
                
                // Special handling for cap() function for slices
                if name == "cap" && args.len() == 1 {
                    let slice_expr = self.generate_expression(&args[0]);
                    return format!("slice_cap({})", slice_expr);
                }
                
                // Special handling for append() function for slices
                if name == "append" && args.len() >= 2 {
                    let slice_expr = self.generate_expression(&args[0]);
                    let elem_expr = self.generate_expression(&args[1]);
                    // Simplified - assumes int size for now
                    return format!("slice_append({}, &{}, sizeof(int))", slice_expr, elem_expr);
                }
                
                // Special handling for json.Marshal with automatic struct detection
                if name == "json.Marshal" && args.len() == 1 {
                    let arg_expr = &args[0];
                    let arg_str = self.generate_expression(arg_expr);
                    
                    // Infer the type of the argument expression
                    let arg_type = crate::type_inference::infer_type(arg_expr);
                    
                    // Check if it's a struct type (direct or pointer)
                    let struct_name = match &arg_type {
                        Some(crate::ast::Type::Struct { name }) => Some(name.clone()),
                        Some(crate::ast::Type::Pointer(inner)) => {
                            if let crate::ast::Type::Struct { name } = inner.as_ref() {
                                Some(name.clone())
                            } else {
                                None
                            }
                        }
                        _ => {
                            // Try to infer from variable name if it's an identifier
                            if let Expr::Identifier(var_name) = arg_expr {
                                // Check if variable is declared as a struct type
                                if let Some(var_type) = self.variable_types.get(var_name) {
                                    match var_type {
                                        crate::ast::Type::Struct { name } => Some(name.clone()),
                                        crate::ast::Type::Pointer(inner) => {
                                            if let crate::ast::Type::Struct { name } = inner.as_ref() {
                                                Some(name.clone())
                                            } else {
                                                None
                                            }
                                        }
                                        _ => None,
                                    }
                                } else {
                                    None
                                }
                            } else {
                                None
                            }
                        }
                    };
                    
                    // If we found a struct type, generate the marshal function call
                    if let Some(struct_name) = struct_name {
                        let marshal_func = format!("json_marshal_{}", struct_name.to_lowercase());
                        // Check if argument is already a pointer or needs address-of
                        let needs_address = match &arg_type {
                            Some(crate::ast::Type::Struct { .. }) => {
                                // Direct struct - need address-of
                                true
                            }
                            Some(crate::ast::Type::Pointer(_)) => {
                                // Already a pointer - no address-of needed
                                false
                            }
                            _ => {
                                // Check from variable type or expression type
                                match arg_expr {
                                    Expr::Identifier(var_name) => {
                                        if let Some(var_type) = self.variable_types.get(var_name) {
                                            !matches!(var_type, crate::ast::Type::Pointer(_))
                                        } else {
                                            true // Default to taking address for direct structs
                                        }
                                    }
                                    Expr::Kotha { .. } => false, // kotha returns pointer
                                    Expr::Deref { .. } => false, // Deref is already a pointer
                                    Expr::MemberAccess { .. } => {
                                        // Member access on struct - check if object is pointer
                                        // For now, assume direct struct access needs address
                                        true
                                    }
                                    _ => true, // Default to taking address
                                }
                            }
                        };
                        
                        if needs_address {
                            return format!("{}(&{})", marshal_func, arg_str);
                        } else {
                            return format!("{}({})", marshal_func, arg_str);
                        }
                    }
                    
                    // Fallback: if it's not a struct, use the legacy json.Marshal(type, value) format
                    // But we only have one arg, so this might be an error - let it fall through
                }
                
                let args_str: Vec<String> = args.iter().map(|a| self.generate_expression(a)).collect();
                // Convert dot notation to underscore notation for C (e.g., strconv.Atoi -> strconv_Atoi)
                // Handle package.function calls (e.g., utils.sum -> utils_sum)
                // Also handle aliased imports (e.g., dhimpu "utils" as u -> u.sum -> u_sum)
                let c_name = name.replace(".", "_");
                format!("{}({})", c_name, args_str.join(", "))
            }
            Expr::Assignment { name, value } => {
                let val_str = self.generate_expression(value);
                format!("{} = {}", name, val_str)
            }
            Expr::MemberAssignment { object, field, value } => {
                // Generate member assignment: always use . in Tlang, but -> in C for pointers
                let obj_str = self.generate_expression(object);
                let val_str = self.generate_expression(value);
                // Check if object is a pointer by examining the expression type
                let is_pointer = match object.as_ref() {
                    Expr::Identifier(name) => {
                        // Check if variable is declared as a pointer type
                        if let Some(var_type) = self.variable_types.get(name) {
                            matches!(var_type, crate::ast::Type::Pointer(_))
                        } else {
                            // Fallback heuristic: check if name or generated code suggests pointer
                            obj_str.ends_with("*") || obj_str.contains("->")
                        }
                    }
                    Expr::Deref { .. } => true,
                    Expr::Kotha { .. } => true,  // kotha always returns a pointer
                    Expr::MemberAccess { .. } => {
                        // Nested member access - check if result is pointer
                        obj_str.ends_with("*") || obj_str.contains("->")
                    }
                    _ => obj_str.ends_with("*") || obj_str.contains("->") || obj_str.contains("malloc")
                };
                let accessor = if is_pointer { "->" } else { "." };
                format!("{}{}{} = {}", obj_str, accessor, field, val_str)
            }
            Expr::ErrorCheck { expr } => {
                // Error check expression (for future use)
                self.generate_expression(expr)
            }
            Expr::ArrayIndex { array, index } => {
                let array_str = self.generate_expression(array);
                let index_str = self.generate_expression(index);
                // Check if it's a slice - if so, access via slice_data
                if array_str.contains("slice") || array_str.ends_with("*") {
                    format!("((int*)slice_data({}))[{}]", array_str, index_str)
                } else {
                    format!("{}[{}]", array_str, index_str)
                }
            }
            Expr::ArrayLiteral { elements } => {
                // Generate array literal: {1, 2, 3}
                // Note: This will be used for both arrays and slices
                let elems_str: Vec<String> = elements.iter().map(|e| self.generate_expression(e)).collect();
                format!("{{{}}}", elems_str.join(", "))
            }
            Expr::SliceExpr { array, start, end } => {
                // Generate slice expression: arr[1:3]
                let array_str = self.generate_expression(array);
                let start_str = start.as_ref()
                    .map(|s| self.generate_expression(s))
                    .unwrap_or_else(|| "0".to_string());
                // For end, we need to get the length if None
                // This is simplified - in a real implementation, we'd need to track types
                let end_str = end.as_ref()
                    .map(|e| self.generate_expression(e))
                    .unwrap_or_else(|| format!("slice_len({})", array_str));
                
                // Generate slice creation code
                // This is a simplified implementation
                format!("slice_create_slice({}, {}, {})", array_str, start_str, end_str)
            }
            Expr::MemberAccess { object, field } => {
                // Generate member access: always use . in Tlang, but -> in C for pointers
                let obj_str = self.generate_expression(object);
                // Check if object is a pointer by examining the expression type
                let is_pointer = match object.as_ref() {
                    Expr::Identifier(name) => {
                        // Check if variable is declared as a pointer type
                        if let Some(var_type) = self.variable_types.get(name) {
                            matches!(var_type, crate::ast::Type::Pointer(_))
                        } else {
                            // Fallback heuristic: check if name or generated code suggests pointer
                            obj_str.ends_with("*") || obj_str.contains("->")
                        }
                    }
                    Expr::Deref { .. } => true,
                    Expr::Kotha { .. } => true,  // kotha always returns a pointer
                    Expr::MemberAccess { .. } => {
                        // Nested member access - check if result is pointer
                        obj_str.ends_with("*") || obj_str.contains("->")
                    }
                    _ => obj_str.ends_with("*") || obj_str.contains("->") || obj_str.contains("malloc")
                };
                let accessor = if is_pointer { "->" } else { "." };
                format!("{}{}{}", obj_str, accessor, field)
            }
            Expr::MapIndex { map, key } => {
                // Generate map indexing: map[key]
                let map_str = self.generate_expression(map);
                let key_str = self.generate_expression(key);
                // Use map_get with address of key - simplified to int for now
                // In full implementation, would need type information
                format!("*(int*)map_get({}, &{})", map_str, key_str)
            }
            Expr::StructLiteral { struct_type, fields } => {
                // Generate struct literal: Person{name: "Alice", age: 30}
                let fields_str: Vec<String> = fields.iter()
                    .map(|(name, expr)| {
                        format!(".{} = {}", name, self.generate_expression(expr))
                    })
                    .collect();
                format!("({}){{{}}}", struct_type, fields_str.join(", "))
            }
            Expr::MapLiteral { key_type, value_type, entries } => {
                // Generate map literal: jatha[string]int{"key1": 1, "key2": 2}
                // Determine key and value type codes (0=string, 1=int, 2=float, 3=bool)
                let key_type_code = match key_type.as_ref() {
                    crate::ast::Type::String => "0",
                    crate::ast::Type::Int => "1",
                    crate::ast::Type::Float => "2",
                    _ => "0", // Default to string
                };
                let value_type_code = match value_type.as_ref() {
                    crate::ast::Type::Int => "0",
                    crate::ast::Type::Float => "1",
                    crate::ast::Type::String => "2",
                    crate::ast::Type::Bool => "3",
                    _ => "0", // Default to int
                };
                
                // Create map and add entries
                let mut code = format!("map_create({}, {})", key_type_code, value_type_code);
                for (key, value) in entries {
                    let key_str = self.generate_expression(key);
                    let value_str = self.generate_expression(value);
                    code = format!("(map_set({}, &{}, &{}), {})", code, key_str, value_str, code);
                }
                code
            }
            Expr::TupleLiteral { elements } => {
                // Generate tuple literal: (value, error)
                // Use current function's return type to determine struct name
                if let Some(crate::ast::Type::Tuple { types }) = &self.current_function_return_type {
                    if elements.len() == types.len() {
                        // Generate struct name from types
                        let struct_name = format!("Tuple_{}", types.iter()
                            .map(|t| {
                                let t_str = self.type_to_c_string(t, false);
                                t_str.replace("*", "ptr").replace(" ", "_")
                            })
                            .collect::<Vec<_>>()
                            .join("_"));
                        
                        let field_strs: Vec<String> = elements.iter()
                            .enumerate()
                            .map(|(i, elem)| {
                                let elem_str = self.generate_expression(elem);
                                format!(".field{} = {}", i, elem_str)
                            })
                            .collect();
                        
                        format!("({}){{{}}}", struct_name, field_strs.join(", "))
                    } else {
                        // Mismatch - use generic
                        let field_strs: Vec<String> = elements.iter()
                            .enumerate()
                            .map(|(i, elem)| {
                                let elem_str = self.generate_expression(elem);
                                format!(".field{} = {}", i, elem_str)
                            })
                            .collect();
                        format!("(Tuple_unknown){{{}}}", field_strs.join(", "))
                    }
                } else {
                    // No return type context - use generic
                    let field_strs: Vec<String> = elements.iter()
                        .enumerate()
                        .map(|(i, elem)| {
                            let elem_str = self.generate_expression(elem);
                            format!(".field{} = {}", i, elem_str)
                        })
                        .collect();
                    format!("(Tuple_unknown){{{}}}", field_strs.join(", "))
                }
            }
            Expr::ErrorPropagate { expr } => {
                // Error propagation: expr?
                // This is handled at statement level for proper return
                // For expression context, just return the expression
                // The actual error check and return is done in Stmt::Expression
                self.generate_expression(expr)
            }
            Expr::TypeCast { target_type, expr } => {
                // Type conversion: int(x), float(x), string(x), bool(x)
                let expr_str = self.generate_expression(expr);
                // Infer source type to generate appropriate conversion
                let source_type = crate::type_inference::infer_type(expr);
                
                match target_type {
                    crate::ast::Type::Int => {
                        // Convert to int
                        match source_type {
                            Some(crate::ast::Type::Float) => {
                                format!("(int)({})", expr_str)
                            }
                            Some(crate::ast::Type::String) => {
                                format!("strconv_Atoi({})", expr_str)
                            }
                            Some(crate::ast::Type::Bool) => {
                                format!("({} ? 1 : 0)", expr_str)
                            }
                            _ => {
                                // Already int or unknown - cast to int
                                format!("(int)({})", expr_str)
                            }
                        }
                    }
                    crate::ast::Type::Float => {
                        // Convert to float
                        match source_type {
                            Some(crate::ast::Type::Int) => {
                                format!("(double)({})", expr_str)
                            }
                            Some(crate::ast::Type::String) => {
                                format!("strconv_ParseFloat({})", expr_str)
                            }
                            _ => {
                                // Already float or unknown - cast to double
                                format!("(double)({})", expr_str)
                            }
                        }
                    }
                    crate::ast::Type::String => {
                        // Convert to string
                        match source_type {
                            Some(crate::ast::Type::Int) => {
                                format!("strconv_Itoa({})", expr_str)
                            }
                            Some(crate::ast::Type::Float) => {
                                format!("strconv_FormatFloat({}, 6)", expr_str)
                            }
                            Some(crate::ast::Type::Bool) => {
                                format!("strconv_FormatBool({})", expr_str)
                            }
                            _ => {
                                // Already string or unknown - return as is
                                expr_str
                            }
                        }
                    }
                    crate::ast::Type::Bool => {
                        // Convert to bool (int: 0 or 1)
                        match source_type {
                            Some(crate::ast::Type::String) => {
                                format!("strconv_ParseBool({})", expr_str)
                            }
                            _ => {
                                // For numeric types, convert to bool (0 = false, non-zero = true)
                                format!("({} != 0 ? 1 : 0)", expr_str)
                            }
                        }
                    }
                    _ => {
                        // Unsupported type conversion
                        expr_str // Return original expression
                    }
                }
            }
            Expr::Borrow { expr, mutable } => {
                // Borrow expression: &expr (immutable) or &mut expr (mutable)
                // In C, both translate to taking address
                let expr_str = self.generate_expression(expr);
                // For mutable borrows, we might want to add a comment for clarity
                if *mutable {
                    format!("/* &mut */ &{}", expr_str)
                } else {
                    format!("&{}", expr_str)
                }
            }
            Expr::Deref { expr } => {
                // Dereference expression: *expr
                let expr_str = self.generate_expression(expr);
                format!("*{}", expr_str)
            }
            Expr::Jarugu { expr } => {
                // Explicit jarugu: jarugu expr
                // In C, moves are just assignments
                // The borrow checker handles ownership tracking at compile time
                self.generate_expression(expr)
            }
        }
    }
    
    fn generate_struct_json_marshal(&mut self, struct_name: &str, fields: &[(String, crate::ast::Type)]) {
        // Generate automatic JSON marshal function for a struct
        let func_name = format!("json_marshal_{}", struct_name.to_lowercase());
        self.write(&format!("// Automatic JSON marshal for struct {}\n", struct_name));
        self.write(&format!("char* {}({}* s) {{\n", func_name, struct_name));
        self.indent();
        self.writeln("static char buffer[16384];");
        self.writeln("strcpy(buffer, \"{\");");
        self.writeln("int first = 1;");
        
        for (i, (field_name, field_type)) in fields.iter().enumerate() {
            if i > 0 {
                self.writeln("if (!first) strcat(buffer, \", \");");
            }
            self.writeln("first = 0;");
            
            // Add field name (use JSON field name from tags if available)
            // For now, use field name directly - tags will be handled in validation
            self.writeln(&format!("strcat(buffer, \"\\\"{}\\\":\");", field_name));
            
            // Generate code to marshal the field value based on type
            match field_type {
                crate::ast::Type::Int => {
                    self.writeln(&format!("char val_str[64];"));
                    self.writeln(&format!("snprintf(val_str, sizeof(val_str), \"%d\", s->{});", field_name));
                    self.writeln(&format!("strcat(buffer, val_str);"));
                }
                crate::ast::Type::Float => {
                    self.writeln(&format!("char val_str[64];"));
                    self.writeln(&format!("snprintf(val_str, sizeof(val_str), \"%.6g\", s->{});", field_name));
                    self.writeln(&format!("strcat(buffer, val_str);"));
                }
                crate::ast::Type::String => {
                    self.writeln(&format!("if (s->{}) {{", field_name));
                    self.writeln(&format!("    strcat(buffer, json_escape(s->{}));", field_name));
                    self.writeln(&format!("}} else {{"));
                    self.writeln(&format!("    strcat(buffer, \"null\");"));
                    self.writeln(&format!("}}"));
                }
                crate::ast::Type::Bool => {
                    self.writeln(&format!("strcat(buffer, s->{} ? \"true\" : \"false\");", field_name));
                }
                crate::ast::Type::Struct { name: nested_struct } => {
                    // Recursive call for nested structs
                    let nested_func = format!("json_marshal_{}", nested_struct.to_lowercase());
                    self.writeln(&format!("char* nested_json = {}(&s->{});", nested_func, field_name));
                    self.writeln(&format!("strcat(buffer, nested_json);"));
                }
                crate::ast::Type::Slice { element_type } => {
                    // Handle slices
                    self.writeln(&format!("if (s->{}) {{", field_name));
                    self.writeln(&format!("    char* slice_json = json_MarshalSliceEnhanced(s->{}, \"{}\");", 
                        field_name, self.get_type_string_for_json(element_type)));
                    self.writeln(&format!("    strcat(buffer, slice_json);"));
                    self.writeln(&format!("}} else {{"));
                    self.writeln(&format!("    strcat(buffer, \"[]\");"));
                    self.writeln(&format!("}}"));
                }
                crate::ast::Type::Array { size: _, element_type } => {
                    // Handle arrays - convert to slice-like format
                    self.writeln(&format!("strcat(buffer, \"[\");"));
                    self.writeln(&format!("for (int i = 0; i < (int)(sizeof(s->{}) / sizeof(s->{}[0])); i++) {{", field_name, field_name));
                    self.writeln(&format!("    if (i > 0) strcat(buffer, \", \");"));
                    let elem_type_str = self.get_type_string_for_json(element_type);
                    match elem_type_str.as_str() {
                        "int" => {
                            self.writeln(&format!("    char elem_str[64];"));
                            self.writeln(&format!("    snprintf(elem_str, sizeof(elem_str), \"%d\", s->{}[i]);", field_name));
                            self.writeln(&format!("    strcat(buffer, elem_str);"));
                        }
                        "string" => {
                            self.writeln(&format!("    if (s->{}[i]) {{", field_name));
                            self.writeln(&format!("        strcat(buffer, json_escape(s->{}[i]));", field_name));
                            self.writeln(&format!("    }} else {{"));
                            self.writeln(&format!("        strcat(buffer, \"null\");"));
                            self.writeln(&format!("    }}"));
                        }
                        _ => {
                            self.writeln(&format!("    strcat(buffer, \"null\");"));
                        }
                    }
                    self.writeln(&format!("}}"));
                    self.writeln(&format!("strcat(buffer, \"]\");"));
                }
                _ => {
                    self.writeln(&format!("strcat(buffer, \"null\");"));
                }
            }
        }
        
        self.writeln("strcat(buffer, \"}\");");
        self.writeln("return buffer;");
        self.dedent();
        self.writeln("}\n");
    }
    
    fn generate_struct_schema_validation(&mut self, struct_name: &str, fields: &[(String, crate::ast::Type, Option<String>)]) {
        // Generate schema validation function from struct tags
        // Function: json_validate_<structname>(json) -> error
        let func_name = format!("json_validate_{}", struct_name.to_lowercase());
        
        self.write(&format!("// Automatic schema validation for struct {}\n", struct_name));
        self.write(&format!("// Generated from struct tags\n"));
        self.write(&format!("char* {}(const char* json) {{\n", func_name));
        self.indent();
        
        // First validate JSON syntax
        self.writeln("char* syntax_err = json_Validate(json);");
        self.writeln("if (syntax_err) return syntax_err;");
        self.writeln("");
        
        // Build schema from struct tags
        let mut schema_parts = Vec::new();
        for (field_name, field_type, tags) in fields {
            // Extract JSON field name from tags
            let json_field_name = if let Some(tags_str) = tags {
                // Parse tags: `json:"fieldname" validate:"required"`
                // Extract json:"..." part
                if let Some(json_start) = tags_str.find("json:\"") {
                    let after_json = &tags_str[json_start + 6..];
                    if let Some(json_end) = after_json.find('"') {
                        after_json[..json_end].to_string()
                    } else {
                        field_name.clone() // Fallback to field name
                    }
                } else {
                    field_name.clone() // No json tag, use field name
                }
            } else {
                field_name.clone() // No tags, use field name
            };
            
            // Determine type string
            let type_str = match field_type {
                crate::ast::Type::String => "string",
                crate::ast::Type::Int => "int",
                crate::ast::Type::Float => "float",
                crate::ast::Type::Bool => "bool",
                crate::ast::Type::Array { .. } => "array",
                crate::ast::Type::Slice { .. } => "array",
                crate::ast::Type::Struct { .. } => "object",
                crate::ast::Type::Map { .. } => "object",
                crate::ast::Type::Any => "object", // interface{} - any type
                _ => "string", // Default
            };
            
            schema_parts.push(format!("{}:{}", json_field_name, type_str));
        }
        
        let schema_str = schema_parts.join(",");
        self.writeln(&format!("const char* schema = \"{}\";", schema_str));
        self.writeln("return json_ValidateSchema(json, schema);");
        self.dedent();
        self.writeln("}\n");
    }
    
    fn generate_struct_json_unmarshal(&mut self, struct_name: &str, fields: &[(String, crate::ast::Type)]) {
        // Generate automatic JSON unmarshal function for a struct
        let func_name = format!("json_unmarshal_{}", struct_name.to_lowercase());
        self.write(&format!("// Automatic JSON unmarshal for struct {}\n", struct_name));
        self.write(&format!("{}* {}(const char* json) {{\n", struct_name, func_name));
        self.indent();
        self.writeln(&format!("{}* s = ({}*)malloc(sizeof({}));", struct_name, struct_name, struct_name));
        self.writeln("if (!s) return NULL;");
        self.writeln("");
        self.writeln("// Initialize all fields to zero");
        self.writeln("memset(s, 0, sizeof(*s));");
        self.writeln("");
        
        for (field_name, field_type) in fields {
            self.writeln(&format!("// Unmarshal field: {}", field_name));
            
            match field_type {
                crate::ast::Type::Int => {
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = json_UnmarshalInt({}_json);", field_name, field_name));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Float => {
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = json_UnmarshalFloat({}_json);", field_name, field_name));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::String => {
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = json_UnmarshalString({}_json);", field_name, field_name));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Bool => {
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = json_UnmarshalBool({}_json);", field_name, field_name));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Struct { name: nested_struct } => {
                    // Recursive call for nested structs
                    let nested_func = format!("json_unmarshal_{}", nested_struct.to_lowercase());
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = *{}({}_json);", field_name, nested_func, field_name));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Slice { element_type } => {
                    let elem_type_str = self.get_type_string_for_json(element_type);
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    s->{} = json_UnmarshalArray({}_json, \"{}\");", field_name, field_name, elem_type_str));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Array { size: arr_size, element_type } => {
                    // Arrays are fixed-size, so we need to handle them differently
                    // For now, treat as slice and copy elements
                    let elem_type_str = self.get_type_string_for_json(element_type);
                    self.writeln(&format!("const char* {}_json = json_GetObjectValue(json, \"{}\");", field_name, field_name));
                    self.writeln(&format!("if ({}_json) {{", field_name));
                    self.writeln(&format!("    Slice* temp_slice = json_UnmarshalArray({}_json, \"{}\");", field_name, elem_type_str));
                    self.writeln(&format!("    if (temp_slice) {{"));
                    self.writeln(&format!("        // Copy elements to array (limit to array size)"));
                    self.writeln(&format!("        int copy_len = temp_slice->len < {} ? temp_slice->len : {};", arr_size, arr_size));
                    let elem_c_type = match element_type.as_ref() {
                        crate::ast::Type::Int => "int",
                        crate::ast::Type::Float => "double",
                        crate::ast::Type::String => "char*",
                        crate::ast::Type::Bool => "int",
                        _ => "void",
                    };
                    self.writeln(&format!("        memcpy(s->{}, temp_slice->data, copy_len * sizeof({}));", field_name, elem_c_type));
                    self.writeln(&format!("        free(temp_slice->data);"));
                    self.writeln(&format!("        free(temp_slice);"));
                    self.writeln(&format!("    }}"));
                    self.writeln(&format!("    free((void*){}_json);", field_name));
                    self.writeln("}");
                }
                _ => {
                    self.writeln(&format!("// Field {}: type not yet supported for unmarshaling", field_name));
                }
            }
            self.writeln("");
        }
        
        self.writeln("return s;");
        self.dedent();
        self.writeln("}\n");
    }
    
    /// After all code is generated, check which structs satisfy which interfaces
    /// and generate vtable initialization code
    fn generate_interface_vtables(&mut self, statements: &[Stmt]) {
        // Find all struct definitions
        let structs: Vec<&str> = statements.iter()
            .filter_map(|stmt| {
                if let Stmt::StructDef { name, .. } = stmt {
                    Some(name.as_str())
                } else {
                    None
                }
            })
            .collect();
        
        // Clone interfaces to avoid borrow conflict
        let interfaces: Vec<(String, Vec<(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)>)> = 
            self.interfaces.iter()
                .map(|(k, v)| (k.clone(), v.clone()))
                .collect();
        
        // For each interface, check which structs satisfy it
        for (interface_name, interface_methods) in &interfaces {
            for struct_name in &structs {
                if self.check_interface_satisfaction(struct_name, interface_name, interface_methods) {
                    // Generate vtable for this struct implementing this interface
                    self.generate_struct_interface_vtable(struct_name, interface_name, interface_methods);
                }
            }
        }
    }
    
    fn get_type_string_for_json(&self, typ: &crate::ast::Type) -> String {
        match typ {
            crate::ast::Type::Int => "int".to_string(),
            crate::ast::Type::Float => "float".to_string(),
            crate::ast::Type::String => "string".to_string(),
            crate::ast::Type::Bool => "bool".to_string(),
            crate::ast::Type::Slice { element_type } => {
                format!("slice_{}", self.get_type_string_for_json(element_type))
            }
            crate::ast::Type::Array { element_type, .. } => {
                self.get_type_string_for_json(element_type)
            }
            _ => "unknown".to_string(),
        }
    }
    
    fn generate_struct_protobuf_marshal(&mut self, struct_name: &str, fields: &[(String, crate::ast::Type)]) {
        // Generate automatic Protobuf marshal function for a struct
        let func_name = format!("protobuf_marshal_{}", struct_name.to_lowercase());
        self.write(&format!("// Automatic Protobuf marshal for struct {}\n", struct_name));
        self.write(&format!("char* {}({}* s, size_t* out_size) {{\n", func_name, struct_name));
        self.indent();
        self.writeln("if (!s || !out_size) return NULL;");
        self.writeln("");
        self.writeln("ProtobufBuffer* buf = protobuf_buffer_new(256);");
        self.writeln("if (!buf) return NULL;");
        self.writeln("");
        
        for (field_num, (field_name, field_type)) in fields.iter().enumerate() {
            let field_number = field_num + 1; // Protobuf field numbers start at 1
            
            // Generate code to encode each field based on type
            match field_type {
                crate::ast::Type::Int => {
                    self.writeln(&format!("// Field {}: {} (int32)", field_number, field_name));
                    self.writeln(&format!("protobuf_encode_tag(buf, {}, PROTOBUF_WIRE_VARINT);", field_number));
                    self.writeln(&format!("protobuf_encode_int32(buf, s->{});", field_name));
                }
                crate::ast::Type::Float => {
                    self.writeln(&format!("// Field {}: {} (float)", field_number, field_name));
                    self.writeln(&format!("protobuf_encode_tag(buf, {}, PROTOBUF_WIRE_FIXED32);", field_number));
                    self.writeln(&format!("protobuf_encode_float(buf, s->{});", field_name));
                }
                crate::ast::Type::String => {
                    self.writeln(&format!("// Field {}: {} (string)", field_number, field_name));
                    self.writeln(&format!("if (s->{}) {{", field_name));
                    self.writeln(&format!("    protobuf_encode_tag(buf, {}, PROTOBUF_WIRE_LENGTH_DELIMITED);", field_number));
                    self.writeln(&format!("    protobuf_encode_string(buf, s->{});", field_name));
                    self.writeln("}");
                }
                crate::ast::Type::Bool => {
                    self.writeln(&format!("// Field {}: {} (bool)", field_number, field_name));
                    self.writeln(&format!("protobuf_encode_tag(buf, {}, PROTOBUF_WIRE_VARINT);", field_number));
                    self.writeln(&format!("protobuf_encode_bool(buf, s->{});", field_name));
                }
                crate::ast::Type::Struct { name: nested_struct } => {
                    // Recursive call for nested structs
                    let nested_func = format!("protobuf_marshal_{}", nested_struct.to_lowercase());
                    self.writeln(&format!("// Field {}: {} (nested struct {})", field_number, field_name, nested_struct));
                    self.writeln(&format!("size_t nested_size;"));
                    self.writeln(&format!("char* nested_data = {}(&s->{}, &nested_size);", nested_func, field_name));
                    self.writeln(&format!("if (nested_data) {{"));
                    self.writeln(&format!("    protobuf_encode_tag(buf, {}, PROTOBUF_WIRE_LENGTH_DELIMITED);", field_number));
                    self.writeln(&format!("    protobuf_encode_varint(buf, nested_size);"));
                    self.writeln(&format!("    protobuf_buffer_ensure(buf, nested_size);"));
                    self.writeln(&format!("    memcpy(buf->data + buf->size, nested_data, nested_size);"));
                    self.writeln(&format!("    buf->size += nested_size;"));
                    self.writeln(&format!("    free(nested_data);"));
                    self.writeln("}");
                }
                _ => {
                    self.writeln(&format!("// Field {}: {} - type not yet supported for protobuf", field_number, field_name));
                }
            }
            self.writeln("");
        }
        
        self.writeln("char* result = protobuf_Marshal(buf);");
        self.writeln("*out_size = protobuf_Size(buf);");
        self.writeln("protobuf_buffer_free(buf);");
        self.writeln("return result;");
        self.dedent();
        self.writeln("}\n");
    }
    
    fn generate_struct_protobuf_unmarshal(&mut self, struct_name: &str, fields: &[(String, crate::ast::Type)]) {
        // Generate automatic Protobuf unmarshal function for a struct
        let func_name = format!("protobuf_unmarshal_{}", struct_name.to_lowercase());
        self.write(&format!("// Automatic Protobuf unmarshal for struct {}\n", struct_name));
        self.write(&format!("{}* {}(const char* data, size_t len) {{\n", struct_name, func_name));
        self.indent();
        self.writeln(&format!("if (!data || len == 0) return NULL;"));
        self.writeln("");
        self.writeln(&format!("{}* s = ({}*)malloc(sizeof({}));", struct_name, struct_name, struct_name));
        self.writeln("if (!s) return NULL;");
        self.writeln("");
        self.writeln("// Initialize all fields to zero");
        self.writeln("memset(s, 0, sizeof(*s));");
        self.writeln("");
        self.writeln("ProtobufBuffer* buf = protobuf_Unmarshal(data, len);");
        self.writeln("if (!buf) { free(s); return NULL; }");
        self.writeln("");
        
        // Decode fields by reading tags
        self.writeln("int field_num, wire_type;");
        self.writeln("while (protobuf_decode_tag(buf, &field_num, &wire_type)) {");
        self.indent();
        self.writeln("switch (field_num) {");
        
        for (field_num, (field_name, field_type)) in fields.iter().enumerate() {
            let field_number = field_num + 1;
            self.writeln(&format!("case {}:  // {}", field_number, field_name));
            self.indent();
            
            match field_type {
                crate::ast::Type::Int => {
                    self.writeln("if (wire_type == PROTOBUF_WIRE_VARINT) {");
                    self.writeln(&format!("    protobuf_decode_int32(buf, &s->{});", field_name));
                    self.writeln("}");
                    self.writeln("break;");
                }
                crate::ast::Type::Float => {
                    self.writeln("if (wire_type == PROTOBUF_WIRE_FIXED32) {");
                    self.writeln(&format!("    protobuf_decode_float(buf, &s->{});", field_name));
                    self.writeln("}");
                    self.writeln("break;");
                }
                crate::ast::Type::String => {
                    self.writeln("if (wire_type == PROTOBUF_WIRE_LENGTH_DELIMITED) {");
                    self.writeln(&format!("    s->{} = protobuf_decode_string(buf);", field_name));
                    self.writeln("}");
                    self.writeln("break;");
                }
                crate::ast::Type::Bool => {
                    self.writeln("if (wire_type == PROTOBUF_WIRE_VARINT) {");
                    self.writeln(&format!("    int temp_bool;"));
                    self.writeln(&format!("    protobuf_decode_bool(buf, &temp_bool);"));
                    self.writeln(&format!("    s->{} = temp_bool;", field_name));
                    self.writeln("}");
                    self.writeln("break;");
                }
                crate::ast::Type::Struct { name: nested_struct } => {
                    // Recursive call for nested structs
                    let nested_func = format!("protobuf_unmarshal_{}", nested_struct.to_lowercase());
                    self.writeln("if (wire_type == PROTOBUF_WIRE_LENGTH_DELIMITED) {");
                    self.writeln("    uint64_t nested_len;");
                    self.writeln("    if (protobuf_decode_varint(buf, &nested_len) && buf->pos + nested_len <= buf->size) {");
                    self.writeln(&format!("        s->{} = {}((const char*)(buf->data + buf->pos), (size_t)nested_len);", field_name, nested_func));
                    self.writeln("        buf->pos += (size_t)nested_len;");
                    self.writeln("    }");
                    self.writeln("}");
                    self.writeln("break;");
                }
                _ => {
                    self.writeln("// Type not yet supported");
                    self.writeln("break;");
                }
            }
            self.dedent();
        }
        
        self.writeln("default:");
        self.indent();
        self.writeln("// Unknown field - skip it based on wire type");
        self.writeln("if (wire_type == PROTOBUF_WIRE_VARINT) {");
        self.writeln("    uint64_t dummy;");
        self.writeln("    protobuf_decode_varint(buf, &dummy);");
        self.writeln("} else if (wire_type == PROTOBUF_WIRE_FIXED32) {");
        self.writeln("    buf->pos += 4;");
        self.writeln("} else if (wire_type == PROTOBUF_WIRE_FIXED64) {");
        self.writeln("    buf->pos += 8;");
        self.writeln("} else if (wire_type == PROTOBUF_WIRE_LENGTH_DELIMITED) {");
        self.writeln("    uint64_t len;");
        self.writeln("    if (protobuf_decode_varint(buf, &len)) {");
        self.writeln("        buf->pos += (size_t)len;");
        self.writeln("    }");
        self.writeln("}");
        self.writeln("break;");
        self.dedent();
        self.writeln("}");
        self.dedent();
        self.writeln("}");
        self.writeln("");
        self.writeln("protobuf_buffer_free(buf);");
        self.writeln("return s;");
        self.dedent();
        self.writeln("}\n");
    }
    
    /// Generate interface constructor function that creates interface from struct
    /// This function automatically populates the vtable if the struct implements all required methods
    fn generate_interface_constructor(&mut self, interface_name: &str, _methods: &[(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)]) {
        // Generate constructor: InterfaceName NewInterfaceName(void* data)
        // This will be called automatically when converting a struct to an interface
        let constructor_name = format!("New{}", interface_name);
        self.write(&format!("// Constructor for {} interface\n", interface_name));
        self.write(&format!("// Automatically creates interface from implementing struct\n"));
        self.write(&format!("{}* {}(void* data) {{\n", interface_name, constructor_name));
        self.indent();
        self.writeln(&format!("if (!data) return NULL;"));
        self.writeln(&format!("{}* iface = ({}*)malloc(sizeof({}));", interface_name, interface_name, interface_name));
        self.writeln(&format!("if (!iface) return NULL;"));
        self.writeln(&format!("iface->vtable = NULL;  // Will be populated by struct-specific constructors"));
        self.writeln(&format!("iface->data = data;"));
        self.writeln(&format!("return iface;"));
        self.dedent();
        self.writeln("}\n");
    }
    
    /// Check if a struct satisfies an interface by verifying all required methods exist
    /// This is called during code generation to verify interface satisfaction
    fn check_interface_satisfaction(&self, struct_name: &str, _interface_name: &str, interface_methods: &[(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)]) -> bool {
        // Check if struct has all required methods
        // Method names should be in format: StructName_MethodName
        for (method_name, expected_params, expected_return) in interface_methods {
            let _struct_method_name = format!("{}_{}", struct_name, method_name);
            // Check if this method exists in struct_methods
            if let Some(method_sigs) = self.struct_methods.get(struct_name) {
                // Find matching method
                let found = method_sigs.iter().any(|(actual_method_name, actual_params, actual_return)| {
                    // Method name should match (without struct prefix in comparison)
                    if actual_method_name != method_name {
                        return false;
                    }
                    // Check parameter count (first param is usually self pointer, so skip it)
                    let actual_param_count = if actual_params.len() > 0 && 
                        matches!(actual_params[0].1, crate::ast::Type::Pointer(_)) {
                        actual_params.len() - 1
                    } else {
                        actual_params.len()
                    };
                    if actual_param_count != expected_params.len() {
                        return false;
                    }
                    // Check return type
                    actual_return == expected_return
                });
                if !found {
                    return false;
                }
            } else {
                // No methods found for this struct
                return false;
            }
        }
        true
    }
    
    /// Generate vtable initialization for a struct implementing an interface
    fn generate_struct_interface_vtable(&mut self, struct_name: &str, interface_name: &str, methods: &[(String, Vec<(String, crate::ast::Type)>, Option<crate::ast::Type>)]) {
        let vtable_name = format!("{}_vtable_{}", struct_name.to_lowercase(), interface_name.to_lowercase());
        self.write(&format!("// Vtable for {} implementing {}\n", struct_name, interface_name));
        self.write(&format!("// Automatically generated - struct {} satisfies interface {}\n", struct_name, interface_name));
        self.write(&format!("static {}_vtable {} = {{\n", interface_name, vtable_name));
        self.indent();
        
        for (i, (method_name, _params, _return_type)) in methods.iter().enumerate() {
            let struct_method_name = format!("{}_{}", struct_name, method_name);
            if i > 0 {
                self.write(",\n");
            }
            self.write(&format!("    .{} = ({}){}", method_name, 
                // Cast to function pointer type (simplified - actual type would be more complex)
                "void*", struct_method_name));
        }
        self.write("\n");
        self.dedent();
        self.writeln("};\n");
        
        // Generate constructor that uses this vtable
        let constructor_name = format!("New{}_{}", struct_name, interface_name);
        self.write(&format!("// Constructor: {} as {}\n", struct_name, interface_name));
        self.write(&format!("// Usage: {}* iface = {}(&struct_instance);\n", interface_name, constructor_name));
        self.write(&format!("{}* {}({}* s) {{\n", interface_name, constructor_name, struct_name));
        self.indent();
        self.writeln(&format!("if (!s) return NULL;"));
        self.writeln(&format!("{}* iface = ({}*)malloc(sizeof({}));", interface_name, interface_name, interface_name));
        self.writeln(&format!("if (!iface) return NULL;"));
        self.writeln(&format!("iface->vtable = &{};", vtable_name));
        self.writeln(&format!("iface->data = (void*)s;"));
        self.writeln(&format!("return iface;"));
        self.dedent();
        self.writeln("}\n");
    }
}

impl Default for CodeGenerator {
    fn default() -> Self {
        Self::new()
    }
}
