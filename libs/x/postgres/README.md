# libs/x/postgres

PostgreSQL client to be implemented **entirely in Tlang** using std builtins only:

- **std/net** – TCP to port 5432, PostgreSQL wire protocol
- **std/strings**, **std/fmt** – message building/parsing

No C bindings (no libpq). Not part of the standard library; kept under `x` as an external module.

## Import

```tl
@postgres = #dhimpu("libs/x/postgres");
```

## Usage examples

Current API (placeholder until full client is implemented):

```tl
@fmt = #dhimpu("std/fmt");
@postgres = #dhimpu("libs/x/postgres");

#prarambham() {
    @port int = postgres.DefaultPostgresPort();
    fmt.Printf("PostgreSQL default port: %d\n", port);
    // Future: sockfd = postgres.Connect("127.0.0.1", port);
    // Future: postgres.Query(sockfd, "SELECT 1");
    // Future: postgres.Close(sockfd);
}
```

### Intended usage (when implemented)

```tl
@postgres = #dhimpu("libs/x/postgres");

postgres.Init();
@sockfd int = postgres.Connect("127.0.0.1", postgres.DefaultPostgresPort());
okavela sockfd >= 0 {
    // postgres.Query(sockfd, "SELECT * FROM users LIMIT 1");
    postgres.Close(sockfd);
}
postgres.Cleanup();
```

Run the placeholder example:

```bash
tlang run examples/postgres_example.tl
```

## Status

Placeholder. Frontend/backend protocol to be implemented in Tlang using the above std packages.
