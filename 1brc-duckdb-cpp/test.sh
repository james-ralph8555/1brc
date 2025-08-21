#!/run/current-system/sw/bin/bash

# Minimal Test Suite for 1BRC DuckDB C++ Implementation
set -e

BUILD_DIR="build"
TEST_MODE="${1:-quick}"

echo "=== 1BRC DuckDB C++ Test Suite ==="

# Check for executable
EXECUTABLE="1brc_duckdb"
if [[ ! -f "$BUILD_DIR/$EXECUTABLE" ]]; then
    echo "Error: Executable $EXECUTABLE not found. Build first with ./build.sh"
    exit 1
fi

echo "Found executable to test: $EXECUTABLE"

# Check for measurements_1k.txt
MEASUREMENTS_1K="../test_data/measurements_1k.txt"
if [[ ! -f "$MEASUREMENTS_1K" ]]; then
    echo "Error: Test data file not found at $MEASUREMENTS_1K"
    exit 1
fi

# Test the executable
tests_passed=0
tests_total=0

echo "Testing: $EXECUTABLE"

# Test with measurements_1k.txt
echo -n "  measurements_1k.txt test... "
if timeout 30s ./build/"$EXECUTABLE" "$MEASUREMENTS_1K" output_1k.csv >/dev/null 2>&1; then
    echo "✓ PASS"
    ((tests_passed++))
else
    echo "✗ FAIL"
fi
((tests_total++))

# Run unit tests if in full mode
if [[ "$TEST_MODE" == "full" && -f "$BUILD_DIR/test_runner" ]]; then
    echo "Running unit tests..."
    if ./build/test_runner; then
        echo "✓ Unit tests PASS"
        ((tests_passed++))
    else
        echo "✗ Unit tests FAIL"
    fi
    ((tests_total++))
fi

# Cleanup
rm -f output_1k.csv

# Summary
echo "=== Results ==="
echo "Passed: $tests_passed/$tests_total"

if [[ $tests_passed -eq $tests_total ]]; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ Some tests failed!"
    exit 1
fi
