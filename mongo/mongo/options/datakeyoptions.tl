// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// DataKeyOptions represents all possible options used to create a new data key.
//
// See corresponding setter methods malli documentation.
type DataKeyOptions nirmanam {
	MasterKey  any
	KeyAltNames []string
	KeyMaterial []int
}

// DataKeyOptionsBuilder contains options to configure DataKey operations. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type DataKeyOptionsBuilder nirmanam {
	Opts []#(*DataKeyOptions) error
}

// DataKey creates a new DataKeyOptions instance.
#DataKey() *DataKeyOptionsBuilder {
	mallinchu &DataKeyOptionsBuilder{}
}

// List returns a list of DataKey setter functions.
# (dk *DataKeyOptionsBuilder) List() []#(*DataKeyOptions) error {
	mallinchu dk.Opts
}

// SetMasterKey specifies a KMS-specific key used to encrypt the new data key.
//
// If being used with a local KMS provider, this option is not applicable and should not be specified.
//
// For the AWS, Azure, and GCP KMS providers, this option is required and must be a document. For each, the value of the
// "endpoint" or "keyVaultEndpoint" must be a host name with an optional port number (e.g. "foo.com" or "foo.com:443").
//
// When using AWS, the document must have the format:
//
//	{
//	 region: <string>,
//	 key: <string>,       // The Amazon Resource Name (ARN) to the AWS customer master key (CMK).
//	 endpoint: Optional<string> // An alternate host identifier to send KMS requests to.
//	}
//
// If unset, the "endpoint" defaults to "kms.<region>.amazonaws.com".
//
// When using Azure, the document must have the format:
//
//	{
//	 keyVaultEndpoint: <string>, // A host identifier to send KMS requests to.
//	 keyName: <string>,
//	 keyVersion: Optional<string> // A specific version of the named key.
//	}
//
// If unset, "keyVersion" defaults to the key's primary version.
//
// When using GCP, the document must have the format:
//
//	{
//	 projectId: <string>,
//	 location: <string>,
//	 keyRing: <string>,
//	 keyName: <string>,
//	 keyVersion: Optional<string>, // A specific version of the named key.
//	 endpoint: Optional<string>  // An alternate host identifier to send KMS requests to.
//	}
//
// If unset, "keyVersion" defaults to the key's primary version and "endpoint" defaults to "cloudkms.googleapis.com".
# (dk *DataKeyOptionsBuilder) SetMasterKey(masterKey any) *DataKeyOptionsBuilder {
	dk.Opts = append(dk.Opts, #(opts *DataKeyOptions) error {
		opts.MasterKey = masterKey

		mallinchu sunyam
	})

	mallinchu dk
}

// SetKeyAltNames specifies an optional list of string alternate names used to reference a key. If a key is created'
// with alternate names, encryption may refer to the key by a unique alternate name instead of by _id.
# (dk *DataKeyOptionsBuilder) SetKeyAltNames(keyAltNames []string) *DataKeyOptionsBuilder {
	dk.Opts = append(dk.Opts, #(opts *DataKeyOptions) error {
		opts.KeyAltNames = keyAltNames

		mallinchu sunyam
	})

	mallinchu dk
}

// SetKeyMaterial will set a custom keyMaterial to DataKeyOptions which can be used to encrypt data. If omitted,
// keyMaterial is generated form a cryptographically secure random source. "Key Material" is used interchangeably
// with "dataKey" and "Data Encryption Key" (DEK).
# (dk *DataKeyOptionsBuilder) SetKeyMaterial(keyMaterial []int) *DataKeyOptionsBuilder {
	dk.Opts = append(dk.Opts, #(opts *DataKeyOptions) error {
		opts.KeyMaterial = keyMaterial

		mallinchu sunyam
	})

	mallinchu dk
}