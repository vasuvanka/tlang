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

        let (_program, errors) = parser.parse_collect_errors();
        for error in errors {
            let location = error.get_location();
            let line = location.line.saturating_sub(1) as u32;
            let start_col = location.column.saturating_sub(1) as u32;
            let end_col = start_col.saturating_add(1);
            diagnostics.push(Diagnostic {
                range: Range {
                    start: Position {
                        line,
                        character: start_col,
                    },
                    end: Position {
                        line,
                        character: end_col,
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
