// Express-style HTTP server helpers for Tlang
// Port of Express.js concepts: Request/Response, routing, Send/SendJson.
// Use with std/http: pass a handler that uses this package to build responses.
//
// Import: @express = #dhimpu("libs/x/express");  (or path relative to your project)
// Depends: std/http, std/json (optional, for SendJson with structs)

@http = #dhimpu("std/http");

// Request holds parsed request data (method, path, body).
nirmanam Request {
    Method string
    Path   string
    Body   string
}

// Response holds status, content type, and body for the HTTP response.
nirmanam Response {
    Status      int
    ContentType string
    Body        string
}

// NewRequest creates a Request from the handler arguments.
#NewRequest(method string, pathStr string, body string) Request {
    mallinchu Request{Method: method, Path: pathStr, Body: body};
}

// NewResponse creates an empty response (200, text/plain, empty body).
#NewResponse() Response {
    mallinchu Response{Status: 200, ContentType: "text/plain", Body: ""};
}

// Match returns 1 if the request method and path match (exact match), else 0.
#Match(req Request, method string, pathPattern string) int {
    okavela req.Method != method {
        mallinchu 0;
    }
    okavela req.Path != pathPattern {
        mallinchu 0;
    }
    mallinchu 1;
}

// Send sets the response status, content type, and body (mutates res).
#Send(res *Response, status int, contentType string, body string) {
    res.Status = status;
    res.ContentType = contentType;
    res.Body = body;
}

// SendJson sets the response to application/json with the given status and JSON body string.
#SendJson(res *Response, status int, body string) {
    Send(res, status, "application/json", body);
}

// SendHtml sets the response to text/html with the given status and body.
#SendHtml(res *Response, status int, body string) {
    Send(res, status, "text/html", body);
}

// NotFound sets the response to 404 Not Found.
#NotFound(res *Response) {
    Send(res, 404, "text/plain", "Not Found");
}

// Build returns the response body string to return from the HTTP handler.
// The underlying http server uses this as the response body (status 200 for non-empty).
// For 404, you can call NotFound(res) then return Build(res); the server will still send 200
// unless the C layer is extended to interpret a convention (e.g. empty body or prefix).
#Build(res Response) string {
    mallinchu res.Body;
}
