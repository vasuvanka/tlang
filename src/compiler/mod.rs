// Compiler core: lexer → parser → ast → type_inference → codegen, plus error and borrow_checker.

pub mod lexer;
pub mod error;
pub mod ast;
pub mod parser;
pub mod type_inference;
pub mod codegen;
pub mod borrow_checker;
