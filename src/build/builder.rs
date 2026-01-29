// Main build system - orchestrates compilation, caching, and bundling

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use crate::error::{CompileError, CompileResult};
use crate::lexer::Lexer;
use crate::parser::Parser;
use crate::codegen::CodeGenerator;
use crate::package::PackageResolver;
use crate::linter::{Linter, LintIssue, LintLevel};
use crate::formatter::Formatter;
use crate::borrow_checker::BorrowChecker;
use super::config::ProjectConfig;
use super::cache::BuildCache;
use super::dependencies::DependencyManager;
use super::lockfile::LockFile;

pub struct Builder {
    config: ProjectConfig,
    cache: BuildCache,
    project_root: PathBuf,
}

impl Builder {
    pub fn new<P: AsRef<Path>>(project_root: P) -> CompileResult<Self> {
        let root = project_root.as_ref().canonicalize().map_err(|e| {
            CompileError::codegen(format!("Invalid project root: {}", e), None)
        })?;
        
        let config = ProjectConfig::load(&root)?;
        let cache = BuildCache::new(&root);
        
        Ok(Builder {
            config,
            cache,
            project_root: root,
        })
    }
    
    /// Build the project - compile once, run anywhere
    pub fn build(&mut self) -> CompileResult<PathBuf> {
        println!("Building project: {}", self.config.package.name);
        
        // Load cache
        self.cache.load();
        
        // Find main file
        let main_file = self.config.get_main_file(&self.project_root);
        if !main_file.exists() {
            return Err(CompileError::codegen(
                format!("Main file not found: {}", main_file.display()),
                None,
            ));
        }
        
        // Extract dependencies and check if rebuild is needed (incremental compilation)
        let source_files = self.collect_source_files()?;
        
        // Extract dependencies from each source file
        for file in &source_files {
            match self.extract_file_dependencies(file) {
                Ok(deps) => {
                    self.cache.set_file_dependencies(file, deps);
                }
                Err(_) => {
                    // If we can't extract dependencies, assume file needs recompilation
                    // This can happen if file has parse errors - will be caught later
                }
            }
        }
        
        // Check build config hash
        let config_hash = match self.compute_config_hash() {
            Ok(h) => h,
            Err(_) => String::new(),
        };
        let config_changed = self.cache.is_config_changed(&config_hash);
        if config_changed {
            self.cache.set_config_hash(config_hash);
        }
        
        // Get files that need recompilation (changed files + dependents)
        use std::collections::HashSet;
        let files_to_recompile: HashSet<String> = if config_changed {
            // Config changed - rebuild everything
            source_files.iter().map(|f| f.to_string_lossy().to_string()).collect()
        } else {
            self.cache.get_files_to_recompile(&source_files)
        };
        
        let needs_rebuild = !files_to_recompile.is_empty();
        
        if !needs_rebuild && self.is_binary_up_to_date()? {
            println!("✓ No changes detected. Using cached build.");
            return Ok(self.get_binary_path());
        }
        
        if !files_to_recompile.is_empty() && files_to_recompile.len() < source_files.len() {
            println!("📦 Incremental compilation: {} of {} files need recompilation", 
                files_to_recompile.len(), source_files.len());
        }
        
        // Run linter before compilation
        println!("Linting...");
        let lint_issues = self.lint_all_files()?;
        let errors: Vec<&LintIssue> = lint_issues.iter().filter(|i| i.level == LintLevel::Error).collect();
        if !errors.is_empty() {
            eprintln!("\n✗ Linting failed with {} error(s):", errors.len());
            for issue in &errors {
                eprintln!("  {}:{}:{} [{}] {}", 
                    issue.location.filename,
                    issue.location.line,
                    issue.location.column,
                    issue.code,
                    issue.message
                );
            }
            return Err(CompileError::codegen(
                format!("Build aborted due to {} linting error(s)", errors.len()),
                None,
            ));
        }
        let warnings: Vec<&LintIssue> = lint_issues.iter().filter(|i| i.level == LintLevel::Warning).collect();
        if !warnings.is_empty() {
            println!("⚠ Found {} warning(s):", warnings.len());
            for issue in &warnings {
                println!("  {}:{}:{} [{}] {}", 
                    issue.location.filename,
                    issue.location.line,
                    issue.location.column,
                    issue.code,
                    issue.message
                );
            }
        }
        
        // Run borrow checker for ownership analysis
        println!("Checking ownership...");
        let borrow_errors = self.check_borrows()?;
        if !borrow_errors.is_empty() {
            eprintln!("\n✗ Borrow check failed with {} error(s):", borrow_errors.len());
            for error_msg in &borrow_errors {
                eprintln!("{}", error_msg);
            }
            return Err(CompileError::codegen(
                format!("Build aborted due to {} ownership error(s)", borrow_errors.len()),
                None,
            ));
        }
        
        // Check for circular dependencies
        println!("Checking dependencies...");
        self.check_circular_dependencies(&main_file)?;
        
        println!("Compiling...");
        
        // Resolve dependencies (including transitive)
        let mut dep_manager = DependencyManager::new(&self.project_root);
        let lock_file = LockFile::load(&self.project_root).ok();
        let (dependencies, new_lock) = dep_manager.resolve_all(
            &self.config.dependencies,
            lock_file.as_ref(),
            &self.config.ignore,
        )?;
        
        // Save updated lock file
        new_lock.save(&self.project_root)?;
        
        // Compile Tlang to C
        let c_file = self.compile_to_c(&main_file, &dependencies)?;
        
        // Compile C to binary with static linking
        let binary = self.compile_to_binary(&c_file)?;
        
        // Mark all source files as compiled
        for file in &source_files {
            self.cache.mark_compiled(file);
        }
        
        // Save cache
        self.cache.save();
        
        println!("Build complete: {}", binary.display());
        Ok(binary)
    }
    
    /// Extract dependencies (imports) from a source file
    fn extract_file_dependencies(&self, file: &Path) -> CompileResult<Vec<String>> {
        let source = fs::read_to_string(file).map_err(|e| {
            CompileError::codegen(format!("Failed to read source file: {}", e), None)
        })?;
        
        // Quick parse to extract imports only (lightweight)
        let lexer = Lexer::new_with_filename(&source, file.to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        
        // Parse just to get imports
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Parse error in {}: {}", file.display(), e), None)
        })?;
        
        let mut dependencies = Vec::new();
        
        // Extract import paths
        for import in &program.imports {
            // Resolve import to actual file path
            let resolver = PackageResolver::new(file.to_string_lossy().as_ref());
            // Try to resolve the import path
            // For built-in libraries, this will fail but that's OK
            let resolved_path: Result<PathBuf, String> = {
                // Use a helper closure to resolve the path
                // Since resolve_import_path is private, we'll use the file path directly
                // for non-builtin libraries, or mark as builtin
                if resolver.is_builtin_library(&import.path) {
                    Err(format!("Built-in library"))
                } else {
                    // For now, construct path manually
                    let current_dir = file.parent().unwrap_or(Path::new("."));
                    let import_file = current_dir.join(format!("{}.tl", import.path));
                    if import_file.exists() {
                        Ok(import_file)
                    } else {
                        Err(format!("Not found"))
                    }
                }
            };
            
            if let Ok(resolved_path) = resolved_path {
                if let Ok(canonical) = resolved_path.canonicalize() {
                    dependencies.push(canonical.to_string_lossy().to_string());
                } else {
                    dependencies.push(resolved_path.to_string_lossy().to_string());
                }
            } else {
                // Built-in library - use import path as dependency identifier
                dependencies.push(import.path.clone());
            }
        }
        
        Ok(dependencies)
    }
    
    /// Compute hash of build configuration
    fn compute_config_hash(&self) -> CompileResult<String> {
        use sha2::{Sha256, Digest};
        
        let mut hasher = Sha256::new();
        
        // Hash relevant build config fields
        hasher.update(self.config.build.output_dir.as_bytes());
        hasher.update(self.config.build.binary_name.as_bytes());
        hasher.update(self.config.build.optimize.as_bytes());
        let static_str = if self.config.build.static_link { "static" } else { "dynamic" };
        hasher.update(static_str.as_bytes());
        let debug_str = if self.config.build.debug { "debug" } else { "nodebug" };
        hasher.update(debug_str.as_bytes());
        
        // Hash compiler flags
        for flag in &self.config.build.compiler_flags {
            hasher.update(flag.as_bytes());
        }
        
        // Hash linker flags
        for flag in &self.config.build.linker_flags {
            hasher.update(flag.as_bytes());
        }
        
        let hash = hasher.finalize();
        Ok(format!("{:x}", hash))
    }
    
    /// Collect all source files in the project
    fn collect_source_files(&self) -> CompileResult<Vec<PathBuf>> {
        let mut files = Vec::new();
        
        // Add main file
        let main_file = self.config.get_main_file(&self.project_root);
        if main_file.exists() {
            files.push(main_file);
        }
        
        // Find all .tl files in project
        self.collect_tl_files(&self.project_root, &mut files)?;
        
        Ok(files)
    }
    
    fn collect_tl_files<P: AsRef<Path>>(&self, dir: P, files: &mut Vec<PathBuf>) -> CompileResult<()> {
        let dir = dir.as_ref();
        
        if !dir.is_dir() {
            return Ok(());
        }
        
        for entry in fs::read_dir(dir).map_err(|e| {
            CompileError::codegen(format!("Failed to read directory: {}", e), None)
        })? {
            let entry = entry.map_err(|e| {
                CompileError::codegen(format!("Failed to read directory entry: {}", e), None)
            })?;
            let path = entry.path();
            
            if path.is_dir() && !path.ends_with("target") && !path.ends_with(".tlang_cache") {
                self.collect_tl_files(&path, files)?;
            } else if path.extension().and_then(|s| s.to_str()) == Some("tl") {
                files.push(path);
            }
        }
        
        Ok(())
    }
    
    /// Check if binary is up to date
    fn is_binary_up_to_date(&self) -> CompileResult<bool> {
        let binary = self.get_binary_path();
        if !binary.exists() {
            return Ok(false);
        }
        
        // Check if binary is newer than all source files
        let binary_meta = fs::metadata(&binary).map_err(|e| {
            CompileError::codegen(format!("Failed to read binary metadata: {}", e), None)
        })?;
        let binary_time = binary_meta.modified().unwrap_or(std::time::SystemTime::UNIX_EPOCH);
        
        let source_files = self.collect_source_files()?;
        for file in source_files {
            let file_meta = fs::metadata(&file).map_err(|e| {
                CompileError::codegen(format!("Failed to read file metadata: {}", e), None)
            })?;
            let file_time = file_meta.modified().unwrap_or(std::time::SystemTime::UNIX_EPOCH);
            
            if file_time > binary_time {
                return Ok(false);
            }
        }
        
        Ok(true)
    }
    
    /// Compile Tlang source to C
    fn compile_to_c(&self, main_file: &Path, _dependencies: &[crate::package::PackageInfo]) -> CompileResult<PathBuf> {
        let source = fs::read_to_string(main_file).map_err(|e| {
            CompileError::codegen(format!("Failed to read source file: {}", e), None)
        })?;
        
        // Parse
        let lexer = Lexer::new_with_filename(&source, main_file.to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Parse error: {}", e), None)
        })?;
        
        // Resolve packages
        let mut resolver = PackageResolver::new(main_file.to_string_lossy().as_ref());
        let imported_packages = resolver.resolve_imports(&program).map_err(|e| {
            CompileError::codegen(format!("Package resolution error: {}", e), None)
        })?;
        
        // Generate C code
        let mut codegen = CodeGenerator::new();
        codegen.set_source_filename(main_file.to_string_lossy().to_string());
        let c_code = codegen.generate_with_packages(&program, &imported_packages);
        
        // Write to output directory
        let output_dir = self.project_root.join(&self.config.build.output_dir);
        fs::create_dir_all(&output_dir).map_err(|e| {
            CompileError::codegen(format!("Failed to create output directory: {}", e), None)
        })?;
        
        let c_file = output_dir.join("output.c");
        fs::write(&c_file, c_code).map_err(|e| {
            CompileError::codegen(format!("Failed to write C file: {}", e), None)
        })?;
        
        Ok(c_file)
    }
    
    /// Compile C to static binary (compile once, run anywhere)
    fn compile_to_binary(&self, c_file: &Path) -> CompileResult<PathBuf> {
        let output_dir = self.project_root.join(&self.config.build.output_dir);
        let binary_name = if cfg!(windows) {
            format!("{}.exe", self.config.build.binary_name)
        } else {
            self.config.build.binary_name.clone()
        };
        let binary_path = output_dir.join(&binary_name);
        
        // Determine compiler
        let compiler = self.find_c_compiler()?;
        
        // Build compiler command
        let mut cmd = Command::new(&compiler);
        
        // Add optimization flags
        match self.config.build.optimize.as_str() {
            "none" => {
                cmd.arg("-O0");
            }
            "size" => {
                cmd.arg("-Os");
            }
            "speed" | _ => {
                cmd.arg("-O2");
            }
        }
        
        // Add debug symbols if requested
        if self.config.build.debug {
            cmd.arg("-g");
        }
        
        // Static linking for "compile once, run anywhere"
        if self.config.build.static_link {
            cmd.arg("-static");
        }
        
        // Add custom compiler flags
        for flag in &self.config.build.compiler_flags {
            cmd.arg(flag);
        }
        
        // Add OpenSSL support
        cmd.arg("-DUSE_OPENSSL");
        
        // Output file
        cmd.arg("-o").arg(&binary_path);
        
        // Input file
        cmd.arg(c_file);
        
        // Linker flags
        cmd.arg("-lm"); // Math library
        
        // OpenSSL libraries
        if self.config.build.static_link {
            // Try to find static OpenSSL libraries
            cmd.arg("-lssl").arg("-lcrypto");
        } else {
            cmd.arg("-lssl").arg("-lcrypto");
        }
        
        // Add custom linker flags
        for flag in &self.config.build.linker_flags {
            cmd.arg(flag);
        }
        
        // Execute compilation
        let output = cmd.output().map_err(|e| {
            CompileError::codegen(
                format!("Failed to execute compiler: {}", e),
                None,
            )
        })?;
        
        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            return Err(CompileError::codegen(
                format!("Compilation failed:\n{}", stderr),
                None,
            ));
        }
        
        Ok(binary_path)
    }
    
    /// Find available C compiler
    fn find_c_compiler(&self) -> CompileResult<String> {
        // Try gcc first
        if Command::new("gcc").arg("--version").output().is_ok() {
            return Ok("gcc".to_string());
        }
        
        // Try clang
        if Command::new("clang").arg("--version").output().is_ok() {
            return Ok("clang".to_string());
        }
        
        // Try cl on Windows
        if cfg!(windows) {
            if Command::new("cl").arg("/?").output().is_ok() {
                return Ok("cl".to_string());
            }
        }
        
        Err(CompileError::codegen(
            "No C compiler found. Please install gcc, clang, or MSVC.".to_string(),
            None,
        ))
    }
    
    /// Get the output binary path
    pub fn get_binary_path(&self) -> PathBuf {
        let output_dir = self.project_root.join(&self.config.build.output_dir);
        if cfg!(windows) {
            output_dir.join(format!("{}.exe", self.config.build.binary_name))
        } else {
            output_dir.join(&self.config.build.binary_name)
        }
    }
    
    /// Lint all source files in the project
    pub fn lint_all_files(&self) -> CompileResult<Vec<LintIssue>> {
        let source_files = self.collect_source_files()?;
        let mut all_issues = Vec::new();
        let mut linter = Linter::new();
        
        for file in &source_files {
            let source = fs::read_to_string(file).map_err(|e| {
                CompileError::codegen(format!("Failed to read file for linting: {}", e), None)
            })?;
            
            // Parse the file
            let lexer = Lexer::new_with_filename(&source, file.to_string_lossy().to_string());
            let mut parser = Parser::new(lexer);
            let program = match parser.parse() {
                Ok(p) => p,
                Err(_) => {
                    // Skip files that don't parse - they'll be caught during compilation
                    continue;
                }
            };
            
            // Lint the program
            let issues = linter.lint(&program, &source, file);
            all_issues.extend(issues);
        }
        
        Ok(all_issues)
    }
    
    /// Format all source files in the project
    pub fn format_all_files(&mut self, write: bool) -> CompileResult<usize> {
        let source_files = self.collect_source_files()?;
        let mut formatted_count = 0;
        let mut formatter = Formatter::new();
        
        for file in &source_files {
            let source = fs::read_to_string(file).map_err(|e| {
                CompileError::codegen(format!("Failed to read file for formatting: {}", e), None)
            })?;
            
            // Parse the file
            let lexer = Lexer::new_with_filename(&source, file.to_string_lossy().to_string());
            let mut parser = Parser::new(lexer);
            let program = match parser.parse() {
                Ok(p) => p,
                Err(_) => {
                    // Skip files that don't parse
                    continue;
                }
            };
            
            // Format the program
            let formatted = formatter.format(&program).map_err(|e| {
                CompileError::codegen(format!("Formatting error: {}", e), None)
            })?;
            
            if write {
                fs::write(file, formatted).map_err(|e| {
                    CompileError::codegen(format!("Failed to write formatted file: {}", e), None)
                })?;
                formatted_count += 1;
            } else {
                // Just check if formatting would change the file
                if formatted != source {
                    formatted_count += 1;
                }
            }
        }
        
        Ok(formatted_count)
    }
    
    /// Clean build artifacts
    pub fn clean(&mut self) -> CompileResult<()> {
        let output_dir = self.project_root.join(&self.config.build.output_dir);
        if output_dir.exists() {
            fs::remove_dir_all(&output_dir).map_err(|e| {
                CompileError::codegen(format!("Failed to clean output directory: {}", e), None)
            })?;
        }
        
        self.cache.clear();
        Ok(())
    }
    
    /// Run borrow checker on all source files
    pub fn check_borrows(&self) -> CompileResult<Vec<String>> {
        let source_files = self.collect_source_files()?;
        let mut all_errors = Vec::new();
        
        for file in &source_files {
            let source = fs::read_to_string(file).map_err(|e| {
                CompileError::codegen(format!("Failed to read file for borrow checking: {}", e), None)
            })?;
            
            // Parse the file
            let lexer = Lexer::new_with_filename(&source, file.to_string_lossy().to_string());
            let mut parser = Parser::new(lexer);
            let program = match parser.parse() {
                Ok(p) => p,
                Err(_) => {
                    // Skip files that don't parse - they'll be caught during compilation
                    continue;
                }
            };
            
            // Run borrow checker
            let mut checker = BorrowChecker::new();
            checker.check(&program);
            
            // Collect errors
            for error in checker.get_errors() {
                all_errors.push(format!("{}:\n{}", file.display(), error.message()));
            }
        }
        
        Ok(all_errors)
    }
    
    /// Check for circular dependencies in imports
    pub fn check_circular_dependencies(&self, main_file: &Path) -> CompileResult<()> {
        let source = fs::read_to_string(main_file).map_err(|e| {
            CompileError::codegen(format!("Failed to read main file: {}", e), None)
        })?;
        
        // Parse the main file
        let lexer = Lexer::new_with_filename(&source, main_file.to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Parse error: {}", e), None)
        })?;
        
        // Create package resolver and check for cycles
        let mut resolver = PackageResolver::new(main_file.to_string_lossy().as_ref());
        
        resolver.check_circular_dependencies(&program).map_err(|e| {
            CompileError::codegen(
                format!("Circular dependency error:\n{}", e),
                None,
            )
        })?;
        
        Ok(())
    }
    
    /// Get the dependency graph for the project
    pub fn get_dependency_graph(&self, main_file: &Path) -> CompileResult<std::collections::HashMap<String, Vec<String>>> {
        let source = fs::read_to_string(main_file).map_err(|e| {
            CompileError::codegen(format!("Failed to read main file: {}", e), None)
        })?;
        
        // Parse the main file
        let lexer = Lexer::new_with_filename(&source, main_file.to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Parse error: {}", e), None)
        })?;
        
        // Create package resolver and get dependency graph
        let mut resolver = PackageResolver::new(main_file.to_string_lossy().as_ref());
        
        Ok(resolver.get_dependency_graph(&program))
    }
}
