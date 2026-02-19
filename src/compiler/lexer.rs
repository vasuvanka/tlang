#[derive(Debug, Clone, PartialEq)]
pub enum Token {
    // Identifiers and literals
    Identifier(String),
    Number(f64),
    String(String),
    
    // Math operators
    Plus,      // +
    Minus,     // -
    Multiply,  // *
    Divide,    // /
    Modulo,    // %
    Power,     // ^
    
    // Comparison operators
    Equal,           // ==
    NotEqual,        // !=
    LessThan,        // <
    GreaterThan,     // >
    LessThanEqual,   // <=
    GreaterThanEqual, // >=
    
    // Assignment
    Assign,          // =
    
    // Delimiters
    LeftParen,       // (
    RightParen,      // )
    LeftBrace,       // {
    RightBrace,      // }
    LeftBracket,     // [
    RightBracket,    // ]
    Comma,           // ,
    Semicolon,       // ;
    Dot,             // .
    Colon,           // :
    
    // Keywords (Telugu equivalents)
    AtIdentifier(String),  // @variableName - variable declaration
    AtMutIdentifier(String), // @!variableName - mutable variable declaration
    HashIdentifier(String), // #functionName - function declaration
    Okavela,         // okavela (Telugu for "if")
    Lekapothe,       // lekapothe (Telugu for "else")
    Malli,           // malli loop (Telugu for "again")
    Mallinchu,       // mallinchu (Telugu for "return")
    Agu,             // agu (Telugu for "break")
    Konasagu,        // konasagu (Telugu for "continue")
    Nirmanam,        // nirmanam (Telugu for "struct")
    Jatha,           // jatha (Telugu for "map")
    Sunyam,          // sunyam (Telugu for "nil")
    Varasa,          // varasa (for range-based loops: malli key := varasa map)
    // Type keywords
    IntType,         // integer type
    FloatType,       // float type
    StringType,      // string type
    BoolType,        // boolean type
    ErrorType,       // error type
    ChannelType,     // channel type (channel[elementType])
    
    // Borrow checker related
    Ampersand,       // & (immutable borrow)
    AmpersandMut,    // &mut (mutable borrow)
    Jarugu,          // <- move / channel send & receive (only from <-, no keyword)
    
    // Special characters
    QuestionMark,    // ? (error propagation)
    Backtick,        // ` (tags in structs)
    
    // Special
    Invalid(String),
    EOF,
    Newline,
}

pub struct Lexer {
    input: Vec<char>,
    position: usize,
    current_char: Option<char>,
    line: usize,
    column: usize,
    filename: String,
}

impl Lexer {
    pub fn new(input: &str) -> Self {
        Lexer::new_with_filename(input, "input".to_string())
    }

    pub fn new_with_filename(input: &str, filename: String) -> Self {
        let chars: Vec<char> = input.chars().collect();
        let current = if chars.is_empty() { None } else { Some(chars[0]) };
        
        Lexer {
            input: chars,
            position: 0,
            current_char: current,
            line: 1,
            column: 1,
            filename,
        }
    }

    pub fn get_location(&self) -> crate::error::SourceLocation {
        crate::error::SourceLocation::new(self.line, self.column, self.filename.clone())
    }
    
    fn advance(&mut self) {
        if let Some(ch) = self.current_char {
            if ch == '\n' {
                self.line += 1;
                self.column = 1;
            } else {
                self.column += 1;
            }
        }
        
        self.position += 1;
        if self.position >= self.input.len() {
            self.current_char = None;
        } else {
            self.current_char = Some(self.input[self.position]);
        }
    }
    
    fn skip_whitespace(&mut self) {
        while let Some(ch) = self.current_char {
            if ch.is_whitespace() && ch != '\n' {
                self.advance();
            } else {
                break;
            }
        }
    }
    
    fn read_number(&mut self) -> f64 {
        let mut num_str = String::new();
        while let Some(ch) = self.current_char {
            if ch.is_ascii_digit() || ch == '.' {
                num_str.push(ch);
                self.advance();
            } else {
                break;
            }
        }
        num_str.parse().unwrap_or(0.0)
    }
    
    fn read_identifier(&mut self) -> String {
        let mut ident = String::new();
        while let Some(ch) = self.current_char {
            if ch.is_alphanumeric() || ch == '_' {
                ident.push(ch);
                self.advance();
            } else {
                break;
            }
        }
        ident
    }
    
    fn read_string(&mut self) -> (String, bool) {
        let mut s = String::new();
        self.advance(); // Skip opening quote
        while let Some(ch) = self.current_char {
            if ch == '"' {
                self.advance();
                return (s, true);
            }
            s.push(ch);
            self.advance();
        }
        (s, false)
    }
    
    fn read_tag(&mut self) -> (String, bool) {
        let mut s = String::new();
        self.advance(); // Skip opening backtick
        while let Some(ch) = self.current_char {
            if ch == '`' {
                self.advance();
                return (s, true);
            }
            s.push(ch);
            self.advance();
        }
        (s, false)
    }
    
    pub fn next_token(&mut self) -> Token {
        self.skip_whitespace();
        
        let token = match self.current_char {
            None => Token::EOF,
            Some('\n') => {
                self.advance();
                Token::Newline
            }
            Some('+') => {
                self.advance();
                Token::Plus
            }
            Some('-') => {
                self.advance();
                Token::Minus
            }
            Some('*') => {
                self.advance();
                Token::Multiply
            }
            Some('/') => {
                self.advance();
                // Check for comment
                if let Some('/') = self.current_char {
                    // Single-line comment: //
                    // Skip until newline
                    while let Some(ch) = self.current_char {
                        if ch == '\n' {
                            break;
                        }
                        self.advance();
                    }
                    // Recursively get next token (skip the comment)
                    self.next_token()
                } else if let Some('*') = self.current_char {
                    // Multi-line comment: /* ... */
                    self.advance(); // Skip the '*'
                    let mut found_end = false;
                    while let Some(ch) = self.current_char {
                        if ch == '*' {
                            self.advance();
                            if let Some('/') = self.current_char {
                                self.advance(); // Skip the '/'
                                found_end = true;
                                break;
                            }
                        } else {
                            self.advance();
                        }
                    }
                    if !found_end {
                        Token::Invalid("Unterminated multi-line comment. Add closing '*/'.".to_string())
                    } else {
                        // Recursively get next token (skip the comment)
                        self.next_token()
                    }
                } else {
                    Token::Divide
                }
            }
            Some('%') => {
                self.advance();
                Token::Modulo
            }
            Some('^') => {
                self.advance();
                Token::Power
            }
            Some('&') => {
                self.advance();
                // Check for &mut
                if let Some(ch) = self.current_char {
                    if ch == 'm' {
                        // Peek ahead for "mut"
                        let saved_pos = self.position;
                        let saved_col = self.column;
                        let saved_line = self.line;
                        let saved_char = self.current_char;
                        
                        // Try to read "mut"
                        let mut ident = String::new();
                        while let Some(c) = self.current_char {
                            if c.is_alphabetic() {
                                ident.push(c);
                                self.advance();
                            } else {
                                break;
                            }
                        }
                        
                        if ident == "mut" {
                            Token::AmpersandMut
                        } else {
                            // Not "mut", restore position and return Ampersand
                            self.position = saved_pos;
                            self.column = saved_col;
                            self.line = saved_line;
                            self.current_char = saved_char;
                            Token::Ampersand
                        }
                    } else {
                        Token::Ampersand
                    }
                } else {
                    Token::Ampersand
                }
            }
            Some('=') => {
                self.advance();
                if let Some('=') = self.current_char {
                    self.advance();
                    Token::Equal
                } else {
                    Token::Assign
                }
            }
            Some('!') => {
                self.advance();
                if let Some('=') = self.current_char {
                    self.advance();
                    Token::NotEqual
                } else {
                    Token::Invalid("Unexpected '!'. Use '!=' for comparison or '@!name' for mutable variable declaration.".to_string())
                }
            }
            Some('<') => {
                self.advance();
                if let Some('=') = self.current_char {
                    self.advance();
                    Token::LessThanEqual
                } else if let Some('-') = self.current_char {
                    self.advance();
                    Token::Jarugu  // <- move / channel send & receive
                } else {
                    Token::LessThan
                }
            }
            Some('>') => {
                self.advance();
                if let Some('=') = self.current_char {
                    self.advance();
                    Token::GreaterThanEqual
                } else {
                    Token::GreaterThan
                }
            }
            Some('(') => {
                self.advance();
                Token::LeftParen
            }
            Some(')') => {
                self.advance();
                Token::RightParen
            }
            Some('{') => {
                self.advance();
                Token::LeftBrace
            }
            Some('}') => {
                self.advance();
                Token::RightBrace
            }
            Some(',') => {
                self.advance();
                Token::Comma
            }
            Some(';') => {
                self.advance();
                Token::Semicolon
            }
            Some('.') => {
                self.advance();
                Token::Dot
            }
            Some(':') => {
                self.advance();
                Token::Colon
            }
            Some('?') => {
                self.advance();
                Token::QuestionMark
            }
            Some('[') => {
                self.advance();
                Token::LeftBracket
            }
            Some(']') => {
                self.advance();
                Token::RightBracket
            }
            Some('@') => {
                self.advance();
                // Check for @! (mutable variable declaration)
                if let Some('!') = self.current_char {
                    // Check for @! (mutable variable declaration)
                    self.advance();
                    // Read identifier immediately after @! (no space)
                    if let Some(ch) = self.current_char {
                        if ch.is_alphabetic() || ch == '_' {
                            let ident = self.read_identifier();
                            Token::AtMutIdentifier(ident)
                        } else {
                            // @! without identifier is an error, but return AtMutIdentifier for now
                            Token::AtMutIdentifier("".to_string())
                        }
                    } else {
                        Token::AtMutIdentifier("".to_string())
                    }
                } else {
                    // Single @ - variable declaration
                    // Read identifier immediately after @ (no space)
                    if let Some(ch) = self.current_char {
                        if ch.is_alphabetic() || ch == '_' {
                            let ident = self.read_identifier();
                            Token::AtIdentifier(ident)
                        } else {
                            // @ without identifier is an error, but return AtIdentifier for now
                            Token::AtIdentifier("".to_string())
                        }
                    } else {
                        Token::AtIdentifier("".to_string())
                    }
                }
            }
            Some('#') => {
                self.advance();
                // Read identifier immediately after # (no space)
                if let Some(ch) = self.current_char {
                    if ch.is_alphabetic() || ch == '_' {
                        let ident = self.read_identifier();
                        Token::HashIdentifier(ident)
                    } else {
                        // # without identifier is an error, but return HashIdentifier for now
                        Token::HashIdentifier("".to_string())
                    }
                } else {
                    Token::HashIdentifier("".to_string())
                }
            }
            Some('"') => {
                let (value, terminated) = self.read_string();
                if terminated {
                    Token::String(value)
                } else {
                    Token::Invalid("Unterminated string literal. Add closing '\"'.".to_string())
                }
            }
            Some('`') => {
                let (tag_content, terminated) = self.read_tag();
                if terminated {
                    Token::String(tag_content) // Tag content as string
                } else {
                    Token::Invalid("Unterminated tag literal. Add closing '`'.".to_string())
                }
            }
            Some(ch) if ch.is_ascii_digit() => {
                Token::Number(self.read_number())
            }
            Some(ch) if ch.is_alphabetic() || ch == '_' => {
                let ident = self.read_identifier();
                match ident.as_str() {
                    "okavela" => Token::Okavela,
                    "lekapothe" => Token::Lekapothe,
                    "malli" => Token::Malli,
                    "mallinchu" => Token::Mallinchu,
                    "agu" => Token::Agu,
                    "konasagu" => Token::Konasagu,
                    "nirmanam" => Token::Nirmanam,
                    "jatha" => Token::Jatha,
                    "sunyam" => Token::Sunyam,  // nil keyword
                    "int" => Token::IntType,
                    "float" => Token::FloatType,
                    "string" => Token::StringType,
                    "bool" => Token::BoolType,
                    "error" => Token::ErrorType,  // error type
                    "channel" => Token::ChannelType,
                    "true" => Token::Identifier("true".to_string()), // Boolean literal
                    "false" => Token::Identifier("false".to_string()), // Boolean literal
                    "prarambham" => Token::Identifier("prarambham".to_string()), // Entry point function (Telugu for "beginning")
                    _ => Token::Identifier(ident),
                }
            }
            Some(ch) => {
                let suggestion = match ch {
                    '“' | '”' => " Use regular double quotes (\").",
                    '‘' | '’' => " Use regular single quotes (').",
                    _ => "",
                };
                self.advance();
                Token::Invalid(format!("Unexpected character '{}'.{}", ch, suggestion))
            }
        };
        
        token
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_tokens() {
        let mut lexer = Lexer::new("+ - * / %");
        assert_eq!(lexer.next_token(), Token::Plus);
        assert_eq!(lexer.next_token(), Token::Minus);
        assert_eq!(lexer.next_token(), Token::Multiply);
        assert_eq!(lexer.next_token(), Token::Divide);
        assert_eq!(lexer.next_token(), Token::Modulo);
    }

    #[test]
    fn test_numbers() {
        let mut lexer = Lexer::new("123 45.67");
        assert_eq!(lexer.next_token(), Token::Number(123.0));
        assert_eq!(lexer.next_token(), Token::Number(45.67));
    }

    #[test]
    fn test_comparison_and_assign() {
        let mut lexer = Lexer::new("== != <= >= < > =");
        assert_eq!(lexer.next_token(), Token::Equal);
        assert_eq!(lexer.next_token(), Token::NotEqual);
        assert_eq!(lexer.next_token(), Token::LessThanEqual);
        assert_eq!(lexer.next_token(), Token::GreaterThanEqual);
        assert_eq!(lexer.next_token(), Token::LessThan);
        assert_eq!(lexer.next_token(), Token::GreaterThan);
        assert_eq!(lexer.next_token(), Token::Assign);
    }

    #[test]
    fn test_move_operator() {
        let mut lexer = Lexer::new("<-");
        assert_eq!(lexer.next_token(), Token::Jarugu);
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_less_than_not_move() {
        let mut lexer = Lexer::new("<  -");
        assert_eq!(lexer.next_token(), Token::LessThan);
        assert_eq!(lexer.next_token(), Token::Minus);
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_keywords() {
        let mut lexer = Lexer::new("okavela lekapothe malli mallinchu agu konasagu nirmanam jatha sunyam");
        assert_eq!(lexer.next_token(), Token::Okavela);
        assert_eq!(lexer.next_token(), Token::Lekapothe);
        assert_eq!(lexer.next_token(), Token::Malli);
        assert_eq!(lexer.next_token(), Token::Mallinchu);
        assert_eq!(lexer.next_token(), Token::Agu);
        assert_eq!(lexer.next_token(), Token::Konasagu);
        assert_eq!(lexer.next_token(), Token::Nirmanam);
        assert_eq!(lexer.next_token(), Token::Jatha);
        assert_eq!(lexer.next_token(), Token::Sunyam);
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_varasa_as_identifier() {
        let mut lexer = Lexer::new("varasa");
        assert_eq!(lexer.next_token(), Token::Identifier("varasa".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_type_keywords() {
        let mut lexer = Lexer::new("int float string bool error channel");
        assert_eq!(lexer.next_token(), Token::IntType);
        assert_eq!(lexer.next_token(), Token::FloatType);
        assert_eq!(lexer.next_token(), Token::StringType);
        assert_eq!(lexer.next_token(), Token::BoolType);
        assert_eq!(lexer.next_token(), Token::ErrorType);
        assert_eq!(lexer.next_token(), Token::ChannelType);
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_at_identifier() {
        let mut lexer = Lexer::new("@x");
        assert_eq!(lexer.next_token(), Token::AtIdentifier("x".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_at_mut_identifier() {
        let mut lexer = Lexer::new("@!count");
        assert_eq!(lexer.next_token(), Token::AtMutIdentifier("count".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_hash_identifier() {
        let mut lexer = Lexer::new("#prarambham");
        assert_eq!(lexer.next_token(), Token::HashIdentifier("prarambham".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_string_literal() {
        let mut lexer = Lexer::new(r#""hello""#);
        assert_eq!(lexer.next_token(), Token::String("hello".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_delimiters() {
        let mut lexer = Lexer::new("( ) { } [ ] , ; . :");
        assert_eq!(lexer.next_token(), Token::LeftParen);
        assert_eq!(lexer.next_token(), Token::RightParen);
        assert_eq!(lexer.next_token(), Token::LeftBrace);
        assert_eq!(lexer.next_token(), Token::RightBrace);
        assert_eq!(lexer.next_token(), Token::LeftBracket);
        assert_eq!(lexer.next_token(), Token::RightBracket);
        assert_eq!(lexer.next_token(), Token::Comma);
        assert_eq!(lexer.next_token(), Token::Semicolon);
        assert_eq!(lexer.next_token(), Token::Dot);
        assert_eq!(lexer.next_token(), Token::Colon);
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_identifier_and_boolean_literals() {
        let mut lexer = Lexer::new("true false foo_bar");
        assert_eq!(lexer.next_token(), Token::Identifier("true".to_string()));
        assert_eq!(lexer.next_token(), Token::Identifier("false".to_string()));
        assert_eq!(lexer.next_token(), Token::Identifier("foo_bar".to_string()));
        assert_eq!(lexer.next_token(), Token::EOF);
    }

    #[test]
    fn test_power_and_question_mark() {
        let mut lexer = Lexer::new("^ ?");
        assert_eq!(lexer.next_token(), Token::Power);
        assert_eq!(lexer.next_token(), Token::QuestionMark);
        assert_eq!(lexer.next_token(), Token::EOF);
    }
}
