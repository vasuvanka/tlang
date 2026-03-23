//! Type checker: validates types of expressions and statements, emits clear type errors.
//! Runs after parsing; uses context-aware type inference (symbol table) for identifiers.

use crate::ast::*;
use crate::error::{CompileError, CompileResult, SourceLocation};
use crate::type_inference::infer_type_with_context;
use std::collections::HashMap;

/// Human-readable type name for error messages.
pub fn type_display(t: &Type) -> String {
    match t {
        Type::Int => "int".to_string(),
        Type::Float => "float".to_string(),
        Type::String => "string".to_string(),
        Type::Bool => "bool".to_string(),
        Type::Void => "void".to_string(),
        Type::Error => "error".to_string(),
        Type::Pointer(inner) => format!("*{}", type_display(inner)),
        Type::Reference { inner, .. } => format!("&{}", type_display(inner)),
        Type::Array { size, element_type } => format!("[{}]{}", size, type_display(element_type)),
        Type::Slice { element_type } => format!("slice of {}", type_display(element_type)),
        Type::Struct { name } => name.clone(),
        Type::Map { key_type, value_type } => {
            format!("map[{}]{}", type_display(key_type), type_display(value_type))
        }
        Type::Any => "any".to_string(),
        Type::Tuple { types } => {
            let inner: Vec<String> = types.iter().map(type_display).collect();
            format!("({})", inner.join(", "))
        }
        Type::Owned { inner, .. } => type_display(inner),
        Type::Channel { element_type } => format!("channel[{}]", type_display(element_type)),
        Type::WaitGroup => "WaitGroup".to_string(),
    }
}

/// Whether a value of type `got` can be assigned to a variable of type `expected`.
fn is_assignable(expected: &Type, got: &Type) -> bool {
    if expected == got {
        return true;
    }
    if matches!(expected, Type::Any) || matches!(got, Type::Any) {
        return true;
    }
    // int can be used where float is expected (promotion)
    if matches!(expected, Type::Float) && matches!(got, Type::Int) {
        return true;
    }
    false
}

fn type_error(message: impl Into<String>, filename: &str) -> CompileError {
    CompileError::type_error(message.into(), SourceLocation::new(0, 0, filename.to_string()))
}

pub struct TypeChecker {
    filename: String,
    /// Stack of scopes (innermost last). Each scope is name -> type.
    scopes: Vec<HashMap<String, Type>>,
    /// Current function's return type when checking a function body.
    current_return_type: Option<Type>,
}

impl TypeChecker {
    pub fn new(filename: impl Into<String>) -> Self {
        TypeChecker {
            filename: filename.into(),
            scopes: vec![HashMap::new()],
            current_return_type: None,
        }
    }

    fn scope(&self) -> &HashMap<String, Type> {
        self.scopes.last().unwrap()
    }

    fn scope_mut(&mut self) -> &mut HashMap<String, Type> {
        self.scopes.last_mut().unwrap()
    }

    fn push_scope(&mut self) {
        self.scopes.push(HashMap::new());
    }

    fn pop_scope(&mut self) {
        self.scopes.pop();
    }

    fn insert(&mut self, name: String, typ: Type) {
        self.scope_mut().insert(name, typ);
    }

    fn get(&self, name: &str) -> Option<Type> {
        for scope in self.scopes.iter().rev() {
            if let Some(t) = scope.get(name) {
                return Some(t.clone());
            }
        }
        None
    }

    /// Run type checking on the whole program. Returns the first type error if any.
    pub fn check_program(&mut self, program: &Program) -> CompileResult<()> {
        for stmt in &program.statements {
            self.check_statement(stmt)?;
        }
        Ok(())
    }

    fn check_statement(&mut self, stmt: &Stmt) -> CompileResult<()> {
        match stmt {
            Stmt::Expression(expr) => {
                self.check_expression(expr)?;
            }
            Stmt::VariableDecl {
                name,
                type_annot,
                value,
                ..
            } => {
                let typ = if let Some(annot) = type_annot {
                    annot.clone()
                } else if let Some(val) = value {
                    infer_type_with_context(val, self.scope())
                        .ok_or_else(|| {
                            type_error(
                                format!("cannot infer type for variable '{}'; add an explicit type", name),
                                &self.filename,
                            )
                        })?
                } else {
                    return Err(type_error(
                        format!("variable '{}' has no type and no initial value", name),
                        &self.filename,
                    ));
                };
                if let Some(val) = value {
                    let val_type = infer_type_with_context(val, self.scope())
                        .ok_or_else(|| {
                            type_error(
                                format!("cannot infer type of initial value for '{}'", name),
                                &self.filename,
                            )
                        })?;
                    if !is_assignable(&typ, &val_type) {
                        return Err(type_error(
                            format!(
                                "variable '{}' has type {} but initial value has type {}",
                                name,
                                type_display(&typ),
                                type_display(&val_type),
                            ),
                            &self.filename,
                        ));
                    }
                }
                self.insert(name.clone(), typ);
            }
            Stmt::Assignment { name, value } => {
                let expected = self.get(name).ok_or_else(|| {
                    type_error(
                        format!("undefined variable '{}'", name),
                        &self.filename,
                    )
                })?;
                let got = infer_type_with_context(value, self.scope()).ok_or_else(|| {
                    type_error(
                        format!("cannot infer type of right-hand side of assignment to '{}'", name),
                        &self.filename,
                    )
                })?;
                if !is_assignable(&expected, &got) {
                    return Err(type_error(
                        format!(
                            "cannot assign {} to '{}' (type {}); expected {}",
                            type_display(&got),
                            name,
                            type_display(&expected),
                            type_display(&expected),
                        ),
                        &self.filename,
                    ));
                }
                self.check_expression(value)?;
            }
            Stmt::MultiAssignment { names, value } => {
                let value_type = infer_type_with_context(value, self.scope()).ok_or_else(|| {
                    type_error("cannot infer type of multi-assignment value", &self.filename)
                })?;
                if let Type::Tuple { types } = &value_type {
                    if types.len() != names.len() {
                        return Err(type_error(
                            format!(
                                "multi-assignment: {} variables but value has {} elements",
                                names.len(),
                                types.len(),
                            ),
                            &self.filename,
                        ));
                    }
                    for (n, t) in names.iter().zip(types.iter()) {
                        if let Some(expected) = self.get(n) {
                            if !is_assignable(&expected, t) {
                                return Err(type_error(
                                    format!(
                                        "cannot assign {} to '{}' (type {})",
                                        type_display(t),
                                        n,
                                        type_display(&expected),
                                    ),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                } else {
                    return Err(type_error(
                        format!(
                            "multi-assignment requires a tuple value, got {}",
                            type_display(&value_type),
                        ),
                        &self.filename,
                    ));
                }
                self.check_expression(value)?;
            }
            Stmt::If {
                condition,
                then_block,
                else_block,
            } => {
                self.check_expression(condition)?;
                let cond_type = infer_type_with_context(condition, self.scope()).ok_or_else(|| {
                    type_error("cannot infer type of condition", &self.filename)
                })?;
                if cond_type != Type::Bool {
                    return Err(type_error(
                        format!(
                            "if condition must be bool, got {}",
                            type_display(&cond_type),
                        ),
                        &self.filename,
                    ));
                }
                self.push_scope();
                for s in then_block {
                    self.check_statement(s)?;
                }
                self.pop_scope();
                if let Some(else_block) = else_block {
                    self.push_scope();
                    for s in else_block {
                        self.check_statement(s)?;
                    }
                    self.pop_scope();
                }
            }
            Stmt::For {
                init,
                condition,
                update,
                body,
            } => {
                if let Some(init) = init {
                    self.check_statement(init)?;
                }
                if let Some(cond) = condition {
                    self.check_expression(cond)?;
                    let ct = infer_type_with_context(cond, self.scope()).ok_or_else(|| {
                        type_error("cannot infer type of for condition", &self.filename)
                    })?;
                    if ct != Type::Bool {
                        return Err(type_error(
                            format!("for condition must be bool, got {}", type_display(&ct)),
                            &self.filename,
                        ));
                    }
                }
                self.push_scope();
                for s in body {
                    self.check_statement(s)?;
                }
                if let Some(up) = update {
                    self.check_statement(up)?;
                }
                self.pop_scope();
            }
            Stmt::ForRange {
                iterable,
                body,
                ..
            } => {
                self.check_expression(iterable)?;
                let _iter_type = infer_type_with_context(iterable, self.scope()); // map/slice/array
                self.push_scope();
                for s in body {
                    self.check_statement(s)?;
                }
                self.pop_scope();
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    self.check_expression(e)?;
                    let got = infer_type_with_context(e, self.scope()).ok_or_else(|| {
                        type_error("cannot infer return expression type", &self.filename)
                    })?;
                    if let Some(ref expected) = self.current_return_type {
                        if !is_assignable(expected, &got) {
                            return Err(type_error(
                                format!(
                                    "return type mismatch: expected {}, got {}",
                                    type_display(expected),
                                    type_display(&got),
                                ),
                                &self.filename,
                            ));
                        }
                    }
                } else if self.current_return_type.as_ref().map_or(false, |t| *t != Type::Void) {
                    return Err(type_error(
                        "function returns a value but return statement has no expression",
                        &self.filename,
                    ));
                }
            }
            Stmt::Break | Stmt::Continue => {}
            Stmt::Function {
                name: _,
                params,
                return_type,
                body,
                ..
            } => {
                self.push_scope();
                for (pname, ptype) in params {
                    self.insert(pname.clone(), ptype.clone());
                }
                let old_return = self.current_return_type.clone();
                self.current_return_type = return_type.clone().or(Some(Type::Void));
                for s in body {
                    self.check_statement(s)?;
                }
                self.current_return_type = old_return;
                self.pop_scope();
            }
            Stmt::Block(statements) => {
                self.push_scope();
                for s in statements {
                    self.check_statement(s)?;
                }
                self.pop_scope();
            }
            Stmt::Import { .. } | Stmt::StructDef { .. } => {}
        }
        Ok(())
    }

    fn check_expression(&mut self, expr: &Expr) -> CompileResult<()> {
        match expr {
            Expr::BinaryOp { op, left, right } => {
                self.check_expression(left)?;
                self.check_expression(right)?;
                let left_t = infer_type_with_context(left, self.scope());
                let right_t = infer_type_with_context(right, self.scope());
                use crate::ast::BinaryOperator::*;
                match op {
                    Add | Subtract | Multiply | Divide | Modulo | Power => {
                        let (l, r) = (left_t, right_t);
                        if let (Some(lt), Some(rt)) = (l, r) {
                            let numeric = matches!(lt, Type::Int | Type::Float)
                                && matches!(rt, Type::Int | Type::Float);
                            if !numeric {
                                return Err(type_error(
                                    format!(
                                        "arithmetic operator requires numeric types, got {} and {}",
                                        type_display(&lt),
                                        type_display(&rt),
                                    ),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                    Equal | NotEqual | LessThan | GreaterThan | LessThanEqual | GreaterThanEqual => {
                        let (l, r) = (left_t, right_t);
                        if let (Some(lt), Some(rt)) = (l, r) {
                            if !is_assignable(&lt, &rt) && !is_assignable(&rt, &lt) {
                                return Err(type_error(
                                    format!(
                                        "comparison requires compatible types, got {} and {}",
                                        type_display(&lt),
                                        type_display(&rt),
                                    ),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                    And | Or => {
                        if let (Some(lt), Some(rt)) = (left_t, right_t) {
                            if lt != Type::Bool || rt != Type::Bool {
                                return Err(type_error(
                                    format!(
                                        "logical operator requires bool, got {} and {}",
                                        type_display(&lt),
                                        type_display(&rt),
                                    ),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                }
            }
            Expr::UnaryOp { op, expr } => {
                self.check_expression(expr)?;
                let t = infer_type_with_context(expr, self.scope());
                use crate::ast::UnaryOperator::*;
                match op {
                    Negate => {
                        if let Some(typ) = t {
                            if !matches!(typ, Type::Int | Type::Float) {
                                return Err(type_error(
                                    format!("unary '-' requires numeric type, got {}", type_display(&typ)),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                    Not => {
                        if let Some(typ) = t {
                            if typ != Type::Bool {
                                return Err(type_error(
                                    format!("unary '!' requires bool, got {}", type_display(&typ)),
                                    &self.filename,
                                ));
                            }
                        }
                    }
                }
            }
            Expr::Assignment { value, .. }
            | Expr::MemberAssignment { value, .. }
            | Expr::TypeCast { expr: value, .. }
            | Expr::Borrow { expr: value, .. }
            | Expr::Deref { expr: value }
            | Expr::ErrorCheck { expr: value }
            | Expr::ErrorPropagate { expr: value }
            | Expr::SunyamFree { expr: value } => {
                self.check_expression(value)?;
            }
            Expr::FunctionCall { args, .. } => {
                for arg in args {
                    self.check_expression(arg)?;
                }
            }
            Expr::ArrayIndex { array, index } => {
                self.check_expression(array)?;
                self.check_expression(index)?;
                let idx_t = infer_type_with_context(index, self.scope());
                if let Some(t) = idx_t {
                    if t != Type::Int {
                        return Err(type_error(
                            format!("array index must be int, got {}", type_display(&t)),
                            &self.filename,
                        ));
                    }
                }
            }
            Expr::ArrayLiteral { elements } => {
                for e in elements {
                    self.check_expression(e)?;
                }
            }
            Expr::SliceExpr { array, start, end } => {
                self.check_expression(array)?;
                if let Some(s) = start {
                    self.check_expression(s)?;
                }
                if let Some(e) = end {
                    self.check_expression(e)?;
                }
            }
            Expr::MemberAccess { object, .. } => {
                self.check_expression(object)?;
            }
            Expr::MapIndex { map, key } => {
                self.check_expression(map)?;
                self.check_expression(key)?;
            }
            Expr::StructLiteral { fields, .. } => {
                for (_, e) in fields {
                    self.check_expression(e)?;
                }
            }
            Expr::MapLiteral { entries, .. } => {
                for (k, v) in entries {
                    self.check_expression(k)?;
                    self.check_expression(v)?;
                }
            }
            Expr::TupleLiteral { elements } => {
                for e in elements {
                    self.check_expression(e)?;
                }
            }
            Expr::ChannelSend { channel, value } => {
                self.check_expression(channel)?;
                self.check_expression(value)?;
            }
            Expr::ChannelRecv { channel } => {
                self.check_expression(channel)?;
            }
            Expr::Spawn { args, .. } => {
                for a in args {
                    self.check_expression(a)?;
                }
            }
            Expr::Number(_)
            | Expr::String(_)
            | Expr::Bool(_)
            | Expr::Nil
            | Expr::Identifier(_)
            | Expr::Kotha { .. } => {}
        }
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ast::{Program, Type};
    use crate::lexer::Lexer;
    use crate::parser::Parser;

    fn parse_program(source: &str) -> Program {
        let lexer = Lexer::new_with_filename(source, "test.tl".to_string());
        let mut parser = Parser::new(lexer);
        parser.parse().expect("parse should succeed")
    }

    #[test]
    fn test_check_valid_program() {
        let program = parse_program(
            r#"
            @x int = 1;
            @y int = 2;
            @z int = x + y;
            "#,
        );
        let mut checker = TypeChecker::new("test.tl");
        assert!(checker.check_program(&program).is_ok());
    }

    #[test]
    fn test_check_rejects_invalid_programs() {
        // bool + int is invalid (arithmetic requires numeric types)
        let program = parse_program("@b bool = true; @x int = b + 1;");
        let mut checker = TypeChecker::new("test.tl");
        let r = checker.check_program(&program);
        assert!(r.is_err(), "expected type error for bool + int");
    }

    #[test]
    fn test_type_display() {
        assert_eq!(type_display(&Type::Int), "int");
        assert_eq!(type_display(&Type::Float), "float");
        assert_eq!(type_display(&Type::Bool), "bool");
        assert_eq!(type_display(&Type::String), "string");
    }
}
