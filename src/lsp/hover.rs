// Hover documentation provider for LSP

use tower_lsp::lsp_types::*;
use std::sync::Arc;

use crate::lsp::symbols::SymbolTable;
use crate::lsp::utils::extract_word_at_position;

pub struct HoverProvider {
    symbol_table: Arc<SymbolTable>,
}

impl HoverProvider {
    pub fn new(symbol_table: Arc<SymbolTable>) -> Self {
        HoverProvider { symbol_table }
    }
    
    /// Get hover information at position
    pub fn get_hover(&self, _uri: &Url, position: Position, source: &str) -> Option<Hover> {
        // Extract identifier at position
        let identifier = extract_word_at_position(source, position)?;
        
        // Remove @ or # prefix for lookup
        let lookup_name = identifier.trim_start_matches('@').trim_start_matches('#').to_string();
        
        // Find symbol in symbol table
        let symbol = self.symbol_table.find_symbol(&lookup_name)
            .and_then(|symbols| symbols.first())
            .or_else(|| {
                // Try with prefix
                self.symbol_table.find_symbol(&identifier)
                    .and_then(|symbols| symbols.first())
            })?;
        
        // Build hover content as a single string
        let mut hover_text = String::new();
        
        // Add detail (type/signature)
        if let Some(detail) = &symbol.detail {
            hover_text.push_str(&format!("```tlang\n{}\n```", detail));
        }
        
        // Add documentation if available
        if let Some(docs) = &symbol.documentation {
            if !hover_text.is_empty() {
                hover_text.push_str("\n\n");
            }
            hover_text.push_str(docs);
        }
        
        if hover_text.is_empty() {
            // Fallback: just show the name and kind
            hover_text = format!("{}: {:?}", symbol.name, symbol.kind);
        }
        
        Some(Hover {
            contents: HoverContents::Scalar(MarkedString::String(hover_text)),
            range: None,
        })
    }
}
