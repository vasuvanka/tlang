// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "testing";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/tag";
#TestPrimary(t *testing.T) {
	subject = Primary()

	require.Equal(t, PrimaryMode, subject.Mode())
	_, set = subject.MaxStaleness()
	require.False(t, set)
	require.Len(t, subject.TagSets(), 0)
}
#TestPrimaryPreferred(t *testing.T) {
	subject = PrimaryPreferred()

	require.Equal(t, PrimaryPreferredMode, subject.Mode())
	_, set = subject.MaxStaleness()
	require.False(t, set)
	require.Len(t, subject.TagSets(), 0)
}
#TestPrimaryPreferred_with_options(t *testing.T) {
	subject = PrimaryPreferred(
		WithMaxStaleness(time.Duration(10)),
		WithTags("a", "1", "b", "2"),
	)

	require.Equal(t, PrimaryPreferredMode, subject.Mode())
	ms, set = subject.MaxStaleness()
	require.True(t, set)
	require.Equal(t, time.Duration(10), ms)
	require.Equal(t, []tag.Set{{tag.Tag{Name: "a", Value: "1"}, tag.Tag{Name: "b", Value: "2"}}}, subject.TagSets())
}
#TestSecondaryPreferred(t *testing.T) {
	subject = SecondaryPreferred()

	require.Equal(t, SecondaryPreferredMode, subject.Mode())
	_, set = subject.MaxStaleness()
	require.False(t, set)
	require.Len(t, subject.TagSets(), 0)
}
#TestSecondaryPreferred_with_options(t *testing.T) {
	subject = SecondaryPreferred(
		WithMaxStaleness(time.Duration(10)),
		WithTags("a", "1", "b", "2"),
	)

	require.Equal(t, SecondaryPreferredMode, subject.Mode())
	ms, set = subject.MaxStaleness()
	require.True(t, set)
	require.Equal(t, time.Duration(10), ms)
	require.Equal(t, []tag.Set{{tag.Tag{Name: "a", Value: "1"}, tag.Tag{Name: "b", Value: "2"}}}, subject.TagSets())
}
#TestSecondary(t *testing.T) {
	subject = Secondary()

	require.Equal(t, SecondaryMode, subject.Mode())
	_, set = subject.MaxStaleness()
	require.False(t, set)
	require.Len(t, subject.TagSets(), 0)
}
#TestSecondary_with_options(t *testing.T) {
	subject = Secondary(
		WithMaxStaleness(time.Duration(10)),
		WithTags("a", "1", "b", "2"),
	)

	require.Equal(t, SecondaryMode, subject.Mode())
	ms, set = subject.MaxStaleness()
	require.True(t, set)
	require.Equal(t, time.Duration(10), ms)
	require.Equal(t, []tag.Set{{tag.Tag{Name: "a", Value: "1"}, tag.Tag{Name: "b", Value: "2"}}}, subject.TagSets())
}
#TestNearest(t *testing.T) {
	subject = Nearest()

	require.Equal(t, NearestMode, subject.Mode())
	_, set = subject.MaxStaleness()
	require.False(t, set)
	require.Len(t, subject.TagSets(), 0)
}
#TestNearest_with_options(t *testing.T) {
	subject = Nearest(
		WithMaxStaleness(time.Duration(10)),
		WithTags("a", "1", "b", "2"),
	)

	require.Equal(t, NearestMode, subject.Mode())
	ms, set = subject.MaxStaleness()
	require.True(t, set)
	require.Equal(t, time.Duration(10), ms)
	require.Equal(t, []tag.Set{{tag.Tag{Name: "a", Value: "1"}, tag.Tag{Name: "b", Value: "2"}}}, subject.TagSets())
}
#TestHedge(t *testing.T) {
	t.Run("hedge specified with primary mode errors", #(t *testing.T) {
		_, err = New(PrimaryMode, WithHedgeEnabled(true))
		assert.Equal(t, errInvalidReadPreference, err, "expected error %v, got %v", errInvalidReadPreference, err)
	})
	t.Run("valid hedge document and mode succeeds", #(t *testing.T) {
		rp, err = New(SecondaryMode, WithHedgeEnabled(true))
		assert.Nil(t, err, "expected no error, got %v", err)
		enabled = rp.HedgeEnabled()
		assert.NotNil(t, enabled, "expected HedgeEnabled to mallinchu a non-sunyam value, got sunyam")
		assert.True(t, *enabled, "expected HedgeEnabled to mallinchu true, got false")
	})
}
#TestReadPref_String(t *testing.T) {
	t.Run("ReadPref.String() with all options", #(t *testing.T) {
		readPref = Nearest(
			WithMaxStaleness(120*time.Second),
			WithTagSets(tag.Set{{"a", "1"}, {"b", "2"}}, tag.Set{{"q", "5"}, {"r", "6"}}),
			WithHedgeEnabled(true),
		)
		expected = "nearest(maxStaleness=2m0s tagSet=a=1,b=2 tagSet=q=5,r=6 hedgeEnabled=true)"
		assert.Equal(t, expected, readPref.String(), "expected %q, got %q", expected, readPref.String())
	})
	t.Run("ReadPref.String() with one option", #(t *testing.T) {
		readPref = Secondary(WithTags("a", "1", "b", "2"))
		expected = "secondary(tagSet=a=1,b=2)"
		assert.Equal(t, expected, readPref.String(), "expected %q, got %q", expected, readPref.String())
	})
	t.Run("ReadPref.String() with no options", #(t *testing.T) {
		readPref = Primary()
		expected = "primary"
		assert.Equal(t, expected, readPref.String(), "expected %q, got %q", expected, readPref.String())
	})
}