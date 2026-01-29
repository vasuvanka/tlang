// Project configuration parser for config.toml (manifest file)

use serde::{Deserialize, Serialize};
use std::fs;
use std::path::{Path, PathBuf};
use crate::error::{CompileError, CompileResult, SourceLocation};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectConfig {
    pub package: PackageInfo,
    #[serde(default)]
    pub build: BuildConfig,
    #[serde(default, rename = "dependencies", deserialize_with = "deserialize_dependencies")]
    pub dependencies: Vec<NamedDependency>,
    #[serde(default, rename = "dev-dependencies", deserialize_with = "deserialize_dependencies")]
    pub dev_dependencies: Vec<NamedDependency>,
    #[serde(default)]
    pub ignore: Vec<String>, // Packages to ignore (from dependencies or experimental)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NamedDependency {
    pub name: String,
    pub source: DependencySource,
    pub version: String,
    pub optional: bool,
}

fn deserialize_dependencies<'de, D>(deserializer: D) -> Result<Vec<NamedDependency>, D::Error>
where
    D: serde::Deserializer<'de>,
{
    use serde::Deserialize;
    
    // Try to deserialize as a table (inline format: utils = { path = "..." })
    // or as an array of tables (table format: [[dependencies]])
    #[derive(Deserialize)]
    #[serde(untagged)]
    enum DepFormat {
        Inline(std::collections::HashMap<String, DependencyInline>),
        Array(Vec<DependencyTable>),
    }
    
    #[derive(Deserialize)]
    struct DependencyInline {
        #[serde(flatten)]
        source: DependencySource,
        #[serde(default)]
        version: String,
        #[serde(default)]
        optional: bool,
    }
    
    #[derive(Deserialize)]
    struct DependencyTable {
        name: String,
        #[serde(flatten)]
        source: DependencySource,
        #[serde(default)]
        version: String,
        #[serde(default)]
        optional: bool,
    }
    
    let format = DepFormat::deserialize(deserializer)?;
    
    let mut deps = Vec::new();
    match format {
        DepFormat::Inline(map) => {
            for (name, dep) in map {
                deps.push(NamedDependency {
                    name,
                    source: dep.source,
                    version: dep.version,
                    optional: dep.optional,
                });
            }
        }
        DepFormat::Array(arr) => {
            for dep in arr {
                deps.push(NamedDependency {
                    name: dep.name,
                    source: dep.source,
                    version: dep.version,
                    optional: dep.optional,
                });
            }
        }
    }
    
    Ok(deps)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackageInfo {
    pub name: String,
    #[serde(default)]
    pub version: String,
    #[serde(default)]
    pub description: String,
    #[serde(default)]
    pub author: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BuildConfig {
    #[serde(default = "default_output_dir")]
    pub output_dir: String,
    
    #[serde(default = "default_binary_name")]
    pub binary_name: String,
    
    #[serde(default)]
    pub entry_file: Option<String>,
    
    #[serde(default)]
    pub static_link: bool,
    
    #[serde(default)]
    pub optimize: String, // "none", "size", "speed"
    
    #[serde(default)]
    pub debug: bool,
    
    #[serde(default)]
    pub compiler_flags: Vec<String>,
    
    #[serde(default)]
    pub linker_flags: Vec<String>,
}

fn default_output_dir() -> String {
    "target".to_string()
}

fn default_binary_name() -> String {
    "app".to_string()
}

impl Default for BuildConfig {
    fn default() -> Self {
        BuildConfig {
            output_dir: default_output_dir(),
            binary_name: default_binary_name(),
            entry_file: None, // None means auto-detect
            static_link: true, // Default to static linking for "compile once, run anywhere"
            optimize: "speed".to_string(),
            debug: false,
            compiler_flags: Vec::new(),
            linker_flags: Vec::new(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(untagged)]
pub enum DependencySource {
    Path { path: String },
    Http { 
        http: String,
        #[serde(default)]
        version: Option<String>,
    },
    Git { 
        git: String, 
        #[serde(default)]
        branch: Option<String>, 
        #[serde(default)]
        tag: Option<String>, 
        #[serde(default)]
        rev: Option<String> 
    },
    Registry { registry: String },
}

impl DependencySource {
    pub fn as_path(&self) -> Option<&str> {
        match self {
            DependencySource::Path { path } => Some(path),
            _ => None,
        }
    }
    
    pub fn as_http(&self) -> Option<&str> {
        match self {
            DependencySource::Http { http, .. } => Some(http),
            _ => None,
        }
    }
    
    pub fn as_git(&self) -> Option<&str> {
        match self {
            DependencySource::Git { git, .. } => Some(git),
            _ => None,
        }
    }
}

impl ProjectConfig {
    /// Load configuration from config.toml
    pub fn load<P: AsRef<Path>>(project_dir: P) -> CompileResult<Self> {
        let project_path = project_dir.as_ref();
        let config_path = project_path.join("config.toml");
        
        if !config_path.exists() {
            // Return default config if no manifest exists
            return Ok(ProjectConfig {
                package: PackageInfo {
                    name: project_path
                        .file_name()
                        .and_then(|n| n.to_str())
                        .unwrap_or("app")
                        .to_string(),
                    version: "0.1.0".to_string(),
                    description: String::new(),
                    author: String::new(),
                },
                build: BuildConfig::default(),
                dependencies: Vec::new(),
                dev_dependencies: Vec::new(),
                ignore: Vec::new(),
            });
        }
        
        let content = fs::read_to_string(&config_path).map_err(|e| {
            CompileError::codegen(
                format!("Failed to read manifest: {}", e),
                Some(SourceLocation::new(1, 1, config_path.to_string_lossy().to_string())),
            )
        })?;
        
        let config: ProjectConfig = toml::from_str(&content).map_err(|e| {
            CompileError::codegen(
                format!("Failed to parse manifest: {}", e),
                Some(SourceLocation::new(1, 1, config_path.to_string_lossy().to_string())),
            )
        })?;
        
        Ok(config)
    }
    
    /// Find the project root (directory containing config.toml)
    pub fn find_project_root<P: AsRef<Path>>(start_dir: P) -> Option<PathBuf> {
        let mut current = start_dir.as_ref().canonicalize().ok()?;
        
        loop {
            let config_path = current.join("config.toml");
            
            if config_path.exists() {
                return Some(current);
            }
            
            if let Some(parent) = current.parent() {
                current = parent.to_path_buf();
            } else {
                break;
            }
        }
        
        None
    }
    
    /// Get manifest file path (config.toml)
    pub fn get_manifest_path<P: AsRef<Path>>(project_dir: P) -> PathBuf {
        project_dir.as_ref().join("config.toml")
    }
    
    /// Get the main entry point file
    pub fn get_main_file(&self, project_dir: &Path) -> PathBuf {
        // If entry_file is specified in config.toml, use it
        if let Some(ref entry_file) = self.build.entry_file {
            let path = project_dir.join(entry_file);
            if path.exists() {
                return path;
            }
            // If specified but doesn't exist, return it anyway (will error later with better message)
            return path;
        }
        
        // Otherwise, try common entry point names (auto-detect)
        let package_file = format!("{}.tl", self.package.name);
        let candidates = vec![
            "prarambham.tl",
            "main.tl",
            package_file.as_str(),
        ];
        
        for candidate in candidates {
            let path = project_dir.join(candidate);
            if path.exists() {
                return path;
            }
        }
        
        // Default to main.tl
        project_dir.join("main.tl")
    }
    
    /// Save configuration to config.toml
    pub fn save<P: AsRef<Path>>(&self, project_dir: P) -> CompileResult<()> {
        use toml::Value;
        
        let config_path = project_dir.as_ref().join("config.toml");
        
        // Build TOML manually to preserve inline dependency format
        let mut root = toml::map::Map::new();
        
        // Package section
        let mut package = toml::map::Map::new();
        package.insert("name".to_string(), Value::String(self.package.name.clone()));
        package.insert("version".to_string(), Value::String(self.package.version.clone()));
        if !self.package.description.is_empty() {
            package.insert("description".to_string(), Value::String(self.package.description.clone()));
        }
        if !self.package.author.is_empty() {
            package.insert("author".to_string(), Value::String(self.package.author.clone()));
        }
        root.insert("package".to_string(), Value::Table(package));
        
        // Build section
        if self.build.output_dir != "target" || 
           self.build.binary_name != "app" ||
           self.build.entry_file.is_some() ||
           !self.build.static_link ||
           self.build.optimize != "speed" ||
           self.build.debug ||
           !self.build.compiler_flags.is_empty() ||
           !self.build.linker_flags.is_empty() {
            let mut build = toml::map::Map::new();
            if self.build.output_dir != "target" {
                build.insert("output_dir".to_string(), Value::String(self.build.output_dir.clone()));
            }
            if self.build.binary_name != "app" {
                build.insert("binary_name".to_string(), Value::String(self.build.binary_name.clone()));
            }
            if let Some(ref entry_file) = self.build.entry_file {
                build.insert("entry_file".to_string(), Value::String(entry_file.clone()));
            }
            if !self.build.static_link {
                build.insert("static_link".to_string(), Value::Boolean(self.build.static_link));
            }
            if self.build.optimize != "speed" {
                build.insert("optimize".to_string(), Value::String(self.build.optimize.clone()));
            }
            if self.build.debug {
                build.insert("debug".to_string(), Value::Boolean(self.build.debug));
            }
            if !self.build.compiler_flags.is_empty() {
                build.insert("compiler_flags".to_string(), 
                    Value::Array(self.build.compiler_flags.iter().map(|s| Value::String(s.clone())).collect()));
            }
            if !self.build.linker_flags.is_empty() {
                build.insert("linker_flags".to_string(), 
                    Value::Array(self.build.linker_flags.iter().map(|s| Value::String(s.clone())).collect()));
            }
            root.insert("build".to_string(), Value::Table(build));
        }
        
        // Dependencies section (inline format)
        if !self.dependencies.is_empty() {
            let mut deps = toml::map::Map::new();
            for dep in &self.dependencies {
                let mut dep_value = toml::map::Map::new();
                match &dep.source {
                    DependencySource::Path { path } => {
                        dep_value.insert("path".to_string(), Value::String(path.clone()));
                    }
                    DependencySource::Http { http, version } => {
                        dep_value.insert("http".to_string(), Value::String(http.clone()));
                        if let Some(v) = version {
                            dep_value.insert("version".to_string(), Value::String(v.clone()));
                        }
                    }
                    DependencySource::Git { git, branch, tag, rev } => {
                        dep_value.insert("git".to_string(), Value::String(git.clone()));
                        if let Some(b) = branch {
                            dep_value.insert("branch".to_string(), Value::String(b.clone()));
                        }
                        if let Some(t) = tag {
                            dep_value.insert("tag".to_string(), Value::String(t.clone()));
                        }
                        if let Some(r) = rev {
                            dep_value.insert("rev".to_string(), Value::String(r.clone()));
                        }
                    }
                    DependencySource::Registry { registry } => {
                        dep_value.insert("registry".to_string(), Value::String(registry.clone()));
                    }
                }
                if !dep.version.is_empty() {
                    dep_value.insert("version".to_string(), Value::String(dep.version.clone()));
                }
                if dep.optional {
                    dep_value.insert("optional".to_string(), Value::Boolean(true));
                }
                deps.insert(dep.name.clone(), Value::Table(dep_value));
            }
            root.insert("dependencies".to_string(), Value::Table(deps));
        }
        
        // Dev dependencies section
        if !self.dev_dependencies.is_empty() {
            let mut deps = toml::map::Map::new();
            for dep in &self.dev_dependencies {
                let mut dep_value = toml::map::Map::new();
                match &dep.source {
                    DependencySource::Path { path } => {
                        dep_value.insert("path".to_string(), Value::String(path.clone()));
                    }
                    DependencySource::Http { http, version } => {
                        dep_value.insert("http".to_string(), Value::String(http.clone()));
                        if let Some(v) = version {
                            dep_value.insert("version".to_string(), Value::String(v.clone()));
                        }
                    }
                    DependencySource::Git { git, branch, tag, rev } => {
                        dep_value.insert("git".to_string(), Value::String(git.clone()));
                        if let Some(b) = branch {
                            dep_value.insert("branch".to_string(), Value::String(b.clone()));
                        }
                        if let Some(t) = tag {
                            dep_value.insert("tag".to_string(), Value::String(t.clone()));
                        }
                        if let Some(r) = rev {
                            dep_value.insert("rev".to_string(), Value::String(r.clone()));
                        }
                    }
                    DependencySource::Registry { registry } => {
                        dep_value.insert("registry".to_string(), Value::String(registry.clone()));
                    }
                }
                if !dep.version.is_empty() {
                    dep_value.insert("version".to_string(), Value::String(dep.version.clone()));
                }
                if dep.optional {
                    dep_value.insert("optional".to_string(), Value::Boolean(true));
                }
                deps.insert(dep.name.clone(), Value::Table(dep_value));
            }
            root.insert("dev-dependencies".to_string(), Value::Table(deps));
        }
        
        // Ignore section (top-level array)
        if !self.ignore.is_empty() {
            root.insert("ignore".to_string(), 
                Value::Array(self.ignore.iter().map(|s| Value::String(s.clone())).collect()));
        }
        
        let toml_string = toml::to_string_pretty(&Value::Table(root)).map_err(|e| {
            CompileError::codegen(
                format!("Failed to serialize config: {}", e),
                Some(SourceLocation::new(1, 1, config_path.to_string_lossy().to_string())),
            )
        })?;
        
        fs::write(&config_path, toml_string).map_err(|e| {
            CompileError::codegen(
                format!("Failed to write config.toml: {}", e),
                Some(SourceLocation::new(1, 1, config_path.to_string_lossy().to_string())),
            )
        })?;
        
        Ok(())
    }
    
    /// Add a dependency
    pub fn add_dependency(&mut self, name: String, source: DependencySource, version: String) {
        // Remove if already exists
        self.dependencies.retain(|d| d.name != name);
        self.dependencies.push(NamedDependency {
            name,
            source,
            version,
            optional: false,
        });
    }
    
    /// Remove a dependency
    pub fn remove_dependency(&mut self, name: &str) -> bool {
        let before = self.dependencies.len();
        self.dependencies.retain(|d| d.name != name);
        self.dev_dependencies.retain(|d| d.name != name);
        self.dependencies.len() < before || self.dev_dependencies.len() < before
    }
    
    /// Get a dependency by name
    pub fn get_dependency(&self, name: &str) -> Option<&NamedDependency> {
        self.dependencies.iter().find(|d| d.name == name)
            .or_else(|| self.dev_dependencies.iter().find(|d| d.name == name))
    }
    
    /// Update a dependency's version
    pub fn update_dependency_version(&mut self, name: &str, version: String) -> bool {
        if let Some(dep) = self.dependencies.iter_mut().find(|d| d.name == name) {
            dep.version = version;
            return true;
        }
        if let Some(dep) = self.dev_dependencies.iter_mut().find(|d| d.name == name) {
            dep.version = version;
            return true;
        }
        false
    }
}
