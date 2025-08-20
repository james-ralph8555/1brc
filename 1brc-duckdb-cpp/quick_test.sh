#!/run/current-system/sw/bin/bash

# Quick Test Suite for 1BRC DuckDB C++ Implementation

set -e

BUILD_DIR="build"
EXECUTABLE="$BUILD_DIR/1brc_duckdb"
TEST_DATA_DIR="test_data"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== 1BRC DuckDB C++ Quick Test Suite ===${NC}"

# Check if executable exists
if [[ ! -f "$EXECUTABLE" ]]; then
    echo -e "${RED}Error: Executable not found at $EXECUTABLE${NC}"
    exit 1
fi

# Create test data directory
mkdir -p "$TEST_DATA_DIR"

# Test 1: Basic functionality
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

# Test 2: Edge case temperatures
echo -e "\n${YELLOW}Test 2: Edge case temperatures${NC}"
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

# Test 3: Error handling
echo -e "\n${YELLOW}Test 3: Error handling${NC}"

# Test with wrong number of arguments
if ./$EXECUTABLE 2>/dev/null; then
    echo -e "${RED}✗ Error handling test failed${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Error handling test passed${NC}"
fi

# Cleanup
rm -rf "$TEST_DATA_DIR"

echo -e "\n${GREEN}=== All quick tests passed! ===\n${NC}"
echo "The 1BRC DuckDB C++ implementation is working correctly."