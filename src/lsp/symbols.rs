// Symbol table for LSP - tracks functions, variables, types, etc.

use tower_lsp::lsp_types::*;
use std::collections::HashMap;

use crate::lexer::Lexer;
use crate::parser::Parser;
use crate::ast::*;

/// Symbol information
#[derive(Debug, Clone)]
pub struct SymbolInfo {
    pub name: String,
    pub kind: SymbolKind,
    pub location: Location,
    pub detail: Option<String>,  // Type information, signature, etc.
    pub documentation: Option<String>,
}

/// Symbol table for a document
#[derive(Debug)]
pub struct SymbolTable {
    symbols: HashMap<String, Vec<SymbolInfo>>,  // name -> list of symbols (for overloading)
    #[allow(dead_code)]
    by_position: HashMap<(u32, u32), SymbolInfo>,  // (line, column) -> symbol (for future use)
}

impl SymbolTable {
    /// Build symbol table from source code
    pub fn from_source(source: &str, uri: &Url) -> Result<Self, String> {
        let lexer = Lexer::new_with_filename(source, uri.to_file_path().unwrap_or_default().to_string_lossy().to_string());
        let mut parser = Parser::new(lexer);
        
        let program = parser.parse().map_err(|e| format!("Parse error: {}", e))?;
        
        let mut symbol_table = SymbolTable {
            symbols: HashMap::new(),
            by_position: HashMap::new(),
        };
        
        // Extract symbols from program
        symbol_table.extract_symbols(&program, uri);
        
        Ok(symbol_table)
    }
    
    /// Extract symbols from AST (imports + statements)
    fn extract_symbols(&mut self, program: &Program, uri: &Url) {
        // Import bindings: @var = #dhimpu("path") — expose as MODULE so completion/hover know the name
        for import_info in &program.imports {
            let name = import_info
                .alias
                .as_deref()
                .unwrap_or_else(|| {
                    import_info.path.split('/').last().unwrap_or(import_info.path.as_str())
                });
            let detail = format!("import \"{}\"", import_info.path);
            let symbol = SymbolInfo {
                name: name.to_string(),
                kind: SymbolKind::MODULE,
                location: Location {
                    uri: uri.clone(),
                    range: Range {
                        start: Position { line: 0, character: 0 },
                        end: Position { line: 0, character: 0 },
                    },
                },
                detail: Some(detail),
                documentation: None,
            };
            self.add_symbol(symbol);
        }
        for stmt in &program.statements {
            self.extract_symbol_from_stmt(stmt, uri);
        }
    }
    
    /// Extract symbol from a statement
    fn extract_symbol_from_stmt(&mut self, stmt: &Stmt, uri: &Url) {
        match stmt {
            Stmt::Function { name, params, return_type, .. } => {
                let detail = self.format_function_signature(name, params, return_type);
                let symbol = SymbolInfo {
                    name: name.clone(),
                    kind: SymbolKind::FUNCTION,
                    location: Location {
                        uri: uri.clone(),
                        range: Range {
                            start: Position { line: 0, character: 0 },  // TODO: Get actual position
                            end: Position { line: 0, character: 0 },
                        },
                    },
                    detail: Some(detail),
                    documentation: None,
                };
                self.add_symbol(symbol);
            }
            Stmt::VariableDecl { name, type_annot, .. } => {
                let detail = type_annot.as_ref()
                    .map(|t| self.format_type(t))
                    .unwrap_or_else(|| "unknown".to_string());
                let symbol = SymbolInfo {
                    name: name.clone(),
                    kind: SymbolKind::VARIABLE,
                    location: Location {
                        uri: uri.clone(),
                        range: Range {
                            start: Position { line: 0, character: 0 },
                            end: Position { line: 0, character: 0 },
                        },
                    },
                    detail: Some(detail),
                    documentation: None,
                };
                self.add_symbol(symbol);
            }
            Stmt::StructDef { name, .. } => {
                let symbol = SymbolInfo {
                    name: name.clone(),
                    kind: SymbolKind::STRUCT,
                    location: Location {
                        uri: uri.clone(),
                        range: Range {
                            start: Position { line: 0, character: 0 },
                            end: Position { line: 0, character: 0 },
                        },
                    },
                    detail: None,
                    documentation: None,
                };
                self.add_symbol(symbol);
            }
            _ => {}
        }
    }
    
    /// Add symbol to table
    fn add_symbol(&mut self, symbol: SymbolInfo) {
        self.symbols
            .entry(symbol.name.clone())
            .or_insert_with(Vec::new)
            .push(symbol.clone());
        
        // Store by position (simplified - would need actual line/column from AST)
        // self.by_position.insert((line, col), symbol);
    }
    
    /// Find symbol by name
    pub fn find_symbol(&self, name: &str) -> Option<&Vec<SymbolInfo>> {
        self.symbols.get(name)
    }
    
    /// Get all symbols
    pub fn all_symbols(&self) -> &HashMap<String, Vec<SymbolInfo>> {
        &self.symbols
    }
    
    /// Format function signature for display
    fn format_function_signature(
        &self,
        name: &str,
        params: &[(String, Type)],
        return_type: &Option<Type>,
    ) -> String {
        let param_strs: Vec<String> = params
            .iter()
            .map(|(pname, ptype)| format!("{} {}", pname, self.format_type(ptype)))
            .collect();
        
        let return_str = return_type
            .as_ref()
            .map(|t| format!(" -> {}", self.format_type(t)))
            .unwrap_or_default();
        
        format!("{}({}){}", name, param_strs.join(", "), return_str)
    }
    
    /// Format type for display
    fn format_type(&self, typ: &Type) -> String {
        match typ {
            Type::Int => "int".to_string(),
            Type::Float => "float".to_string(),
            Type::String => "string".to_string(),
            Type::Bool => "bool".to_string(),
            Type::Pointer(inner) => format!("*{}", self.format_type(inner)),
            Type::Array { size, element_type } => {
                format!("[{}]{}", size, self.format_type(element_type))
            }
            Type::Slice { element_type } => {
                format!("[]{}", self.format_type(element_type))
            }
            Type::Struct { name } => name.clone(),
            Type::Channel { element_type } => format!("channel[{}]", self.format_type(element_type)),
            Type::WaitGroup => "WaitGroup".to_string(),
            Type::Any => "nirmanam{}".to_string(),
            Type::Map { key_type, value_type } => {
                format!("jatha[{}]{}", self.format_type(key_type), self.format_type(value_type))
            }
            Type::Tuple { types } => {
                let type_strs: Vec<String> = types.iter().map(|t| self.format_type(t)).collect();
                format!("({})", type_strs.join(", "))
            }
            _ => "unknown".to_string(),
        }
    }
}
