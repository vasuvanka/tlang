# crypto - Cryptographic Library

The `crypto` library provides cryptographic hash functions and encryption algorithms (AES, DES, etc.) for data integrity and security.

## Functions

### Hash Functions

**`hash.MD5(data)`** - MD5 hash

- `data`: String to hash
- Returns: MD5 hash as hexadecimal string (32 characters)
- **Note:** MD5 is cryptographically broken, use SHA256 or SHA512 for security

**Example:**
```tl
@hash string = hash.MD5("Hello, World!");
fmt.Printf("MD5: %s\n", hash);
```

**`hash.SHA1(data)`** - SHA1 hash

- `data`: String to hash
- Returns: SHA1 hash as hexadecimal string (40 characters)
- **Note:** SHA1 is deprecated for security, use SHA256 or SHA512

**Example:**
```tl
@hash string = hash.SHA1("Hello, World!");
fmt.Printf("SHA1: %s\n", hash);
```

**`hash.SHA256(data)`** - SHA256 hash

- `data`: String to hash
- Returns: SHA256 hash as hexadecimal string (64 characters)
- **Recommended** for most security applications

**Example:**
```tl
@hash string = hash.SHA256("Hello, World!");
fmt.Printf("SHA256: %s\n", hash);
```

**`hash.SHA512(data)`** - SHA512 hash

- `data`: String to hash
- Returns: SHA512 hash as hexadecimal string (128 characters)
- **Recommended** for high-security applications

**Example:**
```tl
@hash string = hash.SHA512("Hello, World!");
fmt.Printf("SHA512: %s\n", hash);
```

### HMAC (Hash-based Message Authentication Code)

**`hash.HMAC(key, data, algo)`** - HMAC hash

- `key`: Secret key for HMAC
- `data`: Data to authenticate
- `algo`: Hash algorithm ("md5", "sha1", "sha256", "sha512")
- Returns: HMAC hash as hexadecimal string

**Example:**
```tl
@key string = "secret-key";
@data string = "message";
@hmac string = hash.HMAC(key, data, "sha256");
fmt.Printf("HMAC: %s\n", hmac);
```

## Hash Output Lengths

| Algorithm | Output Length (hex) | Output Length (bytes) |
|-----------|-------------------|---------------------|
| MD5       | 32 characters     | 16 bytes            |
| SHA1      | 40 characters     | 20 bytes            |
| SHA256    | 64 characters     | 32 bytes            |
| SHA512    | 128 characters    | 64 bytes            |

## Common Use Cases

### Password Hashing

```tl
@password string = "userPassword123";
@hash string = hash.SHA256(password);
// Store hash in database (never store plain passwords)
fmt.Printf("Password hash: %s\n", hash);
```

**Note:** For production password hashing, use proper password hashing functions (bcrypt, argon2) with salt, not just SHA256.

### File Integrity Verification

```tl
@fileContent string = io.ReadFile("important.txt");
@fileHash string = hash.SHA256(fileContent);
fmt.Printf("File hash: %s\n", fileHash);
// Store this hash to verify file hasn't been modified
```

### Message Authentication (HMAC)

```tl
@secretKey string = "my-secret-key";
@message string = "Important message";
@hmac string = hash.HMAC(secretKey, message, "sha256");
fmt.Printf("HMAC: %s\n", hmac);
// Send message and HMAC, recipient can verify authenticity
```

### Data Deduplication

```tl
@data1 string = "Some data";
@data2 string = "Some data";
@hash1 string = hash.SHA256(data1);
@hash2 string = hash.SHA256(data2);
@same int = (hash1 == hash2);  // 1 if same
```

## Security Notes

### Algorithm Recommendations

- **MD5**: ❌ **Do not use** for security - cryptographically broken
- **SHA1**: ⚠️ **Deprecated** - use only for legacy compatibility
- **SHA256**: ✅ **Recommended** - good balance of security and performance
- **SHA512**: ✅ **Recommended** - highest security, slightly slower

### Best Practices

1. **Use SHA256 or SHA512** for security-critical applications
2. **Never use MD5 or SHA1** for new security applications
3. **Use HMAC** for message authentication
4. **Add salt** when hashing passwords (use proper password hashing libraries)
5. **Store hashes securely** - hashes can be used for verification but original data cannot be recovered

## OpenSSL Integration

For production use with cryptographically secure hashing, compile with OpenSSL:

```bash
# Compile with OpenSSL support
gcc -DUSE_OPENSSL output.c -o program -lssl -lcrypto
```

Without OpenSSL, the library uses simplified implementations suitable for testing but **not cryptographically secure**.

## Example Usage

```tl
#prarambham() {
    @data string = "Hello, World!";
    
    // Different hash algorithms
    @md5 string = hash.MD5(data);
    @sha1 string = hash.SHA1(data);
    @sha256 string = hash.SHA256(data);
    @sha512 string = hash.SHA512(data);
    
    fmt.Printf("MD5: %s\n", md5);
    fmt.Printf("SHA1: %s\n", sha1);
    fmt.Printf("SHA256: %s\n", sha256);
    fmt.Printf("SHA512: %s\n", sha512);
    
    // HMAC
    @key string = "secret";
    @hmac string = hash.HMAC(key, data, "sha256");
    fmt.Printf("HMAC-SHA256: %s\n", hmac);
}
```

## Notes

- All hash functions return hexadecimal strings (lowercase)
- Same input always produces same hash (deterministic)
- Small changes in input produce completely different hashes
- Hash functions are one-way (cannot recover original data from hash)
- For production security, compile with OpenSSL support

## Encryption Algorithms

### AES Encryption

**`crypto.AESEncrypt(data, key, mode)`** - AES encryption

- `data`: String to encrypt
- `key`: Encryption key (16 bytes for AES-128, 24 bytes for AES-192, 32 bytes for AES-256)
- `mode`: Encryption mode ("cbc" or "ecb")
- Returns: Base64-encoded encrypted data (includes IV for CBC mode)

**Example:**
```tl
@key string = "1234567890123456";  // 16 bytes for AES-128
@data string = "Secret message";
@encrypted string = crypto.AESEncrypt(data, key, "cbc");
fmt.Printf("Encrypted: %s\n", encrypted);
```

**`crypto.AESDecrypt(encrypted, key, mode)`** - AES decryption

- `encrypted`: Base64-encoded encrypted data
- `key`: Encryption key (must match encryption key)
- `mode`: Encryption mode ("cbc" or "ecb")
- Returns: Decrypted plaintext string

**Example:**
```tl
@decrypted string = crypto.AESDecrypt(encrypted, key, "cbc");
fmt.Printf("Decrypted: %s\n", decrypted);
```

### DES Encryption (Deprecated)

**`crypto.DESEncrypt(data, key)`** - DES encryption

- `data`: String to encrypt
- `key`: Encryption key (8 bytes)
- Returns: Base64-encoded encrypted data
- **Warning:** DES is cryptographically weak. Use AES instead.

**Example:**
```tl
@key string = "12345678";  // 8 bytes for DES
@data string = "Message";
@encrypted string = crypto.DESEncrypt(data, key);
```

**`crypto.DESDecrypt(encrypted, key)`** - DES decryption

- `encrypted`: Base64-encoded encrypted data
- `key`: Encryption key (must match encryption key)
- Returns: Decrypted plaintext string

### Key Generation

**`crypto.GenerateKey(length)`** - Generate random encryption key

- `length`: Key length in bytes (1-64, default 32 for 256-bit key)
- Returns: Random key as hexadecimal string

**Example:**
```tl
@key128 string = crypto.GenerateKey(16);  // 128-bit key
@key256 string = crypto.GenerateKey(32);  // 256-bit key
fmt.Printf("AES-128 key: %s\n", key128);
fmt.Printf("AES-256 key: %s\n", key256);
```

## Encryption Algorithm Comparison

| Algorithm | Key Size | Block Size | Security | Speed | Recommendation |
|-----------|----------|------------|----------|-------|----------------|
| AES-128   | 128 bits | 128 bits   | High     | Fast  | ✅ Recommended |
| AES-192   | 192 bits | 128 bits   | Very High| Medium| ✅ Recommended |
| AES-256   | 256 bits | 128 bits   | Very High| Medium| ✅ Recommended |
| DES       | 56 bits  | 64 bits    | Weak     | Fast  | ❌ Deprecated |

## Encryption Use Cases

### Encrypting Sensitive Data

```tl
@key string = crypto.GenerateKey(32);  // Generate 256-bit key
@sensitiveData string = "Credit card: 1234-5678-9012-3456";
@encrypted string = crypto.AESEncrypt(sensitiveData, key, "cbc");
// Store encrypted data securely
```

### Decrypting Data

```tl
@decrypted string = crypto.AESDecrypt(encrypted, key, "cbc");
fmt.Printf("Decrypted: %s\n", decrypted);
```

### Secure File Encryption

```tl
@fileContent string = io.ReadFile("secret.txt");
@key string = crypto.GenerateKey(32);
@encrypted string = crypto.AESEncrypt(fileContent, key, "cbc");
io.WriteFile("secret.enc", encrypted);
// Store key securely (never in the same location as encrypted file)
```

## Security Best Practices

### Encryption

1. **Use AES-256** for maximum security
2. **Use CBC mode** for most applications (ECB is less secure)
3. **Generate random keys** using `crypto.GenerateKey()`
4. **Store keys securely** - never hardcode keys in source code
5. **Use proper key management** - consider key derivation functions (PBKDF2, Argon2)
6. **Never use DES** - it's cryptographically broken

### Key Management

1. **Generate strong keys** - use `crypto.GenerateKey()` with appropriate length
2. **Store keys securely** - use environment variables or secure key stores
3. **Never commit keys** to version control
4. **Rotate keys periodically** for long-term security
5. **Use different keys** for different purposes

### General Security

1. **Always use OpenSSL** for production (compile with `-DUSE_OPENSSL`)
2. **Validate input** before encryption/decryption
3. **Handle errors** properly - encryption can fail
4. **Use authenticated encryption** (AES-GCM) when available for additional security
5. **Keep libraries updated** - security vulnerabilities are discovered regularly

## Complete Example

```tl
#prarambham() {
    // Generate a secure key
    @key string = crypto.GenerateKey(32);  // 256-bit key
    fmt.Printf("Generated key: %s\n", key);
    
    // Original message
    @message string = "This is a secret message!";
    fmt.Printf("Original: %s\n", message);
    
    // Encrypt
    @encrypted string = crypto.AESEncrypt(message, key, "cbc");
    fmt.Printf("Encrypted: %s\n", encrypted);
    
    // Decrypt
    @decrypted string = crypto.AESDecrypt(encrypted, key, "cbc");
    fmt.Printf("Decrypted: %s\n", decrypted);
    
    // Verify
    okavela message == decrypted {
        fmt.Printf("Encryption/Decryption successful!\n");
    }
}
```

## OpenSSL Integration

For production use with cryptographically secure encryption, compile with OpenSSL:

```bash
# Compile with OpenSSL support
gcc -DUSE_OPENSSL output.c -o program -lssl -lcrypto
```

Without OpenSSL, the library uses placeholder implementations suitable for testing but **NOT cryptographically secure**.

## Notes

- **AES encryption** returns base64-encoded strings for easy storage/transmission
- **CBC mode** includes IV (Initialization Vector) in the encrypted output
- **ECB mode** does not use IV (less secure, not recommended)
- **Key length** determines AES variant: 16 bytes = AES-128, 24 bytes = AES-192, 32 bytes = AES-256
- **DES is deprecated** - use only for legacy compatibility, prefer AES
- **Always use OpenSSL** for production security

## Advanced Encryption Algorithms

### AES-GCM (Authenticated Encryption)

**`crypto.AESGCMEncrypt(data, key, aad)`** - AES-GCM authenticated encryption

- `data`: String to encrypt
- `key`: Encryption key (16 bytes for AES-128-GCM, 24 bytes for AES-192-GCM, 32 bytes for AES-256-GCM)
- `aad`: Additional Authenticated Data (optional, can be empty string "")
- Returns: Base64-encoded encrypted data (includes IV and authentication tag)
- **Recommended** for most secure applications - provides both encryption and authentication

**Example:**
```tl
@key string = "1234567890123456";  // 16 bytes for AES-128-GCM
@data string = "Secret message";
@aad string = "metadata";  // Optional authenticated data
@encrypted string = crypto.AESGCMEncrypt(data, key, aad);
fmt.Printf("Encrypted: %s\n", encrypted);
```

**`crypto.AESGCMDecrypt(encrypted, key, aad)`** - AES-GCM authenticated decryption

- `encrypted`: Base64-encoded encrypted data
- `key`: Encryption key (must match encryption key)
- `aad`: Additional Authenticated Data (must match encryption AAD)
- Returns: Decrypted plaintext string (empty if authentication fails)

**Example:**
```tl
@decrypted string = crypto.AESGCMDecrypt(encrypted, key, aad);
okavela decrypted != "" {
    fmt.Printf("Decrypted: %s\n", decrypted);
} lekapothe {
    fmt.Printf("Decryption failed - data may be tampered\n");
}
```

**Why AES-GCM?**
- ✅ Provides both encryption and authentication
- ✅ Prevents tampering attacks
- ✅ Industry standard (used in TLS 1.2+, HTTPS)
- ✅ Fast and secure
- ✅ Recommended over AES-CBC for new applications

### ChaCha20-Poly1305 (Modern Stream Cipher)

**`crypto.ChaCha20Poly1305Encrypt(data, key, nonce, aad)`** - ChaCha20-Poly1305 authenticated encryption

- `data`: String to encrypt
- `key`: Encryption key (32 bytes required)
- `nonce`: Nonce (12 bytes, optional - generated randomly if not provided)
- `aad`: Additional Authenticated Data (optional, can be empty string "")
- Returns: Base64-encoded encrypted data (includes nonce and authentication tag)
- **Recommended** for high-performance applications and modern protocols

**Example:**
```tl
@key string = crypto.GenerateKey(32);  // 32 bytes required
@data string = "High-performance encryption";
@nonce string = "";  // Will be generated randomly
@aad string = "";  // Optional
@encrypted string = crypto.ChaCha20Poly1305Encrypt(data, key, nonce, aad);
fmt.Printf("Encrypted: %s\n", encrypted);
```

**`crypto.ChaCha20Poly1305Decrypt(encrypted, key, nonce, aad)`** - ChaCha20-Poly1305 authenticated decryption

- `encrypted`: Base64-encoded encrypted data
- `key`: Encryption key (32 bytes, must match encryption key)
- `nonce`: Nonce (12 bytes, optional - extracted from encrypted data if not provided)
- `aad`: Additional Authenticated Data (must match encryption AAD)
- Returns: Decrypted plaintext string (empty if authentication fails)

**Example:**
```tl
@decrypted string = crypto.ChaCha20Poly1305Decrypt(encrypted, key, nonce, aad);
fmt.Printf("Decrypted: %s\n", decrypted);
```

**Why ChaCha20-Poly1305?**
- ✅ Very fast (faster than AES on many systems)
- ✅ Secure and modern (used in TLS 1.3)
- ✅ Excellent for mobile devices and high-performance applications
- ✅ Provides authenticated encryption
- ✅ Resistant to timing attacks

### PBKDF2 (Password-Based Key Derivation)

**`crypto.PBKDF2(password, salt, iterations, keyLength, hashAlgo)`** - Derive key from password

- `password`: Password string
- `salt`: Salt string (should be random, at least 8 bytes)
- `iterations`: Number of iterations (recommended: 10000+)
- `keyLength`: Desired key length in bytes (1-64, recommended: 32)
- `hashAlgo`: Hash algorithm ("sha1", "sha256", "sha512")
- Returns: Derived key as hexadecimal string

**Example:**
```tl
@password string = "mySecretPassword";
@salt string = crypto.GenerateKey(16);  // Generate random salt
@iterations int = 10000;
@keyLength int = 32;  // 256-bit key
@hashAlgo string = "sha256";
@derivedKey string = crypto.PBKDF2(password, salt, iterations, keyLength, hashAlgo);
fmt.Printf("Derived key: %s\n", derivedKey);
```

**Use Cases:**
- Deriving encryption keys from passwords
- Password hashing (though Argon2/bcrypt are better for passwords)
- Key stretching for weak passwords

**Best Practices:**
- Use at least 10,000 iterations (more is better, but slower)
- Use random salt (at least 8 bytes, preferably 16+)
- Use SHA256 or SHA512 (not SHA1)
- Store salt with the derived key

## Updated Algorithm Comparison

| Algorithm | Type | Key Size | Security | Speed | Authentication | Recommendation |
|-----------|------|----------|----------|-------|----------------|----------------|
| AES-GCM | Authenticated Encryption | 128/192/256 | Very High | Fast | ✅ Yes | ⭐⭐⭐⭐⭐ Recommended |
| ChaCha20-Poly1305 | Authenticated Stream | 256 | Very High | Very Fast | ✅ Yes | ⭐⭐⭐⭐⭐ Recommended |
| AES-CBC | Symmetric | 128/192/256 | High | Fast | ❌ No | ⭐⭐⭐ Good |
| AES-ECB | Symmetric | 128/192/256 | Medium | Fast | ❌ No | ⭐⭐ Avoid |
| DES | Symmetric | 56 | Weak | Fast | ❌ No | ❌ Deprecated |

## When to Use Which Algorithm

### For New Applications (Recommended)
- **AES-GCM** or **ChaCha20-Poly1305** - Use for all new encryption needs
- Provides both encryption and authentication
- Prevents tampering attacks
- Industry standard

### For High Performance
- **ChaCha20-Poly1305** - Fastest, especially on mobile/ARM devices
- **AES-GCM** - Fast with hardware acceleration

### For Password-Based Key Derivation
- **PBKDF2** - Standard, widely supported
- Use with SHA256 or SHA512
- Minimum 10,000 iterations

### For Legacy Compatibility
- **AES-CBC** - If you need compatibility with older systems
- **DES** - Only for legacy systems (avoid for new code)

## Complete Advanced Example

```tl
#prarambham() {
    // AES-GCM Example
    fmt.Printf("=== AES-GCM Authenticated Encryption ===\n");
    @key string = crypto.GenerateKey(32);  // 256-bit key
    @message string = "This message is authenticated";
    @aad string = "metadata123";
    
    @encrypted string = crypto.AESGCMEncrypt(message, key, aad);
    fmt.Printf("Encrypted: %s\n", encrypted);
    
    @decrypted string = crypto.AESGCMDecrypt(encrypted, key, aad);
    fmt.Printf("Decrypted: %s\n", decrypted);
    
    // ChaCha20-Poly1305 Example
    fmt.Printf("\n=== ChaCha20-Poly1305 ===\n");
    @chachaKey string = crypto.GenerateKey(32);
    @chachaEncrypted string = crypto.ChaCha20Poly1305Encrypt(message, chachaKey, "", aad);
    fmt.Printf("Encrypted: %s\n", chachaEncrypted);
    
    @chachaDecrypted string = crypto.ChaCha20Poly1305Decrypt(chachaEncrypted, chachaKey, "", aad);
    fmt.Printf("Decrypted: %s\n", chachaDecrypted);
    
    // PBKDF2 Example
    fmt.Printf("\n=== PBKDF2 Key Derivation ===\n");
    @password string = "userPassword123";
    @salt string = crypto.GenerateKey(16);
    @derivedKey string = crypto.PBKDF2(password, salt, 10000, 32, "sha256");
    fmt.Printf("Password: %s\n", password);
    fmt.Printf("Salt: %s\n", salt);
    fmt.Printf("Derived key: %s\n", derivedKey);
}
```

## Security Best Practices (Updated)

### Encryption
1. **Use authenticated encryption** (AES-GCM, ChaCha20-Poly1305) whenever possible
2. **Never use ECB mode** - it's insecure
3. **Use CBC mode** only if you need legacy compatibility
4. **Generate random keys** using `crypto.GenerateKey()`
5. **Never reuse nonces** with stream ciphers (ChaCha20)
6. **Store keys securely** - never hardcode in source code

### Key Derivation
1. **Use PBKDF2** with at least 10,000 iterations
2. **Use random salt** (at least 8 bytes, preferably 16+)
3. **Use SHA256 or SHA512** (not SHA1)
4. **Store salt** with the derived key
5. **For passwords**, consider Argon2 or bcrypt instead of PBKDF2

### General
1. **Always use OpenSSL** for production (compile with `-DUSE_OPENSSL`)
2. **Validate authentication** - check return values from decrypt functions
3. **Handle errors securely** - don't leak information about failures
4. **Keep libraries updated** - security vulnerabilities are discovered regularly

## Public Key Cryptography

### RSA (Rivest-Shamir-Adleman)

**`crypto.RSAGenerateKeyPair(bits)`** - Generate RSA key pair

- `bits`: Key size in bits (512, 1024, 2048, 4096 - recommended: 2048 or 4096)
- Returns: PEM-encoded key pair as string (format: "PRIVATE_KEY|PUBLIC_KEY")
- **Note:** RSA keys are returned in PEM format, separated by `|`

**Example:**
```tl
@keyPair string = crypto.RSAGenerateKeyPair(2048);
// Extract private and public keys (split by |)
@keys string = strings.Split(keyPair, "|");
@privateKey string = keys[0];
@publicKey string = keys[1];
```

**`crypto.RSAEncrypt(data, publicKeyPEM)`** - RSA encryption

- `data`: String to encrypt
- `publicKeyPEM`: Public key in PEM format
- Returns: Base64-encoded encrypted data
- **Note:** RSA can only encrypt small amounts of data (max ~245 bytes for 2048-bit key)

**Example:**
```tl
@message string = "Secret message";
@encrypted string = crypto.RSAEncrypt(message, publicKey);
fmt.Printf("Encrypted: %s\n", encrypted);
```

**`crypto.RSADecrypt(encrypted, privateKeyPEM)`** - RSA decryption

- `encrypted`: Base64-encoded encrypted data
- `privateKeyPEM`: Private key in PEM format
- Returns: Decrypted plaintext string

**Example:**
```tl
@decrypted string = crypto.RSADecrypt(encrypted, privateKey);
fmt.Printf("Decrypted: %s\n", decrypted);
```

**`crypto.RSASign(data, privateKeyPEM)`** - Create RSA digital signature

- `data`: Data to sign
- `privateKeyPEM`: Private key in PEM format
- Returns: Signature as hexadecimal string

**Example:**
```tl
@signature string = crypto.RSASign("Important document", privateKey);
fmt.Printf("Signature: %s\n", signature);
```

**`crypto.RSAVerify(data, signature, publicKeyPEM)`** - Verify RSA signature

- `data`: Original data
- `signature`: Signature as hexadecimal string
- `publicKeyPEM`: Public key in PEM format
- Returns: 1 if valid, 0 if invalid

**Example:**
```tl
@valid int = crypto.RSAVerify("Important document", signature, publicKey);
okavela valid == 1 {
    fmt.Printf("Signature is valid!\n");
} lekapothe {
    fmt.Printf("Signature is invalid!\n");
}
```

### ECDSA/ECC (Elliptic Curve Cryptography)

**`crypto.ECCGenerateKeyPair(curve)`** - Generate ECC key pair

- `curve`: Curve name ("P-256", "P-384", "P-521", "secp256r1", "secp384r1", "secp521r1")
- Returns: PEM-encoded key pair as string (format: "PRIVATE_KEY|PUBLIC_KEY")
- **Recommended:** Use "P-256" for most applications

**Example:**
```tl
@keyPair string = crypto.ECCGenerateKeyPair("P-256");
@keys string = strings.Split(keyPair, "|");
@privateKey string = keys[0];
@publicKey string = keys[1];
```

**`crypto.ECDSASign(data, privateKeyPEM)`** - Create ECDSA digital signature

- `data`: Data to sign
- `privateKeyPEM`: Private key in PEM format
- Returns: Signature as hexadecimal string

**Example:**
```tl
@signature string = crypto.ECDSASign("Document to sign", privateKey);
fmt.Printf("ECDSA Signature: %s\n", signature);
```

**`crypto.ECDSAVerify(data, signature, publicKeyPEM)`** - Verify ECDSA signature

- `data`: Original data
- `signature`: Signature as hexadecimal string
- `publicKeyPEM`: Public key in PEM format
- Returns: 1 if valid, 0 if invalid

**Example:**
```tl
@valid int = crypto.ECDSAVerify("Document to sign", signature, publicKey);
okavela valid == 1 {
    fmt.Printf("ECDSA signature is valid!\n");
}
```

### Argon2 (Password Hashing)

**`crypto.Argon2Hash(password, salt, timeCost, memoryCost, parallelism)`** - Argon2 password hashing

- `password`: Password to hash
- `salt`: Salt string (should be random, at least 8 bytes)
- `timeCost`: Time cost (iterations, recommended: 2-3)
- `memoryCost`: Memory cost in KB (recommended: 65536 = 64 MB)
- `parallelism`: Parallelism factor (recommended: 4)
- Returns: Hash as hexadecimal string

**Example:**
```tl
@password string = "mySecretPassword";
@salt string = crypto.GenerateKey(16);  // Random salt
@hash string = crypto.Argon2Hash(password, salt, 2, 65536, 4);
fmt.Printf("Argon2 hash: %s\n", hash);
```

**`crypto.Argon2Verify(password, hash)`** - Verify Argon2 password hash

- `password`: Password to verify
- `hash`: Hash to verify against
- Returns: 1 if password matches, 0 otherwise

**Example:**
```tl
@valid int = crypto.Argon2Verify("mySecretPassword", storedHash);
okavela valid == 1 {
    fmt.Printf("Password is correct!\n");
}
```

**Note:** Argon2 implementation uses scrypt (via OpenSSL) as an approximation when full Argon2 library is not available. For production, consider using a dedicated Argon2 library.

## Algorithm Comparison (Updated)

| Algorithm | Type | Key Size | Security | Speed | Use Case |
|-----------|------|----------|----------|-------|----------|
| AES-GCM | Authenticated Encryption | 128/192/256 | Very High | Fast | ✅ Recommended for encryption |
| ChaCha20-Poly1305 | Authenticated Stream | 256 | Very High | Very Fast | ✅ Recommended for high performance |
| RSA | Asymmetric | 2048/4096 | High | Slow | ✅ Key exchange, signatures |
| ECDSA/ECC | Asymmetric | 256/384/521 | Very High | Fast | ✅ Modern signatures, key exchange |
| PBKDF2 | Key Derivation | Variable | High | Medium | ✅ Password-based key derivation |
| Argon2 | Password Hashing | Variable | Very High | Medium | ✅ Modern password hashing |

## Complete Example with RSA and ECDSA

```tl
#prarambham() {
    // RSA Example
    fmt.Printf("=== RSA Public Key Cryptography ===\n");
    @rsaKeys string = crypto.RSAGenerateKeyPair(2048);
    @rsaKeyParts string = strings.Split(rsaKeys, "|");
    @rsaPrivate string = rsaKeyParts[0];
    @rsaPublic string = rsaKeyParts[1];
    
    @message string = "RSA encrypted message";
    @rsaEncrypted string = crypto.RSAEncrypt(message, rsaPublic);
    fmt.Printf("RSA Encrypted: %s\n", rsaEncrypted);
    
    @rsaDecrypted string = crypto.RSADecrypt(rsaEncrypted, rsaPrivate);
    fmt.Printf("RSA Decrypted: %s\n", rsaDecrypted);
    
    @rsaSignature string = crypto.RSASign(message, rsaPrivate);
    @rsaValid int = crypto.RSAVerify(message, rsaSignature, rsaPublic);
    fmt.Printf("RSA Signature valid: %d\n", rsaValid);
    
    // ECDSA Example
    fmt.Printf("\n=== ECDSA Digital Signatures ===\n");
    @eccKeys string = crypto.ECCGenerateKeyPair("P-256");
    @eccKeyParts string = strings.Split(eccKeys, "|");
    @eccPrivate string = eccKeyParts[0];
    @eccPublic string = eccKeyParts[1];
    
    @document string = "Important document";
    @eccSignature string = crypto.ECDSASign(document, eccPrivate);
    fmt.Printf("ECDSA Signature: %s\n", eccSignature);
    
    @eccValid int = crypto.ECDSAVerify(document, eccSignature, eccPublic);
    fmt.Printf("ECDSA Signature valid: %d\n", eccValid);
    
    // Argon2 Example
    fmt.Printf("\n=== Argon2 Password Hashing ===\n");
    @password string = "userPassword123";
    @salt string = crypto.GenerateKey(16);
    @argon2Hash string = crypto.Argon2Hash(password, salt, 2, 65536, 4);
    fmt.Printf("Argon2 Hash: %s\n", argon2Hash);
    
    @argon2Valid int = crypto.Argon2Verify(password, argon2Hash);
    fmt.Printf("Argon2 Verification: %d\n", argon2Valid);
}
```

## Security Best Practices (Updated)

### Public Key Cryptography

1. **Use RSA 2048-bit or larger** for new applications (4096-bit for high security)
2. **Prefer ECDSA/ECC** over RSA for new applications (smaller keys, faster)
3. **Use P-256 curve** for ECDSA (good balance of security and performance)
4. **Never share private keys** - keep them secure
5. **Use proper key management** - store keys securely, rotate periodically

### Password Hashing

1. **Use Argon2** for new password hashing (recommended by OWASP)
2. **Use PBKDF2** for compatibility with existing systems
3. **Always use random salt** (at least 8 bytes, preferably 16+)
4. **Store salt with hash** for verification
5. **Use appropriate parameters:**
   - Argon2: timeCost=2-3, memoryCost=65536 (64MB), parallelism=4
   - PBKDF2: iterations=10000+ (more is better, but slower)

### General

1. **Always use OpenSSL** for production
2. **Validate all inputs** before cryptographic operations
3. **Handle errors properly** - cryptographic operations can fail
4. **Use authenticated encryption** when possible
5. **Keep libraries updated** - security vulnerabilities are discovered regularly

## Phase 3 Algorithms

### Ed25519 (Modern Signature Scheme)

**`crypto.Ed25519GenerateKeyPair()`** - Generate Ed25519 key pair

- Returns: PEM-encoded key pair as string (format: "PRIVATE_KEY|PUBLIC_KEY")
- **Note:** Ed25519 is a modern, fast signature scheme used in SSH, Git, and many modern systems
- Requires OpenSSL 1.1.1+

**Example:**
```tl
@keyPair string = crypto.Ed25519GenerateKeyPair();
@keys string = strings.Split(keyPair, "|");
@privateKey string = keys[0];
@publicKey string = keys[1];
```

**`crypto.Ed25519Sign(data, privateKeyPEM)`** - Create Ed25519 signature

- `data`: Data to sign
- `privateKeyPEM`: Private key in PEM format
- Returns: Signature as hexadecimal string

**Example:**
```tl
@signature string = crypto.Ed25519Sign("Document", privateKey);
fmt.Printf("Ed25519 Signature: %s\n", signature);
```

**`crypto.Ed25519Verify(data, signature, publicKeyPEM)`** - Verify Ed25519 signature

- `data`: Original data
- `signature`: Signature as hexadecimal string
- `publicKeyPEM`: Public key in PEM format
- Returns: 1 if valid, 0 if invalid

**Example:**
```tl
@valid int = crypto.Ed25519Verify("Document", signature, publicKey);
okavela valid == 1 {
    fmt.Printf("Ed25519 signature is valid!\n");
}
```

**Why Ed25519?**
- ✅ Very fast (faster than RSA and ECDSA)
- ✅ Small signatures (64 bytes)
- ✅ Small keys (32 bytes private, 32 bytes public)
- ✅ High security
- ✅ Used in SSH, Git, modern authentication

### bcrypt (Password Hashing)

**`crypto.BcryptHash(password, cost)`** - bcrypt password hashing

- `password`: Password to hash
- `cost`: Cost factor (4-31, recommended: 10-12)
- Returns: bcrypt hash string
- **Note:** Uses PBKDF2 as approximation when true bcrypt library is not available

**Example:**
```tl
@password string = "myPassword123";
@hash string = crypto.BcryptHash(password, 10);
fmt.Printf("bcrypt hash: %s\n", hash);
```

**`crypto.BcryptVerify(password, hash)`** - Verify bcrypt password hash

- `password`: Password to verify
- `hash`: bcrypt hash to verify against
- Returns: 1 if password matches, 0 otherwise

**Example:**
```tl
@valid int = crypto.BcryptVerify("myPassword123", storedHash);
okavela valid == 1 {
    fmt.Printf("Password is correct!\n");
}
```

**Why bcrypt?**
- ✅ Widely supported and battle-tested
- ✅ Adaptive (cost factor can be increased over time)
- ✅ Good for compatibility with existing systems
- ⚠️ Slower than Argon2, but still secure

### scrypt (Memory-Hard Key Derivation)

**`crypto.Scrypt(password, salt, N, r, p, keyLength)`** - scrypt key derivation

- `password`: Password to derive key from
- `salt`: Salt string (should be random)
- `N`: CPU/memory cost parameter (recommended: 16384)
- `r`: Block size parameter (recommended: 8)
- `p`: Parallelism parameter (recommended: 1)
- `keyLength`: Desired key length in bytes (1-64)
- Returns: Derived key as hexadecimal string

**Example:**
```tl
@password string = "password";
@salt string = crypto.GenerateKey(16);
@key string = crypto.Scrypt(password, salt, 16384, 8, 1, 32);
fmt.Printf("scrypt derived key: %s\n", key);
```

**scrypt Parameters:**
- **N**: CPU/memory cost (must be power of 2, e.g., 16384, 32768)
- **r**: Block size (typically 8)
- **p**: Parallelism (typically 1)
- **Memory usage**: ~128 * N * r bytes

**Why scrypt?**
- ✅ Memory-hard (resistant to ASIC attacks)
- ✅ Used in some cryptocurrencies
- ✅ Good for password-based key derivation
- ✅ More memory-intensive than PBKDF2

## Complete Phase 3 Example

```tl
#prarambham() {
    // Ed25519 Example
    fmt.Printf("=== Ed25519 Signatures ===\n");
    @ed25519Keys string = crypto.Ed25519GenerateKeyPair();
    @edKeys string = strings.Split(ed25519Keys, "|");
    @edPrivate string = edKeys[0];
    @edPublic string = edKeys[1];
    
    @message string = "Ed25519 signed message";
    @edSignature string = crypto.Ed25519Sign(message, edPrivate);
    fmt.Printf("Ed25519 Signature: %s\n", edSignature);
    
    @edValid int = crypto.Ed25519Verify(message, edSignature, edPublic);
    fmt.Printf("Ed25519 valid: %d\n", edValid);
    
    // bcrypt Example
    fmt.Printf("\n=== bcrypt Password Hashing ===\n");
    @password string = "userPassword";
    @bcryptHash string = crypto.BcryptHash(password, 10);
    fmt.Printf("bcrypt hash: %s\n", bcryptHash);
    
    @bcryptValid int = crypto.BcryptVerify(password, bcryptHash);
    fmt.Printf("bcrypt valid: %d\n", bcryptValid);
    
    // scrypt Example
    fmt.Printf("\n=== scrypt Key Derivation ===\n");
    @salt string = crypto.GenerateKey(16);
    @scryptKey string = crypto.Scrypt(password, salt, 16384, 8, 1, 32);
    fmt.Printf("scrypt key: %s\n", scryptKey);
}
```

## Algorithm Comparison (Complete)

| Algorithm | Type | Key Size | Security | Speed | Use Case | Priority |
|-----------|------|----------|----------|-------|----------|----------|
| AES-GCM | Authenticated Encryption | 128/192/256 | Very High | Fast | Encryption | ⭐⭐⭐⭐⭐ |
| ChaCha20-Poly1305 | Authenticated Stream | 256 | Very High | Very Fast | High-performance encryption | ⭐⭐⭐⭐⭐ |
| RSA | Asymmetric | 2048/4096 | High | Slow | Key exchange, signatures | ⭐⭐⭐⭐⭐ |
| ECDSA/ECC | Asymmetric | 256/384/521 | Very High | Fast | Modern signatures | ⭐⭐⭐⭐⭐ |
| PBKDF2 | Key Derivation | Variable | High | Medium | Password-based keys | ⭐⭐⭐⭐ |
| Argon2 | Password Hashing | Variable | Very High | Medium | Modern password hashing | ⭐⭐⭐⭐ |
| Ed25519 | Signatures | 256 | Very High | Very Fast | Modern signatures | ⭐⭐⭐⭐ |
| bcrypt | Password Hashing | Variable | High | Slow | Compatible password hashing | ⭐⭐⭐ |
| scrypt | Key Derivation | Variable | Very High | Medium | Memory-hard key derivation | ⭐⭐⭐ |

## See Also

- [Examples](../examples.md) - Code examples
- [Language Reference](../language-reference.md)
- [Base64 Encoding](../libraries/base64.md) - For encoding/decoding encrypted data
