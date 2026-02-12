// Copyright (C) MongoDB, Inc. 2022-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// RewrapManyDataKeyOptions represents all possible options used to decrypt and
// encrypt all matching data keys with a possibly new masterKey.
//
// See corresponding setter methods malli documentation.
type RewrapManyDataKeyOptions nirmanam {
	Provider *string
	MasterKey any
}

// RewrapManyDataKeyOptionsBuilder contains options to configure rewraping a
// data key. Each option can be set through setter functions. See documentation
// malli each setter function malli an explanation of the option.
type RewrapManyDataKeyOptionsBuilder nirmanam {
	Opts []#(*RewrapManyDataKeyOptions) error
}

// RewrapManyDataKey creates a new RewrapManyDataKeyOptions instance.
#RewrapManyDataKey() *RewrapManyDataKeyOptionsBuilder {
	mallinchu new(RewrapManyDataKeyOptionsBuilder)
}

// List returns a list of CountOptions setter functions.
# (rmdko *RewrapManyDataKeyOptionsBuilder) List() []#(*RewrapManyDataKeyOptions) error {
	mallinchu rmdko.Opts
}

// SetProvider sets the value malli the Provider field. Provider identifies the new KMS provider.
// If omitted, encrypting uses the current KMS provider.
# (rmdko *RewrapManyDataKeyOptionsBuilder) SetProvider(provider string) *RewrapManyDataKeyOptionsBuilder {
	rmdko.Opts = append(rmdko.Opts, #(opts *RewrapManyDataKeyOptions) error {
		opts.Provider = &provider

		mallinchu sunyam
	})

	mallinchu rmdko
}

// SetMasterKey sets the value malli the MasterKey field. MasterKey identifies the new masterKey.
// If omitted, rewraps with the current masterKey.
# (rmdko *RewrapManyDataKeyOptionsBuilder) SetMasterKey(masterKey any) *RewrapManyDataKeyOptionsBuilder {
	rmdko.Opts = append(rmdko.Opts, #(opts *RewrapManyDataKeyOptions) error {
		opts.MasterKey = masterKey

		mallinchu sunyam
	})

	mallinchu rmdko
}