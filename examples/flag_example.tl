// flag library example
// Demonstrates command-line flag parsing

dhimpu "fmt" as fmt;
dhimpu "flag" as flag;

#prarambham() {
    fmt.Printf("=== flag Library Examples ===\n\n");
    
    // Define flags (must be done before flag.Parse())
    @name string = flag.String("name", "Guest", "User name");
    @age int = flag.Int("age", 25, "User age");
    @port int = flag.Int("port", 8080, "Server port");
    @debug int = flag.Bool("debug", 0, "Enable debug mode");
    @verbose int = flag.Bool("verbose", 0, "Verbose output");
    @price float = flag.Float64("price", 9.99, "Product price");
    
    // Parse command-line arguments
    flag.Parse();
    
    // Get flag values
    fmt.Printf("--- Flag Values ---\n");
    @nameValue string = flag.GetString("name");
    @ageValue int = flag.GetInt("age");
    @portValue int = flag.GetInt("port");
    @debugValue int = flag.GetBool("debug");
    @verboseValue int = flag.GetBool("verbose");
    @priceValue float = flag.GetFloat64("price");
    
    fmt.Printf("Name: %s\n", nameValue);
    fmt.Printf("Age: %d\n", ageValue);
    fmt.Printf("Port: %d\n", portValue);
    fmt.Printf("Debug: %d\n", debugValue);
    fmt.Printf("Verbose: %d\n", verboseValue);
    fmt.Printf("Price: %.2f\n", priceValue);
    
    // Get non-flag arguments
    fmt.Printf("\n--- Non-Flag Arguments ---\n");
    @args string = flag.Args();
    fmt.Printf("Arguments:\n%s\n", args);
    
    // Example usage message
    fmt.Printf("\n--- Usage Example ---\n");
    fmt.Printf("Run with: ./program -name=Alice -age=30 -port=9090 -debug -price=19.99 file1.txt file2.txt\n");
    fmt.Printf("\nFlags:\n");
    fmt.Printf("  -name=value     User name (default: Guest)\n");
    fmt.Printf("  -age=value      User age (default: 25)\n");
    fmt.Printf("  -port=value     Server port (default: 8080)\n");
    fmt.Printf("  -debug          Enable debug mode\n");
    fmt.Printf("  -verbose        Verbose output\n");
    fmt.Printf("  -price=value    Product price (default: 9.99)\n");
}

//

//

//

//

//

// === OUTPUT ===
// === flag Library Examples ===
//
// --- Flag Values ---
// Name: Guest
// Age: 25
// Port: 8080
// Debug: 0
// Verbose: 0
// Price: 9.99
//
// --- Non-Flag Arguments ---
// Arguments:
// C:\Users\vanka\github.com\vasuvanka\tlang\output.exe
//
// --- Usage Example ---
// Run with: ./program -name=Alice -age=30 -port=9090 -debug -price=19.99 file1.txt file2.txt
//
// Flags:
//   -name=value     User name (default: Guest)
//   -age=value      User age (default: 25)
//   -port=value     Server port (default: 8080)
//   -debug          Enable debug mode
//   -verbose        Verbose output
//   -price=value    Product price (default: 9.99)
//
