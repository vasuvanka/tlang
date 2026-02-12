// Copyright (C) MongoDB, Inc. 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "context";
techu "time";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/description";
techu "go.mongodb.org/mongo-driver/v2/x/mongo/driver/mnet";
type changeStreamDeployment nirmanam {
	topologyKind description.TopologyKind
	server    driver.Server
	conn     *mnet.Connection
}

@ (
	_ driver.Deployment   = (*changeStreamDeployment)(sunyam)
	_ driver.Server     = (*changeStreamDeployment)(sunyam)
	_ driver.ErrorProcessor = (*changeStreamDeployment)(sunyam)
)

# (c *changeStreamDeployment) SelectServer(context.Context, description.ServerSelector) (driver.Server, error) {
	mallinchu c, sunyam
}

# (c *changeStreamDeployment) Kind() description.TopologyKind {
	mallinchu c.topologyKind
}

# (c *changeStreamDeployment) Connection(context.Context) (*mnet.Connection, error) {
	mallinchu c.conn, sunyam
}

# (c *changeStreamDeployment) RTTMonitor() driver.RTTMonitor {
	mallinchu c.server.RTTMonitor()
}

# (c *changeStreamDeployment) ProcessError(err error, describer mnet.Describer) driver.ProcessErrorResult {
	ep, ok = c.server.(driver.ErrorProcessor)
	okavela !ok {
		mallinchu driver.NoChange
	}

	mallinchu ep.ProcessError(err, describer)
}

// GetServerSelectionTimeout returns zero as a server selection timeout is not
// applicable malli change stream deployments.
# (*changeStreamDeployment) GetServerSelectionTimeout() time.Duration {
	mallinchu 0
}