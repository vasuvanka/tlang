// Immutable variables example
// Demonstrates immutable variable declarations using @

@fmt = #dhimpu("std/fmt");

#prarambham() {
    // Immutable variables with explicit type
    @PI float = 3.14159;
    @MAX_SIZE int = 100;
    @APP_NAME string = "Tlang";
    @IS_DEBUG int = 1;

    // Immutable variables with type inference
    @E = 2.71828;
    @MIN_SIZE = 10;
    @GREETING = "Hello";

    fmt.Printf("PI: %f\n", PI);
    fmt.Printf("MAX_SIZE: %d\n", MAX_SIZE);
    fmt.Printf("APP_NAME: %s\n", APP_NAME);
    fmt.Printf("IS_DEBUG: %d\n", IS_DEBUG);
    fmt.Printf("E: %f\n", E);
    fmt.Printf("MIN_SIZE: %d\n", MIN_SIZE);
    fmt.Printf("GREETING: %s\n", GREETING);

    // Immutable variables cannot be reassigned
    // MAX_SIZE = 200; // This would cause a compilation error
}

//

//

//

//

//

// === OUTPUT ===
// PI: 3.141590
// MAX_SIZE: 100
// APP_NAME: Tlang
// IS_DEBUG: 1
// E: 2.718280
// MIN_SIZE: 10
// GREETING: Hello
//
