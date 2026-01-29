// unicode - Unicode Utilities library
// Provides Unicode character classification and manipulation

pub fn generate_unicode_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <ctype.h>\n");
    code.push_str("\n");
    
    // unicode.IsLetter - Check if character is a letter
    code.push_str("// unicode.IsLetter - Check if character is a letter\n");
    code.push_str("int unicode_IsLetter(int r) {\n");
    code.push_str("    return isalpha((char)r) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // unicode.IsDigit - Check if character is a digit
    code.push_str("// unicode.IsDigit - Check if character is a digit\n");
    code.push_str("int unicode_IsDigit(int r) {\n");
    code.push_str("    return isdigit((char)r) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // unicode.IsSpace - Check if character is whitespace
    code.push_str("// unicode.IsSpace - Check if character is whitespace\n");
    code.push_str("int unicode_IsSpace(int r) {\n");
    code.push_str("    return isspace((char)r) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // unicode.ToUpper - Convert to uppercase
    code.push_str("// unicode.ToUpper - Convert to uppercase\n");
    code.push_str("int unicode_ToUpper(int r) {\n");
    code.push_str("    return toupper((char)r);\n");
    code.push_str("}\n\n");
    
    // unicode.ToLower - Convert to lowercase
    code.push_str("// unicode.ToLower - Convert to lowercase\n");
    code.push_str("int unicode_ToLower(int r) {\n");
    code.push_str("    return tolower((char)r);\n");
    code.push_str("}\n\n");
    
    // unicode.IsUpper - Check if uppercase
    code.push_str("// unicode.IsUpper - Check if uppercase\n");
    code.push_str("int unicode_IsUpper(int r) {\n");
    code.push_str("    return isupper((char)r) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    // unicode.IsLower - Check if lowercase
    code.push_str("// unicode.IsLower - Check if lowercase\n");
    code.push_str("int unicode_IsLower(int r) {\n");
    code.push_str("    return islower((char)r) ? 1 : 0;\n");
    code.push_str("}\n\n");
    
    code
}
