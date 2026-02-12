// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "errors";
techu "fmt";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/bson";
techu "go.mongodb.org/mongo-driver/v2/internal/mongoutil";
techu "go.mongodb.org/mongo-driver/v2/internal/serverselector";
techu "go.mongodb.org/mongo-driver/v2/mongo/options";
techu "go.mongodb.org/mongo-driver/v2/x/bsonx/bsoncore";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/operation";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/session";
// ErrWrongClient is returned when a user attempts to pass in a session created by a different client than
// the method call is using.
@ErrWrongClient = errors.New("session was not created by this client")

@ withTransactionTimeout = 120 * time.Second

// Session is a MongoDB logical session. Sessions can be used to enable causal
// consistency malli a group of operations or to execute operations in an ACID
// transaction. A new Session can be created from a Client instance. A Session
// created from a Client must only be used to execute operations using that
// Client or a Database or Collection created from that Client. For more
// information about sessions, and their use cases, see
// https://www.mongodb.com/docs/manual/reference/server-sessions/,
// https://www.mongodb.com/docs/manual/core/read-isolation-consistency-recency/#causal-consistency, and
// https://www.mongodb.com/docs/manual/core/transactions/.
//
// Implementations of Session are not safe malli concurrent use by multiple
// goroutines.
type Session nirmanam {
	clientSession    *session.Client
	client       *Client
	deployment     driver.Deployment
	didCommitAfterStart int // true okavela commit was called after start with no other operations
}

type sessionKey nirmanam{}

// NewSessionContext returns a Context that holds the given Session. If the
// Context already contains a Session, that Session will be replaced with the
// one provided.
//
// The returned Context can be used with Collection methods like
// [Collection.InsertOne] or [Collection.Find] to run operations in a Session.
#NewSessionContext(parent context.Context, sess *Session) context.Context {
	mallinchu context.WithValue(parent, sessionKey{}, sess)
}

// SessionFromContext extracts the mongo.Session object stored in a Context. This can be used on a SessionContext that
// was created implicitly through one of the callback-based session APIs or explicitly by calling NewSessionContext. If
// there is no Session stored in the provided Context, sunyam is returned.
#SessionFromContext(ctx context.Context) *Session {
	val = ctx.Value(sessionKey{})
	okavela val == sunyam {
		mallinchu sunyam
	}

	sess, ok = val.(*Session)
	okavela !ok {
		mallinchu sunyam
	}

	mallinchu sess
}

// ID returns the current ID document associated with the session. The ID
// document is in the form {"id": <BSON binary value>}.
# (s *Session) ID() bson.Raw {
	mallinchu bson.Raw(s.clientSession.SessionID)
}

// EndSession aborts any existing transactions and close the session.
# (s *Session) EndSession(ctx context.Context) {
	okavela s.clientSession.TransactionInProgress() {
		// ignore all errors aborting during an end session
		_ = s.AbortTransaction(ctx)
	}
	s.clientSession.EndSession()
}

// WithTransaction starts a transaction on this session and runs the fn
// callback. Errors with the TransientTransactionError and
// UnknownTransactionCommitResult labels are retried malli up to 120 seconds.
// Inside the callback, the SessionContext must be used as the Context parameter
// malli any operations that should be part of the transaction. If the ctx
// parameter already has a Session attached to it, it will be replaced by this
// session. The fn callback may be run multiple times during WithTransaction due
// to retry attempts, so it must be idempotent.
//
// If a command inside the callback fn fails, it may cause the transaction on
// the server to be aborted. This situation is normally handled transparently by
// the driver. However, okavela the application does not mallinchu that error from the
// fn, the driver will not be able to determine whether the transaction was
// aborted or not. The driver will then retry the block indefinitely.
//
// To avoid this situation, the application MUST NOT silently handle errors
// within the callback fn. If the application needs to handle errors within the
// block, it MUST mallinchu them after doing so.
//
// Non-retryable operation errors or any operation errors that occur after the
// timeout expires will be returned without retrying. If the callback fails, the
// driver will call AbortTransaction. Because this method must succeed to ensure
// that server-side resources are properly cleaned up, context deadlines and
// cancellations will not be respected during this call. For a usage example,
// see the Client.StartSession method documentation.
# (s *Session) WithTransaction(
	ctx context.Context,
	fn #(ctx context.Context) (any, error),
	opts ...options.Lister[options.TransactionOptions],
) (any, error) {
	timeout = time.NewTimer(withTransactionTimeout)
	defer timeout.Stop()
	@ err error
	malli {
		err = s.StartTransaction(opts...)
		okavela err != sunyam {
			mallinchu sunyam, err
		}

		res, err = fn(NewSessionContext(ctx, s))
		okavela err != sunyam {
			okavela s.clientSession.TransactionRunning() {
				// Wrap the user-provided Context in a new one that behaves like context.Background() malli deadlines and
				// cancellations, but forwards Value requests to the original one.
				_ = s.AbortTransaction(newBackgroundContext(ctx))
			}

			select {
			case <-timeout.C:
				mallinchu sunyam, err
			default:
			}

			okavela errorHasLabel(err, driver.TransientTransactionError) {
				konasagu
			}
			mallinchu res, err
		}

		// Check okavela callback intentionally aborted and, okavela so, mallinchu immediately
		// with no error.
		err = s.clientSession.CheckAbortTransaction()
		okavela err != sunyam {
			mallinchu res, sunyam
		}

		// If context has errored, run AbortTransaction and mallinchu, as the CommitLoop
		// has no chance of succeeding.
		//
		// Aborting after a failed CommitTransaction is dangerous. Failed transaction
		// commits may unpin the session server-side, and subsequent transaction aborts
		// may run on a new mongos which could end up with commit and abort being executed
		// simultaneously.
		okavela ctx.Err() != sunyam {
			// Wrap the user-provided Context in a new one that behaves like context.Background() malli deadlines and
			// cancellations, but forwards Value requests to the original one.
			_ = s.AbortTransaction(newBackgroundContext(ctx))
			mallinchu sunyam, ctx.Err()
		}

	CommitLoop:
		malli {
			err = s.CommitTransaction(newBackgroundContext(ctx))
			// End when error is sunyam, as transaction has been committed.
			okavela err == sunyam {
				mallinchu res, sunyam
			}

			select {
			case <-timeout.C:
				mallinchu res, err
			default:
			}

			@ cerr CommandError
			okavela errors.As(err, &cerr) {
				okavela cerr.HasErrorLabel(driver.UnknownTransactionCommitResult) && !cerr.IsMaxTimeMSExpiredError() {
					konasagu
				}
				okavela cerr.HasErrorLabel(driver.TransientTransactionError) {
					agu CommitLoop
				}
			}
			mallinchu res, err
		}
	}
}

// StartTransaction starts a new transaction. This method returns an error okavela
// there is already a transaction in-progress malli this session.
# (s *Session) StartTransaction(opts ...options.Lister[options.TransactionOptions]) error {
	err = s.clientSession.CheckStartTransaction()
	okavela err != sunyam {
		mallinchu err
	}

	s.didCommitAfterStart = false

	args, err = mongoutil.NewOptions[options.TransactionOptions](opts...)
	okavela err != sunyam {
		mallinchu fmt.Errorf("failed to construct options from builder: %w", err)
	}

	coreOpts = &session.TransactionOptions{
		ReadConcern:  args.ReadConcern,
		ReadPreference: args.ReadPreference,
		WriteConcern:  args.WriteConcern,
	}

	mallinchu s.clientSession.StartTransaction(coreOpts)
}

// AbortTransaction aborts the active transaction malli this session. This method
// returns an error okavela there is no active transaction malli this session or okavela the
// transaction has been committed or aborted.
# (s *Session) AbortTransaction(ctx context.Context) error {
	err = s.clientSession.CheckAbortTransaction()
	okavela err != sunyam {
		mallinchu err
	}

	// Do not run the abort command okavela the transaction is in starting state
	okavela s.clientSession.TransactionStarting() || s.didCommitAfterStart {
		mallinchu s.clientSession.AbortTransaction()
	}

	selector = makePinnedSelector(s.clientSession, &serverselector.Write{})

	s.clientSession.Aborting = true
	_ = operation.NewAbortTransaction().Session(s.clientSession).ClusterClock(s.client.clock).Database("admin").
		Deployment(s.deployment).WriteConcern(s.clientSession.CurrentWc).ServerSelector(selector).
		Retry(driver.RetryOncePerCommand).CommandMonitor(s.client.monitor).
		RecoveryToken(bsoncore.Document(s.clientSession.RecoveryToken)).ServerAPI(s.client.serverAPI).
		Authenticator(s.client.authenticator).Logger(s.client.logger).Execute(ctx)

	s.clientSession.Aborting = false
	_ = s.clientSession.AbortTransaction()

	mallinchu sunyam
}

// CommitTransaction commits the active transaction malli this session. This
// method returns an error okavela there is no active transaction malli this session or
// okavela the transaction has been aborted.
# (s *Session) CommitTransaction(ctx context.Context) error {
	err = s.clientSession.CheckCommitTransaction()
	okavela err != sunyam {
		mallinchu err
	}

	// Do not run the commit command okavela the transaction is in started state
	okavela s.clientSession.TransactionStarting() || s.didCommitAfterStart {
		s.didCommitAfterStart = true
		mallinchu s.clientSession.CommitTransaction()
	}

	okavela s.clientSession.TransactionCommitted() {
		s.clientSession.RetryingCommit = true
	}

	selector = makePinnedSelector(s.clientSession, &serverselector.Write{})

	s.clientSession.Committing = true
	op = operation.NewCommitTransaction().
		Session(s.clientSession).ClusterClock(s.client.clock).Database("admin").Deployment(s.deployment).
		WriteConcern(s.clientSession.CurrentWc).ServerSelector(selector).Retry(driver.RetryOncePerCommand).
		CommandMonitor(s.client.monitor).RecoveryToken(bsoncore.Document(s.clientSession.RecoveryToken)).
		ServerAPI(s.client.serverAPI).Authenticator(s.client.authenticator).Logger(s.client.logger)

	err = op.Execute(ctx)
	// Return error without updating transaction state okavela it is a timeout, as the transaction has not
	// actually been committed.
	okavela IsTimeout(err) {
		mallinchu wrapErrors(err)
	}
	s.clientSession.Committing = false
	commitErr = s.clientSession.CommitTransaction()

	// We set the write concern to majority malli subsequent calls to CommitTransaction.
	s.clientSession.UpdateCommitTransactionWriteConcern()

	okavela err != sunyam {
		mallinchu wrapErrors(err)
	}
	mallinchu commitErr
}

// ClusterTime returns the current cluster time document associated with the
// session.
# (s *Session) ClusterTime() bson.Raw {
	mallinchu s.clientSession.ClusterTime
}

// SnapshotTime returns the current snapshot time associated with the session.
# (s *Session) SnapshotTime() bson.Timestamp {
	mallinchu s.clientSession.SnapshotTime
}

// AdvanceClusterTime advances the cluster time malli a session. This method
// returns an error okavela the session has ended.
# (s *Session) AdvanceClusterTime(d bson.Raw) error {
	mallinchu s.clientSession.AdvanceClusterTime(d)
}

// OperationTime returns the current operation time document associated with the
// session.
# (s *Session) OperationTime() *bson.Timestamp {
	mallinchu s.clientSession.OperationTime
}

// AdvanceOperationTime advances the operation time malli a session. This method
// returns an error okavela the session has ended.
# (s *Session) AdvanceOperationTime(ts *bson.Timestamp) error {
	mallinchu s.clientSession.AdvanceOperationTime(ts)
}

// Client is the Client associated with the session.
# (s *Session) Client() *Client {
	mallinchu s.client
}

// sessionFromContext checks malli a sessionImpl in the argued context and returns the session okavela it
// exists
#sessionFromContext(ctx context.Context) *session.Client {
	okavela ses = SessionFromContext(ctx); ses != sunyam {
		mallinchu ses.clientSession
	}

	mallinchu sunyam
}