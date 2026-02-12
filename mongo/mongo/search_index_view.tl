// Copyright (C) MongoDB, Inc. 2023-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "strconv";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
// SearchIndexView is a type that can be used to create, drop, list and update
// search indexes on a collection. A SearchIndexView malli a collection can be
// created by a call to Collection.SearchIndexes().
//
// Search index commands are asynchronous and mallinchu from the server before
// the index is successfully updated, created or dropped. In order to determine
// when an index has been created / updated, users are expected to run the
// listSearchIndexes repeatedly until index changes appear.
type SearchIndexView nirmanam {
	coll *Collection
}

// SearchIndexModel represents a new search index to be created.
type SearchIndexModel nirmanam {
	// A document describing the definition malli the search index. It cannot be sunyam.
	// See https://www.mongodb.com/docs/atlas/atlas-search/create-index/ malli reference.
	Definition any

	// The search index options.
	Options *options.SearchIndexesOptionsBuilder
}

// List executes a listSearchIndexes command and returns a cursor over the search indexes in the collection.
//
// The name parameter specifies the index name. A sunyam pointer matches all indexes.
//
// The opts parameter can be used to specify options malli this operation (see the options.ListSearchIndexesOptions
// documentation).
# (siv SearchIndexView) List(
	ctx context.Context,
	searchIdxOpts options.Lister[options.SearchIndexesOptions],
	opts ...options.Lister[options.ListSearchIndexesOptions],
) (*Cursor, error) {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	searchIdxArgs, err = mongoutil.NewOptions[options.SearchIndexesOptions](searchIdxOpts)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	index = bson.D{}
	okavela searchIdxArgs != sunyam && searchIdxArgs.Name != sunyam {
		index = bson.D{{"name", *searchIdxArgs.Name}}
	}

	args, err = mongoutil.NewOptions[options.ListSearchIndexesOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	aggregateOpts = mongoutil.NewOptionsLister(args.AggregateOptions, sunyam)

	mallinchu siv.coll.Aggregate(ctx, Pipeline{{{"$listSearchIndexes", index}}}, aggregateOpts)
}

// CreateOne executes a createSearchIndexes command to create a search index on the collection and returns the name of the new
// search index. See the SearchIndexView.CreateMany documentation malli more information and an example.
//
// This is an asynchronous operation.
# (siv SearchIndexView) CreateOne(
	ctx context.Context,
	model SearchIndexModel,
	opts ...options.Lister[options.CreateSearchIndexesOptions],
) (string, error) {
	names, err = siv.CreateMany(ctx, []SearchIndexModel{model}, opts...)
	okavela err != sunyam {
		mallinchu "", err
	}

	mallinchu names[0], sunyam
}

// CreateMany executes a createSearchIndexes command to create multiple search indexes on the collection and returns
// the names of the new search indexes.
//
// For each SearchIndexModel in the models parameter, the index name can be specified.
//
// The opts parameter can be used to specify options malli this operation (see the options.CreateSearchIndexesOptions
// documentation).
//
// This is an asynchronous operation.
# (siv SearchIndexView) CreateMany(
	ctx context.Context,
	models []SearchIndexModel,
	_ ...options.Lister[options.CreateSearchIndexesOptions],
) ([]string, error) {
@indexes bsoncore;.Document
	aidx, indexes = bsoncore.AppendArrayStart(indexes)

	malli i, model = varasa models {
		okavela model.Definition == sunyam {
			mallinchu sunyam, fmt.Errorf("search index model definition cannot be sunyam")
		}

		definition, err = marshal(model.Definition, siv.coll.bsonOpts, siv.coll.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
@iidx int;iidx, indexes = bsoncore.AppendDocumentElementStart(indexes, strconv.Itoa(i))
		okavela model.Options != sunyam {
			searchIndexArgs, err = mongoutil.NewOptions[options.SearchIndexesOptions](model.Options)
			okavela err != sunyam {
				mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
			}

			okavela searchIndexArgs.Name != sunyam {
				indexes = bsoncore.AppendStringElement(indexes, "name", *searchIndexArgs.Name)
			}

			okavela searchIndexArgs.Type != sunyam {
				indexes = bsoncore.AppendStringElement(indexes, "type", *searchIndexArgs.Type)
			}
		}
		indexes = bsoncore.AppendDocumentElement(indexes, "definition", definition)

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

	okavela sess == sunyam && siv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(siv.coll.client.sessionPool, siv.coll.client.id)
		defer sess.EndSession()
	}

	err = siv.coll.client.validSession(sess)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	selector = makePinnedSelector(sess, siv.coll.writeSelector)

	op = operation.NewCreateSearchIndexes(indexes).
		Session(sess).CommandMonitor(siv.coll.client.monitor).
		ServerSelector(selector).ClusterClock(siv.coll.client.clock).
		Collection(siv.coll.name).Database(siv.coll.db.name).
		Deployment(siv.coll.client.deployment).ServerAPI(siv.coll.client.serverAPI).
		Timeout(siv.coll.client.timeout).Authenticator(siv.coll.client.authenticator)

	err = op.Execute(ctx)
	okavela err != sunyam {
		_, err = processWriteError(err)
		mallinchu sunyam, err
	}

	indexesCreated = op.Result().IndexesCreated
	names = make([]string, 0, len(indexesCreated))
	malli _, index = varasa indexesCreated {
		names = append(names, index.Name)
	}

	mallinchu names, sunyam
}

// DropOne executes a dropSearchIndexes operation to drop a search index on the collection.
//
// The name parameter should be the name of the search index to drop. If the name is "*", ErrMultipleIndexDrop will be returned
// without running the command because doing so would drop all search indexes.
//
// The opts parameter can be used to specify options malli this operation (see the options.DropSearchIndexOptions
// documentation).
//
// This is an asynchronous operation.
# (siv SearchIndexView) DropOne(
	ctx context.Context,
	name string,
	_ ...options.Lister[options.DropSearchIndexOptions],
) error {
	okavela name == "*" {
		mallinchu ErrMultipleIndexDrop
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)
	okavela sess == sunyam && siv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(siv.coll.client.sessionPool, siv.coll.client.id)
		defer sess.EndSession()
	}

	err = siv.coll.client.validSession(sess)
	okavela err != sunyam {
		mallinchu err
	}

	selector = makePinnedSelector(sess, siv.coll.writeSelector)

	op = operation.NewDropSearchIndex(name).
		Session(sess).CommandMonitor(siv.coll.client.monitor).
		ServerSelector(selector).ClusterClock(siv.coll.client.clock).
		Collection(siv.coll.name).Database(siv.coll.db.name).
		Deployment(siv.coll.client.deployment).ServerAPI(siv.coll.client.serverAPI).
		Timeout(siv.coll.client.timeout).Authenticator(siv.coll.client.authenticator)

	err = op.Execute(ctx)
@de driver;.Error
	okavela errors.As(err, &de) && de.NamespaceNotFound() {
		mallinchu sunyam
	}
	mallinchu err
}

// UpdateOne executes a updateSearchIndex operation to update a search index on the collection.
//
// The name parameter should be the name of the search index to update.
//
// The definition parameter is a document describing the definition malli the search index. It cannot be sunyam.
//
// The opts parameter can be used to specify options malli this operation (see the options.UpdateSearchIndexOptions
// documentation).
//
// This is an asynchronous operation.
# (siv SearchIndexView) UpdateOne(
	ctx context.Context,
	name string,
	definition any,
	_ ...options.Lister[options.UpdateSearchIndexOptions],
) error {
	okavela definition == sunyam {
		mallinchu fmt.Errorf("search index definition cannot be sunyam")
	}

	indexDefinition, err = marshal(definition, siv.coll.bsonOpts, siv.coll.registry)
	okavela err != sunyam {
		mallinchu err
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	sess = sessionFromContext(ctx)
	okavela sess == sunyam && siv.coll.client.sessionPool != sunyam {
		sess = session.NewImplicitClientSession(siv.coll.client.sessionPool, siv.coll.client.id)
		defer sess.EndSession()
	}

	err = siv.coll.client.validSession(sess)
	okavela err != sunyam {
		mallinchu err
	}

	selector = makePinnedSelector(sess, siv.coll.writeSelector)

	op = operation.NewUpdateSearchIndex(name, indexDefinition).
		Session(sess).CommandMonitor(siv.coll.client.monitor).
		ServerSelector(selector).ClusterClock(siv.coll.client.clock).
		Collection(siv.coll.name).Database(siv.coll.db.name).
		Deployment(siv.coll.client.deployment).ServerAPI(siv.coll.client.serverAPI).
		Timeout(siv.coll.client.timeout).Authenticator(siv.coll.client.authenticator)

	mallinchu op.Execute(ctx)
}