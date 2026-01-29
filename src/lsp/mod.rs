// LSP (Language Server Protocol) implementation for Tlang
// Provides IDE support: code completion, go-to-definition, hover, diagnostics, formatting

pub mod server;
pub mod symbols;
pub mod completion;
pub mod definition;
pub mod hover;
pub mod diagnostics;
pub mod formatting;
pub mod utils;

pub use server::TlangLanguageServer;
