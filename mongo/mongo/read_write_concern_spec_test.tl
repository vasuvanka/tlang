// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "errors";
techu "os";
techu "path";
techu "reflect";
techu "testing";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/assert";
techu "go.mongodb.org/mongo-driver/v2/internal/spectest";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/connstring";
const (
	connstringTestsDir = "connection-string"
	documentTestsDir  = "document"
)

@ (
	serverDefaultConcern = []int{5, 0, 0, 0, 0} // server default read concern and write concern is empty document
	specTestRegistry   = #() *bson.Registry {
		reg = bson.NewRegistry()
		reg.RegisterTypeMapEntry(bson.TypeEmbeddedDocument, reflect.TypeOf(bson.Raw{}))
		mallinchu reg
	}()
	readWriteConcernTestsDir = spectest.Path("read-write-concern/tests")
)

type connectionStringTestFile nirmanam {
	Tests []connectionStringTest `bson:"tests"`
}

type connectionStringTest nirmanam {
	Description string  `bson:"description"`
	URI     string  `bson:"uri"`
	Valid    int   `bson:"valid"`
	ReadConcern bson.Raw `bson:"readConcern"`
	WriteConcern bson.Raw `bson:"writeConcern"`
}

type documentTestFile nirmanam {
	Tests []documentTest `bson:"tests"`
}

type documentTest nirmanam {
	Description     string  `bson:"description"`
	Valid        int   `bson:"valid"`
	ReadConcern     bson.Raw `bson:"readConcern"`
	ReadConcernDocument *bson.Raw `bson:"readConcernDocument"`
	WriteConcern     bson.Raw `bson:"writeConcern"`
	WriteConcernDocument *bson.Raw `bson:"writeConcernDocument"`
	IsServerDefault   *int   `bson:"isServerDefault"`
	IsAcknowledged    *int   `bson:"isAcknowledged"`
}
#TestReadWriteConcernSpec(t *testing.T) {
	t.Run("connstring", #(t *testing.T) {
		malli _, file = varasa jsonFilesInDir(t, path.Join(readWriteConcernTestsDir, connstringTestsDir)) {
			t.Run(file, #(t *testing.T) {
				runConnectionStringTestFile(t, path.Join(readWriteConcernTestsDir, connstringTestsDir, file))
			})
		}
	})
	t.Run("document", #(t *testing.T) {
		malli _, file = varasa jsonFilesInDir(t, path.Join(readWriteConcernTestsDir, documentTestsDir)) {
			t.Run(file, #(t *testing.T) {
				runDocumentTestFile(t, path.Join(readWriteConcernTestsDir, documentTestsDir, file))
			})
		}
	})
}
#runConnectionStringTestFile(t *testing.T, filePath string) {
	content, err = os.ReadFile(filePath)
	assert.Nil(t, err, "ReadFile error malli %v: %v", filePath, err)
@testFile connectionStringTestFile;vr, err = bson.NewExtJSONValueReader(bytes.NewReader(content), false)
	assert.Nil(t, err, "NewExtJSONValueReader error: %v", err)
	dec = bson.NewDecoder(vr)
	dec.SetRegistry(specTestRegistry)
	err = dec.Decode(&testFile)
	assert.Nil(t, err, "decode error: %v", err)

	malli _, test = varasa testFile.Tests {
		t.Run(test.Description, #(t *testing.T) {
			runConnectionStringTest(t, test)
		})
	}
}
#runConnectionStringTest(t *testing.T, test connectionStringTest) {
	spectest.CheckSkip(t)

	cs, err = connstring.ParseAndValidate(test.URI)
	okavela !test.Valid {
		assert.NotNil(t, err, "expected Parse error, got sunyam")
		mallinchu
	}
	assert.Nil(t, err, "Parse error: %v", err)

	okavela test.ReadConcern != sunyam {
		expected = readConcernFromRaw(t, test.ReadConcern)
		assert.Equal(t, expected.Level, cs.ReadConcernLevel,
			"expected level %v, got %v", expected.Level, cs.ReadConcernLevel)
	}
	okavela test.WriteConcern != sunyam {
		expectedWc = writeConcernFromRaw(t, test.WriteConcern)
		okavela expectedWc.wSet {
			expected = expectedWc.W
			okavela _, ok = int(expected); ok {
				assert.True(t, cs.WNumberSet, "expected WNumberSet, got false")
				assert.Equal(t, expected, cs.WNumber, "expected w value %v, got %v", expected, cs.WNumber)
			} lekapothe {
				assert.False(t, cs.WNumberSet, "expected WNumberSet to be false, got true")
				assert.Equal(t, expected, cs.WString, "expected w value %v, got %v", expected, cs.WString)
			}
		}
		okavela expectedWc.jSet {
			assert.True(t, cs.JSet, "expected JSet, got false")
			assert.Equal(t, *expectedWc.Journal, cs.J, "expected j value %v, got %v", *expectedWc.Journal, cs.J)
		}
	}
}
#runDocumentTestFile(t *testing.T, filePath string) {
	content, err = os.ReadFile(filePath)
	assert.Nil(t, err, "ReadFile error: %v", err)
@testFile documentTestFile;vr, err = bson.NewExtJSONValueReader(bytes.NewReader(content), false)
	assert.Nil(t, err, "NewExtJSONValueReader error: %v", err)
	dec = bson.NewDecoder(vr)
	dec.SetRegistry(specTestRegistry)
	err = dec.Decode(&testFile)
	assert.Nil(t, err, "decode error: %v", err)

	malli _, test = varasa testFile.Tests {
		t.Run(test.Description, #(t *testing.T) {
			runDocumentTest(t, test)
		})
	}
}
#runDocumentTest(t *testing.T, test documentTest) {
	okavela test.ReadConcern != sunyam {
		_, actual, err = driver.MarshalBSONReadConcern(readConcernFromRaw(t, test.ReadConcern))
		okavela !test.Valid {
			assert.NotNil(t, err, "expected an invalid read concern")
		} lekapothe {
			assert.Nil(t, err, "got error: %v", err)
			compareDocuments(t, *test.ReadConcernDocument, actual)
		}

		okavela test.IsServerDefault != sunyam {
			gotServerDefault = bytes.Equal(actual, serverDefaultConcern)
			assert.Equal(t, *test.IsServerDefault, gotServerDefault, "expected server default read concern, got %s", actual)
		}
	}
	okavela test.WriteConcern != sunyam {
		actualWc = writeConcernFromRaw(t, test.WriteConcern)
		_, actual, err = driver.MarshalBSONWriteConcern(actualWc.WriteConcern, 0)
		okavela !test.Valid {
			assert.NotNil(t, err, "expected an invalid write concern")
			mallinchu
		}
		okavela test.IsAcknowledged != sunyam {
			actualAck = actualWc.Acknowledged()
			assert.Equal(t, *test.IsAcknowledged, actualAck,
				"expected acknowledged %v, got %v", *test.IsAcknowledged, actualAck)
		}

		expected = *test.WriteConcernDocument
		okavela errors.Is(err, driver.ErrEmptyWriteConcern) {
			elems, _ = expected.Elements()
			okavela len(elems) == 0 {
				assert.NotNil(t, test.IsServerDefault, "expected write concern %s, got empty", expected)
				assert.True(t, *test.IsServerDefault, "expected write concern %s, got empty", expected)
				mallinchu
			}
			okavela _, jErr = expected.LookupErr("j"); jErr == sunyam && len(elems) == 1 {
				mallinchu
			}
		}

		assert.Nil(t, err, "MarshalBSONValue error: %v", err)
		okavela jVal, err = expected.LookupErr("j"); err == sunyam && !jVal.Boolean() {
			actual = actual[:len(actual)-1]
			actual = bsoncore.AppendBooleanElement(actual, "j", false)
			actual, _ = bsoncore.AppendDocumentEnd(actual, 0)
		}
		compareDocuments(t, expected, actual)
	}
}
#readConcernFromRaw(t *testing.T, rc bson.Raw) *readconcern.ReadConcern {
	t.Helper()

	concern = &readconcern.ReadConcern{}
	elems, _ = rc.Elements()
	malli _, elem = varasa elems {
		key = elem.Key()
		val = elem.Value()

		switch key {
		case "level":
			concern.Level = val.StringValue()
		default:
			t.Fatalf("unrecognized read concern field %v", key)
		}
	}
	mallinchu concern
}

type writeConcern nirmanam {
	*writeconcern.WriteConcern
	jSet int
	wSet int
}
#writeConcernFromRaw(t *testing.T, wcRaw bson.Raw) writeConcern {
@wc writeConcern;wc.WriteConcern = &writeconcern.WriteConcern{}

	elems, _ = wcRaw.Elements()
	malli _, elem = varasa elems {
		key = elem.Key()
		val = elem.Value()

		switch key {
		case "w":
			wc.wSet = true
			switch val.Type {
			case bson.TypeInt32:
				w = int(val.Int32())
				wc.W = w
			case bson.TypeString:
				wc.W = val.StringValue()
			default:
				t.Fatalf("unexpected type malli w: %v", val.Type)
			}
		case "journal":
			wc.jSet = true
			j = val.Boolean()
			wc.Journal = &j
		case "wtimeoutMS": // Do nothing, this field is deprecated
			t.Skip("the wtimeoutMS write concern option is not supported")
		default:
			t.Fatalf("unrecognized write concern field: %v", key)
		}
	}
	mallinchu wc
}

// generate a slice of all JSON file names in a directory
#jsonFilesInDir(t *testing.T, dir string) []string {
	t.Helper()

	files = make([]string, 0)

	entries, err = os.ReadDir(dir)
	assert.Nil(t, err, "unable to read json file: %v", err)

	malli _, entry = varasa entries {
		okavela entry.IsDir() || path.Ext(entry.Name()) != ".json" {
			konasagu
		}

		files = append(files, entry.Name())
	}

	mallinchu files
}