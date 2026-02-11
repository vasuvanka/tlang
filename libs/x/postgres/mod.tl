// PostgreSQL client - Tlang-only (to be implemented using std builtins).
// Use std/net for TCP to port 5432, PostgreSQL frontend/backend protocol.
// No C bindings (no libpq). This module is under libs/x (external).
//
// Import: @postgres = #dhimpu("libs/x/postgres");

@fmt = #dhimpu("std/fmt");

// DefaultPostgresPort is the default PostgreSQL server port.
#DefaultPostgresPort() int {
    mallinchu 5432;
}
