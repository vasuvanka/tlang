// Code formatting provider for LSP

use tower_lsp::lsp_types::*;
use std::sync::Arc;

use crate::lsp::symbols::SymbolTable;

pub struct FormattingProvider {
    #[allow(dead_code)]
    symbol_table: Arc<SymbolTable>,  // For future use in formatting
}

impl FormattingProvider {
    pub fn new(symbol_table: Arc<SymbolTable>) -> Self {
        FormattingProvider { symbol_table }
    }
    
    /// Format entire document
    pub fn format_document(&self, _uri: &Url, source: &str) -> Option<Vec<TextEdit>> {
        let formatted = self.format_text(source);
        
        if formatted != source {
            Some(vec![TextEdit {
                range: Range {
                    start: Position { line: 0, character: 0 },
                    end: Position {
                        line: source.lines().count() as u32,
                        character: 0,
                    },
                },
                new_text: formatted,
            }])
        } else {
            None
        }
    }
    
    /// Format on type (triggered by specific characters)
    pub fn format_on_type(&self, _uri: &Url, position: Position, ch: String, source: &str) -> Option<Vec<TextEdit>> {
        // Simple auto-indent after closing brace
        if ch == "}" {
            let lines: Vec<&str> = source.lines().collect();
            let line_idx = position.line as usize;
            
            if line_idx < lines.len() {
                let current_line = lines[line_idx];
                let indent_level = self.get_indent_level(current_line);
                
                // Check if we need to adjust indentation
                let expected_indent = "    ".repeat(indent_level);
                let current_indent: String = current_line.chars().take_while(|c| c.is_whitespace()).collect();
                
                if current_indent != expected_indent {
                    let new_line = format!("{}{}", expected_indent, current_line.trim_start());
                    return Some(vec![TextEdit {
                        range: Range {
                            start: Position { line: position.line, character: 0 },
                            end: Position { line: position.line, character: current_line.len() as u32 },
                        },
                        new_text: new_line,
                    }]);
                }
            }
        }
        
        None
    }
    
    /// Format text with basic indentation and spacing
    fn format_text(&self, source: &str) -> String {
        let lines: Vec<&str> = source.lines().collect();
        let mut formatted = Vec::new();
        let mut indent_level: usize = 0;
        let indent_str = "    "; // 4 spaces
        
        for line in lines {
            let trimmed = line.trim();
            
            // Skip empty lines
            if trimmed.is_empty() {
                formatted.push(String::new());
                continue;
            }
            
            // Decrease indent before closing braces
            if trimmed.starts_with('}') || trimmed.starts_with(']') || trimmed.starts_with(')') {
                indent_level = indent_level.saturating_sub(1);
            }
            
            // Add line with proper indentation
            formatted.push(format!("{}{}", indent_str.repeat(indent_level), trimmed));
            
            // Increase indent after opening braces
            if trimmed.ends_with('{') || trimmed.ends_with('[') || trimmed.ends_with('(') {
                indent_level += 1;
            }
        }
        
        formatted.join("\n")
    }
    
    /// Get current indent level from line
    fn get_indent_level(&self, line: &str) -> usize {
        let indent: String = line.chars().take_while(|c| c.is_whitespace()).collect();
        indent.len() / 4 // Assuming 4 spaces per indent level
    }
}
