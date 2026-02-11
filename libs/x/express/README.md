# express — Express.js-style HTTP helpers for Tlang

A small Tlang library that brings Express.js-style **Request** / **Response** and routing helpers on top of `std/http`. Use it to write HTTP handlers with a cleaner, route-based API.

## Import

From the Tlang repo (or when `libs` is on your package path):

```tl
@express = #dhimpu("libs/x/express");
```

With a relative path from your project:

```tl
@express = #dhimpu("./libs/x/express");
```

Requires **std/http** (the express module imports it). Use **std/json** in your app if you need to marshal structs to JSON.

## API

### Types

- **Request** — `Method`, `Path`, `Body` (strings)
- **Response** — `Status`, `ContentType`, `Body`

### Functions

| Function | Description |
|----------|-------------|
| `express.NewRequest(method, path, body)` | Build a Request from handler arguments. |
| `express.NewResponse()` | New response (200, text/plain, empty body). |
| `express.Match(req, method, path)` | Returns 1 if request method and path match exactly, else 0. |
| `express.Send(res, status, contentType, body)` | Set response status, content type, and body (mutates `*res`). |
| `express.SendJson(res, status, body)` | Set response to `application/json` with status and body. |
| `express.SendHtml(res, status, body)` | Set response to `text/html`. |
| `express.NotFound(res)` | Set response to 404 Not Found. |
| `express.Build(res)` | Return the response body string (for use as the handler return value). |

## Usage examples

### Minimal handler (GET only)

```tl
@http = #dhimpu("std/http");
@express = #dhimpu("libs/x/express");

#handler(method string, path string, body string) string {
    @req Request = express.NewRequest(method, path, body);
    @!res Response = express.NewResponse();
    okavela express.Match(req, "GET", "/") {
        express.SendHtml(&res, 200, "<h1>Hello</h1>");
        mallinchu express.Build(res);
    }
    express.NotFound(&res);
    mallinchu express.Build(res);
}

#prarambham() {
    http.ListenAndServe(":8080", handler);
}
```

### Full example (GET, POST, JSON, 404)

```tl
@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");
@express = #dhimpu("libs/x/express");

#handler(method string, path string, body string) string {
    @req Request = express.NewRequest(method, path, body);
    @!res Response = express.NewResponse();

    okavela express.Match(req, "GET", "/") {
        express.SendHtml(&res, 200, "<h1>Hello from Tlang + express</h1>");
        mallinchu express.Build(res);
    }
    okavela express.Match(req, "GET", "/api/hello") {
        express.SendJson(&res, 200, "{\"message\": \"Hello\"}");
        mallinchu express.Build(res);
    }
    okavela express.Match(req, "POST", "/api/echo") {
        express.SendJson(&res, 200, body);
        mallinchu express.Build(res);
    }

    express.NotFound(&res);
    mallinchu express.Build(res);
}

#prarambham() {
    fmt.Printf("Server at http://localhost:8080\n");
    http.ListenAndServe(":8080", handler);
}
```

Run the full example from the repo root:

```bash
tlang run examples/express_server_example.tl
```

## Notes

- The underlying **http** server uses the string returned by the handler as the **response body** and sends it with status 200. To support other status codes (e.g. 404) the C layer would need to be extended; until then, `NotFound` only sets the body to `"Not Found"`.
- **Match** is exact (method + path). Path parameters or wildcards are not implemented.
- For more control, use `http.JSONResponse`, `http.HTMLResponse`, and `http.ListenAndServe` directly.
