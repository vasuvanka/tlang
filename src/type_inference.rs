use crate::ast::{Expr, Type};

/// Infers the type of an expression
pub fn infer_type(expr: &Expr) -> Option<Type> {
    match expr {
        Expr::Number(n) => {
            // Check if it's a whole number (int) or has decimal (float)
            if n.fract() == 0.0 {
                Some(Type::Int)
            } else {
                Some(Type::Float)
            }
        }
        Expr::String(_) => Some(Type::String),
        Expr::Bool(_) => Some(Type::Bool),
        Expr::Identifier(_) => {
            // Can't infer type from identifier alone
            // This would require a symbol table
            None
        }
        Expr::BinaryOp { op: _, left, right } => {
            // For binary operations, infer from operands
            let left_type = infer_type(left);
            let right_type = infer_type(right);
            
            // If both operands have the same type, use that
            if let (Some(l), Some(r)) = (left_type, right_type) {
                if l == r {
                    return Some(l);
                }
                // If one is float and other is int, result is float
                match (l, r) {
                    (Type::Float, Type::Int) | (Type::Int, Type::Float) => Some(Type::Float),
                    _ => None,
                }
            } else {
                None
            }
        }
        Expr::UnaryOp { op: _, expr } => infer_type(expr),
        Expr::FunctionCall { name: _, args: _ } => {
            // Can't infer from function call without knowing function signature
            None
        }
        Expr::Assignment { name: _, value } => infer_type(value),
        Expr::Nil => Some(Type::Error), // nil is error type (NULL)
        Expr::ErrorCheck { expr } => infer_type(expr),
        Expr::ArrayLiteral { elements } => {
            if elements.is_empty() {
                // Empty array - can't infer type
                None
            } else {
                // Infer element type from first element
                if let Some(elem_type) = infer_type(&elements[0]) {
                    Some(Type::Array {
                        size: elements.len(),
                        element_type: Box::new(elem_type),
                    })
                } else {
                    None
                }
            }
        }
        Expr::ArrayIndex { array, index: _ } => {
            // Array/slice indexing returns element type
            if let Some(typ) = infer_type(array) {
                match typ {
                    Type::Array { element_type, .. } => Some(*element_type),
                    Type::Slice { element_type } => Some(*element_type),
                    _ => None,
                }
            } else {
                None
            }
        }
        Expr::SliceExpr { array, start: _, end: _ } => {
            // Slice expression returns a slice of the same element type
            if let Some(typ) = infer_type(array) {
                match typ {
                    Type::Array { element_type, .. } => Some(Type::Slice {
                        element_type: element_type.clone(),
                    }),
                    Type::Slice { element_type } => Some(Type::Slice {
                        element_type: element_type.clone(),
                    }),
                    _ => None,
                }
            } else {
                None
            }
        }
        Expr::MemberAccess { object, field: _ } => {
            // Member access returns the type of the field
            // This is simplified - full implementation would look up struct definition
            if let Some(obj_type) = infer_type(object) {
                match obj_type {
                    Type::Struct { name: _ } => {
                        // We can't infer the field type without struct definition info
                        // Return None for now - type checker will handle it
                        None
                    }
                    _ => None,
                }
            } else {
                None
            }
        }
        Expr::MapIndex { map, key: _ } => {
            // Map index returns the value type of the map
            if let Some(map_type) = infer_type(map) {
                match map_type {
                    Type::Map { value_type, .. } => {
                        Some(*value_type)
                    }
                    _ => None,
                }
            } else {
                None
            }
        }
        Expr::StructLiteral { struct_type, fields: _ } => {
            // Struct literal returns the struct type
            Some(Type::Struct {
                name: struct_type.clone(),
            })
        }
        Expr::Kotha { target_type } => {
            // kotha Type returns a pointer to that type
            Some(Type::Pointer(Box::new(target_type.clone())))
        }
        Expr::MapLiteral { key_type, value_type, entries: _ } => {
            // Map literal returns the map type
            Some(Type::Map {
                key_type: key_type.clone(),
                value_type: value_type.clone(),
            })
        }
        Expr::TypeCast { target_type, expr: _ } => {
            // Type cast returns the target type
            Some(target_type.clone())
        }
        Expr::Borrow { expr, mutable } => {
            // Borrow returns a reference type
            if let Some(inner_type) = infer_type(expr) {
                Some(Type::Reference {
                    inner: Box::new(inner_type),
                    mutable: *mutable,
                })
            } else {
                None
            }
        }
        Expr::Deref { expr } => {
            // Dereference returns the inner type of a reference/pointer
            if let Some(ref_type) = infer_type(expr) {
                match ref_type {
                    Type::Reference { inner, .. } => Some(*inner),
                    Type::Pointer(inner) => Some(*inner),
                    _ => None, // Can't dereference non-reference types
                }
            } else {
                None
            }
        }
        Expr::Jarugu { expr } => {
            // Jarugu returns the same type as the expression
            infer_type(expr)
        }
        Expr::TupleLiteral { elements } => {
            // Tuple literal returns a tuple type with inferred element types
            let types: Vec<Type> = elements.iter()
                .filter_map(infer_type)
                .collect();
            if types.len() == elements.len() {
                Some(Type::Tuple { types })
            } else {
                None // Can't infer all element types
            }
        }
        Expr::ErrorPropagate { expr } => {
            // Error propagation returns the non-error part of the expression's type
            // This is typically the inner type for a (value, error) tuple
            infer_type(expr)
        }
        Expr::MemberAssignment { object: _, field: _, value } => {
            // Member assignment returns the type of the assigned value
            infer_type(value)
        }
    }
}
