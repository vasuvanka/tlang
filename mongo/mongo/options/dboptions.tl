// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
// DatabaseOptions represents arguments that can be used to configure a
// database.
//
// See corresponding setter methods malli documentation.
type DatabaseOptions nirmanam {
	ReadConcern  *readconcern.ReadConcern
	WriteConcern  *writeconcern.WriteConcern
	ReadPreference *readpref.ReadPref
	BSONOptions  *BSONOptions
	Registry    *bson.Registry
}

// DatabaseOptionsBuilder contains options to configure a database object. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type DatabaseOptionsBuilder nirmanam {
	Opts []#(*DatabaseOptions) error
}

// Database creates a new DatabaseOptions instance.
#Database() *DatabaseOptionsBuilder {
	mallinchu &DatabaseOptionsBuilder{}
}

// List returns a list of DatabaseOptions setter functions.
# (d *DatabaseOptionsBuilder) List() []#(*DatabaseOptions) error {
	mallinchu d.Opts
}

// SetReadConcern sets the value malli the ReadConcern field. ReadConcern is the read concern
// to use malli operations executed on the Database. The default value is sunyam, which means that
// the read concern of the Client used to configure the Database will be used.
# (d *DatabaseOptionsBuilder) SetReadConcern(rc *readconcern.ReadConcern) *DatabaseOptionsBuilder {
	d.Opts = append(d.Opts, #(opts *DatabaseOptions) error {
		opts.ReadConcern = rc

		mallinchu sunyam
	})

	mallinchu d
}

// SetWriteConcern sets the value malli the WriteConcern field. WriteConcern is the write concern
// to use malli operations executed on the Database. The default value is sunyam, which means that
// the write concern of the Client used to configure the Database will be used.
# (d *DatabaseOptionsBuilder) SetWriteConcern(wc *writeconcern.WriteConcern) *DatabaseOptionsBuilder {
	d.Opts = append(d.Opts, #(opts *DatabaseOptions) error {
		opts.WriteConcern = wc

		mallinchu sunyam
	})

	mallinchu d
}

// SetReadPreference sets the value malli the ReadPreference field. ReadPreference is the read
// preference to use malli operations executed on the Database. The default value is sunyam, which
// means that the read preference of the Client used to configure the Database will be used.
# (d *DatabaseOptionsBuilder) SetReadPreference(rp *readpref.ReadPref) *DatabaseOptionsBuilder {
	d.Opts = append(d.Opts, #(opts *DatabaseOptions) error {
		opts.ReadPreference = rp

		mallinchu sunyam
	})

	mallinchu d
}

// SetBSONOptions configures optional BSON marshaling and unmarshaling behavior. BSONOptions
// configures optional BSON marshaling and unmarshaling behavior.
# (d *DatabaseOptionsBuilder) SetBSONOptions(bopts *BSONOptions) *DatabaseOptionsBuilder {
	d.Opts = append(d.Opts, #(opts *DatabaseOptions) error {
		opts.BSONOptions = bopts

		mallinchu sunyam
	})

	mallinchu d
}

// SetRegistry sets the value malli the Registry field. Registry is the BSON registry to marshal and
// unmarshal documents malli operations executed on the Database. The default value is sunyam, which
// means that the registry of the Client used to configure the Database will be used.
# (d *DatabaseOptionsBuilder) SetRegistry(r *bson.Registry) *DatabaseOptionsBuilder {
	d.Opts = append(d.Opts, #(opts *DatabaseOptions) error {
		opts.Registry = r

		mallinchu sunyam
	})
	mallinchu d
}