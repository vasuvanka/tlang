// Build cache for incremental compilation

use std::collections::{HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use sha2::{Sha256, Digest};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FileMetadata {
    pub hash: String,
    pub dependencies: Vec<String>,  // Imported packages/files
    pub last_compiled: Option<u64>, // Timestamp
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BuildCacheData {
    pub files: HashMap<String, FileMetadata>,
    pub build_config_hash: String,  // Hash of build config to invalidate on config changes
}

#[derive(Debug, Clone)]
pub struct BuildCache {
    cache_dir: PathBuf,
    data: BuildCacheData,
}

impl BuildCache {
    pub fn new<P: AsRef<Path>>(cache_dir: P) -> Self {
        let cache_path = cache_dir.as_ref().join(".tlang_cache");
        fs::create_dir_all(&cache_path).ok();
        
        BuildCache {
            cache_dir: cache_path,
            data: BuildCacheData {
                files: HashMap::new(),
                build_config_hash: String::new(),
            },
        }
    }
    
    /// Calculate SHA256 hash of file contents
    pub fn hash_file<P: AsRef<Path>>(path: P) -> Option<String> {
        let content = fs::read_to_string(path).ok()?;
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        let hash = hasher.finalize();
        Some(format!("{:x}", hash))
    }
    
    /// Check if file has changed since last build
    pub fn is_file_changed<P: AsRef<Path>>(&mut self, path: P) -> bool {
        let path_str = path.as_ref().to_string_lossy().to_string();
        let canonical_path = match path.as_ref().canonicalize() {
            Ok(p) => p.to_string_lossy().to_string(),
            Err(_) => path_str.clone(),
        };
        
        let current_hash = match Self::hash_file(path.as_ref()) {
            Some(h) => h,
            None => return true, // Can't hash = assume changed
        };
        
        let cached = self.data.files.get(&canonical_path);
        
        if let Some(metadata) = cached {
            if metadata.hash != current_hash {
                // Update hash
                self.data.files.insert(canonical_path, FileMetadata {
                    hash: current_hash,
                    dependencies: metadata.dependencies.clone(),
                    last_compiled: metadata.last_compiled,
                });
                return true;
            }
            false
        } else {
            // New file
            self.data.files.insert(canonical_path, FileMetadata {
                hash: current_hash,
                dependencies: Vec::new(),
                last_compiled: None,
            });
            true
        }
    }
    
    /// Record file dependencies (imports)
    pub fn set_file_dependencies<P: AsRef<Path>>(&mut self, path: P, dependencies: Vec<String>) {
        let path_str = match path.as_ref().canonicalize() {
            Ok(p) => p.to_string_lossy().to_string(),
            Err(_) => path.as_ref().to_string_lossy().to_string(),
        };
        
        let current_hash = Self::hash_file(path.as_ref()).unwrap_or_default();
        
        self.data.files.insert(path_str.clone(), FileMetadata {
            hash: current_hash,
            dependencies,
            last_compiled: None,
        });
    }
    
    /// Get files that need recompilation (changed files + their dependents)
    pub fn get_files_to_recompile<P: AsRef<Path>>(&mut self, source_files: &[P]) -> HashSet<String> {
        let mut to_recompile = HashSet::new();
        
        // First, check which files have changed
        for file in source_files {
            if self.is_file_changed(file) {
                let path_str = match file.as_ref().canonicalize() {
                    Ok(p) => p.to_string_lossy().to_string(),
                    Err(_) => file.as_ref().to_string_lossy().to_string(),
                };
                to_recompile.insert(path_str);
            }
        }
        
        // Find all files that depend on changed files
        let mut changed = to_recompile.clone();
        loop {
            let mut new_dependents = HashSet::new();
            
            for (file_path, metadata) in &self.data.files {
                // If any dependency is in changed set, this file needs recompilation
                for dep in &metadata.dependencies {
                    if changed.contains(dep) {
                        new_dependents.insert(file_path.clone());
                        break;
                    }
                }
            }
            
            if new_dependents.is_empty() {
                break;
            }
            
            for dep in &new_dependents {
                changed.insert(dep.clone());
                to_recompile.insert(dep.clone());
            }
        }
        
        to_recompile
    }
    
    /// Check if build config has changed
    pub fn is_config_changed(&self, config_hash: &str) -> bool {
        self.data.build_config_hash != config_hash
    }
    
    /// Update build config hash
    pub fn set_config_hash(&mut self, config_hash: String) {
        self.data.build_config_hash = config_hash;
    }
    
    /// Load cache from disk
    pub fn load(&mut self) {
        let cache_file = self.cache_dir.join("cache.json");
        if let Ok(content) = fs::read_to_string(&cache_file) {
            if let Ok(data) = serde_json::from_str::<BuildCacheData>(&content) {
                self.data = data;
            }
        }
    }
    
    /// Save cache to disk
    pub fn save(&self) {
        let cache_file = self.cache_dir.join("cache.json");
        if let Ok(json) = serde_json::to_string_pretty(&self.data) {
            fs::write(cache_file, json).ok();
        }
    }
    
    /// Clear the cache
    pub fn clear(&mut self) {
        self.data.files.clear();
        self.data.build_config_hash.clear();
        if self.cache_dir.exists() {
            fs::remove_dir_all(&self.cache_dir).ok();
            fs::create_dir_all(&self.cache_dir).ok();
        }
    }
    
    /// Get cache directory path
    pub fn cache_dir(&self) -> &Path {
        &self.cache_dir
    }
    
    /// Check if any source files have changed
    pub fn has_changes<P: AsRef<Path>>(&mut self, source_files: &[P]) -> bool {
        for file in source_files {
            if self.is_file_changed(file) {
                return true;
            }
        }
        false
    }
    
    /// Get cached file metadata
    pub fn get_file_metadata<P: AsRef<Path>>(&self, path: P) -> Option<&FileMetadata> {
        let path_str = match path.as_ref().canonicalize() {
            Ok(p) => p.to_string_lossy().to_string(),
            Err(_) => path.as_ref().to_string_lossy().to_string(),
        };
        self.data.files.get(&path_str)
    }
    
    /// Mark file as compiled
    pub fn mark_compiled<P: AsRef<Path>>(&mut self, path: P) {
        let path_str = match path.as_ref().canonicalize() {
            Ok(p) => p.to_string_lossy().to_string(),
            Err(_) => path.as_ref().to_string_lossy().to_string(),
        };
        
        if let Some(metadata) = self.data.files.get_mut(&path_str) {
            use std::time::{SystemTime, UNIX_EPOCH};
            metadata.last_compiled = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .ok()
                .map(|d| d.as_secs());
        }
    }
}
