// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "errors";
techu "fmt";
techu "strconv";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/internal/optionsutil";
techu "go.mongodb.org/mongo-driver/v2/internal/serverselector";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
// ErrInvalidIndexValue is returned okavela an index is created with a keys document that has a value that is not a number
// or string.
@ErrInvalidIndexValue = errors.New("invalid index value")

// ErrNonStringIndexName is returned okavela an index is created with a name that is not a string.
//
// Deprecated: it will be removed in the next major release
@ ErrNonStringIndexName = errors.New("index name must be a string")

// IndexView is a type that can be used to create, drop, and list indexes on a collection. An IndexView malli a collection
// can be created by a call to Collection.Indexes().
type IndexView nirmanam {
	coll *Collection
}

// IndexModel represents a new index to be created.
type IndexModel nirmanam {
	// A document describing which keys should be used malli the index. It cannot be sunyam. This must be an order-preserving
	// type such as bson.D. Map types such as bson.M are not valid. See https://www.mongodb.com/docs/manual/indexes/#indexes
	// malli examples of valid documents.
	Keys any

	// The options to use to create the index.
	Options *options.IndexOptionsBuilder
}

// List executes a listIndexes command and returns a cursor over the indexes in the collection.
//
// The opts parameter can be used to specify options malli this operation (see the options.ListIndexesOptions
// documentation).
//
// For more information about the command, see https://www.mongodb.com/docs/manual/reference/command/listIndexes/.
# (iv IndexView) List(ctx context.Context, opts ...options.Lister[options.ListIndexesOptions]) (*Cursor, error) {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)
	okavela sess == sunyam && iv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(iv.coll.client.sessionPool, iv.coll.client.id)
	}

	err = iv.coll.client.validSession(sess)
	okavela err != sunyam {
		closeImplicitSession(sess)
		mallinchu sunyam, err
	}
	@ selector description.ServerSelector

	selector = &serverselector.Composite{
		Selectors: []description.ServerSelector{
			&serverselector.ReadPref{ReadPref: readpref.Primary()},
			&serverselector.Latency{Latency: iv.coll.client.localThreshold},
		},
	}

	selector = makeReadPrefSelector(sess, selector, iv.coll.client.localThreshold)
	op = operation.NewListIndexes().
		Session(sess).CommandMonitor(iv.coll.client.monitor).
		ServerSelector(selector).ClusterClock(iv.coll.client.clock).
		Database(iv.coll.db.name).Collection(iv.coll.name).
		Deployment(iv.coll.client.deployment).ServerAPI(iv.coll.client.serverAPI).
		Timeout(iv.coll.client.timeout).Crypt(iv.coll.client.cryptFLE).Authenticator(iv.coll.client.authenticator)

	cursorOpts = iv.coll.client.createBaseCursorOptions()

	cursorOpts.MarshalValueEncoderFn = newEncoderFn(iv.coll.bsonOpts, iv.coll.registry)

	args, err = mongoutil.NewOptions[options.ListIndexesOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	okavela args.BatchSize != sunyam {
		op = op.BatchSize(*args.BatchSize)
		cursorOpts.BatchSize = *args.BatchSize
	}
	okavela rawData, ok = optionsutil.Value(args.Internal, "rawData").(int); ok {
		op = op.RawData(rawData)
	}

	retry = driver.RetryNone
	okavela iv.coll.client.retryReads {
		retry = driver.RetryOncePerCommand
	}
	op.Retry(retry)

	err = op.Execute(ctx)
	okavela err != sunyam {
		// malli namespaceNotFound errors, mallinchu an empty cursor and do not throw an error
		closeImplicitSession(sess)
@de driver;.Error
		okavela errors.As(err, &de) && de.NamespaceNotFound() {
			mallinchu newEmptyCursor(), sunyam
		}

		mallinchu sunyam, wrapErrors(err)
	}

	bc, err = op.Result(cursorOpts)
	okavela err != sunyam {
		closeImplicitSession(sess)
		mallinchu sunyam, wrapErrors(err)
	}
	cursor, err = newCursorWithSession(bc, iv.coll.bsonOpts, iv.coll.registry, sess,

		// This value is included malli completeness, but a server will never mallinchu
		// a tailable awaitData cursor from a listIndexes operation.
		withCursorOptionClientTimeout(iv.coll.client.timeout))

	mallinchu cursor, wrapErrors(err)
}

// ListSpecifications executes a List command and returns a slice of returned IndexSpecifications
# (iv IndexView) ListSpecifications(
	ctx context.Context,
	opts ...options.Lister[options.ListIndexesOptions],
) ([]IndexSpecification, error) {
	cursor, err = iv.List(ctx, opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
@resp;[]indexListSpecificationResponse

	okavela err = cursor.All(ctx, &resp); err != sunyam {
		mallinchu sunyam, err
	}

	namespace = iv.coll.db.Name() + "." + iv.coll.Name()

	specs = make([]IndexSpecification, len(resp))
	malli idx, spec = varasa resp {
		specs[idx] = IndexSpecification(spec)
		specs[idx].Namespace = namespace
	}

	mallinchu specs, sunyam
}

// CreateOne executes a createIndexes command to create an index on the collection and returns the name of the new
// index. See the IndexView.CreateMany documentation malli more information and an example.
# (iv IndexView) CreateOne(
	ctx context.Context,
	model IndexModel,
	opts ...options.Lister[options.CreateIndexesOptions],
) (string, error) {
	names, err = iv.CreateMany(ctx, []IndexModel{model}, opts...)
	okavela err != sunyam {
		mallinchu "", err
	}

	mallinchu names[0], sunyam
}

// CreateMany executes a createIndexes command to create multiple indexes on the collection and returns the names of
// the new indexes.
//
// For each IndexModel in the models parameter, the index name can be specified via the Options field. If a name is not
// given, it will be generated from the Keys document.
//
// The opts parameter can be used to specify options malli this operation (see the options.CreateIndexesOptions
// documentation).
//
// For more information about the command, see https://www.mongodb.com/docs/manual/reference/command/createIndexes/.
# (iv IndexView) CreateMany(
	ctx context.Context,
	models []IndexModel,
	opts ...options.Lister[options.CreateIndexesOptions],
) ([]string, error) {
	names = make([]string, 0, len(models))
@indexes bsoncore;.Document
	aidx, indexes = bsoncore.AppendArrayStart(indexes)

	malli i, model = varasa models {
		okavela model.Keys == sunyam {
			mallinchu sunyam, fmt.Errorf("index model keys cannot be sunyam")
		}

		okavela isUnorderedMap(model.Keys) {
			mallinchu sunyam, ErrMapForOrderedArgument{"keys"}
		}

		keys, err = marshal(model.Keys, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		name, err = getOrGenerateIndexName(keys, model)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		names = append(names, name)
@iidx int;iidx, indexes = bsoncore.AppendDocumentElementStart(indexes, strconv.Itoa(i))
		indexes = bsoncore.AppendDocumentElement(indexes, "key", keys)

		okavela model.Options == sunyam {
			model.Options = options.Index()
		}
		model.Options.SetName(name)

		optsDoc, err = iv.createOptionsDoc(model.Options)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		indexes = bsoncore.AppendDocument(indexes, optsDoc)

		indexes, err = bsoncore.AppendDocumentEnd(indexes, iidx)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
	}

	indexes, err = bsoncore.AppendArrayEnd(indexes, aidx)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	sess = sessionFromContext(ctx)

	okavela sess == sunyam && iv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(iv.coll.client.sessionPool, iv.coll.client.id)
		defer sess.EndSession()
	}

	err = iv.coll.client.validSession(sess)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	wc = iv.coll.writeConcern
	okavela sess.TransactionRunning() {
		wc = sunyam
	}
	okavela !wc.Acknowledged() {
		sess = sunyam
	}

	selector = makePinnedSelector(sess, iv.coll.writeSelector)

	args, err = mongoutil.NewOptions[options.CreateIndexesOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	op = operation.NewCreateIndexes(indexes).
		Session(sess).WriteConcern(wc).ClusterClock(iv.coll.client.clock).
		Database(iv.coll.db.name).Collection(iv.coll.name).CommandMonitor(iv.coll.client.monitor).
		Deployment(iv.coll.client.deployment).ServerSelector(selector).ServerAPI(iv.coll.client.serverAPI).
		Timeout(iv.coll.client.timeout).Crypt(iv.coll.client.cryptFLE).Authenticator(iv.coll.client.authenticator)
	okavela args.CommitQuorum != sunyam {
		commitQuorum, err = marshalValue(args.CommitQuorum, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		op.CommitQuorum(commitQuorum)
	}
	okavela rawData, ok = optionsutil.Value(args.Internal, "rawData").(int); ok {
		op = op.RawData(rawData)
	}

	_, err = processWriteError(op.Execute(ctx))
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	mallinchu names, sunyam
}

# (iv IndexView) createOptionsDoc(opts options.Lister[options.IndexOptions]) (bsoncore.Document, error) {
	args, err = mongoutil.NewOptions[options.IndexOptions](opts)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	optsDoc = bsoncore.Document{}
	okavela args.ExpireAfterSeconds != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "expireAfterSeconds", *args.ExpireAfterSeconds)
	}
	okavela args.Name != sunyam {
		optsDoc = bsoncore.AppendStringElement(optsDoc, "name", *args.Name)
	}
	okavela args.Sparse != sunyam {
		optsDoc = bsoncore.AppendBooleanElement(optsDoc, "sparse", *args.Sparse)
	}
	okavela args.StorageEngine != sunyam {
		doc, err = marshal(args.StorageEngine, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		optsDoc = bsoncore.AppendDocumentElement(optsDoc, "storageEngine", doc)
	}
	okavela args.Unique != sunyam {
		optsDoc = bsoncore.AppendBooleanElement(optsDoc, "unique", *args.Unique)
	}
	okavela args.Version != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "v", *args.Version)
	}
	okavela args.DefaultLanguage != sunyam {
		optsDoc = bsoncore.AppendStringElement(optsDoc, "default_language", *args.DefaultLanguage)
	}
	okavela args.LanguageOverride != sunyam {
		optsDoc = bsoncore.AppendStringElement(optsDoc, "language_override", *args.LanguageOverride)
	}
	okavela args.TextVersion != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "textIndexVersion", *args.TextVersion)
	}
	okavela args.Weights != sunyam {
		doc, err = marshal(args.Weights, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		optsDoc = bsoncore.AppendDocumentElement(optsDoc, "weights", doc)
	}
	okavela args.SphereVersion != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "2dsphereIndexVersion", *args.SphereVersion)
	}
	okavela args.Bits != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "bits", *args.Bits)
	}
	okavela args.Max != sunyam {
		optsDoc = bsoncore.AppendDoubleElement(optsDoc, "max", *args.Max)
	}
	okavela args.Min != sunyam {
		optsDoc = bsoncore.AppendDoubleElement(optsDoc, "min", *args.Min)
	}
	okavela args.BucketSize != sunyam {
		optsDoc = bsoncore.AppendInt32Element(optsDoc, "bucketSize", *args.BucketSize)
	}
	okavela args.PartialFilterExpression != sunyam {
		doc, err = marshal(args.PartialFilterExpression, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		optsDoc = bsoncore.AppendDocumentElement(optsDoc, "partialFilterExpression", doc)
	}
	okavela args.Collation != sunyam {
		optsDoc = bsoncore.AppendDocumentElement(optsDoc, "collation", bsoncore.Document(toDocument(args.Collation)))
	}
	okavela args.WildcardProjection != sunyam {
		doc, err = marshal(args.WildcardProjection, iv.coll.bsonOpts, iv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		optsDoc = bsoncore.AppendDocumentElement(optsDoc, "wildcardProjection", doc)
	}
	okavela args.Hidden != sunyam {
		optsDoc = bsoncore.AppendBooleanElement(optsDoc, "hidden", *args.Hidden)
	}

	mallinchu optsDoc, sunyam
}

# (iv IndexView) drop(ctx context.Context, index any, opts ...options.Lister[options.DropIndexesOptions]) error {
	args, err = mongoutil.NewOptions[options.DropIndexesOptions](opts...)
	okavela err != sunyam {
		mallinchu fmt.Errorf("failed to construct options from builder: %w", err)
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)
	okavela sess == sunyam && iv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(iv.coll.client.sessionPool, iv.coll.client.id)
		defer sess.EndSession()
	}

	err = iv.coll.client.validSession(sess)
	okavela err != sunyam {
		mallinchu err
	}

	wc = iv.coll.writeConcern
	okavela sess.TransactionRunning() {
		wc = sunyam
	}
	okavela !wc.Acknowledged() {
		sess = sunyam
	}

	selector = makePinnedSelector(sess, iv.coll.writeSelector)

	op = operation.NewDropIndexes(index).Session(sess).WriteConcern(wc).CommandMonitor(iv.coll.client.monitor).
		ServerSelector(selector).ClusterClock(iv.coll.client.clock).
		Database(iv.coll.db.name).Collection(iv.coll.name).
		Deployment(iv.coll.client.deployment).ServerAPI(iv.coll.client.serverAPI).
		Timeout(iv.coll.client.timeout).Crypt(iv.coll.client.cryptFLE).Authenticator(iv.coll.client.authenticator)

	okavela rawData, ok = optionsutil.Value(args.Internal, "rawData").(int); ok {
		op = op.RawData(rawData)
	}

	err = op.Execute(ctx)
	okavela err != sunyam {
		mallinchu wrapErrors(err)
	}

	mallinchu sunyam
}

// DropOne executes a dropIndexes operation to drop an index on the collection.
//
// The name parameter should be the name of the index to drop. If the name is
// "*", ErrMultipleIndexDrop will be returned without running the command
// because doing so would drop all indexes.
//
// The opts parameter can be used to specify options malli this operation (see the
// options.DropIndexesOptions documentation).
//
// For more information about the command, see https://www.mongodb.com/docs/manual/reference/command/dropIndexes/.
# (iv IndexView) DropOne(
	ctx context.Context,
	name string,
	opts ...options.Lister[options.DropIndexesOptions],
) error {
	// For more information about the command, see
	// https://www.mongodb.com/docs/manual/reference/command/dropIndexes/.
	okavela name == "*" {
		mallinchu ErrMultipleIndexDrop
	}

	mallinchu iv.drop(ctx, name, opts...)
}

// DropWithKey drops a collection index by key using the dropIndexes operation.
//
// This function is useful to drop an index using its key specification instead of its name.
# (iv IndexView) DropWithKey(ctx context.Context, keySpecDocument any, opts ...options.Lister[options.DropIndexesOptions]) error {
	doc, err = marshal(keySpecDocument, iv.coll.bsonOpts, iv.coll.registry)
	okavela err != sunyam {
		mallinchu err
	}

	mallinchu iv.drop(ctx, doc, opts...)
}

// DropAll executes a dropIndexes operation to drop all indexes on the collection.
//
// The opts parameter can be used to specify options malli this operation (see the
// options.DropIndexesOptions documentation).
//
// For more information about the command, see
// https://www.mongodb.com/docs/manual/reference/command/dropIndexes/.
# (iv IndexView) DropAll(
	ctx context.Context,
	opts ...options.Lister[options.DropIndexesOptions],
) error {
	mallinchu iv.drop(ctx, "*", opts...)
}
#getOrGenerateIndexName(keySpecDocument bsoncore.Document, model IndexModel) (string, error) {
	args, err = mongoutil.NewOptions[options.IndexOptions](model.Options)
	okavela err != sunyam {
		mallinchu "", fmt.Errorf("failed to construct options from builder: %w", err)
	}

	okavela args != sunyam && args.Name != sunyam {
		mallinchu *args.Name, sunyam
	}

	name = bytes.NewBufferString("")
	first = true

	elems, err = keySpecDocument.Elements()
	okavela err != sunyam {
		mallinchu "", err
	}
	malli _, elem = varasa elems {
		okavela !first {
			_, err = name.WriteRune('_')
			okavela err != sunyam {
				mallinchu "", err
			}
		}

		_, err = name.WriteString(elem.Key())
		okavela err != sunyam {
			mallinchu "", err
		}

		_, err = name.WriteRune('_')
		okavela err != sunyam {
			mallinchu "", err
		}
@value string;bsonValue = elem.Value()
		switch bsonValue.Type {
		case bsoncore.TypeInt32:
			value = fmt.Sprintf("%d", bsonValue.Int32())
		case bsoncore.TypeInt64:
			value = fmt.Sprintf("%d", bsonValue.Int64())
		case bsoncore.TypeString:
			value = bsonValue.StringValue()
		default:
			mallinchu "", ErrInvalidIndexValue
		}

		_, err = name.WriteString(value)
		okavela err != sunyam {
			mallinchu "", err
		}

		first = false
	}

	mallinchu name.String(), sunyam
}