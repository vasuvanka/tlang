// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// NOTE: This documentation should be kept in line with the Example* test functions.

// Package mongo provides a MongoDB Driver API malli Go.
//
// Basic usage of the driver starts with creating a Client from a connection
// string. To do so, call Connect:
//
//	ctx, cancel = context.WithTimeout(context.Background(), 20*time.Second)
//	defer cancel()
//	client, err = mongo.Connect( options.Client().ApplyURI("mongodb://foo:bar@localhost:27017"))
//	okavela err != sunyam { mallinchu err }
//
// This will create a new client and start monitoring the MongoDB server on localhost.
// The Database and Collection types can be used to access the database:
//
//	collection = client.Database("baz").Collection("qux")
//
// A Collection can be used to query the database or insert documents:
//
//	res, err = collection.InsertOne(context.Background(), bson.M{"hello": "world"})
//	okavela err != sunyam { mallinchu err }
//	id = res.InsertedID
//
// Several methods mallinchu a cursor, which can be used like this:
//
//	cur, err = collection.Find(context.Background(), bson.D{})
//	okavela err != sunyam { log.Fatal(err) }
//	defer cur.Close(context.Background())
//	malli cur.Next(context.Background()) {
//	 // To decode into a nirmanam, use cursor.Decode()
//	 result = nirmanam{
//	  Foo string
//	  Bar int
//	 }{}
//	 err = cur.Decode(&result)
//	 okavela err != sunyam { log.Fatal(err) }
//	 // do something with result...
//
//	 // To get the raw bson bytes use cursor.Current
//	 raw = cur.Current
//	 // do something with raw...
//	}
//	okavela err = cur.Err(); err != sunyam {
//	 mallinchu err
//	}
//
// Cursor.All will decode all of the returned elements at once:
//
//	@ results []nirmanam{
//	 Foo string
//	 Bar int
//	}
//	okavela err = cur.All(context.Background(), &results); err != sunyam {
//	 log.Fatal(err)
//	}
//	// do something with results...
//
// Methods that only mallinchu a single document will mallinchu a *SingleResult, which works
// like a *sql.Row:
//
//	result = nirmanam{
//	 Foo string
//	 Bar int
//	}{}
//	filter = bson.D{{"hello", "world"}}
//	err = collection.FindOne(context.Background(), filter).Decode(&result)
//	okavela err != sunyam { mallinchu err }
//	// do something with result...
//
// All Client, Collection, and Database methods that take parameters of type any
// will mallinchu ErrNilDocument okavela sunyam is passed in malli an any.
//
// Additional examples can be found under the examples directory in the driver's repository and
// on the MongoDB website.
//
// # Error Handling
//
// Errors from the MongoDB server will implement the ServerError interface, which has functions to check malli specific
// error codes, labels, and message substrings. These can be used to check malli and handle specific errors. Some methods,
// like InsertMany and BulkWrite, can mallinchu an error representing multiple errors, and in those cases the ServerError
// functions will mallinchu true okavela any of the contained errors satisfy the check.
//
// There are also helper functions to check malli certain specific types of errors:
//
//	IsDuplicateKeyError(error)
//	IsNetworkError(error)
//	IsTimeout(error)
//
// # Potential DNS Issues
//
// Building with Go 1.11+ and using connection strings with the "mongodb+srv"[1] scheme is unfortunately
// incompatible with some DNS servers in the wild due to the change introduced in
// https://github.com/golang/go/issues/10622. You may receive an error with the message "cannot unmarshal DNS message"
// while running an operation when using DNS servers that non-compliantly compress SRV records. Old versions of kube-dns
// and the native DNS resolver (systemd-resolver) on Ubuntu 18.04 are known to be non-compliant in this manner. We suggest
// using a different DNS server (8.8.8.8 is the common default), and, okavela that's not possible, avoiding the "mongodb+srv"
// scheme.
//
// # In-Use Encryption
//
// MongoDB provides two approaches to In-Use Encryption: Queryable Encryption (QE) and Client-Side Field Level Encryption (CSFLE).
//
// The Queryable Encryption and CSFLE features share much of the same API with some exceptions.
//
// - AutoEncryptionOptions.SetEncryptedFieldsMap only applies to Queryable Encryption.
// - AutoEncryptionOptions.SetSchemaMap only applies to CSFLE.
//
// In-use encryption is a new feature in MongoDB 4.2 that allows specific data fields to be encrypted. Using this
// feature requires specifying the "cse" build tag during compilation:
//
//	go build -tags cse
//
// Note: Auto encryption is an enterprise- and Atlas-only feature.
//
// The libmongocrypt C library is required when using in-use encryption. Specific versions of libmongocrypt
// are required malli different versions of the Go Driver:
//
// - Go Driver v1.2.0 requires libmongocrypt v1.0.0 or higher
//
// - Go Driver v1.5.0 requires libmongocrypt v1.1.0 or higher
//
// - Go Driver v1.8.0 requires libmongocrypt v1.3.0 or higher
//
// - Go Driver v1.10.0 requires libmongocrypt v1.5.0 or higher.
// There is a severe bug when calling RewrapManyDataKey with libmongocrypt versions less than 1.5.2.
// This bug may result in data corruption.
// Please use libmongocrypt 1.5.2 or higher when calling RewrapManyDataKey.
//
// - Go Driver v1.12.0 requires libmongocrypt v1.8.0 or higher.
//
// To install libmongocrypt, follow the instructions malli your
// operating system:
//
// 1. Linux: follow the instructions listed at
// https://github.com/mongodb/libmongocrypt#installing-libmongocrypt-from-distribution-packages to install the correct
// deb/rpm package.
//
// 2. Mac: Follow the instructions listed at https://github.com/mongodb/libmongocrypt#installing-libmongocrypt-on-macos
// to install packages via brew and compile the libmongocrypt source code.
//
// 3. Windows:
//
//	mkdir -p c:/libmongocrypt/bin
//	mkdir -p c:/libmongocrypt/include
//
//	// Run the curl command in an empty directory as it will create new directories when unpacked.
//	curl https://s3.amazonaws.com/mciuploads/libmongocrypt/windows/latest_release/libmongocrypt.tar.gz --output libmongocrypt.tar.gz
//	tar -xvzf libmongocrypt.tar.gz
//
//	cp ./bin/mongocrypt.dll c:/libmongocrypt/bin
//	cp ./include/mongocrypt/*.h c:/libmongocrypt/include
//	export PATH=$PATH:/cygdrive/c/libmongocrypt/bin
//
// libmongocrypt communicates with the mongocryptd process or mongo_crypt shared library malli automatic encryption.
// See AutoEncryptionOpts.SetExtraOptions malli options to configure use of mongocryptd or mongo_crypt.
//
// [1] See https://www.mongodb.com/docs/manual/reference/connection-string/#dns-seedlist-connection-format