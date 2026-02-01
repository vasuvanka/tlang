// Tlang build system CLI
// Usage: tlang-build [command] [options]

use std::env;
use std::path::{Path, PathBuf};
use tlang::build::Builder;
use tlang::error::CompileError;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        print_usage();
        std::process::exit(1);
    }
    
    let command = &args[1];
    
    // Get project directory from args or use current directory
    // For add/remove/upgrade: args[2] = package spec, args[3] = optional directory
    // For build/clean: args[2] = optional directory
    // For init: args[2] = app_name (optional), args[3] = optional directory
    let (project_root, app_name) = if matches!(command.as_str(), "add" | "remove" | "upgrade") {
        // Package commands: directory is args[3] if it exists
        let dir = if args.len() > 3 {
            PathBuf::from(&args[3])
        } else {
            env::current_dir().unwrap_or_else(|_| PathBuf::from("."))
        };
        (dir, None)
    } else if command.as_str() == "init" {
        // Init: args[2] = app_name (optional), args[3] = optional directory
        // Parse app_name and directory from remaining args
        let mut parsed_app_name = None;
        let mut parsed_dir = None;
        
        if args.len() > 2 {
            let arg2 = &args[2];
            // Check if it looks like a directory path (starts with . or / or contains path separators)
            let path_sep = std::path::MAIN_SEPARATOR.to_string();
            if arg2.starts_with('.') || arg2.starts_with('/') || arg2.contains(&path_sep) {
                // It's a directory path
                parsed_dir = Some(PathBuf::from(arg2));
            } else {
                // It's likely an app name
                parsed_app_name = Some(arg2.clone());
                // Check if there's a third arg for directory
                if args.len() > 3 {
                    parsed_dir = Some(PathBuf::from(&args[3]));
                }
            }
        }
        
        let dir = parsed_dir.unwrap_or_else(|| env::current_dir().unwrap_or_else(|_| PathBuf::from(".")));
        (dir, parsed_app_name)
    } else {
        // Build/clean: directory is args[2] if it exists
        let dir = if args.len() > 2 {
            PathBuf::from(&args[2])
        } else {
            env::current_dir().unwrap_or_else(|_| PathBuf::from("."))
        };
        (dir, None)
    };
    
    match command.as_str() {
        "build" => {
            match build_project(&project_root) {
                Ok(binary) => {
                    println!("✓ Build successful!");
                    println!("  Binary: {}", binary.display());
                }
                Err(e) => {
                    eprintln!("✗ Build failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "clean" => {
            match clean_project(&project_root) {
                Ok(_) => {
                    println!("✓ Clean successful!");
                }
                Err(e) => {
                    eprintln!("✗ Clean failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "init" => {
            match init_project(&project_root, app_name.as_deref()) {
                Ok(_) => {
                    println!("✓ Project initialized!");
                }
                Err(e) => {
                    eprintln!("✗ Init failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "add" => {
            if args.len() < 3 {
                eprintln!("Error: Package name required");
                eprintln!("Usage: tlang-build add <package>@<version> [directory]");
                std::process::exit(1);
            }
            // Package spec is always args[2], directory is optional last arg
            let package_spec = &args[2];
            match add_package(&project_root, package_spec) {
                Ok(_) => {
                    println!("✓ Package added successfully!");
                }
                Err(e) => {
                    eprintln!("✗ Add failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "remove" => {
            if args.len() < 3 {
                eprintln!("Error: Package name required");
                eprintln!("Usage: tlang-build remove <package> [directory]");
                std::process::exit(1);
            }
            // Package name is always args[2], directory is optional last arg
            let package_name = &args[2];
            match remove_package(&project_root, package_name) {
                Ok(_) => {
                    println!("✓ Package removed successfully!");
                }
                Err(e) => {
                    eprintln!("✗ Remove failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "upgrade" => {
            if args.len() < 3 {
                eprintln!("Error: Package name required (use '.' or '*' for all packages)");
                eprintln!("Usage: tlang-build upgrade <package|.|*> [directory]");
                std::process::exit(1);
            }
            // Package spec is always args[2], directory is optional last arg
            let package_spec = &args[2];
            match upgrade_package(&project_root, package_spec) {
                Ok(_) => {
                    println!("✓ Upgrade completed!");
                }
                Err(e) => {
                    eprintln!("✗ Upgrade failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "lint" => {
            match lint_project(&project_root) {
                Ok(issues) => {
                    let errors: Vec<_> = issues.iter().filter(|i| i.level == tlang::linter::LintLevel::Error).collect();
                    let warnings: Vec<_> = issues.iter().filter(|i| i.level == tlang::linter::LintLevel::Warning).collect();
                    let infos: Vec<_> = issues.iter().filter(|i| i.level == tlang::linter::LintLevel::Info).collect();
                    
                    if errors.is_empty() && warnings.is_empty() && infos.is_empty() {
                        println!("✓ No linting issues found!");
                        std::process::exit(0);
                    }
                    
                    if !errors.is_empty() {
                        eprintln!("\n✗ Found {} error(s):", errors.len());
                        for issue in &errors {
                            eprintln!("  {}:{}:{} [{}] {}", 
                                issue.location.filename,
                                issue.location.line,
                                issue.location.column,
                                issue.code,
                                issue.message
                            );
                        }
                    }
                    
                    if !warnings.is_empty() {
                        println!("\n⚠ Found {} warning(s):", warnings.len());
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
                    
                    if !infos.is_empty() {
                        println!("\nℹ Found {} info(s):", infos.len());
                        for issue in &infos {
                            println!("  {}:{}:{} [{}] {}", 
                                issue.location.filename,
                                issue.location.line,
                                issue.location.column,
                                issue.code,
                                issue.message
                            );
                        }
                    }
                    
                    if !errors.is_empty() {
                        std::process::exit(1);
                    }
                }
                Err(e) => {
                    eprintln!("✗ Lint failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "fmt" => {
            let check_only = args.len() > 2 && args[2] == "--check";
            match format_project(&project_root, !check_only) {
                Ok(count) => {
                    if check_only {
                        if count > 0 {
                            println!("✗ {} file(s) need formatting. Run 'tlang fmt' to fix.", count);
                            std::process::exit(1);
                        } else {
                            println!("✓ All files are properly formatted!");
                            std::process::exit(0);
                        }
                    } else {
                        println!("✓ Formatted {} file(s)", count);
                    }
                }
                Err(e) => {
                    eprintln!("✗ Format failed: {}", e);
                    std::process::exit(1);
                }
            }
        }
        "version" => {
            println!("{}", env!("CARGO_PKG_VERSION"));
            std::process::exit(0);
        }
        _ => {
            eprintln!("Unknown command: {}", command);
            print_usage();
            std::process::exit(1);
        }
    }
}

fn print_usage() {
    println!("Tlang Build System");
    println!();
    println!("Usage: tlang-build <command> [options] [directory]");
    println!();
    println!("Commands:");
    println!("  build [dir]              Build the project (compile once, run anywhere)");
    println!("  clean [dir]              Clean build artifacts");
    println!("  init [app_name] [dir]    Initialize a new project with config.toml");
    println!("  lint [dir]               Lint all source files");
    println!("  fmt [--check] [dir]      Format all source files (--check to verify only)");
    println!("  add <package>@<version> [dir]  Add a package dependency");
    println!("  remove <package> [dir]        Remove a package dependency");
    println!("  upgrade <package|.|*> [dir]   Upgrade package(s) to latest version");
    println!("  version                  Show version information");
    println!();
    println!("If directory is not specified, uses current directory.");
}

fn build_project(project_root: &PathBuf) -> Result<PathBuf, CompileError> {
    let mut builder = Builder::new(project_root)?;
    builder.build()
}

fn clean_project(project_root: &PathBuf) -> Result<(), CompileError> {
    let mut builder = Builder::new(project_root)?;
    builder.clean()
}

fn lint_project(project_root: &PathBuf) -> Result<Vec<tlang::linter::LintIssue>, CompileError> {
    let builder = Builder::new(project_root)?;
    builder.lint_all_files()
}

fn format_project(project_root: &PathBuf, write: bool) -> Result<usize, CompileError> {
    let mut builder = Builder::new(project_root)?;
    builder.format_all_files(write)
}

fn init_project(project_root: &PathBuf, app_name: Option<&str>) -> Result<(), CompileError> {
    use std::fs;
    use tlang::build::config::{ProjectConfig, BuildConfig};
    
    let config_path = project_root.join("config.toml");
    
    if config_path.exists() {
        return Err(CompileError::codegen(
            "config.toml already exists".to_string(),
            None,
        ));
    }
    
    // Determine project name: use provided app_name, or directory name, or default
    let project_name = app_name
        .map(|s| s.to_string())
        .or_else(|| {
            project_root
                .file_name()
                .and_then(|n| n.to_str())
                .map(|s| s.to_string())
        })
        .unwrap_or_else(|| "myproject".to_string());
    
    // Create src directory
    let src_dir = project_root.join("src");
    fs::create_dir_all(&src_dir).map_err(|e| {
        CompileError::codegen(format!("Failed to create src directory: {}", e), None)
    })?;
    
    // Create prarambham.tl in src directory
    let entry_file_path = "src/prarambham.tl";
    let prarambham_file = project_root.join(entry_file_path);
    let prarambham_content = "@fmt = #dhimpu(\"fmt\");\n\n#prarambham() {{\n    fmt.Printf(\"Hello, World!\\n\");\n}}\n".to_string();
    fs::write(&prarambham_file, prarambham_content).map_err(|e| {
        CompileError::codegen(format!("Failed to write {}: {}", entry_file_path, e), None)
    })?;
    
    // Create config with entry_file pointing to src/prarambham.tl
    let mut build_config = BuildConfig::default();
    build_config.entry_file = Some(entry_file_path.to_string());
    
    let config = ProjectConfig {
        package: tlang::build::config::PackageInfo {
            name: project_name.clone(),
            version: "1.0.0".to_string(),
            description: "A Tlang project".to_string(),
            author: String::new(),
        },
        build: build_config,
        dependencies: Vec::new(),
        dev_dependencies: Vec::new(),
        ignore: Vec::new(),
    };
    
    config.save(project_root)?;
    
    println!("Created project: {}", project_name);
    println!("  Entry file: {}", entry_file_path);
    println!("  Config: config.toml");
    
    Ok(())
}

fn add_package(project_root: &PathBuf, package_spec: &str) -> Result<(), CompileError> {
    use tlang::build::config::{ProjectConfig, DependencySource};
    
    // Check if package_spec is an HTTP/HTTPS URL
    let is_http_url = package_spec.starts_with("http://") || package_spec.starts_with("https://");
    
    let (name, version, source) = if is_http_url {
        // HTTP/HTTPS URL - download the package
        println!("Downloading package from: {}", package_spec);
        
        // Extract package name from URL (use last path segment or domain)
        let url_name = extract_package_name_from_url(package_spec);
        let (pkg_name, pkg_version) = if let Some(at_pos) = url_name.find('@') {
            (url_name[..at_pos].to_string(), url_name[at_pos + 1..].to_string())
        } else {
            (url_name, String::new())
        };
        
        // Download and extract package
        let _dep_path = download_package_from_http(project_root, package_spec, &pkg_name)?;
        
        let source = DependencySource::Http {
            http: package_spec.to_string(),
            version: if pkg_version.is_empty() { None } else { Some(pkg_version.clone()) },
        };
        
        (pkg_name, pkg_version, source)
    } else {
        // Parse package@version or package
        let (name, version) = if let Some(at_pos) = package_spec.find('@') {
            let name = package_spec[..at_pos].to_string();
            let version = package_spec[at_pos + 1..].to_string();
            (name, version)
        } else {
            (package_spec.to_string(), String::new())
        };
        
        // For now, assume path dependency (relative to project root)
        let default_path = format!("../{}", name);
        let source = DependencySource::Path { path: default_path };
        
        (name, version, source)
    };
    
    // Load config
    let mut config = ProjectConfig::load(project_root)?;
    
    // Check if already exists
    if config.get_dependency(&name).is_some() {
        return Err(CompileError::codegen(
            format!("Package '{}' already exists in dependencies", name),
            None,
        ));
    }
    
    config.add_dependency(name.clone(), source, version.clone());
    config.save(project_root)?;
    
    if is_http_url {
        println!("✓ Added dependency: {} (downloaded from {})", name, package_spec);
    } else {
        println!("✓ Added dependency: {}", name);
        println!("Note: Update the path in config.toml if the package is located elsewhere");
    }
    
    Ok(())
}

fn extract_package_name_from_url(url: &str) -> String {
    // Try to extract package name from URL
    // Examples:
    // https://example.com/packages/utils -> utils
    // https://example.com/packages/utils@1.0.0 -> utils@1.0.0
    // https://example.com/utils.tar.gz -> utils
    
    if let Some(last_slash) = url.rfind('/') {
        let after_slash = &url[last_slash + 1..];
        // Remove common archive extensions
        let name = after_slash
            .trim_end_matches(".tar.gz")
            .trim_end_matches(".tar")
            .trim_end_matches(".zip")
            .trim_end_matches(".tgz");
        
        if !name.is_empty() {
            return name.to_string();
        }
    }
    
    // Fallback: use domain name
    if let Some(domain_start) = url.find("://") {
        let after_proto = &url[domain_start + 3..];
        if let Some(domain_end) = after_proto.find('/') {
            return after_proto[..domain_end].replace('.', "_").to_string();
        }
        return after_proto.replace('.', "_").to_string();
    }
    
    "package".to_string()
}

fn download_package_from_http(
    project_root: &Path,
    url: &str,
    package_name: &str,
) -> Result<PathBuf, CompileError> {
    
    // Create dependencies directory
    let deps_dir = project_root.join("dependencies");
    std::fs::create_dir_all(&deps_dir).map_err(|e| {
        CompileError::codegen(format!("Failed to create dependencies directory: {}", e), None)
    })?;
    
    let package_dir = deps_dir.join(package_name);
    
    // Check if already downloaded
    if package_dir.exists() {
        println!("Package already downloaded at: {}", package_dir.display());
        return Ok(package_dir);
    }
    
    println!("Downloading from: {}", url);
    
    // Download the file
    let response = reqwest::blocking::get(url).map_err(|e| {
        CompileError::codegen(format!("Failed to download package: {}", e), None)
    })?;
    
    if !response.status().is_success() {
        return Err(CompileError::codegen(
            format!("HTTP error: {}", response.status()),
            None,
        ));
    }
    
    let content_type = response.headers()
        .get("content-type")
        .and_then(|h| h.to_str().ok())
        .unwrap_or("")
        .to_string();
    
    let bytes = response.bytes().map_err(|e| {
        CompileError::codegen(format!("Failed to read response: {}", e), None)
    })?;
    
    // Determine if it's an archive or a single file
    let is_archive = url.ends_with(".zip") || url.ends_with(".tar.gz") || url.ends_with(".tar") || url.ends_with(".tgz")
        || content_type.contains("zip") || content_type.contains("tar") || content_type.contains("gzip");
    
    if is_archive {
        // Extract archive
        extract_archive(&bytes, &package_dir, url)?;
    } else {
        // Single file - check if it's a .tl file or create a directory structure
        if url.ends_with(".tl") {
            // Single .tl file - create package directory and save it
            std::fs::create_dir_all(&package_dir).map_err(|e| {
                CompileError::codegen(format!("Failed to create package directory: {}", e), None)
            })?;
            
            let filename = url.split('/').last().unwrap_or("prarambham.tl");
            let file_path = package_dir.join(filename);
            std::fs::write(&file_path, &bytes).map_err(|e| {
                CompileError::codegen(format!("Failed to write file: {}", e), None)
            })?;
        } else {
            // Assume it's a directory structure (maybe a tar.gz without extension)
            // Try to extract as archive first, fallback to creating a single file
            if extract_archive(&bytes, &package_dir, url).is_err() {
                // Fallback: create a simple package structure
                std::fs::create_dir_all(&package_dir).map_err(|e| {
                    CompileError::codegen(format!("Failed to create package directory: {}", e), None)
                })?;
                
                let filename = url.split('/').last().unwrap_or("package.tl");
                let file_path = package_dir.join(filename);
                std::fs::write(&file_path, &bytes).map_err(|e| {
                    CompileError::codegen(format!("Failed to write file: {}", e), None)
                })?;
            }
        }
    }
    
    println!("✓ Package downloaded to: {}", package_dir.display());
    Ok(package_dir)
}

fn extract_archive(
    bytes: &[u8],
    dest_dir: &Path,
    url: &str,
) -> Result<(), CompileError> {
    use std::io::Cursor;
    
    // Try ZIP first
    if url.ends_with(".zip") || url.contains("zip") {
        let cursor = Cursor::new(bytes);
        let mut archive = zip::ZipArchive::new(cursor).map_err(|e| {
            CompileError::codegen(format!("Failed to open ZIP archive: {}", e), None)
        })?;
        
        std::fs::create_dir_all(dest_dir).map_err(|e| {
            CompileError::codegen(format!("Failed to create destination directory: {}", e), None)
        })?;
        
        // Find common prefix (top-level directory) to strip
        let mut common_prefix: Option<String> = None;
        for i in 0..archive.len() {
            let file = archive.by_index(i).map_err(|e| {
                CompileError::codegen(format!("Failed to read file from ZIP: {}", e), None)
            })?;
            let name = file.name();
            if let Some(first_slash) = name.find('/') {
                let prefix = &name[..first_slash];
                if common_prefix.is_none() {
                    common_prefix = Some(prefix.to_string());
                } else if common_prefix.as_ref() != Some(&prefix.to_string()) {
                    common_prefix = None;
                    break;
                }
            } else {
                common_prefix = None;
                break;
            }
        }
        
        // Extract files
        for i in 0..archive.len() {
            let mut file = archive.by_index(i).map_err(|e| {
                CompileError::codegen(format!("Failed to read file from ZIP: {}", e), None)
            })?;
            
            let mut file_name = file.name().to_string();
            // Strip common prefix if found
            if let Some(ref prefix) = common_prefix {
                if file_name.starts_with(prefix) {
                    file_name = file_name[prefix.len()..].trim_start_matches('/').to_string();
                }
            }
            
            if file_name.is_empty() {
                continue;
            }
            
            let outpath = dest_dir.join(&file_name);
            
            if file_name.ends_with('/') {
                std::fs::create_dir_all(&outpath).map_err(|e| {
                    CompileError::codegen(format!("Failed to create directory: {}", e), None)
                })?;
            } else {
                if let Some(parent) = outpath.parent() {
                    std::fs::create_dir_all(parent).map_err(|e| {
                        CompileError::codegen(format!("Failed to create parent directory: {}", e), None)
                    })?;
                }
                
                let mut outfile = std::fs::File::create(&outpath).map_err(|e| {
                    CompileError::codegen(format!("Failed to create file: {}", e), None)
                })?;
                std::io::copy(&mut file, &mut outfile).map_err(|e| {
                    CompileError::codegen(format!("Failed to extract file: {}", e), None)
                })?;
            }
        }
        
        return Ok(());
    }
    
    // Try TAR (including .tar.gz)
    if url.ends_with(".tar.gz") || url.ends_with(".tar") || url.ends_with(".tgz") || url.contains("tar") {
        let cursor = Cursor::new(bytes);
        
        // Handle gzip compression
        let reader: Box<dyn std::io::Read> = if url.ends_with(".tar.gz") || url.ends_with(".tgz") {
            Box::new(flate2::read::GzDecoder::new(cursor))
        } else {
            Box::new(cursor)
        };
        
        let mut archive = tar::Archive::new(reader);
        
        // First pass: find common prefix
        let mut common_prefix: Option<String> = None;
        {
            let entries = archive.entries().map_err(|e| {
                CompileError::codegen(format!("Failed to read TAR entries: {}", e), None)
            })?;
            
            for entry in entries {
                let entry = entry.map_err(|e| {
                    CompileError::codegen(format!("Failed to read TAR entry: {}", e), None)
                })?;
                let path = entry.path().map_err(|e| {
                    CompileError::codegen(format!("Failed to get entry path: {}", e), None)
                })?;
                let path_str = path.to_string_lossy().to_string();
                
                if let Some(first_slash) = path_str.find('/') {
                    let prefix = &path_str[..first_slash];
                    if common_prefix.is_none() {
                        common_prefix = Some(prefix.to_string());
                    } else if common_prefix.as_ref() != Some(&prefix.to_string()) {
                        common_prefix = None;
                        break;
                    }
                } else {
                    common_prefix = None;
                    break;
                }
            }
        }
        
        // Second pass: extract files
        let cursor = Cursor::new(bytes);
        let reader: Box<dyn std::io::Read> = if url.ends_with(".tar.gz") || url.ends_with(".tgz") {
            Box::new(flate2::read::GzDecoder::new(cursor))
        } else {
            Box::new(cursor)
        };
        
        let mut archive = tar::Archive::new(reader);
        let entries = archive.entries().map_err(|e| {
            CompileError::codegen(format!("Failed to read TAR entries: {}", e), None)
        })?;
        
        for entry in entries {
            let mut entry = entry.map_err(|e| {
                CompileError::codegen(format!("Failed to read TAR entry: {}", e), None)
            })?;
            
            let path = entry.path().map_err(|e| {
                CompileError::codegen(format!("Failed to get entry path: {}", e), None)
            })?;
            
            let mut path_str = path.to_string_lossy().to_string();
            // Strip common prefix if found
            if let Some(ref prefix) = common_prefix {
                if path_str.starts_with(prefix) {
                    path_str = path_str[prefix.len()..].trim_start_matches('/').to_string();
                }
            }
            
            if path_str.is_empty() {
                continue;
            }
            
            let outpath = dest_dir.join(&path_str);
            
            if entry.header().entry_type().is_dir() {
                std::fs::create_dir_all(&outpath).map_err(|e| {
                    CompileError::codegen(format!("Failed to create directory: {}", e), None)
                })?;
            } else {
                if let Some(parent) = outpath.parent() {
                    std::fs::create_dir_all(parent).map_err(|e| {
                        CompileError::codegen(format!("Failed to create parent directory: {}", e), None)
                    })?;
                }
                
                let mut outfile = std::fs::File::create(&outpath).map_err(|e| {
                    CompileError::codegen(format!("Failed to create file: {}", e), None)
                })?;
                std::io::copy(&mut entry, &mut outfile).map_err(|e| {
                    CompileError::codegen(format!("Failed to extract file: {}", e), None)
                })?;
            }
        }
        
        return Ok(());
    }
    
    Err(CompileError::codegen(
        "Unsupported archive format. Supported: .zip, .tar, .tar.gz, .tgz".to_string(),
        None,
    ))
}

fn remove_package(project_root: &PathBuf, package_name: &str) -> Result<(), CompileError> {
    use tlang::build::config::ProjectConfig;
    
    // Load config
    let mut config = ProjectConfig::load(project_root)?;
    
    // Remove dependency
    if !config.remove_dependency(package_name) {
        return Err(CompileError::codegen(
            format!("Package '{}' not found in dependencies", package_name),
            None,
        ));
    }
    
    config.save(project_root)?;
    
    println!("Removed dependency: {}", package_name);
    
    Ok(())
}

fn upgrade_package(project_root: &PathBuf, package_spec: &str) -> Result<(), CompileError> {
    use tlang::build::config::ProjectConfig;
    
    // Load config
    let mut config = ProjectConfig::load(project_root)?;
    
    // Handle upgrade all ('.' or '*')
    if package_spec == "." || package_spec == "*" {
        let mut upgraded = 0;
        let deps: Vec<String> = config.dependencies.iter()
            .map(|d| d.name.clone())
            .collect();
        
        for dep_name in deps {
            // Clone dep info to avoid borrow issues
            let dep_info = config.get_dependency(&dep_name).map(|d| (d.source.as_path().map(|s| s.to_string()), d.version.clone()));
            if let Some((Some(path_str), current_version)) = dep_info {
                // Try to get latest version from package's config.toml
                let dep_path = project_root.join(&path_str);
                if dep_path.exists() {
                    if let Ok(dep_config) = ProjectConfig::load(&dep_path) {
                        let latest_version = dep_config.package.version;
                        if latest_version != current_version {
                            config.update_dependency_version(&dep_name, latest_version.clone());
                            println!("Upgraded {}: {} -> {}", dep_name, current_version, latest_version);
                            upgraded += 1;
                        } else {
                            println!("{} is already at latest version ({})", dep_name, latest_version);
                        }
                    }
                }
            }
        }
        
        if upgraded == 0 {
            println!("All packages are up to date");
        } else {
            config.save(project_root)?;
        }
        
        return Ok(());
    }
    
    // Upgrade specific package
    let dep_name = package_spec;
    
    // Clone dep info to avoid borrow issues
    let dep_info = config.get_dependency(dep_name).map(|d| (d.source.as_path().map(|s| s.to_string()), d.version.clone()));
    
    if let Some((source_path, current_version)) = dep_info {
        if let Some(path_str) = source_path {
            // Try to get latest version from package's config.toml
            let dep_path = project_root.join(&path_str);
            if dep_path.exists() {
                if let Ok(dep_config) = ProjectConfig::load(&dep_path) {
                    let latest_version = dep_config.package.version;
                    if latest_version != current_version {
                        config.update_dependency_version(dep_name, latest_version.clone());
                        config.save(project_root)?;
                        println!("Upgraded {}: {} -> {}", dep_name, current_version, latest_version);
                    } else {
                        println!("{} is already at latest version ({})", dep_name, latest_version);
                    }
                } else {
                    return Err(CompileError::codegen(
                        format!("Failed to read package config for '{}'", dep_name),
                        None,
                    ));
                }
            } else {
                return Err(CompileError::codegen(
                    format!("Package path not found: {}", dep_path.display()),
                    None,
                ));
            }
        } else {
            return Err(CompileError::codegen(
                format!("Package '{}' is not a path dependency (upgrade only supports path dependencies)", dep_name),
                None,
            ));
        }
    } else {
        return Err(CompileError::codegen(
            format!("Package '{}' not found in dependencies", dep_name),
            None,
        ));
    }
    
    Ok(())
}
