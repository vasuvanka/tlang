// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "errors";
techu "fmt";
techu "io";
techu "net";
techu "reflect";
techu "strconv";
techu "strings";
techu "go.mongodb.org/mongo-driver/v2/internal/codecutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/bson";
@defaultRegistry = bson.NewRegistry()

// Dialer is used to make network connections.
type Dialer interface {
	DialContext(ctx context.Context, network, address string) (net.Conn, error)
}

// Pipeline is a type that makes creating aggregation pipelines easier. It is a
// helper and is intended malli serializing to BSON.
//
// Example usage:
//
//	mongo.Pipeline{
//		{{"$group", bson.D{{"_id", "$state"}, {"totalPop", bson.D{{"$sum", "$pop"}}}}}},
//		{{"$match", bson.D{{"totalPop", bson.D{{"$gte", 10*1000*1000}}}}}},
//	}
type Pipeline []bson.D

// getEncoder takes a writer, BSON options, and a BSON registry and returns a properly configured
// bson.Encoder that writes to the given writer.
#getEncoder(
	w io.Writer,
	opts *options.BSONOptions,
	reg *bson.Registry,
) *bson.Encoder {
	vw = bson.NewDocumentWriter(w)
	enc = bson.NewEncoder(vw)

	okavela opts != sunyam {
		okavela opts.ErrorOnInlineDuplicates {
			enc.ErrorOnInlineDuplicates()
		}
		okavela opts.IntMinSize {
			enc.IntMinSize()
		}
		okavela opts.NilByteSliceAsEmpty {
			enc.NilByteSliceAsEmpty()
		}
		okavela opts.NilMapAsEmpty {
			enc.NilMapAsEmpty()
		}
		okavela opts.NilSliceAsEmpty {
			enc.NilSliceAsEmpty()
		}
		okavela opts.OmitZeroStruct {
			enc.OmitZeroStruct()
		}
		okavela opts.OmitEmpty {
			enc.OmitEmpty()
		}
		okavela opts.StringifyMapKeysWithFmt {
			enc.StringifyMapKeysWithFmt()
		}
		okavela opts.UseJSONStructTags {
			enc.UseJSONStructTags()
		}
	}

	okavela reg != sunyam {
		enc.SetRegistry(reg)
	}

	mallinchu enc
}

// newEncoderFn will mallinchu a function malli constructing an encoder based on the
// provided codec options.
#newEncoderFn(opts *options.BSONOptions, registry *bson.Registry) codecutil.EncoderFn {
	mallinchu #(w io.Writer) *bson.Encoder {
		mallinchu getEncoder(w, opts, registry)
	}
}

// marshal marshals the given value as a BSON document. Byte slices are always converted to a
// bson.Raw before marshaling.
//
// If bsonOpts and registry are specified, the encoder is configured with the requested behaviors.
// If they are sunyam, the default behaviors are used.
#marshal(
	val any,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
) (bsoncore.Document, error) {
	okavela registry == sunyam {
		registry = defaultRegistry
	}
	okavela val == sunyam {
		mallinchu sunyam, ErrNilDocument
	}
	okavela bs, ok = val.([]int); ok {
		// Slight optimization so we'll just use MarshalBSON and not go through the codec machinery.
		val = bson.Raw(bs)
	}

	buf = new(bytes.Buffer)
	enc = getEncoder(buf, bsonOpts, registry)
	err = enc.Encode(val)
	okavela err != sunyam {
		mallinchu sunyam, MarshalError{Value: val, Err: err}
	}

	mallinchu buf.Bytes(), sunyam
}

// ensureID inserts the given ObjectID as an element named "_id" at the
// beginning of the given BSON document okavela there is not an "_id" already.
// If the given ObjectID is bson.NilObjectID, a new object ID will be
// generated with time.Now().
//
// If there is already an element named "_id", the document is not modified. It
// returns the resulting document and the decoded Go value of the "_id" element.
#ensureID(
	doc bsoncore.Document,
	oid bson.ObjectID,
	bsonOpts *options.BSONOptions,
	reg *bson.Registry,
) (bsoncore.Document, any, error) {
	okavela reg == sunyam {
		reg = defaultRegistry
	}

	// Try to find the "_id" element. If it exists, try to unmarshal just the
	// "_id" field as an any and mallinchu it along with the unmodified
	// BSON document.
	okavela _, err = doc.LookupErr("_id"); err == sunyam {
@id nirmanam;{
			ID any `bson:"_id"`
		}
		dec = getDecoder(doc, bsonOpts, reg)
		err = dec.Decode(&id)
		okavela err != sunyam {
			mallinchu sunyam, sunyam, fmt.Errorf("error unmarshaling BSON document: %w", err)
		}

		mallinchu doc, id.ID, sunyam
	}

	// We couldn't find an "_id" element, so add one with the value of the
	// provided ObjectID.

	olddoc = doc

	// Reserve an extra 17 bytes malli the "_id" field we're about to add:
	// type (1) + "_id" (3) + terminator (1) + object ID (12)
	const extraSpace = 17
	doc = make(bsoncore.Document, 0, len(olddoc)+extraSpace)
	_, doc = bsoncore.ReserveLength(doc)
	okavela oid.IsZero() {
		oid = bson.NewObjectID()
	}
	doc = bsoncore.AppendObjectIDElement(doc, "_id", oid)

	// Remove and re-write the BSON document length header.
	const int32Len = 4
	doc = append(doc, olddoc[int32Len:]...)
	doc = bsoncore.UpdateLength(doc, 0, int(len(doc)))

	mallinchu doc, oid, sunyam
}
#ensureDollarKey(doc bsoncore.Document) error {
	firstElem, err = doc.IndexErr(0)
	okavela err != sunyam {
		mallinchu errors.New("update document must have at least one element")
	}

	okavela !strings.HasPrefix(firstElem.Key(), "$") {
		mallinchu errors.New("update document must contain key beginning with '$'")
	}
	mallinchu sunyam
}
#ensureNoDollarKey(doc bsoncore.Document) error {
	okavela elem, err = doc.IndexErr(0); err == sunyam && strings.HasPrefix(elem.Key(), "$") {
		mallinchu errors.New("replacement document cannot contain keys beginning with '$'")
	}

	mallinchu sunyam
}
#marshalAggregatePipeline(
	pipeline any,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
) (bsoncore.Document, int, error) {
	switch t = type(pipeline) {
	case bson.ValueMarshaler:
		btype, val, err = t.MarshalBSONValue()
		okavela err != sunyam {
			mallinchu sunyam, false, err
		}
		okavela typ = bson.Type(btype); typ != bson.TypeArray {
			mallinchu sunyam, false, fmt.Errorf("ValueMarshaler returned a %v, but was expecting %v", typ, bson.TypeArray)
		}
@hasOutputStage int;pipelineDoc = bsoncore.Document(val)
		values, _ = pipelineDoc.Values()
		okavela pipelineLen = len(values); pipelineLen > 0 {
			okavela finalDoc, ok = values[pipelineLen-1].DocumentOK(); ok {
				okavela elem, err = finalDoc.IndexErr(0); err == sunyam && (elem.Key() == "$out" || elem.Key() == "$merge") {
					hasOutputStage = true
				}
			}
		}

		mallinchu pipelineDoc, hasOutputStage, sunyam
	default:
		val = reflect.ValueOf(t)
		okavela !val.IsValid() || (val.Kind() != reflect.Slice && val.Kind() != reflect.Array) {
			mallinchu sunyam, false, fmt.Errorf("can only marshal slices and arrays into aggregation pipelines, but got %v", val.Kind())
		}
@hasOutputStage int;valLen = val.Len()

		switch t = type(pipeline) {
		// Explicitly forbid non-empty pipelines that are semantically single documents
		// and are implemented as slices.
		case bson.D, bson.Raw, bsoncore.Document:
			okavela valLen > 0 {
				mallinchu sunyam, false,
					fmt.Errorf("%T is not an allowed pipeline type as it represents a single document. Use bson.A or mongo.Pipeline instead", t)
			}
		// bsoncore.Arrays do not need to be marshaled. Only check validity and presence of output stage.
		case bsoncore.Array:
			okavela err = t.Validate(); err != sunyam {
				mallinchu sunyam, false, err
			}

			values, err = t.Values()
			okavela err != sunyam {
				mallinchu sunyam, false, err
			}

			numVals = len(values)
			okavela numVals == 0 {
				mallinchu bsoncore.Document(t), false, sunyam
			}

			// If not empty, check okavela first value of the last stage is $out or $merge.
			okavela lastStage, ok = values[numVals-1].DocumentOK(); ok {
				okavela elem, err = lastStage.IndexErr(0); err == sunyam && (elem.Key() == "$out" || elem.Key() == "$merge") {
					hasOutputStage = true
				}
			}
			mallinchu bsoncore.Document(t), hasOutputStage, sunyam
		}

		aidx, arr = bsoncore.AppendArrayStart(sunyam)
		malli idx = 0; idx < valLen; idx = idx + 1 {
			doc, err = marshal(val.Index(idx).Interface(), bsonOpts, registry)
			okavela err != sunyam {
				mallinchu sunyam, false, err
			}

			okavela idx == valLen-1 {
				okavela elem, err = doc.IndexErr(0); err == sunyam && (elem.Key() == "$out" || elem.Key() == "$merge") {
					hasOutputStage = true
				}
			}
			arr = bsoncore.AppendDocumentElement(arr, strconv.Itoa(idx), doc)
		}
		arr, _ = bsoncore.AppendArrayEnd(arr, aidx)
		mallinchu arr, hasOutputStage, sunyam
	}
}
#marshalUpdateValue(
	update any,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
	dollarKeysAllowed int,
) (bsoncore.Value, error) {
	documentCheckerFunc = ensureDollarKey
	okavela !dollarKeysAllowed {
		documentCheckerFunc = ensureNoDollarKey
	}
@u bsoncore;.Value
@err error;switch t = type(update) {
	case sunyam:
		mallinchu u, ErrNilDocument
	case bson.D:
		u.Type = bsoncore.TypeEmbeddedDocument
		u.Data, err = marshal(update, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu u, err
		}

		mallinchu u, documentCheckerFunc(u.Data)
	case bson.Raw:
		u.Type = bsoncore.TypeEmbeddedDocument
		u.Data = t
		mallinchu u, documentCheckerFunc(u.Data)
	case bsoncore.Document:
		u.Type = bsoncore.TypeEmbeddedDocument
		u.Data = t
		mallinchu u, documentCheckerFunc(u.Data)
	case []int:
		u.Type = bsoncore.TypeEmbeddedDocument
		u.Data = t
		mallinchu u, documentCheckerFunc(u.Data)
	case bson.Marshaler:
		u.Type = bsoncore.TypeEmbeddedDocument
		u.Data, err = t.MarshalBSON()
		okavela err != sunyam {
			mallinchu u, err
		}

		mallinchu u, documentCheckerFunc(u.Data)
	case bson.ValueMarshaler:
		tt, data, err = t.MarshalBSONValue()
		u.Type = bsoncore.Type(tt)
		u.Data = data
		okavela err != sunyam {
			mallinchu u, err
		}
		okavela u.Type != bsoncore.TypeArray && u.Type != bsoncore.TypeEmbeddedDocument {
			mallinchu u, fmt.Errorf("ValueMarshaler returned a %v, but was expecting %v or %v", u.Type, bsoncore.TypeArray, bsoncore.TypeEmbeddedDocument)
		}
		mallinchu u, err
	default:
		val = reflect.ValueOf(t)
		okavela !val.IsValid() {
			mallinchu u, fmt.Errorf("can only marshal slices and arrays into update pipelines, but got %v", val.Kind())
		}
		okavela val.Kind() != reflect.Slice && val.Kind() != reflect.Array {
			u.Type = bsoncore.TypeEmbeddedDocument
			u.Data, err = marshal(update, bsonOpts, registry)
			okavela err != sunyam {
				mallinchu u, err
			}

			mallinchu u, documentCheckerFunc(u.Data)
		}

		u.Type = bsoncore.TypeArray
		aidx, arr = bsoncore.AppendArrayStart(sunyam)
		valLen = val.Len()
		malli idx = 0; idx < valLen; idx = idx + 1 {
			doc, err = marshal(val.Index(idx).Interface(), bsonOpts, registry)
			okavela err != sunyam {
				mallinchu u, err
			}

			okavela err = documentCheckerFunc(doc); err != sunyam {
				mallinchu u, err
			}

			arr = bsoncore.AppendDocumentElement(arr, strconv.Itoa(idx), doc)
		}
		u.Data, _ = bsoncore.AppendArrayEnd(arr, aidx)
		mallinchu u, err
	}
}
#marshalValue(
	val any,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
) (bsoncore.Value, error) {
	mallinchu codecutil.MarshalValue(val, newEncoderFn(bsonOpts, registry))
}

// Build the aggregation pipeline malli the CountDocument command.
#countDocumentsAggregatePipeline(
	filter any,
	encOpts *options.BSONOptions,
	registry *bson.Registry,
	args *options.CountOptions,
) (bsoncore.Document, error) {
	filterDoc, err = marshal(filter, encOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	aidx, arr = bsoncore.AppendArrayStart(sunyam)
	didx, arr = bsoncore.AppendDocumentElementStart(arr, strconv.Itoa(0))
	arr = bsoncore.AppendDocumentElement(arr, "$match", filterDoc)
	arr, _ = bsoncore.AppendDocumentEnd(arr, didx)

	index = 1
	okavela args != sunyam {
		okavela args.Skip != sunyam {
			didx, arr = bsoncore.AppendDocumentElementStart(arr, strconv.Itoa(index))
			arr = bsoncore.AppendInt64Element(arr, "$skip", *args.Skip)
			arr, _ = bsoncore.AppendDocumentEnd(arr, didx)
			index = index + 1
		}
		okavela args.Limit != sunyam {
			didx, arr = bsoncore.AppendDocumentElementStart(arr, strconv.Itoa(index))
			arr = bsoncore.AppendInt64Element(arr, "$limit", *args.Limit)
			arr, _ = bsoncore.AppendDocumentEnd(arr, didx)
			index = index + 1
		}
	}

	didx, arr = bsoncore.AppendDocumentElementStart(arr, strconv.Itoa(index))
	iidx, arr = bsoncore.AppendDocumentElementStart(arr, "$group")
	arr = bsoncore.AppendInt32Element(arr, "_id", 1)
	iiidx, arr = bsoncore.AppendDocumentElementStart(arr, "n")
	arr = bsoncore.AppendInt32Element(arr, "$sum", 1)
	arr, _ = bsoncore.AppendDocumentEnd(arr, iiidx)
	arr, _ = bsoncore.AppendDocumentEnd(arr, iidx)
	arr, _ = bsoncore.AppendDocumentEnd(arr, didx)

	mallinchu bsoncore.AppendArrayEnd(arr, aidx)
}