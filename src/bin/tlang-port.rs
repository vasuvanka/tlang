// tlang-port - Porting tool to convert Go or Rust to Tlang
// Converts Go (.go) or Rust (.rs) source code to Tlang syntax

use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use std::process;
use regex::Regex;

#[derive(Clone, Copy, PartialEq)]
enum SourceLang {
    Go,
    Rust,
}

fn detect_lang(path: &Path) -> Option<SourceLang> {
    path.extension()
        .and_then(|e| e.to_str())
        .and_then(|ext| match ext {
            "go" => Some(SourceLang::Go),
            "rs" => Some(SourceLang::Rust),
            _ => None,
        })
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut from_arg: Option<SourceLang> = None;
    let mut rest = Vec::new();
    let mut i = 1;
    while i < args.len() {
        if args[i] == "--from" {
            i += 1;
            if i < args.len() {
                from_arg = match args[i].as_str() {
                    "go" => Some(SourceLang::Go),
                    "rust" | "rs" => Some(SourceLang::Rust),
                    _ => {
                        eprintln!("Error: --from must be 'go' or 'rust'");
                        process::exit(1);
                    }
                };
                i += 1;
            }
        } else {
            rest.push(args[i].clone());
            i += 1;
        }
    }

    if rest.len() < 1 {
        eprintln!("Usage: tlang-port [--from go|rust] <input_file> [output_file]");
        eprintln!("       tlang-port [--from go|rust] <input_directory> [output_directory]");
        eprintln!("\nConverts Go (.go) or Rust (.rs) source to Tlang (.tl).");
        eprintln!("Language is auto-detected by extension unless --from is given.");
        eprintln!("\nExamples:");
        eprintln!("  tlang-port main.go main.tl");
        eprintln!("  tlang-port main.rs main.tl");
        eprintln!("  tlang-port --from rust ./src ./tlang_out");
        eprintln!("  tlang-port ./go-pkg ./tlang-pkg");
        process::exit(1);
    }

    let input = &rest[0];
    let output = rest.get(1).map(|s| s.as_str());
    let input_path = Path::new(input);

    let lang = if let Some(l) = from_arg {
        l
    } else if input_path.is_file() {
        match detect_lang(input_path) {
            Some(l) => l,
            None => {
                eprintln!("Error: Unknown file extension. Use .go or .rs, or pass --from go|rust");
                process::exit(1);
            }
        }
    } else {
        // Directory: detect from presence of .rs or .go files (prefer Rust if both exist)
        let has_rs = fs::read_dir(input_path)
            .ok()
            .map(|rd| rd.filter_map(Result::ok).any(|e| e.path().extension().map(|x| x == "rs").unwrap_or(false)))
            .unwrap_or(false);
        let has_go = fs::read_dir(input_path)
            .ok()
            .map(|rd| rd.filter_map(Result::ok).any(|e| e.path().extension().map(|x| x == "go").unwrap_or(false)))
            .unwrap_or(false);
        if has_rs {
            SourceLang::Rust
        } else if has_go {
            SourceLang::Go
        } else {
            eprintln!("Error: No .go or .rs files found in directory. Use --from go or --from rust.");
            process::exit(1);
        }
    };

    if input_path.is_file() {
        let ext_ok = input_path.extension().map(|e| e == "go" || e == "rs").unwrap_or(false);
        if !ext_ok {
            eprintln!("Error: Input file must have .go or .rs extension");
            process::exit(1);
        }
        let output_path = output.map(PathBuf::from).unwrap_or_else(|| input_path.with_extension("tl"));
        let result = match lang {
            SourceLang::Go => convert_go_file(input_path, &output_path),
            SourceLang::Rust => convert_rust_file(input_path, &output_path),
        };
        match result {
            Ok(_) => println!("Converted {} to {}", input_path.display(), output_path.display()),
            Err(e) => {
                eprintln!("Error converting file: {}", e);
                process::exit(1);
            }
        }
    } else if input_path.is_dir() {
        let output_dir = output.map(PathBuf::from).unwrap_or_else(|| input_path.join("tlang_output"));
        let result = match lang {
            SourceLang::Go => convert_go_directory(input_path, &output_dir),
            SourceLang::Rust => convert_rust_directory(input_path, &output_dir),
        };
        match result {
            Ok(_) => println!("Converted directory {} to {}", input_path.display(), output_dir.display()),
            Err(e) => {
                eprintln!("Error converting directory: {}", e);
                process::exit(1);
            }
        }
    } else {
        eprintln!("Error: Input path does not exist: {}", input);
        process::exit(1);
    }
}

fn convert_go_file(input: &Path, output: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(input)?;
    let converted = convert_go_to_tlang(&content);
    fs::write(output, converted)?;
    Ok(())
}

fn convert_go_directory(input_dir: &Path, output_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
    // Create output directory
    fs::create_dir_all(output_dir)?;
    
    // Walk through directory and convert all .go files
    for entry in fs::read_dir(input_dir)? {
        let entry = entry?;
        let path = entry.path();
        
        if path.is_file() && path.extension().map(|e| e == "go").unwrap_or(false) {
            let relative_path = path.strip_prefix(input_dir)?;
            let output_path = output_dir.join(relative_path).with_extension("tl");
            
            // Create subdirectories if needed
            if let Some(parent) = output_path.parent() {
                fs::create_dir_all(parent)?;
            }
            
            convert_go_file(&path, &output_path)?;
            println!("Converted: {} -> {}", path.display(), output_path.display());
        } else if path.is_dir() {
            // Recursively process subdirectories
            let sub_output = output_dir.join(path.file_name().unwrap());
            convert_go_directory(&path, &sub_output)?;
        }
    }
    
    Ok(())
}

fn convert_rust_file(input: &Path, output: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(input)?;
    let converted = convert_rust_to_tlang(&content);
    fs::write(output, converted)?;
    Ok(())
}

fn convert_rust_directory(input_dir: &Path, output_dir: &Path) -> Result<(), Box<dyn std::error::Error>> {
    fs::create_dir_all(output_dir)?;
    for entry in fs::read_dir(input_dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_file() && path.extension().map(|e| e == "rs").unwrap_or(false) {
            let relative_path = path.strip_prefix(input_dir)?;
            let output_path = output_dir.join(relative_path).with_extension("tl");
            if let Some(parent) = output_path.parent() {
                fs::create_dir_all(parent)?;
            }
            convert_rust_file(&path, &output_path)?;
            println!("Converted: {} -> {}", path.display(), output_path.display());
        } else if path.is_dir() {
            let sub_output = output_dir.join(path.file_name().unwrap());
            convert_rust_directory(&path, &sub_output)?;
        }
    }
    Ok(())
}

fn convert_go_to_tlang(go_code: &str) -> String {
    let mut result = go_code.to_string();
    
    // Keyword mappings: Go -> Tlang
    let keyword_map: HashMap<&str, &str> = [
        ("import", "dhimpu"),
        ("func", "#"),
        ("var", "@"),
        ("if", "okavela"),
        ("else", "lekapothe"),
        ("for", "malli"),
        ("return", "mallinchu"),
        ("break", "agu"),
        ("continue", "konasagu"),
        ("struct", "nirmanam"),
        ("map", "jatha"),
        ("nil", "sunyam"),
        ("error", "error"), // Keep error type as is
        ("main", "prarambham"),
        // interface - removed from Tlang
        ("range", "varasa"), // Convert range to varasa
        ("type", "type"), // Keep type as is (for type aliases)
    ].iter().cloned().collect();
    
    // Type mappings: Go -> Tlang
    let type_map: HashMap<&str, &str> = [
        ("int", "int"),
        ("int8", "int"),
        ("int16", "int"),
        ("int32", "int"),
        ("int64", "int"),
        ("uint", "int"),
        ("uint8", "int"),
        ("uint16", "int"),
        ("uint32", "int"),
        ("uint64", "int"),
        ("float32", "float"),
        ("float64", "float"),
        ("string", "string"),
        ("bool", "int"), // Tlang uses int for bool (1/0)
        ("byte", "int"),
        ("rune", "int"),
        ("error", "error"),
    ].iter().cloned().collect();
    
    // Step 1: Remove Go package declaration (Tlang has no package declaration)
    result = convert_package_decl(&result);
    
    // Step 2: Convert imports (before keyword conversion)
    result = convert_imports(&result);
    
    // Step 3: Convert nil to sunyam first (before other keyword conversions)
    result = result.replace(" nil ", " sunyam ");
    result = result.replace(" nil\n", " sunyam\n");
    result = result.replace(" nil;", " sunyam;");
    result = result.replace(" nil)", " sunyam)");
    result = result.replace(" nil,", " sunyam,");
    result = result.replace(" nil{", " sunyam{");
    
    // Step 4: Convert types (before keyword conversion to avoid conflicts)
    result = convert_types(&result, &type_map);
    
    // Step 5: Convert keywords (order matters - do func before var to avoid conflicts)
    result = convert_keywords(&result, &keyword_map);
    
    // Step 6: Convert function declarations (after keyword conversion)
    result = convert_functions(&result);
    
    // Step 7: Convert variable declarations (after keyword conversion)
    result = convert_variables(&result);
    
    // Step 8: Convert struct declarations and fields
    result = convert_structs(&result);
    
    // Step 9: Convert error handling patterns
    result = convert_error_handling(&result);
    
    // Step 10: Convert remaining nil checks
    result = convert_nil_checks(&result);
    
    // Step 11: Convert type conversions
    result = convert_type_conversions(&result);
    
    // Step 12: Convert for loops
    result = convert_for_loops(&result);
    
    // Step 13: Clean up formatting
    result = cleanup_formatting(&result);
    
    result
}

fn convert_package_decl(code: &str) -> String {
    // Remove Go package declaration; Tlang has no package declaration
    let re = Regex::new(r"(?m)^package\s+\w+\s*$").unwrap();
    re.replace_all(code, "").to_string()
}

fn convert_imports(code: &str) -> String {
    // Handle single import: import "fmt"
    let re_single = Regex::new(r#"(?m)^import\s+"([^"]+)"\s*$"#).unwrap();
    let mut result = re_single.replace_all(code, |caps: &regex::Captures| {
        format!("#dhimpu(\"{}\");", &caps[1])
    }).to_string();
    
    // Handle import block: import ( "fmt" "strings" )
    let re_block = Regex::new(r#"(?m)^import\s*\(\s*((?:"[^"]+"\s*)+)\s*\)\s*$"#).unwrap();
    result = re_block.replace_all(&result, |caps: &regex::Captures| {
        let imports = caps[1].trim();
        let import_list: Vec<&str> = imports.split_whitespace()
            .filter(|s| s.starts_with('"'))
            .collect();
        import_list.iter()
            .map(|imp| format!("techu {};", imp))
            .collect::<Vec<_>>()
            .join("\n")
    }).to_string();
    
    // Handle import with alias: import alias "package"
    let re_alias = Regex::new(r#"(?m)^import\s+(\w+)\s+"([^"]+)"\s*$"#).unwrap();
    result = re_alias.replace_all(&result, |caps: &regex::Captures| {
        format!("@{} = #dhimpu(\"{}\");", &caps[1], &caps[2])
    }).to_string();
    
    result
}

fn convert_keywords(code: &str, keyword_map: &HashMap<&str, &str>) -> String {
    let mut result = code.to_string();
    
    // Convert keywords (in order to avoid conflicts)
    for (go_keyword, tlang_keyword) in keyword_map {
        // Use word boundaries to avoid partial matches
        let pattern = format!(r"\b{}\b", regex::escape(go_keyword));
        let re = regex::Regex::new(&pattern).unwrap();
        result = re.replace_all(&result, *tlang_keyword).to_string();
    }
    
    result
}

fn convert_types(code: &str, type_map: &HashMap<&str, &str>) -> String {
    let mut result = code.to_string();
    
    for (go_type, tlang_type) in type_map {
        // Match type in type annotations (e.g., var x int, func f() int)
        let pattern = format!(r"\b{}\b", regex::escape(go_type));
        let re = regex::Regex::new(&pattern).unwrap();
        result = re.replace_all(&result, *tlang_type).to_string();
    }
    
    result
}

fn convert_functions(code: &str) -> String {
    // Convert # prarambham() to #prarambham() (remove space after #)
    let re_main = Regex::new(r"(?m)^\s*#\s+prarambham\s*\([^)]*\)\s*\{").unwrap();
    let mut result = re_main.replace_all(code, "#prarambham() {").to_string();
    
    // Convert # functionName() to #functionName() (remove space after #)
    let re_func = Regex::new(r"(?m)^\s*#\s+(\w+)\s*\(").unwrap();
    result = re_func.replace_all(&result, "#$1(").to_string();
    
    result
}

fn convert_variables(code: &str) -> String {
    // Convert var declarations: @ x int = 10 -> @x int = 10;
    // Handle: @ x int, @ x = 10, @ x int = 10
    // Note: var has already been converted to @ by keyword conversion
    let re_var = Regex::new(r"(?m)^\s*@\s+(\w+)(?:\s+(\w+))?(?:\s*=\s*([^;]+))?\s*;?").unwrap();
    let result = re_var.replace_all(code, |caps: &regex::Captures| {
        let name = &caps[1];
        let type_annot = caps.get(2).map(|m| m.as_str());
        let value = caps.get(3).map(|m| m.as_str());
        
        match (type_annot, value) {
            (Some(typ), Some(val)) => format!("@{} {} = {};", name, typ, val.trim()),
            (Some(typ), None) => format!("@{} {};", name, typ),
            (None, Some(val)) => format!("@{} = {};", name, val.trim()),
            (None, None) => format!("@{};", name),
        }
    }).to_string();
    
    
    result
}

fn convert_structs(code: &str) -> String {
    // Convert struct fields inside struct blocks: fieldName Type -> @fieldName Type;
    // This is a simplified approach - looks for patterns inside struct blocks
    let result = code.to_string();
    
    // Convert struct field declarations inside struct blocks
    // Pattern: fieldName Type (with optional tags)
    // This regex matches lines that look like struct fields (identifier followed by type)
    // but only inside struct blocks
    let _re_struct_field = Regex::new(r"(?m)^(\s+)(\w+)\s+(\w+(?:\*|\[\])*)\s*(?:`[^`]*`)?\s*$").unwrap();
    
    // We'll use a simpler approach: convert field patterns that appear after struct declarations
    // This is a heuristic - full implementation would parse struct blocks properly
    let lines: Vec<&str> = result.lines().collect();
    let mut new_lines = Vec::new();
    let mut in_struct = false;
    let mut brace_count = 0;
    
    for line in lines {
        let trimmed = line.trim();
        
        // Check if we're entering a struct
        if trimmed.starts_with("nirmanam ") && trimmed.contains('{') {
            in_struct = true;
            brace_count = trimmed.matches('{').count() - trimmed.matches('}').count();
            new_lines.push(line.to_string());
            continue;
        }
        
        // Track brace count to know when we exit struct
        if in_struct {
            brace_count += line.matches('{').count();
            brace_count -= line.matches('}').count();
            
            if brace_count <= 0 {
                in_struct = false;
            }
            
            // Convert struct fields: fieldName Type -> @fieldName Type;
            if in_struct && !trimmed.is_empty() && !trimmed.starts_with("//") && !trimmed.starts_with("/*") {
                // Check if this looks like a struct field (identifier + type)
                // Pattern: whitespace + identifier + type (with optional pointer/array)
                let re_field = Regex::new(r"^(\s+)(\w+)\s+(\w+(?:\*|\[\])*)\s*(?:`[^`]*`)?\s*$").unwrap();
                if let Some(caps) = re_field.captures(line) {
                    let indent = &caps[1];
                    let field_name = &caps[2];
                    let field_type = &caps[3];
                    new_lines.push(format!("{}@{} {};", indent, field_name, field_type));
                    continue;
                }
            }
        }
        
        new_lines.push(line.to_string());
    }
    
    new_lines.join("\n")
}

fn convert_error_handling(code: &str) -> String {
    // Convert if err != nil { ... } to okavela err != sunyam { ... }
    let re_err_check = Regex::new(r"(?m)if\s+(\w+)\s*!=\s*nil\s*\{").unwrap();
    let mut result = re_err_check.replace_all(code, |caps: &regex::Captures| {
        format!("okavela {} != sunyam {{", &caps[1])
    }).to_string();
    
    // Convert return err to mallinchu err
    // This is already handled by keyword conversion
    
    // Convert return nil to mallinchu sunyam
    let re_return_nil = Regex::new(r"\bmallinchu\s+sunyam\b").unwrap();
    result = re_return_nil.replace_all(&result, "mallinchu sunyam").to_string();
    
    result
}

fn convert_nil_checks(code: &str) -> String {
    // Convert x == nil to x == sunyam (already handled in step 3, but catch any remaining)
    let mut result = code.to_string();
    result = result.replace(" == nil", " == sunyam");
    result = result.replace(" != nil", " != sunyam");
    result = result.replace("= nil", "= sunyam");
    result
}

fn convert_for_loops(code: &str) -> String {
    // Convert Go for loops to Tlang malli loops
    // Go: for i := 0; i < 10; i++ { ... }
    // Tlang: @i int = 0; malli i < 10; i = i + 1 { ... }
    
    let mut result = code.to_string();
    
    // Convert for range loops: for key, value := range map { ... } to varasa
    // to: malli key, value := varasa map { ... }
    // This is already handled by keyword conversion (for -> malli)
    
    // Convert i++ to i = i + 1
    let re_inc = Regex::new(r"(\w+)\+\+").unwrap();
    result = re_inc.replace_all(&result, |caps: &regex::Captures| {
        format!("{} = {} + 1", &caps[1], &caps[1])
    }).to_string();
    
    // Convert i-- to i = i - 1
    let re_dec = Regex::new(r"(\w+)--").unwrap();
    result = re_dec.replace_all(&result, |caps: &regex::Captures| {
        format!("{} = {} - 1", &caps[1], &caps[1])
    }).to_string();
    
    // Convert := to = (short variable declaration)
    result = result.replace(" := ", " = ");
    result = result.replace(":=", "=");
    
    result
}

fn convert_type_conversions(code: &str) -> String {
    // Convert Go type assertions and conversions
    // x.(type) -> type(x) for type conversions
    let re_type_assert = Regex::new(r"(\w+)\.\((\w+)\)").unwrap();
    let result = re_type_assert.replace_all(code, |caps: &regex::Captures| {
        format!("{}({})", &caps[2], &caps[1])
    }).to_string();
    
    result
}

fn cleanup_formatting(code: &str) -> String {
    let mut result = code.to_string();
    
    // Ensure semicolons at end of statements
    // Remove extra whitespace
    result = result.replace("  ", " ");
    result = result.replace("\n\n\n", "\n\n");
    
    result
}

// ---------- Rust to Tlang conversion ----------

fn convert_rust_to_tlang(rust_code: &str) -> String {
    let mut result = rust_code.to_string();

    // Step 1: Comment out or remove crate attributes
    result = convert_rust_attributes(&result);

    // Step 2: Convert use/mod (before keyword conversion)
    result = convert_rust_imports(&result);

    // Step 3: Convert types (before keywords to avoid touching e.g. "fn" inside "refinement")
    let rust_type_map: HashMap<&str, &str> = [
        ("i8", "int"),
        ("i16", "int"),
        ("i32", "int"),
        ("i64", "int"),
        ("isize", "int"),
        ("u8", "int"),
        ("u16", "int"),
        ("u32", "int"),
        ("u64", "int"),
        ("usize", "int"),
        ("f32", "float"),
        ("f64", "float"),
        ("bool", "int"),
        ("String", "string"),
        ("str", "string"),
        ("Option", "optional"), // Option<T> -> optional; manual follow-up may be needed
        ("Result", "result"),   // Result<T,E> -> result or (T, error)
    ]
    .iter()
    .cloned()
    .collect();
    result = convert_types(&result, &rust_type_map);

    // Step 4: Convert keywords
    let rust_keyword_map: HashMap<&str, &str> = [
        ("fn", "#"),
        ("if", "okavela"),
        ("else", "lekapothe"),
        ("loop", "malli"),
        ("return", "mallinchu"),
        ("struct", "nirmanam"),
        ("break", "agu"),
        ("continue", "konasagu"),
        ("match", "match"), // keep; can convert to okavela/lekapothe later
        ("None", "sunyam"),
        ("Some", "Some"), // keep for now; manual unwrap
        ("true", "1"),
        ("false", "0"),
        ("self", "self"),
        ("Self", "Self"),
    ]
    .iter()
    .cloned()
    .collect();
    result = convert_keywords(&result, &rust_keyword_map);

    // Step 5: Convert let/let mut
    result = convert_rust_let(&result);

    // Step 6: Convert while/for
    result = convert_rust_loops(&result);

    // Step 7: Convert fn and impl
    result = convert_rust_fns(&result);

    // Step 7b: Rust param style (name: Type) -> Tlang (name Type)
    result = result.replace(": int", " int");
    result = result.replace(": float", " float");
    result = result.replace(": string", " string");

    // Step 8: Convert struct and impl blocks
    result = convert_rust_structs(&result);

    // Step 9: Remove pub, mut (standalone), ref, &
    result = convert_rust_modifiers(&result);

    // Step 10: Macros -> comments or fmt
    result = convert_rust_macros(&result);

    // Step 11: Cleanup
    result = cleanup_formatting(&result);

    result
}

fn convert_rust_attributes(code: &str) -> String {
    // Comment out #![...] and #[...] so they don't break Tlang
    let re_inner = Regex::new(r"(?m)^#!\[.*\]\s*$").unwrap();
    let mut result = re_inner.replace_all(code, |caps: &regex::Captures| format!("// {}", &caps[0])).to_string();
    let re_attr = Regex::new(r"(?m)^#\[.*\]\s*$").unwrap();
    result = re_attr.replace_all(&result, |caps: &regex::Captures| format!("// {}", &caps[0])).to_string();
    result
}

fn convert_rust_imports(code: &str) -> String {
    let mut result = code.to_string();
    // use std::fmt; -> @fmt = #dhimpu("std/fmt");
    let re_std = Regex::new(r"(?m)^\s*use\s+std::(\w+)\s*;\s*$").unwrap();
    result = re_std.replace_all(&result, |caps: &regex::Captures| {
        let m = &caps[1];
        format!(r#"@{} = #dhimpu("std/{}");"#, m, m)
    }).to_string();
    // use crate::foo::bar -> @bar = #dhimpu("crate/foo/bar");
    let re_crate = Regex::new(r"(?m)^\s*use\s+crate::([\w:]+)\s*;\s*$").unwrap();
    result = re_crate.replace_all(&result, |caps: &regex::Captures| {
        let path = caps[1].replace("::", "/");
        let name = path.split('/').last().unwrap_or(&path);
        format!(r#"@{} = #dhimpu("{}");"#, name, path)
    }).to_string();
    // use path as alias;
    let re_alias = Regex::new(r"(?m)^\s*use\s+([\w:]+)\s+as\s+(\w+)\s*;\s*$").unwrap();
    result = re_alias.replace_all(&result, |caps: &regex::Captures| {
        let path = caps[1].replace("::", "/");
        format!(r#"@{} = #dhimpu("{}");"#, &caps[2], path)
    }).to_string();
    result
}

fn convert_rust_let(code: &str) -> String {
    let mut result = code.to_string();
    // let mut x = ...; -> @!x = ...;
    let re_let_mut = Regex::new(r"(?m)^\s*let\s+mut\s+(\w+)\s*(?::\s*([^=]+))?\s*=\s*(.+);\s*$").unwrap();
    result = re_let_mut.replace_all(&result, |caps: &regex::Captures| {
        let name = &caps[1];
        let typ = caps.get(2).map(|m| m.as_str().trim());
        let value = caps[3].trim();
        match typ {
            Some(t) => format!("@!{} {} = {};", name, t, value),
            None => format!("@!{} = {};", name, value),
        }
    }).to_string();
    // let x: Type = ...; -> @x Type = ...;
    let re_let_typed = Regex::new(r"(?m)^\s*let\s+(\w+)\s*:\s*([^=]+)=\s*(.+);\s*$").unwrap();
    result = re_let_typed.replace_all(&result, |caps: &regex::Captures| {
        let name = &caps[1];
        let typ = caps[2].trim();
        let value = caps[3].trim();
        format!("@{} {} = {};", name, typ, value)
    }).to_string();
    // let x = ...; -> @x = ...;
    let re_let = Regex::new(r"(?m)^\s*let\s+(\w+)\s*=\s*(.+);\s*$").unwrap();
    result = re_let.replace_all(&result, |caps: &regex::Captures| {
        format!("@{} = {};", &caps[1], caps[2].trim())
    }).to_string();
    result
}

fn convert_rust_loops(code: &str) -> String {
    let mut result = code.to_string();
    // while cond { -> malli cond {
    let re_while = Regex::new(r"(?m)\bwhile\s+(.+)\s*\{").unwrap();
    result = re_while.replace_all(&result, "malli $1 {").to_string();
    // for x in iter { -> malli x varasa iter {
    let re_for = Regex::new(r"(?m)\bfor\s+(\w+)\s+in\s+(.+)\s*\{").unwrap();
    result = re_for.replace_all(&result, "malli $1 varasa $2 {").to_string();
    // i += 1 -> i = i + 1 (and similar)
    let re_plus_eq = Regex::new(r"(\w+)\s*\+=\s*1\b").unwrap();
    result = re_plus_eq.replace_all(&result, "$1 = $1 + 1").to_string();
    let re_minus_eq = Regex::new(r"(\w+)\s*-=\s*1\b").unwrap();
    result = re_minus_eq.replace_all(&result, "$1 = $1 - 1").to_string();
    result
}

fn convert_rust_fns(code: &str) -> String {
    let mut result = code.to_string();
    // Do main first so it isn't turned into #main by the general fn regex
    let re_main = Regex::new(r"(?m)^\s*#\s+main\s*\([^)]*\)\s*(?:->[^{]*)?\s*\{").unwrap();
    result = re_main.replace_all(&result, "#prarambham() {").to_string();
    // Also catch #main() { (no space) in case it was produced earlier
    let re_main2 = Regex::new(r"(?m)^\s*#main\s*\([^)]*\)\s*\{").unwrap();
    result = re_main2.replace_all(&result, "#prarambham() {").to_string();
    // # name(...) -> Ret { -> #name(...) Ret {
    let re_fn = Regex::new(r"(?m)^\s*#\s+(\w+)\s*\(([^)]*)\)\s*->\s*([^{]+)\s*\{").unwrap();
    result = re_fn.replace_all(&result, "#$1($2) $3 {").to_string();
    // # name(...) { (no return type)
    let re_fn_no_ret = Regex::new(r"(?m)^\s*#\s+(\w+)\s*\(([^)]*)\)\s*\{").unwrap();
    result = re_fn_no_ret.replace_all(&result, "#$1($2) {").to_string();
    result
}

fn convert_rust_structs(code: &str) -> String {
    let lines: Vec<&str> = code.lines().collect();
    let mut new_lines = Vec::new();
    let mut in_struct = false;
    let mut brace_count = 0;

    for line in lines {
        let trimmed = line.trim();
        if trimmed.starts_with("nirmanam ") && trimmed.contains('{') {
            in_struct = true;
            brace_count = trimmed.matches('{').count() - trimmed.matches('}').count();
            new_lines.push(line.to_string());
            continue;
        }
        if in_struct {
            brace_count += line.matches('{').count();
            brace_count -= line.matches('}').count();
            if brace_count <= 0 {
                in_struct = false;
            }
            if in_struct && !trimmed.is_empty() && !trimmed.starts_with("//") {
                let re_field = Regex::new(r"^(\s+)(\w+)\s*:\s*([^,]+)(?:,\s*)?$").unwrap();
                if let Some(caps) = re_field.captures(line) {
                    let indent = &caps[1];
                    let field = &caps[2];
                    let typ = caps[3].trim().trim_end_matches(',');
                    new_lines.push(format!("{}@{} {};", indent, field, typ));
                    continue;
                }
            }
        }
        new_lines.push(line.to_string());
    }
    new_lines.join("\n")
}

fn convert_rust_modifiers(code: &str) -> String {
    let mut result = code.to_string();
    result = result.replace(" pub ", " ");
    result = result.replace(" pub\n", " \n");
    result = result.replace(" pub(", " (");
    result = result.replace("pub #", "#");  // pub fn -> pub # after keyword conversion
    result = result.replace("pub nirmanam", "nirmanam");
    result = result.replace("pub struct", "nirmanam");
    result = result.replace(" ref ", " ");
    result = result.replace(" mut ", " ");
    result = result.replace(" &mut ", " ");
    result = result.replace(" & ", " ");
    result = result.replace(" *const ", " ");
    result = result.replace(" *mut ", " ");
    result
}

fn convert_rust_macros(code: &str) -> String {
    let mut result = code.to_string();
    // println!("...", ...) -> fmt.Printf("...\n", ...)
    let re_println = Regex::new(r#"println!\s*\(\s*"([^"]*)"\s*(?:,\s*(.+))?\)"#).unwrap();
    result = re_println.replace_all(&result, |caps: &regex::Captures| {
        let fmt = &caps[1];
        let rest = caps.get(2).map(|m| m.as_str()).unwrap_or("");
        let fmt_esc = fmt.replace('\\', "\\\\").replace('"', "\\\"");
        let fmt_new = format!("{}\\n", fmt_esc);
        if rest.is_empty() {
            format!("fmt.Printf(\"{}\")", fmt_new)
        } else {
            format!("fmt.Printf(\"{}\", {})", fmt_new, rest)
        }
    }).to_string();
    // print!("...") -> fmt.Printf("...")
    let re_print = Regex::new(r#"print!\s*\(\s*"([^"]*)"\s*(?:,\s*(.+))?\)"#).unwrap();
    result = re_print.replace_all(&result, |caps: &regex::Captures| {
        let fmt = &caps[1];
        let rest = caps.get(2).map(|m| m.as_str()).unwrap_or("");
        let fmt_esc = fmt.replace('\\', "\\\\").replace('"', "\\\"");
        if rest.is_empty() {
            format!("fmt.Printf(\"{}\")", fmt_esc)
        } else {
            format!("fmt.Printf(\"{}\", {})", fmt_esc, rest)
        }
    }).to_string();
    // panic!("...") -> leave as comment or simple error
    let re_panic = Regex::new(r#"panic!\s*\(\s*"([^"]*)"\s*\)"#).unwrap();
    result = re_panic.replace_all(&result, |caps: &regex::Captures| {
        format!("/* panic: {} */ mallinchu sunyam", &caps[1])
    }).to_string();
    result
}
