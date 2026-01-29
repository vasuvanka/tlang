// crypto public key cryptography example
// Demonstrates RSA, ECDSA/ECC, and Argon2

dhimpu "fmt" as fmt;
dhimpu "crypto" as crypto;
dhimpu "strings" as strings;

#prarambham() {
    fmt.Printf("=== Public Key Cryptography Examples ===\n\n");
    
    // RSA Key Generation and Encryption
    fmt.Printf("--- RSA Public Key Cryptography ---\n");
    @rsaKeyPair string = crypto.RSAGenerateKeyPair(2048);
    
    // Split key pair (format: "PRIVATE_KEY|PUBLIC_KEY")
    @keyParts string = strings.Split(rsaKeyPair, "|");
    @rsaPrivateKey string = keyParts[0];
    @rsaPublicKey string = keyParts[1];
    
    fmt.Printf("RSA 2048-bit key pair generated\n");
    fmt.Printf("Private key length: %d\n", strings.Index(rsaPrivateKey, ""));
    fmt.Printf("Public key length: %d\n", strings.Index(rsaPublicKey, ""));
    
    // RSA Encryption/Decryption
    @rsaMessage string = "RSA encrypted secret";
    fmt.Printf("\nOriginal message: %s\n", rsaMessage);
    
    @rsaEncrypted string = crypto.RSAEncrypt(rsaMessage, rsaPublicKey);
    fmt.Printf("RSA Encrypted: %s\n", rsaEncrypted);
    
    @rsaDecrypted string = crypto.RSADecrypt(rsaEncrypted, rsaPrivateKey);
    fmt.Printf("RSA Decrypted: %s\n", rsaDecrypted);
    
    @rsaMatch int = (rsaMessage == rsaDecrypted);
    fmt.Printf("RSA Encryption/Decryption match: %d (expected: 1)\n", rsaMatch);
    
    // RSA Digital Signatures
    fmt.Printf("\n--- RSA Digital Signatures ---\n");
    @document string = "Important document to sign";
    @rsaSignature string = crypto.RSASign(document, rsaPrivateKey);
    fmt.Printf("Document: %s\n", document);
    fmt.Printf("RSA Signature: %s\n", rsaSignature);
    
    @rsaValid int = crypto.RSAVerify(document, rsaSignature, rsaPublicKey);
    fmt.Printf("RSA Signature valid: %d (expected: 1)\n", rsaValid);
    
    // Test with wrong document
    @wrongDoc string = "Modified document";
    @rsaInvalid int = crypto.RSAVerify(wrongDoc, rsaSignature, rsaPublicKey);
    fmt.Printf("RSA Signature with wrong document: %d (expected: 0)\n", rsaInvalid);
    fmt.Printf("\n");
    
    // ECDSA/ECC Key Generation and Signatures
    fmt.Printf("--- ECDSA/ECC Digital Signatures ---\n");
    @eccKeyPair string = crypto.ECCGenerateKeyPair("P-256");
    
    @eccKeyParts string = strings.Split(eccKeyPair, "|");
    @eccPrivateKey string = eccKeyParts[0];
    @eccPublicKey string = eccKeyParts[1];
    
    fmt.Printf("ECDSA P-256 key pair generated\n");
    fmt.Printf("Private key length: %d\n", strings.Index(eccPrivateKey, ""));
    fmt.Printf("Public key length: %d\n", strings.Index(eccPublicKey, ""));
    
    // ECDSA Signatures
    @eccDocument string = "ECDSA signed document";
    @eccSignature string = crypto.ECDSASign(eccDocument, eccPrivateKey);
    fmt.Printf("\nDocument: %s\n", eccDocument);
    fmt.Printf("ECDSA Signature: %s\n", eccSignature);
    
    @eccValid int = crypto.ECDSAVerify(eccDocument, eccSignature, eccPublicKey);
    fmt.Printf("ECDSA Signature valid: %d (expected: 1)\n", eccValid);
    
    // Test with wrong document
    @eccInvalid int = crypto.ECDSAVerify(wrongDoc, eccSignature, eccPublicKey);
    fmt.Printf("ECDSA Signature with wrong document: %d (expected: 0)\n", eccInvalid);
    
    // Different curves
    fmt.Printf("\n--- ECC Different Curves ---\n");
    @p384Keys string = crypto.ECCGenerateKeyPair("P-384");
    @p521Keys string = crypto.ECCGenerateKeyPair("P-521");
    fmt.Printf("P-384 keys generated: %d\n", strings.Index(p384Keys, ""));
    fmt.Printf("P-521 keys generated: %d\n", strings.Index(p521Keys, ""));
    fmt.Printf("\n");
    
    // Argon2 Password Hashing
    fmt.Printf("--- Argon2 Password Hashing ---\n");
    @password string = "mySecretPassword123";
    @salt string = crypto.GenerateKey(16);  // Random 16-byte salt
    
    fmt.Printf("Password: %s\n", password);
    fmt.Printf("Salt: %s\n", salt);
    
    @argon2Hash string = crypto.Argon2Hash(password, salt, 2, 65536, 4);
    fmt.Printf("Argon2 Hash: %s\n", argon2Hash);
    fmt.Printf("Hash length: %d hex chars\n", strings.Index(argon2Hash, ""));
    
    // Verify password
    @argon2Valid int = crypto.Argon2Verify(password, argon2Hash);
    fmt.Printf("Argon2 Verification (correct password): %d (expected: 1)\n", argon2Valid);
    
    @wrongPassword string = "wrongPassword";
    @argon2Invalid int = crypto.Argon2Verify(wrongPassword, argon2Hash);
    fmt.Printf("Argon2 Verification (wrong password): %d (expected: 0)\n", argon2Invalid);
    
    // Different Argon2 parameters
    fmt.Printf("\n--- Argon2 Different Parameters ---\n");
    @hash1 string = crypto.Argon2Hash(password, salt, 1, 32768, 2);  // Lower cost
    @hash2 string = crypto.Argon2Hash(password, salt, 3, 131072, 8);  // Higher cost
    fmt.Printf("Low cost hash: %s\n", hash1);
    fmt.Printf("High cost hash: %s\n", hash2);
    fmt.Printf("\n");
    
    // Complete workflow example
    fmt.Printf("--- Complete Workflow Example ---\n");
    fmt.Printf("1. User registration with password hashing:\n");
    @userPassword string = "userPassword456";
    @userSalt string = crypto.GenerateKey(16);
    @storedHash string = crypto.Argon2Hash(userPassword, userSalt, 2, 65536, 4);
    fmt.Printf("   Password hashed and stored: %s\n", storedHash);
    
    fmt.Printf("\n2. User login verification:\n");
    @loginPassword string = "userPassword456";
    @loginValid int = crypto.Argon2Verify(loginPassword, storedHash);
    okavela loginValid == 1 {
        fmt.Printf("   Login successful!\n");
    } lekapothe {
        fmt.Printf("   Login failed!\n");
    }
    
    fmt.Printf("\n3. Document signing with ECDSA:\n");
    @contract string = "Contract terms and conditions";
    @contractSig string = crypto.ECDSASign(contract, eccPrivateKey);
    fmt.Printf("   Contract signed: %s\n", contractSig);
    
    fmt.Printf("\n4. Document verification:\n");
    @contractValid int = crypto.ECDSAVerify(contract, contractSig, eccPublicKey);
    okavela contractValid == 1 {
        fmt.Printf("   Contract signature verified!\n");
    } lekapothe {
        fmt.Printf("   Contract signature invalid!\n");
    }
    
    fmt.Printf("\n=== All Public Key Crypto Tests Complete ===\n");
}

//

//

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
// Compiled to C: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// Compiling C to binary using gcc...
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl`
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:47:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    47 |     fmt.Printf("RSA Signature valid: %d (expected: 1)\n", rsaValid);
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:5:28: error: implicit declaration of function 'strings_Split' [-Wimplicit-function-declaration]
//     5 | 
//       |                            ^            
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:5:28: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:6:33: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//     6 | dhimpu "fmt" as fmt;
//       |                                 ^       
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:7:32: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//     7 | dhimpu "crypto" as crypto;
//       |                                ^       
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:32:31: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
//    32 | 
//       |                               ^            
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:33:33: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//    33 |     @rsaDecrypted string = crypto.RSADecrypt(rsaEncrypted, rsaPrivateKey);
//       |                                 ^~~~~~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl:34:32: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//    34 |     fmt.Printf("RSA Decrypted: %s\n", rsaDecrypted);
//       |                                ^~~~~~~~~~~
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_publickey_example.tl` (exit code: 1)
//
