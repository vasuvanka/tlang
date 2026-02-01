// Test cases for time library

@fmt = #dhimpu("std/fmt");
@time = #dhimpu("std/time");

#prarambham() {
    fmt.Printf("=== time Library Tests ===\n");
    
    // Now test
    @now1 long = time.Now();
    fmt.Printf("Now (first call): %ld\n", now1);
    
    // Small delay
    time.SleepMilliseconds(10);
    
    @now2 long = time.Now();
    fmt.Printf("Now (after 10ms): %ld\n", now2);
    fmt.Printf("Time difference: %ld seconds\n", now2 - now1);
    
    // Format tests
    @formatted1 string = time.Format(now1, "%Y-%m-%d");
    @formatted2 string = time.Format(now1, "%H:%M:%S");
    @formatted3 string = time.Format(now1, "%Y-%m-%d %H:%M:%S");
    @formatted4 string = time.Format(now1, "%A, %B %d, %Y");
    
    fmt.Printf("Format('%%Y-%%m-%%d'): %s\n", formatted1);
    fmt.Printf("Format('%%H:%%M:%%S'): %s\n", formatted2);
    fmt.Printf("Format('%%Y-%%m-%%d %%H:%%M:%%S'): %s\n", formatted3);
    fmt.Printf("Format('%%A, %%B %%d, %%Y'): %s\n", formatted4);
    
    // Parse tests
    @testTime1 string = "2024-01-01 12:00:00";
    @parsed1 long = time.Parse(testTime1, "%Y-%m-%d %H:%M:%S");
    fmt.Printf("Parse('2024-01-01 12:00:00'): %ld\n", parsed1);
    
    @testTime2 string = "2024-12-25 00:00:00";
    @parsed2 long = time.Parse(testTime2, "%Y-%m-%d %H:%M:%S");
    fmt.Printf("Parse('2024-12-25 00:00:00'): %ld\n", parsed2);
    
    // Format the parsed time back
    @formattedBack string = time.Format(parsed1, "%Y-%m-%d %H:%M:%S");
    fmt.Printf("Formatted back: %s\n", formattedBack);
    
    // Sleep tests
    fmt.Printf("Sleeping 100ms...\n");
    @beforeSleep long = time.Now();
    time.SleepMilliseconds(100);
    @afterSleep long = time.Now();
    fmt.Printf("Slept for approximately %ld milliseconds\n", (afterSleep - beforeSleep) * 1000);
    
    fmt.Printf("Sleeping 1 second...\n");
    @beforeSleep2 long = time.Now();
    time.Sleep(1);
    @afterSleep2 long = time.Now();
    fmt.Printf("Slept for approximately %ld seconds\n", afterSleep2 - beforeSleep2);
}

//

//

//

// === OUTPUT ===
// === time Library Tests ===
// Now (first call): 1769532947
// Now (after 10ms): 1769532947
// Time difference: 0 seconds
// Format('%Y-%m-%d'): Tuesday, January 27, 2026
// Format('%H:%M:%S'): Tuesday, January 27, 2026
// Format('%Y-%m-%d %H:%M:%S'): Tuesday, January 27, 2026
// Format('%A, %B %d, %Y'): Tuesday, January 27, 2026
// Parse('2024-01-01 12:00:00'): 1704090600
// Parse('2024-12-25 00:00:00'): 1735065000
// Formatted back: 2024-01-01 12:00:00
// Sleeping 100ms...
// Slept for approximately 0 milliseconds
// Sleeping 1 second...
// Slept for approximately 1 seconds
//
