// math - Mathematical functions library
// Ported from Go's math package

pub fn generate_math_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <math.h>\n\n");
    
    // Constants
    code.push_str("// math.Pi - Pi constant\n");
    code.push_str("double math_Pi() { return 3.14159265358979323846; }\n\n");
    
    code.push_str("// math.E - Euler's number\n");
    code.push_str("double math_E() { return 2.71828182845904523536; }\n\n");
    
    // Basic operations
    code.push_str("// math.Abs - Absolute value\n");
    code.push_str("double math_Abs(double x) { return fabs(x); }\n\n");
    
    code.push_str("// math.Max - Maximum of two values\n");
    code.push_str("double math_Max(double x, double y) { return x > y ? x : y; }\n\n");
    
    code.push_str("// math.Min - Minimum of two values\n");
    code.push_str("double math_Min(double x, double y) { return x < y ? x : y; }\n\n");
    
    // Powers and roots
    code.push_str("// math.Sqrt - Square root\n");
    code.push_str("double math_Sqrt(double x) { return sqrt(x); }\n\n");
    
    code.push_str("// math.Pow - Power (x^y)\n");
    code.push_str("double math_Pow(double x, double y) { return pow(x, y); }\n\n");
    
    code.push_str("// math.Exp - e^x\n");
    code.push_str("double math_Exp(double x) { return exp(x); }\n\n");
    
    code.push_str("// math.Log - Natural logarithm\n");
    code.push_str("double math_Log(double x) { return log(x); }\n\n");
    
    code.push_str("// math.Log10 - Base 10 logarithm\n");
    code.push_str("double math_Log10(double x) { return log10(x); }\n\n");
    
    // Trigonometric functions
    code.push_str("// math.Sin - Sine\n");
    code.push_str("double math_Sin(double x) { return sin(x); }\n\n");
    
    code.push_str("// math.Cos - Cosine\n");
    code.push_str("double math_Cos(double x) { return cos(x); }\n\n");
    
    code.push_str("// math.Tan - Tangent\n");
    code.push_str("double math_Tan(double x) { return tan(x); }\n\n");
    
    code.push_str("// math.Asin - Arc sine\n");
    code.push_str("double math_Asin(double x) { return asin(x); }\n\n");
    
    code.push_str("// math.Acos - Arc cosine\n");
    code.push_str("double math_Acos(double x) { return acos(x); }\n\n");
    
    code.push_str("// math.Atan - Arc tangent\n");
    code.push_str("double math_Atan(double x) { return atan(x); }\n\n");
    
    code.push_str("// math.Atan2 - Arc tangent of y/x\n");
    code.push_str("double math_Atan2(double y, double x) { return atan2(y, x); }\n\n");
    
    // Rounding functions
    code.push_str("// math.Ceil - Ceiling (round up)\n");
    code.push_str("double math_Ceil(double x) { return ceil(x); }\n\n");
    
    code.push_str("// math.Floor - Floor (round down)\n");
    code.push_str("double math_Floor(double x) { return floor(x); }\n\n");
    
    code.push_str("// math.Round - Round to nearest integer\n");
    code.push_str("double math_Round(double x) { return round(x); }\n\n");
    
    code.push_str("// math.Trunc - Truncate (remove fractional part)\n");
    code.push_str("double math_Trunc(double x) { return trunc(x); }\n\n");
    
    code
}
