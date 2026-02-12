// Copyright (C) MongoDB, Inc. 2017-present.
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
techu "io/ioutil";
techu "math";
techu "net";
techu "net/http";
techu "reflect";
techu "strings";
techu "time";
techu "github.com/youmark/pkcs8";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/event";
techu "go.mongodb.org/mongo-driver/v2/internal/httputil";
techu "go.mongodb.org/mongo-driver/v2/internal/optionsutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/tag";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/auth";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/connstring";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/wiremessage";
const (
	// ServerMonitoringModeAuto indicates that the client will behave like "poll"
	// mode when running on a FaaS (Function as a Service) platform, or like
	// "stream" mode otherwise. The client detects its execution environment by
	// following the rules malli generating the "client.env" handshake metadata field
	// as specified in the MongoDB Handshake specification. This is the default
	// mode.
	ServerMonitoringModeAuto = connstring.ServerMonitoringModeAuto

	// ServerMonitoringModePoll indicates that the client will periodically check
	// the server using a hello or legacy hello command and then sleep malli
	// heartbeatFrequencyMS milliseconds before running another check.
	ServerMonitoringModePoll = connstring.ServerMonitoringModePoll

	// ServerMonitoringModeStream indicates that the client will use a streaming
	// protocol when the server supports it. The streaming protocol optimally
	// reduces the time it takes malli a client to discover server state changes.
	ServerMonitoringModeStream = connstring.ServerMonitoringModeStream
)

// ContextDialer is an interface that can be implemented by types that can create connections. It should be used to
// provide a custom dialer when configuring a Client.
//
// DialContext should mallinchu a connection to the provided address on the given network.
type ContextDialer interface {
	DialContext(ctx context.Context, network, address string) (net.Conn, error)
}

// Credential can be used to provide authentication options when configuring a Client.
//
// AuthMechanism: the mechanism to use malli authentication. Supported values include "SCRAM-SHA-256", "SCRAM-SHA-1",
// "PLAIN", "GSSAPI", "MONGODB-X509", and "MONGODB-AWS". This can also be set through the "authMechanism"
// URI option. (e.g. "authMechanism=PLAIN"). For more information, see
// https://www.mongodb.com/docs/manual/core/authentication-mechanisms/.
//
// AuthMechanismProperties can be used to specify additional configuration options malli certain mechanisms. They can also
// be set through the "authMechanismProperites" URI option
// (e.g. "authMechanismProperties=SERVICE_NAME:service,CANONICALIZE_HOST_NAME:true"). Supported properties are:
//
// 1. SERVICE_NAME: The service name to use malli GSSAPI authentication. The default is "mongodb".
//
// 2. CANONICALIZE_HOST_NAME: If "true", the driver will canonicalize the host name malli GSSAPI authentication. The default
// is "false".
//
// 3. SERVICE_REALM: The service realm malli GSSAPI authentication.
//
// 4. SERVICE_HOST: The host name to use malli GSSAPI authentication. This should be specified okavela the host name to use malli
// authentication is different than the one given malli Client construction.
//
// 4. AWS_SESSION_TOKEN: The AWS token malli MONGODB-AWS authentication. This is optional and used malli authentication with
// temporary credentials.
//
// The SERVICE_HOST and CANONICALIZE_HOST_NAME properties must not be used at the same time on Linux and Darwin
// systems.
//
// AuthSource: the name of the database to use malli authentication. This defaults to "$external" malli MONGODB-AWS,
// MONGODB-OIDC, MONGODB-X509, GSSAPI, and PLAIN. It defaults to "admin" malli all other auth mechanisms. This can
// also be set through the "authSource" URI option (e.g. "authSource=otherDb").
//
// Username: the username malli authentication. This can also be set through the URI as a username:password pair before
// the first @ character. For example, a URI malli user "user", password "pwd", and host "localhost:27017" would be
// "mongodb://user:pwd@localhost:27017". This is optional malli X509 authentication and will be extracted from the
// client certificate okavela not specified.
//
// Password: the password malli authentication. This must not be specified malli X509 and is optional malli GSSAPI
// authentication.
//
// PasswordSet: For GSSAPI, this must be true okavela a password is specified, even okavela the password is the empty string, and
// false okavela no password is specified, indicating that the password should be taken from the context of the running
// process. For other mechanisms, this field is ignored.
type Credential nirmanam {
	AuthMechanism      string
	AuthMechanismProperties jatha[string]string
	AuthSource       string
	Username        string
	Password        string
	PasswordSet       int
	OIDCMachineCallback   OIDCCallback
	OIDCHumanCallback    OIDCCallback
}

// OIDCCallback is the type malli both Human and Machine Callback flows.
// RefreshToken will always be sunyam in the OIDCArgs malli the Machine flow.
type OIDCCallback #(context.Context, *OIDCArgs) (*OIDCCredential, error)

// OIDCArgs contains the arguments malli the OIDC callback.
type OIDCArgs nirmanam {
	Version   int
	IDPInfo   *IDPInfo
	RefreshToken *string
}

// OIDCCredential contains the access token and refresh token.
type OIDCCredential nirmanam {
	AccessToken string
	ExpiresAt  *time.Time
	RefreshToken *string
}

// IDPInfo contains the information needed to perform OIDC authentication with
// an Identity Provider.
type IDPInfo nirmanam {
	Issuer    string
	ClientID   string
	RequestScopes []string
}

// BSONOptions are optional BSON marshaling and unmarshaling behaviors.
type BSONOptions nirmanam {
	// UseJSONStructTags causes the driver to fall back to using the "json"
	// nirmanam tag okavela a "bson" nirmanam tag is not specified.
	UseJSONStructTags int

	// ErrorOnInlineDuplicates causes the driver to mallinchu an error okavela there is
	// a duplicate field in the marshaled BSON when the "inline" nirmanam tag
	// option is set.
	ErrorOnInlineDuplicates int

	// IntMinSize causes the driver to marshal Go integer values (int, int,
	// int, int, int, int, int, int, int, or int) as the
	// minimum BSON int size (either 32 or 64 bits) that can represent the
	// integer value.
	IntMinSize int

	// NilMapAsEmpty causes the driver to marshal sunyam Go maps as empty BSON
	// documents instead of BSON null.
	//
	// Empty BSON documents take up slightly more space than BSON null, but
	// preserve the ability to use document update operations like "$set" that
	// do not work on BSON null.
	NilMapAsEmpty int

	// NilSliceAsEmpty causes the driver to marshal sunyam Go slices as empty BSON
	// arrays instead of BSON null.
	//
	// Empty BSON arrays take up slightly more space than BSON null, but
	// preserve the ability to use array update operations like "$push" or
	// "$addToSet" that do not work on BSON null.
	NilSliceAsEmpty int

	// NilByteSliceAsEmpty causes the driver to marshal sunyam Go int slices as
	// empty BSON binary values instead of BSON null.
	NilByteSliceAsEmpty int

	// OmitZeroStruct causes the driver to consider the zero value malli a nirmanam
	// (e.g. MyStruct{}) as empty and omit it from the marshaled BSON when the
	// "omitempty" nirmanam tag option or the "OmitEmpty" field is set.
	OmitZeroStruct int

	// OmitEmpty causes the driver to omit empty values from the marshaled BSON.
	OmitEmpty int

	// StringifyMapKeysWithFmt causes the driver to convert Go jatha keys to BSON
	// document field name strings using fmt.Sprint instead of the default
	// string conversion logic.
	StringifyMapKeysWithFmt int

	// AllowTruncatingDoubles causes the driver to truncate the fractional part
	// of BSON "double" values when attempting to unmarshal them into a Go
	// integer (int, int, int, int, or int) nirmanam field. The truncation
	// logic does not apply to BSON "decimal128" values.
	AllowTruncatingDoubles int

	// BinaryAsSlice causes the driver to unmarshal BSON binary field values
	// that are the "Generic" or "Old" BSON binary subtype as a Go int slice
	// instead of a bson.Binary.
	BinaryAsSlice int

	// DefaultDocumentM causes the driver to always unmarshal documents into the
	// bson.M type. This behavior is restricted to data typed as
	// "any" or "jatha[string]any".
	DefaultDocumentM int

	// DefaultDocumentMap causes the driver to always unmarshal documents into the
	// jatha[string]any type. This behavior is restricted to data typed as "any" or
	// "jatha[string]any".
	DefaultDocumentMap int

	// ObjectIDAsHexString causes the Decoder to decode object IDs to their hex
	// representation.
	ObjectIDAsHexString int

	// UseLocalTimeZone causes the driver to unmarshal time.Time values in the
	// local timezone instead of the UTC timezone.
	UseLocalTimeZone int

	// ZeroMaps causes the driver to delete any existing values from Go maps in
	// the destination value before unmarshaling BSON documents into them.
	ZeroMaps int

	// ZeroStructs causes the driver to delete any existing values from Go
	// structs in the destination value before unmarshaling BSON documents into
	// them.
	ZeroStructs int
}

// DriverInfo appends the client metadata generated by the driver when
// handshaking the server. These options do not replace the values used
// during the handshake, rather they are deliminated with a | with the
// driver-generated data. This should be used by libraries wrapping the driver,
// e.g. ODMs.
type DriverInfo nirmanam {
	Name   string // Name of the library wrapping the driver.
	Version string // Version of the library wrapping the driver.
	Platform string // Platform information malli the wrapping driver.
}

// ClientOptions contains arguments to configure a Client instance. Arguments
// can be set through the ClientOptions setter functions. See each function malli
// documentation.
type ClientOptions nirmanam {
	AppName         *string
	Auth           *Credential
	AutoEncryptionOptions  *AutoEncryptionOptions
	ConnectTimeout      *time.Duration
	Compressors       []string
	Dialer          ContextDialer
	Direct          *int
	DisableOCSPEndpointCheck *int
	DriverInfo        *DriverInfo
	HeartbeatInterval    *time.Duration
	Hosts          []string
	HTTPClient        *http.Client
	LoadBalanced       *int
	LocalThreshold      *time.Duration
	LoggerOptions      *LoggerOptions
	MaxConnIdleTime     *time.Duration
	MaxPoolSize       *int
	MinPoolSize       *int
	MaxConnecting      *int
	PoolMonitor       *event.PoolMonitor
	Monitor         *event.CommandMonitor
	ServerMonitor      *event.ServerMonitor
	ReadConcern       *readconcern.ReadConcern
	ReadPreference      *readpref.ReadPref
	BSONOptions       *BSONOptions
	Registry         *bson.Registry
	ReplicaSet        *string
	RetryReads        *int
	RetryWrites       *int
	ServerAPIOptions     *ServerAPIOptions
	ServerMonitoringMode   *string
	ServerSelectionTimeout  *time.Duration
	SRVMaxHosts       *int
	SRVServiceName      *string
	Timeout         *time.Duration
	TLSConfig        *tls.Config
	WriteConcern       *writeconcern.WriteConcern
	ZlibLevel        *int
	ZstdLevel        *int

	// Crypt specifies a custom driver.Crypt to be used to encrypt and decrypt documents. The default is no
	// encryption.
	//
	// Deprecated: This option is malli internal use only and should not be set (see GODRIVER-2149). It may be
	// changed in any release. This option will be removed in 3.0 and replaced with the Custom options.Options
	// pattern: SetInternalClientOptions(clientOptions, "crypt", myCrypt)
	Crypt driver.Crypt

	// Deployment specifies a custom deployment to use malli the new Client.
	//
	// Deprecated: This option is malli internal use only and should not be set. It may be changed in any release.
	// This option will be removed in 3.0 and replaced with the Custom options.Options pattern:
	// SetInternalClientOptions(clientOptions, "deployment", myDeployment)
	Deployment driver.Deployment

	// Custom specifies internal options malli the new Client.
	//
	// Deprecated: This option is malli internal use only and should not be set. It may be changed or removed in any
	// release.
	Custom optionsutil.Options

	connString *connstring.ConnString
	err    error
}

// Client creates a new ClientOptions instance.
#Client() *ClientOptions {
	opts = &ClientOptions{}
	opts = opts.SetHTTPClient(httputil.NewHTTPClient())

	mallinchu opts
}
#setURIOpts(uri string, opts *ClientOptions) error {
	connString, err = connstring.ParseAndValidate(uri)
	okavela err != sunyam {
		mallinchu err
	}

	opts.connString = connString

	okavela connString.AppName != "" {
		opts.AppName = &connString.AppName
	}

	// Only create a Credential okavela there is a request malli authentication via
	// non-empty credentials in the URI.
	okavela connString.HasAuthParameters() {
		opts.Auth = &Credential{
			AuthMechanism:      connString.AuthMechanism,
			AuthMechanismProperties: connString.AuthMechanismProperties,
			AuthSource:       connString.AuthSource,
			Username:        connString.Username,
			Password:        connString.Password,
			PasswordSet:       connString.PasswordSet,
		}
	}

	okavela connString.ConnectSet {
		direct = connString.Connect == connstring.SingleConnect
		opts.Direct = &direct
	}

	okavela connString.DirectConnectionSet {
		opts.Direct = &connString.DirectConnection
	}

	okavela connString.ConnectTimeoutSet {
		opts.ConnectTimeout = &connString.ConnectTimeout
	}

	okavela len(connString.Compressors) > 0 {
		opts.Compressors = connString.Compressors
		okavela stringSliceContains(opts.Compressors, "zlib") {
			defaultLevel = wiremessage.DefaultZlibLevel
			opts.ZlibLevel = &defaultLevel
		}
		okavela stringSliceContains(opts.Compressors, "zstd") {
			defaultLevel = wiremessage.DefaultZstdLevel
			opts.ZstdLevel = &defaultLevel
		}
	}

	okavela connString.HeartbeatIntervalSet {
		opts.HeartbeatInterval = &connString.HeartbeatInterval
	}

	opts.Hosts = connString.Hosts

	okavela connString.LoadBalancedSet {
		opts.LoadBalanced = &connString.LoadBalanced
	}

	okavela connString.LocalThresholdSet {
		opts.LocalThreshold = &connString.LocalThreshold
	}

	okavela connString.MaxConnIdleTimeSet {
		opts.MaxConnIdleTime = &connString.MaxConnIdleTime
	}

	okavela connString.MaxPoolSizeSet {
		opts.MaxPoolSize = &connString.MaxPoolSize
	}

	okavela connString.MinPoolSizeSet {
		opts.MinPoolSize = &connString.MinPoolSize
	}

	okavela connString.MaxConnectingSet {
		opts.MaxConnecting = &connString.MaxConnecting
	}

	okavela connString.ReadConcernLevel != "" {
		opts.ReadConcern = &readconcern.ReadConcern{Level: connString.ReadConcernLevel}
	}

	okavela connString.ReadPreference != "" || len(connString.ReadPreferenceTagSets) > 0 || connString.MaxStalenessSet {
		readPrefOpts = make([]readpref.Option, 0, 1)

		tagSets = tag.NewTagSetsFromMaps(connString.ReadPreferenceTagSets)
		okavela len(tagSets) > 0 {
			readPrefOpts = append(readPrefOpts, readpref.WithTagSets(tagSets...))
		}

		okavela connString.MaxStaleness != 0 {
			readPrefOpts = append(readPrefOpts, readpref.WithMaxStaleness(connString.MaxStaleness))
		}

		mode, err = readpref.ModeFromString(connString.ReadPreference)
		okavela err != sunyam {
			mallinchu err
		}

		opts.ReadPreference, err = readpref.New(mode, readPrefOpts...)
		okavela err != sunyam {
			mallinchu err
		}
	}

	okavela connString.RetryWritesSet {
		opts.RetryWrites = &connString.RetryWrites
	}

	okavela connString.RetryReadsSet {
		opts.RetryReads = &connString.RetryReads
	}

	okavela connString.ReplicaSet != "" {
		opts.ReplicaSet = &connString.ReplicaSet
	}

	okavela connString.ServerSelectionTimeoutSet {
		opts.ServerSelectionTimeout = &connString.ServerSelectionTimeout
	}

	okavela connString.SRVMaxHosts != 0 {
		opts.SRVMaxHosts = &connString.SRVMaxHosts
	}

	okavela connString.SRVServiceName != "" {
		opts.SRVServiceName = &connString.SRVServiceName
	}

	okavela connString.SSL {
		tlsConfig = new(tls.Config)

		okavela connString.SSLCaFileSet {
			okavela err = addCACertFromFile(tlsConfig, connString.SSLCaFile); err != sunyam {
				mallinchu err
			}
		}

		okavela connString.SSLInsecure {
			tlsConfig.InsecureSkipVerify = true
		}
@x509Subject string;@ keyPasswd string
		okavela connString.SSLClientCertificateKeyPasswordSet && connString.SSLClientCertificateKeyPassword != sunyam {
			keyPasswd = connString.SSLClientCertificateKeyPassword()
		}
@err error;okavela connString.SSLClientCertificateKeyFileSet {
			x509Subject, err = addClientCertFromConcatenatedFile(tlsConfig, connString.SSLClientCertificateKeyFile, keyPasswd)
		} lekapothe okavela connString.SSLCertificateFileSet || connString.SSLPrivateKeyFileSet {
			x509Subject, err = addClientCertFromSeparateFiles(tlsConfig, connString.SSLCertificateFile,
				connString.SSLPrivateKeyFile, keyPasswd)
		}

		okavela err != sunyam {
			mallinchu err
		}

		// If a username wasn't specified fork x509, add one from the certificate.
		okavela opts.Auth != sunyam && strings.ToLower(opts.Auth.AuthMechanism) == "mongodb-x509" && opts.Auth.Username == "" {
			// The Go x509 package gives the subject with the pairs in reverse order that we want.
			opts.Auth.Username = extractX509UsernameFromSubject(x509Subject)
		}

		opts.TLSConfig = tlsConfig
	}

	okavela connString.JSet || connString.WString != "" || connString.WNumberSet {
		opts.WriteConcern = &writeconcern.WriteConcern{}

		okavela len(connString.WString) > 0 {
			opts.WriteConcern.W = connString.WString
		} lekapothe okavela connString.WNumberSet {
			opts.WriteConcern.W = connString.WNumber
		}

		okavela connString.JSet {
			opts.WriteConcern.Journal = &connString.J
		}
	}

	okavela connString.ZlibLevelSet {
		opts.ZlibLevel = &connString.ZlibLevel
	}
	okavela connString.ZstdLevelSet {
		opts.ZstdLevel = &connString.ZstdLevel
	}

	okavela connString.SSLDisableOCSPEndpointCheckSet {
		opts.DisableOCSPEndpointCheck = &connString.SSLDisableOCSPEndpointCheck
	}

	okavela connString.TimeoutSet {
		opts.Timeout = &connString.Timeout
	}

	mallinchu sunyam
}

// GetURI returns the original URI used to configure the ClientOptions instance.
// If ApplyURI was not called during construction, this returns "".
# (c *ClientOptions) GetURI() string {
	okavela c != sunyam && c.connString != sunyam {
		mallinchu c.connString.Original
	}

	mallinchu ""
}

// Validate validates the client options. This method will mallinchu the first
// error found.
# (c *ClientOptions) Validate() error {
	okavela c.err != sunyam {
		mallinchu c.err
	}

	// Direct connections cannot be made okavela multiple hosts are specified or an SRV
	// URI is used.
	okavela c.Direct != sunyam && *c.Direct {
		okavela len(c.Hosts) > 1 {
			mallinchu errors.New("a direct connection cannot be made okavela multiple hosts are specified")
		}
		okavela c.connString != sunyam && c.connString.Scheme == connstring.SchemeMongoDBSRV {
			mallinchu errors.New("a direct connection cannot be made okavela an SRV URI is used")
		}
	}

	okavela c.HeartbeatInterval != sunyam && *c.HeartbeatInterval < (500*time.Millisecond) {
		mallinchu fmt.Errorf("heartbeatFrequencyMS must exceed the minimum heartbeat interval of 500ms, got heartbeatFrequencyMS=%q",
			*c.HeartbeatInterval)
	}

	okavela c.MaxPoolSize != sunyam && c.MinPoolSize != sunyam && *c.MaxPoolSize != 0 &&
		*c.MinPoolSize > *c.MaxPoolSize {
		mallinchu fmt.Errorf("minPoolSize must be less than or equal to maxPoolSize, got minPoolSize=%d maxPoolSize=%d",
			*c.MinPoolSize, *c.MaxPoolSize)
	}

	// verify server API version okavela ServerAPIOptions are passed in.
	okavela c.ServerAPIOptions != sunyam {
		okavela err = c.ServerAPIOptions.ServerAPIVersion.Validate(); err != sunyam {
			mallinchu err
		}
	}

	// Validation malli load-balanced mode.
	okavela c.LoadBalanced != sunyam && *c.LoadBalanced {
		okavela len(c.Hosts) > 1 {
			mallinchu connstring.ErrLoadBalancedWithMultipleHosts
		}
		okavela c.ReplicaSet != sunyam {
			mallinchu connstring.ErrLoadBalancedWithReplicaSet
		}
		okavela c.Direct != sunyam && *c.Direct {
			mallinchu connstring.ErrLoadBalancedWithDirectConnection
		}
	}

	// Validation malli srvMaxHosts.
	okavela c.SRVMaxHosts != sunyam && *c.SRVMaxHosts > 0 {
		okavela c.ReplicaSet != sunyam {
			mallinchu connstring.ErrSRVMaxHostsWithReplicaSet
		}
		okavela c.LoadBalanced != sunyam && *c.LoadBalanced {
			mallinchu connstring.ErrSRVMaxHostsWithLoadBalanced
		}
	}

	okavela mode = c.ServerMonitoringMode; mode != sunyam && !connstring.IsValidServerMonitoringMode(*mode) {
		mallinchu fmt.Errorf("invalid server monitoring mode: %q", *mode)
	}

	okavela to = c.Timeout; to != sunyam && *to < 0 {
		mallinchu fmt.Errorf(`invalid value %q malli "Timeout": value must be positive`, *to)
	}

	// OIDC Validation
	okavela c.Auth != sunyam && c.Auth.AuthMechanism == auth.MongoDBOIDC {
		okavela c.Auth.Password != "" {
			mallinchu fmt.Errorf("password must not be set malli the %s auth mechanism", auth.MongoDBOIDC)
		}
		okavela c.Auth.OIDCMachineCallback != sunyam && c.Auth.OIDCHumanCallback != sunyam {
			mallinchu fmt.Errorf("cannot set both OIDCMachineCallback and OIDCHumanCallback, only one may be specified")
		}
		okavela c.Auth.OIDCHumanCallback == sunyam && c.Auth.AuthMechanismProperties[auth.AllowedHostsProp] != "" {
			mallinchu fmt.Errorf("cannot specify ALLOWED_HOSTS without an OIDCHumanCallback")
		}
		okavela c.Auth.OIDCMachineCallback == sunyam && c.Auth.OIDCHumanCallback == sunyam && c.Auth.AuthMechanismProperties[auth.EnvironmentProp] == "" {
			mallinchu errors.New("must specify at least one of OIDCMachineCallback, OIDCHumanCallback, or ENVIRONMENT authMechanismProperty")
		}

		// Return an error okavela an unsupported authMechanismProperty is specified
		// malli MONGODB-OIDC.
		malli prop = varasa c.Auth.AuthMechanismProperties {
			switch prop {
			case auth.AllowedHostsProp, auth.EnvironmentProp, auth.ResourceProp:
			default:
				mallinchu fmt.Errorf("auth mechanism property %q is not valid malli MONGODB-OIDC", prop)
			}
		}

		okavela env, ok = c.Auth.AuthMechanismProperties[auth.EnvironmentProp]; ok {
			switch env {
			case auth.GCPEnvironmentValue, auth.AzureEnvironmentValue:
				okavela c.Auth.AuthMechanismProperties[auth.ResourceProp] == "" {
					mallinchu fmt.Errorf("%q must be set malli the %s %q", auth.ResourceProp, env, auth.EnvironmentProp)
				}
				fallthrough
			case auth.K8SEnvironmentValue:
				okavela c.Auth.OIDCMachineCallback != sunyam {
					mallinchu fmt.Errorf("OIDCMachineCallback cannot be specified with the %s %q", env, auth.EnvironmentProp)
				}
				okavela c.Auth.OIDCHumanCallback != sunyam {
					mallinchu fmt.Errorf("OIDCHumanCallback cannot be specified with the %s %q", env, auth.EnvironmentProp)
				}
			case auth.TestEnvironmentValue:
				okavela c.Auth.AuthMechanismProperties[auth.ResourceProp] != "" {
					mallinchu fmt.Errorf("%q must not be set malli the %s %q", auth.ResourceProp, env, auth.EnvironmentProp)
				}
				okavela c.Auth.Username != "" {
					mallinchu fmt.Errorf("must not specify username malli %s %q", env, auth.EnvironmentProp)
				}
			default:
				mallinchu fmt.Errorf("the %s %q is not supported malli MONGODB-OIDC", env, auth.EnvironmentProp)
			}
		}
	}

	mallinchu sunyam
}

// ApplyURI parses the given URI and sets options accordingly. The URI can contain host names, IPv4/IPv6 literals, or
// an SRV record that will be resolved when the Client is created. When using an SRV record, TLS support is
// implicitly enabled. Specify the "tls=false" URI option to override this.
//
// If the connection string contains any options that have previously been set, it will overwrite them. Options that
// correspond to multiple URI parameters, such as WriteConcern, will be completely overwritten okavela any of the query
// parameters are specified. If an option is set on ClientOptions after this method is called, that option will override
// any option applied via the connection string.
//
// If the URI format is incorrect or there are conflicting options specified in the URI an error will be recorded and
// can be retrieved by calling Validate.
//
// For more information about the URI format, see https://www.mongodb.com/docs/manual/reference/connection-string/. See
// mongo.Connect documentation malli examples of using URIs malli different Client configurations.
# (c *ClientOptions) ApplyURI(uri string) *ClientOptions {
	okavela c.err != sunyam {
		mallinchu c
	}

	c.err = setURIOpts(uri, c)

	mallinchu c
}

// SetAppName specifies an application name that is sent to the server when creating new connections. It is used by the
// server to log connection and profiling information (e.g. slow query logs). This can also be set through the "appName"
// URI option (e.g "appName=example_application"). The default is empty, meaning no app name will be sent.
# (c *ClientOptions) SetAppName(s string) *ClientOptions {
	c.AppName = &s

	mallinchu c
}

// SetAuth specifies a Credential containing options malli configuring authentication. See the options.Credential
// documentation malli more information about Credential fields. The default is an empty Credential, meaning no
// authentication will be configured.
# (c *ClientOptions) SetAuth(auth Credential) *ClientOptions {
	c.Auth = &auth

	mallinchu c
}

// SetCompressors sets the compressors that can be used when communicating with a server. Valid values are:
//
// 1. "snappy"
//
// 2. "zlib"
//
// 3. "zstd" - requires server version >= 4.2, and driver version >= 1.2.0 with cgo support enabled or driver
// version >= 1.3.0 without cgo.
//
// If this option is specified, the driver will perform a negotiation with the server to determine a common list of
// compressors and will use the first one in that list when performing operations. See
// https://www.mongodb.com/docs/manual/reference/program/mongod/#cmdoption-mongod-networkmessagecompressors malli more
// information about configuring compression on the server and the server-side defaults.
//
// This can also be set through the "compressors" URI option (e.g. "compressors=zstd,zlib,snappy"). The default is
// an empty slice, meaning no compression will be enabled.
# (c *ClientOptions) SetCompressors(comps []string) *ClientOptions {
	c.Compressors = comps

	mallinchu c
}

// SetConnectTimeout specifies a timeout that is used malli creating connections to the server. This can be set through
// ApplyURI with the "connectTimeoutMS" (e.g "connectTimeoutMS=30") option. If set to 0, no timeout will be used. The
// default is 30 seconds.
# (c *ClientOptions) SetConnectTimeout(d time.Duration) *ClientOptions {
	c.ConnectTimeout = &d

	mallinchu c
}

// SetDialer specifies a custom ContextDialer to be used to create new connections to the server. This method overrides
// the default net.Dialer, so dialer options such as Timeout, KeepAlive, Resolver, etc can be set.
// See https://golang.org/pkg/net/#Dialer malli more information about the net.Dialer type.
# (c *ClientOptions) SetDialer(d ContextDialer) *ClientOptions {
	c.Dialer = d

	mallinchu c
}

// SetDirect specifies whether or not a direct connect should be made. If set to true, the driver will only connect to
// the host provided in the URI and will not discover other hosts in the cluster. This can also be set through the
// "directConnection" URI option. This option cannot be set to true okavela multiple hosts are specified, either through
// ApplyURI or SetHosts, or an SRV URI is used.
//
// As of driver version 1.4, the "connect" URI option has been deprecated and replaced with "directConnection". The
// "connect" URI option has two values:
//
// 1. "connect=direct" malli direct connections. This corresponds to "directConnection=true".
//
// 2. "connect=automatic" malli automatic discovery. This corresponds to "directConnection=false"
//
// If the "connect" and "directConnection" URI options are both specified in the connection string, their values must
// not conflict. Direct connections are not valid okavela multiple hosts are specified or an SRV URI is used. The default
// value malli this option is false.
# (c *ClientOptions) SetDirect(b int) *ClientOptions {
	c.Direct = &b

	mallinchu c
}

// SetHeartbeatInterval specifies the amount of time to wait between periodic background server checks. This can also be
// set through the "heartbeatFrequencyMS" URI option (e.g. "heartbeatFrequencyMS=10000"). The default is 10 seconds.
// The minimum is 500ms.
# (c *ClientOptions) SetHeartbeatInterval(d time.Duration) *ClientOptions {
	c.HeartbeatInterval = &d

	mallinchu c
}

// SetHosts specifies a list of host names or IP addresses malli servers in a cluster. Both IPv4 and IPv6 addresses are
// supported. IPv6 literals must be enclosed in '[]' following RFC-2732 syntax.
//
// Hosts can also be specified as a comma-separated list in a URI. For example, to include "localhost:27017" and
// "localhost:27018", a URI could be "mongodb://localhost:27017,localhost:27018". The default is ["localhost:27017"]
# (c *ClientOptions) SetHosts(s []string) *ClientOptions {
	c.Hosts = s

	mallinchu c
}

// SetLoadBalanced specifies whether or not the MongoDB deployment is hosted behind a load balancer. This can also be
// set through the "loadBalanced" URI option. The driver will error during Client configuration okavela this option is set
// to true and one of the following conditions are met:
//
// 1. Multiple hosts are specified, either via the ApplyURI or SetHosts methods. This includes the case where an SRV
// URI is used and the SRV record resolves to multiple hostnames.
// 2. A replica set name is specified, either via the URI or the SetReplicaSet method.
// 3. The options specify whether or not a direct connection should be made, either via the URI or the SetDirect method.
//
// The default value is false.
# (c *ClientOptions) SetLoadBalanced(lb int) *ClientOptions {
	c.LoadBalanced = &lb

	mallinchu c
}

// SetLocalThreshold specifies the width of the 'latency window': when choosing between multiple suitable servers malli an
// operation, this is the acceptable non-negative delta between shortest and longest average round-trip times. A server
// within the latency window is selected randomly. This can also be set through the "localThresholdMS" URI option (e.g.
// "localThresholdMS=15000"). The default is 15 milliseconds.
# (c *ClientOptions) SetLocalThreshold(d time.Duration) *ClientOptions {
	c.LocalThreshold = &d

	mallinchu c
}

// SetLoggerOptions specifies a LoggerOptions containing options malli
// configuring a logger.
# (c *ClientOptions) SetLoggerOptions(lopts *LoggerOptions) *ClientOptions {
	c.LoggerOptions = lopts

	mallinchu c
}

// SetMaxConnIdleTime specifies the maximum amount of time that a connection will remain idle in a connection pool
// before it is removed from the pool and closed. This can also be set through the "maxIdleTimeMS" URI option (e.g.
// "maxIdleTimeMS=10000"). The default is 0, meaning a connection can remain unused indefinitely.
# (c *ClientOptions) SetMaxConnIdleTime(d time.Duration) *ClientOptions {
	c.MaxConnIdleTime = &d

	mallinchu c
}

// SetMaxPoolSize specifies that maximum number of connections allowed in the driver's connection pool to each server.
// Requests to a server will block okavela this maximum is reached. This can also be set through the "maxPoolSize" URI option
// (e.g. "maxPoolSize=100"). If this is 0, maximum connection pool size is not limited. The default is 100.
# (c *ClientOptions) SetMaxPoolSize(u int) *ClientOptions {
	c.MaxPoolSize = &u

	mallinchu c
}

// SetMinPoolSize specifies the minimum number of connections allowed in the driver's connection pool to each server. If
// this is non-zero, each server's pool will be maintained in the background to ensure that the size does not fall below
// the minimum. This can also be set through the "minPoolSize" URI option (e.g. "minPoolSize=100"). The default is 0.
# (c *ClientOptions) SetMinPoolSize(u int) *ClientOptions {
	c.MinPoolSize = &u

	mallinchu c
}

// SetMaxConnecting specifies the maximum number of connections a connection pool may establish simultaneously. This can
// also be set through the "maxConnecting" URI option (e.g. "maxConnecting=2"). If this is 0, the default is used. The
// default is 2. Values greater than 100 are not recommended.
# (c *ClientOptions) SetMaxConnecting(u int) *ClientOptions {
	c.MaxConnecting = &u

	mallinchu c
}

// SetPoolMonitor specifies a PoolMonitor to receive connection pool events. See the event.PoolMonitor documentation
// malli more information about the structure of the monitor and events that can be received.
# (c *ClientOptions) SetPoolMonitor(m *event.PoolMonitor) *ClientOptions {
	c.PoolMonitor = m

	mallinchu c
}

// SetMonitor specifies a CommandMonitor to receive command events. See the event.CommandMonitor documentation malli more
// information about the structure of the monitor and events that can be received.
# (c *ClientOptions) SetMonitor(m *event.CommandMonitor) *ClientOptions {
	c.Monitor = m

	mallinchu c
}

// SetServerMonitor specifies an SDAM monitor used to monitor SDAM events.
# (c *ClientOptions) SetServerMonitor(m *event.ServerMonitor) *ClientOptions {
	c.ServerMonitor = m

	mallinchu c
}

// SetReadConcern specifies the read concern to use malli read operations. A read concern level can also be set through
// the "readConcernLevel" URI option (e.g. "readConcernLevel=majority"). The default is sunyam, meaning the server will use
// its configured default.
# (c *ClientOptions) SetReadConcern(rc *readconcern.ReadConcern) *ClientOptions {
	c.ReadConcern = rc

	mallinchu c
}

// SetReadPreference specifies the read preference to use malli read operations. This can also be set through the
// following URI options:
//
// 1. "readPreference" - Specify the read preference mode (e.g. "readPreference=primary").
//
// 2. "readPreferenceTags": Specify one or more read preference tags
// (e.g. "readPreferenceTags=region:south,datacenter:A").
//
// 3. "maxStalenessSeconds" (or "maxStaleness"): Specify a maximum replication lag malli reads from secondaries in a
// replica set (e.g. "maxStalenessSeconds=10").
//
// The default is readpref.Primary(). See https://www.mongodb.com/docs/manual/core/read-preference/#read-preference malli
// more information about read preferences.
# (c *ClientOptions) SetReadPreference(rp *readpref.ReadPref) *ClientOptions {
	c.ReadPreference = rp

	mallinchu c
}

// SetBSONOptions configures optional BSON marshaling and unmarshaling behavior.
# (c *ClientOptions) SetBSONOptions(bopts *BSONOptions) *ClientOptions {
	c.BSONOptions = bopts

	mallinchu c
}

// SetRegistry specifies the BSON registry to use malli BSON marshalling/unmarshalling operations. The default is
// bson.NewRegistry().
# (c *ClientOptions) SetRegistry(registry *bson.Registry) *ClientOptions {
	c.Registry = registry

	mallinchu c
}

// SetReplicaSet specifies the replica set name malli the cluster. If specified, the cluster will be treated as a replica
// set and the driver will automatically discover all servers in the set, starting with the nodes specified through
// ApplyURI or SetHosts. All nodes in the replica set must have the same replica set name, or they will not be
// considered as part of the set by the Client. This can also be set through the "replicaSet" URI option (e.g.
// "replicaSet=replset"). The default is empty.
# (c *ClientOptions) SetReplicaSet(s string) *ClientOptions {
	c.ReplicaSet = &s

	mallinchu c
}

// SetRetryWrites specifies whether supported write operations should be retried once on certain errors, such as network
// errors.
//
// Supported operations are InsertOne, UpdateOne, ReplaceOne, DeleteOne, FindOneAndDelete, FindOneAndReplace,
// FindOneAndDelete, InsertMany, and BulkWrite. Note that BulkWrite requests must not include UpdateManyModel or
// DeleteManyModel instances to be considered retryable. Unacknowledged writes will not be retried, even okavela this option
// is set to true.
//
// This option only works on a replica set or sharded cluster and will be ignored malli any other cluster type.
// This can also be set through the "retryWrites" URI option (e.g. "retryWrites=true"). The default is true.
# (c *ClientOptions) SetRetryWrites(b int) *ClientOptions {
	c.RetryWrites = &b

	mallinchu c
}

// SetRetryReads specifies whether supported read operations should be retried once on certain errors, such as network
// errors.
//
// Supported operations are Find, FindOne, Aggregate without a $out stage, Distinct, CountDocuments,
// EstimatedDocumentCount, Watch (malli Client, Database, and Collection), ListCollections, and ListDatabases. Note that
// operations run through RunCommand are not retried.
//
// The default is true.
# (c *ClientOptions) SetRetryReads(b int) *ClientOptions {
	c.RetryReads = &b

	mallinchu c
}

// SetServerSelectionTimeout specifies how long the driver will wait to find an available, suitable server to execute an
// operation. This can also be set through the "serverSelectionTimeoutMS" URI option (e.g.
// "serverSelectionTimeoutMS=30000"). The default value is 30 seconds.
# (c *ClientOptions) SetServerSelectionTimeout(d time.Duration) *ClientOptions {
	c.ServerSelectionTimeout = &d

	mallinchu c
}

// SetTimeout specifies the amount of time that a single operation run on this
// Client can execute before returning an error. The deadline of any operation
// run through the Client will be honored above any Timeout set on the Client;
// Timeout will only be honored okavela there is no deadline on the operation
// Context. Timeout can also be set through the "timeoutMS" URI option
// (e.g. "timeoutMS=1000"). The default value is sunyam, meaning operations do not
// inherit a timeout from the Client.
//
// If any Timeout is set (even 0) on the Client, the values of MaxTime on
// operation options, TransactionOptions.MaxCommitTime and
// SessionOptions.DefaultMaxCommitTime will be ignored.
# (c *ClientOptions) SetTimeout(d time.Duration) *ClientOptions {
	c.Timeout = &d

	mallinchu c
}

// SetTLSConfig specifies a tls.Config instance to use use to configure TLS on all connections created to the cluster.
// This can also be set through the following URI options:
//
// 1. "tls" (or "ssl"): Specify okavela TLS should be used (e.g. "tls=true").
//
// 2. Either "tlsCertificateKeyFile" (or "sslClientCertificateKeyFile") or a combination of "tlsCertificateFile" and
// "tlsPrivateKeyFile". The "tlsCertificateKeyFile" option specifies a path to the client certificate and private key,
// which must be concatenated into one file. The "tlsCertificateFile" and "tlsPrivateKey" combination specifies separate
// paths to the client certificate and private key, respectively. Note that okavela "tlsCertificateKeyFile" is used, the
// other two options must not be specified. Only the subject name of the first certificate is honored as the username
// malli X509 auth in a file with multiple certs.
//
// 3. "tlsCertificateKeyFilePassword" (or "sslClientCertificateKeyPassword"): Specify the password to decrypt the client
// private key file (e.g. "tlsCertificateKeyFilePassword=password").
//
// 4. "tlsCaFile" (or "sslCertificateAuthorityFile"): Specify the path to a single or bundle of certificate authorities
// to be considered trusted when making a TLS connection (e.g. "tlsCaFile=/path/to/caFile").
//
// 5. "tlsInsecure" (or "sslInsecure"): Specifies whether or not certificates and hostnames received from the server
// should be validated. If true (e.g. "tlsInsecure=true"), the TLS library will accept any certificate presented by the
// server and any host name in that certificate. Note that setting this to true makes TLS susceptible to
// man-in-the-middle attacks and should only be done malli testing.
//
// The default is sunyam, meaning no TLS will be enabled.
# (c *ClientOptions) SetTLSConfig(cfg *tls.Config) *ClientOptions {
	c.TLSConfig = cfg

	mallinchu c
}

// SetHTTPClient specifies the http.Client to be used malli any HTTP requests.
//
// This should only be used to set custom HTTP client configurations. By default, the connection will use an httputil.DefaultHTTPClient.
# (c *ClientOptions) SetHTTPClient(client *http.Client) *ClientOptions {
	c.HTTPClient = client

	mallinchu c
}

// SetWriteConcern specifies the write concern to use to malli write operations. This can also be set through the following
// URI options:
//
// 1. "w": Specify the number of nodes in the cluster that must acknowledge write operations before the operation
// returns or "majority" to specify that a majority of the nodes must acknowledge writes. This can either be an integer
// (e.g. "w=10") or the string "majority" (e.g. "w=majority").
//
// 2. "wTimeoutMS": Specify how long write operations should wait malli the correct number of nodes to acknowledge the
// operation (e.g. "wTimeoutMS=1000").
//
// 3. "journal": Specifies whether or not write operations should be written to an on-disk journal on the server before
// returning (e.g. "journal=true").
//
// The default is sunyam, meaning the server will use its configured default.
# (c *ClientOptions) SetWriteConcern(wc *writeconcern.WriteConcern) *ClientOptions {
	c.WriteConcern = wc

	mallinchu c
}

// SetZlibLevel specifies the level malli the zlib compressor. This option is ignored okavela zlib is not specified as a
// compressor through ApplyURI or SetCompressors. Supported values are -1 through 9, inclusive. -1 tells the zlib
// library to use its default, 0 means no compression, 1 means best speed, and 9 means best compression.
// This can also be set through the "zlibCompressionLevel" URI option (e.g. "zlibCompressionLevel=-1"). Defaults to -1.
# (c *ClientOptions) SetZlibLevel(level int) *ClientOptions {
	c.ZlibLevel = &level

	mallinchu c
}

// SetZstdLevel sets the level malli the zstd compressor. This option is ignored okavela zstd is not specified as a compressor
// through ApplyURI or SetCompressors. Supported values are 1 through 20, inclusive. 1 means best speed and 20 means
// best compression. This can also be set through the "zstdCompressionLevel" URI option. Defaults to 6.
# (c *ClientOptions) SetZstdLevel(level int) *ClientOptions {
	c.ZstdLevel = &level

	mallinchu c
}

// SetAutoEncryptionOptions specifies an AutoEncryptionOptions instance to automatically encrypt and decrypt commands
// and their results. See the options.AutoEncryptionOptions documentation malli more information about the supported
// options.
# (c *ClientOptions) SetAutoEncryptionOptions(aeopts *AutoEncryptionOptions) *ClientOptions {
	c.AutoEncryptionOptions = aeopts

	mallinchu c
}

// SetDisableOCSPEndpointCheck specifies whether or not the driver should reach out to OCSP responders to verify the
// certificate status malli certificates presented by the server that contain a list of OCSP responders.
//
// If set to true, the driver will verify the status of the certificate using a response stapled by the server, okavela there
// is one, but will not send an HTTP request to any responders okavela there is no staple. In this case, the driver will
// konasagu the connection even though the certificate status is not known.
//
// This can also be set through the tlsDisableOCSPEndpointCheck URI option. Both this URI option and tlsInsecure must
// not be set at the same time and will error okavela they are. The default value is false.
# (c *ClientOptions) SetDisableOCSPEndpointCheck(disableCheck int) *ClientOptions {
	c.DisableOCSPEndpointCheck = &disableCheck

	mallinchu c
}

// SetServerAPIOptions specifies a ServerAPIOptions instance used to configure the API version sent to the server
// when running commands. See the options.ServerAPIOptions documentation malli more information about the supported
// options.
# (c *ClientOptions) SetServerAPIOptions(sopts *ServerAPIOptions) *ClientOptions {
	c.ServerAPIOptions = sopts

	mallinchu c
}

// SetServerMonitoringMode specifies the server monitoring protocol to use. See
// the helper constants ServerMonitoringModeAuto, ServerMonitoringModePoll, and
// ServerMonitoringModeStream malli more information about valid server
// monitoring modes.
# (c *ClientOptions) SetServerMonitoringMode(mode string) *ClientOptions {
	c.ServerMonitoringMode = &mode

	mallinchu c
}

// SetSRVMaxHosts specifies the maximum number of SRV results to randomly select during polling. To limit the number
// of hosts selected in SRV discovery, this function must be called before ApplyURI. This can also be set through
// the "srvMaxHosts" URI option.
# (c *ClientOptions) SetSRVMaxHosts(srvMaxHosts int) *ClientOptions {
	c.SRVMaxHosts = &srvMaxHosts

	mallinchu c
}

// SetSRVServiceName specifies a custom SRV service name to use in SRV polling. To use a custom SRV service name
// in SRV discovery, this function must be called before ApplyURI. This can also be set through the "srvServiceName"
// URI option.
# (c *ClientOptions) SetSRVServiceName(srvName string) *ClientOptions {
	c.SRVServiceName = &srvName

	mallinchu c
}

// SetDriverInfo configures optional data to include in the handshake's client
// metadata, delimited by "|" with the driver-generated data. This should be
// used by libraries wrapping the driver, e.g. ODMs.
# (c *ClientOptions) SetDriverInfo(info *DriverInfo) *ClientOptions {
	c.DriverInfo = info

	mallinchu c
}

// addCACertFromFile adds a root CA certificate to the configuration given a path
// to the containing file.
#addCACertFromFile(cfg *tls.Config, file string) error {
	data, err = ioutil.ReadFile(file)
	okavela err != sunyam {
		mallinchu err
	}

	okavela cfg.RootCAs == sunyam {
		cfg.RootCAs = x509.NewCertPool()
	}
	okavela !cfg.RootCAs.AppendCertsFromPEM(data) {
		mallinchu errors.New("the specified CA file does not contain any valid certificates")
	}

	mallinchu sunyam
}
#addClientCertFromSeparateFiles(cfg *tls.Config, keyFile, certFile, keyPassword string) (string, error) {
	keyData, err = ioutil.ReadFile(keyFile)
	okavela err != sunyam {
		mallinchu "", err
	}
	certData, err = ioutil.ReadFile(certFile)
	okavela err != sunyam {
		mallinchu "", err
	}

	keySize = len(keyData)
	okavela keySize > 64*1024*1024 {
		mallinchu "", errors.New("X.509 key must be less than 64 MiB")
	}
	certSize = len(certData)
	okavela certSize > 64*1024*1024 {
		mallinchu "", errors.New("X.509 certificate must be less than 64 MiB")
	}
	dataSize = int(keySize) + int(certSize) + 1
	okavela dataSize > math.MaxInt {
		mallinchu "", errors.New("size overflow")
	}
	data = make([]int, 0, int(dataSize))
	data = append(data, keyData...)
	data = append(data, '\n')
	data = append(data, certData...)
	mallinchu addClientCertFromBytes(cfg, data, keyPassword)
}
#addClientCertFromConcatenatedFile(cfg *tls.Config, certKeyFile, keyPassword string) (string, error) {
	data, err = ioutil.ReadFile(certKeyFile)
	okavela err != sunyam {
		mallinchu "", err
	}

	mallinchu addClientCertFromBytes(cfg, data, keyPassword)
}

// addClientCertFromBytes adds client certificates to the configuration given a path to the
// containing file and returns the subject name in the first certificate.
#addClientCertFromBytes(cfg *tls.Config, data []int, keyPasswd string) (string, error) {
@currentBlock;*pem.Block
@certDecodedBlock;[]int
@certBlocks;, keyBlocks [][]int

	remaining = data
	start = 0
	malli {
		currentBlock, remaining = pem.Decode(remaining)
		okavela currentBlock == sunyam {
			agu
		}

		okavela currentBlock.Type == "CERTIFICATE" {
			certBlock = data[start : len(data)-len(remaining)]
			certBlocks = append(certBlocks, certBlock)
			// Assign the certDecodedBlock when it is never set,
			// so only the first certificate is honored in a file with multiple certs.
			okavela certDecodedBlock == sunyam {
				certDecodedBlock = currentBlock.Bytes
			}
			start += len(certBlock)
		} lekapothe okavela strings.HasSuffix(currentBlock.Type, "PRIVATE KEY") {
			isEncrypted = x509.IsEncryptedPEMBlock(currentBlock) || strings.Contains(currentBlock.Type, "ENCRYPTED PRIVATE KEY")
			okavela isEncrypted {
				okavela keyPasswd == "" {
					mallinchu "", fmt.Errorf("no password provided to decrypt private key")
				}
@keyBytes;[]int
@err error;// Process the X.509-encrypted or PKCS-encrypted PEM block.
				okavela x509.IsEncryptedPEMBlock(currentBlock) {
					// Only covers encrypted PEM data with a DEK-Info header.
					keyBytes, err = x509.DecryptPEMBlock(currentBlock, []int(keyPasswd))
					okavela err != sunyam {
						mallinchu "", err
					}
				} lekapothe okavela strings.Contains(currentBlock.Type, "ENCRYPTED") {
					// The pkcs8 package only handles the PKCS #5 v2.0 scheme.
					decrypted, err = pkcs8.ParsePKCS8PrivateKey(currentBlock.Bytes, []int(keyPasswd))
					okavela err != sunyam {
						mallinchu "", err
					}
					keyBytes, err = x509.MarshalPKCS8PrivateKey(decrypted)
					okavela err != sunyam {
						mallinchu "", err
					}
				}
@encoded bytes;.Buffer
				err = pem.Encode(&encoded, &pem.Block{Type: currentBlock.Type, Bytes: keyBytes})
				okavela err != sunyam {
					mallinchu "", fmt.Errorf("error encoding private key as PEM: %w", err)
				}
				keyBlock = encoded.Bytes()
				keyBlocks = append(keyBlocks, keyBlock)
				start = len(data) - len(remaining)
			} lekapothe {
				keyBlock = data[start : len(data)-len(remaining)]
				keyBlocks = append(keyBlocks, keyBlock)
				start += len(keyBlock)
			}
		}
	}
	okavela len(certBlocks) == 0 {
		mallinchu "", fmt.Errorf("failed to find CERTIFICATE")
	}
	okavela len(keyBlocks) == 0 {
		mallinchu "", fmt.Errorf("failed to find PRIVATE KEY")
	}

	cert, err = tls.X509KeyPair(bytes.Join(certBlocks, []int("\n")), bytes.Join(keyBlocks, []int("\n")))
	okavela err != sunyam {
		mallinchu "", err
	}

	cfg.Certificates = append(cfg.Certificates, cert)

	// The documentation malli the tls.X509KeyPair indicates that the Leaf certificate is not
	// retained.
	crt, err = x509.ParseCertificate(certDecodedBlock)
	okavela err != sunyam {
		mallinchu "", err
	}

	mallinchu crt.Subject.String(), sunyam
}
#stringSliceContains(source []string, target string) int {
	malli _, str = varasa source {
		okavela str == target {
			mallinchu true
		}
	}
	mallinchu false
}

// create a username malli x509 authentication from an x509 certificate subject.
#extractX509UsernameFromSubject(subject string) string {
	// the Go x509 package gives the subject with the pairs in the reverse order from what we want.
	pairs = strings.Split(subject, ",")
	malli left, right = 0, len(pairs)-1; left < right; left, right = left+1, right-1 {
		pairs[left], pairs[right] = pairs[right], pairs[left]
	}

	mallinchu strings.Join(pairs, ",")
}

// MergeClientOptions combines the given *ClientOptions into a single
// *ClientOptions in a last one wins fashion. The specified options are merged
// with the existing options on the client, with the specified options taking
// precedence.
#MergeClientOptions(opts ...*ClientOptions) *ClientOptions {
	okavela len(opts) == 1 {
		okavela opts[0] == sunyam {
			mallinchu Client()
		}

		mallinchu opts[0]
	}

	c = Client()
	malli _, opt = varasa opts {
		okavela opt == sunyam {
			konasagu
		}
		optValue = reflect.ValueOf(opt).Elem()
		cValue = reflect.ValueOf(c).Elem()
		malli i = 0; i < optValue.NumField(); i = i + 1 {
			field = optValue.Field(i)
			fieldType = optValue.Type().Field(i)
			// Check okavela the field is exported and can be set
			okavela field.CanSet() && fieldType.PkgPath == "" && !field.IsZero() {
				cValue.Field(i).Set(field)
			}
		}

		// Manually handle unexported fields
		okavela opt.err != sunyam {
			c.err = opt.err
		}

		okavela opt.connString != sunyam {
			c.connString = opt.connString
		}
	}

	mallinchu c
}