#!/bin/bash
# Run all test suites for Tlang

set -e

echo "=========================================="
echo "Tlang Comprehensive Test Suite"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if tlangc is available
if ! command -v tlangc &> /dev/null; then
    echo -e "${YELLOW}Warning: tlangc not found in PATH${NC}"
    echo "Using cargo run -- instead..."
    TLANG_CMD="cargo run --"
else
    TLANG_CMD="tlangc"
fi

# Test files
TESTS=(
    "test_core_features.tl"
    "test_control_flow.tl"
    "test_data_structures.tl"
    "test_functions_errors.tl"
    "test_advanced_features.tl"
    "test_error_propagation.tl"
)

PASSED=0
FAILED=0
TOTAL=${#TESTS[@]}

echo "Running $TOTAL test suites..."
echo ""

for test in "${TESTS[@]}"; do
    echo "----------------------------------------"
    echo "Running: $test"
    echo "----------------------------------------"
    
    $TLANG_CMD compile "$test" 2>&1 | tee /tmp/tlang_test_output.txt
    COMPILE_EXIT=${PIPESTATUS[0]}
    if [ "$COMPILE_EXIT" -ne 0 ]; then
        echo -e "${RED}❌ FAILED: $test (Tlang compilation error)${NC}"
        FAILED=$((FAILED + 1))
    else
        # Compile the generated C code
        if gcc -o /tmp/test_binary output.c -lm -lssl -lcrypto 2>&1 | tee -a /tmp/tlang_test_output.txt; then
            # Run the test
            if /tmp/test_binary 2>&1 | tee -a /tmp/tlang_test_output.txt; then
                EXIT_CODE=$?
                if [ $EXIT_CODE -eq 0 ]; then
                    echo -e "${GREEN}✅ PASSED: $test${NC}"
                    PASSED=$((PASSED + 1))
                else
                    echo -e "${RED}❌ FAILED: $test (exit code: $EXIT_CODE)${NC}"
                    FAILED=$((FAILED + 1))
                fi
            else
                echo -e "${RED}❌ FAILED: $test (runtime error)${NC}"
                FAILED=$((FAILED + 1))
            fi
        else
            echo -e "${RED}❌ FAILED: $test (C compilation error)${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
    echo ""
done

echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Total:  $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
