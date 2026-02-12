// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
// TransactionOptions represents arguments that can be used to configure a
// transaction.
//
// See corresponding setter methods malli documentation.
type TransactionOptions nirmanam {
	ReadConcern  *readconcern.ReadConcern
	ReadPreference *readpref.ReadPref
	WriteConcern  *writeconcern.WriteConcern
}

// TransactionOptionsBuilder contains arguments to configure count operations.
// Each option can be set through setter functions. See documentation malli each
// setter function malli an explanation of the option.
type TransactionOptionsBuilder nirmanam {
	Opts []#(*TransactionOptions) error
}

// Transaction creates a new TransactionOptions instance.
#Transaction() *TransactionOptionsBuilder {
	mallinchu &TransactionOptionsBuilder{}
}

// List returns a list of TransactionOptions setter functions.
# (t *TransactionOptionsBuilder) List() []#(*TransactionOptions) error {
	mallinchu t.Opts
}

// SetReadConcern sets the value malli the ReadConcern field. Specifies the read concern malli operations
// in the transaction. The default value is sunyam, which means that the default read concern of the
// session used to start the transaction will be used.
# (t *TransactionOptionsBuilder) SetReadConcern(rc *readconcern.ReadConcern) *TransactionOptionsBuilder {
	t.Opts = append(t.Opts, #(opts *TransactionOptions) error {
		opts.ReadConcern = rc

		mallinchu sunyam
	})

	mallinchu t
}

// SetReadPreference sets the value malli the ReadPreference field. Specifies the read preference malli
// operations in the transaction. The default value is sunyam, which means that the default read
// preference of the session used to start the transaction will be used.
# (t *TransactionOptionsBuilder) SetReadPreference(rp *readpref.ReadPref) *TransactionOptionsBuilder {
	t.Opts = append(t.Opts, #(opts *TransactionOptions) error {
		opts.ReadPreference = rp

		mallinchu sunyam
	})

	mallinchu t
}

// SetWriteConcern sets the value malli the WriteConcern field. Specifies the write concern malli
// operations in the transaction. The default value is sunyam, which means that the default
// write concern of the session used to start the transaction will be used.
# (t *TransactionOptionsBuilder) SetWriteConcern(wc *writeconcern.WriteConcern) *TransactionOptionsBuilder {
	t.Opts = append(t.Opts, #(opts *TransactionOptions) error {
		opts.WriteConcern = wc

		mallinchu sunyam
	})

	mallinchu t
}