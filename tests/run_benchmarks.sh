#!/usr/bin/env bash
# Run Tlang benchmark programs (scripts that use std/benchmark).
# Use run_tests_and_benchmarks.sh to run both tests and benchmarks.

set -e

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

# Benchmark files in tests/ (add ../examples/benchmark_example.tl if present)
BENCHMARKS=("bench_math.tl")
[ -f "../examples/benchmark_example.tl" ] && BENCHMARKS+=("../examples/benchmark_example.tl")

PASSED=0
FAILED=0

echo -e "${CYAN}=========================================="
echo "Tlang benchmarks"
echo -e "==========================================${NC}"
echo ""

for bench in "${BENCHMARKS[@]}"; do
    [ -f "$bench" ] || continue
    echo "----------------------------------------"
    echo "Run: $bench"
    echo "----------------------------------------"
    if $TLANG_CMD compile "$bench" output.c 2>/dev/null && gcc -o bench_binary output.c -lm -lssl -lcrypto 2>/dev/null; then
        if ./bench_binary 2>/dev/null; then
            echo -e "${GREEN}PASS: $bench${NC}"
            ((PASSED++)) || true
        else
            echo -e "${RED}FAIL: $bench (non-zero exit)${NC}"
            ((FAILED++)) || true
        fi
        rm -f bench_binary output.c 2>/dev/null || true
    else
        echo -e "${RED}FAIL: $bench (compile error)${NC}"
        ((FAILED++)) || true
    fi
    echo ""
done

echo "Summary: $PASSED passed, $FAILED failed"
[ "$FAILED" -eq 0 ] || exit 1
exit 0
