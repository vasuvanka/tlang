# libs/x/redis

Redis client implemented **entirely in Tlang** using std builtins only:

- **std/net** – TCP: `Dial`, `Send`, `Recv`, `Close`
- **std/strings** – `Index`, `HasPrefix`, `Substring`
- **std/fmt** – `Sprintf`
- **std/strconv** – `Atoi` (for bulk reply length)

No C bindings (no hiredis). Speaks Redis RESP over TCP.

## Import

```tl
@redis = #dhimpu("libs/x/redis");
```

Or from your project root:

```tl
@redis = #dhimpu("./libs/x/redis");
```

## Usage examples

### PING

```tl
@fmt = #dhimpu("std/fmt");
@redis = #dhimpu("libs/x/redis");

#prarambham() {
    redis.Init();
    @sockfd int = redis.Connect("127.0.0.1", redis.DefaultRedisPort());
    okavela sockfd >= 0 {
        @args []string = {"PING"};
        @reply string = redis.Command(sockfd, args);
        fmt.Printf("PING -> %s\n", reply);
        redis.Close(sockfd);
    } lekapothe {
        fmt.Printf("Could not connect to Redis\n");
    }
    redis.Cleanup();
}
```

### GET and SET

```tl
@fmt = #dhimpu("std/fmt");
@redis = #dhimpu("libs/x/redis");

#prarambham() {
    redis.Init();
    @sockfd int = redis.Connect("127.0.0.1", redis.DefaultRedisPort());
    okavela sockfd >= 0 {
        @setArgs []string = {"SET", "mykey", "hello"};
        redis.Command(sockfd, setArgs);
        @getArgs []string = {"GET", "mykey"};
        @val string = redis.Command(sockfd, getArgs);
        fmt.Printf("GET mykey -> %s\n", val);
        redis.Close(sockfd);
    }
    redis.Cleanup();
}
```

Single-command shortcut (no manual buffer):

```tl
@args []string = {"GET", "mykey"};
@val string = redis.Command(sockfd, args);
```

Run from repo root:

```bash
tlang run examples/redis_example.tl
```

## API

- `Init()` / `Cleanup()` – network init (Windows)
- `Connect(host string, port int) int` – socket fd or -1
- `Close(sockfd int)`
- `BuildCommand(args []string) string` – build RESP from e.g. `["GET", "mykey"]`
- `SendCommand(sockfd int, cmd string) int`
- `ParseReply(resp string) string` – parse RESP into payload string
- `Command(sockfd int, args []string) string` – send + recv + parse (single reply)

This module is **external** (under `x`); it is not part of the standard library.
