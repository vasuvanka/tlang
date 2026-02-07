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
            // nirmanam(Type) returns a pointer to that type
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
        Expr::ChannelRecv { channel } => {
            // <- ch returns the channel's element type
            if let Some(crate::ast::Type::Channel { element_type }) = infer_type(channel) {
                Some(*element_type)
            } else {
                // Move: same type as the source expression
                infer_type(channel)
            }
        }
        Expr::ChannelSend { channel: _, value } => infer_type(value), // statement-like; type is unit/ignored
        Expr::Spawn { name: _, args: _ } => None, // spawn returns void for now
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
            // ? unwraps (value, error) to just value for assignment
            if let Some(crate::ast::Type::Tuple { types }) = infer_type(expr) {
                if types.len() >= 2 {
                    return Some(types[0].clone());
                }
            }
            infer_type(expr)
        }
        Expr::SunyamFree { expr: _ } => None, // sunyam(ptr) is void (free)
        Expr::MemberAssignment { object: _, field: _, value } => {
            // Member assignment returns the type of the assigned value
            infer_type(value)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ast::{BinaryOperator, UnaryOperator};

    #[test]
    fn test_infer_number_int() {
        let expr = Expr::Number(42.0);
        assert_eq!(infer_type(&expr), Some(Type::Int));
    }

    #[test]
    fn test_infer_number_float() {
        let expr = Expr::Number(3.14);
        assert_eq!(infer_type(&expr), Some(Type::Float));
    }

    #[test]
    fn test_infer_string() {
        let expr = Expr::String("hello".to_string());
        assert_eq!(infer_type(&expr), Some(Type::String));
    }

    #[test]
    fn test_infer_bool() {
        let expr = Expr::Bool(true);
        assert_eq!(infer_type(&expr), Some(Type::Bool));
    }

    #[test]
    fn test_infer_nil() {
        let expr = Expr::Nil;
        assert_eq!(infer_type(&expr), Some(Type::Error));
    }

    #[test]
    fn test_infer_identifier_returns_none() {
        let expr = Expr::Identifier("x".to_string());
        assert_eq!(infer_type(&expr), None);
    }

    #[test]
    fn test_infer_binary_op_same_type() {
        let expr = Expr::BinaryOp {
            op: BinaryOperator::Add,
            left: Box::new(Expr::Number(1.0)),
            right: Box::new(Expr::Number(2.0)),
        };
        assert_eq!(infer_type(&expr), Some(Type::Int));
    }

    #[test]
    fn test_infer_binary_op_int_float_promotes_to_float() {
        let expr = Expr::BinaryOp {
            op: BinaryOperator::Add,
            left: Box::new(Expr::Number(1.0)),
            right: Box::new(Expr::Number(2.5)),
        };
        assert_eq!(infer_type(&expr), Some(Type::Float));
    }

    #[test]
    fn test_infer_unary_op() {
        let expr = Expr::UnaryOp {
            op: UnaryOperator::Not,
            expr: Box::new(Expr::Bool(false)),
        };
        assert_eq!(infer_type(&expr), Some(Type::Bool));
    }

    #[test]
    fn test_infer_array_literal() {
        let expr = Expr::ArrayLiteral {
            elements: vec![
                Expr::Number(1.0),
                Expr::Number(2.0),
                Expr::Number(3.0),
            ],
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Array {
                size: 3,
                element_type: Box::new(Type::Int),
            })
        );
    }

    #[test]
    fn test_infer_empty_array_literal_returns_none() {
        let expr = Expr::ArrayLiteral { elements: vec![] };
        assert_eq!(infer_type(&expr), None);
    }

    #[test]
    fn test_infer_struct_literal() {
        let expr = Expr::StructLiteral {
            struct_type: "Point".to_string(),
            fields: vec![
                ("x".to_string(), Expr::Number(0.0)),
                ("y".to_string(), Expr::Number(0.0)),
            ],
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Struct {
                name: "Point".to_string(),
            })
        );
    }

    #[test]
    fn test_infer_type_cast() {
        let expr = Expr::TypeCast {
            target_type: Type::Float,
            expr: Box::new(Expr::Number(1.0)),
        };
        assert_eq!(infer_type(&expr), Some(Type::Float));
    }

    #[test]
    fn test_infer_map_literal() {
        let expr = Expr::MapLiteral {
            key_type: Box::new(Type::String),
            value_type: Box::new(Type::Int),
            entries: vec![],
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Map {
                key_type: Box::new(Type::String),
                value_type: Box::new(Type::Int),
            })
        );
    }

    #[test]
    fn test_infer_borrow() {
        let expr = Expr::Borrow {
            expr: Box::new(Expr::String("x".to_string())),
            mutable: false,
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Reference {
                inner: Box::new(Type::String),
                mutable: false,
            })
        );
    }

    #[test]
    fn test_infer_deref_identifier_returns_none() {
        let expr = Expr::Deref {
            expr: Box::new(Expr::Identifier("p".to_string())),
        };
        assert_eq!(infer_type(&expr), None);
    }

    #[test]
    fn test_infer_deref_pointer_returns_inner() {
        let ptr_expr = Expr::Kotha {
            target_type: Type::Int,
        };
        let deref_expr = Expr::Deref {
            expr: Box::new(ptr_expr),
        };
        assert_eq!(infer_type(&deref_expr), Some(Type::Int));
    }

    #[test]
    fn test_infer_kotha_returns_pointer() {
        let expr = Expr::Kotha {
            target_type: Type::String,
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Pointer(Box::new(Type::String)))
        );
    }

    #[test]
    fn test_infer_tuple_literal() {
        let expr = Expr::TupleLiteral {
            elements: vec![
                Expr::Number(1.0),
                Expr::String("a".to_string()),
            ],
        };
        assert_eq!(
            infer_type(&expr),
            Some(Type::Tuple {
                types: vec![Type::Int, Type::String],
            })
        );
    }
}
