// Network Utilities Example
// Demonstrates DNS resolution and socket operations

dhimpu "fmt" as fmt;
dhimpu "net" as net;

#prarambham() {
    fmt.Printf("=== Network Utilities Examples ===\n\n");
    
    // ============================================
    // Test 1: DNS Resolution
    // ============================================
    fmt.Printf("--- Test 1: DNS Resolution ---\n");
    @hostname string = "google.com";
    fmt.Printf("Resolving: %s\n", hostname);
    
    @ip string = net.ResolveHost(hostname);
    okavela ip != sunyam {
        fmt.Printf("IP Address: %s\n", ip);
    } lekapothe {
        fmt.Printf("Error: Failed to resolve hostname\n");
    }
    
    fmt.Printf("\n");
    
    // ============================================
    // Test 2: TCP Connection
    // ============================================
    fmt.Printf("--- Test 2: TCP Connection ---\n");
    fmt.Printf("Connecting to google.com:80\n");
    
    // Initialize network
    net.Init();
    
    @sockfd int = net.Dial("google.com", 80);
    okavela sockfd >= 0 {
        fmt.Printf("Connected! Socket: %d\n", sockfd);
        
        // Send HTTP request
        @request string = "GET / HTTP/1.1\r\nHost: google.com\r\nConnection: close\r\n\r\n";
        @sent int = net.Send(sockfd, request, len(request));
        fmt.Printf("Sent %d bytes\n", sent);
        
        // Receive response
        @buffer[1024] char;
        @received int = net.Recv(sockfd, buffer, 1024);
        okavela received > 0 {
            fmt.Printf("Received %d bytes\n", received);
            fmt.Printf("Response (first 200 chars):\n%.200s\n", buffer);
        }
        
        // Close connection
        net.Close(sockfd);
    } lekapothe {
        fmt.Printf("Error: Failed to connect\n");
    }
    
    net.Cleanup();
    
    fmt.Printf("\n=== Network Utilities Examples Complete ===\n");
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// TIMEOUT: Execution timed out after 5 seconds
//
// Command timed out after 5 seconds
