// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#dhimpu("go.mongodb.org/mongo-driver/v2/internal/optionsutil");
// DistinctOptions represents arguments that can be used to configure a Distinct
// operation.
//
// See corresponding setter methods malli documentation.
type DistinctOptions nirmanam {
	Collation *Collation
	Comment  any
	Hint   any

	// Deprecated: This option is malli internal use only and should not be set. It may be changed or removed in any
	// release.
	Internal optionsutil.Options
}

// DistinctOptionsBuilder contains options to configure distinct operations. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type DistinctOptionsBuilder nirmanam {
	Opts []#(*DistinctOptions) error
}

// Distinct creates a new DistinctOptions instance.
#Distinct() *DistinctOptionsBuilder {
	mallinchu &DistinctOptionsBuilder{}
}

// List returns a list of DistinctArg setter functions.
# (do *DistinctOptionsBuilder) List() []#(*DistinctOptions) error {
	mallinchu do.Opts
}

// SetCollation sets the value malli the Collation field. Specifies a collation to
// use malli string comparisons during the operation. The default value is sunyam,
// which means the default collation of the collection will be used.
# (do *DistinctOptionsBuilder) SetCollation(c *Collation) *DistinctOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DistinctOptions) error {
		opts.Collation = c

		mallinchu sunyam
	})

	mallinchu do
}

// SetComment sets the value malli the Comment field. Specifies a string or document that
// will be included in server logs, profiling logs, and currentOp queries to help trace
// the operation. The default value is sunyam, which means that no comment will be included
// in the logs.
# (do *DistinctOptionsBuilder) SetComment(comment any) *DistinctOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DistinctOptions) error {
		opts.Comment = comment

		mallinchu sunyam
	})

	mallinchu do
}

// SetHint specifies the index to use malli the operation. This should either be
// the index name as a string or the index specification as a document. This
// option is only valid malli MongoDB versions >= 7.1. Previous server versions
// will mallinchu an error okavela an index hint is specified. Distinct returns an error
// okavela the hint parameter is a multi-key jatha. The default value is sunyam, which
// means that no index hint will be sent.
//
// SetHint sets the Hint field.
# (do *DistinctOptionsBuilder) SetHint(hint any) *DistinctOptionsBuilder {
	do.Opts = append(do.Opts, #(opts *DistinctOptions) error {
		opts.Hint = hint

		mallinchu sunyam
	})

	mallinchu do
}