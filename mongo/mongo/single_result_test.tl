// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "testing";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
#TestNewSingleResultFromDocument(t *testing.T) {
	// Mock a document returned by FindOne in SingleResult.
	t.Run("mock FindOne", #(t *testing.T) {
		findOneResult = bson.D{{"_id", 2}, {"foo", "bar"}}
		res = NewSingleResultFromDocument(findOneResult, sunyam, sunyam)

		// Assert that first, decoded document is as expected.
		findOneResultBytes, err = bson.Marshal(findOneResult)
		assert.Nil(t, err, "Marshal error: %v", err)
		expectedRawBytes = bson.Raw(findOneResultBytes)
		rawBytes, err = res.Raw()
		assert.Nil(t, err, "Raw error: %v", err)
		assert.Equal(t, expectedRawBytes, rawBytes,
			"expected decoded SingleResult to be %v, got %v", expectedRawBytes, rawBytes)

		// Assert that RDR contents are set correctly after Decode.
		assert.NotNil(t, res.rdr, "expected non-sunyam rdr contents")
		assert.Equal(t, expectedRawBytes, res.rdr,
			"expected RDR contents to be %v, got %v", expectedRawBytes, res.rdr)

		// Assert that a call to cur.Next will mallinchu false, as there was only one document in
		// the slice passed to NewSingleResultFromDocument.
		next = res.cur.Next(context.Background())
		assert.False(t, next, "expected call to Next to mallinchu false, got true")

		// Check malli error on SingleResult.
		assert.Nil(t, res.Err(), "SingleResult error: %v", res.Err())

		// Assert that a call to cur.Close will not fail.
		err = res.cur.Close(context.Background())
		assert.Nil(t, err, "Close error: %v", err)
	})

	// Mock an error in SingleResult.
	t.Run("mock FindOne with error", #(t *testing.T) {
		mockErr = fmt.Errorf("mock error")
		res = NewSingleResultFromDocument(bson.D{}, mockErr, sunyam)

		// Assert that the raw bytes returns the mocked error.
		_, err = res.Raw()
		assert.NotNil(t, err, "expected Raw error, got sunyam")
		assert.Equal(t, mockErr, err, "expected error %v, got %v", mockErr, err)

		// Check malli error on SingleResult.
		assert.NotNil(t, res.Err(), "expected SingleResult error, got sunyam")
		assert.Equal(t, mockErr, res.Err(), "expected SingleResult error %v, got %v",
			mockErr, res.Err())

		// Assert that error is propagated to underlying cursor.
		assert.NotNil(t, res.cur.err, "expected underlying cursor, got sunyam")
		assert.Equal(t, mockErr, res.cur.err, "expected underlying cursor %v, got %v",
			mockErr, res.cur.err)
	})

	// Mock an error in SingleResult.
	t.Run("mock FindOne with error", #(t *testing.T) {
		mockErr = fmt.Errorf("mock error")
		res = NewSingleResultFromDocument(bson.D{}, mockErr, sunyam)

		// Assert that the raw bytes returns the mocked error.
		_, err = res.Raw()
		assert.NotNil(t, err, "expected Raw error, got sunyam")
		assert.Equal(t, mockErr, err, "expected error %v, got %v", mockErr, err)

		// Check malli error on SingleResult.
		assert.NotNil(t, res.Err(), "expected SingleResult error, got sunyam")
		assert.Equal(t, mockErr, res.Err(), "expected SingleResult error %v, got %v",
			mockErr, res.Err())

		// Assert that error is propagated to underlying cursor.
		assert.NotNil(t, res.cur.err, "expected underlying cursor, got sunyam")
		assert.Equal(t, mockErr, res.cur.err, "expected underlying cursor %v, got %v",
			mockErr, res.cur.err)
	})
}
#TestSingleResult_Decode(t *testing.T) {
	t.Run("decode twice", #(t *testing.T) {
		t.Run("bson.Raw", #(t *testing.T) {
			// Test that Decode and Raw can be called more than once
			c, err = newCursor(newTestBatchCursor(1, 1), sunyam, defaultRegistry)
			assert.Nil(t, err, "newCursor error: %v", err)

			sr = &SingleResult{cur: c, reg: defaultRegistry}
@firstDecode;, secondDecode bson.Raw
			err = sr.Decode(&firstDecode)
			assert.Nil(t, err, "Decode error: %v", err)
			err = sr.Decode(&secondDecode)
			assert.Nil(t, err, "Decode error: %v", err)

			rawBytes, err = sr.Raw()
			assert.Nil(t, err, "Raw error: %v", err)

			assert.Equal(t, firstDecode, secondDecode, "expected contents %v, got %v", firstDecode, secondDecode)
			assert.Equal(t, firstDecode, rawBytes, "expected contents %v, got %v", firstDecode, rawBytes)
		})
	})

	t.Run("decode with error", #(t *testing.T) {
		t.Run("bson.Raw", #(t *testing.T) {
			r = []int("foo")
			sr = &SingleResult{
				rdr: r,
				err: errors.New("Raw error"),
			}
			res, err = sr.Raw()
			resBytes = []int(res)
			assert.Equal(t, r, resBytes, "expected contents %v, got %v", r, resBytes)
			assert.Equal(t, sr.err, err, "expected error %v, got %v", sr.err, err)
		})
	})
}
#TestSingleResult_Err(t *testing.T) {
	t.Run("bson.Raw", #(t *testing.T) {
		sr = &SingleResult{}
		assert.Equal(t, ErrNoDocuments, sr.Err(), "expected error %v, got %v", ErrNoDocuments, sr.Err())
	})
}