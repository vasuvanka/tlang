// Code completion provider for LSP

use tower_lsp::lsp_types::*;
use std::sync::Arc;

use crate::lsp::symbols::SymbolTable;

pub struct CompletionProvider {
    symbol_table: Arc<SymbolTable>,
}

impl CompletionProvider {
    pub fn new(symbol_table: Arc<SymbolTable>) -> Self {
        CompletionProvider { symbol_table }
    }
    
    /// Convert SymbolKind to CompletionItemKind
    fn symbol_kind_to_completion_kind(symbol_kind: SymbolKind) -> CompletionItemKind {
        match symbol_kind {
            SymbolKind::FUNCTION | SymbolKind::METHOD => CompletionItemKind::FUNCTION,
            SymbolKind::VARIABLE | SymbolKind::FIELD => CompletionItemKind::VARIABLE,
            SymbolKind::CONSTANT => CompletionItemKind::CONSTANT,
            SymbolKind::STRUCT | SymbolKind::CLASS => CompletionItemKind::STRUCT,
            SymbolKind::INTERFACE => CompletionItemKind::INTERFACE,
            SymbolKind::MODULE | SymbolKind::PACKAGE => CompletionItemKind::MODULE,
            _ => CompletionItemKind::TEXT,
        }
    }
    
    /// Get completion items at position
    pub fn complete(&self, _uri: &Url, _position: Position) -> Option<CompletionResponse> {
        let mut items = Vec::new();
        
        // Add standard library functions
        items.extend(self.get_stdlib_completions());
        
        // Add symbols from current file
        for (name, symbols) in self.symbol_table.all_symbols() {
            for symbol in symbols {
                items.push(CompletionItem {
                    label: name.clone(),
                    kind: Some(Self::symbol_kind_to_completion_kind(symbol.kind)),
                    detail: symbol.detail.clone(),
                    documentation: symbol.documentation.clone().map(|d| {
                        Documentation::String(d)
                    }),
                    ..Default::default()
                });
            }
        }
        
        Some(CompletionResponse::Array(items))
    }
    
    /// Get standard library completions
    fn get_stdlib_completions(&self) -> Vec<CompletionItem> {
        vec![
            // fmt library
            self.create_completion("fmt.Printf", SymbolKind::FUNCTION, "fmt.Printf(format string, ...args)"),
            self.create_completion("fmt.Sprintf", SymbolKind::FUNCTION, "fmt.Sprintf(format string, ...args) -> string"),
            // strings library
            self.create_completion("strings.Contains", SymbolKind::FUNCTION, "strings.Contains(s string, substr string) -> bool"),
            self.create_completion("strings.HasPrefix", SymbolKind::FUNCTION, "strings.HasPrefix(s string, prefix string) -> bool"),
            // http library
            self.create_completion("http.Get", SymbolKind::FUNCTION, "http.Get(url string) -> string"),
            self.create_completion("http.Post", SymbolKind::FUNCTION, "http.Post(url string, data string) -> string"),
            self.create_completion("http.Put", SymbolKind::FUNCTION, "http.Put(url string, data string) -> string"),
            self.create_completion("http.Delete", SymbolKind::FUNCTION, "http.Delete(url string) -> string"),
            self.create_completion("http.Head", SymbolKind::FUNCTION, "http.Head(url string) -> string"),
            self.create_completion("http.Options", SymbolKind::FUNCTION, "http.Options(url string) -> string"),
            self.create_completion("http.Patch", SymbolKind::FUNCTION, "http.Patch(url string, data string) -> string"),
            self.create_completion("http.Trace", SymbolKind::FUNCTION, "http.Trace(url string) -> string"),
            self.create_completion("http.Connect", SymbolKind::FUNCTION, "http.Connect(url string) -> string"),
            // json library
            self.create_completion("json.Marshal", SymbolKind::FUNCTION, "json.Marshal(type string, value string) -> string"),
            self.create_completion("json.Unmarshal", SymbolKind::FUNCTION, "json.Unmarshal(json string, type string) -> string"),
            self.create_completion("json.Validate", SymbolKind::FUNCTION, "json.Validate(json string) -> error"),
            // os library
            self.create_completion("os.Getenv", SymbolKind::FUNCTION, "os.Getenv(key string) -> string"),
            self.create_completion("os.Setenv", SymbolKind::FUNCTION, "os.Setenv(key string, value string) -> int"),
            // time library
            self.create_completion("time.Now", SymbolKind::FUNCTION, "time.Now() -> long"),
            self.create_completion("time.Sleep", SymbolKind::FUNCTION, "time.Sleep(seconds int)"),
            // sandarbham (context) library
            self.create_completion("sandarbham.Background", SymbolKind::FUNCTION, "sandarbham.Background() -> context"),
            self.create_completion("sandarbham.TODO", SymbolKind::FUNCTION, "sandarbham.TODO() -> context"),
            self.create_completion("sandarbham.Done", SymbolKind::FUNCTION, "sandarbham.Done(ctx) -> channel"),
            self.create_completion("sandarbham.Err", SymbolKind::FUNCTION, "sandarbham.Err(ctx) -> int (0=ok, 1=cancelled, 2=deadline)"),
            self.create_completion("sandarbham.Deadline_ms", SymbolKind::FUNCTION, "sandarbham.Deadline_ms(ctx) -> long"),
            self.create_completion("sandarbham.Deadline_ok", SymbolKind::FUNCTION, "sandarbham.Deadline_ok(ctx) -> int"),
            self.create_completion("sandarbham.WithCancel", SymbolKind::FUNCTION, "sandarbham.WithCancel(parent) -> context"),
            self.create_completion("sandarbham.Cancel", SymbolKind::FUNCTION, "sandarbham.Cancel(ctx)"),
            self.create_completion("sandarbham.WithDeadline", SymbolKind::FUNCTION, "sandarbham.WithDeadline(parent, deadline_ms) -> context"),
            self.create_completion("sandarbham.WithTimeout", SymbolKind::FUNCTION, "sandarbham.WithTimeout(parent, timeout_ms) -> context"),
            self.create_completion("sandarbham.WithValue", SymbolKind::FUNCTION, "sandarbham.WithValue(parent, key, value) -> context"),
            self.create_completion("sandarbham.Value", SymbolKind::FUNCTION, "sandarbham.Value(ctx, key) -> value"),
        ]
    }
    
    fn create_completion(&self, label: &str, kind: SymbolKind, detail: &str) -> CompletionItem {
        CompletionItem {
            label: label.to_string(),
            kind: Some(Self::symbol_kind_to_completion_kind(kind)),
            detail: Some(detail.to_string()),
            ..Default::default()
        }
    }
}
