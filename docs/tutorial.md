# Tlang Tutorial - Step by Step

This tutorial will teach you Tlang from the ground up, with practical examples at each step.

## Table of Contents

1. [Lesson 1: Hello World](#lesson-1-hello-world)
2. [Lesson 2: Variables and Types](#lesson-2-variables-and-types)
3. [Lesson 3: Basic Operations](#lesson-3-basic-operations)
4. [Lesson 4: Functions](#lesson-4-functions)
5. [Lesson 5: Conditionals](#lesson-5-conditionals)
6. [Lesson 6: Loops](#lesson-6-loops)
7. [Lesson 7: Strings](#lesson-7-strings)
8. [Lesson 8: Using Libraries](#lesson-8-using-libraries)
9. [Lesson 9: File I/O](#lesson-9-file-io)
10. [Lesson 10: Building a Complete Program](#lesson-10-building-a-complete-program)

---

## Lesson 1: Hello World

### Your First Program

Create `hello.tl`:

```tl
#prarambham() {
    fmt.Printf("Hello, World!\n");
}
```

**Key Concepts:**
- `#prarambham()` is the entry point (like `main` in C/Go)
- `fmt.Printf` is a library function for formatted output
- `\n` creates a newline

**Compile and Run:**
```bash
tlangc hello.tl
gcc output.c -o hello
./hello
```

### Exercise 1.1
Modify the program to print your name.

---

## Lesson 2: Variables and Types

### Declaring Variables

Use `@` to declare variables:

```tl
#prarambham() {
    @name string = "Tlang";
    @age int = 5;
    @height float = 1.75;
    @isActive int = 1;  // 1 for true, 0 for false
    
    fmt.Printf("Name: %s, Age: %d, Height: %.2f\n", name, age, height);
}
```

### Type Inference

You can omit the type - Tlang will infer it:

```tl
#prarambham() {
    @x = 10;        // int
    @y = 3.14;      // float
    @z = "hello";   // string
    @b = 1;         // int (use 1/0 for boolean)
}
```

### Constants

Use regular `@` variables for constants (they're immutable):

```tl
#prarambham() {
    @PI float = 3.14159;
    @APP_NAME string = "MyApp";
    
    fmt.Printf("PI = %f\n", PI);
}
```

### Exercise 2.1
Create variables for your name, age, and city. Print them.

---

## Lesson 3: Basic Operations

### Arithmetic Operations

```tl
#prarambham() {
    @a int = 10;
    @b int = 3;
    
    fmt.Printf("a + b = %d\n", a + b);  // 13
    fmt.Printf("a - b = %d\n", a - b);  // 7
    fmt.Printf("a * b = %d\n", a * b);  // 30
    fmt.Printf("a / b = %d\n", a / b);  // 3
    fmt.Printf("a %% b = %d\n", a % b); // 1 (modulo)
}
```

### Comparison Operators

```tl
#prarambham() {
    @x int = 10;
    @y int = 20;
    
    fmt.Printf("x == y: %d\n", x == y);  // 0 (false)
    fmt.Printf("x != y: %d\n", x != y);  // 1 (true)
    fmt.Printf("x < y: %d\n", x < y);    // 1 (true)
    fmt.Printf("x > y: %d\n", x > y);    // 0 (false)
    fmt.Printf("x <= y: %d\n", x <= y);  // 1 (true)
    fmt.Printf("x >= y: %d\n", x >= y);  // 0 (false)
}
```

### Exercise 3.1
Calculate the area of a circle (radius = 5). Use `math.Pi()` for π.

---

## Lesson 4: Functions

### Simple Function

```tl
#greet(name string) {
    fmt.Printf("Hello, %s!\n", name);
}

#prarambham() {
    greet("Alice");
    greet("Bob");
}
```

### Function with Return Value

```tl
#add(a int, b int) int {
    mallinchu a + b;
}

#prarambham() {
    @result int = add(5, 3);
    fmt.Printf("5 + 3 = %d\n", result);
}
```

### Multiple Return Values

```tl
#divide(a int, b int) (int, int) {
    mallinchu a / b, a % b;
}

#prarambham() {
    @quotient int = 0;
    @remainder int = 0;
    quotient, remainder = divide(10, 3);
    fmt.Printf("10 / 3 = %d remainder %d\n", quotient, remainder);
}
```

### Exercise 4.1
Write a function `square(x int) int` that returns x².

---

## Lesson 5: Conditionals

### Basic If-Else

```tl
#prarambham() {
    @age int = 20;
    
    okavela age >= 18 {
        fmt.Printf("You are an adult\n");
    } lekapothe {
        fmt.Printf("You are a minor\n");
    }
}
```

### Multiple Conditions

```tl
#prarambham() {
    @score int = 85;
    
    okavela score >= 90 {
        fmt.Printf("Grade: A\n");
    } lekapothe okavela score >= 80 {
        fmt.Printf("Grade: B\n");
    } lekapothe okavela score >= 70 {
        fmt.Printf("Grade: C\n");
    } lekapothe {
        fmt.Printf("Grade: F\n");
    }
}
```

### Exercise 5.1
Write a program that checks if a number is even or odd.

---

## Lesson 6: Loops

### For Loop

```tl
#prarambham() {
    @i int = 0;
    malli i < 5; i = i + 1 {
        fmt.Printf("Count: %d\n", i);
    }
}
```

### Loop with Break

```tl
#prarambham() {
    @i int = 0;
    malli i < 10; i = i + 1 {
        okavela i == 5 {
            agu;  // break
        }
        fmt.Printf("%d\n", i);
    }
}
```

### Loop with Continue

```tl
#prarambham() {
    @i int = 0;
    malli i < 10; i = i + 1 {
        okavela i % 2 == 0 {
            konasagu;  // continue (skip even numbers)
        }
        fmt.Printf("%d\n", i);  // Only odd numbers
    }
}
```

### Exercise 6.1
Print the first 10 Fibonacci numbers.

---

## Lesson 7: Strings

### String Operations

```tl
#prarambham() {
    @text string = "Hello World";
    
    // Check if contains
    @hasHello int = strings.Contains(text, "Hello");
    fmt.Printf("Contains 'Hello': %d\n", hasHello);
    
    // Convert case
    @upper string = strings.ToUpper(text);
    @lower string = strings.ToLower(text);
    fmt.Printf("Upper: %s\n", upper);
    fmt.Printf("Lower: %s\n", lower);
    
    // Find index
    @index int = strings.Index(text, "World");
    fmt.Printf("Index of 'World': %d\n", index);
}
```

### String Formatting

```tl
#prarambham() {
    @name string = "Alice";
    @age int = 30;
    @height float = 1.65;
    
    @message string = fmt.Sprintf("Name: %s, Age: %d, Height: %.2f", name, age, height);
    fmt.Printf("%s\n", message);
}
```

### Exercise 7.1
Write a function that reverses a string (hint: use a loop).

---

## Lesson 8: Using Libraries

### Math Library

```tl
#prarambham() {
    @x float = 16.0;
    @sqrt float = math.Sqrt(x);
    @power float = math.Pow(2.0, 3.0);
    @pi float = math.Pi();
    
    fmt.Printf("sqrt(16) = %f\n", sqrt);
    fmt.Printf("2^3 = %f\n", power);
    fmt.Printf("PI = %f\n", pi);
}
```

### Time Library

```tl
#prarambham() {
    @now int = time.Now();
    fmt.Printf("Current timestamp: %d\n", now);
    
    @formatted string = time.Format(now, "%Y-%m-%d %H:%M:%S");
    fmt.Printf("Formatted: %s\n", formatted);
    
    time.Sleep(1);  // Sleep for 1 second
    fmt.Printf("Slept for 1 second\n");
}
```

### Exercise 8.1
Calculate the distance between two points using the distance formula.

---

## Lesson 9: File I/O

### Reading Files

```tl
#prarambham() {
    @content string = io.ReadFile("data.txt");
    fmt.Printf("File content:\n%s\n", content);
}
```

### Writing Files

```tl
#prarambham() {
    @data string = "Hello from Tlang!\nThis is a test file.";
    @written int = io.WriteFile("output.txt", data);
    fmt.Printf("Wrote %d bytes\n", written);
}
```

### Checking File Existence

```tl
#prarambham() {
    @filename string = "config.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 1 {
        fmt.Printf("File exists\n");
        @content string = io.ReadFile(filename);
        fmt.Printf("Content: %s\n", content);
    } lekapothe {
        fmt.Printf("File does not exist\n");
    }
}
```

### Exercise 9.1
Write a program that reads a file, counts the lines, and writes the count to another file.

---

## Lesson 10: Building a Complete Program

Let's build a simple text analyzer:

```tl
#countWords(text string) int {
    @count int = 0;
    @i int = 0;
    @inWord int = 0;
    
    malli i < strings.Index(text, ""); i = i + 1 {
        @ch string = "";
        // Simplified: count spaces + 1
        // In real implementation, would parse properly
    }
    
    // Simple word count: count spaces + 1
    @spaceCount int = 0;
    @j int = 0;
    malli j < strings.Index(text, ""); j = j + 1 {
        // Count spaces (simplified)
    }
    
    mallinchu spaceCount + 1;
}

#prarambham() {
    fmt.Printf("=== Text Analyzer ===\n\n");
    
    @filename string = "input.txt";
    @exists int = io.Exists(filename);
    
    okavela exists == 0 {
        fmt.Printf("Error: File '%s' not found\n", filename);
        mallinchu;
    }
    
    @content string = io.ReadFile(filename);
    @upper string = strings.ToUpper(content);
    @lower string = strings.ToLower(content);
    
    fmt.Printf("Original length: %d characters\n", strings.Index(content, ""));
    fmt.Printf("Uppercase: %s\n", upper);
    fmt.Printf("Lowercase: %s\n", lower);
    
    // Check if contains specific words
    @hasHello int = strings.Contains(content, "hello");
    okavela hasHello == 1 {
        fmt.Printf("Text contains 'hello'\n");
    }
}
```

### Exercise 10.1
Extend the text analyzer to:
1. Count the number of sentences (ends with `.`, `!`, or `?`)
2. Find the longest word
3. Write a summary to a file

---

## Next Steps

Congratulations! You've completed the Tlang tutorial. Now you can:

1. **Explore More Examples**: Check the `examples/` directory
2. **Read the Reference**: See [Language Reference](language-reference.md)
3. **Learn Libraries**: Explore [Standard Library](standard-library.md)
4. **Concurrency**: Use channels (`ch <- value`, `@x = <- ch`), spawn (`tlang #fn(args)` runs in a new thread on Unix), and WaitGroup (`@wg WaitGroup;` `wg.Add(n)`, `wg.Done()`, `wg.Wait()`). See [Concurrency Architecture & Patterns](concurrency-architecture-suggestions.md).
5. **Build Projects**: Start building your own programs!

## Practice Projects

1. **Calculator**: Build a simple calculator with functions
2. **File Manager**: Create a program that lists and manages files
3. **Text Processor**: Build a tool that processes text files
4. **Number Games**: Create number guessing games or math puzzles
5. **Data Logger**: Build a program that logs data to files

Happy coding! 🚀
