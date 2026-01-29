// Example Go code to demonstrate porting to Tlang
package main

import "fmt"

type Person struct {
    Name string
    Age  int
}

func main() {
    var x int = 10
    var y float64 = 3.14
    fmt.Printf("x = %d, y = %f\n", x, y)
    
    p := Person{Name: "Alice", Age: 30}
    fmt.Printf("Person: %s, %d\n", p.Name, p.Age)
    
    result, err := divide(10, 2)
    if err != nil {
        fmt.Printf("Error: %s\n", err)
        return
    }
    fmt.Printf("Result: %d\n", result)
}

func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}
