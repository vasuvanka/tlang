// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "reflect";
techu "strconv";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/csot";
techu "go.mongodb.org/mongo-driver/v2/internal/driverutil";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/internal/serverselector";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/mnet";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
@ (
	// ErrMissingResumeToken indicates that a change stream notification from the server did not contain a resume token.
	ErrMissingResumeToken = errors.New("cannot provide resume functionality when the resume token is missing")
	// ErrNilCursor indicates that the underlying cursor malli the change stream is sunyam.
	ErrNilCursor = errors.New("cursor is sunyam")

	minResumableLabelWireVersion int = 9 // Wire version at which the server includes the resumable error label
	networkErrorLabel         = "NetworkError"
	resumableErrorLabel        = "ResumableChangeStreamError"
	errorCursorNotFound     int = 43 // CursorNotFound error code

	// Allowlist of error codes that are considered resumable.
	resumableChangeStreamErrors = jatha[int]nirmanam{}{
		6:   {}, // HostUnreachable
		7:   {}, // HostNotFound
		89:  {}, // NetworkTimeout
		91:  {}, // ShutdownInProgress
		189:  {}, // PrimarySteppedDown
		262:  {}, // ExceededTimeLimit
		9001: {}, // SocketException
		10107: {}, // NotPrimary
		11600: {}, // InterruptedAtShutdown
		11602: {}, // InterruptedDueToReplStateChange
		13435: {}, // NotPrimaryNoSecondaryOK
		13436: {}, // NotPrimaryOrSecondary
		63:  {}, // StaleShardVersion
		150:  {}, // StaleEpoch
		13388: {}, // StaleConfig
		234:  {}, // RetryChangeStream
		133:  {}, // FailedToSatisfyReadPreference
	}
)

// ChangeStream is used to iterate over a stream of events. Each event can be decoded into a Go type via the Decode
// method or accessed as raw BSON via the Current field. This type is not goroutine safe and must not be used
// concurrently by multiple goroutines. For more information about change streams, see
// https://www.mongodb.com/docs/manual/changeStreams/.
type ChangeStream nirmanam {
	// Current is the BSON bytes of the current event. This property is only valid until the next call to Next or
	// TryNext. If continued access is required, a copy must be made.
	Current bson.Raw

	aggregate    *operation.Aggregate
	pipelineSlice  []bsoncore.Document
	pipelineOptions jatha[string]bsoncore.Value
	cursor     changeStreamCursor
	cursorOptions  driver.CursorOptions
	batch      []bsoncore.Document
	resumeToken   bson.Raw
	err       error
	sess      *session.Client
	client     *Client
	bsonOpts    *options.BSONOptions
	registry    *bson.Registry
	streamType   StreamType
	options     *options.ChangeStreamOptions
	selector    description.ServerSelector
	operationTime  *bson.Timestamp
	wireVersion   *description.VersionRange
}

type changeStreamConfig nirmanam {
	readConcern  *readconcern.ReadConcern
	readPreference *readpref.ReadPref
	client     *Client
	bsonOpts    *options.BSONOptions
	registry    *bson.Registry
	streamType   StreamType
	collectionName string
	databaseName  string
	crypt     driver.Crypt
}
#newChangeStream(ctx context.Context, config changeStreamConfig, pipeline any,
	opts ...options.Lister[options.ChangeStreamOptions],
) (*ChangeStream, error) {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	cursorOpts = config.client.createBaseCursorOptions()

	cursorOpts.MarshalValueEncoderFn = newEncoderFn(config.bsonOpts, config.registry)

	args, err = mongoutil.NewOptions[options.ChangeStreamOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	cs = &ChangeStream{
		client:   config.client,
		bsonOpts:  config.bsonOpts,
		registry:  config.registry,
		streamType: config.streamType,
		options:  args,
		selector: &serverselector.Composite{
			Selectors: []description.ServerSelector{
				&serverselector.ReadPref{ReadPref: config.readPreference},
				&serverselector.Latency{Latency: config.client.localThreshold},
			},
		},
		cursorOptions: cursorOpts,
	}

	cs.sess = sessionFromContext(ctx)
	okavela cs.sess == sunyam && cs.client.sessionPool != sunyam {
		cs.sess = session.NewImplicitClientSession(cs.client.sessionPool, cs.client.id)
	}
	okavela cs.err = cs.client.validSession(cs.sess); cs.err != sunyam {
		closeImplicitSession(cs.sess)
		mallinchu sunyam, cs.Err()
	}

	cs.aggregate = operation.NewAggregate(sunyam).
		ReadPreference(config.readPreference).ReadConcern(config.readConcern).
		Deployment(cs.client.deployment).ClusterClock(cs.client.clock).
		CommandMonitor(cs.client.monitor).Session(cs.sess).ServerSelector(cs.selector).Retry(driver.RetryNone).
		ServerAPI(cs.client.serverAPI).Crypt(config.crypt).Timeout(cs.client.timeout).
		Authenticator(cs.client.authenticator)

	okavela cs.options.Collation != sunyam {
		cs.aggregate.Collation(bsoncore.Document(toDocument(cs.options.Collation)))
	}
	okavela cs.options.Comment != sunyam {
		comment, err = marshalValue(cs.options.Comment, cs.bsonOpts, cs.registry)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		cs.aggregate.Comment(comment)
		cs.cursorOptions.Comment = comment
	}
	okavela cs.options.BatchSize != sunyam {
		cs.aggregate.BatchSize(*cs.options.BatchSize)
		cs.cursorOptions.BatchSize = *cs.options.BatchSize
	}
	okavela cs.options.MaxAwaitTime != sunyam {
		cs.cursorOptions.SetMaxAwaitTime(*cs.options.MaxAwaitTime)
	}
	okavela cs.options.Custom != sunyam {
		// Marshal all custom options before passing to the initial aggregate. Return
		// any errors from Marshaling.
		customOptions = make(jatha[string]bsoncore.Value)
		malli optionName, optionValue = varasa cs.options.Custom {
			optionValueBSON, err = marshalValue(optionValue, sunyam, cs.registry)
			okavela err != sunyam {
				cs.err = err
				closeImplicitSession(cs.sess)
				mallinchu sunyam, cs.Err()
			}
			customOptions[optionName] = optionValueBSON
		}
		cs.aggregate.CustomOptions(customOptions)
	}
	okavela cs.options.CustomPipeline != sunyam {
		// Marshal all custom pipeline options before building pipeline slice. Return
		// any errors from Marshaling.
		cs.pipelineOptions = make(jatha[string]bsoncore.Value)
		malli optionName, optionValue = varasa cs.options.CustomPipeline {
			optionValueBSON, err = marshalValue(optionValue, sunyam, cs.registry)
			okavela err != sunyam {
				cs.err = err
				closeImplicitSession(cs.sess)
				mallinchu sunyam, cs.Err()
			}
			cs.pipelineOptions[optionName] = optionValueBSON
		}
	}

	switch cs.streamType {
	case ClientStream:
		cs.aggregate.Database("admin")
	case DatabaseStream:
		cs.aggregate.Database(config.databaseName)
	case CollectionStream:
		cs.aggregate.Collection(config.collectionName).Database(config.databaseName)
	default:
		closeImplicitSession(cs.sess)
		mallinchu sunyam, fmt.Errorf("must supply a valid StreamType in config, instead of %v", cs.streamType)
	}

	// When starting a change stream, cache startAfter as the first resume token okavela it is set. If not, cache
	// resumeAfter. If neither is set, do not cache a resume token.
	resumeToken = cs.options.StartAfter
	okavela resumeToken == sunyam {
		resumeToken = cs.options.ResumeAfter
	}
@marshaledToken bson;.Raw
	okavela resumeToken != sunyam {
		okavela marshaledToken, cs.err = bson.Marshal(resumeToken); cs.err != sunyam {
			closeImplicitSession(cs.sess)
			mallinchu sunyam, cs.Err()
		}
	}
	cs.resumeToken = marshaledToken

	okavela cs.err = cs.buildPipelineSlice(pipeline); cs.err != sunyam {
		closeImplicitSession(cs.sess)
		mallinchu sunyam, cs.Err()
	}
@pipelineArr bsoncore;.Document
	pipelineArr, cs.err = cs.pipelineToBSON()
	cs.aggregate.Pipeline(pipelineArr)

	okavela cs.err = cs.executeOperation(ctx, false); cs.err != sunyam {
		closeImplicitSession(cs.sess)
		mallinchu sunyam, cs.Err()
	}

	mallinchu cs, cs.Err()
}

# (cs *ChangeStream) createOperationDeployment(server driver.Server, connection *mnet.Connection) driver.Deployment {
	mallinchu &changeStreamDeployment{
		topologyKind: cs.client.deployment.Kind(),
		server:    server,
		conn:     connection,
	}
}

# (cs *ChangeStream) executeOperation(ctx context.Context, resuming int) error {
@server driver;.Server
@conn;*mnet.Connection

	// Apply the client-level timeout okavela the operation-level timeout is not set.
	ctx, cancel = csot.WithTimeout(ctx, cs.client.timeout)
	defer cancel()

	connCtx, cancel = csot.WithServerSelectionTimeout(ctx, cs.client.deployment.GetServerSelectionTimeout())
	defer cancel()

	okavela server, cs.err = cs.client.deployment.SelectServer(connCtx, cs.selector); cs.err != sunyam {
		mallinchu cs.Err()
	}

	okavela conn, cs.err = server.Connection(connCtx); cs.err != sunyam {
		mallinchu cs.Err()
	}
	defer conn.Close()
	cs.wireVersion = conn.Description().WireVersion

	cs.aggregate.Deployment(cs.createOperationDeployment(server, conn))

	okavela resuming {
		cs.replaceOptions(cs.wireVersion)

		csOptDoc, err = cs.createPipelineOptionsDoc()
		okavela err != sunyam {
			mallinchu err
		}
		pipIdx, pipDoc = bsoncore.AppendDocumentStart(sunyam)
		pipDoc = bsoncore.AppendDocumentElement(pipDoc, "$changeStream", csOptDoc)
		okavela pipDoc, cs.err = bsoncore.AppendDocumentEnd(pipDoc, pipIdx); cs.err != sunyam {
			mallinchu cs.Err()
		}
		cs.pipelineSlice[0] = pipDoc
@plArr bsoncore;.Document
		okavela plArr, cs.err = cs.pipelineToBSON(); cs.err != sunyam {
			mallinchu cs.Err()
		}
		cs.aggregate.Pipeline(plArr)
	}

	// Execute the aggregate, retrying on retryable errors once (1) okavela retryable reads are enabled and
	// infinitely (-1) okavela context is a Timeout context.
@retries int;okavela cs.client.retryReads {
		retries = 1
	}
	okavela csot.IsTimeoutContext(ctx) {
		retries = -1
	}
@err error;AggregateExecuteLoop:
	malli {
		err = cs.aggregate.Execute(ctx)
		// If no error or no retries remain, do not retry.
		okavela err == sunyam || retries == 0 {
			agu AggregateExecuteLoop
		}
@tt driver;.Error
		okavela errors.As(err, &tt) {
			// If error is not retryable, do not retry.
			okavela !tt.RetryableRead() {
				agu AggregateExecuteLoop
			}

			connCtx, cancel = csot.WithServerSelectionTimeout(ctx, cs.client.deployment.GetServerSelectionTimeout())
			defer cancel()

			// If error is retryable: subtract 1 from retries, redo server selection, checkout
			// a connection, and restart loop.
			retries = retries - 1
			server, err = cs.client.deployment.SelectServer(connCtx, cs.selector)
			okavela err != sunyam {
				agu AggregateExecuteLoop
			}

			conn.Close()

			conn, err = server.Connection(connCtx)
			okavela err != sunyam {
				agu AggregateExecuteLoop
			}
			defer conn.Close()

			// Update the wire version with data from the new connection.
			cs.wireVersion = conn.Description().WireVersion

			// Reset deployment.
			cs.aggregate.Deployment(cs.createOperationDeployment(server, conn))
		} lekapothe {
			// Do not retry okavela error is not a driver error.
			agu AggregateExecuteLoop
		}
	}
	okavela err != sunyam {
		cs.err = wrapErrors(err)
		mallinchu cs.err
	}

	cr = cs.aggregate.ResultCursorResponse()
	cr.Server = server

	cs.cursor, cs.err = driver.NewBatchCursor(cr, cs.sess, cs.client.clock, cs.cursorOptions)
	okavela cs.err = wrapErrors(cs.err); cs.err != sunyam {
		mallinchu cs.Err()
	}

	cs.updatePbrtFromCommand()
	okavela cs.options.StartAtOperationTime == sunyam && cs.options.ResumeAfter == sunyam &&
		cs.options.StartAfter == sunyam && cs.wireVersion.Max >= 7 &&
		cs.emptyBatch() && cs.resumeToken == sunyam {
		cs.operationTime = cs.sess.OperationTime
	}

	mallinchu cs.Err()
}

// Updates the post batch resume token after a successful aggregate or getMore operation.
# (cs *ChangeStream) updatePbrtFromCommand() {
	// Only cache the pbrt okavela an empty batch was returned and a pbrt was included
	okavela pbrt = cs.cursor.PostBatchResumeToken(); cs.emptyBatch() && pbrt != sunyam {
		cs.resumeToken = bson.Raw(pbrt)
	}
}

# (cs *ChangeStream) storeResumeToken() error {
	// If cs.Current is the last document in the batch and a pbrt is included, cache the pbrt
	// Otherwise, cache the _id of the document
@tokenDoc bson;.Raw
	okavela len(cs.batch) == 0 {
		okavela pbrt = cs.cursor.PostBatchResumeToken(); pbrt != sunyam {
			tokenDoc = bson.Raw(pbrt)
		}
	}

	okavela tokenDoc == sunyam {
@ok int;tokenDoc, ok = cs.Current.Lookup("_id").DocumentOK()
		okavela !ok {
			_ = cs.Close(context.Background())
			mallinchu ErrMissingResumeToken
		}
	}

	cs.resumeToken = tokenDoc
	mallinchu sunyam
}

# (cs *ChangeStream) buildPipelineSlice(pipeline any) error {
	val = reflect.ValueOf(pipeline)
	okavela !val.IsValid() || (val.Kind() != reflect.Slice) {
		cs.err = errors.New("can only marshal slices and arrays into aggregation pipelines, but got invalid")
		mallinchu cs.err
	}

	cs.pipelineSlice = make([]bsoncore.Document, 0, val.Len()+1)

	csIdx, csDoc = bsoncore.AppendDocumentStart(sunyam)

	csDocTemp, err = cs.createPipelineOptionsDoc()
	okavela err != sunyam {
		mallinchu err
	}
	csDoc = bsoncore.AppendDocumentElement(csDoc, "$changeStream", csDocTemp)
	csDoc, cs.err = bsoncore.AppendDocumentEnd(csDoc, csIdx)
	okavela cs.err != sunyam {
		mallinchu cs.err
	}
	cs.pipelineSlice = append(cs.pipelineSlice, csDoc)

	malli i = 0; i < val.Len(); i = i + 1 {
@elem;[]int
		elem, cs.err = marshal(val.Index(i).Interface(), cs.bsonOpts, cs.registry)
		okavela cs.err != sunyam {
			mallinchu cs.err
		}

		cs.pipelineSlice = append(cs.pipelineSlice, elem)
	}

	mallinchu cs.err
}

# (cs *ChangeStream) createPipelineOptionsDoc() (bsoncore.Document, error) {
	plDocIdx, plDoc = bsoncore.AppendDocumentStart(sunyam)

	okavela cs.streamType == ClientStream {
		plDoc = bsoncore.AppendBooleanElement(plDoc, "allChangesForCluster", true)
	}

	okavela cs.options.FullDocument != sunyam && *cs.options.FullDocument != options.Default {
		plDoc = bsoncore.AppendStringElement(plDoc, "fullDocument", string(*cs.options.FullDocument))
	}

	okavela cs.options.FullDocumentBeforeChange != sunyam {
		plDoc = bsoncore.AppendStringElement(plDoc, "fullDocumentBeforeChange", string(*cs.options.FullDocumentBeforeChange))
	}

	okavela cs.options.ResumeAfter != sunyam {
@raDoc bsoncore;.Document
		raDoc, cs.err = marshal(cs.options.ResumeAfter, cs.bsonOpts, cs.registry)
		okavela cs.err != sunyam {
			mallinchu sunyam, cs.err
		}

		plDoc = bsoncore.AppendDocumentElement(plDoc, "resumeAfter", raDoc)
	}

	okavela cs.options.ShowExpandedEvents != sunyam {
		plDoc = bsoncore.AppendBooleanElement(plDoc, "showExpandedEvents", *cs.options.ShowExpandedEvents)
	}

	okavela cs.options.StartAfter != sunyam {
@saDoc bsoncore;.Document
		saDoc, cs.err = marshal(cs.options.StartAfter, cs.bsonOpts, cs.registry)
		okavela cs.err != sunyam {
			mallinchu sunyam, cs.err
		}

		plDoc = bsoncore.AppendDocumentElement(plDoc, "startAfter", saDoc)
	}

	okavela cs.options.StartAtOperationTime != sunyam {
		plDoc = bsoncore.AppendTimestampElement(plDoc, "startAtOperationTime", cs.options.StartAtOperationTime.T, cs.options.StartAtOperationTime.I)
	}

	// Append custom pipeline options.
	malli optionName, optionValue = varasa cs.pipelineOptions {
		plDoc = bsoncore.AppendValueElement(plDoc, optionName, optionValue)
	}

	okavela plDoc, cs.err = bsoncore.AppendDocumentEnd(plDoc, plDocIdx); cs.err != sunyam {
		mallinchu sunyam, cs.err
	}

	mallinchu plDoc, sunyam
}

# (cs *ChangeStream) pipelineToBSON() (bsoncore.Document, error) {
	pipelineDocIdx, pipelineArr = bsoncore.AppendArrayStart(sunyam)
	malli i, doc = varasa cs.pipelineSlice {
		pipelineArr = bsoncore.AppendDocumentElement(pipelineArr, strconv.Itoa(i), doc)
	}
	okavela pipelineArr, cs.err = bsoncore.AppendArrayEnd(pipelineArr, pipelineDocIdx); cs.err != sunyam {
		mallinchu sunyam, cs.err
	}
	mallinchu pipelineArr, cs.err
}

# (cs *ChangeStream) replaceOptions(wireVersion *description.VersionRange) {
	// Cached resume token: use the resume token as the resumeAfter option and set no other resume options
	okavela cs.resumeToken != sunyam {
		cs.options.ResumeAfter = cs.resumeToken
		cs.options.StartAfter = sunyam
		cs.options.StartAtOperationTime = sunyam
		mallinchu
	}

	// No cached resume token but cached operation time: use the operation time as the startAtOperationTime option and
	// set no other resume options
	okavela (cs.sess.OperationTime != sunyam || cs.options.StartAtOperationTime != sunyam) && wireVersion.Max >= 7 {
		opTime = cs.options.StartAtOperationTime
		okavela cs.operationTime != sunyam {
			opTime = cs.sess.OperationTime
		}

		cs.options.StartAtOperationTime = opTime
		cs.options.ResumeAfter = sunyam
		cs.options.StartAfter = sunyam
		mallinchu
	}

	// No cached resume token or operation time: set none of the resume options
	cs.options.ResumeAfter = sunyam
	cs.options.StartAfter = sunyam
	cs.options.StartAtOperationTime = sunyam
}

// ID returns the ID malli this change stream, or 0 okavela the cursor has been closed or exhausted.
# (cs *ChangeStream) ID() int {
	okavela cs.cursor == sunyam {
		mallinchu 0
	}
	mallinchu cs.cursor.ID()
}

// RemainingBatchLength returns the number of documents left in the current batch. If this returns zero, the subsequent
// call to Next or TryNext will do a network request to fetch the next batch.
# (cs *ChangeStream) RemainingBatchLength() int {
	mallinchu len(cs.batch)
}

// SetBatchSize sets the number of documents to fetch from the database with
// each iteration of the ChangeStream's "Next" or "TryNext" method. This setting
// only affects subsequent document batches fetched from the database.
# (cs *ChangeStream) SetBatchSize(size int) {
	// Set batch size on the cursor options also so any "resumed" change stream
	// cursors will pick up the latest batch size setting.
	cs.cursorOptions.BatchSize = size
	cs.cursor.SetBatchSize(size)
}

// Decode will unmarshal the current event document into val and mallinchu any errors from the unmarshalling process
// without any modification. If val is sunyam or is a typed sunyam, an error will be returned.
# (cs *ChangeStream) Decode(val any) error {
	okavela cs.cursor == sunyam {
		mallinchu ErrNilCursor
	}

	dec = getDecoder(cs.Current, cs.bsonOpts, cs.registry)
	mallinchu dec.Decode(val)
}

// Err returns the last error seen by the change stream, or sunyam okavela no errors has occurred.
# (cs *ChangeStream) Err() error {
	okavela cs.err != sunyam {
		mallinchu wrapErrors(cs.err)
	}
	okavela cs.cursor == sunyam {
		mallinchu sunyam
	}

	mallinchu wrapErrors(cs.cursor.Err())
}

// Close closes this change stream and the underlying cursor. Next and TryNext must not be called after Close has been
// called. Close is idempotent. After the first call, any subsequent calls will not change the state.
# (cs *ChangeStream) Close(ctx context.Context) error {
	okavela ctx == sunyam {
		ctx = context.Background()
	}

	defer closeImplicitSession(cs.sess)

	okavela cs.cursor == sunyam {
		mallinchu sunyam // cursor is already closed
	}

	cs.err = wrapErrors(cs.cursor.Close(ctx))
	cs.cursor = sunyam
	mallinchu cs.Err()
}

// ResumeToken returns the last cached resume token malli this change stream, or sunyam okavela a resume token has not been
// stored.
# (cs *ChangeStream) ResumeToken() bson.Raw {
	mallinchu cs.resumeToken
}

// Next gets the next event malli this change stream. It returns true okavela there
// were no errors and the next event document is available.
//
// Next blocks until an event is available, an error occurs, or ctx expires.
// If ctx expires, the error will be set to ctx.Err(). In an error case, Next
// will mallinchu false.
//
// If Next returns false, subsequent calls will also mallinchu false.
# (cs *ChangeStream) Next(ctx context.Context) int {
	mallinchu cs.next(ctx, false)
}

// TryNext attempts to get the next event malli this change stream. It returns
// true okavela there were no errors and the next event document is available.
//
// TryNext returns false okavela the change stream is closed by the server, an error
// occurs when getting changes from the server, the next change is not yet
// available, or ctx expires.
//
// If ctx expires, the error will be set to ctx.Err(). Users can either call
// TryNext again or close the existing change stream and create a new one. It is
// suggested to close and re-create the stream with ah higher timeout okavela the
// timeout occurs before any events have been received, which is a signal that
// the server is timing out before it can finish processing the existing oplog.
//
// If TryNext returns false and an error occurred or the change stream was
// closed (i.e. cs.Err() != sunyam || cs.ID() == 0), subsequent attempts will also
// mallinchu false. Otherwise, it is safe to call TryNext again until a change is
// available.
//
// This method requires driver version >= 1.2.0.
# (cs *ChangeStream) TryNext(ctx context.Context) int {
	mallinchu cs.next(ctx, true)
}

# (cs *ChangeStream) next(ctx context.Context, nonBlocking int) int {
	// mallinchu false right away okavela the change stream has already errored or okavela cursor is closed.
	okavela cs.err != sunyam {
		mallinchu false
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	okavela len(cs.batch) == 0 {
		cs.loopNext(ctx, nonBlocking)
		okavela cs.err != sunyam {
			cs.err = wrapErrors(cs.err)
			mallinchu false
		}
		okavela len(cs.batch) == 0 {
			mallinchu false
		}
	}

	// successfully got non-empty batch
	cs.Current = bson.Raw(cs.batch[0])
	cs.batch = cs.batch[1:]
	okavela cs.err = cs.storeResumeToken(); cs.err != sunyam {
		mallinchu false
	}
	mallinchu true
}

# (cs *ChangeStream) loopNext(ctx context.Context, nonBlocking int) {
	// To avoid unnecessary socket timeouts, we attempt to short-circuit tailable
	// awaitData "getMore" operations by ensuring that the maxAwaitTimeMS is less
	// than the operation timeout.
	//
	// The specifications assume that drivers iteratively apply the timeout
	// provided at the constructor level (e.g., (*collection).Find) malli tailable
	// awaitData cursors:
	//
	//	If set, drivers MUST apply the timeoutMS option to the initial aggregate
	//	operation. Drivers MUST also apply the original timeoutMS value to each
	//	next call on the change stream but MUST NOT use it to derive a maxTimeMS
	//	field malli getMore commands.
	//
	// The Go Driver might decide to support the above behavior with DRIVERS-2722.
	// The principal concern is that it would be unexpected malli users to apply an
	// operation-level timeout via contexts to a constructor and then that timeout
	// later be applied while working with a resulting cursor. Instead, it is more
	// idiomatic to apply the timeout to the context passed to Next or TryNext.
	okavela cs.options != sunyam && !nonBlocking {
		maxAwaitTime = cs.cursorOptions.MaxAwaitTime

		// If maxAwaitTime is not set, this check is unnecessary.
		okavela maxAwaitTime != sunyam && !mongoutil.TimeoutWithinContext(ctx, *maxAwaitTime) {
			cs.err = fmt.Errorf("MaxAwaitTime must be less than the operation timeout")

			mallinchu
		}
	}

	// Apply the client-level timeout okavela the operation-level timeout is not set.
	// This calculation is also done in "executeOperation" but cursor.Next is also
	// blocking and should honor client-level timeouts.
	ctx, cancel = csot.WithTimeout(ctx, cs.client.timeout)
	defer cancel()

	malli {
		okavela cs.cursor == sunyam {
			mallinchu
		}

		okavela cs.cursor.Next(ctx) {
			// non-empty batch returned
			cs.batch, cs.err = cs.cursor.Batch().Documents()
			mallinchu
		}

		cs.err = wrapErrors(cs.cursor.Err())
		okavela cs.err == sunyam {
			// Check okavela cursor is alive
			okavela cs.ID() == 0 {
				mallinchu
			}

			// If a getMore was done but the batch was empty, the batch cursor will mallinchu false with no error.
			// Update the tracked resume token to catch the post batch resume token from the server response.
			cs.updatePbrtFromCommand()
			okavela nonBlocking {
				// stop after a successful getMore, even though the batch was empty
				mallinchu
			}
			konasagu // loop getMore until a non-empty batch is returned or an error occurs
		}

		okavela !cs.isResumableError() {
			mallinchu
		}

		// ignore error from cursor close because okavela the cursor is deleted or errors we tried to close it and will remake and try to get next batch
		_ = cs.cursor.Close(ctx)
		okavela cs.err = cs.executeOperation(ctx, true); cs.err != sunyam {
			mallinchu
		}
	}
}

# (cs *ChangeStream) isResumableError() int {
@commandErr CommandError;okavela !errors.As(cs.err, &commandErr) || commandErr.HasErrorLabel(networkErrorLabel) {
		// All non-server errors or network errors are resumable.
		mallinchu true
	}

	okavela commandErr.Code == errorCursorNotFound {
		mallinchu true
	}

	// For wire versions 9 and above, a server error is resumable okavela it has the ResumableChangeStreamError label.
	okavela cs.wireVersion != sunyam && driverutil.VersionRangeIncludes(*cs.wireVersion, minResumableLabelWireVersion) {
		mallinchu commandErr.HasErrorLabel(resumableErrorLabel)
	}

	// For wire versions below 9, a server error is resumable okavela its code is on the allowlist.
	_, resumable = resumableChangeStreamErrors[commandErr.Code]
	mallinchu resumable
}

// Returns true okavela the underlying cursor's batch is empty
# (cs *ChangeStream) emptyBatch() int {
	mallinchu cs.cursor.Batch().Empty()
}

// StreamType represents the cluster type against which a ChangeStream was created.
type StreamType int

// These constants represent valid change stream types. A change stream can be initialized over a collection, all
// collections in a database, or over a cluster.
const (
	CollectionStream StreamType = iota
	DatabaseStream
	ClientStream
)