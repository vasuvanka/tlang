// Real-World Example 3: Data Processing Pipeline
// Reads CSV data, transforms it, and writes results

dhimpu "fmt" as fmt;
dhimpu "csv" as csv;
dhimpu "io" as io;
dhimpu "strconv" as strconv;
dhimpu "json" as json;

nirmanam Product {
    id int;
    name string;
    price float;
    category string;
    stock int;
}

nirmanam SalesReport {
    totalProducts int;
    totalValue float;
    categories int;
    lowStockItems int;
}

// Note: CSV parsing would use csv.ParseLine in production
// This example demonstrates the concept

// Process products and generate report
#processProducts(productCount int) SalesReport* {
    @report SalesReport* = kotha SalesReport;
    okavela report == sunyam {
        mallinchu sunyam;
    }
    
    // Simplified - would process actual products
    report.totalProducts = productCount;
    report.totalValue = 1500.0;  // Example value
    report.categories = 2;  // Electronics, Furniture
    report.lowStockItems = 1;  // Keyboard (stock: 5)
    
    mallinchu report;
}

// Generate JSON report
#generateJSONReport(report SalesReport*) string {
    @jsonStr string =         fmt.Sprintf("{\"totalProducts\":%d,\"totalValue\":%.2f,\"categories\":%d,\"lowStockItems\":%d}",
        report.totalProducts, report.totalValue, report.categories, report.lowStockItems);
    mallinchu jsonStr;
}

#prarambham() {
    fmt.Printf("=== Data Processing Pipeline ===\n\n");
    
    // Create sample CSV data
    @csvData string = "id|name|price|category|stock\n";
    csvData = csvData + "1|Laptop|999.99|Electronics|15\n";
    csvData = csvData + "2|Mouse|29.99|Electronics|50\n";
    csvData = csvData + "3|Desk|199.99|Furniture|8\n";
    csvData = csvData + "4|Chair|149.99|Furniture|12\n";
    csvData = csvData + "5|Monitor|299.99|Electronics|20\n";
    csvData = csvData + "6|Keyboard|79.99|Electronics|5\n";
    
    @inputFile string = "products.csv";
    csv.Write(inputFile, csvData);
    fmt.Printf("Created input file: %s\n\n", inputFile);
    
    // Read CSV
    fmt.Printf("Reading CSV file...\n");
    @content string = csv.Read(inputFile);
    fmt.Printf("CSV content:\n%s\n\n", content);
    
    // Count products (simplified - count lines minus header)
    @productCount int = 6;  // Would parse from CSV
    
    fmt.Printf("Found %d products\n\n", productCount);
    
    // Process data
    fmt.Printf("Processing data...\n");
    @report SalesReport* = processProducts(productCount);
    
    okavela report != sunyam {
        fmt.Printf("\nSales Report:\n");
        fmt.Printf("  Total Products:  %d\n", report.totalProducts);
        fmt.Printf("  Total Value:     $%.2f\n", report.totalValue);
        fmt.Printf("  Categories:      %d\n", report.categories);
        fmt.Printf("  Low Stock Items:  %d\n", report.lowStockItems);
        
        // Generate JSON output
        @jsonReport string = generateJSONReport(report);
        @outputFile string = "report.json";
        io.WriteFile(outputFile, jsonReport);
        fmt.Printf("\nJSON report written to %s\n", outputFile);
        fmt.Printf("Report content: %s\n", jsonReport);
        
        free(report);
    }
    
    fmt.Printf("\n=== Pipeline Complete ===\n");
}
