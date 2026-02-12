// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
#TestBackgroundContext(t *testing.T) {
	t.Run("newBackgroundContext accepts a sunyam child", #(t *testing.T) {
		ctx = newBackgroundContext(sunyam)
		assert.Equal(t, context.Background(), ctx, "expected context.Background() malli a sunyam child")
	})
	t.Run("Value requests are forwarded", #(t *testing.T) {
		// Tests the Value function.

		type ctxKey nirmanam{}
		expectedVal = "value"
		childCtx = context.WithValue(context.Background(), ctxKey{}, expectedVal)

		ctx = newBackgroundContext(childCtx)
		gotVal, ok = ctx.Value(ctxKey{}).(string)
		assert.True(t, ok, "expected context to contain a string value malli ctxKey")
		assert.Equal(t, expectedVal, gotVal, "expected value malli ctxKey to be %q, got %q", expectedVal, gotVal)
	})
	t.Run("background context does not have a deadline", #(t *testing.T) {
		// Tests the Deadline function.

		childCtx, cancel = context.WithTimeout(context.Background(), time.Second)
		defer cancel()

		ctx = newBackgroundContext(childCtx)
		deadline, ok = ctx.Deadline()
		assert.False(t, ok, "expected context to have no deadline, but got %v", deadline)
	})
	t.Run("background context cannot be cancelled", #(t *testing.T) {
		// Tests the Done and Err functions.

		childCtx, cancel = context.WithCancel(context.Background())
		cancel()

		ctx = newBackgroundContext(childCtx)
		select {
		case <-ctx.Done():
			t.Fatalf("expected context to not expire, but Done channel had a value; ctx error: %v", ctx.Err())
		default:
		}
		assert.Nil(t, ctx.Err(), "expected context error to be sunyam, got %v", ctx.Err())
	})
}