// Real-World Example 2: File Processing Tool
// Processes log files, extracts statistics, and generates reports

dhimpu "fmt" as fmt;
dhimpu "io" as io;
dhimpu "strings" as strings;
dhimpu "time" as time;

nirmanam LogStats {
    total int;
    errors int;
    warnings int;
    info int;
}

// Simple log line parser (checks for log levels)
#processLogContent(content string) LogStats* {
    @stats LogStats* = kotha LogStats;
    okavela stats == sunyam {
        mallinchu sunyam;
    }
    
    stats.total = 0;
    stats.errors = 0;
    stats.warnings = 0;
    stats.info = 0;
    
    // Count occurrences of log levels in content
    malli (@!i int = 0; i < len(content) - 4; i = i + 1) {
        // Check for ERROR (5 chars)
        okavela i + 4 < len(content) {
            @substr string = "";  // Would extract substring here
            // Simplified: check character by character
            okavela content[i] == 'E' && content[i+1] == 'R' && content[i+2] == 'R' && content[i+3] == 'O' && content[i+4] == 'R' {
                stats.errors = stats.errors + 1;
                stats.total = stats.total + 1;
            } lekapothe okavela content[i] == 'W' && content[i+1] == 'A' && content[i+2] == 'R' && content[i+3] == 'N' {
                stats.warnings = stats.warnings + 1;
                stats.total = stats.total + 1;
            } lekapothe okavela content[i] == 'I' && content[i+1] == 'N' && content[i+2] == 'F' && content[i+3] == 'O' {
                stats.info = stats.info + 1;
                stats.total = stats.total + 1;
            }
        }
    }
    
    mallinchu stats;
}

// Generate report
#generateReport(stats LogStats*, outputFile string) {
    @report string = "Log File Analysis Report\n";
    report = report + "Generated: 2024-01-15 10:00:00\n\n";
    report = report + fmt.Sprintf("Total Entries: %d\n", stats.total);
    report = report + fmt.Sprintf("Errors:       %d\n", stats.errors);
    report = report + fmt.Sprintf("Warnings:     %d\n", stats.warnings);
    report = report + fmt.Sprintf("Info:         %d\n", stats.info);
    
    okavela stats.total > 0 {
        @errorRate float = (float)stats.errors * 100.0 / (float)stats.total;
        @warnRate float = (float)stats.warnings * 100.0 / (float)stats.total;
        report = report + fmt.Sprintf("\nError Rate:   %.2f%%\n", errorRate);
        report = report + fmt.Sprintf("Warning Rate: %.2f%%\n", warnRate);
    }
    
    io.WriteFile(outputFile, report);
    fmt.Printf("Report written to %s\n", outputFile);
}

#prarambham() {
    fmt.Printf("=== File Processing Tool ===\n\n");
    
    // Create sample log file
    @logContent string = "[2024-01-15 10:00:00] INFO: Application started\n";
    logContent = logContent + "[2024-01-15 10:01:00] WARN: High memory usage detected\n";
    logContent = logContent + "[2024-01-15 10:02:00] ERROR: Database connection failed\n";
    logContent = logContent + "[2024-01-15 10:03:00] INFO: Connection restored\n";
    logContent = logContent + "[2024-01-15 10:04:00] WARN: Slow query detected\n";
    logContent = logContent + "[2024-01-15 10:05:00] INFO: Request processed successfully\n";
    
    @logFile string = "app.log";
    io.WriteFile(logFile, logContent);
    fmt.Printf("Created sample log file: %s\n\n", logFile);
    
    // Process log file
    fmt.Printf("Processing log file...\n");
    @content string = io.ReadFile(logFile);
    @stats LogStats* = processLogContent(content);
    
    okavela stats != sunyam {
        fmt.Printf("\nStatistics:\n");
        fmt.Printf("  Total entries: %d\n", stats.total);
        fmt.Printf("  Errors:        %d\n", stats.errors);
        fmt.Printf("  Warnings:      %d\n", stats.warnings);
        fmt.Printf("  Info:          %d\n", stats.info);
        
        // Generate report
        generateReport(stats, "report.txt");
        
        free(stats);
    }
    
    fmt.Printf("\n=== Processing Complete ===\n");
}
