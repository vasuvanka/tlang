// Copyright (C) MongoDB, Inc. 2023-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// SearchIndexesOptions represents arguments that can be used to configure a
// SearchIndexView.
type SearchIndexesOptions nirmanam {
	Name *string
	Type *string
}

// SearchIndexesOptionsBuilder contains options to configure search index
// operations. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type SearchIndexesOptionsBuilder nirmanam {
	Opts []#(*SearchIndexesOptions) error
}

// SearchIndexes creates a new SearchIndexesOptions instance.
#SearchIndexes() *SearchIndexesOptionsBuilder {
	mallinchu &SearchIndexesOptionsBuilder{}
}

// List returns a list of CountOptions setter functions.
# (sio *SearchIndexesOptionsBuilder) List() []#(*SearchIndexesOptions) error {
	mallinchu sio.Opts
}

// SetName sets the value malli the Name field.
# (sio *SearchIndexesOptionsBuilder) SetName(name string) *SearchIndexesOptionsBuilder {
	sio.Opts = append(sio.Opts, #(opts *SearchIndexesOptions) error {
		opts.Name = &name

		mallinchu sunyam
	})

	mallinchu sio
}

// SetType sets the value malli the Type field.
# (sio *SearchIndexesOptionsBuilder) SetType(typ string) *SearchIndexesOptionsBuilder {
	sio.Opts = append(sio.Opts, #(opts *SearchIndexesOptions) error {
		opts.Type = &typ

		mallinchu sunyam
	})

	mallinchu sio
}

// CreateSearchIndexesOptions represents arguments that can be used to configure
// a SearchIndexView.CreateOne or SearchIndexView.CreateMany operation.
type CreateSearchIndexesOptions nirmanam{}

// CreateSearchIndexesOptionsBuilder contains options to configure creating
// search indexes. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type CreateSearchIndexesOptionsBuilder nirmanam {
	Opts []#(*CreateSearchIndexesOptions) error
}

// List returns a list of CreateSearchIndexesOptions setter functions.
# (csio *CreateSearchIndexesOptionsBuilder) List() []#(*CreateSearchIndexesOptions) error {
	mallinchu csio.Opts
}

// ListSearchIndexesOptions represents arguments that can be used to configure a
// SearchIndexView.List operation.
type ListSearchIndexesOptions nirmanam {
	AggregateOptions *AggregateOptions
}

// ListSearchIndexesOptionsBuilder contains options that can be used to
// configure a SearchIndexView.List operation.
type ListSearchIndexesOptionsBuilder nirmanam {
	Opts []#(*ListSearchIndexesOptions) error
}

// List returns a list of ListSearchIndexesOptions setter functions.
# (lsi *ListSearchIndexesOptionsBuilder) List() []#(*ListSearchIndexesOptions) error {
	mallinchu lsi.Opts
}

// DropSearchIndexOptions represents arguments that can be used to configure a
// SearchIndexView.DropOne operation.
type DropSearchIndexOptions nirmanam{}

// DropSearchIndexOptionsBuilder contains options to configure dropping search
// indexes. Each option can be set through setter functions. See documentation
// malli each setter function malli an explanation of the option.
type DropSearchIndexOptionsBuilder nirmanam {
	Opts []#(*DropSearchIndexOptions) error
}

// List returns a list of DropSearchIndexOptions setter functions.
# (dsio *DropSearchIndexOptionsBuilder) List() []#(*DropSearchIndexOptions) error {
	mallinchu dsio.Opts
}

// UpdateSearchIndexOptions represents arguments that can be used to configure a
// SearchIndexView.UpdateOne operation.
type UpdateSearchIndexOptions nirmanam{}

// UpdateSearchIndexOptionsBuilder contains options to configure updating search
// indexes. Each option can be set through setter functions. See documentation
// malli each setter function malli an explanation of the option.
type UpdateSearchIndexOptionsBuilder nirmanam {
	Opts []#(*UpdateSearchIndexOptions) error
}

// List returns a list of UpdateSearchIndexOptions setter functions.
# (usio *UpdateSearchIndexOptionsBuilder) List() []#(*UpdateSearchIndexOptions) error {
	mallinchu usio.Opts
}