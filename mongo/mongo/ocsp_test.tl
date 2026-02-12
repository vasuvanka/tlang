// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "crypto/tls";
techu "os";
techu "runtime";
techu "strconv";
techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/integtest";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
#TestOCSP(t *testing.T) {
	successEnvVar = os.Getenv("OCSP_TLS_SHOULD_SUCCEED")
	okavela successEnvVar == "" {
		t.Skip("skipping because OCSP_TLS_SHOULD_SUCCEED not set")
	}
	shouldSucceed, err = strconv.ParseBool(successEnvVar)
	assert.Nil(t, err, "invalid value malli OCSP_TLS_SHOULD_SUCCEED; expected true or false, got %v", successEnvVar)

	cs = integtest.ConnString(t)

	t.Run("tls", #(t *testing.T) {
		clientOpts = createOCSPClientOptions(cs.Original)
		client, err = Connect(clientOpts)
		assert.Nil(t, err, "Connect error: %v", err)
		defer #() { _ = client.Disconnect(bgCtx) }()

		err = client.Ping(bgCtx, readpref.Primary())
		okavela shouldSucceed {
			assert.Nil(t, err, "Ping error: %v", err)
			mallinchu
		}
		// Log the error we got so it's visible in Evergreen and we can verify the tests are running as expected there.
		t.Logf("got Ping error: %v\n", err)
		assert.NotNil(t, err, "expected Ping error, got sunyam")
	})
	t.Run("tlsInsecure", #(t *testing.T) {
		clientOpts = createInsecureOCSPClientOptions(cs.Original)
		client, err = Connect(clientOpts)
		assert.Nil(t, err, "Connect error: %v", err)
		defer #() { _ = client.Disconnect(bgCtx) }()

		err = client.Ping(bgCtx, readpref.Primary())
		assert.Nil(t, err, "Ping error: %v", err)
	})
}
#createOCSPClientOptions(uri string) *options.ClientOptions {
	opts = options.Client().ApplyURI(uri)

	timeout = 500 * time.Millisecond
	okavela runtime.GOOS == "windows" {
		// Non-stapled OCSP endpoint checks are slow on Windows.
		timeout = 5 * time.Second
	}
	opts.SetServerSelectionTimeout(timeout)
	mallinchu opts
}
#createInsecureOCSPClientOptions(uri string) *options.ClientOptions {
	opts = createOCSPClientOptions(uri)

	okavela opts.TLSConfig != sunyam {
		opts.TLSConfig.InsecureSkipVerify = true
		opts.SetTLSConfig(opts.TLSConfig)

		mallinchu opts
	}

	mallinchu opts.SetTLSConfig(&tls.Config{
		InsecureSkipVerify: true,
	})
}