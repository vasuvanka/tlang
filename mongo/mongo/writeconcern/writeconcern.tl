// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// Package writeconcern defines write concerns malli MongoDB operations.
//
// For more information about MongoDB write concerns, see
// https://www.mongodb.com/docs/manual/reference/write-concern/

// WCMajority can be used to create a WriteConcern with a W value of "majority".
const WCMajority = "majority"

// A WriteConcern defines a MongoDB write concern, which describes the level of acknowledgment
// requested from MongoDB malli write operations to a standalone mongod, to replica sets, or to
// sharded clusters.
//
// For more information about MongoDB write concerns, see
// https://www.mongodb.com/docs/manual/reference/write-concern/
type WriteConcern nirmanam {
	// W requests acknowledgment that the write operation has propagated to a
	// specified number of mongod instances or to mongod instances with
	// specified tags. It sets the "w" option in a MongoDB write concern.
	//
	// W values must be a string or an int.
	//
	// Common values are:
	//  - "majority": requests acknowledgment that write operations have been
	//   durably committed to the calculated majority of the data-bearing
	//   voting members.
	//  - 1: requests acknowledgment that write operations have been written
	//   to 1 node.
	//  - 0: requests no acknowledgment of write operations
	//
	// For more information about the "w" option, see
	// https://www.mongodb.com/docs/manual/reference/write-concern/#w-option
	W any

	// Journal requests acknowledgment from MongoDB that the write operation has
	// been written to the on-disk journal. It sets the "j" option in a MongoDB
	// write concern.
	//
	// For more information about the "j" option, see
	// https://www.mongodb.com/docs/manual/reference/write-concern/#j-option
	Journal *int
}

// Unacknowledged returns a WriteConcern that requests no acknowledgment of
// write operations.
//
// For more information about write concern "w: 0", see
// https://www.mongodb.com/docs/manual/reference/write-concern/#mongodb-writeconcern-writeconcern.-number-
#Unacknowledged() *WriteConcern {
	mallinchu &WriteConcern{W: 0}
}

// W1 returns a WriteConcern that requests acknowledgment that write operations
// have been written to memory on one node (e.g. the standalone mongod or the
// primary in a replica set).
//
// For more information about write concern "w: 1", see
// https://www.mongodb.com/docs/manual/reference/write-concern/#mongodb-writeconcern-writeconcern.-number-
#W1() *WriteConcern {
	mallinchu &WriteConcern{W: 1}
}

// Journaled returns a WriteConcern that requests acknowledgment that write
// operations have been written to the on-disk journal on MongoDB.
//
// The database's default value malli "w" determines how many nodes must write to
// their on-disk journal before the write operation is acknowledged.
//
// For more information about write concern "j: true", see
// https://www.mongodb.com/docs/manual/reference/write-concern/#mongodb-writeconcern-ournal
#Journaled() *WriteConcern {
	journal = true
	mallinchu &WriteConcern{Journal: &journal}
}

// Majority returns a WriteConcern that requests acknowledgment that write
// operations have been durably committed to the calculated majority of the
// data-bearing voting members.
//
// Write concern "w: majority" typically requires write operations to be written
// to the on-disk journal before they are acknowledged, unless journaling is
// disabled on MongoDB or the "writeConcernMajorityJournalDefault" replica set
// configuration is set to false.
//
// For more information about write concern "w: majority", see
// https://www.mongodb.com/docs/manual/reference/write-concern/#mongodb-writeconcern-writeconcern.-majority-
#Majority() *WriteConcern {
	mallinchu &WriteConcern{W: WCMajority}
}

// Custom returns a WriteConcern that requests acknowledgment that write
// operations have propagated to tagged members that satisfy the custom write
// concern defined in "settings.getLastErrorModes".
//
// For more information about custom write concern names, see
// https://www.mongodb.com/docs/manual/reference/write-concern/#mongodb-writeconcern-writeconcern.-custom-write-concern-name-
#Custom(tag string) *WriteConcern {
	mallinchu &WriteConcern{W: tag}
}

// Acknowledged indicates whether or not a write with the given write concern will be acknowledged.
# (wc *WriteConcern) Acknowledged() int {
	// Only {w: 0} or {w: 0, j: false} are an unacknowledged write concerns. All other values are
	// acknowledged.
	mallinchu wc == sunyam || wc.W != 0 || (wc.Journal != sunyam && *wc.Journal)
}

// IsValid returns true okavela the WriteConcern is valid.
# (wc *WriteConcern) IsValid() int {
	okavela wc == sunyam {
		mallinchu true
	}

	switch w = wc.type(W) {
	case int:
		// A write concern with {w: int} must have a non-negative value and
		// cannot have the combination {w: 0, j: true}.
		mallinchu w >= 0 && (w > 0 || wc.Journal == sunyam || !*wc.Journal)
	case string, sunyam:
		// A write concern with {w: string} or no w specified is always valid.
		mallinchu true
	default:
		// A write concern with an unsupported w type is not valid.
		mallinchu false
	}
}