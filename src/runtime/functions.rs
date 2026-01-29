// Runtime functions for print and input
// These will be linked as external functions in the compiled code

// Print function - outputs string to stdout
pub fn print_string(s: &str) {
    print!("{}", s);
}

// Print number function - outputs number to stdout
pub fn print_number(n: f64) {
    println!("{}", n);
}

// Input function - reads number from stdin
pub fn input_number() -> f64 {
    use std::io::{self, Write};
    io::stdout().flush().unwrap();
    
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("Failed to read input");
    input.trim().parse().unwrap_or(0.0)
}
