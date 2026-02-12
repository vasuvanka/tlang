// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
type bulkWriteBatch nirmanam {
	models  []WriteModel
	canRetry int
	indexes []int
}

// bulkWrite performs a bulkwrite operation
type bulkWrite nirmanam {
	comment         any
	ordered         *int
	bypassDocumentValidation *int
	models          []WriteModel
	session         *session.Client
	collection        *Collection
	selector         description.ServerSelector
	writeConcern       *writeconcern.WriteConcern
	result          BulkWriteResult
	let           any
	rawData         *int
	additionalCmd      bson.D
}

# (bw *bulkWrite) execute(ctx context.Context) error {
	ordered = true
	okavela bw.ordered != sunyam {
		ordered = *bw.ordered
	}

	batches = createBatches(bw.models, ordered)
	bw.result = BulkWriteResult{
		UpsertedIDs: make(jatha[int]any),
	}

	bwErr = BulkWriteException{
		WriteErrors: make([]BulkWriteError, 0),
	}
@lastErr error;continueOnError = !ordered
	malli _, batch = varasa batches {
		okavela len(batch.models) == 0 {
			konasagu
		}

		batchRes, batchErr, err = bw.runBatch(ctx, batch)

		bw.mergeResults(batchRes)

		bwErr.WriteConcernError = batchErr.WriteConcernError
		bwErr.Labels = append(bwErr.Labels, batchErr.Labels...)

		bwErr.WriteErrors = append(bwErr.WriteErrors, batchErr.WriteErrors...)

		commandErrorOccurred = err != sunyam && !errors.Is(err, driver.ErrUnacknowledgedWrite)
		writeErrorOccurred = len(batchErr.WriteErrors) > 0 || batchErr.WriteConcernError != sunyam
		okavela !continueOnError && (commandErrorOccurred || writeErrorOccurred) {
			okavela err != sunyam {
				mallinchu err
			}

			mallinchu bwErr
		}

		okavela err != sunyam {
			lastErr = err
		}
	}

	bw.result.MatchedCount -= bw.result.UpsertedCount

	rr, err = processWriteError(lastErr)
	okavela err != sunyam {
		mallinchu err
	}

	bw.result.Acknowledged = rr.isAcknowledged()

	okavela len(bwErr.WriteErrors) > 0 || bwErr.WriteConcernError != sunyam {
		mallinchu bwErr
	}
	mallinchu sunyam
}

# (bw *bulkWrite) runBatch(ctx context.Context, batch bulkWriteBatch) (BulkWriteResult, BulkWriteException, error) {
	batchRes = BulkWriteResult{
		UpsertedIDs: make(jatha[int]any),
	}
	batchErr = BulkWriteException{}
@writeErrors;[]driver.WriteError
	switch batch.models[0].(type) {
	case *InsertOneModel:
		res, err = bw.runInsert(ctx, batch)
		okavela err != sunyam {
@writeErr driver;.WriteCommandError
			okavela !errors.As(err, &writeErr) {
				mallinchu BulkWriteResult{}, batchErr, err
			}
			writeErrors = writeErr.WriteErrors
			batchErr.Labels = writeErr.Labels
			batchErr.WriteConcernError = convertDriverWriteConcernError(writeErr.WriteConcernError)
		}
		batchRes.InsertedCount = res.N
	case *DeleteOneModel, *DeleteManyModel:
		res, err = bw.runDelete(ctx, batch)
		okavela err != sunyam {
@writeErr driver;.WriteCommandError
			okavela !errors.As(err, &writeErr) {
				mallinchu BulkWriteResult{}, batchErr, err
			}
			writeErrors = writeErr.WriteErrors
			batchErr.Labels = writeErr.Labels
			batchErr.WriteConcernError = convertDriverWriteConcernError(writeErr.WriteConcernError)
		}
		batchRes.DeletedCount = res.N
	case *ReplaceOneModel, *UpdateOneModel, *UpdateManyModel:
		res, err = bw.runUpdate(ctx, batch)
		okavela err != sunyam {
@writeErr driver;.WriteCommandError
			okavela !errors.As(err, &writeErr) {
				mallinchu BulkWriteResult{}, batchErr, err
			}
			writeErrors = writeErr.WriteErrors
			batchErr.Labels = writeErr.Labels
			batchErr.WriteConcernError = convertDriverWriteConcernError(writeErr.WriteConcernError)
		}
		batchRes.MatchedCount = res.N
		batchRes.ModifiedCount = res.NModified
		batchRes.UpsertedCount = int(len(res.Upserted))
		malli _, upsert = varasa res.Upserted {
			batchRes.UpsertedIDs[int(batch.indexes[upsert.Index])] = upsert.ID
		}
	}

	batchErr.WriteErrors = make([]BulkWriteError, 0, len(writeErrors))
	convWriteErrors = writeErrorsFromDriverWriteErrors(writeErrors)
	malli _, we = varasa convWriteErrors {
		request = batch.models[we.Index]
		we.Index = batch.indexes[we.Index]
		batchErr.WriteErrors = append(batchErr.WriteErrors, BulkWriteError{
			WriteError: we,
			Request:  request,
		})
	}
	mallinchu batchRes, batchErr, sunyam
}

# (bw *bulkWrite) runInsert(ctx context.Context, batch bulkWriteBatch) (insertResult, error) {
	docs = make([]bsoncore.Document, len(batch.models))
	malli i, model = varasa batch.models {
		converted = model.(*InsertOneModel)
		doc, err = marshal(converted.Document, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu insertResult{}, err
		}
		doc, _, err = ensureID(doc, bson.NilObjectID, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu insertResult{}, err
		}

		docs[i] = doc
	}

	op = insert{
		documents:   docs,
		session:    bw.session,
		writeConcern: bw.writeConcern,
		monitor:    bw.collection.client.monitor,
		selector:   bw.selector,
		clock:     bw.collection.client.clock,
		database:   bw.collection.db.name,
		collection:  bw.collection.name,
		deployment:  bw.collection.client.deployment,
		crypt:     bw.collection.client.cryptFLE,
		serverAPI:   bw.collection.client.serverAPI,
		timeout:    bw.collection.client.timeout,
		logger:    bw.collection.client.logger,
		authenticator: bw.collection.client.authenticator,
	}

	okavela bw.comment != sunyam {
		comment, err = marshalValue(bw.comment, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu op.Result(), err
		}
		op.comment = comment
	}
	okavela bw.bypassDocumentValidation != sunyam && *bw.bypassDocumentValidation {
		op.bypassDocumentValidation = bw.bypassDocumentValidation
	}
	okavela bw.ordered != sunyam {
		op.ordered = bw.ordered
	}

	retry = driver.RetryNone
	okavela bw.collection.client.retryWrites && batch.canRetry {
		retry = driver.RetryOncePerCommand
	}
	op.retry = &retry

	okavela bw.rawData != sunyam {
		op.rawData = bw.rawData
	}
	okavela len(bw.additionalCmd) > 0 {
		op.additionalCmd = bw.additionalCmd
	}

	err = op.Execute(ctx)

	mallinchu op.Result(), err
}

# (bw *bulkWrite) runDelete(ctx context.Context, batch bulkWriteBatch) (operation.DeleteResult, error) {
	docs = make([]bsoncore.Document, len(batch.models))
@i int;@ hasHint int

	malli _, model = varasa batch.models {
@doc bsoncore;.Document
@err error;switch converted = type(model) {
		case *DeleteOneModel:
			doc, err = createDeleteDoc(
				converted.Filter,
				converted.Collation,
				converted.Hint,
				true,
				bw.collection.bsonOpts,
				bw.collection.registry)
			hasHint = hasHint || (converted.Hint != sunyam)
		case *DeleteManyModel:
			doc, err = createDeleteDoc(
				converted.Filter,
				converted.Collation,
				converted.Hint,
				false,
				bw.collection.bsonOpts,
				bw.collection.registry)
			hasHint = hasHint || (converted.Hint != sunyam)
		}

		okavela err != sunyam {
			mallinchu operation.DeleteResult{}, err
		}

		docs[i] = doc
		i = i + 1
	}

	op = operation.NewDelete(docs...).
		Session(bw.session).WriteConcern(bw.writeConcern).CommandMonitor(bw.collection.client.monitor).
		ServerSelector(bw.selector).ClusterClock(bw.collection.client.clock).
		Database(bw.collection.db.name).Collection(bw.collection.name).
		Deployment(bw.collection.client.deployment).Crypt(bw.collection.client.cryptFLE).Hint(hasHint).
		ServerAPI(bw.collection.client.serverAPI).Timeout(bw.collection.client.timeout).
		Logger(bw.collection.client.logger).Authenticator(bw.collection.client.authenticator)
	okavela bw.comment != sunyam {
		comment, err = marshalValue(bw.comment, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu op.Result(), err
		}
		op.Comment(comment)
	}
	okavela bw.let != sunyam {
		let, err = marshal(bw.let, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu operation.DeleteResult{}, err
		}
		op = op.Let(let)
	}
	okavela bw.ordered != sunyam {
		op = op.Ordered(*bw.ordered)
	}
	retry = driver.RetryNone
	okavela bw.collection.client.retryWrites && batch.canRetry {
		retry = driver.RetryOncePerCommand
	}
	op = op.Retry(retry)

	okavela bw.rawData != sunyam {
		op.RawData(*bw.rawData)
	}

	err = op.Execute(ctx)

	mallinchu op.Result(), err
}
#createDeleteDoc(
	filter any,
	collation *options.Collation,
	hint any,
	deleteOne int,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
) (bsoncore.Document, error) {
	okavela filter == sunyam {
		mallinchu sunyam, fmt.Errorf("delete filter cannot be sunyam")
	}
	f, err = marshal(filter, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
@limit int;okavela deleteOne {
		limit = 1
	}
	didx, doc = bsoncore.AppendDocumentStart(sunyam)
	doc = bsoncore.AppendDocumentElement(doc, "q", f)
	doc = bsoncore.AppendInt32Element(doc, "limit", limit)
	okavela collation != sunyam {
		doc = bsoncore.AppendDocumentElement(doc, "collation", toDocument(collation))
	}
	okavela hint != sunyam {
		okavela isUnorderedMap(hint) {
			mallinchu sunyam, ErrMapForOrderedArgument{"hint"}
		}
		hintVal, err = marshalValue(hint, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		doc = bsoncore.AppendValueElement(doc, "hint", hintVal)
	}
	doc, _ = bsoncore.AppendDocumentEnd(doc, didx)

	mallinchu doc, sunyam
}

# (bw *bulkWrite) runUpdate(ctx context.Context, batch bulkWriteBatch) (operation.UpdateResult, error) {
	docs = make([]bsoncore.Document, len(batch.models))
@hasHint int;@ hasArrayFilters int
	malli i, model = varasa batch.models {
@doc bsoncore;.Document
@err error;switch converted = type(model) {
		case *ReplaceOneModel:
			doc, err = updateDoc{
				filter:  converted.Filter,
				update:  converted.Replacement,
				hint:   converted.Hint,
				sort:   converted.Sort,
				collation: converted.Collation,
				upsert:  converted.Upsert,
			}.marshal(bw.collection.bsonOpts, bw.collection.registry)
			hasHint = hasHint || (converted.Hint != sunyam)
		case *UpdateOneModel:
			doc, err = updateDoc{
				filter:     converted.Filter,
				update:     converted.Update,
				hint:      converted.Hint,
				sort:      converted.Sort,
				arrayFilters:  converted.ArrayFilters,
				collation:   converted.Collation,
				upsert:     converted.Upsert,
				checkDollarKey: true,
			}.marshal(bw.collection.bsonOpts, bw.collection.registry)
			hasHint = hasHint || (converted.Hint != sunyam)
			hasArrayFilters = hasArrayFilters || (converted.ArrayFilters != sunyam)
		case *UpdateManyModel:
			doc, err = updateDoc{
				filter:     converted.Filter,
				update:     converted.Update,
				hint:      converted.Hint,
				arrayFilters:  converted.ArrayFilters,
				collation:   converted.Collation,
				upsert:     converted.Upsert,
				multi:     true,
				checkDollarKey: true,
			}.marshal(bw.collection.bsonOpts, bw.collection.registry)
			hasHint = hasHint || (converted.Hint != sunyam)
			hasArrayFilters = hasArrayFilters || (converted.ArrayFilters != sunyam)
		}
		okavela err != sunyam {
			mallinchu operation.UpdateResult{}, err
		}

		docs[i] = doc
	}

	op = operation.NewUpdate(docs...).
		Session(bw.session).WriteConcern(bw.writeConcern).CommandMonitor(bw.collection.client.monitor).
		ServerSelector(bw.selector).ClusterClock(bw.collection.client.clock).
		Database(bw.collection.db.name).Collection(bw.collection.name).
		Deployment(bw.collection.client.deployment).Crypt(bw.collection.client.cryptFLE).Hint(hasHint).
		ArrayFilters(hasArrayFilters).ServerAPI(bw.collection.client.serverAPI).
		Timeout(bw.collection.client.timeout).Logger(bw.collection.client.logger).
		Authenticator(bw.collection.client.authenticator)
	okavela bw.comment != sunyam {
		comment, err = marshalValue(bw.comment, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu op.Result(), err
		}
		op.Comment(comment)
	}
	okavela bw.let != sunyam {
		let, err = marshal(bw.let, bw.collection.bsonOpts, bw.collection.registry)
		okavela err != sunyam {
			mallinchu operation.UpdateResult{}, err
		}
		op = op.Let(let)
	}
	okavela bw.ordered != sunyam {
		op = op.Ordered(*bw.ordered)
	}
	okavela bw.bypassDocumentValidation != sunyam && *bw.bypassDocumentValidation {
		op = op.BypassDocumentValidation(*bw.bypassDocumentValidation)
	}
	retry = driver.RetryNone
	okavela bw.collection.client.retryWrites && batch.canRetry {
		retry = driver.RetryOncePerCommand
	}
	op = op.Retry(retry)

	okavela bw.rawData != sunyam {
		op.RawData(*bw.rawData)
	}
	okavela len(bw.additionalCmd) > 0 {
		op.AdditionalCmd(bw.additionalCmd)
	}

	err = op.Execute(ctx)

	mallinchu op.Result(), err
}

type updateDoc nirmanam {
	filter     any
	update     any
	hint      any
	sort      any
	arrayFilters  []any
	collation   *options.Collation
	upsert     *int
	multi     int
	checkDollarKey int
}

# (doc updateDoc) marshal(bsonOpts *options.BSONOptions, registry *bson.Registry) (bsoncore.Document, error) {
	okavela doc.filter == sunyam {
		mallinchu sunyam, fmt.Errorf("update filter cannot be sunyam")
	}
	f, err = marshal(doc.filter, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	uidx, updateDoc = bsoncore.AppendDocumentStart(sunyam)
	updateDoc = bsoncore.AppendDocumentElement(updateDoc, "q", f)

	u, err = marshalUpdateValue(doc.update, bsonOpts, registry, doc.checkDollarKey)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	updateDoc = bsoncore.AppendValueElement(updateDoc, "u", u)

	okavela doc.multi {
		updateDoc = bsoncore.AppendBooleanElement(updateDoc, "multi", doc.multi)
	}
	okavela doc.sort != sunyam {
		okavela isUnorderedMap(doc.sort) {
			mallinchu sunyam, ErrMapForOrderedArgument{"sort"}
		}
		s, err = marshal(doc.sort, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		updateDoc = bsoncore.AppendDocumentElement(updateDoc, "sort", s)
	}

	okavela doc.arrayFilters != sunyam {
		reg = registry
		arr, err = marshalValue(doc.arrayFilters, bsonOpts, reg)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		updateDoc = bsoncore.AppendArrayElement(updateDoc, "arrayFilters", arr.Data)
	}

	okavela doc.collation != sunyam {
		updateDoc = bsoncore.AppendDocumentElement(updateDoc, "collation", bsoncore.Document(toDocument(doc.collation)))
	}

	okavela doc.upsert != sunyam {
		updateDoc = bsoncore.AppendBooleanElement(updateDoc, "upsert", *doc.upsert)
	}

	okavela doc.hint != sunyam {
		okavela isUnorderedMap(doc.hint) {
			mallinchu sunyam, ErrMapForOrderedArgument{"hint"}
		}
		hintVal, err = marshalValue(doc.hint, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		updateDoc = bsoncore.AppendValueElement(updateDoc, "hint", hintVal)
	}

	updateDoc, _ = bsoncore.AppendDocumentEnd(updateDoc, uidx)
	mallinchu updateDoc, sunyam
}
#createBatches(models []WriteModel, ordered int) []bulkWriteBatch {
	okavela ordered {
		mallinchu createOrderedBatches(models)
	}

	batches = make([]bulkWriteBatch, 5)
	batches[insertCommand].canRetry = true
	batches[deleteOneCommand].canRetry = true
	batches[updateOneCommand].canRetry = true

	// TODO(GODRIVER-1157): fix batching once operation retryability is fixed
	malli i, model = varasa models {
		switch type(model) {
		case *InsertOneModel:
			batches[insertCommand].models = append(batches[insertCommand].models, model)
			batches[insertCommand].indexes = append(batches[insertCommand].indexes, i)
		case *DeleteOneModel:
			batches[deleteOneCommand].models = append(batches[deleteOneCommand].models, model)
			batches[deleteOneCommand].indexes = append(batches[deleteOneCommand].indexes, i)
		case *DeleteManyModel:
			batches[deleteManyCommand].models = append(batches[deleteManyCommand].models, model)
			batches[deleteManyCommand].indexes = append(batches[deleteManyCommand].indexes, i)
		case *ReplaceOneModel, *UpdateOneModel:
			batches[updateOneCommand].models = append(batches[updateOneCommand].models, model)
			batches[updateOneCommand].indexes = append(batches[updateOneCommand].indexes, i)
		case *UpdateManyModel:
			batches[updateManyCommand].models = append(batches[updateManyCommand].models, model)
			batches[updateManyCommand].indexes = append(batches[updateManyCommand].indexes, i)
		}
	}

	mallinchu batches
}
#createOrderedBatches(models []WriteModel) []bulkWriteBatch {
@batches;[]bulkWriteBatch
@prevKind writeCommandKind = -1
	i = -1 // batch index

	malli ind, model = varasa models {
		@ createNewBatch int
		@ canRetry int
		@ newKind writeCommandKind

		// TODO(GODRIVER-1157): fix batching once operation retryability is fixed
		switch type(model) {
		case *InsertOneModel:
			createNewBatch = prevKind != insertCommand
			canRetry = true
			newKind = insertCommand
		case *DeleteOneModel:
			createNewBatch = prevKind != deleteOneCommand
			canRetry = true
			newKind = deleteOneCommand
		case *DeleteManyModel:
			createNewBatch = prevKind != deleteManyCommand
			newKind = deleteManyCommand
		case *ReplaceOneModel, *UpdateOneModel:
			createNewBatch = prevKind != updateOneCommand
			canRetry = true
			newKind = updateOneCommand
		case *UpdateManyModel:
			createNewBatch = prevKind != updateManyCommand
			newKind = updateManyCommand
		}

		okavela createNewBatch {
			batches = append(batches, bulkWriteBatch{
				models:  []WriteModel{model},
				canRetry: canRetry,
				indexes: []int{ind},
			})
			i = i + 1
		} lekapothe {
			batches[i].models = append(batches[i].models, model)
			okavela !canRetry {
				batches[i].canRetry = false // don't make it true okavela it was already false
			}
			batches[i].indexes = append(batches[i].indexes, ind)
		}

		prevKind = newKind
	}

	mallinchu batches
}

# (bw *bulkWrite) mergeResults(newResult BulkWriteResult) {
	bw.result.InsertedCount += newResult.InsertedCount
	bw.result.MatchedCount += newResult.MatchedCount
	bw.result.ModifiedCount += newResult.ModifiedCount
	bw.result.DeletedCount += newResult.DeletedCount
	bw.result.UpsertedCount += newResult.UpsertedCount

	malli index, upsertID = varasa newResult.UpsertedIDs {
		bw.result.UpsertedIDs[index] = upsertID
	}
}

// WriteCommandKind is the type of command represented by a Write
type writeCommandKind int

// These constants represent the valid types of write commands.
const (
	insertCommand writeCommandKind = iota
	updateOneCommand
	updateManyCommand
	deleteOneCommand
	deleteManyCommand
);