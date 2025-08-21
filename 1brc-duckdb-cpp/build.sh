#!/run/current-system/sw/bin/bash

# Build script for 1BRC DuckDB C++ Implementation (Updated with dual schemas)
# Usage: ./build_updated.sh [debug|release|clean]
# - debug: Fast build with debug symbols
# - release: Optimized build (default)
# - clean: Remove build directory and artifacts

set -e

BUILD_DIR="build"
BUILD_TYPE="${1:-release}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validate build type
case "$BUILD_TYPE" in
    "debug"|"DEBUG")
        CMAKE_BUILD_TYPE="Debug"
        echo -e "${YELLOW}=== Building 1BRC DuckDB C++ Implementation (Debug) ===${NC}"
        ;;
    "release"|"RELEASE")
        CMAKE_BUILD_TYPE="Release"
        echo -e "${YELLOW}=== Building 1BRC DuckDB C++ Implementation (Release) ===${NC}"
        ;;
    "clean"|"CLEAN")
        echo -e "${YELLOW}=== Cleaning 1BRC DuckDB C++ Implementation ===${NC}"
        if [[ -d "$BUILD_DIR" ]]; then
            echo -e "${YELLOW}Removing build directory: $BUILD_DIR${NC}"
            rm -rf "$BUILD_DIR"
            echo -e "${GREEN}✓ Clean completed successfully!${NC}"
        else
            echo -e "${YELLOW}Build directory '$BUILD_DIR' does not exist, nothing to clean${NC}"
        fi
        exit 0
        ;;
    *)
        echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'. Use 'debug', 'release', or 'clean'${NC}"
        exit 1
        ;;
esac

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with CMake
echo -e "\n${YELLOW}Configuring with CMake ($CMAKE_BUILD_TYPE)...${NC}"
cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE ..

# Build the project
echo -e "\n${YELLOW}Building executables...${NC}"
make -j$(nproc)

# Check if executables were created
if [[ -f "1brc_duckdb_double" ]] && [[ -f "1brc_duckdb_decimal" ]]; then
    echo -e "\n${GREEN}✓ Build successful!${NC}"
    echo -e "${GREEN}Executables created:${NC}"
    echo -e "  - 1brc_duckdb_double (Float64 schema)"
    echo -e "  - 1brc_duckdb_decimal (Decimal(3,1) schema)"
    echo -e "\n${YELLOW}Usage:${NC}"
    echo -e "  ./1brc_duckdb_double <input_file> <output_csv>"
    echo -e "  ./1brc_duckdb_decimal <input_file> <output_csv>"
    echo -e "\n${YELLOW}Build completed in $CMAKE_BUILD_TYPE mode${NC}"
else
    echo -e "\n${RED}✗ Build failed!${NC}"
    exit 1
fi