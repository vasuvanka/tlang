// args - Command-line arguments library
// Similar to os.Args in Go

pub fn generate_args_lib() -> String {
    let mut code = String::new();
    
    // Global argc and argv
    code.push_str("// Global command-line arguments\n");
    code.push_str("static int g_argc = 0;\n");
    code.push_str("static char** g_argv = NULL;\n\n");
    
    // args.Init - Initialize arguments (called from main)
    code.push_str("// args.Init - Initialize arguments (called from main)\n");
    code.push_str("void args_Init(int argc, char** argv) {\n");
    code.push_str("    g_argc = argc;\n");
    code.push_str("    g_argv = argv;\n");
    code.push_str("}\n\n");
    
    // args.Count - Get number of arguments
    code.push_str("// args.Count - Get number of arguments\n");
    code.push_str("int args_Count() {\n");
    code.push_str("    return g_argc;\n");
    code.push_str("}\n\n");
    
    // args.Get - Get argument at index
    code.push_str("// args.Get - Get argument at index (0 = program name)\n");
    code.push_str("char* args_Get(int index) {\n");
    code.push_str("    if (index < 0 || index >= g_argc) {\n");
    code.push_str("        return \"\";\n");
    code.push_str("    }\n");
    code.push_str("    return g_argv[index];\n");
    code.push_str("}\n\n");
    
    // args.Program - Get program name (args[0])
    code.push_str("// args.Program - Get program name (args[0])\n");
    code.push_str("char* args_Program() {\n");
    code.push_str("    return args_Get(0);\n");
    code.push_str("}\n\n");
    
    code
}
