use std::fmt;

#[derive(Debug, Clone)]
pub struct SourceLocation {
    pub line: usize,
    pub column: usize,
    pub filename: String,
}

impl SourceLocation {
    pub fn new(line: usize, column: usize, filename: String) -> Self {
        SourceLocation { line, column, filename }
    }
}

#[derive(Debug, Clone)]
pub enum CompileError {
    LexerError {
        message: String,
        location: SourceLocation,
    },
    ParserError {
        message: String,
        location: SourceLocation,
        context: Vec<String>, // Stack trace of parsing context
    },
    TypeError {
        message: String,
        location: SourceLocation,
    },
    CodegenError {
        message: String,
        location: Option<SourceLocation>,
    },
}

impl CompileError {
    pub fn lexer(message: String, location: SourceLocation) -> Self {
        CompileError::LexerError { message, location }
    }

    pub fn parser(message: String, location: SourceLocation) -> Self {
        CompileError::ParserError {
            message,
            location,
            context: Vec::new(),
        }
    }

    pub fn parser_with_context(
        message: String,
        location: SourceLocation,
        context: Vec<String>,
    ) -> Self {
        CompileError::ParserError {
            message,
            location,
            context,
        }
    }

    pub fn type_error(message: String, location: SourceLocation) -> Self {
        CompileError::TypeError { message, location }
    }

    pub fn codegen(message: String, location: Option<SourceLocation>) -> Self {
        CompileError::CodegenError { message, location }
    }

    pub fn get_location(&self) -> &SourceLocation {
        match self {
            CompileError::LexerError { location, .. } => location,
            CompileError::ParserError { location, .. } => location,
            CompileError::TypeError { location, .. } => location,
            CompileError::CodegenError { location, .. } => {
                location.as_ref().expect("CodegenError should have location")
            }
        }
    }

    pub fn add_context(&mut self, context: String) {
        if let CompileError::ParserError { context: ctx, .. } = self {
            ctx.push(context);
        }
    }
}

impl fmt::Display for CompileError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            CompileError::LexerError { message, location } => {
                write!(
                    f,
                    "Lexer Error at {}:{}:{}: {}",
                    location.filename, location.line, location.column, message
                )
            }
            CompileError::ParserError {
                message,
                location,
                context,
            } => {
                write!(
                    f,
                    "Parser Error at {}:{}:{}: {}\n",
                    location.filename, location.line, location.column, message
                )?;
                if !context.is_empty() {
                    writeln!(f, "\nContext (most recent call last):")?;
                    for (i, ctx) in context.iter().enumerate().rev() {
                        writeln!(f, "  {}: {}", context.len() - i, ctx)?;
                    }
                }
                Ok(())
            }
            CompileError::TypeError { message, location } => {
                write!(
                    f,
                    "Type Error at {}:{}:{}: {}",
                    location.filename, location.line, location.column, message
                )
            }
            CompileError::CodegenError { message, location } => {
                if let Some(loc) = location {
                    write!(
                        f,
                        "Codegen Error at {}:{}:{}: {}",
                        loc.filename, loc.line, loc.column, message
                    )
                } else {
                    write!(f, "Codegen Error: {}", message)
                }
            }
        }
    }
}

pub type CompileResult<T> = Result<T, CompileError>;

impl From<std::fmt::Error> for CompileError {
    fn from(e: std::fmt::Error) -> Self {
        CompileError::CodegenError {
            message: format!("Formatting error: {}", e),
            location: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_source_location_new() {
        let loc = SourceLocation::new(10, 5, "test.tl".to_string());
        assert_eq!(loc.line, 10);
        assert_eq!(loc.column, 5);
        assert_eq!(loc.filename, "test.tl");
    }

    #[test]
    fn test_compile_error_lexer() {
        let loc = SourceLocation::new(1, 0, "a.tl".to_string());
        let err = CompileError::lexer("unexpected char".to_string(), loc.clone());
        match &err {
            CompileError::LexerError { message, location } => {
                assert_eq!(message, "unexpected char");
                assert_eq!(location.line, 1);
            }
            _ => panic!("expected LexerError"),
        }
        assert_eq!(err.get_location().line, 1);
    }

    #[test]
    fn test_compile_error_parser() {
        let loc = SourceLocation::new(2, 3, "b.tl".to_string());
        let err = CompileError::parser("expected semicolon".to_string(), loc.clone());
        match &err {
            CompileError::ParserError { message, context, .. } => {
                assert_eq!(message, "expected semicolon");
                assert!(context.is_empty());
            }
            _ => panic!("expected ParserError"),
        }
        assert_eq!(err.get_location().column, 3);
    }

    #[test]
    fn test_compile_error_parser_with_context() {
        let loc = SourceLocation::new(5, 0, "c.tl".to_string());
        let ctx = vec!["while parsing function declaration".to_string()];
        let err = CompileError::parser_with_context("expected )".to_string(), loc, ctx);
        match &err {
            CompileError::ParserError { context, .. } => {
                assert_eq!(context.len(), 1);
                assert_eq!(context[0], "while parsing function declaration");
            }
            _ => panic!("expected ParserError"),
        }
    }

    #[test]
    fn test_compile_error_add_context() {
        let loc = SourceLocation::new(1, 0, "d.tl".to_string());
        let mut err = CompileError::parser("oops".to_string(), loc);
        err.add_context("inner context".to_string());
        match &err {
            CompileError::ParserError { context, .. } => {
                assert_eq!(context.len(), 1);
                assert_eq!(context[0], "inner context");
            }
            _ => panic!("expected ParserError"),
        }
    }

    #[test]
    fn test_compile_error_type_error() {
        let loc = SourceLocation::new(3, 2, "e.tl".to_string());
        let err = CompileError::type_error("mismatched types".to_string(), loc);
        match &err {
            CompileError::TypeError { message, location } => {
                assert_eq!(message, "mismatched types");
                assert_eq!(location.filename, "e.tl");
            }
            _ => panic!("expected TypeError"),
        }
    }

    #[test]
    fn test_compile_error_codegen_with_location() {
        let loc = SourceLocation::new(7, 1, "f.tl".to_string());
        let err = CompileError::codegen("unknown type".to_string(), Some(loc.clone()));
        match &err {
            CompileError::CodegenError { message, location } => {
                assert_eq!(message, "unknown type");
                assert_eq!(location.as_ref().unwrap().line, 7);
            }
            _ => panic!("expected CodegenError"),
        }
        assert_eq!(err.get_location().line, 7);
    }

    #[test]
    fn test_compile_error_display_lexer() {
        let loc = SourceLocation::new(1, 0, "x.tl".to_string());
        let err = CompileError::lexer("bad".to_string(), loc);
        let s = format!("{}", err);
        assert!(s.contains("Lexer Error"));
        assert!(s.contains("x.tl"));
        assert!(s.contains("bad"));
    }
}
