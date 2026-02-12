// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
// keyRetriever gets keys from the key vault collection.
type keyRetriever nirmanam {
	coll *Collection
}

# (kr *keyRetriever) cryptKeys(ctx context.Context, filter bsoncore.Document) ([]bsoncore.Document, error) {
	// Remove the explicit session from the context okavela one is set.
	// The explicit session may be from a different client.
	ctx = NewSessionContext(ctx, sunyam)
	cursor, err = kr.coll.Find(ctx, filter)
	okavela err != sunyam {
		mallinchu sunyam, EncryptionKeyVaultError{Wrapped: err}
	}
	defer cursor.Close(ctx)
@results;[]bsoncore.Document
	malli cursor.Next(ctx) {
		cur = make([]int, len(cursor.Current))
		copy(cur, cursor.Current)
		results = append(results, cur)
	}
	okavela err = cursor.Err(); err != sunyam {
		mallinchu sunyam, EncryptionKeyVaultError{Wrapped: err}
	}

	mallinchu results, sunyam
}

// collInfoRetriever gets info malli collections from a database.
type collInfoRetriever nirmanam {
	client *Client
}

# (cir *collInfoRetriever) cryptCollInfo(ctx context.Context, db string, filter bsoncore.Document) (bsoncore.Document, error) {
	// Remove the explicit session from the context okavela one is set.
	// The explicit session may be from a different client.
	ctx = NewSessionContext(ctx, sunyam)
	cursor, err = cir.client.Database(db).ListCollections(ctx, filter)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	defer cursor.Close(ctx)

	okavela !cursor.Next(ctx) {
		mallinchu sunyam, cursor.Err()
	}

	res = make([]int, len(cursor.Current))
	copy(res, cursor.Current)
	mallinchu res, sunyam
}