#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Int,
    Float,
    String,
    Bool,
    Void, // For functions that don't return a value
    Error, // Error type
    Pointer(Box<Type>), // Pointer type: *int, *float, etc.
    Reference {
        inner: Box<Type>,  // The type being referenced
        mutable: bool,     // true for &mut, false for &
    },
    Array {
        size: usize, // Array size (0 means size is inferred from literal)
        element_type: Box<Type>, // Element type
    },
    Slice {
        element_type: Box<Type>, // Element type
    },
    Struct {
        name: String, // Struct type name
    },
    Map {
        key_type: Box<Type>,   // Key type (typically string)
        value_type: Box<Type>, // Value type
    },
    /// Any type: nirmanam{} (for map values, e.g. jatha[string]nirmanam{})
    Any,
    Tuple {
        types: Vec<Type>, // Multiple types: (int, error)
    },
    /// Owned type with explicit lifetime (for advanced use)
    Owned {
        inner: Box<Type>,
        lifetime: Option<String>, // Named lifetime like 'a
    },
    /// Channel type: channel[elementType], unbuffered or buffered (capacity from initializer)
    Channel {
        element_type: Box<Type>,
    },
    /// WaitGroup: wait until N spawned tasks finish (Add(n), Done(), Wait())
    WaitGroup,
}

#[derive(Debug, Clone)]
pub enum Expr {
    Number(f64),
    String(String),
    Bool(bool),
    Nil, // Sunyam (nil value)
    Identifier(String),
    BinaryOp {
        op: BinaryOperator,
        left: Box<Expr>,
        right: Box<Expr>,
    },
    UnaryOp {
        op: UnaryOperator,
        expr: Box<Expr>,
    },
    FunctionCall {
        name: String,
        args: Vec<Expr>,
    },
    Assignment {
        name: String,
        value: Box<Expr>,
    },
    MemberAssignment {
        object: Box<Expr>,  // Object/struct expression
        field: String,      // Field name
        value: Box<Expr>,   // Value to assign
    },
    ErrorCheck {
        expr: Box<Expr>, // Expression that may return error
    },
    ArrayIndex {
        array: Box<Expr>, // Array expression
        index: Box<Expr>, // Index expression
    },
    ArrayLiteral {
        elements: Vec<Expr>, // Array elements
    },
    SliceExpr {
        array: Box<Expr>, // Array/slice expression
        start: Option<Box<Expr>>, // Start index (None = 0)
        end: Option<Box<Expr>>, // End index (None = length)
    },
    MemberAccess {
        object: Box<Expr>, // Object/struct expression
        field: String,     // Field name
    },
    MapIndex {
        map: Box<Expr>,    // Map expression
        key: Box<Expr>,    // Key expression
    },
    StructLiteral {
        struct_type: String,              // Struct type name
        fields: Vec<(String, Expr)>,     // Field name and value pairs
    },
    MapLiteral {
        key_type: Box<Type>,             // Key type
        value_type: Box<Type>,           // Value type
        entries: Vec<(Expr, Expr)>,      // Key-value pairs
    },
    TypeCast {
        target_type: Type,               // Target type (int, float, string, bool)
        expr: Box<Expr>,                 // Expression to convert
    },
    /// Borrow expression: &expr (immutable) or &mut expr (mutable)
    Borrow {
        expr: Box<Expr>,                 // Expression being borrowed
        mutable: bool,                   // true for &mut, false for &
    },
    /// Dereference expression: *expr
    Deref {
        expr: Box<Expr>,                 // Reference being dereferenced
    },
    /// Tuple literal: (expr1, expr2, ...)
    TupleLiteral {
        elements: Vec<Expr>,             // Tuple elements
    },
    /// Error propagation: expr?
    /// Memory allocation: nirmanam(Type)
    Kotha {
        target_type: Type,  // Type to allocate
    },
    ErrorPropagate {
        expr: Box<Expr>,                 // Expression that may return error
    },
    /// sunyam(ptr): free/release memory (same keyword as nil value)
    SunyamFree {
        expr: Box<Expr>,                  // Pointer expression to free
    },
    /// Channel send: ch <- value (move value into channel)
    ChannelSend {
        channel: Box<Expr>,
        value: Box<Expr>,
    },
    /// Channel receive: <- ch (value moves out of channel); also parsed as Jarugu when type is channel
    ChannelRecv {
        channel: Box<Expr>,
    },
    /// Spawn: tlang #name(args) — run function in new OS thread
    Spawn {
        name: String,
        args: Vec<Expr>,
    },
}

#[derive(Debug, Clone, PartialEq)]
pub enum BinaryOperator {
    Add,      // +
    Subtract, // -
    Multiply, // *
    Divide,   // /
    Modulo,   // %
    Power,    // ^
    Equal,    // ==
    NotEqual, // !=
    LessThan, // <
    GreaterThan, // >
    LessThanEqual, // <=
    GreaterThanEqual, // >=
    And,      // &&
    Or,       // ||
}

#[derive(Debug, Clone, PartialEq)]
pub enum UnaryOperator {
    Negate, // -
    Not,    // !
}

#[derive(Debug, Clone)]
pub enum Stmt {
    Expression(Expr),
    VariableDecl {
        name: String,
        type_annot: Option<Type>, // Go-style: var x int = 10 or var x = 10
        value: Option<Expr>,
        mutable: bool, // true for @!, false for @ (immutable by default)
    },
    Assignment {
        name: String,
        value: Expr,
    },
    MultiAssignment {
        names: Vec<String>, // Multiple variable names: @a, @b = func()
        value: Expr,        // Expression that returns multiple values
    },
    If {
        condition: Expr,
        then_block: Vec<Stmt>,
        else_block: Option<Vec<Stmt>>,
    },
    For {
        init: Option<Box<Stmt>>,
        condition: Option<Expr>,
        update: Option<Box<Stmt>>,
        body: Vec<Stmt>,
    },
    ForRange {
        key_var: String,           // Key variable name
        value_var: Option<String>, // Optional value variable name
        iterable: Expr,            // Map, slice, or array to iterate over
        body: Vec<Stmt>,
    },
    Return(Option<Expr>),
    Break,              // Break statement (agu)
    Continue,           // Continue statement (konasagu)
    Function {
        name: String,
        params: Vec<(String, Type)>, // (name, type) pairs
        return_type: Option<Type>,   // Return type (None = void)
        body: Vec<Stmt>,
        is_macro: bool,              // # prefix for macro functions
    },
    Block(Vec<Stmt>),
    Import {
        path: String, // Import path (e.g., "fmt", "./utils", "math")
        alias: Option<String>, // Optional alias (e.g., @m = #dhimpu("math"))
    },
    StructDef {
        name: String,                    // Struct name
        fields: Vec<(String, Type, Option<String>)>, // Field name, type, and optional tags (e.g., `json:"name" validate:"required"`)
    },
}

#[derive(Debug, Clone)]
pub struct Program {
    pub imports: Vec<ImportInfo>,     // Import statements (#dhimpu)
    pub statements: Vec<Stmt>,        // Other statements
}

#[derive(Debug, Clone)]
pub struct ImportInfo {
    pub path: String,      // Import path (e.g. "fmt", "./utils")
    pub alias: Option<String>, // Optional alias; recommended for clarity (e.g. @fmt = #dhimpu("fmt"))
}
