use crate::ast::*;
use crate::lexer::{Lexer, Token};
use crate::error::{CompileError, CompileResult, SourceLocation};
use std::collections::{HashSet, HashMap};

pub struct Parser {
    lexer: Lexer,
    current_token: Token,
    context_stack: Vec<String>, // For error stack traces
    declared_vars: Vec<HashSet<String>>, // Stack of variable scopes (for nested blocks)
    mutable_vars: HashMap<String, bool>, // Track which variables are mutable (name -> is_mutable)
}

impl Parser {
    pub fn new(mut lexer: Lexer) -> Self {
        let first_token = lexer.next_token();
        let mut parser = Parser {
            lexer,
            current_token: first_token,
            context_stack: Vec::new(),
            declared_vars: Vec::new(),
            mutable_vars: HashMap::new(),
        };
        // Initialize with global scope
        parser.declared_vars.push(HashSet::new());
        parser
    }
    
    fn push_scope(&mut self) {
        self.declared_vars.push(HashSet::new());
    }
    
    fn pop_scope(&mut self) {
        self.declared_vars.pop();
    }
    
    fn current_scope(&mut self) -> &mut HashSet<String> {
        self.declared_vars.last_mut().unwrap()
    }
    
    fn is_declared(&self, name: &str) -> bool {
        // Check all scopes from innermost to outermost
        for scope in self.declared_vars.iter().rev() {
            if scope.contains(name) {
                return true;
            }
        }
        false
    }
    
    fn declare_var(&mut self, name: String, is_mutable: bool) -> CompileResult<()> {
        if self.is_declared(&name) {
            let location = self.get_location();
            let context = self.context_stack.clone();
            return Err(CompileError::parser_with_context(
                format!("Variable '{}' is already declared in this scope", name),
                location,
                context,
            ));
        }
        self.current_scope().insert(name.clone());
        self.mutable_vars.insert(name, is_mutable);
        Ok(())
    }
    
    fn is_variable_mutable(&self, name: &str) -> bool {
        // Check if variable is declared in any scope (from innermost to outermost)
        // and return its mutability status
        for scope in self.declared_vars.iter().rev() {
            if scope.contains(name) {
                return self.mutable_vars.get(name).copied().unwrap_or(false);
            }
        }
        false // Variable not found - default to immutable
    }
    
    fn advance(&mut self) {
        self.current_token = self.lexer.next_token();
    }

    fn get_location(&self) -> SourceLocation {
        self.lexer.get_location()
    }

    fn push_context(&mut self, context: String) {
        self.context_stack.push(context);
    }

    fn pop_context(&mut self) {
        self.context_stack.pop();
    }
    
    fn expect(&mut self, expected: Token) -> CompileResult<()> {
        if std::mem::discriminant(&self.current_token) == std::mem::discriminant(&expected) {
            self.advance();
            Ok(())
        } else {
            let location = self.get_location();
            let expected_str = format!("{:?}", expected);
            let got_str = format!("{:?}", self.current_token);
            let context = self.context_stack.clone();
            Err(CompileError::parser_with_context(
                format!("Expected {}, but found {}", expected_str, got_str),
                location,
                context,
            ))
        }
    }

    fn error(&self, message: String) -> CompileError {
        let location = self.get_location();
        let context = self.context_stack.clone();
        CompileError::parser_with_context(message, location, context)
    }
    
    pub fn parse(&mut self) -> CompileResult<Program> {
        let mut imports: Vec<crate::ast::ImportInfo> = Vec::new();
        let mut statements = Vec::new();
        
        while self.current_token != Token::EOF {
            // Skip newlines between statements
            if matches!(self.current_token, Token::Newline) {
                self.advance();
                continue;
            }
            
            // Handle import: #dhimpu("path") or @alias = #dhimpu("path")
            if matches!(&self.current_token, Token::HashIdentifier(s) if s == "dhimpu") {
                let import_stmt = self.parse_import_dhimpu()?;
                if let Stmt::Import { path, alias } = import_stmt {
                    imports.push(crate::ast::ImportInfo { path, alias });
                }
                continue;
            }
            
            // All other statements (may return Import for @alias = #dhimpu("path"))
            let stmt = self.parse_statement()?;
            if let Stmt::Import { path, alias } = stmt {
                imports.push(crate::ast::ImportInfo { path, alias });
            } else {
                statements.push(stmt);
            }
        }
        
        Ok(Program {
            imports,
            statements,
        })
    }
    
    fn parse_statement(&mut self) -> CompileResult<Stmt> {
        match &self.current_token {
            Token::AtIdentifier(_) | Token::AtMutIdentifier(_) => self.parse_variable_decl(),
            Token::HashIdentifier(name) if name == "dhimpu" => self.parse_import_dhimpu(),
            Token::HashIdentifier(_) => self.parse_function(),
            Token::Okavela => self.parse_if(),
            Token::Malli => self.parse_for(),
            Token::Mallinchu => self.parse_return(),
            Token::Agu => {
                self.advance();
                if matches!(self.current_token, Token::Semicolon) {
                    self.advance();
                }
                Ok(Stmt::Break)
            }
            Token::Konasagu => {
                self.advance();
                if matches!(self.current_token, Token::Semicolon) {
                    self.advance();
                }
                Ok(Stmt::Continue)
            }
            Token::Nirmanam => self.parse_struct_def(),
            Token::LeftBrace => self.parse_block(),
            Token::Identifier(ident) if ident.as_str() == "tlang" => self.parse_spawn(),
            _ => {
                let expr = self.parse_expression()?;
                if matches!(self.current_token, Token::Semicolon) {
                    self.advance();
                }
                Ok(Stmt::Expression(expr))
            }
        }
    }
    
    /// Parse spawn: tlang #name(args)
    fn parse_spawn(&mut self) -> CompileResult<Stmt> {
        self.advance(); // consume tlang
        let name = match &self.current_token {
            Token::HashIdentifier(n) => n.clone(),
            _ => return Err(self.error("Expected function name after 'tlang' (e.g. tlang #name(args))".to_string())),
        };
        self.advance(); // consume #name
        self.expect(Token::LeftParen)?;
        let mut args = Vec::new();
        if !matches!(self.current_token, Token::RightParen) {
            loop {
                args.push(self.parse_expression()?);
                if matches!(self.current_token, Token::Comma) {
                    self.advance();
                } else {
                    break;
                }
            }
        }
        self.expect(Token::RightParen)?;
        if matches!(self.current_token, Token::Semicolon) {
            self.advance();
        }
        Ok(Stmt::Expression(Expr::Spawn { name, args }))
    }
    
    /// Parse a type. When allow_any is true, nirmanam{} is allowed (for map value types only).
    fn parse_type(&mut self, allow_any: bool) -> CompileResult<crate::ast::Type> {
        // Check for nirmanam{} (any type) - only in map value: jatha[string]nirmanam{}
        if matches!(self.current_token, Token::Nirmanam) {
            self.advance(); // Skip nirmanam
            if matches!(self.current_token, Token::LeftBrace) {
                if !allow_any {
                    return Err(self.error("nirmanam{} can only be used in map value type (e.g. jatha[string]nirmanam{})".to_string()));
                }
                self.advance(); // Skip {
                self.expect(Token::RightBrace)?; // Skip }
                return Ok(crate::ast::Type::Any);
            }
            return Err(self.error("Expected {} after nirmanam for any type (e.g. jatha[string]nirmanam{})".to_string()));
        }
        
        // Check for tuple type: (type1, type2, ...)
        if matches!(self.current_token, Token::LeftParen) {
            self.advance(); // Skip (
            let mut types = Vec::new();
            
            // Parse types separated by commas
            while !matches!(self.current_token, Token::RightParen) {
                types.push(self.parse_type(false)?);
                if matches!(self.current_token, Token::Comma) {
                    self.advance(); // Skip comma
                } else if !matches!(self.current_token, Token::RightParen) {
                    return Err(self.error("Expected ',' or ')' in tuple type".to_string()));
                }
            }
            
            self.expect(Token::RightParen)?;
            
            if types.len() == 1 {
                // Single type in parentheses - just return that type (not a tuple)
                return Ok(types.into_iter().next().unwrap());
            }
            
            return Ok(crate::ast::Type::Tuple { types });
        }
        
        // Check for channel type: channel[elementType]
        if matches!(self.current_token, Token::ChannelType) {
            self.advance(); // Skip channel
            self.expect(Token::LeftBracket)?;
            let element_type = Box::new(self.parse_type(false)?);
            self.expect(Token::RightBracket)?;
            return Ok(crate::ast::Type::Channel {
                element_type,
            });
        }
        
        // Check for map type: jatha[keyType]valueType
        if matches!(self.current_token, Token::Jatha) {
            self.advance(); // Skip jatha
            self.expect(Token::LeftBracket)?;
            let key_type = Box::new(self.parse_type(false)?);
            self.expect(Token::RightBracket)?;
            let value_type = Box::new(self.parse_type(true)?); // nirmanam{} allowed as map value type
            return Ok(crate::ast::Type::Map {
                key_type,
                value_type,
            });
        }
        
        // Check for array or slice type ([N]type or []type)
        if matches!(self.current_token, Token::LeftBracket) {
            self.advance(); // Skip [
            
            if matches!(self.current_token, Token::RightBracket) {
                // []type - slice (variable size)
                self.advance(); // Skip ]
                let element_type = Box::new(self.parse_type(false)?);
                return Ok(crate::ast::Type::Slice {
                    element_type,
                });
            } else if let Token::Number(n) = &self.current_token {
                // [N]type - fixed size array
                let size_val = *n as usize;
                self.advance();
                self.expect(Token::RightBracket)?;
                let element_type = Box::new(self.parse_type(false)?);
                return Ok(crate::ast::Type::Array {
                    size: size_val,
                    element_type,
                });
            } else {
                return Err(self.error("Expected array size (number) or ] for slice".to_string()));
            }
        }
        
        // Check for pointer type (*int, *float, etc.)
        if matches!(self.current_token, Token::Multiply) {
            self.advance(); // Skip *
            let base_type = self.parse_type(false)?;
            return Ok(crate::ast::Type::Pointer(Box::new(base_type)));
        }
        
        let typ = match &self.current_token {
            Token::IntType => {
                self.advance();
                crate::ast::Type::Int
            }
            Token::FloatType => {
                self.advance();
                crate::ast::Type::Float
            }
            Token::StringType => {
                self.advance();
                crate::ast::Type::String
            }
            Token::BoolType => {
                self.advance();
                crate::ast::Type::Bool
            }
            Token::ErrorType => {
                self.advance();
                crate::ast::Type::Error
            }
            Token::Identifier(name) => {
                let type_name = name.clone();
                self.advance();
                if type_name == "WaitGroup" {
                    crate::ast::Type::WaitGroup
                } else {
                    // Struct type name
                    crate::ast::Type::Struct {
                        name: type_name,
                    }
                }
            }
            _ => return Err(self.error("Expected type (int, float, string, bool, struct, jatha[key]value, jatha[key]nirmanam{}, *type, or [N]type)".to_string())),
        };
        Ok(typ)
    }
    
    fn parse_variable_decl(&mut self) -> CompileResult<Stmt> {
        self.push_context("while parsing variable declaration".to_string());
        
        let (name, is_mutable) = match &self.current_token {
            Token::AtIdentifier(name) => {
                if name.is_empty() {
                    self.pop_context();
                    return Err(self.error("Expected variable name after '@'".to_string()));
                }
                let n = name.clone();
                self.advance();
                (n, false)
            }
            Token::AtMutIdentifier(name) => {
                if name.is_empty() {
                    self.pop_context();
                    return Err(self.error("Expected variable name after '@!'".to_string()));
                }
                let n = name.clone();
                self.advance();
                (n, true)
            }
            _ => {
                self.pop_context();
                return Err(self.error("Expected @variableName or @!variableName".to_string()));
            }
        };
        
        // Go-style: var x int = 10 or var x = 10
        let type_annot = if matches!(self.current_token, Token::IntType) 
            || matches!(self.current_token, Token::FloatType)
            || matches!(self.current_token, Token::StringType)
            || matches!(self.current_token, Token::BoolType) 
            || matches!(self.current_token, Token::ErrorType)
            || matches!(self.current_token, Token::ChannelType) // Channel
            || matches!(self.current_token, Token::LeftBracket) // Array/Slice
            || matches!(self.current_token, Token::Jatha) // Map
            || matches!(self.current_token, Token::Multiply) // Pointer
            || matches!(self.current_token, Token::LeftParen) // Tuple
            || matches!(self.current_token, Token::Identifier(_)) { // Struct/Type alias
            Some(self.parse_type(false)?)
        } else {
            None
        };
        
        // @alias = #dhimpu("path") → import with alias
        let value = if matches!(self.current_token, Token::Assign) {
            self.advance(); // skip =
            if type_annot.is_none() {
                if matches!(&self.current_token, Token::HashIdentifier(s) if s == "dhimpu") {
                    self.advance(); // skip #dhimpu
                    self.expect(Token::LeftParen)?;
                    let path = match &self.current_token {
                        Token::String(p) => { let x = p.clone(); self.advance(); x }
                        Token::Identifier(p) => { let x = p.clone(); self.advance(); x }
                        _ => {
                            self.pop_context();
                            return Err(self.error("Expected import path string in #dhimpu(\"path\") (e.g. @fmt = #dhimpu(\"fmt\"))".to_string()));
                        }
                    };
                    self.expect(Token::RightParen)?;
                    if matches!(self.current_token, Token::Semicolon) {
                        self.advance();
                    }
                    self.pop_context();
                    return Ok(Stmt::Import { path, alias: Some(name) });
                }
            }
            // Not an import: declare var and parse RHS expression
            self.declare_var(name.clone(), is_mutable)?;
            Some(self.parse_expression()?)
        } else {
            self.declare_var(name.clone(), is_mutable)?;
            None
        };
        
        // Infer type from value if type_annot is None and value is Some
        let final_type_annot = if type_annot.is_none() && value.is_some() {
            // Use type inference
            crate::type_inference::infer_type(value.as_ref().unwrap())
        } else {
            type_annot
        };
        
        if matches!(self.current_token, Token::Semicolon) {
            self.advance();
        }
        
        self.pop_context();
        Ok(Stmt::VariableDecl { name, type_annot: final_type_annot, value, mutable: is_mutable })
    }
    
    fn parse_if(&mut self) -> CompileResult<Stmt> {
        // Handle Okavela
        match &self.current_token {
            Token::Okavela => {
                self.advance();
            }
            _ => {
                return Err(self.error("Expected 'okavela'".to_string()));
            }
        }
        // Go-style: if condition { } - no parentheses required
        let condition = if matches!(self.current_token, Token::LeftParen) {
            self.advance();
            let cond = self.parse_expression()?;
            self.expect(Token::RightParen)?;
            cond
        } else {
            self.parse_expression()?
        };
        
        self.push_scope();  // New scope for then block
        let then_block = self.parse_block_statements()?;
        self.pop_scope();
        
        let else_block = if matches!(self.current_token, Token::Lekapothe) {
            self.advance();
            self.push_scope();  // New scope for else block
            let block = Some(self.parse_block_statements()?);
            self.pop_scope();
            block
        } else {
            None
        };
        
        Ok(Stmt::If {
            condition,
            then_block,
            else_block,
        })
    }
    
    fn parse_for(&mut self) -> CompileResult<Stmt> {
        // Handle Malli
        match &self.current_token {
            Token::Malli => {
                self.advance();
            }
            _ => {
                return Err(self.error("Expected 'malli'".to_string()));
            }
        }
        
        // Infinite loop: malli { ... }
        if matches!(self.current_token, Token::LeftBrace) {
            let body = self.parse_block_statements()?;
            return Ok(Stmt::For {
                init: None,
                condition: None,
                update: None,
                body,
            });
        }
        
        // Check for varasa loop: i, v := varasa ...
        // We use a heuristic: if we see "varasa" within the next few tokens?
        // Since we can't easily peek far, we'll try to parse as statement/expression
        // and if it turns out to be a varasa declaration, we handle it.
        // Actually, let's look for "key, val :=" pattern specifically if we can.
        
        // For now, let's try to parse clauses separated by semicolons.
        // Possible forms:
        // 1. cond { }
        // 2. init; cond { }  (ambiguous with cond; update?)
        // 3. init; cond; update { }
        // 4. range_decl { }
        
        // Skip optional opening paren (support C-style)
        let has_paren = if matches!(self.current_token, Token::LeftParen) {
            self.advance();
            true
        } else {
            false
        };
        
        // Parse first part
        let (part1, init_consumed_semicolon) = if !matches!(self.current_token, Token::Semicolon) && !matches!(self.current_token, Token::LeftBrace) {
            // Check if it's a range loop start
            // identifier [comma identifier] assign varasa
            // This logic inside parse_statement/expression is hard; we might need manual parsing here
            if let Token::Identifier(_id1) = &self.current_token {
                // Peek next could be useful, but let's try to consume
                // If we see Identifier, Comma, Identifier, Assign, Varasa -> Range
                // If we see Identifier, Assign, Varasa -> Range
                
                // Let's rely on standard parsing. If it's a range loop, 
                // the user should probably use proper syntax. 
                // But wait, the parser errored because it entered the Identifier branch solely.
                
                // Let's consume statement.
                let stmt = self.parse_statement()?;
                
                // Check if the statement already consumed a semicolon
                // VariableDecl consumes semicolons, but Assignment and Expression don't always
                let consumed = matches!(
                    stmt,
                    Stmt::VariableDecl { .. }
                );
                
                (Some(stmt), consumed)
            } else {
                let stmt = self.parse_statement()?;
                 let consumed = matches!(
                    stmt,
                    Stmt::VariableDecl { .. }
                );
                (Some(stmt), consumed)
            }
        } else {
            (None, false)
        };
        
        // Check if we have passed the first separator (either init consumed it, or we see one)
        let first_semi_passed = if init_consumed_semicolon {
            true
        } else if matches!(self.current_token, Token::Semicolon) {
            self.advance(); // consume first semicolon
            true
        } else {
            false
        };

        if first_semi_passed {
            // We have at least 2 parts (or 1 part + semi).
            // part1 is init.
            
            // Parse part2 (Condition)
            let part2 = if !matches!(self.current_token, Token::Semicolon) && !matches!(self.current_token, Token::LeftBrace) && !matches!(self.current_token, Token::RightParen) {
                Some(self.parse_expression()?)
            } else {
                None
            };
            
            if matches!(self.current_token, Token::Semicolon) {
                self.advance(); // consume second semicolon
                
                // We have 3 parts: init; cond; update
                let part3 = if !matches!(self.current_token, Token::LeftBrace) && !matches!(self.current_token, Token::RightParen) {
                    // Update part often contains assignment which in Tlang is a Stmt, not Expr (usually).
                    // parse_statement() consumes semicolon. But loop header `) {` has no semicolon after update.
                    // We need to parse assignment *without* semicolon.
                    
                    // Check if it's an assignment: Identifier = Expr
                    if let Token::Identifier(name) = &self.current_token {
                        // Look ahead for assignment
                        let name_str = name.clone();
                        self.advance(); // consume identifier
                        
                        if matches!(self.current_token, Token::Assign) {
                            self.advance(); // consume =
                            let value = self.parse_expression()?;
                            // Create Assignment Stmt
                            Some(Box::new(Stmt::Assignment {
                                name: name_str,
                                value,
                            }))
                        } else {
                            // Backtrack or error?
                            // For simplicity, error if not assignment for now via restart or just expect assignment
                            // Or maybe it was just an identifier expression?
                            // We consumed identifier. Can we wrap it in Expr?
                            // Yes, basic Identifier expr.
                            // But what if it was `i < 5`? Valid as update? No.
                            // `i++`? Token::PlusPlus? if supported.
                            
                            // Let's return error for now to be safe, or assume it's just identifier access (valid expr)
                            return Err(self.error("Expected assignment in loop update".to_string()));
                        }
                    } else {
                        // Could be call: `func()`
                        let expr = self.parse_expression()?;
                        Some(Box::new(Stmt::Expression(expr)))
                    }
                } else {
                    None
                };
                
                if has_paren { self.expect(Token::RightParen)?; }
                let body = self.parse_block_statements()?;
                
                return Ok(Stmt::For {
                    init: part1.map(Box::new),
                    condition: part2,
                    update: part3,
                    body,
                });
            } else {
                // 2 parts: init; cond
                if has_paren { self.expect(Token::RightParen)?; }
                let body = self.parse_block_statements()?;
                
                return Ok(Stmt::For {
                    init: part1.map(Box::new),
                    condition: part2,
                    update: None,
                    body,
                });
            }
        } else {
            // No semicolon found after part1.
            // Check for "varasa" if part1 was an identifier
            // But we already parsed part1 as a full Stmt.
            
            // If part1 is `key, value := varasa iterable`, checking `Stmt` structure is hard.
            // But if it was parsed as ExpressionStmt, we might check the expression?
            
            // Special Case: `array_example.tl` -> `malli i < 5; i = i + 1`.
            // Wait, if I parsed `part1` as `i < 5` (ExprStmt), then I saw `;`.
            // Then I parsed `part2` as `i = i + 1` (Expression).
            // Then `{`.
            // So my logic above would treat it as `init=i<5`, `cond=i=i+1`.
            // `i=i+1` as condition? If assignment returns value (void?), it's weird.
            // Unless Tlang treats assignment as expression evaluating to value (C-style).
            
            if has_paren { self.expect(Token::RightParen)?; }
            let body = self.parse_block_statements()?;
            
            // Single part: `cond`
            // Convert Stmt to parsing condition?
            // If part1 is ExprStmt, extract Expr.
            let condition = if let Some(Stmt::Expression(expr)) = &part1 {
                Some(expr.clone())
            } else {
                // If part1 is not expression (e.g. var decl), it can't be just condition.
                // But `for var x = 1 {}` is not valid.
                // Assuming it's `for condition {}`
                None 
            };
            
            // If part1 was not expr, maybe it was `init` and `cond` is empty?
            // `for init; ; {}` -> infinite with init.
            
            return Ok(Stmt::For {
                init: if condition.is_none() { part1.map(Box::new) } else { None },
                condition,
                update: None,
                body,
            });
        }
    }
    
    fn parse_return(&mut self) -> CompileResult<Stmt> {
        // Handle Mallinchu
        match &self.current_token {
            Token::Mallinchu => {
                self.advance();
            }
            _ => {
                return Err(self.error("Expected 'mallinchu'".to_string()));
            }
        }
        let value = if matches!(self.current_token, Token::Semicolon | Token::Newline | Token::RightBrace | Token::EOF) {
            None
        } else {
            Some(self.parse_expression()?)
        };
        if matches!(self.current_token, Token::Semicolon) {
            self.advance();
        }
        Ok(Stmt::Return(value))
    }
    
    fn parse_function(&mut self) -> CompileResult<Stmt> {
        self.push_context("while parsing function declaration".to_string());
        
        // Handle #functionName syntax
        let (name, is_macro) = match &self.current_token {
            Token::HashIdentifier(name) => {
                if name.is_empty() {
                    self.pop_context();
                    return Err(self.error("Expected function name after '#'".to_string()));
                }
                let n = name.clone();
                self.advance();
                (n, true) // # prefix means it's a macro
            }
            _ => {
                self.pop_context();
                return Err(self.error("Expected #functionName".to_string()));
            }
        };
        
        self.expect(Token::LeftParen)?;
        
        // Go-style: func name(param1 type1, param2 type2) returnType { }
        let mut params = Vec::new();
        while !matches!(self.current_token, Token::RightParen) {
            let param_name = match &self.current_token {
                Token::Identifier(name) => {
                    let n = name.clone();
                    self.advance();
                    n
                }
                _ => {
                    self.pop_context();
                    return Err(self.error("Expected parameter name".to_string()));
                }
            };
            
            let param_type = self.parse_type(false)?;
            params.push((param_name, param_type));
            
            if matches!(self.current_token, Token::Comma) {
                self.advance();
            }
        }
        
        self.expect(Token::RightParen)?;
        
        // Parse return type (optional - None means void)
        // Can be single type or tuple type: (int, error)
        let return_type = if matches!(self.current_token, Token::IntType) 
            || matches!(self.current_token, Token::FloatType)
            || matches!(self.current_token, Token::StringType)
            || matches!(self.current_token, Token::BoolType)
            || matches!(self.current_token, Token::ErrorType)
            || matches!(self.current_token, Token::LeftParen) // Tuple type: (int, error)
            || matches!(self.current_token, Token::Identifier(_)) { // Struct/interface type
            Some(self.parse_type(false)?)
        } else {
            None
        };
        
        // Block scope for function body: variables (and params) are local to this function
        self.push_scope();
        for (param_name, _) in &params {
            self.current_scope().insert(param_name.clone());
            self.mutable_vars.insert(param_name.clone(), false);
        }
        let body = self.parse_block_statements()?;
        self.pop_scope();
        
        self.pop_context();
        Ok(Stmt::Function { name, params, return_type, body, is_macro })
    }
    
    fn parse_import_dhimpu(&mut self) -> CompileResult<Stmt> {
        self.push_context("while parsing #dhimpu (import)".to_string());
        self.advance(); // skip #dhimpu (caller verified HashIdentifier("dhimpu"))
        self.expect(Token::LeftParen)?;
        let path = match &self.current_token {
            Token::String(p) => { let x = p.clone(); self.advance(); x }
            Token::Identifier(p) => { let x = p.clone(); self.advance(); x }
            _ => {
                self.pop_context();
                return Err(self.error("Expected import path string in #dhimpu(\"path\")".to_string()));
            }
        };
        self.expect(Token::RightParen)?;
        if matches!(self.current_token, Token::Semicolon) {
            self.advance();
        }
        self.pop_context();
        Ok(Stmt::Import { path, alias: None })
    }
    
    fn parse_struct_def(&mut self) -> CompileResult<Stmt> {
        self.push_context("while parsing struct definition".to_string());
        self.expect(Token::Nirmanam)?;
        
        let name = match &self.current_token {
            Token::Identifier(name) => {
                let n = name.clone();
                self.advance();
                n
            }
            _ => {
                self.pop_context();
                return Err(self.error("Expected struct name after 'nirmanam'".to_string()));
            }
        };
        
        self.expect(Token::LeftBrace)?;
        
        let mut fields = Vec::new();
        while !matches!(self.current_token, Token::RightBrace) {
            if matches!(self.current_token, Token::Newline) {
                self.advance();
                continue;
            }
            let field_name = match &self.current_token {
                Token::Identifier(name) => {
                    let n = name.clone();
                    self.advance();
                    n
                }
                _ => {
                    self.pop_context();
                    return Err(self.error("Expected field name".to_string()));
                }
            };
            
            let field_type = self.parse_type(false)?;
            
            // Parse optional struct tags: `json:"fieldname" validate:"required"`
            // The lexer reads backtick-delimited content as a String token
            // So we check for String token that might be a tag
            // Actually, we need to check if the next token after type is a backtick
            // For now, let's check if there's a String token that looks like a tag
            let tags = if matches!(self.current_token, Token::String(_)) {
                // Check if this string looks like a tag (contains json: or validate:)
                let potential_tag = match &self.current_token {
                    Token::String(s) => s.clone(),
                    _ => String::new(),
                };
                
                // If it contains tag-like content, treat it as a tag
                if potential_tag.contains("json:") || potential_tag.contains("validate:") {
                    self.advance(); // Consume the tag string
                    Some(potential_tag)
                } else {
                    None
                }
            } else {
                None
            };
            
            fields.push((field_name, field_type, tags));
            
            if matches!(self.current_token, Token::Semicolon) {
                self.advance();
            }
        }
        
        self.expect(Token::RightBrace)?;
        
        if matches!(self.current_token, Token::Semicolon) {
            self.advance();
        }
        
        self.pop_context();
        Ok(Stmt::StructDef { name, fields })
    }
    
    fn parse_block(&mut self) -> CompileResult<Stmt> {
        self.expect(Token::LeftBrace)?;
        self.push_scope();  // New scope for block
        let statements = self.parse_block_statements()?;
        self.pop_scope();  // Pop scope when block ends
        Ok(Stmt::Block(statements))
    }
    
    fn parse_block_statements(&mut self) -> CompileResult<Vec<Stmt>> {
        if matches!(self.current_token, Token::LeftBrace) {
            self.advance();
        }
        
        let mut statements = Vec::new();
        while !matches!(self.current_token, Token::RightBrace) && self.current_token != Token::EOF {
            // Skip newlines between statements
            if matches!(self.current_token, Token::Newline) {
                self.advance();
                continue;
            }
            statements.push(self.parse_statement()?);
        }
        
        if matches!(self.current_token, Token::RightBrace) {
            self.advance();
        }
        
        Ok(statements)
    }
    
    fn parse_expression(&mut self) -> CompileResult<Expr> {
        self.parse_assignment()
    }
    
    fn parse_assignment(&mut self) -> CompileResult<Expr> {
        let expr = self.parse_equality()?;
        
        // Channel send: ch <- value
        if matches!(self.current_token, Token::Jarugu) {
            self.advance(); // consume <-
            let value = self.parse_assignment()?; // RHS (allows nested expressions and assignment)
            return Ok(Expr::ChannelSend {
                channel: Box::new(expr),
                value: Box::new(value),
            });
        }
        
        if matches!(self.current_token, Token::Assign) {
            // Check if this is an assignment to a variable or member access
            match expr {
                Expr::Identifier(name) => {
                    // Check if variable is mutable
                    if !self.is_variable_mutable(&name) {
                        let location = self.get_location();
                        let context = self.context_stack.clone();
                        return Err(CompileError::parser_with_context(
                            format!("Cannot assign to variable '{}': variables are immutable by default. Use '@!{}' to declare a mutable variable, or use a new variable declaration instead.", name, name),
                            location,
                            context,
                        ));
                    }
                    
                    // Variable is mutable - allow assignment
                    self.advance(); // consume '='
                    let value = self.parse_assignment()?; // Parse right-hand side (supports chained assignments)
                    return Ok(Expr::Assignment {
                        name,
                        value: Box::new(value),
                    });
                }
                Expr::MemberAccess { object, field } => {
                    // Allow assignment to struct fields: person.name = value
                    self.advance(); // consume '='
                    let value = self.parse_assignment()?; // Parse right-hand side
                    return Ok(Expr::MemberAssignment {
                        object,
                        field,
                        value: Box::new(value),
                    });
                }
                _ => {
                    return Err(self.error("Left side of assignment must be an identifier or member access".to_string()));
                }
            }
        }
        
        Ok(expr)
    }
    
    fn parse_equality(&mut self) -> CompileResult<Expr> {
        let mut expr = self.parse_comparison()?;
        
        while matches!(self.current_token, Token::Equal) || matches!(self.current_token, Token::NotEqual) {
            let op = match self.current_token {
                Token::Equal => BinaryOperator::Equal,
                Token::NotEqual => BinaryOperator::NotEqual,
                _ => break,
            };
            self.advance();
            let right = self.parse_comparison()?;
            expr = Expr::BinaryOp {
                op,
                left: Box::new(expr),
                right: Box::new(right),
            };
        }
        
        Ok(expr)
    }
    
    fn parse_comparison(&mut self) -> CompileResult<Expr> {
        let mut expr = self.parse_additive()?;
        
        while matches!(self.current_token, Token::LessThan)
            || matches!(self.current_token, Token::GreaterThan)
            || matches!(self.current_token, Token::LessThanEqual)
            || matches!(self.current_token, Token::GreaterThanEqual)
        {
            let op = match self.current_token {
                Token::LessThan => {
                    self.advance();
                    BinaryOperator::LessThan
                }
                Token::GreaterThan => {
                    self.advance();
                    BinaryOperator::GreaterThan
                }
                Token::LessThanEqual => {
                    self.advance();
                    BinaryOperator::LessThanEqual
                }
                Token::GreaterThanEqual => {
                    self.advance();
                    BinaryOperator::GreaterThanEqual
                }
                _ => break,
            };
            let right = self.parse_additive()?;
            expr = Expr::BinaryOp {
                op,
                left: Box::new(expr),
                right: Box::new(right),
            };
        }
        
        Ok(expr)
    }
    
    fn parse_additive(&mut self) -> CompileResult<Expr> {
        let mut expr = self.parse_multiplicative()?;
        
        while matches!(self.current_token, Token::Plus) || matches!(self.current_token, Token::Minus) {
            let op = match self.current_token {
                Token::Plus => {
                    self.advance();
                    BinaryOperator::Add
                }
                Token::Minus => {
                    self.advance();
                    BinaryOperator::Subtract
                }
                _ => break,
            };
            let right = self.parse_multiplicative()?;
            expr = Expr::BinaryOp {
                op,
                left: Box::new(expr),
                right: Box::new(right),
            };
        }
        
        Ok(expr)
    }
    
    fn parse_multiplicative(&mut self) -> CompileResult<Expr> {
        let mut expr = self.parse_unary()?;
        
        while matches!(self.current_token, Token::Multiply)
            || matches!(self.current_token, Token::Divide)
            || matches!(self.current_token, Token::Modulo)
            || matches!(self.current_token, Token::Power)
        {
            let op = match self.current_token {
                Token::Multiply => {
                    self.advance();
                    BinaryOperator::Multiply
                }
                Token::Divide => {
                    self.advance();
                    BinaryOperator::Divide
                }
                Token::Modulo => {
                    self.advance();
                    BinaryOperator::Modulo
                }
                Token::Power => {
                    self.advance();
                    BinaryOperator::Power
                }
                _ => break,
            };
            let right = self.parse_unary()?;
            expr = Expr::BinaryOp {
                op,
                left: Box::new(expr),
                right: Box::new(right),
            };
        }
        
        Ok(expr)
    }
    
    fn parse_unary(&mut self) -> CompileResult<Expr> {
        match self.current_token {
            Token::Minus => {
                self.advance();
                let expr = self.parse_unary()?;
                Ok(Expr::UnaryOp {
                    op: UnaryOperator::Negate,
                    expr: Box::new(expr),
                })
            }
            Token::Ampersand => {
                // Immutable borrow: &expr
                self.advance();
                let expr = self.parse_unary()?;
                Ok(Expr::Borrow {
                    expr: Box::new(expr),
                    mutable: false,
                })
            }
            Token::AmpersandMut => {
                // Mutable borrow: &mut expr
                self.advance();
                let expr = self.parse_unary()?;
                Ok(Expr::Borrow {
                    expr: Box::new(expr),
                    mutable: true,
                })
            }
            Token::Multiply => {
                // Dereference: *expr
                self.advance();
                let expr = self.parse_unary()?;
                Ok(Expr::Deref {
                    expr: Box::new(expr),
                })
            }
            Token::Jarugu => {
                // Channel receive or move: <- expr (value from channel, or move)
                self.advance();
                let expr = self.parse_unary()?;
                Ok(Expr::ChannelRecv {
                    channel: Box::new(expr),
                })
            }
            _ => {
                let primary = self.parse_primary()?;
                let expr = self.parse_postfix(primary)?;
                // Check for error propagation operator (?)
                if matches!(self.current_token, Token::QuestionMark) {
                    self.advance();
                    Ok(Expr::ErrorPropagate {
                        expr: Box::new(expr),
                    })
                } else {
                    Ok(expr)
                }
            }
        }
    }
    
    fn parse_primary(&mut self) -> CompileResult<Expr> {
        // Check for tuple literal: (expr1, expr2, ...)
        if matches!(self.current_token, Token::LeftParen) {
            self.advance(); // Skip (
            let mut elements = Vec::new();
            
            // Parse elements separated by commas
            while !matches!(self.current_token, Token::RightParen) {
                elements.push(self.parse_expression()?);
                if matches!(self.current_token, Token::Comma) {
                    self.advance(); // Skip comma
                } else if !matches!(self.current_token, Token::RightParen) {
                    return Err(self.error("Expected ',' or ')' in tuple literal".to_string()));
                }
            }
            
            self.expect(Token::RightParen)?;
            
            if elements.len() == 1 {
                // Single expression in parentheses - just return that (not a tuple)
                return Ok(elements.into_iter().next().unwrap());
            }
            
            // Multiple elements - tuple literal
            return Ok(Expr::TupleLiteral { elements });
        }
        
        match &self.current_token {
            Token::Number(n) => {
                let value = *n;
                self.advance();
                Ok(Expr::Number(value))
            }
            Token::String(s) => {
                let value = s.clone();
                self.advance();
                Ok(Expr::String(value))
            }
            Token::Sunyam => {
                self.advance();
                // sunyam(expr) = free(expr); plain sunyam = nil value
                if matches!(self.current_token, Token::LeftParen) {
                    self.advance(); // consume (
                    let expr = self.parse_expression()?;
                    self.expect(Token::RightParen)?;
                    Ok(Expr::SunyamFree { expr: Box::new(expr) })
                } else {
                    Ok(Expr::Nil)
                }
            }
            Token::Nirmanam => {
                // nirmanam(Map) only - use Type{} or Type{ field: value } for structs
                self.advance();
                self.expect(Token::LeftParen)?;
                let target_type = self.parse_type(false)?;
                self.expect(Token::RightParen)?;
                match &target_type {
                    crate::ast::Type::Map { .. } => Ok(Expr::Kotha { target_type }),
                    crate::ast::Type::Struct { name } => Err(self.error(format!("Use {} {{}} or {} {{ field: value }} instead of nirmanam({})", name, name, name))),
                    crate::ast::Type::Pointer(inner) => {
                        if let crate::ast::Type::Struct { name } = inner.as_ref() {
                            Err(self.error(format!("Use @var *{} = {} {{}} or {} {{ field: value }} instead of nirmanam({})", name, name, name, name)))
                        } else {
                            Err(self.error("nirmanam() is only for maps: use nirmanam(jatha[key]value)".to_string()))
                        }
                    }
                    _ => Err(self.error("nirmanam() is only for maps: use nirmanam(jatha[key]value)".to_string())),
                }
            }
            Token::Identifier(name) => {
                let qualified_name = name.clone();
                self.advance();
                
                // Handle boolean literals
                if qualified_name == "true" {
                    return Ok(Expr::Bool(true));
                }
                if qualified_name == "false" {
                    return Ok(Expr::Bool(false));
                }
                
                // Handle type conversion: int(x), float(x), string(x), bool(x)
                if matches!(self.current_token, Token::LeftParen) {
                    let target_type = match qualified_name.as_str() {
                        "int" => Some(crate::ast::Type::Int),
                        "float" => Some(crate::ast::Type::Float),
                        "string" => Some(crate::ast::Type::String),
                        "bool" => Some(crate::ast::Type::Bool),
                        _ => None,
                    };
                    
                    if let Some(typ) = target_type {
                        // This is a type conversion, not a function call
                        self.advance(); // Skip (
                        let expr = self.parse_expression()?;
                        self.expect(Token::RightParen)?;
                        return Ok(Expr::TypeCast {
                            target_type: typ,
                            expr: Box::new(expr),
                        });
                    }
                }
                
                // Check for struct literal: Person{field: value, ...}
                if matches!(self.current_token, Token::LeftBrace) {
                    self.advance(); // Skip {
                    let mut fields = Vec::new();
                    
                    if !matches!(self.current_token, Token::RightBrace) {
                        loop {
                            let field_name = match &self.current_token {
                                Token::Identifier(name) => {
                                    let n = name.clone();
                                    self.advance();
                                    n
                                }
                                _ => {
                                    return Err(self.error("Expected field name in struct literal".to_string()));
                                }
                            };
                            
                            self.expect(Token::Colon)?;
                            let field_value = self.parse_expression()?;
                            fields.push((field_name, field_value));
                            
                            if matches!(self.current_token, Token::Comma) {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                    }
                    
                    self.expect(Token::RightBrace)?;
                    return Ok(Expr::StructLiteral {
                        struct_type: qualified_name,
                        fields,
                    });
                }
                
                // nirmanam(Map) only - structs use Type{} or Type{ field: value }
                if qualified_name == "nirmanam" && matches!(self.current_token, Token::LeftParen) {
                    self.advance(); // skip (
                    let target_type = self.parse_type(false)?;
                    self.expect(Token::RightParen)?;
                    match &target_type {
                        crate::ast::Type::Map { .. } => return Ok(Expr::Kotha { target_type }),
                        crate::ast::Type::Struct { name } => {
                            return Err(self.error(format!("Use {} {{}} or {} {{ field: value }} instead of nirmanam({})", name, name, name)));
                        }
                        _ => return Err(self.error("nirmanam() is only for maps: use nirmanam(jatha[key]value)".to_string())),
                    }
                }
                
                // Handle qualified names (e.g., strconv.Atoi) - but stop at dots for member access
                let mut base_expr = Expr::Identifier(qualified_name);
                while matches!(self.current_token, Token::Dot) {
                    self.advance(); // Skip the dot
                    if let Token::Identifier(part) = &self.current_token {
                        let field_name = part.clone();
                        self.advance();
                        
                        // Check if this is a function call (package.function) or member access (struct.field)
                        if matches!(self.current_token, Token::LeftParen) {
                            // It's a function call - reconstruct qualified name
                            let mut fn_name = match &base_expr {
                                Expr::Identifier(id) => id.clone(),
                                Expr::MemberAccess { object: _, field } => field.clone(),
                                _ => return Err(self.error("Invalid function call syntax".to_string())),
                            };
                            fn_name.push_str(".");
                            fn_name.push_str(&field_name);
                            
                            self.advance();
                            let mut args = Vec::new();
                            
                            if !matches!(self.current_token, Token::RightParen) {
                                loop {
                                    args.push(self.parse_expression()?);
                                    if matches!(self.current_token, Token::Comma) {
                                        self.advance();
                                    } else {
                                        break;
                                    }
                                }
                            }
                            
                            self.expect(Token::RightParen)?;
                            return Ok(Expr::FunctionCall { name: fn_name, args });
                        } else {
                            // It's member access
                            base_expr = Expr::MemberAccess {
                                object: Box::new(base_expr),
                                field: field_name,
                            };
                        }
                    } else {
                        return Err(self.error("Expected identifier after '.'".to_string()));
                    }
                }
                
                if matches!(self.current_token, Token::LeftParen) {
                    // Function call on the base expression
                    let fn_name = match &base_expr {
                        Expr::Identifier(id) => id.clone(),
                        _ => return Err(self.error("Cannot call function on non-identifier".to_string())),
                    };
                    self.advance();
                    let mut args = Vec::new();
                    
                    if !matches!(self.current_token, Token::RightParen) {
                        loop {
                            args.push(self.parse_expression()?);
                            if matches!(self.current_token, Token::Comma) {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                    }
                    
                    self.expect(Token::RightParen)?;
                    Ok(Expr::FunctionCall { name: fn_name, args })
                } else {
                    Ok(base_expr)
                }
            }
            Token::LeftParen => {
                self.advance();
                let expr = self.parse_expression()?;
                self.expect(Token::RightParen)?;
                Ok(expr)
            }
            Token::LeftBrace => {
                // Array literal: {1, 2, 3}
                self.advance();
                let mut elements = Vec::new();
                
                if !matches!(self.current_token, Token::RightBrace) {
                    loop {
                        elements.push(self.parse_expression()?);
                        if matches!(self.current_token, Token::Comma) {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                }
                
                self.expect(Token::RightBrace)?;
                Ok(Expr::ArrayLiteral { elements })
            }
            Token::Semicolon | Token::Newline | Token::EOF => {
                // These are statement terminators, not part of expressions
                Err(self.error(format!("Unexpected token: {:?}", self.current_token)))
            }
            _ => Err(self.error(format!("Unexpected token: {:?}", self.current_token))),
        }
    }
    
    fn parse_postfix(&mut self, expr: Expr) -> CompileResult<Expr> {
        let mut expr = expr;
        
        // Handle postfix operators: member access, array/map indexing, slicing
        loop {
            // Member access: obj.field
            if matches!(self.current_token, Token::Dot) {
                self.advance(); // Skip .
                let field_name = match &self.current_token {
                    Token::Identifier(name) => {
                        let n = name.clone();
                        self.advance();
                        n
                    }
                    _ => {
                        return Err(self.error("Expected field name after '.'".to_string()));
                    }
                };
                expr = Expr::MemberAccess {
                    object: Box::new(expr),
                    field: field_name,
                };
                continue;
            }
            
            // Array/map indexing or slicing: arr[0] or map[key] or arr[1:3]
            if matches!(self.current_token, Token::LeftBracket) {
                self.advance(); // Skip [
                
                // Check if this is a slice expression [start:end] or just indexing [index]
                let start = if matches!(self.current_token, Token::Colon) {
                    None // [:] - no start
                } else {
                    let start_expr = self.parse_expression()?;
                    if matches!(self.current_token, Token::Colon) {
                        Some(Box::new(start_expr)) // [start:]
                    } else {
                        // Just an index - could be array or map
                        self.expect(Token::RightBracket)?;
                        // We'll determine if it's array or map based on the type of expr
                        // For now, use ArrayIndex (codegen will handle map vs array)
                        expr = Expr::ArrayIndex {
                            array: Box::new(expr),
                            index: Box::new(start_expr),
                        };
                        continue; // Continue to check for more postfix operations
                    }
                };
                
                // We have a colon, so this is a slice
                if matches!(self.current_token, Token::Colon) {
                    self.advance(); // Skip :
                    let end = if matches!(self.current_token, Token::RightBracket) {
                        None // [start:] or [:]
                    } else {
                        Some(Box::new(self.parse_expression()?)) // [start:end] or [:end]
                    };
                    self.expect(Token::RightBracket)?;
                    expr = Expr::SliceExpr {
                        array: Box::new(expr),
                        start,
                        end,
                    };
                } else {
                    return Err(self.error("Expected ':' for slice or ']' for index".to_string()));
                }
            } else {
                break;
            }
        }
        
        Ok(expr)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ast::{Stmt, Expr, Type};

    fn parse_source(source: &str) -> CompileResult<Program> {
        let lexer = Lexer::new_with_filename(source, "test.tl".to_string());
        let mut parser = Parser::new(lexer);
        parser.parse()
    }

    #[test]
    fn test_parse_empty_program() {
        let program = parse_source("").unwrap();
        assert!(program.imports.is_empty());
        assert!(program.statements.is_empty());
    }

    #[test]
    fn test_parse_prarambham_empty_body() {
        let program = parse_source("#prarambham() { }").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::Function { name, params, return_type, body, is_macro } => {
                assert_eq!(name, "prarambham");
                assert!(params.is_empty());
                assert!(return_type.is_none());
                assert!(body.is_empty());
                assert!(*is_macro);
            }
            _ => panic!("expected Function statement"),
        }
    }

    #[test]
    fn test_parse_variable_decl() {
        let program = parse_source("@x int = 5").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::VariableDecl { name, type_annot, value, mutable } => {
                assert_eq!(name, "x");
                assert_eq!(type_annot.as_ref(), Some(&Type::Int));
                assert!(value.is_some());
                assert!(!*mutable);
            }
            _ => panic!("expected VariableDecl statement"),
        }
    }

    #[test]
    fn test_parse_mutable_variable_decl() {
        let program = parse_source("@!n int = 0").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::VariableDecl { name, mutable, .. } => {
                assert_eq!(name, "n");
                assert!(*mutable);
            }
            _ => panic!("expected VariableDecl statement"),
        }
    }

    #[test]
    fn test_parse_function_with_return_type() {
        let program = parse_source("#add(a int, b int) int { mallinchu a + b }").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::Function { name, params, return_type, body, .. } => {
                assert_eq!(name, "add");
                assert_eq!(params.len(), 2);
                assert_eq!(params[0].0, "a");
                assert_eq!(params[1].0, "b");
                assert!(return_type.as_ref().map(|t| matches!(t, Type::Int)).unwrap_or(false));
                assert_eq!(body.len(), 1);
            }
            _ => panic!("expected Function statement"),
        }
    }

    #[test]
    fn test_parse_if_statement() {
        let program = parse_source("okavela true { @x int = 1 }").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::If { then_block, else_block, .. } => {
                assert_eq!(then_block.len(), 1);
                assert!(else_block.is_none());
            }
            _ => panic!("expected If statement"),
        }
    }

    #[test]
    fn test_parse_return_statement() {
        let program = parse_source("#f() { mallinchu 42 }").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::Function { body, .. } => {
                assert_eq!(body.len(), 1);
                match &body[0] {
                    Stmt::Return(Some(expr)) => {
                        assert!(matches!(expr, Expr::Number(n) if *n == 42.0));
                    }
                    _ => panic!("expected Return(Some(Expr))"),
                }
            }
            _ => panic!("expected Function statement"),
        }
    }

    #[test]
    fn test_parse_break_continue() {
        let program = parse_source("malli { agu konasagu }").unwrap();
        assert_eq!(program.statements.len(), 1);
        match &program.statements[0] {
            Stmt::For { body, .. } => {
                assert_eq!(body.len(), 2);
                assert!(matches!(&body[0], Stmt::Break));
                assert!(matches!(&body[1], Stmt::Continue));
            }
            _ => panic!("expected For statement"),
        }
    }

    #[test]
    fn test_parse_rejects_duplicate_variable_in_scope() {
        let result = parse_source("@x int = 1\n@x int = 2");
        assert!(result.is_err());
    }
}
