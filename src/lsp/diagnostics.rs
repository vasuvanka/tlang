// Diagnostics provider for LSP - error checking and reporting

use tower_lsp::lsp_types::*;

pub struct DiagnosticsProvider;

impl DiagnosticsProvider {
    pub fn new() -> Self {
        DiagnosticsProvider
    }
    
    /// Get diagnostics (errors, warnings) for a document
    pub fn get_diagnostics(&self, source: &str) -> Vec<Diagnostic> {
        let mut diagnostics = Vec::new();
        
        // Parse and check for errors
        use crate::lexer::Lexer;
        use crate::parser::Parser;
        
        let lexer = Lexer::new_with_filename(source, "document.tl".to_string());
        let mut parser = Parser::new(lexer);
        
        if let Err(error) = parser.parse() {
            let location = error.get_location();
            diagnostics.push(Diagnostic {
                range: Range {
                    start: Position {
                        line: (location.line - 1) as u32,
                        character: (location.column - 1) as u32,
                    },
                    end: Position {
                        line: (location.line - 1) as u32,
                        character: (location.column) as u32,
                    },
                },
                severity: Some(DiagnosticSeverity::ERROR),
                code: None,
                code_description: None,
                source: Some("tlang".to_string()),
                message: error.to_string(),
                related_information: None,
                tags: None,
                data: None,
            });
        }
        
        diagnostics
    }
}
