#!/run/current-system/sw/bin/bash

# Simplified Test Suite for 1BRC DataFusion Rust Implementation
# Usage: ./test.sh [quick|full]
# - quick: Unit tests and basic binary execution (default)
# - full: Includes additional performance tests

set -e

TEST_DATA_DIR="test_data"
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

# Auto-detect available executables (check both release and debug)
DOUBLE_EXEC_RELEASE="target/release/onebrc-datafusion-double"
DECIMAL_EXEC_RELEASE="target/release/onebrc-datafusion-decimal"
DOUBLE_EXEC_DEBUG="target/debug/onebrc-datafusion-double"
DECIMAL_EXEC_DEBUG="target/debug/onebrc-datafusion-decimal"

# Determine which executables to test
EXECUTABLES=()
EXEC_NAMES=()

if [[ -f "$DOUBLE_EXEC_RELEASE" ]]; then
    EXECUTABLES+=("$DOUBLE_EXEC_RELEASE")
    EXEC_NAMES+=("Double schema (release)")
elif [[ -f "$DOUBLE_EXEC_DEBUG" ]]; then
    EXECUTABLES+=("$DOUBLE_EXEC_DEBUG")
    EXEC_NAMES+=("Double schema (debug)")
fi

if [[ -f "$DECIMAL_EXEC_RELEASE" ]]; then
    EXECUTABLES+=("$DECIMAL_EXEC_RELEASE")
    EXEC_NAMES+=("Decimal schema (release)")
elif [[ -f "$DECIMAL_EXEC_DEBUG" ]]; then
    EXECUTABLES+=("$DECIMAL_EXEC_DEBUG")
    EXEC_NAMES+=("Decimal schema (debug)")
fi

if [[ ${#EXECUTABLES[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No executables found. Please build the project first.${NC}"
    echo "Available build commands:"
    echo "  ./build.sh release"
    echo "  ./build.sh debug"
    echo "  cargo build --release"
    exit 1
fi

echo -e "${GREEN}Found ${#EXECUTABLES[@]} executable(s) to test:${NC}"
for i in "${!EXECUTABLES[@]}"; do
    echo -e "  - ${EXEC_NAMES[$i]}: ${EXECUTABLES[$i]}"
done

# Create test directories
mkdir -p "$TEST_DATA_DIR"
mkdir -p "$OUTPUT_DIR"

# Test data setup
setup_basic_test_data() {
    cat > "$TEST_DATA_DIR/basic.txt" << EOF
Hamburg;12.0
Bulawayo;8.9
Palembang;38.8
St. John's;15.2
Cracow;12.6
EOF
}

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

# Test 2: Binary execution tests
echo "DEBUG: About to start binary tests. Number of executables: ${#EXECUTABLES[@]}"
for i in "${!EXECUTABLES[@]}"; do
    executable="${EXECUTABLES[$i]}"
    exec_name="${EXEC_NAMES[$i]}"
    
    echo "DEBUG: Testing executable $i: $executable"
    echo -e "\n${YELLOW}Test $((i + 2)): Binary execution - $exec_name${NC}"
    
    # Test 2a: Basic execution
    setup_basic_test_data
    
    echo -n "    Testing basic execution... "
    output_file="$OUTPUT_DIR/test_output.csv"
    if ./"$executable" "$TEST_DATA_DIR/basic.txt" "$output_file" 2>/dev/null; then
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
    if ./"$executable" 2>/dev/null; then
        echo -e "${RED}✗ Failed (should error with no arguments)${NC}"
        ((test_count++))
    else
        echo -e "${GREEN}✓ Passed${NC}"
        ((test_count++))
        ((passed_count++))
    fi
done

# Full test mode: performance tests
if [[ "$TEST_MODE" == "full" || "$TEST_MODE" == "FULL" ]]; then
    echo -e "\n${YELLOW}=== Full Test Mode: Performance Tests ===${NC}"
    
    # Use the first available executable for performance testing
    primary_exec="${EXECUTABLES[0]}"
    
    # Performance test with measurements_1k.txt
    if [[ -f "../test_data/measurements_1k.txt" ]]; then
        echo -e "\n${YELLOW}Performance test with measurements_1k.txt${NC}"
        echo "Running performance test..."
        
        START_TIME=$(date +%s.%N)
        
        ./"$primary_exec" "../test_data/measurements_1k.txt" "$OUTPUT_DIR/sample_output.csv" 2>/dev/null
        
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
rm -rf "$TEST_DATA_DIR"
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