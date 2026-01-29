// Dependency management for Tlang projects with transitive dependency resolution

use std::path::{Path, PathBuf};
use std::collections::{HashMap, HashSet};
use crate::error::{CompileError, CompileResult};
use crate::ast::Program;
use crate::build::config::NamedDependency;
use crate::build::lockfile::{LockFile, LockedDependency, DependencySourceLocked};
use sha2::{Sha256, Digest};

#[derive(Debug, Clone)]
pub struct DependencyManager {
    project_root: PathBuf,
    dependencies_dir: PathBuf,
    resolved: HashMap<String, ResolvedDependency>,
}

#[derive(Debug, Clone)]
pub struct ResolvedDependency {
    pub name: String,
    pub version: String,
    pub path: PathBuf,
    pub program: Program,
    pub direct_deps: Vec<String>, // Names of direct dependencies
    pub checksum: Option<String>,
}

impl DependencyManager {
    pub fn new<P: AsRef<Path>>(project_root: P) -> Self {
        let root = project_root.as_ref();
        DependencyManager {
            project_root: root.to_path_buf(),
            dependencies_dir: root.join("dependencies"),
            resolved: HashMap::new(),
        }
    }
    
    /// Resolve all dependencies including transitive (indirect) dependencies
    pub fn resolve_all(
        &mut self,
        dependencies: &[NamedDependency],
        lock_file: Option<&LockFile>,
        ignore_list: &[String],
    ) -> CompileResult<(Vec<crate::package::PackageInfo>, LockFile)> {
        let mut lock = lock_file.cloned().unwrap_or_else(LockFile::new);
        let mut visited = HashSet::new();
        let mut loading = HashSet::new();
        
        // Ensure dependencies directory exists
        std::fs::create_dir_all(&self.dependencies_dir).map_err(|e| {
            CompileError::codegen(
                format!("Failed to create dependencies directory: {}", e),
                None,
            )
        })?;
        
        // Resolve direct dependencies
        for dep in dependencies {
            if dep.optional {
                continue; // Skip optional dependencies for now
            }
            if ignore_list.contains(&dep.name) {
                println!("Ignoring package: {} (listed in ignore)", dep.name);
                continue;
            }
            self.resolve_dependency_recursive(
                dep,
                false, // is_indirect
                &mut lock,
                &mut visited,
                &mut loading,
                ignore_list,
            )?;
        }
        
        // Convert resolved dependencies to PackageInfo
        let packages: Vec<crate::package::PackageInfo> = self.resolved.values()
            .map(|r| crate::package::PackageInfo {
                name: r.name.clone(),
                path: r.path.clone(),
                program: r.program.clone(),
                functions: Vec::new(), // Will be populated during compilation
            })
            .collect();
        
        Ok((packages, lock))
    }
    
    /// Recursively resolve a dependency and its transitive dependencies
    fn resolve_dependency_recursive(
        &mut self,
        dep: &NamedDependency,
        is_indirect: bool,
        lock: &mut LockFile,
        visited: &mut HashSet<String>,
        loading: &mut HashSet<String>,
        ignore_list: &[String],
    ) -> CompileResult<()> {
        // Check if package is in ignore list
        if ignore_list.contains(&dep.name) {
            println!("Ignoring package: {} (listed in ignore)", dep.name);
            return Ok(());
        }
        
        // Check for circular dependencies
        if loading.contains(&dep.name) {
            return Err(CompileError::codegen(
                format!("Circular dependency detected: {}", dep.name),
                None,
            ));
        }
        
        // Skip if already resolved
        if visited.contains(&dep.name) {
            return Ok(());
        }
        
        loading.insert(dep.name.clone());
        
        // Resolve the dependency
        let resolved = self.resolve_dependency(dep, lock)?;
        
        // Get its dependencies from its manifest/config.toml
        let dep_deps = self.load_dependency_manifest(&resolved.path)?;
        
        // Recursively resolve transitive dependencies
        for transitive_dep in &dep_deps {
            if ignore_list.contains(&transitive_dep.name) {
                println!("Ignoring transitive dependency: {} (listed in ignore)", transitive_dep.name);
                continue;
            }
            self.resolve_dependency_recursive(
                transitive_dep,
                true, // is_indirect
                lock,
                visited,
                loading,
                ignore_list,
            )?;
        }
        
        // Update resolved dependencies list
        let direct_deps: Vec<String> = dep_deps.iter().map(|d| d.name.clone()).collect();
        let locked = LockedDependency {
            name: resolved.name.clone(),
            version: resolved.version.clone(),
            source: self.source_to_locked(&dep.source)?,
            checksum: resolved.checksum.clone(),
            dependencies: direct_deps,
        };
        lock.add_dependency(locked, is_indirect);
        
        self.resolved.insert(dep.name.clone(), resolved);
        loading.remove(&dep.name);
        visited.insert(dep.name.clone());
        
        Ok(())
    }
    
    /// Resolve a single dependency
    fn resolve_dependency(
        &mut self,
        dep: &NamedDependency,
        lock: &LockFile,
    ) -> CompileResult<ResolvedDependency> {
        // Check lock file first
        if let Some(locked) = lock.find_dependency(&dep.name) {
            return self.resolve_from_lock(locked);
        }
        
        // Resolve based on source type
        match &dep.source {
            crate::build::config::DependencySource::Path { path } => {
                self.resolve_path_dependency(dep, path)
            }
            crate::build::config::DependencySource::Http { http, .. } => {
                self.resolve_http_dependency(dep, http)
            }
            crate::build::config::DependencySource::Git { git, .. } => {
                Err(CompileError::codegen(
                    format!("Git dependencies not yet implemented: {}", git),
                    None,
                ))
            }
            crate::build::config::DependencySource::Registry { registry, .. } => {
                Err(CompileError::codegen(
                    format!("Registry dependencies not yet implemented: {}", registry),
                    None,
                ))
            }
        }
    }
    
    /// Resolve dependency from lock file
    fn resolve_from_lock(&self, locked: &LockedDependency) -> CompileResult<ResolvedDependency> {
        match &locked.source {
            DependencySourceLocked::Path { path } => {
                let dep_path = if Path::new(path).is_absolute() {
                    PathBuf::from(path)
                } else {
                    self.project_root.join(path)
                };
                
                self.load_package_from_path(&dep_path, Some(&locked.version))
            }
            DependencySourceLocked::Http { url, .. } => {
                // HTTP dependencies should be in dependencies directory
                let package_dir = self.dependencies_dir.join(&locked.name);
                if !package_dir.exists() {
                    return Err(CompileError::codegen(
                        format!("HTTP dependency '{}' not found. Run 'tlang add {}' first.", locked.name, url),
                        None,
                    ));
                }
                self.load_package_from_path(&package_dir, Some(&locked.version))
            }
            _ => Err(CompileError::codegen(
                format!("Lock file source type not yet supported for: {}", locked.name),
                None,
            )),
        }
    }
    
    /// Resolve HTTP/HTTPS-based dependency
    fn resolve_http_dependency(
        &self,
        dep: &NamedDependency,
        url: &str,
    ) -> CompileResult<ResolvedDependency> {
        // Check if already downloaded
        let package_dir = self.dependencies_dir.join(&dep.name);
        
        if !package_dir.exists() {
            // Download the package (this should have been done during `tlang add`)
            return Err(CompileError::codegen(
                format!("Package '{}' not found. Run 'tlang add {}' first.", dep.name, url),
                None,
            ));
        }
        
        self.load_package_from_path(&package_dir, Some(&dep.version))
    }
    
    /// Resolve path-based dependency
    fn resolve_path_dependency(
        &self,
        dep: &NamedDependency,
        path: &str,
    ) -> CompileResult<ResolvedDependency> {
        let dep_path = if Path::new(path).is_absolute() {
            PathBuf::from(path)
        } else {
            self.project_root.join(path)
        };
        
        if !dep_path.exists() {
            return Err(CompileError::codegen(
                format!("Dependency path not found: {}", path),
                None,
            ));
        }
        
        self.load_package_from_path(&dep_path, Some(&dep.version))
    }
    
    /// Load package from path and parse its manifest
    fn load_package_from_path(
        &self,
        path: &Path,
        version: Option<&str>,
    ) -> CompileResult<ResolvedDependency> {
        // Try to load manifest
        let manifest_path = path.join("config.toml");
        
        let config = if manifest_path.exists() {
            crate::build::config::ProjectConfig::load(path)?
        } else {
            // No manifest, treat as simple package
            return self.load_simple_package(path, version);
        };
        
        // Load the package source
        let main_file = config.get_main_file(path);
        let source = std::fs::read_to_string(&main_file).map_err(|e| {
            CompileError::codegen(format!("Failed to read package file: {}", e), None)
        })?;
        
        // Parse the package
        let lexer = crate::lexer::Lexer::new_with_filename(&source, main_file.to_string_lossy().to_string());
        let mut parser = crate::parser::Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Failed to parse package: {}", e), None)
        })?;
        
        // Calculate checksum
        let checksum = Self::calculate_checksum(&source);
        
        Ok(ResolvedDependency {
            name: config.package.name,
            version: version.unwrap_or(&config.package.version).to_string(),
            path: path.to_path_buf(),
            program,
            direct_deps: config.dependencies.iter().map(|d| d.name.clone()).collect(),
            checksum: Some(checksum),
        })
    }
    
    /// Load simple package without manifest
    fn load_simple_package(
        &self,
        path: &Path,
        version: Option<&str>,
    ) -> CompileResult<ResolvedDependency> {
        // Find .tl files in directory
        let mut tl_files = Vec::new();
        if path.is_dir() {
            for entry in std::fs::read_dir(path).map_err(|e| {
                CompileError::codegen(format!("Failed to read directory: {}", e), None)
            })? {
                let entry = entry.map_err(|e| {
                    CompileError::codegen(format!("Failed to read entry: {}", e), None)
                })?;
                if entry.path().extension().and_then(|s| s.to_str()) == Some("tl") {
                    tl_files.push(entry.path());
                }
            }
        } else if path.extension().and_then(|s| s.to_str()) == Some("tl") {
            tl_files.push(path.to_path_buf());
        }
        
        if tl_files.is_empty() {
            return Err(CompileError::codegen(
                format!("No Tlang files found in: {}", path.display()),
                None,
            ));
        }
        
        // Load and parse first file
        let source = std::fs::read_to_string(&tl_files[0]).map_err(|e| {
            CompileError::codegen(format!("Failed to read file: {}", e), None)
        })?;
        
        let lexer = crate::lexer::Lexer::new_with_filename(&source, tl_files[0].to_string_lossy().to_string());
        let mut parser = crate::parser::Parser::new(lexer);
        let program = parser.parse().map_err(|e| {
            CompileError::codegen(format!("Failed to parse: {}", e), None)
        })?;
        
        let name = path.file_name()
            .and_then(|n| n.to_str())
            .unwrap_or("unknown")
            .to_string();
        
        let checksum = Self::calculate_checksum(&source);
        
        Ok(ResolvedDependency {
            name,
            version: version.unwrap_or("0.1.0").to_string(),
            path: path.to_path_buf(),
            program,
            direct_deps: Vec::new(),
            checksum: Some(checksum),
        })
    }
    
    /// Load dependency manifest from a package
    fn load_dependency_manifest(&self, path: &Path) -> CompileResult<Vec<NamedDependency>> {
        let config = crate::build::config::ProjectConfig::load(path)?;
        Ok(config.dependencies)
    }
    
    /// Convert DependencySource to DependencySourceLocked
    fn source_to_locked(
        &self,
        source: &crate::build::config::DependencySource,
    ) -> CompileResult<DependencySourceLocked> {
        match source {
            crate::build::config::DependencySource::Path { path } => {
                Ok(DependencySourceLocked::Path { path: path.clone() })
            }
            crate::build::config::DependencySource::Http { http, version } => {
                Ok(DependencySourceLocked::Http {
                    url: http.clone(),
                    version: version.clone(),
                })
            }
            crate::build::config::DependencySource::Git { git, branch, tag, rev } => {
                Ok(DependencySourceLocked::Git {
                    url: git.clone(),
                    branch: branch.clone(),
                    tag: tag.clone(),
                    rev: rev.clone(),
                })
            }
            crate::build::config::DependencySource::Registry { registry } => {
                Ok(DependencySourceLocked::Registry {
                    registry: registry.clone(),
                    version: String::new(), // Will be set from dependency
                })
            }
        }
    }
    
    /// Calculate SHA256 checksum of source
    fn calculate_checksum(source: &str) -> String {
        let mut hasher = Sha256::new();
        hasher.update(source.as_bytes());
        format!("{:x}", hasher.finalize())
    }
}
