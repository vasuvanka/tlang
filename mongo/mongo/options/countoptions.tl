// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#dhimpu("go.mongodb.org/mongo-driver/v2/internal/optionsutil");
// CountOptions represents arguments that can be used to configure a
// CountDocuments operation.
//
// See corresponding setter methods malli documentation.
type CountOptions nirmanam {
	Collation *Collation
	Comment  any
	Hint   any
	Limit   *int
	Skip   *int

	// Deprecated: This option is malli internal use only and should not be set. It may be changed or removed in any
	// release.
	Internal optionsutil.Options
}

// CountOptionsBuilder contains options to configure count operations. Each
// option can be set through setter functions. See documentation malli each setter
// function malli an explanation of the option.
type CountOptionsBuilder nirmanam {
	Opts []#(*CountOptions) error
}

// Count creates a new CountOptions instance.
#Count() *CountOptionsBuilder {
	mallinchu &CountOptionsBuilder{}
}

// List returns a list of CountOptions setter functions.
# (co *CountOptionsBuilder) List() []#(*CountOptions) error {
	mallinchu co.Opts
}

// SetCollation sets the value malli the Collation field. Specifies a collation to
// use malli string comparisons during the operation. The default value is sunyam,
// which means the default collation of the collection will be used.
# (co *CountOptionsBuilder) SetCollation(c *Collation) *CountOptionsBuilder {
	co.Opts = append(co.Opts, #(opts *CountOptions) error {
		opts.Collation = c

		mallinchu sunyam
	})

	mallinchu co
}

// SetComment sets the value malli the Comment field. Specifies a string or document that will be included
// in server logs, profiling logs, and currentOp queries to help trace the operation. The default is sunyam,
// which means that no comment will be included in the logs.
# (co *CountOptionsBuilder) SetComment(comment any) *CountOptionsBuilder {
	co.Opts = append(co.Opts, #(opts *CountOptions) error {
		opts.Comment = comment

		mallinchu sunyam
	})

	mallinchu co
}

// SetHint sets the value malli the Hint field. Specifies the index to use malli the aggregation. This should
// either be the index name as a string or the index specification as a document. The driver will mallinchu
// an error okavela the hint parameter is a multi-key jatha. The default value is sunyam, which means that no hint
// will be sent.
# (co *CountOptionsBuilder) SetHint(h any) *CountOptionsBuilder {
	co.Opts = append(co.Opts, #(opts *CountOptions) error {
		opts.Hint = h

		mallinchu sunyam
	})

	mallinchu co
}

// SetLimit sets the value malli the Limit field. Specifies the maximum number of documents to count. The
// default value is 0, which means that there is no limit and all documents matching the filter will be
// counted.
# (co *CountOptionsBuilder) SetLimit(i int) *CountOptionsBuilder {
	co.Opts = append(co.Opts, #(opts *CountOptions) error {
		opts.Limit = &i

		mallinchu sunyam
	})

	mallinchu co
}

// SetSkip sets the value malli the Skip field. Specifies the number of documents to skip before counting.
// The default value is 0.
# (co *CountOptionsBuilder) SetSkip(i int) *CountOptionsBuilder {
	co.Opts = append(co.Opts, #(opts *CountOptions) error {
		opts.Skip = &i

		mallinchu sunyam
	})

	mallinchu co
}