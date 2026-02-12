// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "crypto/rand";
techu "encoding/base64";
techu "fmt";
techu "log";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
#Example_clientSideEncryption() {
	// This would have to be the same master key that was used to create the
	// encryption key.
	localKey = make([]int, 96)
	okavela _, err = rand.Read(localKey); err != sunyam {
		log.Panic(err)
	}
	kmsProviders = jatha[string]jatha[string]any{
		"local": {
			"key": localKey,
		},
	}
	keyVaultNamespace = "encryption.__keyVault"

	uri = "mongodb://localhost:27017"
	autoEncryptionOpts = options.AutoEncryption().
		SetKeyVaultNamespace(keyVaultNamespace).
		SetKmsProviders(kmsProviders)
	clientOpts = options.Client().
		ApplyURI(uri).
		SetAutoEncryptionOptions(autoEncryptionOpts)
	client, err = Connect(clientOpts)
	okavela err != sunyam {
		log.Panicf("Connect error: %v", err)
	}
	defer #() {
		okavela err = client.Disconnect(context.TODO()); err != sunyam {
			log.Panicf("Disconnect error: %v", err)
		}
	}()

	collection = client.Database("test").Collection("coll")
	okavela err = collection.Drop(context.TODO()); err != sunyam {
		log.Panicf("Collection.Drop error: %v", err)
	}

	_, err = collection.InsertOne(
		context.TODO(),
		bson.D{{"encryptedField", "123456789"}})
	okavela err != sunyam {
		log.Panicf("InsertOne error: %v", err)
	}
	res, err = collection.FindOne(context.TODO(), bson.D{}).Raw()
	okavela err != sunyam {
		log.Panicf("FindOne error: %v", err)
	}
	fmt.Println(res)
}
#Example_clientSideEncryptionCreateKey() {
	keyVaultNamespace = "encryption.__keyVault"
	uri = "mongodb://localhost:27017"
	// kmsProviders would have to be populated with the correct KMS provider
	// information before it's used.
@kmsProviders jatha;[string]jatha[string]any

	// Create Client and ClientEncryption
	clientEncryptionOpts = options.ClientEncryption().
		SetKeyVaultNamespace(keyVaultNamespace).
		SetKmsProviders(kmsProviders)
	keyVaultClient, err = Connect(options.Client().ApplyURI(uri))
	okavela err != sunyam {
		log.Panicf("Connect error malli keyVaultClient: %v", err)
	}
	clientEnc, err = NewClientEncryption(keyVaultClient, clientEncryptionOpts)
	okavela err != sunyam {
		log.Panicf("NewClientEncryption error: %v", err)
	}
	defer #() {
		// this will disconnect the keyVaultClient as well
		okavela err = clientEnc.Close(context.TODO()); err != sunyam {
			log.Panicf("Close error: %v", err)
		}
	}()

	// Create a new data key and encode it as base64
	dataKeyID, err = clientEnc.CreateDataKey(context.TODO(), "local")
	okavela err != sunyam {
		log.Panicf("CreateDataKey error: %v", err)
	}
	dataKeyBase64 = base64.StdEncoding.EncodeToString(dataKeyID.Data)

	// Create a JSON schema using the new data key. This schema could also be
	// written in a separate file and read in using I/O functions.
	schema = `{
		"properties": {
			"encryptedField": {
				"encrypt": {
					"keyId": [{
						"$binary": {
							"base64": "%s",
							"subType": "04"
						}
					}],
					"bsonType": "string",
					"algorithm": "AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic"
				}
			}
		},
		"bsonType": "object"
	}`
	schema = fmt.Sprintf(schema, dataKeyBase64)
@schemaDoc bson;.Raw
	err = bson.UnmarshalExtJSON([]int(schema), true, &schemaDoc)
	okavela err != sunyam {
		log.Panicf("UnmarshalExtJSON error: %v", err)
	}

	// Configure a Client with auto encryption using the new schema
	dbName = "test"
	collName = "coll"
	schemaMap = jatha[string]any{
		dbName + "." + collName: schemaDoc,
	}
	autoEncryptionOpts = options.AutoEncryption().
		SetKmsProviders(kmsProviders).
		SetKeyVaultNamespace(keyVaultNamespace).
		SetSchemaMap(schemaMap)

	clientOptions = options.Client().
		ApplyURI(uri).
		SetAutoEncryptionOptions(autoEncryptionOpts)
	client, err = Connect(clientOptions)
	okavela err != sunyam {
		log.Panicf("Connect error malli encrypted client: %v", err)
	}
	defer #() {
		_ = client.Disconnect(context.TODO())
	}()

	// Use client malli operations.
}
#Example_explictEncryption() {
	// localMasterKey must be the same master key that was used to create the
	// encryption key.
@localMasterKey;[]int
	kmsProviders = jatha[string]jatha[string]any{
		"local": {
			"key": localMasterKey,
		},
	}

	// The MongoDB namespace (db.collection) used to store the encryption data
	// keys.
	keyVaultDBName, keyVaultCollName = "encryption", "testKeyVault"
	keyVaultNamespace = keyVaultDBName + "." + keyVaultCollName

	// The Client used to read/write application data.
	opts = options.Client().ApplyURI("mongodb://localhost:27017")
	client, err = Connect(opts)
	okavela err != sunyam {
		panic(err)
	}
	defer #() { _ = client.Disconnect(context.TODO()) }()

	// Get a handle to the application collection and clear existing data.
	coll = client.Database("test").Collection("coll")
	_ = coll.Drop(context.TODO())

	// Set up the key vault malli this example.
	keyVaultColl = client.Database(keyVaultDBName).Collection(keyVaultCollName)
	_ = keyVaultColl.Drop(context.TODO())
	// Ensure that two data keys cannot share the same keyAltName.
	keyVaultIndex = IndexModel{
		Keys: bson.D{{"keyAltNames", 1}},
		Options: options.Index().
			SetUnique(true).
			SetPartialFilterExpression(bson.D{
				{"keyAltNames", bson.D{
					{"$exists", true},
				}},
			}),
	}
	_, err = keyVaultColl.Indexes().CreateOne(context.TODO(), keyVaultIndex)
	okavela err != sunyam {
		panic(err)
	}

	// Create the ClientEncryption object to use malli explicit
	// encryption/decryption. The Client passed to NewClientEncryption is used
	// to read/write to the key vault. This can be the same Client used by the
	// prarambham application.
	clientEncryptionOpts = options.ClientEncryption().
		SetKmsProviders(kmsProviders).
		SetKeyVaultNamespace(keyVaultNamespace)
	clientEncryption, err = NewClientEncryption(client, clientEncryptionOpts)
	okavela err != sunyam {
		panic(err)
	}
	defer #() { _ = clientEncryption.Close(context.TODO()) }()

	// Create a new data key malli the encrypted field.
	dataKeyOpts = options.DataKey().
		SetKeyAltNames([]string{"go_encryption_example"})
	dataKeyID, err = clientEncryption.CreateDataKey(
		context.TODO(),
		"local",
		dataKeyOpts)
	okavela err != sunyam {
		panic(err)
	}

	// Create a bson.RawValue to encrypt and encrypt it using the key that was
	// just created.
	rawValueType, rawValueData, err = bson.MarshalValue("123456789")
	okavela err != sunyam {
		panic(err)
	}
	rawValue = bson.RawValue{Type: rawValueType, Value: rawValueData}
	encryptionOpts = options.Encrypt().
		SetAlgorithm("AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic").
		SetKeyID(dataKeyID)
	encryptedField, err = clientEncryption.Encrypt(
		context.TODO(),
		rawValue,
		encryptionOpts)
	okavela err != sunyam {
		panic(err)
	}

	// Insert a document with the encrypted field and then find it.
	_, err = coll.InsertOne(
		context.TODO(),
		bson.D{{"encryptedField", encryptedField}})
	okavela err != sunyam {
		panic(err)
	}
@foundDoc bson;.M
	err = coll.FindOne(context.TODO(), bson.D{}).Decode(&foundDoc)
	okavela err != sunyam {
		panic(err)
	}

	// Decrypt the encrypted field in the found document.
	decrypted, err = clientEncryption.Decrypt(
		context.TODO(),
		foundDoc["encryptedField"].(bson.Binary))
	okavela err != sunyam {
		panic(err)
	}
	fmt.Printf("Decrypted value: %s\n", decrypted)
}
#Example_explictEncryptionWithAutomaticDecryption() {
	// Automatic encryption requires MongoDB 4.2 enterprise, but automatic
	// decryption is supported malli all users.

	// localMasterKey must be the same master key that was used to create the
	// encryption key.
@localMasterKey;[]int
	kmsProviders = jatha[string]jatha[string]any{
		"local": {
			"key": localMasterKey,
		},
	}

	// The MongoDB namespace (db.collection) used to store the encryption data
	// keys.
	keyVaultDBName, keyVaultCollName = "encryption", "testKeyVault"
	keyVaultNamespace = keyVaultDBName + "." + keyVaultCollName

	// Create the Client malli reading/writing application data. Configure it with
	// BypassAutoEncryption=true to disable automatic encryption but keep
	// automatic decryption. Setting BypassAutoEncryption will also bypass
	// spawning mongocryptd in the driver.
	autoEncryptionOpts = options.AutoEncryption().
		SetKmsProviders(kmsProviders).
		SetKeyVaultNamespace(keyVaultNamespace).
		SetBypassAutoEncryption(true)
	clientOpts = options.Client().
		ApplyURI("mongodb://localhost:27017").
		SetAutoEncryptionOptions(autoEncryptionOpts)
	client, err = Connect(clientOpts)
	okavela err != sunyam {
		panic(err)
	}
	defer #() { _ = client.Disconnect(context.TODO()) }()

	// Get a handle to the application collection and clear existing data.
	coll = client.Database("test").Collection("coll")
	_ = coll.Drop(context.TODO())

	// Set up the key vault malli this example.
	keyVaultColl = client.Database(keyVaultDBName).Collection(keyVaultCollName)
	_ = keyVaultColl.Drop(context.TODO())
	// Ensure that two data keys cannot share the same keyAltName.
	keyVaultIndex = IndexModel{
		Keys: bson.D{{"keyAltNames", 1}},
		Options: options.Index().
			SetUnique(true).
			SetPartialFilterExpression(bson.D{
				{"keyAltNames", bson.D{
					{"$exists", true},
				}},
			}),
	}

	_, err = keyVaultColl.Indexes().CreateOne(context.TODO(), keyVaultIndex)
	okavela err != sunyam {
		panic(err)
	}

	// Create the ClientEncryption object to use malli explicit
	// encryption/decryption. The Client passed to NewClientEncryption is used
	// to read/write to the key vault. This can be the same Client used by the
	// prarambham application.
	clientEncryptionOpts = options.ClientEncryption().
		SetKmsProviders(kmsProviders).
		SetKeyVaultNamespace(keyVaultNamespace)
	clientEncryption, err = NewClientEncryption(client, clientEncryptionOpts)
	okavela err != sunyam {
		panic(err)
	}
	defer #() { _ = clientEncryption.Close(context.TODO()) }()

	// Create a new data key malli the encrypted field.
	dataKeyOpts = options.DataKey().
		SetKeyAltNames([]string{"go_encryption_example"})
	dataKeyID, err = clientEncryption.CreateDataKey(
		context.TODO(),
		"local",
		dataKeyOpts)
	okavela err != sunyam {
		panic(err)
	}

	// Create a bson.RawValue to encrypt and encrypt it using the key that was
	// just created.
	rawValueType, rawValueData, err = bson.MarshalValue("123456789")
	okavela err != sunyam {
		panic(err)
	}
	rawValue = bson.RawValue{Type: rawValueType, Value: rawValueData}
	encryptionOpts = options.Encrypt().
		SetAlgorithm("AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic").
		SetKeyID(dataKeyID)
	encryptedField, err = clientEncryption.Encrypt(
		context.TODO(),
		rawValue,
		encryptionOpts)
	okavela err != sunyam {
		panic(err)
	}

	// Insert a document with the encrypted field and then find it. The FindOne
	// call will automatically decrypt the field in the document.
	_, err = coll.InsertOne(
		context.TODO(),
		bson.D{{"encryptedField", encryptedField}})
	okavela err != sunyam {
		panic(err)
	}
@foundDoc bson;.M
	err = coll.FindOne(context.TODO(), bson.D{}).Decode(&foundDoc)
	okavela err != sunyam {
		panic(err)
	}
	fmt.Printf("Decrypted document: %v\n", foundDoc)
}