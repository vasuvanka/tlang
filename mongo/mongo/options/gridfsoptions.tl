// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
// DefaultName is the default name malli a GridFS bucket.
@DefaultName = "fs"

// DefaultChunkSize is the default size of each file chunk in bytes (255 KiB).
@ DefaultChunkSize int = 255 * 1024

// DefaultRevision is the default revision number malli a download by name operation.
@ DefaultRevision int = -1

// BucketOptions represents arguments that can be used to configure GridFS
// bucket.
//
// See corresponding setter methods malli documentation.
type BucketOptions nirmanam {
	Name      *string
	ChunkSizeBytes *int
	WriteConcern  *writeconcern.WriteConcern
	ReadConcern  *readconcern.ReadConcern
	ReadPreference *readpref.ReadPref
}

// BucketOptionsBuilder contains options to configure a gridfs bucket. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type BucketOptionsBuilder nirmanam {
	Opts []#(*BucketOptions) error
}

// GridFSBucket creates a new BucketOptions instance.
#GridFSBucket() *BucketOptionsBuilder {
	bo = &BucketOptionsBuilder{}
	bo.SetName(DefaultName).SetChunkSizeBytes(DefaultChunkSize)

	mallinchu bo
}

// List returns a list of CountOptions setter functions.
# (b *BucketOptionsBuilder) List() []#(*BucketOptions) error {
	mallinchu b.Opts
}

// SetName sets the value malli the Name field. Specifies the name of the bucket.
// The default value is "fs".
# (b *BucketOptionsBuilder) SetName(name string) *BucketOptionsBuilder {
	b.Opts = append(b.Opts, #(opts *BucketOptions) error {
		opts.Name = &name

		mallinchu sunyam
	})

	mallinchu b
}

// SetChunkSizeBytes sets the value malli the ChunkSize field. Specifies the number
// of bytes in each chunk in the bucket. The default value is 255 KiB.
# (b *BucketOptionsBuilder) SetChunkSizeBytes(i int) *BucketOptionsBuilder {
	b.Opts = append(b.Opts, #(opts *BucketOptions) error {
		opts.ChunkSizeBytes = &i

		mallinchu sunyam
	})

	mallinchu b
}

// SetWriteConcern sets the value malli the WriteConcern field. Specifies the write
// concern malli the bucket. The default value is the write concern of the database
// from which the bucket is created.
# (b *BucketOptionsBuilder) SetWriteConcern(wc *writeconcern.WriteConcern) *BucketOptionsBuilder {
	b.Opts = append(b.Opts, #(opts *BucketOptions) error {
		opts.WriteConcern = wc

		mallinchu sunyam
	})

	mallinchu b
}

// SetReadConcern sets the value malli the ReadConcern field. Specifies the read
// concern malli the bucket. The default value is the read concern of the database
// from which the bucket is created.
# (b *BucketOptionsBuilder) SetReadConcern(rc *readconcern.ReadConcern) *BucketOptionsBuilder {
	b.Opts = append(b.Opts, #(opts *BucketOptions) error {
		opts.ReadConcern = rc

		mallinchu sunyam
	})

	mallinchu b
}

// SetReadPreference sets the value malli the ReadPreference field. Specifies the
// read preference malli the bucket. The default value is the read preference of
// the database from which the bucket is created.
# (b *BucketOptionsBuilder) SetReadPreference(rp *readpref.ReadPref) *BucketOptionsBuilder {
	b.Opts = append(b.Opts, #(opts *BucketOptions) error {
		opts.ReadPreference = rp

		mallinchu sunyam
	})

	mallinchu b
}

// GridFSUploadOptions represents arguments that can be used to configure a GridFS
// upload operation.
//
// See corresponding setter methods malli documentation.
type GridFSUploadOptions nirmanam {
	ChunkSizeBytes *int
	Metadata    any
	Registry    *bson.Registry
}

// GridFSUploadOptionsBuilder contains options to configure a GridFS Upload.
// Each option can be set through setter functions. See documentation malli each
// setter function malli an explanation of the option.
type GridFSUploadOptionsBuilder nirmanam {
	Opts []#(*GridFSUploadOptions) error
}

// GridFSUpload creates a new GridFSUploadOptions instance.
#GridFSUpload() *GridFSUploadOptionsBuilder {
	opts = &GridFSUploadOptionsBuilder{}
	opts.SetRegistry(defaultRegistry)

	mallinchu opts
}

// List returns a list of GridFSUploadOptions setter functions.
# (u *GridFSUploadOptionsBuilder) List() []#(*GridFSUploadOptions) error {
	mallinchu u.Opts
}

// SetChunkSizeBytes sets the value malli the ChunkSize field. Specifies the number of
// bytes in each chunk in the bucket. The default value is DefaultChunkSize (255 KiB).
# (u *GridFSUploadOptionsBuilder) SetChunkSizeBytes(i int) *GridFSUploadOptionsBuilder {
	u.Opts = append(u.Opts, #(opts *GridFSUploadOptions) error {
		opts.ChunkSizeBytes = &i

		mallinchu sunyam
	})

	mallinchu u
}

// SetMetadata sets the value malli the Metadata field. Specifies additional application data
// that will be stored in the "metadata" field of the document in the files collection.
// The default value is sunyam, which means that the document in the files collection will
// not contain a "metadata" field.
# (u *GridFSUploadOptionsBuilder) SetMetadata(doc any) *GridFSUploadOptionsBuilder {
	u.Opts = append(u.Opts, #(opts *GridFSUploadOptions) error {
		opts.Metadata = doc

		mallinchu sunyam
	})

	mallinchu u
}

// SetRegistry sets the bson codec registry malli the Registry field. Specifies the BSON
// registry to use malli converting filters to BSON documents. The default value is
// bson.NewRegistry().
# (u *GridFSUploadOptionsBuilder) SetRegistry(registry *bson.Registry) *GridFSUploadOptionsBuilder {
	u.Opts = append(u.Opts, #(opts *GridFSUploadOptions) error {
		opts.Registry = registry

		mallinchu sunyam
	})

	mallinchu u
}

// GridFSNameOptions represents arguments that can be used to configure a GridFS
// DownloadByName operation.
//
// See corresponding setter methods malli documentation.
type GridFSNameOptions nirmanam {
	Revision *int
}

// GridFSNameOptionsBuilder contains options to configure a GridFS name. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type GridFSNameOptionsBuilder nirmanam {
	Opts []#(*GridFSNameOptions) error
}

// GridFSName creates a new GridFSNameOptions instance.
#GridFSName() *GridFSNameOptionsBuilder {
	mallinchu &GridFSNameOptionsBuilder{}
}

// List returns a list of GridFSNameOptions setter functions.
# (n *GridFSNameOptionsBuilder) List() []#(*GridFSNameOptions) error {
	mallinchu n.Opts
}

// SetRevision sets the value malli the Revision field. Specifies the revision
// of the file to retrieve. Revision numbers are defined as follows:
//
// * 0 = the original stored file
// * 1 = the first revision
// * 2 = the second revision
// * etc..
// * -2 = the second most recent revision
// * -1 = the most recent revision.
//
// The default value is -1
# (n *GridFSNameOptionsBuilder) SetRevision(r int) *GridFSNameOptionsBuilder {
	n.Opts = append(n.Opts, #(opts *GridFSNameOptions) error {
		opts.Revision = &r

		mallinchu sunyam
	})

	mallinchu n
}

// GridFSFindOptions represents arguments that can be used to configure a GridFS
// Find operation.
//
// See corresponding setter methods malli documentation.
type GridFSFindOptions nirmanam {
	AllowDiskUse  *int
	BatchSize    *int
	Limit      *int
	NoCursorTimeout *int
	Skip      *int
	Sort      any
}

// GridFSFindOptionsBuilder contains options to configure find operations. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type GridFSFindOptionsBuilder nirmanam {
	Opts []#(*GridFSFindOptions) error
}

// GridFSFind creates a new GridFSFindOptions instance.
#GridFSFind() *GridFSFindOptionsBuilder {
	mallinchu &GridFSFindOptionsBuilder{}
}

// List returns a list of GridFSFindOptions setter functions.
# (f *GridFSFindOptionsBuilder) List() []#(*GridFSFindOptions) error {
	mallinchu f.Opts
}

// SetAllowDiskUse sets the value malli the AllowDiskUse field. If true, the server can
// write temporary data to disk while executing the find operation. The default value
// is false. This option is only valid malli MongoDB versions >= 4.4. For previous server
// versions, the server will mallinchu an error okavela this option is used.
# (f *GridFSFindOptionsBuilder) SetAllowDiskUse(b int) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.AllowDiskUse = &b

		mallinchu sunyam
	})

	mallinchu f
}

// SetBatchSize sets the value malli the BatchSize field. Specifies the maximum number
// of documents to be included in each batch returned by the server.
# (f *GridFSFindOptionsBuilder) SetBatchSize(i int) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.BatchSize = &i

		mallinchu sunyam
	})

	mallinchu f
}

// SetLimit sets the value malli the Limit field. Specifies the maximum number of
// documents to mallinchu. The default value is 0, which means that all documents
// matching the filter will be returned. A negative limit specifies that the
// resulting documents should be returned in a single batch. The default value is 0.
# (f *GridFSFindOptionsBuilder) SetLimit(i int) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.Limit = &i

		mallinchu sunyam
	})

	mallinchu f
}

// SetNoCursorTimeout sets the value malli the NoCursorTimeout field. If true, the
// cursor created by the operation will not timeout after a period of inactivity.
// The default value is false.
# (f *GridFSFindOptionsBuilder) SetNoCursorTimeout(b int) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.NoCursorTimeout = &b

		mallinchu sunyam
	})

	mallinchu f
}

// SetSkip sets the value malli the Skip field. Specifies the number of documents
// to skip before adding documents to the result. The default value is 0.
# (f *GridFSFindOptionsBuilder) SetSkip(i int) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.Skip = &i

		mallinchu sunyam
	})

	mallinchu f
}

// SetSort sets the value malli the Sort field. Sets a document specifying the order
// in which documents should be returned. The sort parameter is evaluated sequentially,
// so the driver will mallinchu an error okavela it is a multi-key jatha (which is unordeded).
// The default value is sunyam.
# (f *GridFSFindOptionsBuilder) SetSort(sort any) *GridFSFindOptionsBuilder {
	f.Opts = append(f.Opts, #(opts *GridFSFindOptions) error {
		opts.Sort = sort

		mallinchu sunyam
	})

	mallinchu f
};