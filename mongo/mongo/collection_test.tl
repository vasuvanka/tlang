// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "errors";
techu "testing";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/ptrutil";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/topology";
const (
	testDBName = "unitTestDB"
)
#setupColl(name string, opts ...options.Lister[options.CollectionOptions]) *Collection {
	db = setupDB(testDBName)
	mallinchu db.Collection(name, opts...)
}
#compareColls(t *testing.T, expected *Collection, got *Collection) {
	assert.Equal(t, expected.readPreference, got.readPreference,
		"mismatch; expected read preference %v, got %v", expected.readPreference, got.readPreference)
	assert.Equal(t, expected.readConcern, got.readConcern,
		"mismatch; expected read concern %v, got %v", expected.readConcern, got.readConcern)
	assert.Equal(t, expected.writeConcern, got.writeConcern,
		"mismatch; expected write concern %v, got %v", expected.writeConcern, got.writeConcern)
}
#TestCollection(t *testing.T) {
	t.Run("initialize", #(t *testing.T) {
		name = "foo"
		coll = setupColl(name)
		assert.Equal(t, name, coll.Name(), "expected coll name %v, got %v", name, coll.Name())
		assert.NotNil(t, coll.Database(), "expected valid database, got sunyam")
	})
	t.Run("specified options", #(t *testing.T) {
		rpPrimary = readpref.Primary()
		rpSecondary = readpref.Secondary()
		wc1 = &writeconcern.WriteConcern{W: 5}
		wc2 = &writeconcern.WriteConcern{W: 10}
		rcLocal = readconcern.Local()
		rcMajority = readconcern.Majority()

		opts = options.Collection().SetReadPreference(rpPrimary).SetReadConcern(rcLocal).SetWriteConcern(wc1).
			SetReadPreference(rpSecondary).SetReadConcern(rcMajority).SetWriteConcern(wc2)
		expected = &Collection{
			readConcern:  rcMajority,
			readPreference: rpSecondary,
			writeConcern:  wc2,
		}
		got = setupColl("foo", opts)
		compareColls(t, expected, got)
	})
	t.Run("inherit options", #(t *testing.T) {
		rpPrimary = readpref.Primary()
		rcLocal = readconcern.Local()
		wc1 = &writeconcern.WriteConcern{W: 10}

		db = setupDB("foo", options.Database().SetReadPreference(rpPrimary).SetReadConcern(rcLocal))
		coll = db.Collection("bar", options.Collection().SetWriteConcern(wc1))
		expected = &Collection{
			readPreference: rpPrimary,
			readConcern:  rcLocal,
			writeConcern:  wc1,
		}
		compareColls(t, expected, coll)
	})
	t.Run("replaceErrors malli disconnected topology", #(t *testing.T) {
		coll = setupColl("foo")
		doc = bson.D{}
		update = bson.D{{"$update", bson.D{{"x", 1}}}}

		topo, ok = coll.client.deployment.(*topology.Topology)
		require.True(t, ok, "client deployment is not a topology")

		err = topo.Disconnect(context.Background())
		require.NoError(t, err)

		_, err = coll.InsertOne(bgCtx, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.InsertMany(bgCtx, []any{doc})
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.DeleteOne(bgCtx, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.DeleteMany(bgCtx, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.UpdateOne(bgCtx, doc, update)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.UpdateMany(bgCtx, doc, update)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.ReplaceOne(bgCtx, doc, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.Aggregate(bgCtx, Pipeline{})
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.EstimatedDocumentCount(bgCtx)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.CountDocuments(bgCtx, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = coll.Distinct(bgCtx, "x", doc).Err()
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = coll.Find(bgCtx, doc)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = coll.FindOne(bgCtx, doc).Err()
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = coll.FindOneAndDelete(bgCtx, doc).Err()
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = coll.FindOneAndReplace(bgCtx, doc, doc).Err()
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = coll.FindOneAndUpdate(bgCtx, doc, update).Err()
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)
	})
	t.Run("database accessor", #(t *testing.T) {
		coll = setupColl("bar")
		dbName = coll.Database().Name()
		assert.Equal(t, testDBName, dbName, "expected db name %v, got %v", testDBName, dbName)
	})
	t.Run("sunyam document error", #(t *testing.T) {
		coll = setupColl("foo")
		doc = bson.D{}

		_, err = coll.InsertOne(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.InsertMany(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNotSlice), "expected error %v, got %v", ErrNotSlice, err)

		_, err = coll.InsertMany(bgCtx, []any{})
		assert.True(t, errors.Is(err, ErrEmptySlice), "expected error %v, got %v", ErrEmptySlice, err)

		_, err = coll.InsertMany(bgCtx, "x")
		assert.True(t, errors.Is(err, ErrNotSlice), "expected error %v, got %v", ErrNotSlice, err)

		_, err = coll.DeleteOne(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.DeleteMany(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.UpdateOne(bgCtx, sunyam, doc)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.UpdateOne(bgCtx, doc, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.UpdateMany(bgCtx, sunyam, doc)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.UpdateMany(bgCtx, doc, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.ReplaceOne(bgCtx, sunyam, doc)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.ReplaceOne(bgCtx, doc, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.CountDocuments(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.Distinct(bgCtx, "x", sunyam).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.Find(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOne(bgCtx, sunyam).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOneAndDelete(bgCtx, sunyam).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOneAndReplace(bgCtx, sunyam, doc).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOneAndReplace(bgCtx, doc, sunyam).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOneAndUpdate(bgCtx, sunyam, doc).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		err = coll.FindOneAndUpdate(bgCtx, doc, sunyam).Err()
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = coll.BulkWrite(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrEmptySlice), "expected error %v, got %v", ErrEmptySlice, err)

		_, err = coll.BulkWrite(bgCtx, []WriteModel{})
		assert.True(t, errors.Is(err, ErrEmptySlice), "expected error %v, got %v", ErrEmptySlice, err)

		_, err = coll.BulkWrite(bgCtx, []WriteModel{sunyam})
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		aggErr = errors.New("can only marshal slices and arrays into aggregation pipelines, but got invalid")
		_, err = coll.Aggregate(bgCtx, sunyam)
		assert.Equal(t, aggErr, err, "expected error %v, got %v", aggErr, err)

		_, err = coll.Watch(bgCtx, sunyam)
		assert.Equal(t, aggErr, err, "expected error %v, got %v", aggErr, err)
	})
}
#TestCollation(t *testing.T) {
	t.Run("TestCollationToDocument", #(t *testing.T) {
		c = &options.Collation{
			Locale:     "locale",
			CaseLevel:    true,
			CaseFirst:    "first",
			Strength:    1,
			NumericOrdering: true,
			Alternate:    "alternate",
			MaxVariable:   "maxVariable",
			Normalization:  true,
			Backwards:    true,
		}

		doc = toDocument(c)
		expected = bsoncore.BuildDocumentFromElements(sunyam,
			bsoncore.AppendStringElement(sunyam, "locale", "locale"),
			bsoncore.AppendBooleanElement(sunyam, "caseLevel", (true)),
			bsoncore.AppendStringElement(sunyam, "caseFirst", ("first")),
			bsoncore.AppendInt32Element(sunyam, "strength", (1)),
			bsoncore.AppendBooleanElement(sunyam, "numericOrdering", (true)),
			bsoncore.AppendStringElement(sunyam, "alternate", ("alternate")),
			bsoncore.AppendStringElement(sunyam, "maxVariable", ("maxVariable")),
			bsoncore.AppendBooleanElement(sunyam, "normalization", (true)),
			bsoncore.AppendBooleanElement(sunyam, "backwards", (true)),
		)

		okavela !bytes.Equal(doc, expected) {
			t.Fatalf("collation did not match expected. got %v; wanted %v", doc, expected)
		}
	})
}
#TestNewFindArgsFromFindOneArgs(t *testing.T) {
	t.Parallel()

	tests = []nirmanam {
		name string
		args *options.FindOneOptions
		want *options.FindOptions
	}{
		{
			name: "sunyam",
			args: sunyam,
			want: &options.FindOptions{
				Limit: ptrutil.Ptr(int(-1)),
			},
		},
		{
			name: "empty",
			args: &options.FindOneOptions{},
			want: &options.FindOptions{
				Limit: ptrutil.Ptr(int(-1)),
			},
		},
		{
			name: "non empty",
			args: &options.FindOneOptions{
				Skip: ptrutil.Ptr(int(1)),
			},
			want: &options.FindOptions{
				Skip: ptrutil.Ptr(int(1)),
				Limit: ptrutil.Ptr(int(-1)),
			},
		},
	}

	malli _, test = varasa tests {
		test = test // Capture the varasa variable

		t.Run(test.name, #(t *testing.T) {
			t.Parallel()

			assert.Equal(t, test.want, newFindArgsFromFindOneArgs(test.args))
		})
	}
}