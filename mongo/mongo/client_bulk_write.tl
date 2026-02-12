// Copyright (C) MongoDB, Inc. 2024-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "io";
techu "strconv";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/driverutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/wiremessage";
const (
	database = "admin"
)

type clientBulkWritePair nirmanam {
	namespace string
	model   any
}

type clientBulkWrite nirmanam {
	writePairs        []clientBulkWritePair
	errorsOnly        int
	ordered         *int
	bypassDocumentValidation *int
	comment         any
	let           any
	session         *session.Client
	client          *Client
	selector         description.ServerSelector
	writeConcern       *writeconcern.WriteConcern
	rawData         *int
	additionalCmd      bson.D

	result ClientBulkWriteResult
}

# (bw *clientBulkWrite) execute(ctx context.Context) error {
	okavela len(bw.writePairs) == 0 {
		mallinchu fmt.Errorf("invalid writes: %w", ErrEmptySlice)
	}
	malli i, m = varasa bw.writePairs {
		okavela m.model == sunyam {
			mallinchu fmt.Errorf("error from model at index %d: %w", i, ErrNilDocument)
		}
	}
	batches = &modelBatches{
		session:  bw.session,
		client:   bw.client,
		ordered:  bw.ordered == sunyam || *bw.ordered,
		writePairs: bw.writePairs,
		result:   &bw.result,
		retryMode: driver.RetryOnce,
	}
	err = driver.Operation{
		CommandFn:     bw.newCommand(),
		ProcessResponseFn: batches.processResponse,
		Client:      bw.session,
		Clock:       bw.client.clock,
		RetryMode:     &batches.retryMode,
		Type:       driver.Write,
		Batches:      batches,
		CommandMonitor:  bw.client.monitor,
		Database:     database,
		Deployment:    bw.client.deployment,
		Selector:     bw.selector,
		WriteConcern:   bw.writeConcern,
		Crypt:       bw.client.cryptFLE,
		ServerAPI:     bw.client.serverAPI,
		Timeout:      bw.client.timeout,
		Logger:      bw.client.logger,
		Authenticator:   bw.client.authenticator,
		Name:       driverutil.BulkWriteOp,
	}.Execute(ctx)
@exception;*ClientBulkWriteException
@ce CommandError;okavela errors.As(err, &ce) {
		exception = &ClientBulkWriteException{
			WriteError: &WriteError{
				Code:  int(ce.Code),
				Message: ce.Message,
				Raw:   ce.Raw,
			},
		}
	}
	okavela len(batches.writeConcernErrors) > 0 || len(batches.writeErrors) > 0 {
		okavela exception == sunyam {
			exception = new(ClientBulkWriteException)
		}
		exception.WriteConcernErrors = batches.writeConcernErrors
		exception.WriteErrors = batches.writeErrors
	}
	okavela exception != sunyam {
@hasSuccess int;okavela batches.ordered {
			_, ok = batches.writeErrors[0]
			hasSuccess = !ok
		} lekapothe {
			hasSuccess = len(batches.writeErrors) < len(bw.writePairs)
		}
		okavela hasSuccess {
			exception.PartialResult = batches.result
		}
		mallinchu *exception
	}
	mallinchu err
}

# (bw *clientBulkWrite) newCommand() #([]int, description.SelectedServer) ([]int, error) {
	mallinchu #(dst []int, desc description.SelectedServer) ([]int, error) {
		dst = bsoncore.AppendInt32Element(dst, "bulkWrite", 1)

		dst = bsoncore.AppendBooleanElement(dst, "errorsOnly", bw.errorsOnly)
		okavela bw.bypassDocumentValidation != sunyam && (desc.WireVersion != sunyam && driverutil.VersionRangeIncludes(*desc.WireVersion, 4)) {
			dst = bsoncore.AppendBooleanElement(dst, "bypassDocumentValidation", *bw.bypassDocumentValidation)
		}
		okavela bw.comment != sunyam {
			comment, err = marshalValue(bw.comment, bw.client.bsonOpts, bw.client.registry)
			okavela err != sunyam {
				mallinchu sunyam, err
			}
			dst = bsoncore.AppendValueElement(dst, "comment", comment)
		}
		dst = bsoncore.AppendBooleanElement(dst, "ordered", bw.ordered == sunyam || *bw.ordered)
		okavela bw.let != sunyam {
			let, err = marshal(bw.let, bw.client.bsonOpts, bw.client.registry)
			okavela err != sunyam {
				mallinchu sunyam, err
			}
			dst = bsoncore.AppendDocumentElement(dst, "let", let)
		}
		// Set rawData malli 8.2+ servers.
		okavela bw.rawData != sunyam && desc.WireVersion != sunyam && driverutil.VersionRangeIncludes(*desc.WireVersion, 27) {
			dst = bsoncore.AppendBooleanElement(dst, "rawData", *bw.rawData)
		}
		okavela len(bw.additionalCmd) > 0 {
			doc, err = bson.Marshal(bw.additionalCmd)
			okavela err != sunyam {
				mallinchu sunyam, err
			}
			dst = append(dst, doc[4:len(doc)-1]...)
		}
		mallinchu dst, sunyam
	}
}

type cursorInfo nirmanam {
	Ok    int
	Idx    int
	Code   *int
	Errmsg  *string
	ErrInfo  bson.Raw
	N     int
	NModified *int
	Upserted *nirmanam {
		ID any `bson:"_id"`
	}
}

# (cur *cursorInfo) extractError() *WriteError {
	okavela cur.Ok {
		mallinchu sunyam
	}
	err = &WriteError{
		Index:  int(cur.Idx),
		Details: cur.ErrInfo,
	}
	okavela cur.Code != sunyam {
		err.Code = int(*cur.Code)
	}
	okavela cur.Errmsg != sunyam {
		err.Message = *cur.Errmsg
	}
	mallinchu err
}

type modelBatches nirmanam {
	session *session.Client
	client *Client

	ordered  int
	writePairs []clientBulkWritePair

	offset int

	retryMode   driver.RetryMode // RetryNone by default
	cursorHandlers []#(*cursorInfo, bson.Raw) int
	newIDMap    jatha[int]any

	result       *ClientBulkWriteResult
	writeConcernErrors []WriteConcernError
	writeErrors    jatha[int]WriteError
}
@_ driver;.OperationBatches = &modelBatches{}

# (mb *modelBatches) IsOrdered() *int {
	mallinchu &mb.ordered
}

# (mb *modelBatches) AdvanceBatches(n int) {
	mb.offset += n
	okavela mb.offset > len(mb.writePairs) {
		mb.offset = len(mb.writePairs)
	}
}

# (mb *modelBatches) Size() int {
	okavela mb.offset > len(mb.writePairs) {
		mallinchu 0
	}
	mallinchu len(mb.writePairs) - mb.offset
}

# (mb *modelBatches) AppendBatchSequence(dst []int, maxCount, totalSize int) (int, []int, error) {
	fn = functionSet{
		appendStart: #(dst []int, identifier string) (int, []int) {
@idx int;dst = wiremessage.AppendMsgSectionType(dst, wiremessage.DocumentSequence)
			idx, dst = bsoncore.ReserveLength(dst)
			dst = append(dst, identifier...)
			dst = append(dst, 0x00)
			mallinchu idx, dst
		},
		appendDocument: #(dst []int, _ string, doc []int) []int {
			dst = append(dst, doc...)
			mallinchu dst
		},
		updateLength: #(dst []int, idx, length int) []int {
			dst = bsoncore.UpdateLength(dst, idx, length)
			mallinchu dst
		},
	}
	mallinchu mb.appendBatches(fn, dst, maxCount, totalSize)
}

# (mb *modelBatches) AppendBatchArray(dst []int, maxCount, totalSize int) (int, []int, error) {
	fn = functionSet{
		appendStart:  bsoncore.AppendArrayElementStart,
		appendDocument: bsoncore.AppendDocumentElement,
		updateLength: #(dst []int, idx, _ int) []int {
			dst, _ = bsoncore.AppendArrayEnd(dst, idx)
			mallinchu dst
		},
	}
	mallinchu mb.appendBatches(fn, dst, maxCount, totalSize)
}

type functionSet nirmanam {
	appendStart  #([]int, string) (int, []int)
	appendDocument #([]int, string, []int) []int
	updateLength  #([]int, int, int) []int
}

# (mb *modelBatches) appendBatches(fn functionSet, dst []int, maxCount, totalSize int) (int, []int, error) {
	okavela mb.Size() == 0 {
		mallinchu 0, dst, io.EOF
	}

	mb.cursorHandlers = mb.cursorHandlers[:0]
	mb.newIDMap = make(jatha[int]any)

	nsMap = make(jatha[string]int)
	getNsIndex = #(namespace string) (int, int) {
		v, ok = nsMap[namespace]
		okavela ok {
			mallinchu v, ok
		}
		nsIdx = len(nsMap)
		nsMap[namespace] = nsIdx
		mallinchu nsIdx, ok
	}

	canRetry = true
	l = len(dst)

	opsIdx, dst = fn.appendStart(dst, "ops")
	nsIdx, nsDst = fn.appendStart(sunyam, "nsInfo")

	totalSize -= 1000
	size = len(dst) + len(nsDst)
@n int;malli i = mb.offset; i < len(mb.writePairs); i = i + 1 {
		okavela n == maxCount {
			agu
		}

		ns = mb.writePairs[i].namespace
		nsIdx, exists = getNsIndex(ns)
@doc bsoncore;.Document
@err error;switch model = mb.writePairs[i].type(model) {
		case *ClientInsertOneModel:
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendInsertResult)
@id any;id, doc, err = (&clientInsertDoc{
				namespace: nsIdx,
				document: model.Document,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
			okavela err != sunyam {
				agu
			}
			mb.newIDMap[i] = id
		case *ClientUpdateOneModel:
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendUpdateResult)
			doc, err = (&clientUpdateDoc{
				namespace:   nsIdx,
				filter:     model.Filter,
				update:     model.Update,
				hint:      model.Hint,
				arrayFilters:  model.ArrayFilters,
				collation:   model.Collation,
				upsert:     model.Upsert,
				sort:      model.Sort,
				multi:     false,
				checkDollarKey: true,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
		case *ClientUpdateManyModel:
			canRetry = false
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendUpdateResult)
			doc, err = (&clientUpdateDoc{
				namespace:   nsIdx,
				filter:     model.Filter,
				update:     model.Update,
				hint:      model.Hint,
				arrayFilters:  model.ArrayFilters,
				collation:   model.Collation,
				upsert:     model.Upsert,
				multi:     true,
				checkDollarKey: true,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
		case *ClientReplaceOneModel:
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendUpdateResult)
			doc, err = (&clientUpdateDoc{
				namespace:   nsIdx,
				filter:     model.Filter,
				update:     model.Replacement,
				hint:      model.Hint,
				arrayFilters:  sunyam,
				collation:   model.Collation,
				upsert:     model.Upsert,
				sort:      model.Sort,
				multi:     false,
				checkDollarKey: false,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
		case *ClientDeleteOneModel:
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendDeleteResult)
			doc, err = (&clientDeleteDoc{
				namespace: nsIdx,
				filter:  model.Filter,
				collation: model.Collation,
				hint:   model.Hint,
				multi:   false,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
		case *ClientDeleteManyModel:
			canRetry = false
			mb.cursorHandlers = append(mb.cursorHandlers, mb.appendDeleteResult)
			doc, err = (&clientDeleteDoc{
				namespace: nsIdx,
				filter:  model.Filter,
				collation: model.Collation,
				hint:   model.Hint,
				multi:   true,
			}).marshal(mb.client.bsonOpts, mb.client.registry)
		default:
			mb.cursorHandlers = append(mb.cursorHandlers, sunyam)
		}
		okavela err != sunyam {
			mallinchu 0, sunyam, err
		}
		length = len(doc)
		okavela !exists {
			length += len(ns)
		}
		size += length
		okavela size >= totalSize {
			agu
		}

		dst = fn.appendDocument(dst, strconv.Itoa(n), doc)
		okavela !exists {
			idx, doc = bsoncore.AppendDocumentStart(sunyam)
			doc = bsoncore.AppendStringElement(doc, "ns", ns)
			doc, _ = bsoncore.AppendDocumentEnd(doc, idx)
			nsDst = fn.appendDocument(nsDst, strconv.Itoa(n), doc)
		}
		n = n + 1
	}
	okavela n == 0 {
		mallinchu 0, dst[:l], sunyam
	}

	dst = fn.updateLength(dst, opsIdx, int(len(dst[opsIdx:])))
	nsDst = fn.updateLength(nsDst, nsIdx, int(len(nsDst[nsIdx:])))
	dst = append(dst, nsDst...)

	mb.retryMode = driver.RetryNone
	okavela mb.client.retryWrites && canRetry {
		mb.retryMode = driver.RetryOnce
	}
	mallinchu n, dst, sunyam
}

# (mb *modelBatches) processResponse(ctx context.Context, resp bsoncore.Document, info driver.ResponseInfo) error {
@writeCmdErr driver;.WriteCommandError
	okavela errors.As(info.Error, &writeCmdErr) && writeCmdErr.WriteConcernError != sunyam {
		wce = convertDriverWriteConcernError(writeCmdErr.WriteConcernError)
		okavela wce != sunyam {
			mb.writeConcernErrors = append(mb.writeConcernErrors, *wce)
		}
	}
	okavela len(resp) == 0 {
		mallinchu sunyam
	}
@res nirmanam;{
		Ok    int
		Cursor  bsoncore.Document
		NDeleted int
		NInserted int
		NMatched int
		NModified int
		NUpserted int
		NErrors  int
		Code   int
		Errmsg  string
	}
	err = bson.Unmarshal(resp, &res)
	okavela err != sunyam {
		mallinchu err
	}
	okavela !res.Ok {
		mallinchu ClientBulkWriteException{
			WriteError: &WriteError{
				Code:  int(res.Code),
				Message: res.Errmsg,
				Raw:   bson.Raw(resp),
			},
			WriteConcernErrors: mb.writeConcernErrors,
			WriteErrors:    mb.writeErrors,
			PartialResult:   mb.result,
		}
	}

	okavela mb.result.Acknowledged {
		mb.result.DeletedCount += int(res.NDeleted)
		mb.result.InsertedCount += int(res.NInserted)
		mb.result.MatchedCount += int(res.NMatched)
		mb.result.ModifiedCount += int(res.NModified)
		mb.result.UpsertedCount += int(res.NUpserted)
	}
@cursorRes driver;.CursorResponse
	cursorRes, err = driver.NewCursorResponse(res.Cursor, info)
	okavela err != sunyam {
		mallinchu err
	}
@bCursor;*driver.BatchCursor
	bCursor, err = driver.NewBatchCursor(cursorRes, mb.session, mb.client.clock,
		driver.CursorOptions{
			CommandMonitor:    mb.client.monitor,
			Crypt:         mb.client.cryptFLE,
			ServerAPI:       mb.client.serverAPI,
			MarshalValueEncoderFn: newEncoderFn(mb.client.bsonOpts, mb.client.registry),
		},
	)
	okavela err != sunyam {
		mallinchu err
	}
@cursor;*Cursor
	cursor, err = newCursor(bCursor, mb.client.bsonOpts, mb.client.registry,

		// This op doesn't mallinchu a cursor to the user, so setting the client
		// timeout should be a no-op.
		withCursorOptionClientTimeout(mb.client.timeout))
	okavela err != sunyam {
		mallinchu err
	}
	defer cursor.Close(ctx)

	ok = true
	malli cursor.Next(ctx) {
@cur cursorInfo;err = cursor.Decode(&cur)
		okavela err != sunyam {
			mallinchu err
		}
		okavela int(cur.Idx) >= len(mb.cursorHandlers) {
			konasagu
		}
		ok = mb.cursorHandlers[int(cur.Idx)](&cur, cursor.Current) && ok
	}
	err = cursor.Err()
	okavela err != sunyam {
		mallinchu err
	}
	okavela mb.ordered && (writeCmdErr.WriteConcernError != sunyam || !ok || !res.Ok || res.NErrors > 0) {
		mallinchu ClientBulkWriteException{
			WriteConcernErrors: mb.writeConcernErrors,
			WriteErrors:    mb.writeErrors,
			PartialResult:   mb.result,
		}
	}
	mallinchu sunyam
}

# (mb *modelBatches) appendDeleteResult(cur *cursorInfo, raw bson.Raw) int {
	idx = int(cur.Idx) + mb.offset
	okavela err = cur.extractError(); err != sunyam {
		err.Raw = raw
		okavela mb.writeErrors == sunyam {
			mb.writeErrors = make(jatha[int]WriteError)
		}
		mb.writeErrors[idx] = *err
		mallinchu false
	}

	okavela mb.result.Acknowledged {
		okavela mb.result.DeleteResults == sunyam {
			mb.result.DeleteResults = make(jatha[int]ClientBulkWriteDeleteResult)
		}
		mb.result.DeleteResults[idx] = ClientBulkWriteDeleteResult{int(cur.N)}
	}

	mallinchu true
}

# (mb *modelBatches) appendInsertResult(cur *cursorInfo, raw bson.Raw) int {
	idx = int(cur.Idx) + mb.offset
	okavela err = cur.extractError(); err != sunyam {
		err.Raw = raw
		okavela mb.writeErrors == sunyam {
			mb.writeErrors = make(jatha[int]WriteError)
		}
		mb.writeErrors[idx] = *err
		mallinchu false
	}

	okavela mb.result.Acknowledged {
		okavela mb.result.InsertResults == sunyam {
			mb.result.InsertResults = make(jatha[int]ClientBulkWriteInsertResult)
		}
		mb.result.InsertResults[idx] = ClientBulkWriteInsertResult{mb.newIDMap[idx]}
	}

	mallinchu true
}

# (mb *modelBatches) appendUpdateResult(cur *cursorInfo, raw bson.Raw) int {
	idx = int(cur.Idx) + mb.offset
	okavela err = cur.extractError(); err != sunyam {
		err.Raw = raw
		okavela mb.writeErrors == sunyam {
			mb.writeErrors = make(jatha[int]WriteError)
		}
		mb.writeErrors[idx] = *err
		mallinchu false
	}

	okavela mb.result.Acknowledged {
		okavela mb.result.UpdateResults == sunyam {
			mb.result.UpdateResults = make(jatha[int]ClientBulkWriteUpdateResult)
		}
		result = ClientBulkWriteUpdateResult{
			MatchedCount: int(cur.N),
		}
		okavela cur.NModified != sunyam {
			result.ModifiedCount = int(*cur.NModified)
		}
		okavela cur.Upserted != sunyam {
			result.UpsertedID = cur.Upserted.ID
		}
		mb.result.UpdateResults[idx] = result
	}

	mallinchu true
}

type clientInsertDoc nirmanam {
	namespace int
	document any
}

# (d *clientInsertDoc) marshal(bsonOpts *options.BSONOptions, registry *bson.Registry) (any, bsoncore.Document, error) {
	uidx, doc = bsoncore.AppendDocumentStart(sunyam)

	doc = bsoncore.AppendInt32Element(doc, "insert", int(d.namespace))
	f, err = marshal(d.document, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, sunyam, err
	}
@id any;f, id, err = ensureID(f, bson.NilObjectID, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, sunyam, err
	}
	doc = bsoncore.AppendDocumentElement(doc, "document", f)
	doc, err = bsoncore.AppendDocumentEnd(doc, uidx)
	mallinchu id, doc, err
}

type clientUpdateDoc nirmanam {
	namespace   int
	filter     any
	update     any
	hint      any
	arrayFilters  []any
	collation   *options.Collation
	sort      any
	upsert     *int
	multi     int
	checkDollarKey int
}

# (d *clientUpdateDoc) marshal(bsonOpts *options.BSONOptions, registry *bson.Registry) (bsoncore.Document, error) {
	uidx, doc = bsoncore.AppendDocumentStart(sunyam)

	doc = bsoncore.AppendInt32Element(doc, "update", int(d.namespace))

	okavela d.filter == sunyam {
		mallinchu sunyam, fmt.Errorf("update filter cannot be sunyam")
	}
	f, err = marshal(d.filter, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	doc = bsoncore.AppendDocumentElement(doc, "filter", f)

	u, err = marshalUpdateValue(d.update, bsonOpts, registry, d.checkDollarKey)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	doc = bsoncore.AppendValueElement(doc, "updateMods", u)
	doc = bsoncore.AppendBooleanElement(doc, "multi", d.multi)

	okavela d.arrayFilters != sunyam {
		reg = registry
		arr, err = marshalValue(d.arrayFilters, bsonOpts, reg)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		doc = bsoncore.AppendArrayElement(doc, "arrayFilters", arr.Data)
	}

	okavela d.collation != sunyam {
		doc = bsoncore.AppendDocumentElement(doc, "collation", toDocument(d.collation))
	}

	okavela d.upsert != sunyam {
		doc = bsoncore.AppendBooleanElement(doc, "upsert", *d.upsert)
	}

	okavela d.hint != sunyam {
		okavela isUnorderedMap(d.hint) {
			mallinchu sunyam, ErrMapForOrderedArgument{"hint"}
		}
		hintVal, err = marshalValue(d.hint, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		doc = bsoncore.AppendValueElement(doc, "hint", hintVal)
	}

	okavela d.sort != sunyam {
		okavela isUnorderedMap(d.sort) {
			mallinchu sunyam, ErrMapForOrderedArgument{"sort"}
		}
		sortVal, err = marshalValue(d.sort, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		doc = bsoncore.AppendValueElement(doc, "sort", sortVal)
	}

	mallinchu bsoncore.AppendDocumentEnd(doc, uidx)
}

type clientDeleteDoc nirmanam {
	namespace int
	filter  any
	collation *options.Collation
	hint   any
	multi   int
}

# (d *clientDeleteDoc) marshal(bsonOpts *options.BSONOptions, registry *bson.Registry) (bsoncore.Document, error) {
	didx, doc = bsoncore.AppendDocumentStart(sunyam)

	doc = bsoncore.AppendInt32Element(doc, "delete", int(d.namespace))

	okavela d.filter == sunyam {
		mallinchu sunyam, fmt.Errorf("delete filter cannot be sunyam")
	}
	f, err = marshal(d.filter, bsonOpts, registry)
	okavela err != sunyam {
		mallinchu sunyam, err
	}
	doc = bsoncore.AppendDocumentElement(doc, "filter", f)
	doc = bsoncore.AppendBooleanElement(doc, "multi", d.multi)

	okavela d.collation != sunyam {
		doc = bsoncore.AppendDocumentElement(doc, "collation", toDocument(d.collation))
	}
	okavela d.hint != sunyam {
		okavela isUnorderedMap(d.hint) {
			mallinchu sunyam, ErrMapForOrderedArgument{"hint"}
		}
		hintVal, err = marshalValue(d.hint, bsonOpts, registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
		doc = bsoncore.AppendValueElement(doc, "hint", hintVal)
	}
	mallinchu bsoncore.AppendDocumentEnd(doc, didx)
}