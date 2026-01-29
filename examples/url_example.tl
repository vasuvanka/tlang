// url library example
// Demonstrates URL parsing and manipulation

dhimpu "fmt" as fmt;
dhimpu "url" as url;

#prarambham() {
    fmt.Printf("=== url Library Examples ===\n\n");
    
    // URL Parsing
    fmt.Printf("--- URL Parsing ---\n");
    @url1 string = "https://example.com/path/to/resource?query=value&key=123";
    @parsed1 string = url.Parse(url1);
    fmt.Printf("URL: %s\n", url1);
    fmt.Printf("Parsed: %s\n", parsed1);
    fmt.Printf("Format: scheme|host|path|query\n");
    
    @url2 string = "http://localhost:8080/api/users?id=1";
    @parsed2 string = url.Parse(url2);
    fmt.Printf("\nURL: %s\n", url2);
    fmt.Printf("Parsed: %s\n", parsed2);
    
    @url3 string = "https://example.com";
    @parsed3 string = url.Parse(url3);
    fmt.Printf("\nURL: %s\n", url3);
    fmt.Printf("Parsed: %s\n", parsed3);
    
    // Query Escaping
    fmt.Printf("\n--- Query Escaping ---\n");
    @query1 string = "hello world";
    @escaped1 string = url.QueryEscape(query1);
    fmt.Printf("Original: %s\n", query1);
    fmt.Printf("Escaped: %s\n", escaped1);
    
    @query2 string = "user@example.com";
    @escaped2 string = url.QueryEscape(query2);
    fmt.Printf("\nOriginal: %s\n", query2);
    fmt.Printf("Escaped: %s\n", escaped2);
    
    @query3 string = "price=$100&discount=10%";
    @escaped3 string = url.QueryEscape(query3);
    fmt.Printf("\nOriginal: %s\n", query3);
    fmt.Printf("Escaped: %s\n", escaped3);
    
    // Query Unescaping
    fmt.Printf("\n--- Query Unescaping ---\n");
    @escapedQuery string = "hello%20world";
    @unescaped string = url.QueryUnescape(escapedQuery);
    fmt.Printf("Escaped: %s\n", escapedQuery);
    fmt.Printf("Unescaped: %s\n", unescaped);
    
    @escapedQuery2 string = "user%40example.com";
    @unescaped2 string = url.QueryUnescape(escapedQuery2);
    fmt.Printf("\nEscaped: %s\n", escapedQuery2);
    fmt.Printf("Unescaped: %s\n", unescaped2);
    
    // Path Escaping
    fmt.Printf("\n--- Path Escaping ---\n");
    @path1 string = "user profile";
    @pathEscaped1 string = url.PathEscape(path1);
    fmt.Printf("Original: %s\n", path1);
    fmt.Printf("Escaped: %s\n", pathEscaped1);
    
    @path2 string = "file name.txt";
    @pathEscaped2 string = url.PathEscape(path2);
    fmt.Printf("\nOriginal: %s\n", path2);
    fmt.Printf("Escaped: %s\n", pathEscaped2);
    
    // Path Unescaping
    fmt.Printf("\n--- Path Unescaping ---\n");
    @escapedPath string = "user%20profile";
    @pathUnescaped string = url.PathUnescape(escapedPath);
    fmt.Printf("Escaped: %s\n", escapedPath);
    fmt.Printf("Unescaped: %s\n", pathUnescaped);
    
    // Join Path
    fmt.Printf("\n--- Join Path ---\n");
    @base1 string = "https://example.com";
    @path3 string = "/api/users";
    @joined1 string = url.JoinPath(base1, path3);
    fmt.Printf("Base: %s\n", base1);
    fmt.Printf("Path: %s\n", path3);
    fmt.Printf("Joined: %s\n", joined1);
    
    @base2 string = "https://example.com/";
    @path4 string = "api/users";
    @joined2 string = url.JoinPath(base2, path4);
    fmt.Printf("\nBase: %s\n", base2);
    fmt.Printf("Path: %s\n", path4);
    fmt.Printf("Joined: %s\n", joined2);
    
    @base3 string = "https://example.com/api";
    @path5 string = "/users";
    @joined3 string = url.JoinPath(base3, path5);
    fmt.Printf("\nBase: %s\n", base3);
    fmt.Printf("Path: %s\n", path5);
    fmt.Printf("Joined: %s\n", joined3);
    
    // Practical example: Building URLs
    fmt.Printf("\n--- Practical Example: Building URLs ---\n");
    @baseURL string = "https://api.example.com";
    @endpoint string = "/v1/users";
    @userID string = "123";
    @fullPath string = url.JoinPath(url.JoinPath(baseURL, endpoint), userID);
    @queryParam string = url.QueryEscape("John Doe");
    @finalURL string = fmt.Sprintf("%s?name=%s", fullPath, queryParam);
    fmt.Printf("Base: %s\n", baseURL);
    fmt.Printf("Endpoint: %s\n", endpoint);
    fmt.Printf("User ID: %s\n", userID);
    fmt.Printf("Query: name=John Doe\n");
    fmt.Printf("Final URL: %s\n", finalURL);
}

//

//

//

// === OUTPUT ===
// === url Library Examples ===
//
// --- URL Parsing ---
// URL: https://example.com/path/to/resource?query=value&key=123
// Parsed: https|example.com|/path/to/resource|query=value&key=123
// Format: scheme|host|path|query
//
// URL: http://localhost:8080/api/users?id=1
// Parsed: http|localhost:8080|/api/users|id=1
//
// URL: https://example.com
// Parsed: https|example.com||
//
// --- Query Escaping ---
// Original: hello world
// Escaped: hello%20world
//
// Original: user@example.com
// Escaped: user%40example.com
//
// Original: price=$100&discount=10%
// Escaped: price%3D%24100%26discount%3D10%25
//
// --- Query Unescaping ---
// Escaped: hello%20world
// Unescaped: hello world
//
// Escaped: user%40example.com
// Unescaped: user@example.com
//
// --- Path Escaping ---
// Original: user profile
// Escaped: user%20profile
//
// Original: file name.txt
// Escaped: file%20name.txt
//
// --- Path Unescaping ---
// Escaped: user%20profile
// Unescaped: user profile
//
// --- Join Path ---
// Base: https://example.com
// Path: /api/users
// Joined: https://example.com/api/users
//
// Base: https://example.com/
// Path: api/users
// Joined: https://example.com/api/users
//
// Base: https://example.com/api
// Path: /users
// Joined: https://example.com/api/users
//
// --- Practical Example: Building URLs ---
// Base: https://api.example.com
// Endpoint: /v1/users
// User ID: 123
// Query: name=John Doe
// Final URL: 123?name=John%20Doe
//
