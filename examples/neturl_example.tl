// net/url library example
// Demonstrates network URL utilities

dhimpu "fmt" as fmt;
dhimpu "neturl" as neturl;

#prarambham() {
    fmt.Printf("=== net/url Library Examples ===\n\n");
    
    // Parse network URL
    fmt.Printf("--- URL Parsing ---\n");
    @url1 string = "https://user:pass@example.com:8080/api/users";
    @parsed1 string = neturl.Parse(url1);
    fmt.Printf("URL: %s\n", url1);
    fmt.Printf("Parsed: %s\n", parsed1);
    fmt.Printf("Format: scheme|user|host|port|path\n");
    
    @url2 string = "http://localhost:3000";
    @parsed2 string = neturl.Parse(url2);
    fmt.Printf("\nURL: %s\n", url2);
    fmt.Printf("Parsed: %s\n", parsed2);
    
    @url3 string = "https://admin@example.com/path";
    @parsed3 string = neturl.Parse(url3);
    fmt.Printf("\nURL: %s\n", url3);
    fmt.Printf("Parsed: %s\n", parsed3);
    
    // Extract hostname
    fmt.Printf("\n--- Extract Hostname ---\n");
    @url4 string = "https://example.com:8080/path";
    @hostname string = neturl.Hostname(url4);
    fmt.Printf("URL: %s\n", url4);
    fmt.Printf("Hostname: %s\n", hostname);
    
    @url5 string = "http://subdomain.example.com/api";
    @hostname2 string = neturl.Hostname(url5);
    fmt.Printf("\nURL: %s\n", url5);
    fmt.Printf("Hostname: %s\n", hostname2);
    
    // Extract port
    fmt.Printf("\n--- Extract Port ---\n");
    @url6 string = "https://example.com:8080/path";
    @port string = neturl.Port(url6);
    fmt.Printf("URL: %s\n", url6);
    fmt.Printf("Port: %s\n", port);
    
    @url7 string = "http://example.com/path";
    @port2 string = neturl.Port(url7);
    fmt.Printf("\nURL: %s\n", url7);
    fmt.Printf("Port: %s (empty if no port)\n", port2);
    
    // Create user info
    fmt.Printf("\n--- Create User Info ---\n");
    @user1 string = neturl.User("admin", "secret");
    @user2 string = neturl.User("guest", "");
    fmt.Printf("User with password: %s\n", user1);
    fmt.Printf("User without password: %s\n", user2);
    
    // Build URL with user info
    fmt.Printf("\n--- Build URL with User Info ---\n");
    @username string = "admin";
    @password string = "secret123";
    @host string = "example.com";
    @portNum string = "8080";
    @path string = "/api/data";
    @userInfo string = neturl.User(username, password);
    @fullURL string = fmt.Sprintf("https://%s@%s:%s%s", userInfo, host, portNum, path);
    fmt.Printf("Full URL: %s\n", fullURL);
}

//

//

//

// === OUTPUT ===
// === net/url Library Examples ===
//
// --- URL Parsing ---
// URL: https://user:pass@example.com:8080/api/users
// Parsed: https|user:pass|example.com|8080|/api/users
// Format: scheme|user|host|port|path
//
// URL: http://localhost:3000
// Parsed: http||localhost|3000|
//
// URL: https://admin@example.com/path
// Parsed: https|admin|example.com||/path
//
// --- Extract Hostname ---
// URL: https://example.com:8080/path
// Hostname: 8080
//
// URL: http://subdomain.example.com/api
// Hostname: /api
//
// --- Extract Port ---
// URL: https://example.com:8080/path
// Port: /path
//
// URL: http://example.com/path
// Port:  (empty if no port)
//
// --- Create User Info ---
// User with password: guest
// User without password: guest
//
// --- Build URL with User Info ---
// Full URL: https://admin:secret123@example.com:8080/api/data
//
