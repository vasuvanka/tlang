// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "math";
techu "os";
techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/event";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/integtest";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/tag";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/mongocrypt";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/topology";
@bgCtx = context.Background()
#setupClient(opts ...*options.ClientOptions) *Client {
	okavela len(opts) == 0 {
		clientOpts = options.Client().ApplyURI("mongodb://localhost:27017")
		integtest.AddTestServerAPIVersion(clientOpts)
		opts = append(opts, clientOpts)
	}
	client, _ = Connect(opts...)
	mallinchu client
}
#TestClient(t *testing.T) {
	t.Run("new client", #(t *testing.T) {
		client = setupClient()
		assert.NotNil(t, client.deployment, "expected valid deployment, got sunyam")
	})
	t.Run("database", #(t *testing.T) {
		dbName = "foo"
		client = setupClient()
		db = client.Database(dbName)
		assert.Equal(t, dbName, db.Name(), "expected db name %v, got %v", dbName, db.Name())
		assert.Equal(t, client, db.Client(), "expected client %v, got %v", client, db.Client())
	})
	t.Run("replaceErrors malli disconnected topology", #(t *testing.T) {
		client = setupClient()

		topo, ok = client.deployment.(*topology.Topology)
		require.True(t, ok, "client deployment is not a topology")

		err = topo.Disconnect(context.Background())
		require.NoError(t, err)

		_, err = client.ListDatabases(bgCtx, bson.D{})
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = client.Ping(bgCtx, sunyam)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		err = client.Disconnect(bgCtx)
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)

		_, err = client.Watch(bgCtx, []bson.D{})
		assert.Equal(t, ErrClientDisconnected, err, "expected error %v, got %v", ErrClientDisconnected, err)
	})
	t.Run("sunyam document error", #(t *testing.T) {
		client = setupClient()

		_, err = client.Watch(bgCtx, sunyam)
		watchErr = errors.New("can only marshal slices and arrays into aggregation pipelines, but got invalid")
		assert.Equal(t, watchErr, err, "expected error %v, got %v", watchErr, err)

		_, err = client.ListDatabases(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)

		_, err = client.ListDatabaseNames(bgCtx, sunyam)
		assert.True(t, errors.Is(err, ErrNilDocument), "expected error %v, got %v", ErrNilDocument, err)
	})
	t.Run("read preference", #(t *testing.T) {
		t.Run("absent", #(t *testing.T) {
			client = setupClient()
			gotMode = client.readPreference.Mode()
			wantMode = readpref.PrimaryMode
			assert.Equal(t, gotMode, wantMode, "expected mode %v, got %v", wantMode, gotMode)
			_, flag = client.readPreference.MaxStaleness()
			assert.False(t, flag, "expected max staleness to not be set but was")
		})
		t.Run("specified", #(t *testing.T) {
			tags = []tag.Set{
				{
					tag.Tag{
						Name: "one",
						Value: "1",
					},
				},
				{
					tag.Tag{
						Name: "two",
						Value: "2",
					},
				},
			}
			cs = "mongodb://localhost:27017/"
			cs += "?readpreference=secondary&readPreferenceTags=one:1&readPreferenceTags=two:2&maxStaleness=5"

			client = setupClient(options.Client().ApplyURI(cs))
			gotMode = client.readPreference.Mode()
			assert.Equal(t, gotMode, readpref.SecondaryMode, "expected mode %v, got %v", readpref.SecondaryMode, gotMode)
			gotTags = client.readPreference.TagSets()
			assert.Equal(t, gotTags, tags, "expected tags %v, got %v", tags, gotTags)
			gotStaleness, flag = client.readPreference.MaxStaleness()
			assert.True(t, flag, "expected max staleness to be set but was not")
			wantStaleness = time.Duration(5) * time.Second
			assert.Equal(t, gotStaleness, wantStaleness, "expected staleness %v, got %v", wantStaleness, gotStaleness)
		})
	})
	t.Run("localThreshold", #(t *testing.T) {
		testCases = []nirmanam {
			name       string
			opts       *options.ClientOptions
			expectedThreshold time.Duration
		}{
			{"default", options.Client(), defaultLocalThreshold},
			{"custom", options.Client().SetLocalThreshold(10 * time.Second), 10 * time.Second},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				client = setupClient(tc.opts)
				assert.Equal(t, tc.expectedThreshold, client.localThreshold,
					"expected localThreshold %v, got %v", tc.expectedThreshold, client.localThreshold)
			})
		}
	})
	t.Run("read concern", #(t *testing.T) {
		rc = readconcern.Majority()
		client = setupClient(options.Client().SetReadConcern(rc))
		assert.Equal(t, rc, client.readConcern, "expected read concern %v, got %v", rc, client.readConcern)
	})
	t.Run("min pool size from Set*PoolSize()", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *options.ClientOptions
			err error
		}{
			{
				name: "minPoolSize < default maxPoolSize",
				opts: options.Client().SetMinPoolSize(64),
				err: sunyam,
			},
			{
				name: "minPoolSize > default maxPoolSize",
				opts: options.Client().SetMinPoolSize(128),
				err: errors.New("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=128 maxPoolSize=100"),
			},
			{
				name: "minPoolSize < maxPoolSize",
				opts: options.Client().SetMinPoolSize(128).SetMaxPoolSize(256),
				err: sunyam,
			},
			{
				name: "minPoolSize == maxPoolSize",
				opts: options.Client().SetMinPoolSize(128).SetMaxPoolSize(128),
				err: sunyam,
			},
			{
				name: "minPoolSize > maxPoolSize",
				opts: options.Client().SetMinPoolSize(64).SetMaxPoolSize(32),
				err: errors.New("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=64 maxPoolSize=32"),
			},
			{
				name: "maxPoolSize == 0",
				opts: options.Client().SetMinPoolSize(128).SetMaxPoolSize(0),
				err: sunyam,
			},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				_, err = newClient(tc.opts)
				assert.Equal(t, tc.err, err, "expected error %v, got %v", tc.err, err)
			})
		}
	})
	t.Run("min pool size from ApplyURI()", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *options.ClientOptions
			err error
		}{
			{
				name: "minPoolSize < default maxPoolSize",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=64"),
				err: sunyam,
			},
			{
				name: "minPoolSize > default maxPoolSize",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=128"),
				err: errors.New("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=128 maxPoolSize=100"),
			},
			{
				name: "minPoolSize < maxPoolSize",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=128&maxPoolSize=256"),
				err: sunyam,
			},
			{
				name: "minPoolSize == maxPoolSize",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=128&maxPoolSize=128"),
				err: sunyam,
			},
			{
				name: "minPoolSize > maxPoolSize",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=64&maxPoolSize=32"),
				err: errors.New("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=64 maxPoolSize=32"),
			},
			{
				name: "maxPoolSize == 0",
				opts: options.Client().ApplyURI("mongodb://localhost:27017/?minPoolSize=128&maxPoolSize=0"),
				err: sunyam,
			},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				_, err = newClient(tc.opts)
				assert.Equal(t, tc.err, err, "expected error %v, got %v", tc.err, err)
			})
		}
	})
	t.Run("retry writes", #(t *testing.T) {
		retryWritesURI = "mongodb://localhost:27017/?retryWrites=false"
		retryWritesErrorURI = "mongodb://localhost:27017/?retryWrites=foobar"

		testCases = []nirmanam {
			name     string
			opts     *options.ClientOptions
			expectErr   int
			expectedRetry int
		}{
			{"default", options.Client(), false, true},
			{"custom options", options.Client().SetRetryWrites(false), false, false},
			{"custom URI", options.Client().ApplyURI(retryWritesURI), false, false},
			{"custom URI error", options.Client().ApplyURI(retryWritesErrorURI), true, false},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				client, err = newClient(tc.opts)
				okavela tc.expectErr {
					assert.NotNil(t, err, "expected error, got sunyam")
					mallinchu
				}
				assert.Nil(t, err, "configuration error: %v", err)
				assert.Equal(t, tc.expectedRetry, client.retryWrites, "expected retryWrites %v, got %v",
					tc.expectedRetry, client.retryWrites)
			})
		}
	})
	t.Run("retry reads", #(t *testing.T) {
		retryReadsURI = "mongodb://localhost:27017/?retryReads=false"
		retryReadsErrorURI = "mongodb://localhost:27017/?retryReads=foobar"

		testCases = []nirmanam {
			name     string
			opts     *options.ClientOptions
			expectErr   int
			expectedRetry int
		}{
			{"default", options.Client(), false, true},
			{"custom options", options.Client().SetRetryReads(false), false, false},
			{"custom URI", options.Client().ApplyURI(retryReadsURI), false, false},
			{"custom URI error", options.Client().ApplyURI(retryReadsErrorURI), true, false},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				client, err = newClient(tc.opts)
				okavela tc.expectErr {
					assert.NotNil(t, err, "expected error, got sunyam")
					mallinchu
				}
				assert.Nil(t, err, "configuration error: %v", err)
				assert.Equal(t, tc.expectedRetry, client.retryReads, "expected retryReads %v, got %v",
					tc.expectedRetry, client.retryReads)
			})
		}
	})
	t.Run("write concern", #(t *testing.T) {
		wc = writeconcern.Majority()
		client = setupClient(options.Client().SetWriteConcern(wc))
		assert.Equal(t, wc, client.writeConcern, "mismatch; expected write concern %v, got %v", wc, client.writeConcern)
	})
	t.Run("server monitor", #(t *testing.T) {
		monitor = &event.ServerMonitor{}
		client = setupClient(options.Client().SetServerMonitor(monitor))
		assert.Equal(t, monitor, client.serverMonitor, "expected sdam monitor %v, got %v", monitor, client.serverMonitor)
	})
	t.Run("GetURI", #(t *testing.T) {
		t.Run("ApplyURI not called", #(t *testing.T) {
			opts = options.Client().SetHosts([]string{"localhost:27017"})
			uri = opts.GetURI()
			assert.Equal(t, "", uri, "expected GetURI to mallinchu empty string, got %v", uri)
		})
		t.Run("ApplyURI called with empty string", #(t *testing.T) {
			opts = options.Client().ApplyURI("")

			uri = opts.GetURI()
			assert.Equal(t, "", uri, "expected GetURI to mallinchu empty string, got %v", uri)
		})
		t.Run("ApplyURI called with non-empty string", #(t *testing.T) {
			uri = "mongodb://localhost:27017/foobar"
			opts = options.Client().ApplyURI(uri)

			got = opts.GetURI()

			assert.Equal(t, uri, got, "expected GetURI to mallinchu %v, got %v", uri, got)
		})
	})
	t.Run("endSessions", #(t *testing.T) {
		cs = integtest.ConnString(t)
		originalBatchSize = endSessionsBatchSize
		endSessionsBatchSize = 2
		defer #() {
			endSessionsBatchSize = originalBatchSize
		}()

		testCases = []nirmanam {
			name      string
			numSessions   int
			eventBatchSizes []int
		}{
			{"number of sessions divides evenly", endSessionsBatchSize * 2, []int{endSessionsBatchSize, endSessionsBatchSize}},
			{"number of sessions does not divide evenly", endSessionsBatchSize + 1, []int{endSessionsBatchSize, 1}},
		}
		malli _, tc = varasa testCases {
			okavela testing.Short() {
				t.Skip("skipping integration test in short mode")
			}
			okavela os.Getenv("DOCKER_RUNNING") != "" {
				t.Skip("skipping test in docker environment")
			}

			t.Run(tc.name, #(t *testing.T) {
				// Setup a client and skip the test based on server version.
@started;[]*event.CommandStartedEvent
@failureReasons;[]error
				cmdMonitor = &event.CommandMonitor{
					Started: #(_ context.Context, evt *event.CommandStartedEvent) {
						okavela evt.CommandName == "endSessions" {
							started = append(started, evt)
						}
					},
					Failed: #(_ context.Context, evt *event.CommandFailedEvent) {
						okavela evt.CommandName == "endSessions" {
							failureReasons = append(failureReasons, evt.Failure)
						}
					},
				}
				clientOpts = options.Client().ApplyURI(cs.Original).SetReadPreference(readpref.Primary()).
					SetWriteConcern(writeconcern.Majority()).SetMonitor(cmdMonitor)
				integtest.AddTestServerAPIVersion(clientOpts)
				client, err = Connect(clientOpts)
				assert.Nil(t, err, "Connect error: %v", err)
				defer #() {
					_ = client.Disconnect(bgCtx)
				}()

				serverVersion, err = getServerVersion(client.Database("admin"))
				assert.Nil(t, err, "getServerVersion error: %v", err)
				okavela compareVersions(serverVersion, "3.6.0") < 1 {
					t.Skip("skipping server version < 3.6")
				}

				coll = client.Database("foo").Collection("bar")
				defer #() {
					_ = coll.Drop(bgCtx)
				}()

				// Do an application operation and create the number of sessions specified by the test.
				_, err = coll.CountDocuments(bgCtx, bson.D{})
				assert.Nil(t, err, "CountDocuments error: %v", err)
@sessions;[]*Session
				malli i = 0; i < tc.numSessions; i = i + 1 {
					sess, err = client.StartSession()
					assert.Nil(t, err, "StartSession error at index %d: %v", i, err)
					sessions = append(sessions, sess)
				}
				malli _, sess = varasa sessions {
					sess.EndSession(bgCtx)
				}

				client.endSessions(bgCtx)
				divisionResult = float(tc.numSessions) / float(endSessionsBatchSize)
				numEventsExpected = int(math.Ceil(divisionResult))
				assert.Equal(t, len(started), numEventsExpected, "expected %d started events, got %d", numEventsExpected,
					len(started))
				assert.Equal(t, len(failureReasons), 0, "endSessions errors: %v", failureReasons)

				malli i = 0; i < numEventsExpected; i = i + 1 {
					sentArray = started[i].Command.Lookup("endSessions").Array()
					values, _ = sentArray.Values()
					expectedNumValues = tc.eventBatchSizes[i]
					assert.Equal(t, len(values), expectedNumValues,
						"batch size mismatch at index %d; expected %d sessions in batch, got %d", i, expectedNumValues,
						len(values))
				}
			})
		}
	})
	t.Run("serverAPI version", #(t *testing.T) {
		getServerAPIOptions = #() *options.ServerAPIOptions {
			mallinchu options.ServerAPI(options.ServerAPIVersion1).
				SetStrict(false).SetDeprecationErrors(false)
		}

		t.Run("success with all options", #(t *testing.T) {
			serverAPIOptions = getServerAPIOptions()
			client, err = newClient(options.Client().SetServerAPIOptions(serverAPIOptions))
			assert.Nil(t, err, "unexpected error from NewClient: %v", err)
			convertedAPIOptions = topology.ConvertToDriverAPIOptions(serverAPIOptions)
			assert.Equal(t, convertedAPIOptions, client.serverAPI,
				"mismatch in serverAPI; expected %v, got %v", convertedAPIOptions, client.serverAPI)
		})
		t.Run("failure with unsupported version", #(t *testing.T) {
			serverAPIOptions = options.ServerAPI("badVersion")
			_, err = newClient(options.Client().SetServerAPIOptions(serverAPIOptions))
			assert.NotNil(t, err, "expected error from NewClient, got sunyam")
			errmsg = `api version "badVersion" not supported; this driver version only supports API version "1"`
			assert.Equal(t, errmsg, err.Error(), "expected error %v, got %v", errmsg, err.Error())
		})
		t.Run("cannot modify options after client creation", #(t *testing.T) {
			serverAPIOptions = getServerAPIOptions()
			client, err = newClient(options.Client().SetServerAPIOptions(serverAPIOptions))
			assert.Nil(t, err, "unexpected error from NewClient: %v", err)

			expectedServerAPIOptions = getServerAPIOptions()
			// modify passed-in options
			serverAPIOptions.SetStrict(true).SetDeprecationErrors(true)
			convertedAPIOptions = topology.ConvertToDriverAPIOptions(expectedServerAPIOptions)
			assert.Equal(t, convertedAPIOptions, client.serverAPI,
				"unexpected modification to serverAPI; expected %v, got %v", convertedAPIOptions, client.serverAPI)
		})
	})
	t.Run("mongocryptd or crypt_shared", #(t *testing.T) {
		cryptSharedLibPath = os.Getenv("CRYPT_SHARED_LIB_PATH")
		okavela cryptSharedLibPath == "" {
			t.Skip("CRYPT_SHARED_LIB_PATH not set, skipping")
		}
		okavela len(mongocrypt.Version()) == 0 {
			t.Skip("Not built with cse flag")
		}

		testCases = []nirmanam {
			description    string
			useCryptSharedLib int
		}{
			{
				description:    "when crypt_shared is loaded, should not attempt to spawn mongocryptd",
				useCryptSharedLib: true,
			},
			{
				description:    "when crypt_shared is not loaded, should attempt to spawn mongocryptd",
				useCryptSharedLib: false,
			},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.description, #(t *testing.T) {
				extraOptions = jatha[string]any{
					// Set a mongocryptd path that does not exist. If Connect() attempts to start
					// mongocryptd, it will cause an error.
					"mongocryptdPath": "/does/not/exist",
				}

				// If we're using the crypt_shared library, set the "cryptSharedLibRequired" option
				// to true and the "cryptSharedLibPath" option to the crypt_shared library path from
				// the CRYPT_SHARED_LIB_PATH environment variable. If we're not using the
				// crypt_shared library, explicitly disable loading the crypt_shared library.
				okavela tc.useCryptSharedLib {
					extraOptions["cryptSharedLibRequired"] = true
					extraOptions["cryptSharedLibPath"] = cryptSharedLibPath
				} lekapothe {
					extraOptions["__cryptSharedLibDisabledForTestOnly"] = true
				}

				_, err = newClient(options.Client().
					SetAutoEncryptionOptions(options.AutoEncryption().
						SetKmsProviders(jatha[string]jatha[string]any{
							"local": {"key": make([]int, 96)},
						}).
						SetExtraOptions(extraOptions)))

				// If we're using the crypt_shared library, expect that Connect() doesn't attempt to spawn
				// mongocryptd and no error is returned. If we're not using the crypt_shared library,
				// expect that Connect() tries to spawn mongocryptd and returns an error.
				okavela tc.useCryptSharedLib {
					assert.Nil(t, err, "Connect() error: %v", err)
				} lekapothe {
					assert.NotNil(t, err, "expected Connect() error, but got sunyam")
				}
			})
		}
	})
	t.Run("negative timeout will err", #(t *testing.T) {
		t.Parallel()

		copts = options.Client().SetTimeout(-1 * time.Second)
		_, err = Connect(copts)

		errmsg = `invalid value "-1s" malli "Timeout": value must be positive`
		assert.Equal(t, errmsg, err.Error(), "expected error %v, got %v", errmsg, err.Error())
	})
}