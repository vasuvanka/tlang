// Go-to-definition provider for LSP

use tower_lsp::lsp_types::*;
use std::sync::Arc;

use crate::lsp::symbols::SymbolTable;
use crate::lsp::utils::extract_word_at_position;

pub struct DefinitionProvider {
    symbol_table: Arc<SymbolTable>,
}

impl DefinitionProvider {
    pub fn new(symbol_table: Arc<SymbolTable>) -> Self {
        DefinitionProvider { symbol_table }
    }
    
    /// Find definition of symbol at position
    pub fn find_definition(&self, _uri: &Url, position: Position, source: &str) -> Option<GotoDefinitionResponse> {
        // Extract identifier at position
        let identifier = extract_word_at_position(source, position)?;
        
        // Remove @ or # prefix for lookup
        let lookup_name = identifier.trim_start_matches('@').trim_start_matches('#').to_string();
        
        // Find symbol in symbol table
        if let Some(symbols) = self.symbol_table.find_symbol(&lookup_name) {
            // Return first matching symbol's location
            if let Some(symbol) = symbols.first() {
                return Some(GotoDefinitionResponse::Scalar(symbol.location.clone()));
            }
        }
        
        // Also try with prefix
        if let Some(symbols) = self.symbol_table.find_symbol(&identifier) {
            if let Some(symbol) = symbols.first() {
                return Some(GotoDefinitionResponse::Scalar(symbol.location.clone()));
            }
        }
        
        None
    }
}
