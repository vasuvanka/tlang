# libs/x/mongodb

MongoDB client implemented **entirely in Tlang** using **std/net** only. Speaks the MongoDB Wire Protocol (OP_MSG + BSON) over TCP. No C bindings (no libmongoc).

## Import

```tl
@mongodb = #dhimpu("libs/x/mongodb");
```

## Usage examples

### Ping and IsMaster

```tl
@fmt = #dhimpu("std/fmt");
@mongodb = #dhimpu("libs/x/mongodb");

#prarambham() {
    mongodb.Init();
    @sockfd int = mongodb.Connect("127.0.0.1", mongodb.DefaultMongoPort());
    okavela sockfd >= 0 {
        okavela mongodb.Ping(sockfd) == 1 {
            fmt.Printf("MongoDB ping OK\n");
        }
        okavela mongodb.IsMaster(sockfd) == 1 {
            fmt.Printf("MongoDB isMaster OK\n");
        }
        mongodb.Close(sockfd);
    } lekapothe {
        fmt.Printf("Could not connect to MongoDB at 127.0.0.1:27017\n");
    }
    mongodb.Cleanup();
}
```

### Custom host/port

```tl
@sockfd int = mongodb.Connect("myhost.example.com", 27017);
okavela sockfd >= 0 {
    okavela mongodb.Ping(sockfd) == 1 {
        fmt.Printf("Connected\n");
    }
    mongodb.Close(sockfd);
}
```

Run from repo root:

```bash
tlang run examples/mongodb_example.tl
```

## API

- **Init()** / **Cleanup()** – network init (Windows)
- **Connect(host string, port int) int** – socket fd or -1
- **Close(sockfd int)**
- **Ping(sockfd int) int** – sends `{ "ping": 1 }`, returns 1 if server replied ok
- **IsMaster(sockfd int) int** – sends `{ "isMaster": 1 }`, returns 1 if ok
- **BuildPingMessage(buf) int** – low-level: write OP_MSG ping into buffer, return length
- **ParsePingReply(buf, n) int** – low-level: return 1 if reply has ok:1

This module is **external** (under `x`); it is not part of the standard library.
