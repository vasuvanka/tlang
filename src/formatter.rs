// Built-in formatter for Tlang
// Formats Tlang code according to standard style guidelines

use crate::ast::{Expr, Stmt, Program, Type};
use std::fmt::Write;

// Helper macro to convert fmt::Result to Result<(), String>
macro_rules! try_write {
    ($($arg:tt)*) => {
        write!($($arg)*).map_err(|e| e.to_string())?
    };
}

macro_rules! try_writeln {
    ($($arg:tt)*) => {
        writeln!($($arg)*).map_err(|e| e.to_string())?
    };
}

pub struct Formatter {
    indent_level: usize,
    indent_size: usize,
    #[allow(dead_code)]
    line_length: usize,  // For future use in line wrapping
}

impl Formatter {
    pub fn new() -> Self {
        Formatter {
            indent_level: 0,
            indent_size: 4,
            line_length: 100,
        }
    }

    /// Format a Tlang program
    pub fn format(&mut self, program: &Program) -> Result<String, String> {
        let mut output = String::new();
        
        // Format imports
        if !program.imports.is_empty() {
            for import in &program.imports {
                if let Some(alias) = &import.alias {
                    try_writeln!(output, "@{} = #dhimpu(\"{}\");", alias, import.path);
                } else {
                    try_writeln!(output, "#dhimpu(\"{}\");", import.path);
                }
            }
            try_writeln!(output);
        }

        // Format statements
        for (i, stmt) in program.statements.iter().enumerate() {
            self.format_stmt(stmt, &mut output)?;
            if i < program.statements.len() - 1 {
                try_writeln!(output);
            }
        }

        Ok(output)
    }

    fn format_stmt(&mut self, stmt: &Stmt, output: &mut String) -> Result<(), String> {
        match stmt {
            Stmt::VariableDecl { name, type_annot, value, mutable, .. } => {
                try_write!(output, "{}", self.indent());
                if *mutable {
                    try_write!(output, "@!{}", name.trim_start_matches('@'));
                } else {
                    try_write!(output, "@{}", name.trim_start_matches('@'));
                }
                if let Some(t) = type_annot {
                    try_write!(output, " {}", self.format_type(t));
                }
                if let Some(v) = value {
                    try_write!(output, " = ");
                    self.format_expr(v, output)?;
                }
                try_writeln!(output, ";");
            }
            Stmt::Assignment { name, value } => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "{} = ", name);
                self.format_expr(value, output)?;
                try_writeln!(output, ";");
            }
            Stmt::Expression(expr) => {
                try_write!(output, "{}", self.indent());
                self.format_expr(expr, output)?;
                try_writeln!(output, ";");
            }
            Stmt::Return(expr) => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "mallinchu");
                if let Some(e) = expr {
                    try_write!(output, " ");
                    self.format_expr(e, output)?;
                }
                try_writeln!(output, ";");
            }
            Stmt::If { condition, then_block, else_block, .. } => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "okavela ");
                self.format_expr(condition, output)?;
                try_writeln!(output, " {{");
                
                self.indent_level += 1;
                for s in then_block {
                    self.format_stmt(s, output)?;
                }
                self.indent_level -= 1;
                
                try_write!(output, "{}", self.indent());
                if let Some(else_body) = else_block {
                    try_writeln!(output, "}} lekapothe {{");
                    self.indent_level += 1;
                    for s in else_body {
                        self.format_stmt(s, output)?;
                    }
                    self.indent_level -= 1;
                    try_write!(output, "{}", self.indent());
                }
                try_writeln!(output, "}}");
            }
            Stmt::For { init, condition, update, body, .. } => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "malli");
                
                if let Some(init_stmt) = init {
                    try_write!(output, " ");
                    // Format init statement (usually a variable declaration or assignment)
                    match init_stmt.as_ref() {
                        Stmt::VariableDecl { name, type_annot, value, mutable, .. } => {
                            if *mutable {
                                try_write!(output, "@!{}", name.trim_start_matches('@'));
                            } else {
                                try_write!(output, "@{}", name.trim_start_matches('@'));
                            }
                            if let Some(t) = type_annot {
                                try_write!(output, " {}", self.format_type(t));
                            }
                            if let Some(v) = value {
                                try_write!(output, " = ");
                                self.format_expr(v, output)?;
                            }
                        }
                        Stmt::Assignment { name, value } => {
                            try_write!(output, "{} = ", name);
                            self.format_expr(value, output)?;
                        }
                        _ => {}
                    }
                }
                
                if let Some(cond_expr) = condition {
                    try_write!(output, "; ");
                    self.format_expr(cond_expr, output)?;
                }
                
                if let Some(update_stmt) = update {
                    try_write!(output, "; ");
                    // Format update statement
                    match update_stmt.as_ref() {
                        Stmt::Assignment { name, value } => {
                            try_write!(output, "{} = ", name);
                            self.format_expr(value, output)?;
                        }
                        Stmt::Expression(expr) => {
                            self.format_expr(expr, output)?;
                        }
                        _ => {}
                    }
                }
                
                try_writeln!(output, " {{");
                
                self.indent_level += 1;
                for s in body {
                    self.format_stmt(s, output)?;
                }
                self.indent_level -= 1;
                
                try_write!(output, "{}", self.indent());
                try_writeln!(output, "}}");
            }
            Stmt::Function { name, params, return_type, body, .. } => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "{}(", name);
                
                for (i, (param_name, param_type)) in params.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    try_write!(output, "@{} {}", param_name.trim_start_matches('@'), self.format_type(param_type));
                }
                
                try_write!(output, ")");
                
                if let Some(rt) = return_type {
                    if rt != &Type::Void {
                        try_write!(output, " {} ", self.format_type(rt));
                    }
                }
                
                try_writeln!(output, " {{");
                
                self.indent_level += 1;
                for s in body {
                    self.format_stmt(s, output)?;
                }
                self.indent_level -= 1;
                
                try_write!(output, "{}", self.indent());
                try_writeln!(output, "}}");
            }
            Stmt::Break => {
                try_write!(output, "{}", self.indent());
                try_writeln!(output, "agu;");
            }
            Stmt::Continue => {
                try_write!(output, "{}", self.indent());
                try_writeln!(output, "konasagu;");
            }
            Stmt::MultiAssignment { names, value } => {
                try_write!(output, "{}", self.indent());
                for (i, name) in names.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    try_write!(output, "@{}", name.trim_start_matches('@'));
                }
                try_write!(output, " = ");
                self.format_expr(value, output)?;
                try_writeln!(output, ";");
            }
            Stmt::ForRange { key_var, value_var, iterable, body } => {
                try_write!(output, "{}", self.indent());
                try_write!(output, "malli @{}", key_var);
                if let Some(val) = value_var {
                    try_write!(output, ", @{}", val);
                }
                try_write!(output, " := varasa ");
                self.format_expr(iterable, output)?;
                try_writeln!(output, " {{");
                
                self.indent_level += 1;
                for s in body {
                    self.format_stmt(s, output)?;
                }
                self.indent_level -= 1;
                
                try_write!(output, "{}", self.indent());
                try_writeln!(output, "}}");
            }
            Stmt::Block(stmts) => {
                for s in stmts {
                    self.format_stmt(s, output)?;
                }
            }
            Stmt::Import { path, alias } => {
                if let Some(a) = alias {
                    try_writeln!(output, "{}@{} = #dhimpu(\"{}\");", self.indent(), a, path);
                } else {
                    try_writeln!(output, "{}#dhimpu(\"{}\");", self.indent(), path);
                }
            }
            Stmt::StructDef { name, fields } => {
                try_writeln!(output, "nirmanam {} {{", name);
                self.indent_level += 1;
                for (field_name, field_type, tag) in fields {
                    try_write!(output, "{}", self.indent());
                    try_write!(output, "@{} {}", field_name, self.format_type(field_type));
                    if let Some(t) = tag {
                        try_write!(output, " `{}`", t);
                    }
                    try_writeln!(output);
                }
                self.indent_level -= 1;
                try_writeln!(output, "}}");
            }
        }
        
        Ok(())
    }

    fn format_expr(&self, expr: &Expr, output: &mut String) -> Result<(), String> {
        match expr {
            Expr::Number(n) => {
                // Format number without unnecessary decimals
                if *n == (*n as i64 as f64) {
                    try_write!(output, "{}", *n as i64);
                } else {
                    try_write!(output, "{}", n);
                }
            }
            Expr::String(s) => {
                try_write!(output, "\"{}\"", s.escape_default());
            }
            Expr::Bool(b) => {
                try_write!(output, "{}", if *b { "satyam" } else { "asatyam" });
            }
            Expr::Nil => {
                try_write!(output, "sunyam");
            }
            Expr::Identifier(name) => {
                try_write!(output, "{}", name);
            }
            Expr::BinaryOp { op, left, right } => {
                self.format_expr(left, output)?;
                try_write!(output, " {} ", self.format_binary_op(op));
                self.format_expr(right, output)?;
            }
            Expr::UnaryOp { op, expr } => {
                try_write!(output, "{}", self.format_unary_op(op));
                self.format_expr(expr, output)?;
            }
            Expr::FunctionCall { name, args } => {
                try_write!(output, "{}(", name);
                for (i, arg) in args.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    self.format_expr(arg, output)?;
                }
                try_write!(output, ")");
            }
            Expr::Assignment { name, value } => {
                try_write!(output, "{} = ", name);
                self.format_expr(value, output)?;
            }
            Expr::ArrayIndex { array, index } => {
                self.format_expr(array, output)?;
                try_write!(output, "[");
                self.format_expr(index, output)?;
                try_write!(output, "]");
            }
            Expr::ArrayLiteral { elements } => {
                try_write!(output, "[");
                for (i, elem) in elements.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    self.format_expr(elem, output)?;
                }
                try_write!(output, "]");
            }
            Expr::SliceExpr { array, start, end } => {
                self.format_expr(array, output)?;
                try_write!(output, "[");
                if let Some(s) = start {
                    self.format_expr(s, output)?;
                }
                try_write!(output, ":");
                if let Some(e) = end {
                    self.format_expr(e, output)?;
                }
                try_write!(output, "]");
            }
            Expr::MemberAccess { object, field } => {
                self.format_expr(object, output)?;
                try_write!(output, ".{}", field);
            }
            Expr::MemberAssignment { object, field, value } => {
                self.format_expr(object, output)?;
                try_write!(output, ".{} = ", field);
                self.format_expr(value, output)?;
            }
            Expr::MapIndex { map, key } => {
                self.format_expr(map, output)?;
                try_write!(output, "[");
                self.format_expr(key, output)?;
                try_write!(output, "]");
            }
            Expr::StructLiteral { struct_type, fields } => {
                try_write!(output, "{} {{", struct_type);
                for (i, (field_name, value)) in fields.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    try_write!(output, "{}: ", field_name);
                    self.format_expr(value, output)?;
                }
                try_write!(output, "}}");
            }
            Expr::MapLiteral { key_type: _, value_type: _, entries } => {
                try_write!(output, "jatha[");
                // Note: We'd need to format types here, but for now just show entries
                try_write!(output, "{{");
                for (i, (key, value)) in entries.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    self.format_expr(key, output)?;
                    try_write!(output, ": ");
                    self.format_expr(value, output)?;
                }
                try_write!(output, "}}");
            }
            Expr::TypeCast { target_type, expr } => {
                try_write!(output, "{}(", self.format_type(target_type));
                self.format_expr(expr, output)?;
                try_write!(output, ")");
            }
            Expr::ErrorCheck { expr } => {
                self.format_expr(expr, output)?;
                try_write!(output, "?");
            }
            Expr::Borrow { expr, mutable } => {
                if *mutable {
                    try_write!(output, "&mut ");
                } else {
                    try_write!(output, "&");
                }
                self.format_expr(expr, output)?;
            }
            Expr::Deref { expr } => {
                try_write!(output, "*");
                self.format_expr(expr, output)?;
            }
            Expr::Jarugu { expr } => {
                try_write!(output, "jarugu ");
                self.format_expr(expr, output)?;
            }
            Expr::TupleLiteral { elements } => {
                try_write!(output, "(");
                for (i, elem) in elements.iter().enumerate() {
                    if i > 0 {
                        try_write!(output, ", ");
                    }
                    self.format_expr(elem, output)?;
                }
                try_write!(output, ")");
            }
            Expr::ErrorPropagate { expr } => {
                self.format_expr(expr, output)?;
                try_write!(output, "?");
            }
            Expr::Kotha { target_type } => {
                try_write!(output, "nirmanam({})", self.format_type(target_type));
            }
            Expr::SunyamFree { expr } => {
                try_write!(output, "sunyam(");
                self.format_expr(expr, output)?;
                try_write!(output, ")");
            }
        }
        
        Ok(())
    }

    fn format_type(&self, ty: &Type) -> String {
        match ty {
            Type::Int => "int".to_string(),
            Type::Float => "float".to_string(),
            Type::String => "string".to_string(),
            Type::Bool => "bool".to_string(),
            Type::Void => "void".to_string(),
            Type::Error => "error".to_string(),
            Type::Pointer(inner) => format!("*{}", self.format_type(inner)),
            Type::Array { size, element_type } => {
                if *size == 0 {
                    format!("[]{}", self.format_type(element_type))
                } else {
                    format!("[{}]{}", size, self.format_type(element_type))
                }
            }
            Type::Slice { element_type } => {
                format!("[]{}", self.format_type(element_type))
            }
            Type::Struct { name } => name.clone(),
            Type::Map { key_type, value_type } => {
                format!("jatha[{}]{}", self.format_type(key_type), self.format_type(value_type))
            }
            Type::Any => "nirmanam{}".to_string(),
            Type::Tuple { types } => {
                let type_strs: Vec<String> = types.iter().map(|t| self.format_type(t)).collect();
                format!("({})", type_strs.join(", "))
            }
            Type::Reference { inner, mutable } => {
                if *mutable {
                    format!("&mut {}", self.format_type(inner))
                } else {
                    format!("&{}", self.format_type(inner))
                }
            }
            Type::Owned { inner, .. } => {
                self.format_type(inner)
            }
        }
    }

    fn format_binary_op(&self, op: &crate::ast::BinaryOperator) -> &str {
        use crate::ast::BinaryOperator::*;
        match op {
            Add => "+",
            Subtract => "-",
            Multiply => "*",
            Divide => "/",
            Modulo => "%",
            Power => "^",
            Equal => "==",
            NotEqual => "!=",
            LessThan => "<",
            GreaterThan => ">",
            LessThanEqual => "<=",
            GreaterThanEqual => ">=",
            And => "&&",
            Or => "||",
        }
    }

    fn format_unary_op(&self, op: &crate::ast::UnaryOperator) -> &str {
        use crate::ast::UnaryOperator::*;
        match op {
            Negate => "-",
            Not => "!",
        }
    }

    fn indent(&self) -> String {
        " ".repeat(self.indent_level * self.indent_size)
    }
}

impl Default for Formatter {
    fn default() -> Self {
        Self::new()
    }
}
