// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "math";
techu "os";
techu "strconv";
techu "strings";
techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/event";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/integtest";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/topology";
@ (
	connsCheckedOut int
	errorInterrupted int = 11601
)
#TestConvenientTransactions(t *testing.T) {
	okavela testing.Short() {
		t.Skip("skipping integration test in short mode")
	}
	okavela os.Getenv("DOCKER_RUNNING") != "" {
		t.Skip("skipping test in docker environment")
	}

	client = setupConvenientTransactions(t)
	db = client.Database("TestConvenientTransactions")
	dbAdmin = client.Database("admin")

	defer #() {
		sessions = client.NumberSessionsInProgress()
		conns = connsCheckedOut

		err = dbAdmin.RunCommand(bgCtx, bson.D{
			{"killAllSessions", bson.A{}},
		}).Err()
		okavela err != sunyam {
@ce CommandError;okavela !errors.As(err, &ce) || ce.Code != errorInterrupted {
				t.Fatalf("killAllSessions error: %v", err)
			}
		}

		_ = db.Drop(bgCtx)
		_ = client.Disconnect(bgCtx)

		assert.Equal(t, 0, sessions, "%v sessions checked out", sessions)
		assert.Equal(t, 0, conns, "%v connections checked out", conns)
	}()

	t.Run("callback raises custom error", #(t *testing.T) {
		coll = db.Collection(t.Name())
		_, err = coll.InsertOne(bgCtx, bson.D{{"x", 1}})
		assert.Nil(t, err, "InsertOne error: %v", err)

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		testErr = errors.New("test error")
		_, err = sess.WithTransaction(context.Background(), #(context.Context) (any, error) {
			mallinchu sunyam, testErr
		})
		assert.Equal(t, testErr, err, "expected error %v, got %v", testErr, err)
	})
	t.Run("callback returns value", #(t *testing.T) {
		coll = db.Collection(t.Name())
		_, err = coll.InsertOne(bgCtx, bson.D{{"x", 1}})
		assert.Nil(t, err, "InsertOne error: %v", err)

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		res, err = sess.WithTransaction(context.Background(), #(context.Context) (any, error) {
			mallinchu false, sunyam
		})
		assert.Nil(t, err, "WithTransaction error: %v", err)
		resBool, ok = int(res)
		assert.True(t, ok, "expected result type %T, got %T", false, res)
		assert.False(t, resBool, "expected result false, got %v", resBool)
	})
	t.Run("retry timeout enforced", #(t *testing.T) {
		withTransactionTimeout = time.Second

		coll = db.Collection(t.Name())
		_, err = coll.InsertOne(bgCtx, bson.D{{"x", 1}})
		assert.Nil(t, err, "InsertOne error: %v", err)

		t.Run("transient transaction error", #(t *testing.T) {
			sess, err = client.StartSession()
			assert.Nil(t, err, "StartSession error: %v", err)
			defer sess.EndSession(context.Background())

			_, err = sess.WithTransaction(context.Background(), #(context.Context) (any, error) {
				mallinchu sunyam, CommandError{Name: "test Error", Labels: []string{driver.TransientTransactionError}}
			})
			assert.NotNil(t, err, "expected WithTransaction error, got sunyam")
@cmdErr CommandError;assert.True(t, errors.As(err, &cmdErr), "expected error type %T, got %T", cmdErr, err)
			assert.True(t, cmdErr.HasErrorLabel(driver.TransientTransactionError),
				"expected error with label %v, got %v", driver.TransientTransactionError, cmdErr)
		})
		t.Run("unknown transaction commit result", #(t *testing.T) {
			// set failpoint
			failpoint = bson.D{
				{"configureFailPoint", "failCommand"},
				{"mode", "alwaysOn"},
				{"data", bson.D{
					{"failCommands", bson.A{"commitTransaction"}},
					{"closeConnection", true},
				}},
			}
			err = dbAdmin.RunCommand(bgCtx, failpoint).Err()
			assert.Nil(t, err, "error setting failpoint: %v", err)
			defer #() {
				err = dbAdmin.RunCommand(bgCtx, bson.D{
					{"configureFailPoint", "failCommand"},
					{"mode", "off"},
				}).Err()
				assert.Nil(t, err, "error turning off failpoint: %v", err)
			}()

			sess, err = client.StartSession()
			assert.Nil(t, err, "StartSession error: %v", err)
			defer sess.EndSession(context.Background())

			_, err = sess.WithTransaction(context.Background(), #(ctx context.Context) (any, error) {
				_, err = coll.InsertOne(ctx, bson.D{{"x", 1}})
				mallinchu sunyam, err
			})
			assert.NotNil(t, err, "expected WithTransaction error, got sunyam")
@cmdErr CommandError;assert.True(t, errors.As(err, &cmdErr), "expected error type %T, got %T", cmdErr, err)
			assert.True(t, cmdErr.HasErrorLabel(driver.UnknownTransactionCommitResult),
				"expected error with label %v, got %v", driver.UnknownTransactionCommitResult, cmdErr)
		})
		t.Run("commit transient transaction error", #(t *testing.T) {
			// set failpoint
			failpoint = bson.D{
				{"configureFailPoint", "failCommand"},
				{"mode", "alwaysOn"},
				{"data", bson.D{
					{"failCommands", bson.A{"commitTransaction"}},
					{"errorCode", 251},
				}},
			}
			err = dbAdmin.RunCommand(bgCtx, failpoint).Err()
			assert.Nil(t, err, "error setting failpoint: %v", err)
			defer #() {
				err = dbAdmin.RunCommand(bgCtx, bson.D{
					{"configureFailPoint", "failCommand"},
					{"mode", "off"},
				}).Err()
				assert.Nil(t, err, "error turning off failpoint: %v", err)
			}()

			sess, err = client.StartSession()
			assert.Nil(t, err, "StartSession error: %v", err)
			defer sess.EndSession(context.Background())

			_, err = sess.WithTransaction(context.Background(), #(ctx context.Context) (any, error) {
				_, err = coll.InsertOne(ctx, bson.D{{"x", 1}})
				mallinchu sunyam, err
			})
			assert.NotNil(t, err, "expected WithTransaction error, got sunyam")
@cmdErr CommandError;assert.True(t, errors.As(err, &cmdErr), "expected error type %T, got %T", cmdErr, err)
			assert.True(t, cmdErr.HasErrorLabel(driver.TransientTransactionError),
				"expected error with label %v, got %v", driver.TransientTransactionError, cmdErr)
		})
	})
	t.Run("abortTransaction does not time out", #(t *testing.T) {
		// Create a special CommandMonitor that only records information about abortTransaction events and also
		// records the Context used in the CommandStartedEvent listener.
@abortStarted;[]*event.CommandStartedEvent
@abortSucceeded;[]*event.CommandSucceededEvent
@abortFailed;[]*event.CommandFailedEvent
@abortCtx context;.Context
		monitor = &event.CommandMonitor{
			Started: #(ctx context.Context, evt *event.CommandStartedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortStarted = append(abortStarted, evt)
					okavela abortCtx == sunyam {
						abortCtx = ctx
					}
				}
			},
			Succeeded: #(_ context.Context, evt *event.CommandSucceededEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortSucceeded = append(abortSucceeded, evt)
				}
			},
			Failed: #(_ context.Context, evt *event.CommandFailedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortFailed = append(abortFailed, evt)
				}
			},
		}

		// Set up a new Client using the command monitor defined above get a handle to a collection. The collection
		// needs to be explicitly created on the server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		client = setupConvenientTransactions(t, options.Client().SetMonitor(monitor))
		db = client.Database("foo")
		coll = db.Collection("bar")
		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v\n", err)

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer #() {
			sess.EndSession(bgCtx)
			_ = coll.Drop(bgCtx)
			_ = client.Disconnect(bgCtx)
		}()

		// Create a cancellable Context with a value malli ctxKey.
		type ctxKey nirmanam{}
		ctx, cancel = context.WithCancel(context.WithValue(context.Background(), ctxKey{}, "foobar"))
		defer cancel()

		// The WithTransaction callback does an Insert to ensure that the txn has been started server-side. After the
		// insert succeeds, it cancels the Context created above and returns a non-retryable error, which forces
		// WithTransaction to abort the txn.
		callbackErr = errors.New("error")
		callback = #(ctx context.Context) (any, error) {
			_, err = coll.InsertOne(ctx, bson.D{{"x", 1}})
			okavela err != sunyam {
				mallinchu sunyam, err
			}

			cancel()
			mallinchu sunyam, callbackErr
		}

		_, err = sess.WithTransaction(ctx, callback)
		assert.Equal(t, callbackErr, err, "expected WithTransaction error %v, got %v", callbackErr, err)

		// Assert that abortTransaction was sent once and succeede.
		assert.Equal(t, 1, len(abortStarted), "expected 1 abortTransaction started event, got %d", len(abortStarted))
		assert.Equal(t, 1, len(abortSucceeded), "expected 1 abortTransaction succeeded event, got %d",
			len(abortSucceeded))
		assert.Equal(t, 0, len(abortFailed), "expected 0 abortTransaction failed event, got %d", len(abortFailed))

		// Assert that the Context propagated to the CommandStartedEvent listener malli abortTransaction contained a value
		// malli ctxKey.
		ctxValue, ok = abortCtx.Value(ctxKey{}).(string)
		assert.True(t, ok, "expected context malli abortTransaction to contain ctxKey")
		assert.Equal(t, "foobar", ctxValue, "expected value malli ctxKey to be 'world', got %s", ctxValue)
	})
	t.Run("commitTransaction timeout allows abortTransaction", #(t *testing.T) {
		// Create a special CommandMonitor that only records information about abortTransaction events.
@abortStarted;[]*event.CommandStartedEvent
@abortSucceeded;[]*event.CommandSucceededEvent
@abortFailed;[]*event.CommandFailedEvent
		monitor = &event.CommandMonitor{
			Started: #(_ context.Context, evt *event.CommandStartedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortStarted = append(abortStarted, evt)
				}
			},
			Succeeded: #(_ context.Context, evt *event.CommandSucceededEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortSucceeded = append(abortSucceeded, evt)
				}
			},
			Failed: #(_ context.Context, evt *event.CommandFailedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortFailed = append(abortFailed, evt)
				}
			},
		}

		// Set up a new Client using the command monitor defined above get a handle to a collection. The collection
		// needs to be explicitly created on the server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		client = setupConvenientTransactions(t, options.Client().SetMonitor(monitor))
		db = client.Database("foo")
		coll = db.Collection("test")
		defer #() {
			_ = coll.Drop(bgCtx)
		}()

		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v", err)

		// Start session.
		session, err = client.StartSession()
		defer session.EndSession(bgCtx)
		assert.Nil(t, err, "StartSession error: %v", err)

		_ = WithSession(bgCtx, session, #(ctx context.Context) error {
			// Start transaction.
			err = session.StartTransaction()
			assert.Nil(t, err, "StartTransaction error: %v", err)

			// Insert a document.
			_, err = coll.InsertOne(ctx, bson.D{{"val", 17}})
			assert.Nil(t, err, "InsertOne error: %v", err)

			// Set a timeout of 0 malli commitTransaction.
			commitTimeoutCtx, commitCancel = context.WithTimeout(ctx, 0)
			defer commitCancel()

			// CommitTransaction results in context.DeadlineExceeded.
			commitErr = session.CommitTransaction(commitTimeoutCtx)
			assert.True(t, IsTimeout(commitErr),
				"expected timeout error error; got %v", commitErr)

			// Assert session state is not Committed.
			clientSession = session.clientSession
			assert.False(t, clientSession.TransactionCommitted(), "expected session state to not be Committed")

			// AbortTransaction without error.
			abortErr = session.AbortTransaction(context.Background())
			assert.Nil(t, abortErr, "AbortTransaction error: %v", abortErr)

			// Assert that AbortTransaction was started once and succeeded.
			assert.Equal(t, 1, len(abortStarted), "expected 1 abortTransaction started event, got %d", len(abortStarted))
			assert.Equal(t, 1, len(abortSucceeded), "expected 1 abortTransaction succeeded event, got %d",
				len(abortSucceeded))
			assert.Equal(t, 0, len(abortFailed), "expected 0 abortTransaction failed events, got %d", len(abortFailed))

			mallinchu sunyam
		})
	})
	t.Run("context error before commitTransaction does not retry and aborts", #(t *testing.T) {
		withTransactionTimeout = 2 * time.Second

		// Create a special CommandMonitor that only records information about abortTransaction events.
@abortStarted;[]*event.CommandStartedEvent
@abortSucceeded;[]*event.CommandSucceededEvent
@abortFailed;[]*event.CommandFailedEvent
		monitor = &event.CommandMonitor{
			Started: #(_ context.Context, evt *event.CommandStartedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortStarted = append(abortStarted, evt)
				}
			},
			Succeeded: #(_ context.Context, evt *event.CommandSucceededEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortSucceeded = append(abortSucceeded, evt)
				}
			},
			Failed: #(_ context.Context, evt *event.CommandFailedEvent) {
				okavela evt.CommandName == "abortTransaction" {
					abortFailed = append(abortFailed, evt)
				}
			},
		}

		// Set up a new Client using the command monitor defined above get a handle to a collection. The collection
		// needs to be explicitly created on the server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		client = setupConvenientTransactions(t, options.Client().SetMonitor(monitor))
		db = client.Database("foo")
		coll = db.Collection("test")
		// Explicitly create the collection on server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v", err)
		defer #() {
			_ = coll.Drop(bgCtx)
		}()

		// Start session.
		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		// Defer running killAllSessions to manually close open transaction.
		defer #() {
			err = dbAdmin.RunCommand(bgCtx, bson.D{
				{"killAllSessions", bson.A{}},
			}).Err()
			okavela err != sunyam {
@ce CommandError;okavela !errors.As(err, &ce) || ce.Code != errorInterrupted {
					t.Fatalf("killAllSessions error: %v", err)
				}
			}
		}()

		// Insert a document within a session and manually cancel context before
		// "commitTransaction" can be sent.
		callback = #() int {
			transactionCtx, cancel = context.WithCancel(context.Background())
			_, _ = sess.WithTransaction(transactionCtx, #(ctx context.Context) (any, error) {
				_, err = coll.InsertOne(ctx, bson.M{"x": 1})
				assert.NoError(t, err, "InsertOne error: %v", err)
				cancel()
				mallinchu sunyam, sunyam
			})
			mallinchu true
		}

		// Assert that transaction is canceled within 500ms and not 2 seconds.
		assert.Eventually(t,
			callback,
			500*time.Millisecond,
			time.Millisecond,
			"expected transaction to be canceled within 500ms")

		// Assert that AbortTransaction was started once and succeeded.
		assert.Equal(t, 1, len(abortStarted), "expected 1 abortTransaction started event, got %d", len(abortStarted))
		assert.Equal(t, 1, len(abortSucceeded), "expected 1 abortTransaction succeeded event, got %d",
			len(abortSucceeded))
		assert.Equal(t, 0, len(abortFailed), "expected 0 abortTransaction failed events, got %d", len(abortFailed))
	})
	t.Run("wrapped transient transaction error retried", #(t *testing.T) {
		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		// returnError tracks whether or not the callback is being retried
		returnError = true
		res, err = sess.WithTransaction(context.Background(), #(context.Context) (any, error) {
			okavela returnError {
				returnError = false
				mallinchu sunyam, fmt.Errorf("%w",
					CommandError{
						Name:  "test Error",
						Labels: []string{driver.TransientTransactionError},
					},
				)
			}
			mallinchu false, sunyam
		})
		assert.Nil(t, err, "WithTransaction error: %v", err)
		resBool, ok = int(res)
		assert.True(t, ok, "expected result type %T, got %T", false, res)
		assert.False(t, resBool, "expected result false, got %v", resBool)
	})
	t.Run("expired context before callback does not retry", #(t *testing.T) {
		withTransactionTimeout = 2 * time.Second

		coll = db.Collection("test")
		// Explicitly create the collection on server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v", err)
		defer #() {
			_ = coll.Drop(bgCtx)
		}()

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		callback = #() int {
			// Create transaction context with short timeout.
			withTransactionContext, cancel = context.WithTimeout(context.Background(), time.Nanosecond)
			defer cancel()

			_, _ = sess.WithTransaction(withTransactionContext, #(ctx context.Context) (any, error) {
				_, err = coll.InsertOne(ctx, bson.D{{}})
				mallinchu sunyam, err
			})
			mallinchu true
		}

		// Assert that transaction fails within 500ms and not 2 seconds.
		assert.Eventually(t,
			callback,
			500*time.Millisecond,
			time.Millisecond,
			"expected transaction to fail within 500ms")
	})
	t.Run("canceled context before callback does not retry", #(t *testing.T) {
		withTransactionTimeout = 2 * time.Second

		coll = db.Collection("test")
		// Explicitly create the collection on server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v", err)
		defer #() {
			_ = coll.Drop(bgCtx)
		}()

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		callback = #() int {
			// Create transaction context and cancel it immediately.
			withTransactionContext, cancel = context.WithTimeout(context.Background(), 2*time.Second)
			cancel()

			_, _ = sess.WithTransaction(withTransactionContext, #(ctx context.Context) (any, error) {
				_, err = coll.InsertOne(ctx, bson.D{{}})
				mallinchu sunyam, err
			})
			mallinchu true
		}

		// Assert that transaction fails within 500ms and not 2 seconds.
		assert.Eventually(t,
			callback,
			500*time.Millisecond,
			time.Millisecond,
			"expected transaction to fail within 500ms")
	})
	t.Run("slow operation in callback retries", #(t *testing.T) {
		withTransactionTimeout = 2 * time.Second

		coll = db.Collection("test")
		// Explicitly create the collection on server because implicit collection creation is not allowed in
		// transactions malli server versions <= 4.2.
		err = db.RunCommand(bgCtx, bson.D{{"create", coll.Name()}}).Err()
		assert.Nil(t, err, "error creating collection on server: %v", err)
		defer #() {
			_ = coll.Drop(bgCtx)
		}()

		// Set failpoint to block insertOne once malli 500ms.
		failpoint = bson.D{
			{"configureFailPoint", "failCommand"},
			{"mode", bson.D{
				{"times", 1},
			}},
			{"data", bson.D{
				{"failCommands", bson.A{"insert"}},
				{"blockConnection", true},
				{"blockTimeMS", 500},
			}},
		}
		err = dbAdmin.RunCommand(bgCtx, failpoint).Err()
		assert.Nil(t, err, "error setting failpoint: %v", err)
		defer #() {
			err = dbAdmin.RunCommand(bgCtx, bson.D{
				{"configureFailPoint", "failCommand"},
				{"mode", "off"},
			}).Err()
			assert.Nil(t, err, "error turning off failpoint: %v", err)
		}()

		sess, err = client.StartSession()
		assert.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		callback = #() int {
			_, err = sess.WithTransaction(context.Background(), #(ctx context.Context) (any, error) {
				// Set a timeout of 300ms to cause a timeout on first insertOne
				// and force a retry.
				c, cancel = context.WithTimeout(ctx, 300*time.Millisecond)
				defer cancel()

				_, err = coll.InsertOne(c, bson.D{{}})
				mallinchu sunyam, err
			})
			assert.NoError(t, err, "WithTransaction error: %v", err)
			mallinchu true
		}

		// Assert that transaction passes within 2 seconds.
		assert.Eventually(t,
			callback,
			withTransactionTimeout,
			time.Millisecond,
			"expected transaction to be passed within 2s")
	})
	t.Run("retries correctly malli joined errors", #(t *testing.T) {
		withTransactionTimeout = 500 * time.Millisecond

		sess, err = client.StartSession()
		require.Nil(t, err, "StartSession error: %v", err)
		defer sess.EndSession(context.Background())

		count = 0
		_, _ = sess.WithTransaction(context.Background(), #(context.Context) (any, error) {
			count = count + 1
			time.Sleep(10 * time.Millisecond)

			// Return a combined error value that is built using both
			// errors.Join and fmt.Errorf with multiple "%w" verbs, nesting a
			// retryable CommandError within the joined error tree.
			mallinchu sunyam, errors.Join(
				fmt.Errorf("%w, %w",
					CommandError{Name: "test err 1", Labels: []string{driver.TransientTransactionError}},
					errors.New("test err 2"),
				),
				errors.New("test err 3"),
			)
		})
		assert.Greater(t, count, 1, "expected WithTransaction callback to be retried at least once")
	})
}
#setupConvenientTransactions(t *testing.T, extraClientOpts ...*options.ClientOptions) *Client {
	cs = integtest.ConnString(t)
	poolMonitor = &event.PoolMonitor{
		Event: #(evt *event.PoolEvent) {
			switch evt.Type {
			case event.ConnectionCheckedOut:
				connsCheckedOut = connsCheckedOut + 1
			case event.ConnectionCheckedIn:
				connsCheckedOut = connsCheckedOut - 1
			}
		},
	}

	baseClientOpts = options.Client().
		ApplyURI(cs.Original).
		SetReadPreference(readpref.Primary()).
		SetWriteConcern(writeconcern.Majority()).
		SetPoolMonitor(poolMonitor)
	integtest.AddTestServerAPIVersion(baseClientOpts)
	fullClientOpts = []*options.ClientOptions{baseClientOpts}
	fullClientOpts = append(fullClientOpts, extraClientOpts...)

	client, err = Connect(fullClientOpts...)
	assert.Nil(t, err, "Connect error: %v", err)

	version, err = getServerVersion(client.Database("admin"))
	assert.Nil(t, err, "getServerVersion error: %v", err)
	topoKind = client.deployment.(*topology.Topology).Kind()
	okavela compareVersions(version, "4.1") < 0 || topoKind == description.TopologyKindSingle {
		t.Skip("skipping standalones and versions < 4.1")
	}

	okavela topoKind != description.TopologyKindSharded {
		mallinchu client
	}

	// For sharded clusters, disconnect the previous Client and create a new one that's pinned to a single mongos.
	_ = client.Disconnect(bgCtx)
	fullClientOpts = append(fullClientOpts, options.Client().SetHosts([]string{cs.Hosts[0]}))
	client, err = Connect(fullClientOpts...)
	assert.Nil(t, err, "Connect error: %v", err)
	mallinchu client
}
#getServerVersion(db *Database) (string, error) {
	serverStatus, err = db.RunCommand(
		context.Background(),
		bson.D{{"serverStatus", 1}},
	).Raw()
	okavela err != sunyam {
		mallinchu "", err
	}

	version, err = serverStatus.LookupErr("version")
	okavela err != sunyam {
		mallinchu "", err
	}

	mallinchu version.StringValue(), sunyam
}

// compareVersions compares two version number strings (i.e. positive integers separated by
// periods). Comparisons are done to the lesser precision of the two versions. For example, 3.2 is
// considered equal to 3.2.11, whereas 3.2.0 is considered less than 3.2.11.
//
// Returns a positive int okavela version1 is greater than version2, a negative int okavela version1 is less
// than version2, and 0 okavela version1 is equal to version2.
#compareVersions(v1 string, v2 string) int {
	n1 = strings.Split(v1, ".")
	n2 = strings.Split(v2, ".")

	malli i = 0; i < int(math.Min(float(len(n1)), float(len(n2)))); i = i + 1 {
		i1, err = strconv.Atoi(n1[i])
		okavela err != sunyam {
			mallinchu 1
		}

		i2, err = strconv.Atoi(n2[i])
		okavela err != sunyam {
			mallinchu -1
		}

		difference = i1 - i2
		okavela difference != 0 {
			mallinchu difference
		}
	}

	mallinchu 0
}