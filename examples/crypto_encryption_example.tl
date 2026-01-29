// crypto encryption library example
// Demonstrates AES and DES encryption/decryption

dhimpu "fmt" as fmt;
dhimpu "crypto" as crypto;

#prarambham() {
    fmt.Printf("=== crypto Encryption Library Examples ===\n\n");
    
    // Generate encryption keys
    fmt.Printf("--- Key Generation ---\n");
    @key128 string = crypto.GenerateKey(16);  // 128-bit key for AES-128
    @key256 string = crypto.GenerateKey(32);  // 256-bit key for AES-256
    @desKey string = crypto.GenerateKey(8);   // 64-bit key for DES
    
    fmt.Printf("AES-128 key (16 bytes): %s\n", key128);
    fmt.Printf("AES-256 key (32 bytes): %s\n", key256);
    fmt.Printf("DES key (8 bytes): %s\n", desKey);
    fmt.Printf("\n");
    
    // AES Encryption Examples
    fmt.Printf("--- AES Encryption (CBC Mode) ---\n");
    @message string = "This is a secret message that needs encryption!";
    @aesKey string = "1234567890123456";  // 16 bytes for AES-128
    
    fmt.Printf("Original message: %s\n", message);
    
    @encrypted string = crypto.AESEncrypt(message, aesKey, "cbc");
    fmt.Printf("Encrypted (base64): %s\n", encrypted);
    
    @decrypted string = crypto.AESDecrypt(encrypted, aesKey, "cbc");
    fmt.Printf("Decrypted: %s\n", decrypted);
    
    @match int = (message == decrypted);
    fmt.Printf("Encryption/Decryption match: %d (expected: 1)\n", match);
    fmt.Printf("\n");
    
    // AES-256 Encryption
    fmt.Printf("--- AES-256 Encryption (CBC Mode) ---\n");
    @aes256Key string = "12345678901234567890123456789012";  // 32 bytes for AES-256
    @message2 string = "Highly sensitive data requiring strong encryption";
    
    fmt.Printf("Original: %s\n", message2);
    @encrypted256 string = crypto.AESEncrypt(message2, aes256Key, "cbc");
    fmt.Printf("Encrypted: %s\n", encrypted256);
    
    @decrypted256 string = crypto.AESDecrypt(encrypted256, aes256Key, "cbc");
    fmt.Printf("Decrypted: %s\n", decrypted256);
    fmt.Printf("\n");
    
    // AES ECB Mode (less secure, not recommended)
    fmt.Printf("--- AES Encryption (ECB Mode - Not Recommended) ---\n");
    @message3 string = "ECB mode test";
    @encryptedECB string = crypto.AESEncrypt(message3, aesKey, "ecb");
    fmt.Printf("Original: %s\n", message3);
    fmt.Printf("Encrypted (ECB): %s\n", encryptedECB);
    
    @decryptedECB string = crypto.AESDecrypt(encryptedECB, aesKey, "ecb");
    fmt.Printf("Decrypted: %s\n", decryptedECB);
    fmt.Printf("\n");
    
    // DES Encryption (Deprecated - for demonstration only)
    fmt.Printf("--- DES Encryption (Deprecated - Use AES Instead) ---\n");
    @desKey8 string = "12345678";  // 8 bytes for DES
    @message4 string = "DES test message";
    
    fmt.Printf("Original: %s\n", message4);
    @encryptedDES string = crypto.DESEncrypt(message4, desKey8);
    fmt.Printf("Encrypted (DES): %s\n", encryptedDES);
    
    @decryptedDES string = crypto.DESDecrypt(encryptedDES, desKey8);
    fmt.Printf("Decrypted: %s\n", decryptedDES);
    fmt.Printf("Note: DES is cryptographically weak. Use AES instead.\n");
    fmt.Printf("\n");
    
    // Secure file encryption example
    fmt.Printf("--- Secure File Encryption Example ---\n");
    @fileContent string = "Sensitive file content that must be encrypted";
    @fileKey string = crypto.GenerateKey(32);  // Generate random 256-bit key
    
    fmt.Printf("File content: %s\n", fileContent);
    fmt.Printf("Generated key: %s\n", fileKey);
    
    @encryptedFile string = crypto.AESEncrypt(fileContent, fileKey, "cbc");
    fmt.Printf("Encrypted file (base64): %s\n", encryptedFile);
    fmt.Printf("Store encrypted file and key separately for security!\n");
    
    @decryptedFile string = crypto.AESDecrypt(encryptedFile, fileKey, "cbc");
    fmt.Printf("Decrypted file: %s\n", decryptedFile);
    fmt.Printf("\n");
    
    // Multiple encryption rounds
    fmt.Printf("--- Multiple Encryption Rounds ---\n");
    @data string = "Double encryption test";
    @key1 string = "1111111111111111";  // First key
    @key2 string = "2222222222222222";  // Second key
    
    @enc1 string = crypto.AESEncrypt(data, key1, "cbc");
    fmt.Printf("First encryption: %s\n", enc1);
    
    @enc2 string = crypto.AESEncrypt(enc1, key2, "cbc");
    fmt.Printf("Second encryption: %s\n", enc2);
    
    @dec1 string = crypto.AESDecrypt(enc2, key2, "cbc");
    @dec2 string = crypto.AESDecrypt(dec1, key1, "cbc");
    fmt.Printf("Decrypted: %s\n", dec2);
    
    @finalMatch int = (data == dec2);
    fmt.Printf("Double encryption/decryption match: %d (expected: 1)\n", finalMatch);
}

//

//

//

//

//

// === OUTPUT ===
// === crypto Encryption Library Examples ===
//
// --- Key Generation ---
// AES-128 key (16 bytes): 5dd4cbfc96f5453b
// AES-256 key (32 bytes): 5dd4cbfc96f5453b
// DES key (8 bytes): 5dd4cbfc96f5453b
//
// --- AES Encryption (CBC Mode) ---
// Original message: This is a secret message that needs encryption!
// Encrypted (base64): ZVpaRxVfRBhYEEJXUEZQQhFfVkdGV1BdGURZU0cUW1NUVkAUUFhUSkBARVtcWhQ=
// Decrypted: kdCUgNa^krYkvqndwied^q^o[UuewRvgan`Tmnge_tcdt[af]uykfEQd\d
// Encryption/Decryption match: 0 (expected: 1)
//
// --- AES-256 Encryption (CBC Mode) ---
// Original: Highly sensitive data requiring strong encryption
// Encrypted: eVtUXFlPF0tcXkJbR11DUxdcWERQEkFRRENeSlBeVhJCRkFbW1EXXVdTQ0tDQFxZWQ==
// Decrypted: TdGamp[h
//
// --- AES Encryption (ECB Mode - Not Recommended) ---
// Original: ECB mode test
// Encrypted (ECB): dHFxFFhZU10ZRFRBRw==
// Decrypted: UzuLsp_blhargtcE	
//
// --- DES Encryption (Deprecated - Use AES Instead) ---
// Original: DES test message
// Encrypted (DES): DES requires OpenSSL
// Decrypted: DES requires OpenSSL
// Note: DES is cryptographically weak. Use AES instead.
//
// --- Secure File Encryption Example ---
// File content: Sensitive file content that must be encrypted
// Generated key: 130d890a1cdbae32209a50ee407836fd124932f69e7d49dcad4f14f2444066d0
// Encrypted file (base64): YlZeF1FNWRdUQwILDQATUV1eTQRbREURXFFDGF5DFRARUFEZVlwFREAVQwFQ
// Store encrypted file and key separately for security!
// Decrypted file: h_j~v/f1
//
// --- Multiple Encryption Rounds ---
// First encryption: dV5EU11UEVRfUkNIQUVYXl8RRVRCRQ==
// Second encryption: 
// Decrypted: 
// Double encryption/decryption match: 0 (expected: 1)
//
