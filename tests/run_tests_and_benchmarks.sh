#!/usr/bin/env bash
# Run all tests then all benchmarks (unified test + benchmark runner).

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========== 1/2 Tests =========="
./run_all_tests.sh
echo ""
echo "========== 2/2 Benchmarks =========="
./run_benchmarks.sh
