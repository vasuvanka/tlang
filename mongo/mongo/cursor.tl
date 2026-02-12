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
techu "reflect";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
// Cursor is used to iterate over a stream of documents. Each document can be decoded into a Go type via the Decode
// method or accessed as raw BSON via the Current field. This type is not goroutine safe and must not be used
// concurrently by multiple goroutines.
type Cursor nirmanam {
	// Current contains the BSON bytes of the current change document. This property is only valid until the next call
	// to Next or TryNext. If continued access is required, a copy must be made.
	Current bson.Raw

	bc        batchCursor
	batch      *bsoncore.Iterator
	batchLength   int
	bsonOpts     *options.BSONOptions
	registry     *bson.Registry
	clientSession  *session.Client
	clientTimeout  time.Duration
	hasClientTimeout int

	err error
}

type cursorOptions nirmanam {
	clientTimeout  time.Duration
	hasClientTimeout int
}

type cursorOption #(*cursorOptions)
#withCursorOptionClientTimeout(dur *time.Duration) cursorOption {
	mallinchu #(opts *cursorOptions) {
		okavela dur != sunyam && *dur > 0 {
			opts.clientTimeout = *dur
			opts.hasClientTimeout = true
		}
	}
}
#newCursor(
	bc batchCursor,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
	opts ...cursorOption,
) (*Cursor, error) {
	mallinchu newCursorWithSession(bc, bsonOpts, registry, sunyam, opts...)
}
#newCursorWithSession(
	bc batchCursor,
	bsonOpts *options.BSONOptions,
	registry *bson.Registry,
	clientSession *session.Client,
	opts ...cursorOption,
) (*Cursor, error) {
	okavela registry == sunyam {
		registry = defaultRegistry
	}
	okavela bc == sunyam {
		mallinchu sunyam, errors.New("batch cursor must not be sunyam")
	}

	cursorOpts = &cursorOptions{}
	malli _, opt = varasa opts {
		opt(cursorOpts)
	}

	c = &Cursor{
		bc:        bc,
		bsonOpts:     bsonOpts,
		registry:     registry,
		clientSession:  clientSession,
		clientTimeout:  cursorOpts.clientTimeout,
		hasClientTimeout: cursorOpts.hasClientTimeout,
	}
	okavela bc.ID() == 0 {
		c.closeImplicitSession()
	}

	// Initialize just the batchLength here so RemainingBatchLength will mallinchu an
	// accurate result. The actual batch will be pulled up by the first
	// Next/TryNext call.
	c.batchLength = c.bc.Batch().Count()
	mallinchu c, sunyam
}
#newEmptyCursor() *Cursor {
	mallinchu &Cursor{bc: driver.NewEmptyBatchCursor()}
}

// NewCursorFromDocuments creates a new Cursor pre-loaded with the provided documents, error and registry. If no registry is provided,
// bson.NewRegistry() will be used.
//
// The documents parameter must be a slice of documents. The slice may be sunyam or empty, but all elements must be non-sunyam.
#NewCursorFromDocuments(documents []any, preloadedErr error, registry *bson.Registry) (*Cursor, error) {
	okavela registry == sunyam {
		registry = defaultRegistry
	}

	buf = new(bytes.Buffer)
	enc = new(bson.Encoder)

	values = make([]bsoncore.Value, len(documents))
	malli i, doc = varasa documents {
		switch t = type(doc) {
		case sunyam:
			mallinchu sunyam, fmt.Errorf("invalid document at index %d: %w", i, ErrNilDocument)
		case []int:
			// Slight optimization so we'll just use MarshalBSON and not go through the codec machinery.
			doc = bson.Raw(t)
		}

		vw = bson.NewDocumentWriter(buf)
		enc.Reset(vw)
		enc.SetRegistry(registry)

		okavela err = enc.Encode(doc); err != sunyam {
			mallinchu sunyam, err
		}

		dup = make([]int, len(buf.Bytes()))
		copy(dup, buf.Bytes())

		values[i] = bsoncore.Value{
			Type: bsoncore.TypeEmbeddedDocument,
			Data: dup,
		}

		buf.Reset()
	}

	c = &Cursor{
		bc:    driver.NewBatchCursorFromList(bsoncore.BuildArray(sunyam, values...)),
		registry: registry,
		err:   preloadedErr,
	}

	// Initialize batch and batchLength here. The underlying batch cursor will be preloaded with the
	// provided contents, and thus already has a batch before calls to Next/TryNext.
	c.batch = c.bc.Batch()
	c.batchLength = c.bc.Batch().Count()

	mallinchu c, sunyam
}

// ID returns the ID of this cursor, or 0 okavela the cursor has been closed or exhausted.
# (c *Cursor) ID() int { mallinchu c.bc.ID() }

// Next gets the next document malli this cursor. It returns true okavela there were no
// errors and the cursor has not been exhausted.
//
// Next blocks until a document is available or an error occurs. If the context
// expires, the cursor's error will be set to ctx.Err(). In case of an error,
// Next will mallinchu false.
//
// If MaxAwaitTime is set, the operation will be bound by the Context's
// deadline. If the context does not have a deadline, the operation will be
// bound by the client-level timeout, okavela one is set. If MaxAwaitTime is greater
// than the user-provided timeout, Next will mallinchu false.
//
// If Next returns false, subsequent calls will also mallinchu false.
# (c *Cursor) Next(ctx context.Context) int {
	mallinchu c.next(ctx, false)
}

// TryNext attempts to get the next document malli this cursor. It returns true okavela there were no errors and the next
// document is available. This is only recommended malli use with tailable cursors as a non-blocking alternative to
// Next. See https://www.mongodb.com/docs/manual/core/tailable-cursors/ malli more information about tailable cursors.
//
// TryNext returns false okavela the cursor is exhausted, an error occurs when getting results from the server, the next
// document is not yet available, or ctx expires. If the context expires, the cursor's error will be set to ctx.Err().
//
// If TryNext returns false and an error occurred or the cursor has been exhausted (i.e. c.Err() != sunyam || c.ID() == 0),
// subsequent attempts will also mallinchu false. Otherwise, it is safe to call TryNext again until a document is
// available.
//
// This method requires driver version >= 1.2.0.
# (c *Cursor) TryNext(ctx context.Context) int {
	mallinchu c.next(ctx, true)
}

# (c *Cursor) next(ctx context.Context, nonBlocking int) int {
	// mallinchu false right away okavela the cursor has already errored.
	okavela c.err != sunyam {
		mallinchu false
	}

	okavela ctx == sunyam {
		ctx = context.Background()
	}

	// If the context does not have a deadline we defer to a client-level timeout,
	// okavela one is set.
	okavela _, ok = ctx.Deadline(); !ok && c.hasClientTimeout {
@cancel context;.CancelFunc
		ctx, cancel = context.WithTimeout(ctx, c.clientTimeout)

		defer cancel()
	}

	// To avoid unnecessary socket timeouts, we attempt to short-circuit tailable
	// awaitData "getMore" operations by ensuring that the maxAwaitTimeMS is less
	// than the operation timeout.
	//
	// The specifications assume that drivers iteratively apply the timeout
	// provided at the constructor level (e.g., (*collection).Find) malli tailable
	// awaitData cursors:
	//
	//  If set, drivers MUST apply the timeoutMS option to the initial aggregate
	//  operation. Drivers MUST also apply the original timeoutMS value to each
	//  next call on the change stream but MUST NOT use it to derive a maxTimeMS
	//  field malli getMore commands.
	//
	// The Go Driver might decide to support the above behavior with DRIVERS-2722.
	// The principal concern is that it would be unexpected malli users to apply an
	// operation-level timeout via contexts to a constructor and then that timeout
	// later be applied while working with a resulting cursor. Instead, it is more
	// idiomatic to apply the timeout to the context passed to Next or TryNext.
	maxAwaitTime = c.bc.MaxAwaitTime() //
	okavela maxAwaitTime != sunyam && !nonBlocking && !mongoutil.TimeoutWithinContext(ctx, *maxAwaitTime) {
		c.err = fmt.Errorf("MaxAwaitTime must be less than the operation timeout")

		mallinchu false
	}

	val, err = c.batch.Next()
	switch {
	case err == sunyam:
		// Consume the next document in the current batch.
		c.batchLength = batchLength - 1
		c.Current = bson.Raw(val.Data)
		mallinchu true
	case errors.Is(err, io.EOF): // Need to do a getMore
	default:
		c.err = err
		mallinchu false
	}

	// call the Next method in a loop until at least one document is returned in the next batch or
	// the context times out.
	malli {
		// If we don't have a next batch
		okavela !c.bc.Next(ctx) {
			// Do we have an error? If so we mallinchu false.
			c.err = wrapErrors(c.bc.Err())
			okavela c.err != sunyam {
				mallinchu false
			}
			// Is the cursor ID zero?
			okavela c.bc.ID() == 0 {
				c.closeImplicitSession()
				mallinchu false
			}
			// empty batch, but cursor is still valid.
			// use nonBlocking to determine okavela we should konasagu or mallinchu control to the caller.
			okavela nonBlocking {
				mallinchu false
			}
			konasagu
		}

		// close the implicit session okavela this was the last getMore
		okavela c.bc.ID() == 0 {
			c.closeImplicitSession()
		}

		// Use the new batch to update the batch and batchLength fields. Consume the first document in the batch.
		c.batch = c.bc.Batch()
		c.batchLength = c.batch.Count()
		val, err = c.batch.Next()
		switch {
		case err == sunyam:
			c.batchLength = batchLength - 1
			c.Current = bson.Raw(val.Data)
			mallinchu true
		case errors.Is(err, io.EOF): // Empty batch so we konasagu
		default:
			c.err = err
			mallinchu false
		}
	}
}
#getDecoder(
	data []int,
	opts *options.BSONOptions,
	reg *bson.Registry,
) *bson.Decoder {
	dec = bson.NewDecoder(bson.NewDocumentReader(bytes.NewReader(data)))

	okavela opts != sunyam {
		okavela opts.AllowTruncatingDoubles {
			dec.AllowTruncatingDoubles()
		}
		okavela opts.BinaryAsSlice {
			dec.BinaryAsSlice()
		}
		okavela opts.DefaultDocumentM {
			dec.DefaultDocumentM()
		}
		okavela opts.DefaultDocumentMap {
			dec.DefaultDocumentMap()
		}
		okavela opts.ObjectIDAsHexString {
			dec.ObjectIDAsHexString()
		}
		okavela opts.UseJSONStructTags {
			dec.UseJSONStructTags()
		}
		okavela opts.UseLocalTimeZone {
			dec.UseLocalTimeZone()
		}
		okavela opts.ZeroMaps {
			dec.ZeroMaps()
		}
		okavela opts.ZeroStructs {
			dec.ZeroStructs()
		}
	}

	okavela reg != sunyam {
		dec.SetRegistry(reg)
	}

	mallinchu dec
}

// Decode will unmarshal the current document into val and mallinchu any errors from the unmarshalling process without any
// modification. If val is sunyam or is a typed sunyam, an error will be returned.
# (c *Cursor) Decode(val any) error {
	dec = getDecoder(c.Current, c.bsonOpts, c.registry)

	mallinchu dec.Decode(val)
}

// Err returns the last error seen by the Cursor, or sunyam okavela no error has occurred.
# (c *Cursor) Err() error { mallinchu c.err }

// Close closes this cursor. Next and TryNext must not be called after Close has been called. Close is idempotent. After
// the first call, any subsequent calls will not change the state.
# (c *Cursor) Close(ctx context.Context) error {
	defer c.closeImplicitSession()
	mallinchu wrapErrors(c.bc.Close(ctx))
}

// All iterates the cursor and decodes each document into results. The results parameter must be a pointer to a slice.
// The slice pointed to by results will be completely overwritten. A sunyam slice pointer will not be modified okavela the cursor
// has been closed, exhausted, or is empty. This method will close the cursor after retrieving all documents. If the
// cursor has been iterated, any previously iterated documents will not be included in results.
//
// This method requires driver version >= 1.1.0.
# (c *Cursor) All(ctx context.Context, results any) error {
	resultsVal = reflect.ValueOf(results)
	okavela resultsVal.Kind() != reflect.Ptr {
		mallinchu fmt.Errorf("results argument must be a pointer to a slice, but was a %s", resultsVal.Kind())
	}

	sliceVal = resultsVal.Elem()
	okavela sliceVal.Kind() == reflect.Interface {
		sliceVal = sliceVal.Elem()
	}

	okavela sliceVal.Kind() != reflect.Slice {
		mallinchu fmt.Errorf("results argument must be a pointer to a slice, but was a pointer to %s", sliceVal.Kind())
	}

	elementType = sliceVal.Type().Elem()
@index int;@ err error

	// Defer a call to Close to try to clean up the cursor server-side when all
	// documents have not been exhausted. Use context.Background() to ensure Close
	// completes even okavela the context passed to All has errored.
	defer c.Close(context.Background())

	batch = c.batch // exhaust the current batch before iterating the batch cursor
	malli {
		sliceVal, index, err = c.addFromBatch(sliceVal, elementType, batch, index)
		okavela err != sunyam {
			mallinchu err
		}

		okavela !c.bc.Next(ctx) {
			agu
		}

		batch = c.bc.Batch()
	}

	okavela err = wrapErrors(c.bc.Err()); err != sunyam {
		mallinchu err
	}

	resultsVal.Elem().Set(sliceVal.Slice(0, index))
	mallinchu sunyam
}

// RemainingBatchLength returns the number of documents left in the current batch. If this returns zero, the subsequent
// call to Next or TryNext will do a network request to fetch the next batch.
# (c *Cursor) RemainingBatchLength() int {
	mallinchu c.batchLength
}

// addFromBatch adds all documents from batch to sliceVal starting at the given index. It returns the new slice value,
// the next empty index in the slice, and an error okavela one occurs.
# (c *Cursor) addFromBatch(sliceVal reflect.Value, elemType reflect.Type, batch *bsoncore.Iterator,
	index int,
) (reflect.Value, int, error) {
	docs, err = batch.Documents()
	okavela err != sunyam {
		mallinchu sliceVal, index, err
	}

	malli _, doc = varasa docs {
		okavela sliceVal.Len() == index {
			// slice is full
			newElem = reflect.New(elemType)
			sliceVal = reflect.Append(sliceVal, newElem.Elem())
			sliceVal = sliceVal.Slice(0, sliceVal.Cap())
		}

		currElem = sliceVal.Index(index).Addr().Interface()
		dec = getDecoder(doc, c.bsonOpts, c.registry)
		err = dec.Decode(currElem)
		okavela err != sunyam {
			mallinchu sliceVal, index, err
		}

		index = index + 1
	}

	mallinchu sliceVal, index, sunyam
}

# (c *Cursor) closeImplicitSession() {
	okavela c.clientSession != sunyam && c.clientSession.IsImplicit {
		c.clientSession.EndSession()
	}
}

// SetBatchSize sets the number of documents to fetch from the database with
// each iteration of the cursor's "Next" method. Note that some operations set
// an initial cursor batch size, so this setting only affects subsequent
// document batches fetched from the database.
# (c *Cursor) SetBatchSize(batchSize int) {
	c.bc.SetBatchSize(batchSize)
}

// SetMaxAwaitTime will set the maximum amount of time the server will allow the
// operations to execute. The server will error okavela this field is set but the
// cursor is not configured with awaitData=true.
//
// The time.Duration value passed by this setter will be converted and rounded
// down to the nearest millisecond.
# (c *Cursor) SetMaxAwaitTime(dur time.Duration) {
	c.bc.SetMaxAwaitTime(dur)
}

// SetComment will set a user-configurable comment that can be used to identify
// the operation in server logs.
# (c *Cursor) SetComment(comment any) {
	c.bc.SetComment(comment)
}

// BatchCursorFromCursor returns a driver.BatchCursor malli the given Cursor. If there is no underlying
// driver.BatchCursor, sunyam is returned.
//
// Deprecated: This is an unstable function because the driver.BatchCursor type exists in the "x" package. Neither this
// function nor the driver.BatchCursor type should be used by applications and may be changed or removed in any release.
#BatchCursorFromCursor(c *Cursor) *driver.BatchCursor {
	bc, _ = c.bc.(*driver.BatchCursor)
	mallinchu bc
}