// Go-get style: fetch dependencies from HTTP/Git before build or run

use std::path::Path;
use std::io::Cursor;
use crate::error::{CompileError, CompileResult};
use crate::build::config::{DependencySource, ProjectConfig};

/// Ensure all dependencies that have remote sources (HTTP/Git) are downloaded
/// into project_root/dependencies/<name>. Called automatically before run/compile.
pub fn ensure_dependencies(project_root: &Path, config: &ProjectConfig) -> CompileResult<()> {
    let deps_dir = project_root.join("dependencies");
    std::fs::create_dir_all(&deps_dir).map_err(|e| {
        CompileError::codegen(
            format!("Failed to create dependencies directory: {}", e),
            None,
        )
    })?;

    for dep in &config.dependencies {
        if dep.optional {
            continue;
        }
        if config.ignore.contains(&dep.name) {
            continue;
        }
        let package_dir = deps_dir.join(&dep.name);
        if package_dir.exists() {
            continue;
        }
        match &dep.source {
            DependencySource::Path { .. } => {}
            DependencySource::Http { http, .. } => {
                download_package(project_root, http, &dep.name)?;
            }
            DependencySource::Git { git, branch, tag, .. } => {
                let url = git_to_archive_url(git, branch.as_deref(), tag.as_deref())?;
                download_package(project_root, &url, &dep.name)?;
            }
            DependencySource::Registry { .. } => {
                return Err(CompileError::codegen(
                    format!("Registry dependency '{}' not supported yet. Use http or git.", dep.name),
                    None,
                ));
            }
        }
    }
    Ok(())
}

fn git_to_archive_url(git: &str, branch: Option<&str>, tag: Option<&str>) -> CompileResult<String> {
    // GitHub: https://github.com/user/repo/archive/refs/heads/main.zip
    let ref_part = if let Some(t) = tag {
        format!("refs/tags/{}", t)
    } else if let Some(b) = branch {
        format!("refs/heads/{}", b)
    } else {
        "refs/heads/main".to_string()
    };
    let git = git.trim_end_matches('/').trim_end_matches(".git");
    let rest = if let Some(r) = git.strip_prefix("https://") {
        r.to_string()
    } else if let Some(r) = git.strip_prefix("http://") {
        r.to_string()
    } else if let Some(r) = git.strip_prefix("git@github.com:") {
        format!("github.com/{}", r)
    } else if git.starts_with("github.com/") {
        git.to_string()
    } else {
        return Err(CompileError::codegen(
            format!("Unsupported git URL: {}. Use https://github.com/user/repo", git),
            None,
        ));
    };
    if !rest.starts_with("github.com/") {
        return Err(CompileError::codegen(
            format!("Only GitHub git URLs supported for now: {}", git),
            None,
        ));
    }
    Ok(format!("https://{}/archive/{}.zip", rest, ref_part))
}

fn download_package(project_root: &Path, url: &str, package_name: &str) -> CompileResult<()> {
    let deps_dir = project_root.join("dependencies");
    let package_dir = deps_dir.join(package_name);
    if package_dir.exists() {
        return Ok(());
    }
    println!("Getting {}...", package_name);
    let response = reqwest::blocking::get(url).map_err(|e| {
        CompileError::codegen(format!("Failed to download {}: {}", package_name, e), None)
    })?;
    if !response.status().is_success() {
        return Err(CompileError::codegen(
            format!("HTTP {} when fetching {}", response.status(), url),
            None,
        ));
    }
    let content_type: String = response
        .headers()
        .get("content-type")
        .and_then(|h| h.to_str().ok())
        .unwrap_or("")
        .to_string();
    let bytes = response.bytes().map_err(|e| {
        CompileError::codegen(format!("Failed to read response: {}", e), None)
    })?;
    let is_archive = url.ends_with(".zip")
        || url.ends_with(".tar.gz")
        || url.ends_with(".tar")
        || url.ends_with(".tgz")
        || content_type.contains("zip")
        || content_type.contains("tar")
        || content_type.contains("gzip");
    if is_archive {
        extract_archive(&bytes, &package_dir, url)?;
    } else {
        std::fs::create_dir_all(&package_dir).map_err(|e| {
            CompileError::codegen(format!("Failed to create directory: {}", e), None)
        })?;
        let filename = url.split('/').last().unwrap_or("mod.tl");
        let path = package_dir.join(filename);
        std::fs::write(&path, &bytes).map_err(|e| {
            CompileError::codegen(format!("Failed to write file: {}", e), None)
        })?;
    }
    println!("  ✓ {}", package_name);
    Ok(())
}

fn extract_archive(bytes: &[u8], dest_dir: &Path, url: &str) -> CompileResult<()> {
    if url.ends_with(".zip") || url.contains("/archive/") {
        extract_zip(bytes, dest_dir, url)?;
        return Ok(());
    }
    if url.ends_with(".tar.gz") || url.ends_with(".tgz") || url.ends_with(".tar") {
        extract_tar(bytes, dest_dir, url)?;
        return Ok(());
    }
    Err(CompileError::codegen(
        "Unsupported archive format. Use .zip or .tar.gz".to_string(),
        None,
    ))
}

fn extract_zip(bytes: &[u8], dest_dir: &Path, _url: &str) -> CompileResult<()> {
    let cursor = Cursor::new(bytes);
    let mut archive = zip::ZipArchive::new(cursor).map_err(|e| {
        CompileError::codegen(format!("Invalid ZIP: {}", e), None)
    })?;
    std::fs::create_dir_all(dest_dir).map_err(|e| {
        CompileError::codegen(format!("Failed to create directory: {}", e), None)
    })?;
    let mut common_prefix: Option<String> = None;
    for i in 0..archive.len() {
        let file = archive.by_index(i).map_err(|e| {
            CompileError::codegen(format!("Failed to read ZIP entry: {}", e), None)
        })?;
        let name = file.name();
        if let Some(idx) = name.find('/') {
            let prefix = &name[..idx];
            match &common_prefix {
                None => common_prefix = Some(prefix.to_string()),
                Some(p) if p == prefix => {}
                _ => {
                    common_prefix = None;
                    break;
                }
            }
        } else {
            common_prefix = None;
            break;
        }
    }
    for i in 0..archive.len() {
        let mut file = archive.by_index(i).map_err(|e| {
            CompileError::codegen(format!("Failed to read ZIP entry: {}", e), None)
        })?;
        let mut name = file.name().to_string();
        if let Some(ref p) = common_prefix {
            if name.starts_with(p) {
                name = name[p.len()..].trim_start_matches('/').to_string();
            }
        }
        if name.is_empty() {
            continue;
        }
        let out = dest_dir.join(&name);
        if name.ends_with('/') {
            std::fs::create_dir_all(&out).map_err(|e| {
                CompileError::codegen(format!("Failed to create dir: {}", e), None)
            })?;
        } else {
            if let Some(parent) = out.parent() {
                std::fs::create_dir_all(parent).map_err(|e| {
                    CompileError::codegen(format!("Failed to create dir: {}", e), None)
                })?;
            }
            let mut f = std::fs::File::create(&out).map_err(|e| {
                CompileError::codegen(format!("Failed to create file: {}", e), None)
            })?;
            std::io::copy(&mut file, &mut f).map_err(|e| {
                CompileError::codegen(format!("Failed to extract: {}", e), None)
            })?;
        }
    }
    Ok(())
}

fn extract_tar(bytes: &[u8], dest_dir: &Path, url: &str) -> CompileResult<()> {
    let cursor = Cursor::new(bytes);
    let reader: Box<dyn std::io::Read> = if url.ends_with(".tar.gz") || url.ends_with(".tgz") {
        Box::new(flate2::read::GzDecoder::new(cursor))
    } else {
        Box::new(cursor)
    };
    let mut archive = tar::Archive::new(reader);
    let mut common_prefix: Option<String> = None;
    {
        let entries = archive.entries().map_err(|e| {
            CompileError::codegen(format!("Failed to read TAR: {}", e), None)
        })?;
        for entry in entries {
            let entry = entry.map_err(|e| {
                CompileError::codegen(format!("TAR entry: {}", e), None)
            })?;
            let path = entry.path().map_err(|e| {
                CompileError::codegen(format!("TAR path: {}", e), None)
            })?;
            let s = path.to_string_lossy();
            if let Some(idx) = s.find('/') {
                let prefix = &s[..idx];
                match &common_prefix {
                    None => common_prefix = Some(prefix.to_string()),
                    Some(p) if p == prefix => {}
                    _ => {
                        common_prefix = None;
                        break;
                    }
                }
            } else {
                common_prefix = None;
                break;
            }
        }
    }
    let cursor = Cursor::new(bytes);
    let reader: Box<dyn std::io::Read> = if url.ends_with(".tar.gz") || url.ends_with(".tgz") {
        Box::new(flate2::read::GzDecoder::new(cursor))
    } else {
        Box::new(cursor)
    };
    let mut archive = tar::Archive::new(reader);
    let entries = archive.entries().map_err(|e| {
        CompileError::codegen(format!("Failed to read TAR: {}", e), None)
    })?;
    for entry in entries {
        let mut entry = entry.map_err(|e| {
            CompileError::codegen(format!("TAR entry: {}", e), None)
        })?;
        let path = entry.path().map_err(|e| {
            CompileError::codegen(format!("TAR path: {}", e), None)
        })?;
        let mut name = path.to_string_lossy().to_string();
        if let Some(ref p) = common_prefix {
            if name.starts_with(p) {
                name = name[p.len()..].trim_start_matches('/').to_string();
            }
        }
        if name.is_empty() {
            continue;
        }
        let out = dest_dir.join(&name);
        if entry.header().entry_type().is_dir() {
            std::fs::create_dir_all(&out).map_err(|e| {
                CompileError::codegen(format!("Failed to create dir: {}", e), None)
            })?;
        } else {
            if let Some(parent) = out.parent() {
                std::fs::create_dir_all(parent).map_err(|e| {
                    CompileError::codegen(format!("Failed to create dir: {}", e), None)
                })?;
            }
            let mut f = std::fs::File::create(&out).map_err(|e| {
                CompileError::codegen(format!("Failed to create file: {}", e), None)
            })?;
            std::io::copy(&mut entry, &mut f).map_err(|e| {
                CompileError::codegen(format!("Failed to extract: {}", e), None)
            })?;
        }
    }
    Ok(())
}
