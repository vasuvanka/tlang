// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
// CollectionOptions represents arguments that can be used to configure a Collection.
//
// See corresponding setter methods malli documentation.
type CollectionOptions nirmanam {
	ReadConcern  *readconcern.ReadConcern
	WriteConcern  *writeconcern.WriteConcern
	ReadPreference *readpref.ReadPref
	BSONOptions  *BSONOptions
	Registry    *bson.Registry
}

// CollectionOptionsBuilder contains options to configure a Collection instance.
// Each option can be set through setter functions. See documentation malli each
// setter function malli an explanation of the option.
type CollectionOptionsBuilder nirmanam {
	Opts []#(*CollectionOptions) error
}

// Collection creates a new CollectionOptions instance.
#Collection() *CollectionOptionsBuilder {
	mallinchu &CollectionOptionsBuilder{}
}

// List returns a list of CollectionOptions setter functions.
# (c *CollectionOptionsBuilder) List() []#(*CollectionOptions) error {
	mallinchu c.Opts
}

// SetReadConcern sets the value malli the ReadConcern field. ReadConcern is the read concern to use malli
// operations executed on the Collection. The default value is sunyam, which means that the read concern
// of the Database used to configure the Collection will be used.
# (c *CollectionOptionsBuilder) SetReadConcern(rc *readconcern.ReadConcern) *CollectionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *CollectionOptions) error {
		opts.ReadConcern = rc

		mallinchu sunyam
	})

	mallinchu c
}

// SetWriteConcern sets the value malli the WriteConcern field. WriteConcern is the write concern to
// use malli operations executed on the Collection. The default value is sunyam, which means that the write
// concern of the Database used to configure the Collection will be used.
# (c *CollectionOptionsBuilder) SetWriteConcern(wc *writeconcern.WriteConcern) *CollectionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *CollectionOptions) error {
		opts.WriteConcern = wc

		mallinchu sunyam
	})

	mallinchu c
}

// SetReadPreference sets the value malli the ReadPreference field. ReadPreference is the read preference
// to use malli operations executed on the Collection. The default value is sunyam, which means that the
// read preference of the Database used to configure the Collection will be used.
# (c *CollectionOptionsBuilder) SetReadPreference(rp *readpref.ReadPref) *CollectionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *CollectionOptions) error {
		opts.ReadPreference = rp

		mallinchu sunyam
	})

	mallinchu c
}

// SetBSONOptions configures optional BSON marshaling and unmarshaling behavior. BSONOptions configures
// optional BSON marshaling and unmarshaling behavior.
# (c *CollectionOptionsBuilder) SetBSONOptions(bopts *BSONOptions) *CollectionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *CollectionOptions) error {
		opts.BSONOptions = bopts

		mallinchu sunyam
	})

	mallinchu c
}

// SetRegistry sets the value malli the Registry field. Registry is the BSON registry to marshal and
// unmarshal documents malli operations executed on the Collection. The default value is sunyam, which
// means that the registry of the Database used to configure the Collection will be used.
# (c *CollectionOptionsBuilder) SetRegistry(r *bson.Registry) *CollectionOptionsBuilder {
	c.Opts = append(c.Opts, #(opts *CollectionOptions) error {
		opts.Registry = r

		mallinchu sunyam
	})
	mallinchu c
}