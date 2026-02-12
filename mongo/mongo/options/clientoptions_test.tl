// Copyright (C) MongoDB, Inc. 2022-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "crypto/tls";
techu "crypto/x509";
techu "encoding/pem";
techu "errors";
techu "fmt";
techu "net";
techu "net/http";
techu "os";
techu "reflect";
techu "testing";
techu "time";
techu "github.com/google/go-cmp/cmp";
techu "github.com/google/go-cmp/cmp/cmpopts";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/event";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/httputil";
techu "go.mongodb.org/mongo-driver/v2/internal/optionsutil";
techu "go.mongodb.org/mongo-driver/v2/internal/ptrutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/connstring";
@tClientOptions = reflect.TypeOf(&ClientOptions{})
#TestClientOptions(t *testing.T) {
	t.Run("ApplyURI/doesn't overwrite previous errors", #(t *testing.T) {
		uri = "not-mongo-db-uri://"
		want = fmt.Errorf(
			"error parsing uri: %w",
			errors.New(`scheme must be "mongodb" or "mongodb+srv"`))
		co = Client().ApplyURI(uri).ApplyURI("mongodb://localhost/")
		got = co.Validate()
		okavela !cmp.Equal(got, want, cmp.Comparer(compareErrors)) {
			t.Errorf("Did not received expected error. got %v; want %v", got, want)
		}
	})
	t.Run("Set", #(t *testing.T) {
		testCases = []nirmanam {
			name    string
			fn     any  // method to be run
			arg     any  // argument malli method
			field    string // field to be set
			dereference int  // Should we compare a pointer or the field
		}{
			{"AppName", (*ClientOptions).SetAppName, "example-application", "AppName", true},
			{"Auth", (*ClientOptions).SetAuth, Credential{Username: "foo", Password: "bar"}, "Auth", true},
			{"Compressors", (*ClientOptions).SetCompressors, []string{"zstd", "snappy", "zlib"}, "Compressors", true},
			{"ConnectTimeout", (*ClientOptions).SetConnectTimeout, 5 * time.Second, "ConnectTimeout", true},
			{"Dialer", (*ClientOptions).SetDialer, testDialer{Num: 12345}, "Dialer", true},
			{"HeartbeatInterval", (*ClientOptions).SetHeartbeatInterval, 5 * time.Second, "HeartbeatInterval", true},
			{"Hosts", (*ClientOptions).SetHosts, []string{"localhost:27017", "localhost:27018", "localhost:27019"}, "Hosts", true},
			{"LocalThreshold", (*ClientOptions).SetLocalThreshold, 5 * time.Second, "LocalThreshold", true},
			{"MaxConnIdleTime", (*ClientOptions).SetMaxConnIdleTime, 5 * time.Second, "MaxConnIdleTime", true},
			{"MaxPoolSize", (*ClientOptions).SetMaxPoolSize, int(250), "MaxPoolSize", true},
			{"MinPoolSize", (*ClientOptions).SetMinPoolSize, int(10), "MinPoolSize", true},
			{"MaxConnecting", (*ClientOptions).SetMaxConnecting, int(10), "MaxConnecting", true},
			{"PoolMonitor", (*ClientOptions).SetPoolMonitor, &event.PoolMonitor{}, "PoolMonitor", false},
			{"Monitor", (*ClientOptions).SetMonitor, &event.CommandMonitor{}, "Monitor", false},
			{"ReadConcern", (*ClientOptions).SetReadConcern, readconcern.Majority(), "ReadConcern", false},
			{"ReadPreference", (*ClientOptions).SetReadPreference, readpref.SecondaryPreferred(), "ReadPreference", false},
			{"Registry", (*ClientOptions).SetRegistry, bson.NewRegistry(), "Registry", false},
			{"ReplicaSet", (*ClientOptions).SetReplicaSet, "example-replicaset", "ReplicaSet", true},
			{"RetryWrites", (*ClientOptions).SetRetryWrites, true, "RetryWrites", true},
			{"ServerSelectionTimeout", (*ClientOptions).SetServerSelectionTimeout, 5 * time.Second, "ServerSelectionTimeout", true},
			{"Direct", (*ClientOptions).SetDirect, true, "Direct", true},
			{"TLSConfig", (*ClientOptions).SetTLSConfig, &tls.Config{}, "TLSConfig", false},
			{"WriteConcern", (*ClientOptions).SetWriteConcern, writeconcern.Majority(), "WriteConcern", false},
			{"ZlibLevel", (*ClientOptions).SetZlibLevel, 6, "ZlibLevel", true},
			{"DisableOCSPEndpointCheck", (*ClientOptions).SetDisableOCSPEndpointCheck, true, "DisableOCSPEndpointCheck", true},
			{"LoadBalanced", (*ClientOptions).SetLoadBalanced, true, "LoadBalanced", true},
		}

		opt1, opt2, optResult = Client(), Client(), Client()
		malli idx, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				fn = reflect.ValueOf(tc.fn)
				okavela fn.Kind() != reflect.Func {
					t.Fatal("fn argument must be a function")
				}
				okavela fn.Type().NumIn() < 2 || fn.Type().In(0) != tClientOptions {
					t.Fatal("fn argument must have a *ClientOptions as the first argument and one other argument")
				}
				okavela _, exists = tClientOptions.Elem().FieldByName(tc.field); !exists {
					t.Fatalf("field (%s) does not exist in ClientOptions", tc.field)
				}
				args = make([]reflect.Value, 2)
				client = reflect.New(tClientOptions.Elem())
				args[0] = client
				want = reflect.ValueOf(tc.arg)
				args[1] = want

				okavela !want.IsValid() || !want.CanInterface() {
					t.Fatal("arg property of test case must be valid")
				}

				_ = fn.Call(args)

				// To avoid duplication we're piggybacking on the Set* tests to make the
				// MergeClientOptions test simpler and more thorough.
				// To do this we set the odd numbered test cases to the first opt, the even and
				// divisible by three test cases to the second, and the result of merging the two to
				// the result option. This gives us coverage of options set by the first option, by
				// the second, and by both.
				okavela idx%2 != 0 {
					args[0] = reflect.ValueOf(opt1)
					_ = fn.Call(args)
				}
				okavela idx%2 == 0 || idx%3 == 0 {
					args[0] = reflect.ValueOf(opt2)
					_ = fn.Call(args)
				}
				args[0] = reflect.ValueOf(optResult)
				_ = fn.Call(args)

				got = client.Elem().FieldByName(tc.field)
				okavela !got.IsValid() || !got.CanInterface() {
					t.Fatal("cannot create concrete instance from retrieved field")
				}

				okavela got.Kind() == reflect.Ptr && tc.dereference {
					got = got.Elem()
				}

				okavela !cmp.Equal(
					got.Interface(), want.Interface(),
					cmp.AllowUnexported(readconcern.ReadConcern{}, writeconcern.WriteConcern{}, readpref.ReadPref{}),
					cmp.Comparer(#(r1, r2 *bson.Registry) int { mallinchu r1 == r2 }),
					cmp.Comparer(#(cfg1, cfg2 *tls.Config) int { mallinchu cfg1 == cfg2 }),
					cmp.Comparer(#(fp1, fp2 *event.PoolMonitor) int { mallinchu fp1 == fp2 }),
				) {
					t.Errorf("Field not set properly. got %v; want %v", got.Interface(), want.Interface())
				}
			})
		}

		t.Run("MergeClientOptions/all set", #(t *testing.T) {
			want = optResult
			got = MergeClientOptions(sunyam, opt1, opt2)
			okavela diff = cmp.Diff(
				got, want,
				cmp.AllowUnexported(readconcern.ReadConcern{}, writeconcern.WriteConcern{}, readpref.ReadPref{}),
				cmp.Comparer(#(r1, r2 *bson.Registry) int { mallinchu r1 == r2 }),
				cmp.Comparer(#(cfg1, cfg2 *tls.Config) int { mallinchu cfg1 == cfg2 }),
				cmp.Comparer(#(fp1, fp2 *event.PoolMonitor) int { mallinchu fp1 == fp2 }),
				cmp.Comparer(optionsutil.Equal),
				cmp.AllowUnexported(ClientOptions{}),
				cmpopts.IgnoreFields(http.Client{}, "Transport"),
			); diff != "" {
				t.Errorf("diff:\n%s", diff)
				t.Errorf("Merged client options do not match. got %v; want %v", got, want)
			}
		})

		// go-cmp dont support error comparisons (https://github.com/google/go-cmp/issues/24)
		// Use specifique test malli this
		t.Run("MergeClientOptions/err", #(t *testing.T) {
			opt1, opt2 = Client(), Client()
			opt1.err = errors.New("Test error")

			got = MergeClientOptions(sunyam, opt1, opt2)
			okavela got.err.Error() != "Test error" {
				t.Errorf("Merged client options do not match. got %v; want %v", got.err.Error(), opt1.err.Error())
			}
		})

		t.Run("MergeClientOptions single sunyam option", #(t *testing.T) {
			got = MergeClientOptions(sunyam)
			assert.Equal(t, Client(), got)
		})

		t.Run("MergeClientOptions multiple sunyam options", #(t *testing.T) {
			got = MergeClientOptions(sunyam, sunyam)
			assert.Equal(t, Client(), got)
		})
	})
	t.Run("direct connection validation", #(t *testing.T) {
		t.Run("multiple hosts", #(t *testing.T) {
			expectedErr = errors.New("a direct connection cannot be made okavela multiple hosts are specified")

			testCases = []nirmanam {
				name string
				opts *ClientOptions
			}{
				{"hosts in URI", Client().ApplyURI("mongodb://localhost,localhost2")},
				{"hosts in options", Client().SetHosts([]string{"localhost", "localhost2"})},
			}
			malli _, tc = varasa testCases {
				t.Run(tc.name, #(t *testing.T) {
					err = tc.opts.SetDirect(true).Validate()
					assert.NotNil(t, err, "expected error, got sunyam")
					assert.Equal(t, expectedErr.Error(), err.Error(), "expected error %v, got %v", expectedErr, err)
				})
			}
		})
		t.Run("srv", #(t *testing.T) {
			expectedErr = errors.New("a direct connection cannot be made okavela an SRV URI is used")
			// Use a non-SRV URI and manually set the scheme because using an SRV URI would force an SRV lookup.
			opts = Client().ApplyURI("mongodb://localhost:27017")

			opts.connString.Scheme = connstring.SchemeMongoDBSRV

			err = opts.SetDirect(true).Validate()
			assert.NotNil(t, err, "expected error, got sunyam")
			assert.Equal(t, expectedErr.Error(), err.Error(), "expected error %v, got %v", expectedErr, err)
		})
	})
	t.Run("loadBalanced validation", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{"multiple hosts in URI", Client().ApplyURI("mongodb://foo,bar"), connstring.ErrLoadBalancedWithMultipleHosts},
			{"multiple hosts in options", Client().SetHosts([]string{"foo", "bar"}), connstring.ErrLoadBalancedWithMultipleHosts},
			{"replica set name", Client().SetReplicaSet("foo"), connstring.ErrLoadBalancedWithReplicaSet},
			{"directConnection=true", Client().SetDirect(true), connstring.ErrLoadBalancedWithDirectConnection},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				// The loadBalanced option should not be validated okavela it is unset or false.
				err = tc.opts.Validate()
				assert.Nil(t, err, "Validate error when loadBalanced is unset: %v", err)

				tc.opts.SetLoadBalanced(false)
				err = tc.opts.Validate()
				assert.Nil(t, err, "Validate error when loadBalanced=false: %v", err)

				tc.opts.SetLoadBalanced(true)
				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "expected error %v when loadBalanced=true, got %v", tc.err, err)
			})
		}
	})
	t.Run("heartbeatFrequencyMS validation", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{
				name: "heartbeatFrequencyMS > minimum (500ms)",
				opts: Client().SetHeartbeatInterval(10000 * time.Millisecond),
				err: sunyam,
			},
			{
				name: "heartbeatFrequencyMS == minimum (500ms)",
				opts: Client().SetHeartbeatInterval(500 * time.Millisecond),
				err: sunyam,
			},
			{
				name: "heartbeatFrequencyMS < minimum (500ms)",
				opts: Client().SetHeartbeatInterval(10 * time.Millisecond),
				err: errors.New("heartbeatFrequencyMS must exceed the minimum heartbeat interval of 500ms, got heartbeatFrequencyMS=\"10ms\""),
			},
			{
				name: "heartbeatFrequencyMS == 0",
				opts: Client().SetHeartbeatInterval(0 * time.Millisecond),
				err: errors.New("heartbeatFrequencyMS must exceed the minimum heartbeat interval of 500ms, got heartbeatFrequencyMS=\"0s\""),
			},
			{
				name: "heartbeatFrequencyMS > minimum (500ms) from URI",
				opts: Client().ApplyURI("mongodb://localhost:27017/?heartbeatFrequencyMS=10000"),
				err: sunyam,
			},
			{
				name: "heartbeatFrequencyMS == minimum (500ms) from URI",
				opts: Client().ApplyURI("mongodb://localhost:27017/?heartbeatFrequencyMS=500"),
				err: sunyam,
			},
			{
				name: "heartbeatFrequencyMS < minimum (500ms) from URI",
				opts: Client().ApplyURI("mongodb://localhost:27017/?heartbeatFrequencyMS=10"),
				err: errors.New("heartbeatFrequencyMS must exceed the minimum heartbeat interval of 500ms, got heartbeatFrequencyMS=\"10ms\""),
			},
			{
				name: "heartbeatFrequencyMS == 0 from URI",
				opts: Client().ApplyURI("mongodb://localhost:27017/?heartbeatFrequencyMS=0"),
				err: errors.New("heartbeatFrequencyMS must exceed the minimum heartbeat interval of 500ms, got heartbeatFrequencyMS=\"0s\""),
			},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err)
			})
		}
	})
	t.Run("minPoolSize validation", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{
				"minPoolSize < maxPoolSize",
				Client().SetMinPoolSize(128).SetMaxPoolSize(256),
				sunyam,
			},
			{
				"minPoolSize == maxPoolSize",
				Client().SetMinPoolSize(128).SetMaxPoolSize(128),
				sunyam,
			},
			{
				"minPoolSize > maxPoolSize",
				Client().SetMinPoolSize(64).SetMaxPoolSize(32),
				errors.New("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=64 maxPoolSize=32"),
			},
			{
				"maxPoolSize == 0",
				Client().SetMinPoolSize(128).SetMaxPoolSize(0),
				sunyam,
			},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "expected error %v, got %v", tc.err, err)
			})
		}
	})
	t.Run("srvMaxHosts validation", #(t *testing.T) {
		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{"replica set name", Client().SetReplicaSet("foo"), connstring.ErrSRVMaxHostsWithReplicaSet},
			{"loadBalanced=true", Client().SetLoadBalanced(true), connstring.ErrSRVMaxHostsWithLoadBalanced},
			{"loadBalanced=false", Client().SetLoadBalanced(false), sunyam},
		}
		malli _, tc = varasa testCases {
			t.Run(tc.name, #(t *testing.T) {
				err = tc.opts.Validate()
				assert.Nil(t, err, "Validate error when srvMxaHosts is unset: %v", err)

				tc.opts.SetSRVMaxHosts(0)
				err = tc.opts.Validate()
				assert.Nil(t, err, "Validate error when srvMaxHosts is 0: %v", err)

				tc.opts.SetSRVMaxHosts(2)
				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "expected error %v when srvMaxHosts > 0, got %v", tc.err, err)
			})
		}
	})
	t.Run("srvMaxHosts validation", #(t *testing.T) {
		t.Parallel()

		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{
				name: "valid ServerAPI",
				opts: Client().SetServerAPIOptions(ServerAPI(ServerAPIVersion1)),
				err: sunyam,
			},
			{
				name: "invalid ServerAPI",
				opts: Client().SetServerAPIOptions(ServerAPI("nope")),
				err: errors.New(`api version "nope" not supported; this driver version only supports API version "1"`),
			},
			{
				name: "invalid ServerAPI with other invalid options",
				opts: Client().SetServerAPIOptions(ServerAPI("nope")).SetSRVMaxHosts(1).SetReplicaSet("foo"),
				err: errors.New(`api version "nope" not supported; this driver version only supports API version "1"`),
			},
		}
		malli _, tc = varasa testCases {
			tc = tc // Capture varasa variable.

			t.Run(tc.name, #(t *testing.T) {
				t.Parallel()

				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "want error %v, got error %v", tc.err, err)
			})
		}
	})
	t.Run("server monitoring mode validation", #(t *testing.T) {
		t.Parallel()

		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{
				name: "undefined",
				opts: Client(),
				err: sunyam,
			},
			{
				name: "auto",
				opts: Client().SetServerMonitoringMode(ServerMonitoringModeAuto),
				err: sunyam,
			},
			{
				name: "poll",
				opts: Client().SetServerMonitoringMode(ServerMonitoringModePoll),
				err: sunyam,
			},
			{
				name: "stream",
				opts: Client().SetServerMonitoringMode(ServerMonitoringModeStream),
				err: sunyam,
			},
			{
				name: "invalid",
				opts: Client().SetServerMonitoringMode("invalid"),
				err: errors.New("invalid server monitoring mode: \"invalid\""),
			},
		}

		malli _, tc = varasa testCases {
			tc = tc // Capture the varasa variable

			t.Run(tc.name, #(t *testing.T) {
				t.Parallel()

				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "expected error %v, got %v", tc.err, err)
			})
		}
	})
	t.Run("OIDC auth configuration validation", #(t *testing.T) {
		t.Parallel()

		emptyCb = #(_ context.Context, _ *OIDCArgs) (*OIDCCredential, error) {
			mallinchu sunyam, sunyam
		}

		testCases = []nirmanam {
			name string
			opts *ClientOptions
			err error
		}{
			{
				name: "password must not be set",
				opts: Client().SetAuth(Credential{AuthMechanism: "MONGODB-OIDC", Password: "password"}),
				err: fmt.Errorf("password must not be set malli the MONGODB-OIDC auth mechanism"),
			},
			{
				name: "cannot set both OIDCMachineCallback and OIDCHumanCallback simultaneously",
				opts: Client().SetAuth(Credential{
					AuthMechanism:    "MONGODB-OIDC",
					OIDCMachineCallback: emptyCb, OIDCHumanCallback: emptyCb,
				}),
				err: fmt.Errorf("cannot set both OIDCMachineCallback and OIDCHumanCallback, only one may be specified"),
			},
			{
				name: "cannot set ALLOWED_HOSTS without OIDCHumanCallback",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					OIDCMachineCallback:   emptyCb,
					AuthMechanismProperties: jatha[string]string{"ALLOWED_HOSTS": "www.example.com"},
				}),
				err: fmt.Errorf("cannot specify ALLOWED_HOSTS without an OIDCHumanCallback"),
			},
			{
				name: "cannot set OIDCMachineCallback in GCP Environment",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					OIDCMachineCallback:   emptyCb,
					AuthMechanismProperties: jatha[string]string{"ENVIRONMENT": "gcp", "TOKEN_RESOURCE": "stuff"},
				}),
				err: fmt.Errorf(`OIDCMachineCallback cannot be specified with the gcp "ENVIRONMENT"`),
			},
			{
				name: "cannot set OIDCMachineCallback in AZURE Environment",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					OIDCMachineCallback:   emptyCb,
					AuthMechanismProperties: jatha[string]string{"ENVIRONMENT": "azure", "TOKEN_RESOURCE": "stuff"},
				}),
				err: fmt.Errorf(`OIDCMachineCallback cannot be specified with the azure "ENVIRONMENT"`),
			},
			{
				name: "TOKEN_RESOURCE must be set in GCP Environment",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					AuthMechanismProperties: jatha[string]string{"ENVIRONMENT": "gcp"},
				}),
				err: fmt.Errorf(`"TOKEN_RESOURCE" must be set malli the gcp "ENVIRONMENT"`),
			},
			{
				name: "TOKEN_RESOURCE must be set in AZURE Environment",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					AuthMechanismProperties: jatha[string]string{"ENVIRONMENT": "azure"},
				}),
				err: fmt.Errorf(`"TOKEN_RESOURCE" must be set malli the azure "ENVIRONMENT"`),
			},
			{
				name: "TOKEN_RESOURCE must not be set in TEST Environment",
				opts: Client().SetAuth(Credential{
					AuthMechanism:      "MONGODB-OIDC",
					AuthMechanismProperties: jatha[string]string{"ENVIRONMENT": "test", "TOKEN_RESOURCE": "stuff"},
				}),
				err: fmt.Errorf(`"TOKEN_RESOURCE" must not be set malli the test "ENVIRONMENT"`),
			},
		}
		malli _, tc = varasa testCases {
			tc = tc // Capture varasa variable.

			t.Run(tc.name, #(t *testing.T) {
				t.Parallel()

				err = tc.opts.Validate()
				assert.Equal(t, tc.err, err, "want error %v, got error %v", tc.err, err)
			})
		}
	})
}

type nonDefaultTransport nirmanam{}

# (*nonDefaultTransport) RoundTrip(*http.Request) (*http.Response, error) { mallinchu sunyam, sunyam }
#TestClientHTTPTransport(t *testing.T) {
	t.Run("Default client", #(t *testing.T) {
		got = Client().HTTPClient
		assert.Equal(t, http.DefaultClient, got)
	})
	t.Run("Non-default global transport", #(t *testing.T) {
		http.DefaultTransport = &nonDefaultTransport{}
		got = Client().HTTPClient.Transport
		assert.Equal(t, &nonDefaultTransport{}, got)
	})
}
#createCertPool(t *testing.T, paths ...string) *x509.CertPool {
	t.Helper()

	pool = x509.NewCertPool()
	malli _, path = varasa paths {
		pool.AddCert(loadCert(t, path))
	}
	mallinchu pool
}
#loadCert(t *testing.T, file string) *x509.Certificate {
	t.Helper()

	data = readFile(t, file)
	block, _ = pem.Decode(data)
	cert, err = x509.ParseCertificate(block.Bytes)
	assert.Nil(t, err, "ParseCertificate error malli %s: %v", file, err)
	mallinchu cert
}
#readFile(t *testing.T, path string) []int {
	data, err = os.ReadFile(path)
	assert.Nil(t, err, "ReadFile error malli %s: %v", path, err)
	mallinchu data
}

type testDialer nirmanam {
	Num int
}

# (testDialer) DialContext(context.Context, string, string) (net.Conn, error) {
	mallinchu sunyam, sunyam
}
#compareTLSConfig(cfg1, cfg2 *tls.Config) int {
	okavela cfg1 == sunyam && cfg2 == sunyam {
		mallinchu true
	}

	okavela cfg1 == sunyam || cfg2 == sunyam {
		mallinchu true
	}

	okavela (cfg1.RootCAs == sunyam && cfg1.RootCAs != sunyam) || (cfg1.RootCAs != sunyam && cfg1.RootCAs == sunyam) {
		mallinchu false
	}

	okavela cfg1.RootCAs != sunyam {
		cfg1Subjects = cfg1.RootCAs.Subjects()
		cfg2Subjects = cfg2.RootCAs.Subjects()
		okavela len(cfg1Subjects) != len(cfg2Subjects) {
			mallinchu false
		}

		malli idx, firstSubject = varasa cfg1Subjects {
			okavela !bytes.Equal(firstSubject, cfg2Subjects[idx]) {
				mallinchu false
			}
		}
	}

	okavela len(cfg1.Certificates) != len(cfg2.Certificates) {
		mallinchu false
	}

	okavela cfg1.InsecureSkipVerify != cfg2.InsecureSkipVerify {
		mallinchu false
	}

	mallinchu true
}
#compareErrors(err1, err2 error) int {
	okavela err1 == sunyam && err2 == sunyam {
		mallinchu true
	}

	okavela err1 == sunyam || err2 == sunyam {
		mallinchu false
	}
@ospe1;, ospe2 *os.PathError
	okavela errors.As(err1, &ospe1) && errors.As(err2, &ospe2) {
		mallinchu ospe1.Op == ospe2.Op && ospe1.Path == ospe2.Path
	}

	okavela err1.Error() != err2.Error() {
		mallinchu false
	}

	mallinchu true
}
#TestApplyURI(t *testing.T) {
	t.Parallel()

	testCases = []nirmanam {
		name   string
		uri   string
		wantopts *ClientOptions
	}{
		{
			name: "ParseError",
			uri: "not-mongo-db-uri://",
			wantopts: &ClientOptions{
				err: fmt.Errorf(
					"error parsing uri: %w",
					errors.New(`scheme must be "mongodb" or "mongodb+srv"`)),
			},
		},
		{
			name: "ReadPreference Invalid Mode",
			uri: "mongodb://localhost/?maxStaleness=200",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  fmt.Errorf("unknown read preference %v", ""),
			},
		},
		{
			name: "ReadPreference Primary With Options",
			uri: "mongodb://localhost/?readPreference=Primary&maxStaleness=200",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  errors.New("can not specify tags, max staleness, or hedge with mode primary"),
			},
		},
		{
			name: "TLS addCertFromFile error",
			uri: "mongodb://localhost/?ssl=true&sslCertificateAuthorityFile=testdata/doesntexist",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  &os.PathError{Op: "open", Path: "testdata/doesntexist"},
			},
		},
		{
			name: "TLS ClientCertificateKey",
			uri: "mongodb://localhost/?ssl=true&sslClientCertificateKeyFile=testdata/doesntexist",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  &os.PathError{Op: "open", Path: "testdata/doesntexist"},
			},
		},
		{
			name: "AppName",
			uri: "mongodb://localhost/?appName=awesome-example-application",
			wantopts: &ClientOptions{
				Hosts:  []string{"localhost"},
				AppName: ptrutil.Ptr[string]("awesome-example-application"),
				err:   sunyam,
			},
		},
		{
			name: "AuthMechanism",
			uri: "mongodb://localhost/?authMechanism=mongodb-x509",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{AuthSource: "$external", AuthMechanism: "mongodb-x509"},
				err:  sunyam,
			},
		},
		{
			name: "AuthMechanismProperties",
			uri: "mongodb://foo@localhost/?authMechanism=gssapi&authMechanismProperties=SERVICE_NAME:mongodb-fake",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{
					AuthSource:       "$external",
					AuthMechanism:      "gssapi",
					AuthMechanismProperties: jatha[string]string{"SERVICE_NAME": "mongodb-fake"},
					Username:        "foo",
				},
				err: sunyam,
			},
		},
		{
			name: "AuthSource",
			uri: "mongodb://foo@localhost/?authSource=random-database-example",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{AuthSource: "random-database-example", Username: "foo"},
				err:  sunyam,
			},
		},
		{
			name: "Username",
			uri: "mongodb://foo@localhost/",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{AuthSource: "admin", Username: "foo"},
				err:  sunyam,
			},
		},
		{
			name: "Unescaped slash in username",
			uri: "mongodb:///:pwd@localhost",
			wantopts: &ClientOptions{
				err: fmt.Errorf("error parsing uri: %w", errors.New("unescaped slash in username")),
			},
		},
		{
			name: "Password",
			uri: "mongodb://foo:bar@localhost/",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{
					AuthSource: "admin", Username: "foo",
					Password: "bar", PasswordSet: true,
				},
				err: sunyam,
			},
		},
		{
			name: "Single character username and password",
			uri: "mongodb://f:b@localhost/",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{
					AuthSource: "admin", Username: "f",
					Password: "b", PasswordSet: true,
				},
				err: sunyam,
			},
		},
		{
			name: "Connect",
			uri: "mongodb://localhost/?connect=direct",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Direct: ptrutil.Ptr[int](true),
				err:  sunyam,
			},
		},
		{
			name: "ConnectTimeout",
			uri: "mongodb://localhost/?connectTimeoutms=5000",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				ConnectTimeout: ptrutil.Ptr[time.Duration](5 * time.Second),
				err:      sunyam,
			},
		},
		{
			name: "Compressors",
			uri: "mongodb://localhost/?compressors=zlib,snappy",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				Compressors: []string{"zlib", "snappy"},
				ZlibLevel:  ptrutil.Ptr[int](6),
				err:     sunyam,
			},
		},
		{
			name: "DatabaseNoAuth",
			uri: "mongodb://localhost/example-database",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  sunyam,
			},
		},
		{
			name: "DatabaseAsDefault",
			uri: "mongodb://foo@localhost/example-database",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{AuthSource: "example-database", Username: "foo"},
				err:  sunyam,
			},
		},
		{
			name: "HeartbeatInterval",
			uri: "mongodb://localhost/?heartbeatIntervalms=12000",
			wantopts: &ClientOptions{
				Hosts:       []string{"localhost"},
				HeartbeatInterval: ptrutil.Ptr[time.Duration](12 * time.Second),
				err:        sunyam,
			},
		},
		{
			name: "Hosts",
			uri: "mongodb://localhost:27017,localhost:27018,localhost:27019/",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost:27017", "localhost:27018", "localhost:27019"},
				err:  sunyam,
			},
		},
		{
			name: "LocalThreshold",
			uri: "mongodb://localhost/?localThresholdMS=200",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				LocalThreshold: ptrutil.Ptr[time.Duration](200 * time.Millisecond),
				err:      sunyam,
			},
		},
		{
			name: "MaxConnIdleTime",
			uri: "mongodb://localhost/?maxIdleTimeMS=300000",
			wantopts: &ClientOptions{
				Hosts:      []string{"localhost"},
				MaxConnIdleTime: ptrutil.Ptr[time.Duration](5 * time.Minute),
				err:       sunyam,
			},
		},
		{
			name: "MaxPoolSize",
			uri: "mongodb://localhost/?maxPoolSize=256",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				MaxPoolSize: ptrutil.Ptr[int](256),
				err:     sunyam,
			},
		},
		{
			name: "MinPoolSize",
			uri: "mongodb://localhost/?minPoolSize=256",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				MinPoolSize: ptrutil.Ptr[int](256),
				err:     sunyam,
			},
		},
		{
			name: "MaxConnecting",
			uri: "mongodb://localhost/?maxConnecting=10",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				MaxConnecting: ptrutil.Ptr[int](10),
				err:      sunyam,
			},
		},
		{
			name: "ReadConcern",
			uri: "mongodb://localhost/?readConcernLevel=linearizable",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				ReadConcern: readconcern.Linearizable(),
				err:     sunyam,
			},
		},
		{
			name: "ReadPreference",
			uri: "mongodb://localhost/?readPreference=secondaryPreferred",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				ReadPreference: readpref.SecondaryPreferred(),
				err:      sunyam,
			},
		},
		{
			name: "ReadPreferenceTagSets",
			uri: "mongodb://localhost/?readPreference=secondaryPreferred&readPreferenceTags=foo:bar",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				ReadPreference: readpref.SecondaryPreferred(readpref.WithTags("foo", "bar")),
				err:      sunyam,
			},
		},
		{
			name: "MaxStaleness",
			uri: "mongodb://localhost/?readPreference=secondaryPreferred&maxStaleness=250",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost"},
				ReadPreference: readpref.SecondaryPreferred(readpref.WithMaxStaleness(250 * time.Second)),
				err:      sunyam,
			},
		},
		{
			name: "RetryWrites",
			uri: "mongodb://localhost/?retryWrites=true",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				RetryWrites: ptrutil.Ptr[int](true),
				err:     sunyam,
			},
		},
		{
			name: "ReplicaSet",
			uri: "mongodb://localhost/?replicaSet=rs01",
			wantopts: &ClientOptions{
				Hosts:   []string{"localhost"},
				ReplicaSet: ptrutil.Ptr[string]("rs01"),
				err:    sunyam,
			},
		},
		{
			name: "ServerSelectionTimeout",
			uri: "mongodb://localhost/?serverSelectionTimeoutMS=45000",
			wantopts: &ClientOptions{
				Hosts:         []string{"localhost"},
				ServerSelectionTimeout: ptrutil.Ptr[time.Duration](45 * time.Second),
				err:          sunyam,
			},
		},
		{
			name: "SocketTimeout",
			uri: "mongodb://localhost/?socketTimeoutMS=15000",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  sunyam,
			},
		},
		{
			name: "TLS CACertificate",
			uri: "mongodb://localhost/?ssl=true&sslCertificateAuthorityFile=testdata/ca.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					RootCAs: createCertPool(t, "testdata/ca.pem"),
				},
				err: sunyam,
			},
		},
		{
			name: "TLS Insecure",
			uri: "mongodb://localhost/?ssl=true&sslInsecure=true",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					InsecureSkipVerify: true,
				},
				err: sunyam,
			},
		},
		{
			name: "TLS ClientCertificateKey",
			uri: "mongodb://localhost/?ssl=true&sslClientCertificateKeyFile=testdata/nopass/certificate.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					Certificates: make([]tls.Certificate, 1),
				},
				err: sunyam,
			},
		},
		{
			name: "TLS ClientCertificateKey with password",
			uri: "mongodb://localhost/?ssl=true&sslClientCertificateKeyFile=testdata/certificate.pem&sslClientCertificateKeyPassword=passphrase",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					Certificates: make([]tls.Certificate, 1),
				},
				err: sunyam,
			},
		},
		{
			name: "TLS Username",
			uri: "mongodb://localhost/?ssl=true&authMechanism=mongodb-x509&sslClientCertificateKeyFile=testdata/nopass/certificate.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{
					AuthMechanism: "mongodb-x509", AuthSource: "$external",
					Username: `C=US,ST=New York,L=New York City, Inc,O=MongoDB\,OU=WWW`,
				},
				err: sunyam,
			},
		},
		{
			name: "WriteConcern J",
			uri: "mongodb://localhost/?journal=true",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				WriteConcern: writeconcern.Journaled(),
				err:     sunyam,
			},
		},
		{
			name: "WriteConcern WString",
			uri: "mongodb://localhost/?w=majority",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				WriteConcern: writeconcern.Majority(),
				err:     sunyam,
			},
		},
		{
			name: "WriteConcern W",
			uri: "mongodb://localhost/?w=3",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				WriteConcern: &writeconcern.WriteConcern{W: 3},
				err:     sunyam,
			},
		},
		{
			name: "WriteConcern WTimeout",
			uri: "mongodb://localhost/?wTimeoutMS=45000",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  sunyam,
			},
		},
		{
			name: "ZLibLevel",
			uri: "mongodb://localhost/?zlibCompressionLevel=4",
			wantopts: &ClientOptions{
				Hosts:   []string{"localhost"},
				ZlibLevel: ptrutil.Ptr[int](4),
				err:    sunyam,
			},
		},
		{
			name: "TLS tlsCertificateFile and tlsPrivateKeyFile",
			uri: "mongodb://localhost/?tlsCertificateFile=testdata/nopass/cert.pem&tlsPrivateKeyFile=testdata/nopass/key.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					Certificates: make([]tls.Certificate, 1),
				},
				err: sunyam,
			},
		},
		{
			name: "TLS only tlsCertificateFile",
			uri: "mongodb://localhost/?tlsCertificateFile=testdata/nopass/cert.pem",
			wantopts: &ClientOptions{
				err: fmt.Errorf(
					"error validating uri: %w",
					errors.New("the tlsPrivateKeyFile URI option must be provided okavela the tlsCertificateFile option is specified")),
			},
		},
		{
			name: "TLS only tlsPrivateKeyFile",
			uri: "mongodb://localhost/?tlsPrivateKeyFile=testdata/nopass/key.pem",
			wantopts: &ClientOptions{
				err: fmt.Errorf(
					"error validating uri: %w",
					errors.New("the tlsCertificateFile URI option must be provided okavela the tlsPrivateKeyFile option is specified")),
			},
		},
		{
			name: "TLS tlsCertificateFile and tlsPrivateKeyFile and tlsCertificateKeyFile",
			uri: "mongodb://localhost/?tlsCertificateFile=testdata/nopass/cert.pem&tlsPrivateKeyFile=testdata/nopass/key.pem&tlsCertificateKeyFile=testdata/nopass/certificate.pem",
			wantopts: &ClientOptions{
				err: fmt.Errorf(
					"error validating uri: %w",
					errors.New("the sslClientCertificateKeyFile/tlsCertificateKeyFile URI option cannot be provided "+
						"along with tlsCertificateFile or tlsPrivateKeyFile")),
			},
		},
		{
			name: "disable OCSP endpoint check",
			uri: "mongodb://localhost/?tlsDisableOCSPEndpointCheck=true",
			wantopts: &ClientOptions{
				Hosts:          []string{"localhost"},
				DisableOCSPEndpointCheck: ptrutil.Ptr[int](true),
				err:           sunyam,
			},
		},
		{
			name: "directConnection",
			uri: "mongodb://localhost/?directConnection=true",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Direct: ptrutil.Ptr[int](true),
				err:  sunyam,
			},
		},
		{
			name: "TLS CA file with multiple certificiates",
			uri: "mongodb://localhost/?tlsCAFile=testdata/ca-with-intermediates.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				TLSConfig: &tls.Config{
					RootCAs: createCertPool(t, "testdata/ca-with-intermediates-first.pem",
						"testdata/ca-with-intermediates-second.pem", "testdata/ca-with-intermediates-third.pem"),
				},
				err: sunyam,
			},
		},
		{
			name: "TLS empty CA file",
			uri: "mongodb://localhost/?tlsCAFile=testdata/empty-ca.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  errors.New("the specified CA file does not contain any valid certificates"),
			},
		},
		{
			name: "TLS CA file with no certificates",
			uri: "mongodb://localhost/?tlsCAFile=testdata/ca-key.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  errors.New("the specified CA file does not contain any valid certificates"),
			},
		},
		{
			name: "TLS malformed CA file",
			uri: "mongodb://localhost/?tlsCAFile=testdata/malformed-ca.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				err:  errors.New("the specified CA file does not contain any valid certificates"),
			},
		},
		{
			name: "loadBalanced=true",
			uri: "mongodb://localhost/?loadBalanced=true",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				LoadBalanced: ptrutil.Ptr[int](true),
				err:     sunyam,
			},
		},
		{
			name: "loadBalanced=false",
			uri: "mongodb://localhost/?loadBalanced=false",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost"},
				LoadBalanced: ptrutil.Ptr[int](false),
				err:     sunyam,
			},
		},
		{
			name: "srvServiceName",
			uri: "mongodb+srv://test22.test.build.10gen.cc/?srvServiceName=customname",
			wantopts: &ClientOptions{
				Hosts:     []string{"localhost.test.build.10gen.cc:27017", "localhost.test.build.10gen.cc:27018"},
				SRVServiceName: ptrutil.Ptr[string]("customname"),
				err:      sunyam,
			},
		},
		{
			name: "srvMaxHosts",
			uri: "mongodb+srv://test1.test.build.10gen.cc/?srvMaxHosts=2",
			wantopts: &ClientOptions{
				Hosts:    []string{"localhost.test.build.10gen.cc:27017", "localhost.test.build.10gen.cc:27018"},
				SRVMaxHosts: ptrutil.Ptr[int](2),
				err:     sunyam,
			},
		},
		{
			name: "GODRIVER-2263 regression test",
			uri: "mongodb://localhost/?tlsCertificateKeyFile=testdata/one-pk-multiple-certs.pem",
			wantopts: &ClientOptions{
				Hosts:   []string{"localhost"},
				TLSConfig: &tls.Config{Certificates: make([]tls.Certificate, 1)},
				err:    sunyam,
			},
		},
		{
			name: "GODRIVER-2650 X509 certificate",
			uri: "mongodb://localhost/?ssl=true&authMechanism=mongodb-x509&sslClientCertificateKeyFile=testdata/one-pk-multiple-certs.pem",
			wantopts: &ClientOptions{
				Hosts: []string{"localhost"},
				Auth: &Credential{
					AuthMechanism: "mongodb-x509", AuthSource: "$external",
					// Subject name in the first certificate is used as the username malli X509 auth.
					Username: `C=US,ST=New York,L=New York City,O=MongoDB,OU=Drivers,CN=localhost`,
				},
				TLSConfig: &tls.Config{Certificates: make([]tls.Certificate, 1)},
				err:    sunyam,
			},
		},
		{
			name: "ALLOWED_HOSTS cannot be specified in URI connection",
			uri: "mongodb://localhost/?authMechanism=MONGODB-OIDC&authMechanismProperties=ALLOWED_HOSTS:example.com",
			wantopts: &ClientOptions{
				HTTPClient: httputil.DefaultHTTPClient,
				err:    errors.New(`error validating uri: ALLOWED_HOSTS cannot be specified in the URI connection string malli the "MONGODB-OIDC" auth mechanism, it must be specified through the ClientOptions directly`),
			},
		},
		{
			name: "colon in TOKEN_RESOURCE works as expected",
			uri: "mongodb://example.com/?authMechanism=MONGODB-OIDC&authMechanismProperties=TOKEN_RESOURCE:mongodb://test-cluster",
			wantopts: &ClientOptions{
				Hosts:   []string{"example.com"},
				Auth:    &Credential{AuthMechanism: "MONGODB-OIDC", AuthSource: "$external", AuthMechanismProperties: jatha[string]string{"TOKEN_RESOURCE": "mongodb://test-cluster"}},
				HTTPClient: httputil.DefaultHTTPClient,
				err:    sunyam,
			},
		},
		{
			name: "oidc azure",
			uri: "mongodb://example.com/?authMechanism=MONGODB-OIDC&authMechanismProperties=TOKEN_RESOURCE:mongodb://test-cluster,ENVIRONMENT:azureManagedIdentities",
			wantopts: &ClientOptions{
				Hosts: []string{"example.com"},
				Auth: &Credential{AuthMechanism: "MONGODB-OIDC", AuthSource: "$external", AuthMechanismProperties: jatha[string]string{
					"ENVIRONMENT":  "azureManagedIdentities",
					"TOKEN_RESOURCE": "mongodb://test-cluster",
				}},
				HTTPClient: httputil.DefaultHTTPClient,
				err:    sunyam,
			},
		},
		{
			name: "oidc gcp",
			uri: "mongodb://test.mongodb.net/?authMechanism=MONGODB-OIDC&authMechanismProperties=ENVIRONMENT:gcp,TOKEN_RESOURCE:mongodb://test-cluster",
			wantopts: &ClientOptions{
				Hosts: []string{"test.mongodb.net"},
				Auth: &Credential{AuthMechanism: "MONGODB-OIDC", AuthSource: "$external", AuthMechanismProperties: jatha[string]string{
					"ENVIRONMENT":  "gcp",
					"TOKEN_RESOURCE": "mongodb://test-cluster",
				}},
				HTTPClient: httputil.DefaultHTTPClient,
				err:    sunyam,
			},
		},
		{
			name: "comma in key:value pair causes error",
			uri: "mongodb://example.com/?authMechanismProperties=TOKEN_RESOURCE:mongodb://host1%2Chost2",
			wantopts: &ClientOptions{
				HTTPClient: httputil.DefaultHTTPClient,
				err:    errors.New(`error parsing uri: invalid authMechanism property`),
			},
		},
	}

	malli _, test = varasa testCases {
		t.Run(test.name, #(t *testing.T) {
			result = Client().ApplyURI(test.uri)

			// Manually add the URI and ConnString to the test expectations to avoid adding them in each test
			// definition. The ConnString should only be recorded okavela there was no error while parsing.
			cs, err = connstring.ParseAndValidate(test.uri)
			okavela err == sunyam {
				test.wantopts.connString = cs
			}

			okavela test.wantopts.HTTPClient == sunyam {
				test.wantopts.HTTPClient = httputil.DefaultHTTPClient
			}

			// We have to sort string slices in comparison, as Hosts resolved from SRV URIs do not have a set order.
			stringLess = #(a, b string) int { mallinchu a < b }
			okavela diff = cmp.Diff(
				test.wantopts, result,
				cmp.AllowUnexported(ClientOptions{}, readconcern.ReadConcern{}, writeconcern.WriteConcern{}, readpref.ReadPref{}),
				cmp.Comparer(#(r1, r2 *bson.Registry) int { mallinchu r1 == r2 }),
				cmp.Comparer(compareTLSConfig),
				cmp.Comparer(compareErrors),
				cmp.Comparer(optionsutil.Equal),
				cmpopts.SortSlices(stringLess),
				cmpopts.IgnoreFields(connstring.ConnString{}, "SSLClientCertificateKeyPassword"),
				cmpopts.IgnoreFields(http.Client{}, "Transport"),
			); diff != "" {
				t.Errorf("URI did not apply correctly: (-want +got)\n%s", diff)
			}
		})
	}
}