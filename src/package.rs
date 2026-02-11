use crate::ast::*;
use crate::lexer::Lexer;
use crate::parser::Parser;
use crate::error::{CompileError, CompileResult};
use std::collections::{HashMap, HashSet};
use std::fs;
use std::path::PathBuf;

/// Package information
#[derive(Debug, Clone)]
pub struct PackageInfo {
    pub name: String,
    pub path: PathBuf,
    pub program: Program,
    pub functions: Vec<String>, // List of exported function names
}

/// Package resolver - handles finding and loading packages.
///
/// **Recommended:** Use `@alias = #dhimpu("path")` so calls are explicit (`alias.Symbol`)
/// and there are no name clashes when multiple packages export the same name.
pub struct PackageResolver {
    packages: HashMap<String, PackageInfo>,
    search_paths: Vec<PathBuf>,
    current_dir: PathBuf,
}

impl PackageResolver {
    /// Check if an identifier is exported (Go-style: uppercase first letter)
    /// In Go, identifiers starting with uppercase are exported (public),
    /// while those starting with lowercase are unexported (private)
    pub fn is_exported(name: &str) -> bool {
        if name.is_empty() {
            return false;
        }
        // Check if first character is uppercase ASCII letter
        let first_char = name.chars().next().unwrap();
        first_char.is_uppercase() && first_char.is_ascii_alphabetic()
    }
    
    pub fn new(current_file: &str) -> Self {
        let current_path = PathBuf::from(current_file);
        let current_dir = current_path.parent()
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|| PathBuf::from("."));
        
        let mut search_paths = Vec::new();
        search_paths.push(current_dir.clone());
        search_paths.push(PathBuf::from("."));
        
        // Add standard library path: libs/std/<package> (if exists)
        if let Ok(cargo_manifest) = std::env::var("CARGO_MANIFEST_DIR") {
            let std_path = PathBuf::from(&cargo_manifest).join("libs").join("std");
            if std_path.exists() {
                search_paths.push(std_path);
            }
            // Legacy: stdlib at repo root (if present)
            let stdlib_path = PathBuf::from(cargo_manifest).join("stdlib");
            if stdlib_path.exists() {
                search_paths.push(stdlib_path);
            }
        }
        
        PackageResolver {
            packages: HashMap::new(),
            search_paths,
            current_dir,
        }
    }
    
    /// Add a search path for packages
    pub fn add_search_path(&mut self, path: PathBuf) {
        self.search_paths.push(path);
    }
    
    /// Standard library package names (under std/ in import path).
    pub const STDLIB_NAMES: &[&str] = &[
        "fmt", "strings", "strconv", "math", "os", "io", "filepath", "time",
        "regexp", "rand", "log", "testing", "args", "flag", "bytes", "sort",
        "json", "unicode", "csv", "xml", "url", "neturl", "bufio", "benchmark",
        "doc", "reflect", "crypto", "hex", "base64", "http", "errors", "net", "protobuf",
    ];

    /// Check if import is a built-in standard library. Use `std/<name>` in source (e.g. `#dhimpu("std/fmt")`).
    pub fn is_builtin_library(&self, import_path: &str) -> bool {
        if let Some(name) = import_path.strip_prefix("std/") {
            return Self::STDLIB_NAMES.contains(&name);
        }
        false
    }

    /// Return the short package name for an import path (e.g. "std/fmt" -> "fmt").
    pub fn stdlib_short_name(import_path: &str) -> &str {
        import_path.strip_prefix("std/").unwrap_or(import_path)
    }
    
    /// Resolve import path to file path
    fn resolve_import_path(&self, import_path: &str) -> Result<PathBuf, String> {
        // Handle built-in standard library imports: std/<name> (e.g. "std/fmt", "std/math")
        if self.is_builtin_library(import_path) {
            return Err(format!("Built-in library '{}' (no file resolution needed)", import_path));
        }

        // Handle std/<name> file resolution (libs/std/<name>/mod.tl or libs/std/<name>.tl)
        if let Some(name) = import_path.strip_prefix("std/") {
            for search_path in &self.search_paths {
                let mod_path = search_path.join(name).join("mod.tl");
                if mod_path.exists() {
                    return Ok(mod_path);
                }
                let file_path = search_path.join(format!("{}.tl", name));
                if file_path.exists() {
                    return Ok(file_path);
                }
            }
            return Err(format!("Package '{}' not found (expected under libs/std/<package>)", import_path));
        }
        
        // Handle other non-relative package names (look in stdlib directory for legacy)
        if !import_path.contains('/') && !import_path.contains('\\') && !import_path.starts_with('.') {
            for search_path in &self.search_paths {
                let stdlib_path = search_path.join("stdlib").join(format!("{}.tl", import_path));
                if stdlib_path.exists() {
                    return Ok(stdlib_path);
                }
            }
            return Err(format!("Package '{}' not found (use std/<name> for standard library, e.g. #dhimpu(\"std/fmt\"))", import_path));
        }
        
        // Handle relative imports (e.g., "./utils", "../common", "../libs/x/express")
        if import_path.starts_with("./") || import_path.starts_with("../") {
            let relative_path = self.current_dir.join(import_path);
            if relative_path.exists() && relative_path.is_file() {
                return Ok(relative_path);
            }
            // Try with .tl extension
            let with_ext = relative_path.with_extension("tl");
            if with_ext.exists() {
                return Ok(with_ext);
            }
            // Try as directory with mod.tl
            if relative_path.is_dir() {
                let mod_path = relative_path.join("mod.tl");
                if mod_path.exists() {
                    return Ok(mod_path);
                }
            }
            return Err(format!("File not found: {}", relative_path.display()));
        }
        
        // Handle absolute or module paths
        for search_path in &self.search_paths {
            let full_path = search_path.join(format!("{}.tl", import_path));
            if full_path.exists() {
                return Ok(full_path);
            }
            // Try as directory with mod.tl
            let mod_path = search_path.join(import_path).join("mod.tl");
            if mod_path.exists() {
                return Ok(mod_path);
            }
        }
        
        Err(format!("Package '{}' not found in search paths", import_path))
    }
    
    /// Load and parse a package file
    pub fn load_package(&mut self, import_path: &str) -> CompileResult<PackageInfo> {
        // Check if already loaded
        if let Some(pkg) = self.packages.get(import_path) {
            return Ok(pkg.clone());
        }
        
        // Resolve file path
        let file_path = match self.resolve_import_path(import_path) {
            Ok(path) => path,
            Err(e) => {
                // If it's a built-in library, create a placeholder (no functions to import)
                if e.contains("Built-in library") {
                    let short_name = Self::stdlib_short_name(import_path).to_string();
                    return Ok(PackageInfo {
                        name: short_name,
                        path: PathBuf::from(import_path),
                        program: Program {
                            imports: Vec::new(),
                            statements: Vec::new(),
                        },
                        functions: Vec::new(), // Built-in libraries have functions in codegen
                    });
                }
                return Err(CompileError::parser(
                    format!("Cannot find package '{}': {}", import_path, e),
                    crate::error::SourceLocation::new(1, 1, import_path.to_string()),
                ));
            }
        };
        
        // Read file
        let source = fs::read_to_string(&file_path).map_err(|e| {
            CompileError::parser(
                format!("Error reading file '{}': {}", file_path.display(), e),
                crate::error::SourceLocation::new(1, 1, file_path.to_string_lossy().to_string()),
            )
        })?;
        
        // Parse file
        let lexer = Lexer::new_with_filename(&source, file_path.to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::parser(
                format!("Error parsing package '{}': {}", import_path, e),
                crate::error::SourceLocation::new(1, 1, file_path.to_string_lossy().to_string()),
            )
        })?;
        
        // Extract exported functions and variables
        // In Go, exported names start with capital letter (Go-style visibility)
        // Only identifiers starting with uppercase letter are exported
        let functions: Vec<String> = program.statements.iter()
            .filter_map(|stmt| {
                match stmt {
                    Stmt::Function { name, .. } => {
                        // Only export functions with uppercase first letter
                        if Self::is_exported(&name) {
                            Some(name.clone())
                        } else {
                            None
                        }
                    }
                    Stmt::VariableDecl { name, .. } => {
                        // Only export package-level variables with uppercase first letter
                        if Self::is_exported(&name) {
                            Some(name.clone())
                        } else {
                            None
                        }
                    }
                    Stmt::StructDef { name, .. } => {
                        // Only export structs with uppercase first letter
                        if Self::is_exported(&name) {
                            Some(name.clone())
                        } else {
                            None
                        }
                    }
                    _ => None,
                }
            })
            .collect();
        
        // Derive package name from import path (e.g. "fmt" -> "fmt", "./utils" -> "utils")
        let package_name = import_path
            .replace('\\', "/")
            .split('/')
            .last()
            .unwrap_or(import_path)
            .trim_start_matches('.')
            .to_string();
        
        let package_info = PackageInfo {
            name: package_name,
            path: file_path,
            program,
            functions,
        };
        
        // Cache the package
        self.packages.insert(import_path.to_string(), package_info.clone());
        
        Ok(package_info)
    }
    
    /// Resolve all imports for a program with circular dependency detection
    pub fn resolve_imports(&mut self, program: &Program) -> CompileResult<Vec<PackageInfo>> {
        let mut packages = Vec::new();
        let mut loaded = HashSet::new();
        let mut loading_stack = Vec::new(); // Track the loading order for better error messages
        
        self.resolve_imports_recursive(program, &mut packages, &mut loaded, &mut loading_stack)?;
        
        Ok(packages)
    }
    
    /// Recursive helper for resolving imports with circular dependency detection
    fn resolve_imports_recursive(
        &mut self,
        program: &Program,
        packages: &mut Vec<PackageInfo>,
        loaded: &mut HashSet<String>,
        loading_stack: &mut Vec<String>,
    ) -> CompileResult<()> {
        for import_info in &program.imports {
            let import_path = &import_info.path;
            
            // Skip if already loaded
            if loaded.contains(import_path) {
                continue;
            }
            
            // Check for circular dependency
            if let Some(cycle_start) = loading_stack.iter().position(|p| p == import_path) {
                // Build the dependency chain for the error message
                let mut cycle_chain: Vec<String> = loading_stack[cycle_start..].to_vec();
                cycle_chain.push(import_path.clone());
                
                let chain_display = cycle_chain.join(" -> ");
                
                return Err(CompileError::parser(
                    format!(
                        "Circular dependency detected!\n\
                         Dependency chain: {}\n\
                         Package '{}' cannot import '{}' because '{}' already depends on it.\n\
                         \n\
                         To fix this:\n\
                         1. Extract shared code into a separate package\n\
                         2. Restructure your packages to avoid the cycle",
                        chain_display,
                        loading_stack.last().unwrap_or(&"<root>".to_string()),
                        import_path,
                        import_path
                    ),
                    crate::error::SourceLocation::new(1, 1, import_path.clone()),
                ));
            }
            
            // Push onto loading stack
            loading_stack.push(import_path.clone());
            
            // Load package (recursively handles its imports)
            let pkg = self.load_package(import_path)?;
            
            // Recursively resolve imports of this package
            self.resolve_imports_recursive(&pkg.program, packages, loaded, loading_stack)?;
            
            // Pop from loading stack and mark as loaded
            loading_stack.pop();
            packages.push(pkg.clone());
            loaded.insert(import_path.clone());
        }
        
        Ok(())
    }
    
    /// Check for circular dependencies without loading packages
    /// Returns Ok(()) if no cycles, or Err with the cycle description
    pub fn check_circular_dependencies(&mut self, program: &Program) -> CompileResult<()> {
        let mut visited = HashSet::new();
        let mut rec_stack = HashSet::new();
        let mut path = Vec::new();
        
        for import_info in &program.imports {
            self.detect_cycle(&import_info.path, &mut visited, &mut rec_stack, &mut path)?;
        }
        
        Ok(())
    }
    
    /// DFS-based cycle detection
    fn detect_cycle(
        &mut self,
        import_path: &str,
        visited: &mut HashSet<String>,
        rec_stack: &mut HashSet<String>,
        path: &mut Vec<String>,
    ) -> CompileResult<()> {
        // Skip built-in libraries
        if self.is_builtin_library(import_path) {
            return Ok(());
        }
        
        // If in recursion stack, we found a cycle
        if rec_stack.contains(import_path) {
            path.push(import_path.to_string());
            let cycle_start = path.iter().position(|p| p == import_path).unwrap_or(0);
            let cycle = path[cycle_start..].join(" -> ");
            return Err(CompileError::parser(
                format!("Circular dependency detected: {}", cycle),
                crate::error::SourceLocation::new(1, 1, import_path.to_string()),
            ));
        }
        
        // If already visited (and not in rec_stack), no cycle through this node
        if visited.contains(import_path) {
            return Ok(());
        }
        
        // Mark as visited and add to recursion stack
        visited.insert(import_path.to_string());
        rec_stack.insert(import_path.to_string());
        path.push(import_path.to_string());
        
        // Try to load and check dependencies
        if let Ok(pkg) = self.load_package(import_path) {
            for dep_import in &pkg.program.imports {
                self.detect_cycle(&dep_import.path, visited, rec_stack, path)?;
            }
        }
        
        // Remove from recursion stack and path
        rec_stack.remove(import_path);
        path.pop();
        
        Ok(())
    }
    
    /// Get a dependency graph for visualization/debugging
    pub fn get_dependency_graph(&mut self, program: &Program) -> HashMap<String, Vec<String>> {
        let mut graph: HashMap<String, Vec<String>> = HashMap::new();
        let mut visited = HashSet::new();
        
        self.build_dependency_graph(program, "main", &mut graph, &mut visited);
        
        graph
    }
    
    /// Build dependency graph recursively
    fn build_dependency_graph(
        &mut self,
        program: &Program,
        pkg_name: &str,
        graph: &mut HashMap<String, Vec<String>>,
        visited: &mut HashSet<String>,
    ) {
        if visited.contains(pkg_name) {
            return;
        }
        visited.insert(pkg_name.to_string());
        
        let deps: Vec<String> = program.imports.iter()
            .map(|i| i.path.clone())
            .collect();
        
        graph.insert(pkg_name.to_string(), deps.clone());
        
        // Recursively process dependencies
        for dep in deps {
            if self.is_builtin_library(&dep) {
                // Built-in libraries have no further dependencies
                graph.entry(dep).or_insert_with(Vec::new);
            } else if let Ok(pkg) = self.load_package(&dep) {
                self.build_dependency_graph(&pkg.program, &pkg.name, graph, visited);
            }
        }
    }
    
    /// Get all loaded packages
    pub fn get_packages(&self) -> &HashMap<String, PackageInfo> {
        &self.packages
    }
}
