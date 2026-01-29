// Tlang Language Server Protocol (LSP) server
// Run with: cargo run --bin tlang-lsp

use tlang::lsp::TlangLanguageServer;

#[tokio::main]
async fn main() {
    TlangLanguageServer::run().await;
}
