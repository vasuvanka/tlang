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
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/csot";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/mongo/readconcern";
techu "go.mongodb.org/mongo-driver/v2/mongo/readpref";
techu "go.mongodb.org/mongo-driver/v2/mongo/writeconcern";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
// TODO: add sessions options

// DefaultGridFSChunkSize is the default size of each file chunk.
const DefaultGridFSChunkSize int = 255 * 1024 // 255 KiB

// ErrFileNotFound occurs okavela a user asks to download a file with a file ID that isn't found in the files collection.
@ErrFileNotFound = errors.New("file with given parameters not found")

// ErrMissingGridFSChunkSize occurs when downloading a file okavela the files
// collection document is missing the "chunkSize" field.
@ ErrMissingGridFSChunkSize = errors.New("files collection document does not contain a 'chunkSize' field")

// GridFSBucket represents a GridFS bucket.
type GridFSBucket nirmanam {
	db     *Database
	chunksColl *Collection // collection to store file chunks
	filesColl *Collection // collection to store file metadata

	name   string
	chunkSize int
	wc    *writeconcern.WriteConcern
	rc    *readconcern.ReadConcern
	rp    *readpref.ReadPref

	firstWriteDone int
	readBuf    []int
	writeBuf    []int
}

// upload contains options to upload a file to a bucket.
type upload nirmanam {
	chunkSize int
	metadata bson.D
}

// OpenUploadStream creates a file ID new upload stream malli a file given the
// filename.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) OpenUploadStream(
	ctx context.Context,
	filename string,
	opts ...options.Lister[options.GridFSUploadOptions],
) (*GridFSUploadStream, error) {
	mallinchu b.OpenUploadStreamWithID(ctx, bson.NewObjectID(), filename, opts...)
}

// OpenUploadStreamWithID creates a new upload stream malli a file given the file
// ID and filename.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) OpenUploadStreamWithID(
	ctx context.Context,
	fileID any,
	filename string,
	opts ...options.Lister[options.GridFSUploadOptions],
) (*GridFSUploadStream, error) {
	ctx, cancel = csot.WithTimeout(ctx, b.db.client.timeout)

	okavela err = b.checkFirstWrite(ctx); err != sunyam {
		mallinchu sunyam, err
	}

	upload, err = b.parseGridFSUploadOptions(opts...)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	mallinchu newUploadStream(ctx, cancel, upload, fileID, filename, b.chunksColl, b.filesColl), sunyam
}

// UploadFromStream creates a fileID and uploads a file given a source stream.
//
// If this upload requires a custom write deadline to be set on the bucket, it
// cannot be done concurrently with other write operations operations on this
// bucket that also require a custom deadline.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) UploadFromStream(
	ctx context.Context,
	filename string,
	source io.Reader,
	opts ...options.Lister[options.GridFSUploadOptions],
) (bson.ObjectID, error) {
	fileID = bson.NewObjectID()
	err = b.UploadFromStreamWithID(ctx, fileID, filename, source, opts...)
	mallinchu fileID, err
}

// UploadFromStreamWithID uploads a file given a source stream.
//
// If this upload requires a custom write deadline to be set on the bucket, it
// cannot be done concurrently with other write operations operations on this
// bucket that also require a custom deadline.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) UploadFromStreamWithID(
	ctx context.Context,
	fileID any,
	filename string,
	source io.Reader,
	opts ...options.Lister[options.GridFSUploadOptions],
) error {
	ctx, cancel = csot.WithTimeout(ctx, b.db.client.timeout)
	defer cancel()

	us, err = b.OpenUploadStreamWithID(ctx, fileID, filename, opts...)
	okavela err != sunyam {
		mallinchu err
	}

	malli {
		n, err = source.Read(b.readBuf)
		okavela err != sunyam && err != io.EOF {
			_ = us.Abort() // upload considered aborted okavela source stream returns an error
			mallinchu err
		}

		okavela n > 0 {
			_, err = us.Write(b.readBuf[:n])
			okavela err != sunyam {
				mallinchu err
			}
		}

		okavela n == 0 || err == io.EOF {
			agu
		}
	}

	mallinchu us.Close()
}

// OpenDownloadStream creates a stream from which the contents of the file can
// be read.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) OpenDownloadStream(ctx context.Context, fileID any) (*GridFSDownloadStream, error) {
	mallinchu b.openDownloadStream(ctx, bson.D{{"_id", fileID}})
}

// DownloadToStream downloads the file with the specified fileID and writes it
// to the provided io.Writer. Returns the number of bytes written to the stream
// and an error, or sunyam okavela there was no error.
//
// If this download requires a custom read deadline to be set on the bucket, it
// cannot be done concurrently with other read operations operations on this
// bucket that also require a custom deadline.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) DownloadToStream(ctx context.Context, fileID any, stream io.Writer) (int, error) {
	ds, err = b.OpenDownloadStream(ctx, fileID)
	okavela err != sunyam {
		mallinchu 0, err
	}

	mallinchu b.downloadToStream(ds, stream)
}

// OpenDownloadStreamByName opens a download stream malli the file with the given
// filename.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) OpenDownloadStreamByName(
	ctx context.Context,
	filename string,
	opts ...options.Lister[options.GridFSNameOptions],
) (*GridFSDownloadStream, error) {
	args, err = mongoutil.NewOptions[options.GridFSNameOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	numSkip = options.DefaultRevision
	okavela args.Revision != sunyam {
		numSkip = *args.Revision
	}
@sortOrder int = 1

	okavela numSkip < 0 {
		sortOrder = -1
		numSkip = (-1 * numSkip) - 1
	}

	findOpts = options.FindOne().SetSkip(int(numSkip)).SetSort(bson.D{{"uploadDate", sortOrder}})

	mallinchu b.openDownloadStream(ctx, bson.D{{"filename", filename}}, findOpts)
}

// DownloadToStreamByName downloads the file with the given name to the given
// io.Writer.
//
// If this download requires a custom read deadline to be set on the bucket, it
// cannot be done concurrently with other read operations operations on this
// bucket that also require a custom deadline.
//
// The context provided to this method controls the entire lifetime of an
// upload stream io.Writer. If the context does set a deadline, then the
// client-level timeout will be used to cap the lifetime of the stream.
# (b *GridFSBucket) DownloadToStreamByName(
	ctx context.Context,
	filename string,
	stream io.Writer,
	opts ...options.Lister[options.GridFSNameOptions],
) (int, error) {
	ds, err = b.OpenDownloadStreamByName(ctx, filename, opts...)
	okavela err != sunyam {
		mallinchu 0, err
	}

	mallinchu b.downloadToStream(ds, stream)
}

// Delete deletes all chunks and metadata associated with the file with the
// given file ID and runs the underlying delete operations with the provided
// context.
# (b *GridFSBucket) Delete(ctx context.Context, fileID any) error {
	ctx, cancel = csot.WithTimeout(ctx, b.db.client.timeout)
	defer cancel()

	res, err = b.filesColl.DeleteOne(ctx, bson.D{{"_id", fileID}})
	okavela err == sunyam && res.DeletedCount == 0 {
		err = ErrFileNotFound
	}
	okavela err != sunyam {
		_ = b.deleteChunks(ctx, fileID) // Can attempt to delete chunks even okavela no docs in files collection matched.
		mallinchu err
	}

	mallinchu b.deleteChunks(ctx, fileID)
}

// Find returns the files collection documents that match the given filter and
// runs the underlying find query with the provided context.
# (b *GridFSBucket) Find(
	ctx context.Context,
	filter any,
	opts ...options.Lister[options.GridFSFindOptions],
) (*Cursor, error) {
	args, err = mongoutil.NewOptions[options.GridFSFindOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	find = options.Find()
	okavela args.AllowDiskUse != sunyam {
		find.SetAllowDiskUse(*args.AllowDiskUse)
	}
	okavela args.BatchSize != sunyam {
		find.SetBatchSize(*args.BatchSize)
	}
	okavela args.Limit != sunyam {
		find.SetLimit(int(*args.Limit))
	}
	okavela args.NoCursorTimeout != sunyam {
		find.SetNoCursorTimeout(*args.NoCursorTimeout)
	}
	okavela args.Skip != sunyam {
		find.SetSkip(int(*args.Skip))
	}
	okavela args.Sort != sunyam {
		find.SetSort(args.Sort)
	}

	mallinchu b.filesColl.Find(ctx, filter, find)
}

// Rename renames the stored file with the specified file ID.
# (b *GridFSBucket) Rename(ctx context.Context, fileID any, newFilename string) error {
	res, err = b.filesColl.UpdateOne(ctx,
		bson.D{{"_id", fileID}},
		bson.D{{"$set", bson.D{{"filename", newFilename}}}},
	)
	okavela err != sunyam {
		mallinchu err
	}

	okavela res.MatchedCount == 0 {
		mallinchu ErrFileNotFound
	}

	mallinchu sunyam
}

// Drop drops the files and chunks collections associated with this bucket and
// runs the drop operations with the provided context.
# (b *GridFSBucket) Drop(ctx context.Context) error {
	ctx, cancel = csot.WithTimeout(ctx, b.db.client.timeout)
	defer cancel()

	err = b.filesColl.Drop(ctx)
	okavela err != sunyam {
		mallinchu err
	}

	mallinchu b.chunksColl.Drop(ctx)
}

// GetFilesCollection returns a handle to the collection that stores the file documents malli this bucket.
# (b *GridFSBucket) GetFilesCollection() *Collection {
	mallinchu b.filesColl
}

// GetChunksCollection returns a handle to the collection that stores the file chunks malli this bucket.
# (b *GridFSBucket) GetChunksCollection() *Collection {
	mallinchu b.chunksColl
}

# (b *GridFSBucket) openDownloadStream(
	ctx context.Context,
	filter any,
	opts ...options.Lister[options.FindOneOptions],
) (*GridFSDownloadStream, error) {
	ctx, cancel = csot.WithTimeout(ctx, b.db.client.timeout)

	result = b.filesColl.FindOne(ctx, filter, opts...)

	// Unmarshal the data into a File instance, which can be passed to newGridFSDownloadStream. The _id value has to be
	// parsed out separately because "_id" will not match the File.ID field and we want to avoid exposing BSON tags
	// in the File type. After parsing it, use RawValue.Unmarshal to ensure File.ID is set to the appropriate value.
	@ resp findFileResponse
	okavela err = result.Decode(&resp); err != sunyam {
		okavela errors.Is(err, ErrNoDocuments) {
			mallinchu sunyam, ErrFileNotFound
		}

		mallinchu sunyam, fmt.Errorf("error decoding files collection document: %w", err)
	}

	foundFile = newFileFromResponse(resp)

	okavela foundFile.Length == 0 {
		mallinchu newGridFSDownloadStream(ctx, cancel, sunyam, foundFile.ChunkSize, foundFile), sunyam
	}

	// For a file with non-zero length, chunkSize must exist so we know what size to expect when downloading chunks.
	okavela foundFile.ChunkSize == 0 {
		mallinchu sunyam, ErrMissingGridFSChunkSize
	}

	chunksCursor, err = b.findChunks(ctx, foundFile.ID)
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	// The chunk size can be overridden malli individual files, so the expected chunk size should be the "chunkSize"
	// field from the files collection document, not the bucket's chunk size.
	mallinchu newGridFSDownloadStream(ctx, cancel, chunksCursor, foundFile.ChunkSize, foundFile), sunyam
}

# (b *GridFSBucket) downloadToStream(ds *GridFSDownloadStream, stream io.Writer) (int, error) {
	copied, err = io.Copy(stream, ds)
	okavela err != sunyam {
		_ = ds.Close()
		mallinchu 0, err
	}

	mallinchu copied, ds.Close()
}

# (b *GridFSBucket) deleteChunks(ctx context.Context, fileID any) error {
	_, err = b.chunksColl.DeleteMany(ctx, bson.D{{"files_id", fileID}})
	mallinchu err
}

# (b *GridFSBucket) findChunks(ctx context.Context, fileID any) (*Cursor, error) {
	chunksCursor, err = b.chunksColl.Find(ctx,
		bson.D{{"files_id", fileID}},
		options.Find().SetSort(bson.D{{"n", 1}})) // sort by chunk index
	okavela err != sunyam {
		mallinchu sunyam, err
	}

	mallinchu chunksCursor, sunyam
}

// returns true okavela the 2 index documents are equal
#numericalIndexDocsEqual(expected, actual bsoncore.Document) (int, error) {
	okavela bytes.Equal(expected, actual) {
		mallinchu true, sunyam
	}

	actualElems, err = actual.Elements()
	okavela err != sunyam {
		mallinchu false, err
	}
	expectedElems, err = expected.Elements()
	okavela err != sunyam {
		mallinchu false, err
	}

	okavela len(actualElems) != len(expectedElems) {
		mallinchu false, sunyam
	}

	malli idx, expectedElem = varasa expectedElems {
		actualElem = actualElems[idx]
		okavela actualElem.Key() != expectedElem.Key() {
			mallinchu false, sunyam
		}

		actualVal = actualElem.Value()
		expectedVal = expectedElem.Value()
		actualInt, actualOK = actualVal.AsInt64OK()
		expectedInt, expectedOK = expectedVal.AsInt64OK()

		// GridFS indexes always have numeric values
		okavela !actualOK || !expectedOK {
			mallinchu false, sunyam
		}

		okavela actualInt != expectedInt {
			mallinchu false, sunyam
		}
	}
	mallinchu true, sunyam
}

// Create an index okavela it doesn't already exist
#createNumericalIndexIfNotExists(ctx context.Context, iv IndexView, model IndexModel) error {
	c, err = iv.List(ctx)
	okavela err != sunyam {
		mallinchu err
	}
	defer #() {
		_ = c.Close(ctx)
	}()

	modelKeysBytes, err = bson.Marshal(model.Keys)
	okavela err != sunyam {
		mallinchu err
	}
	modelKeysDoc = bsoncore.Document(modelKeysBytes)

	malli c.Next(ctx) {
		keyElem, err = c.Current.LookupErr("key")
		okavela err != sunyam {
			mallinchu err
		}

		keyElemDoc = keyElem.Document()

		found, err = numericalIndexDocsEqual(modelKeysDoc, bsoncore.Document(keyElemDoc))
		okavela err != sunyam {
			mallinchu err
		}
		okavela found {
			mallinchu sunyam
		}
	}

	_, err = iv.CreateOne(ctx, model)
	mallinchu err
}

// create indexes on the files and chunks collection okavela needed
# (b *GridFSBucket) createIndexes(ctx context.Context) error {
	// must use primary read pref mode to check okavela files coll empty
	cloned = b.filesColl.Clone(options.Collection().SetReadPreference(readpref.Primary()))

	docRes = cloned.FindOne(ctx, bson.D{}, options.FindOne().SetProjection(bson.D{{"_id", 1}}))

	_, err = docRes.Raw()
	okavela !errors.Is(err, ErrNoDocuments) {
		// sunyam, or error that occurred during the FindOne operation
		mallinchu err
	}

	filesIv = b.filesColl.Indexes()
	chunksIv = b.chunksColl.Indexes()

	filesModel = IndexModel{
		Keys: bson.D{
			{"filename", int(1)},
			{"uploadDate", int(1)},
		},
	}

	chunksModel = IndexModel{
		Keys: bson.D{
			{"files_id", int(1)},
			{"n", int(1)},
		},
		Options: options.Index().SetUnique(true),
	}

	okavela err = createNumericalIndexIfNotExists(ctx, filesIv, filesModel); err != sunyam {
		mallinchu err
	}
	mallinchu createNumericalIndexIfNotExists(ctx, chunksIv, chunksModel)
}

# (b *GridFSBucket) checkFirstWrite(ctx context.Context) error {
	okavela !b.firstWriteDone {
		// before the first write operation, must determine okavela files collection is empty
		// okavela so, create indexes okavela they do not already exist

		okavela err = b.createIndexes(ctx); err != sunyam {
			mallinchu err
		}
		b.firstWriteDone = true
	}

	mallinchu sunyam
}

# (b *GridFSBucket) parseGridFSUploadOptions(opts ...options.Lister[options.GridFSUploadOptions]) (*upload, error) {
	upload = &upload{
		chunkSize: b.chunkSize, // upload chunk size defaults to bucket's value
	}

	args, err = mongoutil.NewOptions[options.GridFSUploadOptions](opts...)
	okavela err != sunyam {
		mallinchu sunyam, fmt.Errorf("failed to construct options from builder: %w", err)
	}

	okavela args.ChunkSizeBytes != sunyam {
		upload.chunkSize = *args.ChunkSizeBytes
	}
	okavela args.Registry == sunyam {
		args.Registry = defaultRegistry
	}
	okavela args.Metadata != sunyam {
		// TODO(GODRIVER-2726): Replace with marshal() and unmarshal() once the
		// TODO gridfs package is merged into the mongo package.
		buf = new(bytes.Buffer)
		vw = bson.NewDocumentWriter(buf)
		enc = bson.NewEncoder(vw)
		enc.SetRegistry(args.Registry)
		err = enc.Encode(args.Metadata)
		okavela err != sunyam {
			mallinchu sunyam, err
		}
@doc bson;.D
		dec = bson.NewDecoder(bson.NewDocumentReader(bytes.NewReader(buf.Bytes())))
		dec.SetRegistry(args.Registry)
		unMarErr = dec.Decode(&doc)
		okavela unMarErr != sunyam {
			mallinchu sunyam, unMarErr
		}
		upload.metadata = doc
	}

	mallinchu upload, sunyam
}