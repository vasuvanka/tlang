// Express-style HTTP server example using libs/x/express
// Run from repo root: tlang run examples/express_server_example.tl
// Import path: ../libs/x/express when running from examples/

@fmt = #dhimpu("std/fmt");
@http = #dhimpu("std/http");
@express = #dhimpu("../libs/x/express");

#handler(method string, path string, body string) string {
    @req Request = express.NewRequest(method, path, body);
    @!res Response = express.NewResponse();

    okavela express.Match(req, "GET", "/") {
        @html string = "<html><body><h1>Tlang + express</h1><p><a href='/api/hello'>/api/hello</a></p></body></html>";
        express.SendHtml(&res, 200, html);
        mallinchu express.Build(res);
    }
    okavela express.Match(req, "GET", "/api/hello") {
        express.Send(&res, 200, "application/json", "{}");
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
    fmt.Printf("Express-style server at http://localhost:8080\n");
    fmt.Printf("  GET  /         -> HTML\n");
    fmt.Printf("  GET  /api/hello -> JSON\n");
    fmt.Printf("  POST /api/echo -> echo body\n");
    http.ListenAndServe(":8080", handler);
}
