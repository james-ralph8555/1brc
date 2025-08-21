#!/run/current-system/sw/bin/bash

# Simplified Test Suite for 1BRC DataFusion Rust Implementation
# Usage: ./test.sh [quick|full]
# - quick: Unit tests and basic binary execution (default)
# - full: Includes additional performance tests

set -e

OUTPUT_DIR="test_output"
TEST_MODE="${1:-quick}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validate test mode
case "$TEST_MODE" in
    "quick"|"QUICK")
        echo -e "${YELLOW}=== 1BRC DataFusion Rust Quick Test Suite ===${NC}"
        ;;
    "full"|"FULL")
        echo -e "${YELLOW}=== 1BRC DataFusion Rust Full Test Suite ===${NC}"
        ;;
    *)
        echo -e "${RED}Error: Invalid test mode '$TEST_MODE'. Use 'quick' or 'full'${NC}"
        exit 1
        ;;
esac

# Auto-detect available executable (check both release and debug)
EXEC_RELEASE="target/release/onebrc-datafusion"
EXEC_DEBUG="target/debug/onebrc-datafusion"

# Determine which executable to test
EXECUTABLE=""
EXEC_NAME=""

if [[ -f "$EXEC_RELEASE" ]]; then
    EXECUTABLE="$EXEC_RELEASE"
    EXEC_NAME="Float64 schema (release)"
elif [[ -f "$EXEC_DEBUG" ]]; then
    EXECUTABLE="$EXEC_DEBUG"
    EXEC_NAME="Float64 schema (debug)"
fi

if [[ -z "$EXECUTABLE" ]]; then
    echo -e "${RED}Error: No executable found. Please build the project first.${NC}"
    echo "Available build commands:"
    echo "  ./build.sh release"
    echo "  ./build.sh debug"
    echo "  cargo build --release"
    exit 1
fi

echo -e "${GREEN}Found executable to test:${NC}"
echo -e "  - $EXEC_NAME: $EXECUTABLE"

# Create test directories
mkdir -p "$OUTPUT_DIR"

test_count=0
passed_count=0

# Test 1: Unit tests (comprehensive correctness validation)
echo -e "\n${YELLOW}Test 1: Unit tests${NC}"
echo "Running cargo test..."

if cargo test --quiet; then
    echo -e "${GREEN}    ✓ Unit tests passed${NC}"
    ((test_count++))
    ((passed_count++))
else
    echo -e "${RED}    ✗ Unit tests failed${NC}"
    ((test_count++))
fi

# Test 2: Binary execution test
echo -e "\n${YELLOW}Test 2: Binary execution - $EXEC_NAME${NC}"

# Test 2a: Basic execution
echo -n "    Testing basic execution... "
output_file="$OUTPUT_DIR/test_output.csv"
if ./"$EXECUTABLE" "../test_data/measurements_1k.txt" "$output_file" 2>/dev/null; then
    if [[ -f "$output_file" && -s "$output_file" ]]; then
        echo -e "${GREEN}✓ Passed${NC}"
        ((test_count++))
        ((passed_count++))
    else
        echo -e "${RED}✗ Failed (no output)${NC}"
        ((test_count++))
    fi
else
    echo -e "${RED}✗ Failed (execution error)${NC}"
    ((test_count++))
fi

# Test 2b: Error handling
echo -n "    Testing error handling... "
if ./"$EXECUTABLE" 2>/dev/null; then
    echo -e "${RED}✗ Failed (should error with no arguments)${NC}"
    ((test_count++))
else
    echo -e "${GREEN}✓ Passed${NC}"
    ((test_count++))
    ((passed_count++))
fi

# Full test mode: performance tests
if [[ "$TEST_MODE" == "full" || "$TEST_MODE" == "FULL" ]]; then
    echo -e "\n${YELLOW}=== Full Test Mode: Performance Tests ===${NC}"
    
    # Performance test with measurements_1k.txt
    if [[ -f "../test_data/measurements_1k.txt" ]]; then
        echo -e "\n${YELLOW}Performance test with measurements_1k.txt${NC}"
        echo "Running performance test..."
        
        START_TIME=$(date +%s.%N)
        
        ./"$EXECUTABLE" "../test_data/measurements_1k.txt" "$OUTPUT_DIR/sample_output.csv" 2>/dev/null
        
        END_TIME=$(date +%s.%N)
        RUNTIME=$(echo "$END_TIME - $START_TIME" | bc 2>/dev/null || echo "N/A")
        RESULT_LINES=$(wc -l < "$OUTPUT_DIR/sample_output.csv")
        
        echo -e "${GREEN}    ✓ Performance test completed${NC}"
        echo "      Runtime: ${RUNTIME}s"
        echo "      Result lines: $RESULT_LINES"
        
        ((test_count++))
        ((passed_count++))
    else
        echo -e "\n${YELLOW}Performance test skipped (../test_data/measurements_1k.txt not found)${NC}"
    fi
fi

# Cleanup
rm -rf "$OUTPUT_DIR"

# Summary
echo -e "\n${YELLOW}=== Test Summary ===${NC}"
echo "Total tests: $test_count"
echo "Passed: $passed_count"
echo "Failed: $((test_count - passed_count))"

if [[ $passed_count -eq $test_count ]]; then
    echo -e "\n${GREEN}=== All tests passed! ===${NC}"
    echo "The 1BRC DataFusion Rust implementation is working correctly."
    exit 0
else
    echo -e "\n${RED}=== Some tests failed! ===${NC}"
    exit 1
fi
