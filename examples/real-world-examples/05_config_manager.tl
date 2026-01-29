// Real-World Example 5: Configuration Manager
// Reads and writes configuration files, manages environment variables

dhimpu "fmt" as fmt;
dhimpu "io" as io;
dhimpu "json" as json;
dhimpu "os" as os;
dhimpu "strings" as strings;
dhimpu "strconv" as strconv;

nirmanam AppConfig {
    appName string;
    version string;
    port int;
    debug int;  // bool
    databaseUrl string;
    apiKey string;
}

// Load configuration from file
#loadConfig(filename string) AppConfig* {
    @content string = io.ReadFile(filename);
    okavela content == sunyam {
        fmt.Printf("Warning: Config file %s not found, using defaults\n", filename);
        mallinchu sunyam;
    }
    
    @config AppConfig* = json_unmarshal_app_config(content);
    okavela config != sunyam {
        mallinchu config;
    }
    
    // Fallback: create default config
    @defaultConfig AppConfig* = kotha AppConfig;
    okavela defaultConfig == sunyam {
        mallinchu sunyam;
    }
    
    defaultConfig.appName = "MyApp";
    defaultConfig.version = "1.0.0";
    defaultConfig.port = 8080;
    defaultConfig.debug = 0;
    defaultConfig.databaseUrl = "";
    defaultConfig.apiKey = "";
    
    mallinchu defaultConfig;
}

// Save configuration to file
#saveConfig(config AppConfig*, filename string) {
    @json string = json.Marshal(config);
    okavela json != sunyam {
        io.WriteFile(filename, json);
        fmt.Printf("Configuration saved to %s\n", filename);
    } lekapothe {
        fmt.Printf("Error: Failed to serialize configuration\n");
    }
}

// Load from environment variables (override file config)
#loadFromEnv(config AppConfig*) {
    @envPort string = os.Getenv("APP_PORT");
    okavela envPort != sunyam {
        @port int = strconv.Atoi(envPort);
        okavela port > 0 {
            config.port = port;
            fmt.Printf("Loaded port from environment: %d\n", port);
        }
    }
    
    @envDebug string = os.Getenv("APP_DEBUG");
    okavela envDebug != sunyam {
        okavela strings.Contains(envDebug, "true") || strings.Contains(envDebug, "1") {
            config.debug = 1;
        } lekapothe {
            config.debug = 0;
        }
        fmt.Printf("Loaded debug from environment: %d\n", config.debug);
    }
    
    @envDbUrl string = os.Getenv("DATABASE_URL");
    okavela envDbUrl != sunyam {
        config.databaseUrl = envDbUrl;
        fmt.Printf("Loaded database URL from environment\n");
    }
    
    @envApiKey string = os.Getenv("API_KEY");
    okavela envApiKey != sunyam {
        config.apiKey = envApiKey;
        fmt.Printf("Loaded API key from environment\n");
    }
}

// Print configuration
#printConfig(config AppConfig*) {
    fmt.Printf("\n=== Application Configuration ===\n");
    fmt.Printf("App Name:     %s\n", config.appName);
    fmt.Printf("Version:      %s\n", config.version);
    fmt.Printf("Port:         %d\n", config.port);
    fmt.Printf("Debug:        %d\n", config.debug);
    fmt.Printf("Database URL: %s\n", config.databaseUrl);
    okavela len(config.apiKey) > 0 {
        // Mask API key (show first 4 chars, rest masked)
        @masked string = "****";
        fmt.Printf("API Key:      %s (masked)\n", masked);
    } lekapothe {
        fmt.Printf("API Key:      (not set)\n");
    }
    fmt.Printf("================================\n");
}

#prarambham() {
    fmt.Printf("=== Configuration Manager ===\n\n");
    
    // Create default configuration
    @config AppConfig* = kotha AppConfig;
    okavela config == sunyam {
        fmt.Printf("Error: Failed to allocate memory\n");
        mallinchu;
    }
    
    config.appName = "MyApp";
    config.version = "1.0.0";
    config.port = 8080;
    config.debug = 0;
    config.databaseUrl = "postgresql://localhost:5432/mydb";
    config.apiKey = "secret-key-12345";
    
    // Save initial config
    @configFile string = "config.json";
    saveConfig(config, configFile);
    
    // Load configuration from file
    fmt.Printf("\nLoading configuration from file...\n");
    @loadedConfig AppConfig* = loadConfig(configFile);
    
    okavela loadedConfig != sunyam {
        // Override with environment variables
        fmt.Printf("\nLoading from environment variables...\n");
        loadFromEnv(loadedConfig);
        
        // Display configuration
        printConfig(loadedConfig);
        
        // Save updated config
        fmt.Printf("\nSaving updated configuration...\n");
        saveConfig(loadedConfig, configFile);
        
        free(loadedConfig.appName);
        free(loadedConfig.version);
        free(loadedConfig.databaseUrl);
        free(loadedConfig.apiKey);
        free(loadedConfig);
    }
    
    free(config.appName);
    free(config.version);
    free(config.databaseUrl);
    free(config.apiKey);
    free(config);
    
    fmt.Printf("\n=== Configuration Manager Complete ===\n");
}
