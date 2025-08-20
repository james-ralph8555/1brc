#!/run/current-system/sw/bin/bash

# Test Suite for 1BRC DuckDB C++ Implementation
# This script creates various test cases and validates the output

set -e

BUILD_DIR="build"
EXECUTABLE="$BUILD_DIR/1brc_duckdb"
DATA_DIR="data"
TEST_DATA_DIR="test_data"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== 1BRC DuckDB C++ Implementation Test Suite ===${NC}"

# Check if executable exists
if [[ ! -f "$EXECUTABLE" ]]; then
    echo -e "${RED}Error: Executable not found at $EXECUTABLE${NC}"
    echo "Please build the project first: cd build && cmake .. && make"
    exit 1
fi

# Create test data directory
mkdir -p "$TEST_DATA_DIR"

# Test 1: Basic functionality with small dataset
echo -e "\n${YELLOW}Test 1: Basic functionality${NC}"
cat > "$TEST_DATA_DIR/basic.txt" << EOF
Hamburg;12.0
Bulawayo;8.9
Palembang;38.8
St. John's;15.2
Cracow;12.6
Hamburg;13.2
Bulawayo;9.1
Palembang;39.0
St. John's;14.8
Cracow;13.1
EOF

EXPECTED_BASIC="Bulawayo=8.9/9.0/9.1
Cracow=12.6/12.9/13.1
Hamburg=12.0/12.6/13.2
Palembang=38.8/38.9/39.0
St. John's=14.8/15.0/15.2"

ACTUAL_BASIC=$(./$EXECUTABLE "$TEST_DATA_DIR/basic.txt")

if [[ "$ACTUAL_BASIC" == "$EXPECTED_BASIC" ]]; then
    echo -e "${GREEN}✓ Basic functionality test passed${NC}"
else
    echo -e "${RED}✗ Basic functionality test failed${NC}"
    echo "Expected:"
    echo "$EXPECTED_BASIC"
    echo "Actual:"
    echo "$ACTUAL_BASIC"
    exit 1
fi

# Test 2: Single station
echo -e "\n${YELLOW}Test 2: Single station${NC}"
cat > "$TEST_DATA_DIR/single.txt" << EOF
Stockholm;15.5
EOF

EXPECTED_SINGLE="Stockholm=15.5/15.5/15.5"
ACTUAL_SINGLE=$(./$EXECUTABLE "$TEST_DATA_DIR/single.txt")

if [[ "$ACTUAL_SINGLE" == "$EXPECTED_SINGLE" ]]; then
    echo -e "${GREEN}✓ Single station test passed${NC}"
else
    echo -e "${RED}✗ Single station test failed${NC}"
    echo "Expected: $EXPECTED_SINGLE"
    echo "Actual: $ACTUAL_SINGLE"
    exit 1
fi

# Test 3: Negative temperatures
echo -e "\n${YELLOW}Test 3: Negative temperatures${NC}"
cat > "$TEST_DATA_DIR/negative.txt" << EOF
Anchorage;-15.5
Anchorage;-20.0
Anchorage;-10.5
EOF

EXPECTED_NEGATIVE="Anchorage=-20.0/-15.3/-10.5"
ACTUAL_NEGATIVE=$(./$EXECUTABLE "$TEST_DATA_DIR/negative.txt")

if [[ "$ACTUAL_NEGATIVE" == "$EXPECTED_NEGATIVE" ]]; then
    echo -e "${GREEN}✓ Negative temperatures test passed${NC}"
else
    echo -e "${RED}✗ Negative temperatures test failed${NC}"
    echo "Expected: $EXPECTED_NEGATIVE"
    echo "Actual: $ACTUAL_NEGATIVE"
    exit 1
fi

# Test 4: Edge case temperatures (min/max values)
echo -e "\n${YELLOW}Test 4: Edge case temperatures${NC}"
cat > "$TEST_DATA_DIR/edge.txt" << EOF
Extreme;-99.9
Extreme;99.9
Extreme;0.0
EOF

EXPECTED_EDGE="Extreme=-99.9/0.0/99.9"
ACTUAL_EDGE=$(./$EXECUTABLE "$TEST_DATA_DIR/edge.txt")

if [[ "$ACTUAL_EDGE" == "$EXPECTED_EDGE" ]]; then
    echo -e "${GREEN}✓ Edge case temperatures test passed${NC}"
else
    echo -e "${RED}✗ Edge case temperatures test failed${NC}"
    echo "Expected: $EXPECTED_EDGE"
    echo "Actual: $ACTUAL_EDGE"
    exit 1
fi

# Test 5: Many stations (alphabetical sorting)
echo -e "\n${YELLOW}Test 5: Alphabetical sorting with many stations${NC}"
cat > "$TEST_DATA_DIR/sorting.txt" << EOF
Zebra;10.0
Alpha;20.0
Beta;30.0
Gamma;40.0
Delta;50.0
EOF

EXPECTED_SORTING="Alpha=20.0/20.0/20.0
Beta=30.0/30.0/30.0
Delta=50.0/50.0/50.0
Gamma=40.0/40.0/40.0
Zebra=10.0/10.0/10.0"

ACTUAL_SORTING=$(./$EXECUTABLE "$TEST_DATA_DIR/sorting.txt")

if [[ "$ACTUAL_SORTING" == "$EXPECTED_SORTING" ]]; then
    echo -e "${GREEN}✓ Alphabetical sorting test passed${NC}"
else
    echo -e "${RED}✗ Alphabetical sorting test failed${NC}"
    echo "Expected:"
    echo "$EXPECTED_SORTING"
    echo "Actual:"
    echo "$ACTUAL_SORTING"
    exit 1
fi

# Test 6: Decimal precision
echo -e "\n${YELLOW}Test 6: Decimal precision and rounding${NC}"
cat > "$TEST_DATA_DIR/precision.txt" << EOF
TestCity;10.1
TestCity;10.2
TestCity;10.3
EOF

EXPECTED_PRECISION="TestCity=10.1/10.2/10.3"
ACTUAL_PRECISION=$(./$EXECUTABLE "$TEST_DATA_DIR/precision.txt")

if [[ "$ACTUAL_PRECISION" == "$EXPECTED_PRECISION" ]]; then
    echo -e "${GREEN}✓ Decimal precision test passed${NC}"
else
    echo -e "${RED}✗ Decimal precision test failed${NC}"
    echo "Expected: $EXPECTED_PRECISION"
    echo "Actual: $ACTUAL_PRECISION"
    exit 1
fi

# Test 7: Large dataset simulation (performance test)
echo -e "\n${YELLOW}Test 7: Large dataset simulation${NC}"
echo "Generating 100,000 records..."

# Generate a larger test file
{
    for i in {1..100000}; do
        STATION_NUM=$((i % 1000))
        TEMP=$(echo "scale=1; (($RANDOM % 2000) - 1000) / 10" | bc)
        echo "Station$STATION_NUM;$TEMP"
    done
} > "$TEST_DATA_DIR/large.txt"

echo "Running performance test..."
START_TIME=$(date +%s.%N)
LARGE_RESULT=$(./$EXECUTABLE "$TEST_DATA_DIR/large.txt")
END_TIME=$(date +%s.%N)

RUNTIME=$(echo "$END_TIME - $START_TIME" | bc)
RESULT_LINES=$(echo "$LARGE_RESULT" | wc -l)

echo -e "${GREEN}✓ Large dataset test completed${NC}"
echo "Runtime: ${RUNTIME}s"
echo "Result lines: $RESULT_LINES"

# Test 8: Error handling
echo -e "\n${YELLOW}Test 8: Error handling${NC}"

# Test with non-existent file
if ./$EXECUTABLE "nonexistent_file.txt" 2>/dev/null; then
    echo -e "${RED}✗ Error handling test failed - should have failed with non-existent file${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Error handling test passed - correctly handled non-existent file${NC}"
fi

# Test with wrong number of arguments
if ./$EXECUTABLE 2>/dev/null; then
    echo -e "${RED}✗ Error handling test failed - should have failed with no arguments${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Error handling test passed - correctly handled missing arguments${NC}"
fi

# Cleanup
echo -e "\n${YELLOW}Cleaning up test files...${NC}"
rm -rf "$TEST_DATA_DIR"

echo -e "\n${GREEN}=== All tests passed! ===\n${NC}"
echo "The 1BRC DuckDB C++ implementation is working correctly."
echo -e "${YELLOW}Performance Summary:${NC}"
echo "- Large dataset (100K records): ${RUNTIME}s"
echo "- Stations processed: $RESULT_LINES"