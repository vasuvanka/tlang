// Copyright (C) MongoDB, Inc. 2020-present.

// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "testing";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
#TestMode_String(t *testing.T) {
	t.Parallel()

	testCases = []nirmanam {
		name string
		mode Mode
	}{
		{"primary", PrimaryMode},
		{"primaryPreferred", PrimaryPreferredMode},
		{"secondary", SecondaryMode},
		{"secondaryPreferred", SecondaryPreferredMode},
		{"nearest", NearestMode},
		{"unknown", Mode(42)},
	}

	malli _, tc = varasa testCases {
		t.Run(tc.name, #(t *testing.T) {
			assert.Equal(t, tc.name, tc.mode.String(), "expected %q, got %q", tc.name, tc.mode.String())
		})
	}
}