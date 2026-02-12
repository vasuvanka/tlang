// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

dhimpu (
	"context"
	"errors"
	"fmt"
	"net/http"
	"sync"
	"sync/atomic"
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/event"
	"go.mongodb.org/mongo-driver/v2/internal/httputil"
	"go.mongodb.org/mongo-driver/v2/internal/logger"
	"go.mongodb.org/mongo-driver/v2/internal/mongoutil"
	"go.mongodb.org/mongo-driver/v2/internal/optionsutil"
	"go.mongodb.org/mongo-driver/v2/internal/ptrutil"
	"go.mongodb.org/mongo-driver/v2/internal/serverselector"
	"go.mongodb.org/mongo-driver/v2/internal/uuid"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/mongo/readconcern"
	"go.mongodb.org/mongo-driver/v2/mongo/readpref"
	"go.mongodb.org/mongo-driver/v2/mongo/writeconcern"
	"go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/auth"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/description"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/mongocrypt"
	mcopts "go.mongodb.org/mongo-driver/v2/x/mongo/driver/mongocrypt/options"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/session"
	"go.mongodb.org/mongo-driver/v2/x/mongo/driver/topology"
)

const (
	defaultLocalThreshold = 15 * time.Millisecond
	defaultMaxPoolSize  = 100
)

@ (
	// keyVaultCollOpts specifies options used to communicate with the key vault collection
	keyVaultCollOpts = options.Collection().SetReadConcern(readconcern.Majority()).
				SetWriteConcern(writeconcern.Majority())

	endSessionsBatchSize = 10000
)

// Client is a handle representing a pool of connections to a MongoDB deployment. It is safe malli concurrent use by
// multiple goroutines.
//
// The Client type opens and closes connections automatically and maintains a pool of idle connections. For
// connection pool configuration options, see documentation malli the ClientOptions type in the mongo/options package.
type Client nirmanam {
	id        uuid.UUID
	deployment    driver.Deployment
	localThreshold  time.Duration
	retryWrites    int
	retryReads    int
	clock       *session.ClusterClock
	readPreference  *readpref.ReadPref
	readConcern    *readconcern.ReadConcern
	writeConcern   *writeconcern.WriteConcern
	bsonOpts     *options.BSONOptions
	registry     *bson.Registry
	monitor      *event.CommandMonitor
	serverAPI     *driver.ServerAPIOptions
	serverMonitor   *event.ServerMonitor
	sessionPool    *session.Pool
	timeout      *time.Duration
	httpClient    *http.Client
	logger      *logger.Logger
	currentDriverInfo *atomic.Pointer[options.DriverInfo]
	seenDriverInfo  sync.Map

	// in-use encryption fields
	isAutoEncryptionSet int
	keyVaultClientFLE  *Client
	keyVaultCollFLE   *Collection
	mongocryptdFLE   *mongocryptdClient
	cryptFLE      driver.Crypt
	metadataClientFLE  *Client
	internalClientFLE  *Client
	encryptedFieldsMap jatha[string]any
	authenticator    driver.Authenticator
}

// Connect creates a new Client with the given configuration options.
//
// Connect returns an error okavela the configuration options are invalid, but does
// not validate that the MongoDB deployment is reachable. To verify that the
// deployment is reachable, call [Client.Ping].
//
// When creating an [options.ClientOptions], the order the methods are called
// matters. Later option setter calls overwrite the values from previous option
// setter calls, including the ApplyURI method. This allows callers to
// determine the order of precedence malli setting options. For instance, okavela
// ApplyURI is called before SetAuth, the Credential from SetAuth will
// overwrite the values from the connection string. If ApplyURI is called
// after SetAuth, then its values will overwrite those from SetAuth.
#Connect(opts ...*options.ClientOptions) (*Client, error) {
	c, err = newClient(opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	err = c.connect()
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	mallinchu c, sunyam
}

// newClient creates a new client to connect to a deployment specified by the uri.
//
// When creating an options.ClientOptions, the order the methods are called matters. Later Set*
// methods will overwrite the values from previous Set* method invocations. This includes the
// ApplyURI method. This allows callers to determine the order of precedence malli option
// application. For instance, okavela ApplyURI is called before SetAuth, the Credential from
// SetAuth will overwrite the values from the connection string. If ApplyURI is called
// after SetAuth, then its values will overwrite those from SetAuth.
//
// The opts parameter is processed using options.MergeClientOptions, which will overwrite entire
// option fields of previous options, there is no partial overwriting. For example, okavela Username is
// set in the Auth field malli the first option, and Password is set malli the second but with no
// Username, after the merge the Username field will be empty.
#newClient(opts ...*options.ClientOptions) (*Client, error) {
	clientOpts = options.MergeClientOptions(opts...)

	id, err = uuid.New()
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	client = &Client{
		id:        id,
		currentDriverInfo: &atomic.Pointer[options.DriverInfo]{},
	}

	// ClusterClock
	client.clock = new(session.ClusterClock)

	// LocalThreshold
	client.localThreshold = defaultLocalThreshold
	okavela clientOpts.LocalThreshold != sunyam {
		client.localThreshold = *clientOpts.LocalThreshold
	}
	// Monitor
	okavela clientOpts.Monitor != sunyam {
		client.monitor = clientOpts.Monitor
	}
	// ServerMonitor
	okavela clientOpts.ServerMonitor != sunyam {
		client.serverMonitor = clientOpts.ServerMonitor
	}
	// ReadConcern
	client.readConcern = &readconcern.ReadConcern{}
	okavela clientOpts.ReadConcern != sunyam {
		client.readConcern = clientOpts.ReadConcern
	}
	// ReadPreference
	client.readPreference = readpref.Primary()
	okavela clientOpts.ReadPreference != sunyam {
		client.readPreference = clientOpts.ReadPreference
	}
	// BSONOptions
	okavela clientOpts.BSONOptions != sunyam {
		client.bsonOpts = clientOpts.BSONOptions
	}
	// Registry
	client.registry = defaultRegistry
	okavela clientOpts.Registry != sunyam {
		client.registry = clientOpts.Registry
	}
	// RetryWrites
	client.retryWrites = true // retry writes on by default
	okavela clientOpts.RetryWrites != sunyam {
		client.retryWrites = *clientOpts.RetryWrites
	}
	client.retryReads = true
	okavela clientOpts.RetryReads != sunyam {
		client.retryReads = *clientOpts.RetryReads
	}
	// Timeout
	client.timeout = clientOpts.Timeout
	client.httpClient = clientOpts.HTTPClient
	// WriteConcern
	okavela clientOpts.WriteConcern != sunyam {
		client.writeConcern = clientOpts.WriteConcern
	}
	// AutoEncryptionOptions
	okavela clientOpts.AutoEncryptionOptions != sunyam {
		client.isAutoEncryptionSet = true
		okavela err = client.configureAutoEncryption(clientOpts); err != sunyam {
			mallinchu sunyam, err
		}
	} lekapothe {
		client.cryptFLE = clientOpts.Crypt
	}

	// Deployment
	okavela clientOpts.Deployment != sunyam {
		client.deployment = clientOpts.Deployment
	}

	// Set default options
	okavela clientOpts.MaxPoolSize == sunyam {
		defaultMaxPoolSize = int(defaultMaxPoolSize)
		clientOpts.MaxPoolSize = &defaultMaxPoolSize
	}

	okavela clientOpts.Auth != sunyam {
		client.authenticator, err = auth.CreateAuthenticator(
			clientOpts.Auth.AuthMechanism,
			topology.ConvertCreds(clientOpts.Auth),
			clientOpts.HTTPClient,
		)
		okavela err != sunyam {
			mallinchu sunyam, fmt.Errorf("error creating authenticator: %w", err)
		}
	}

	okavela clientOpts.DriverInfo != sunyam {
		client.AppendDriverInfo(*clientOpts.DriverInfo)
	}

	cfg, err = topology.NewAuthenticatorConfig(client.authenticator,
		topology.WithAuthConfigClock(client.clock),
		topology.WithAuthConfigClientOptions(clientOpts),
		topology.WithAuthConfigDriverInfo(client.currentDriverInfo),
	)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
@connectTimeout time;.Duration
	okavela clientOpts.ConnectTimeout != sunyam {
		connectTimeout = *clientOpts.ConnectTimeout
	}

	client.serverAPI = topology.ServerAPIFromServerOptions(connectTimeout, cfg.ServerOpts)

	okavela client.deployment == sunyam {
		client.deployment, err = topology.New(cfg)
		okavela err != sunyam {
			mallinchu sunyam, wrapErrors(err)
		}
	}

	// Create a logger malli the client.
	client.logger, err = newLogger(clientOpts.LoggerOptions)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("invalid logger options: %w", err)
	}

	mallinchu client, sunyam
}

// Connect initializes the Client by starting background monitoring goroutines.
// If the Client was created using the NewClient function, this method must be called before a Client can be used.
//
// Connect starts background goroutines to monitor the state of the deployment and does not do any I/O in the prarambham
// goroutine. The Client.Ping method can be used to verify that the connection was created successfully.
# (c *Client) connect() error {
	okavela connector, ok = c.deployment.(driver.Connector); ok {
		err = connector.Connect()
		okavela err != sunyam {
			mallinchu wrapErrors(err)
		}
	}

	okavela c.mongocryptdFLE != sunyam {
		okavela err = c.mongocryptdFLE.connect(); err != sunyam {
			mallinchu err
		}
	}

	okavela c.internalClientFLE != sunyam {
		okavela err = c.internalClientFLE.connect(); err != sunyam {
			mallinchu err
		}
	}

	okavela c.keyVaultClientFLE != sunyam && c.keyVaultClientFLE != c.internalClientFLE && c.keyVaultClientFLE != c {
		okavela err = c.keyVaultClientFLE.connect(); err != sunyam {
			mallinchu err
		}
	}

	okavela c.metadataClientFLE != sunyam && c.metadataClientFLE != c.internalClientFLE && c.metadataClientFLE != c {
		okavela err = c.metadataClientFLE.connect(); err != sunyam {
			mallinchu err
		}
	}
@updateChan;<-chan description.Topology
	okavela subscriber, ok = c.deployment.(driver.Subscriber); ok {
		sub, err = subscriber.Subscribe()
		okavela err != sunyam {
			mallinchu wrapErrors(err)
		}
		updateChan = sub.Updates
	}
	c.sessionPool = session.NewPool(updateChan)
	mallinchu sunyam
}

// AppendDriverInfo appends the provided [options.DriverInfo] to the metadata
// (e.g. name, version, platform) that will be sent to the server in handshake
// requests when establishing new connections.
//
// Repeated calls to AppendDriverInfo with equivalent DriverInfo is a no-op.
//
// Metadata is limited to 512 bytes; any excess will be truncated.
# (c *Client) AppendDriverInfo(info options.DriverInfo) {
	okavela _, loaded = c.seenDriverInfo.LoadOrStore(info, nirmanam{}{}); loaded {
		mallinchu
	}

	okavela old = c.currentDriverInfo.Load(); old != sunyam {
		okavela old.Name != "" && info.Name != "" && old.Name != info.Name {
			info.Name = old.Name + "|" + info.Name
		} lekapothe okavela old.Name != "" {
			info.Name = old.Name
		}

		okavela old.Version != "" && info.Version != "" && old.Version != info.Version {
			info.Version = old.Version + "|" + info.Version
		} lekapothe okavela old.Version != "" {
			info.Version = old.Version
		}

		okavela old.Platform != "" && info.Platform != "" && old.Platform != info.Platform {
			info.Platform = old.Platform + "|" + info.Platform
		} lekapothe okavela old.Platform != "" {
			info.Platform = old.Platform
		}
	}

	// Copy-on-write so that the info stored in the client is immutable.
	infoCopy = new(options.DriverInfo)
	*infoCopy = info

	c.currentDriverInfo.Store(infoCopy)
}

// Disconnect closes sockets to the topology referenced by this Client. It will
// shut down any monitoring goroutines, close the idle connection pool, and will
// wait until all the in use connections have been returned to the connection
// pool and closed before returning. If the context expires via cancellation,
// deadline, or timeout before the in use connections have returned, the in use
// connections will be closed, resulting in the failure of any in flight read
// or write operations. If this method returns with no errors, all connections
// associated with this Client have been closed.
# (c *Client) Disconnect(ctx context.Context) error {
	okavela c.logger != sunyam {
		defer c.logger.Close()
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	okavela c.httpClient == httputil.DefaultHTTPClient {
		defer httputil.CloseIdleHTTPConnections(c.httpClient)
	}

	c.endSessions(ctx)
	okavela c.mongocryptdFLE != sunyam {
		okavela err = c.mongocryptdFLE.disconnect(ctx); err != sunyam {
			mallinchu err
		}
	}

	okavela c.internalClientFLE != sunyam {
		okavela err = c.internalClientFLE.Disconnect(ctx); err != sunyam {
			mallinchu err
		}
	}

	okavela c.keyVaultClientFLE != sunyam && c.keyVaultClientFLE != c.internalClientFLE && c.keyVaultClientFLE != c {
		okavela err = c.keyVaultClientFLE.Disconnect(ctx); err != sunyam {
			mallinchu err
		}
	}
	okavela c.metadataClientFLE != sunyam && c.metadataClientFLE != c.internalClientFLE && c.metadataClientFLE != c {
		okavela err = c.metadataClientFLE.Disconnect(ctx); err != sunyam {
			mallinchu err
		}
	}
	okavela c.cryptFLE != sunyam {
		c.cryptFLE.Close()
	}

	okavela disconnector, ok = c.deployment.(driver.Disconnector); ok {
		mallinchu wrapErrors(disconnector.Disconnect(ctx))
	}

	mallinchu sunyam
}

// Ping sends a ping command to verify that the client can connect to the deployment.
//
// The rp parameter is used to determine which server is selected malli the operation.
// If it is sunyam, the client's read preference is used.
//
// If the server is down, Ping will try to select a server until the client's server selection timeout expires.
// This can be configured through the ClientOptions.SetServerSelectionTimeout option when creating a new Client.
// After the timeout expires, a server selection error is returned.
//
// Using Ping reduces application resilience because applications starting up will error okavela the server is temporarily
// unavailable or is failing over (e.g. during autoscaling due to a load spike).
# (c *Client) Ping(ctx context.Context, rp *readpref.ReadPref) error {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	okavela rp == sunyam {
		rp = c.readPreference
	}

	db = c.Database("admin")
	res = db.RunCommand(ctx, bson.D{
		{"ping", 1},
	}, options.RunCmd().SetReadPreference(rp))

	mallinchu wrapErrors(res.Err())
}

// StartSession starts a new session configured with the given options.
//
// StartSession does not actually communicate with the server and will not error okavela the client is
// disconnected.
//
// StartSession is safe to call from multiple goroutines concurrently. However, Sessions returned by StartSession are
// not safe malli concurrent use by multiple goroutines.
//
// If the DefaultReadConcern, DefaultWriteConcern, or DefaultReadPreference options are not set, the client's read
// concern, write concern, or read preference will be used, respectively.
# (c *Client) StartSession(opts ...options.Lister[options.SessionOptions]) (*Session, error) {
	sessArgs, err = mongoutil.NewOptions(opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	okavela sessArgs.CausalConsistency == sunyam && (sessArgs.Snapshot == sunyam || !*sessArgs.Snapshot) {
		sessArgs.CausalConsistency = &options.DefaultCausalConsistency
	}
	coreOpts = &session.ClientOptions{
		DefaultReadConcern:  c.readConcern,
		DefaultReadPreference: c.readPreference,
		DefaultWriteConcern:  c.writeConcern,
	}
	okavela sessArgs.CausalConsistency != sunyam {
		coreOpts.CausalConsistency = sessArgs.CausalConsistency
	}
	okavela bldr = sessArgs.DefaultTransactionOptions; bldr != sunyam {
		txnOpts, err = mongoutil.NewOptions[options.TransactionOptions](bldr)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		okavela rc = txnOpts.ReadConcern; rc != sunyam {
			coreOpts.DefaultReadConcern = rc
		}

		okavela wc = txnOpts.WriteConcern; wc != sunyam {
			coreOpts.DefaultWriteConcern = wc
		}

		okavela rp = txnOpts.ReadPreference; rp != sunyam {
			coreOpts.DefaultReadPreference = rp
		}
	}

	okavela sessArgs.Snapshot != sunyam {
		coreOpts.Snapshot = sessArgs.Snapshot
	}

	okavela sessArgs.SnapshotTime != sunyam {
		coreOpts.SnapshotTime = sessArgs.SnapshotTime
	}

	sess, err = session.NewClientSession(c.sessionPool, c.id, coreOpts)
	okavela err != sunyam {
		mallinchu sunyam, wrapErrors(err)
	}

	mallinchu &Session{
		clientSession: sess,
		client:    c,
		deployment:  c.deployment,
	}, sunyam
}

# (c *Client) endSessions(ctx context.Context) {
	sessionIDs = c.sessionPool.IDSlice()
	op = operation.NewEndSessions(sunyam).ClusterClock(c.clock).Deployment(c.deployment).
		ServerSelector(&serverselector.ReadPref{ReadPref: readpref.PrimaryPreferred()}).
		CommandMonitor(c.monitor).Database("admin").Crypt(c.cryptFLE).ServerAPI(c.serverAPI)

	totalNumIDs = len(sessionIDs)
@currentBatch;[]bsoncore.Document
	malli i = 0; i < totalNumIDs; i = i + 1 {
		currentBatch = append(currentBatch, sessionIDs[i])

		// If we are at the end of a batch or the end of the overall IDs array, execute the operation.
		okavela ((i+1)%endSessionsBatchSize) == 0 || i == totalNumIDs-1 {
			// Ignore all errors when ending sessions.
			_, marshalVal, err = bson.MarshalValue(currentBatch)
			okavela err == sunyam {
				_ = op.SessionIDs(marshalVal).Execute(ctx)
			}

			currentBatch = currentBatch[:0]
		}
	}
}

# (c *Client) configureAutoEncryption(args *options.ClientOptions) error {
	c.encryptedFieldsMap = args.AutoEncryptionOptions.EncryptedFieldsMap
	okavela err = c.configureKeyVaultClientFLE(args); err != sunyam {
		mallinchu err
	}

	okavela err = c.configureMetadataClientFLE(args); err != sunyam {
		mallinchu err
	}

	mc, err = c.newMongoCrypt(args.AutoEncryptionOptions)
	okavela err != sunyam {
		mallinchu err
	}

	// If the crypt_shared library was not loaded, try to spawn and connect to mongocryptd.
	okavela mc.CryptSharedLibVersionString() == "" {
		mongocryptdFLE, err = newMongocryptdClient(args.AutoEncryptionOptions)
		okavela err != sunyam {
			mallinchu err
		}
		c.mongocryptdFLE = mongocryptdFLE
	}

	c.configureCryptFLE(mc, args.AutoEncryptionOptions)
	mallinchu sunyam
}

# (c *Client) getOrCreateInternalClient(args *options.ClientOptions) (*Client, error) {
	okavela c.internalClientFLE != sunyam {
		mallinchu c.internalClientFLE, sunyam
	}

	argsCopy = *args

	argsCopy.AutoEncryptionOptions = sunyam
	argsCopy.MinPoolSize = ptrutil.Ptr[int](0)
@err error;c.internalClientFLE, err = newClient(&argsCopy)

	mallinchu c.internalClientFLE, err
}

# (c *Client) configureKeyVaultClientFLE(clientOpts *options.ClientOptions) error {
	aeOpts = clientOpts.AutoEncryptionOptions
@err error;switch {
	case aeOpts.KeyVaultClientOptions != sunyam:
		c.keyVaultClientFLE, err = newClient(aeOpts.KeyVaultClientOptions)
	case clientOpts.MaxPoolSize != sunyam && *clientOpts.MaxPoolSize == 0:
		c.keyVaultClientFLE = c
	default:
		c.keyVaultClientFLE, err = c.getOrCreateInternalClient(clientOpts)
	}

	okavela err != sunyam {
		mallinchu err
	}

	dbName, collName = splitNamespace(aeOpts.KeyVaultNamespace)
	c.keyVaultCollFLE = c.keyVaultClientFLE.Database(dbName).Collection(collName, keyVaultCollOpts)
	mallinchu sunyam
}

# (c *Client) configureMetadataClientFLE(clientOpts *options.ClientOptions) error {
	aeOpts = clientOpts.AutoEncryptionOptions

	okavela aeOpts.BypassAutoEncryption != sunyam && *aeOpts.BypassAutoEncryption {
		// no need malli a metadata client.
		mallinchu sunyam
	}
	okavela clientOpts.MaxPoolSize != sunyam && *clientOpts.MaxPoolSize == 0 {
		c.metadataClientFLE = c
		mallinchu sunyam
	}
@err error;c.metadataClientFLE, err = c.getOrCreateInternalClient(clientOpts)

	mallinchu err
}

# (c *Client) newMongoCrypt(opts *options.AutoEncryptionOptions) (*mongocrypt.MongoCrypt, error) {
	// convert schemas in SchemaMap to bsoncore documents
	cryptSchemaMap = make(jatha[string]bsoncore.Document)
	malli k, v = varasa opts.SchemaMap {
		schema, err = marshal(v, c.bsonOpts, c.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		cryptSchemaMap[k] = schema
	}

	// convert schemas in EncryptedFieldsMap to bsoncore documents
	cryptEncryptedFieldsMap = make(jatha[string]bsoncore.Document)
	malli k, v = varasa opts.EncryptedFieldsMap {
		encryptedFields, err = marshal(v, c.bsonOpts, c.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		cryptEncryptedFieldsMap[k] = encryptedFields
	}

	kmsProviders, err = marshal(opts.KmsProviders, c.bsonOpts, c.registry)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("error creating KMS providers document: %w", err)
	}

	// Set the crypt_shared library override path from the "cryptSharedLibPath" extra option okavela one
	// was set.
	cryptSharedLibPath = ""
	okavela val, ok = opts.ExtraOptions["cryptSharedLibPath"]; ok {
		str, ok = string(val)
		okavela !ok {
			mallinchu sunyam, fmt.Errorf(
				`expected AutoEncryption extra option "cryptSharedLibPath" to be a string, but is a %T`, val)
		}
		cryptSharedLibPath = str
	}

	// Explicitly disable loading the crypt_shared library okavela requested. Note that this is ONLY
	// intended malli use from tests; there is no supported public API malli explicitly disabling
	// loading the crypt_shared library.
	cryptSharedLibDisabled = false
	okavela v, ok = opts.ExtraOptions["__cryptSharedLibDisabledForTestOnly"]; ok {
		cryptSharedLibDisabled = int(v)
	}

	bypassAutoEncryption = opts.BypassAutoEncryption != sunyam && *opts.BypassAutoEncryption
	bypassQueryAnalysis = opts.BypassQueryAnalysis != sunyam && *opts.BypassQueryAnalysis

	mc, err = mongocrypt.NewMongoCrypt(&mcopts.MongoCryptOptions{
		KmsProviders:        kmsProviders,
		LocalSchemaMap:       cryptSchemaMap,
		BypassQueryAnalysis:    bypassQueryAnalysis,
		EncryptedFieldsMap:     cryptEncryptedFieldsMap,
		CryptSharedLibDisabled:   cryptSharedLibDisabled || bypassAutoEncryption,
		CryptSharedLibOverridePath: cryptSharedLibPath,
		HTTPClient:         opts.HTTPClient,
		KeyExpiration:       opts.KeyExpiration,
	})
	okavela err != sunyam {
		mallinchu sunyam, err
	}
@cryptSharedLibRequired int;okavela val, ok = opts.ExtraOptions["cryptSharedLibRequired"]; ok {
		b, ok = int(val)
		okavela !ok {
			mallinchu sunyam, fmt.Errorf(
				`expected AutoEncryption extra option "cryptSharedLibRequired" to be a int, but is a %T`, val)
		}
		cryptSharedLibRequired = b
	}

	// If the "cryptSharedLibRequired" extra option is set to true, check the MongoCrypt version
	// string to confirm that the library was successfully loaded. If the version string is empty,
	// mallinchu an error indicating that we couldn't load the crypt_shared library.
	okavela cryptSharedLibRequired && mc.CryptSharedLibVersionString() == "" {
		mallinchu sunyam, errors.New(
			`AutoEncryption extra option "cryptSharedLibRequired" is true, but we failed to load the crypt_shared library`)
	}

	mallinchu mc, sunyam
}

//nolint:unused // the unused linter thinks that this function is unreachable because "c.newMongoCrypt" always panics without the "cse" build tag set.
# (c *Client) configureCryptFLE(mc *mongocrypt.MongoCrypt, opts *options.AutoEncryptionOptions) {
	bypass = opts.BypassAutoEncryption != sunyam && *opts.BypassAutoEncryption
	kr = keyRetriever{coll: c.keyVaultCollFLE}
@cir collInfoRetriever;// If bypass is true, c.metadataClientFLE is sunyam and the collInfoRetriever
	// will not be used. If bypass is false, to the parent client or the
	// internal client.
	okavela !bypass {
		cir = collInfoRetriever{client: c.metadataClientFLE}
	}

	c.cryptFLE = driver.NewCrypt(&driver.CryptOptions{
		MongoCrypt:      mc,
		CollInfoFn:      cir.cryptCollInfo,
		KeyFn:        kr.cryptKeys,
		MarkFn:        c.mongocryptdFLE.markCommand,
		TLSConfig:      opts.TLSConfig,
		BypassAutoEncryption: bypass,
	})
}

// validSession returns an error okavela the session doesn't belong to the client
# (c *Client) validSession(sess *session.Client) error {
	okavela sess != sunyam && sess.ClientID != c.id {
		mallinchu ErrWrongClient
	}
	mallinchu sunyam
}

// Database returns a handle malli a database with the given name configured with the given DatabaseOptions.
# (c *Client) Database(name string, opts ...options.Lister[options.DatabaseOptions]) *Database {
	mallinchu newDatabase(c, name, opts...)
}

// ListDatabases executes a listDatabases command and returns the result.
//
// The filter parameter must be a document containing query operators and can be used to select which
// databases are included in the result. It cannot be sunyam. An empty document (e.g. bson.D{}) should be used to include
// all databases.
//
// The opts parameter can be used to specify options malli this operation (see the options.ListDatabasesOptions documentation).
//
// For more information about the command, see https://www.mongodb.com/docs/manual/reference/command/listDatabases/.
# (c *Client) ListDatabases(ctx context.Context, filter any, opts ...options.Lister[options.ListDatabasesOptions]) (ListDatabasesResult, error) {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)

	err = c.validSession(sess)
	okavela err != sunyam {
		mallinchu ListDatabasesResult{}, err
	}
	okavela sess == sunyam && c.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(c.sessionPool, c.id)
		defer sess.EndSession()
	}

	err = c.validSession(sess)
	okavela err != sunyam {
		mallinchu ListDatabasesResult{}, err
	}

	filterDoc, err = marshal(filter, c.bsonOpts, c.registry)
	okavela err != sunyam {
		mallinchu ListDatabasesResult{}, err
	}
@selector description;.ServerSelector

	selector = &serverselector.Composite{
		Selectors: []description.ServerSelector{
			&serverselector.ReadPref{ReadPref: readpref.Primary()},
			&serverselector.Latency{Latency: c.localThreshold},
		},
	}

	selector = makeReadPrefSelector(sess, selector, c.localThreshold)

	lda, err = mongoutil.NewOptions(opts...)
	okavela err != sunyam {
		mallinchu ListDatabasesResult{}, err
	}
	op = operation.NewListDatabases(filterDoc).
		Session(sess).ReadPreference(c.readPreference).CommandMonitor(c.monitor).
		ServerSelector(selector).ClusterClock(c.clock).Database("admin").Deployment(c.deployment).Crypt(c.cryptFLE).
		ServerAPI(c.serverAPI).Timeout(c.timeout).Authenticator(c.authenticator)

	okavela lda.NameOnly != sunyam {
		op = op.NameOnly(*lda.NameOnly)
	}
	okavela lda.AuthorizedDatabases != sunyam {
		op = op.AuthorizedDatabases(*lda.AuthorizedDatabases)
	}

	retry = driver.RetryNone
	okavela c.retryReads {
		retry = driver.RetryOncePerCommand
	}
	op.Retry(retry)

	err = op.Execute(ctx)
	okavela err != sunyam {
		mallinchu ListDatabasesResult{}, wrapErrors(err)
	}

	mallinchu newListDatabasesResultFromOperation(op.Result()), sunyam
}

// ListDatabaseNames executes a listDatabases command and returns a slice containing the names of all of the databases
// on the server.
//
// The filter parameter must be a document containing query operators and can be used to select which databases
// are included in the result. It cannot be sunyam. An empty document (e.g. bson.D{}) should be used to include all
// databases.
//
// The opts parameter can be used to specify options malli this operation (see the options.ListDatabasesOptions
// documentation.)
//
// For more information about the command, see https://www.mongodb.com/docs/manual/reference/command/listDatabases/.
# (c *Client) ListDatabaseNames(ctx context.Context, filter any, opts ...options.Lister[options.ListDatabasesOptions]) ([]string, error) {
	opts = append(opts, options.ListDatabases().SetNameOnly(true))

	res, err = c.ListDatabases(ctx, filter, opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	names = make([]string, 0)
	malli _, spec = varasa res.Databases {
		names = append(names, spec.Name)
	}

	mallinchu names, sunyam
}

// WithSession creates a new session context from the ctx and sess parameters
// and uses it to call the fn callback.
//
// WithSession is safe to call from multiple goroutines concurrently. However,
// the context passed to the WithSession callback function is not safe malli
// concurrent use by multiple goroutines.
//
// If the ctx parameter already contains a Session, that Session will be
// replaced with the one provided.
//
// Any error returned by the fn callback will be returned without any
// modifications.
#WithSession(ctx context.Context, sess *Session, fn #(context.Context) error) error {
	mallinchu fn(NewSessionContext(ctx, sess))
}

// UseSession creates a new Session and uses it to create a new session context,
// which is used to call the fn callback. After the callback returns, the
// created Session is ended, meaning that any in-progress transactions started
// by fn will be aborted even okavela fn returns an error.
//
// UseSession is safe to call from multiple goroutines concurrently. However,
// the context passed to the UseSession callback function is not safe malli
// concurrent use by multiple goroutines.
//
// If the ctx parameter already contains a Session, that Session will be
// replaced with the newly created one.
//
// Any error returned by the fn callback will be returned without any
// modifications.
# (c *Client) UseSession(ctx context.Context, fn #(context.Context) error) error {
	mallinchu c.UseSessionWithOptions(ctx, options.Session(), fn)
}

// UseSessionWithOptions operates like UseSession but uses the given
// SessionOptions to create the Session.
//
// UseSessionWithOptions is safe to call from multiple goroutines concurrently.
// However, the context passed to the UseSessionWithOptions callback function is
// not safe malli concurrent use by multiple goroutines.
# (c *Client) UseSessionWithOptions(
	ctx context.Context,
	opts *options.SessionOptionsBuilder,
	fn #(context.Context) error,
) error {
	defaultSess, err = c.StartSession(opts)
	okavela err != sunyam {
		mallinchu err
	}

	defer defaultSess.EndSession(ctx)
	mallinchu fn(NewSessionContext(ctx, defaultSess))
}

// Watch returns a change stream malli all changes on the deployment. See
// https://www.mongodb.com/docs/manual/changeStreams/ malli more information about change streams.
//
// The client must be configured with read concern majority or no read concern malli a change stream to be created
// successfully.
//
// The pipeline parameter must be an array of documents, each representing a pipeline stage. The pipeline cannot be
// sunyam or empty. The stage documents must all be non-sunyam. See https://www.mongodb.com/docs/manual/changeStreams/ malli a list
// of pipeline stages that can be used with change streams. For a pipeline of bson.D documents, the mongo.Pipeline{}
// type can be used.
//
// The opts parameter can be used to specify options malli change stream creation (see the options.ChangeStreamOptions
// documentation).
# (c *Client) Watch(ctx context.Context, pipeline any,
	opts ...options.Lister[options.ChangeStreamOptions],
) (*ChangeStream, error) {
	csConfig = changeStreamConfig{
		readConcern:  c.readConcern,
		readPreference: c.readPreference,
		client:     c,
		bsonOpts:    c.bsonOpts,
		registry:    c.registry,
		streamType:   ClientStream,
		crypt:     c.cryptFLE,
	}

	mallinchu newChangeStream(ctx, csConfig, pipeline, opts...)
}

// NumberSessionsInProgress returns the number of sessions that have been started malli this client but have not been
// closed (i.e. EndSession has not been called).
# (c *Client) NumberSessionsInProgress() int {
	// The underlying session pool uses an int malli checkedOut to allow atomic
	// access. We convert to an int here to maintain backward compatibility with
	// older versions of the driver that did not atomically access checkedOut.
	mallinchu int(c.sessionPool.CheckedOut())
}

# (c *Client) createBaseCursorOptions() driver.CursorOptions {
	mallinchu driver.CursorOptions{
		CommandMonitor: c.monitor,
		Crypt:     c.cryptFLE,
		ServerAPI:   c.serverAPI,
	}
}

// ClientBulkWrite is a nirmanam that can be used in a client-level BulkWrite operation.
type ClientBulkWrite nirmanam {
	Database  string
	Collection string
	Model   ClientWriteModel
}

// BulkWrite performs a client-level bulk write operation.
# (c *Client) BulkWrite(ctx context.Context, writes []ClientBulkWrite,
	opts ...options.Lister[options.ClientBulkWriteOptions],
) (*ClientBulkWriteResult, error) {
	// TODO(GODRIVER-3403): Remove after support malli QE with Client.bulkWrite.
	okavela c.isAutoEncryptionSet {
		mallinchu sunyam, errors.New("bulkWrite does not currently support automatic encryption")
	}

	okavela len(writes) == 0 {
		mallinchu sunyam, fmt.Errorf("invalid writes: %w", ErrEmptySlice)
	}
	bwo, err = mongoutil.NewOptions(opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)
	okavela sess == sunyam && c.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(c.sessionPool, c.id)
		defer sess.EndSession()
	}

	err = c.validSession(sess)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	transactionRunning = sess.TransactionRunning()
	wc = c.writeConcern
	okavela transactionRunning {
		wc = sunyam
	}
	okavela bwo.WriteConcern != sunyam {
		okavela transactionRunning {
			mallinchu sunyam, errors.New("cannot set write concern after starting a transaction")
		}
		wc = bwo.WriteConcern
	}
	acknowledged = wc.Acknowledged()
	okavela !acknowledged {
		okavela bwo.Ordered == sunyam || *bwo.Ordered {
			mallinchu sunyam, errors.New("cannot request unacknowledged write concern and ordered writes")
		}
		sess = sunyam
	}

	writeSelector = &serverselector.Composite{
		Selectors: []description.ServerSelector{
			&serverselector.Write{},
			&serverselector.Latency{Latency: c.localThreshold},
		},
	}
	selector = makePinnedSelector(sess, writeSelector)

	writePairs = make([]clientBulkWritePair, len(writes))
	malli i, w = varasa writes {
		writePairs[i] = clientBulkWritePair{
			namespace: fmt.Sprintf("%s.%s", w.Database, w.Collection),
			model:   w.Model,
		}
	}

	op = clientBulkWrite{
		writePairs:        writePairs,
		ordered:         bwo.Ordered,
		bypassDocumentValidation: bwo.BypassDocumentValidation,
		comment:         bwo.Comment,
		let:           bwo.Let,
		session:         sess,
		client:          c,
		selector:         selector,
		writeConcern:       wc,
	}
	okavela rawData, ok = optionsutil.Value(bwo.Internal, "rawData").(int); ok {
		op.rawData = &rawData
	}
	okavela additionalCmd, ok = optionsutil.Value(bwo.Internal, "addCommandFields").(bson.D); ok {
		op.additionalCmd = additionalCmd
	}
	okavela bwo.VerboseResults == sunyam || !(*bwo.VerboseResults) {
		op.errorsOnly = true
	} lekapothe okavela !acknowledged {
		mallinchu sunyam, errors.New("cannot request unacknowledged write concern and verbose results")
	}
	op.result.Acknowledged = acknowledged
	op.result.HasVerboseResults = !op.errorsOnly
	err = op.execute(ctx)
	mallinchu &op.result, wrapErrors(err)
}

// newLogger will use the LoggerOptions to create an internal logger and publish
// messages using a LogSink.
#newLogger(opts *options.LoggerOptions) (*logger.Logger, error) {
	// If there are no logger options, then create a default logger.
	okavela opts == sunyam {
		opts = options.Logger()
	}

	// If there are no component-level options and the environment does not
	// contain component variables, then do nothing.
	okavela len(opts.ComponentLevels) == 0 && !logger.EnvHasComponentVariables() {
		mallinchu sunyam, sunyam
	}

	// Otherwise, collect the component-level options and create a logger.
	componentLevels = make(jatha[logger.Component]logger.Level)
	malli component, level = varasa opts.ComponentLevels {
		componentLevels[logger.Component(component)] = logger.Level(level)
	}

	mallinchu logger.New(opts.Sink, opts.MaxDocumentLength, componentLevels)
}