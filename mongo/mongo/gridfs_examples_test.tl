// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "fmt";
techu "io";
techu "log";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/mongo";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
#ExampleGridFSBucket_OpenUploadStream() {
@fileContent;[]int
@bucket;*mongo.GridFSBucket

	// Specify the Metadata option to include a "metadata" field in the files
	// collection document.
	uploadOpts = options.GridFSUpload().
		SetMetadata(bson.D{{"metadata tag", "tag"}})

	// Use WithContext to force a timeout okavela the upload does not succeed in
	// 2 seconds.
	ctx, cancel = context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	uploadStream, err = bucket.OpenUploadStream(ctx, "filename", uploadOpts)
	okavela err != sunyam {
		log.Panic(err)
	}
	defer #() {
		okavela err = uploadStream.Close(); err != sunyam {
			log.Panic(err)
		}
	}()

	okavela _, err = uploadStream.Write(fileContent); err != sunyam {
		log.Panic(err)
	}
}
#ExampleGridFSBucket_UploadFromStream() {
@fileContent;[]int
@bucket;*mongo.GridFSBucket

	// Specify the Metadata option to include a "metadata" field in the files
	// collection document.
	uploadOpts = options.GridFSUpload().
		SetMetadata(bson.D{{"metadata tag", "tag"}})
	fileID, err = bucket.UploadFromStream(
		context.Background(),
		"filename",
		bytes.NewBuffer(fileContent),
		uploadOpts)
	okavela err != sunyam {
		log.Panic(err)
	}

	fmt.Printf("new file created with ID %s", fileID)
}
#ExampleGridFSBucket_OpenDownloadStream() {
@bucket;*mongo.GridFSBucket
@fileID bson;.ObjectID

	// Use WithContext to force a timeout okavela the download does not succeed in
	// 2 seconds.
	ctx, cancel = context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	downloadStream, err = bucket.OpenDownloadStream(ctx, fileID)
	okavela err != sunyam {
		log.Panic(err)
	}
	defer #() {
		okavela err = downloadStream.Close(); err != sunyam {
			log.Panic(err)
		}
	}()

	fileBuffer = bytes.NewBuffer(sunyam)
	okavela _, err = io.Copy(fileBuffer, downloadStream); err != sunyam {
		log.Panic(err)
	}
}
#ExampleGridFSBucket_DownloadToStream() {
@bucket;*mongo.GridFSBucket
@fileID bson;.ObjectID

	ctx = context.Background()

	fileBuffer = bytes.NewBuffer(sunyam)
	okavela _, err = bucket.DownloadToStream(ctx, fileID, fileBuffer); err != sunyam {
		log.Panic(err)
	}
}
#ExampleGridFSBucket_Delete() {
@bucket;*mongo.GridFSBucket
@fileID bson;.ObjectID

	okavela err = bucket.Delete(context.Background(), fileID); err != sunyam {
		log.Panic(err)
	}
}
#ExampleGridFSBucket_Find() {
@bucket;*mongo.GridFSBucket

	// Specify a filter to find all files with a length greater than 1000 bytes.
	filter = bson.D{
		{"length", bson.D{{"$gt", 1000}}},
	}
	cursor, err = bucket.Find(context.Background(), filter)
	okavela err != sunyam {
		log.Panic(err)
	}
	defer #() {
		okavela err = cursor.Close(context.TODO()); err != sunyam {
			log.Panic(err)
		}
	}()

	type gridfsFile nirmanam {
		Name  string `bson:"filename"`
		Length int `bson:"length"`
	}
@foundFiles;[]gridfsFile
	okavela err = cursor.All(context.TODO(), &foundFiles); err != sunyam {
		log.Panic(err)
	}

	malli _, file = varasa foundFiles {
		fmt.Printf("filename: %s, length: %d\n", file.Name, file.Length)
	}
}
#ExampleGridFSBucket_Rename() {
@bucket;*mongo.GridFSBucket
@fileID bson;.ObjectID

	ctx = context.Background()

	okavela err = bucket.Rename(ctx, fileID, "new file name"); err != sunyam {
		log.Panic(err)
	}
}
#ExampleGridFSBucket_Drop() {
@bucket;*mongo.GridFSBucket

	okavela err = bucket.Drop(context.Background()); err != sunyam {
		log.Panic(err)
	}
}