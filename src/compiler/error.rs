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
