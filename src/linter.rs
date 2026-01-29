// Built-in linter for Tlang
// Checks for common issues and code quality problems

use crate::ast::{Expr, Stmt, Program, Type};
use crate::error::SourceLocation;
use std::collections::{HashSet, HashMap};
use std::path::Path;

#[derive(Debug, Clone)]
pub struct LintIssue {
    pub level: LintLevel,
    pub message: String,
    pub location: SourceLocation,
    pub code: String, // Lint code (e.g., "W001", "E001")
}

#[derive(Debug, Clone, PartialEq)]
pub enum LintLevel {
    Error,   // Must be fixed
    Warning, // Should be fixed
    Info,    // Nice to have
}

pub struct Linter {
    issues: Vec<LintIssue>,
    used_imports: HashSet<String>,
    defined_functions: HashSet<String>,
    defined_variables: HashSet<String>,
    // Track declarations with their locations for better error messages
    variable_locations: HashMap<String, SourceLocation>,
    function_locations: HashMap<String, SourceLocation>,
    import_locations: HashMap<String, SourceLocation>,
}

impl Linter {
    pub fn new() -> Self {
        Linter {
            issues: Vec::new(),
            used_imports: HashSet::new(),
            defined_functions: HashSet::new(),
            defined_variables: HashSet::new(),
            variable_locations: HashMap::new(),
            function_locations: HashMap::new(),
            import_locations: HashMap::new(),
        }
    }

    /// Lint a Tlang program
    pub fn lint<P: AsRef<Path>>(
        &mut self,
        program: &Program,
        source: &str,
        filename: P,
    ) -> Vec<LintIssue> {
        self.issues.clear();
        self.used_imports.clear();
        self.defined_functions.clear();
        self.defined_variables.clear();
        self.variable_locations.clear();
        self.function_locations.clear();
        self.import_locations.clear();

        let filename_str = filename.as_ref().to_string_lossy().to_string();

        // Check imports
        self.check_imports(program, &filename_str);

        // First pass: collect all declarations and their locations
        self.collect_declarations(program, &filename_str, source);

        // Second pass: collect all usages
        self.collect_used_identifiers(program, source);
        self.collect_all_usages(program, source);

        // Third pass: check for unused items
        self.check_unused_imports(program, &filename_str);
        self.check_unused_functions(program, &filename_str);
        self.check_unused_variables(program, &filename_str);

        // Check functions for issues
        for stmt in &program.statements {
            if let Stmt::Function { name, params, body, return_type, .. } = stmt {
                self.check_function(name, params, body, return_type, &filename_str);
            }
        }

        // Check for dead code (unreachable code)
        self.check_dead_code(program, &filename_str);

        // Check for common issues
        self.check_common_issues(program, source, &filename_str);

        self.issues.clone()
    }

    fn check_imports(&mut self, program: &Program, filename: &str) {
        let mut seen_imports = HashSet::new();
        let mut import_line = 1;
        for import in &program.imports {
            let import_key = format!("{}:{}", import.path, import.alias.as_ref().unwrap_or(&"".to_string()));
            if seen_imports.contains(&import_key) {
                self.add_issue(
                    LintLevel::Warning,
                    format!("Duplicate import: '{}'", import.path),
                    SourceLocation::new(import_line, 1, filename.to_string()),
                    "W001",
                );
            }
            seen_imports.insert(import_key);
            import_line += 1;
        }
    }

    fn collect_declarations(&mut self, program: &Program, filename: &str, _source: &str) {
        // Collect import declarations with locations
        let mut import_line = 1;
        for import in &program.imports {
            let import_name = import.alias.as_deref().unwrap_or_else(|| {
                // Extract package name from path (last component)
                import.path.split('/').last().unwrap_or(import.path.as_str())
            });
            let location = SourceLocation::new(import_line, 1, filename.to_string());
            self.import_locations.insert(import_name.to_string(), location);
            import_line += 1;
        }

        // Collect function and variable declarations
        self.collect_declarations_in_statements(&program.statements, filename, 1);
    }

    fn collect_declarations_in_statements(&mut self, statements: &[Stmt], filename: &str, base_line: usize) {
        for (idx, stmt) in statements.iter().enumerate() {
            let line = base_line + idx;
            match stmt {
                Stmt::Function { name, .. } => {
                    let location = SourceLocation::new(line, 1, filename.to_string());
                    self.defined_functions.insert(name.clone());
                    self.function_locations.insert(name.clone(), location);
                }
                Stmt::VariableDecl { name, .. } => {
                    let location = SourceLocation::new(line, 1, filename.to_string());
                    self.defined_variables.insert(name.clone());
                    self.variable_locations.insert(name.clone(), location);
                }
                Stmt::Block(body) | Stmt::If { then_block: body, .. } => {
                    self.collect_declarations_in_statements(body, filename, line + 1);
                }
                Stmt::For { body, .. } | Stmt::ForRange { body, .. } => {
                    self.collect_declarations_in_statements(body, filename, line + 1);
                }
                // Note: Stmt::Function is already handled above, so we don't need to handle it again here
                _ => {}
            }
        }
    }

    fn collect_all_usages(&mut self, program: &Program, _source: &str) {
        // Collect all identifier usages in the program
        let mut used = HashSet::new();
        for stmt in &program.statements {
            self.collect_identifiers_in_stmt(stmt, &mut used);
        }
    }

    fn collect_identifiers_in_stmt(&mut self, stmt: &Stmt, used: &mut HashSet<String>) {
        match stmt {
            Stmt::Expression(expr) => {
                self.collect_identifiers_in_expr(expr, used);
            }
            Stmt::VariableDecl { value, .. } => {
                if let Some(v) = value {
                    self.collect_identifiers_in_expr(v, used);
                }
            }
            Stmt::Assignment { name, value } => {
                used.insert(name.clone());
                self.collect_identifiers_in_expr(value, used);
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    self.collect_identifiers_in_expr(e, used);
                }
            }
            Stmt::If { condition, then_block, else_block, .. } => {
                self.collect_identifiers_in_expr(condition, used);
                for s in then_block {
                    self.collect_identifiers_in_stmt(s, used);
                }
                if let Some(else_body) = else_block {
                    for s in else_body {
                        self.collect_identifiers_in_stmt(s, used);
                    }
                }
            }
            Stmt::For { init, condition, update, body, .. } => {
                if let Some(init_stmt) = init {
                    self.collect_identifiers_in_stmt(init_stmt, used);
                }
                if let Some(cond_expr) = condition {
                    self.collect_identifiers_in_expr(cond_expr, used);
                }
                if let Some(update_stmt) = update {
                    self.collect_identifiers_in_stmt(update_stmt, used);
                }
                for s in body {
                    self.collect_identifiers_in_stmt(s, used);
                }
            }
            Stmt::ForRange { iterable, body, .. } => {
                self.collect_identifiers_in_expr(iterable, used);
                for s in body {
                    self.collect_identifiers_in_stmt(s, used);
                }
            }
            Stmt::Function { body, .. } => {
                for s in body {
                    self.collect_identifiers_in_stmt(s, used);
                }
            }
            Stmt::Block(body) => {
                for s in body {
                    self.collect_identifiers_in_stmt(s, used);
                }
            }
            _ => {}
        }
    }

    fn check_unused_imports(&mut self, program: &Program, _filename: &str) {
        for import in &program.imports {
            let import_name = import.alias.as_deref().unwrap_or_else(|| {
                // Extract package name from path (last component)
                import.path.split('/').last().unwrap_or(import.path.as_str())
            });
            
            if !self.used_imports.contains(import_name) {
                if let Some(location) = self.import_locations.get(import_name) {
                    self.add_issue(
                        LintLevel::Warning,
                        format!("Unused import: '{}'", import.path),
                        location.clone(),
                        "W002",
                    );
                }
            }
        }
    }

    fn check_unused_functions(&mut self, program: &Program, _filename: &str) {
        // Track which functions are called
        let mut called_functions = HashSet::new();
        
        // Collect function calls
        for stmt in &program.statements {
            self.collect_function_calls(stmt, &mut called_functions);
        }

        // Check for unused functions (excluding #prarambham which is the entry point)
        let unused_functions: Vec<_> = self.function_locations.iter()
            .filter(|(func_name, _)| *func_name != "#prarambham" && !called_functions.contains(*func_name))
            .map(|(name, loc)| (name.clone(), loc.clone()))
            .collect();
        
        for (func_name, location) in unused_functions {
            self.add_issue(
                LintLevel::Warning,
                format!("Unused function: '{}'", func_name),
                location,
                "W006",
            );
        }
    }

    fn collect_function_calls(&mut self, stmt: &Stmt, called: &mut HashSet<String>) {
        match stmt {
            Stmt::Expression(expr) => {
                self.collect_function_calls_in_expr(expr, called);
            }
            Stmt::VariableDecl { value, .. } => {
                if let Some(v) = value {
                    self.collect_function_calls_in_expr(v, called);
                }
            }
            Stmt::Assignment { value, .. } => {
                self.collect_function_calls_in_expr(value, called);
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    self.collect_function_calls_in_expr(e, called);
                }
            }
            Stmt::If { condition, then_block, else_block, .. } => {
                self.collect_function_calls_in_expr(condition, called);
                for s in then_block {
                    self.collect_function_calls(s, called);
                }
                if let Some(else_body) = else_block {
                    for s in else_body {
                        self.collect_function_calls(s, called);
                    }
                }
            }
            Stmt::For { init, condition, update, body, .. } => {
                if let Some(init_stmt) = init {
                    self.collect_function_calls(init_stmt, called);
                }
                if let Some(cond_expr) = condition {
                    self.collect_function_calls_in_expr(cond_expr, called);
                }
                if let Some(update_stmt) = update {
                    self.collect_function_calls(update_stmt, called);
                }
                for s in body {
                    self.collect_function_calls(s, called);
                }
            }
            Stmt::ForRange { iterable, body, .. } => {
                self.collect_function_calls_in_expr(iterable, called);
                for s in body {
                    self.collect_function_calls(s, called);
                }
            }
            Stmt::Function { body, .. } => {
                for s in body {
                    self.collect_function_calls(s, called);
                }
            }
            Stmt::Block(body) => {
                for s in body {
                    self.collect_function_calls(s, called);
                }
            }
            _ => {}
        }
    }

    fn collect_function_calls_in_expr(&mut self, expr: &Expr, called: &mut HashSet<String>) {
        match expr {
            Expr::FunctionCall { name, args } => {
                // Extract function name (remove package prefix if present)
                let func_name = if let Some((_, func)) = name.split_once('.') {
                    func
                } else {
                    name
                };
                // Function names in AST already have # prefix
                if func_name.starts_with('#') {
                    called.insert(func_name.to_string());
                } else {
                    called.insert(format!("#{}", func_name));
                }
                
                // Also check for package-qualified calls
                if name.contains('.') {
                    if let Some((pkg, _)) = name.split_once('.') {
                        self.used_imports.insert(pkg.to_string());
                    }
                }
                
                for arg in args {
                    self.collect_function_calls_in_expr(arg, called);
                }
            }
            Expr::BinaryOp { left, right, .. } => {
                self.collect_function_calls_in_expr(left, called);
                self.collect_function_calls_in_expr(right, called);
            }
            Expr::UnaryOp { expr, .. } => {
                self.collect_function_calls_in_expr(expr, called);
            }
            Expr::Assignment { value, .. } => {
                self.collect_function_calls_in_expr(value, called);
            }
            Expr::ArrayIndex { array, index } => {
                self.collect_function_calls_in_expr(array, called);
                self.collect_function_calls_in_expr(index, called);
            }
            Expr::ArrayLiteral { elements } => {
                for elem in elements {
                    self.collect_function_calls_in_expr(elem, called);
                }
            }
            Expr::SliceExpr { array, start, end } => {
                self.collect_function_calls_in_expr(array, called);
                if let Some(s) = start {
                    self.collect_function_calls_in_expr(s, called);
                }
                if let Some(e) = end {
                    self.collect_function_calls_in_expr(e, called);
                }
            }
            Expr::MemberAccess { object, .. } => {
                self.collect_function_calls_in_expr(object, called);
            }
            Expr::MapIndex { map, key } => {
                self.collect_function_calls_in_expr(map, called);
                self.collect_function_calls_in_expr(key, called);
            }
            Expr::StructLiteral { fields, .. } => {
                for (_, value) in fields {
                    self.collect_function_calls_in_expr(value, called);
                }
            }
            Expr::MapLiteral { entries, .. } => {
                for (key, value) in entries {
                    self.collect_function_calls_in_expr(key, called);
                    self.collect_function_calls_in_expr(value, called);
                }
            }
            Expr::TypeCast { expr, .. } => {
                self.collect_function_calls_in_expr(expr, called);
            }
            _ => {}
        }
    }

    fn check_function(
        &mut self,
        name: &str,
        params: &[(String, Type)],
        body: &[Stmt],
        return_type: &Option<Type>,
        filename: &str,
    ) {
        // Check for function name starting with #
        if !name.starts_with('#') {
            self.add_issue(
                LintLevel::Error,
                format!("Function name '{}' must start with '#'", name),
                SourceLocation::new(1, 1, filename.to_string()),
                "E002",
            );
        }

        // Check for unused parameters
        let mut used_params = HashSet::new();
        self.collect_used_identifiers_in_body(body, &mut used_params);
        
        for (param_name, _) in params {
            if !used_params.contains(param_name) {
                self.add_issue(
                    LintLevel::Warning,
                    format!("Unused parameter: '{}'", param_name),
                    SourceLocation::new(1, 1, filename.to_string()),
                    "W003",
                );
            }
        }

        // Check for missing return statement in non-void functions
        if return_type.is_some() && return_type != &Some(Type::Void) {
            if !self.has_return_statement(body) {
                self.add_issue(
                    LintLevel::Warning,
                    format!("Function '{}' has return type but no return statement", name),
                    SourceLocation::new(1, 1, filename.to_string()),
                    "W004",
                );
            }
        }
    }

    fn has_return_statement(&self, body: &[Stmt]) -> bool {
        for stmt in body {
            match stmt {
                Stmt::Return(_) => return true,
                Stmt::If { then_block, else_block, .. } => {
                    if self.has_return_statement(then_block) {
                        if let Some(else_body) = else_block {
                            if self.has_return_statement(else_body) {
                                return true;
                            }
                        }
                    }
                }
                _ => {}
            }
        }
        false
    }

    fn check_unused_variables(&mut self, program: &Program, _filename: &str) {
        // Collect all variable usages
        let mut used_vars = HashSet::new();
        for stmt in &program.statements {
            self.collect_variable_usages_in_stmt(stmt, &mut used_vars);
        }

        // Check for unused variables (excluding function parameters)
        let unused_variables: Vec<_> = self.variable_locations.iter()
            .filter(|(var_name, _)| !used_vars.contains(*var_name) && !var_name.starts_with("_"))
            .map(|(name, loc)| (name.clone(), loc.clone()))
            .collect();
        
        for (var_name, location) in unused_variables {
            self.add_issue(
                LintLevel::Warning,
                format!("Unused variable: '{}'", var_name),
                location,
                "W007",
            );
        }
    }

    fn collect_variable_usages_in_stmt(&mut self, stmt: &Stmt, used: &mut HashSet<String>) {
        match stmt {
            Stmt::Expression(expr) => {
                self.collect_variable_usages_in_expr(expr, used);
            }
            Stmt::VariableDecl { value, .. } => {
                if let Some(v) = value {
                    self.collect_variable_usages_in_expr(v, used);
                }
            }
            Stmt::Assignment { name, value } => {
                used.insert(name.clone());
                self.collect_variable_usages_in_expr(value, used);
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    self.collect_variable_usages_in_expr(e, used);
                }
            }
            Stmt::If { condition, then_block, else_block, .. } => {
                self.collect_variable_usages_in_expr(condition, used);
                for s in then_block {
                    self.collect_variable_usages_in_stmt(s, used);
                }
                if let Some(else_body) = else_block {
                    for s in else_body {
                        self.collect_variable_usages_in_stmt(s, used);
                    }
                }
            }
            Stmt::For { init, condition, update, body, .. } => {
                if let Some(init_stmt) = init {
                    self.collect_variable_usages_in_stmt(init_stmt, used);
                }
                if let Some(cond_expr) = condition {
                    self.collect_variable_usages_in_expr(cond_expr, used);
                }
                if let Some(update_stmt) = update {
                    self.collect_variable_usages_in_stmt(update_stmt, used);
                }
                for s in body {
                    self.collect_variable_usages_in_stmt(s, used);
                }
            }
            Stmt::ForRange { iterable, body, .. } => {
                self.collect_variable_usages_in_expr(iterable, used);
                for s in body {
                    self.collect_variable_usages_in_stmt(s, used);
                }
            }
            Stmt::Function { body, .. } => {
                for s in body {
                    self.collect_variable_usages_in_stmt(s, used);
                }
            }
            Stmt::Block(body) => {
                for s in body {
                    self.collect_variable_usages_in_stmt(s, used);
                }
            }
            _ => {}
        }
    }

    fn collect_variable_usages_in_expr(&mut self, expr: &Expr, used: &mut HashSet<String>) {
        match expr {
            Expr::Identifier(name) => {
                used.insert(name.clone());
            }
            Expr::BinaryOp { left, right, .. } => {
                self.collect_variable_usages_in_expr(left, used);
                self.collect_variable_usages_in_expr(right, used);
            }
            Expr::UnaryOp { expr, .. } => {
                self.collect_variable_usages_in_expr(expr, used);
            }
            Expr::FunctionCall { args, .. } => {
                for arg in args {
                    self.collect_variable_usages_in_expr(arg, used);
                }
            }
            Expr::Assignment { name, value } => {
                used.insert(name.clone());
                self.collect_variable_usages_in_expr(value, used);
            }
            Expr::ArrayIndex { array, index } => {
                self.collect_variable_usages_in_expr(array, used);
                self.collect_variable_usages_in_expr(index, used);
            }
            Expr::ArrayLiteral { elements } => {
                for elem in elements {
                    self.collect_variable_usages_in_expr(elem, used);
                }
            }
            Expr::SliceExpr { array, start, end } => {
                self.collect_variable_usages_in_expr(array, used);
                if let Some(s) = start {
                    self.collect_variable_usages_in_expr(s, used);
                }
                if let Some(e) = end {
                    self.collect_variable_usages_in_expr(e, used);
                }
            }
            Expr::MemberAccess { object, .. } => {
                self.collect_variable_usages_in_expr(object, used);
            }
            Expr::MapIndex { map, key } => {
                self.collect_variable_usages_in_expr(map, used);
                self.collect_variable_usages_in_expr(key, used);
            }
            Expr::StructLiteral { fields, .. } => {
                for (_, value) in fields {
                    self.collect_variable_usages_in_expr(value, used);
                }
            }
            Expr::MapLiteral { entries, .. } => {
                for (key, value) in entries {
                    self.collect_variable_usages_in_expr(key, used);
                    self.collect_variable_usages_in_expr(value, used);
                }
            }
            Expr::TypeCast { expr, .. } => {
                self.collect_variable_usages_in_expr(expr, used);
            }
            _ => {}
        }
    }

    fn collect_variable_usage(&mut self, stmt: &Stmt, defined: &mut HashSet<String>, used: &mut HashSet<String>) {
        match stmt {
            Stmt::VariableDecl { name, value, .. } => {
                defined.insert(name.clone());
                if let Some(v) = value {
                    self.collect_identifiers_in_expr(v, used);
                }
            }
            Stmt::Assignment { name, value } => {
                used.insert(name.clone());
                self.collect_identifiers_in_expr(value, used);
            }
            Stmt::Expression(expr) => {
                self.collect_identifiers_in_expr(expr, used);
            }
            Stmt::Return(expr) => {
                if let Some(e) = expr {
                    self.collect_identifiers_in_expr(e, used);
                }
            }
            Stmt::If { condition, then_block, else_block, .. } => {
                self.collect_identifiers_in_expr(condition, used);
                for s in then_block {
                    self.collect_variable_usage(s, defined, used);
                }
                if let Some(else_body) = else_block {
                    for s in else_body {
                        self.collect_variable_usage(s, defined, used);
                    }
                }
            }
            Stmt::For { init, condition, update, body, .. } => {
                if let Some(init_stmt) = init {
                    self.collect_variable_usage(init_stmt, defined, used);
                }
                if let Some(cond_expr) = condition {
                    self.collect_identifiers_in_expr(cond_expr, used);
                }
                if let Some(update_stmt) = update {
                    self.collect_variable_usage(update_stmt, defined, used);
                }
                for s in body {
                    self.collect_variable_usage(s, defined, used);
                }
            }
            Stmt::Function { params, body, .. } => {
                for (param_name, _) in params {
                    defined.insert(param_name.clone());
                }
                for s in body {
                    self.collect_variable_usage(s, defined, used);
                }
            }
            _ => {}
        }
    }

    fn collect_identifiers_in_expr(&mut self, expr: &Expr, used: &mut HashSet<String>) {
        match expr {
            Expr::Identifier(name) => {
                used.insert(name.clone());
            }
            Expr::BinaryOp { left, right, .. } => {
                self.collect_identifiers_in_expr(left, used);
                self.collect_identifiers_in_expr(right, used);
            }
            Expr::UnaryOp { expr, .. } => {
                self.collect_identifiers_in_expr(expr, used);
            }
            Expr::FunctionCall { name, args } => {
                // Check if it's a package-qualified call (e.g., fmt.Printf)
                if let Some((pkg, _)) = name.split_once('.') {
                    self.used_imports.insert(pkg.to_string());
                }
                for arg in args {
                    self.collect_identifiers_in_expr(arg, used);
                }
            }
            Expr::Assignment { name, value } => {
                used.insert(name.clone());
                self.collect_identifiers_in_expr(value, used);
            }
            Expr::ArrayIndex { array, index } => {
                self.collect_identifiers_in_expr(array, used);
                self.collect_identifiers_in_expr(index, used);
            }
            Expr::ArrayLiteral { elements } => {
                for elem in elements {
                    self.collect_identifiers_in_expr(elem, used);
                }
            }
            Expr::SliceExpr { array, start, end } => {
                self.collect_identifiers_in_expr(array, used);
                if let Some(s) = start {
                    self.collect_identifiers_in_expr(s, used);
                }
                if let Some(e) = end {
                    self.collect_identifiers_in_expr(e, used);
                }
            }
            Expr::MemberAccess { object, .. } => {
                self.collect_identifiers_in_expr(object, used);
            }
            Expr::MapIndex { map, key } => {
                self.collect_identifiers_in_expr(map, used);
                self.collect_identifiers_in_expr(key, used);
            }
            Expr::StructLiteral { fields, .. } => {
                for (_, value) in fields {
                    self.collect_identifiers_in_expr(value, used);
                }
            }
            Expr::MapLiteral { entries, .. } => {
                for (key, value) in entries {
                    self.collect_identifiers_in_expr(key, used);
                    self.collect_identifiers_in_expr(value, used);
                }
            }
            Expr::TypeCast { expr, .. } => {
                self.collect_identifiers_in_expr(expr, used);
            }
            _ => {}
        }
    }

    fn collect_used_identifiers(&mut self, program: &Program, source: &str) {
        // Simple heuristic: look for package.Identifier patterns in source
        // This is a simplified approach - a full implementation would parse more carefully
        for import in &program.imports {
            let pkg_name = import.alias.as_deref().unwrap_or_else(|| {
                import.path.split('/').last().unwrap_or(import.path.as_str())
            });
            
            // Check if package is used in source
            if source.contains(&format!("{}.", pkg_name)) {
                self.used_imports.insert(pkg_name.to_string());
            }
        }
    }

    fn collect_used_identifiers_in_body(&mut self, body: &[Stmt], used: &mut HashSet<String>) {
        for stmt in body {
            match stmt {
                Stmt::VariableDecl { name: _, value, .. } => {
                    if let Some(v) = value {
                        self.collect_identifiers_in_expr(v, used);
                    }
                }
                Stmt::Assignment { name, value } => {
                    used.insert(name.clone());
                    self.collect_identifiers_in_expr(value, used);
                }
                Stmt::Expression(expr) => {
                    self.collect_identifiers_in_expr(expr, used);
                }
                Stmt::Return(expr) => {
                    if let Some(e) = expr {
                        self.collect_identifiers_in_expr(e, used);
                    }
                }
                Stmt::If { condition, then_block, else_block, .. } => {
                    self.collect_identifiers_in_expr(condition, used);
                    self.collect_used_identifiers_in_body(then_block, used);
                    if let Some(else_body) = else_block {
                        self.collect_used_identifiers_in_body(else_body, used);
                    }
                }
                Stmt::For { init, condition, update, body, .. } => {
                    if let Some(init_stmt) = init {
                        self.collect_variable_usage(init_stmt, &mut HashSet::new(), used);
                    }
                    if let Some(cond_expr) = condition {
                        self.collect_identifiers_in_expr(cond_expr, used);
                    }
                    if let Some(update_stmt) = update {
                        self.collect_variable_usage(update_stmt, &mut HashSet::new(), used);
                    }
                    self.collect_used_identifiers_in_body(body, used);
                }
                Stmt::Function { params, body, .. } => {
                    for (param_name, _) in params {
                        used.insert(param_name.clone());
                    }
                    self.collect_used_identifiers_in_body(body, used);
                }
                _ => {}
            }
        }
    }

    fn check_dead_code(&mut self, program: &Program, filename: &str) {
        // Check for unreachable code after return/break/continue
        for stmt in &program.statements {
            self.check_dead_code_in_stmt(stmt, filename, 1);
        }
    }

    fn check_dead_code_in_stmt(&mut self, stmt: &Stmt, filename: &str, base_line: usize) {
        match stmt {
            Stmt::Function { body, name, .. } => {
                self.check_dead_code_in_block(body, filename, base_line + 1, format!("function '{}'", name));
            }
            Stmt::Block(body) => {
                self.check_dead_code_in_block(body, filename, base_line + 1, "block".to_string());
            }
            Stmt::If { then_block, else_block, .. } => {
                self.check_dead_code_in_block(then_block, filename, base_line + 1, "if block".to_string());
                if let Some(else_body) = else_block {
                    self.check_dead_code_in_block(else_body, filename, base_line + 1, "else block".to_string());
                }
            }
            Stmt::For { body, .. } | Stmt::ForRange { body, .. } => {
                self.check_dead_code_in_block(body, filename, base_line + 1, "loop".to_string());
            }
            _ => {}
        }
    }

    fn check_dead_code_in_block(&mut self, body: &[Stmt], filename: &str, base_line: usize, context: String) {
        let mut found_unreachable = false;
        let mut unreachable_start_line = 0;

        for (idx, stmt) in body.iter().enumerate() {
            let line = base_line + idx;
            
            // Check if this statement is unreachable
            if found_unreachable {
                match stmt {
                    Stmt::Return(_) | Stmt::Break | Stmt::Continue => {
                        // Another terminating statement - continue marking as dead
                    }
                    _ => {
                        // Non-terminating statement after unreachable point
                        if unreachable_start_line == 0 {
                            unreachable_start_line = line;
                        }
                        self.add_issue(
                            LintLevel::Warning,
                            format!("Unreachable code in {} (code after return/break/continue)", context),
                            SourceLocation::new(line, 1, filename.to_string()),
                            "W008",
                        );
                    }
                }
            }

            // Check if this statement terminates execution
            match stmt {
                Stmt::Return(_) | Stmt::Break | Stmt::Continue => {
                    found_unreachable = true;
                    unreachable_start_line = line + 1;
                }
                Stmt::If { then_block, else_block, .. } => {
                    // Check if both branches terminate
                    let then_terminates = self.block_terminates(then_block);
                    let else_terminates = else_block.as_ref().map_or(false, |b| self.block_terminates(b));
                    if then_terminates && else_terminates {
                        found_unreachable = true;
                        unreachable_start_line = line + 1;
                    }
                }
                _ => {
                    // Recursively check nested blocks
                    self.check_dead_code_in_stmt(stmt, filename, line);
                }
            }
        }
    }

    fn block_terminates(&self, body: &[Stmt]) -> bool {
        for stmt in body {
            match stmt {
                Stmt::Return(_) | Stmt::Break | Stmt::Continue => {
                    return true;
                }
                Stmt::If { then_block, else_block, .. } => {
                    let then_terminates = self.block_terminates(then_block);
                    let else_terminates = else_block.as_ref().map_or(false, |b| self.block_terminates(b));
                    if then_terminates && else_terminates {
                        return true;
                    }
                }
                _ => {}
            }
        }
        false
    }

    fn check_common_issues(&mut self, _program: &Program, source: &str, filename: &str) {
        // Check for trailing whitespace
        for (line_num, line) in source.lines().enumerate() {
            if line.ends_with(' ') || line.ends_with('\t') {
                self.add_issue(
                    LintLevel::Info,
                    "Trailing whitespace",
                    SourceLocation::new(line_num + 1, line.len(), filename.to_string()),
                    "I001",
                );
            }
        }

        // Check for inconsistent indentation (simplified)
        let lines: Vec<&str> = source.lines().collect();
        let mut prev_indent = 0;
        for (line_num, line) in lines.iter().enumerate() {
            if line.trim().is_empty() {
                continue;
            }
            let indent = line.chars().take_while(|c| c.is_whitespace()).count();
            // Check for significant indentation changes (more than 4 spaces)
            if indent > prev_indent + 4 && prev_indent > 0 {
                self.add_issue(
                    LintLevel::Warning,
                    "Inconsistent indentation (expected 4 spaces per level)",
                    SourceLocation::new(line_num + 1, 1, filename.to_string()),
                    "W005",
                );
            }
            prev_indent = indent;
        }
    }

    fn add_issue(&mut self, level: LintLevel, message: impl AsRef<str>, location: SourceLocation, code: &str) {
        self.issues.push(LintIssue {
            level,
            message: message.as_ref().to_string(),
            location,
            code: code.to_string(),
        });
    }
}

impl Default for Linter {
    fn default() -> Self {
        Self::new()
    }
}
