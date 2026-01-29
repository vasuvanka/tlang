# math - Mathematical Functions Library

The `math` library provides mathematical functions and constants, similar to Go's math package.

## Constants

### Pi

**`math.Pi()`** - Mathematical constant π

- Returns: 3.141592653589793

**Example:**
```tl
@pi float = math.Pi();
fmt.Printf("PI = %f\n", pi);
```

### E

**`math.E()`** - Mathematical constant e (Euler's number)

- Returns: 2.718281828459045

**Example:**
```tl
@e float = math.E();
fmt.Printf("E = %f\n", e);
```

## Basic Functions

### Abs

**`math.Abs(x)`** - Absolute value

- `x`: Number (int or float)
- Returns: Absolute value

**Example:**
```tl
@abs1 float = math.Abs(-5.5);   // 5.5
@abs2 float = math.Abs(3.14);   // 3.14
```

### Max

**`math.Max(a, b)`** - Maximum of two values

- `a`, `b`: Numbers to compare
- Returns: Maximum value

**Example:**
```tl
@max float = math.Max(10.0, 20.0);  // 20.0
```

### Min

**`math.Min(a, b)`** - Minimum of two values

- `a`, `b`: Numbers to compare
- Returns: Minimum value

**Example:**
```tl
@min float = math.Min(10.0, 20.0);  // 10.0
```

## Power and Roots

### Sqrt

**`math.Sqrt(x)`** - Square root

- `x`: Number (must be >= 0)
- Returns: Square root

**Example:**
```tl
@sqrt float = math.Sqrt(16.0);  // 4.0
```

### Pow

**`math.Pow(base, exp)`** - Power function

- `base`: Base number
- `exp`: Exponent
- Returns: base^exp

**Example:**
```tl
@power float = math.Pow(2.0, 3.0);  // 8.0 (2^3)
```

### Exp

**`math.Exp(x)`** - Exponential function (e^x)

- `x`: Exponent
- Returns: e^x

**Example:**
```tl
@exp float = math.Exp(1.0);  // ~2.718 (e^1)
```

## Logarithms

### Log

**`math.Log(x)`** - Natural logarithm (base e)

- `x`: Number (must be > 0)
- Returns: Natural logarithm

**Example:**
```tl
@log float = math.Log(math.E());  // 1.0
```

### Log10

**`math.Log10(x)`** - Base 10 logarithm

- `x`: Number (must be > 0)
- Returns: Base 10 logarithm

**Example:**
```tl
@log10 float = math.Log10(100.0);  // 2.0
```

## Trigonometric Functions

All trigonometric functions use radians.

### Sin

**`math.Sin(x)`** - Sine

- `x`: Angle in radians
- Returns: Sine value

**Example:**
```tl
@sin float = math.Sin(math.Pi() / 2.0);  // ~1.0
```

### Cos

**`math.Cos(x)`** - Cosine

- `x`: Angle in radians
- Returns: Cosine value

**Example:**
```tl
@cos float = math.Cos(0.0);  // 1.0
```

### Tan

**`math.Tan(x)`** - Tangent

- `x`: Angle in radians
- Returns: Tangent value

**Example:**
```tl
@tan float = math.Tan(math.Pi() / 4.0);  // ~1.0
```

### Asin

**`math.Asin(x)`** - Arc sine (inverse sine)

- `x`: Value between -1 and 1
- Returns: Angle in radians

**Example:**
```tl
@angle float = math.Asin(1.0);  // ~1.57 (π/2)
```

### Acos

**`math.Acos(x)`** - Arc cosine (inverse cosine)

- `x`: Value between -1 and 1
- Returns: Angle in radians

**Example:**
```tl
@angle float = math.Acos(1.0);  // 0.0
```

### Atan

**`math.Atan(x)`** - Arc tangent (inverse tangent)

- `x`: Any number
- Returns: Angle in radians

**Example:**
```tl
@angle float = math.Atan(1.0);  // ~0.785 (π/4)
```

## Rounding Functions

### Ceil

**`math.Ceil(x)`** - Ceiling (round up)

- `x`: Number
- Returns: Smallest integer >= x

**Example:**
```tl
@ceil float = math.Ceil(3.14);  // 4.0
```

### Floor

**`math.Floor(x)`** - Floor (round down)

- `x`: Number
- Returns: Largest integer <= x

**Example:**
```tl
@floor float = math.Floor(3.14);  // 3.0
```

### Round

**`math.Round(x)`** - Round to nearest integer

- `x`: Number
- Returns: Rounded value

**Example:**
```tl
@round1 float = math.Round(3.14);  // 3.0
@round2 float = math.Round(3.75);  // 4.0
```

### Trunc

**`math.Trunc(x)`** - Truncate (remove decimal part)

- `x`: Number
- Returns: Integer part

**Example:**
```tl
@trunc float = math.Trunc(3.14);  // 3.0
```

## Common Patterns

### Distance Calculation
```tl
#distance(x1 float, y1 float, x2 float, y2 float) float {
    @dx float = x2 - x1;
    @dy float = y2 - y1;
    mallinchu math.Sqrt(dx * dx + dy * dy);
}
```

### Converting Degrees to Radians
```tl
#degToRad(deg float) float {
    mallinchu deg * math.Pi() / 180.0;
}
```

### Circle Area
```tl
#circleArea(radius float) float {
    mallinchu math.Pi() * radius * radius;
}
```

## See Also

- [Tutorial - Lesson 8](tutorial.md#lesson-8-using-libraries)
- [Language Reference](language-reference.md)
