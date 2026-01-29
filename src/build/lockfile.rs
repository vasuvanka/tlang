// Dependency lock file (config.lock) - similar to Cargo.lock or go.sum

use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;
use crate::error::{CompileError, CompileResult};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LockFile {
    pub version: String,
    pub dependencies: Vec<LockedDependency>,
    #[serde(default)]
    pub indirect_dependencies: Vec<LockedDependency>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LockedDependency {
    pub name: String,
    pub version: String,
    pub source: DependencySourceLocked,
    pub checksum: Option<String>, // SHA256 hash for integrity
    pub dependencies: Vec<String>, // Names of direct dependencies
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum DependencySourceLocked {
    #[serde(rename = "path")]
    Path { path: String },
    #[serde(rename = "http")]
    Http {
        url: String,
        version: Option<String>,
    },
    #[serde(rename = "git")]
    Git {
        url: String,
        branch: Option<String>,
        tag: Option<String>,
        rev: Option<String>,
    },
    #[serde(rename = "registry")]
    Registry { registry: String, version: String },
}

impl LockFile {
    pub fn new() -> Self {
        LockFile {
            version: "1".to_string(),
            dependencies: Vec::new(),
            indirect_dependencies: Vec::new(),
        }
    }
    
    /// Load lock file from disk
    pub fn load<P: AsRef<Path>>(project_dir: P) -> CompileResult<Self> {
        let lock_path = project_dir.as_ref().join("config.lock");
        
        if !lock_path.exists() {
            return Ok(LockFile::new());
        }
        
        let content = fs::read_to_string(&lock_path).map_err(|e| {
            CompileError::codegen(
                format!("Failed to read lock file: {}", e),
                None,
            )
        })?;
        
        let lock: LockFile = toml::from_str(&content).map_err(|e| {
            CompileError::codegen(
                format!("Failed to parse lock file: {}", e),
                None,
            )
        })?;
        
        Ok(lock)
    }
    
    /// Save lock file to disk
    pub fn save<P: AsRef<Path>>(&self, project_dir: P) -> CompileResult<()> {
        let lock_path = project_dir.as_ref().join("config.lock");
        
        let content = toml::to_string_pretty(self).map_err(|e| {
            CompileError::codegen(
                format!("Failed to serialize lock file: {}", e),
                None,
            )
        })?;
        
        fs::write(&lock_path, content).map_err(|e| {
            CompileError::codegen(
                format!("Failed to write lock file: {}", e),
                None,
            )
        })?;
        
        Ok(())
    }
    
    /// Find a locked dependency by name
    pub fn find_dependency(&self, name: &str) -> Option<&LockedDependency> {
        self.dependencies.iter()
            .chain(self.indirect_dependencies.iter())
            .find(|dep| dep.name == name)
    }
    
    /// Add or update a dependency in the lock file
    pub fn add_dependency(&mut self, dep: LockedDependency, is_indirect: bool) {
        // Remove if exists
        self.dependencies.retain(|d| d.name != dep.name);
        self.indirect_dependencies.retain(|d| d.name != dep.name);
        
        if is_indirect {
            self.indirect_dependencies.push(dep);
        } else {
            self.dependencies.push(dep);
        }
    }
    
    /// Get all dependencies (direct + indirect)
    pub fn all_dependencies(&self) -> Vec<&LockedDependency> {
        self.dependencies.iter()
            .chain(self.indirect_dependencies.iter())
            .collect()
    }
}
