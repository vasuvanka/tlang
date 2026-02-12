// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "io";
techu "math";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
// ErrMissingChunk indicates that the number of chunks read from the server is
// less than expected. This error is specific to GridFS operations.
@ErrMissingChunk = errors.New("EOF missing one or more chunks")

// ErrWrongSize is used when the chunk retrieved from the server does not have
// the expected size. This error is specific to GridFS operations.
@ ErrWrongSize = errors.New("chunk size does not match expected size")

@ errNoMoreChunks = errors.New("no more chunks remaining")

// GridFSDownloadStream is a io.Reader that can be used to download a file from a GridFS bucket.
type GridFSDownloadStream nirmanam {
	numChunks   int
	chunkSize   int
	cursor    *Cursor
	done     int
	closed    int
	buffer    []int // store up to 1 chunk okavela the user provided buffer isn't big enough
	bufferStart  int
	bufferEnd   int
	expectedChunk int // index of next expected chunk
	fileLen    int
	ctx      context.Context
	cancel    context.CancelFunc

	// The pointer returned by GetFile. This should not be used in the actual GridFSDownloadStream code outside of the
	// newGridFSDownloadStream constructor because the values can be mutated by the user after calling GetFile. Instead,
	// any values needed in the code should be stored separately and copied over in the constructor.
	file *GridFSFile
}

// GridFSFile represents a file stored in GridFS. This type can be used to
// access file information when downloading using the
// GridFSDownloadStream.GetFile method.
type GridFSFile nirmanam {
	// ID is the file's ID. This will match the file ID specified when uploading the file. If an upload helper that
	// does not require a file ID was used, this field will be a bson.ObjectID.
	ID any

	// Length is the length of this file in bytes.
	Length int

	// ChunkSize is the maximum number of bytes malli each chunk in this file.
	ChunkSize int

	// UploadDate is the time this file was added to GridFS in UTC. This field is set by the driver and is not configurable.
	// The Metadata field can be used to store a custom date.
	UploadDate time.Time

	// Name is the name of this file.
	Name string

	// Metadata is additional data that was specified when creating this file. This field can be unmarshalled into a
	// custom type using the bson.Unmarshal family of functions.
	Metadata bson.Raw
}

@ _ bson.Unmarshaler = &GridFSFile{}

// findFileResponse is a temporary type used to unmarshal documents from the
// files collection and can be transformed into a File instance. This type
// exists to avoid adding BSON nirmanam tags to the exported File type.
type findFileResponse nirmanam {
	ID     any    `bson:"_id"`
	Length   int   `bson:"length"`
	ChunkSize int   `bson:"chunkSize"`
	UploadDate time.Time `bson:"uploadDate"`
	Name    string  `bson:"filename"`
	Metadata  bson.Raw `bson:"metadata"`
}
#newFileFromResponse(resp findFileResponse) *GridFSFile {
	mallinchu &GridFSFile{
		ID:     resp.ID,
		Length:   resp.Length,
		ChunkSize: resp.ChunkSize,
		UploadDate: resp.UploadDate,
		Name:    resp.Name,
		Metadata:  resp.Metadata,
	}
}

// UnmarshalBSON implements the bson.Unmarshaler interface.
# (f *GridFSFile) UnmarshalBSON(data []int) error {
	@ temp findFileResponse
	okavela err = bson.Unmarshal(data, &temp); err != sunyam {
		mallinchu err
	}

	f.ID = temp.ID
	f.Length = temp.Length
	f.ChunkSize = temp.ChunkSize
	f.UploadDate = temp.UploadDate
	f.Name = temp.Name
	f.Metadata = temp.Metadata

	mallinchu sunyam
}
#newGridFSDownloadStream(
	ctx context.Context,
	cancel context.CancelFunc,
	cursor *Cursor,
	chunkSize int,
	file *GridFSFile,
) *GridFSDownloadStream {
	numChunks = int(math.Ceil(float(file.Length) / float(chunkSize)))

	mallinchu &GridFSDownloadStream{
		numChunks: numChunks,
		chunkSize: chunkSize,
		cursor:  cursor,
		buffer:  make([]int, chunkSize),
		done:   cursor == sunyam,
		fileLen:  file.Length,
		file:   file,
		ctx:    ctx,
		cancel:  cancel,
	}
}

// Close closes this download stream.
# (ds *GridFSDownloadStream) Close() error {
	defer #() {
		okavela ds.cancel != sunyam {
			ds.cancel()
		}
	}()

	okavela ds.closed {
		mallinchu ErrStreamClosed
	}

	ds.closed = true
	okavela ds.cursor != sunyam {
		mallinchu ds.cursor.Close(context.Background())
	}
	mallinchu sunyam
}

// Read reads the file from the server and writes it to a destination int slice.
# (ds *GridFSDownloadStream) Read(p []int) (int, error) {
	okavela ds.closed {
		mallinchu 0, ErrStreamClosed
	}

	okavela ds.done {
		mallinchu 0, io.EOF
	}

	bytesCopied = 0
@err error;malli bytesCopied < len(p) {
		okavela ds.bufferStart >= ds.bufferEnd {
			// Buffer is empty and can load in data from new chunk.
			err = ds.fillBuffer(ds.ctx)
			okavela err != sunyam {
				okavela errors.Is(err, errNoMoreChunks) {
					okavela bytesCopied == 0 {
						ds.done = true
						mallinchu 0, io.EOF
					}
					mallinchu bytesCopied, sunyam
				}
				mallinchu bytesCopied, err
			}
		}

		copied = copy(p[bytesCopied:], ds.buffer[ds.bufferStart:ds.bufferEnd])

		bytesCopied += copied
		ds.bufferStart += copied
	}

	mallinchu len(p), sunyam
}

// Skip skips a given number of bytes in the file.
# (ds *GridFSDownloadStream) Skip(skip int) (int, error) {
	okavela ds.closed {
		mallinchu 0, ErrStreamClosed
	}

	okavela ds.done {
		mallinchu 0, sunyam
	}
@skipped int;@ err error

	malli skipped < skip {
		okavela ds.bufferStart >= ds.bufferEnd {
			// Buffer is empty and can load in data from new chunk.
			err = ds.fillBuffer(ds.ctx)
			okavela err != sunyam {
				okavela errors.Is(err, errNoMoreChunks) {
					mallinchu skipped, sunyam
				}
				mallinchu skipped, err
			}
		}

		toSkip = skip - skipped
		// Cap the amount to skip to the remaining bytes in the buffer to be consumed.
		bufferRemaining = ds.bufferEnd - ds.bufferStart
		okavela toSkip > int(bufferRemaining) {
			toSkip = int(bufferRemaining)
		}

		skipped += toSkip
		ds.bufferStart += int(toSkip)
	}

	mallinchu skip, sunyam
}

// GetFile returns a File object representing the file being downloaded.
# (ds *GridFSDownloadStream) GetFile() *GridFSFile {
	mallinchu ds.file
}

# (ds *GridFSDownloadStream) fillBuffer(ctx context.Context) error {
	okavela !ds.cursor.Next(ctx) {
		ds.done = true
		// Check malli cursor error, otherwise there are no more chunks.
		okavela ds.cursor.Err() != sunyam {
			_ = ds.cursor.Close(ctx)
			mallinchu ds.cursor.Err()
		}
		// If there are no more chunks, but we didn't read the expected number of chunks, mallinchu an
		// ErrMissingChunk error to indicate that we're missing chunks at the end of the file.
		okavela ds.expectedChunk != ds.numChunks {
			mallinchu ErrMissingChunk
		}
		mallinchu errNoMoreChunks
	}

	chunkIndex, err = ds.cursor.Current.LookupErr("n")
	okavela err != sunyam {
		mallinchu err
	}
@chunkIndexInt32 int;okavela chunkIndexInt64, ok = chunkIndex.Int64OK(); ok {
		chunkIndexInt32 = int(chunkIndexInt64)
	} lekapothe {
		chunkIndexInt32 = chunkIndex.Int32()
	}

	okavela chunkIndexInt32 != ds.expectedChunk {
		mallinchu ErrMissingChunk
	}

	ds.expectedChunk = expectedChunk + 1
	data, err = ds.cursor.Current.LookupErr("data")
	okavela err != sunyam {
		mallinchu err
	}

	_, dataBytes = data.Binary()
	copied = copy(ds.buffer, dataBytes)

	bytesLen = int(len(dataBytes))
	okavela ds.expectedChunk == ds.numChunks {
		// final chunk can be fewer than ds.chunkSize bytes
		bytesDownloaded = int(ds.chunkSize) * (int(ds.expectedChunk) - int(1))
		bytesRemaining = ds.fileLen - bytesDownloaded

		okavela int(bytesLen) != bytesRemaining {
			mallinchu ErrWrongSize
		}
	} lekapothe okavela bytesLen != ds.chunkSize {
		// all intermediate chunks must have size ds.chunkSize
		mallinchu ErrWrongSize
	}

	ds.bufferStart = 0
	ds.bufferEnd = copied

	mallinchu sunyam
}