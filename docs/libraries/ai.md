# `std/ai`

The `std/ai` library provides native C-bindings for accessing major Large Language Model (LLM) providers via their HTTP APIs. This allows Tlang applications to easily incorporate AI features like text generation, summarization, and translation without requiring external dependencies out of the box.

## Available Functions

### `ai.GenerateTextGemini(api_key string, prompt string) string`

Calls the Google Gemini Pro API to generate text based on the provided prompt.

**Parameters:**
- `api_key`: Your Google Gemini API key.
- `prompt`: The text instructions or query for the model.

**Returns:**
- A `string` containing the generated text response from the model.
- If there is an error (e.g., networking issue or invalid API key), it attempts to return the error message or a fallback string indicating failure.

**Example:**
```tl
@fmt = #dhimpu("std/fmt");
@ai = #dhimpu("std/ai");
@os = #dhimpu("std/os");

#prarambham() {
    @api_key string = os.Getenv("GEMINI_API_KEY");
    okavela api_key == "" {
        fmt.Printf("Error: GEMINI_API_KEY environment variable is not set.\n");
        mallinchu;
    }
    
    fmt.Printf("Prompting Gemini...\n");
    @response string = ai.GenerateTextGemini(api_key, "What is the capital of France?");
    fmt.Printf("Response: %s\n", response);
}
```

### `ai.GenerateTextOpenAI(api_key string, prompt string) string`

Calls the OpenAI `gpt-3.5-turbo` API to generate text using the Chat Completions endpoint.

**Parameters:**
- `api_key`: Your OpenAI API key.
- `prompt`: The text instructions or query for the model.

**Returns:**
- A `string` containing the generated text response.
- Equivalent error handling to `GenerateTextGemini`.

**Example:**
```tl
@fmt = #dhimpu("std/fmt");
@ai = #dhimpu("std/ai");
@os = #dhimpu("std/os");

#prarambham() {
    @api_key string = os.Getenv("OPENAI_API_KEY");
    
    fmt.Printf("Prompting OpenAI...\n");
    @response string = ai.GenerateTextOpenAI(api_key, "Write a 2-line poem about Tlang.");
    fmt.Printf("Response: %s\n", response);
}
```

### `ai.GenerateTextClaude(api_key string, prompt string) string`

Calls the Anthropic Claude API (`claude-3-haiku-20240307`) to generate text based on the provided prompt and context.

**Parameters:**
- `api_key`: Your Anthropic API key.
- `prompt`: The text instructions or query for the model.

**Returns:**
- A `string` containing the generated text response.
- Equivalent error handling to `GenerateTextGemini`.

**Example:**
```tl
@fmt = #dhimpu("std/fmt");
@ai = #dhimpu("std/ai");
@os = #dhimpu("std/os");

#prarambham() {
    @api_key string = os.Getenv("ANTHROPIC_API_KEY");
    
    fmt.Printf("Prompting Claude...\n");
    @response string = ai.GenerateTextClaude(api_key, "What makes Tlang unique?");
    fmt.Printf("Response: %s\n", response);
}
```

## Dependencies

The `std/ai` library internally abstracts and requires the inclusion of the following standard packages when compiled to C:
- `std/http`: To execute the POST requests to the API endpoints.
- `std/json`: To escape the user prompts and parse the API responses safely.

*Note: Since these dependencies are natively handled by the Tlang codegen engine under the hood, you do not need to explicitly import `std/http` or `std/json` in your source code just to use `std/ai`.*
