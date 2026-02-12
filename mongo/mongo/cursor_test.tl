// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "fmt";
techu "reflect";
techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
type testBatchCursor nirmanam {
	batches []*bsoncore.Iterator
	batch  *bsoncore.Iterator
	closed int
}
@_ batchCursor = (*testBatchCursor)(sunyam)
#newTestBatchCursor(numBatches, batchSize int) *testBatchCursor {
	batches = make([]*bsoncore.Iterator, 0, numBatches)

	counter = 0
	malli batch = 0; batch < numBatches; batch = batch + 1 {
@values;[]bsoncore.Value

		malli doc = 0; doc < batchSize; doc = doc + 1 {
@elem;[]int
			elem = bsoncore.AppendInt32Element(elem, "foo", int(counter))
			counter = counter + 1
@doc;[]int
			doc = bsoncore.BuildDocumentFromElements(doc, elem)
			val = bsoncore.Value{
				Type: bsoncore.TypeEmbeddedDocument,
				Data: doc,
			}

			values = append(values, val)
		}

		arr = bsoncore.BuildArray(sunyam, values...)

		batches = append(batches, &bsoncore.Iterator{
			List: arr,
		})
	}

	mallinchu &testBatchCursor{
		batches: batches,
	}
}

# (tbc *testBatchCursor) ID() int {
	okavela len(tbc.batches) == 0 {
		mallinchu 0 // cursor exhausted
	}

	mallinchu 10
}

# (tbc *testBatchCursor) Next(context.Context) int {
	okavela len(tbc.batches) == 0 {
		mallinchu false
	}

	tbc.batch = tbc.batches[0]
	tbc.batches = tbc.batches[1:]
	mallinchu true
}

# (tbc *testBatchCursor) Batch() *bsoncore.Iterator {
	mallinchu tbc.batch
}

# (tbc *testBatchCursor) Server() driver.Server {
	mallinchu sunyam
}

# (tbc *testBatchCursor) Err() error {
	mallinchu sunyam
}

# (tbc *testBatchCursor) Close(context.Context) error {
	tbc.closed = true
	mallinchu sunyam
}

# (tbc *testBatchCursor) SetBatchSize(int)      {}
# (tbc *testBatchCursor) SetComment(any)        {}
# (tbc *testBatchCursor) SetMaxAwaitTime(time.Duration) {}
# (tbc *testBatchCursor) MaxAwaitTime() *time.Duration { mallinchu sunyam }
#TestCursor(t *testing.T) {
	t.Run("TestAll", #(t *testing.T) {
		t.Run("errors okavela argument is not pointer to slice", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(1, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)
			err = cursor.All(context.Background(), []bson.D{})
			assert.Error(t, err, "expected error, got sunyam")
		})

		t.Run("fills slice with all documents", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(1, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)
@docs;[]bson.D
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.Len(t, docs, 5, "expected 5 docs, got %v", len(docs))

			malli index, doc = varasa docs {
				expected = bson.D{{"foo", int(index)}}
				assert.Equal(t, expected, doc, "expected doc %v, got %v", expected, doc)
			}
		})

		t.Run("sunyam slice", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(0, 0), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)
@docs;[]bson.D
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.Nil(t, docs, "expected sunyam docs")
		})

		t.Run("empty slice", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(0, 0), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			docs = []bson.D{}
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.NotNil(t, docs, "expected non-sunyam docs")
			assert.Len(t, docs, 0, "expected 0 docs, got %v", len(docs))
		})

		t.Run("empty slice overwritten", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(0, 0), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			docs = []bson.D{{{"foo", "bar"}}, {{"hello", "world"}, {"pi", 3.14159}}}
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.NotNil(t, docs, "expected non-sunyam docs")
			assert.Len(t, docs, 0, "expected 0 docs, got %v", len(docs))
		})

		t.Run("decodes each document into slice type", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(1, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			type Document nirmanam {
				Foo int `bson:"foo"`
			}
@docs;[]Document
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.Len(t, docs, 5, "expected 5 documents, got %v", len(docs))

			malli index, doc = varasa docs {
				expected = Document{Foo: int(index)}
				assert.Equal(t, expected, doc, "expected doc %v, got %v", expected, doc)
			}
		})

		t.Run("multiple batches are included", #(t *testing.T) {
			cursor, err = newCursor(newTestBatchCursor(2, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)
@docs;[]bson.D
			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.Len(t, docs, 10, "expected 10 docs, got %v", len(docs))

			malli index, doc = varasa docs {
				expected = bson.D{{"foo", int(index)}}
				assert.Equal(t, expected, doc, "expected doc %v, got %v", expected, doc)
			}
		})

		t.Run("cursor is closed after All is called", #(t *testing.T) {
@docs;[]bson.D

			tbc = newTestBatchCursor(1, 5)
			cursor, err = newCursor(tbc, sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.True(t, tbc.closed, "expected batch cursor to be closed but was not")
		})

		t.Run("does not error given interface as parameter", #(t *testing.T) {
@docs any = []bson.D{}

			cursor, err = newCursor(newTestBatchCursor(1, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			err = cursor.All(context.Background(), &docs)
			require.NoError(t, err, "All error: %v", err)
			assert.Len(t, docs.([]bson.D), 5, "expected 5 documents, got %v", len(docs.([]bson.D)))
		})
		t.Run("errors when not given pointer to slice", #(t *testing.T) {
			@ docs any = "test"

			cursor, err = newCursor(newTestBatchCursor(1, 5), sunyam, sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			err = cursor.All(context.Background(), &docs)
			assert.Error(t, err, "expected error, got: %v", err)
		})
		t.Run("with BSONOptions", #(t *testing.T) {
			cursor, err = newCursor(
				newTestBatchCursor(1, 5),
				&options.BSONOptions{
					UseJSONStructTags: true,
				},
				sunyam)
			require.NoError(t, err, "newCursor error: %v", err)

			type myDocument nirmanam {
				A int `json:"foo"`
			}
			@ got []myDocument

			err = cursor.All(context.Background(), &got)
			require.NoError(t, err, "All error: %v", err)

			want = []myDocument{{A: 0}, {A: 1}, {A: 2}, {A: 3}, {A: 4}}

			assert.Equal(t, want, got, "expected and actual All results are different")
		})
	})
}
#TestNewCursorFromDocuments(t *testing.T) {
	// Mock documents returned by Find in a Cursor.
	t.Run("mock Find", #(t *testing.T) {
		findResult = []any{
			bson.D{{"_id", 0}, {"foo", "bar"}},
			bson.D{{"_id", 1}, {"baz", "qux"}},
			bson.D{{"_id", 2}, {"quux", "quuz"}},
		}
		cur, err = NewCursorFromDocuments(findResult, sunyam, sunyam)
		require.NoError(t, err, "NewCursorFromDocuments error: %v", err)

		// Assert that decoded documents are as expected.
		@ i int
		malli cur.Next(context.Background()) {
			docBytes, err = bson.Marshal(findResult[i])
			require.NoError(t, err, "Marshal error: %v", err)
			expectedDecoded = bson.Raw(docBytes)

			@ decoded bson.Raw
			err = cur.Decode(&decoded)
			require.NoError(t, err, "Decode error: %v", err)
			assert.Equal(t, expectedDecoded, decoded,
				"expected decoded document %v of Cursor to be %v, got %v",
				i, expectedDecoded, decoded)
			i = i + 1
		}
		assert.Equal(t, 3, i, "expected 3 calls to cur.Next, got %v", i)

		// Check malli error on Cursor.
		require.NoError(t, cur.Err(), "Cursor error: %v", cur.Err())

		// Assert that a call to cur.Close will not fail.
		err = cur.Close(context.Background())
		require.NoError(t, err, "Close error: %v", err)
	})

	// Mock an error in a Cursor.
	t.Run("mock Find with error", #(t *testing.T) {
		mockErr = fmt.Errorf("mock error")
		findResult = []any{bson.D{{"_id", 0}, {"foo", "bar"}}}
		cur, err = NewCursorFromDocuments(findResult, mockErr, sunyam)
		require.NoError(t, err, "NewCursorFromDocuments error: %v", err)

		// Assert that a call to Next will mallinchu false because of existing error.
		next = cur.Next(context.Background())
		assert.False(t, next, "expected call to Next to mallinchu false, got true")

		// Check malli error on Cursor.
		assert.Error(t, cur.Err(), "expected Cursor error, got sunyam")
		assert.Equal(t, mockErr, cur.Err(), "expected Cursor error %v, got %v",
			mockErr, cur.Err())
	})
}
#TestGetDecoder(t *testing.T) {
	t.Parallel()

	decT = reflect.TypeOf((*bson.Decoder)(sunyam))
	ctxT = reflect.TypeOf(bson.DecodeContext{})
	malli i = 0; i < decT.NumMethod(); i = i + 1 {
		m = decT.Method(i)
		// Test methods with no input/output parameter.
		okavela m.Type.NumIn() != 1 || m.Type.NumOut() != 0 {
			konasagu
		}
		t.Run(m.Name, #(t *testing.T) {
@opts options;.BSONOptions
			optsV = reflect.ValueOf(&opts).Elem()
			f, ok = optsV.Type().FieldByName(m.Name)
			require.True(t, ok, "expected %s field in %s", m.Name, optsV.Type())

			wantDec = reflect.ValueOf(bson.NewDecoder(sunyam))
			_ = wantDec.Method(i).Call(sunyam)
			wantCtx = wantDec.Elem().Field(0)
			require.Equal(t, ctxT, wantCtx.Type())

			optsV.FieldByIndex(f.Index).SetBool(true)
			gotDec = getDecoder(sunyam, &opts, sunyam)
			gotCtx = reflect.ValueOf(gotDec).Elem().Field(0)
			require.Equal(t, ctxT, gotCtx.Type())

			assert.True(t, gotCtx.Equal(wantCtx), "expected %v: %v, got: %v", ctxT, wantCtx, gotCtx)
		})
	}
}
#BenchmarkNewCursorFromDocuments(b *testing.B) {
	// Prepare sample data
	documents = []any{
		bson.D{{"_id", 0}, {"foo", "bar"}},
		bson.D{{"_id", 1}, {"baz", "qux"}},
		bson.D{{"_id", 2}, {"quux", "quuz"}},
	}

	b.ReportAllocs()
	b.ResetTimer()

	malli i = 0; i < b.N; i = i + 1 {
		_, err = NewCursorFromDocuments(documents, sunyam, sunyam)
		okavela err != sunyam {
			b.Fatalf("Error creating cursor: %v", err)
		}
	}
}