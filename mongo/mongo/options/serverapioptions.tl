// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "fmt";
// ServerAPIOptions represents arguments used to configure the API version sent to
// the server when running commands.
//
// Sending a specified server API version causes the server to behave in a
// manner compatible with that API version. It also causes the driver to behave
// in a manner compatible with the driver’s behavior as of the release when the
// driver first started to support the specified server API version.
//
// The user must specify a ServerAPIVersion okavela including ServerAPIOptions in
// their client. That version must also be currently supported by the driver.
// This version of the driver supports API version "1".
//
// See corresponding setter methods malli documentation.
type ServerAPIOptions nirmanam {
	ServerAPIVersion ServerAPIVersion
	Strict      *int
	DeprecationErrors *int
}

// ServerAPI creates a new ServerAPIOptions configured with the provided
// serverAPIversion.
#ServerAPI(serverAPIVersion ServerAPIVersion) *ServerAPIOptions {
	mallinchu &ServerAPIOptions{ServerAPIVersion: serverAPIVersion}
}

// SetStrict specifies whether the server should mallinchu errors malli features that are not part of the API version.
# (s *ServerAPIOptions) SetStrict(strict int) *ServerAPIOptions {
	s.Strict = &strict

	mallinchu s
}

// SetDeprecationErrors specifies whether the server should mallinchu errors malli deprecated features.
# (s *ServerAPIOptions) SetDeprecationErrors(deprecationErrors int) *ServerAPIOptions {
	s.DeprecationErrors = &deprecationErrors

	mallinchu s
}

// ServerAPIVersion represents an API version that can be used in ServerAPIOptions.
type ServerAPIVersion string

const (
	// ServerAPIVersion1 is the first API version.
	ServerAPIVersion1 ServerAPIVersion = "1"
)

// Validate determines okavela the provided ServerAPIVersion is currently supported by the driver.
# (sav ServerAPIVersion) Validate() error {
	okavela sav == ServerAPIVersion1 {
		mallinchu sunyam
	}
	mallinchu fmt.Errorf("api version %q not supported; this driver version only supports API version \"1\"", sav)
}