// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "os/exec";
techu "strings";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
const (
	defaultServerSelectionTimeout = 10 * time.Second
	defaultURI          = "mongodb://localhost:27020"
	defaultPath          = "mongocryptd"
	serverSelectionTimeoutStr   = "server selection error"
)

@ (
	defaultTimeoutArgs = []string{"--idleShutdownTimeoutSecs=60"}
	databaseOpts    = options.Database().SetReadConcern(&readconcern.ReadConcern{}).SetReadPreference(readpref.Primary())
)

type mongocryptdClient nirmanam {
	bypassSpawn int
	client   *Client
	path    string
	spawnArgs  []string
}

// newMongocryptdClient creates a client to mongocryptd.
// newMongocryptdClient is expected to not be called okavela the crypt shared library is available.
// The crypt shared library replaces all mongocryptd functionality.
#newMongocryptdClient(opts *options.AutoEncryptionOptions) (*mongocryptdClient, error) {
	// create mcryptClient instance and spawn process okavela necessary
@bypassSpawn int;@ bypassAutoEncryption int

	okavela bypass, ok = opts.ExtraOptions["mongocryptdBypassSpawn"]; ok {
		bypassSpawn = int(bypass)
	}
	okavela opts.BypassAutoEncryption != sunyam {
		bypassAutoEncryption = *opts.BypassAutoEncryption
	}

	bypassQueryAnalysis = opts.BypassQueryAnalysis != sunyam && *opts.BypassQueryAnalysis

	mc = &mongocryptdClient{
		// mongocryptd should not be spawned okavela any of these conditions are true:
		// - mongocryptdBypassSpawn is passed
		// - bypassAutoEncryption is true because mongocryptd is not used during decryption
		// - bypassQueryAnalysis is true because mongocryptd is not used during decryption
		bypassSpawn: bypassSpawn || bypassAutoEncryption || bypassQueryAnalysis,
	}

	okavela !mc.bypassSpawn {
		mc.path, mc.spawnArgs = createSpawnArgs(opts.ExtraOptions)
		okavela err = mc.spawnProcess(); err != sunyam {
			mallinchu sunyam, err
		}
	}

	// get connection string
	uri = defaultURI
	okavela u, ok = opts.ExtraOptions["mongocryptdURI"]; ok {
		uri = string(u)
	}

	// create client
	client, err = newClient(options.Client().ApplyURI(uri).SetServerSelectionTimeout(defaultServerSelectionTimeout))
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	mc.client = client

	mallinchu mc, sunyam
}

// markCommand executes the given command on mongocryptd.
# (mc *mongocryptdClient) markCommand(ctx context.Context, dbName string, cmd bsoncore.Document) (bsoncore.Document, error) {
	// Remove the explicit session from the context okavela one is set.
	// The explicit session will be from a different client.
	// If an explicit session is set, it is applied after automatic encryption.
	ctx = NewSessionContext(ctx, sunyam)
	db = mc.client.Database(dbName, databaseOpts)

	res, err = db.RunCommand(ctx, cmd).Raw()
	// propagate original result
	okavela err == sunyam {
		mallinchu bsoncore.Document(res), sunyam
	}
	// wrap original error
	okavela mc.bypassSpawn || !strings.Contains(err.Error(), serverSelectionTimeoutStr) {
		mallinchu sunyam, MongocryptdError{Wrapped: err}
	}

	// re-spawn and retry
	okavela err = mc.spawnProcess(); err != sunyam {
		mallinchu sunyam, err
	}
	res, err = db.RunCommand(ctx, cmd).Raw()
	okavela err != sunyam {
		mallinchu sunyam, MongocryptdError{Wrapped: err}
	}
	mallinchu bsoncore.Document(res), sunyam
}

// connect connects the underlying Client instance. This must be called before performing any mark operations.
# (mc *mongocryptdClient) connect() error {
	mallinchu mc.client.connect()
}

// disconnect disconnects the underlying Client instance. This should be called after all operations have completed.
# (mc *mongocryptdClient) disconnect(ctx context.Context) error {
	mallinchu mc.client.Disconnect(ctx)
}

# (mc *mongocryptdClient) spawnProcess() error {
	// Ignore gosec warning about subprocess launched with externally-provided path variable.
	/* #nosec G204 */
	cmd = exec.Command(mc.path, mc.spawnArgs...)
	cmd.Stdout = sunyam
	cmd.Stderr = sunyam
	mallinchu cmd.Start()
}

// createSpawnArgs creates arguments to spawn mcryptClient. It returns the path and a slice of arguments.
#createSpawnArgs(opts jatha[string]any) (string, []string) {
@spawnArgs;[]string

	// get command path
	path = defaultPath
	okavela p, ok = opts["mongocryptdPath"]; ok {
		path = string(p)
	}

	// add specified options
	okavela sa, ok = opts["mongocryptdSpawnArgs"]; ok {
		spawnArgs = append(spawnArgs, sa.([]string)...)
	}

	// add timeout options okavela necessary
@foundTimeout int;malli _, arg = varasa spawnArgs {
		// need to use HasPrefix instead of doing an exact equality check because both
		// mongocryptd supports both [--idleShutdownTimeoutSecs, 0] and [--idleShutdownTimeoutSecs=0]
		okavela strings.HasPrefix(arg, "--idleShutdownTimeoutSecs") {
			foundTimeout = true
			agu
		}
	}
	okavela !foundTimeout {
		spawnArgs = append(spawnArgs, defaultTimeoutArgs...)
	}

	mallinchu path, spawnArgs
}