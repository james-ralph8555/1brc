#!/run/current-system/sw/bin/bash

# Build script for 1BRC DataFusion Rust Implementation (Updated with dual schemas)
# Usage: ./build_updated.sh [debug|release|pgo|clean]
# - debug: Fast build with debug symbols
# - release: Optimized build with native CPU targeting (default)
# - pgo: Profile-Guided Optimization build (automated 3-phase process)
# - clean: Remove target directory and artifacts

set -e

BUILD_TYPE="${1:-release}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper function for PGO build
build_pgo() {
    echo -e "${YELLOW}=== Profile-Guided Optimization Build (Automated 3-Phase Process) ===${NC}"
    
    # Check for required profile data (use test data if measurements.txt doesn't exist)
    PROFILE_DATA="../test_data/measurements_1k.txt"
    if [[ ! -f "$PROFILE_DATA" ]]; then
        if [[ -f "../measurements.txt" ]]; then
            PROFILE_DATA="../measurements.txt"
        else
            echo -e "${RED}Error: No profile data found. Please ensure ../test_data/measurements_1k.txt or ../measurements.txt exists${NC}"
            exit 1
        fi
    fi
    
    # Setup PGO directory
    PGO_DIR="/tmp/pgo-data-datafusion"
    echo -e "${YELLOW}Setting up PGO directory: $PGO_DIR${NC}"
    rm -rf "$PGO_DIR"
    mkdir -p "$PGO_DIR"
    
    # Phase 1: Build instrumented binary
    echo -e "\n${YELLOW}Phase 1: Building instrumented binary for profiling...${NC}"
    RUSTFLAGS="-C target-cpu=native -C profile-generate=$PGO_DIR" cargo build --release
    
    if [[ ! -f "target/release/onebrc-datafusion-double" ]]; then
        echo -e "${RED}✗ Instrumented build failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Instrumented binary created${NC}"
    
    # Phase 2: Generate profile data
    echo -e "\n${YELLOW}Phase 2: Generating profile data using $PROFILE_DATA...${NC}"
    echo -e "${YELLOW}Running instrumented binary to collect profile data...${NC}"
    
    # Run both executables to generate comprehensive profile data
    ./target/release/onebrc-datafusion-double "$PROFILE_DATA" /tmp/pgo_output_double.csv || {
        echo -e "${RED}✗ Profile data generation failed for double version!${NC}"
        exit 1
    }
    
    ./target/release/onebrc-datafusion-decimal "$PROFILE_DATA" /tmp/pgo_output_decimal.csv || {
        echo -e "${RED}✗ Profile data generation failed for decimal version!${NC}"
        exit 1
    }
    
    echo -e "${GREEN}✓ Profile data generated${NC}"
    
    # Phase 3: Merge profile data and build PGO-optimized binary
    echo -e "\n${YELLOW}Phase 3: Merging profile data and building PGO-optimized binary...${NC}"
    
    # Find llvm-profdata
    LLVM_PROFDATA=""
    if command -v llvm-profdata >/dev/null 2>&1; then
        LLVM_PROFDATA="llvm-profdata"
    else
        # Try to find it in rustup installation
        LLVM_PROFDATA=$(find ~/.rustup -name "llvm-profdata" 2>/dev/null | head -n 1)
        if [[ -z "$LLVM_PROFDATA" ]]; then
            echo -e "${RED}Error: llvm-profdata not found. Install with: rustup component add llvm-tools-preview${NC}"
            exit 1
        fi
    fi
    
    # Merge profile data
    "$LLVM_PROFDATA" merge -o "$PGO_DIR/merged.profdata" "$PGO_DIR"/*.profraw || {
        echo -e "${RED}✗ Profile data merging failed!${NC}"
        exit 1
    }
    echo -e "${GREEN}✓ Profile data merged${NC}"
    
    # Build final PGO-optimized binary
    echo -e "${YELLOW}Building final PGO-optimized binary...${NC}"
    RUSTFLAGS="-C target-cpu=native -C profile-use=$PGO_DIR/merged.profdata" cargo build --release || {
        echo -e "${RED}✗ PGO-optimized build failed!${NC}"
        exit 1
    }
    
    # Cleanup temporary files
    rm -f /tmp/pgo_output_double.csv /tmp/pgo_output_decimal.csv
    
    echo -e "\n${GREEN}✓ Profile-Guided Optimization build completed successfully!${NC}"
    echo -e "${GREEN}PGO-optimized executables created:${NC}"
    echo -e "  - target/release/onebrc-datafusion-double (Float64 schema, PGO-optimized)"
    echo -e "  - target/release/onebrc-datafusion-decimal (Decimal128(3,1) schema, PGO-optimized)"
    echo -e "\n${YELLOW}Profile data retained at: $PGO_DIR${NC}"
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./target/release/onebrc-datafusion-double <input_file> <output_csv>"
    echo -e "  ./target/release/onebrc-datafusion-decimal <input_file> <output_csv>"
    echo -e "\n${YELLOW}Benchmark with:${NC}"
    echo -e "  hyperfine --warmup 3 './target/release/onebrc-datafusion-double ../measurements.txt results.csv'"
}

# Validate build type and set build parameters
case "$BUILD_TYPE" in
    "debug"|"DEBUG")
        BUILD_FLAG=""
        TARGET_DIR="target/debug"
        RUSTFLAGS=""
        echo -e "${YELLOW}=== Building 1BRC DataFusion Rust Implementation (Debug) ===${NC}"
        ;;
    "release"|"RELEASE")
        BUILD_FLAG="--release"
        TARGET_DIR="target/release"
        RUSTFLAGS='-C target-cpu=native'
        echo -e "${YELLOW}=== Building 1BRC DataFusion Rust Implementation (Release) ===${NC}"
        ;;
    "pgo"|"PGO")
        build_pgo
        exit 0
        ;;
    "clean"|"CLEAN")
        echo -e "${YELLOW}=== Cleaning 1BRC DataFusion Rust Implementation ===${NC}"
        if [[ -d "target" ]]; then
            echo -e "${YELLOW}Removing target directory: target${NC}"
            cargo clean
            echo -e "${GREEN}✓ Clean completed successfully!${NC}"
        else
            echo -e "${YELLOW}Target directory does not exist, nothing to clean${NC}"
        fi
        exit 0
        ;;
    *)
        echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'. Use 'debug', 'release', 'pgo', or 'clean'${NC}"
        exit 1
        ;;
esac

# Build executables
echo -e "\n${YELLOW}Building executables ($BUILD_TYPE mode)...${NC}"
if [[ -n "$RUSTFLAGS" ]]; then
    RUSTFLAGS="$RUSTFLAGS" cargo build $BUILD_FLAG
else
    cargo build $BUILD_FLAG
fi

# Check if executables were created
if [[ -f "$TARGET_DIR/onebrc-datafusion-double" ]] && [[ -f "$TARGET_DIR/onebrc-datafusion-decimal" ]]; then
    echo -e "\n${GREEN}✓ Build successful!${NC}"
    echo -e "${GREEN}Executables created:${NC}"
    echo -e "  - $TARGET_DIR/onebrc-datafusion-double (Float64 schema)"
    echo -e "  - $TARGET_DIR/onebrc-datafusion-decimal (Decimal128(3,1) schema)"
    echo -e "\n${YELLOW}Usage:${NC}"
    echo -e "  ./$TARGET_DIR/onebrc-datafusion-double <input_file> <output_csv>"
    echo -e "  ./$TARGET_DIR/onebrc-datafusion-decimal <input_file> <output_csv>"
    echo -e "\n${YELLOW}Build completed in $BUILD_TYPE mode${NC}"
    echo -e "\n${YELLOW}Test with:${NC}"
    echo -e "  ./test.sh"
else
    echo -e "\n${RED}✗ Build failed!${NC}"
    exit 1
fi