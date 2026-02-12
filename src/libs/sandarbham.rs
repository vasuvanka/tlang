// Sandarbham (Context) - Go-style context for cancellation, deadlines, and request-scoped values.
// Telugu: సందర్భం = context. Use: @sandarbham = #dhimpu("std/sandarbham");

use std::string::String;

/// Generate C code for the full Sandarbham (context) library.
/// Requires channel runtime (TlangCh) and pthread on non-Windows for Done/cancel.
pub fn generate_sandarbham_lib() -> String {
    let mut code = String::new();

    code.push_str("// Sandarbham (Context) - cancellation, deadlines, request-scoped values\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <time.h>\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("#include <pthread.h>\n");
    code.push_str("#endif\n\n");

    // Opaque context struct; layout used only inside this file.
    // parent, done channel, err_code (0=ok, 1=canceled, 2=deadline), deadline_ms, key/value for WithValue chain.
    code.push_str("typedef struct SandarbhamCtx {\n");
    code.push_str("    struct SandarbhamCtx* parent;\n");
    code.push_str("    TlangCh* done;\n");
    code.push_str("    int err_code;\n");
    code.push_str("    long deadline_ms;\n");
    code.push_str("    char* key;\n");
    code.push_str("    void* value;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    pthread_t timer_thread;\n");
    code.push_str("    int timer_started;\n");
    code.push_str("#endif\n");
    code.push_str("} SandarbhamCtx;\n\n");

    // Static background context: never cancelled. Done is a channel we never close (receive blocks forever).
    code.push_str("static SandarbhamCtx* sandarbham_background_ctx = NULL;\n");
    code.push_str("static TlangCh* sandarbham_never_done_ch = NULL;\n\n");

    code.push_str("static void sandarbham_init_background(void) {\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    if (sandarbham_background_ctx) return;\n");
    code.push_str("    sandarbham_never_done_ch = tlang_ch_create(0, sizeof(int));\n");
    code.push_str("    sandarbham_background_ctx = (SandarbhamCtx*)malloc(sizeof(SandarbhamCtx));\n");
    code.push_str("    if (sandarbham_background_ctx) {\n");
    code.push_str("        sandarbham_background_ctx->parent = NULL;\n");
    code.push_str("        sandarbham_background_ctx->done = sandarbham_never_done_ch;\n");
    code.push_str("        sandarbham_background_ctx->err_code = 0;\n");
    code.push_str("        sandarbham_background_ctx->deadline_ms = 0;\n");
    code.push_str("        sandarbham_background_ctx->key = NULL;\n");
    code.push_str("        sandarbham_background_ctx->value = NULL;\n");
    code.push_str("    }\n");
    code.push_str("#else\n");
    code.push_str("    if (sandarbham_background_ctx) return;\n");
    code.push_str("    sandarbham_background_ctx = (SandarbhamCtx*)malloc(sizeof(SandarbhamCtx));\n");
    code.push_str("    if (sandarbham_background_ctx) {\n");
    code.push_str("        sandarbham_background_ctx->parent = NULL;\n");
    code.push_str("        sandarbham_background_ctx->done = NULL;\n");
    code.push_str("        sandarbham_background_ctx->err_code = 0;\n");
    code.push_str("        sandarbham_background_ctx->deadline_ms = 0;\n");
    code.push_str("        sandarbham_background_ctx->key = NULL;\n");
    code.push_str("        sandarbham_background_ctx->value = NULL;\n");
    code.push_str("    }\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");

    // Background() - root context, never cancelled.
    code.push_str("void* sandarbham_Background(void) {\n");
    code.push_str("    sandarbham_init_background();\n");
    code.push_str("    return (void*)sandarbham_background_ctx;\n");
    code.push_str("}\n\n");

    // TODO() - same as Background (placeholder for code that will add real context later).
    code.push_str("void* sandarbham_TODO(void) {\n");
    code.push_str("    sandarbham_init_background();\n");
    code.push_str("    return (void*)sandarbham_background_ctx;\n");
    code.push_str("}\n\n");

    // Done(ctx) - return the done channel (TlangCh*). May be NULL on Windows.
    code.push_str("TlangCh* sandarbham_Done(void* ctx) {\n");
    code.push_str("    if (!ctx) return NULL;\n");
    code.push_str("    return ((SandarbhamCtx*)ctx)->done;\n");
    code.push_str("}\n\n");

    // Err(ctx) - 0 = ok, 1 = canceled, 2 = deadline exceeded.
    code.push_str("int sandarbham_Err(void* ctx) {\n");
    code.push_str("    if (!ctx) return 0;\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)ctx;\n");
    code.push_str("    if (c->err_code != 0) return c->err_code;\n");
    code.push_str("    if (c->parent) return sandarbham_Err(c->parent);\n");
    code.push_str("    return 0;\n");
    code.push_str("}\n\n");

    // Deadline(ctx) - returns (deadline_ms, ok). ok=1 if deadline set.
    code.push_str("long sandarbham_Deadline_ms(void* ctx) {\n");
    code.push_str("    if (!ctx) return 0;\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)ctx;\n");
    code.push_str("    if (c->deadline_ms > 0) return c->deadline_ms;\n");
    code.push_str("    if (c->parent) return sandarbham_Deadline_ms(c->parent);\n");
    code.push_str("    return 0;\n");
    code.push_str("}\n\n");
    code.push_str("int sandarbham_Deadline_ok(void* ctx) {\n");
    code.push_str("    return sandarbham_Deadline_ms(ctx) > 0 ? 1 : 0;\n");
    code.push_str("}\n\n");

    // WithCancel(parent) - new context; cancel via sandarbham_Cancel(child).
    code.push_str("void* sandarbham_WithCancel(void* parent) {\n");
    code.push_str("    if (!parent) return sandarbham_Background();\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)malloc(sizeof(SandarbhamCtx));\n");
    code.push_str("    if (!c) return NULL;\n");
    code.push_str("    c->parent = (SandarbhamCtx*)parent;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    c->done = tlang_ch_create(0, sizeof(int));\n");
    code.push_str("    c->timer_started = 0;\n");
    code.push_str("#else\n");
    code.push_str("    c->done = NULL;\n");
    code.push_str("#endif\n");
    code.push_str("    c->err_code = 0;\n");
    code.push_str("    c->deadline_ms = 0;\n");
    code.push_str("    c->key = NULL;\n");
    code.push_str("    c->value = NULL;\n");
    code.push_str("    return (void*)c;\n");
    code.push_str("}\n\n");

    // Cancel(ctx) - close done channel and set err_code = 1.
    code.push_str("void sandarbham_Cancel(void* ctx) {\n");
    code.push_str("    if (!ctx) return;\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)ctx;\n");
    code.push_str("    if (c->err_code != 0) return;\n");
    code.push_str("    c->err_code = 1;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    if (c->done) tlang_ch_close(c->done);\n");
    code.push_str("#endif\n");
    code.push_str("}\n\n");

    // Timer thread for WithDeadline: sleep until deadline then cancel.
    code.push_str("#ifndef _WIN32\n");
    code.push_str("static void* sandarbham_timer_thread(void* arg) {\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)arg;\n");
    code.push_str("    long now_ms = (long)time(NULL) * 1000;\n");
    code.push_str("    long wait_ms = c->deadline_ms - now_ms;\n");
    code.push_str("    if (wait_ms > 0) {\n");
    code.push_str("        struct timespec ts = { wait_ms / 1000, (wait_ms % 1000) * 1000000 };\n");
    code.push_str("        nanosleep(&ts, NULL);\n");
    code.push_str("    }\n");
    code.push_str("    if (c->err_code == 0) {\n");
    code.push_str("        c->err_code = 2;\n");
    code.push_str("        if (c->done) tlang_ch_close(c->done);\n");
    code.push_str("    }\n");
    code.push_str("    return NULL;\n");
    code.push_str("}\n\n");
    code.push_str("#endif\n\n");

    // WithDeadline(parent, deadline_ms) - deadline is absolute (ms since epoch). Returns new context.
    code.push_str("void* sandarbham_WithDeadline(void* parent, long deadline_ms) {\n");
    code.push_str("    if (!parent) parent = sandarbham_Background();\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)malloc(sizeof(SandarbhamCtx));\n");
    code.push_str("    if (!c) return NULL;\n");
    code.push_str("    c->parent = (SandarbhamCtx*)parent;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    c->done = tlang_ch_create(0, sizeof(int));\n");
    code.push_str("    c->timer_started = 0;\n");
    code.push_str("#else\n");
    code.push_str("    c->done = NULL;\n");
    code.push_str("#endif\n");
    code.push_str("    c->err_code = 0;\n");
    code.push_str("    c->deadline_ms = deadline_ms;\n");
    code.push_str("    c->key = NULL;\n");
    code.push_str("    c->value = NULL;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    if (pthread_create(&c->timer_thread, NULL, sandarbham_timer_thread, c) == 0)\n");
    code.push_str("        c->timer_started = 1;\n");
    code.push_str("#endif\n");
    code.push_str("    return (void*)c;\n");
    code.push_str("}\n\n");

    // WithTimeout(parent, timeout_ms) - relative timeout.
    code.push_str("void* sandarbham_WithTimeout(void* parent, long timeout_ms) {\n");
    code.push_str("    long deadline = (long)time(NULL) * 1000 + timeout_ms;\n");
    code.push_str("    return sandarbham_WithDeadline(parent, deadline);\n");
    code.push_str("}\n\n");

    // WithValue(parent, key, value) - key and value are strings for simplicity (C: const char*).
    code.push_str("void* sandarbham_WithValue(void* parent, const char* key, void* value) {\n");
    code.push_str("    if (!parent) parent = sandarbham_Background();\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)malloc(sizeof(SandarbhamCtx));\n");
    code.push_str("    if (!c) return NULL;\n");
    code.push_str("    c->parent = (SandarbhamCtx*)parent;\n");
    code.push_str("    c->done = ((SandarbhamCtx*)parent)->done;\n");
    code.push_str("    c->err_code = 0;\n");
    code.push_str("    c->deadline_ms = 0;\n");
    code.push_str("    c->key = key ? strdup(key) : NULL;\n");
    code.push_str("    c->value = value;\n");
    code.push_str("#ifndef _WIN32\n");
    code.push_str("    c->timer_started = 0;\n");
    code.push_str("#endif\n");
    code.push_str("    return (void*)c;\n");
    code.push_str("}\n\n");

    // Value(ctx, key) - walk chain, return first matching value (void*). NULL if not found.
    code.push_str("void* sandarbham_Value(void* ctx, const char* key) {\n");
    code.push_str("    if (!ctx || !key) return NULL;\n");
    code.push_str("    SandarbhamCtx* c = (SandarbhamCtx*)ctx;\n");
    code.push_str("    if (c->key && strcmp(c->key, key) == 0) return c->value;\n");
    code.push_str("    if (c->parent) return sandarbham_Value(c->parent, key);\n");
    code.push_str("    return NULL;\n");
    code.push_str("}\n\n");

    code
}
