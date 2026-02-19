#!/usr/bin/env bash
# Run Tlang test suites with line coverage (gcov).
# Requires: tlangc (or cargo), gcc with gcov (gcc --version), and optionally lcov for HTML report.
# Generated C uses #line directives so gcov reports map back to .tl source where possible.

set -e

COVERAGE_DIR="${COVERAGE_DIR:-./coverage_out}"
TLANG_TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$TLANG_TEST_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if ! command -v tlangc &> /dev/null; then
    echo -e "${YELLOW}Warning: tlangc not in PATH, using: cargo run --${NC}"
    TLANG_CMD="cargo run --"
else
    TLANG_CMD="tlangc"
fi

if ! gcc --version | head -1 | grep -q gcc; then
    echo -e "${RED}Error: gcc not found. Install gcc (with gcov) to run coverage.${NC}"
    exit 1
fi

TESTS=(
    "test_core_features.tl"
    "test_control_flow.tl"
    "test_data_structures.tl"
    "test_functions_errors.tl"
    "test_advanced_features.tl"
    "test_error_propagation.tl"
)

mkdir -p "$COVERAGE_DIR"
rm -f "$COVERAGE_DIR"/*.gcda "$COVERAGE_DIR"/*.gcno "$COVERAGE_DIR"/*.c "$COVERAGE_DIR"/*.gcov 2>/dev/null || true

echo -e "${CYAN}=========================================="
echo "Tlang tests with coverage (gcov)"
echo -e "==========================================${NC}"
echo ""

PASSED=0
FAILED=0

for test in "${TESTS[@]}"; do
    base="${test%.tl}"
    cfile="$COVERAGE_DIR/${base}.c"
    binary="$COVERAGE_DIR/$base"
    echo "----------------------------------------"
    echo "Compile & run: $test"
    echo "----------------------------------------"

    if ! $TLANG_CMD compile "$test" "$cfile" 2>/dev/null; then
        echo -e "${RED}FAIL: $test (Tlang compile)${NC}"
        ((FAILED++)) || true
        continue
    fi

    if ! gcc -fprofile-arcs -ftest-coverage -o "$binary" "$cfile" -lm -lssl -lcrypto -I. 2>/dev/null; then
        echo -e "${RED}FAIL: $test (gcc compile)${NC}"
        ((FAILED++)) || true
        continue
    fi

    if ! "$binary" 2>/dev/null; then
        echo -e "${RED}FAIL: $test (test exit non-zero)${NC}"
        ((FAILED++)) || true
        continue
    fi

    echo -e "${GREEN}PASS: $test${NC}"
    ((PASSED++)) || true
done

echo ""
echo -e "${CYAN}----------------------------------------"
echo "Coverage report (gcov)"
echo -e "----------------------------------------${NC}"

# Run gcov for each .c in coverage dir (from that dir so .gcda are found)
for c in "$COVERAGE_DIR"/*.c; do
    [ -f "$c" ] || continue
    base=$(basename "$c" .c)
    (cd "$COVERAGE_DIR" && gcov -n "$base.c" 2>/dev/null) || true
done

# Summarise: parse .gcov (format "count: line_no: source"; - = non-executable, ##### = 0 hits)
exec_count=0
exec_covered=0
for g in "$COVERAGE_DIR"/*.gcov; do
    [ -f "$g" ] || continue
    while IFS= read -r line; do
        count="${line%%:*}"
        count="${count// /}"
        # Skip non-executable (first field is "-")
        [[ "$count" == "-" ]] && continue
        # Skip non-data lines
        [[ "$count" == "" ]] && continue
        ((exec_count++)) || true
        # Covered = has a numeric count (not #####)
        if [[ "$count" != "#####" && "$count" =~ ^[0-9]+$ ]]; then
            ((exec_covered++)) || true
        fi
    done < "$g" 2>/dev/null || true
done

if [ "$exec_count" -gt 0 ]; then
    pct=$((exec_covered * 100 / exec_count))
    echo ""
    echo -e "Lines executed: ${GREEN}$exec_covered${NC} / $exec_count (~${pct}%)"
    echo "Detailed .gcov files and .c are in: $COVERAGE_DIR/"
fi

echo ""
echo "Summary: $PASSED passed, $FAILED failed (of ${#TESTS[@]} tests)"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
exit 0
