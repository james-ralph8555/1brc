#!/run/current-system/sw/bin/bash

# Benchmark Script for 1BRC DuckDB C++ Implementation
# Runs comprehensive benchmarks using hyperfine with 3 warmups and 10 trials

set -e

# Configuration
DATASET_PATH="../test_data/measurements_1b.txt"
BUILD_DIR="build"
WARMUPS=3
RUNS=10
FLAMEGRAPH_ENABLED=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== 1BRC DuckDB C++ Benchmark Suite ===${NC}"
echo "Dataset: $DATASET_PATH"
echo "Warmups: $WARMUPS"
echo "Runs: $RUNS"
echo "Flamegraph: $FLAMEGRAPH_ENABLED"
echo ""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --flamegraph)
            FLAMEGRAPH_ENABLED=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --flamegraph    Generate flamegraphs for each benchmark"
            echo "  --help, -h      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check prerequisites
if ! command -v hyperfine &> /dev/null; then
    echo -e "${RED}Error: hyperfine not found. Install with: cargo install hyperfine${NC}"
    exit 1
fi

if [[ "$FLAMEGRAPH_ENABLED" == "true" ]]; then
    if ! command -v flamegraph &> /dev/null; then
        echo -e "${RED}Error: flamegraph not found. Install with: cargo install flamegraph${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Note: Flamegraph generation requires perf and may need elevated permissions${NC}"
    echo "If you encounter permission issues, run: echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid"
    echo ""
fi

if [[ ! -f "$DATASET_PATH" ]]; then
    echo -e "${RED}Error: Dataset not found at $DATASET_PATH${NC}"
    echo "Generate the dataset with:"
    echo "  cd .. && java -cp . dev.morling.onebrc.CreateMeasurements 1000000000"
    exit 1
fi

# Check for built executables
EXECUTABLES=()
EXEC_NAMES=()

if [[ -f "$BUILD_DIR/1brc_duckdb_double" ]]; then
    EXECUTABLES+=("$BUILD_DIR/1brc_duckdb_double")
    EXEC_NAMES+=("Double schema")
fi

if [[ -f "$BUILD_DIR/1brc_duckdb_decimal" ]]; then
    EXECUTABLES+=("$BUILD_DIR/1brc_duckdb_decimal")
    EXEC_NAMES+=("Decimal schema")
fi

if [[ ${#EXECUTABLES[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No executables found in $BUILD_DIR${NC}"
    echo "Build the project first with: ./build_updated.sh release"
    exit 1
fi

echo -e "${GREEN}Found ${#EXECUTABLES[@]} executable(s) to benchmark:${NC}"
for i in "${!EXECUTABLES[@]}"; do
    echo "  - ${EXEC_NAMES[$i]}: ${EXECUTABLES[$i]}"
done
echo ""

# Get dataset size for throughput calculation
DATASET_SIZE=$(wc -c < "$DATASET_PATH")
DATASET_SIZE_GB=$(echo "scale=2; $DATASET_SIZE / 1024 / 1024 / 1024" | bc 2>/dev/null || echo "~14")

echo -e "${YELLOW}Dataset size: ${DATASET_SIZE_GB} GB${NC}"
echo ""

# Run benchmarks for each executable
for i in "${!EXECUTABLES[@]}"; do
    executable="${EXECUTABLES[$i]}"
    exec_name="${EXEC_NAMES[$i]}"
    
    echo -e "${YELLOW}=== Benchmarking: $exec_name ===${NC}"
    echo "Command: ./$executable $DATASET_PATH results.csv"
    echo ""
    
    # Run hyperfine benchmark
    hyperfine \
        --warmup $WARMUPS \
        --runs $RUNS \
        --export-csv "benchmark_${exec_name// /_}_results.csv" \
        --export-json "benchmark_${exec_name// /_}_results.json" \
        --style full \
        --command-name "$exec_name" \
        "./$executable $DATASET_PATH results.csv"
    
    # Generate flamegraph if enabled
    if [[ "$FLAMEGRAPH_ENABLED" == "true" ]]; then
        echo -e "${YELLOW}Generating flamegraph for: $exec_name${NC}"
        
        # Generate flamegraph using the executable directly
        flamegraph \
            --output="flamegraph_${exec_name// /_}.svg" \
            -- "./$executable" "$DATASET_PATH" "results_flamegraph.csv"
        
        echo -e "${GREEN}Flamegraph saved to: flamegraph_${exec_name// /_}.svg${NC}"
        rm -f results_flamegraph.csv
        echo ""
    fi
    
    echo ""
    echo -e "${GREEN}Results saved to:${NC}"
    echo "  - CSV: benchmark_${exec_name// /_}_results.csv"
    echo "  - JSON: benchmark_${exec_name// /_}_results.json"
    if [[ "$FLAMEGRAPH_ENABLED" == "true" ]]; then
        echo "  - Flamegraph: flamegraph_${exec_name// /_}.svg"
    fi
    echo ""
    
    # Cleanup result file
    rm -f results.csv
done

# Summary
echo -e "${BLUE}=== Benchmark Complete ===${NC}"
echo "All benchmark results have been saved to CSV and JSON files."
echo ""
echo "To analyze results:"
echo "  - View CSV files in a spreadsheet application"
echo "  - Use jq to parse JSON: jq '.results[0].mean' benchmark_*_results.json"
echo ""
echo "Performance comparison commands:"
echo "  hyperfine --export-markdown comparison.md \\"
for i in "${!EXECUTABLES[@]}"; do
    executable="${EXECUTABLES[$i]}"
    exec_name="${EXEC_NAMES[$i]}"
    echo "    './$executable $DATASET_PATH results.csv' \\"
done
echo ""

if [[ "$FLAMEGRAPH_ENABLED" == "true" ]]; then
    echo "Flamegraph files generated (open in browser for interactive view):"
    for i in "${!EXECUTABLES[@]}"; do
        exec_name="${EXEC_NAMES[$i]}"
        flamegraph_file="flamegraph_${exec_name// /_}.svg"
        if [[ -f "$flamegraph_file" ]]; then
            echo "  - $flamegraph_file"
        fi
    done
    echo ""
fi