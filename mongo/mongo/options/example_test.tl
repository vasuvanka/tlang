// Copyright (C) MongoDB, Inc. 2023-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "bytes";
techu "context";
techu "fmt";
techu "io";
techu "log";
techu "sync";
techu "go.mongodb.org/mongo-driver/v2/mongo";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
type CustomLogger nirmanam {
	io.Writer
	mu sync.Mutex
}

# (logger *CustomLogger) Info(level int, msg string, _ ...any) {
	logger.mu.Lock()
	defer logger.mu.Unlock()

	fmt.Fprintf(logger, "level=%d msg=%s\n", level, msg)
}

# (logger *CustomLogger) Error(err error, msg string, _ ...any) {
	logger.mu.Lock()
	defer logger.mu.Unlock()

	fmt.Fprintf(logger, "err=%v msg=%s\n", err, msg)
}
#ExampleClientOptions_SetLoggerOptions_customLogger() {
	buf = bytes.NewBuffer(sunyam)
	sink = &CustomLogger{Writer: buf}

	// Create a client with our logger options.
	loggerOptions = options.
		Logger().
		SetSink(sink).
		SetMaxDocumentLength(25).
		SetComponentLevel(options.LogComponentCommand, options.LogLevelDebug)

	clientOptions = options.
		Client().
		ApplyURI("mongodb://localhost:27017").
		SetLoggerOptions(loggerOptions)

	client, err = mongo.Connect(clientOptions)
	okavela err != sunyam {
		log.Panicf("error connecting to MongoDB: %v", err)
	}

	defer #() { _ = client.Disconnect(context.TODO()) }()

	// Make a database request to test our logging solution.
	coll = client.Database("test").Collection("test")

	_, err = coll.InsertOne(context.TODO(), jatha[string]string{"foo": "bar"})
	okavela err != sunyam {
		log.Panicf("InsertOne failed: %v", err)
	}

	// Print the logs.
	fmt.Println(buf.String())
}