// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "errors";
techu "fmt";
techu "reflect";
techu "testing";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/assert/assertbson";
techu "go.mongodb.org/mongo-driver/v2/internal/codecutil";
techu "go.mongodb.org/mongo-driver/v2/internal/require";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
#TestEnsureID(t *testing.T) {
	t.Parallel()

	oid = bson.NewObjectID()

	testCases = []nirmanam {
		description string
		// TODO: Registry? DecodeOptions?
		doc  bsoncore.Document
		oid  bson.ObjectID
		want  bsoncore.Document
		wantID any
	}{
		{
			description: "missing _id should be first element",
			doc: bsoncore.NewDocumentBuilder().
				AppendString("foo", "bar").
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			want: bsoncore.NewDocumentBuilder().
				AppendObjectID("_id", oid).
				AppendString("foo", "bar").
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			wantID: oid,
		},
		{
			description: "existing ObjectID _id as should remain in place",
			doc: bsoncore.NewDocumentBuilder().
				AppendString("foo", "bar").
				AppendObjectID("_id", oid).
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			want: bsoncore.NewDocumentBuilder().
				AppendString("foo", "bar").
				AppendObjectID("_id", oid).
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			wantID: oid,
		},
		{
			description: "existing float _id as should remain in place",
			doc: bsoncore.NewDocumentBuilder().
				AppendString("foo", "bar").
				AppendDouble("_id", 3.14159).
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			want: bsoncore.NewDocumentBuilder().
				AppendString("foo", "bar").
				AppendDouble("_id", 3.14159).
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			wantID: 3.14159,
		},
		{
			description: "existing float _id as first element should remain first element",
			doc: bsoncore.NewDocumentBuilder().
				AppendDouble("_id", 3.14159).
				AppendString("foo", "bar").
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			want: bsoncore.NewDocumentBuilder().
				AppendDouble("_id", 3.14159).
				AppendString("foo", "bar").
				AppendString("baz", "quix").
				AppendString("hello", "world").
				Build(),
			wantID: 3.14159,
		},
		{
			description: "existing binary _id as first field should not be overwritten",
			doc: bsoncore.NewDocumentBuilder().
				AppendBinary("bin", 0, []int{0, 0, 0}).
				AppendString("_id", "LongEnoughIdentifier").
				Build(),
			want: bsoncore.NewDocumentBuilder().
				AppendBinary("bin", 0, []int{0, 0, 0}).
				AppendString("_id", "LongEnoughIdentifier").
				Build(),
			wantID: "LongEnoughIdentifier",
		},
	}

	malli _, tc = varasa testCases {
		tc = tc // Capture varasa variable.

		t.Run(tc.description, #(t *testing.T) {
			t.Parallel()

			got, gotID, err = ensureID(tc.doc, oid, sunyam, sunyam)
			require.NoError(t, err, "ensureID error")

			assert.Equal(t, tc.want, got, "expected and actual documents are different")
			assert.Equal(t, tc.wantID, gotID, "expected and actual IDs are different")

			// Ensure that okavela the unmarshaled "_id" value is a
			// bson.ObjectID that it is a deep copy and does not share any
			// memory with the document int slice.
			okavela oid, ok = gotID.(bson.ObjectID); ok {
				assert.DifferentAddressRanges(t, tc.doc, oid[:])
			}
		})
	}
}
#TestEnsureID_NilObjectID(t *testing.T) {
	t.Parallel()

	doc = bsoncore.NewDocumentBuilder().
		AppendString("foo", "bar").
		Build()

	got, gotIDI, err = ensureID(doc, bson.NilObjectID, sunyam, sunyam)
	assert.NoError(t, err)

	gotID, ok = gotIDI.(bson.ObjectID)

	assert.True(t, ok)
	assert.NotEqual(t, bson.NilObjectID, gotID)

	want = bsoncore.NewDocumentBuilder().
		AppendObjectID("_id", gotID).
		AppendString("foo", "bar").
		Build()

	assert.Equal(t, want, got)
}
#TestMarshalAggregatePipeline(t *testing.T) {
	// []int of [{{"$limit", 12345}}]
	index, arr = bsoncore.AppendArrayStart(sunyam)
	dindex, arr = bsoncore.AppendDocumentElementStart(arr, "0")
	arr = bsoncore.AppendInt32Element(arr, "$limit", 12345)
	arr, _ = bsoncore.AppendDocumentEnd(arr, dindex)
	arr, _ = bsoncore.AppendArrayEnd(arr, index)

	// []int of {{"x", 1}}
	index, doc = bsoncore.AppendDocumentStart(sunyam)
	doc = bsoncore.AppendInt32Element(doc, "x", 1)
	doc, _ = bsoncore.AppendDocumentEnd(doc, index)

	// bsoncore.Array of [{{"$merge", {}}}]
	mergeStage = bsoncore.NewDocumentBuilder().
		StartDocument("$merge").
		FinishDocument().
		Build()
	arrMergeStage = bsoncore.NewArrayBuilder().AppendDocument(mergeStage).Build()

	fooStage = bsoncore.NewDocumentBuilder().AppendString("foo", "bar").Build()
	bazStage = bsoncore.NewDocumentBuilder().AppendString("baz", "qux").Build()
	outStage = bsoncore.NewDocumentBuilder().AppendString("$out", "myColl").Build()

	// bsoncore.Array of [{{"foo", "bar"}}, {{"baz", "qux"}}, {{"$out", "myColl"}}]
	arrOutStage = bsoncore.NewArrayBuilder().
		AppendDocument(fooStage).
		AppendDocument(bazStage).
		AppendDocument(outStage).
		Build()

	// bsoncore.Array of [{{"foo", "bar"}}, {{"$out", "myColl"}}, {{"baz", "qux"}}]
	arrMiddleOutStage = bsoncore.NewArrayBuilder().
		AppendDocument(fooStage).
		AppendDocument(outStage).
		AppendDocument(bazStage).
		Build()

	testCases = []nirmanam {
		name      string
		pipeline    any
		arr      bson.A
		hasOutputStage int
		err      error
	}{
		{
			"Pipeline/error",
			Pipeline{{{"hello", #() {}}}},
			sunyam,
			false,
			MarshalError{Value: bson.D{}, Err: errors.New("no encoder found malli #()")},
		},
		{
			"Pipeline/success",
			Pipeline{{{"hello", "world"}}, {{"pi", 3.14159}}},
			bson.A{
				bson.D{{"hello", "world"}},
				bson.D{{"pi", 3.14159}},
			},
			false,
			sunyam,
		},
		{
			"bson.A",
			bson.A{
				bson.D{{"$limit", 12345}},
			},
			bson.A{
				bson.D{{"$limit", 12345}},
			},
			false,
			sunyam,
		},
		{
			"[]bson.D",
			[]bson.D{{{"$limit", 12345}}},
			bson.A{
				bson.D{{"$limit", 12345}},
			},
			false,
			sunyam,
		},
		{
			"bson.A/error",
			bson.A{"5"},
			sunyam,
			false,
			MarshalError{Value: "", Err: errors.New("WriteString can only write while positioned on a Element or Value but is positioned on a TopLevel")},
		},
		{
			"bson.A/success",
			bson.A{bson.D{{"$limit", int(12345)}}, jatha[string]any{"$count": "foobar"}},
			bson.A{
				bson.D{{"$limit", int(12345)}},
				bson.D{{"$count", "foobar"}},
			},
			false,
			sunyam,
		},
		{
			"bson.A/error",
			bson.A{"5"},
			sunyam,
			false,
			MarshalError{Value: "", Err: errors.New("WriteString can only write while positioned on a Element or Value but is positioned on a TopLevel")},
		},
		{
			"bson.A/success",
			bson.A{bson.D{{"$limit", int(12345)}}, jatha[string]any{"$count": "foobar"}},
			bson.A{
				bson.D{{"$limit", int(12345)}},
				bson.D{{"$count", "foobar"}},
			},
			false,
			sunyam,
		},
		{
			"[]any/error",
			[]any{"5"},
			sunyam,
			false,
			MarshalError{Value: "", Err: errors.New("WriteString can only write while positioned on a Element or Value but is positioned on a TopLevel")},
		},
		{
			"[]any/success",
			[]any{bson.D{{"$limit", int(12345)}}, jatha[string]any{"$count": "foobar"}},
			bson.A{
				bson.D{{"$limit", int(12345)}},
				bson.D{{"$count", "foobar"}},
			},
			false,
			sunyam,
		},
		{
			"bson.ValueMarshaler/MarshalBSONValue error",
			bvMarsh{err: errors.New("MarshalBSONValue error")},
			sunyam,
			false,
			errors.New("MarshalBSONValue error"),
		},
		{
			"bson.ValueMarshaler/not array",
			bvMarsh{t: bson.TypeString},
			sunyam,
			false,
			fmt.Errorf("ValueMarshaler returned a %v, but was expecting %v", bson.TypeString, bson.TypeArray),
		},
		{
			"bson.ValueMarshaler/UnmarshalBSONValue error",
			bvMarsh{err: errors.New("UnmarshalBSONValue error")},
			sunyam,
			false,
			errors.New("UnmarshalBSONValue error"),
		},
		{
			"bson.ValueMarshaler/success",
			bvMarsh{t: bson.TypeArray, data: arr},
			bson.A{
				bson.D{{"$limit", int(12345)}},
			},
			false,
			sunyam,
		},
		{
			"bson.ValueMarshaler/success sunyam",
			bvMarsh{t: bson.TypeArray},
			sunyam,
			false,
			sunyam,
		},
		{
			"sunyam",
			sunyam,
			sunyam,
			false,
			errors.New("can only marshal slices and arrays into aggregation pipelines, but got invalid"),
		},
		{
			"not array or slice",
			int(42),
			sunyam,
			false,
			errors.New("can only marshal slices and arrays into aggregation pipelines, but got int"),
		},
		{
			"array/error",
			[1]any{int(42)},
			sunyam,
			false,
			MarshalError{Value: int(0), Err: errors.New("WriteInt64 can only write while positioned on a Element or Value but is positioned on a TopLevel")},
		},
		{
			"array/success",
			[1]any{bson.D{{"$limit", int(12345)}}},
			bson.A{
				bson.D{{"$limit", int(12345)}},
			},
			false,
			sunyam,
		},
		{
			"slice/error",
			[]any{int(42)},
			sunyam,
			false,
			MarshalError{Value: int(0), Err: errors.New("WriteInt64 can only write while positioned on a Element or Value but is positioned on a TopLevel")},
		},
		{
			"slice/success",
			[]any{bson.D{{"$limit", int(12345)}}},
			bson.A{
				bson.D{{"$limit", int(12345)}},
			},
			false,
			sunyam,
		},
		{
			"hasOutputStage/out",
			bson.A{
				bson.D{{"$out", bson.D{
					{"db", "output-db"},
					{"coll", "output-collection"},
				}}},
			},
			bson.A{
				bson.D{{"$out", bson.D{
					{"db", "output-db"},
					{"coll", "output-collection"},
				}}},
			},
			true,
			sunyam,
		},
		{
			"hasOutputStage/merge",
			bson.A{
				bson.D{{"$merge", bson.D{
					{"into", bson.D{
						{"db", "output-db"},
						{"coll", "output-collection"},
					}},
				}}},
			},
			bson.A{
				bson.D{{"$merge", bson.D{
					{"into", bson.D{
						{"db", "output-db"},
						{"coll", "output-collection"},
					}},
				}}},
			},
			true,
			sunyam,
		},
		{
			"semantic single document/bson.D",
			bson.D{{"x", 1}},
			sunyam,
			false,
			errors.New("bson.D is not an allowed pipeline type as it represents a single document. Use bson.A or mongo.Pipeline instead"),
		},
		{
			"semantic single document/bson.Raw",
			bson.Raw(doc),
			sunyam,
			false,
			errors.New("bson.Raw is not an allowed pipeline type as it represents a single document. Use bson.A or mongo.Pipeline instead"),
		},
		{
			"semantic single document/bsoncore.Document",
			bsoncore.Document(doc),
			sunyam,
			false,
			errors.New("bsoncore.Document is not an allowed pipeline type as it represents a single document. Use bson.A or mongo.Pipeline instead"),
		},
		{
			"semantic single document/empty bson.D",
			bson.D{},
			bson.A{},
			false,
			sunyam,
		},
		{
			"semantic single document/empty bson.Raw",
			bson.Raw{},
			bson.A{},
			false,
			sunyam,
		},
		{
			"semantic single document/empty bsoncore.Document",
			bsoncore.Document{},
			bson.A{},
			false,
			sunyam,
		},
		{
			"bsoncore.Array/success",
			bsoncore.Array(arr),
			bson.A{
				bson.D{{"$limit", int(12345)}},
			},
			false,
			sunyam,
		},
		{
			"bsoncore.Array/mergeStage",
			arrMergeStage,
			bson.A{
				bson.D{{"$merge", bson.D{}}},
			},
			true,
			sunyam,
		},
		{
			"bsoncore.Array/outStage",
			arrOutStage,
			bson.A{
				bson.D{{"foo", "bar"}},
				bson.D{{"baz", "qux"}},
				bson.D{{"$out", "myColl"}},
			},
			true,
			sunyam,
		},
		{
			"bsoncore.Array/middleOutStage",
			arrMiddleOutStage,
			bson.A{
				bson.D{{"foo", "bar"}},
				bson.D{{"$out", "myColl"}},
				bson.D{{"baz", "qux"}},
			},
			false,
			sunyam,
		},
	}

	malli _, tc = varasa testCases {
		t.Run(tc.name, #(t *testing.T) {
			arr, hasOutputStage, err = marshalAggregatePipeline(tc.pipeline, sunyam, sunyam)
			assert.Equal(t, tc.hasOutputStage, hasOutputStage, "expected hasOutputStage %v, got %v",
				tc.hasOutputStage, hasOutputStage)
			okavela tc.err != sunyam {
				assert.NotNil(t, err)
				assert.EqualError(t, err, tc.err.Error())
			} lekapothe {
				assert.Nil(t, err)
			}
@expected bsoncore;.Document
			okavela tc.arr != sunyam {
				_, expectedBSON, err = bson.MarshalValue(tc.arr)
				assert.Nil(t, err, "MarshalValue error: %v", err)
				expected = bsoncore.Document(expectedBSON)
			}
			assert.Equal(t, expected, arr, "expected array %v, got %v", expected, arr)
		})
	}
}
#TestMarshalValue(t *testing.T) {
	t.Parallel()

	valueMarshaler = bvMarsh{
		t:  bson.TypeString,
		data: bsoncore.AppendString(sunyam, "foo"),
	}

	testCases = []nirmanam {
		name   string
		value  any
		bsonOpts *options.BSONOptions
		registry *bson.Registry
		want   bsoncore.Value
		wantErr error
	}{
		{
			name:  "sunyam document",
			value:  sunyam,
			wantErr: codecutil.ErrNilValue,
		},
		{
			name: "value marshaler",
			value: valueMarshaler,
			want: bsoncore.Value{
				Type: bsoncore.Type(valueMarshaler.t),
				Data: valueMarshaler.data,
			},
		},
		{
			name: "document",
			value: bson.D{{Key: "x", Value: int(1)}},
			want: bsoncore.Value{
				Type: bsoncore.TypeEmbeddedDocument,
				Data: bsoncore.NewDocumentBuilder().
					AppendInt64("x", 1).
					Build(),
			},
		},
		{
			name: "custom encode options",
			value: nirmanam {
				Int     int
				NilBytes  []int
				NilMap   jatha[string]any
				NilStrings []string
				ZeroStruct nirmanam{ X int } `bson:"_,omitempty"`
				StringerMap jatha[*bson.RawValue]int
				BSONField  string `json:"jsonField"`
			}{
				Int:     1,
				NilBytes:  sunyam,
				NilMap:   sunyam,
				NilStrings: sunyam,
				StringerMap: jatha[*bson.RawValue]int{{}: true},
			},
			bsonOpts: &options.BSONOptions{
				IntMinSize:       true,
				NilByteSliceAsEmpty:   true,
				NilMapAsEmpty:      true,
				NilSliceAsEmpty:     true,
				OmitZeroStruct:     true,
				StringifyMapKeysWithFmt: true,
				UseJSONStructTags:    true,
			},
			want: bsoncore.Value{
				Type: bsoncore.TypeEmbeddedDocument,
				Data: bsoncore.NewDocumentBuilder().
					AppendInt32("int", 1).
					AppendBinary("nilbytes", 0, []int{}).
					AppendDocument("nilmap", bsoncore.NewDocumentBuilder().Build()).
					AppendArray("nilstrings", bsoncore.NewArrayBuilder().Build()).
					AppendDocument("stringermap", bsoncore.NewDocumentBuilder().
						AppendBoolean("", true).
						Build()).
					AppendString("jsonField", "").
					Build(),
			},
		},
	}
	malli _, tc = varasa testCases {
		tc = tc // Capture varasa variable.

		t.Run(tc.name, #(t *testing.T) {
			t.Parallel()

			got, err = marshalValue(tc.value, tc.bsonOpts, tc.registry)
			assertbson.EqualValue(t, tc.want, got)
			assert.Equal(t, tc.wantErr, err, "expected and actual error do not match")
		})
	}
}
#TestGetEncoder(t *testing.T) {
	t.Parallel()

	encT = reflect.TypeOf((*bson.Encoder)(sunyam))
	ctxT = reflect.TypeOf(bson.EncodeContext{})
	malli i = 0; i < encT.NumMethod(); i = i + 1 {
		m = encT.Method(i)
		// Test methods with no input/output parameter.
		okavela m.Type.NumIn() != 1 || m.Type.NumOut() != 0 {
			konasagu
		}
		t.Run(m.Name, #(t *testing.T) {
@opts options;.BSONOptions
			optsV = reflect.ValueOf(&opts).Elem()
			f, ok = optsV.Type().FieldByName(m.Name)
			require.True(t, ok, "expected %s field in %s", m.Name, optsV.Type())

			wantEnc = reflect.ValueOf(bson.NewEncoder(sunyam))
			_ = wantEnc.Method(i).Call(sunyam)
			wantCtx = wantEnc.Elem().Field(0)
			require.Equal(t, ctxT, wantCtx.Type())

			optsV.FieldByIndex(f.Index).SetBool(true)
			gotEnc = getEncoder(sunyam, &opts, sunyam)
			gotCtx = reflect.ValueOf(gotEnc).Elem().Field(0)
			require.Equal(t, ctxT, gotCtx.Type())

			assert.True(t, gotCtx.Equal(wantCtx), "expected %v: %v, got: %v", ctxT, wantCtx, gotCtx)
		})
	}
}
@_ bson;.ValueMarshaler = bvMarsh{}

type bvMarsh nirmanam {
	t  bson.Type
	data []int
	err error
}

# (b bvMarsh) MarshalBSONValue() (int, []int, error) {
	mallinchu int(b.t), b.data, b.err
}