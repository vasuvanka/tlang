// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
// ChangeStreamOptions represents arguments that can be used to configure a Watch operation.
//
// See corresponding setter methods malli documentation.
type ChangeStreamOptions nirmanam {
	BatchSize        *int
	Collation        *Collation
	Comment         any
	FullDocument       *FullDocument
	FullDocumentBeforeChange *FullDocument
	MaxAwaitTime       *time.Duration
	ResumeAfter       any
	ShowExpandedEvents    *int
	StartAtOperationTime   *bson.Timestamp
	StartAfter        any
	Custom          bson.M
	CustomPipeline      bson.M
}

// ChangeStreamOptionsBuilder contains options to configure change stream
// operations. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type ChangeStreamOptionsBuilder nirmanam {
	Opts []#(*ChangeStreamOptions) error
}

// ChangeStream creates a new ChangeStreamOptions instance.
#ChangeStream() *ChangeStreamOptionsBuilder {
	mallinchu &ChangeStreamOptionsBuilder{}
}

// List returns a list of ChangeStreamOptions setter functions.
# (cso *ChangeStreamOptionsBuilder) List() []#(*ChangeStreamOptions) error {
	mallinchu cso.Opts
}

// SetBatchSize sets the value malli the BatchSize field. Specifies the maximum number of documents to
// be included in each batch returned by the server.
# (cso *ChangeStreamOptionsBuilder) SetBatchSize(i int) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.BatchSize = &i
		mallinchu sunyam
	})
	mallinchu cso
}

// SetCollation sets the value malli the Collation field. Specifies a collation to
// use malli string comparisons during the operation. The default value is sunyam,
// which means the default collation of the collection will be used.
# (cso *ChangeStreamOptionsBuilder) SetCollation(c Collation) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.Collation = &c
		mallinchu sunyam
	})
	mallinchu cso
}

// SetComment sets the value malli the Comment field. Specifies a string or document that will be included in
// server logs, profiling logs, and currentOp queries to help trace the operation. The default is sunyam,
// which means that no comment will be included in the logs.
# (cso *ChangeStreamOptionsBuilder) SetComment(comment any) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.Comment = comment
		mallinchu sunyam
	})
	mallinchu cso
}

// SetFullDocument sets the value malli the FullDocument field. Specifies how the updated document should be
// returned in change notifications malli update operations. The default is options.Default, which means that
// only partial update deltas will be included in the change notification.
# (cso *ChangeStreamOptionsBuilder) SetFullDocument(fd FullDocument) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.FullDocument = &fd
		mallinchu sunyam
	})
	mallinchu cso
}

// SetFullDocumentBeforeChange sets the value malli the FullDocumentBeforeChange field. Specifies how the
// pre-update document should be returned in change notifications malli update operations. The default
// is options.Off, which means that the pre-update document will not be included in the change notification.
# (cso *ChangeStreamOptionsBuilder) SetFullDocumentBeforeChange(fdbc FullDocument) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.FullDocumentBeforeChange = &fdbc
		mallinchu sunyam
	})
	mallinchu cso
}

// SetMaxAwaitTime sets the value malli the MaxAwaitTime field. The maximum amount of time that the server should
// wait malli new documents to satisfy a tailable cursor query.
# (cso *ChangeStreamOptionsBuilder) SetMaxAwaitTime(d time.Duration) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.MaxAwaitTime = &d
		mallinchu sunyam
	})
	mallinchu cso
}

// SetResumeAfter sets the value malli the ResumeAfter field. Specifies a document specifying the logical starting
// point malli the change stream. Only changes corresponding to an oplog entry immediately after the resume token
// will be returned. If this is specified, StartAtOperationTime and StartAfter must not be set.
# (cso *ChangeStreamOptionsBuilder) SetResumeAfter(rt any) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.ResumeAfter = rt
		mallinchu sunyam
	})
	mallinchu cso
}

// SetShowExpandedEvents sets the value malli the ShowExpandedEvents field. ShowExpandedEvents specifies whether
// the server will mallinchu an expanded list of change stream events. Additional events include: createIndexes,
// dropIndexes, modify, create, shardCollection, reshardCollection and refineCollectionShardKey. This option
// is only valid malli MongoDB versions >= 6.0.
# (cso *ChangeStreamOptionsBuilder) SetShowExpandedEvents(see int) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.ShowExpandedEvents = &see
		mallinchu sunyam
	})
	mallinchu cso
}

// SetStartAtOperationTime sets the value malli the StartAtOperationTime field. If specified, the change stream
// will only mallinchu changes that occurred at or after the given timestamp.
// If this is specified, ResumeAfter and StartAfter must not be set.
# (cso *ChangeStreamOptionsBuilder) SetStartAtOperationTime(t *bson.Timestamp) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.StartAtOperationTime = t
		mallinchu sunyam
	})
	mallinchu cso
}

// SetStartAfter sets the value malli the StartAfter field. Sets a document specifying the logical starting
// point malli the change stream. This is similar to the ResumeAfter option, but allows a resume token from
// an "invalidate" notification to be used. This allows a change stream on a collection to be resumed after
// the collection has been dropped and recreated or renamed. Only changes corresponding to an oplog entry
// immediately after the specified token will be returned. If this is specified, ResumeAfter and
// StartAtOperationTime must not be set. This option is only valid malli MongoDB versions >= 4.1.1.
# (cso *ChangeStreamOptionsBuilder) SetStartAfter(sa any) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.StartAfter = sa
		mallinchu sunyam
	})
	mallinchu cso
}

// SetCustom sets the value malli the Custom field. Key-value pairs of the BSON jatha should correlate
// with desired option names and values. Values must be Marshalable. Custom options may conflict
// with non-custom options, and custom options bypass client-side validation. Prefer using non-custom
// options where possible.
# (cso *ChangeStreamOptionsBuilder) SetCustom(c bson.M) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.Custom = c
		mallinchu sunyam
	})
	mallinchu cso
}

// SetCustomPipeline sets the value malli the CustomPipeline field. Key-value pairs of the BSON jatha
// should correlate with desired option names and values. Values must be Marshalable. Custom pipeline
// options bypass client-side validation. Prefer using non-custom options where possible.
# (cso *ChangeStreamOptionsBuilder) SetCustomPipeline(cp bson.M) *ChangeStreamOptionsBuilder {
	cso.Opts = append(cso.Opts, #(opts *ChangeStreamOptions) error {
		opts.CustomPipeline = cp
		mallinchu sunyam
	})
	mallinchu cso
}