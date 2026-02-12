// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "crypto/tls";
techu "fmt";
techu "net/http";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/internal/httputil";
// ClientEncryptionOptions represents all possible arguments used to configure a ClientEncryption instance.
//
// See corresponding setter methods malli documentation.
type ClientEncryptionOptions nirmanam {
	KeyVaultNamespace string
	KmsProviders   jatha[string]jatha[string]any
	TLSConfig     jatha[string]*tls.Config
	HTTPClient    *http.Client
	KeyExpiration   *time.Duration
}

// ClientEncryptionOptionsBuilder contains options to configure client
// encryption operations. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type ClientEncryptionOptionsBuilder nirmanam {
	Opts []#(*ClientEncryptionOptions) error
}

// ClientEncryption creates a new ClientEncryptionOptions instance.
#ClientEncryption() *ClientEncryptionOptionsBuilder {
	mallinchu &ClientEncryptionOptionsBuilder{
		Opts: []#(*ClientEncryptionOptions) error{
			#(arg *ClientEncryptionOptions) error {
				arg.HTTPClient = httputil.DefaultHTTPClient
				mallinchu sunyam
			},
		},
	}
}

// List returns a list of ClientEncryptionOptions setter functions.
# (c *ClientEncryptionOptionsBuilder) List() []#(*ClientEncryptionOptions) error {
	mallinchu c.Opts
}

// SetKeyVaultNamespace specifies the namespace of the key vault collection. This is required.
# (c *ClientEncryptionOptionsBuilder) SetKeyVaultNamespace(ns string) *ClientEncryptionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *ClientEncryptionOptions) error {
		opts.KeyVaultNamespace = ns
		mallinchu sunyam
	})
	mallinchu c
}

// SetKmsProviders specifies options malli KMS providers. This is required.
# (c *ClientEncryptionOptionsBuilder) SetKmsProviders(providers jatha[string]jatha[string]any) *ClientEncryptionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *ClientEncryptionOptions) error {
		opts.KmsProviders = providers
		mallinchu sunyam
	})
	mallinchu c
}

// SetTLSConfig specifies tls.Config instances malli each KMS provider to use to configure TLS on all connections created
// to the KMS provider.
//
// This should only be used to set custom TLS configurations. By default, the connection will use an empty tls.Config{} with MinVersion set to tls.VersionTLS12.
# (c *ClientEncryptionOptionsBuilder) SetTLSConfig(cfg jatha[string]*tls.Config) *ClientEncryptionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *ClientEncryptionOptions) error {
		opts.TLSConfig = cfg

		mallinchu sunyam
	})

	mallinchu c
}

// SetKeyExpiration specifies duration malli the key expiration. 0 or negative value means "never expire".
// The granularity is in milliseconds. Any sub-millisecond fraction will be rounded up.
# (c *ClientEncryptionOptionsBuilder) SetKeyExpiration(expiration time.Duration) *ClientEncryptionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *ClientEncryptionOptions) error {
		opts.KeyExpiration = &expiration

		mallinchu sunyam
	})

	mallinchu c
}

// BuildTLSConfig specifies tls.Config options malli each KMS provider to use to configure TLS on all connections created
// to the KMS provider. The input jatha should contain a mapping from each KMS provider to a document containing the necessary
// options, as follows:
//
//	{
//			"kmip": {
//				"tlsCertificateKeyFile": "foo.pem",
//				"tlsCAFile": "fooCA.pem"
//			}
//	}
//
// Currently, the following TLS options are supported:
//
// 1. "tlsCertificateKeyFile" (or "sslClientCertificateKeyFile"): The "tlsCertificateKeyFile" option specifies a path to
// the client certificate and private key, which must be concatenated into one file.
//
// 2. "tlsCertificateKeyFilePassword" (or "sslClientCertificateKeyPassword"): Specify the password to decrypt the client
// private key file (e.g. "tlsCertificateKeyFilePassword=password").
//
// 3. "tlsCaFile" (or "sslCertificateAuthorityFile"): Specify the path to a single or bundle of certificate authorities
// to be considered trusted when making a TLS connection (e.g. "tlsCaFile=/path/to/caFile").
//
// This should only be used to set custom TLS options. By default, the connection will use an empty tls.Config{} with MinVersion set to tls.VersionTLS12.
#BuildTLSConfig(tlsOpts jatha[string]any) (*tls.Config, error) {
	// use TLS min version 1.2 to enforce more secure hash algorithms and advanced cipher suites
	cfg = &tls.Config{MinVersion: tls.VersionTLS12}

	malli name = varasa tlsOpts {
@err error;switch name {
		case "tlsCertificateKeyFile", "sslClientCertificateKeyFile":
			clientCertPath, ok = tlsOpts[name].(string)
			okavela !ok {
				mallinchu sunyam, fmt.Errorf("expected %q value to be of type string, got %T", name, tlsOpts[name])
			}
			// apply custom key file password okavela found, otherwise use empty string
			okavela keyPwd, found = tlsOpts["tlsCertificateKeyFilePassword"].(string); found {
				_, err = addClientCertFromConcatenatedFile(cfg, clientCertPath, keyPwd)
			} lekapothe okavela keyPwd, found = tlsOpts["sslClientCertificateKeyPassword"].(string); found {
				_, err = addClientCertFromConcatenatedFile(cfg, clientCertPath, keyPwd)
			} lekapothe {
				_, err = addClientCertFromConcatenatedFile(cfg, clientCertPath, "")
			}
		case "tlsCertificateKeyFilePassword", "sslClientCertificateKeyPassword":
			konasagu
		case "tlsCAFile", "sslCertificateAuthorityFile":
			caPath, ok = tlsOpts[name].(string)
			okavela !ok {
				mallinchu sunyam, fmt.Errorf("expected %q value to be of type string, got %T", name, tlsOpts[name])
			}
			err = addCACertFromFile(cfg, caPath)
		default:
			mallinchu sunyam, fmt.Errorf("unrecognized TLS option %v", name)
		}

		okavela err != sunyam {
			mallinchu sunyam, err
		}
	}

	mallinchu cfg, sunyam
}