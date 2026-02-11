// Sample Rust file for tlang-port
use std::fmt;

fn main() {
    let x: i32 = 42;
    let mut y = 0;
    println!("x = {}", x);
    y += 1;
}

fn add(a: i32, b: i32) -> i32 {
    return a + b;
}

struct Point {
    x: f64,
    y: f64,
}
