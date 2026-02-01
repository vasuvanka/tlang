// Real-World Example 1: REST API Server
// A complete REST API server with JSON handling and routing

@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");
@json = #dhimpu("std/json");

// Data models
nirmanam User {
    id int;
    name string;
    email string;
    age int;
}

nirmanam CreateUserRequest {
    name string;
    email string;
    age int;
}

// In-memory user store (simplified - using global variables)
@!userCount int = 0;
@!users [100]User;

// Helper: Create JSON response
#jsonResponse(success int, message string, data string) string {
    @json string = fmt.Sprintf("{\"success\":%d,\"message\":\"%s\",\"data\":%s}", success, message, data);
    okavela json != sunyam {
        mallinchu http.JSONResponse(200, json);
    }
    mallinchu http.JSONResponse(200, "{\"error\":\"Failed to format response\"}");
}

// GET /api/users - List all users
#handleGetUsers() string {
    okavela userCount == 0 {
        mallinchu jsonResponse(1, "No users found", "[]");
    }
    
    @json string = "[";
    malli (@!i int = 0; i < userCount; i = i + 1) {
        okavela i > 0 {
            json = json + ",";
        }
        @userJson string = json.Marshal(users[i]);
        okavela userJson != sunyam {
            json = json + userJson;
        }
    }
    json = json + "]";
    
    mallinchu jsonResponse(1, "Users retrieved successfully", json);
}

// POST /api/users - Create new user
#handleCreateUser(body string) string {
    okavela body == sunyam {
        mallinchu jsonResponse(0, "Request body is required", "null");
    }
    
    // Parse JSON request - use automatic unmarshaling
    @req *CreateUserRequest = json_unmarshal_create_user_request(body);
    okavela req == sunyam {
        mallinchu jsonResponse(0, "Invalid request format", "null");
    }
    
    @name string = req.name;
    @email string = req.email;
    @age int = req.age;
    
    // Free request after extracting values
    free(req.name);
    free(req.email);
    free(req);
    
    // Create user
    @user User = User{
        id: userCount + 1,
        name: name,
        email: email,
        age: age
    };
    
    users[userCount] = user;
    userCount = userCount + 1;
    
    // Return created user - Go-style syntax!
    @userJson string = json.Marshal(user);
    okavela userJson != sunyam {
        mallinchu jsonResponse(1, "User created successfully", userJson);
    }
    
    mallinchu jsonResponse(0, "Failed to create user", "null");
}

// Main HTTP handler
#apiHandler(method string, path string, body string) string {
    fmt.Printf("[%s] %s\n", method, path);
    
    // Route: GET /api/users
    okavela method == "GET" && path == "/api/users" {
        mallinchu handleGetUsers();
    }
    
    // Route: POST /api/users
    okavela method == "POST" && path == "/api/users" {
        mallinchu handleCreateUser(body);
    }
    
    // Health check
    okavela path == "/health" {
        mallinchu jsonResponse(1, "API is running", "{\"status\":\"ok\"}");
    }
    
    // 404 Not Found
    mallinchu http.JSONResponse(404, "{\"error\":\"Not found\"}");
}

#prarambham() {
    fmt.Printf("=== REST API Server ===\n");
    fmt.Printf("Starting server on :8080\n");
    fmt.Printf("Endpoints:\n");
    fmt.Printf("  GET  /api/users  - List all users\n");
    fmt.Printf("  POST /api/users  - Create new user\n");
    fmt.Printf("  GET  /health     - Health check\n");
    fmt.Printf("\n");
    
    // Start HTTP server
    http.ListenAndServe(":8080", apiHandler);
}
