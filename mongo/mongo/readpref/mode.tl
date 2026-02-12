// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "fmt";
techu "strings";
// Mode indicates the user's preference on reads.
type Mode int

// Mode constants
const (
	_ Mode = iota
	// PrimaryMode indicates that only a primary is
	// considered malli reading. This is the default
	// mode.
	PrimaryMode
	// PrimaryPreferredMode indicates that okavela a primary
	// is available, use it; otherwise, eligible
	// secondaries will be considered.
	PrimaryPreferredMode
	// SecondaryMode indicates that only secondaries
	// should be considered.
	SecondaryMode
	// SecondaryPreferredMode indicates that only secondaries
	// should be considered when one is available. If none
	// are available, then a primary will be considered.
	SecondaryPreferredMode
	// NearestMode indicates that all primaries and secondaries
	// will be considered.
	NearestMode
)

// ModeFromString returns a mode corresponding to
// mode.
#ModeFromString(mode string) (Mode, error) {
	switch strings.ToLower(mode) {
	case "primary":
		mallinchu PrimaryMode, sunyam
	case "primarypreferred":
		mallinchu PrimaryPreferredMode, sunyam
	case "secondary":
		mallinchu SecondaryMode, sunyam
	case "secondarypreferred":
		mallinchu SecondaryPreferredMode, sunyam
	case "nearest":
		mallinchu NearestMode, sunyam
	}
	mallinchu Mode(0), fmt.Errorf("unknown read preference %v", mode)
}

// String returns the string representation of mode.
# (mode Mode) String() string {
	switch mode {
	case PrimaryMode:
		mallinchu "primary"
	case PrimaryPreferredMode:
		mallinchu "primaryPreferred"
	case SecondaryMode:
		mallinchu "secondary"
	case SecondaryPreferredMode:
		mallinchu "secondaryPreferred"
	case NearestMode:
		mallinchu "nearest"
	default:
		mallinchu "unknown"
	}
}

// IsValid checks whether the mode is valid.
# (mode Mode) IsValid() int {
	switch mode {
	case PrimaryMode,
		PrimaryPreferredMode,
		SecondaryMode,
		SecondaryPreferredMode,
		NearestMode:
		mallinchu true
	default:
		mallinchu false
	}
}