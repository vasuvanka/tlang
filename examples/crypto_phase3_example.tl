// crypto Phase 3 algorithms example
// Demonstrates Ed25519, bcrypt, and scrypt

@fmt = #dhimpu("std/fmt");
@crypto = #dhimpu("std/crypto");
@strings = #dhimpu("std/strings");

#prarambham() {
    fmt.Printf("=== Phase 3 Crypto Algorithms Examples ===\n\n");
    
    // Ed25519 Signatures
    fmt.Printf("--- Ed25519 Digital Signatures ---\n");
    @ed25519Keys string = crypto.Ed25519GenerateKeyPair();
    
    @edKeyParts string = strings.Split(ed25519Keys, "|");
    @edPrivateKey string = edKeyParts[0];
    @edPublicKey string = edKeyParts[1];
    
    fmt.Printf("Ed25519 key pair generated\n");
    fmt.Printf("Private key length: %d\n", strings.Index(edPrivateKey, ""));
    fmt.Printf("Public key length: %d\n", strings.Index(edPublicKey, ""));
    
    @edMessage string = "Ed25519 signed document";
    @edSignature string = crypto.Ed25519Sign(edMessage, edPrivateKey);
    fmt.Printf("\nMessage: %s\n", edMessage);
    fmt.Printf("Ed25519 Signature: %s\n", edSignature);
    fmt.Printf("Signature length: %d hex chars\n", strings.Index(edSignature, ""));
    
    @edValid int = crypto.Ed25519Verify(edMessage, edSignature, edPublicKey);
    fmt.Printf("Ed25519 Signature valid: %d (expected: 1)\n", edValid);
    
    // Test with wrong message
    @wrongMessage string = "Modified document";
    @edInvalid int = crypto.Ed25519Verify(wrongMessage, edSignature, edPublicKey);
    fmt.Printf("Ed25519 Signature with wrong message: %d (expected: 0)\n", edInvalid);
    
    // Compare Ed25519 with ECDSA
    fmt.Printf("\n--- Ed25519 vs ECDSA Comparison ---\n");
    @eccKeys string = crypto.ECCGenerateKeyPair("P-256");
    @eccParts string = strings.Split(eccKeys, "|");
    @eccPrivate string = eccParts[0];
    @eccPublic string = eccParts[1];
    
    @testDoc string = "Comparison document";
    @edSig string = crypto.Ed25519Sign(testDoc, edPrivateKey);
    @eccSig string = crypto.ECDSASign(testDoc, eccPrivate);
    
    fmt.Printf("Document: %s\n", testDoc);
    fmt.Printf("Ed25519 signature length: %d\n", strings.Index(edSig, ""));
    fmt.Printf("ECDSA signature length: %d\n", strings.Index(eccSig, ""));
    fmt.Printf("Ed25519 is faster and has smaller signatures!\n");
    fmt.Printf("\n");
    
    // bcrypt Password Hashing
    fmt.Printf("--- bcrypt Password Hashing ---\n");
    @password string = "mySecurePassword123";
    
    @bcryptHash1 string = crypto.BcryptHash(password, 10);
    fmt.Printf("Password: %s\n", password);
    fmt.Printf("bcrypt hash (cost 10): %s\n", bcryptHash1);
    
    @bcryptValid int = crypto.BcryptVerify(password, bcryptHash1);
    fmt.Printf("bcrypt Verification: %d (expected: 1)\n", bcryptValid);
    
    // Different cost factors
    fmt.Printf("\n--- bcrypt Different Cost Factors ---\n");
    @bcryptHash4 string = crypto.BcryptHash(password, 4);   // Low cost (fast, less secure)
    @bcryptHash12 string = crypto.BcryptHash(password, 12); // High cost (slow, more secure)
    
    fmt.Printf("bcrypt hash (cost 4): %s\n", bcryptHash4);
    fmt.Printf("bcrypt hash (cost 12): %s\n", bcryptHash12);
    fmt.Printf("Higher cost = slower but more secure\n");
    
    @valid4 int = crypto.BcryptVerify(password, bcryptHash4);
    @valid12 int = crypto.BcryptVerify(password, bcryptHash12);
    fmt.Printf("Verification (cost 4): %d\n", valid4);
    fmt.Printf("Verification (cost 12): %d\n", valid12);
    fmt.Printf("\n");
    
    // scrypt Key Derivation
    fmt.Printf("--- scrypt Memory-Hard Key Derivation ---\n");
    @scryptPassword string = "password123";
    @scryptSalt string = crypto.GenerateKey(16);
    
    fmt.Printf("Password: %s\n", scryptPassword);
    fmt.Printf("Salt: %s\n", scryptSalt);
    
    // Standard scrypt parameters
    @scryptKey1 string = crypto.Scrypt(scryptPassword, scryptSalt, 16384, 8, 1, 32);
    fmt.Printf("scrypt key (N=16384, r=8, p=1): %s\n", scryptKey1);
    
    // Higher memory cost
    @scryptKey2 string = crypto.Scrypt(scryptPassword, scryptSalt, 32768, 8, 1, 32);
    fmt.Printf("scrypt key (N=32768, r=8, p=1): %s\n", scryptKey2);
    
    // Consistency test
    @scryptKey3 string = crypto.Scrypt(scryptPassword, scryptSalt, 16384, 8, 1, 32);
    @scryptMatch int = (scryptKey1 == scryptKey3);
    fmt.Printf("scrypt consistency: %d (expected: 1)\n", scryptMatch);
    
    // Different key lengths
    fmt.Printf("\n--- scrypt Different Key Lengths ---\n");
    @key16 string = crypto.Scrypt(scryptPassword, scryptSalt, 16384, 8, 1, 16);
    @key32 string = crypto.Scrypt(scryptPassword, scryptSalt, 16384, 8, 1, 32);
    @key64 string = crypto.Scrypt(scryptPassword, scryptSalt, 16384, 8, 1, 64);
    
    fmt.Printf("16-byte key: %s\n", key16);
    fmt.Printf("32-byte key: %s\n", key32);
    fmt.Printf("64-byte key: %s\n", key64);
    fmt.Printf("\n");
    
    // Password Hashing Comparison
    fmt.Printf("--- Password Hashing Algorithm Comparison ---\n");
    @testPassword string = "testPassword";
    @testSalt string = crypto.GenerateKey(16);
    
    // PBKDF2
    @pbkdf2Hash string = crypto.PBKDF2(testPassword, testSalt, 10000, 32, "sha256");
    fmt.Printf("PBKDF2 hash: %s\n", pbkdf2Hash);
    
    // Argon2
    @argon2Hash string = crypto.Argon2Hash(testPassword, testSalt, 2, 65536, 4);
    fmt.Printf("Argon2 hash: %s\n", argon2Hash);
    
    // bcrypt
    @bcryptHash string = crypto.BcryptHash(testPassword, 10);
    fmt.Printf("bcrypt hash: %s\n", bcryptHash);
    
    // scrypt (for key derivation, not password hashing, but shown for comparison)
    @scryptHash string = crypto.Scrypt(testPassword, testSalt, 16384, 8, 1, 32);
    fmt.Printf("scrypt key: %s\n", scryptHash);
    
    fmt.Printf("\nRecommendation: Use Argon2 for new applications, bcrypt for compatibility\n");
    fmt.Printf("\n");
    
    // Complete workflow
    fmt.Printf("--- Complete Workflow with Phase 3 Algorithms ---\n");
    fmt.Printf("1. User registration with bcrypt:\n");
    @userPass string = "newUserPassword";
    @userBcryptHash string = crypto.BcryptHash(userPass, 10);
    fmt.Printf("   Password hashed with bcrypt: %s\n", userBcryptHash);
    
    fmt.Printf("\n2. User login verification:\n");
    @loginPass string = "newUserPassword";
    @loginValid int = crypto.BcryptVerify(loginPass, userBcryptHash);
    okavela loginValid == 1 {
        fmt.Printf("   Login successful!\n");
    } lekapothe {
        fmt.Printf("   Login failed!\n");
    }
    
    fmt.Printf("\n3. Document signing with Ed25519:\n");
    @contract string = "Service Agreement";
    @edSig2 string = crypto.Ed25519Sign(contract, edPrivateKey);
    fmt.Printf("   Contract signed with Ed25519: %s\n", edSig2);
    
    fmt.Printf("\n4. Signature verification:\n");
    @contractValid int = crypto.Ed25519Verify(contract, edSig2, edPublicKey);
    okavela contractValid == 1 {
        fmt.Printf("   Contract signature verified!\n");
    } lekapothe {
        fmt.Printf("   Contract signature invalid!\n");
    }
    
    fmt.Printf("\n5. Key derivation with scrypt:\n");
    @masterPassword string = "masterPassword";
    @masterSalt string = crypto.GenerateKey(16);
    @derivedKey string = crypto.Scrypt(masterPassword, masterSalt, 16384, 8, 1, 32);
    fmt.Printf("   Derived encryption key: %s\n", derivedKey);
    fmt.Printf("   Use this key for AES encryption\n");
    
    fmt.Printf("\n=== All Phase 3 Crypto Tests Complete ===\n");
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
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.29s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl`
// âœ— C compilation failed:
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:47:5: warning: '_putenv' redeclared without dllimport attribute: previous dllimport ignored [-Wattributes]
//    47 |     @edSig string = crypto.Ed25519Sign(testDoc, edPrivateKey);
//       |     ^~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl: In function 'adhi':
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:5:30: error: implicit declaration of function 'strings_Split' [-Wimplicit-function-declaration]
//     5 | 
//       |                              ^            
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:5:30: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:6:32: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//     6 | @fmt = #dhimpu("std/fmt");
//       |                                ^         
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:7:31: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//     7 | @crypto = #dhimpu("std/crypto");
//       |                               ^         
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:23:28: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
//    23 |     fmt.Printf("Public key length: %d\n", strings.Index(edPublicKey, ""));
//       |                            ^~~~~~~~~~~~~
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:24:30: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//    24 | 
//       |                              ^       
// C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl:25:29: error: initialization of 'const char *' from 'char' makes pointer from integer without a cast [-Wint-conversion]
//    25 |     @edMessage string = "Ed25519 signed document";
//       |                             ^~~~~~~~
//
//
// C file is available at: \\?\C:\Users\vanka\github.com\vasuvanka\tlang\output.c
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\crypto_phase3_example.tl` (exit code: 1)
//
