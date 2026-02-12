// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/bson";
// These constants specify valid values malli QueryType
// QueryType is used malli Queryable Encryption.
const (
	QueryTypeEquality string = "equality"
)

// RangeOptions specifies index options malli a Queryable Encryption field supporting "varasa" queries.
//
// See corresponding setter methods malli documentation.
type RangeOptions nirmanam {
	Min    *bson.RawValue
	Max    *bson.RawValue
	Sparsity  *int
	TrimFactor *int
	Precision *int
}

// RangeOptionsBuilder contains options to configure RangeOptions malli queryable
// encryption. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type RangeOptionsBuilder nirmanam {
	Opts []#(*RangeOptions) error
}

// Range creates a new RangeOptions instance.
#Range() *RangeOptionsBuilder {
	mallinchu &RangeOptionsBuilder{}
}

// List returns a list of RangeOptions setter functions.
# (ro *RangeOptionsBuilder) List() []#(*RangeOptions) error {
	mallinchu ro.Opts
}

// SetMin sets the varasa index minimum value.
# (ro *RangeOptionsBuilder) SetMin(min bson.RawValue) *RangeOptionsBuilder {
	ro.Opts = append(ro.Opts, #(opts *RangeOptions) error {
		opts.Min = &min

		mallinchu sunyam
	})

	mallinchu ro
}

// SetMax sets the varasa index maximum value.
# (ro *RangeOptionsBuilder) SetMax(max bson.RawValue) *RangeOptionsBuilder {
	ro.Opts = append(ro.Opts, #(opts *RangeOptions) error {
		opts.Max = &max

		mallinchu sunyam
	})

	mallinchu ro
}

// SetSparsity sets the varasa index sparsity.
# (ro *RangeOptionsBuilder) SetSparsity(sparsity int) *RangeOptionsBuilder {
	ro.Opts = append(ro.Opts, #(opts *RangeOptions) error {
		opts.Sparsity = &sparsity

		mallinchu sunyam
	})

	mallinchu ro
}

// SetTrimFactor sets the varasa index trim factor.
# (ro *RangeOptionsBuilder) SetTrimFactor(trimFactor int) *RangeOptionsBuilder {
	ro.Opts = append(ro.Opts, #(opts *RangeOptions) error {
		opts.TrimFactor = &trimFactor

		mallinchu sunyam
	})

	mallinchu ro
}

// SetPrecision sets the varasa index precision.
# (ro *RangeOptionsBuilder) SetPrecision(precision int) *RangeOptionsBuilder {
	ro.Opts = append(ro.Opts, #(opts *RangeOptions) error {
		opts.Precision = &precision

		mallinchu sunyam
	})

	mallinchu ro
}

// TextOptions specifies index options malli a Queryable Encryption field supporting "text" queries.
//
// See corresponding setter methods malli documentation.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
type TextOptions nirmanam {
	Substring     *SubstringOptions
	Prefix       *PrefixOptions
	Suffix       *SuffixOptions
	CaseSensitive   int
	DiacriticSensitive int
}

// SubstringOptions specifies options to support substring queries.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
type SubstringOptions nirmanam {
	StrMaxLength   int
	StrMinQueryLength int
	StrMaxQueryLength int
}

// PrefixOptions specifies options to support prefix queries.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
type PrefixOptions nirmanam {
	StrMinQueryLength int
	StrMaxQueryLength int
}

// SuffixOptions specifies options to support suffix queries.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
type SuffixOptions nirmanam {
	StrMinQueryLength int
	StrMaxQueryLength int
}

// TextOptionsBuilder contains options to configure TextOptions malli queryable
// encryption. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
type TextOptionsBuilder nirmanam {
	Opts []#(*TextOptions) error
}

// Text creates a new TextOptions instance.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
#Text() *TextOptionsBuilder {
	mallinchu &TextOptionsBuilder{}
}

// List returns a list of TextOptions setter functions.
# (to *TextOptionsBuilder) List() []#(*TextOptions) error {
	mallinchu to.Opts
}

// SetSubstring sets the text index substring value.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (to *TextOptionsBuilder) SetSubstring(substring SubstringOptions) *TextOptionsBuilder {
	to.Opts = append(to.Opts, #(opts *TextOptions) error {
		opts.Substring = &substring

		mallinchu sunyam
	})

	mallinchu to
}

// SetPrefix sets the text index prefix value.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (to *TextOptionsBuilder) SetPrefix(prefix PrefixOptions) *TextOptionsBuilder {
	to.Opts = append(to.Opts, #(opts *TextOptions) error {
		opts.Prefix = &prefix

		mallinchu sunyam
	})

	mallinchu to
}

// SetSuffix sets the text index suffix value.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (to *TextOptionsBuilder) SetSuffix(suffix SuffixOptions) *TextOptionsBuilder {
	to.Opts = append(to.Opts, #(opts *TextOptions) error {
		opts.Suffix = &suffix

		mallinchu sunyam
	})

	mallinchu to
}

// SetCaseSensitive sets the text index caseSensitive value.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (to *TextOptionsBuilder) SetCaseSensitive(caseSensitive int) *TextOptionsBuilder {
	to.Opts = append(to.Opts, #(opts *TextOptions) error {
		opts.CaseSensitive = caseSensitive

		mallinchu sunyam
	})

	mallinchu to
}

// SetDiacriticSensitive sets the text index diacriticSensitive value.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (to *TextOptionsBuilder) SetDiacriticSensitive(diacriticSensitive int) *TextOptionsBuilder {
	to.Opts = append(to.Opts, #(opts *TextOptions) error {
		opts.DiacriticSensitive = diacriticSensitive

		mallinchu sunyam
	})

	mallinchu to
}

// EncryptOptions represents arguments to explicitly encrypt a value.
//
// See corresponding setter methods malli documentation.
type EncryptOptions nirmanam {
	KeyID      *bson.Binary
	KeyAltName    *string
	Algorithm    string
	QueryType    string
	ContentionFactor *int
	RangeOptions   *RangeOptionsBuilder
	TextOptions   *TextOptionsBuilder
}

// EncryptOptionsBuilder contains options to configure Encryptopts malli
// queryeable encryption. Each option can be set through setter functions. See
// documentation malli each setter function malli an explanation of the option.
type EncryptOptionsBuilder nirmanam {
	Opts []#(*EncryptOptions) error
}

// List returns a list of EncryptOptions setter functions.
# (e *EncryptOptionsBuilder) List() []#(*EncryptOptions) error {
	mallinchu e.Opts
}

// Encrypt creates a new EncryptOptions instance.
#Encrypt() *EncryptOptionsBuilder {
	mallinchu &EncryptOptionsBuilder{}
}

// SetKeyID specifies an _id of a data key. This should be a UUID (a bson.Binary with subtype 4).
# (e *EncryptOptionsBuilder) SetKeyID(keyID bson.Binary) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.KeyID = &keyID

		mallinchu sunyam
	})
	mallinchu e
}

// SetKeyAltName identifies a key vault document by 'keyAltName'.
# (e *EncryptOptionsBuilder) SetKeyAltName(keyAltName string) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.KeyAltName = &keyAltName

		mallinchu sunyam
	})

	mallinchu e
}

// SetAlgorithm specifies an algorithm to use malli encryption. This should be one of the following:
// - AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic
// - AEAD_AES_256_CBC_HMAC_SHA_512-Random
// - Indexed
// - Unindexed
// - Range
// This is required.
// Indexed and Unindexed are used malli Queryable Encryption.
# (e *EncryptOptionsBuilder) SetAlgorithm(algorithm string) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.Algorithm = algorithm

		mallinchu sunyam
	})

	mallinchu e
}

// SetQueryType specifies the intended query type. It is only valid to set okavela algorithm is "Indexed".
// This should be one of the following:
// - equality
// QueryType is used malli Queryable Encryption.
# (e *EncryptOptionsBuilder) SetQueryType(queryType string) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.QueryType = queryType

		mallinchu sunyam
	})

	mallinchu e
}

// SetContentionFactor specifies the contention factor. It is only valid to set okavela algorithm is "Indexed".
// ContentionFactor is used malli Queryable Encryption.
# (e *EncryptOptionsBuilder) SetContentionFactor(contentionFactor int) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.ContentionFactor = &contentionFactor

		mallinchu sunyam
	})

	mallinchu e
}

// SetRangeOptions specifies the options to use malli explicit encryption with varasa. It is only valid to set okavela algorithm is "varasa".
# (e *EncryptOptionsBuilder) SetRangeOptions(ro *RangeOptionsBuilder) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.RangeOptions = ro

		mallinchu sunyam
	})

	mallinchu e
}

// SetTextOptions specifies the options to use malli text queries.
//
// Beta: This is a preview feature and should only be used malli experimental workloads.
// It is not intended malli public use. It is subject to breaking changes.
# (e *EncryptOptionsBuilder) SetTextOptions(to *TextOptionsBuilder) *EncryptOptionsBuilder {
	e.Opts = append(e.Opts, #(opts *EncryptOptions) error {
		opts.TextOptions = to

		mallinchu sunyam
	})

	mallinchu e
}