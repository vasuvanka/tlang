// crypto advanced algorithms example
// Demonstrates AES-GCM, ChaCha20-Poly1305, and PBKDF2

dhimpu "fmt" as fmt;
dhimpu "crypto" as crypto;

#prarambham() {
    fmt.Printf("=== Advanced Crypto Algorithms Examples ===\n\n");
    
    // AES-GCM Authenticated Encryption
    fmt.Printf("--- AES-GCM Authenticated Encryption ---\n");
    @aesGcmKey string = crypto.GenerateKey(32);  // 256-bit key
    @message string = "This message is authenticated and encrypted";
    @aad string = "metadata123";  // Additional Authenticated Data
    
    fmt.Printf("Original message: %s\n", message);
    fmt.Printf("AAD: %s\n", aad);
    fmt.Printf("Key: %s\n", aesGcmKey);
    
    @encryptedGcm string = crypto.AESGCMEncrypt(message, aesGcmKey, aad);
    fmt.Printf("Encrypted (AES-GCM): %s\n", encryptedGcm);
    
    @decryptedGcm string = crypto.AESGCMDecrypt(encryptedGcm, aesGcmKey, aad);
    fmt.Printf("Decrypted: %s\n", decryptedGcm);
    
    @matchGcm int = (message == decryptedGcm);
    fmt.Printf("AES-GCM match: %d (expected: 1)\n", matchGcm);
    
    // Test authentication failure (wrong AAD)
    fmt.Printf("\n--- Testing Authentication (Wrong AAD) ---\n");
    @wrongAad string = "wrongmetadata";
    @decryptedWrong string = crypto.AESGCMDecrypt(encryptedGcm, aesGcmKey, wrongAad);
    @authFailed int = (decryptedWrong == "");
    fmt.Printf("Decryption with wrong AAD: %s\n", decryptedWrong);
    fmt.Printf("Authentication failed (expected): %d (expected: 1)\n", authFailed);
    fmt.Printf("\n");
    
    // ChaCha20-Poly1305
    fmt.Printf("--- ChaCha20-Poly1305 Authenticated Encryption ---\n");
    @chachaKey string = crypto.GenerateKey(32);  // 32 bytes required
    @chachaMessage string = "High-performance authenticated encryption";
    @chachaAad string = "context123";
    
    fmt.Printf("Original: %s\n", chachaMessage);
    fmt.Printf("AAD: %s\n", chachaAad);
    fmt.Printf("Key: %s\n", chachaKey);
    
    @encryptedChacha string = crypto.ChaCha20Poly1305Encrypt(chachaMessage, chachaKey, "", chachaAad);
    fmt.Printf("Encrypted (ChaCha20-Poly1305): %s\n", encryptedChacha);
    
    @decryptedChacha string = crypto.ChaCha20Poly1305Decrypt(encryptedChacha, chachaKey, "", chachaAad);
    fmt.Printf("Decrypted: %s\n", decryptedChacha);
    
    @matchChacha int = (chachaMessage == decryptedChacha);
    fmt.Printf("ChaCha20-Poly1305 match: %d (expected: 1)\n", matchChacha);
    fmt.Printf("\n");
    
    // PBKDF2 Key Derivation
    fmt.Printf("--- PBKDF2 Password-Based Key Derivation ---\n");
    @password string = "mySecretPassword123";
    @salt string = crypto.GenerateKey(16);  // Random salt
    @iterations int = 10000;
    @keyLength int = 32;  // 256-bit key
    @hashAlgo string = "sha256";
    
    fmt.Printf("Password: %s\n", password);
    fmt.Printf("Salt: %s\n", salt);
    fmt.Printf("Iterations: %d\n", iterations);
    fmt.Printf("Key length: %d bytes\n", keyLength);
    fmt.Printf("Hash algorithm: %s\n", hashAlgo);
    
    @derivedKey string = crypto.PBKDF2(password, salt, iterations, keyLength, hashAlgo);
    fmt.Printf("Derived key: %s\n", derivedKey);
    fmt.Printf("Key length: %d hex chars (expected: %d)\n", strings.Index(derivedKey, ""), keyLength * 2);
    
    // Verify PBKDF2 consistency (same password + salt = same key)
    fmt.Printf("\n--- PBKDF2 Consistency Test ---\n");
    @derivedKey2 string = crypto.PBKDF2(password, salt, iterations, keyLength, hashAlgo);
    @pbkdf2Match int = (derivedKey == derivedKey2);
    fmt.Printf("First derivation: %s\n", derivedKey);
    fmt.Printf("Second derivation: %s\n", derivedKey2);
    fmt.Printf("Keys match: %d (expected: 1)\n", pbkdf2Match);
    
    // Different salt produces different key
    @salt2 string = crypto.GenerateKey(16);
    @derivedKey3 string = crypto.PBKDF2(password, salt2, iterations, keyLength, hashAlgo);
    @differentKey int = (derivedKey != derivedKey3);
    fmt.Printf("\nDifferent salt produces different key: %d (expected: 1)\n", differentKey);
    fmt.Printf("\n");
    
    // Using derived key for encryption
    fmt.Printf("--- Using PBKDF2 Key for Encryption ---\n");
    @dataToEncrypt string = "Data encrypted with password-derived key";
    
    // Convert hex key to bytes (simplified - use first 32 hex chars as key)
    @encryptionKey string = salt;  // Use salt as key for demo (in real app, use derived key properly)
    @encryptedData string = crypto.AESGCMEncrypt(dataToEncrypt, encryptionKey, "");
    fmt.Printf("Data: %s\n", dataToEncrypt);
    fmt.Printf("Encrypted: %s\n", encryptedData);
    
    @decryptedData string = crypto.AESGCMDecrypt(encryptedData, encryptionKey, "");
    fmt.Printf("Decrypted: %s\n", decryptedData);
    fmt.Printf("\n");
    
    // Performance comparison
    fmt.Printf("--- Algorithm Comparison ---\n");
    @testData string = "Performance test data";
    @testKey string = crypto.GenerateKey(32);
    
    fmt.Printf("Test data: %s\n", testData);
    fmt.Printf("Key: %s\n", testKey);
    
    // AES-GCM
    @startTime1 int = time.Now();
    @enc1 string = crypto.AESGCMEncrypt(testData, testKey, "");
    @dec1 string = crypto.AESGCMDecrypt(enc1, testKey, "");
    @time1 int = time.Now() - startTime1;
    
    // ChaCha20-Poly1305
    @startTime2 int = time.Now();
    @enc2 string = crypto.ChaCha20Poly1305Encrypt(testData, testKey, "", "");
    @dec2 string = crypto.ChaCha20Poly1305Decrypt(enc2, testKey, "", "");
    @time2 int = time.Now() - startTime2;
    
    fmt.Printf("AES-GCM time: %d ms\n", time1);
    fmt.Printf("ChaCha20-Poly1305 time: %d ms\n", time2);
    fmt.Printf("\n");
    
    fmt.Printf("=== All Advanced Crypto Tests Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// === Advanced Crypto Algorithms Examples ===
//
// --- AES-GCM Authenticated Encryption ---
// Original message: This message is authenticated and encrypted
// AAD: metadata123
// Key: 2923be84e16cd6ae529049f1f1bbe9ebb3a6db3c870c3e99245e0d1c06b747de
// Encrypted (AES-GCM): ZlFbQEIIXUcWUFEGRF8SRVRHTVhRVxJYBVAWBwEZBAwGEwRYBxBKE0xSVA==
// Decrypted: hUtQ3 q}=dU41p$"gtcfo4y2g
// 03A/; e a&v9zvG$vk`pLw.uTI0fw_
//
// AES-GCM match: 0 (expected: 1)
//
// --- Testing Authentication (Wrong AAD) ---
// Decryption with wrong AAD: hUtQ3 q}=dU41p$"gtcfo4y2g
// 03A/; e a&v9zvG$vk`pLw.uTI0fw_
//
// Authentication failed (expected): 0 (expected: 1)
//
// --- ChaCha20-Poly1305 Authenticated Encryption ---
// Original: High-performance authenticated encryption
// AAD: context123
// Key: b3124dc843bb8ba61f035a7d0938251f5dd4cbfc96f5453b130d890a1cdbae32
// Encrypted (ChaCha20-Poly1305): KlpWWhkUBkpSXBAPWQwCUxEHRUddBFkQWVpSTFdREQNbBxZNExYPDFc=
// Decrypted: )_AecmvX1`  ff7Gp`r,blW\psZ7b2g7$1|g(WvMi,tKi4|S\
// ChaCha20-Poly1305 match: 0 (expected: 1)
//
// --- PBKDF2 Password-Based Key Derivation ---
// Password: mySecretPassword123
// Salt: 209a50ee407836fd124932f69e7d49dc
// Iterations: 10000
// Key length: 32 bytes
// Hash algorithm: sha256
// Derived key: 333e498660707a838e93a5a9bbf0d2d8e820ff043d1c53366a7584599871ae8d
// Key length: 0 hex chars (expected: 64)
//
// --- PBKDF2 Consistency Test ---
// First derivation: 333e498660707a838e93a5a9bbf0d2d8e820ff043d1c53366a7584599871ae8d
// Second derivation: 333e498660707a838e93a5a9bbf0d2d8e820ff043d1c53366a7584599871ae8d
// Keys match: 1 (expected: 1)
//
// Different salt produces different key: 0 (expected: 1)
//
// --- Using PBKDF2 Key for Encryption ---
// Data: Data encrypted with password-derived key
// Encrypted: JQVABxFRCFFGTUREU1JER18WCxRDURFERF1BBkxVV0AIElECEV8DSw==
// Decrypted: +5b'sL `wrrwbc6ucS)qaZ`pJa&4ctw3"$s_dbuysZ!ss4[p`G_
//
//
// --- Algorithm Comparison ---
// Test data: Performance test data
// Key: f622919de18b1fdab0ca9902b9729d492c807ec599d5e980b2eac9cc53bf67d6
// AES-GCM time: 0 ms
// ChaCha20-Poly1305 time: 0 ms
//
// === All Advanced Crypto Tests Complete ===
//
