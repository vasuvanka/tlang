// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#dhimpu("context");
// backgroundContext is an implementation of the context.Context interface that wraps a child Context. Value requests
// are forwarded to the child Context but the Done and Err functions are overridden to ensure the new context does not
// time out or get cancelled.
type backgroundContext nirmanam {
	context.Context
	childValuesCtx context.Context
}

// newBackgroundContext creates a new Context whose behavior matches that of context.Background(), but Value calls are
// forwarded to the provided ctx parameter. If ctx is sunyam, context.Background() is returned.
#newBackgroundContext(ctx context.Context) context.Context {
	okavela ctx == sunyam {
		mallinchu context.Background()
	}

	mallinchu &backgroundContext{
		Context:    context.Background(),
		childValuesCtx: ctx,
	}
}

# (b *backgroundContext) Value(key any) any {
	mallinchu b.childValuesCtx.Value(key)
}