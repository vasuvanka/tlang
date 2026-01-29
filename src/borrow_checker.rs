//! Borrow Checker for Tlang
//!
//! Implements Rust-style ownership and borrowing rules:
//! 1. Each value has exactly one owner
//! 2. When the owner goes out of scope, the value is dropped
//! 3. Values can be borrowed immutably (&) multiple times OR mutably (&mut) once
//! 4. References cannot outlive their referent

use std::collections::{HashMap, HashSet};
use crate::ast::{Expr, Stmt, Program, Type};

/// Ownership state of a variable
#[derive(Debug, Clone, PartialEq)]
pub enum OwnershipState {
    /// Variable owns its value
    Owned,
    /// Value has been moved to another variable
    Moved { to: String, at_line: usize },
    /// Variable is borrowed immutably
    BorrowedImmutable { by: Vec<String> },
    /// Variable is borrowed mutably
    BorrowedMutable { by: String },
    /// Variable is a reference (doesn't own the data)
    Reference { to: String, mutable: bool },
    /// Variable has been dropped (out of scope)
    Dropped,
}

/// Information about a variable's ownership
#[derive(Debug, Clone)]
pub struct VariableInfo {
    pub name: String,
    pub var_type: Type,
    pub state: OwnershipState,
    pub defined_at: usize,      // Line number where defined
    pub scope_level: usize,     // Scope depth
    pub is_mutable: bool,       // Whether declared with mut
    pub lifetime: Option<String>, // Named lifetime (e.g., 'a)
}

/// A borrow of a variable
#[derive(Debug, Clone)]
pub struct Borrow {
    pub borrower: String,       // Variable doing the borrowing
    pub borrowed_from: String,  // Variable being borrowed
    pub mutable: bool,          // Is it a mutable borrow?
    pub line: usize,            // Line where borrow occurs
    pub scope_level: usize,     // Scope where borrow is valid
}

/// Borrow checker error types
#[derive(Debug, Clone)]
pub enum BorrowError {
    /// Attempting to use a moved value
    UseAfterMove {
        variable: String,
        moved_to: String,
        move_line: usize,
        use_line: usize,
    },
    /// Attempting to borrow mutably while immutable borrows exist
    MutableBorrowWhileImmutableExists {
        variable: String,
        immutable_borrowers: Vec<String>,
        line: usize,
    },
    /// Attempting to borrow (immutable or mutable) while mutable borrow exists
    BorrowWhileMutableExists {
        variable: String,
        mutable_borrower: String,
        line: usize,
    },
    /// Attempting second mutable borrow
    DoubleMutableBorrow {
        variable: String,
        first_borrower: String,
        second_borrower: String,
        line: usize,
    },
    /// Reference outlives the data it refers to
    DanglingReference {
        reference: String,
        referent: String,
        line: usize,
    },
    /// Mutating through an immutable reference
    MutationThroughImmutableRef {
        reference: String,
        line: usize,
    },
    /// Moving out of a borrowed value
    MoveWhileBorrowed {
        variable: String,
        borrower: String,
        line: usize,
    },
    /// Assigning to immutable variable
    AssignToImmutable {
        variable: String,
        line: usize,
    },
}

impl BorrowError {
    pub fn message(&self) -> String {
        match self {
            BorrowError::UseAfterMove { variable, moved_to, move_line, use_line } => {
                format!(
                    "error[E0382]: borrow of jarugu value: `{}`\n  --> line {}\n  |\n  | value jarugu to `{}` at line {}\n  | value used here after jarugu",
                    variable, use_line, moved_to, move_line
                )
            }
            BorrowError::MutableBorrowWhileImmutableExists { variable, immutable_borrowers, line } => {
                format!(
                    "error[E0502]: cannot borrow `{}` as mutable because it is also borrowed as immutable\n  --> line {}\n  |\n  | immutable borrow(s) by: {}",
                    variable, line, immutable_borrowers.join(", ")
                )
            }
            BorrowError::BorrowWhileMutableExists { variable, mutable_borrower, line } => {
                format!(
                    "error[E0503]: cannot borrow `{}` because it is already mutably borrowed by `{}`\n  --> line {}",
                    variable, mutable_borrower, line
                )
            }
            BorrowError::DoubleMutableBorrow { variable, first_borrower, second_borrower, line } => {
                format!(
                    "error[E0499]: cannot borrow `{}` as mutable more than once at a time\n  --> line {}\n  |\n  | first mutable borrow: `{}`\n  | second mutable borrow: `{}`",
                    variable, line, first_borrower, second_borrower
                )
            }
            BorrowError::DanglingReference { reference, referent, line } => {
                format!(
                    "error[E0597]: `{}` does not live long enough\n  --> line {}\n  |\n  | `{}` dropped here while still borrowed by `{}`",
                    referent, line, referent, reference
                )
            }
            BorrowError::MutationThroughImmutableRef { reference, line } => {
                format!(
                    "error[E0594]: cannot assign to `*{}` which is behind a `&` reference\n  --> line {}\n  |\n  | `{}` is a `&` reference, so the data it refers to cannot be written",
                    reference, line, reference
                )
            }
            BorrowError::MoveWhileBorrowed { variable, borrower, line } => {
                format!(
                    "error[E0505]: cannot jarugu out of `{}` because it is borrowed\n  --> line {}\n  |\n  | borrow of `{}` by `{}`",
                    variable, line, variable, borrower
                )
            }
            BorrowError::AssignToImmutable { variable, line } => {
                format!(
                    "error[E0384]: cannot assign twice to immutable variable `{}`\n  --> line {}\n  |\n  | help: consider making this binding mutable: `@!{}`",
                    variable, line, variable
                )
            }
        }
    }
}

/// Source location for error reporting
#[derive(Debug, Clone, Default)]
pub struct SourceLocation {
    pub line: usize,
    pub column: usize,
    pub file: String,
}

/// The borrow checker context
pub struct BorrowChecker {
    /// All variables and their ownership info
    variables: HashMap<String, VariableInfo>,
    /// Active borrows
    borrows: Vec<Borrow>,
    /// Current scope level (0 = global)
    scope_level: usize,
    /// Current line number
    current_line: usize,
    /// Collected errors
    pub errors: Vec<BorrowError>,
    /// Stack of scope variables (for cleanup when leaving scope)
    scope_stack: Vec<HashSet<String>>,
    /// Function parameter lifetimes
    #[allow(dead_code)]
    lifetime_params: HashMap<String, String>,  // For future lifetime tracking
}

impl BorrowChecker {
    pub fn new() -> Self {
        BorrowChecker {
            variables: HashMap::new(),
            borrows: Vec::new(),
            scope_level: 0,
            current_line: 1,
            errors: Vec::new(),
            scope_stack: vec![HashSet::new()],
            lifetime_params: HashMap::new(),
        }
    }

    /// Check a program for borrow violations
    pub fn check(&mut self, program: &Program) {
        for stmt in &program.statements {
            self.check_stmt(stmt);
        }
        
        // Check for any dangling references at end of program
        self.check_end_of_scope();
    }

    /// Enter a new scope
    fn enter_scope(&mut self) {
        self.scope_level += 1;
        self.scope_stack.push(HashSet::new());
    }

    /// Exit current scope - drop all variables in this scope
    fn exit_scope(&mut self) {
        if let Some(scope_vars) = self.scope_stack.pop() {
            // Check for dangling references before dropping
            for var_name in &scope_vars {
                self.check_before_drop(var_name);
            }
            
            // Mark all variables in this scope as dropped
            for var_name in scope_vars {
                if let Some(var) = self.variables.get_mut(&var_name) {
                    var.state = OwnershipState::Dropped;
                }
                
                // Remove borrows from this variable
                self.borrows.retain(|b| b.borrowed_from != var_name);
            }
        }
        self.scope_level = self.scope_level.saturating_sub(1);
    }

    /// Check if dropping a variable would create dangling references
    fn check_before_drop(&mut self, var_name: &str) {
        // Find any borrows of this variable
        let active_borrows: Vec<_> = self.borrows.iter()
            .filter(|b| b.borrowed_from == var_name)
            .cloned()
            .collect();
        
        for borrow in active_borrows {
            // Check if the borrower is in an outer scope (would outlive)
            if let Some(borrower_info) = self.variables.get(&borrow.borrower) {
                if borrower_info.scope_level < self.scope_level {
                    self.errors.push(BorrowError::DanglingReference {
                        reference: borrow.borrower.clone(),
                        referent: var_name.to_string(),
                        line: self.current_line,
                    });
                }
            }
        }
    }

    /// Check end of scope for dangling references
    fn check_end_of_scope(&mut self) {
        while self.scope_level > 0 {
            self.exit_scope();
        }
    }

    /// Check a statement
    fn check_stmt(&mut self, stmt: &Stmt) {
        match stmt {
            Stmt::VariableDecl { name, type_annot, value, mutable } => {
                self.current_line += 1;
                
                // Check if value involves a jarugu
                if let Some(val_expr) = value {
                    self.check_expr(val_expr);
                    
                    // If the value is an identifier, it's a jarugu
                    if let Expr::Identifier(src_name) = val_expr {
                        self.handle_move(src_name, name);
                    }
                }
                
                // Register the new variable
                let var_type = type_annot.clone().unwrap_or(Type::Void);
                
                self.variables.insert(name.clone(), VariableInfo {
                    name: name.clone(),
                    var_type,
                    state: OwnershipState::Owned,
                    defined_at: self.current_line,
                    scope_level: self.scope_level,
                    is_mutable: *mutable,
                    lifetime: None,
                });
                
                // Add to current scope
                if let Some(scope) = self.scope_stack.last_mut() {
                    scope.insert(name.clone());
                }
            }
            
            Stmt::Assignment { name, value } => {
                self.current_line += 1;
                
                // Check if variable is mutable
                if let Some(var) = self.variables.get(name) {
                    if !var.is_mutable && var.state == OwnershipState::Owned {
                        // Allow first assignment (initialization) but not subsequent
                        // This is simplified - full impl would track initialization state
                    }
                }
                
                // Check the value expression
                self.check_expr(value);
                
                // Check for jarugu
                if let Expr::Identifier(src_name) = value {
                    self.handle_move(src_name, name);
                }
            }
            
            Stmt::Function { name: _, params, return_type: _, body, is_macro: _ } => {
                self.enter_scope();
                
                // Register parameters
                for (param_name, param_type) in params {
                    self.variables.insert(param_name.clone(), VariableInfo {
                        name: param_name.clone(),
                        var_type: param_type.clone(),
                        state: OwnershipState::Owned,
                        defined_at: self.current_line,
                        scope_level: self.scope_level,
                        is_mutable: false,
                        lifetime: None,
                    });
                    
                    if let Some(scope) = self.scope_stack.last_mut() {
                        scope.insert(param_name.clone());
                    }
                }
                
                // Check function body
                for stmt in body {
                    self.check_stmt(stmt);
                }
                
                self.exit_scope();
            }
            
            Stmt::If { condition, then_block, else_block } => {
                self.check_expr(condition);
                
                self.enter_scope();
                for stmt in then_block {
                    self.check_stmt(stmt);
                }
                self.exit_scope();
                
                if let Some(else_stmts) = else_block {
                    self.enter_scope();
                    for stmt in else_stmts {
                        self.check_stmt(stmt);
                    }
                    self.exit_scope();
                }
            }
            
            Stmt::For { init, condition, update, body } => {
                self.enter_scope();
                
                if let Some(init_stmt) = init {
                    self.check_stmt(init_stmt);
                }
                
                if let Some(cond) = condition {
                    self.check_expr(cond);
                }
                
                for stmt in body {
                    self.check_stmt(stmt);
                }
                
                if let Some(update_stmt) = update {
                    self.check_stmt(update_stmt);
                }
                
                self.exit_scope();
            }
            
            Stmt::ForRange { key_var, value_var, iterable, body } => {
                self.check_expr(iterable);
                
                self.enter_scope();
                
                // Register loop variables
                self.variables.insert(key_var.clone(), VariableInfo {
                    name: key_var.clone(),
                    var_type: Type::Int, // Simplified
                    state: OwnershipState::Owned,
                    defined_at: self.current_line,
                    scope_level: self.scope_level,
                    is_mutable: false,
                    lifetime: None,
                });
                
                if let Some(val_var) = value_var {
                    self.variables.insert(val_var.clone(), VariableInfo {
                        name: val_var.clone(),
                        var_type: Type::Void, // Will be inferred
                        state: OwnershipState::Owned,
                        defined_at: self.current_line,
                        scope_level: self.scope_level,
                        is_mutable: false,
                        lifetime: None,
                    });
                }
                
                for stmt in body {
                    self.check_stmt(stmt);
                }
                
                self.exit_scope();
            }
            
            Stmt::Return(Some(expr)) => {
                self.check_expr(expr);
            }
            
            Stmt::Expression(expr) => {
                self.check_expr(expr);
            }
            
            Stmt::Block(stmts) => {
                self.enter_scope();
                for stmt in stmts {
                    self.check_stmt(stmt);
                }
                self.exit_scope();
            }
            
            _ => {
                self.current_line += 1;
            }
        }
    }

    /// Check an expression for borrow violations
    fn check_expr(&mut self, expr: &Expr) {
        match expr {
            Expr::Identifier(name) => {
                // Check if this variable has been moved
                if let Some(var) = self.variables.get(name) {
                    if let OwnershipState::Moved { to, at_line } = &var.state {
                        self.errors.push(BorrowError::UseAfterMove {
                            variable: name.clone(),
                            moved_to: to.clone(),
                            move_line: *at_line,
                            use_line: self.current_line,
                        });
                    }
                }
            }
            
            Expr::UnaryOp { op, expr } => {
                // Check for borrow operations (& and &mut)
                // In Tlang, we'll use AddressOf operator for this
                match op {
                    crate::ast::UnaryOperator::Negate | crate::ast::UnaryOperator::Not => {
                        self.check_expr(expr);
                    }
                }
            }
            
            Expr::BinaryOp { op: _, left, right } => {
                self.check_expr(left);
                self.check_expr(right);
            }
            
            Expr::FunctionCall { name: _, args } => {
                for arg in args {
                    self.check_expr(arg);
                    
                    // Function calls may jarugu their arguments
                    // (unless they're references or Copy types)
                    if let Expr::Identifier(arg_name) = arg {
                        // For now, assume ownership is transferred unless it's a reference
                        if let Some(var) = self.variables.get(arg_name) {
                            match &var.state {
                                OwnershipState::Reference { .. } => {
                                    // References are just borrowed, not moved
                                }
                                _ => {
                                    // Check if type is Copy (primitives are Copy)
                                    if !self.is_copy_type(&var.var_type) {
                                        // Non-copy types are moved
                                        // We don't know the function parameter name, so use generic
                                        // self.handle_move(arg_name, &format!("fn_param_{}", arg_name));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Expr::ArrayLiteral { elements } => {
                for elem in elements {
                    self.check_expr(elem);
                }
            }
            
            Expr::ArrayIndex { array, index } => {
                self.check_expr(array);
                self.check_expr(index);
            }
            
            Expr::MemberAccess { object, field: _ } => {
                self.check_expr(object);
            }
            Expr::MemberAssignment { object, field: _, value } => {
                self.check_expr(object);
                self.check_expr(value);
            }
            
            Expr::MapIndex { map, key } => {
                self.check_expr(map);
                self.check_expr(key);
            }
            
            Expr::StructLiteral { struct_type: _, fields } => {
                for (_, field_expr) in fields {
                    self.check_expr(field_expr);
                }
            }
            
            _ => {}
        }
    }

    /// Handle a jarugu from one variable to another
    fn handle_move(&mut self, from: &str, to: &str) {
        // Check if the source is borrowed
        let active_borrow = self.borrows.iter()
            .find(|b| b.borrowed_from == from)
            .cloned();
        
        if let Some(borrow) = active_borrow {
            self.errors.push(BorrowError::MoveWhileBorrowed {
                variable: from.to_string(),
                borrower: borrow.borrower,
                line: self.current_line,
            });
            return;
        }
        
        // Check if source is already moved
        if let Some(var) = self.variables.get(from) {
            if let OwnershipState::Moved { to: prev_to, at_line } = &var.state {
                self.errors.push(BorrowError::UseAfterMove {
                    variable: from.to_string(),
                    moved_to: prev_to.clone(),
                    move_line: *at_line,
                    use_line: self.current_line,
                });
                return;
            }
            
            // Only jarugu non-Copy types
            if !self.is_copy_type(&var.var_type) {
                // Mark as moved
                if let Some(var) = self.variables.get_mut(from) {
                    var.state = OwnershipState::Moved {
                        to: to.to_string(),
                        at_line: self.current_line,
                    };
                }
            }
        }
    }

    /// Create an immutable borrow
    pub fn borrow_immutable(&mut self, borrower: &str, borrowed_from: &str) -> Result<(), BorrowError> {
        // Check if already mutably borrowed
        if let Some(var) = self.variables.get(borrowed_from) {
            if let OwnershipState::BorrowedMutable { by } = &var.state {
                return Err(BorrowError::BorrowWhileMutableExists {
                    variable: borrowed_from.to_string(),
                    mutable_borrower: by.clone(),
                    line: self.current_line,
                });
            }
        }
        
        // Add the borrow
        self.borrows.push(Borrow {
            borrower: borrower.to_string(),
            borrowed_from: borrowed_from.to_string(),
            mutable: false,
            line: self.current_line,
            scope_level: self.scope_level,
        });
        
        // Update the variable state
        if let Some(var) = self.variables.get_mut(borrowed_from) {
            match &mut var.state {
                OwnershipState::Owned => {
                    var.state = OwnershipState::BorrowedImmutable {
                        by: vec![borrower.to_string()],
                    };
                }
                OwnershipState::BorrowedImmutable { by } => {
                    by.push(borrower.to_string());
                }
                _ => {}
            }
        }
        
        // Register the borrower as a reference
        self.variables.insert(borrower.to_string(), VariableInfo {
            name: borrower.to_string(),
            var_type: Type::Pointer(Box::new(
                self.variables.get(borrowed_from)
                    .map(|v| v.var_type.clone())
                    .unwrap_or(Type::Void)
            )),
            state: OwnershipState::Reference {
                to: borrowed_from.to_string(),
                mutable: false,
            },
            defined_at: self.current_line,
            scope_level: self.scope_level,
            is_mutable: false,
            lifetime: None,
        });
        
        Ok(())
    }

    /// Create a mutable borrow
    pub fn borrow_mutable(&mut self, borrower: &str, borrowed_from: &str) -> Result<(), BorrowError> {
        // Check if any borrows exist
        if let Some(var) = self.variables.get(borrowed_from) {
            match &var.state {
                OwnershipState::BorrowedMutable { by } => {
                    return Err(BorrowError::DoubleMutableBorrow {
                        variable: borrowed_from.to_string(),
                        first_borrower: by.clone(),
                        second_borrower: borrower.to_string(),
                        line: self.current_line,
                    });
                }
                OwnershipState::BorrowedImmutable { by } => {
                    return Err(BorrowError::MutableBorrowWhileImmutableExists {
                        variable: borrowed_from.to_string(),
                        immutable_borrowers: by.clone(),
                        line: self.current_line,
                    });
                }
                _ => {}
            }
        }
        
        // Add the borrow
        self.borrows.push(Borrow {
            borrower: borrower.to_string(),
            borrowed_from: borrowed_from.to_string(),
            mutable: true,
            line: self.current_line,
            scope_level: self.scope_level,
        });
        
        // Update the variable state
        if let Some(var) = self.variables.get_mut(borrowed_from) {
            var.state = OwnershipState::BorrowedMutable {
                by: borrower.to_string(),
            };
        }
        
        // Register the borrower as a mutable reference
        self.variables.insert(borrower.to_string(), VariableInfo {
            name: borrower.to_string(),
            var_type: Type::Pointer(Box::new(
                self.variables.get(borrowed_from)
                    .map(|v| v.var_type.clone())
                    .unwrap_or(Type::Void)
            )),
            state: OwnershipState::Reference {
                to: borrowed_from.to_string(),
                mutable: true,
            },
            defined_at: self.current_line,
            scope_level: self.scope_level,
            is_mutable: true,
            lifetime: None,
        });
        
        Ok(())
    }

    /// Check if a type is Copy (doesn't need ownership transfer)
    fn is_copy_type(&self, t: &Type) -> bool {
        match t {
            Type::Int | Type::Float | Type::Bool => true,
            Type::Pointer(_) => true, // Pointers are Copy
            _ => false,
        }
    }

    /// End a borrow (when the borrower goes out of scope)
    pub fn end_borrow(&mut self, borrower: &str) {
        // Remove the borrow
        self.borrows.retain(|b| b.borrower != borrower);
        
        // Update the borrowed variable's state
        if let Some(var_info) = self.variables.get(borrower) {
            if let OwnershipState::Reference { to, .. } = &var_info.state {
                let borrowed_from = to.clone();
                
                // Check if there are still other borrows
                let remaining_borrows: Vec<_> = self.borrows.iter()
                    .filter(|b| b.borrowed_from == borrowed_from)
                    .collect();
                
                if remaining_borrows.is_empty() {
                    // No more borrows, restore to Owned
                    if let Some(borrowed_var) = self.variables.get_mut(&borrowed_from) {
                        borrowed_var.state = OwnershipState::Owned;
                    }
                } else if remaining_borrows.iter().any(|b| b.mutable) {
                    // Still has mutable borrow
                    if let Some(mutable_borrow) = remaining_borrows.iter().find(|b| b.mutable) {
                        if let Some(borrowed_var) = self.variables.get_mut(&borrowed_from) {
                            borrowed_var.state = OwnershipState::BorrowedMutable {
                                by: mutable_borrow.borrower.clone(),
                            };
                        }
                    }
                } else {
                    // Only immutable borrows remain
                    let borrowers: Vec<_> = remaining_borrows.iter()
                        .map(|b| b.borrower.clone())
                        .collect();
                    if let Some(borrowed_var) = self.variables.get_mut(&borrowed_from) {
                        borrowed_var.state = OwnershipState::BorrowedImmutable { by: borrowers };
                    }
                }
            }
        }
    }

    /// Check if a variable is currently borrowed
    pub fn is_borrowed(&self, name: &str) -> bool {
        self.borrows.iter().any(|b| b.borrowed_from == name)
    }

    /// Get all errors
    pub fn get_errors(&self) -> &[BorrowError] {
        &self.errors
    }

    /// Check if there are any errors
    pub fn has_errors(&self) -> bool {
        !self.errors.is_empty()
    }
    
    /// Print all errors
    pub fn print_errors(&self) {
        for error in &self.errors {
            eprintln!("{}", error.message());
            eprintln!();
        }
    }
}

impl Default for BorrowChecker {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_ownership() {
        let mut checker = BorrowChecker::new();
        
        // Simulate: @x string = "hello";
        checker.variables.insert("x".to_string(), VariableInfo {
            name: "x".to_string(),
            var_type: Type::String,
            state: OwnershipState::Owned,
            defined_at: 1,
            scope_level: 0,
            is_mutable: false,
            lifetime: None,
        });
        
        assert!(!checker.has_errors());
    }

    #[test]
    fn test_immutable_borrow() {
        let mut checker = BorrowChecker::new();
        
        // @x string = "hello";
        checker.variables.insert("x".to_string(), VariableInfo {
            name: "x".to_string(),
            var_type: Type::String,
            state: OwnershipState::Owned,
            defined_at: 1,
            scope_level: 0,
            is_mutable: false,
            lifetime: None,
        });
        
        // @ref1 = &x;
        assert!(checker.borrow_immutable("ref1", "x").is_ok());
        
        // @ref2 = &x; (multiple immutable borrows OK)
        assert!(checker.borrow_immutable("ref2", "x").is_ok());
    }

    #[test]
    fn test_mutable_borrow_conflict() {
        let mut checker = BorrowChecker::new();
        
        // @x string = "hello";
        checker.variables.insert("x".to_string(), VariableInfo {
            name: "x".to_string(),
            var_type: Type::String,
            state: OwnershipState::Owned,
            defined_at: 1,
            scope_level: 0,
            is_mutable: true,
            lifetime: None,
        });
        
        // @ref1 = &x;
        assert!(checker.borrow_immutable("ref1", "x").is_ok());
        
        // @ref2 = &mut x; (should fail - mutable borrow while immutable exists)
        let result = checker.borrow_mutable("ref2", "x");
        assert!(result.is_err());
    }

    #[test]
    fn test_double_mutable_borrow() {
        let mut checker = BorrowChecker::new();
        
        // @x string = "hello";
        checker.variables.insert("x".to_string(), VariableInfo {
            name: "x".to_string(),
            var_type: Type::String,
            state: OwnershipState::Owned,
            defined_at: 1,
            scope_level: 0,
            is_mutable: true,
            lifetime: None,
        });
        
        // @ref1 = &mut x;
        assert!(checker.borrow_mutable("ref1", "x").is_ok());
        
        // @ref2 = &mut x; (should fail - double mutable borrow)
        let result = checker.borrow_mutable("ref2", "x");
        assert!(result.is_err());
    }
}
