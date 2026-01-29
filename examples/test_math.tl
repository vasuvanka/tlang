// Test cases for math library

dhimpu "fmt" as fmt;
dhimpu "math" as math;

#prarambham() {
    fmt.Printf("=== math Library Tests ===\n");
    
    // Constants
    fmt.Printf("Pi: %f\n", math.Pi());
    fmt.Printf("E: %f\n", math.E());
    
    // Absolute value
    fmt.Printf("Abs(-5.5): %f\n", math.Abs(-5.5));
    fmt.Printf("Abs(5.5): %f\n", math.Abs(5.5));
    fmt.Printf("Abs(0): %f\n", math.Abs(0.0));
    
    // Max/Min
    fmt.Printf("Max(10, 20): %f\n", math.Max(10.0, 20.0));
    fmt.Printf("Max(-10, -20): %f\n", math.Max(-10.0, -20.0));
    fmt.Printf("Min(10, 20): %f\n", math.Min(10.0, 20.0));
    fmt.Printf("Min(-10, -20): %f\n", math.Min(-10.0, -20.0));
    
    // Square root
    fmt.Printf("Sqrt(16): %f\n", math.Sqrt(16.0));
    fmt.Printf("Sqrt(25): %f\n", math.Sqrt(25.0));
    fmt.Printf("Sqrt(2): %f\n", math.Sqrt(2.0));
    
    // Power
    fmt.Printf("Pow(2, 3): %f\n", math.Pow(2.0, 3.0));
    fmt.Printf("Pow(10, 2): %f\n", math.Pow(10.0, 2.0));
    fmt.Printf("Pow(2, 0.5): %f\n", math.Pow(2.0, 0.5));
    
    // Exponential
    fmt.Printf("Exp(1): %f\n", math.Exp(1.0));
    fmt.Printf("Exp(0): %f\n", math.Exp(0.0));
    fmt.Printf("Exp(2): %f\n", math.Exp(2.0));
    
    // Logarithms
    fmt.Printf("Log(e): %f\n", math.Log(math.E()));
    fmt.Printf("Log(1): %f\n", math.Log(1.0));
    fmt.Printf("Log10(100): %f\n", math.Log10(100.0));
    fmt.Printf("Log10(1000): %f\n", math.Log10(1000.0));
    
    // Trigonometric functions
    fmt.Printf("Sin(0): %f\n", math.Sin(0.0));
    fmt.Printf("Sin(Pi/2): %f\n", math.Sin(math.Pi() / 2.0));
    fmt.Printf("Cos(0): %f\n", math.Cos(0.0));
    fmt.Printf("Cos(Pi): %f\n", math.Cos(math.Pi()));
    fmt.Printf("Tan(0): %f\n", math.Tan(0.0));
    
    // Inverse trigonometric
    fmt.Printf("Asin(0): %f\n", math.Asin(0.0));
    fmt.Printf("Acos(1): %f\n", math.Acos(1.0));
    fmt.Printf("Atan(0): %f\n", math.Atan(0.0));
    
    // Rounding
    fmt.Printf("Ceil(3.1): %f\n", math.Ceil(3.1));
    fmt.Printf("Ceil(3.9): %f\n", math.Ceil(3.9));
    fmt.Printf("Ceil(-3.1): %f\n", math.Ceil(-3.1));
    fmt.Printf("Floor(3.1): %f\n", math.Floor(3.1));
    fmt.Printf("Floor(3.9): %f\n", math.Floor(3.9));
    fmt.Printf("Floor(-3.1): %f\n", math.Floor(-3.1));
    fmt.Printf("Round(3.4): %f\n", math.Round(3.4));
    fmt.Printf("Round(3.6): %f\n", math.Round(3.6));
    fmt.Printf("Trunc(3.7): %f\n", math.Trunc(3.7));
    fmt.Printf("Trunc(-3.7): %f\n", math.Trunc(-3.7));
}

//

//

//

// === OUTPUT ===
// === math Library Tests ===
// Pi: 3.141593
// E: 2.718282
// Abs(-5.5): 5.500000
// Abs(5.5): 5.500000
// Abs(0): 0.000000
// Max(10, 20): 20.000000
// Max(-10, -20): -10.000000
// Min(10, 20): 10.000000
// Min(-10, -20): -20.000000
// Sqrt(16): 4.000000
// Sqrt(25): 5.000000
// Sqrt(2): 1.414214
// Pow(2, 3): 8.000000
// Pow(10, 2): 100.000000
// Pow(2, 0.5): 1.414214
// Exp(1): 2.718282
// Exp(0): 1.000000
// Exp(2): 7.389056
// Log(e): 1.000000
// Log(1): 0.000000
// Log10(100): 2.000000
// Log10(1000): 3.000000
// Sin(0): 0.000000
// Sin(Pi/2): 1.000000
// Cos(0): 1.000000
// Cos(Pi): -1.000000
// Tan(0): 0.000000
// Asin(0): 0.000000
// Acos(1): 0.000000
// Atan(0): 0.000000
// Ceil(3.1): 4.000000
// Ceil(3.9): 4.000000
// Ceil(-3.1): -3.000000
// Floor(3.1): 3.000000
// Floor(3.9): 3.000000
// Floor(-3.1): -4.000000
// Round(3.4): 3.000000
// Round(3.6): 4.000000
// Trunc(3.7): 3.000000
// Trunc(-3.7): -3.000000
//
