// LSP Server implementation
// Handles JSON-RPC communication and delegates to specific feature handlers

use tower_lsp::{LspService, Server};
use tower_lsp::lsp_types::*;
use tower_lsp::jsonrpc::Result;
use std::sync::{Arc, Mutex};
use std::collections::HashMap;
use std::path::PathBuf;

use crate::lsp::symbols::SymbolTable;
use crate::lsp::completion::CompletionProvider;
use crate::lsp::definition::DefinitionProvider;
use crate::lsp::hover::HoverProvider;
use crate::lsp::diagnostics::DiagnosticsProvider;
use crate::lsp::formatting::FormattingProvider;

/// Document state
#[derive(Debug, Clone)]
struct DocumentState {
    text: String,
    version: i32,
}

/// Tlang Language Server
#[derive(Debug)]
pub struct TlangLanguageServer {
    client: tower_lsp::Client,
    symbol_tables: Arc<Mutex<HashMap<PathBuf, Arc<SymbolTable>>>>,
    documents: Arc<Mutex<HashMap<PathBuf, DocumentState>>>,
    workspace_root: Arc<Mutex<Option<PathBuf>>>,
}

impl TlangLanguageServer {
    pub fn new(client: tower_lsp::Client) -> Self {
        TlangLanguageServer {
            client,
            symbol_tables: Arc::new(Mutex::new(HashMap::new())),
            documents: Arc::new(Mutex::new(HashMap::new())),
            workspace_root: Arc::new(Mutex::new(None)),
        }
    }
    
    /// Update symbol table for a document
    fn update_symbol_table(&self, uri: &Url, text: &str) {
        if let Ok(symbol_table) = SymbolTable::from_source(text, uri) {
            if let Ok(path) = uri.to_file_path() {
                self.symbol_tables.lock().unwrap().insert(path, Arc::new(symbol_table));
            }
        }
    }

    /// Create and run the LSP server
    pub async fn run() {
        let stdin = tokio::io::stdin();
        let stdout = tokio::io::stdout();

        let (service, socket) = LspService::new(|client| TlangLanguageServer::new(client));
        Server::new(stdin, stdout, socket).serve(service).await;
    }
}

#[tower_lsp::async_trait]
impl tower_lsp::LanguageServer for TlangLanguageServer {
    async fn initialize(&self, params: InitializeParams) -> Result<InitializeResult> {
        // Store workspace root if provided
        let workspace_root = params.root_uri.and_then(|uri| uri.to_file_path().ok());
        if let Some(root) = &workspace_root {
            *self.workspace_root.lock().unwrap() = Some(root.clone());
        }
        
        Ok(InitializeResult {
            server_info: Some(ServerInfo {
                name: "tlang-lsp".to_string(),
                version: Some("0.1.0".to_string()),
            }),
            capabilities: ServerCapabilities {
                text_document_sync: Some(TextDocumentSyncCapability::Kind(
                    TextDocumentSyncKind::INCREMENTAL,
                )),
                completion_provider: Some(CompletionOptions {
                    resolve_provider: Some(false),
                    trigger_characters: Some(vec![
                        ".".to_string(),
                        ":".to_string(),
                        "@".to_string(),
                        "#".to_string(),
                    ]),
                    ..Default::default()
                }),
                hover_provider: Some(HoverProviderCapability::Simple(true)),
                definition_provider: Some(OneOf::Left(true)),
                document_formatting_provider: Some(OneOf::Left(true)),
                document_on_type_formatting_provider: Some(DocumentOnTypeFormattingOptions {
                    first_trigger_character: "}".to_string(),
                    more_trigger_character: Some(vec![";".to_string(), "\n".to_string()]),
                }),
                ..Default::default()
            },
        })
    }

    async fn initialized(&self, _: InitializedParams) {
        self.client.log_message(MessageType::INFO, "Tlang Language Server initialized").await;
    }

    async fn shutdown(&self) -> Result<()> {
        Ok(())
    }

    async fn did_open(&self, params: DidOpenTextDocumentParams) {
        let uri = params.text_document.uri;
        let text = params.text_document.text;
        let version = params.text_document.version;
        
        // Store document state
        if let Ok(path) = uri.to_file_path() {
            self.documents.lock().unwrap().insert(path.clone(), DocumentState {
                text: text.clone(),
                version,
            });
        }
        
        // Parse document and build symbol table
        self.update_symbol_table(&uri, &text);
        
        // Publish diagnostics
        self.publish_diagnostics(&uri, &text).await;
    }

    async fn did_change(&self, params: DidChangeTextDocumentParams) {
        let uri = params.text_document.uri;
        let version = params.text_document.version;
        
        // Extract the updated text while holding the lock, then release it before await
        let updated_text = if let Ok(path) = uri.to_file_path() {
            let mut documents = self.documents.lock().unwrap();
            if let Some(doc_state) = documents.get_mut(&path) {
                // Apply incremental changes
                for change in params.content_changes.clone() {
                    match change {
                        TextDocumentContentChangeEvent {
                            range: Some(range),
                            range_length: _,
                            text,
                        } => {
                            // Apply range-based change using line-based splicing
                            let lines: Vec<String> = doc_state.text.lines().map(String::from).collect();
                            let start_line = range.start.line as usize;
                            let end_line = range.end.line as usize;
                            let start_char = range.start.character as usize;
                            let end_char = range.end.character as usize;
                            
                            if start_line < lines.len() && end_line < lines.len() {
                                let mut new_lines = lines[..start_line].to_vec();
                                
                                // Handle first line
                                if start_line == end_line {
                                    // Single line edit
                                    let line = &lines[start_line];
                                    let new_line = format!("{}{}{}", 
                                        &line[..start_char.min(line.len())],
                                        text,
                                        &line[end_char.min(line.len())..]
                                    );
                                    new_lines.push(new_line);
                                } else {
                                    // Multi-line edit
                                    let first_line = &lines[start_line];
                                    let last_line = &lines[end_line];
                                    let new_first = format!("{}{}", 
                                        &first_line[..start_char.min(first_line.len())],
                                        text.lines().next().unwrap_or("")
                                    );
                                    new_lines.push(new_first);
                                    
                                    // Add middle lines from replacement text
                                    let replacement_lines: Vec<&str> = text.lines().collect();
                                    if replacement_lines.len() > 1 {
                                        new_lines.extend(replacement_lines[1..].iter().map(|s| s.to_string()));
                                    }
                                    
                                    // Handle last line
                                    if end_char < last_line.len() {
                                        new_lines.push(format!("{}{}", 
                                            replacement_lines.last().unwrap_or(&""),
                                            &last_line[end_char..]
                                        ));
                                    }
                                }
                                
                                // Add remaining lines
                                if end_line + 1 < lines.len() {
                                    new_lines.extend_from_slice(&lines[end_line + 1..]);
                                }
                                
                                doc_state.text = new_lines.join("\n");
                            } else {
                                // Fallback: full replacement
                                doc_state.text = text;
                            }
                        }
                        TextDocumentContentChangeEvent {
                            range: None,
                            range_length: _,
                            text,
                        } => {
                            // Full document replacement
                            doc_state.text = text;
                        }
                    }
                }
                doc_state.version = version;
                Some(doc_state.text.clone())
            } else {
                None
            }
        } else {
            None
        };
        
        // Now perform async operations outside the lock
        if let Some(text) = updated_text {
            self.update_symbol_table(&uri, &text);
            self.publish_diagnostics(&uri, &text).await;
        }
    }

    async fn did_save(&self, params: DidSaveTextDocumentParams) {
        let uri = params.text_document.uri;
        
        // Rebuild symbol table on save and publish diagnostics
        // Extract text while holding lock, then release before await
        let text = if let Ok(path) = uri.to_file_path() {
            self.documents.lock().unwrap().get(&path).map(|doc| doc.text.clone())
        } else {
            None
        };
        
        if let Some(text) = text {
            self.update_symbol_table(&uri, &text);
            self.publish_diagnostics(&uri, &text).await;
        }
    }

    async fn did_close(&self, params: DidCloseTextDocumentParams) {
        // Clean up symbol table and document state for closed document
        if let Ok(path) = params.text_document.uri.to_file_path() {
            self.symbol_tables.lock().unwrap().remove(&path);
            self.documents.lock().unwrap().remove(&path);
        }
    }

    async fn completion(&self, params: CompletionParams) -> Result<Option<CompletionResponse>> {
        let uri = params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;
        
        if let Ok(path) = uri.to_file_path() {
            let tables = self.symbol_tables.lock().unwrap();
            if let Some(symbol_table) = tables.get(&path) {
                let provider = CompletionProvider::new(symbol_table.clone());
                return Ok(provider.complete(&uri, position));
            }
        }
        
        Ok(None)
    }

    async fn goto_definition(
        &self,
        params: GotoDefinitionParams,
    ) -> Result<Option<GotoDefinitionResponse>> {
        let uri = params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;
        
        if let Ok(path) = uri.to_file_path() {
            let tables = self.symbol_tables.lock().unwrap();
            let documents = self.documents.lock().unwrap();
            
            if let Some(symbol_table) = tables.get(&path) {
                if let Some(doc_state) = documents.get(&path) {
                    let provider = DefinitionProvider::new(symbol_table.clone());
                    return Ok(provider.find_definition(&uri, position, &doc_state.text));
                }
            }
        }
        
        Ok(None)
    }

    async fn hover(&self, params: HoverParams) -> Result<Option<Hover>> {
        let uri = params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;
        
        if let Ok(path) = uri.to_file_path() {
            let tables = self.symbol_tables.lock().unwrap();
            let documents = self.documents.lock().unwrap();
            
            if let Some(symbol_table) = tables.get(&path) {
                if let Some(doc_state) = documents.get(&path) {
                    let provider = HoverProvider::new(symbol_table.clone());
                    return Ok(provider.get_hover(&uri, position, &doc_state.text));
                }
            }
        }
        
        Ok(None)
    }

    async fn formatting(&self, params: DocumentFormattingParams) -> Result<Option<Vec<TextEdit>>> {
        let uri = params.text_document.uri;
        
        if let Ok(path) = uri.to_file_path() {
            let tables = self.symbol_tables.lock().unwrap();
            let documents = self.documents.lock().unwrap();
            
            if let Some(symbol_table) = tables.get(&path) {
                if let Some(doc_state) = documents.get(&path) {
                    let provider = FormattingProvider::new(symbol_table.clone());
                    return Ok(provider.format_document(&uri, &doc_state.text));
                }
            }
        }
        
        Ok(None)
    }

    async fn on_type_formatting(&self, params: DocumentOnTypeFormattingParams) -> Result<Option<Vec<TextEdit>>> {
        let uri = params.text_document_position.text_document.uri;
        
        if let Ok(path) = uri.to_file_path() {
            let tables = self.symbol_tables.lock().unwrap();
            let documents = self.documents.lock().unwrap();
            
            if let Some(symbol_table) = tables.get(&path) {
                if let Some(doc_state) = documents.get(&path) {
                    let provider = FormattingProvider::new(symbol_table.clone());
                    return Ok(provider.format_on_type(&uri, params.text_document_position.position, params.ch, &doc_state.text));
                }
            }
        }
        
        Ok(None)
    }
}

impl TlangLanguageServer {
    /// Publish diagnostics for a document
    async fn publish_diagnostics(&self, uri: &Url, text: &str) {
        let provider = DiagnosticsProvider::new();
        let diagnostics = provider.get_diagnostics(text);
        
        self.client.publish_diagnostics(uri.clone(), diagnostics, None).await;
    }
}
