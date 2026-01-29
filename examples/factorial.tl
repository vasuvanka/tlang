// Factorial calculation example - Go-style
// Demonstrates functions with explicit types

dhimpu "fmt" as fmt;

#factorial(n int) int {
    okavela n <= 1 {
        mallinchu 1;
    }
    mallinchu n * factorial(n - 1);
}

#prarambham() {
    @num int = 5;
    @result int = factorial(num);
    
    fmt.Printf("Factorial of %d is %d\n", num, result);
}

//

//

//

//

//

// === OUTPUT ===
// Factorial of 5 is 120
//
