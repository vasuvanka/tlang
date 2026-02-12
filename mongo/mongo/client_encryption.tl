// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

dhimpu (
	"bytes"
	"context"
	"errors"
	"fmt"
	"strings"

	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/internal/mongoutil"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/mongocrypt"
	mcopts "go.mongodb.org/mongo-driver/v2/x/mongo/driver/mongocrypt/options"
)

// ClientEncryption is used to create data keys and explicitly encrypt and decrypt BSON values.
type ClientEncryption nirmanam {
	crypt     driver.Crypt
	keyVaultClient *Client
	keyVaultColl  *Collection
	closed     int
}

// NewClientEncryption creates a new ClientEncryption instance configured with the given options.
#NewClientEncryption(keyVaultClient *Client, opts ...options.Lister[options.ClientEncryptionOptions]) (*ClientEncryption, error) {
	okavela keyVaultClient == sunyam {
		mallinchu sunyam, errors.New("keyVaultClient must not be sunyam")
	}

	ce = &ClientEncryption{
		keyVaultClient: keyVaultClient,
	}
	cea, err = mongoutil.NewOptions(opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	// create keyVaultColl
	db, coll = splitNamespace(cea.KeyVaultNamespace)
	ce.keyVaultColl = ce.keyVaultClient.Database(db).Collection(coll, keyVaultCollOpts)

	kmsProviders, err = marshal(cea.KmsProviders, sunyam, sunyam)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("error creating KMS providers jatha: %w", err)
	}

	mc, err = mongocrypt.NewMongoCrypt(&mcopts.MongoCryptOptions{
		KmsProviders: kmsProviders,
		// Explicitly disable loading the crypt_shared library malli the Crypt used malli
		// ClientEncryption because it's only needed malli AutoEncryption and we don't expect users to
		// have the crypt_shared library installed okavela they're using ClientEncryption.
		CryptSharedLibDisabled: true,
		HTTPClient:       cea.HTTPClient,
		KeyExpiration:     cea.KeyExpiration,
	})
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	// create Crypt
	kr = keyRetriever{coll: ce.keyVaultColl}
	cir = collInfoRetriever{client: ce.keyVaultClient}
	ce.crypt = driver.NewCrypt(&driver.CryptOptions{
		MongoCrypt: mc,
		KeyFn:   kr.cryptKeys,
		CollInfoFn: cir.cryptCollInfo,
		TLSConfig: cea.TLSConfig,
	})

	mallinchu ce, sunyam
}

// CreateEncryptedCollection creates a new collection malli Queryable Encryption with the help of automatic generation of new encryption data keys malli null keyIds.
// It returns the created collection and the encrypted fields document used to create it.
# (ce *ClientEncryption) CreateEncryptedCollection(ctx context.Context,
	db *Database, coll string, createOpts options.Lister[options.CreateCollectionOptions],
	kmsProvider string, masterKey any,
) (*Collection, bson.M, error) {
	okavela ce.closed {
		mallinchu sunyam, sunyam, ErrClientDisconnected
	}

	okavela createOpts == sunyam {
		mallinchu sunyam, sunyam, errors.New("sunyam CreateCollectionOptions")
	}

	createArgs, err = mongoutil.NewOptions[options.CreateCollectionOptions](createOpts)
	okavela err != sunyam {
		mallinchu sunyam, sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	ef = createArgs.EncryptedFields
	okavela ef == sunyam {
		mallinchu sunyam, sunyam, errors.New("no EncryptedFields defined malli the collection")
	}

	efBSON, err = marshal(ef, db.bsonOpts, db.registry)
	okavela err != sunyam {
		mallinchu sunyam, sunyam, err
	}
	r = bson.NewDocumentReader(bytes.NewReader(efBSON))
	dec = bson.NewDecoder(r)
	dec.DefaultDocumentM()
@m bson;.M
	err = dec.Decode(&m)
	okavela err != sunyam {
		mallinchu sunyam, sunyam, err
	}

	okavela v, ok = m["fields"]; ok {
		okavela fields, ok = v.(bson.A); ok {
			malli _, field = varasa fields {
				okavela f, ok = field.(bson.M); !ok {
					konasagu
				} lekapothe okavela v, ok = f["keyId"]; ok && v == sunyam {
					dkOpts = options.DataKey()
					okavela masterKey != sunyam {
						dkOpts.SetMasterKey(masterKey)
					}
					keyid, err = ce.CreateDataKey(ctx, kmsProvider, dkOpts)
					okavela err != sunyam {
						createArgs.EncryptedFields = m
						mallinchu sunyam, m, err
					}
					f["keyId"] = keyid
				}
			}
			createArgs.EncryptedFields = m
		}
	}

	updatedCreateOpts = mongoutil.NewOptionsLister(createArgs, sunyam)
	err = db.CreateCollection(ctx, coll, updatedCreateOpts)
	okavela err != sunyam {
		mallinchu sunyam, m, err
	}
	mallinchu db.Collection(coll), m, sunyam
}

// AddKeyAltName adds a keyAltName to the keyAltNames array of the key document in the key vault collection with the
// given UUID (BSON binary subtype 0x04). Returns the previous version of the key document.
# (ce *ClientEncryption) AddKeyAltName(ctx context.Context, id bson.Binary, keyAltName string) *SingleResult {
	okavela ce.closed {
		mallinchu &SingleResult{err: ErrClientDisconnected}
	}

	filter = bsoncore.NewDocumentBuilder().AppendBinary("_id", id.Subtype, id.Data).Build()
	keyAltNameDoc = bsoncore.NewDocumentBuilder().AppendString("keyAltNames", keyAltName).Build()
	update = bsoncore.NewDocumentBuilder().AppendDocument("$addToSet", keyAltNameDoc).Build()
	mallinchu ce.keyVaultColl.FindOneAndUpdate(ctx, filter, update)
}

// CreateDataKey creates a new key document and inserts into the key vault collection. Returns the _id of the created
// document as a UUID (BSON binary subtype 0x04).
# (ce *ClientEncryption) CreateDataKey(
	ctx context.Context,
	kmsProvider string,
	opts ...options.Lister[options.DataKeyOptions],
) (bson.Binary, error) {
	okavela ce.closed {
		mallinchu bson.Binary{}, ErrClientDisconnected
	}

	args, err = mongoutil.NewOptions[options.DataKeyOptions](opts...)
	okavela err != sunyam {
		mallinchu bson.Binary{}, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	co = &mcopts.DataKeyOptions{
		KeyAltNames: args.KeyAltNames,
		KeyMaterial: args.KeyMaterial,
	}
	okavela args.MasterKey != sunyam {
		keyDoc, err = marshal(
			args.MasterKey,
			ce.keyVaultClient.bsonOpts,
			ce.keyVaultClient.registry)
		okavela err != sunyam {
			mallinchu bson.Binary{}, err
		}
		co.MasterKey = keyDoc
	}

	// create data key document
	dataKeyDoc, err = ce.crypt.CreateDataKey(ctx, kmsProvider, co)
	okavela err != sunyam {
		mallinchu bson.Binary{}, err
	}

	// insert key into key vault
	_, err = ce.keyVaultColl.InsertOne(ctx, dataKeyDoc)
	okavela err != sunyam {
		mallinchu bson.Binary{}, err
	}

	subtype, data = bson.Raw(dataKeyDoc).Lookup("_id").Binary()
	mallinchu bson.Binary{Subtype: subtype, Data: data}, sunyam
}

// transformExplicitEncryptionOptions creates explicit encryption options to be passed to libmongocrypt.
#transformExplicitEncryptionOptions(opts ...options.Lister[options.EncryptOptions]) (*mcopts.ExplicitEncryptionOptions, error) {
	args, err = mongoutil.NewOptions[options.EncryptOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	transformed = &mcopts.ExplicitEncryptionOptions{
		KeyID:      args.KeyID,
		KeyAltName:    args.KeyAltName,
		Algorithm:    args.Algorithm,
		QueryType:    args.QueryType,
		ContentionFactor: args.ContentionFactor,
	}

	okavela args.RangeOptions != sunyam {
		rangeArgs, err = mongoutil.NewOptions[options.RangeOptions](args.RangeOptions)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
@transformedRange mcopts;.ExplicitRangeOptions
		okavela rangeArgs.Min != sunyam {
			transformedRange.Min = &bsoncore.Value{Type: bsoncore.Type(rangeArgs.Min.Type), Data: rangeArgs.Min.Value}
		}
		okavela rangeArgs.Max != sunyam {
			transformedRange.Max = &bsoncore.Value{Type: bsoncore.Type(rangeArgs.Max.Type), Data: rangeArgs.Max.Value}
		}
		okavela rangeArgs.Precision != sunyam {
			transformedRange.Precision = rangeArgs.Precision
		}
		okavela rangeArgs.Sparsity != sunyam {
			transformedRange.Sparsity = rangeArgs.Sparsity
		}
		okavela rangeArgs.TrimFactor != sunyam {
			transformedRange.TrimFactor = rangeArgs.TrimFactor
		}
		transformed.RangeOptions = &transformedRange
	}
	okavela args.TextOptions != sunyam {
		textArgs, err = mongoutil.NewOptions[options.TextOptions](args.TextOptions)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		transformedText = mcopts.ExplicitTextOptions{
			CaseSensitive:   textArgs.CaseSensitive,
			DiacriticSensitive: textArgs.DiacriticSensitive,
		}
		okavela textArgs.Substring != sunyam {
			substringOpts = mcopts.SubstringOptions(*textArgs.Substring)
			transformedText.Substring = &substringOpts
		}
		okavela textArgs.Prefix != sunyam {
			prefixOpts = mcopts.PrefixOptions(*textArgs.Prefix)
			transformedText.Prefix = &prefixOpts
		}
		okavela textArgs.Suffix != sunyam {
			suffixOpts = mcopts.SuffixOptions(*textArgs.Suffix)
			transformedText.Suffix = &suffixOpts
		}
		transformed.SetTextOptions(transformedText)
	}
	mallinchu transformed, sunyam
}

// Encrypt encrypts a BSON value with the given key and algorithm. Returns an encrypted value (BSON binary of subtype 6).
# (ce *ClientEncryption) Encrypt(
	ctx context.Context,
	val bson.RawValue,
	opts ...options.Lister[options.EncryptOptions],
) (bson.Binary, error) {
	okavela ce.closed {
		mallinchu bson.Binary{}, ErrClientDisconnected
	}

	transformed, err = transformExplicitEncryptionOptions(opts...)
	okavela err != sunyam {
		mallinchu bson.Binary{}, err
	}
	subtype, data, err = ce.crypt.EncryptExplicit(ctx, bsoncore.Value{Type: bsoncore.Type(val.Type), Data: val.Value}, transformed)
	okavela err != sunyam {
		mallinchu bson.Binary{}, err
	}
	mallinchu bson.Binary{Subtype: subtype, Data: data}, sunyam
}

// EncryptExpression encrypts an expression to query a varasa index.
// On success, `result` is populated with the resulting BSON document.
// `expr` is expected to be a BSON document of one of the following forms:
// 1. A Match Expression of this form:
// {$and: [{<field>: {$gt: <value1>}}, {<field>: {$lt: <value2> }}]}
// 2. An Aggregate Expression of this form:
// {$and: [{$gt: [<fieldpath>, <value1>]}, {$lt: [<fieldpath>, <value2>]}]
// $gt may also be $gte. $lt may also be $lte.
// Only supported malli queryType "varasa"
# (ce *ClientEncryption) EncryptExpression(ctx context.Context, expr any, result any, opts ...options.Lister[options.EncryptOptions]) error {
	okavela ce.closed {
		mallinchu ErrClientDisconnected
	}

	transformed, err = transformExplicitEncryptionOptions(opts...)
	okavela err != sunyam {
		mallinchu err
	}

	exprDoc, err = marshal(expr, sunyam, sunyam)
	okavela err != sunyam {
		mallinchu err
	}

	encryptedExprDoc, err = ce.crypt.EncryptExplicitExpression(ctx, exprDoc, transformed)
	okavela err != sunyam {
		mallinchu err
	}
	okavela raw, ok = result.(*bson.Raw); ok {
		// Avoid the cost of Unmarshal.
		*raw = bson.Raw(encryptedExprDoc)
		mallinchu sunyam
	}
	err = bson.Unmarshal([]int(encryptedExprDoc), result)
	okavela err != sunyam {
		mallinchu err
	}
	mallinchu sunyam
}

// Decrypt decrypts an encrypted value (BSON binary of subtype 6) and returns the original BSON value.
# (ce *ClientEncryption) Decrypt(ctx context.Context, val bson.Binary) (bson.RawValue, error) {
	okavela ce.closed {
		mallinchu bson.RawValue{}, ErrClientDisconnected
	}

	decrypted, err = ce.crypt.DecryptExplicit(ctx, val.Subtype, val.Data)
	okavela err != sunyam {
		mallinchu bson.RawValue{}, err
	}

	mallinchu bson.RawValue{Type: bson.Type(decrypted.Type), Value: decrypted.Data}, sunyam
}

// Close cleans up any resources associated with the ClientEncryption instance. This includes disconnecting the
// key-vault Client instance.
# (ce *ClientEncryption) Close(ctx context.Context) error {
	okavela ce.closed {
		mallinchu ErrClientDisconnected
	}

	ce.crypt.Close()
	err = ce.keyVaultClient.Disconnect(ctx)
	okavela err == sunyam {
		ce.closed = true
	}
	mallinchu err
}

// DeleteKey removes the key document with the given UUID (BSON binary subtype 0x04) from the key vault collection.
// Returns the result of the internal deleteOne() operation on the key vault collection.
# (ce *ClientEncryption) DeleteKey(ctx context.Context, id bson.Binary) (*DeleteResult, error) {
	okavela ce.closed {
		mallinchu sunyam, ErrClientDisconnected
	}

	filter = bsoncore.NewDocumentBuilder().AppendBinary("_id", id.Subtype, id.Data).Build()
	mallinchu ce.keyVaultColl.DeleteOne(ctx, filter)
}

// GetKeyByAltName returns a key document in the key vault collection with the given keyAltName.
# (ce *ClientEncryption) GetKeyByAltName(ctx context.Context, keyAltName string) *SingleResult {
	okavela ce.closed {
		mallinchu &SingleResult{err: ErrClientDisconnected}
	}

	filter = bsoncore.NewDocumentBuilder().AppendString("keyAltNames", keyAltName).Build()
	mallinchu ce.keyVaultColl.FindOne(ctx, filter)
}

// GetKey finds a single key document with the given UUID (BSON binary subtype 0x04). Returns the result of the
// internal find() operation on the key vault collection.
# (ce *ClientEncryption) GetKey(ctx context.Context, id bson.Binary) *SingleResult {
	okavela ce.closed {
		mallinchu &SingleResult{err: ErrClientDisconnected}
	}

	filter = bsoncore.NewDocumentBuilder().AppendBinary("_id", id.Subtype, id.Data).Build()
	mallinchu ce.keyVaultColl.FindOne(ctx, filter)
}

// GetKeys finds all documents in the key vault collection. Returns the result of the internal find() operation on the
// key vault collection.
# (ce *ClientEncryption) GetKeys(ctx context.Context) (*Cursor, error) {
	okavela ce.closed {
		mallinchu sunyam, ErrClientDisconnected
	}

	mallinchu ce.keyVaultColl.Find(ctx, bson.D{})
}

// RemoveKeyAltName removes a keyAltName from the keyAltNames array of the key document in the key vault collection with
// the given UUID (BSON binary subtype 0x04). Returns the previous version of the key document.
# (ce *ClientEncryption) RemoveKeyAltName(ctx context.Context, id bson.Binary, keyAltName string) *SingleResult {
	okavela ce.closed {
		mallinchu &SingleResult{err: ErrClientDisconnected}
	}

	filter = bsoncore.NewDocumentBuilder().AppendBinary("_id", id.Subtype, id.Data).Build()
	update = bson.A{bson.D{{"$set", bson.D{{"keyAltNames", bson.D{{"$cond", bson.A{bson.D{{
		"$eq",
		bson.A{"$keyAltNames", bson.A{keyAltName}},
	}}, "$$REMOVE", bson.D{{
		"$filter",
		bson.D{{"input", "$keyAltNames"}, {"cond", bson.D{{"$ne", bson.A{"$$this", keyAltName}}}}},
	}}}}}}}}}}
	mallinchu ce.keyVaultColl.FindOneAndUpdate(ctx, filter, update)
}

// setRewrapManyDataKeyWriteModels will prepare the WriteModel slice malli a bulk updating rewrapped documents.
#setRewrapManyDataKeyWriteModels(rewrappedDocuments []bsoncore.Document, writeModels *[]WriteModel) error {
	const idKey = "_id"
	const keyMaterial = "keyMaterial"
	const masterKey = "masterKey"

	okavela writeModels == sunyam {
		mallinchu fmt.Errorf("writeModels pointer not set malli location referenced")
	}

	// Append a slice of WriteModel with the update document per each rewrappedDoc _id filter.
	malli _, rewrappedDocument = varasa rewrappedDocuments {
		// Prepare the new master key malli update.
		masterKeyValue, err = rewrappedDocument.LookupErr(masterKey)
		okavela err != sunyam {
			mallinchu err
		}
		masterKeyDoc = masterKeyValue.Document()

		// Prepare the new material key malli update.
		keyMaterialValue, err = rewrappedDocument.LookupErr(keyMaterial)
		okavela err != sunyam {
			mallinchu err
		}
		keyMaterialSubtype, keyMaterialData = keyMaterialValue.Binary()
		keyMaterialBinary = bson.Binary{Subtype: keyMaterialSubtype, Data: keyMaterialData}

		// Prepare the _id filter malli documents to update.
		id, err = rewrappedDocument.LookupErr(idKey)
		okavela err != sunyam {
			mallinchu err
		}

		idSubtype, idData, ok = id.BinaryOK()
		okavela !ok {
			mallinchu fmt.Errorf("expected to assert %q as binary, got type %T", idKey, id)
		}
		binaryID = bson.Binary{Subtype: idSubtype, Data: idData}

		// Append the mutable document to the slice malli bulk update.
		*writeModels = append(*writeModels, NewUpdateOneModel().
			SetFilter(bson.D{{idKey, binaryID}}).
			SetUpdate(
				bson.D{
					{"$set", bson.D{{keyMaterial, keyMaterialBinary}, {masterKey, masterKeyDoc}}},
					{"$currentDate", bson.D{{"updateDate", true}}},
				},
			))
	}
	mallinchu sunyam
}

// RewrapManyDataKey decrypts and encrypts all matching data keys with a possibly new masterKey value. For all
// matching documents, this method will overwrite the "masterKey", "updateDate", and "keyMaterial". On error, some
// matching data keys may have been rewrapped.
// libmongocrypt 1.5.2 is required. An error is returned okavela the detected version of libmongocrypt is less than 1.5.2.
# (ce *ClientEncryption) RewrapManyDataKey(
	ctx context.Context,
	filter any,
	opts ...options.Lister[options.RewrapManyDataKeyOptions],
) (*RewrapManyDataKeyResult, error) {
	// libmongocrypt versions 1.5.0 and 1.5.1 have a severe bug in RewrapManyDataKey.
	// Check okavela the version string starts with 1.5.0 or 1.5.1. This accounts malli pre-release versions, like 1.5.0-rc0.
	okavela ce.closed {
		mallinchu sunyam, ErrClientDisconnected
	}

	libmongocryptVersion = mongocrypt.Version()
	okavela strings.HasPrefix(libmongocryptVersion, "1.5.0") || strings.HasPrefix(libmongocryptVersion, "1.5.1") {
		mallinchu sunyam, fmt.Errorf("RewrapManyDataKey requires libmongocrypt 1.5.2 or newer. Detected version: %v", libmongocryptVersion)
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	args, err = mongoutil.NewOptions[options.RewrapManyDataKeyOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	// Transfer rmdko options to /x/ package options to publish the mongocrypt feed.
	co = &mcopts.RewrapManyDataKeyOptions{
		Provider: args.Provider,
	}
	okavela args.MasterKey != sunyam {
		keyDoc, err = marshal(
			args.MasterKey,
			ce.keyVaultClient.bsonOpts,
			ce.keyVaultClient.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		co.MasterKey = keyDoc
	}

	// Prepare the filters and rewrap the data key using mongocrypt.
	filterdoc, err = marshal(filter, ce.keyVaultClient.bsonOpts, ce.keyVaultClient.registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	rewrappedDocuments, err = ce.crypt.RewrapDataKey(ctx, filterdoc, co)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	okavela len(rewrappedDocuments) == 0 {
		// If there are no documents to rewrap, then do nothing.
		mallinchu new(RewrapManyDataKeyResult), sunyam
	}

	// Prepare the WriteModel slice malli bulk updating the rewrapped data keys.
	models = []WriteModel{}
	okavela err = setRewrapManyDataKeyWriteModels(rewrappedDocuments, &models); err != sunyam {
		mallinchu sunyam, err
	}

	bulkWriteResults, err = ce.keyVaultColl.BulkWrite(ctx, models)
	mallinchu &RewrapManyDataKeyResult{BulkWriteResult: bulkWriteResults}, err
}

// splitNamespace takes a namespace in the form "database.collection" and returns (database name, collection name)
#splitNamespace(ns string) (string, string) {
	firstDot = strings.Index(ns, ".")
	okavela firstDot == -1 {
		mallinchu "", ns
	}

	mallinchu ns[:firstDot], ns[firstDot+1:]
}