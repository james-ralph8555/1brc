#!/run/current-system/sw/bin/bash

# Build script for 1BRC DuckDB C++ Implementation
# Usage: ./build.sh [debug|release|flamegraph|clean]
# - debug: Fast build with debug symbols
# - release: Optimized build (default)
# - flamegraph: Release build with debug symbols for profiling
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
    "flamegraph"|"FLAMEGRAPH")
        CMAKE_BUILD_TYPE="RelWithDebInfo"
        echo -e "${YELLOW}=== Building 1BRC DuckDB C++ Implementation (Flamegraph-ready) ===${NC}"
        echo -e "${YELLOW}Building optimized release with debug symbols for profiling...${NC}"
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
        echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'. Use 'debug', 'release', 'flamegraph', or 'clean'${NC}"
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

# Check if executable was created
if [[ -f "1brc_duckdb" ]]; then
    echo -e "\n${GREEN}✓ Build successful!${NC}"
    echo -e "${GREEN}Executable created:${NC}"
    if [[ "$BUILD_TYPE" == "flamegraph" || "$BUILD_TYPE" == "FLAMEGRAPH" ]]; then
        echo -e "  - 1brc_duckdb (Float64/Double schema, debug symbols)"
        echo -e "\n${GREEN}✓ Flamegraph-ready build completed!${NC}"
        echo -e "${YELLOW}Executable ready for flamegraph profiling${NC}"
    else
        echo -e "  - 1brc_duckdb (Float64/Double schema)"
    fi
    echo -e "\n${YELLOW}Usage:${NC}"
    echo -e "  ./1brc_duckdb <input_file> <output_csv>"
    echo -e "\n${YELLOW}Build completed in $CMAKE_BUILD_TYPE mode${NC}"
else
    echo -e "\n${RED}✗ Build failed!${NC}"
    exit 1
fi