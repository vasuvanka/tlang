# rand - Random Number Generation Library

The `rand` library provides random number generation, UUID creation, and random string generation.

## Functions

### Random Numbers

**`rand.Int()`** - Random integer

- Returns: Random integer value
- Uses system random number generator

**Example:**
```tl
@random int = rand.Int();
fmt.Printf("Random: %d\n", random);
```

**`rand.Intn(n)`** - Random integer in range [0, n)

- `n`: Upper bound (exclusive)
- Returns: Random integer from 0 to n-1

**Example:**
```tl
@dice int = rand.Intn(6) + 1;  // 1-6
@lottery int = rand.Intn(100);  // 0-99
```

**`rand.Float64()`** - Random float in [0.0, 1.0)

- Returns: Random float between 0.0 (inclusive) and 1.0 (exclusive)

**Example:**
```tl
@percent float = rand.Float64() * 100.0;  // 0-100
```

**`rand.Float64Range(min, max)`** - Random float in range [min, max)

- `min`: Minimum value (inclusive)
- `max`: Maximum value (exclusive)
- Returns: Random float in the specified range

**Example:**
```tl
@temp float = rand.Float64Range(20.0, 30.0);  // 20-30
```

### Seeding

**`rand.Seed(seed)`** - Seed random number generator

- `seed`: Integer seed value
- Same seed produces same sequence of random numbers
- Useful for reproducible tests or simulations

**Example:**
```tl
rand.Seed(42);
@value1 int = rand.Intn(100);
rand.Seed(42);  // Reset
@value2 int = rand.Intn(100);
// value1 and value2 will be the same
```

### UUID Generation

**`rand.UUID()`** - Generate UUID v4 (random UUID)

- Returns: UUID string in format `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`
- Format: 36 characters (32 hex digits + 4 dashes)
- Version 4 (random) UUID

**Example:**
```tl
@id string = rand.UUID();
fmt.Printf("UUID: %s\n", id);
// Output: 550e8400-e29b-41d4-a716-446655440000
```

### Random Strings

**`rand.RandomString(length)`** - Generate random string of given length

- `length`: Desired string length
- Returns: Random string containing lowercase, uppercase, and digits
- Characters: `a-z`, `A-Z`, `0-9` (62 possible characters)
- Maximum length: 1023 characters

**Example:**
```tl
@password string = rand.RandomString(16);
@sessionId string = rand.RandomString(32);
fmt.Printf("Password: %s\n", password);
```

## Common Patterns

### Generate Session ID
```tl
@sessionId string = rand.RandomString(32);
```

### Generate Transaction ID
```tl
@txnId string = rand.UUID();
```

### Generate Password
```tl
@password string = rand.RandomString(16);
```

### Simulate Dice Roll
```tl
@dice int = rand.Intn(6) + 1;  // 1-6
```

### Random Percentage
```tl
@percent float = rand.Float64() * 100.0;
```

### Random Selection
```tl
@index int = rand.Intn(choicesCount);
```

## Notes

- Random number generator is automatically seeded with current time on first use
- Use `rand.Seed()` for reproducible sequences (useful for testing)
- UUID format follows RFC 4122 version 4 specification
- Random strings use alphanumeric characters (a-z, A-Z, 0-9)
- All functions are thread-safe (use static buffers for string returns)

## See Also

- [Examples](../examples.md)
- [Language Reference](../language-reference.md)
