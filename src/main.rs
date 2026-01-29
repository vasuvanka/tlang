use std::env;
use std::fs;
use std::process;
use std::process::Command;
use tlang::lexer::Lexer;
use tlang::parser::Parser;
use tlang::codegen::CodeGenerator;
use tlang::package::PackageResolver;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    // Handle version flag
    if args.len() > 1 && (args[1] == "--version" || args[1] == "-v" || args[1] == "version") {
        println!("{}", env!("CARGO_PKG_VERSION"));
        process::exit(0);
    }
    
    // Handle subcommands: "run", "build", "compile" - track which one
    let mut arg_idx = 1;
    let command = if args.len() > arg_idx {
        let cmd = &args[arg_idx];
        if cmd == "run" || cmd == "build" || cmd == "compile" {
            arg_idx += 1;
            Some(cmd.clone())
        } else {
            None
        }
    } else {
        None
    };
    
    if args.len() <= arg_idx {
        eprintln!("Usage: tlangc [run|build|compile] <input_file> [output_file]");
        eprintln!("       tlangc --version  Show version");
        eprintln!("\nCommands:");
        eprintln!("  compile  Compile to C and then to executable binary");
        eprintln!("  run      Compile to C only (for running with tlang run)");
        eprintln!("  build    Compile to C only (for build system)");
        eprintln!("\nExamples:");
        eprintln!("  tlangc program.tl              # Compile to output.c");
        eprintln!("  tlangc compile program.tl      # Compile to executable");
        eprintln!("  tlangc compile program.tl app # Compile to app.exe");
        process::exit(1);
    }
    
    let filename = &args[arg_idx];
    let source = match fs::read_to_string(filename) {
        Ok(content) => content,
        Err(e) => {
            eprintln!("Error reading file {}: {}", filename, e);
            process::exit(1);
        }
    };
    
    // Lexical analysis
    let lexer = Lexer::new_with_filename(&source, filename.clone());
    let mut parser = Parser::new(lexer);
    
    // Parse main program
    let program = match parser.parse() {
        Ok(prog) => prog,
        Err(e) => {
            eprintln!("\n{}", e);
            // Print source context if available
            if let Some(line) = source.lines().nth(e.get_location().line.saturating_sub(1)) {
                eprintln!("\n  {} | {}", e.get_location().line, line);
                eprintln!("  {} | {:>width$}", "", "^".repeat(e.get_location().column), width = e.get_location().column + 3);
            }
            process::exit(1);
        }
    };
    
    // Resolve packages
    let mut resolver = PackageResolver::new(filename);
    let imported_packages = match resolver.resolve_imports(&program) {
        Ok(packages) => packages,
        Err(e) => {
            eprintln!("\n{}", e);
            process::exit(1);
        }
    };
    
    // Code generation
    let mut codegen = CodeGenerator::new();
    // Set source filename for debug symbol generation (#line directives)
    codegen.set_source_filename(filename.clone());
    let output = codegen.generate_with_packages(&program, &imported_packages);
    
    // Determine output file names
    let output_c_file = if args.len() > arg_idx + 1 {
        let user_output = &args[arg_idx + 1];
        // If user provided output without .c extension and command is compile, add .c for intermediate file
        if command.as_ref().map(|c| c == "compile").unwrap_or(false) && !user_output.ends_with(".c") {
            // Use a temporary .c filename, binary will use the user's name
            format!("{}.c", user_output)
        } else {
            user_output.clone()
        }
    } else {
        "output.c".to_string()
    };
    
    // Write C file
    match fs::write(&output_c_file, output) {
        Ok(_) => {
            // Get absolute path of the C file
            let absolute_c_path = match std::fs::canonicalize(&output_c_file) {
                Ok(path) => path.display().to_string(),
                Err(_) => {
                    match std::env::current_dir() {
                        Ok(cwd) => cwd.join(&output_c_file).display().to_string(),
                        Err(_) => output_c_file.clone(),
                    }
                }
            };
            println!("Compiled to C: {}", absolute_c_path);
        }
        Err(e) => {
            eprintln!("Error writing output file: {}", e);
            process::exit(1);
        }
    }
    
    // If command is "compile", also compile C to binary
    if command.as_ref().map(|c| c == "compile").unwrap_or(false) {
        // Determine binary name
        let binary_name = if args.len() > arg_idx + 1 {
            let user_output = &args[arg_idx + 1];
            // Remove .c extension if present
            if user_output.ends_with(".c") {
                user_output.trim_end_matches(".c")
            } else {
                user_output
            }
        } else {
            // Default: remove .c from output_c_file
            if output_c_file.ends_with(".c") {
                output_c_file.trim_end_matches(".c")
            } else {
                "output"
            }
        };
        
        let binary_path = if cfg!(windows) {
            format!("{}.exe", binary_name)
        } else {
            binary_name.to_string()
        };
        
        // Find C compiler
        let compiler = find_c_compiler();
        if compiler.is_none() {
            // Get absolute path for warning message
            let absolute_c_path = match std::fs::canonicalize(&output_c_file) {
                Ok(path) => path.display().to_string(),
                Err(_) => {
                    match std::env::current_dir() {
                        Ok(cwd) => cwd.join(&output_c_file).display().to_string(),
                        Err(_) => output_c_file.clone(),
                    }
                }
            };
            eprintln!("Warning: No C compiler found. C file generated but binary not compiled.");
            eprintln!("Install gcc, clang, or MSVC to compile to binary.");
            eprintln!("C file available at: {}", absolute_c_path);
            process::exit(0);
        }
        let compiler = compiler.unwrap();
        
        println!("Compiling C to binary using {}...", compiler);
        
        // Compile C to binary
        let mut cmd = Command::new(&compiler);
        cmd.arg("-o").arg(&binary_path);
        cmd.arg(&output_c_file);
        cmd.arg("-lm"); // Math library
        
        if cfg!(windows) {
            cmd.arg("-lws2_32");
        }

        // Add OpenSSL libraries (try, but don't fail if not available)
        // Check if the generated C code uses OpenSSL
        let c_content = fs::read_to_string(&output_c_file).unwrap_or_default();
        if c_content.contains("USE_OPENSSL") { // Only link if USE_OPENSSL is actually defined/used
             if !cfg!(windows) {
                cmd.arg("-lssl").arg("-lcrypto");
             }
        }
        
        match cmd.output() {
            Ok(output) => {
                if output.status.success() {
                    // Get absolute path of the binary
                    let absolute_binary_path = match std::fs::canonicalize(&binary_path) {
                        Ok(path) => path.display().to_string(),
                        Err(_) => {
                            // If canonicalize fails (file might not exist yet or path issues),
                            // try to get absolute path from current directory
                            match std::env::current_dir() {
                                Ok(cwd) => cwd.join(&binary_path).display().to_string(),
                                Err(_) => binary_path.clone(),
                            }
                        }
                    };
                    println!("✓ Binary compiled successfully!");
                    println!("  Binary location: {}", absolute_binary_path);
                    // Optionally clean up intermediate C file (user can keep it if they want)
                    // fs::remove_file(&output_c_file).ok(); // Uncomment to auto-delete .c file
                } else {
                    let stderr = String::from_utf8_lossy(&output.stderr);
                    eprintln!("✗ C compilation failed:");
                    eprintln!("{}", stderr);
                    // Get absolute path for error message
                    let absolute_c_path = match std::fs::canonicalize(&output_c_file) {
                        Ok(path) => path.display().to_string(),
                        Err(_) => {
                            match std::env::current_dir() {
                                Ok(cwd) => cwd.join(&output_c_file).display().to_string(),
                                Err(_) => output_c_file.clone(),
                            }
                        }
                    };
                    eprintln!("\nC file is available at: {}", absolute_c_path);
                    process::exit(1);
                }
            }
            Err(e) => {
                eprintln!("Error running compiler: {}", e);
                // Get absolute path for error message
                let absolute_c_path = match std::fs::canonicalize(&output_c_file) {
                    Ok(path) => path.display().to_string(),
                    Err(_) => {
                        match std::env::current_dir() {
                            Ok(cwd) => cwd.join(&output_c_file).display().to_string(),
                            Err(_) => output_c_file.clone(),
                        }
                    }
                };
                eprintln!("C file is available at: {}", absolute_c_path);
                process::exit(1);
            }
        }
    } else {
        // Get absolute path for display
        let absolute_c_path = match std::fs::canonicalize(&output_c_file) {
            Ok(path) => path.display().to_string(),
            Err(_) => {
                match std::env::current_dir() {
                    Ok(cwd) => cwd.join(&output_c_file).display().to_string(),
                    Err(_) => output_c_file.clone(),
                }
            }
        };
        println!("Compilation successful! Output written to {}", absolute_c_path);
        if command.is_none() {
            println!("Use 'tlangc compile {}' to compile to binary.", output_c_file);
        }
    }
}

fn find_c_compiler() -> Option<String> {
    // Try gcc first
    if Command::new("gcc").arg("--version").output().is_ok() {
        return Some("gcc".to_string());
    }
    
    // Try clang
    if Command::new("clang").arg("--version").output().is_ok() {
        return Some("clang".to_string());
    }
    
    // Try cl on Windows (MSVC)
    if cfg!(windows) {
        if Command::new("cl").arg("/?").output().is_ok() {
            return Some("cl".to_string());
        }
    }
    
    None
}
