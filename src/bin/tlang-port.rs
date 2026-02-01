// tlang-port - Porting tool to convert Go packages to Tlang
// Converts Go source code to Tlang syntax

use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::collections::HashMap;
use std::process;
use regex::Regex;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        eprintln!("Usage: tlang-port <go_file> [output_file]");
        eprintln!("       tlang-port <directory> [output_directory]");
        eprintln!("\nConverts Go source files to Tlang syntax.");
        eprintln!("\nExamples:");
        eprintln!("  tlang-port main.go main.tl");
        eprintln!("  tlang-port ./go-package ./tlang-package");
        process::exit(1);
    }
    
    let input = &args[1];
    let output = args.get(2).map(|s| s.as_str());
    
    let input_path = Path::new(input);
    
    if input_path.is_file() {
        // Convert single file
        if !input_path.extension().map(|e| e == "go").unwrap_or(false) {
            eprintln!("Error: Input file must have .go extension");
            process::exit(1);
        }
        
        let output_path = if let Some(out) = output {
            PathBuf::from(out)
        } else {
            input_path.with_extension("tl")
        };
        
        match convert_go_file(input_path, &output_path) {
            Ok(_) => {
                println!("Converted {} to {}", input_path.display(), output_path.display());
            }
            Err(e) => {
                eprintln!("Error converting file: {}", e);
                process::exit(1);
            }
        }
    } else if input_path.is_dir() {
        // Convert directory
        let output_dir = if let Some(out) = output {
            PathBuf::from(out)
        } else {
            input_path.join("tlang_output")
        };
        
        match convert_go_directory(input_path, &output_dir) {
            Ok(_) => {
                println!("Converted directory {} to {}", input_path.display(), output_dir.display());
            }
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
