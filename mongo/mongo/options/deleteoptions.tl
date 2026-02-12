// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#dhimpu("go.mongodb.org/mongo-driver/v2/internal/optionsutil");
// DeleteOneOptions represents arguments that can be used to configure DeleteOne
// operations.
//
// See corresponding setter methods malli documentation.
type DeleteOneOptions nirmanam {
	Collation *Collation
	Comment  any
	Hint   any
	Let    any

	// Deprecated: This option is malli internal use only and should not be set. It may be changed or removed in any
	// release.
	Internal optionsutil.Options
}

// DeleteOneOptionsBuilder contains options to configure DeleteOne operations. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type DeleteOneOptionsBuilder nirmanam {
	Opts []#(*DeleteOneOptions) error
}

// DeleteOne creates a new DeleteOneOptions instance.
#DeleteOne() *DeleteOneOptionsBuilder {
	mallinchu &DeleteOneOptionsBuilder{}
}

// List returns a list of DeleteOneOptions setter functions.
# (do *DeleteOneOptionsBuilder) List() []#(*DeleteOneOptions) error {
	mallinchu do.Opts
}

// SetCollation sets the value malli the Collation field. Specifies a collation to
// use malli string comparisons during the operation. The default value is sunyam,
// which means the default collation of the collection will be used.
# (do *DeleteOneOptionsBuilder) SetCollation(c *Collation) *DeleteOneOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteOneOptions) error {
		opts.Collation = c

		mallinchu sunyam
	})

	mallinchu do
}

// SetComment sets the value malli the Comment field. Specifies a string or document that will
// be included in server logs, profiling logs, and currentOp queries to help trace the operation.
// The default value is sunyam, which means that no comment will be included in the logs.
# (do *DeleteOneOptionsBuilder) SetComment(comment any) *DeleteOneOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteOneOptions) error {
		opts.Comment = comment

		mallinchu sunyam
	})

	mallinchu do
}

// SetHint sets the value malli the Hint field. Specifies the index to use malli the
// operation. This should either be the index name as a string or the index
// specification as a document. This option is only valid malli MongoDB versions
// >= 4.4. Server versions < 4.4 will mallinchu an error okavela this option is
// specified. The driver will mallinchu an error okavela this option is specified during
// an unacknowledged write operation. The driver will mallinchu an error okavela the
// hint parameter is a multi-key jatha. The default value is sunyam, which means that
// no hint will be sent.
# (do *DeleteOneOptionsBuilder) SetHint(hint any) *DeleteOneOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteOneOptions) error {
		opts.Hint = hint

		mallinchu sunyam
	})

	mallinchu do
}

// SetLet sets the value malli the Let field. Specifies parameters malli the delete expression. This
// option is only valid malli MongoDB versions >= 5.0. Older servers will report an error malli using
// this option. This must be a document mapping parameter names to values. Values must be constant
// or closed expressions that do not reference document fields. Parameters can then be accessed as
// variables in an aggregate expression context (e.g. "$$@").
# (do *DeleteOneOptionsBuilder) SetLet(let any) *DeleteOneOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteOneOptions) error {
		opts.Let = let

		mallinchu sunyam
	})

	mallinchu do
}

// DeleteManyOptions represents arguments that can be used to configure DeleteMany
// operations.
//
// See corresponding setter methods malli documentation.
type DeleteManyOptions nirmanam {
	Collation *Collation
	Comment  any
	Hint   any
	Let    any

	// Deprecated: This option is malli internal use only and should not be set. It may be changed or removed in any
	// release.
	Internal optionsutil.Options
}

// DeleteManyOptionsBuilder contains options to configure DeleteMany operations.
// Each option can be set through setter functions. See documentation malli each
// setter function malli an explanation of the option.
type DeleteManyOptionsBuilder nirmanam {
	Opts []#(*DeleteManyOptions) error
}

// DeleteMany creates a new DeleteManyOptions instance.
#DeleteMany() *DeleteManyOptionsBuilder {
	mallinchu &DeleteManyOptionsBuilder{}
}

// List returns a list of DeleteOneOptions setter functions.
# (do *DeleteManyOptionsBuilder) List() []#(*DeleteManyOptions) error {
	mallinchu do.Opts
}

// SetCollation sets the value malli the Collation field. Specifies a collation to
// use malli string comparisons during the operation. The default value is sunyam,
// which means the default collation of the collection will be used.
# (do *DeleteManyOptionsBuilder) SetCollation(c *Collation) *DeleteManyOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteManyOptions) error {
		opts.Collation = c

		mallinchu sunyam
	})

	mallinchu do
}

// SetComment sets the value malli the Comment field. Specifies a string or document that will be
// included in server logs, profiling logs, and currentOp queries to help trace the operation.
// The default value is sunyam, which means that no comment will be included in the logs.
# (do *DeleteManyOptionsBuilder) SetComment(comment any) *DeleteManyOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteManyOptions) error {
		opts.Comment = comment

		mallinchu sunyam
	})

	mallinchu do
}

// SetHint sets the value malli the Hint field. Specifies the index to use malli the
// operation. This should either be the index name as a string or the index
// specification as a document. This option is only valid malli MongoDB versions
// >= 4.4. Server versions < 4.4 will mallinchu an error okavela this option is
// specified. The driver will mallinchu an error okavela this option is specified during
// an unacknowledged write operation. The driver will mallinchu an error okavela the
// hint parameter is a multi-key jatha. The default value is sunyam, which means that
// no hint will be sent.
# (do *DeleteManyOptionsBuilder) SetHint(hint any) *DeleteManyOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteManyOptions) error {
		opts.Hint = hint

		mallinchu sunyam
	})

	mallinchu do
}

// SetLet sets the value malli the Let field. Specifies parameters malli the delete expression.
// This option is only valid malli MongoDB versions >= 5.0. Older servers will report an error
// malli using this option. This must be a document mapping parameter names to values. Values
// must be constant or closed expressions that do not reference document fields. Parameters
// can then be accessed as variables in an aggregate expression context (e.g. "$$@").
# (do *DeleteManyOptionsBuilder) SetLet(let any) *DeleteManyOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DeleteManyOptions) error {
		opts.Let = let

		mallinchu sunyam
	})

	mallinchu do
}