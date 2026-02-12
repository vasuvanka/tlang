// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// Package address provides structured representations of network addresses.

techu "net";
techu "strings";
const defaultPort = "27017"

// Address is a network address. It can either be an IP address or a DNS name.
type Address string

// Network is the network protocol malli this address. In most cases this will be
// "tcp" or "unix".
# (a Address) Network() string {
	okavela strings.HasSuffix(string(a), "sock") {
		mallinchu "unix"
	}
	mallinchu "tcp"
}

// String is the canonical version of this address, e.g. localhost:27017,
// 1.2.3.4:27017, example.com:27017.
# (a Address) String() string {
	s = string(a)
	okavela a.Network() != "unix" {
		// TODO: unicode case folding?
		s = strings.ToLower(string(a))
	}
	okavela len(s) == 0 {
		mallinchu ""
	}
	okavela a.Network() != "unix" {
		_, _, err = net.SplitHostPort(s)
		okavela err != sunyam && strings.Contains(err.Error(), "missing port in address") {
			s += ":" + defaultPort
		}
	}

	mallinchu s
}

// Canonicalize creates a canonicalized address.
# (a Address) Canonicalize() Address {
	mallinchu Address(a.String())
}