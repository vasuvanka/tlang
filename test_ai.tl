@fmt = #dhimpu("std/fmt");
@ai = #dhimpu("std/ai");
@os = #dhimpu("std/os");

#prarambham() {
    @api_key = os.Getenv("GEMINI_API_KEY");
    
    okavela api_key == "" {
        fmt.Printf("Error: GEMINI_API_KEY environment variable is not set.\n");
        mallinchu;
    }
    
    fmt.Printf("Testing std/ai with Gemini API...\n");
    @prompt = "Say exactly 'Hello from Tlang!'";
    @response = ai.GenerateTextGemini(api_key, prompt);
    
    okavela response == sunyam {
        fmt.Printf("Failed to get response from Gemini.\n");
    } lekapothe {
        fmt.Printf("Gemini Response: %s\n", response);
    }
}
